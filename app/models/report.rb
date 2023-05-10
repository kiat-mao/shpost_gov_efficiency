class Report 
	def self.select_destinations
  	["全部", "全国", "本省", "异地", "国际"]
	end

	def self.select_years
    years = []
    i = 4
    until i < 0 
      years << Time.now.year-i
      i = i - 1
    end
    return years
  end

  def self.select_months
    ["1","2","3","4","5","6","7","8","9","10","11","12"]
  end

  def self.select_posting_hours
    i = 0
    posting_hours = []
    until i > 24
      posting_hours << i
      i += 1
    end
    return posting_hours
  end

  def self.select_delivered_days_show
    ["3","4","5","6","7","8","9","10"]
  end

  DELIVERED_DAYS_NAME = {0.0 => '当日', 0.5 => '次日上午', 1.0 => '次日下午', 1.5 => '三日上午', 2.0 => '三日下午', 2.5 => '四日上午', 3.0 => '四日下午', 3.5 => '五日上午', 4.0 => '五日下午', 4.5 => '六日上午', 5.0 => '六日下午', 5.5 => '七日上午', 6.0 => '七日下午', 6.5 => '八日上午', 7.0 => '八日下午', 7.5 => '九日上午', 8.0 => '九日下午', 8.5 => '十日上午', 9.0 => '十日下午', 9.5 => '十一日上午', 10.0 => '十一日下午'}
  DELAY_DELIVERED_NAME = {3.0 => '三', 4.0 => '四',5.0 => '五',6.0 => '六',7.0 => '七',8.0 => '八',9.0 => '九',10.0 => '十'}

  # def self.get_filter_expresses(params)
  #   start_date = nil
  #   end_date = nil
  #   expresses = Express.left_outer_joins(:business)
    
  #   if !params[:industry].blank? && !params[:industry][0].blank?
  #     industry = params[:industry]
  #     # from link
  #     if industry.is_a?String
  #       industry = params[:industry].split(",")
  #     end
  #     expresses = expresses.where(businesses: {industry: industry})
  #   end
    
  #   if !params[:btype].blank? && !params[:btype][0].blank?
  #     btype = params[:btype]
  #     # from link
  #     if btype.is_a?String
  #       btype = params[:btype].split(",")
  #     end
  #     # expresses = expresses.where("businesses.btype in (?)", btype)
  #     expresses = expresses.where(businesses: {btype: btype})
  #   end

  #   if !params[:business].blank?
  #     expresses = expresses.where("businesses.code like ? or businesses.name like ?", "%#{params[:business]}%", "%#{params[:business]}%")
  #   end

  #   if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
  #     if !params[:year].blank? && !params[:month].blank?
  #       start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month
  #       end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month+1.day
  #     end
  #   else
  #     start_date = params[:posting_date_start] if !params[:posting_date_start].blank?
  #     end_date = params[:posting_date_end].to_date+1.day if !params[:posting_date_end].blank?
  #   end

  #   if !start_date.blank?
  #     expresses = expresses.where("expresses.posting_date >= ?",start_date)
  #   end

  #   if !end_date.blank?
  #     expresses = expresses.where("expresses.posting_date <= ?", end_date)
  #   end
    
  #   if !params[:detail_btype].blank? && !(params[:detail_btype].eql?"合计")
  #     expresses = expresses.where(businesses: {btype: params[:detail_btype]})
  #   end

  #   if !params[:status].blank?
  #     if params[:status].eql?"not_delivered"
  #       expresses = expresses.where.not(status: "delivered")
  #     else
  #       expresses = expresses.where(status: params[:status])
  #     end
  #   end

  #   if !params[:last_unit_id].blank? && !(params[:last_unit_id].eql?"合计")
  #     if params[:last_unit_id].eql?"其他"
  #       expresses = expresses.where(last_unit_id: nil)
  #     else
  #       expresses = expresses.where(last_unit_id: params[:last_unit_id])
  #     end
  #   end

  #   # if (!params[:is_court].blank?) && (params[:is_court].eql?"true")
  #   #   expresses = expresses.where.not(receiver_province_no: "310000")
  #   # else
  #   #   expresses = expresses.where.not("businesses.industry = ? and expresses.receiver_province_no != ?", "法院", "310000") 
  #   # end
  #   if !params[:is_court].blank?
  #     if params[:is_court].eql?"false"
  #       expresses = expresses.where.not(businesses: {industry: "法院"})
  #     else
  #       expresses = expresses.where(businesses: {industry: "法院"})
  #     end
  #   end

  #   if !params[:detail_business].blank?
  #     expresses = expresses.where(business_id: params[:detail_business])
  #   end

  #   if !params[:destination].blank?
  #     if params[:destination].eql?"全国"
  #       expresses = expresses.where.not(receiver_province_no: nil)
  #     elsif params[:destination].eql?"本省"
  #       expresses = expresses.where(receiver_province_no: "310000")
  #     elsif params[:destination].eql?"异地"
  #       expresses = expresses.where.not(receiver_province_no: "310000")
  #     elsif params[:destination].eql?"国际"
  #       expresses = expresses.where(receiver_province_no: "nil")
  #     end         
  #   end

  #   if !params[:lv2_unit].blank?
  #     expresses = expresses.left_outer_joins(:last_unit).where(units: {parent_id: params[:lv2_unit]})
  #   end

  #   if !params[:transit_delivery].blank?
  #     expresses = expresses.where(whereis: params[:transit_delivery])
  #   end

  #   if !params[:product].blank? || (!params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:base_product_no].blank? && !params[:expresses][:f][:base_product_no][0].blank?)
  #     # from wice_grid
  #     if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:base_product_no].blank? && !params[:expresses][:f][:base_product_no][0].blank?
  #       product = params[:expresses][:f][:base_product_no][0].split(",")
  #     else
  #       # from link
  #       if params[:product].is_a?String
  #         product = params[:product].split(",")
  #       # from submit
  #       else
  #         product = params[:product]
  #       end
  #     end

  #     if !product.include?"other_product"       
  #       expresses = expresses.where(base_product_no: product)
  #     else
  #       if product.size==1
  #         expresses = expresses.other_product
  #       else
  #         expresses = expresses.where(base_product_no: product-["other_product"]).or(expresses.where.not(base_product_no: Express::BASE_PRODUCT_NOS.values)).or(expresses.where(base_product_no: nil))
  #       end
  #     end

  #     if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:base_product_no].blank?
  #       params[:expresses][:f][:base_product_no] = nil
  #     end
  #   end

  #   if !params[:receipt_flag].blank?
  #     expresses = expresses.where(receipt_flag: params[:receipt_flag])
  #   end

  #   if !params[:receipt_status].blank?
  #     if params[:receipt_status].eql?"no_receipt_receive"
  #       expresses = expresses.no_receipt_receive
  #     elsif params[:receipt_status].eql?"receipt_receive"
  #       expresses = expresses.receipt_receive
  #     elsif params[:receipt_status].eql?"receipt_delivered"
  #       expresses = expresses.receipt_delivered  
  #     elsif params[:receipt_status].eql?"receipt_receive_or_delivered"
  #       expresses = expresses.where.not(receipt_status: nil)         
  #     end
  #   end
      
  #   if !params[:distributive_center_no].blank?
  #     expresses = expresses.where(distributive_center_no: params[:distributive_center_no])
  #   end

  #   if !params[:posting_hour_start].blank? && !params[:posting_hour_end].blank?
  #     expresses = expresses.where("posting_hour >= ? and posting_hour < ?", params[:posting_hour_start].to_i, params[:posting_hour_end].to_i)
  #   end

  #   if !params[:receiver_province_no].blank? && !(params[:receiver_province_no].eql?"合计")
  #     if params[:receiver_province_no].eql?"nil"
  #       expresses = expresses.where(receiver_province_no: nil)
  #     else
  #       expresses = expresses.where(receiver_province_no: params[:receiver_province_no])
  #     end
  #   end

  #   if !params[:receiver_city_no].blank? && !(params[:receiver_city_no].eql?"合计")
  #     if params[:receiver_province_no].eql?"nil"
  #       expresses = expresses.where(receiver_province_no: nil)
  #     else
  #       expresses = expresses.where(receiver_city_no: params[:receiver_city_no])
  #     end
  #   end

  #   if !params[:delivered_days].blank?
  #     expresses = expresses.where("delivered_days <= ?", params[:delivered_days].to_f)
  #   end

  #   if !params[:delivered_date_start].blank?
  #     expresses = expresses.delivered.where("expresses.last_op_at >= ?", params[:delivered_date_start])
  #   end

  #   if !params[:delivered_date_end].blank?
  #     expresses = expresses.delivered.where("expresses.last_op_at <= ?", params[:delivered_date_end].to_date+1.day)
  #   end

  #   if !params[:delivered_status].blank?
  #     expresses = expresses.where(delivered_status: params[:delivered_status])
  #   end

  #   if !params[:checkbox].blank? && (!params[:checkbox][:bf_free_tax].blank?) && (params[:checkbox][:bf_free_tax].eql?"1")
  #     expresses = expresses.bf_free_tax
  #   end
  #   # from link
  #   if !params[:bf_free_tax].blank? && (params[:bf_free_tax].eql?"1")
  #     expresses = expresses.bf_free_tax
  #   end

  #   if !params[:transfer_type].blank? || (!params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:transfer_type].blank? && !params[:expresses][:f][:transfer_type][0].blank?)
  #     if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:transfer_type].blank? && !params[:expresses][:f][:transfer_type][0].blank?
  #       transfer_type = params[:expresses][:f][:transfer_type][0]
  #     else
  #       transfer_type = params[:transfer_type]
  #     end
      
  #     if transfer_type.eql?"3"       
  #       expresses = expresses.all_land
  #     elsif transfer_type.eql?"other_type" 
  #       expresses = expresses.other_type
  #     end

  #     if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:transfer_type].blank?
  #       params[:expresses][:f][:transfer_type] = nil
  #     end
  #   end

  #   if !params[:need_alert].blank? && (params[:need_alert].eql?"true")
  #     if RailsEnv.is_oracle?
  #       expresses = expresses.where("businesses.static_alert=? and expresses.status=?", true, "waiting").where("businesses.time_limit is not null").where("expresses.last_op_at + businesses.time_limit/24)<?", Time.now)
  #     else
  #       expresses = expresses.where("businesses.static_alert=? and expresses.status=?", true, "waiting").where("businesses.time_limit is not null").where("datetime(expresses.last_op_at, '+' || businesses.time_limit || ' hours')<?", Time.now)
  #     end
  #   end

  #   return expresses
  # end

  def self.get_filter_expresses(params)
    start_date = nil
    end_date = nil
    expresses = Express.all
    
    if !params[:industry].blank? && !params[:industry][0].blank?
      industry = params[:industry]
      # from link
      if industry.is_a?String
        industry = params[:industry].split(",")
      end
      businesses = Business.where(industry: industry).map{|b| b.id}.uniq
      expresses = expresses.where(business_id: businesses)
    end
    
    if !params[:btype].blank? && !params[:btype][0].blank?
      btype = params[:btype]
      # from link
      if btype.is_a?String
        btype = params[:btype].split(",")
      end
      businesses = Business.where(btype: btype).map{|b| b.id}.uniq
      expresses = expresses.where(business_id: businesses)
    end

    if !params[:business].blank?
      businesses = Business.where("businesses.code like ? or businesses.name like ?", "%#{params[:business]}%", "%#{params[:business]}%").map{|b| b.id}.uniq
      expresses = expresses.where(business_id: businesses)
    end

    if !params[:search_time].blank? && (params[:search_time].eql?"by_m")
      if !params[:year].blank? && !params[:month].blank?
        start_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.at_beginning_of_month
        end_date = (params[:year] + params[:month].rjust(2, '0')+"01").to_date.end_of_month+1.day
      end
    else
      start_date = params[:posting_date_start] if !params[:posting_date_start].blank?
      end_date = params[:posting_date_end].to_date+1.day if !params[:posting_date_end].blank?
    end

    if !start_date.blank?
      expresses = expresses.where("expresses.posting_date >= ?",start_date)
    end

    if !end_date.blank?
      expresses = expresses.where("expresses.posting_date <= ?", end_date)
    end
    
    if !params[:detail_btype].blank? && !(params[:detail_btype].eql?"合计")
      businesses = Business.where(btype: params[:detail_btype]).map{|b| b.id}.uniq
      expresses = expresses.where(business_id: businesses)
    end

    if !params[:status].blank?
      if params[:status].eql?"not_delivered"
        expresses = expresses.where.not(status: "delivered")
      else
        expresses = expresses.where(status: params[:status])
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
    if !params[:is_court].blank?
      businesses = Business.where(industry: "法院").map{|b| b.id}.uniq
      if params[:is_court].eql?"false"
        expresses = expresses.where.not(business_id: businesses)
      else
        expresses = expresses.where(business_id: businesses)
      end
    end

    if !params[:detail_business].blank?
      expresses = expresses.where(business_id: params[:detail_business])
    end

    if !params[:destination].blank?
      if params[:destination].eql?"全国"
        expresses = expresses.where.not(receiver_province_no: nil)
      elsif params[:destination].eql?"本省"
        expresses = expresses.where(receiver_province_no: "310000")
      elsif params[:destination].eql?"异地"
        expresses = expresses.where.not(receiver_province_no: "310000")
      elsif params[:destination].eql?"国际"
        expresses = expresses.where(receiver_province_no: "nil")
      end         
    end

    if !params[:lv2_unit].blank?
      expresses = expresses.left_outer_joins(:last_unit).where(units: {parent_id: params[:lv2_unit]})
    end

    if !params[:transit_delivery].blank?
      expresses = expresses.where(whereis: params[:transit_delivery])
    end

    if !params[:product].blank? || (!params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:base_product_no].blank? && !params[:expresses][:f][:base_product_no][0].blank?)
      # from wice_grid
      if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:base_product_no].blank? && !params[:expresses][:f][:base_product_no][0].blank?
        product = params[:expresses][:f][:base_product_no][0].split(",")
      else
        # from link
        if params[:product].is_a?String
          product = params[:product].split(",")
        # from submit
        else
          product = params[:product]
        end
      end

      if !product.include?"other_product"       
        expresses = expresses.where(base_product_no: product)
      else
        if product.size==1
          expresses = expresses.other_product
        else
          expresses = expresses.where(base_product_no: product-["other_product"]).or(expresses.where.not(base_product_no: Express::BASE_PRODUCT_NOS.values)).or(expresses.where(base_product_no: nil))
        end
      end

      if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:base_product_no].blank?
        params[:expresses][:f][:base_product_no] = nil
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
      elsif params[:receipt_status].eql?"receipt_delivered"
        expresses = expresses.receipt_delivered  
      elsif params[:receipt_status].eql?"receipt_receive_or_delivered"
        expresses = expresses.where.not(receipt_status: nil)         
      end
    end
      
    if !params[:distributive_center_no].blank?
      expresses = expresses.where(distributive_center_no: params[:distributive_center_no])
    end

    if !params[:posting_hour_start].blank? && !params[:posting_hour_end].blank?
      expresses = expresses.where("posting_hour >= ? and posting_hour < ?", params[:posting_hour_start].to_i, params[:posting_hour_end].to_i)
    end

    if !params[:receiver_province_no].blank? && !(params[:receiver_province_no].eql?"合计")
      if params[:receiver_province_no].eql?"nil"
        expresses = expresses.where(receiver_province_no: nil)
      else
        expresses = expresses.where(receiver_province_no: params[:receiver_province_no])
      end
    end

    if !params[:receiver_city_no].blank? && !(params[:receiver_city_no].eql?"合计")
      if params[:receiver_province_no].eql?"nil"
        expresses = expresses.where(receiver_province_no: nil)
      else
        expresses = expresses.where(receiver_city_no: params[:receiver_city_no])
      end
    end

    if !params[:delivered_days].blank?
      expresses = expresses.where("delivered_days <= ?", params[:delivered_days].to_f)
    end

    if !params[:delivered_date_start].blank?
      expresses = expresses.delivered.where("expresses.last_op_at >= ?", params[:delivered_date_start])
    end

    if !params[:delivered_date_end].blank?
      expresses = expresses.delivered.where("expresses.last_op_at <= ?", params[:delivered_date_end].to_date+1.day)
    end

    if !params[:delivered_status].blank?
      expresses = expresses.where(delivered_status: params[:delivered_status])
    end

    if !params[:checkbox].blank? && (!params[:checkbox][:bf_free_tax].blank?) && (params[:checkbox][:bf_free_tax].eql?"1")
      expresses = expresses.bf_free_tax
    end
    # from link
    if !params[:bf_free_tax].blank? && (params[:bf_free_tax].eql?"1")
      expresses = expresses.bf_free_tax
    end

    if !params[:transfer_type].blank? || (!params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:transfer_type].blank? && !params[:expresses][:f][:transfer_type][0].blank?)
      if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:transfer_type].blank? && !params[:expresses][:f][:transfer_type][0].blank?
        transfer_type = params[:expresses][:f][:transfer_type][0]
      else
        transfer_type = params[:transfer_type]
      end
      
      if transfer_type.eql?"3"       
        expresses = expresses.all_land
      elsif transfer_type.eql?"other_type" 
        expresses = expresses.other_type
      end

      if !params[:expresses].blank? && !params[:expresses][:f].blank? && !params[:expresses][:f][:transfer_type].blank?
        params[:expresses][:f][:transfer_type] = nil
      end
    end

    if !params[:need_alert].blank? && (params[:need_alert].eql?"true")
      if RailsEnv.is_oracle?
        expresses = expresses.left_outer_joins(:business).where("businesses.static_alert=? and expresses.status=?", true, "waiting").where("businesses.time_limit is not null").where("expresses.last_op_at + businesses.time_limit/24)<?", Time.now)
      else
        expresses = expresses.left_outer_joins(:business).where("businesses.static_alert=? and expresses.status=?", true, "waiting").where("businesses.time_limit is not null").where("datetime(expresses.last_op_at, '+' || businesses.time_limit || ' hours')<?", Time.now)
      end
    end

    if !params[:is_delay].blank? && !params[:delivered_days_show].blank?
      if params[:is_delay].eql?"true"
        expresses = expresses.where("expresses.delivered_days > ? or expresses.status = ?", params[:delivered_days_show].to_f, "waiting")
      end
    end

    if !params[:parent_unit_id].blank?
      last_unit_ids = Unit.where(parent_id: params[:parent_unit_id].to_i).map{|u| u.id}.uniq
      expresses = expresses.where(last_unit_id: last_unit_ids)
    end

    return expresses
  end


  def self.get_deliver_market_result(expresses, params, current_user)
    results = {}
    businesses = nil
    btypes = nil
    total_hj = 0
    deliver_hj = 0
    waiting_hj = 0
    return_hj = 0
    in_transit_hj = 0
    delivery_part_hj = 0
    deliver_own_hj = 0
    deliver_other_hj = 0
    deliver_unit_hj = 0
    delivered_days_hj = init_delivered_days_hj(params[:delivered_days_show])   #某日的妥投总数
    
    expresses = expresses.left_outer_joins(:business)
    if current_user.superadmin? || current_user.company_admin?
      if (!params[:is_court].blank?) && (params[:is_court].eql?"true")
        businesses = Business.where(industry: "法院")
      else
        businesses = Business.where.not("businesses.industry = ?", "法院")
      end
      
      if !params[:industry].blank? && !params[:industry][0].blank?
        if params[:industry].is_a?String
          # get_expresses_path拼装的数组
          businesses = businesses.where("industry in (?)", params[:industry].split(","))
        else
          # 页面上直接取得的数组
          businesses = businesses.where("industry in (?)", params[:industry])
        end
      end

      if !params[:btype].blank? && !params[:btype][0].blank?
        if params[:btype].is_a?String
          # get_expresses_path拼装的数组
          businesses = businesses.where("btype in (?)", params[:btype].split(","))
        else
          # 页面上直接取得的数组
          businesses = businesses.where("btype in (?)", params[:btype])
        end
      end
      btypes = businesses.group(:btype).count
    else
      btypes = expresses.group(:btype).count
    end
       
    status_amount = expresses.group("businesses.btype", "expresses.status").count
    deliver_days_amount = expresses.delivered.where("expresses.delivered_days <= ?", params[:delivered_days_show].to_f-1).group("businesses.btype").group("expresses.delivered_days").count
    transit_delivery = expresses.waiting.group("businesses.btype", "expresses.whereis").count
    delivered_status_amount = expresses.delivered.group("businesses.btype", "expresses.delivered_status").count

    btypes.each do |k,v|
      btype = k
      total_am = get_total_amount(k, status_amount)
      total_hj += total_am
      deliver_am =status_amount[[btype, "delivered"]].blank? ? 0 : status_amount[[btype, "delivered"]]
      deliver_hj += deliver_am
      deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
      
      delivered_days_xj = get_deliverd_days_per_hj(delivered_days_hj, params[:delivered_days_show], deliver_days_amount, k, total_am)

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
      deliver_own_am =delivered_status_amount[[btype, "own"]].blank? ? 0 : delivered_status_amount[[btype, "own"]]
      deliver_own_hj += deliver_own_am
      deliver_other_am =delivered_status_amount[[btype, "other"]].blank? ? 0 : delivered_status_amount[[btype, "other"]]
      deliver_other_hj += deliver_other_am
      deliver_unit_am =delivered_status_amount[[btype, "unit"]].blank? ? 0 : delivered_status_amount[[btype, "unit"]]
      deliver_unit_hj += deliver_unit_am

      # 0收寄数, 1总妥投数, 2本人收数, 3他人收数, 4单位/快递柜收数, 5妥投率, 6未妥投总数, 7未妥投率, 8退回数, 9退回率, 10在途中数, 11投递端数, 12各日妥投率
      results[btype] = [total_am, deliver_am, deliver_own_am, deliver_other_am, deliver_unit_am, deliver_per, waiting_am, waiting_per, return_am, return_per, in_transit_am, delivery_part_am, delivered_days_xj]
    end
    deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
    waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
    return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
    process_delivered_days_hj(delivered_days_hj, total_hj)

    # 0收寄数, 1总妥投数, 2本人收数, 3他人收数, 4单位/快递柜收数, 5妥投率, 6未妥投总数, 7未妥投率, 8退回数, 9退回率, 10在途中数, 11投递端数, 12各日妥投率  
    results["合计"] = [total_hj, deliver_hj, deliver_own_hj, deliver_other_hj, deliver_unit_hj, deliver_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj, in_transit_hj, delivery_part_hj, delivered_days_hj]

    return results
  end

  # def self.get_deliver_unit_result(expresses, params)
  #   results = {}
  #   results1 = {}
  #   total_hj = 0
  #   deliver_hj = 0
  #   waiting_hj = 0
  #   return_hj = 0
  #   in_transit_hj = 0
  #   delivery_part_hj = 0
  #   deliver_own_hj = 0
  #   deliver_other_hj = 0
  #   deliver_unit_hj = 0
  #   delivered_days_hj = init_delivered_days_hj(params[:delivered_days_show]) #某日的妥投总数
  #   delay_hj = 0
  
  #   if expresses.count>0
  #     # 总邮件数
  #     total_amount = expresses.left_outer_joins(:last_unit).left_outer_joins(:last_unit=>:parent_unit).group(:last_unit_id).group("units.name").group("units.parent_id").group("parent_units_units.name").count
  #     # 总妥投数,未妥投总数,退回数
  #     status_amount = expresses.group(:last_unit_id).group(:status).count
  #     # **日妥投率
  #     deliver_days_amount = expresses.delivered.where("expresses.delivered_days <= ?", params[:delivered_days_show].to_f-1).group(:last_unit_id).group("expresses.delivered_days").count
  #     # 在途中数,投递端数
  #     transit_delivery = expresses.waiting.group("expresses.last_unit_id", "expresses.whereis").count
  #     # 本人收数,他人收数,单位/快递柜收数
  #     delivered_status_amount = expresses.delivered.group(:last_unit_id, :delivered_status).count
  #     # *日未妥投数
  #     delay_amount = expresses.where("expresses.delivered_days > ? or expresses.status = ?", params[:delivered_days_show].to_f, "waiting").group(:last_unit_id).count

  #     total_amount.each do |k, v|
  #       last_unit_id = k[0]
  #       # 总邮件数
  #       total_am = v
  #       total_hj += total_am    
  #       # 总妥投数
  #       deliver_am =status_amount[[last_unit_id, "delivered"]].blank? ? 0 : status_amount[[last_unit_id, "delivered"]]
  #       deliver_hj += deliver_am
  #       # 妥投率
  #       deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
  #       # 各日妥投率
  #       delivered_days_xj = get_deliverd_days_per_hj(delivered_days_hj, params[:delivered_days_show], deliver_days_amount, last_unit_id, total_am)
  #       # 未妥投总数
  #       waiting_am = status_amount[[last_unit_id, "waiting"]].blank? ? 0 : status_amount[[last_unit_id, "waiting"]]
  #       waiting_hj += waiting_am
  #       # 在途中数
  #       in_transit_am = transit_delivery[[last_unit_id, "in_transit"]].blank? ? 0 : transit_delivery[[last_unit_id, "in_transit"]]
  #       in_transit_hj += in_transit_am
  #       # 投递端数
  #       delivery_part_am = transit_delivery[[last_unit_id, "delivery_part"]].blank? ? 0 : transit_delivery[[last_unit_id, "delivery_part"]]
  #       delivery_part_hj += delivery_part_am
  #       # 未妥投率
  #       waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0
  #       # 退回数 
  #       return_am = status_amount[[last_unit_id, "returns"]].blank? ? 0 : status_amount[[last_unit_id, "returns"]]
  #       return_hj += return_am
  #       # 退回率
  #       return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0
  #       # 本人收数
  #       deliver_own_am =delivered_status_amount[[last_unit_id, "own"]].blank? ? 0 :    delivered_status_amount[[last_unit_id, "own"]]
  #       deliver_own_hj += deliver_own_am
  #       # 他人收数
  #       deliver_other_am =delivered_status_amount[[last_unit_id, "other"]].blank? ? 0 : delivered_status_amount[[last_unit_id, "other"]]
  #       deliver_other_hj += deliver_other_am
  #       # 单位/快递柜收数
  #       deliver_unit_am =delivered_status_amount[[last_unit_id, "unit"]].blank? ? 0 : delivered_status_amount[[last_unit_id, "unit"]]
  #       deliver_unit_hj += deliver_unit_am
  #       # 未及时妥投数
  #       delay_am = delay_amount[last_unit_id].blank? ? 0 : delay_amount[last_unit_id]
  #       delay_hj += delay_am

  #       # 0上级单位id, 1总邮件数, 2总妥投数, 3本人收数, 4他人收数, 5单位/快递柜收数, 6妥投率, 7未妥投总数, 8未妥投率, 9退回数, 10退回率, 11在途中数, 12投递端数, 13单位名称, 14上级单位名称, 15各日妥投率, 16未及时妥投数
  #       results[last_unit_id] = [k[2], total_am, deliver_am, deliver_own_am, deliver_other_am, deliver_unit_am, deliver_per, waiting_am, waiting_per, return_am, return_per, in_transit_am, delivery_part_am, k[1], k[3], delivered_days_xj, delay_am]
  #     end

  #     results = results.sort{|x,y|  (x[0].nil? || x[1][0].nil?) ? 1 : ((y[0].nil? || y[1][0].nil?)? -1 : x[1][0]<=>y[1][0]) }.to_h

  #     deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
  #     waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
  #     return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
  #     process_delivered_days_hj(delivered_days_hj, total_hj)

  #     # 0"", 1总邮件数, 2总妥投数, 3本人收数, 4他人收数, 5单位/快递柜收数, 6妥投率, 7未妥投总数, 8未妥投率, 9退回数, 10退回率, 11在途中数, 12投递端数, 13单位名称, 14上级单位名称, 15各日妥投率, 16未及时妥投数
  #     results["合计"] = ["", total_hj, deliver_hj, deliver_own_hj, deliver_other_hj, deliver_unit_hj, deliver_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj, in_transit_hj, delivery_part_hj, "", "", delivered_days_hj, delay_hj]
  #   end

  #   return results
  # end

  def self.get_deliver_unit_result(expresses, params)
    results = {}
    total_hj = 0
    deliver_hj = 0
    waiting_hj = 0
    return_hj = 0
    in_transit_hj = 0
    delivery_part_hj = 0
    deliver_own_hj = 0
    deliver_other_hj = 0
    deliver_unit_hj = 0
    delivered_days_hj = init_delivered_days_hj(params[:delivered_days_show]) #某日的妥投总数
    delay_hj = 0
    parent_unit_hj = []
    parent_unit_results = {}
  
    if expresses.count>0
      # 总邮件数
      total_amount = expresses.left_outer_joins(:last_unit).left_outer_joins(:last_unit=>:parent_unit).group(:last_unit_id).group("units.name").group("units.parent_id").group("parent_units_units.name").order("units.parent_id, expresses.last_unit_id").count
      # 总妥投数,未妥投总数,退回数
      status_amount = expresses.group(:last_unit_id).group(:status).count
      # **日妥投率
      deliver_days_amount = expresses.delivered.where("expresses.delivered_days <= ?", params[:delivered_days_show].to_f-1).group(:last_unit_id).group("expresses.delivered_days").count
      # 在途中数,投递端数
      transit_delivery = expresses.waiting.group("expresses.last_unit_id", "expresses.whereis").count
      # 本人收数,他人收数,单位/快递柜收数
      delivered_status_amount = expresses.delivered.group(:last_unit_id, :delivered_status).count
      # *日未妥投数
      delay_amount = expresses.where("expresses.delivered_days > ? or expresses.status = ?", params[:delivered_days_show].to_f, "waiting").group(:last_unit_id).count
      last_parent_id = total_amount.keys[0][2]
    
      total_amount.each do |k, v|
        last_unit_id = k[0]
        
        # 总邮件数
        total_am = v
        total_hj += total_am    
        # 总妥投数
        deliver_am =status_amount[[last_unit_id, "delivered"]].blank? ? 0 : status_amount[[last_unit_id, "delivered"]]
        deliver_hj += deliver_am
        # 妥投率
        deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
        # 各日妥投率
        delivered_days_xj = get_deliverd_days_per_hj(delivered_days_hj, params[:delivered_days_show], deliver_days_amount, last_unit_id, total_am)
        # 未妥投总数
        waiting_am = status_amount[[last_unit_id, "waiting"]].blank? ? 0 : status_amount[[last_unit_id, "waiting"]]
        waiting_hj += waiting_am
        # 在途中数
        in_transit_am = transit_delivery[[last_unit_id, "in_transit"]].blank? ? 0 : transit_delivery[[last_unit_id, "in_transit"]]
        in_transit_hj += in_transit_am
        # 投递端数
        delivery_part_am = transit_delivery[[last_unit_id, "delivery_part"]].blank? ? 0 : transit_delivery[[last_unit_id, "delivery_part"]]
        delivery_part_hj += delivery_part_am
        # 未妥投率
        waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0
        # 退回数 
        return_am = status_amount[[last_unit_id, "returns"]].blank? ? 0 : status_amount[[last_unit_id, "returns"]]
        return_hj += return_am
        # 退回率
        return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0
        # 本人收数
        deliver_own_am =delivered_status_amount[[last_unit_id, "own"]].blank? ? 0 :    delivered_status_amount[[last_unit_id, "own"]]
        deliver_own_hj += deliver_own_am
        # 他人收数
        deliver_other_am =delivered_status_amount[[last_unit_id, "other"]].blank? ? 0 : delivered_status_amount[[last_unit_id, "other"]]
        deliver_other_hj += deliver_other_am
        # 单位/快递柜收数
        deliver_unit_am =delivered_status_amount[[last_unit_id, "unit"]].blank? ? 0 : delivered_status_amount[[last_unit_id, "unit"]]
        deliver_unit_hj += deliver_unit_am
        # 未及时妥投数
        delay_am = delay_amount[last_unit_id].blank? ? 0 : delay_amount[last_unit_id]
        delay_hj += delay_am

        # 0上级单位id, 1总邮件数, 2总妥投数, 3本人收数, 4他人收数, 5单位/快递柜收数, 6妥投率, 7未妥投总数, 8未妥投率, 9退回数, 10退回率, 11在途中数, 12投递端数, 13单位名称, 14上级单位名称, 15各日妥投率, 16未及时妥投数
        results[last_unit_id] = [k[2], total_am, deliver_am, deliver_own_am, deliver_other_am, deliver_unit_am, deliver_per, waiting_am, waiting_per, return_am, return_per, in_transit_am, delivery_part_am, k[1], k[3], delivered_days_xj, delay_am]
        # 计算单位小计
        if k[2] != last_parent_id          
          parent_unit_hj = []
        end
        parent_unit_hj = cal_parent_unit_hj(parent_unit_hj, results[last_unit_id])
        parent_unit_results[k[2]] = parent_unit_hj if !parent_unit_hj.blank?

        # byebug
        last_parent_id = k[2]
      end

      results = results.sort{|x,y|  (x[0].nil? || x[1][0].nil?) ? 1 : ((y[0].nil? || y[1][0].nil?)? -1 : x[1][0]<=>y[1][0]) }.to_h

      deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
      waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
      return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
      process_delivered_days_hj(delivered_days_hj, total_hj)

      # 0"", 1总邮件数, 2总妥投数, 3本人收数, 4他人收数, 5单位/快递柜收数, 6妥投率, 7未妥投总数, 8未妥投率, 9退回数, 10退回率, 11在途中数, 12投递端数, 13单位名称, 14上级单位名称, 15各日妥投率, 16未及时妥投数
      results["合计"] = ["", total_hj, deliver_hj, deliver_own_hj, deliver_other_hj, deliver_unit_hj, deliver_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj, in_transit_hj, delivery_part_hj, "", "", delivered_days_hj, delay_hj]
    end

    return [results, parent_unit_results]
  end

  def self.get_business_result(expresses, params)
    results = {}
    total_hj = 0
    deliver_hj = 0
    waiting_hj = 0
    return_hj = 0
    in_transit_hj = 0
    delivery_part_hj = 0
    deliver_own_hj = 0
    deliver_other_hj = 0
    deliver_unit_hj = 0
    delivered_days_hj = {}    #某日的妥投总数
    delivered_days_hj = init_delivered_days_hj(params[:delivered_days_show])   #某日的妥投总数
    
    businesses = Business.where(btype: params[:detail_btype])   
    # total_amount = expresses.group(:business).count
    status_amount = expresses.group(:business_id, :status).count
    deliver_days_amount = expresses.delivered.where("expresses.delivered_days <= ?", params[:delivered_days_show].to_f-1).group(:business_id).group("expresses.delivered_days").count
    transit_delivery = expresses.waiting.group("expresses.business_id", "expresses.whereis").count
    delivered_status_amount = expresses.delivered.group(:business_id, :delivered_status).count

    businesses.each do |x|
      total_am = get_total_amount(x.id, status_amount)
      total_hj += total_am
      deliver_am =status_amount[[x.try(:id), "delivered"]].blank? ? 0 : status_amount[[x.try(:id), "delivered"]]
      deliver_hj += deliver_am
      deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
      delivered_days_xj = get_deliverd_days_per_hj(delivered_days_hj, params[:delivered_days_show], deliver_days_amount, x.try(:id), total_am)

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
      deliver_own_am =delivered_status_amount[[x.try(:id), "own"]].blank? ? 0 :    delivered_status_amount[[x.try(:id), "own"]]
      deliver_own_hj += deliver_own_am
      deliver_other_am =delivered_status_amount[[x.try(:id), "other"]].blank? ? 0 : delivered_status_amount[[x.try(:id), "other"]]
      deliver_other_hj += deliver_other_am
      deliver_unit_am =delivered_status_amount[[x.try(:id), "unit"]].blank? ? 0 : delivered_status_amount[[x.try(:id), "unit"]]
      deliver_unit_hj += deliver_unit_am

      # 0收寄数, 1总妥投数, 2本人收数, 3他人收数, 4单位/快递柜收数, 5妥投率, 6未妥投总数, 7未妥投率, 8退回数, 9退回率, 10在途中数, 11投递端数, 12各日妥投率
      results[x] = [total_am, deliver_am, deliver_own_am, deliver_other_am, deliver_unit_am, deliver_per, waiting_am, waiting_per, return_am, return_per, in_transit_am, delivery_part_am, delivered_days_xj]
    end
      
    deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
    waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
    return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
    process_delivered_days_hj(delivered_days_hj, total_hj)
    
    # 0收寄数, 1总妥投数, 2本人收数, 3他人收数, 4单位/快递柜收数, 5妥投率, 6未妥投总数, 7未妥投率, 8退回数, 9退回率, 10在途中数, 11投递端数, 12各日妥投率   
    results["合计"] = [total_hj, deliver_hj, deliver_own_hj, deliver_other_hj, deliver_unit_hj, deliver_per_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj, in_transit_hj, delivery_part_hj, delivered_days_hj]
 
    return results
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

    total_amount = expresses.where(receipt_flag:"forward").group(:business).count
    exp = expresses.where(receipt_flag:["forward"]).group(:business_id, :status, :receipt_status).count
    
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
        if (k[0] == x.id)
          f_total_am += v
        end

        if (k[0] == x.id) && (k[1].eql?"delivered")
          fd_am += v
        end

        if (k[0] == x.id) && (k[1].eql?"waiting")
          fw_am += v
        end
    
        if (k[0] == x.id) && (k[1].eql?"returns")
          fr_am += v
        end
        
        if (k[0] == x.id) && (!k[1].eql?"delivered") && (!k[2].nil?)
          fndrr_am += v
        end

        if (k[0] == x.id) && (k[1].eql?"delivered") && (!k[2].nil?)
          fdrr_am += v
        end

        if (k[0] == x.id) && (k[2].eql?"receipt_delivered")
          rd_am += v
        end

        if (k[0] == x.id) && (k[2].eql?"receipt_receive")
          rw_am += v
        end
      end

      fdrn_am = exp[[x.id, "delivered", nil]].blank? ? 0 : exp[[x.id, "delivered", nil]]
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

  def self.get_province_city_result(expresses, params)
    results = {}
    total_hj = 0         #收寄数
    deliver_hj = 0       #总妥投数
    waiting_hj = 0       #未妥投总数
    return_hj = 0        #退回数
    deliver_own_hj = 0   #妥投本人收总数
    deliver_other_hj = 0 #妥投他人收总数
    deliver_unit_hj = 0  #妥投单位/快递柜收总数
    delivered_days_hj = init_delivered_days_hj(params[:delivered_days_show])   #某日的妥投总数


    # 省
    if params[:receiver_province_no].blank?   
      expresses = expresses.left_outer_joins(:receiver_province)
      total_amount = expresses.group(:receiver_province_no, "areas.name").count
      status_amount = expresses.group(:receiver_province_no).group(:status).count
      deliver_days_amount = expresses.delivered.where("expresses.delivered_days <= ?", params[:delivered_days_show].to_f-1).group(:receiver_province_no).group("expresses.delivered_days").count
      deliver_avg = expresses.delivered.group(:receiver_province_no).average(:delivered_days)
      delivered_status_amount = expresses.delivered.group(:receiver_province_no, :delivered_status).count
    else
      # 市
      expresses = expresses.left_outer_joins(:receiver_city)
      total_amount = expresses.group(:receiver_city_no, "areas.name").count
      status_amount = expresses.group(:receiver_city_no).group(:status).count
      deliver_days_amount = expresses.delivered.where("expresses.delivered_days <= ?", params[:delivered_days_show].to_f-1).group(:receiver_city_no).group("expresses.delivered_days").count
      deliver_avg = expresses.delivered.group(:receiver_city_no).average(:delivered_days)
      delivered_status_amount = expresses.delivered.group(:receiver_city_no, :delivered_status).count
    end

    total_amount.each do |k, v|
      total_am = v
      total_hj += total_am
      deliver_am =status_amount[[k[0], "delivered"]].blank? ? 0 : status_amount[[k[0], "delivered"]]
      deliver_hj += deliver_am
      deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
      deliver_days_avg = deliver_avg[k[0]].blank? ? 0 : deliver_avg[k[0]]
      delivered_days_xj = get_deliverd_days_per_hj(delivered_days_hj, params[:delivered_days_show], deliver_days_amount, k[0], total_am)
      deliver_days_am = get_deliver_days_amount(k[0], deliver_days_amount)
      
      waiting_am = status_amount[[k[0], "waiting"]].blank? ? 0 : status_amount[[k[0], "waiting"]]
      waiting_hj += waiting_am
      waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0 
      return_am = status_amount[[k[0], "returns"]].blank? ? 0 : status_amount[[k[0], "returns"]]
      return_hj += return_am
      return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0
      deliver_own_am =delivered_status_amount[[k[0], "own"]].blank? ? 0 :    delivered_status_amount[[k[0], "own"]]
      deliver_own_hj += deliver_own_am
      deliver_other_am =delivered_status_amount[[k[0], "other"]].blank? ? 0 : delivered_status_amount[[k[0], "other"]]
      deliver_other_hj += deliver_other_am
      deliver_unit_am =delivered_status_amount[[k[0], "unit"]].blank? ? 0 : delivered_status_amount[[k[0], "unit"]]
      deliver_unit_hj += deliver_unit_am

      # 0收寄数, 1总妥投数, 2本人收数, 3他人收数, 4单位/快递柜收数, 5妥投率, 6平均妥投天数, 7次日妥投率, 8次日妥投总数, 9三日妥投率, 10三日妥投总数, 11五日妥投率, 12五日妥投总数, 13未妥投总数, 14未妥投率, 15退回数, 16退回率, 17当日妥投率, 18当日妥投总数, 19三日上午妥投率, 20三日上午妥投总数, 21四日上午妥投率, 22四日上午妥投总数, 23五日上午妥投率, 24五日上午妥投总数, 25次日上午妥投率, 26次日上午妥投总数

      # 0收寄数, 1总妥投数, 2本人收数, 3他人收数, 4单位/快递柜收数, 5妥投率, 6平均妥投天数, 7未妥投总数, 8未妥投率, 9退回数, 10退回率, 11各日妥投数率
      results[k] = [total_am, deliver_am, deliver_own_am, deliver_other_am, deliver_unit_am, deliver_per, deliver_days_avg, waiting_am, waiting_per, return_am, return_per, delivered_days_xj
      ]
    end

    results = results.sort{|x,y|  x[0][0].nil? ? 1 : (y[0][0].nil? ? -1 : x[0][0]<=>y[0][0]) }.to_h

    deliver_per_hj = total_hj>0 ? (deliver_hj/total_hj.to_f*100).round(2) : 0
    waiting_per_hj = total_hj>0 ? (waiting_hj/total_hj.to_f*100).round(2) : 0 
    return_per_hj = total_hj>0 ? (return_hj/total_hj.to_f*100).round(2) : 0
    deliver_days_avg_hj = expresses.delivered.average(:delivered_days).blank? ? 0 : expresses.delivered.average(:delivered_days)
    process_delivered_days_hj(delivered_days_hj, total_hj)
      
    if total_hj>0
      # 0收寄数, 1总妥投数, 2本人收数, 3他人收数, 4单位/快递柜收数, 5妥投率, 6平均妥投天数, 7未妥投总数, 8未妥投率, 9退回数, 10退回率, 11各日妥投数率
      results[["合计","合计"]] = [total_hj, deliver_hj, deliver_own_hj, deliver_other_hj, deliver_unit_hj, deliver_per_hj, deliver_days_avg_hj, waiting_hj, waiting_per_hj, return_hj, return_per_hj, delivered_days_hj
      ]
    end
