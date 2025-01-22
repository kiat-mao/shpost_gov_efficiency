class AirMail < ApplicationRecord
  belongs_to :post_unit, class_name: 'Unit', optional: true
  has_one :post_parent_unit, class_name: 'Unit', through: :post_unit, source: 'parent_unit'
  belongs_to :last_unit, class_name: 'Unit', optional: true
  has_one :last_parent_unit, class_name: 'Unit', through: :last_unit, source: 'parent_unit'
 
  enum direction: {import: 'import', export: 'export'}
  DIRECTION = {import: '进口', export: '出口'}

  enum status: {waiting: 'waiting', delivered: 'delivered', returns: 'returns', del: 'del'}
  STATUS_NAME = { waiting: '未妥投', delivered: '妥投', returns: '退回'}

  enum whereis: {in_transit: 'in_transit', delivery_part: 'delivery part'}
  WHEREIS_NAME = {in_transit: '在途中', delivery_part: '投递端'}

  def self.get_filter_air_mails(params) 
  	air_mails = AirMail.all

  	if !params[:direction].blank?
			air_mails = air_mails.where(direction: params[:direction])
		end

		if !params[:posting_date_start].blank?
    	posting_date_start = params[:posting_date_start].to_date 
    	air_mails = air_mails.where("air_mails.posting_date >= ? ",posting_date_start)
    end

		if !params[:posting_date_end].blank?
			posting_date_end = params[:posting_date_end].to_date+1.day
			air_mails = air_mails.where("air_mails.posting_date < ? ",posting_date_end)
    end

    if !params[:parent_post_unit_id].blank?
    	if eval(params[:parent_post_unit_id]).blank?
    		post_unit_ids = nil
    	else
    		post_unit_ids = Unit.where(parent_id: eval(params[:parent_post_unit_id])).map{|u| u.id}.uniq
    	end
    	air_mails = air_mails.where(post_unit_id: post_unit_ids)
    end

    if !params[:post_unit_id].blank?
    	air_mails = air_mails.where(post_unit_id: eval(params[:post_unit_id]))
    end

    if !params[:flight_date_start].blank?
    	flight_date_start = params[:flight_date_start].to_date-13.5.hours
    	air_mails = air_mails.where("air_mails.flight_date >= ? ",flight_date_start)
    end

    if !params[:flight_date_end].blank?
    	flight_date_end = params[:flight_date_end].to_date+10.5.hours
    	air_mails = air_mails.where("air_mails.flight_date < ? ",flight_date_end)
    end

    fno = []
    if !params[:fno1].blank?
    	fno << I18n.t('flight_number.fno1')
    end

    if !params[:fno2].blank?
    	fno << I18n.t('flight_number.fno2')
    end
    if !fno.blank?
    	air_mails = air_mails.where(flight_number: fno)
    end

    if !params[:flight_num].blank?
    	air_mails = air_mails.where(flight_number: params[:flight_num])
    end

    if !params[:is_arrive_jm].blank?
    	air_mails = air_mails.where(is_arrive_jm: eval(params[:is_arrive_jm]))
    end

    if !params[:is_leave_jm].blank?
    	air_mails = air_mails.where(is_leave_jm: eval(params[:is_leave_jm]))
    end

    if !params[:transfer_center_unit_no].blank?
    	air_mails = air_mails.where(transfer_center_unit_no: params[:transfer_center_unit_no])
    end

    if !params[:is_arrive_center].blank?
    	air_mails = air_mails.where(is_arrive_center: eval(params[:is_arrive_center]))
    end

    if !params[:is_leave_center].blank?
    	air_mails = air_mails.where(is_leave_center: eval(params[:is_leave_center]))
    end

    if !params[:is_leave_center_in_time].blank?
    	air_mails = air_mails.where(is_leave_center_in_time: eval(params[:is_leave_center_in_time]))
    end

    if !params[:last_unit_id].blank?
    	air_mails = air_mails.where(last_unit_id: eval(params[:last_unit_id]))
    end

    if !params[:parent_last_unit_id].blank?
    	if eval(params[:parent_last_unit_id]).blank?
    		last_unit_ids = nil
    	else
    		last_unit_ids = Unit.where(parent_id: eval(params[:parent_last_unit_id])).map{|u| u.id}.uniq
    	end
    	air_mails = air_mails.where(last_unit_id: last_unit_ids)
    end

    if !params[:is_arrive_sub].blank?
    	air_mails = air_mails.where(is_arrive_sub: eval(params[:is_arrive_sub]))
    end

    if !params[:is_in_delivery].blank?
    	air_mails = air_mails.where(is_in_delivery: eval(params[:is_in_delivery]))
    end

    if !params[:is_delivered_in_time].blank?
    	air_mails = air_mails.where(is_delivered_in_time: eval(params[:is_delivered_in_time]))
    end
  	
  	return air_mails
  end

end