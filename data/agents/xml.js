{
	"identifier": "agents_xml",
	"title": "XML Agent",
	"help": "Check for content changes on XML files",
	"publisher":"xml",
	"schedule":"2h",
	"action":"lovd",
	"payload": {
        "uri": "https://eds.gene.le.ac.uk/api/rest.php/variants/COL3A1",
        "cache": "//title"
    }
}