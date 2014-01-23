{
    "identifier": "sql",
    "title": "SQL variant template",
    "help": "Load variome metadata for new variants.",
    "publisher": "sql",
    "payload": {
        "server": "mysql",
        "host": "localhost",
        "port": 3306,
        "username": "root",
        "password": "telematica",
        "database": "i2x",
        "query": "INSERT INTO stds(label, help, visited, created_at, updated_at) VALUES('variant', '%{refseq}:%{variant}', %{id}, '%{i2x.datetime}', now());"
    }
}