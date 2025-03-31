class AddOverTimeToExpresses < ActiveRecord::Migration[6.0]
  def change
    add_column :expresses, :is_over_time, :boolean, default: false
  end
end
