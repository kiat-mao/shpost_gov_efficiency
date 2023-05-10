module ReportHelper
	# 根路径, 行业市场, 状态, 网点(投递维度),客户名称(返单),是否在途,是否正向(返单),返单状态,妥投天数,收寄省,收寄市,妥投状态,显示预警邮件,是否统计未及时妥投,单位(投递维度)
	def get_expresses_path(addr, detail_btype, status, last_unit_id, detail_business, transit_delivery, receipt_flag, receipt_status, delivered_days, receiver_province_no, receiver_city_no, delivered_status, need_alert, is_delay, parent_unit_id)
	  # addr = "/expresses"
	  sep="?"
	  industry = nil

	  if detail_btype.blank?
	  	if !params[:is_court].blank? && (params[:is_court].eql?"true")
	  		industry = '法院'
	  	else
				if !params[:industry].blank? && !params[:industry][0].blank?
					if params[:industry].is_a?String
						industry = params[:industry]
					else
						industry = params[:industry].compact.join(",")	
					end	
				end
			end

			if !industry.blank?
				addr += sep+"industry=#{industry}"
				sep = "&"		
			end

			if !params[:btype].blank? && !params[:btype][0].blank?
				if params[:btype].is_a?String
					btype = params[:btype]
				else
					btype = params[:btype].compact.join(",")	
				end
				addr += sep+"btype=#{btype}"
				sep = "&"
			end
		end

		if !params[:business].blank?
			addr += sep+"business=#{params[:business]}"
			sep = "&"
		end

		if !params[:posting_date_start].blank?
			addr += sep+"posting_date_start=#{params[:posting_date_start]}"
			sep = "&"
		end

		if !params[:posting_date_end].blank?
			addr += sep+"posting_date_end=#{params[:posting_date_end]}"
			sep = "&"
		end

		if !detail_btype.blank?
			addr += sep+"detail_btype=#{detail_btype}"
			sep = "&"
		end

		if !status.blank?
			addr += sep+"status=#{status}"
			sep = "&"
		end

		if !last_unit_id.blank?
			addr += sep+"last_unit_id=#{last_unit_id}"
			sep = "&"
		end

		if !params[:is_court].blank?
			addr += sep+"is_court=#{params[:is_court]}"
			sep = "&"
		end

		if !detail_business.blank?
			addr += sep+"detail_business=#{detail_business}"
			sep = "&"
		end

		if !params[:destination].blank?
			addr += sep+"destination=#{params[:destination]}"
			sep = "&"
		end

		if !params[:lv2_unit].blank?
			addr += sep+"lv2_unit=#{params[:lv2_unit]}"
			sep = "&"
		end

		if !params[:search_time].blank?
			addr += sep+"search_time=#{params[:search_time]}"
			sep = "&"
		end

		if !params[:year].blank?
			addr += sep+"year=#{params[:year]}"
			sep = "&"
		end

		if !params[:month].blank?
			addr += sep+"month=#{params[:month]}"
			sep = "&"
		end

		if !transit_delivery.blank?
			addr += sep+"transit_delivery=#{transit_delivery}"
			sep = "&"
		end

		if !params[:product].blank? && !params[:product][0].blank?
			if params[:product].is_a?String
				product = params[:product]
			else
				product = params[:product].compact.join(",")	
			end
			addr += sep+"product=#{product}"
			sep = "&"
		end

		if !receipt_flag.blank?
			addr += sep+"receipt_flag=#{receipt_flag}"
			sep = "&"
		end

		if !receipt_status.blank?
			addr += sep+"receipt_status=#{receipt_status}"
			sep = "&"
		end

		if !params[:distributive_center_no].blank?
			addr += sep+"distributive_center_no=#{params[:distributive_center_no]}"
			sep = "&"
		end

		if !params[:posting_hour_start].blank?
			addr += sep+"posting_hour_start=#{params[:posting_hour_start]}"
			sep = "&"
		end

		if !params[:posting_hour_end].blank?
			addr += sep+"posting_hour_end=#{params[:posting_hour_end]}"
			sep = "&"
		end

		if !delivered_days.blank?
			addr += sep+"delivered_days=#{delivered_days}"
			sep = "&"
		end

		if !receiver_province_no.blank?
			addr += sep+"receiver_province_no=#{receiver_province_no}"
			sep = "&"
		end

		if !receiver_city_no.blank?
			addr += sep+"receiver_city_no=#{receiver_city_no}"
			sep = "&"
		end

		if !params[:is_monitor].blank?
			addr += sep+"is_monitor=#{params[:is_monitor]}"
			sep = "&"
		end

		if !delivered_status.blank?
			addr += sep+"delivered_status=#{delivered_status}"
			sep = "&"
		end

		if !params[:delivered_date_start].blank?
			addr += sep+"delivered_date_start=#{params[:delivered_date_start]}"
			sep = "&"
		end

		if !params[:delivered_date_end].blank?
			addr += sep+"delivered_date_end=#{params[:delivered_date_end]}"
			sep = "&"
		end
# byebug
		if !params[:checkbox].blank? && (!params[:checkbox][:bf_free_tax].blank?) && (params[:checkbox][:bf_free_tax].eql?"1")
		  	addr += sep+"bf_free_tax=#{params[:checkbox][:bf_free_tax]}"
			sep = "&"
		end

		if !params[:transfer_type].blank?
			addr += sep+"transfer_type=#{params[:transfer_type]}"
			sep = "&"
		end

		if !need_alert.blank? && need_alert
			addr += sep+"need_alert=#{need_alert}"
			sep = "&"
		end

		if !params[:delivered_days_show].blank?
			addr += sep+"delivered_days_show=#{params[:delivered_days_show]}"
			sep = "&"
		end

		if !is_delay.blank?
			addr += sep+"is_delay=#{is_delay}"
			sep = "&"
		end

		if !parent_unit_id.blank?
			addr += sep+"parent_unit_id=#{parent_unit_id}"
			sep = "&"
		end
		
