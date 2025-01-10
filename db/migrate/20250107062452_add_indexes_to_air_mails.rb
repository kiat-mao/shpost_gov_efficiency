class AddIndexesToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_index :air_mails, [:is_arrive_jm, :is_leave_jm], name: 'index_air_mail_jm_report'
    add_index :air_mails, [:transfer_center_unit_no, :is_arrive_center, :is_leave_center, :is_leave_center_in_time], name: 'index_air_mail_center_report'
    add_index :air_mails, [:last_unit, :is_arrive_sub, :is_in_delivery, :is_delivered_in_time], name: 'index_air_mail_delivery_report'
  end
end
