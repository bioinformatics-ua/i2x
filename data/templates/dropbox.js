{
	"identifier": "dropbox_template",
	"title": "Dropbox file Template",
	"help": "Append content to a file in your dropbox.",
	"publisher": "dropbox",
	"payload": {
		"method": "append",
		"uri": "i2x_log.csv",
		"content": "${i2x.datetime},%{id},%{title}\n"
	}
}