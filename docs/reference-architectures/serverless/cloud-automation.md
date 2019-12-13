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

Automating workflows and repetitive tasks on the cloud using [serverless technologies](https://azure.microsoft.com/solutions/serverless/), can dramatically improve productivity of an organization's DevOps team. A serverless model is best suited for automation scenarios that fit an [event driven approach](https://docs.microsoft.com/azure/architecture/guide/architecture-styles/event-driven). This reference architecture illustrates two such cloud automation scenarios:

1. [Cost center tagging](https://github.com/mspnp/serverless-automation/blob/master/src/automation/cost-center/deployment.md) - This implementation tracks the cost centers of each Azure resource. The [Azure Policy](https://docs.microsoft.com/azure/governance/policy/) service [tags all new resources](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-using-tags) in a group with a default cost center ID. The Event Grid monitors resource creation events, and then calls an [Azure function](https://docs.microsoft.com/azure/azure-functions/). The function interacts with Azure Active Directory, and validates the cost center ID for the new resource. If different, it updates the tag and sends out an email to the resource owner. The REST queries for Azure Active Directory are mocked out for simplicity. Azure AD can also be integrated using the [Azure AD PowerShell module](https://docs.microsoft.com/powershell/module/azuread/?view=azureadps-2.0) or the [ADAL for Python library](https://pypi.org/project/adal/).

1. [Throttling response](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/deployment.md) - This implementation monitors a Cosmos DB database for throttling. [Azure Monitor alerts](https://docs.microsoft.com/azure/azure-monitor/overview#alerts) are triggered when data access requests to CosmosDB exceed the [capacity in Request Units (or RUs)](https://docs.microsoft.com/azure/cosmos-db/request-units). An [Azure Monitor action group](https://azure.microsoft.com/resources/videos/azure-friday-azure-monitor-action-groups/) is configured to call the automation function in response to these alerts. The function scales the RUs to a higher value, increasing the capacity and in turn stopping the alerts. Note that the [CosmosDB autopilot mode (Preview)](https://docs.microsoft.com/azure/cosmos-db/provision-throughput-autopilot) is an alternative to this implementation.

![Serverless cloud automation](./_images/cloud-automation.png)

![GitHub logo](../../_images/github.png) The reference implementations for this architecture are available on [GitHub](https://github.com/mspnp/serverless-automation).

The functions in these implementations are written in PowerShell and Python, two of the most common scripting languages used in automation. They are deployed using [Azure Functions Core Tools](https://docs.microsoft.com/azure/azure-functions/functions-run-local) in Azure CLI. Alternatively, you can try a preview version of [PowerShell cmdlet to deploy and manage Azure Functions](https://www.powershellgallery.com/packages/Az.Functions/0.0.1-preview).

## Patterns in event-based automation

Event-based automation scenarios are best implemented using Azure Functions. They follow these common patterns:

1. **Respond to events on resources**. These are responses to events such as an Azure resource or resource group getting created, deleted, changed, and so on. This pattern uses [Event Grid](https://docs.microsoft.com/azure/event-grid/overview) to trigger the function for such events. The cost center tagging implementation is an example of this pattern. Other common scenarios include:

    1. granting the DevOps teams access to newly created resource groups,
    1. sending notification to the DevOps when a resource is deleted, and
    1. responding to maintenance events for resources such as Azure Virtual Machines (VMs).

1. **Scheduled tasks**. These are typically maintenance tasks executed using [timer-triggered functions](https://docs.microsoft.com/azure/azure-functions/functions-create-scheduled-function). Examples of this pattern are:

    1. stopping a VM at night, and starting in the morning,
    1. reading Blob Storage content at regular intervals, and converting to a CosmosDB document, and
    1. periodically scanning for resources no longer in use, and removing them.

1. **Process Azure alerts**. This pattern leverages the ease of integrating Azure Monitor alerts and action groups with Azure Functions. The function typically takes remedial actions in response to metrics, log analytics, and alerts originating in the applications as well as the infrastructure. The throttling response implementation is an example of this pattern. Other common scenarios are:

    1. truncating the table when SQL Database reaches maximum size,
    1. restarting a service in a VM when it is erroneously stopped, and
    1. sending notifications if a function is failing.

1. **Orchestrate with external systems**. This pattern enables integration with external systems, using [Logic Apps](https://docs.microsoft.com/azure/logic-apps/) to orchestrate the workflow. [Logic Apps connectors](https://docs.microsoft.com/azure/connectors/apis-list) can easily integrate with several third-party services as well as Microsoft services such as Office 365. Azure Functions can be used for the actual automation. The cost center tagging implementation demonstrates this pattern. Other common scenarios include:

    1. monitoring IT processes such as change requests or approvals, and
    1. sending email notification when automation task is completed.

1. **Expose as a *web hook* or API**. Automation tasks using Azure Functions can be integrated into third-party applications or even command-line tools, by exposing the function as a web hook/API using [an HTTP trigger](https://docs.microsoft.com/azure/azure-functions/functions-create-first-azure-function). Multiple authentication methods are available in both PowerShell and Python to secure external access to the function. The automation happens in response to the app-specific external events, for example, integration with power apps or GitHub. Common scenarios include:

    1. triggering automation for a failing service, and
    1. onboarding users to the organization's resources.

## Architecture

The architecture consists of the following blocks:

**Azure Functions**. Azure Functions provide the event-driven, serverless compute capabilities in this architecture. A function performs automation tasks, when triggered by events or alerts. In the reference implementations, a function is invoked with an HTTP request. Code complexity should be minimized, by developing the function so that:

- it does exactly one thing (single responsibility principle),
- it returns as soon as possible,
- it is stateless, and
- it is idempotent (that is, multiple executions do not create different results).

To maintain idempotency, the function scaling in the throttling scenario is kept simplistic. In real world automation, make sure to scale up or down appropriately.

Additionally, read the [Optimize the performance and reliability of Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-best-practices) for best practices when writing your functions.

**Logic Apps**. Logic Apps can be used to perform simpler tasks, easily implemented using [the built-in connectors](https://docs.microsoft.com/azure/connectors/apis-list). These tasks can range from email notifications, to integrating with external management applications. To learn how to use Logic Apps with third-party applications, read [basic enterprise integration in Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/enterprise-integration/basic-enterprise-integration).

Logic Apps provides a *no code* or *low code* visual designer, and may be used alone in some automation scenarios. Read [this comparison between Azure Functions and Logic Apps](https://docs.microsoft.com/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-azure-functions-and-azure-logic-apps) to see which service can fit your scenario.

**Event Grid**. Event Grid has built-in support for events from other Azure services, as well as custom events (also called *custom topics*). Operational events such as resource creation can be easily propagated to the automation function, using the Event Grid's built-in mechanism.

Event Grid simplifies the event-based automation with a [publish-subscribe model](https://docs.microsoft.com/azure/event-grid/concepts), allowing reliable automation for events delivered over HTTP.

**Azure Monitor**. Azure Monitor alerts can monitor for critical conditions, and take corrective action using Azure Monitor action groups. These action groups are easily integrated with Azure Functions. This is useful to watch for and fix any error conditions in your infrastructure, such as database throttling.

**Automation action**. This broad block represents other services that your function can interact with, to provide the automation functionality. For example, Azure Active Directory for tag validation as in the first scenario, or a database to provision as in the second scenario.

## Resiliency considerations

### Azure Functions

#### Handle HTTP timeouts

To avoid HTTP timeouts for a longer automation task, queue this event in a [Service Bus](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-messaging-overview#queues), and handle the actual automation in another function. The throttling response automation scenario illustrates this pattern, even though the actual CosmosDB RU provisioning is fast.

![Reliability in automation function](./_images/automation-function-reliability.png)

[Durable functions](https://docs.microsoft.com/azure/azure-functions/durable/durable-functions-overview), which maintain state between invocations, provide an alternative to the above approach. These are currently supported only in JavaScript and C#.

#### Log failures

As a best practice, the function should log any failures in carrying out automation tasks. This allows for proper troubleshooting of the error conditions. The reference implementations use the [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview) as the telemetry system.

#### Concurrency

Verify the concurrency requirement for your automation function. For example, the throttling automation workflow limits the maximum number of [concurrent HTTP calls](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook?tabs=csharp#hostjson-settings) to the function to one, to avoid side-effects of false alarms. The following [host.json](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/throttling-respond/host.json) file illustrates this:

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

Make sure your automation function is idempotent. Both Azure Monitor and Event Grid may emit alerts or events that indicate progression such as your subscribed event is *resolved*, *fired*, *in progress*, etc., your resource is *being provisioned*, *created successfully*, etc., or even send false alerts due to a misconfiguration. Make sure your function acts only on the relevant alerts and events, and ignores all others, so that false or misconfigured events do not cause unwanted results. For more information, read [this blog post on idempotency patterns](https://blog.jonathanoliver.com/idempotency-patterns/).

### Event Grid

If your workflow uses Event Grid, check if your scenario could generate a high volume of events, enough to clog the grid. See [Event Grid message delivery and retry](https://docs.microsoft.com/azure/event-grid/delivery-and-retry) to understand how it handles events when delivery isn't acknowledged, and modify your logic accordingly. The cost center workflow does not implement additional checks for this, since it only watches for resource creation events in a resource group. Monitoring resources created in an entire subscription, can generate larger number of events, requiring a more resilient handling.

### Azure Monitor

If a sufficiently large number of alerts are generated, and the automation updates Azure resources, [throttling limits of the Azure Resource Manager](https://docs.microsoft.com/azure/azure-resource-manager/resource-manager-request-limits#subscription-and-tenant-limits) might be reached. This can negatively affect the rest of the infrastructure in that subscription. Avoid this situation by limiting the *frequency* of alerts getting generated by the Azure Monitor. You may also limit the alerts getting generated for a particular error. Refer to the [documentation on Azure Monitor alerts](https://docs.microsoft.com/azure/azure-monitor/platform/alerts-overview) for more information.

## Security considerations

### Control access to the function

Restrict access to an HTTP-triggered function by setting the [authorization level](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook?tabs=csharp#trigger---configuration). With *anonymous* authentication, the function is easily accessible with a URL such as `http://<APP_NAME>.azurewebsites.net/api/<FUNCTION_NAME>`. *Function* level authentication can obfuscate the http endpoint, by requiring function keys in the URL. This level is set in the file [function.json](https://github.com/mspnp/serverless-automation/blob/master/src/automation/cost-center/cost-center-tagging/OnResourceWriteSuccess/function.json):

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

For production environment, additional strategies might be required to secure the function. In the reference implementations, the functions are executed within the Azure platform by other Azure services, and will not be exposed to the internet. Function authorization is sufficient for functions accessed as web hooks.

Consider adding security layers on top of function authentication, such as,

- authenticating with client certificates, or
- making sure the caller is part of or has access to the directory that hosts the function, by using [Easy Auth integration](https://blogs.msdn.microsoft.com/mihansen/2018/03/25/azure-active-directory-authentication-easy-auth-with-custom-backend-web-api/).

Note that function-level authentication is the only option available to Azure Monitor action groups.

If the function needs to be called from a third-party application or service, it is recommended to provide access to it with an [API Management](https://docs.microsoft.com/azure/api-management/api-management-key-concepts) layer. This layer should enforce authentication. API Management now has a [consumption tier](https://azure.microsoft.com/updates/azure-api-management-consumption-tier-is-now-generally-available/) integrated with Azure Functions, which allows you to pay only if the API gets executed. For more information, read [Create and expose your functions with OpenAPI](https://docs.microsoft.com/azure/azure-functions/functions-openapi-definition).

If the calling service supports service endpoints, the following costlier options could be considered:

- Use a dedicated App Service plan, where you can lock down the functions in a virtual network to limit access to it. This is not possible in a consumption-based serverless model.
- Use the [Azure Functions Premium plan](https://docs.microsoft.com/azure/azure-functions/functions-premium-plan), which includes a dedicated virtual network to be used by your function apps.

To compare pricing and features between these options, read [Azure Functions scale and hosting](https://docs.microsoft.com/azure/azure-functions/functions-scale).

### Control what the function can access

[Managed identities for Azure resources](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview), an Azure Active Directory feature, simplifies how the function authenticates and accesses other Azure resources and services. The code does not need to manage the authentication credentials, since it is managed by Azure AD.

There are two types of managed identities:

- **System-assigned managed identities**: These are created as part of the Azure resource, and cannot be shared among multiple resources. These get deleted when the resource is deleted. Use these for scenarios, which involve single Azure resource or which need independent identities. Both the reference implementations use system-assigned identities since they update only a single resource. Managed identities are only required to update another resource. For example, a function can read the resource tags without a managed identity. See [these instructions](https://docs.microsoft.com/azure/app-service/overview-managed-identity?toc=%2Fazure%2Fazure-functions%2Ftoc.json&tabs=dotnet#adding-a-system-assigned-identity) to add a system-assigned identity to your function.

- **User-assigned managed identities**: These are created as stand-alone Azure resources. These can be shared across multiple resources, and need to be explicitly deleted. Read [these instructions](https://docs.microsoft.com/azure/app-service/overview-managed-identity?toc=%2Fazure%2Fazure-functions%2Ftoc.json&tabs=dotnet#adding-a-user-assigned-identity) on how to add user-assigned identity to your function. Use these for scenarios that:

    - require access to multiple resources that can share a single identity, or
    - need pre-authorization to secure resources during provisioning, or
    - where resources are recycled frequently, while permissions need to be consistent.

Once the identity is assigned to the Azure function, assign it a role using [role-based access control (RBAC)](https://docs.microsoft.com/azure/role-based-access-control/overview) to access the resources. For example, to update a resource, the *Contributor* role will need to be assigned to the function identity.

## Deployment considerations

For critical automation workflows that manage behavior of your application, zero downtime deployment must be achieved using an efficient DevOps pipeline. For more information, read [serverless backend deployment](https://docs.microsoft.com/azure/architecture/reference-architectures/serverless/web-app#back-end-deployment).

If the automation covers multiple applications, keep the resources required by the automation in a [separate resource group](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-overview#resource-groups). A single resource group can be shared between automation and application resources, if the automation covers a single application.

If the workflow involves a number of automation functions, group the functions catering to one scenario in a single function app. Read [Manage function app](https://docs.microsoft.com/azure/azure-functions/functions-how-to-use-azure-function-app-settings) for more information.

## Deploy the solution

To deploy the reference implementations for this architecture, see the [deployment steps on GitHub](https://github.com/mspnp/serverless-automation) for the desired workflow.

## Next steps

To learn more about the serverless implementations, start [here](https://docs.microsoft.com/azure/architecture/reference-architectures/#serverless-applications).
