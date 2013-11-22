json.array!(@events) do |event|
  json.extract! event, :payload, :memory
  json.url event_url(event, format: :json)
end
