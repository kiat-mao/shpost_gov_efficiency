class AddIndexToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_index :expresses, :express_no
  	add_index :expresses, :business_id
  	add_index :expresses, :status
  	add_index :expresses, :last_unit_id
  	add_index :expresses, :posting_date
  end
end
