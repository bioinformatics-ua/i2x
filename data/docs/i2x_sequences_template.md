<div class="panel" markdown="1">
### Goal
Check final delivery template and use semantic abstraction data to generate final action.
</div>

1. Forward Graph *Flux Capacitor-Postman*: send a graph for processing to **Postman**
2. Get Template *Postman-COEUS*: check **COEUS** knowledge base for final delivery template
3. Return Template *COEUS-Postman*: return the final delivery template to be applied to the graph
4. Process Graph *Flux Capacitor-App Engine*: use graph data to fill in the delivery template, and execute associated action
5. Return status *App Engine-Flux Capacitor*: return the execution status