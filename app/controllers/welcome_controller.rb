class WelcomeController < ApplicationController
	def index
		@show = nil
		days = Date.today - I18n.t("update_info_day").to_date if !I18n.t("update_info_day").include?"translation missing"
		
		@show = days<=3 ? true : false if !days.blank?
	end
end
