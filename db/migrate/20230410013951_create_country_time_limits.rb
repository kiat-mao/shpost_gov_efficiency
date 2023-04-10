class CreateCountryTimeLimits < ActiveRecord::Migration[6.0]
  def change
    create_table :country_time_limits do |t|
    	t.string   :country, :null => false, :unique => true
    	t.integer  :interchange1
    	t.integer  :interchange2
    	t.integer  :air
    	t.integer  :arrive
    	t.integer  :leave
    end
  end
end
