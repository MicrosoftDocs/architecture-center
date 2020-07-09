---
title: Events, Insights, and Actions
titleSuffix: Azure Example Scenarios
description: An explanation of the core functional concepts of Events, Insights, and Actions and how they interact in an IoT Solution.
author: wamachine
ms.date: 06/29/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---
# Events, Insights, and Actions

Where Azure IoT Solutions are topologically divided across **devices**,
**IoT** **platform**, and **application** parts, **events**,
**insights**, and **actions** are functional concepts that exist across
the three parts of a solution.

To illustrate, consider an application that monitors cooling system
temperatures for food storage and calls emergency maintenance services
if a cooling system's temperature becomes dangerously low or high:

![A diagram illustrating the relationship between events, insights, and actions in an IoT solution used to monitor a food storage system](media/events-insights-actions.png)

Here a cooling system can send its operating temperature as telemetry
events to a connected application through IoT Hub. Additionally, backup
systems exist in the event a primary cooling system malfunctions or
needs to be offline. The devices can receive commands to adjust
temperature, start, and stop operation. The following occurs in this
example:

-   **Devices Generate Events:** Temperature samples are sent from the
    primary cooling system to the application's IoT Hub, via
    Device-to-Cloud Events at an interval of every 30 seconds.

-   **Insights Based on Data:** Events are evaluated by routing rules
    configured in the IoT Hub for any immediate contextual insights,
    such as "temperature at malfunctioning level".

-   **Actions Based on Insights:** If the temperature is at a
    malfunctioning level, event routing sends the event to a specific
    handler to take action. The handler invokes an action to another
    process to dispatch maintenance to the site and sends a command to
    the backup system to start while maintenance is in-route to
    location.

## Types of Events

Events represent **Device-to-Cloud** communication in an IoT Solution
and may be **Notifications**, **Acknowledgements**, or **Telemetry**. A
description of these event types is provided:


<table>
<thead>
    <tr>
        <th>Type of Event</th>
        <th>Description</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td width=20%><b>Notifications</b></td>
        <td>Unsolicited events sent from device for the purpose of conveying state or requests from a device to its cloud application. These types of events are often used for alerts, state changes, and requests from a device for an application to take an action.<br><br>
        <b>Examples:</b>
            <ul>
                <li>Alert from a device that it is experiencing a malfunction.</li>
                <li>Request from a device for information to be sent to it.</li>
                <li>Update on local state or property change on a device.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><b>Acknowledgements</b></td>
        <td>Events sent as an indicator of receipt, progress, or completion of an asynchronous operation requested from a device. Acknowledgements are often used in transactions between a cloud and device where the application logic relies on stateful communication from a device.<br><br>
        <b>Examples:</b>
            <ul>
                <li>Progress updates on a long-running request from an application.</li>
                <li>Signal successful, or failed, completion of an asynchronous request.</li>
                <li>Tightly coupled multi-step device and application transactions.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><b>Telemetry</b></td>
        <td>Recurring transmission of events sent at a regular interval that represent measurements or state from a device to the cloud. These types of events are typically used for remote monitoring of sensors.<br><br>
        <b>Examples:</b>
            <ul>
                <li>Continual sensor data from devices to applications to interpret.</li>
                <li>Monitored health and diagnostics data sent from devices.</li>
                <li>Tracked assets regularly sending their location data.</li>
            </ul>
        </td>
    </tr>
</tbody>
</table>

## Types of Insights

Insights are interpretations of events. They may be derived from events
directly as **Contextual Insights**, or event data that has been
transformed and/or stored by application event processing for
**Real-Time** or **Aggregated Insights**. A description of these insight
types provided:

<table>
<thead>
    <tr>
        <th>Type of Insight</th>
        <th>Description</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td width=20%><b>Contextual Insights</b></td>
        <td>Context-sensitive interpretations made on events to determining where they should be routed to or what immediate actions should be executed by application logic. <br><br>
        <b>Examples:</b>
            <ul>
                <li>Determining where to route a message based on contextual data such as message header content or the type of device.</li>
                <li>Runtime decisions made by event handling code that decides to take immediate action based on an event.</li>
                <li>Reconciling acknowledgements to complete a stateful transaction.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><b>Real-Time Insights</b></td>
        <td>Interpretations gathered and observed in real-time for monitoring and decision-making purposes.<br><br>
        <b>Examples:</b>
            <ul>
                <li>Gathering and observing metrics for a solution in near real-time.</li>
                <li>Monitoring of solution health for visualization, alerting, and remediation workflows.</li>
                <li>Combination of events with other data sources for real-time transformation and output to display and analyze.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><b>Aggregated Insights</b></td>
        <td>Interpretations made by gathering larger quantities of events over time, storing them, and executing batch processing on the aggregated data.<br><br>
        <b>Examples:</b>
            <ul>
                <li>Building training data from real events for Machine Learning and AI insights for use in improving device and service algorithms.</li>
                <li>Gathering and observing trends and characteristics over a long period of time for use in improving processes.</li>
                <li>Building on-demand query capabilities around multiple data sources to use in business planning.</li>
            </ul>
        </td>
    </tr>
</tbody>
</table>

## Types of Actions

Actions are deliberate activity undertaken in a solution either
programmatically, or manually as **Device Actions**, **Service
Actions**, or **Analog Actions**. A description of these action types is
provided:

<table>
<thead>
    <tr>
        <th>Type of Action</th>
        <th>Description</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td width=20%><b>Device Actions</b></td>
        <td><b>Commands</b> that are instructions, or information, sent to a device, from an IoT Application, for the device to act on locally.<br><br>
        <b>Examples:</b>
            <ul>
                <li>Commands sent from a user application to control a device.</li>
                <li>Configuration data sent to a device to modify its behavior.</li>
                <li>Requests to a device to provide data, or state, on-demand.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><b>Service Actions</b></td>
        <td>Service or intra-process communication sent from one part of a solution to another. These may also be requests sent to an external service as part of an application’s logic.<br><br>
        <b>Examples:</b>
            <ul>
                <li>Requesting data from an external service for use by a solution.</li>
                <li>Transactions with another service as part of application logic.</li>
                <li>Summoning emergency, police, or other external services.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><b>Analog Actions</b></td>
        <td>Actions that are tracked by a solution as part of a workflow, but usually take place outside of what is automatable in a solution. These types of action often have a mechanism for a human operator to signal when the action is complete.<br><br>
        <b>Examples:</b>
            <ul>
                <li>Field maintenance on devices where someone is sent to repair, or replace, a device. Solution is notified when repair is complete.</li>
                <li>Stocking, packaging, or staging of physical items in a retail workflow. Solution is notified when items are stocked or staged.</li>
                <li>Human-conducted scoring and tuning of training data for AI.</li>
            </ul>
        </td>
    </tr>
</tbody>
</table>

## Events, Insights, and Actions Downstream

Considering the type of Events, Insights, and Actions we further expand
on the previous cooling system monitoring scenario by adding more
complex insights and actions using the events sent from the cooling
system:

![A diagram illustrating the events, insights, and actions associated with the cooling system monitoring scenario described](media/events-downstream.png)

While the series of events do not change in this case, richer
capabilities are increasingly introduced by the act of gathering events
and applying different types of insights to them. In turn, this enables
additional actions to be taken with the data. This becomes more powerful
when applied to large numbers of devices that may be operating at
multiple locations.
