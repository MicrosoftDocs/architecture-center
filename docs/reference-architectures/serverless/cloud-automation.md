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

Cloud automation is automating workflows and repetitive tasks on the cloud. Using [serverless technologies](https://azure.microsoft.com/solutions/serverless/) for automation, can dramatically improve productivity of an organization's DevOps team. A serverless model is best suited for automation scenarios which can follow an [event driven approach](https://docs.microsoft.com/azure/architecture/guide/architecture-styles/event-driven). This reference architecture illustrates two such cloud automation scenarios using [Azure Functions](https://docs.microsoft.com/azure/azure-functions/). These functions perform customized automation tasks, triggered by subscribed events or monitored activity in the infrastructure.

![Serverless cloud automation](./_images/cloud-automation.png)

![GitHub logo](../../_images/github.png) The reference implementations for this architecture are available on [GitHub](https://github.com/mspnp/serverless-automation). These cover the following automation scenarios:

1. [Cost center tagging](https://github.com/mspnp/serverless-automation/blob/master/src/automation/cost-center/deployment.md) - This implements a scenario where an organization might want to track the cost centers of each Azure resource. This implementation [tags](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-using-tags) all new resources in a group, with a default cost center ID, by using  [Azure Policy](https://docs.microsoft.com/azure/governance/policy/). It then validates this information against Azure Active Directory, to find out the actual cost center ID, updates tags and sends out an email notification to the resource owner. Note that the Azure Active Directory queries are mocked out for simplicity.

1. [Throttling response](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/deployment.md) - This implementation monitors a Cosmos DB database for throttling, which happens when data access requests are more than what the [CosmosDB Request Units (or RUs)](https://docs.microsoft.com/azure/cosmos-db/request-units) can handle. The automation function then scales the throughput, by increasing the RUs to a preset value.

## Architecture

The architecture consists of the following blocks:

**Automation Function**. [Azure Functions](https://docs.microsoft.com/azure/azure-functions/) provides the event-driven serverless compute capabilities. It performs automation tasks, when triggered by events such as a new resource creation in the case of the first scenario, or a database overload error in the case of the second. In both these implementations, the automation function is invoked with an HTTP request. To minimize code complexity, it should be developed so that the function:

- does exactly one thing (single responsibility principle),
- returns as soon as possible,
- is stateless, and
- is idempotent (i.e. multiple executions do not create multiple results).

To maintain idempotency, the function scaling in the throttling scenario is kept simplistic. In real world automation, make sure to scale up or down appropriately.

Additionally, read the [Optimize the performance and reliability of Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-best-practices) for best practices when writing your automation functions.

**Logic App**. [Logic Apps](https://docs.microsoft.com/azure/logic-apps/) can be optionally used in this architecture for a predefined workflow. This can be used to perform non-automation related tasks, which can be more easily implemented using [Logic App's built-in connectors](https://docs.microsoft.com/azure/connectors/apis-list), such as sending an email notification.

**Event Grid**. [Event Grid](https://docs.microsoft.com/azure/event-grid/overview) has built-in support for events from other Azure services, as well as your own events (as custom topics). Operational events such as resource creation can be easily propagated to the the automation event handler, using the Event Grid's built-in mechanism.

**Azure Monitor**. [Azure Monitor Alerts](https://docs.microsoft.com/azure/azure-monitor/overview#alerts) can monitor for critical conditions, and send alert notifications for corrective action using [action groups](https://azure.microsoft.com/resources/videos/azure-friday-azure-monitor-action-groups/). This is useful to watch for and fix any error conditions in your infrastructure, such as database throttling.

**Automation action**. This broad block represents other services that your function can interact with, to provide the automation functionality. For example, Azure Active Directory for tag validation as in the first scenario, or a database to update as in the second scenario.

## Reliability considerations

**Function**. As best practice, the function should log any failures in carrying out automation tasks. This allows for proper troubleshooting of the error conditions. The reference implementations use the [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview) as the telemetry system.

Verify the concurrency requirement for your automation function. For example, the throttling automation workflow limits the maximum number of [concurrent http calls](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook?tabs=csharp#hostjson-settings) to the function to one, to avoid side-effects of false alarms. The following [host.json](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/throttling-respond/host.json) file illustrates this:

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

Make sure your automation function is idempotent. Both Azure Monitor and Event Grid may emit alerts or events that indicate progression such as your subscribed event is *resolved*, *fired*, *in progress*, etc., your resource is *being provisioned*, *created successfully*, etc., or even send false alerts due to a misconfiguration. Make sure your automation logic acts only on the relevant alerts and events, and ignores all others. Ensure that false or misconfigured events do not cause unwanted results. Where possible, read the current value before updating it.

## Resiliency considerations

**Functions**. To avoid HTTP timeouts for a longer automation task, queue this event in a [Service Bus](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-messaging-overview#queues) and handle the actual automation in a second function. This might be required, for example, if the function needs to update a database. The throttling response automation scenario illustrates this pattern, even though the actual CosmosDB RU provisioning does not take a long time.

![Reliability in automation function](./_images/automation-function-reliability.png)

**Event Grid**. If your workflow uses Event Grid, check if your scenario could generate a high volume of events, enough to clog the grid. See [Event Grid message delivery and retry](https://docs.microsoft.com/azure/event-grid/delivery-and-retry) to understand how it handles events when delivery isn't acknowledged, and modify your logic accordingly. The cost center workflow does not implement additional checks for this, since it only watches for resource creation events in a resource group. Monitoring resources created in an entire subscription, can generate larger number of events, requiring resilient handling.

## Security considerations

### **Functions**

#### Control access to the function

If the function is getting invoked by an http trigger, restrict access to the function url by setting the [authorization level](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook?tabs=csharp#trigger---configuration).  With *anonymous* authentication, the function is easily accessible with a URL such as `http://<APP_NAME>.azurewebsites.net/api/<FUNCTION_NAME>`. Using *function* level authentication helps you obfuscate your http endpoint, by requiring function keys in the URL. This level is set in the file [function.json](https://github.com/mspnp/serverless-automation/blob/master/src/automation/cost-center/cost-center-tagging/OnResourceWriteSuccess/function.json):

```JSON
{
  "bindings": [
    {
      "authLevel": "function",
      "type": "httpTrigger",
      "direction": "in",
      "name": "Request",
      "methods": [
        "get",
        "post"
      ]
    },
    {
      "type": "http",
      "direction": "out",
      "name": "Response"
    }
  ]
}
```

For production environment, you might need to implement additional strategies to secure your function. In the reference implementations, the functions are executed within the Azure platform by other Azure services, and will not be exposed to the internet. In such a scenario, function authorization is sufficient. Make sure to secure the function key in a Key Vault.

For additional security, the following costlier options could be considered:

- Use a dedicated App Service plan, where you can lock down the functions in a virtual network to limit access to it. This is not possible in a consumption-based serverless model.
- Try the [Premium plan](https://docs.microsoft.com/azure/azure-functions/functions-premium-plan), which allows a dedicated V-net to be used by your function apps.

For price and feature comparison between these models, read [Azure Functions scale and hosting](https://docs.microsoft.com/azure/azure-functions/functions-scale).

#### Control what the function can access

[Managed identities for Azure resources](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview), an Azure Active Directory feature, simplifies how the function authenticates and accesses other Azure resources and services. The code does not need to manage the authentication credentials, since it is managed by Azure AD.

There are two types of managed identities:

- *System-assigned managed identities*: These are created as part of the Azure resource, and cannot be shared among multiple resources. These get deleted when the resource is deleted. Use these for scenarios which involve single Azure resource or which need independent identities. Both the reference implementations use system-assigned identities since they update only a single resource. Note that managed identities are only required to update another resource. For example, a function can read the resource tags without a managed identity. See [these instructions](https://docs.microsoft.com/azure/app-service/overview-managed-identity?toc=%2Fazure%2Fazure-functions%2Ftoc.json&tabs=dotnet#adding-a-system-assigned-identity) to add a system-assigned identity to your function.

- *User-assigned managed identities*: These are created as stand-alone Azure resource. These can be shared across multiple resources, and need to be explicitly deleted. Use these for scenarios that:

    - require access to multiple resource, which can share a single identity,
    - need pre-authorization to secure resource during provisioning, or
    - where resources recycled frequently, but permissions need to be consistent.

Read [these instructions](https://docs.microsoft.com/azure/app-service/overview-managed-identity?toc=%2Fazure%2Fazure-functions%2Ftoc.json&tabs=dotnet#adding-a-user-assigned-identity) on how to add user-assigned identity to your function.

Once the identity is assigned to the Azure function, assign it a role using [role-based access control or RBAC](https://docs.microsoft.com/azure/role-based-access-control/overview) to correctly access the resources. To be able to update the resources, you will need to assign the *Contributor* role to the function identity.

## Deployment considerations

For critical automation workflows that manage behavior of your application, it is strongly recommended to achieve zero downtime deployment with an efficient DevOps pipeline. For more discussion on this, read [serverless backend deployment](https://docs.microsoft.com/azure/architecture/reference-architectures/serverless/web-app#back-end-deployment).

The deployment pipeline for the automation implementations should also be kept separate from the main application. This ensures that updating the automation function does not affect your application. To separate these deployment cycles, you must use a [separate resource group](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-overview#resource-groups) for all the resources required by the automation.

## Deploy the solution

To deploy the reference implementations for this architecture, see the [GitHub page](https://github.com/mspnp/serverless-automation), and open one of the two workflows.

## Next steps

To learn more about the serverless implementations, start [here](https://docs.microsoft.com/azure/architecture/reference-architectures/#serverless-applications).