# byebug
		addr
		# expresses_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], detail_btype: detail_btype, status: status, last_unit_id: last_unit_id, is_court: params[:is_court], detail_business: detail_business, destination: params[:destination], lv2_unit: params[:lv2_unit], search_time: params[:search_time], year: params[:year], month: params[:month], transit_delivery: transit_delivery, product: params[:product], receipt_flag: receipt_flag, receipt_status: receipt_status, distributive_center_no: params[:distributive_center_no], posting_hour_start: params[:posting_hour_start], posting_hour_end: params[:posting_hour_end], delivered_days: delivered_days, receiver_province_no: receiver_province_no, receiver_city_no: receiver_city_no)
	end

	# 根路径, 客户, 寄达国, 地区, 状态, 是否收寄局已封车, 是否互换局封车, 是否互换局封车1(T+12), 是否互换局封车2(T+36+18), 是否互换局未及时封车, 是否航空启运信息(T+24), 是否航空启运信息(>T+24), 是否总包到达寄达地(T+24), 是否总包到达寄达地(>T+24), 是否离开境外处理中心(T+48), 是否离开境外处理中心(>T+48)
	def get_international_expresses_path(addr, business_id, country_id, receiver_zone_id, status, is_leaved_orig, is_leaved_center, is_interchange1, is_interchange2, is_leaved_center_delay, is_takeoff_less, is_takeoff_more, is_arrived_less, is_arrived_more, is_leaved_less, is_leaved_more)
	  # addr = "/international_expresses"
	  sep="?"
	  # 页面选择条件寄达国，非链接
	  if !params[:country_id].blank?
			addr += sep+"country_id=#{params[:country_id].to_i}"
			sep = "&"
		end

		# 页面选择条件客户，非链接
	  if !params[:business_id].blank?
			addr += sep+"business_id=#{params[:business_id].to_i}"
			sep = "&"
		end

		# 页面选择条件收寄日期开始
		if !params[:posting_date_start].blank?
			addr += sep+"posting_date_start=#{params[:posting_date_start].to_date}"
			sep = "&"
		end

		# 页面选择条件收寄日期结束
		if !params[:posting_date_end].blank?
			addr += sep+"posting_date_end=#{params[:posting_date_end].to_date+1.day}"
			sep = "&"
		end


	  if !business_id.blank? && !(business_id.eql?"all")
			addr += sep+"business_id=#{business_id}"
			sep = "&"
		end

		if !country_id.blank?
			country = Country.find(country_id)
			addr += sep+"country_id=#{country_id}"
			sep = "&"
		end

		if receiver_zone_id.blank?
			# 查询库表中receiver_zone_id=nil的记录
			addr += sep+"receiver_zone_id=0"
			sep = "&"
		else
			if !(receiver_zone_id.eql?"all")
				addr += sep+"receiver_zone_id=#{receiver_zone_id}"
				sep = "&"
			end
		end

		if !status.blank?
			addr += sep+"status=#{status}"
			sep = "&"
		end

		if !is_leaved_orig.blank?
			is_leaved_orig = (is_leaved_orig.eql?"true") ? true : false
			addr += sep+"is_leaved_orig=#{is_leaved_orig}"
			sep = "&"
		end

		if !is_leaved_center.blank?
			is_leaved_center = (is_leaved_center.eql?"true") ? true : false
			addr += sep+"is_leaved_center=#{is_leaved_center}"
			sep = "&"
			if !is_interchange1.blank?
				is_interchange1 = (is_interchange1.eql?"true") ? true : false
				addr += sep+"is_interchange1=#{is_interchange1}"
				sep = "&"
			end
			if !is_interchange2.blank?
				is_interchange2 = (is_interchange2.eql?"true") ? true : false
				addr += sep+"is_interchange2=#{is_interchange2}"
				sep = "&"
			end
		end

		if !is_leaved_center_delay.blank?
			is_leaved_center_delay = (is_leaved_center_delay.eql?"true") ? true : false
			addr += sep+"is_leaved_center_delay=#{is_leaved_center_delay}"
			sep = "&"
		end

		if !is_takeoff_less.blank?
			is_takeoff_less = (is_takeoff_less.eql?"true") ? true : false
			addr += sep+"is_takeoff_less=#{is_takeoff_less}"
			sep = "&"
		end

		if !is_takeoff_more.blank?
			is_takeoff_more = (is_takeoff_more.eql?"true") ? true : false
			addr += sep+"is_takeoff_more=#{is_takeoff_more}"
			sep = "&"
		end

		if !is_arrived_less.blank?
			is_arrived_less = (is_arrived_less.eql?"true") ? true : false
			addr += sep+"is_arrived_less=#{is_arrived_less}"
			sep = "&"
		end

		if !is_arrived_more.blank?
			is_arrived_more = (is_arrived_more.eql?"true") ? true : false
			addr += sep+"is_arrived_more=#{is_arrived_more}"
			sep = "&"
		end

		if !is_leaved_less.blank?
			is_leaved_less = (is_leaved_less.eql?"true") ? true : false
			addr += sep+"is_leaved_less=#{is_leaved_less}"
			sep = "&"
		end

		if !is_leaved_more.blank?
			is_leaved_more = (is_leaved_more.eql?"true") ? true : false
			addr += sep+"is_leaved_more=#{is_leaved_more}"
			sep = "&"
		end

		addr
	end
end