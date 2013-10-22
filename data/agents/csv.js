{
	"identifier": "agents_csv",
	"title": "CSV Agent",
	"help": "Check for content changes on CSV files",
	"publisher":"csv",
	"schedule":"2h",
	"action":"mails",
	"payload": {
        "uri": "http://pedrolopes.net/i2x/log.csv",
        "headers": true,
        "delimiter": ",",
        "memory": "0"
    }
}