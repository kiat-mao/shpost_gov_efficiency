module ReportHelper
	# 行业市场, 状态, 网点(投递维度),客户名称(返单),是否在途,是否正向(返单),返单状态,妥投天数,收寄省,收寄市
	def get_expresses_path(detail_btype, status, last_unit_id, detail_business, transit_delivery, receipt_flag, receipt_status, delivered_days, receiver_province_no, receiver_city_no)
		expresses_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], detail_btype: detail_btype, status: status, last_unit_id: last_unit_id, is_court: params[:is_court], detail_business: detail_business, destination: params[:destination], lv2_unit: params[:lv2_unit], search_time: params[:search_time], year: params[:year], month: params[:month], transit_delivery: transit_delivery, product: params[:product], receipt_flag: receipt_flag, receipt_status: receipt_status, distributive_center_no: params[:distributive_center_no], posting_hour_start: params[:posting_hour_start], posting_hour_end: params[:posting_hour_end], delivered_days: delivered_days, receiver_province_no: receiver_province_no, receiver_city_no: receiver_city_no)
	end

	def get_report_path(is_court, is_market, is_monitor, is_province)
		if !is_province.nil? && is_province
			return deliver_province_report_reports_path
		else
			if !is_court.nil?
				if is_court 
					if is_market
						if is_monitor
							return court_deliver_market_monitor_reports_path
						else
							return court_deliver_market_report_reports_path
						end
					else
						if is_monitor
							return court_deliver_unit_monitor_reports_path
						else
							return court_deliver_unit_report_reports_path
						end
					end
				else
					if is_market
						if is_monitor
							return deliver_market_monitor_reports_path
						else
							return deliver_market_report_reports_path
						end
					else
						if is_monitor
							return deliver_unit_monitor_reports_path
						else
							return deliver_unit_report_reports_path
						end
					end
				end
			else
				if is_market.nil? && !is_monitor
					return receipt_report_reports_path
				end
			end
		end
	end

	def get_export_path(is_market, is_province)
		if !is_province.nil? && is_province
			deliver_prov_city_report_export_reports_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], search_time: params[:search_time], year: params[:year], month: params[:month], destination: params[:destination], product: params[:product], distributive_center_no: params[:distributive_center_no], posting_hour_start: params[:posting_hour_start], posting_hour_end: params[:posting_hour_end])
		else
			if !is_market.nil?
				if is_market
					deliver_market_report_export_reports_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], destination: params[:destination], search_time: params[:search_time], year: params[:year], month: params[:month], is_court: params[:is_court], is_monitor: params[:is_monitor], product: params[:product])
				else
					deliver_unit_report_export_reports_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], destination: params[:destination], search_time: params[:search_time], year: params[:year], month: params[:month], lv2_unit: params[:lv2_unit], is_court: params[:is_court], is_monitor: params[:is_monitor], product: params[:product])
				end
			else
				receipt_report_export_reports_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], destination: params[:destination], search_time: params[:search_time], year: params[:year], month: params[:month], is_court: params[:is_court], is_monitor: params[:is_monitor], product: params[:product])
			end
		end
	end
end