class AddBaseProductNoToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :base_product_no, :string
  end
end
