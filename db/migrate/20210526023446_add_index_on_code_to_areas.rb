class AddIndexOnCodeToAreas < ActiveRecord::Migration[6.0]
  def change
  	# add_index :expresses, :receiver_province_no
  	add_index :areas, :code
  end
end
