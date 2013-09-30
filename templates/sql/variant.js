{
	"title":"variant",
	"type":"sql",
	"payload": {
		"host":"localhost",
		"username":"root",
		"password":"telematica",
		"database":"i2x",
		"query":"INSERT INTO stds(label, help, visited, created_at, updated_at) VALUES('variant', '%{refseq}:%{variant}', %{id}, now(), now());",
		"properties":["id", "variant", "refseq"]
	}
}