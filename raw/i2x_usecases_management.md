In most companies and research units the project management tasks span multiple tools. Hence, developers have to ensure consistency amongst issues in GitHub, tasks in Redmine and, sometimes, their own personal lists. Integrative tools that can exchange data between these distributed systems will greatly improve the management workflow.

## Why
- Enable **automated** integration between **multiple** project management information systems (`GitHub` <-> `Redmine`)

## What
- Register custom **Flux Capacitor** endpoint as GitHub service hook
- Process hook input, submit to Redmine services

## How

### Input
- JSON from GitHub service hook

### Output
- POST a new issue to custom Redmine web service