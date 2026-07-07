---
title: Secure Azure Functions with Event Hubs
description: Learn how to securely develop and deploy efficient and scalable code that runs on Azure Functions and responds to Event Hubs events.
author: dbarkol
ms.author: dabarkol
ms.topic: concept-article
ms.date: 04/22/2026
ms.subservice: architecture-guide
---

# Secure Azure Functions with Azure Event Hubs

When you configure access to resources in Azure, apply fine-grained control over permissions to resources. Base access to these resources on *need to know* and *least privilege* security principles to make sure that clients can only perform the limited set of actions granted to them.

## Authorizing access to Event Hubs

You can authorize access to Azure Event Hubs resources by using the following security constructs:

- **Microsoft Entra ID:** Microsoft Entra ID provides Azure role-based access control (Azure RBAC) for granular control over a client's access to Event Hubs resources. Based on roles and permissions granted, Microsoft Entra ID authorizes requests by using an OAuth 2.0 access token.

- **Shared access signature:** You can use a shared access signature to protect Event Hubs resources based on authorization rules. You define authorization policies by selecting one or more [policy rules](/azure/event-hubs/authorize-access-shared-access-signature#shared-access-authorization-policies), such as the ability to send messages, listen to messages, and manage the entities in the namespace.

### Considerations for using a shared access signature

Take into account the following considerations when you use a shared access signature with Azure Functions and Event Hubs:

- **Avoid the Manage right:** In addition to providing the ability to manage the entities in an Event Hubs namespace, the Manage right provides both Send and Listen rights. Ideally, a function app should only be granted a combination of the Send and Listen rights, depending on the actions it performs.

- **Don't use the default Manage rule:** Avoid using the default policy rule named *RootManageSharedAccessKey*, unless it's needed by your function app, which should be an uncommon scenario. Another caveat to this default rule is that it's created at the namespace level and grants permissions to all underlying event hubs.

- **Review shared access policy scopes:** Shared access policies can be created at the namespace level and at the event hub level. Consider creating granular access policies that are tailored for each client to limit the range and permissions of clients.

### Managed identity

An identity can be assigned to a managed resource in Azure, like a function app or web app. After you assign an identity, it can interact with other resources that use Microsoft Entra ID for authorization, much like a [service principal](/entra/identity-platform/app-objects-and-service-principals).

Function apps can be assigned a [managed identity](/azure/app-service/overview-managed-identity) and take advantage of identity-based connections for a subset of services, including Event Hubs. Identity-based connections provide support for both the trigger and output binding extensions.

## Network

By default, Event Hubs namespaces can be accessed from the internet, as long as the request provides valid authentication and authorization. To limit network access to Event Hubs namespaces, consider these three options:

- [Allow access from specific IP addresses](/azure/event-hubs/event-hubs-ip-filtering)
- [Allow access from specific virtual networks (service endpoints)](/azure/event-hubs/event-hubs-service-endpoints)
- [Allow access via private endpoints](/azure/event-hubs/private-link-service)

In all cases, at least one IP firewall rule or virtual network rule for the namespace is specified. Otherwise, if no IP address or virtual network rule is specified, the namespace can be accessed over the public internet (via the access key).

You can configure Azure Functions to consume events from or publish events to event hubs that are set up with either service endpoints or private endpoints. Your function app requires regional virtual network integration to connect to an event hub through a service endpoint or private endpoint.

When you integrate Functions with a virtual network and enable `vnetRouteAllEnabled`, all outbound traffic from the function app is forced through the virtual network. This configuration is especially important for scenarios where you want to secure your function app by ensuring that all traffic, including traffic to Azure services, goes through your virtual network for inspection and control. If you want to fully lock down your function app, you also need to [restrict your storage account](/azure/azure-functions/configure-networking-how-to#restrict-your-storage-account-to-a-virtual-network).

To consume events in a virtual network environment, you need to host the function app in a Premium plan, a Dedicated (App Service) plan, or an App Service Environment.

Additionally, running in an Azure Functions Premium plan and consuming events from a virtual-network-restricted Event Hub requires virtual network trigger support, also referred to as [runtime scale monitoring](/azure/azure-functions/functions-networking-options#virtual-network-triggers-non-http). You can configure runtime scale monitoring by using the Azure portal, the Azure CLI, or other deployment solutions. Runtime scale monitoring isn't available when the function is running in a Dedicated (App Service) plan or an App Service Environment.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [David Barkol](https://www.linkedin.com/in/davidbarkol/) | AI Apps GBB

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Before you continue, consider reviewing these related articles:

- [Authorize access with Microsoft Entra ID](/azure/event-hubs/authorize-access-azure-active-directory)
- [Authorize access by using a shared access signature in Event Hubs](/azure/event-hubs/authorize-access-shared-access-signature)
- [Configure an identity-based resource](/azure/azure-functions/functions-reference#configure-an-identity-based-connection)

> [!div class="nextstepaction"]
> [Observability](./observability.yml)
