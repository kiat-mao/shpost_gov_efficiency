class Express < ApplicationRecord
  belongs_to :business
  belongs_to :post_unit, class_name: 'Unit', optional: true
  belongs_to :last_unit, class_name: 'Unit', optional: true
  validates_presence_of :express_no, :business_id, :message => '不能为空'
  
  enum status: {waiting: 'waiting', delivered: 'delivered', returns: 'returns'}
  STATUS_NAME = { waiting: '未妥投', delivered: '妥投', returns: '退回'}

  def self.init_expresses_yesterday
    start_date = Date.today - 1.day
    end_date = Date.today
    Express.init_expresses(start_date, end_date)
  end

  def self.refresh_traces_last_week
    start_date = Date.today - 7.day
    end_date = Date.today - 1.day
    Express.refresh_traces(start_date, end_date)
  end

  def self.refresh_traces_yesterday
    start_date = Date.today - 1.day
    end_date = Date.today
    Express.refresh_traces(start_date, end_date)
  end
  
  def self.init_expresses(start_date, end_date)
    puts("#{Time.now}, init_expresses, start_date: #{start_date}, end_date: #{end_date}")
    businesses = Business.all
    businesses.each do |business|
      ActiveRecord::Base.transaction do
        Express.init_expresses_by_business(business, start_date, end_date)
      end
    end
  end

  def self.refresh_traces(start_date, end_date)
    puts("#{Time.now}, refresh_traces, start_date: #{start_date}, end_date: #{end_date}")
    businesses = Business.all
    businesses.each do |business|
      ActiveRecord::Base.transaction do
        
        Express.refresh_traces_by_business(business, start_date, end_date)
      end
    end
  end

  def self.refresh_traces_by_business(business, start_date, end_date)
    if business.blank? || start_date.blank? || end_date.blank?
      return
    end

    puts("#{Time.now}, refresh_traces_by_business, #{business.name},  start")

    expresses = Express.where(business: business).where("posting_date >= ? and posting_date < ?", start_date, end_date).where(status: Express::statuses[:waiting])

    expresses.each do |express|
      express.refresh_trace!
    end

    puts("#{Time.now}, refresh_traces_by_business, #{business.name}, count: #{expresses.size}, end")
  end

  def self.init_expresses_by_business(business, start_date, end_date)
    if business.blank? || start_date.blank? || end_date.blank?
      return
    end

    puts("#{Time.now}  init_expresses_by_business, #{business.name}, start")

    pkp_waybill_bases = PkpWaybillBase.where(sender_no: business.code).where("biz_occur_date >= ? and biz_occur_date < ?", start_date, end_date)
    if end_date.to_date - start_date.to_date <= 1
      pkp_waybill_bases = pkp_waybill_bases.where(created_day: start_date.strftime("%d"))
    end
    pkp_waybill_bases.each do |pkp_waybill_base|
      Express.init_express(pkp_waybill_base, business)
    end

    puts("#{Time.now}, init_expresses_by_business, #{business.name}, count: #{pkp_waybill_bases.size}, end")
  end

	def self.init_express(pkp_waybill_base, business = nil)
    business ||= Business.find_by code: pkp_waybill_base.sender_no
    if business.blank?
      return
    end

    #Maybe express_no is duplication furture
		express = Express.find_by(express_no: pkp_waybill_base.waybill_no)
		express ||= Express.new

		express.express_no = pkp_waybill_base.waybill_no
    express.business = business
    
    if ! pkp_waybill_base.post_org_no.blank?
      post_unit = Unit.find_by no: pkp_waybill_base.post_org_no
      express.post_unit_no = pkp_waybill_base.post_org_no
      express.post_unit = post_unit
    end

    # express.posting_date = pkp_waybill_base.biz_occur_date
    express.posting_date = pkp_waybill_base.biz_occur_date.to_date

    express.receiver_province_no = pkp_waybill_base.receiver_province_no

    express.receiver_district = "#{pkp_waybill_base.receiver_province_name},#{pkp_waybill_base.receiver_city_name},#{pkp_waybill_base.receiver_county_name}"
    
    express.refresh_trace

    #express.sign = nil
    #express.desc = nil
    
    express.save!
  end

  def refresh_trace!
    self.refresh_trace
    self.save!
  end

  def refresh_trace
    mail_trace = MailTrace.find_by mail_no: self.express_no

    if ! mail_trace.blank?
      self.status = Express.to_status(mail_trace.status) || Express::statuses[:waiting]
      self.last_op_at = mail_trace.operated_at
      self.last_op_desc = mail_trace.result

      if ! mail_trace.last_trace.blank?
        last_unit_no = JSON.parse(mail_trace.last_trace)["opOrgCode"]
        self.last_unit_name = JSON.parse(mail_trace.last_trace)["opOrgName"]
        self.last_unit_no = last_unit_no
        self.last_unit = Unit.find_by no: last_unit_no
      end

      self.fill_delivered_days
    else
      self.status ||= Express::statuses[:waiting]
    end
  end

  def self.to_status(status)
    case status
      when 'own', 'other', 'unit'
        statuses[:delivered]
      when 'returns'
        statuses[:returns]
      else
        statuses[:waiting]
      end
  end

  def fill_delivered_days
    if delivered? || returns?
      if ! posting_date.blank? && ! last_op_at.blank?
         self.delivered_days = (last_op_at.to_date - posting_date.to_date).to_i
         return self.delivered_days
      end
    end
    self.delivered_days = nil
  end

  def self.get_deliver_market_result(expresses, params)
    results = {}
    businesses = Business.all
    total_hj = 0
    deliver_hj = 0
    deliver3_hj = 0
    deliver2_hj = 0
    waiting_hj = 0
    return_hj = 0
    
    if !params[:industry].blank?
      businesses = businesses.where(industry: params[:industry])
    end
    if !params[:btype].blank?
      businesses = businesses.where(btype: params[:btype])
    end
    btypes = businesses.select(:btype).distinct
            
    total_amount = expresses.group("businesses.btype").count
    status_amount = expresses.group("businesses.btype", "expresses.status").count
    deliver2 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 2").group("businesses.btype").count
    deliver3 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 3").group("businesses.btype").count

    btypes.each do |x|
      btype = x.btype
      total_am = total_amount[btype].blank? ? 0 : total_amount[btype]
      total_hj += total_am
      deliver_am =status_amount[[btype, "delivered"]].blank? ? 0 : status_amount[[btype, "delivered"]]
      deliver_hj += deliver_am
      deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
      deliver3_per = deliver3[btype].blank? ? 0 : (deliver3[btype]/total_am.to_f*100).round(2)
      deliver3_hj += deliver3[btype].blank? ? 0 : deliver3[btype]
      deliver2_per = deliver2[btype].blank? ? 0 : (deliver2[btype]/total_am.to_f*100).round(2)
      deliver2_hj += deliver2[btype].blank? ? 0 : deliver2[btype]
      waiting_am = status_amount[[btype, "waiting"]].blank? ? 0 : status_amount[[btype, "waiting"]]
      waiting_hj += waiting_am
      waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0 
      return_am = status_amount[[btype, "returns"]].blank? ? 0 : status_amount[[btype, "returns"]]
      return_hj += return_am
      return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0

      results[btype] = [total_am, deliver_am, deliver_per, deliver3_per, deliver2_per, waiting_am, waiting_per, return_am, return_per]
    end
    deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
    deliver3_per_hj = total_hj>0 ? (deliver3_hj/total_hj.to_f*100).round(2) : 0
    deliver2_per_hj = total_hj>0 ? (deliver2_hj/total_hj.to_f*100).round(2) : 0
    waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
    return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
      
    results["合计"] = [total_hj, deliver_hj, deliver_per_hj, deliver3_per_hj, deliver2_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj]

    return results
  end

  def status_name
    status.blank? ? "" : Express::STATUS_NAME["#{status}".to_sym]
  end

  def self.get_filter_expresses(params)
    expresses = Express.left_outer_joins(:business)
    
    # byebug
    if !params[:industry].blank?
      expresses = expresses.where("businesses.industry = ?", params[:industry])
    end
    
    if !params[:btype].blank?
      expresses = expresses.where("businesses.btype = ?", params[:btype])
    end

    if !params[:business].blank?
      expresses = expresses.where("businesses.code like ? or businesses.name like ?", "%#{params[:business]}%", "%#{params[:business]}%")
    end

    if !params[:posting_date_start].blank?
      expresses = expresses.where("expresses.posting_date >= ?", params[:posting_date_start])
    end

    if !params[:posting_date_end].blank?
      expresses = expresses.where("expresses.posting_date <= ?", params[:posting_date_end])
    end
    
    if !params[:detail_btype].blank? && !(params[:detail_btype].eql?"合计")
      expresses = expresses.where("businesses.btype = ?", params[:detail_btype])
    end

    if !params[:status].blank?
      expresses = expresses.where("expresses.status = ?", params[:status])
    end

    if !params[:last_unit_id].blank? && !(params[:last_unit_id].eql?"合计")
      if params[:last_unit_id].eql?"其他"
        expresses = expresses.where(last_unit_id: nil)
      else
        expresses = expresses.where(last_unit_id: params[:last_unit_id])
      end
    end

    if (!params[:is_court].blank?) && (params[:is_court].eql?"true")
      expresses = expresses.where.not(receiver_province_no: "310000")
    else
      expresses = expresses.where.not("businesses.industry = ? and expresses.receiver_province_no != ?", "法院", "310000") 
    end

    return expresses
  end

  def self.get_deliver_unit_result(expresses)
    results = {}
    
    total_amount = expresses.left_outer_joins(:last_unit).order("'parent_id'", :last_unit_id).group(:last_unit).count
    status_amount = expresses.group(:last_unit_id, :status).count
    deliver2 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 2").group("expresses.last_unit_id").count
    deliver3 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 3").group("expresses.last_unit_id").count

    total_amount.each do |k, v|
