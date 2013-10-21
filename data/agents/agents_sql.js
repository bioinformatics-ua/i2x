{
	"identifier": "agent_sql",
	"title": "SQL Agent",
	"help": "Check for content changes on SQL databases",
	"publisher":"sql",
	"schedule":"2d",
	"action":"variants",
	"options": {
        "server":"mysql",
        "host": "localhost",
        "port": 3306,
        "username": "root",
        "password": "telematica",
        "database": "i2x",
        "query": "SELECT * FROM variants;",
        "content_id": "id"
    }
}