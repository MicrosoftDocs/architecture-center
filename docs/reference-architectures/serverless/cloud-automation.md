---
title: Serverless cloud automation 
titleSuffix: Azure Reference Architectures
description: Recommended architecture for implementing cloud automation using serverless technologies.
author: dsk-2015
ms.author: dkshir
ms.date: 10/30/2019
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Serverless cloud automation on Azure

Cloud automation is a broad term, which basically means automating workflows and tasks on the cloud. This reference architecture illustrates two of the most common cloud automation scenarios using [serverless](https://azure.microsoft.com/solutions/serverless/) technologies. Serverless computing can dramatically improve productivity of an organization's DevOps team. The two scenarios covered in this article use [Azure Functions](https://docs.microsoft.com/azure/azure-functions/) that perform customized automation tasks, triggered by events such as infrastructure state change, or some other organizational activity.

![Serverless cloud automation](./_images/cloud-automation.png)

The serverless model is best suited to automate cloud operations that follow an [event-driven approach](https://blogs.gartner.com/tony-iams/using-serverless-computing-automate-cloud-operations/). These scenarios follow key event-driven patterns such as:

- statelessness, where communication happens through callback notifications,
- concurrency, where functions subscribe to notifications from event sources,
- idempotence, where event sources have no knowledge of processing in the function, and
- events record the transitions in the states, and represent the history of actions.

![GitHub logo](../../_images/github.png) The reference implementations for this architecture are available on [GitHub](https://github.com/mspnp/serverless-automation). These cover the following automation scenarios:

1. [Cost center tagging](https://github.com/mspnp/serverless-automation/blob/master/src/automation/cost-center/deployment.md) - This workflow tags all new resources in a group, with the cost center information. It then validates this information against Azure Active Directory, for any change in the cost center, and sends out an email notification to the resource owner. If any changes are detected, it also updates the tagged information, before sending out the email.

1. [Throttling response](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/deployment.md) - This workflow monitors a Cosmos DB database for throttling, which happens when data access requests are more than what the [CosmosDB Request Units (or RUs)](https://docs.microsoft.com/en-us/azure/cosmos-db/request-units) can handle. The automation function then scales the throughput, by increasing the RUs to a preset value.

## Architecture

The architecture consists of the following blocks:

**Automation Function**. [Azure Functions](https://docs.microsoft.com/azure/azure-functions/) provide the event-driven serverless compute capabilities. It performs automation tasks, when triggered by events such as a new resource creation in the case of the first scenario, or a database overload error in the case of the second. In both these implementations, the automation function is invoked with an HTTP request. To minimize code complexity, it should be developed so that the function:

- does exactly one thing (single responsibility principle),
- returns as soon as possible,
- is stateless, and
- is idempotent (i.e. multiple executions do not create multiple results).

To maintain idempotency, the function scaling in the throttling scenario is kept simplistic. In real world automation, make sure to scale up or down appropriately.

**Logic App**. [Logic Apps](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) provide an optional workflow element in this architecture. This can be used to perform non-automation related tasks which can be more easily implemented using [Logic App's built-in connectors](https://docs.microsoft.com/en-us/azure/connectors/apis-list), such as sending an email.

**Event Grid**. [Event Grid](https://docs.microsoft.com/en-us/azure/event-grid/overview) has built-in support for events from other Azure services, as well as your own events (as custom topics). It provides an important channel between events from an Azure resource and your automation workflow. Most event-driven automation workflows will use this channel, such as the cost center automation scenario.

**Azure Monitor**. [Azure Monitor Alerts](https://docs.microsoft.com/en-us/azure/azure-monitor/overview#alerts) can monitor for critical conditions, and send alert notifications for corrective action using *action groups*. This is useful for monitoring for error conditions, such as the CosmosDB throttling alert in the second scenario.

**Actions**. Your automation function can interact with other Azure services to provide the functionality as an action. The tagging scenario verifies the tagged cost center information against the Azure Active Directory, and updates the resource for any changes. The throttling scenario updates the CosmosDB RUs to increase the throughput of the database.

## Reliability considerations

**Function**. As best practice, the function should log any failures in carrying out automation tasks in [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview). This allows for proper troubleshooting of the error conditions.

Verify the concurrency requirement for your automation function. For example, the throttling automation workflow limits the maximum number of [concurrent http calls](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook?tabs=csharp#hostjson-settings) to the function to one, to avoid side-effects of false alarms. The following [host.json](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/throttling-respond/host.json) file illustrates this:

```JSON
{
  "version": "2.0",
  "managedDependency": {
    "enabled": true
  },
  "extensions": {
    "http": {
        "routePrefix": "api",
        "maxConcurrentRequests": 1
    }
  }
}
```

If your automation task is related to a database update or a similar time-consuming operation, make sure that false alarms caused in the meanwhile do not cause unwanted results. Where possible, read the current value before updating to avoid such unwanted results. For example, if the throttling workflow would scale out, it should counter for false alerts.

## Resiliency considerations

**Functions**. To avoid HTTP timeouts for a longer automation task, queue this event in a [Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview#queues) and handle the actual automation in a second function. This might be required for example, if the function needs to update a database, as in the case of the throttling response automation scenario.

![Reliability in automation function](./_images/automation-function-reliability.png)

**Event Grid**. If your workflow uses Event Grid, see [this article](https://docs.microsoft.com/en-us/azure/event-grid/delivery-and-retry) to understand how it handles events when delivery isn't acknowledged, and modify your logic accordingly.

## Security considerations

## Deployment considerations

## Deploy the solution

To deploy the reference implementations for this architecture, see the [GitHub page](https://github.com/mspnp/serverless-automation), and open one of the two workflows.

## Next steps

To learn more about the serverless implementations, start [here](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/#serverless-applications).
