{
    "identifier": "rss",
    "title": "RSS Feed Agent",
    "help": "Monitor content from RSS feed.",
    "publisher": "xml",
    "schedule": "5m",
    "payload": {
        "uri": "http://pedrolopes.svbtle.com/feed",
        "cache": "id",
        "query": "//entry",
        "selectors": "[{\"title\":\"title\"},{\"content\":\"content\"},{\"url\": \"link/@href\"}]"
    }
}