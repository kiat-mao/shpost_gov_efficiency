class Express < ApplicationRecord
  belongs_to :business
  belongs_to :post_unit, class_name: 'Unit'
  belongs_to :last_unit, class_name: 'Unit'
  validates_presence_of :express_no, :business_id, :message => '不能为空'

  enum status: {waiting: 'waiting', delivered: 'delivered', returns: 'returns'}
  STATUS_NAME = { waiting: '未妥投', delivered: '妥投', returns: '退回'}

	def self.init_express(business, pkp_waybill_base, mail_trace)
		express = Express.find_by(express_no: pkp_waybill_base.waybill_no)
		express ||= Express.new

		express.express_no = pkp_waybill_base.waybill_no
    express.business_id = business.try :id
    
    if !pkp_waybill_base.post_org_no.blank?
      post_unit = Unit.find_by no: pkp_waybill_base.post_org_no
      express.post_unit_id = post_unit.try :id
    end

    express.posting_date = pkp_waybill_base.biz_occur_date
    # express.posting_date = pkp_waybill_base.biz_occur_date.to_date
    #express.last_unit_id = mail_trace.
    if ! mail_trace.blank? && mail_trace.mail_no.eql?(pkp_waybill_base.waybill_no)
      express.status = Express.to_status(mail_trace.status) || Express::statuses[:waiting]
      express.last_op_at = mail_trace.operated_at
      express.last_op_desc = mail_trace.result
    else
      express.status = Express::statuses[:waiting]
    end
    #express.sign = nil
    #express.desc = nil
    
    express.fill_delivered_days

    express.save!
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

  def self.get_deliver_market_result(expresses)
    results = {}

    business_ids = expresses.select(:business_id).distinct
    total_amount = expresses.group("businesses.btype").count
    status_amount = expresses.group("businesses.btype", "expresses.status").count
    deliver2 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 2").group("businesses.btype").count
    deliver3 = expresses.where("expresses.status = 'delivered'").where("expresses.delivered_days < 3").group("businesses.btype").count

    business_ids.each do |x|
# debugger
      btype = Business.find(x.business_id).btype
      total_am = total_amount[btype]
      deliver_am = status_amount[[btype, "delivered"]].blank? ? 0 : status_amount[[btype, "delivered"]]
      deliver_per = (deliver_am/total_am.to_f*100).round(2)
      deliver3_per = deliver3[btype].blank? ? 0 : (deliver3[btype]/total_am.to_f*100).round(2)
      deliver2_per = deliver2[btype].blank? ? 0 : (deliver2[btype]/total_am.to_f*100).round(2)
      waiting_am = status_amount[[btype, "waiting"]].blank? ? 0 : status_amount[[btype, "waiting"]]
      waiting_per = (waiting_am/total_am.to_f*100).round(2)
      return_am = status_amount[[btype, "returns"]].blank? ? 0 : status_amount[[btype, "returns"]]
      return_per = (return_am/total_am.to_f*100).round(2)

      results[btype] = [total_am, deliver_am, deliver_per, deliver3_per, deliver2_per, waiting_am, waiting_per, return_am, return_per]
    end

    return results
  end

  def status_name
    status.blank? ? "" : Express::STATUS_NAME["#{status}".to_sym]
  end

  def self.get_filter_expresses(params)
    expresses = Express.left_outer_joins(:business).all
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
      expresses = expresses.where("expresses.posting_date < ?", params[:posting_date_end])
    end

    if !params[:detail_btype].blank?
      expresses = expresses.where("businesses.btype = ?", params[:detail_btype])
    end

    if !params[:status].blank?
      expresses = expresses.where("expresses.status = ?", params[:status])
    end

    return expresses
  end
end
