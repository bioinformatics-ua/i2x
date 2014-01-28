{
    "identifier": "sql",
    "title": "SQL variant template",
    "help": "Load variome metadata for new variants.",
    "publisher": "sql",
    "payload": {
        "server": "mysql",
        "host": "localhost",
        "port": 3306,
        "username": "demo",
        "password": "demo1234",
        "database": "hummer",
        "query": "INSERT INTO mutations(mutation, content, author, created_at) VALUES('%{mutation}', '%{content}', '%{author}', now());"
    }
}