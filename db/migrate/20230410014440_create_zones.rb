class CreateZones < ActiveRecord::Migration[6.0]
  def change
    create_table :receiver_country_zones do |t|
    	t.string   :zone
    	t.integer  :time_limit_id
    	t.string   :start_postcode
    	t.string   :end_postcode
    end
  end
end
