class AddIndexToExpressesOnPostUnitId < ActiveRecord::Migration[6.0]
  def change
        add_index :expresses, :post_unit_id
  end
end

