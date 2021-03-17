class AddBizProductNoToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :biz_product_no, :string
  end
end

