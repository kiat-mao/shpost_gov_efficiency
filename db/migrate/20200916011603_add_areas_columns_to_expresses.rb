class AddAreasColumnsToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :receiver_city_no, :string
  	add_column :expresses, :receiver_county_no, :string
  	add_column :expresses, :receiver_district_no, :string

  	add_column :expresses, :posting_hour, :integer

  	add_column :expresses, :distributive_center_no, :string
  end
end
