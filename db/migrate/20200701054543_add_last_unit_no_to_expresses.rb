class AddLastUnitNoToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :last_unit_no, :string
  end
end
