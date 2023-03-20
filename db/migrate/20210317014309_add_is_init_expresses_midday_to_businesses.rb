class AddIsInitExpressesMiddayToBusinesses < ActiveRecord::Migration[6.0]
  def change
  	add_column :businesses, :is_init_expresses_midday, :boolean
  end
end
