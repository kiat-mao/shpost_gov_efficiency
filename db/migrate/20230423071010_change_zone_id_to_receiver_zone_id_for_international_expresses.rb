class ChangeZoneIdToReceiverZoneIdForInternationalExpresses < ActiveRecord::Migration[6.0]
  def change
  	rename_column :international_expresses, :zone_id, :receiver_zone_id
  end
end
