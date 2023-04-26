class Country < ApplicationRecord
	validates_presence_of :name, :message => '不能为空'
	validates_uniqueness_of :name, :message => '该国家已存在'

	has_many :receiver_zones
end
