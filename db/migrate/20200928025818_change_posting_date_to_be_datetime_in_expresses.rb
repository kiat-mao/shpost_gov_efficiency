class ChangePostingDateToBeDatetimeInExpresses < ActiveRecord::Migration[6.0]
  def change
    change_column :expresses, :posting_date, :datetime
  end
end
