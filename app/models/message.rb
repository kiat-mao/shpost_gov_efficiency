class Message < ApplicationRecord
	has_and_belongs_to_many :user_messages

	def roles_name
		role_name = []
		self.roles.split(',').each do |x|
			role_name << User::ROLE[x.to_sym]
		end
		rname = role_name.compact.join(',')
	end
end
