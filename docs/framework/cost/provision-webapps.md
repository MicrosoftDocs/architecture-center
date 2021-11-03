---
title: Web application cost estimates
description: Describes cost strategies for web apps
author: v-aangie
ms.date: 09/02/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-app-service
ms.custom:
  - article
---

# Web application cost estimates

All web applications (apps) have no up-front cost or termination fees. Some charge only for what you use and others charge per-second or per-hour. In addition, all web apps run in App Service plans. Together these costs can help determine the total cost of a web app.

Use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator/) to help create various cost scenarios.

## App Service plans

The App Service plans include the set of compute resources needed for the web app to run. Except for Free tier, an App Service plan carries a charge on the compute resources it uses. For a description of App Service plans, see Azure [App Service plan overview](/azure/app-service/overview-hosting-plans).

You can potentially save money by choosing one or more App Service plans. To help find the solution that meets your business requirements, see [Should I put an app in a new plan or an existing plan?](/azure/app-service/overview-hosting-plans#should-i-put-an-app-in-a-new-plan-or-an-existing-plan)

The *pricing tier* of an App Service plan determines what App Service features you get and how much you pay for the plan. The higher the tier, the higher the cost. For details on the pricing tiers, see [App Service Pricing](https://azure.microsoft.com/pricing/details/app-service/windows/).

**Are there exceptions that impact App Services plan cost?**
***

You don't get charged for using the App Service features that are available to you (such as configuring custom domains, TLS/SSL certificates, deployment slots, backups, and so on). For a list of exceptions, see [How much does my App Service plan cost?](/azure/app-service/overview-hosting-plans#how-much-does-my-app-service-plan-cost)

## App Service cost

App Service plans are billed on a per second basis. If your solution includes several App Service apps, consider deploying them to separate App Service plans. This approach enables you to scale them independently because they run on separate instances, which saves unnecessary cost.

Azure App Service supports two types of SSL connections: Server Name Indication (SNI) SSL Connections and IP Address SSL Connections. SNI-based SSL works on modern browsers while IP-based SSL works on all browsers. If your business requirements allow, use SNI-based SSL instead of IP-based SSL. There is no charge for SNI-based. IP-based SSL incurs a cost per connection.

See the SSL Connections section in [App Service pricing](https://azure.microsoft.com/pricing/details/app-service/windows/) for details.

## API Management cost

If you want to publish APIs hosted on Azure, on-premises, and in other clouds more securely, reliably, and at scale, use API Management. The pricing tier you choose depends on the features needed based on the business requirements. For example, depending on your requirements for scalability, the number of units required to scale out range from 1-10. As the number of units increases, the cost of the pricing tier increases.

Self-hosted gateways are available in the Developer and Premium pricing tiers. There is an additional cost for this service using the Premium tier. There is no cost for self-hosted gateways if using the Developer tier.

For pricing details, see [API Management Pricing](https://azure.microsoft.com/pricing/details/api-management/).

## Content Delivery Network (CDN) cost

If you want to offer users optimal online content delivery, use CDN in your workload. The data size being used has the most significant impact on cost, so you'll want to choose based on your business requirements. Purchasing data in increments of TB is significantly higher than purchasing data in increments of GB.

The provider you choose also can impact cost. Choose Microsoft as the provider to get the lowest cost.

Some data, such as shopping carts, search results, and other dynamic content, is not cacheable. CDN offers Acceleration Data Transfers, also called Dynamic Site Acceleration (DSA), to accelerate this type of web content. The price for DSA is the same across Standard and Premium profiles.

For pricing details, see [Content Delivery Network pricing](https://azure.microsoft.com/pricing/details/cdn/).

## Azure Cognitive Search cost

To set up and scale a search experience quickly and cost-effectively, use Azure Cognitive Search. When you create an Azure Cognitive Search service, a resource is created at a pricing tier (or SKU) that's fixed for the lifetime of the service. Billing depends on the type of service. See [Search API](/azure/cognitive-services/welcome#search-apis) for a list of services.

The charges are based on the number of transactions for each type of operation specific to a service. A certain number of transactions are free. If you need additional transactions, choose from the Standard instances.

For pricing details, see [Azure Cognitive Search pricing](https://azure.microsoft.com/pricing/details/search).

## Azure SignalR cost

Use SignalR for any scenario that requires pushing data from server to client in real time. For example, Azure SignalR provides secure and simplified communication between client and app one-to-one (such as a chat window) or one-to-many (instant broadcasting, IoT dashboards, or notification to social network). To learn more about Azure SignalR, see [What is Azure SignalR Service?](/azure/azure-signalr/signalr-overview#what-is-azure-signalr-service-used-for)

The Free tier is not recommended for a production environment. With the Standard tier, you pay only for what you use. A Standard tier is recommended as an enterprise solution because it offers a large number of concurrent connections and messages.

For pricing details, see [Azure SignalR Service pricing](https://azure.microsoft.com/pricing/details/signalr-service).

## Notification Hubs cost

To broadcast push notifications to millions of users at once, or tailor notifications to individual users, use Notification Hubs. Pricing is based on number of pushes. The Free tier is a good starting point for exploring push capabilities but is not recommended for production apps. If you require more pushes and features such as scheduled pushes or multi-tenancy, you can buy additional pushes per million for a fee.

See [Push notifications with Azure Notification Hubs: Frequently asked questions](/azure/notification-hubs/notification-hubs-push-notification-faq) for more information. For pricing details, see [Notification Hubs pricing](https://azure.microsoft.com/pricing/details/notification-hubs/).
