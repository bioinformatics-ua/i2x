<div class="panel" markdown="1">
### Goal
Integrate everything.
</div>

1. Pool Content *STD-Origin Resource*: connect to external data source and load content
	- Data can be loaded from CSV, XMl or JSON files, or from SQL or SPARQL query results (COEUS-like)
2. Return Content *Origin Resource-STD*: The Data Source returns with the requested content
3. Check Changes *STD-ContentStore*: The STD imports the data into the internal Content Store and check if there have been any changes since the last update (the diff)
	- External content is processes from the initial queries in a COEUS-like approach: XPath, JSONPath, SQL variables, column numbers…
4. Return Diff *ContentStore-STD*: The ContentStore analyses the newly submitted content and returns a diff with the unique new content
5. Push/Hook Diff *\*-FluxCapacitor*: The Flux Capacitor receives new data, pushed from the STD or hooked other external systems
6. Check ETL *FluxCapacitor-COEUS*: The FC checks COEUS knowledge base for the semantic ETL templates
7. Return ETL *COEUS-FluxCapacitor*: COEUS returns the matching ETL templates
8. Translate *FluxCapacitor-App Engine*: The Flux Capacitor sends the received data and the ETL templates for the App Engine
	- App Engine is the translation engine, similar to COEUS'
9. Return graph *App Engine-FluxCapacitor*: The App Engine returns a new semantic data abstraction, generated from the translation ETL template
10. Store graph *FluxCapacitor-COEUS*: The Flux Capacitor stores the translated graph in COEUS kb
11. Get Graph *FluxCapacitor-COEUS*: Load the action graph for processing from COEUS
12. Return Graph *COEUS-FluxCapacitor*: the Flux Capacitor receives the unique action graph for rule processing
13. Get Rules *FluxCapacitor-COEUS*: the Flux Capacitor gets the action integration rules form COEUS
14. Return Matching Rules *COEUS-Flux Capacitor*: COEUS returns the matching rules, if existing
15. Process & Forward Graph *Flux Capacitor-Ruler-Postman*: Apply matched rules to action/task graph. When applied, send to Postman. Rules:
	- precondition rules: performs operations before data forward
	- postcondition rules: adds post-forward operations to pending list
	- regex: only forwards if regex match
	- complex: only forwards if complex (<, >, LIKE, =, !=)
16. Get Template *Postman-COEUS*: check COEUS kb for final delivery template
17. Return Template *COEUS-Postman*: return the final delivery template to be applied to the graph
18. Process Graph *Flux Capacitor-App Engine*: use graph data to fill in the delivery template, and execute associated action
19. Return status *App Engine-Flux Capacitor*: return the execution status
