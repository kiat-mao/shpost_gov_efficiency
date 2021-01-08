class PkpWaybillBase < PkpDataRecord
  has_one :pkp_waybill_biz, foreign_key: 'waybill_no', primary_key: 'waybill_no'#, optional: true
  has_one :post_unit, class_name: 'Unit', foreign_key: 'no', primary_key: 'post_org_no'
  has_one :mail_trace, foreign_key: 'mail_no', primary_key: 'waybill_no'

  #  # 4 common
  # def self.get_pkp_waybill_bases_yesterday(name)
  #   businesses = I18n.t(:PkpWaybillBase)[name.to_sym][:businesses]
  #   businesses.each do |x|
  #     business_no = x[:business_no]
  #     business = Business.find_by no: business_no

  #     if !business.blank?
  #       sender_no = x[:sender_no]
        
  #       pkp_waybill_bases = self.where(sender_no: sender_no).where(created_day: Date.yesterday.strftime("%d")).where("biz_occur_date >= ? ",Date.yesterday).where("biz_occur_date < ? ", Date.today)

  #       ActiveRecord::Base.transaction do
  #         pkp_waybill_bases.each do |x|
  #           next if QueryResult.exists?(["registration_no = ? and business_id != ?", x.waybill_no, business.id]) #Maybe delete if change registration_no uniq to registration_no&business uniq

  #           query_result = QueryResult.find_or_initialize_by(registration_no: x.waybill_no, business: business)

  #           query_result.update!(registration_no: x.waybill_no, business: business, unit: business.unit, status: QueryResult::STATUS[:waiting], source: 'ESB', business_code: x.logistics_order_no, postcode: x.sender_postcode, order_date: x.biz_occur_date, is_posting: false, is_sent: false, to_send: false)


  #           pkp_waybill_base_local = query_result.pkp_waybill_base_local

  #           pkp_waybill_base_local ||= PkpWaybillBaseLocal.new(query_result: query_result)

  #           pkp_waybill_base_local = x.to_local pkp_waybill_base_local

  #           pkp_waybill_base_local.save!
  #         end
  #       end
  #     end
  #   end
  # end

  # def to_local(pkp_waybill_base_local = nil)
  #   #copy pkp_waybill_base
  #   pkp_waybill_base_local ||= PkpWaybillBaseLocal.new
    
  #   PkpWaybillBase.columns.each{|c| pkp_waybill_base_local[c.name] = x[c.name] if pkp_waybill_base_local.response_to("#{c.name}=") && ! c.name.in?(["id", "created_at", "updated_at"]) }

  #   return pkp_waybill_base_local
  # end
end
