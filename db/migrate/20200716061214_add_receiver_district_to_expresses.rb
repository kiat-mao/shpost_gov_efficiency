class AddReceiverDistrictToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :receiver_district, :string
  end
end
