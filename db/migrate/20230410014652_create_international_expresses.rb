class CreateInternationalExpresses < ActiveRecord::Migration[6.0]
  def change
    create_table :international_expresses do |t|
    	t.string   :express_no
    	t.integer  :country_time_limit_id
    	t.integer  :business_id
    	t.date     :posting_date
    	t.string   :receiver_postcode
    	t.float    :weight
        t.integer  :zone_id
    end
  end
end
