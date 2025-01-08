class AddColumnsToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :transfer_center_unit_no, :string
    add_column :air_mails, :is_arrive_jm, :boolean
    add_column :air_mails, :is_leave_jm, :boolean
    add_column :air_mails, :is_arrive_center, :boolean
    add_column :air_mails, :is_leave_center, :boolean
    add_column :air_mails, :is_leave_center_in_time, :boolean
    add_column :air_mails, :is_arrive_sub, :boolean
    add_column :air_mails, :is_in_delivery, :boolean
    add_column :air_mails, :is_delivered_in_time, :boolean
  end
end
