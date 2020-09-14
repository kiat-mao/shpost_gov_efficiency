class CreateAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :areas do |t|
    	t.string :code
			t.string :name
			t.boolean :is_prov
			t.boolean :is_city
			t.boolean :is_dist

      t.timestamps
    end
  end
end
