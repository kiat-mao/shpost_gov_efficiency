class AddLastUnitNameToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :last_unit_name, :string
  end
end
