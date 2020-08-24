class AddColumnsToExpressesForReceipt < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :receipt_flag, :string
  	add_column :expresses, :receipt_status, :string

  	add_column :expresses, :pre_waybill_no, :string
  	add_column :expresses, :pre_express_id, :integer
  	add_column :expresses, :receipt_waybill_no, :string
  	add_column :expresses, :receipt_express_id, :integer
  end
end
