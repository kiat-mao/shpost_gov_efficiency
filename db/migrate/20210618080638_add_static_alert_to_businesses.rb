class AddStaticAlertToBusinesses < ActiveRecord::Migration[6.0]
  def change
  	add_column :businesses, :static_alert, :boolean
  end
end
