class AirMail < ApplicationRecord
  belongs_to :post_unit, class_name: 'Unit', optional: true
 
  enum direction: {import: 'import', export: 'export'}
  DIRECTION = {import: '进口', export: '出口'}

  enum status: {waiting: 'waiting', delivered: 'delivered', returns: 'returns', del: 'del'}
  STATUS_NAME = { waiting: '未妥投', delivered: '妥投', returns: '退回'}

  enum whereis: {in_transit: 'in_transit', delivery_part: 'delivery part'}
  WHEREIS_NAME = {in_transit: '在途中', delivery_part: '投递端'}

end