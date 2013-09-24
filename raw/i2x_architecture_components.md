<aside class="large-3 columns" markdown="1">

##### Outline
{:.no_toc}

* TOC
{:toc}

</aside>

 <div class="large-9 columns" role="content"  markdown="1">

## COEUS

### Description

[COEUS][coeus] is an application framework designed to enhance the quick creation of new semantic web information systems. i2x uses [COEUS][coeus]' comprehensive semantic triplestore at its backend, allowing the persistence of all relevant data in semantic formats and enabling the semantic rule processing features. [COEUS][coeus], along with the [Log](#log), store all relevant data and metadata of everything that happens within the i2x platform.

### Features

- the knowledge base
- store
	- rules
	- temporary semantic storage
		- for diffs
	- templates

## Flux Capacitor

### Description

The **Flux Capacitor** is the main application controller, registering and proxying everything that happens within the **i2x** platform. With all components deployed independently, the **Flux Capacitor** acts as a glue, to keep all pieces together, and as a flow manager, ensuring that everything operation is performed smoothly, from event detection to the final delivery.

### Features

- controls everything
- open door for receiving data for delivery
	- can receive from web hooks
	- can receive from event detector

## Log

### Description

The **Log** stores summary information for all actions and flows occurring within the i2x platform. Each log entry contains the minimal set of information required to reenact specific transactions or errors. This includes timestamps, origin/destination and the messages sent.

### Features

- logs everything
	- Sentry?

## Postman

### Description

The **Postman**, as implied by its naming, performs the final delivery of each action. That is, it handles the final step of the [actions][]: gets the [action fields][] and applies them to the [delivery template][] for execution. The **Postman** exposes a RESThook interface that can be directly POSTed with data for processing (as long as the POST `payload` matches the selected action `key`.

### Features

- processes delivery actions
	- sends transformed data to destination
- template-based
	- SQL query
	- XML file
	- REST call
	- system call
	- mail call
	- ...

## Ruler

### Description

**Ruler** is a semantic rule processing engine. This tool allows the definition of multiple processing rules, which can be applied to Events metadata. Configured rules can be of two types: _1)_ pre conditions and _2)_ post conditions. Preconditions are applied to Events metatadata before delivery, these include asserts or data transformations. Post conditions are applied to event metadata after delivery, these can be other actions or further logging operations. 
Rule processing uses a semantic engine, where new results can be inferred from existing data. Inference can from simple sums to complex axiom processing.

### Features 

- rules are semantic based
- samples
	- regular expression matching
	- pre conditions asserts
	- post conditions asserts
		- forward chaining
	- infer on semantic context
		- p1 > p2
		- p1 + p2 > 10
		- reasoning and inference
- reads rules from COEUS

## STD: Spot The Differences

### Description

**Spot the Differences** monitors specified resources looking for changes in the output content. **STD**'s algorithm identifies what has changed since the last visit to a data source (using hashes and id matching). When content changes are detected, the **STD** triggers a new event. **Events** will then be processed through configured **i2x** integration ruless. In the system, detected events are sent for processing to the Flux Capacitor.

### Features

- change detection engine
- connects to external resources (according to preconfigured settings), and detects what has changed since the last successful integration

</div>


[LinkedData]:	http://linkeddata.org 				"LinkedData"
[coeus]:		http://bioinformatics.ua.pt/coeus/	"COEUS: Semantic Web Application Framework"
