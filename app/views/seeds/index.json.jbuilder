json.array!(@seeds) do |seed|
  json.extract! seed, :identifier, :title, :publisher, :help, :payload, :memmory
  json.url seed_url(seed, format: :json)
end
