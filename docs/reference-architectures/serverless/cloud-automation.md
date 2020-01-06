---
title: Event-based cloud automation | Microsoft Docs
titleSuffix: Azure Reference Architectures
description: Recommended architecture for implementing cloud automation using serverless technologies.
author: dsk-2015
ms.author: dkshir
ms.date: 10/30/2019
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Event-based cloud automation on Azure

Cloud automation means automating workflows and repetitive tasks on the cloud. Using [serverless technologies](https://azure.microsoft.com/solutions/serverless/) for automation, can dramatically improve productivity of an organization's DevOps team. A serverless model is best suited for automation scenarios, which can follow an [event driven approach](https://docs.microsoft.com/azure/architecture/guide/architecture-styles/event-driven). This reference architecture illustrates two such cloud automation scenarios using [Azure Functions](https://docs.microsoft.com/azure/azure-functions/). These functions perform customized automation tasks, triggered by subscribed events or monitored activity in the infrastructure.

![GitHub logo](../../_images/github.png) The reference implementations for this architecture are available on [GitHub](https://github.com/mspnp/serverless-automation).

These cover the following automation scenarios:

1. [Cost center tagging](https://github.com/mspnp/serverless-automation/blob/master/src/automation/cost-center/deployment.md) - This implements a scenario where an organization might want to track the cost centers of each Azure resource. This implementation [tags](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-using-tags) all new resources in a group, with a default cost center ID, by using  [Azure Policy](https://docs.microsoft.com/azure/governance/policy/). It then validates this information against Azure Active Directory, to find out the actual cost center ID, updates tags and sends out an email notification to the resource owner. Note that the Azure Active Directory queries are mocked out for simplicity. Alternatively, Azure AD can also be integrated using the [Azure AD PowerShell module](https://docs.microsoft.com/powershell/module/azuread/?view=azureadps-2.0) or the [ADAL for Python library](https://pypi.org/project/adal/).

1. [Throttling response](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/deployment.md) - This implementation monitors a Cosmos DB database for throttling, which happens when data access requests are more than what the [CosmosDB Request Units (or RUs)](https://docs.microsoft.com/azure/cosmos-db/request-units) can handle. The automation function then scales the throughput, by increasing the RUs to a preset value. Note that the purpose of this implementation is demonstration only; the [CosmosDB autopilot mode (Preview)](https://docs.microsoft.com/azure/cosmos-db/provision-throughput-autopilot) provides an alternative to this approach.

![Serverless cloud automation](./_images/cloud-automation.png)

The functions in these implementations are written in PowerShell and Python, two of the most common scripting languages used in automation. They are deployed using [Azure Functions Core Tools](https://docs.microsoft.com/azure/azure-functions/functions-run-local) in Azure CLI. Alternatively, you can try a preview version of [PowerShell cmdlet to deploy and manage Azure Functions](https://www.powershellgallery.com/packages/Az.Functions/0.0.1-preview).

## Patterns in event-based automation

Event-based automation scenarios fall into either of the following patterns.

1. **Respond to events on resources**. These are responses to events such as an Azure resource or resource group getting created, deleted, changed, and so on. This pattern uses integration with Event Grid to trigger the function for such events. The cost center tagging implementation is an example of this pattern. Other common scenarios include:
    a. Grant access to newly created resource groups to DevOps teams.
    b. Send a notification when a resource is deleted.
    c. Respond to Azure Virtual Machines maintenance events.

1. **Scheduled tasks**. These are typically maintenance tasks executed using [timer-triggered functions](https://docs.microsoft.com/azure/azure-functions/functions-create-scheduled-function). Examples of this pattern are:
    a. Stop a VM at night and start in the morning.
    b. Reads a Blob Storage content at regular intervals and creates a CosmosDB document.
    c. Remove resources no longer in use.

1. **Process Azure alerts**. This pattern leverages the Azure Monitor alerts and action groups integrated into Azure Functions. The automation actions are typically remedial actions in response to metrics, log analytics, or alerts originating in your applications as well as the infrastructure. The throttling response implementation is an example of this pattern. Other common scenarios are:
    a. Truncate table when SQL Database reaches maximum size.
    b. Restart a service in a VM when it is erroneously stopped.
    c. Send notifications if a function is failing.

1. **Orchestrate with external systems**. This pattern enables integration with external systems, using Logic Apps to orchestrate the workflow. [Logic Apps connectors](https://docs.microsoft.com/en-us/azure/connectors/apis-list) can easily integrate with Microsoft services such as Office 365 as well as several third-party services. Customized automation can be achieved using the integration of Azure Functions with the Logic Apps. The cost center tagging implementation also implements this pattern. Other common scenarios include:
    a. Monitor IT processes such as change requests or approvals.
    b. Send customized email notification when automation task is completed.
    c. Start deployments based on certain conditions.

1. **Expose as a *web hook* or API**. Automation tasks using Azure Functions can be integrated into third-party applications or even command-line tools, by exposing the function as a web hook/API with [an HTTP trigger](https://docs.microsoft.com/azure/azure-functions/functions-create-first-azure-function). Multiple authentication methods are available in both PowerShell and Python to secure external access to the function. The automation happens in response to the app-specific external events, for example, integration with power apps or GitHub. Common scenarios include:
    a. Trigger automation for a failing service.
    b. Onboard users to organization's resources.

## Architecture

The architecture consists of the following blocks:

**Automation Function**. [Azure Functions](https://docs.microsoft.com/azure/azure-functions/) provides the event-driven serverless compute capabilities. It performs automation tasks, when triggered by events such as a new resource creation in the case of the first scenario, or a database overload error in the case of the second. In both these implementations, the automation function is invoked with an HTTP request. To minimize code complexity, it should be developed so that the function:

- does exactly one thing (single responsibility principle),
- returns as soon as possible,
- is stateless, and
- is idempotent (that is, multiple executions do not create different results).

To maintain idempotency, the function scaling in the throttling scenario is kept simplistic. In real world automation, make sure to scale up or down appropriately.

Additionally, read the [Optimize the performance and reliability of Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-best-practices) for best practices when writing your automation functions.

**Logic App**. [Logic Apps](https://docs.microsoft.com/azure/logic-apps/) can be optionally used in this architecture for a predefined workflow. This can be used to perform non-automation related tasks, which can be more easily implemented using [Logic App's built-in connectors](https://docs.microsoft.com/azure/connectors/apis-list). These tasks can range from a simple email notification, to integrating with external management applications. To learn how to use Logic Apps with third-party applications, read [basic enterprise integration in Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/enterprise-integration/basic-enterprise-integration).

Logic Apps provides a *no-code*, visual designer, and may be used alone in some automation scenarios. Read [this comparison between Azure Functions and Logic Apps](https://docs.microsoft.com/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-azure-functions-and-azure-logic-apps) to see which service can fit your scenario.

**Event Grid**. [Event Grid](https://docs.microsoft.com/azure/event-grid/overview) has built-in support for events from other Azure services, as well as your own events (as custom topics). Operational events such as resource creation can be easily propagated to the automation event handler, using the Event Grid's built-in mechanism.

Event Grid simplifies the event-based automation with a [publish-subscribe model](https://docs.microsoft.com/en-us/azure/event-grid/concepts), allowing reliable automation for events delivered over HTTP. 

**Azure Monitor**. [Azure Monitor Alerts](https://docs.microsoft.com/azure/azure-monitor/overview#alerts) can monitor for critical conditions, and send alert notifications for corrective action using [action groups](https://azure.microsoft.com/resources/videos/azure-friday-azure-monitor-action-groups/). This is useful to watch for and fix any error conditions in your infrastructure, such as database throttling.

**Automation action**. This broad block represents other services that your function can interact with, to provide the automation functionality. For example, Azure Active Directory for tag validation as in the first scenario, or a database to update as in the second scenario.

## Resiliency considerations

### Functions

#### Handle HTTP timeouts

To avoid HTTP timeouts for a longer automation task, queue this event in a [Service Bus](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-messaging-overview#queues) and handle the actual automation in a second function. The throttling response automation scenario illustrates this pattern, even though the actual CosmosDB RU provisioning is fast.

![Reliability in automation function](./_images/automation-function-reliability.png)

The Service Bus pattern above could be avoided by using [*durable functions*](https://docs.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=csharp#async-http), which maintain state between invocations. Durable functions are currently supported only in JavaScript and C#.

#### Log failures

As best practice, the function should log any failures in carrying out automation tasks. This allows for proper troubleshooting of the error conditions. The reference implementations use the [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview) as the telemetry system.

#### Concurrency

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

#### Idempotency

Make sure your automation function is idempotent. Both Azure Monitor and Event Grid may emit alerts or events that indicate progression such as your subscribed event is *resolved*, *fired*, *in progress*, etc., your resource is *being provisioned*, *created successfully*, etc., or even send false alerts due to a misconfiguration. Make sure your automation logic acts only on the relevant alerts and events, and ignores all others. Ensure that false or misconfigured events do not cause unwanted results.

### Event Grid

If your workflow uses Event Grid, check if your scenario could generate a high volume of events, enough to clog the grid. See [Event Grid message delivery and retry](https://docs.microsoft.com/azure/event-grid/delivery-and-retry) to understand how it handles events when delivery isn't acknowledged, and modify your logic accordingly. The cost center workflow does not implement additional checks for this, since it only watches for resource creation events in a resource group. Monitoring resources created in an entire subscription, can generate larger number of events, requiring resilient handling.

### Azure Monitor

If a sufficiently large number of alerts are generated, and if the resulting automation involves updating Azure resources, [throttling limits of the Azure Resource Manager](https://docs.microsoft.com/azure/azure-resource-manager/resource-manager-request-limits#subscription-and-tenant-limits) might be reached. This in turn can negatively affect the rest of the infrastructure in that subscription. Avoid this situation by limiting the *frequency* of alerts getting generated by the Azure Monitor. You may also limit the alerts getting generated for a particular error. Refine the alert management by consulting the [documentation for the alerts](https://docs.microsoft.com/azure/azure-monitor/platform/alerts-overview).

## Security considerations

### Functions

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

For production environment, you might need to implement additional strategies to secure your function. In the reference implementations, the functions are executed within the Azure platform by other Azure services, and will not be exposed to the internet. Function authorization is sufficient for functions accessed as web hooks. Make sure to secure the function key in a Key Vault. You may consider adding secure layers on top of function authentication, such as authenticating with client certificates, or make sure the caller is part of or has access to the directory that hosts the function, by using [Easy Auth integration](https://blogs.msdn.microsoft.com/mihansen/2018/03/25/azure-active-directory-authentication-easy-auth-with-custom-backend-web-api/). Note that these options are currently unavailable to Azure Action Groups, other than the function-level authorization.

If the calling service supports service endpoints, the following costlier options could be considered:

- Use a dedicated App Service plan, where you can lock down the functions in a virtual network to limit access to it. This is not possible in a consumption-based serverless model.
- Try the [Premium plan](https://docs.microsoft.com/azure/azure-functions/functions-premium-plan), which allows a dedicated virtual network to be used by your function apps.

For price and feature comparison between these models, read [Azure Functions scale and hosting](https://docs.microsoft.com/azure/azure-functions/functions-scale).

If the function needs to be called from a third-party application or service, it is recommended to provide access to the function with an [API Management](https://docs.microsoft.com/azure/api-management/api-management-key-concepts) layer, which should include authentication. API Management now has a [Consumption tier](https://azure.microsoft.com/en-au/updates/azure-api-management-consumption-tier-is-now-generally-available/), integrated with Azure Functions, which allows you to pay only if the API gets executed. For more information, read [Create and expose your functions with OpenAPI](https://docs.microsoft.com/en-us/azure/azure-functions/functions-openapi-definition)

#### Control what the function can access

[Managed identities for Azure resources](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview), an Azure Active Directory feature, simplifies how the function authenticates and accesses other Azure resources and services. The code does not need to manage the authentication credentials, since it is managed by Azure AD.

There are two types of managed identities:

- *System-assigned managed identities*: These are created as part of the Azure resource, and cannot be shared among multiple resources. These get deleted when the resource is deleted. Use these for scenarios, which involve single Azure resource or which need independent identities. Both the reference implementations use system-assigned identities since they update only a single resource. Note that managed identities are only required to update another resource. For example, a function can read the resource tags without a managed identity. See [these instructions](https://docs.microsoft.com/azure/app-service/overview-managed-identity?toc=%2Fazure%2Fazure-functions%2Ftoc.json&tabs=dotnet#adding-a-system-assigned-identity) to add a system-assigned identity to your function.

- *User-assigned managed identities*: These are created as stand-alone Azure resource. These can be shared across multiple resources, and need to be explicitly deleted. Use these for scenarios that:

    - require access to multiple resource, which can share a single identity,
    - need pre-authorization to secure resource during provisioning, or
    - where resources recycled frequently, but permissions need to be consistent.

Read [these instructions](https://docs.microsoft.com/azure/app-service/overview-managed-identity?toc=%2Fazure%2Fazure-functions%2Ftoc.json&tabs=dotnet#adding-a-user-assigned-identity) on how to add user-assigned identity to your function.

Once the identity is assigned to the Azure function, assign it a role using [role-based access control or RBAC](https://docs.microsoft.com/azure/role-based-access-control/overview) to correctly access the resources. To be able to update the resources, you will need to assign the *Contributor* role to the function identity.

## Deployment considerations

For critical automation workflows that manage behavior of your application, it is strongly recommended to achieve zero downtime deployment with an efficient DevOps pipeline. For more discussion on this, read [serverless backend deployment](https://docs.microsoft.com/azure/architecture/reference-architectures/serverless/web-app#back-end-deployment).

Keep the resources required by the automation in a [separate resource group](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-overview#resource-groups) if the automation spans multiple applications. For automating a single application, a single life cycle can be maintained by keeping automation and application resources in one resource group.

If the workflow involves a number of automation functions, group the functions catering to one scenario in a single function app. Read [Manage function app](https://docs.microsoft.com/azure/azure-functions/functions-how-to-use-azure-function-app-settings) for more information.

## Deploy the solution

To deploy the reference implementations for this architecture, see the [GitHub page](https://github.com/mspnp/serverless-automation), and open one of the two workflows.

## Next steps

To learn more about the serverless implementations, start [here](https://docs.microsoft.com/azure/architecture/reference-architectures/#serverless-applications).
