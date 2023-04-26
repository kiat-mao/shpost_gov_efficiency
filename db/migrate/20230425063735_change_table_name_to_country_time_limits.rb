class ChangeTableNameToCountryTimeLimits < ActiveRecord::Migration[6.0]
  def change
  	rename_table :country_time_limits, :countries
  	rename_column :countries, :country, :name
  	rename_column :import_files, :country_time_limit_id, :country_id
  	rename_column :international_expresses, :country_time_limit_id, :country_id
  	rename_column :receiver_zones, :country_time_limit_id, :country_id
  	change_column :receiver_zones, :country_id, :integer
  	change_column :international_expresses, :posting_date, :datetime
  end
end
