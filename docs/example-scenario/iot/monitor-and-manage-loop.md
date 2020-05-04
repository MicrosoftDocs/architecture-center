---
title: Monitor and Manage Loop
titleSuffix: Azure Example Scenarios
description: A pattern for continually monitoring networked Things to ensure it remains within tolerance.
author: mcosner
ms.date: 05/04/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---

# Monitor and Manage Loop

## Intent

A [Cyber Physical
System](https://en.wikipedia.org/wiki/Cyber-physical_system) (CPS),
composed of multiple networked Things, is continually monitored to make
sure it is within the tolerable range of the desired state setpoint
configuration.

## Motivation

Multiple Things inside a CPS system needs to act in concert to achieve
and stay within the tolerable range of the desired state. The Monitor
and Manage Loop (MML) observes telemetry emitted by multiple Things,
correlates, combines with external inputs and computes new insights.
These insights are then pushed through rules engine to arrive at the
actions that will result in setpoint changes and imperative actions
against the relevant Things.

The following are instances of Monitor and Manage Loop in action:

-   Smart Garbage Collection: direct the truck to the route that has the
    most need for garbage collection.

-   Smart Campus: Issue campus evacuation alert upon fire detection in
    multiple buildings

-   Power Distribution: Proactively shutdown the power to the multiple
    city blocks based on the high wind and rain forecast

-   Gas Pipeline Monitoring: Shutdown the gas pumping station upon
    sensing pressure drops at multiple segments in a remote pipeline

-   Smart Meters: Utility company monitors power consumption and
    combines it with weather forecast to automatically raise the
    setpoint of the home thermostats as a part of a program that gives
    discounts to frugal power consumers

-   Wind Farm: upon noticing power factor drop in a wind farm, the
    monitoring systems schedules the inspection of the suspect wind
    turbines

-   Process Industries: monitor and control crude oil cracking process
    in an oil refinery, monitor and control paints and bulk chemical
    manufacturing

-   Discrete Manufacturing: monitor and control widget inspection and
    packaging cell

## Characteristics

-   **Deployment**: Monitor and Manage Loop (MML) may be deployed closer
    to the premise in case of process industries like oil refining and
    chemical manufacturing. Similarly, discreate manufacturing may also
    deploy MML locally as network downtime can cost the company in terms
    of production schedules. Those premises that are remote by nature
    (e. g. remote oil and gas pipelines, remote power transformers,
    smart door bells, hazardous environment monitoring sensors, asset
    trackers) can\'t accommodate the infrastructure needed by MML loops
    and hence MML operates from remote facilities like public or private
    clouds.

-   **Cycle Time**: depending on the IoT scenario, this may be a few
    seconds (e. g. \< 3 sec); the network jitter is expected due to the
    usage of non-time sensitive network protocols like MQTT, HTTP and
    AMQP.

-   **Autonomy**: the control logic will depend on multiple Measure and
    Control loops for the core monitoring and management process to
    work. The system may be integrated with other enterprise systems
    like ERP, CRM, PLM and Support systems to contextualize the
    operations. However, failures to these systems shouldn't take down a
    Monitor and Manage loop.

-   **Inputs**: this loop will consume sensor telemetry stream and
    contribute to last known Thing state, hot time series cache, warm
    time series history and aggregate rollups.

-   **Outputs**: produces supervisory commands back to things upon
    detection of conditions that need to be corrected. This loop also
    computes dependent thing states as well as event feeds for external
    systems.

-   **Networking**: the supervisory loop primarily integrates with
    things and enterprise systems over HTTP, MQTT and AMQP.

## Structure

![Monitor and Manage Loop](./media/monitor-manage-loop.png)

Monitor and Manage Loop (MML) in IoT is a supervisory system that
ensures that the Cyber Physical System operates within the confines of
the operational thresholds. Example thresholds include the widget
production rate in a discrete manufacturing cell, power generation rate
in a small wind farm, or gas flow rate in a natural gas pipeline. MML
logic takes the perspectives of multiple things into consideration for
deducing the current state. This involves the correlation of hot
telemetry signal trends from multiple things and combine them with
previously known warm time series history and enterprise system
operational signals to generate actuator commands or create alarms. The
components of MML in detail are described below:

Supervisory systems often are located remotely from the actual Things
that represent the physical environment; the things emit timestamped
telemetry using IoT protocols like HTTP, MQTT or AMQP through **Message
Broker**. The telemetry is processed by supervisory system and sends
commands to Things through Messaging Broker to adjust the CPS to be
around the desired sate in the event of a detected deviation. Important
components of the supervisory control system are described below.

**Thing Registry** is the system of record (aka single truth) for all
IoT things; it stores metadata about things as well the relationships
among them. The information in the registry is used by Telemetry Stream
Processor for understanding telemetry message structure as well as parse
and execute stream processing logic. Thing Registry will be used by
Message Broker for validating device connection requests as well as for
message routing decisions. The event computation and handling logic will
use the entity metadata to ensure that inputs, outputs and the
processing logic conforms to the structural as well as semantic
relationships of the entities and their interactions.

**Telemetry Stream Processor** (TSP) receives Thing telemetry and
deduces the current state of individual things as well as the state of
the correlated set of things to detect errors as well as deviations from
the desired state. The error conditions, aggregated data points as well
as raw data points, if needed, will be sent to event handling,
appropriate hot and warm storage for further processing as well as
record keeping.

**Hot Time Series History** is a high-speed storage (in-memory or remote
cache) for accessing Last Known State (LKS) of Thing metrics as well as
for storing a set of data points for detecting near real time trends.

**Warm Time Series History** storage is meant for storing a few weeks\'
worth of data points to help with correlation of near real time trends
with long term trends to sense potential deviations from the desired
state. The trends may be pre-computed and made available through indexed
storage not shown.

**Event Computation** will combine events from stream processor, last
known state of things, near real-time trends from hot time series and if
needed, correlates with warm time series to compute actionable business
events.

**Rules Engine** will consume the business events and handles them by
adjusting the things\' desired state through appropriate commands. The
rules engine may also publish events and alarms to the **Monitoring
Console** for visual display as well as human intervention if need be.

## Implementation

Implement Monitor and Manage Loop at the edge (link to be provided)

Implement Monitor and Manage Loop at remote location (link to be
provided)
