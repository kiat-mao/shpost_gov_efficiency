class InternationalExpress < ApplicationRecord
  belongs_to :business, optional: true
  belongs_to :country
  belongs_to :receiver_zone
  
  enum status: {waiting: 'waiting', returns: 'returns'}
  STATUS_NAME = { waiting: '未妥投', returns: '退回'}
end
