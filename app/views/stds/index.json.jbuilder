json.array!(@stds) do |std|
  json.extract! std, :key, :label, :help, :visited
  json.url std_url(std, format: :json)
end
