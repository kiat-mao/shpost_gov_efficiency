class Express < ApplicationRecord
  validates_presence_of :express_no, :business_id, :message => '不能为空'

  enum status: {waiting: 'waiting', delivered: 'delivered', returns: 'returns'}

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
end