# byebug
    return results
  end

  def self.get_export_product_name(product)
    products = ""
    if !product.blank?
      pro = product.split(",")
      pro.each do |p|
        if p.eql?"other_product"
          products += "#{Express::BASE_PRODUCT_SELECT[p.to_sym]},"
        else
          products += "#{Express::BASE_PRODUCT_SELECT[p]},"
        end
      end
      products = products[0, products.length-1]
    end
    return products
  end

  def self.get_total_amount(key, status_amount)
    total_am = 0
    
    Express::STATUS_NAME.each do |k, v|
      total_am += status_amount[[key, k.to_s]].blank? ? 0 : status_amount[[key, k.to_s]]
    end

    return total_am
  end

  def self.get_deliver_days_amount(key, deliver_days_amount)
    deliver_days_am = {}

    d0 = deliver_days_amount[[key, 0.0]].blank? ? 0 : deliver_days_amount[[key, 0.0]]
    d0h = deliver_days_amount[[key, 0.5]].blank? ? 0 : deliver_days_amount[[key, 0.5]]
    d1 = deliver_days_amount[[key, 1.0]].blank? ? 0 : deliver_days_amount[[key, 1.0]]
    d1h = deliver_days_amount[[key, 1.5]].blank? ? 0 : deliver_days_amount[[key, 1.5]]
    d2 = deliver_days_amount[[key, 2.0]].blank? ? 0 : deliver_days_amount[[key, 2.0]]
    d2h = deliver_days_amount[[key, 2.5]].blank? ? 0 : deliver_days_amount[[key, 2.5]]
    d3 = deliver_days_amount[[key, 3.0]].blank? ? 0 : deliver_days_amount[[key, 3.0]]
    d3h = deliver_days_amount[[key, 3.5]].blank? ? 0 : deliver_days_amount[[key, 3.5]]
    d4 = deliver_days_amount[[key, 4.0]].blank? ? 0 : deliver_days_amount[[key, 4.0]]  
    
    deliver0_am = d0                       #当日
    deliver0h_am = deliver0_am + d0h       #次日上午
    deliver1_am = deliver0h_am + d1        #次日
    deliver1h_am = deliver1_am + d1h       #三日上午
    deliver2_am = deliver1h_am + d2        #三日
    deliver2h_am = deliver2_am + d2h       #四日上午
    deliver3h_am = deliver2h_am +d3 +d3h   #五日上午
    deliver4_am = deliver3h_am + d4        #五日

    deliver_days_am = {"deliver0_am"=>deliver0_am, "deliver1_am"=>deliver1_am, "deliver1h_am"=>deliver1h_am, "deliver2_am"=>deliver2_am, "deliver2h_am"=>deliver2h_am, "deliver3h_am"=>deliver3h_am, "deliver4_am"=>deliver4_am, "deliver0h_am"=>deliver0h_am}
  end

  def self.get_distributive_center_name(distributive_center_no)
    distributive_center_name = ""

    if !distributive_center_no.blank?
      distributive_center_name = Express::DISTRIBUTIVE_CENTER_NAME[distributive_center_no.to_sym]
    end

    return distributive_center_name
  end

  def self.get_transfer_type_name(transfer_type)
    transfer_type_name = ""

    if !transfer_type.blank? && (transfer_type.eql? (Express::TRANSFER_TYPE_NOS["all_land".to_sym]))
      transfer_type_name = Express::TRANSFER_TYPE_NAME["#{Express::TRANSFER_TYPE_NOS.invert[transfer_type]}".to_sym]
    else
      transfer_type_name = Express::TRANSFER_TYPE_NAME["other_type".to_sym]
    end
    
    return transfer_type_name
  end

  def self.get_deliverd_days_per_hj(delivered_days_hj, delivered_days_show, deliver_days_amount, key, total_am)
    delivered_days_am = 0       #某客户某日的妥投数
    delivered_days_hash = {}     #某客户某日的妥投数,妥投率 
    days = 0.0
    
    while days <= delivered_days_show.to_f-1
      delivered_days_am += deliver_days_amount[[key, days]].blank? ? 0 : deliver_days_amount[[key, days]]
      deliver_per = total_am>0 ? (delivered_days_am/total_am.to_f*100).round(2) : 0
      delivered_days_hash[days] = [delivered_days_am, deliver_per]
      delivered_days_hj[days] += delivered_days_am.blank? ? 0 : delivered_days_am

      days += 0.5
    end

    return delivered_days_hash
  end

  def self.init_delivered_days_hj(delivered_days_show)
    delivered_days_hj = {}    #某日的妥投总数
    d = 0.0

    while d <= delivered_days_show.to_f-1
      delivered_days_hj[d] = 0
      d += 0.5
    end

    return delivered_days_hj
  end

  def self.process_delivered_days_hj(delivered_days_hj, total_hj)
    delivered_days_hj.each do |k,v|
      delivered_days_hj[k] = [v, total_hj>0 ? (v/total_hj.to_f*100).round(2) : 0]
    end
  end

  def self.cal_parent_unit_hj(parent_unit_hj, results)
    # results=[0上级单位id, 1总邮件数, 2总妥投数, 3本人收数, 4他人收数, 5单位/快递柜收数, 6妥投率, 7未妥投总数, 8未妥投率, 9退回数, 10退回率, 11在途中数, 12投递端数, 13单位名称, 14上级单位名称, 15各日妥投率, 16未及时妥投数]

    # 总邮件数
    total_am = (parent_unit_hj[1].blank? ? 0 : parent_unit_hj[1])+results[1]
    # 总妥投数
    deliver_am = (parent_unit_hj[2].blank? ? 0 : parent_unit_hj[2])+results[2]
    # 本人收数
    deliver_own_am = (parent_unit_hj[3].blank? ? 0 : parent_unit_hj[3])+results[3]
    # 他人收数
    deliver_other_am = (parent_unit_hj[4].blank? ? 0 : parent_unit_hj[4])+results[4]
    # 单位/快递柜收数
    deliver_unit_am = (parent_unit_hj[5].blank? ? 0 : parent_unit_hj[5])+results[5]
    # 妥投率
    deliver_per = total_am>0 ? (deliver_am/total_am.to_f*100).round(2) : 0
    # 未妥投总数
    waiting_am = (parent_unit_hj[7].blank? ? 0 : parent_unit_hj[7])+results[7]
    # 未妥投率
    waiting_per = total_am>0 ? (waiting_am/total_am.to_f*100).round(2) : 0
    # 退回数 
    return_am = (parent_unit_hj[9].blank? ? 0 : parent_unit_hj[9])+results[9]
    # 退回率
    return_per = total_am>0 ? (return_am/total_am.to_f*100).round(2) : 0
    # 在途中数
    in_transit_am = (parent_unit_hj[11].blank? ? 0 : parent_unit_hj[11])+results[11]
    # 投递端数
    delivery_part_am = (parent_unit_hj[12].blank? ? 0 : parent_unit_hj[12])+results[12]
    # 未及时妥投数
    delay_am = (parent_unit_hj[13].blank? ? 0 : parent_unit_hj[13])+results[16]
    # 各日妥投数
    delivered_days_am = {}
    # parent_unit_hj[14].each do |k,v|
    #   delivered_days_am[k] = v+results[15][k][0]
    # end
    results[15].each do |k,v|
      delivered_days_am[k] = v[0] + (parent_unit_hj[14].blank? ? 0 : parent_unit_hj[14][k])
    end
    
    parent_unit_hj = ["小计", total_am, deliver_am, deliver_own_am, deliver_other_am, deliver_unit_am, deliver_per, waiting_am, waiting_per, return_am, return_per, in_transit_am, delivery_part_am, delay_am, delivered_days_am]
    
  end

  def self.get_filter_international_expresses(params)
    where_sql = ""
    is_and = false
 # byebug   
    # 寄达国
    if !params[:country_id].blank?
      country = Country.find(params[:country_id].to_i)
      if is_and
        where_sql += " and "
      end
      where_sql += "international_expresses.country_id = #{params[:country_id].to_i}"
      is_and = true
    end

    # 收寄日期开始
    if !params[:posting_date_start].blank?
      if is_and
        where_sql += " and "
      end
      where_sql += "posting_date >= '#{params[:posting_date_start]}'"
      is_and = true
    end

    # 收寄日期结束
    if !params[:posting_date_end].blank?
      if is_and
        where_sql += " and "
      end
      where_sql += "posting_date <= '#{params[:posting_date_end].to_date+1.day}'"
      is_and = true
    end

    # 客户
    if !params[:business_id].blank?
      if is_and
        where_sql += " and "
      end
      where_sql += "international_expresses.business_id = #{params[:business_id]}"
      is_and = true
    end

    # 寄达国
    # if !params[:country_id].blank?
    #   country = Country.find(params[:country_id].to_i)
    #   if is_and
    #     where_sql += " and "
    #   end
    #   where_sql += "international_expresses.country_id = #{params[:country_id]}"
    #   is_and = true
    # end

    # 地区
    if !params[:receiver_zone_id].blank?
      if is_and
        where_sql += " and "
      end
      # 查询库表中receiver_zone_id=nil的记录
      if params[:receiver_zone_id].eql?"0"
        where_sql += "international_expresses.receiver_zone_id is null"
      else
        where_sql += "international_expresses.receiver_zone_id = #{params[:receiver_zone_id]}"
      end
      is_and = true
    end

    # 状态
    if !params[:status].blank?
      if is_and
        where_sql += " and "
      end
      where_sql += "international_expresses.status = '#{params[:status]}'"
      is_and = true
    end

    # 是否收寄局已封车
    if !params[:is_leaved_orig].blank?
      if is_and
        where_sql += " and "
      end
      where_sql += "international_expresses.is_leaved_orig = #{params[:is_leaved_orig]}"
      is_and = true
    end

    # 是否互换局已封车
    if !params[:is_leaved_center].blank?
      if is_and
        where_sql += " and "
      end
      where_sql += "international_expresses.is_leaved_center = #{params[:is_leaved_center]}"
      is_and = true

      # 是否互换局封车1(T+12)
      if !params[:is_interchange1].blank? && (params[:is_interchange1].eql?"true")
        if is_and
          where_sql += " and "
        end
        where_sql += "international_expresses.leaved_center_hours <= #{country.interchange1} and international_expresses.leaved_orig_after_18 = false"
        is_and = true
      end

      # 是否互换局封车2(T+36+18)
      if !params[:is_interchange2].blank? && (params[:is_interchange2].eql?"true")
        if is_and
          where_sql += " and "
        end
        where_sql += "international_expresses.leaved_center_hours <= #{country.interchange2} and international_expresses.leaved_orig_after_18 = true"
        is_and = true
      end
    end

    # 是否互换局未及时封车
    if !params[:is_leaved_center_delay].blank? && (params[:is_leaved_center_delay].eql?"true")
      if is_and
        where_sql += " and "
      end
      where_sql += "((international_expresses.leaved_center_hours > #{country.interchange1}) and international_expresses.leaved_orig_after_18 = false) or ((international_expresses.leaved_center_hours > #{country.interchange2}) and international_expresses.leaved_orig_after_18 = true) or (international_expresses.is_leaved_orig = true and international_expresses.leaved_center_hours is null)" 
      is_and = true
    end

    # 是否航空启运信息(T+24)
    if !params[:is_takeoff_less].blank? && (params[:is_takeoff_less].eql?"true")
      if is_and
        where_sql += " and "
      end
      where_sql += "international_expresses.is_takeoff = true and international_expresses.takeoff_hours <= #{country.air}" 
      is_and = true
    end

    # 是否航空启运信息(>T+24)
    if !params[:is_takeoff_more].blank? && (params[:is_takeoff_more].eql?"true")
      if is_and
        where_sql += " and "
      end
      where_sql += "(international_expresses.is_takeoff = true and international_expresses.takeoff_hours > #{country.air}) or (international_expresses.is_leaved_center = true and international_expresses.takeoff_hours is null)" 
      is_and = true
    end

    # 是否总包到达寄达地(T+24)
    if !params[:is_arrived_less].blank? && (params[:is_arrived_less].eql?"true")
      if is_and
        where_sql += " and "
      end
      where_sql += "international_expresses.is_arrived = true and international_expresses.arrived_hours <= #{country.arrive}" 
      is_and = true
    end

    # 是否总包到达寄达地(>T+24)
    if !params[:is_arrived_more].blank? && (params[:is_arrived_more].eql?"true")
      if is_and
        where_sql += " and "
      end
      where_sql += "(international_expresses.is_arrived = true and international_expresses.arrived_hours > #{country.arrive}) or (international_expresses.is_takeoff = true and international_expresses.arrived_hours is null)" 
      is_and = true
    end

    # 是否离开境外处理中心(T+48)
    if !params[:is_leaved_less].blank? && (params[:is_leaved_less].eql?"true")
      if is_and
        where_sql += " and "
      end
      where_sql += "international_expresses.is_leaved = true and international_expresses.leaved_hours <= #{country.leave}" 
      is_and = true
    end

    # 是否离开境外处理中心(>T+48)
    if !params[:is_leaved_more].blank? && (params[:is_leaved_more].eql?"true")
      if is_and
        where_sql += " and "
      end
      where_sql += "(international_expresses.is_leaved = true and international_expresses.leaved_hours > #{country.leave}) or (international_expresses.is_arrived = true and international_expresses.leaved_hours is null)" 
      is_and = true
    end

    if where_sql.blank?
      international_expresses = InternationalExpress.all
    else
      international_expresses = InternationalExpress.where(where_sql)
    end

    return international_expresses
  end

  def self.get_international_result(international_expresses, params)
    results = {}
    i = 1
    country_id = params[:country_id].to_i
    country = Country.find(country_id)
    amount_all_hj = 0
    weight_all_hj = 0
    amount_returns_hj = 0
    amount_leaved_orig_yes_hj = 0
    weight_leaved_orig_yes_hj = 0
    amount_leaved_orig_no_hj = 0
    weight_leaved_orig_no_hj = 0
    amount_leaved_center1_hj = 0
    weight_leaved_center1_hj = 0 
    amount_leaved_center2_hj = 0
    weight_leaved_center2_hj = 0
    amount_leaved_center_delay_hj = 0
    weight_leaved_center_delay_hj = 0
    amount_leaved_center_yes_hj = 0
    weight_leaved_center_yes_hj = 0
    amount_leaved_center_no_hj = 0
    weight_leaved_center_no_hj = 0
    amount_takeoff_less_hj = 0
    weight_takeoff_less_hj = 0
    amount_takeoff_more_hj = 0
    weight_takeoff_more_hj = 0
    amount_arrived_less_hj = 0
    weight_arrived_less_hj = 0
    amount_arrived_more_hj = 0
    weight_arrived_more_hj = 0
    amount_leaved_less_hj = 0
    weight_leaved_less_hj = 0
    amount_leaved_more_hj = 0
    weight_leaved_more_hj = 0

    if !international_expresses.blank?
      # 总业务量
      amounts = international_expresses.group(:business_id, :receiver_zone_id, :status).count
      # 总重量
      weights = international_expresses.group(:business_id, :receiver_zone_id).sum(:weight)
      # 收寄局已封车业务量
      amounts_leaved_orig = international_expresses.where(is_leaved_orig: true).group(:business_id, :receiver_zone_id).count
      # 收寄局已封车重量
      weights_leaved_orig = international_expresses.where(is_leaved_orig: true).group(:business_id, :receiver_zone_id).sum(:weight)
      # 互换局封车1(T+12)业务量
      amounts_leaved_center1 = international_expresses.where("leaved_center_hours <= ?", country.interchange1).where(is_leaved_center: true, leaved_orig_after_18: false).group(:business_id, :receiver_zone_id).count
      # 互换局封车1(T+12)重量
      weights_leaved_center1 = international_expresses.where("leaved_center_hours <= ?", country.interchange1).where(is_leaved_center: true, leaved_orig_after_18: false).group(:business_id, :receiver_zone_id).sum(:weight)
      # 互换局封车2(T+36+18)业务量
      amounts_leaved_center2 = international_expresses.where("leaved_center_hours <= ?", country.interchange2).where(is_leaved_center: true, leaved_orig_after_18: true).group(:business_id, :receiver_zone_id).count
      # 互换局封车2(T+36+18)重量
      weights_leaved_center2 = international_expresses.where("leaved_center_hours <= ?", country.interchange2).where(is_leaved_center: true, leaved_orig_after_18: true).group(:business_id, :receiver_zone_id).sum(:weight)
      # 互换局已未封车业务量
      amounts_leaved_center = international_expresses.group(:business_id, :receiver_zone_id, :is_leaved_center).count
      # 互换局已未封车重量
      weights_leaved_center = international_expresses.group(:business_id, :receiver_zone_id, :is_leaved_center).sum(:weight)
      # 航空启运信息(T+24)业务量
      amounts_takeoff = international_expresses.where("takeoff_hours <= ?", country.air).where(is_takeoff: true).group(:business_id, :receiver_zone_id).count
      # 航空启运信息(T+24)重量
      weights_takeoff = international_expresses.where("takeoff_hours <= ?", country.air).where(is_takeoff: true).group(:business_id, :receiver_zone_id).sum(:weight)
      # 有航空启运信息业务量
      amounts_is_takeoff = international_expresses.where(is_takeoff: true).group(:business_id, :receiver_zone_id).count
      # 有航空启运信息重量
      weights_is_takeoff = international_expresses.where(is_takeoff: true).group(:business_id, :receiver_zone_id).sum(:weight)
      # 总包到达寄达地(T+24)业务量
      amounts_arrived = international_expresses.where("arrived_hours <= ?", country.arrive).where(is_arrived: true).group(:business_id, :receiver_zone_id).count
      # 总包到达寄达地(T+24)重量
      weights_arrived = international_expresses.where("arrived_hours <= ?", country.arrive).where(is_arrived: true).group(:business_id, :receiver_zone_id).sum(:weight)
      # 有总包到达寄达地业务量
      amounts_is_arrived = international_expresses.where(is_arrived: true).group(:business_id, :receiver_zone_id).count
      # 有总包到达寄达地重量
      weights_is_arrived = international_expresses.where(is_arrived: true).group(:business_id, :receiver_zone_id).sum(:weight)
      # 离开境外处理中心(T+48)业务量
      amounts_leaved = international_expresses.where("leaved_hours <= ?", country.leave).where(is_leaved: true).group(:business_id, :receiver_zone_id).count
      # 离开境外处理中心(T+48)重量
      weights_leaved = international_expresses.where("leaved_hours <= ?", country.leave).where(is_leaved: true).group(:business_id, :receiver_zone_id).sum(:weight)
      
      business_id = weights.first[0][0]
      receiver_zone_id = weights.first[0][1]
      business_name = Business.find(business_id).name
      receiver_zone_name = ReceiverZone.find(receiver_zone_id).blank? ? "" : ReceiverZone.find(receiver_zone_id).zone

      weights.each do |k, v|   
        # 未妥投量
        amount_waiting = amounts[k+["waiting"]].blank? ? 0 : amounts[k+["waiting"]]
        # 退回妥投量
        amount_returns = amounts[k+["returns"]].blank? ? 0 : amounts[k+["returns"]]
        amount_returns_hj += amount_returns
        # 业务量
        amount_all = amount_waiting + amount_returns
        amount_all_hj += amount_all
        # 重量（克）合计
        weight_all_hj += v
        # 退回妥投占比
        per_returns = amount_all>0 ? (amount_returns/amount_all.to_f*100).round(2) : 0
        # 收寄局已封车业务量
        amount_leaved_orig_yes = amounts_leaved_orig[k].blank? ? 0 : amounts_leaved_orig[k]
        amount_leaved_orig_yes_hj += amount_leaved_orig_yes
        # 收寄局已封车重量
        weight_leaved_orig_yes = weights_leaved_orig[k].blank? ? 0 : weights_leaved_orig[k]
        weight_leaved_orig_yes_hj += weight_leaved_orig_yes
        # 收寄局已封车占比
        per_leaved_orig_yes = amount_all>0 ? (amount_leaved_orig_yes/amount_all.to_f*100).round(2) : 0
        # 收寄局未封车业务量
        amount_leaved_orig_no = amount_all-amount_leaved_orig_yes
        amount_leaved_orig_no_hj += amount_leaved_orig_no
        # 收寄局未封车重量
        weight_leaved_orig_no = v-weight_leaved_orig_yes
        weight_leaved_orig_no_hj += weight_leaved_orig_no
        # 收寄局未封车占比
        per_leaved_orig_no = amount_all>0 ? (amount_leaved_orig_no/amount_all.to_f*100).round(2) : 0
        # 互换局封车1(T+12)业务量
        amount_leaved_center1 = amounts_leaved_center1[k].blank? ? 0 : amounts_leaved_center1[k]
        amount_leaved_center1_hj += amount_leaved_center1
        # 互换局封车1(T+12)重量
        weight_leaved_center1 = weights_leaved_center1[k].blank? ? 0 : weights_leaved_center1[k]
        weight_leaved_center1_hj += weight_leaved_center1
        # 互换局封车1(T+12)占比
        per_leaved_center1 = amount_all>0 ? (amount_leaved_center1/amount_all.to_f*100).round(2) : 0
        # 互换局封车2(T+36+18)业务量
        amount_leaved_center2 = amounts_leaved_center2[k].blank? ? 0 : amounts_leaved_center2[k]
        amount_leaved_center2_hj += amount_leaved_center2
        # 互换局封车2(T+36+18)重量
        weight_leaved_center2 = weights_leaved_center2[k].blank? ? 0 : weights_leaved_center2[k]
        weight_leaved_center2_hj += weight_leaved_center2
        # 互换局封车2(T+36+18)占比
        per_leaved_center2 = amount_all>0 ? (amount_leaved_center2/amount_all.to_f*100).round(2) : 0
        # 互换局未及时封车业务量
        amount_leaved_center_delay = amount_leaved_orig_yes-amount_leaved_center1-amount_leaved_center2
        amount_leaved_center_delay_hj += amount_leaved_center_delay
        # 互换局未及时封车重量
        weight_leaved_center_delay = weight_leaved_orig_yes-weight_leaved_center1-weight_leaved_center2
        weight_leaved_center_delay_hj += weight_leaved_center_delay
        # 互换局未及时封车占比
        per_leaved_center_delay = amount_all>0 ? (amount_leaved_center_delay/amount_all.to_f*100).round(2) : 0
        # 互换局已封车业务量
        amount_leaved_center_yes = amounts_leaved_center[k+[true]].blank? ? 0 : amounts_leaved_center[k+[true]]
        amount_leaved_center_yes_hj += amount_leaved_center_yes
        # 互换局已封车重量
        weight_leaved_center_yes = weights_leaved_center[k+[true]].blank? ? 0 : weights_leaved_center[k+[true]]
        weight_leaved_center_yes_hj += weight_leaved_center_yes
        # 互换局已封车占比
        per_leaved_center_yes = amount_all>0 ? (amount_leaved_center_yes/amount_all.to_f*100).round(2) : 0
        # 互换局未封车业务量
        amount_leaved_center_no = amounts_leaved_center[k+[false]].blank? ? 0 : amounts_leaved_center[k+[false]]
        amount_leaved_center_no_hj += amount_leaved_center_no
        # 互换局未封车重量
        weight_leaved_center_no = weights_leaved_center[k+[false]].blank? ? 0 : weights_leaved_center[k+[false]]
        weight_leaved_center_no_hj += weight_leaved_center_no
        # 互换局未封车占比
        per_leaved_center_no = amount_all>0 ? (amount_leaved_center_yes/amount_all.to_f*100).round(2) : 0
        # 航空启运信息(T+24)业务量
        amount_takeoff_less = amounts_takeoff[k].blank? ? 0 : amounts_takeoff[k]
        amount_takeoff_less_hj += amount_takeoff_less
        # 航空启运信息(T+24)重量
        weight_takeoff_less = weights_takeoff[k].blank? ? 0 : weights_takeoff[k]
        weight_takeoff_less_hj += weight_takeoff_less
        # 航空启运信息(T+24)占比
        per_takeoff_less = amount_all>0 ? (amount_takeoff_less/amount_all.to_f*100).round(2) : 0
        # 航空启运信息(>T+24)业务量
        amount_takeoff_more = amount_leaved_center_yes - amount_takeoff_less
        amount_takeoff_more_hj += amount_takeoff_more
        # 航空启运信息(>T+24)重量
        weight_takeoff_more = weight_leaved_center_yes - weight_takeoff_less
        weight_takeoff_more_hj += weight_takeoff_more
        # 航空启运信息(>T+24)占比
        per_takeoff_more = amount_all>0 ? (amount_takeoff_more/amount_all.to_f*100).round(2) : 0
        # 总包到达寄达地(T+24)业务量
        amount_arrived_less = amounts_arrived[k].blank? ? 0 : amounts_arrived[k]
        amount_arrived_less_hj += amount_arrived_less
        # 总包到达寄达地(T+24)重量
        weight_arrived_less = weights_arrived[k].blank? ? 0 : weights_arrived[k]
        weight_arrived_less_hj += weight_arrived_less
        # 总包到达寄达地(T+24)占比
        per_arrived_less = amount_all>0 ? (amount_arrived_less/amount_all.to_f*100).round(2) : 0
        # 总包到达寄达地(>T+24)业务量
        amount_arrived_more = (amounts_is_takeoff[k].blank? ? 0 : amounts_is_takeoff[k]) - amount_arrived_less
        amount_arrived_more_hj += amount_arrived_more
        # 总包到达寄达地(>T+24)重量
        weight_arrived_more = (weights_is_takeoff[k].blank? ? 0 : weights_is_takeoff[k]) - weight_arrived_less
        weight_arrived_more_hj += weight_arrived_more
        # 总包到达寄达地(>T+24)占比
        per_arrived_more = amount_all>0 ? (amount_arrived_more/amount_all.to_f*100).round(2) : 0
        # 离开境外处理中心(T+48)业务量
        amount_leaved_less = amounts_leaved[k].blank? ? 0 : amounts_leaved[k]
        amount_leaved_less_hj += amount_leaved_less
        # 离开境外处理中心(T+48)重量
        weight_leaved_less = weights_leaved[k].blank? ? 0 : weights_leaved[k]
        weight_leaved_less_hj += weight_leaved_less
        # 离开境外处理中心(T+48)占比
        per_leaved_less = amount_all>0 ? (amount_leaved_less/amount_all.to_f*100).round(2) : 0
        # 离开境外处理中心(>T+48)业务量
        amount_leaved_more = (amounts_is_arrived[k].blank? ? 0 : amounts_is_arrived[k]) - amount_leaved_less
        amount_leaved_more_hj += amount_leaved_more
        # 离开境外处理中心(>T+48)重量
        weight_leaved_more = (weights_is_arrived[k].blank? ? 0 : weights_is_arrived[k]) - weight_leaved_less
        weight_leaved_more_hj += weight_leaved_more
        # 离开境外处理中心(>T+48)占比
        per_leaved_more = amount_all>0 ? (amount_leaved_more/amount_all.to_f*100).round(2) : 0

        if k[0]!=business_id
          business_name = Business.find(k[0]).name
          business_id = k[0]
        end
        if k[1]!=receiver_zone_id
          receiver_zone_name = ReceiverZone.find(k[1]).blank? ? "" : ReceiverZone.find(k[1]).zone
          receiver_zone_id = k[1]
        end
        # results[客户id,地区id] = [0序号, 1客户名称, 2寄达国id, 3寄达国name, 4地区, 5业务量, 6重量（克）, 7退回妥投量, 8退回妥投占比, 9收寄局已封车业务量, 10收寄局已封车重量, 11收寄局已封车占比, 12收寄局未封车业务量, 13收寄局未封车重量, 14收寄局未封车占比, 15互换局封车1(T+12)业务量, 16互换局封车1(T+12)重量, 17互换局封车1(T+12)占比, 18互换局封车2(T+36+18)业务量, 19互换局封车2(T+36+18)重量, 20互换局封车2(T+36+18)占比, 21互换局未及时封车业务量, 22互换局未及时封车重量, 23互换局未及时封车占比, 24互换局已封车业务量, 25互换局已封车重量, 26互换局已封车占比, 27互换局未封车业务量, 28互换局未封车重量, 29互换局未封车占比, 30航空启运信息(T+24)业务量, 31航空启运信息(T+24)重量, 32航空启运信息(T+24)占比, 33航空启运信息(>T+24)业务量, 34航空启运信息(>T+24)重量, 35航空启运信息(>T+24)占比, 36总包到达寄达地(T+24)业务量, 37总包到达寄达地(T+24)重量, 38总包到达寄达地(T+24)占比, 39总包到达寄达地(>T+24)业务量, 40总包到达寄达地(>T+24)重量, 41总包到达寄达地(>T+24)占比, 42离开境外处理中心(T+48)业务量, 43离开境外处理中心(T+48)重量, 44离开境外处理中心(T+48)占比, 45离开境外处理中心(>T+48)业务量, 46离开境外处理中心(>T+48)重量, 47离开境外处理中心(>T+48)占比]
        results[k] = [i, business_name, country_id, country.name, receiver_zone_name, amount_all, v, amount_returns, per_returns, amount_leaved_orig_yes, weight_leaved_orig_yes, per_leaved_orig_yes, amount_leaved_orig_no, weight_leaved_orig_no, per_leaved_orig_no, amount_leaved_center1, weight_leaved_center1, per_leaved_center1, amount_leaved_center2, weight_leaved_center2, per_leaved_center2, amount_leaved_center_delay, weight_leaved_center_delay, per_leaved_center_delay, amount_leaved_center_yes, weight_leaved_center_yes, per_leaved_center_yes, amount_leaved_center_no, weight_leaved_center_no, per_leaved_center_no, amount_takeoff_less, weight_takeoff_less, per_takeoff_less, amount_takeoff_more, weight_takeoff_more, per_takeoff_more, amount_arrived_less, weight_arrived_less, per_arrived_less, amount_arrived_more, weight_arrived_more, per_arrived_more, amount_leaved_less, weight_leaved_less, per_leaved_less, amount_leaved_more, weight_leaved_more, per_leaved_more]
        i += 1
      end

      results[["all", "all"]] = ["合计", "", nil, "", "", amount_all_hj, weight_all_hj, amount_returns_hj, get_per(amount_returns_hj, amount_all_hj), amount_leaved_orig_yes_hj, weight_leaved_orig_yes_hj, get_per(amount_leaved_orig_yes_hj, amount_all_hj), amount_leaved_orig_no_hj, weight_leaved_orig_no_hj, get_per(amount_leaved_orig_no_hj, amount_all_hj), amount_leaved_center1_hj, weight_leaved_center1_hj, get_per(amount_leaved_center1_hj, amount_all_hj), amount_leaved_center2_hj, weight_leaved_center2_hj, get_per(amount_leaved_center2_hj, amount_all_hj), amount_leaved_center_delay_hj, weight_leaved_center_delay_hj, get_per(amount_leaved_center_delay_hj, amount_all_hj), amount_leaved_center_yes_hj, weight_leaved_center_yes_hj, get_per(amount_leaved_center_yes_hj, amount_all_hj), amount_leaved_center_no_hj, weight_leaved_center_no_hj, get_per(amount_leaved_center_no_hj, amount_all_hj), amount_takeoff_less_hj, weight_takeoff_less_hj, get_per(amount_takeoff_less_hj, amount_all_hj), amount_takeoff_more_hj, weight_takeoff_more_hj, get_per(amount_takeoff_more_hj, amount_all_hj), amount_arrived_less_hj, weight_arrived_less_hj, get_per(amount_arrived_less_hj, amount_all_hj), amount_arrived_more_hj, weight_arrived_more_hj, get_per(amount_arrived_more_hj, amount_all_hj), amount_leaved_less_hj, weight_leaved_less_hj, get_per(amount_leaved_less_hj, amount_all_hj), amount_leaved_more_hj, weight_leaved_more_hj, get_per(amount_leaved_more_hj, amount_all_hj)]
    end
    return results
  end


  def self.get_per(amount, amount_all)
    amount_all>0 ? (amount/amount_all.to_f*100).round(2) : 0
  end
end
