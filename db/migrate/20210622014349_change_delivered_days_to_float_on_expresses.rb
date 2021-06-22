class ChangeDeliveredDaysToFloatOnExpresses < ActiveRecord::Migration[6.0]
  def change
  	change_column :expresses, :delivered_days, :float
  end
end
