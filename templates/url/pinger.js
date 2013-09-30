{
	"identifier": "pinger",
	"title": "pinger",
	"help": "Ping server and save on log file",
	"type":"url",
	"variables":["id"],
	"payload": {
		"method":"get",
		"uri":"http://i2x.dev/ping/%{id}"
	}
}