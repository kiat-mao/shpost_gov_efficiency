class AddLimitHourToAreas < ActiveRecord::Migration[6.0]
  def change
    add_column :areas, :limit_hour, :integer
  end
end
