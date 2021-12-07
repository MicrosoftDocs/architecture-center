---
title: Event Grid and operational excellence
description: Focuses on the Event Grid service used in the Messaging solution to provide best-practice, configuration recommendations, and design considerations related to Operational excellence.
author: v-stacywray
ms.date: 12/01/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - event-grid
categories:
  - messaging
  - management-and-governance
---

# Event Grid and operational excellence

[Azure Event Grid](/azure/event-grid/overview) lets you easily build applications with event-based architectures. This solution has build-in support for events coming from Azure services, like storage blobs and resource groups. Event Grid also has support for your own events, using custom topics.

For more information about using Event Grid, reference [Create and route custom events with Azure Event Grid](/azure/event-grid/custom-event-quickstart).

To understand how using Event Grid promotes operational excellence for your workload, reference [Diagnostic logs for Event Grid topics and Event Grid domains](/azure/event-grid/diagnostic-logs).

The following sections are specific to Azure Event Grid and operational excellence:

- Design considerations
- Configuration checklist
- Recommended configuration options
- Source artifacts

## Design considerations

Azure Event Grid provides an uptime SLA. For more information, reference [SLA for Event Grid](https://azure.microsoft.com/support/legal/sla/event-grid/v1_0/).

## Checklist

**Have you configured Azure Event Grid with operational excellence in mind?**

> [!div class="checklist"]
> - Monitor Event Grid for failed event delivery.
> - Use batched events.
> - Event batches can't exceed `1MB` in size.
> - Configure and optimize batch-size selection during load testing.
> - Ensure Event Grid messages are accepted with `HTTP` `200-204` responses only if delivering to an endpoint that holds custom code.
> - Monitor Event Grid for failed event publishing.

## Configuration recommendations

Consider the following recommendations to optimize operational excellence when configuring Azure Event Grid:

|Recommendation|Description|
|--------------|-----------|
|Monitor Event Grid for failed event delivery.|The `Delivery Failed` metric will increase every time a message can't be delivered to an event handler (timeout or a non-`200-204 HTTP` status code). If an event can't be lost, set up a Dead-Letter-Queue (DLQ) storage account. A DLQ account is where events that can't be delivered after the maximum retry count will be placed. Optionally, implement a notification system on the DLQ storage account, for example, by handling a *new file* event through Event Grid.|
|Use batched events in high-throughput scenarios.|The service will deliver a `json` array with multiple events to the subscribers, instead of an array with one event. The consuming application must be able to process these arrays.|
|Event batches can't exceed `1MB` in size.|If the message payload is large, only one or a few messages will fit in the batch. The consuming service will need to process more event batches. If your event has a large payload, consider storing it elsewhere, such as in blob storage, and passing a reference in the event. When integrating with third-party services through the CloudEvents schema, it's not recommended to exceed `64KB` events.|
|Configure and optimize batch-size selection during load testing.|Batch size selection depends on the payload size and the message volume.|
|Monitor Event Grid for failed event publishing.|The `Unmatched` metric will show messages that are published, but not matched to any subscription. Depending on your application architecture, the latter may be intentional.|

## Source artifacts

To determine the **Input Schema** type for all available Event Grid topics, use the following query:

```sql
Resources 
| where type == 'microsoft.eventgrid/topics'
| project name, resourceGroup, location, subscriptionId, properties['inputSchema']
```

To retrieve the **Resource ID** of existing private endpoints for Event Grid domains, use the following query:

```sql
Resources 
| where type == 'microsoft.eventgrid/domains' and notnull(properties['privateEndpointConnections']) 
| mvexpand properties['privateEndpointConnections'] 
| project-rename privateEndpointConnections = properties_privateEndpointConnections 
| project name, resourceGroup, location, subscriptionId, privateEndpointConnections['properties']['privateEndpoint']['id']
```

To identify **Public Network Access** status for all available Event Grid domains, use the following query:

```sql
Resources 
| where type == 'microsoft.eventgrid/domains' 
| project name, resourceGroup, location, subscriptionId, properties['publicNetworkAccess']
```

To identify **Firewall Rules** for all public Event Grid domains, use the following query:

```sql
Resources 
| where type == 'microsoft.eventgrid/domains' and properties['publicNetworkAccess'] == 'Enabled'
| project name, resourceGroup, location, subscriptionId, properties['inboundIpRules']
```

To identify **Firewall Rules** for all public Event Grid topics, use the following query:

```sql
Resources 
| where type == 'microsoft.eventgrid/topics' and properties['publicNetworkAccess'] == 'Enabled'
| project name, resourceGroup, location, subscriptionId, properties['inboundIpRules']
```

To retrieve the **Resource ID** of existing private endpoints for Event Grid topics, use the following query:

```sql
Resources 
| where type == 'microsoft.eventgrid/topics' and notnull(properties['privateEndpointConnections']) 
| mvexpand properties['privateEndpointConnections'] 
| project-rename privateEndpointConnections = properties_privateEndpointConnections 
| project name, resourceGroup, location, subscriptionId, privateEndpointConnections['properties']['privateEndpoint']['id']
```

To determine the **Input Schema** type for all available Event Grid domains, use the following schema:

```sql
Resources 
| where type == 'microsoft.eventgrid/domains'
| project name, resourceGroup, location, subscriptionId, properties['inputSchema']
```

To identify **Public Network Access** status for all available Event Grid topics, use the following query:

```sql
Resources 
| where type == 'microsoft.eventgrid/topics' 
| project name, resourceGroup, location, subscriptionId, properties['publicNetworkAccess']
```

## Next step

> [!div class="nextstepaction"]
> [Event Hub and reliability](reliability.md)
