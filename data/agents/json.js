{
	"identifier": "json",
	"title": "Diseasecard JSON agent",
	"help": "Load data for Alzheimer's disease from Diseasecard, available in JSON format.",
	"publisher": "json",
	"schedule": "2h",
	"payload": {
		"uri": "http://bioinformatics.ua.pt/diseasecard/entry/104300.js",
		"cache": ".size",
		"query": ".",
		"selectors": "[{\"id\":\".omim\"},{\"location\":\".location\"},{\"name\": \".description\"}]"
	}
}