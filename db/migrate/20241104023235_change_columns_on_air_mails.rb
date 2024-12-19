class ChangeColumnsOnAirMails < ActiveRecord::Migration[6.0]
  def change
    change_column :air_mails, :posting_date, :datetime
    add_column  :air_mails, :arrive_jm_at, :datetime
  end
end
