{
	"identifier": "diseasecard_csv",
	"title": "Diseasecard CSV Agent",
	"help": "Load a (small) list of genes from Diseasecard, available in CSV format.",
	"publisher": "csv",
	"schedule": "2h",
	"payload": {
		"uri": "http://bioinformatics.ua.pt/diseasecard/hgnc.csv",
		"headers": false,
		"delimiter": ",",
		"cache": "0",
		"selectors": "[{\"id\":0},{\"gene\":1},{\"name\": 2}]"
	}
}