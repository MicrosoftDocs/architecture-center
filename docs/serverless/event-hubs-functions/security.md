---
title: Secure Azure Functions with Event Hubs
description: Learn how to securely develop and deploy efficient and scalable code that runs on Azure Functions and responds to Event Hubs events.
author: dbarkol
ms.author: dabarkol
ms.topic: conceptual
ms.date: 10/04/2021
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

# Secure Azure Functions with Event Hubs

When configuring access to resources in Azure, you should apply fine-grained control over permissions to resources. Access to these resources should be based on *need to know* and *least privilege* security principles to make sure that clients can only perform the limited set of actions assigned to them.

## Authorizing Access to Event Hubs

Authorizing access to Azure Event Hubs resources can be done using the following security constructs:

- **Azure Active Directory:** Azure Active Directory (Azure AD) provides role-based access control (RBAC) for granular control over a client's access to Event Hubs resources. Based on roles and permissions granted, Azure AD will authorize requests using an OAuth 2.0 access token.

- **Shared access signature:** A shared access signature (SAS) offers the ability to protect Event Hubs resources based on authorization rules. You define authorization policies by selecting one or more [policy rules](/azure/event-hubs/authorize-access-shared-access-signature#shared-access-authorization-policies), such as the ability to send messages, listen to messages, and manage the entities in the namespace.

### Shared access signature considerations

When using a shared access signature with Azure Functions and Event Hubs, the following considerations should be reviewed:

- **Avoid the Manage right:** In addition to being able to manage the entities in an Event Hubs namespace, the Manage right includes both Send and Listen rights. Ideally, a function app should only be granted a combination of the Send and Listen rights, based on the actions they perform.

- **Don't use the default Manage rule**: Avoid using the default policy rule named *RootManageSharedAccessKey* unless it's needed by your function app, which should be an uncommon scenario. Another caveat to this default rule is that it's created at the namespace level and grants permissions to all underlying event hubs.

- **Review shared access policy scopes:** Shared access policies can be created at the namespace level and per event hub. Consider creating granular access policies that are tailored for each client to limit their range and permissions.

### Managed identity

An Active Directory identity can be assigned to a managed resource in Azure such as a function app or web app. Once an identity is assigned, it has the capabilities to work with other resources that use Azure AD for authorization, much like a [service principal](/azure/active-directory/develop/app-objects-and-service-principals).

Function apps can be assigned a [managed identity](/azure/app-service/overview-managed-identity) and take advantage of identity-based connections for a subset of services, including Event Hubs. Identity-based connections provide support for both the trigger and output binding extensions and must use the [Event Hubs extension 5.x and higher](/azure/azure-functions/functions-bindings-event-hubs#event-hubs-extension-5x-and-higher) for support.

## Network

By default, Event Hubs namespaces are accessible from the internet, so long as the request comes with valid authentication and authorization. There are three options for limiting network access to Event Hubs namespaces:

- [Allow access from specific IP addresses](/azure/event-hubs/event-hubs-ip-filtering)
- [Allow access from specific virtual networks (service endpoints)](/azure/event-hubs/event-hubs-service-endpoints)
- [Allow access via private endpoints](/azure/event-hubs/private-link-service)

In all cases, it's important to note that at least one IP firewall rule or virtual network rule for the namespace is specified. Otherwise, if no IP address or virtual network rule is specified, the namespace is accessible over the public internet (using the access key).

Azure Functions can be configured to consume events from or publish events to event hubs, which are set up with either service endpoints or private endpoints. Regional virtual network integration is needed for your function app to connect to an event hub using a service endpoint or a private endpoint.

When setting up Functions to work with a private endpoint enabled resource, you need to set the `WEBSITE_VNET_ROUTE_ALL` application setting to `1`. If you want to fully lock down your function app, you also need to [restrict your storage account](/azure/azure-functions/configure-networking-how-to#restrict-your-storage-account-to-a-virtual-network).

To trigger (consume) events in a virtual network environment, the function app needs to be hosted in a Premium plan, a Dedicated (App Service) plan, or an App Service Environment (ASE).

Additionally, running in an Azure Functions Premium plan and consuming events from a virtual network restricted Event Hub requires virtual network trigger support, also referred to as [runtime scale monitoring](/azure/azure-functions/functions-networking-options#virtual-network-triggers-non-http). Runtime scale monitoring can be configured via the Azure portal, Azure CLI, or other deployment solutions. Runtime scale monitoring isn't available when the function is running in a Dedicated (App Service) plan or an ASE.

To use runtime scale monitoring with Event Hubs, you need to use version 4.1.0 or higher of the Microsoft.Azure.WebJobs.Extensions.EventHubs extension.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [David Barkol](https://www.linkedin.com/in/davidbarkol/) | Principal Solution Specialist GBB

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Before continuing, consider reviewing these related articles:

- [Authorize access with Azure Active Directory](/azure/event-hubs/authorize-access-azure-active-directory)
- [Authorize access with a shared access signature in Azure Event Hubs](/azure/event-hubs/authorize-access-shared-access-signature)
- [Configure an identity-based resource](/azure/azure-functions/functions-reference#configure-an-identity-based-connection)

> [!div class="nextstepaction"]
> [Observability](./observability.yml)

## Related resources

- [Monitoring serverless event processing](../guide/monitoring-serverless-event-processing.md) provides guidance on monitoring serverless event-driven architectures.
- [Serverless event processing](../../reference-architectures/serverless/event-processing.yml) is a reference architecture detailing a typical architecture of this type, with code samples and discussion of important considerations.
- [De-batching and filtering in serverless event processing with Event Hubs](../../solution-ideas/articles/serverless-event-processing-filtering.yml) describes in more detail how these portions of the reference architecture work.
