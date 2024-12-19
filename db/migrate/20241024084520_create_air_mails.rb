class CreateAirMails < ActiveRecord::Migration[6.0]
  def change
    create_table :air_mails do |t|
    	t.string  :mail_no
      t.string  :sender_province_name
      t.string  :sender_city_name
      t.string  :sender_county_name

      t.decimal  :real_weight
      t.decimal  :fee_weight
      t.decimal  :order_weight
      t.decimal  :postage_paid
      t.decimal  :postage_total
      t.date  :posting_date
      t.string  :transfer_type

      t.datetime  :flight_date

      # t.integer  :last_unit_id
      t.string   :last_unit_name
      # t.string	 :status
      t.datetime :last_op_at
      t.string	 :last_op_desc
      # t.string	 :sign
      # t.string	 :desc

      # t.integer	 :delivered_days
      t.timestamps

      t.index :mail_no
    end
    # add_index :express, :express_no
    # add_index :express, :business_id
    # add_index :express, :status
    # add_index :express, :delivered_days
  end
end
