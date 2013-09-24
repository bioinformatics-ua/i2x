{
	"title":"bttf",
	"type":"sql",
	"payload": {
		"host":"localhost",
		"username":"root",
		"password":"telematica",
		"database":"i2x",
		"query":"INSERT INTO bttf(title, description, ts) VALUES('#{title}', '#{description}', now());"
	}
}