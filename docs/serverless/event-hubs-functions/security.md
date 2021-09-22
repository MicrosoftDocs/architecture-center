---
title: Guidance for securing Azure Functions with Event Hubs
description: Learn how to securely develop and deploy efficient and scalable code that runs on Azure Functions and responds to Event Hubs events.
author: dbarkol
ms.author: dabarkol
ms.topic: conceptual
ms.date: 09/22/2021
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - compute
categories:
  - compute
products:
  - azure-event-hubs
  - azure-functions
ms.custom:
  - guide
---

# Securing Azure Functions with Event Hubs

In general, when configuring access to resources in Azure, applying fine-grained control over permissions to those resources is strongly encouraged. This means that access should be based on *need to know* and *least privilege* security principles to ensure that clients can only perform the limited set of actions that have been assigned to them.

## Authorizing Access to Event Hubs

Authorizing access to Azure Event Hubs resources can be done using the following security constructs:

- **Azure Active Directory:** Azure Active Directory (Azure AD) provides role-based access control (RBAC) for granular control over a client’s access to Event Hub resources. Based on roles and permissions granted, Azure AD will authorize requests using an OAuth 2.0 access token.

- **Shared access signature:** A shared access signature (SAS) offers the ability to protect Event Hubs resources based on authorization rules. Authorization policies are created by selecting a combination of [policy rules](/azure/event-hubs/authorize-access-shared-access-signature#shared-access-authorization-policies), such as the ability to send messages, listen to messages and manage the entities in the namespace.

### Shared access signature considerations

When using a shared access signature with Azure Functions and Event Hubs, the following considerations should be reviewed:

- **Avoid the Manage right:** In addition to being able to manage the entities in an Event Hubs namespace, the Manage right includes both Send and Listen rights. Ideally, an Azure Function should only be granted a combination of the Send and Listen rights, based on the actions they perform.

- **Do not use the default Manage rule**: Avoid using the default policy rule named *RootManageSharedAccessKey* unless it is completely necessary for an Azure Function, which should be an extremely rare case. Another caveat to this default rule is that it is created at the namespace level, and grants permissions to all underlying event hubs.

- **Review shared access policy scopes:** Shared access policies can be created at the namespace level as well as per Event Hub. Consider creating granular access policies that are tailored for each client to limit their range and permissions.

### Managed identity

In Azure, an Active Directory identity can be assigned to a managed resource such as an Azure Function or App Service. Once an identity is assigned, it has the capabilities to work with other resources that use Azure AD for authorization, much like a [service principal](/azure/active-directory/develop/app-objects-and-service-principals).

When running in Azure, Functions can be assigned a [managed identity](/azure/app-service/overview-managed-identity) and take advantage of identity-based connections for a subset of services, including Event Hubs. Identity-based connections provide support for both the trigger and output binding extensions and must use the [Event Hubs extension 5.x and higher](/azure/azure-functions/functions-bindings-event-hubs#event-hubs-extension-5x-and-higher) for support.

### References

- [Authorize access with Azure Active Directory](/azure/event-hubs/authorize-access-azure-active-directory)
- [Authorize access with a shared access signature in Azure Event Hubs](/azure/event-hubs/authorize-access-shared-access-signature)
- [Event Hubs extension 5.x](/azure/azure-functions/functions-bindings-event-hubs#event-hubs-extension-5x-and-higher)
- [Configure an identity-based resource](/azure/azure-functions/functions-reference#configure-an-identity-based-connection)

## Network

By default, Event Hubs namespaces are accessible from the internet, so long as the request comes with valid authentication and authorization. There are three options for limiting network access to Event Hubs namespaces:

- [Allow access from specific IP addresses](/azure/event-hubs/event-hubs-ip-filtering)
- [Allow access from specific virtual networks (service endpoints)](/azure/event-hubs/event-hubs-service-endpoints)
- [Allow access via private endpoints](/azure/event-hubs/private-link-service)

In all cases, it is important to note that at least one IP firewall rule or virtual network rule for the namespace is specified. Otherwise, if no IP address or virtual network rule is specified, the namespace is accessible over the public internet (using the access key).

Azure Functions can be configured to consume events from, or publish events to, Event Hubs which are set up with either service endpoints or private endpoints. Regional virtual network integration is needed for Azure Functions to work with resources, such as Event Hubs, via a service endpoint or a private endpoint.

When setting up Azure Functions to work with a private endpoint enabled resource, it is necessary to set the WEBSITE_VNET_ROUTE_ALL application setting to 1. In addition, if you want to fully lock down your function app, you will also need to [restrict your storage account](/azure/azure-functions/configure-networking-how-to#restrict-your-storage-account-to-a-virtual-network).

To trigger (consume) events in a virtual network environment, the function app will need to be hosted in either an Azure Functions Premium plan, an App Service plan, or an App Service Environment.

Additionally, running in an Azure Functions Premium plan, and consuming events from a virtual network restricted Event Hub, will require virtual network trigger support, also referred to as [Runtime Scale Monitoring](/azure/azure-functions/functions-networking-options#virtual-network-triggers-non-http). Runtime Scale Monitoring can be configured via the Azure portal, Azure CLI, or other deployment solutions. Runtime Scale Monitoring is not available when the function is running in an App Service plan or App Service Environment.

It is important to note that version 4.1.0 or higher of the Microsoft.Azure.WebJobs.Extensions.EventHubs extension is required for Runtime Scale Monitoring with Event Hubs.

References:

- [Azure Event Hubs Firewall Rules - Azure Event Hubs \| Microsoft Docs](/azure/event-hubs/event-hubs-ip-filtering)
- [Virtual Network service endpoints - Azure Event Hubs - Azure Event Hubs \| Microsoft Docs](/azure/event-hubs/event-hubs-service-endpoints)
- [Integrate Azure Event Hubs with Azure Private Link Service - Azure Event Hubs \| Microsoft Docs](/azure/event-hubs/private-link-service)
- [Azure Functions networking options \| Microsoft Docs](/azure/azure-functions/functions-networking-options#virtual-network-triggers-non-http)

## Next steps

> [!div class="nextstepaction"]
> [Observability](./observability.md)
