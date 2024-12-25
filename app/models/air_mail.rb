class AirMail < ApplicationRecord
  belongs_to :post_unit, class_name: 'Unit', optional: true
 
  enum direction: {import: 'import', export: 'export'}
  DIRECTION = {import: '进口', export: '出口'}

end