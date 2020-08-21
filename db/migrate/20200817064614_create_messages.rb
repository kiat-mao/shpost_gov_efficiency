class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
    	t.string :title
    	t.text :content
    	t.datetime :start_time
      t.datetime :end_time
      t.string :roles

      t.timestamps
    end
  end
end
