{
	"identifier": "pinger",
	"title": "pinger",
	"help": "Ping server and save on log file",
	"publisher":"url",
	"variables":["id"],
	"payload": {
		"method":"get",
		"uri":"http://i2x.dev/ping/%{id}"	
	}
}