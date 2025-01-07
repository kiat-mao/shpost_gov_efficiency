class AirMail < ApplicationRecord
  belongs_to :post_unit, class_name: 'Unit', optional: true
  has_one :post_parent_unit, class_name: 'Unit', through: :post_unit, source: 'parent_unit'
 
  enum direction: {import: 'import', export: 'export'}
  DIRECTION = {import: '进口', export: '出口'}

end