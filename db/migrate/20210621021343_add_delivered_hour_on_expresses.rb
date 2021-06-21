class AddDeliveredHourOnExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :delivered_hour, :integer
  end
end
