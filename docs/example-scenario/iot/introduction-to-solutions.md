---
title: Introduction to Azure IoT solutions
titleSuffix: Azure Example Scenarios
description: An introduction to building solutions using Microsoft Azure Internet of Things (IoT) services.
author: wamachine
ms.date: 08/01/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Overview of IoT solutions

Connected sensors, devices, and intelligent operations can transform businesses and enable new growth opportunities with [Azure Internet of Things (IoT)](https://azure.microsoft.com/overview/iot/) solutions. This content complements existing [Azure IoT documentation](https://docs.microsoft.com/azure/iot-fundamentals) with concepts and patterns to consider when designing and developing IoT solutions.

Azure *IoT solutions* involve:
- *Devices* sending
- *Events* that generate
- *Insights* to inform
- *Actions* that improve a business or process.

IoT solutions use these relationships between events, insights, and actions to connect diverse populations and types of devices to cloud applications and achieve end-to-end scenarios. The terms *thing* and *device* both mean a connected physical device in an IoT solution.

![A diagram showing devices generating events, which inform insights and actions.](media/devices-events-insights.png) 

## Devices, IoT platform, and applications

![A diagram showing the relationship between devices, the Azure IoT Platform, and an application](media/devices-platform-application.png)

Topologically, Azure IoT solutions are a collection of assets and components divided across *devices*, the *IoT platform*, and *applications*. Events, insights, and actions are concepts representing data flow and processing pipelines that occur across these parts.

*Devices* are the physical or virtual things that connect to IoT applications to send events and receive commands. An IoT device has one or more of the following characteristics:
- Possesses a unique *identity* that distinguishes it within the solution.
- Has *properties*, or a *state*, that applications can access.
- Sends *events* to the IoT platform for applications to act on.
- Receives *commands* from applications to execute.

The *IoT platform* is the collection of services that allow devices and applications to connect and communicate with one another. The IoT platform should, at minimum, provide the following capabilities:
- Broker *authentication, connectivity, and secure communication* between devices and trusted applications.
- Generate contextual *insights* on incoming events to determine the routing of events to endpoints.

*Applications* are the collection of scenario-specific services and components unique to a given IoT solution. IoT applications will typically have:
- A mix of Azure or other services for compute, storage, and event endpoints, combined with unique application business logic.
- *Event* workflows to receive and process incoming device events.
- *Action* workflows to send commands to devices or other processes.

## Events, insights, and actions

While Azure IoT solutions are topologically divided across devices, IoT platform, and applications, *events*, *insights*, and *actions* are functional concepts that exist across the three parts of a solution.

To illustrate, consider an application that monitors cooling system temperatures for food storage and calls emergency maintenance services if a temperature becomes dangerously low or high:

![A diagram illustrating the relationship between events, insights, and actions in an IoT solution used to monitor a food storage system.](media/events-insights-actions.png)

Here a cooling system can send its operating temperature as telemetry events to a connected application through [Azure IoT Hub](). Backup systems also exist in the event a primary cooling system malfunctions or needs to be offline. The devices can receive commands to adjust temperature or start and stop operation. The following process occurs in this example:

1. *Devices generate events.* Devices send temperature samples from the primary cooling system to the application's IoT Hub, via Device-to-Cloud Events, every 30 seconds. 
2. *Events generate insights.* Routing rules in the IoT Hub evaluate events for any immediate contextual insights, such as temperature at malfunctioning level.
3. *Insights inform actions.* If the temperature is at a malfunctioning level, event routing sends the event to a specific handler to take action. The handler invokes an action to another process to dispatch maintenance to the site, and sends a command to the backup system to start while maintenance is enroute to the location.

### Types of events

Events represent *device-to-cloud* communication in an IoT solution, and may be *notifications*, *acknowledgments*, or *telemetry*.

|Event type|Description|
|-|-|
|Notifications|Unsolicited events the device sends to convey state, or requests from a device to its cloud application. These types of events are often used for alerts, state changes, and requests from a device for an application to take an action.<br/><br/>Examples:
<ul>
<li>An alert from a device that it's experiencing a malfunction.</li>
<li>A request from a device for information to be sent to it.</li>
<li>An update on local device state or property change.</li>
</ul>
|
|Acknowledgments|Events a device sends to indicate receipt, progress, or completion of a requested asynchronous operation. Acknowledgments are often used in transactions between a device and cloud where the application logic relies on stateful communication from the device.<br/><br/>Examples:
<ul>
<li>Progress updates on a long-running request from an application.</li>
<li>Success or failure signals for completing an asynchronous request.</li>
<li>Tightly coupled multi-step device and application transactions.</li>
</ul>
|
|Telemetry|Recurring transmission of measurements or state sent at regular intervals from a device to the cloud. These types of events are typically used for remote sensor monitoring.<br/><br/>Examples:
<ul>
<li>Continual sensor data from devices to applications to interpret.</li>
<li>Monitored health and diagnostics data sent from devices.</li>
<li>Tracked assets regularly sending their location data.</li>
</ul>
|

### Types of insights

Insights are interpretations of events. Insights may derive from events directly as *contextual* insights, or from transformed or stored event data by application event processing for *real-time* or *aggregated* insights.

- *Contextual insights* are context-sensitive interpretations of events to determine where they should be routed or what immediate actions application logic should execute. Examples are:
  - Determining where to route a message based on contextual data, such as message header content or the type of device.
  - Runtime decisions by event handling code that decide to take immediate action based on an event.
  - Reconciling acknowledgments to complete a stateful transaction.

- *Real-time insights* are interpretations gathered and observed in real-time for monitoring and decision-making purposes. Examples are:
  - Gathering and observing metrics for a solution in near real-time.
  - Monitoring solution health for visualization, alerting, and remediation workflows.
  - Combining events with other data sources for real-time transformation and output to display and analyze.

- *Aggregated insights* are interpretations made by gathering larger quantities of events over time, storing them, and executing batch processing on the aggregated data. Examples are:
  - Building training data from real events for machine learning and artificial intelligence (AI) insights to use in improving device and service algorithms.
  - Gathering and observing trends and characteristics over a long period of time for use in improving processes.
  - Building on-demand query capabilities around multiple data sources to use in business planning.

### Types of actions

Actions are deliberate activity undertaken in a solution either programmatically or manually as *device*, *service *, or *analog* actions.

- *Device actions* are instructions or information sent to a device from an IoT application, for the device to act on locally. Examples are:
  - Commands sent from a user application to control a device.
  - Configuration data sent to a device to modify its behavior.
  - Requests to a device to provide data or state on-demand.

- *Service actions* are service or intra-process communication sent from one part of a solution to another. These actions may also be requests sent to an external service as part of an application's logic. Examples are:
  - Requesting data from an external service for use by a solution.
  - Transactions with another service as part of application logic.
  - Summoning emergency, police, or other external services.

- *Analog actions* are tracked by a solution as part of a workflow, but usually take place outside of the solution automation. These types of actions often have a mechanism for a human operator to signal when the action is complete. Examples are:
  - Field maintenance on devices where someone is sent to repair or replace a device. The solution is notified when repair is complete.
  - Stocking, packaging, or staging physical items in a retail workflow. The solution is notified when items are stocked or staged.
  - Human-conducted scoring and tuning of training data for AI.</li>

### Events, insights, and actions downstream

Considering the types of events, insights, and actions allows expansion of the cooling system monitoring scenario. The system can add more complex insights and actions by using the events from the cooling system devices:

![A diagram illustrating the events, insights, and actions associated with the cooling system monitoring scenario.](media/events-downstream.png)

While the series of events doesn't change, gathering events and applying different types of insights to them introduces richer capabilities and enables taking additional actions with the data. This strategy becomes more powerful when applied to large numbers of devices operating at multiple locations.

