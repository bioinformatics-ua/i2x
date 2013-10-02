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
        "host": "localhost",
        "username": "root",
        "password": "telematica",
        "database": "i2x",
        "query": "INSERT INTO stds(label, help, visited, created_at, updated_at) VALUES('variant', '%{refseq}:%{variant}', %{id}, now(), now());"
    }
}