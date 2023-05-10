class ChangeIsLeavedChangeToInternationalExpresses < ActiveRecord::Migration[6.0]
  def change
  	rename_column :international_expresses, :is_leaved_change, :is_leaved_center
  	rename_column :international_expresses, :leaved_change_at, :leaved_center_at
  	rename_column :international_expresses, :leaved_change_hours, :leaved_center_hours
  end
end
