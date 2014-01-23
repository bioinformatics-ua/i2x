{
    "identifier": "sql",
    "title": "WAVe SQL agent",
    "help": "Read data for BRCA2 mutations from WAVe database, available through SQL queries.",
    "publisher": "sql",
    "schedule": "2d",
    "payload": {
        "server": "mysql",
        "host": "localhost",
        "port": 3306,
        "username": "root",
        "password": "telematica",
        "database": "i2x",
        "query": "SELECT * FROM variants WHERE gene LIKE 'BRCA2';",
        "cache": "id",
        "selectors": "[{\"refseq\":\"rs\"},{\"variant\":\"mutation\"},{\"locus\": \"gene\"}]"
    }
}