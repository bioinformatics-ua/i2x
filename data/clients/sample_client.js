{
    "server": {
        "name": "%{name}",
        "host": "%{host}",
        "api_key": "%{access_token}"
    },
    "agents": [{
        "identifier": "<id>",
        "publisher": "<publisher>",
        "schedule": "<schedule>",
        "payload": {
            "query": "<query>",
            "cache": "<cache>",
            "selectors": [{
                "<a>": "1"
            }, {
                "<b>": "2"
            }, {
                "<c>": "3"
            }]
        }
    }]
}