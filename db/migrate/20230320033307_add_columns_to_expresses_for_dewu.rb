class AddColumnsToExpressesForDewu < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :last_prov, :string
  	add_column :expresses, :last_city, :string

  	add_column :expresses, :is_change_addr, :boolean
  	add_column :expresses, :is_cancelled, :boolean

  	add_column :expresses, :postage_total, :number
  end
end
