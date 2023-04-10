json.array!(@country_time_limits) do |country_time_limit|
  json.extract! country_time_limit, :id, :country, :interchange1, :interchange2, :air, :arrive, :leave
  json.url country_time_limit_url(country_time_limit, format: :json)
end
