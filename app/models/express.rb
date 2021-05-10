class Express < ApplicationRecord
  belongs_to :business, optional: true
  belongs_to :post_unit, class_name: 'Unit', optional: true
  belongs_to :last_unit, class_name: 'Unit', optional: true

  has_one :post_parent_unit, class_name: 'Unit', through: :post_unit, source: 'parent_unit'
  has_one :last_parent_unit, class_name: 'Unit', through: :last_unit, source: 'parent_unit'
  has_one :mail_trace, foreign_key: 'mail_no', primary_key: 'express_no'

  belongs_to :pre_express, class_name: 'Express', optional: true
  belongs_to :receipt_express, class_name: 'Express', optional: true

  belongs_to :receiver_province, class_name: 'Area', :primary_key => 'code', :foreign_key => 'receiver_province_no', optional: true
  belongs_to :receiver_city, class_name: 'Area', :primary_key => 'code', :foreign_key => 'receiver_city_no', optional: true
  belongs_to :receiver_county, class_name: 'Area', :primary_key => 'code', :foreign_key => 'receiver_county_no', optional: true

  validates_presence_of :express_no, :business_id, :message => '不能为空'
  
  enum status: {waiting: 'waiting', delivered: 'delivered', returns: 'returns', del: 'del'}
  STATUS_NAME = { waiting: '未妥投', delivered: '妥投', returns: '退回'}

  enum whereis: {in_transit: 'in_transit', delivery_part: 'delivery part'}
  WHEREIS_NAME = {in_transit: '在途中', delivery_part: '投递端'}

  enum delivered_status: {own: 'own', other: 'other', unit: 'unit'}
  DELIVERED_STATUS = {own: '本人收', other: '他人收', unit: '单位/快递柜'}

  #enum base_product_no: {standard_express: '11210', express_package: '11312'}
  BASE_PRODUCT_NAME = {standard_express: '标快', express_package: '快包', other_product: '其他'}
  BASE_PRODUCT_NOS =  {standard_express: '11210', express_package: '11312'}
  BASE_PRODUCT_SELECT = {'11210' => '标快', '11312' => '快包', other_product: '其他'}

  enum receipt_flag: {forward: 'forward', receipt: 'receipt', no_receipt_flag: nil}
  RECEIPT_FLAG = {forward: '正向邮件', receipt: '反向邮件', no_receipt_flag: '普通邮件'}
  RECEIPT_FLAG_SELECT = {forward: '正向邮件', receipt: '反向邮件', null: '普通邮件'}

  enum receipt_status: {receipt_receive: 'receipt_receive', no_receipt_receive: nil, receipt_delivered: 'receipt_delivered'}
  RECEIPT_STATUS = {receipt_receive: '已收寄', no_receipt_receive: '未收寄', receipt_delivered: '已妥投'}
  RECEIPT_STATUS_SELECT = {receipt_receive: '已收寄', null: '未收寄', receipt_delivered: '已妥投'}

  DISTRIBUTIVE_CENTER_NAME = { '21112100': '南京集航'}

  scope :standard_express, -> {where(base_product_no: '11210')}

  scope :express_package, -> {where(base_product_no: '11312')}

  scope :other_product, -> {where.not(base_product_no: Express::BASE_PRODUCT_NOS.values).or(Express.where(base_product_no: nil))}

  scope :bf_free_tax, -> {where(biz_product_no: '112104300300991')}

  
  
  def self.init_expresses_yesterday
    start_date = Date.today - 1.day
    end_date = Date.today
    Express.init_expresses(start_date, end_date)
  end

  def self.refresh_traces_last_15days
    start_date = Date.today - 15.day
    end_date = Date.today - 1.day
    Express.refresh_traces(start_date, end_date)
  end

  def self.refresh_traces_25days_ago
    start_date = Date.today - 25.day
    end_date = start_date + 1.day
    Express.refresh_traces(start_date, end_date)
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


  #only business with is_init_expresses_midday true
  def self.refresh_traces_today
    start_date = Date.today
    end_date = Date.today + 1.day
    Express.refresh_traces(start_date, end_date, true)
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

  def self.init_expresses_midday
    start_date = Date.today
    end_date = start_date + 1.day
    puts("#{Time.now}, init_expresses, start_date: #{start_date}, end_date: #{end_date}")
    businesses = Business.where(is_init_expresses_midday: true)
    businesses.each do |business|
      Express.init_expresses_by_business(business, start_date, end_date)
    end
  end

  def self.refresh_traces(start_date, end_date, only_midday = false)
    if start_date.blank? || end_date.blank?
      return
    end
    start_date = start_date.to_date
    end_date = end_date.to_date
    puts("#{Time.now}, refresh_traces, start_date: #{start_date}, end_date: #{end_date}")
    #businesses = Business.all.order(is_init_expresses_midday: :desc)
    
    businesses = Business.where(is_init_expresses_midday: only_midday)

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

    
    expresses = Express.includes(:mail_trace).where(business: business).where("posting_date >= ? and posting_date < ?", start_date, end_date).waiting
    
    ActiveRecord::Base.transaction do
      expresses.find_each(batch_size: 2000) do |express|
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

    pkp_waybill_bases = PkpWaybillBase.includes(:pkp_waybill_biz, :post_unit, :mail_trace).where(sender_no: business.code).where("biz_occur_date >= ? and biz_occur_date < ?", start_date, end_date)
    if end_date - start_date <= 1
      pkp_waybill_bases = pkp_waybill_bases.where(created_day: start_date.strftime("%d"))
    else
      days = (start_date...end_date).to_a.map{|x| x.strftime("%d")}
      pkp_waybill_bases = pkp_waybill_bases.where(created_day: days)
    end
    ActiveRecord::Base.transaction do
      pkp_waybill_bases.find_each(batch_size: 2000) do |pkp_waybill_base|
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
    express.biz_product_no = pkp_waybill_base.biz_product_no

    #distributive_center_no
    #NJ = 21112100
    express.distributive_center_no = pkp_waybill_base.pkp_waybill_biz.distributive_center_no

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

    express.refresh_trace pkp_waybill_base.mail_trace

    #express.sign = nil
    #express.desc = nil
    
    if ! express.del?
      express.save!
    end
  end

  def refresh_trace! mail_trace = nil
    self.refresh_trace mail_trace

    if ! self.del?
      self.save!
    else
      self.destroy!
    end
  end

  def refresh_trace mail_trace = nil
    mail_trace ||= self.mail_trace
    mail_trace ||= MailTrace.find_by mail_no: self.express_no

    if ! mail_trace.blank?
      self.status = Express.to_status(mail_trace.status) || Express::statuses[:waiting]
      if self.delivered? && self.delivered_status.blank?
        begin
          self.delivered_status = mail_trace.status
        rescue
        end
      end
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

      if self.receipt? && self.delivered?
        self.pre_express.try(:receipt_delivered!)
      end
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
      expresses.find_each(batch_size: 2000)  do |express|
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

  def status_name
    status.blank? ? "" : Express::STATUS_NAME["#{status}".to_sym]
  end

  def whereis_name
    whereis.blank? ? "" : Express::WHEREIS_NAME["#{whereis}".to_sym]
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

  def distributive_center_name
    distributive_center_no.blank? ? "" : Express::DISTRIBUTIVE_CENTER_NAME["#{distributive_center_no}".to_sym]
  end

end


