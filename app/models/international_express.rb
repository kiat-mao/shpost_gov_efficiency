class InternationalExpress < ApplicationRecord
  belongs_to :business, optional: true

  enum status: {waiting: 'waiting', returns: 'returns'}
  STATUS_NAME = { waiting: '未妥投', returns: '退回'}
end
