class Ability
	include CanCan::Ability

	CanCan.accessible_by_strategy = :left_join


	def initialize(user)
		if user.superadmin?
			can :manage, User
			can :manage, Unit
			can :manage, UserLog
			can :manage, Role
			can :role, :unitadmin
			can :role, :user
			can :role, :international
			can :role, :zm
			cannot [:role, :create, :destroy, :update], User, role: 'superadmin'
			can :update, User, id: user.id
			can :manage, UpDownload
			can :manage, Business

			can :manage, Express

			can "report", "DeliverMarketReport"

			can "report", "DeliverUnitReport"
			can "report", "InternationalExpressReport"
			can :manage, Message
			can :manage, Country
			can :manage, ReceiverZone
			can :manage, InternationalExpress
			can :manage, ImportFile
			can :manage, AirMail
			can :manage, Report
			can :manage, FakeMail
			#can :manage, User
		elsif user.company_admin?
			can :manage, Unit
			cannot :user, Unit, level: 2
			cannot :manage, Unit, level: 0
			can [:read, :user], Unit, level: 0

			can :manage, User#, role: ['unitadmin', 'user']
			# cannot :role, User
			cannot :manage, User, role: ['superadmin']

			cannot [:role, :create, :destroy], User, id: user.id
			# can :update, User, id: user.id

			can :role, :unitadmin
			can :role, :international
			can :role, :user
			can :role, :zm

			can :manage, Business, is_international: false

			can [:read, :get_mail_trace, :query_mail_trace], Express
			can "report", "DeliverMarketReport"
			can "report", "DeliverUnitReport"

			can [:read, :details], Message
			can :manage, AirMail
			can :manage, Report
			cannot [:zm_deliver_report, :zm_operation_report, :zm_province_report, :zm_time_limit_report], Report
			can :manage, FakeMail
		elsif user.unitadmin?
			can [:read, :user], Unit, id: user.unit.id
			can :read, Unit, parent_id: user.unit.id

			can :manage, User, unit_id: user.unit_id
			cannot :role, User
			cannot :destroy, User, id: user.id
			can :role, :user

			can :read, Business, is_international: false

			can [:read, :get_mail_trace], Express, post_unit_id: user.unit_id
			# can [:read, :get_mail_trace], Express, post_unit: {parent_id: user.unit_id}
			can [:read, :get_mail_trace], Express, post_unit_id: user.unit.child_unit_ids

			can [:read, :get_mail_trace], Express, business_id: Business.where(is_all_visible: true).ids

			can :query_mail_trace, Express

			can "report", "DeliverMarketReport"
			can "report", "DeliverUnitReport"
			can [:read, :details], Message
			can :manage, Report
			cannot [:zm_deliver_report, :zm_operation_report, :zm_province_report, :zm_time_limit_report], Report
		elsif user.user?#user
			can :read, Unit, id: user.unit_id
			can :read, Unit, parent_id: user.unit.id
			
			can [:update, :show], User, id: user.id
			can :read, Business

			can [:read, :get_mail_trace], Express, post_unit_id: user.unit_id
			# can [:read, :get_mail_trace], Express, post_unit: {parent_id: user.unit_id}
			can [:read, :get_mail_trace], Express, post_unit_id: user.unit.child_unit_ids

			can [:read, :get_mail_trace], Express, business_id: Business.where(is_all_visible: true).ids

			can "report", "DeliverMarketReport"
			can "report", "DeliverUnitReport"
			can [:read, :details], Message
			can :manage, Report
			cannot [:zm_deliver_report, :zm_operation_report, :zm_province_report, :zm_time_limit_report], Report
		elsif user.international?
			# can :read, Unit, id: user.unit.id
			# can :read, Unit, parent_id: user.unit.id

			can [:read, :update, :show], User, id: user.id
			can :manage, Business, is_international: true
			can :manage, Country
			can [:read, :import, :get_mail_trace], InternationalExpress
			can :manage, ReceiverZone
			can :manage, ImportFile
			can "report", "InternationalExpressReport"
		elsif user.zm?
			# can :read, Unit, id: user.unit.id
			# can :read, Unit, parent_id: user.unit.id

			can [:read, :update, :show], User, id: user.id
			can [:read, :get_mail_trace, :zm_province_index], Express
			can [:zm_deliver_report, :zm_operation_report, :zm_province_report, :zm_time_limit_report], Report

		end





# Define abilities for the passed in user here. For example:
#
#   user ||= User.new # guest user (not logged in)
#   if user.admin?
#     can :manage, :all
#   else
#     can :read, :all
#   end
#
# The first argument to `can` is the action you are giving the user 
# permission to do.
# If you pass :manage it will apply to every action. Other common actions
# here are :read, :create, :update and :destroy.
#
# The second argument is the resource the user can perform the action on. 
# If you pass :all it will apply to every resource. Otherwise pass a Ruby
# class of the resource.
#
# The third argument is an optional hash of conditions to further filter the
# objects.
# For example, here the user can only update published articles.
#
#   can :update, Article, :published => true
#
# See the wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities
	end
end
