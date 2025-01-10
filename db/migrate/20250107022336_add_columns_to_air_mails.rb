class AddColumnsToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :transfer_center_unit_no, :string
    add_column :air_mails, :is_arrive_jm, :boolean, default: false
    add_column :air_mails, :is_leave_jm, :boolean, default: false
    add_column :air_mails, :is_arrive_center, :boolean, default: false
    add_column :air_mails, :is_leave_center, :boolean, default: false
    add_column :air_mails, :is_leave_center_in_time, :boolean, default: false
    add_column :air_mails, :is_arrive_sub, :boolean, default: false
    add_column :air_mails, :is_in_delivery, :boolean, default: false
    add_column :air_mails, :is_delivered_in_time, :boolean, default: false
  end
end
