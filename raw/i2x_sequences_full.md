# Sequence Diagrams

## Check Content Changes

##### Goal
Check configured data sources for changes in content from the previous integration.

1. Pool Content *STD-DataSource*: connect to external Data Source and load content
	- Data can be loaded from CSV, XMl or JSON files, or from SQL or SPARQL query results (COEUS-like)
2. Return Content *DataSource-STD*: The Data Source returns with the requested content
3. Check Changes *STD-ContentStore*: The STD imports the data into the internal Content Store and check if there have been any changes since the last update (the diff)
	- External content is processes from the initial queries in a COEUS-like approach: XPath, JSONPath, SQL variables, column numbers…
4. Return Diff *ContentStore-STD*: The ContentStore analyses the newly submitted content and returns a diff with the unique new content
5. Push Diff *STD-FluxCapacitor*: If new content was actually found, it is sent to Flux Capacitor for processing
	- The FluxCapactior can receive every and any format for further processing, meaning that it can be a service hook for external systems supporting this paradigm

## Translate Diff to COEUS kb

##### Goal
Generate a semantic abstraction of the identified changes and store it in COEUS kb.

1. Push/Hook Diff *\*-FluxCapacitor*: The Flux Capacitor receives new data, pushed from the STD or hooked other external systems
2. Check ETL *FluxCapacitor-COEUS*: The FC checks COEUS knowledge base for the semantic ETL templates
3. Return ETL *COEUS-FluxCapacitor*: COEUS returns the matching ETL templates
4. Translate *FluxCapacitor-Translator*: The Flux Capacitor sends the received data and the ETL templates for the Translator
	- Translator is the translation engine, similar to COEUS'
5. Return graph *Translator-FluxCapacitor*: The Translator returns a new semantic data abstraction, generated from the translation ETL template
6. Store graph *FluxCapacitor-COEUS*: The Flux Capacitor stores the translated graph in COEUS kb

## Apply Integration Rules

##### Goal
Verify if integration task has validation rules and apply them.

1. Get Graph *FluxCapacitor-COEUS*: Load the action graph for processing from COEUS
2. Return Graph *COEUS-FluxCapacitor*: the Flux Capacitor receives the unique action graph for rule processing
3. Get Rules *FluxCapacitor-COEUS*: the Flux Capacitor gets the action integration rules form COEUS
4. Return Matching Rules *COEUS-Flux Capacitor*: COEUS returns the matching rules, if existing
5. Process Graph *Flux Capacitor-Ruler*: Apply matched rules to action/task graph
	- precondition rules: performs operations before data forward
	- postcondition rules: adds post-forward operations to pending list
	- regex: only forwards if regex match
	- complex: only forwards if complex (<, >, LIKE, =, !=)
6. Forward Graph *Flux Capacitor-Forwarder*: send (final) processed graph to the Forwarder for delivery

## Apply Worker Template

##### Goal
Check final delivery template and use semantic abstraction data to generate final action.

1. Forward Graph *Flux Capacitor-Forwarder*: send a graph for processing to the Forwarder
2. Get Template *Forwarder-COEUS*: check COEUS kb for final delivery template
3. Return Template *COEUS-Forwarder*: return the final delivery template to be applied to the graph
4. Process Graph *Flux Capacitor-Worker*: use graph data to fill in the delivery template, and execute associated action
5. Return status *Worker-Flux Capacitor*: return the execution status

## i2x Sequence Diagram

##### Goal
Integrate everything.

1. Pool Content *STD-DataSource*: connect to external Data Source and load content
	- Data can be loaded from CSV, XMl or JSON files, or from SQL or SPARQL query results (COEUS-like)
2. Return Content *DataSource-STD*: The Data Source returns with the requested content
3. Check Changes *STD-ContentStore*: The STD imports the data into the internal Content Store and check if there have been any changes since the last update (the diff)
	- External content is processes from the initial queries in a COEUS-like approach: XPath, JSONPath, SQL variables, column numbers…
4. Return Diff *ContentStore-STD*: The ContentStore analyses the newly submitted content and returns a diff with the unique new content
5. Push/Hook Diff *\*-FluxCapacitor*: The Flux Capacitor receives new data, pushed from the STD or hooked other external systems
6. Check ETL *FluxCapacitor-COEUS*: The FC checks COEUS knowledge base for the semantic ETL templates
7. Return ETL *COEUS-FluxCapacitor*: COEUS returns the matching ETL templates
8. Translate *FluxCapacitor-Translator*: The Flux Capacitor sends the received data and the ETL templates for the Translator
	- Translator is the translation engine, similar to COEUS'
9. Return graph *Translator-FluxCapacitor*: The Translator returns a new semantic data abstraction, generated from the translation ETL template
10. Store graph *FluxCapacitor-COEUS*: The Flux Capacitor stores the translated graph in COEUS kb
11. Get Graph *FluxCapacitor-COEUS*: Load the action graph for processing from COEUS
12. Return Graph *COEUS-FluxCapacitor*: the Flux Capacitor receives the unique action graph for rule processing
13. Get Rules *FluxCapacitor-COEUS*: the Flux Capacitor gets the action integration rules form COEUS
14. Return Matching Rules *COEUS-Flux Capacitor*: COEUS returns the matching rules, if existing
15. Process & Forward Graph *Flux Capacitor-Ruler-Forwarder*: Apply matched rules to action/task graph. When applied, send to forwarder. Rules:
	- precondition rules: performs operations before data forward
	- postcondition rules: adds post-forward operations to pending list
	- regex: only forwards if regex match
	- complex: only forwards if complex (<, >, LIKE, =, !=)
16. Get Template *Forwarder-COEUS*: check COEUS kb for final delivery template
17. Return Template *COEUS-Forwarder*: return the final delivery template to be applied to the graph
18. Process Graph *Flux Capacitor-Worker*: use graph data to fill in the delivery template, and execute associated action
19. Return status *Worker-Flux Capacitor*: return the execution status
