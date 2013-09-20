## Spotting The Differences

<a href="/images/std.png" class="th">![STD](/images/std.png)</a>

There are two ways to start a new integration task:

1. The STD connects to an external source, imports the data and generates a "diff" from the previous import, pushing it to the Flux Capacitor
2. Smaller (diff) changed portions are hooked directly into Flux Capacitor for processing

## General rule processing overview

<a href="/images/rules_flow.png" class="th">![Rule processing](/images/rules_flow.png)</a>

With the inclusion of a semantic rules processor, the idea is to apply complex semantics to validate specific conditions before, during and after the integration task. This Ruler process works as follows:

1. Data gets into the platform for processing (hook/push diff data)
2. Data are abstracted to a semantic web environment, using custom ETL rules, and storing the graph in COEUS
3. The graph abstraction is sent for rule processing, assessing specific components of the graph
4. Once all defined rules pass, the integration is ready for delivery

## Overview

<a href="/images/full_flow.png" class="th">![Overview](/images/full_flow.png)</a>