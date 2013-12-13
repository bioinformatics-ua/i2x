<aside class="large-3 columns" markdown="1" style="position:fixed;font-size:80%;">

##### Outline
{:.no_toc}

* TOC
{:toc}

</aside>

<!-- [TOC] for Python markdown parser -->

 <div class="large-9 columns" role="content"  markdown="1">
# Agents

Agents are used by the [STD][] to monitor external resources for content changes.


# Agent Types

Each [agent][] has one and only one type. Types are defined in the `publisher` property of each [agent][]. 

## Delimited File

**STD** monitors delimited files accessible through a valid URI (`http://`, `ftp://`, `file://`). These files can have any number of columns delimited by common data exchange delimiters (`;`,`,`,`:`,`|`,`\t`). If an `id` column is configured, the change detection is performed using simple identifier matching: if the `id` has not been seen yet, it is sent for integration. If no `id` column is setup, the **STD** performs a hashing function over the entire row content. In this case, the resulting `hash` is matched against the list of already integrated rows.

**Example**

    {
      "publisher": "csv",
      "payload": {
        "uri": "http://bioinformatics.ua.pt/",
        "cache": "0",
        "headers": "on",
        "delimiter": "\n",
        "selectors": [
          {
            "id": 1
          },
          {
            "key": 2
          }
        ]
      },
      "identifier": "agent id",
      "title": "agent title",
      "help": "agent helpsd",
      "schedule": "1w"
    }

## Database

**STD** can be configured to monitor a database. In this scenario, a _SELECT_ query must be configured to access the database, retrieving the list of values that are being monitored. If an `id` column is configured, the change detection is performed using simple identifier matching: if the `id` has not been seen yet, it is sent for integration. If no `id` column is setup, the **STD** performs a hashing function over the entire row content. In this case, the resulting `hash` is matched against the list of already integrated rows. **Note** that there is forced a query limit of 1000 rows.

**Example**

    {
      "publisher": "sql",
      "payload": {
        "cache": "id",
        "sqlserver": "mysql",
        "host": "localhost",
        "port": "3306",
        "database": "i2x",
        "username": "root",
        "password": "telematica",
        "query": "SELECT * FROM variants;",
        "selectors": [
          {
            "id": "id"
          },
          {
            "refseq": "refseq"
          },
          {
            "variant": "variant"
          },
          {
            "gene": "gene"
          },
          {
            "url": "url"
          }
        ]
      },
      "identifier": "variants",
      "title": "variants",
      "help": "variants",
      "schedule": "1h"
    }

## LinkedData

<div data-alert class="alert-box warning radius">
  <strong>Note</strong>: LinkedData support is not yet available.
  <a href="#" class="close">&times;</a>
</div>

STD can be used to monitor LinkedData URIs. These must be publicly resolveable addresses and must respond properly to `Accept Encoding` headers, according [to the LinkedData principles][linkeddata]. With LinkedData monitors, STD checks all `predicates` described in the URI response. If any new predicate is detected or if a predicate object has changed, STD will generate a new event.

## SPARQL Endpoint

<div data-alert class="alert-box warning radius">
  <strong>Note</strong>: SPARQL Endpoint support is not yet available.
  <a href="#" class="close">&times;</a>
</div>

## Structured File

**STD** can monitor structured files for more complex data exchange scenarios. Structured files are accessible through a valid URI (`http://`, `ftp://`, `file://`) and their content must be valid XML or JSON. Monitored data are configured through XPath or JSONPath queries. If an `id` query is configured, the change detection is performed using simple identifier matching: if the `id` has not been seen yet, it is sent for integration. If no `id` query is setup, the **STD** performs a hashing function over the entire processed query response content. In this case, the resulting `hash` is matched against the list of already integrated results.

# Events

