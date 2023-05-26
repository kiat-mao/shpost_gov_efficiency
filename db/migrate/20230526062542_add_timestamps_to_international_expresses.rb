class AddTimestampsToInternationalExpresses < ActiveRecord::Migration[6.0]
  def change
    add_column :international_expresses, :created_at, :timestamp
    add_column :international_expresses, :updated_at, :timestamp
  end
end
