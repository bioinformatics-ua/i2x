<div class="panel" markdown="1">
### Goal
Check configured data sources for changes in content from the previous integration.
</div>

1. Pool Content *STD-Origin Resource*: connect to external data source and load content
	- Data can be loaded from delimited files, structured files, LinkedData interfaces and SQL/SPARQL endpoints
2. Return Content *Origin Resource-STD*: The origin data source returns with the requested content
3. Check Changes *STD-COEUS*: The **STD** imports the data into the internal content store and check if there have been any changes since the last update (the diff)
	- External content is processed from the initial queries in a COEUS-like approach: `XPath`, `JSONPath`, `SQL` or `SPARQL` variables, `column` numbers…
4. Return Diff *COEUS-STD*: The application analyses the newly submitted content and returns a diff with the unique new content
5. Push Diff *STD-FluxCapacitor*: If new content was actually found, it is sent to **FluxCapacitor** for processing
	- The **FluxCapactior** can receive every and any format for further processing, meaning that it can be a service hook for external systems supporting this paradigm