With next-generation sequencing technologies generating huge amounts of data at an ever-increasing pace, it is critical to develop integration strategies that can maintain up-to-date knowledge bases with the most relevant human variome information.

## Why
- Real-time variant data integration from distributed LSDBs
- Automating data flows from LOVD to [WAVe][WAVe]

## What
- LOVD has RSS/XML API
- Configured as data source
- Ping data source, check changes, integrate in [WAVe][WAVe] (SQL template?)

## How

### Input
- Loop throuhg LSDB property list: iterate all LSDBs
- XML (RSS) format: read XML LOVD web service output
- `XPath` processors: access unique variation entries
- `Regex validation: validate variation description

### Output
- Call [WAVe][WAVe] web service (`POST` to REST interface): service does not exist yet...
    - Execute one or more SQL queries (`INSERT`/`UPDATE`):  write a SQL template, **i2x** just needs to fill in the gaps with graph data

[WAVe]:     http://bioinformatics.ua.pt/wave/   "WAVe: Web Analysis of the Variome"
