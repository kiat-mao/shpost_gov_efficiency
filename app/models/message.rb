class Message < ApplicationRecord
	has_and_belongs_to_many :user_messages
end
