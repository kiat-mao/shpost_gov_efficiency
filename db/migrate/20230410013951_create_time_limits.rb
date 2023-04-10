class CreateTimeLimits < ActiveRecord::Migration[6.0]
  def change
    create_table :time_limits do |t|
    	t.string   :country
    	t.integer  :interchangeA1
    	t.integer  :interchangeA2
    	t.integer  :airB
    	t.integer  :arriveC
    	t.integer  :leaveD
    end
  end
end
