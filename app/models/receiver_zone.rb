class ReceiverZone < ApplicationRecord
	validates_presence_of :zone, :country_time_limit_id, :start_postcode, :end_postcode, :message => '不能为空'
	
	belongs_to :country_time_limit
end
