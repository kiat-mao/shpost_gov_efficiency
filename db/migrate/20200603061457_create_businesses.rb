class CreateBusinesses < ActiveRecord::Migration[6.0]
  def change
    create_table :businesses do |t|
    	t.string   :code, :null => false, :unique => true
    	t.string   :name, :null => false
    	t.string   :btype
    	t.string   :industry
    	t.integer   :time_limit

      t.timestamps
    end
  end
end
