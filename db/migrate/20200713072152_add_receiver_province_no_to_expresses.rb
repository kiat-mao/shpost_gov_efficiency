class AddReceiverProvinceNoToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :receiver_province_no, :string
  end
end
