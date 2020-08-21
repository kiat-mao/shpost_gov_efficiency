class WelcomeController < ApplicationController
	before_action :create_user_message, only: [:index]

	def index
		@message = nil

		um = UserMessage.joins(:message).where(user_id: current_user.id, is_read: false).order("messages.created_at").first
		@message = Message.find(um.message_id) if !um.blank?
	end

	private
		def create_user_message
			# byebug
	    Message.where("start_time<=? and end_time>=? and roles like ?", Time.now, Time.now, "%#{current_user.role}%").each do |m|
	      if UserMessage.where(message_id: m.id, user_id: current_user.id).blank?
	        UserMessage.create message_id: m.id, user_id: current_user.id
	      end
	    end
	  end
end
