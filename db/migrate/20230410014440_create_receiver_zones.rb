class CreateReceiverZones < ActiveRecord::Migration[6.0]
  def change
    create_table :receiver_zones do |t|
    	t.string   :zone, :null => false
    	t.string   :country_time_limit_id, :null => false
    	t.string   :start_postcode, :null => false
    	t.string   :end_postcode, :null => false

    end
  end
end
