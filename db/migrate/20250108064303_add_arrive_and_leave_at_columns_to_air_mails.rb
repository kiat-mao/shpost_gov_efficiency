class AddArriveAndLeaveAtColumnsToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :leave_jm_at, :datetime
    add_column :air_mails, :arrive_center_at, :datetime
    add_column :air_mails, :leave_center_at, :datetime
    add_column :air_mails, :arrive_sub_at, :datetime
    add_column :air_mails, :leave_sub_at, :datetime
    add_column :air_mails, :in_delivery_at, :datetime
    add_column :air_mails, :delivered_at, :datetime
  end
end
