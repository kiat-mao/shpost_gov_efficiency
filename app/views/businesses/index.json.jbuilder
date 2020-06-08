json.array!(@businesses) do |business|
  json.extract! business, :id, :code, :name, :type, :industry, :time_limit
  json.url business_url(business, format: :json)
end
