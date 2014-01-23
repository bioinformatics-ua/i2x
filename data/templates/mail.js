{
    "identifier": "mail",
    "title": "Send mail template",
    "help": "Send some data via mail.",
    "publisher": "mail",
    "payload": {
        "to": "pedrolopes@ua.pt",
        "cc": "pdrlps@gmail.com",
        "bcc": "hello@pedrolopes.net",
        "subject": "New email with %{title}",
        "message": "<b>Title:</b>%{title}<br /><br/>%{content}<br />%{i2x.datetime}"
    }
}