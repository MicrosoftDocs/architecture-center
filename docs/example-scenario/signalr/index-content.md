<!-- cSpell:ignore CNAME -->

This scenario describes how to architect a solution that processes changes to underlying data within a web view, without the need for a page refresh, by using real-time services. Examples that use this scenario include real-time tracking of products and goods, and social media solutions.

## Architecture

:::image type="content" alt-text="Architectural diagram showing Azure service bus queue, Azure Functions, and SignalR sharing live location data." source="./archdiagram.png" lightbox="./archdiagram.png":::

*Download a [Visio file](https://arch-center.azureedge.net/archdiagram.vsdx) of this architecture.*

### Components

- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a highly reliable cloud messaging service between applications and services, even when one or more are offline.
- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service) makes it easy to add real-time communications to your web application.
- [Azure Functions](https://azure.microsoft.com/services/functions) is an event-driven, serverless compute platform that can also solve complex orchestration problems.

### Alternatives

Alternatives exist to address this scenario, including [Pusher](https://pusher.com). It's the category leader in robust APIs for app developers who build scalable real-time communication features.

There's also [PubNub](https://pubnub.com). PubNub makes it easy for you to add real-time capabilities to your apps, without worrying about the infrastructure. Build apps that allow your users to engage in real time across mobile, browser, desktop, and server.

[Ably](https://ably.com) is another alternative. It provides serverless publish/subscribe (pub/sub) messaging, which scales reliably with your needs. The messaging is delivered at the edge using WebSockets. The Ably platform provides a highly available, elastically scalable, and globally distributed real-time infrastructure, at the call of an API.

Although Pusher, PubNub, and Ably are the most widely adopted platforms for real-time messaging, for this scenario, you'll do everything in Azure. We recommend SignalR as the go-to platform, because it allows bi-directional communication between server and client. It's also an open-source tool, with 7.9&nbsp;thousand GitHub stars and 2.2&nbsp;thousand GitHub forks.

For more information, see the [SignalR open-source repository](https://github.com/SignalR/SignalR) on GitHub.

## Scenario details

In this scenario, you'll look at how to set up a real-time messaging service to share the live location of a food delivery service transaction. This example can also be useful for those trying to build a real-time location-sharing platform for their web or mobile applications.

You'll use a SignalR service configured in serverless mode to integrate with an Azure Functions app that's triggered by a service bus, all of it by using .NET Core.

### Potential use cases

These other use cases have similar design patterns:

- Sharing real-time location with client devices
- Pushing notifications to users
- Updating timelines
- Creating chat rooms

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Here are a couple of things to keep in mind as you develop this scenario, including how to configure parameters in the Azure Service Bus connection string in ServiceBusTrigger:

* **Hubs**: Hubs can be compared to a video streaming service. You can subscribe to a hub to send and receive messages from and to it.
* **Targets**: Targets are like radio channels. They include everyone who's listening to the target channel, and they're notified when there's a new message on it.

If you can remember the preceding two features of the SignalR platform, it will be easy to get up and running quickly.

### Availability, scalability, and security

You can achieve high availability with this solution by following what's described in the next two sections.

#### Regional pairing

Each Azure region is paired with another region within the same geography. In general, choose regions from the same regional pair (for example, East US 2 and Central US). Benefits of doing so include:

- If there's a broad outage, recovery of at least one region out of every pair is prioritized.
- Planned Azure system updates are rolled out to paired regions sequentially to minimize possible downtime.
- In most cases, regional pairs reside within the same geography to meet data residency requirements.
- However, make sure that both regions support all the Azure services that are needed for your application. See [Services by region](https://azure.microsoft.com/regions/#services). For more information about regional pairs, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions).

#### Azure Front Door

:::image type="content" alt-text="Architectural diagram showing how Azure Front Page works to provide high availability for a mobile app." source="./haarchitecture.png" lightbox="./haarchitecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/haarchitecture.vsdx) of this architecture.*

Azure Front Door is a scalable and secure entry point for fast delivery of your global applications. When you use *priority routing*, it automatically fails over if the primary region becomes unavailable. A multi-region architecture can provide higher availability than deploying to a single region. If a regional outage affects the primary region, you can use Front Door to fail over to the secondary region. 

This architecture can also help if an individual subsystem of the solution fails. Stop network and application layer attacks at the edge with Web Application Firewall and DDoS Protection. Harden your service by using Microsoft-managed rule sets, and author your own rules for custom protection of your app.

Front Door is a possible failure point in the system. If the service fails, clients can't access your application during the downtime. Review the [Front Door service-level agreement (SLA)](https://azure.microsoft.com/support/legal/sla/frontdoor) and determine whether using Front Door alone meets your business requirements for high availability. If not, consider adding another traffic management solution as a fallback. If the Front Door service fails, change your canonical name (CNAME) records in DNS to point to the other traffic management service. You must perform this step manually, and your application will be unavailable until the DNS changes are propagated.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Let's assume that your business has 1,000 orders a day and needs to share location data with all of them concurrently. Your estimated Azure usage for deploying this scenario will be close to USD192 per month, based on pricing at the date of publication.

| Service type          | Estimated monthly cost |
|--- |---:|
| Azure Functions       | USD119.40        |
| Azure SignalR Service | USD48.97         |
| Azure Service Bus     | USD23.71         |
| Total                 | USD192.08        |

## Deploy this scenario

### Azure Functions development

A serverless real-time application that's built with Azure Functions and Azure SignalR Service ordinarily requires two Azure Functions:

- A `negotiate` function that the client calls to obtain a valid SignalR Service access token and service endpoint URL.
- One or more functions that send messages or manage group membership.

### SignalRFunctionApp

SignalRFunctionApp is a function app that creates an Azure Functions instance, with a service bus trigger with SignalR.

#### Negotiate.cs

This function is triggered by an HTTP request. It's used by client applications to get a token from the SignalR service, which clients can use to subscribe to a hub. This function should be named `negotiate`. For more information, see [Azure Functions development and configuration with Azure SignalR Service](/azure/azure-signalr/signalr-concept-serverless-development-config),

#### Message.cs

This function is triggered by a service bus trigger. It has a binding with SignalR service. It pulls the message from the queue and passes it on to a SignalR hub.

#### Instructions

Before you begin:
* Make sure that you have a service bus queue provisioned on Azure.
* Make sure that you have a SignalR service provisioned in serverless mode on Azure.

1. Enter your connection strings (Service Bus and SignalR) in the *local.settings.json* file.
1. Enter the URL of the client application (SignalR client) in CORS (Cross-Origin Resource Sharing). For the most recent syntax, see [Azure Functions development and configuration with Azure SignalR Service](/azure/azure-signalr/signalr-concept-serverless-development-config).
1. Enter your service bus queue name in the service bus trigger in the *Message.cs* file.

Now, let's configure the client application to test it. First, grab the example sources from the [solution-architectures](https://github.com/mspnp/solution-architectures/tree/master/signalr) GitHub page.

### SignalR client

This is a simple .NET Core web application to subscribe to the hub that's created by SignalRFunctionApp. It displays messages that are received on the service bus queue in real time. Although you can use SignalRFunctionApp to work with a mobile client, let's stick to the web client for this scenario in this repository.

<!-- markdownlint-disable MD024 -->

#### Instructions

1. Make sure that SignalRFunctionApp is running.
1. Copy the URL that's generated by the negotiate function. It looks something like this: `http://localhost:7071/api/`.
1. Paste the URL in the *chat.js* file, inside `signalR.HubConnectionBuilder().withUrl("YOUR_URL_HERE").build();`.
1. Run the application.

   The status is connected when the web client successfully subscribes to the SignalR hub.

### SendToQueue.js

This node.js script pushes a message to the Service Bus, so that you can test the deployment you've just completed.

#### Instructions

1. Install the node Azure Service Bus module (@azure/service-bus).

1. Enter your connection strings and queue name in the script.

1. Run the script.

## Next steps

You can take this scenario into your production environment. However, make sure that your Azure services are set to scale. For instance, your Azure Service Bus should be set to a standard or premium plan.

You can deploy the code to Azure Functions right from Visual Studio. To learn how to publish your code to Azure Functions from Visual Studio, follow the [It’s how you make software](https://tutorials.visualstudio.com/first-azure-function/publish) guide.

See [how to work with Azure Service Bus bindings in Azure Functions](/azure/azure-functions/functions-bindings-service-bus). Azure Functions supports trigger and output bindings for service bus queues and topics.

See [how to authenticate and send real-time messages](/azure/azure-functions/functions-bindings-signalr-service) to clients that are connected to Azure SignalR Service, by using SignalR Service bindings in Azure Functions. Azure Functions supports input and output bindings for SignalR Service.

## Related resources

- [High-volume batch transaction processing](/azure/architecture/example-scenario/mainframe/process-batch-transactions)
- [Transit hub dynamic pub-sub messaging system](/azure/architecture/solution-ideas/articles/transit-hub)
- [Serverless event processing](/azure/architecture/reference-architectures/serverless/event-processing)
- [Blockchain workflow application](/azure/architecture/solution-ideas/articles/blockchain-workflow-application)
- [Event-based cloud automation](/azure/architecture/reference-architectures/serverless/cloud-automation)
