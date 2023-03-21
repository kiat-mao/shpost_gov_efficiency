class AddIndexBtypeToBusinesses < ActiveRecord::Migration[6.0]
  def change
  	add_index :businesses, :btype
  end
end
