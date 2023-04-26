class ImportFile < ApplicationRecord
  belongs_to :country
  belongs_to :unit
  belongs_to :user

  STATUS = { success: '成功', fail: '失败'}

  def status_name
    status.blank? ? "" : ImportFile::STATUS["#{status}".to_sym]
  end
end
