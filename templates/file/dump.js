{
	"identifier": "dump",
	"title": "dumper",
	"help": "Dump id to server and save on log file",
	"publisher":"file",
	"variables":["id"],
	"payload": {
		"method":"append",
		"uri":"file:///Users/pedrolopes/Temp/i2log.csv",
		"content":"%{i2x.date},%{id}\n"
	}
}