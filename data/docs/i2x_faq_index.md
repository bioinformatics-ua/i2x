<aside class="large-4 columns" markdown="1" style="position:fixed;font-size:80%;">

##### Outline
{:.no_toc}

* TOC
{:toc}

</aside>

<!-- [TOC] for Python markdown parser -->

 <div class="large-8 columns" role="content"  markdown="1">

# What is i2x?

**i2x** is a data integration framework, targeting the automated real-time integration of data from heterogeneous resources to multiple destinations. **i2x** provides pure Integration-as-a-Service, acting as an _intelligent ETL proxy_ between distinct services.

<hr>

# How does i2x work?

**i2x** relies on distributed agents to monitor custom content changes. When new changes are detected, **i2x** generates a new [Event][] and triggers the execution of any number of [templates][] associated with the starting [agent][] (through integrations).

<hr>

# What are agents?

[Agents][] are intelligent algorithms that monitor configured data sources, detecting changes to their content. [Agents][] can run on **i2x**'s' server or locally, in a truly distributed environment.

<hr>

# What are templates?

[Templates][] are used to define what to do data with the data points gathered by the [agents][]. This can go from updating a file in your Dropbox account to sending custom emails.

<hr>

# What are integrations?

Putting it simply, [Integrations][] connect [agents][] with [templates][]. Hence, [integrations][] are the logical bridge between the distributed monitored [sources][] and the actions triggered by content changes.
<hr>

</div>

[agent]:        /docs/#agents
[agents]:       /docs/#agents
[event]:        /docs/#events
[templates]:    /docs/#templates
[template]:     /docs/#templates
[integrations]: /docs/#integrations
[integration]:  /docs/#integrations
[sources]:      /docs/#sources