json.array!(@integrations) do |integration|
  json.extract! integration, :identifier, :title, :help, :payload, :memory
  json.url integration_url(integration, format: :json)
end
