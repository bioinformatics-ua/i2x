json.array!(@variants) do |variant|
  json.extract! variant, :refseq, :gene, :variant, :url
  json.url variant_url(variant, format: :json)
end
