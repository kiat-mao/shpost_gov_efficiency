json.array!(@receiver_zones) do |receiver_zone|
  json.extract! receiver_zone, :id, :zone, :country_id, :start_postcode, :end_postcode
  json.url receiver_zone_url(receiver_zone, format: :json)
end
