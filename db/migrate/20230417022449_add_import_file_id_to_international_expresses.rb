class AddImportFileIdToInternationalExpresses < ActiveRecord::Migration[6.0]
  def change
  	add_column :international_expresses, :import_file_id, :integer
  end
end
