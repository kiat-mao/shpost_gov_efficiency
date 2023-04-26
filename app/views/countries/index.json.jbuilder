json.array!(@countries) do |country|
  json.extract! country, :id, :name, :interchange1, :interchange2, :air, :arrive, :leave
  json.url country_url(country, format: :json)
end
