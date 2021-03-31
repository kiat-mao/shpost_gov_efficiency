class AddIsAllVisibleToBusinesses < ActiveRecord::Migration[6.0]
  def change
  	add_column :businesses, :is_all_visible, :boolean
  end
end
