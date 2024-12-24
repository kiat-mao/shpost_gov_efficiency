class AddLastUnitIdToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :last_unit_id, :integer
    add_index :air_mails, :last_unit_id
  end
end
