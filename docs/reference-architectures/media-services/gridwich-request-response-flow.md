---
title: Gridwich operations request and response flow
titleSuffix: Azure Example Scenarios
description: Understand the flow for processing external system requests to Gridwich and responding to the external system.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Gridwich operations request and response flow

This article describes the request and response process between an external system and Gridwich. In the example scenario, the external system is both a media asset management (MAM) and workflow orchestration system provided by a large media company.

The Gridwich request and response process covers request:

- Creation
- Transport
- Reception
- Dispatch to Gridwich components
- Acknowledgement and actions
- Responses

![request_and_response](media/request-response.png)

## Request and response process

1. The external system authors a request and sends it to the request broker.
   
1. The request broker is responsible for dispatching requests to Gridwich request listeners in a traditional publication-subscription model. In this solution, the request broker is [Azure Event Grid](/azure/event-grid/). All requests are encapsulated using the [Event Grid event schema](/azure/event-grid/event-schema).
   
1. The Event Grid service provides a highly reliable delivery endpoint for request initiation. The Azure platform provides required request delivery endpoint uptime and stability.
   
1. The requests are encapsulated within the object `Event.Data` property, which is opaque to the Event Grid broker and transport layer. Gridwich also uses the `Event.EventType` and `Event.DataVersion` object fields to route events to consumers. So the Event Grid request broker can be substituted with other publication-subscription event brokers, Gridwich depends on the fewest event fields possible, and doesn't use the `Event.Topic` nor `Event.Subject` fields.
   
1. [Azure Functions](/azure/azure-functions/) consumes events from Event Grid. To achieve improved throughput, Gridwich defines an [HTTP endpoint](/azure/azure-functions/functions-bindings-http-webhook), which is a push model that Event Grid initiates, rather than an [Event Grid binding](/azure/azure-functions/functions-bindings-event-grid), which is a polling model the Azure Functions hosting platform provides.
   
1. The Azure Function reads the event properties and dispatches events to parts of the Gridwich code that handle that event type and version.
   
   Specifically, the Azure Function uses [Dependency Injection](/azure/azure-functions/functions-dotnet-dependency-injection) to register one or more request handlers for specific event types and data versions. An [event dispatcher](https://github.com/mspnp/gridwich/src/GridWich.Core.EventGrid/src/EventGridDispatcher.cs) is injected with the collection of Event Grid event handlers. When processing an event, the event dispatcher queries the event handlers to determine which handlers will process this event.
   
   An alternative approach is to use the event subscription and filtering mechanism the Event Grid platform provides. This mechanism would impose a 1:1 deployment model, where one Azure function hosts only one event handler. Although the current solution uses a 1:many model, the [clean architecture](gridwich-monolith.md) means that refactoring the solution for 1:1 isn't difficult.
   
1. Any handler that plans to do further work with the current request must provide an acknowledgement. Specifically, each handler in the system uses a common [EventGridHandlerBase](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/Bases/EventGridHandlerBase.cs) class to provide generic services such as request acknowledgement, failure handling, and publication of response events. The event publication service communicates the acknowledgement, failure, scheduled, or success messages to the EventGrid request broker.
   
   When it receives a request by a handler, the base class immediately sends an acknowledgement message, and then dispatches the work to the derived class.
   
   ![handler_message_ack_flow diagram](media/request-acknowledgement.png)
   
1. For requests that are easy to perform and quick to complete, the request handler does the work synchronously and returns the success event, with its operation context, almost immediately after sending the acknowledgement.
   
   For long-running requests like media file encoding, the request handler evaluates the contents of the request, validates arguments, and initiates the long-running operation. The handler then returns a *scheduled* event to confirm that the work activity is requested.
   
   For more information about the synchronous and asynchronous event handlers, see [Simple sync and async handlers](sync-async-handlers.md).
   
1. Upon completing the work activity, the request handler is responsible for providing a *successful completion* event for the work. The handler must retrieve the original operation context, while remaining stateless, and place it in the Completed event message payload.
   
1. The event publisher in the Azure Function sends the response event to an Event Grid topic, which acts as a reliable message broker. The external system subscribes to the topic and consumes the messages. The Event Grid platform provides its normal retry logic for publication to the external system.

## Message order

The external system shouldn't depend on message order. While an Acknowledgement would precede both the Success and Scheduled responses, Gridwich doesn't guarantee that a Scheduled response will always precede the corresponding Success response. A valid response sequence could be either Acknowledged/Scheduled/Success or Acknowledged/Success/Scheduled.

## Request failures

Failures can be due to bad requests, missing pre-conditions, processing failures, security exceptions, or unhandled exceptions. Failures all have the same message form, and should include the original operation context. Failure responses are typically sent by the common [EventGridHandlerBase](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/Bases/EventGridHandlerBase.cs) class to Event Grid via the Azure Function event publisher interface. [Application Insights](/azure/azure-monitor/app/app-insights-overview) also logs failures via the [structured logging](gridwich-logging.md) used throughout the project.

## Related resources

For the specific formats of Gridwich operations message events, see [Gridwich message formats](gridwich-message-formats.md).

