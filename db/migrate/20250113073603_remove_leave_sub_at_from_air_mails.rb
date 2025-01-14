class RemoveLeaveSubAtFromAirMails < ActiveRecord::Migration[6.0]
  def change
    remove_column :air_mails, :leave_sub_at, :datetime
  end
end