# debugger
      last_unit = k
      total_am = v
      deliver_am =status_amount[[last_unit.try(:id), "delivered"]].blank? ? 0 : status_amount[[last_unit.try(:id), "delivered"]]
      deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
      deliver3_per = deliver3[last_unit.try(:id)].blank? ? 0 : (deliver3[last_unit.try(:id)]/total_am.to_f*100).round(2)
      deliver2_per = deliver2[last_unit.try(:id)].blank? ? 0 : (deliver2[last_unit.try(:id)]/total_am.to_f*100).round(2)
      waiting_am = status_amount[[last_unit.try(:id), "waiting"]].blank? ? 0 : status_amount[[last_unit.try(:id), "waiting"]]
      waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0 
      return_am = status_amount[[last_unit.try(:id), "returns"]].blank? ? 0 : status_amount[[last_unit.try(:id), "returns"]]
      return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0

      results[last_unit] = [k.try(:parent_id), total_am, deliver_am, deliver_per, deliver3_per, deliver2_per, waiting_am, waiting_per, return_am, return_per]
    end

    total_hj = expresses.count
    deliver_hj =  expresses.where("expresses.status = 'delivered'").count
    deliver3_hj = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 3").count
    deliver2_hj = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 2").count
    waiting_hj = expresses.where("expresses.status = 'waiting'").count
    return_hj = expresses.where("expresses.status = 'returns'").count
    deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
    deliver3_per_hj = deliver3_hj.blank? ? 0 : (deliver3_hj/total_hj.to_f*100).round(2)
    deliver2_per_hj = deliver2_hj.blank? ? 0 : (deliver2_hj/total_hj.to_f*100).round(2)
    waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
    return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0

    if total_hj>0
      results["合计"] = ["", total_hj, deliver_hj, deliver_per_hj, deliver3_per_hj, deliver2_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj]
    end

    return results
  end
end
