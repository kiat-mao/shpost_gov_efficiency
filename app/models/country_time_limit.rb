class CountryTimeLimit < ApplicationRecord
	validates_presence_of :country, :message => '不能为空'
	validates_uniqueness_of :country, :message => '该国家已存在'

	has_many :receiver_zones
end
