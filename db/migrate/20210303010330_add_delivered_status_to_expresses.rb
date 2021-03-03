class AddDeliveredStatusToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :delivered_status, :string
  end
end
