module AirMailsHelper
	def get_air_mails_path(addr, flight_num, is_arrive_jm, is_leave_jm, transfer_center_unit_no, is_arrive_center, is_leave_center, is_leave_center_in_time, last_unit_id, parent_last_unit_id, is_arrive_sub, is_in_delivery, is_delivered_in_time)
		sep="?"

		if !params[:flight_date_start].blank?
			addr += sep+"flight_date_start=#{params[:flight_date_start]}"
			sep = "&"
		end

		if !params[:flight_date_end].blank?
			addr += sep+"flight_date_end=#{params[:flight_date_end]}"
			sep = "&"
		end

		if !params[:fno1].blank?
			addr += sep+"fno1=#{params[:fno1]}"
			sep = "&"
		end

		if !params[:fno2].blank?
			addr += sep+"fno2=#{params[:fno2]}"
			sep = "&"
		end

		if !params[:direction].blank?
			addr += sep+"direction=#{params[:direction]}"
			sep = "&"
		end

		if !flight_num.blank?
			addr += sep+"flight_num=#{flight_num}"
			sep = "&"
		end

		if !is_arrive_jm.blank?
			addr += sep+"is_arrive_jm=#{is_arrive_jm}"
			sep = "&"
		end

		if !is_leave_jm.blank?
			addr += sep+"is_leave_jm=#{is_leave_jm}"
			sep = "&"
		end

		if !transfer_center_unit_no.blank?
			addr += sep+"transfer_center_unit_no=#{transfer_center_unit_no}"
			sep = "&"
		end

		if !is_arrive_center.blank?
			addr += sep+"is_arrive_center=#{is_arrive_center}"
			sep = "&"
		end

		if !is_leave_center.blank?
			addr += sep+"is_leave_center=#{is_leave_center}"
			sep = "&"
		end

		if !is_leave_center_in_time.blank?
			addr += sep+"is_leave_center_in_time=#{is_leave_center_in_time}"
			sep = "&"
		end

		if !last_unit_id.blank?
			addr += sep+"last_unit_id=#{last_unit_id}"
			sep = "&"
		end

		if !parent_last_unit_id.blank?
			addr += sep+"parent_last_unit_id=#{parent_last_unit_id}"
			sep = "&"
		end

		if !is_arrive_sub.blank?
			addr += sep+"is_arrive_sub=#{is_arrive_sub}"
			sep = "&"
		end

		if !is_in_delivery.blank?
			addr += sep+"is_in_delivery=#{is_in_delivery}"
			sep = "&"
		end

		if !is_delivered_in_time.blank?
			addr += sep+"is_delivered_in_time=#{is_delivered_in_time}"
			sep = "&"
		end

		addr
	end
end