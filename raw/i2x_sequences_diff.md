<div class="panel" markdown="1">
### Goal
Generate a semantic abstraction of the identified changes and store it in COEUS kb.
</div>

1. Push/Hook Diff *\*-FluxCapacitor*: The **Flux Capacitor** receives new data, pushed from the `**STD**` or hooked from  external systems
2. Check ETL *FluxCapacitor-COEUS*: The **FluxCapacitor** checks **COEUS** knowledge base for the semantic ETL templates
3. Return ETL *COEUS-FluxCapacitor*: **COEUS** returns the matching ETL templates
4. Translate *FluxCapacitor-App Engine*: The **Flux Capacitor** sends the received data and the ETL templates for the application engine
5. Return graph *App Engine-FluxCapacitor*: The application engine returns a new semantic data abstraction, generated from the translation ETL template
6. Store graph *FluxCapacitor-COEUS*: The **Flux Capacitor** stores the translated graph in **COEUS** knowledge base