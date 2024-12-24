class AddUnitColumnsToAirMails < ActiveRecord::Migration[6.0]
  def change
    add_column :air_mails, :post_unit_no, :string
    add_column :air_mails, :post_unit_name, :string
    add_column :air_mails, :last_unit_no, :string
  end
end
