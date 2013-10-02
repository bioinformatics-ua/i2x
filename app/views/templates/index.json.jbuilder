json.array!(@templates) do |template|
  json.extract! template, :identifier, :title, :help, :publisher, :variables, :payload, :memory, :count, :last_execute_at, :created_at, :updated_at
  json.url template_url(template, format: :json)
end
