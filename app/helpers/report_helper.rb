module ReportHelper
	# 根路径, 行业市场, 状态, 网点(投递维度),客户名称(返单),是否在途,是否正向(返单),返单状态,妥投天数,收寄省,收寄市
	def get_expresses_path(addr, detail_btype, status, last_unit_id, detail_business, transit_delivery, receipt_flag, receipt_status, delivered_days, receiver_province_no, receiver_city_no)
	  # addr = "/expresses"
	  sep="?"

		if !params[:industry].blank?
			addr += sep+"industry=#{params[:industry]}"
			sep = "&"
		end

		if !params[:btype].blank?
			addr += sep+"btype=#{params[:btype]}"
			sep = "&"
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

		if !params[:product].blank?
			addr += sep+"product=#{params[:product]}"
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
# byebug
		addr
		# expresses_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], detail_btype: detail_btype, status: status, last_unit_id: last_unit_id, is_court: params[:is_court], detail_business: detail_business, destination: params[:destination], lv2_unit: params[:lv2_unit], search_time: params[:search_time], year: params[:year], month: params[:month], transit_delivery: transit_delivery, product: params[:product], receipt_flag: receipt_flag, receipt_status: receipt_status, distributive_center_no: params[:distributive_center_no], posting_hour_start: params[:posting_hour_start], posting_hour_end: params[:posting_hour_end], delivered_days: delivered_days, receiver_province_no: receiver_province_no, receiver_city_no: receiver_city_no)
	end

	
end