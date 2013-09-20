## STD: Spot The Differences
- change detection engine
- connects to external resources (according to preconfigured settings), and detects what has changed since the last successful integration

## Ruler
- backward chaining and forward changing rule processor for events
- rules are semantic based
- samples
	- regular expression matching
	- backward chaining
		- pre conditions asserts
	- forward chaining
		- post conditions asserts
	- infer on semantic context
		- p1 > p2
		- p1 + p2 > 10
- reads rules from COEUS

## Flux Capacitor
- controls everything
- open door for receiving data for delivery
	- can receive from web hooks
	- can receive from event detector

## COEUS KB
- the knowledge base
- store
	- rules
	- temporary semantic storage
		- for diffs
	- templates

## Log
- logs everything
	- Sentry?

## Postman
- processes delivery actions
	- sends transformed data to destination
- template-based
	- SQL query
	- XML file
	- REST call
	- system call
	- mail call
	- ...