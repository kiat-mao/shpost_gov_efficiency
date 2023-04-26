class CreateImportFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :import_files do |t|
    	t.string :file_name, null: false
      t.string :file_path, null: false, default: ''
      t.integer :user_id
      t.integer :unit_id
      t.integer :country_time_limit_id
      t.string :batch_no
      t.string :status
      t.string :desc
      t.string :err_file_path
      
      t.timestamps
    end
  end
end