**Events** are occurrences of specific conditions that will trigger an [Action](#actions). i2x events can be registered when:

- New issue  (Ex: GitHub)
- New row in table (Ex: WAVe)
- New image in index (Ex: Dicoogle)

You can think of an Event as the ignition of a new data integration Action.

Basically, they're things that happen in monitored systems which cause a defined action to happen. Additionally, events supply data about what happened. These data will be passed on to the Integrations controller, which validates them and moves them to the Postman for execution in the [Delivery Template][deliverytemplate].

For example, say a service has a "New Row Added" event being monitored. We will detect when this event happens by [polling][payload]. The general event data will be something like this:

    {
      "id": 987654,
      "owner_id": 321,
      "date_created": "Mon, 17 Sep 2013 15:07:01 0000",
      "description": "Row added",
      "type": "sql",
      "payload": { ... }
    }

These key/value objects are available for mapping into the action as required.

## Metadata

### Title

Human readable, short name of the event. Shown in various places in our interface.

**Example**: *New Ticket Created* or *New Email with Label*

### Identifier

This is a field only really used internally for both prefill and scripting references. Needs to be at least 2 characters long, start with an alpha, and only contain a-z, A-Z, 0-9 or _.

**Example**: *create_issue*, *ticket* or *newEmailLabel*

### Help Text

A longer description of what this event actually watches for.

**Example**: *Triggered when a new row is added to a configured database.*

## Hooks

The traditional workflow uses the [STD][std] to detect new [events][events]. However, [events][events] can be pushed in the system using the Web/REST hooks interface. In this case, the hook payload is directly [pushed][push] to the [Integration][intgratios] in the `payload` object.

# Helper Functions

**i2x** included several internal functions allowing quick access to general variables that can be used in all templates. These functions allow the templates to retrieve information such as date/time, random numbers or strings, action names, among many others.

## Usage

**i2x** helper functions are used just like the template [variables][]. These reserved keywords are written as `i2x.function name`.

## Function list

* `date`: returns the system date
* `datetime`: returns the system date with time included (until _ms_)
* `action_identifier`: returns the ongoing action identifier
* `template_identifier`: returns the ongoing delivery template
* `environment`: returns the server execution environment (from Rails)
* `hostname`: returns the postman server hostname



# Integrations

Integrations represent what the users are trying to achieve:
- Add metadata to index (Ex: Dicoogle)
- Add new data to database (Ex: WAVe)
- Create issue (Ex: Redmine)

You can think of Integrations as POSTs, writes, query executions, or the creation of a resource. **Integrations** are performed by the [Postman](#Postman) using the specified [delivery template][].

## Metadata

### Title

This is a human readable label a user would see when browsing the integrations dashboard describing. Make it short but descriptive.

**Example**: *Create issue*, *Add variant* or *Index document*

### Identifier

This is a field only really used internally for both prefill and scripting references. Needs to be at least 2 characters long, start with an alpha, and only contain a-z, A-Z, 0-9 or _.

**Example**: *create_issue*, *add_variant* or *index*

### Help Text

This is some human-readable explanatory text, usually something that clarifies what the integration does.

**Example**: *Adds a new variant to the configured database*.

# Integration Fields

Integration Fields answer the question: What details can a user provide when creating an Integration? These are the fields available for customization in the [delivery template][]. These are things like:

- Title  (EG: Issue Title in Redmine)
- Description  (EG: Issue Description from Github)
- Parent Object  (span relationships via prefill)
- Variant Description  (EG: HGVS description)

**Note**: each action should have at least one action field. It really makes no sense to send no custom data to the delivery template.

## Metadata

### Identifier

A key for consumption in the Delivery Templates. This is available for variable syntax in the Delivery Template. Needs to be at least 2 characters long, start with an alpha, and only contain a-z, A-Z, 0-9 or _.
We'll take double underscores and convert them to nested dictionaries before execution.

**Example**: *room* or *project__title*  (converts to *{"project": {"title": "some value"} }*)

### Title

A human readable Label shown in the UI as a user works to complete an Integration.

**Example**: *Variant* or *Title*

### Help Text

Human readable description of an action field, useful for describing some detail you couldn't list in the Label.

*Example*: *Choose which room to send the message to.* or *Add a title to the note.*

### Default

A default value that is preloaded in the execution if no values are obtained for Integration execution.

# Polling

Polling is the process of repeatedly hitting the same endpoint looking for new data. Unfortunately, i2x uses the **STD** to do this. We don't like doing this (its wasteful), vendors don't like us doing it (again, its wasteful) and users dislike it (they have to wait a maximum interval to detect new events). However, it is the one method that is ubiquitous, so we support it.

It is also closely tied into how i2x handles deduplication.

A more modern approach uses Web/REST hooks. This way, services can push data into **i2x**, which reduces the application load.

# Postman

Handles the final step of the [integrations][]: gets the [integration fields][] and applies them to the [delivery template][] for execution.

# Push

**i2x** in addition to polling, [integrations][] can be configured to receive data directly from external services. *Pushing* data into **i2x** will start processing the [agents]][] specified in the push request. [Agents][] can be configured to not run in any specific schedule, meaning that they will only run when they receive data via push. However, note that you can push data into any [agent][], even if they have specific monitoring schedules.

# Seeds

[Agents][] can have any number of **Seeds** where you can configure an initial dataset to start the monitoring. Seeds are useful for monitoring long lists of similar sources

# Sources

**Sources** setup the location of external content for event detection. The [STD][] uses a [polling][] process to identify new [events][] in monitored resources. There a few changes tough, URL Routes can only be GET and SQL queries must contain a SELECT statement.

# STD: Spot The Differences

The **STD** engine will perform the [polling][] of configured [sources][] using configured [agents][]. Spot the Differences monitors specified resources looking for changes in the output content. **STD**'s algorithm identifies what has changed since the last visit to a data source (using hashes and id matching). When content changes are detected, the **STD** triggers a new [event][]. [Events][] will then be processed through configured **i2x** integration rules. In the system, detected events are sent for processing to the **FluxCapacitor**.

# Templates

**Delivery Templates** are used to define how **i2x** will handle [events][] data obtained by the [agents][]. 

## Metadata

### Identifier

A key for consumption by the [Postman][postman]. Needs to be at least 2 characters long, start with an alpha, and only contain a-z, A-Z, 0-9 or _.

**Example**: *mapper* or *issue*

**Property**: `identifier` (maps to `dc:identifier`)

### Title

A human readable Title shown in the UI as a user works to complete an [Action][action].

**Example**: *Variant* or *Title*

**Property**: `label` (maps to `dc:title`)

### Help Text

Human readable description of an action field, useful for describing some detail you couldn't list in the Label.

**Example**: *Choose which room to send the message to.* or *Add a title to the note.*

**Property**: `help` (maps to `dc:description`)

### Publisher

The type of template publisher that will be delivered by the Postman.

**Available Publishers**: *url*, *sql*, *sparql*, *mail*, *file*, *json*...

**Property**: `publisher`  (maps to `dc:publisher`)

### Payload

Object containing the set of properties specific to each [delivery][delivery] type.

**Example**: *{"id":"%{id}","subject":"%{subject}"}* or *{"title":"%{title}","key":"%{key}"}*

**Property**: `payload` (related to `i2x:payload` object)

## Sample

Sample configuration for exchanged data between the application controller and the [Integrations][]. Each [Delivery Template][deliverytemplate] type will have its own set of configuration properties, defined in the object payload.

    {
      "publisher": "url",
      "identifier": "i2x",
      "title": "label",
      "payload": {
        "url": "http://www.example.com",
        "method": "post"
        ...
      }
    }

# Template Types

[Delivery Templates][] have one (and only one) type. This defines what processing is required in the [Postman][postman] engine for successful delivery of the data. Variables in each template are marked within `%{ }` characters.

## Email

<div data-alert class="alert-box warning radius">
  <strong>Note</strong>: Email support is not yet available.
  <a href="#" class="close">&times;</a>
</div>

Sends custom emails to the configured recipients. **Note** that emails are sent from the server configured in **i2x**'s Rails settings.

### Metadata

#### Subject

The subject for the new mail to be sent by the [Postman][postman].

**Example**: *[i2x] new mail for %{i2x.action_identifier}*

**Property**: `subject` (maps to `dc:subject`)

#### To

An array with the main destination for the email.

**Example**: *["johndoe@gmail.com", "%{to}"]*

**Property**: `to` (maps to `i2x:to`)

#### CC

An array with the CC destination for the email.

**Example**: *["johndoe@gmail.com", "%{to}"]*

**Property**: `cc` (maps to `i2x:cc`)

#### BCC

An array with the BCC destination for the email.

**Example**: *["johndoe@gmail.com", "%{to}"]*

**Property**: `bcc` (maps to `i2x:bcc`)

#### Body

The body for the message being sent.

**Example**: *Hello %{first_name}! Welcome to i2x!--\n%{i2x.datetime}*

**Property**: `body` (maps to `i2x:body`)

## File Management

Changes files directly on the file system. 

### Metadata

#### Content

Template for the content being written to the selected file.

**Example**: *%{id},%{i2x.datetime}\n*

**Property**: `content` (maps to `i2x:content`)

#### Method

Defines what is the type of the change that will be performed in the file by the [Postman][postman].

**Example**: *append*, *create*

**Property**: `method` (maps to `i2x:method`)

##### Append

The _append_ method will add the content (from the property `content`) to the specified file. **Note** that the append method will attempt to create the file if it does not exist.

##### Create

The _create_ method will create a new file with the generated content (from the property `content`).

#### URI

The file URI. Not that filenames can include _variables_. The use of full system file URIs (starting with _file://_) is advised.

**Example**: *file://Temp/log.csv*

**Property**: `uri` (mas to `i2x:uri`)

### Sample

    {
    "identifier":"github_2_file","title":"GitHub to File","help":"a","publisher":"file","variables":null,"payload":{"method":"append","uri":"data/github.csv","content":"\"%{i2x.date}\",\"%{before}\",\"%{after}\",\"%{repository}\"\n"}
    }

## SQL Query

The SQL Query [Delivery Template][deliverytemplate] will execute the specified SQL query in the destination database. 
 
### Metadata

#### Server

A string matching the available database servers.

**Example**: *sqlserver*, *mysql*, *postgres*, *sqlite*

**Property**: `server` (maps to `i2x:server`)

#### Host

Address for the database host. This value defaults to `localhost` if no data is provided.

**Example**: *localhost*, *192.168.2.5*

**Property**: `host` (maps to `i2x:host`)

#### Port

Port open for connection in the database host. This value defaults to the standard server port (Ex: `3306` for `mysql`) if no data is provided.

**Example**: *3306*, *1255*

**Property**: `port` (maps to `i2x:port`)

#### Database Name

Database name where the query will be performed. 

**Example**: *wave10*, *issues*

**Property**: `database` (maps to `i2x:database`) (**mandatory**)

#### Username

Database user.

**Example**: *john_doe*

**Property**: `username` (maps to `i2x:username`) (**mandatory**)

#### Password

User password. The password is hashed before being exchanged between any service.

**Example**: *qwerty§12345*

**Property**: `password` (maps to `i2x:password`) (**mandatory**)

#### Query

The query that will be executed by the [Postman][postman] in the configured database. 

**Example**: *INSERT INTO issues (title, description, timestamp) VALUES ('{%title}, '%{description}', getdate());*

**Property**: `query` (maps to `i2x:server`) (**mandatory**)

## URL Route

Perform the selected request type on the configured URL, passing on configured parameters.

### Metadata

#### Method

Defines what is the type of the request that will be executed by the [Postman][postman].

**Example**: *get*, *post*, *delete*

**Property**: `method` (maps to `i2x:method`)

##### GET

The URL Route [Delivery Template][] will issue a GET request to the defined URL. URI *keys* are used to match [Action Fields][] defined in the [variables][variables].

**Example**: http://example.com/services/`%{id}`/`%{description}`/`%{otherpayload}`

##### POST

This URL Route POSTs extracted data to the defined URL route. [Action Fields][actionfields] are mapped to specific key/value pairs in the request metadata. The POSTed payload is included in the `payload` object in the template.

**Example**:

    "payload": {
      "type": "%{type}",
      "key": "%{key}",
      "label": "%{label}",
      "id": "%{id}"
    }

**Property**: `payload` (related to `i2x:payload` object)

#### URI

The destination URL for the request.

**Example**: *http://bioinformatics.ua.pt/i2x/postman/%{id}*, *http://bmd-software.com/*

**Property**: `uri` (maps to `i2x:uri`)

# Variables

[Agents][] and [Deliveries][delivery] can have an endless number of variables being matched within **i2x**. Variables are available in _payload_ objects in any configuration. Variables are extracted from the [Selectors][] configured in [Agents][] and [Templates][].

## Usage

**i2x** identifies variables by matching content in property values within `%{ }`. On template processing, each variable is replaced with content from the sent payload. Variables can be included in SQL queries, URIs or request parameters. **Note** that **i2x** helper functions are also variables.

**Example**:  `%{name}` is replaced by the `name` property in the calling function parameters hash. 

</div>


[agent]:              #agents
[agents]:             #agents
[Integration]:        #integrations
[Integrations]:       #actions
[integration fields]: #integration-fields
[delivery]:           #deliveries
[deliverytemplate]:   #delivery-templates
[delivery template]:  #delivery-templates
[delivery templates]: #delivery-templates
[event]:              #events
[events]:             #events
[Field Types]:        #field-types
[polling]:            #polling
[Postman]:            #postman
[source]:             #sources
[sources]:            #sources
[STD]:                #std
[Template]:           #templates
[Templates]:          #templates
[variables]:          #variables
