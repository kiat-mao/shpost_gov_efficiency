class AddFlightNumberToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :flight_number, :string
  end
end
