class Business < ApplicationRecord
	validates_presence_of :code, :name, :message => '不能为空'
	validates_inclusion_of :is_init_expresses_midday, :is_all_visible, in: [true, false], :message => '只能是或否'
	validates_uniqueness_of :code, :message => '该客户代号已存在'

	def self.select_btypes(is_court)
		btypes = nil
		
		if !is_court.nil?
			if !is_court
				btypes = Business.where.not(industry: "法院").select(:btype).distinct
			else
				btypes = Business.where(industry: "法院").select(:btype).distinct
			end
		else
			btypes = Business.all.select(:btype).distinct
		end
		return btypes
	end
end


