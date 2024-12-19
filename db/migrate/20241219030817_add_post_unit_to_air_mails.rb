class AddPostUnitToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :post_unit_id, :integer
    add_index :air_mails, :post_unit_id
  end
end
