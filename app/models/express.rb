class Express < ApplicationRecord
  belongs_to :business
  belongs_to :post_unit, class_name: 'Unit', optional: true
  belongs_to :last_unit, class_name: 'Unit', optional: true

  belongs_to :pre_express, class_name: 'Express', optional: true
  belongs_to :receipt_express, class_name: 'Express', optional: true

  validates_presence_of :express_no, :business_id, :message => '不能为空'
  
  enum status: {waiting: 'waiting', delivered: 'delivered', returns: 'returns', del: 'del'}
  STATUS_NAME = { waiting: '未妥投', delivered: '妥投', returns: '退回'}

  enum whereis: {in_transit: 'in_transit', delivery_part: 'delivery part'}
  WHEREIS_NAME = {in_transit: '在途中', delivery_part: '投递端'}

  #enum base_product_no: {standard_express: '11210', express_package: '11312'}
  BASE_PRODUCT_NAME = {standard_express: '标快', express_package: '快包', other_product: '其他'}
  BASE_PRODUCT_NOS =  {standard_express: '11210', express_package: '11312'}
  BASE_PRODUCT_SELECT = {'11210' => '标快', '11312' => '快包', other_product: '其他'}

  enum receipt_flag: {forward: 'forward', receipt: 'receipt', no_receipt_flag: nil}
  RECEIPT_FLAG = {forward: '正向邮件', receipt: '反向邮件', no_receipt_flag: '普通邮件'}
  RECEIPT_FLAG_SELECT = {forward: '正向邮件', receipt: '反向邮件', null: '普通邮件'}

  enum receipt_status: {receipt_receive: 'receipt_receive', no_receipt_receive: nil}
  RECEIPT_STATUS = {receipt_receive: '已收寄', no_receipt_receive: '未收寄'}
  RECEIPT_STATUS_SELECT = {receipt_receive: '已收寄', null: '未收寄'}

  scope :standard_express, -> {where(base_product_no: '11210')}

  scope :express_package, -> {where(base_product_no: '11312')}

  scope :other_product, -> {where.not(base_product_no: Express::BASE_PRODUCT_NOS.values).or(Express.where(base_product_no: nil))}

  
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
    if start_date.blank? || end_date.blank?
      return
    end
    start_date = start_date.to_date
    end_date = end_date.to_date
    puts("#{Time.now}, init_expresses, start_date: #{start_date}, end_date: #{end_date}")
    businesses = Business.all
    businesses.each do |business|
      Express.init_expresses_by_business(business, start_date, end_date)
    end
  end

  def self.refresh_traces(start_date, end_date)
    if start_date.blank? || end_date.blank?
      return
    end
    start_date = start_date.to_date
    end_date = end_date.to_date
    puts("#{Time.now}, refresh_traces, start_date: #{start_date}, end_date: #{end_date}")
    businesses = Business.all
    businesses.each do |business|
      Express.refresh_traces_by_business(business, start_date, end_date)

      Express.init_receipts_by_business(business, start_date, end_date)
    end
  end

  def self.refresh_traces_by_business(business, start_date, end_date)
    if business.blank? || start_date.blank? || end_date.blank?
      return
    end

    puts("#{Time.now}, refresh_traces_by_business, #{business.name},  start")

    
    expresses = Express.where(business: business).where("posting_date >= ? and posting_date < ?", start_date, end_date).waiting
    
    ActiveRecord::Base.transaction do
      expresses.each do |express|
        express.refresh_trace!
      end
    end

    puts("#{Time.now}, refresh_traces_by_business, #{business.name}, count: #{expresses.size}, end")
  end

  def self.init_expresses_by_business(business, start_date, end_date)
    if business.blank? || start_date.blank? || end_date.blank?
      return
    end
    puts("#{Time.now}  init_expresses_by_business, #{business.name}, start")

    pkp_waybill_bases = PkpWaybillBase.where(sender_no: business.code).where("biz_occur_date >= ? and biz_occur_date < ?", start_date, end_date)
    if end_date - start_date <= 1
      pkp_waybill_bases = pkp_waybill_bases.where(created_day: start_date.strftime("%d"))
    else
      days = (start_date...end_date).to_a.map{|x| x.strftime("%d")}
      pkp_waybill_bases = pkp_waybill_bases.where(created_day: days)
    end
    ActiveRecord::Base.transaction do
      pkp_waybill_bases.each do |pkp_waybill_base|
        Express.init_express(pkp_waybill_base, business)
      end
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
    express.posting_date = pkp_waybill_base.biz_occur_date.to_time
    express.posting_hour = pkp_waybill_base.biz_occur_date.hour

    express.receiver_province_no = pkp_waybill_base.receiver_province_no
    express.receiver_city_no = pkp_waybill_base.receiver_city_no
    express.receiver_county_no = pkp_waybill_base.receiver_county_no
    express.receiver_district_no = pkp_waybill_base.receiver_district_no
    
    express.receiver_district = "#{pkp_waybill_base.receiver_province_name},#{pkp_waybill_base.receiver_city_name},#{pkp_waybill_base.receiver_county_name}"
    
    express.base_product_no = pkp_waybill_base.base_product_no

    # receipt
    if ! pkp_waybill_base.receipt_flag.blank?
      if pkp_waybill_base.receipt_flag.eql?('6')
        express.receipt_flag = Express.receipt_flags[:forward]
        express.receipt_waybill_no = pkp_waybill_base.receipt_waybill_no
      elsif pkp_waybill_base.receipt_flag.eql?('8')
        express.receipt_flag = Express.receipt_flags[:receipt]
        express.pre_waybill_no = pkp_waybill_base.pre_waybill_no

        pre_express = Express.find_by(express_no: express.pre_waybill_no)
        express.pre_express = pre_express
        
        pre_express.receipt_express = express
        # pre_express.receipt_status = Express.receipt_statuses[:receipt_receive]

        pre_express.receipt_receive!
      end
    end

    express.refresh_trace

    #express.sign = nil
    #express.desc = nil
    
    if ! express.del?
      express.save!
    end
  end

  def refresh_trace!
    self.refresh_trace

    if ! self.del?
      self.save!
    else
      self.destroy!
    end
  end

  def refresh_trace
    mail_trace = MailTrace.find_by mail_no: self.express_no

    if ! mail_trace.blank?
      self.status = Express.to_status(mail_trace.status) || Express::statuses[:waiting]
      self.last_op_at = mail_trace.operated_at
      self.last_op_desc = mail_trace.result

      if ! mail_trace.last_trace.blank?
        last_trace = JSON.parse(mail_trace.last_trace)

        self.last_unit_name = last_trace["opOrgName"]
        self.last_unit_no = last_trace["opOrgCode"]
        self.last_unit = Unit.find_by no: last_trace["opOrgCode"]

        self.whereis = self.waiting? ? Express.to_whereis(last_trace["opCode"]) : nil
      else
        self.whereis = self.waiting? ? Express.whereis[:in_transit] : nil
      end

      self.fill_delivered_days
    else
      self.status ||= Express::statuses[:waiting]
    end
  end

  def self.init_receipts_by_business(business, start_date, end_date)
    if business.blank? || start_date.blank? || end_date.blank?
      return
    end

    puts("#{Time.now}, init_receipts_by_business, #{business.name},  start")

    
    expresses = Express.where(business: business).where("posting_date >= ? and posting_date < ?", start_date, end_date).forward.delivered.no_receipt_receive
    
    ActiveRecord::Base.transaction do
      expresses.each do |express|
        express.init_receipt(express.receipt_waybill_no, business)
      end
    end

    puts("#{Time.now}, init_receipts_by_business, #{business.name}, count: #{expresses.size}, end")
  end

  def init_receipt(receipt_waybill_no, business)
    pkp_waybill_base = PkpWaybillBase.where(waybill_no: receipt_waybill_no).last
    if ! pkp_waybill_base.blank?
      Express.init_express(pkp_waybill_base, business)
    end
  end

  def self.to_whereis(code)
    delivery_part_code = ['306', '307', '702', '705']
    if code.in? delivery_part_code
      whereis[:delivery_part]
    else
      whereis[:in_transit]
    end
  end

  def self.to_status(status)
    case status
      when 'own', 'other', 'unit'
        statuses[:delivered]
      when 'returns'
        statuses[:returns]
      when 'del'
        statuses[:del]
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

  def self.get_deliver_market_result(expresses, params, current_user)
    results = {}
    businesses = nil
    btypes = nil
    total_hj = 0
    deliver_hj = 0
    deliver3_hj = 0
    deliver2_hj = 0
    deliver5_hj = 0
    waiting_hj = 0
    return_hj = 0
    in_transit_hj = 0
    delivery_part_hj = 0

    if current_user.superadmin? || current_user.company_admin?
      if (!params[:is_court].blank?) && (params[:is_court].eql?"true")
        businesses = Business.where(industry: "法院")
      else
        businesses = Business.where.not("businesses.industry = ?", "法院")
      end
      
      if !params[:industry].blank?
        businesses = businesses.where(industry: params[:industry])
      end

      if !params[:btype].blank?
        businesses = businesses.where(btype: params[:btype])
      end
      btypes = businesses.select(:btype).distinct
    else
      btypes = expresses.select("businesses.btype").distinct
    end
       
    total_amount = expresses.group("businesses.btype").count
    status_amount = expresses.group("businesses.btype", "expresses.status").count
    deliver2 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 2").group("businesses.btype").count
    deliver3 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 3").group("businesses.btype").count
    deliver5 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 5").group("businesses.btype").count
    transit_delivery = expresses.where("expresses.status = 'waiting'").group("businesses.btype", "expresses.whereis").count

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
      deliver5_per = deliver5[btype].blank? ? 0 : (deliver5[btype]/total_am.to_f*100).round(2)
      deliver5_hj += deliver5[btype].blank? ? 0 : deliver5[btype]
      waiting_am = status_amount[[btype, "waiting"]].blank? ? 0 : status_amount[[btype, "waiting"]]
      waiting_hj += waiting_am
      in_transit_am = transit_delivery[[btype, "in_transit"]].blank? ? 0 : transit_delivery[[btype, "in_transit"]]
      in_transit_hj += in_transit_am
      delivery_part_am = transit_delivery[[btype, "delivery_part"]].blank? ? 0 : transit_delivery[[btype, "delivery_part"]]
      delivery_part_hj += delivery_part_am
      waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0 
      return_am = status_amount[[btype, "returns"]].blank? ? 0 : status_amount[[btype, "returns"]]
      return_hj += return_am
      return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0

      results[btype] = [total_am, deliver_am, deliver_per, deliver3_per, deliver2_per, waiting_am, waiting_per, return_am, return_per, deliver5_per, in_transit_am, delivery_part_am]
    end
    deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
    deliver3_per_hj = total_hj>0 ? (deliver3_hj/total_hj.to_f*100).round(2) : 0
    deliver2_per_hj = total_hj>0 ? (deliver2_hj/total_hj.to_f*100).round(2) : 0
    deliver5_per_hj = total_hj>0 ? (deliver5_hj/total_hj.to_f*100).round(2) : 0
    waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
    return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
      
    results["合计"] = [total_hj, deliver_hj, deliver_per_hj, deliver3_per_hj, deliver2_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj, deliver5_per_hj, in_transit_hj, delivery_part_hj]

    return results
  end

  def status_name
    status.blank? ? "" : Express::STATUS_NAME["#{status}".to_sym]
  end

  def self.get_filter_expresses(params)
    start_date = nil
    end_date = nil
    expresses = Express.left_outer_joins(:business)
   
    if !params[:industry].blank?
      expresses = expresses.where("businesses.industry = ?", params[:industry])
    end
    
    if !params[:btype].blank?
      expresses = expresses.where("businesses.btype = ?", params[:btype])
    end

    if !params[:business].blank?
      expresses = expresses.where("businesses.code like ? or businesses.name like ?", "%#{params[:business]}%", "%#{params[:business]}%")
    end

    if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
      if !params[:year].blank? && !params[:month].blank?
        start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month
        end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month
      end
    else
      start_date = params[:posting_date_start] if !params[:posting_date_start].blank?
      end_date = params[:posting_date_end] if !params[:posting_date_end].blank?
    end

    if !start_date.blank?
      expresses = expresses.where("expresses.posting_date >= ?",start_date)
    end

    if !end_date.blank?
      expresses = expresses.where("expresses.posting_date <= ?", end_date)
    end
    
    if !params[:detail_btype].blank? && !(params[:detail_btype].eql?"合计")
      expresses = expresses.where("businesses.btype = ?", params[:detail_btype])
    end

    if !params[:status].blank?
      if params[:status].eql?"not_delivered"
        expresses = expresses.where.not(status: "delivered")
      else
        expresses = expresses.where("expresses.status = ?", params[:status])
      end
    end

    if !params[:last_unit_id].blank? && !(params[:last_unit_id].eql?"合计")
      if params[:last_unit_id].eql?"其他"
        expresses = expresses.where(last_unit_id: nil)
      else
        expresses = expresses.where(last_unit_id: params[:last_unit_id])
      end
    end

    # if (!params[:is_court].blank?) && (params[:is_court].eql?"true")
    #   expresses = expresses.where.not(receiver_province_no: "310000")
    # else
    #   expresses = expresses.where.not("businesses.industry = ? and expresses.receiver_province_no != ?", "法院", "310000") 
    # end
    if !params[:is_court].blank? && (params[:is_court].eql?"false")
      expresses = expresses.where.not("businesses.industry = ?", "法院")
    end

    if !params[:detail_business].blank?
      expresses = expresses.where(business_id: params[:detail_business])
    end

    if !params[:destination].blank?
      if params[:destination].eql?"本省"
        expresses = expresses.where(receiver_province_no: "310000")
      elsif params[:destination].eql?"异地"
        expresses = expresses.where.not(receiver_province_no: "310000")
      end         
    end

    if !params[:lv2_unit].blank?
      expresses = expresses.left_outer_joins(:last_unit).where("units.parent_id = ?", params[:lv2_unit])
    end

    if !params[:transit_delivery].blank?
      expresses = expresses.where(whereis: params[:transit_delivery])
    end

    if !params[:product].blank? || (!params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:base_product_no].blank? && !params[:expresses][:f][:base_product_no][0].blank?)
      if !params[:product].blank?
        product = params[:product]
      else
        product = params[:expresses][:f][:base_product_no][0]
      end
      if product.eql?"other_product"
        expresses = expresses.other_product
        if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:base_product_no].blank?
          params[:expresses][:f][:base_product_no] = nil
        end
      elsif product.eql?"standard_express"
        expresses = expresses.standard_express
      elsif product.eql?"express_package"
        expresses = expresses.express_package
      end
    end

    if !params[:receipt_flag].blank?
      expresses = expresses.where(receipt_flag: params[:receipt_flag])
    end

    if !params[:receipt_status].blank?
      if params[:receipt_status].eql?"no_receipt_receive"
        expresses = expresses.no_receipt_receive
      elsif params[:receipt_status].eql?"receipt_receive"
        expresses = expresses.receipt_receive
      end
    end

    if !params[:distributive_center_no].blank?
      if params[:distributive_center_no].eql?"南京集散"
        expresses = expresses.where(distributive_center_no: "nj")
      end         
    end

    if !params[:posting_hour_start].blank? && !params[:posting_hour_end].blank?
      expresses = expresses.where("posting_hour >= ? and posting_hour < ?", params[:posting_hour_start].to_i, params[:posting_hour_end].to_i)
    end

    if !params[:receiver_province_no].blank?
      expresses = expresses.where(receiver_province_no: params[:receiver_province_no])
    end

    if !params[:receiver_city_no].blank?
      expresses = expresses.where(receiver_city_no: params[:receiver_city_no])
    end

    if !params[:delivered_days].blank?
      expresses = expresses.where("delivered_days < ?", params[:delivered_days].to_i)
    end

    # byebug

    return expresses
  end

  def self.get_deliver_unit_result(expresses)
    results = {}
    results1 = {}
    total_hj = 0
    deliver_hj = 0
    deliver3_hj = 0
    deliver2_hj = 0
    deliver5_hj = 0
    waiting_hj = 0
    return_hj = 0
    in_transit_hj = 0
    delivery_part_hj = 0
 
    if !expresses.blank?
      total_amount = expresses.left_outer_joins(:last_unit).order("'parent_id'", :last_unit_id).group(:last_unit).count
      status_amount = expresses.group(:last_unit_id, :status).count
      deliver2 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 2").group("expresses.last_unit_id").count
      deliver3 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 3").group("expresses.last_unit_id").count
      deliver5 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 5").group("expresses.last_unit_id").count
      transit_delivery = expresses.where("expresses.status = 'waiting'").group("expresses.last_unit_id", "expresses.whereis").count

      total_amount.each do |k, v|
  # debugger
        last_unit = k
        total_am = v
        total_hj += total_am
        deliver_am =status_amount[[last_unit.try(:id), "delivered"]].blank? ? 0 : status_amount[[last_unit.try(:id), "delivered"]]
        deliver_hj += deliver_am
        deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
        deliver3_per = deliver3[last_unit.try(:id)].blank? ? 0 : (deliver3[last_unit.try(:id)]/total_am.to_f*100).round(2)
        deliver3_hj += deliver3[last_unit.try(:id)].blank? ? 0 : deliver3[last_unit.try(:id)]
        deliver2_per = deliver2[last_unit.try(:id)].blank? ? 0 : (deliver2[last_unit.try(:id)]/total_am.to_f*100).round(2)
        deliver2_hj += deliver2[last_unit.try(:id)].blank? ? 0 : deliver2[last_unit.try(:id)]
        deliver5_per = deliver5[last_unit.try(:id)].blank? ? 0 : (deliver5[last_unit.try(:id)]/total_am.to_f*100).round(2)
        deliver5_hj += deliver5[last_unit.try(:id)].blank? ? 0 : deliver5[last_unit.try(:id)]
        waiting_am = status_amount[[last_unit.try(:id), "waiting"]].blank? ? 0 : status_amount[[last_unit.try(:id), "waiting"]]
        waiting_hj += waiting_am
        in_transit_am = transit_delivery[[last_unit.try(:id), "in_transit"]].blank? ? 0 : transit_delivery[[last_unit.try(:id), "in_transit"]]
        in_transit_hj += in_transit_am
        delivery_part_am = transit_delivery[[last_unit.try(:id), "delivery_part"]].blank? ? 0 : transit_delivery[[last_unit.try(:id), "delivery_part"]]
        delivery_part_hj += delivery_part_am
        waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0 
        return_am = status_amount[[last_unit.try(:id), "returns"]].blank? ? 0 : status_amount[[last_unit.try(:id), "returns"]]
        return_hj += return_am
        return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0

        results[last_unit] = [k.try(:parent_id), total_am, deliver_am, deliver_per, deliver3_per, deliver2_per, waiting_am, waiting_per, return_am, return_per, deliver5_per, in_transit_am, delivery_part_am]
      end

      results = results.sort{|x,y|  x[0].nil? ? 1 : (y[0].nil? ? -1 : x[1][0]<=>y[1][0]) }.to_h

      deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
      deliver3_per_hj = total_hj>0 ? (deliver3_hj/total_hj.to_f*100).round(2) : 0
      deliver2_per_hj = total_hj>0 ? (deliver2_hj/total_hj.to_f*100).round(2) : 0
      deliver5_per_hj = total_hj>0 ? (deliver5_hj/total_hj.to_f*100).round(2) : 0
      waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
      return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0

      results["合计"] = ["", total_hj, deliver_hj, deliver_per_hj, deliver3_per_hj, deliver2_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj, deliver5_per_hj, in_transit_hj, delivery_part_hj]
    end

    return results
  end

  def self.get_business_result(expresses, params)
    results = {}
    total_hj = 0
    deliver_hj = 0
    deliver3_hj = 0
    deliver2_hj = 0
    deliver5_hj = 0
    waiting_hj = 0
    return_hj = 0
    in_transit_hj = 0
    delivery_part_hj = 0
    
    businesses = Business.where(btype: params[:detail_btype])   
    total_amount = expresses.group(:business).count
    status_amount = expresses.group(:business_id, :status).count
    deliver2 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 2").group(:business_id).count
    deliver3 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 3").group(:business_id).count
    deliver5 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 5").group(:business_id).count
    transit_delivery = expresses.where("expresses.status = 'waiting'").group("expresses.business_id", "expresses.whereis").count

    businesses.each do |x|
      total_am = total_amount[x].blank? ? 0 : total_amount[x]
      total_hj += total_am
      deliver_am =status_amount[[x.try(:id), "delivered"]].blank? ? 0 : status_amount[[x.try(:id), "delivered"]]
      deliver_hj += deliver_am
      deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
      deliver3_per = deliver3[x.try(:id)].blank? ? 0 : (deliver3[x.try(:id)]/total_am.to_f*100).round(2)
      deliver3_hj += deliver3[x.try(:id)].blank? ? 0 : deliver3[x.try(:id)]
      deliver2_per = deliver2[x.try(:id)].blank? ? 0 : (deliver2[x.try(:id)]/total_am.to_f*100).round(2)
      deliver2_hj += deliver2[x.try(:id)].blank? ? 0 : deliver2[x.try(:id)]
      deliver5_per = deliver5[x.try(:id)].blank? ? 0 : (deliver5[x.try(:id)]/total_am.to_f*100).round(2)
      deliver5_hj += deliver5[x.try(:id)].blank? ? 0 : deliver5[x.try(:id)]
      waiting_am = status_amount[[x.try(:id), "waiting"]].blank? ? 0 : status_amount[[x.try(:id), "waiting"]]
      waiting_hj += waiting_am
      in_transit_am = transit_delivery[[x.try(:id), "in_transit"]].blank? ? 0 : transit_delivery[[x.try(:id), "in_transit"]]
      in_transit_hj += in_transit_am
      delivery_part_am = transit_delivery[[x.try(:id), "delivery_part"]].blank? ? 0 : transit_delivery[[x.try(:id), "delivery_part"]]
      delivery_part_hj += delivery_part_am
      waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0 
      return_am = status_amount[[x.try(:id), "returns"]].blank? ? 0 : status_amount[[x.try(:id), "returns"]]
      return_hj += return_am
      return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0

      results[x] = [total_am, deliver_am, deliver_per, deliver3_per, deliver2_per, waiting_am, waiting_per, return_am, return_per, deliver5_per, in_transit_am, delivery_part_am]
    end
      
    deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
    deliver3_per_hj = total_hj>0 ? (deliver3_hj/total_hj.to_f*100).round(2) : 0
    deliver2_per_hj = total_hj>0 ? (deliver2_hj/total_hj.to_f*100).round(2) : 0
    deliver5_per_hj = total_hj>0 ? (deliver5_hj/total_hj.to_f*100).round(2) : 0
    waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
    return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
      
    results["合计"] = [total_hj, deliver_hj, deliver_per_hj, deliver3_per_hj, deliver2_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj, deliver5_per_hj, in_transit_hj, delivery_part_hj]
 
    return results
  end

  def whereis_name
    whereis.blank? ? "" : Express::WHEREIS_NAME["#{whereis}".to_sym]
  end

  def self.get_receipt_result(expresses, params)
    results = {}
    f_total_am_hj = 0
    fd_am_hj = 0
    fw_am_hj = 0
    fdrr_am_hj = 0
    fdrn_am_hj = 0
    rd_am_hj = 0
    rw_am_hj = 0
    fr_am_hj = 0
    fndrr_am_hj = 0
    rd_per_hj = 0

    total_amount = expresses.where(receipt_flag:["forward", "receipt"]).group(:business).count
    exp = expresses.where(receipt_flag:["forward", "receipt"]).group(:business_id, :receipt_flag, :status, :receipt_status).count

    total_amount.each do |x, y|
      # 正向邮件总收寄数
      f_total_am = 0
      # 正向邮件妥投数
      fd_am = 0
      # 正向邮件未妥投数
      fw_am = 0
      # 正向邮件妥投返单邮件收寄数
      fdrr_am = 0
      # 正向邮件妥投返单邮件未收寄数
      fdrn_am = 0
      # 返单邮件返回数(妥投数)
      rd_am = 0
      # 返单邮件未返回数（未妥投）
      rw_am = 0
      # 正向邮件退回数
      fr_am = 0
      # 正向邮件未妥投返单邮件已收寄数
      fndrr_am = 0
      # 返单邮件返单率%
      rd_per = 0

      exp.each do |k, v|
        if (k[0] == x.id) && (k[1].eql?"forward")
          f_total_am += v
        end
        if (k[0] == x.id) && (k[1].eql?"forward") && (k[2].eql?"delivered")
          fd_am += v
        end
        if (k[0] == x.id) && (k[1].eql?"forward") && (k[2].eql?"waiting")
          fw_am += v
        end
        if (k[0] == x.id) && (k[1].eql?"receipt") && (k[2].eql?"delivered")
          rd_am += v
        end
        if (k[0] == x.id) && (k[1].eql?"receipt") && (k[2].eql?"waiting")
          rw_am += v
        end
        if (k[0] == x.id) && (k[1].eql?"forward") && (k[2].eql?"returns")
          fr_am += v
        end
        
        if (k[0] == x.id) && (k[1].eql?"forward") && (!k[2].eql?"delivered") && (k[3].eql?"receipt_receive")
          fndrr_am += v
        end
      end
      fdrr_am = exp[[x.id, "forward", "delivered", "receipt_receive"]].blank? ? 0 : exp[[x.id, "forward", "delivered", "receipt_receive"]]
      fdrn_am = exp[[x.id, "forward", "delivered", nil]].blank? ? 0 : exp[[x.id, "forward", "delivered", nil]]
      rd_per = f_total_am>0 ? (rd_am/f_total_am.to_f*100).round(2) : 0

      f_total_am_hj += f_total_am
      fd_am_hj += fd_am
      fw_am_hj += fw_am
      fdrr_am_hj += fdrr_am
      fdrn_am_hj += fdrn_am
      rd_am_hj += rd_am
      rw_am_hj += rw_am
      fr_am_hj += fr_am
      fndrr_am_hj += fndrr_am
      
      results[x] = [f_total_am, fd_am, fw_am, fdrr_am, fdrn_am, rd_am, rw_am, fr_am, fndrr_am, rd_per]
    end
    rd_per_hj = f_total_am_hj>0 ? (rd_am_hj/f_total_am_hj.to_f*100).round(2) : 0

    results["合计"] = [f_total_am_hj, fd_am_hj, fw_am_hj, fdrr_am_hj, fdrn_am_hj, rd_am_hj, rw_am_hj, fr_am_hj, fndrr_am_hj, rd_per_hj]

    return results
  end

  def receipt_flag_name
    Express::RECEIPT_FLAG["#{Express.receipt_flags.invert[receipt_flag]}".to_sym]
  end

  def receipt_status_name
    (!receipt_flag.blank? && (receipt_flag.eql?"forward")) ? Express::RECEIPT_STATUS["#{Express.receipt_statuses.invert[receipt_status]}".to_sym] : ""
  end

  def base_product_no_name
    if !base_product_no.blank? && ((base_product_no.eql?BASE_PRODUCT_NOS["standard_express".to_sym]) || (base_product_no.eql?BASE_PRODUCT_NOS["express_package".to_sym]))
      Express::BASE_PRODUCT_NAME["#{BASE_PRODUCT_NOS.invert[base_product_no]}".to_sym]
    else
      Express::BASE_PRODUCT_NAME["other_product".to_sym]
    end
  end

  def self.get_province_city_result(expresses, params)
    results = {}
    total_hj = 0       #收寄数
    deliver_hj = 0     #总妥投数
    deliver3_hj = 0    #三日妥投总数
    deliver2_hj = 0    #次日妥投总数
    deliver5_hj = 0    #五日妥投总数
    waiting_hj = 0     #未妥投总数
    return_hj = 0      #退回数
    
    if params[:receiver_province_no].blank?   
      expresses = expresses.joins("left join areas on areas.code=expresses.receiver_province_no")
      total_amount = expresses.group(:receiver_province_no, "areas.name").count
      status_amount = expresses.group(:receiver_province_no, "areas.name", :status).count
      deliver2 = expresses.delivered.where("expresses.delivered_days < 2").group(:receiver_province_no, "areas.name").count
      deliver3 = expresses.delivered.where("expresses.delivered_days < 3").group(:receiver_province_no, "areas.name").count
      deliver5 = expresses.delivered.where("expresses.delivered_days < 5").group(:receiver_province_no, "areas.name").count
      deliver_avg = expresses.delivered.group(:receiver_province_no, "areas.name").average(:delivered_days)
    else
      expresses = expresses.joins("left join areas on areas.code=expresses.receiver_city_no").where.not("areas.is_prov=true and areas.is_city=false")
      total_amount = expresses.group(:receiver_city_no, "areas.name").count
      status_amount = expresses.group(:receiver_city_no, "areas.name", :status).count
      deliver2 = expresses.delivered.where("expresses.delivered_days < 2").group(:receiver_city_no, "areas.name").count
      deliver3 = expresses.delivered.where("expresses.delivered_days < 3").group(:receiver_city_no, "areas.name").count
      deliver5 = expresses.delivered.where("expresses.delivered_days < 5").group(:receiver_city_no, "areas.name").count
      deliver_avg = expresses.delivered.group(:receiver_city_no, "areas.name").average(:delivered_days)
    end
 
    total_amount.each do |k, v|
      total_am = v
      total_hj += total_am
      deliver_am =status_amount[[k[0], k[1], "delivered"]].blank? ? 0 : status_amount[[k[0], k[1], "delivered"]]
      deliver_hj += deliver_am
      deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
      deliver_days_avg = deliver_avg[k].blank? ? 0 : deliver_avg[k]
      deliver2_am = deliver2[k].blank? ? 0 : deliver2[k]
      deliver2_hj += deliver2_am
      deliver2_per = total_am>0 ? (deliver2_am/total_am.to_f*100).round(2) : 0
      deliver3_am = deliver3[k].blank? ? 0 : deliver3[k]
      deliver3_hj += deliver3_am
      deliver3_per = total_am>0 ? (deliver3_am/total_am.to_f*100).round(2) : 0
      deliver5_am = deliver5[k].blank? ? 0 : deliver5[k]
      deliver5_hj += deliver5_am
      deliver5_per = total_am>0 ? (deliver5_am/total_am.to_f*100).round(2) : 0
      waiting_am = status_amount[[k[0], k[1], "waiting"]].blank? ? 0 : status_amount[[k[0], k[1], "waiting"]]
      waiting_hj += waiting_am
      waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0 
      return_am = status_amount[[k[0], k[1], "returns"]].blank? ? 0 : status_amount[[k[0], k[1], "returns"]]
      return_hj += return_am
      return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0

      results[k] = [total_am, deliver_am, deliver_per, deliver_days_avg, deliver2_per, deliver2_am, deliver3_per, deliver3_am, deliver5_per, deliver5_am, waiting_am, waiting_per, return_am, return_per]
    end
    deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
    deliver2_per_hj = total_hj>0 ? (deliver2_hj/total_hj.to_f*100).round(2) : 0
    deliver3_per_hj = total_hj>0 ? (deliver3_hj/total_hj.to_f*100).round(2) : 0
    deliver5_per_hj = total_hj>0 ? (deliver5_hj/total_hj.to_f*100).round(2) : 0
    waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
    return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
    deliver_days_avg_hj = expresses.delivered.average(:delivered_days).blank? ? 0 : expresses.delivered.average(:delivered_days)
      
    if total_hj>0
      results[["","合计"]] = [total_hj, deliver_hj, deliver_per_hj, deliver_days_avg_hj, deliver2_per_hj, deliver2_hj, deliver3_per_hj, deliver3_hj, deliver5_per_hj, deliver5_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj]
    end
# byebug
    return results
  end

end


