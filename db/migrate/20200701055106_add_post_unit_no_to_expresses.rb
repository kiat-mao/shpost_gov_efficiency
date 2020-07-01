class AddPostUnitNoToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :post_unit_no, :string
  end
end
