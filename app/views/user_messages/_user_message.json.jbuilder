json.extract! user_message, :id, :created_at, :updated_at
json.url user_message_url(user_message, format: :json)
