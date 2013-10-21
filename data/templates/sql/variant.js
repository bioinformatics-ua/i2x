{
    "identifier": "variant",
    "title": "variant",
    "help": "Load variome metadata for new variants in database",
    "publisher": "sql",
    "variables": [
        "id",
        "variant",
        "refseq"
    ],
    "payload": {
        "server":"mysql"
        "host": "localhost",
        "port": 3306,
        "username": "root",
        "password": "telematica",
        "database": "i2x",
        "query": "INSERT INTO stds(label, help, visited, created_at, updated_at) VALUES('variant', '%{refseq}:%{variant}', %{id}, now(), now());"
    }
}