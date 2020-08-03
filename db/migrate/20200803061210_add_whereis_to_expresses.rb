class AddWhereisToExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :expresses, :whereis, :string
  end
end
