class InternationalExpress < ApplicationRecord
	belongs_to :business, optional: true
	belongs_to :country
	belongs_to :receiver_zone
end
