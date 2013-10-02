<aside class="large-3 columns" markdown="1">

##### Outline
{:.no_toc}

* TOC
{:toc}

</aside>

<!-- [TOC] for Python markdown parser -->

 <div class="large-9 columns" role="content"  markdown="1">
# Actions

Actions represent what the users are trying to achieve:
- Add metadata to index (Ex: Dicoogle)
- Add new data to database (Ex: WAVe)
- Create issue (Ex: Redmine)

You can think of Actions as POSTs, writes, query executions, or the creation of a resource. **Actions** are performed by the [Postman](#Postman) using the specified [delivery template][].

## Metadata

### Label

This is a human readable label a user would see when browsing the directory and adding your service. Make it short but descriptive.

**Example**: *Create issue*, *Add variant* or *Index document*

### Key

This is a field only really used internally for both prefill and scripting references. Needs to be at least 2 characters long, start with an alpha, and only contain a-z, A-Z, 0-9 or _.

**Example**: *create_issue*, *add_variant* or *index*

### Help Text

This is some human-readable explanatory text, usually something that clarifies what the action does.

**Example**: *Adds a new variant to the configured database*.

## Related

- Postman
- Delivery Template

# Action Fields

Action Fields answer the question: What details can a user provide when creating an Action? These are the fields available in for customization in the [delivery template][]. These are things like:

- Title  (EG: Issue Title in Redmine)
- Description  (EG: Issue Description from Github)
- Parent Object  (span relationships via prefill)
- Variant Description  (EG: HGVS description)

**Note**: each action should have at least one action field. It really makes no sense to send no custom data to the delivery template.

## Metadata

### Key

A key for consumption in the Delivery Templates. This is available for variable syntax in the Delivery Template. Needs to be at least 2 characters long, start with an alpha, and only contain a-z, A-Z, 0-9 or _.
We'll take double underscores and convert them to nested dictionaries before execution.

**Example**: *room* or *project__title*  (converts to *{"project": {"title": "some value"} }*)

### Label

A human readable Label shown in the UI as a user works to complete an Action.

**Example**: *Variant* or *Title*

### Help Text

Human readable description of an action field, useful for describing some detail you couldn't list in the Label.

*Example*: *Choose which room to send the message to.* or *Add a title to the note.*

### Default

A default value that is preloaded in the execution if no values are obtained for Action execution.

### Type

The type we will try to coerce to on the backend. Fails silently to ensure that Actions aren't dropped on coercion errors.
You can get a full list of supported types and the coercions implied here: [Field Types][].

### Required

If checked a user will not be able to continue without entering some value.

### Choices

A comma separated string that will be turned into a select field for limiting the choices a user can provide to an action field.

**Example**: *choice_a,choice_b,choice_c* or *Yesterday, Today, Tomorrow*

# Deliveries

**Deliveries** are associated with [Actions][] and define what will be executed by the [Postman][].

# Delivery Templates

Programmatically, each **Delivery Template** is a set of key/value pairs describing the associated [delivery][deliveries].

## Metadata

### Identifier

A key for consumption by the [Postman][]. Needs to be at least 2 characters long, start with an alpha, and only contain a-z, A-Z, 0-9 or _.

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

### Type

The type of Action that will be delivered by the Postman.

**Available Types**: *url*, *sql*, *sparql*, *mail*, *file*, *json*...

**Property**: `type`  (maps to `dc:type`)

### Variables

An array containing all the variables that will be replaced by the integration Action data.

**Example**: *["id","subject"]* or *["title","key"]*

**Property**: `variables` (maps to `i2x:variable` set)

### Payload

Object containing the set of properties specific to each [delivery][delivery] type.

**Example**: *{"id":"%{id}","subject":"%{subject}"}* or *{"title":"%{title}","key":"%{key}"}*

**Property**: `payload` (related to `i2x:payload` object)

## Sample

Sample configuration for exchanged data between the application controller and the [Actions][actions]. Each [Deliverable Template][deliverabletemplate] type will have its own set of configuration properties, defined in the object payload.

    {
      "type": "url",
      "identifier": "i2x",
      "title": "label",
      "payload": {
        "url": "http://www.example.com",
        "method": "post"
        ...
      }
    }

# Delivery Types

[Delivery Templates] have one (and only one) type. This defines what processing is required by in the [Postman][postman] engine for successful delivery of the data. Variables in each template are marked within `%{ }` characters.

## Email

Note that emails are sent from the server configured in **i2x**'s Rails settings.

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

### Metadata

#### Content

Template for the content being written to the selected file.

**Example**: *%{id},%{i2x.datetime}\n*

**Property**: `content` (maps to `i2x:content`)

#### Method

Defines what is the type of the change that will be performed in the file by the [Postman][postman].

**Example**: *append*, *create*, *delete*

**Property**: `method` (maps to `i2x:method`)

##### Append

The _append_ method will add the content (from the property `content`) to the specified file.

##### Create

The _create_ method will create a new file with the generated content (from the property `content`).

#### URI

The file URI. Not that filenames can include _variables_.

**Example**: *file://Temp/log.csv*

**Property**: `uri` (mas to `i2x:uri`)

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

Database name where the query will be performed. This value defaults to the [delivery template][deliverytemplate] key if no data is provided.

**Example**: *wave10*, *issues*

**Property**: `database` (maps to `i2x:database`)

#### Username

Database user.

**Example**: *john_doe*

**Property**: `username` (maps to `i2x:username`)

#### Password

User password. The password is hashed before being exchanged between any service.

**Example**: *qwerty§12345*

**Property**: `password` (maps to `i2x:password`)

#### Query

The query that will be executed by the [Postman][postman] in the configured database. 

**Example**: *INSERT INTO issues (title, description, timestamp) VALUES ('{%title}, '%{description}', getdate());*

**Property**: `query` (maps to `i2x:server`)

## URL Route

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

**Property**: `uri` (mas to `i2x:uri`)

# Events

**Events** are occurrences of specific conditions that will trigger an [Action](#actions). i2x events can be registered when:

- New issue  (Ex: GitHub)
- New row in table (Ex: WAVe)
- New image in index (Ex: Dicoogle)

You can think of an Event as the ignition of a new data integration Action.

Basically, they're things that happen in monitored systems which cause a defined action to happen. Additionally, events supply data about what happened. These data will be passed on to the Actions controller, which validates them and moves them to the Postman for execution in the [Delivery Template][deliverytemplate].

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

The traditional workflow uses the [STD][std] to detect new [events][events]. However, [events][events] can be pushed in the system using the Web/REST hooks interface. In this case, the hook payload is directly proxied to the [Action][actions] in the `payload` object.

# Field Types

The following is a list of available field types. Normally, you'd choose one of these fields when creating your action fields or trigger fields via the type dropdown.

- Unicode `unicode`: Unicode fields are essentially one-line text fields that can support unicode characters. There is no coercion done for this type.
- Text `text`: Think of this as a multi-line unicode field. It's really only used to give the user a textare in the UI instead of a one-line input field. There is no coercion done for this type.
- Integer `int`: Suitable for whole integer numbers, we'll coerce any text down into an integer by stripped non-numeric values from the string. A negative sign (-) in front is also allowed.
- Float `float`: Like integers, this will coerce any text down to a floating point number with the addition of allowed characters like . and ,.
- Boolean `bool`: We apply some natural language parsing to try and coerce any text into True or False. This UI field is also replaced with a dropdown allowing the user to specifically pick "Yes" or "No" explicitly.
- DateTime `datetime`: Our most complex coersion. We'll attempt to convert any given date format into an internal DateTime representation. It is quite robust supporting epoch timestamps, ISO-8061 and even natural language parsing! On the developer platform, datetimes are automatically converted into an ISO-8061 datetime for actions. You can use moment.js via the Scripting API to parse and replace if your servers expect a different format sent to it. |

## Choices

You can provide a choices array which will be mapped automatically into a valiation list for execution:

    [
      {
        "type": "unicode",
        "key": "color",
        "label": "Label",
        "help_text": "Pick a color label to apply to the card.",
        "choices": ["none", "green", "yellow", "orange", "red", "purple", "blue"]
      }
    ]

# Helper Functions

**i2x** included several internal functions allowing quick access to general variables that can be used in all templates. These functions allow the templates to retrieve information such as date/time, random numbers or strings, action names, among many others.

## Usage

**i2x** helper functions are used just like the template variables. These reserved variable keywords start are written as `i2x._function name_`.

## Function list

* `date`: returns the system date
* `datetime`: returns the system date with time included (until _ms_)
* `action_identifier`: returns the ongoing action identifier
* `template_identifier`: returns the ongoing delivery template
* `environment`: returns the server execution environment (from Rails)
* `hostname`: returns the postman server hostname

# Monitor Types

## Delimited File

**STD** monitors delimited files accessible through a valid URI (`http://`, `ftp://`, `file://`). These files can have any number of columns delimited by common data exchange delimiters (`;`,`,`,`:`,`|`,`\t`). If an `id` column is configured, the change detection is performed using simple identifier matching: if the `id` has not been seen yet, it is sent for integration. If no `id` column is setup, the **STD** performs a hashing function over the entire row content. In this case, the resulting `hash` is matched against the list of already integrated rows.

## Database

**STD** can be configured to monitor a database. In this scenario, a _SELECT_ query must be configured to access the database, retrieving the list of values that are being monitored. If an `id` column is configured, the change detection is performed using simple identifier matching: if the `id` has not been seen yet, it is sent for integration. If no `id` column is setup, the **STD** performs a hashing function over the entire row content. In this case, the resulting `hash` is matched against the list of already integrated rows. **Note** that there is forced a query limit of 1000 rows.

## LinkedData

STD can be used to monitor LinkedData URIs. These must be publicly resolveable addresses and must respond properly to `Accept Encoding` headers, according [to the LinkedData principles][linkeddata]. With LinkedData monitors, STD checks all `predicates` described in the URI response. If any new predicate is detected or if a predicate object has changed, STD will generate a new event.

## SPARQL Endpoint

## Structured File

**STD** can monitor structured files for more complex data exchange scenarios. Structured files are accessible through a valid URI (`http://`, `ftp://`, `file://`) and their content must be valid XML or JSON. Monitored data are configured through XPath or JSONPath queries. If an `id` query is configured, the change detection is performed using simple identifier matching: if the `id` has not been seen yet, it is sent for integration. If no `id` query is setup, the **STD** performs a hashing function over the entire processed query response content. In this case, the resulting `hash` is matched against the list of already integrated results.

# Polling

Polling is the process of repeatedly hitting the same endpoint looking for new data. Unfortunately, i2x uses the **STD** to do this. We don't like doing this (its wasteful), vendors don't like us doing it (again, its wasteful) and users dislike it (they have to wait a maximum interval to detect new events). However, it is the one method that is ubiquitous, so we support it.

It is also closely tied into how i2x handles deduplication.

A more modern approach uses Web/REST hooks. This way, services can push data into i2x, which reduces the application load.

# Postman

Handles the final step of the [actions][]: gets the [action fields][] and applies them to the [delivery template][] for execution.

# Sources

**Sources** setup the location of external content for event detection. The [STD][] uses a [polling][] process to identify new [events][] in monitored resources. There a few changes tough, URL Routes can only be GET and SQL queries must contain a SELECT statement.

# Source Templates

**Source Templates** are akin to [delivery templates](#deliverytemplates). They define how to poll the [sources][] being monitored.

## Metadata

### Key

A key for consumption by the Postman. Needs to be at least 2 characters long, start with an alpha, and only contain a-z, A-Z, 0-9 or _.

**Example**: *mapper* or *isse*

### Label

A human readable Label shown in the UI as a user works to complete an Action.

**Example**: *Variant* or *Title*

### Help Text

Human readable description of an action field, useful for describing some detail you couldn't list in the Label.

*Example*: *Choose which room to send the message to.* or *Add a title to the note.*

### Type

The type of [Action][] that will be executed for monitoring by the [STD][].

**Available Types**: *url*, *sql*, *sparql*, *mail*, *file*...

## Sample

Sample configuration for exchanged data between the application controller and the [Actions][]. Each [Delivery Template][] type will have its own set of configuration properties, defined in the object payload.

    {
      "type": "url",
      "key": "i2x",
      "label": "label",
      "id": "123",
      "template": {
        "url": "http://www.example.com",
        "method": "get"
        "path": "/home/this"
      }
    }

# STD: Spot The Differences

The **STD** engine will perform the [polling][] of configured [sources][]. Spot the Differences monitors specified resources looking for changes in the output content. **STD**'s algorithm identifies what has changed since the last visit to a data source (using hashes and id matching). When content changes are detected, the **STD** triggers a new event. **Events** will then be processed through configured **i2x** integration ruless. In the system, detected events are sent for processing to the Flux Capacitor.
</div>



[Action]:             #actions
[Actions]:            #actions
[action fields]:      #action-fields
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
[variables]:          #variables
