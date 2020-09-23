module ReportHelper
	# 行业市场, 状态, 网点(投递维度),客户名称(返单),是否在途,是否正向(返单),返单状态,妥投天数,收寄省,收寄市
	def get_expresses_path(detail_btype, status, last_unit_id, detail_business, transit_delivery, receipt_flag, receipt_status, delivered_days, receiver_province_no, receiver_city_no)
		expresses_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], detail_btype: detail_btype, status: status, last_unit_id: last_unit_id, is_court: params[:is_court], detail_business: detail_business, destination: params[:destination], lv2_unit: params[:lv2_unit], search_time: params[:search_time], year: params[:year], month: params[:month], transit_delivery: transit_delivery, product: params[:product], receipt_flag: receipt_flag, receipt_status: receipt_status, distributive_center_no: params[:distributive_center_no], posting_hour_start: params[:posting_hour_start], posting_hour_end: params[:posting_hour_end], delivered_days: delivered_days, receiver_province_no: receiver_province_no, receiver_city_no: receiver_city_no)
	end

	
end