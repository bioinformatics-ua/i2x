Within the NeoBox system, information about each newborn traverses multiple applications (and, consequently, databases). These actions require manual input or some kind of hard coding within the application scope. With **i2x** we can employ an automated strategy to migrate records between databases and publish data to multiple sources.

## Why
- Automate **NeoBox** data migration/publishing tasks

## What
- Check complete newborn data or flagged newborn data tables
    - Assess changes
- Publish to **NeoWeb**, send to **NeoScreen** DB

## How

### Input
- Constant checkup on **Newborn** status (SQL SELECT query)

### Output
- Update **NeoWeb** results database on distinct server (`SQL INSERT`/`UPDATE` query)
- Update **NeoScreen** flagged table on distinct database server (SQL UPDATE`)