class AddStatusColumnsToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :status, :string
    add_column :air_mails, :whereis, :string
  end
end
