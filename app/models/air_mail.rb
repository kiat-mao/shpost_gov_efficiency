class AirMail < ApplicationRecord
  belongs_to :post_unit, class_name: 'Unit', optional: true
  has_one :post_parent_unit, class_name: 'Unit', through: :post_unit, source: 'parent_unit'
 
  enum direction: {import: 'import', export: 'export'}
  DIRECTION = {import: '进口', export: '出口'}

  enum status: {waiting: 'waiting', delivered: 'delivered', returns: 'returns', del: 'del'}
  STATUS_NAME = { waiting: '未妥投', delivered: '妥投', returns: '退回'}

  enum whereis: {in_transit: 'in_transit', delivery_part: 'delivery part'}
  WHEREIS_NAME = {in_transit: '在途中', delivery_part: '投递端'}

  def self.get_filter_air_mails(params) 
  	air_mails = AirMail.left_outer_joins(:post_unit).left_outer_joins(:post_unit=>:parent_unit)

  	if !params[:direction].blank?
			air_mails = air_mails.where("air_mails.direction = ?", params[:direction])
		end

		if !params[:posting_date_start].blank?
    	posting_date_start = params[:posting_date_start].to_date 
    	air_mails = air_mails.where("air_mails.posting_date >= ? ",posting_date_start)
    end

		if !params[:posting_date_end].blank?
			posting_date_end = params[:posting_date_end].to_date+1.day
			air_mails = air_mails.where("air_mails.posting_date < ? ",posting_date_end)
    end

    if !params[:parent_unit_id].blank?
    	air_mails = air_mails.where("units.parent_id=?", params[:parent_unit_id].to_i)
    end

    if !params[:post_unit_id].blank?
    	air_mails = air_mails.where("air_mails.post_unit_id=?", params[:post_unit_id].to_i)
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
    	air_mails = air_mails.where("air_mails.flight_number in (?)", fno)
    end

    if !params[:flight_num].blank?
    	air_mails = air_mails.where("air_mails.flight_number = ? ", params[:flight_num])
    end

    if !params[:is_arrive_jm].blank?
    	air_mails = air_mails.where("air_mails.is_arrive_jm = ? ", eval(params[:is_arrive_jm]))
    end

    if !params[:is_leave_jm].blank?
    	air_mails = air_mails.where("air_mails.is_leave_jm = ? ", eval(params[:is_leave_jm]))
    end

    if !params[:transfer_center_unit_no].blank?
    	air_mails = air_mails.where("air_mails.transfer_center_unit_no = ? ",params[:transfer_center_unit_no])
    end

    if !params[:is_arrive_center].blank?
    	air_mails = air_mails.where("air_mails.is_arrive_center = ? ", eval(params[:is_arrive_center]))
    end

    if !params[:is_leave_center].blank?
    	air_mails = air_mails.where("air_mails.is_leave_center = ? ", eval(params[:is_leave_center]))
    end

    if !params[:is_leave_center_in_time].blank?
    	air_mails = air_mails.where("air_mails.is_leave_center_in_time = ? ", eval(params[:is_leave_center_in_time]))
    end
  	
  	return air_mails
  end

end