class AddIndexsToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_index :expresses, :delivered_days
  	add_index :expresses, :delivered_status
  	add_index :expresses, :whereis
  end
end
