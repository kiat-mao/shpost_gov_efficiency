class AddIndexesToInternationalExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_index :international_expresses, :country_id
  	add_index :international_expresses, :business_id
  	add_index :international_expresses, :receiver_zone_id
  	add_index :international_expresses, :status
  	add_index :international_expresses, :is_leaved_center
  end
end
