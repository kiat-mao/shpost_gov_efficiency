module ReportHelper
	# 行业市场, 状态, 
	def get_expresses_path(detail_btype, status, last_unit_id, detail_business, transit_delivery, receipt_flag, receipt_status)
		expresses_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], detail_btype: detail_btype, status: status, last_unit_id: last_unit_id, is_court: params[:is_court], detail_business: detail_business, destination: params[:destination], lv2_unit: params[:lv2_unit], search_time: params[:search_time], year: params[:year], month: params[:month], transit_delivery: transit_delivery, product: params[:product], receipt_flag: receipt_flag, receipt_status: receipt_status)
	end

	def get_report_path(is_court, is_market, is_monitor)
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

	def get_export_path(is_market)
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