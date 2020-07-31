---
title: Analyze and Optimize Loop
titleSuffix: Azure Example Scenarios
description: An IoT pattern for the generation and application of business optimization insights based on the entire business context.
author: mcosner
ms.date: 05/04/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Analyze and Optimize Loop

## Intent

Enable the generation and application of business optimization insights
to one or more [Cyber Physical
System](https://en.wikipedia.org/wiki/Cyber-physical_system) (CPS) deployments based on the entire enterprise business context.

## Motivation

Businesses collect data from various IoT, enterprise, private and public
data sources into data lakes which will be consumed in offline analytics
for the discovery of hidden trends and business optimization insights.
These optimizations will flow back to IoT installations through Monitor
and Manage Loop (MML) and Measure and Control Loops (MCL). Analyze and
Optimize Loop (AOL) operates asynchronously and hence no tight timing
deadlines expected for sending the optimization signals to things.

Some example scenarios where Analyze and Optimize process will be
useful:

-   Smart Spaces: Compute campus safety index and take appropriate
    measures

-   Power Transmission: Correlate power outage and wildfire event trends
    to produce proactive transmission repairs and replacement of
    monitoring devices

-   Oil and Gas Production: Compute a basin's oil production trends and
    compare it with site's performance

-   Transportation and Logistics: Compute the carbon footprint trends
    and compare it with the organizational goals and take corrective
    measures

-   Solar Farm: Compute power factor of the entire wind farm operations
    and devise means to improve efficiency of each wind turbine

-   Discrete Manufacturing: increase the widget production rate of many
    plants to meet the market demands

The optimization insights from the offline analytics processes will flow
back into IoT Things on the edge through MML and MCL processes.

## Characteristics

-   **Cycle time**: this operates on async time meaning that no specific
    time duration expected for the consumption of the data and
    production and application of the insights to Things.

-   **System Dependencies**: the logic will depend on multiple systems
    to feed data through data lake which include IoT systems and feeds
    from enterprise systems like ERP, CRM, PLM and Support systems.

-   **Data dependencies**: this loop will depend on long telemetry
    history and enterprise operational data history for running batch
    jobs

-   **Optimizes IoT Operations**: the optimization insights relevant for
    IoT will flow into things through Monitor and Manage and Measure and
    Control loops

-   **Network protocols**: the optimization loop primarily integrates
    with supervisory systems and other enterprise systems through web
    service protocols

## Structure

![An Analyze and Optimize Loop, shown in context with Measure and Control and Monitor and Manage Loops.](./media/analyze-optimize-loop.png)

Analyze and Optimize Loop (AOL) sources telemetry typically from Monitor
and Manage process, refines it and combines it with the enterprise data
sources to generate insights. The following picture shows the schematic
of a typical AOL loop and its relationships with the rest of the IoT
process loops.

The important components of business optimization control are discussed
below.

**Data Lake** is a large-scale storage optimized for lower cost of usage
over a longer period; HDFS storage in the context of map-reduce
processing is an example of such a data lake. Data lake defers the
structure of the data to the processing time and hence friendlier to
store both structured and unstructured data.

**Cold Time Series Data** is the raw and/or processed telemetry deemed
to be important for offline analytics and often sourced from multiple
IoT systems. This data will be further refined and combined with
enterprise as well external data sets to execute analytics jobs.

**Enterprise Data** is a class of data that is produced by enterprise
systems which include Product lifecycle Management, supply chain,
finance, sales, manufacturing and distribution, and customer
relationship management. The data from these systems may be combined
with external data sets (e. g. weather) to contextualize IoT operational
telemetry at appropriate business scope for generating compatible
insights.

**Offline Analytics** is a type of analytics performed on Big Data in a
batch mode; Spark jobs and Hadoop map-reduce processing are a couple of
such examples. The insights produced form offline analytics will be
applied to IoT things through supervisory and regulatory control loops.

## Examples

-   Compute campus safety index and take appropriate measures

-   Correlate power outage and wildfire event trends to produce
    proactive transmission repairs and replacement of monitoring devices

-   Compute a basin's oil production trends and compare it with site's
    performance

-   Compute the carbon footprint trends and compare it with the
    organizational goals and take corrective measures

-   Compute power factor of the entire wind farm operations and devise
    means to improve efficiency of each wind turbine

## Implementation

Note: give pointers to implementations or some concise inline code
examples if it makes sense.
