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
        "username": "demo",
        "password": "demo1234",
        "database": "hummer",
        "query": "SELECT * FROM variants;",
        "cache": "rs",
        "selectors": "[{\"refseq\":\"rs\"},{\"variant\":\"mutation\"},{\"locus\": \"gene\"}]"
    }
}