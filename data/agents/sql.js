{
    "identifier": "sql",
    "title": "SQL Agent",
    "help": "Check for content changes on variant SQL databases",
    "publisher": "sql",
    "schedule": "2d",
    "action": "wave",
    "seed": {
        "publisher": "csv",
        "uri": "http://pedrolopes.net/i2x/log.csv",
        "headers": true,
        "delimiter": ",",
        "selectors": [
            {
                "gene": "1"
            }
        ]
    },
    "payload": {
        "server": "mysql",
        "host": "localhost",
        "port": 3306,
        "username": "root",
        "password": "telematica",
        "database": "i2x",
        "query": "SELECT * FROM variants WHERE gene LIKE '%{gene}';",
        "memory": "id",
        "selectors": [
            {
                "refseq": "refseq"
            },
            {
                "variant": "variant"
            },
            {
                "locus": "gene"
            }
        ]
    }
}