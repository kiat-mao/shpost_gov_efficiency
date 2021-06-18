class AddTransferTypeToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :transfer_type, :string
  end
end
