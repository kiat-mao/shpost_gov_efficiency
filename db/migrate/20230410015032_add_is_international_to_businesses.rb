class AddIsInternationalToBusinesses < ActiveRecord::Migration[6.0]
  def change
  	add_column :businesses, :is_international, :boolean
  end
end
