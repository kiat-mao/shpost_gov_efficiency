class AddDirectionToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :direction, :string
  end
end