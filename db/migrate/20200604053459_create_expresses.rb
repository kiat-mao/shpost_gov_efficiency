class CreateExpresses < ActiveRecord::Migration[6.0]
  def change
    create_table :expresses do |t|
    	t.string   :express_no
      t.integer  :business_id
      t.integer  :post_unit_id
      t.datetime :posting_date
      t.integer  :last_unit_id
      t.string	 :status
      t.datetime :last_op_at
      t.string	 :last_op_desc
      t.string	 :sign
      t.string	 :desc

      t.integer	 :delivered_days
      t.timestamps
    end
    # add_index :express, :express_no
    # add_index :express, :business_id
    # add_index :express, :status
    # add_index :express, :delivered_days
  end
end
