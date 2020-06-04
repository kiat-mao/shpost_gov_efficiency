class Business < ApplicationRecord
	validates_presence_of :code, :name, :message => '不能为空'
	validates_uniqueness_of :code, :message => '该客户代号已存在'
end


