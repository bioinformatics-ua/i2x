## Spotting The Differences

<a href="/i2x/images/flow_std.png" class="th">![STD](/i2x/images/flow_std_th.png)</a>

There are two ways to start a new integration task:

1. The **STD** connects to an external source (using `polling`), imports data and generates a "diff" from the previous import. The "diff" contains the new events that will be _pushed_ to the **Flux Capacitor**
2. Smaller (diff) changed portions are hooked directly (using `push`) into **Flux Capacitor** for processing

## Rule Processing

<a href="/i2x/images/flow_rules.png" class="th">![Rule processing](/i2x/images/flow_rules_th.png)</a>

With the inclusion of a semantic rules processor, we can apply complex semantic rules to validate specific conditions before and after the integration actions. This **Ruler** process works as follows:

1. External data gets into the platform using polling or push (ommitted from the diagram)
2. Data are abstracted to a semantic web environment, using configurable **ETL** rules, and storing the resulting graph in [COEUS][coeus]
3. The graph abstraction is processed in the **Ruler**, according to the rules defined for the associated actions
4. Once all defined rules are integrated, the graph is updated in [COEUS][coeus], and the action is ready for delivery

## Overview

<a href="/i2x/images/full_flow.png" class="th">![Overview](/i2x/images/full_flow.png)</a>

[coeus]:        http://bioinformatics.ua.pt/coeus/  "COEUS: Semantic Web Application Framework"