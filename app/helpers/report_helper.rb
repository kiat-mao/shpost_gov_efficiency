module ReportHelper
	def get_expresses_path(detail_btype, status, last_unit_id)
		expresses_path(industry: params[:industry], btype: params[:btype], business: params[:business], posting_date_start: params[:posting_date_start], posting_date_end: params[:posting_date_end], detail_btype: detail_btype, status: status, last_unit_id: last_unit_id)
	end
end