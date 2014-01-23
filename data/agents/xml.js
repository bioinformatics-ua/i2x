{
    "identifier": "xml",
    "title": "LOVD XML Agent",
    "help": "Load mutation data for COL3A1 gene from LOVD, available in XML format.",
    "publisher": "xml",
    "schedule": "2h",
    "payload": {
        "uri": "https://eds.gene.le.ac.uk/api/rest.php/variants/COL3A1",
        "cache": "id",
        "query": "//entry",
        "selectors": "[{\"mutation\":\"title\"},{\"author\":\"author/name\"},{\"content\": \"content\"}]"
    }
}