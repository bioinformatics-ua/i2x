json.array!(@agents) do |agent|
  json.extract! agent, :publisher, :payload, :memory, :identifier, :title, :help, :schedule, :events_count, :last_check_at, :last_event, :seed, :created_at, :updated_at, :action
  json.url agent_url(agent, format: :json)
end
