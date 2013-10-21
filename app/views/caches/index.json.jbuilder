json.array!(@caches) do |cach|
  json.extract! cach, :hash, :publisher, :agent, :payload, :memory
  json.url cach_url(cach, format: :json)
end
