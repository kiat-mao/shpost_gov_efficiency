class AddIndexToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_index :air_mails, :flight_number
    add_index :air_mails, :direction
  end
end
