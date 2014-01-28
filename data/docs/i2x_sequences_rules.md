<div class="panel" markdown="1">
### Goal
Verify if integration task has validation rules and apply them.
</div>

1. Get Graph *FluxCapacitor-COEUS*: Load the action graph for processing from **COEUS**
2. Return Graph *COEUS-FluxCapacitor*: the **Flux Capacitor** receives the unique action graph for rule processing
3. Get Rules *FluxCapacitor-COEUS*: the **Flux Capacitor** gets the action integration rules from **COEUS**
4. Return Matching Rules *COEUS-Flux Capacitor*: **COEUS** returns the matching rules, if existing
5. Process Graph *Flux Capacitor-Ruler*: Apply matched rules to action/task graph
	- precondition rules: performs operations before data forward
	- postcondition rules: adds post-forward operations to pending list
	- regex: only forwards if regex match
	- complex: only forwards if complex (<, >, LIKE, =, !=)
6. Forward Graph *Flux Capacitor-Postman*: send (final) processed graph to Postman for delivery