class AddColumnsToExpresses4Zmrs < ActiveRecord::Migration[6.0]
  def change
    add_column :expresses, :is_arrive_sub, :boolean, default: false
    add_column :expresses, :is_in_delivery, :boolean, default: false
    add_column :expresses, :is_delivery_failure, :boolean, default: false
  end
end
