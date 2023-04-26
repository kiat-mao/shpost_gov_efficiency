class AddColumnsToInternationalExpresses < ActiveRecord::Migration[6.0]
  def change
    add_column :international_expresses, :status, :string
    add_column :international_expresses, :is_arrived, :boolean
    add_column :international_expresses, :arrived_at, :timestamp
    add_column :international_expresses, :arrived_hours, :integer
    add_column :international_expresses, :is_leaved, :boolean
    add_column :international_expresses, :leaved_at, :timestamp
    add_column :international_expresses, :leaved_hours, :integer
    add_column :international_expresses, :is_leaved_orig, :boolean
    add_column :international_expresses, :leaved_orig_at, :timestamp
    # add_column :international_expresses, :leaved_orig_hours, :integer
    add_column :international_expresses, :leaved_orig_after_18, :boolean
    add_column :international_expresses, :is_leaved_change, :boolean
    add_column :international_expresses, :leaved_change_at, :timestamp
    add_column :international_expresses, :leaved_change_hours, :integer
    add_column :international_expresses, :is_takeoff, :boolean
    add_column :international_expresses, :takeoff_at, :timestamp
    add_column :international_expresses, :takeoff_hours, :integer

    add_column :international_expresses, :last_op_at, :timestamp
    add_column :international_expresses, :last_op_desc, :string
    add_column :international_expresses, :last_unit_name, :string
  end
end
