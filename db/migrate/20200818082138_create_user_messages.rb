class CreateUserMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :user_messages do |t|
    	t.integer :message_id
    	t.integer :user_id
    	t.boolean :is_read, default: false 

      t.timestamps
    end
  end
end
