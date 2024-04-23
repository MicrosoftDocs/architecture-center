---
title: Cross-tenant communication using multitenant applications
description: Learn how to implement bidirectional, secure communications between services that are hosted in Azure subscriptions that are managed by different Microsoft Entra tenants.
author: aulong-msft, ashtmMSFT, John-Garland
ms.author: aulong, ashtm, johngarland
ms.date: 04/24/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - active-directory
  - azure-service-bus
  - entra
  - azure-functions
categories:
  - Identity
  - Security
---

# Cross-tenant communication using multitenant applications

This guide provides a solution to achieve bidirectional, secure communications between services that are hosted in Azure subscriptions that are managed by different Microsoft Microsoft Entra tenants.

Securing multitenant communications in Azure can be challenging due to limitations that are inherent to many services. You can eliminate the need to manage credentials directly by using Azure managed identities to obtain tokens from Microsoft Entra ID. However, Azure managed identities don't work across tenant boundaries, and the typical alternative is to use shared secrets, like shared access signature URLs. Remember that if you use shared secrets, you need to securely distribute and rotate the secrets across Microsoft Entra tenant boundaries. 

One option that avoids this overhead is to create a multitenant application to represent your workload's identity. Through a consent process, you can make this workload identity known to an external tenant and ultimately allow it to authenticate services in the external tenant.

This article covers an example implementation of this pattern and provides [sample code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/edit/main/README.md).

This pattern can be reused for any multitenant scenario that has various services that need to communicate across Microsoft Entra tenant boundaries.

![PoC Infrastructure]([https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/blob/main/Docs/arch.png](https://github.com/aulong-msft/architecture-center-pr/blob/main/docs/patterns/_images/cross-tenant-communication-architecture.png)
                      
## Architecture

![Diagram of the cross-tenant communication architecture.](https://github.com/aulong-msft/architecture-center-pr/blob/main/docs/patterns/_images/cross-tenant-communication-architecture.png)

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

1. An admin on the provider side creates a multitenant application registration and sets up a client secret for it.

1. An admin on the customer side provisions a service principal in their tenant. This service principal is based on the multitenant application that the provider created. You can do this step in various ways. In the example, we chose to craft a URL to provide to the customer tenant admin, but you can use the Graph API instead.

1. The customer applies role-based access control (RBAC) roles to this new service principal so that it's authorized to access Azure Service Bus.

1. The provider's function app uses the client ID and client secret of the application registration to send an authenticated message to the customer's Service Bus queue.

1. The customer's function app uses a managed identity to read the provider's message from the queue via a Service Bus trigger.

1. After it receives the message, the customer's function app typically does some work before sending a status message back to the provider. However in this case, for demo purposes, the function app immediately sends a status message to the provider on a separate queue in the same Service Bus.

1. This function app reads from the status queue from the customer's tenant via a timer that's triggered by Azure Functions.

## Scenario details

A provider has multiple customers. The provider and each customer have their own individual Microsoft Entra ID tenant and Azure resources. The provider and each customer need a secure, bidirectional method of communication so that they can exchange messages via Service Bus queues. The solution should have a compelling identity story that avoids introducing unnecessary credentials or secrets.

### Some context on multitenant applications

- An application object is a globally unique instance of the application.

- When an application is registered in Microsoft Entra, an application object and a service principal object are automatically created in the tenant.

- A service principal object is created in every tenant that uses the application and references the application object. An application object has a one-to-many relationship with its corresponding service principal object.

- The application object is the global representation of your application and is used across all tenants. The service principal object is the local representation that's used in a specific tenant.

- A service principal object must be created in each tenant where the application is used so that it can establish an identity for sign-in or for access to resources that are secured by the tenant. A single-tenant application has only one service principal object in its home tenant. This service principal object is created and allowed for use during application registration. A multitenant application also has a service principal object that's created in each tenant, and a user from that tenant has consented to its use.

- To access resources that are secured by a Microsoft Entra tenant, a security principal must represent the entity that requires access.

- When an application is given permission to access resources in a tenant upon registration or consent, a service principal object is created. This architecture is implemented with the consent flow.

## How does the provider message the customer?

Ideally, the provider is able to assign a managed identity to the Azure compute resource that's responsible for sending messages to a customer's queue. The customer's tenant is configured to trust managed identities from the provider's tenant. However, a true federation, which would essentially allow the "sharing" of identities from one tenant to another, between two Microsoft Entra tenants isn't currently possible. So, the provider needs to authenticate by using an identity that the customer recognizes. The provider needs to authenticate to the customer's Microsoft Entra tenant as a service principal that the customer knows about.

We recommend that the provider registers a multitenant application in its own tenant and then has each customer provision an associated service principal into their tenant. The provider can then authenticate to the customer's tenant and the customer-hosted APIs by using this service principal. The provider never needs to share a client secret in this approach. Credential management is the sole responsibility of the provider.

## How does the customer message the provider?

We recommend that the customer creates or hosts a queue from which the provider can read. The customer writes a message into the queue. By using a service principal object, the provider repeatedly polls each customer queue for messages. The downside of this approach is that it introduces polling latency when receiving a message. Code also needs to run more often in the provider because it must wake up and perform polling logic instead of be triggered by an event. However, credential management remains the sole responsibility of the provider, which bolsters security.

### Alternative solution

Another possible solution is to have the provider create or host a queue for each of its customers. Each customer creates their own multitenant application and requests that the provider provision it in its tenant as a service principal object. The customer then uses this service principal object to send messages to a customer-specific queue on the provider side. Credential management remains the sole responsibility of the customer. One downside to this approach is that the provider must provision service principals that are associated with customer applications into its tenant. This process is manual, and providers likely don't want manual steps to be part of the flow for onboarding a new customer.

## Sample code setup

The following steps guide you through the process of setting up cross-tenant communication between a provider and customer.

### Provider setup

1. The provider setup includes generating and provisioning a multitenant application service principal and the provisioning steps for the customer tenant.

1. Create an HTTP-triggered function app to kick off a message to write to the customer's Service Bus command queue within the customer tenant.

1. Create a time-triggered function app to periodically check a status queue within the customer's Service Bus within the customer tenant.

#### Create a multitenant ppplication within the provider's tenant

First, create a multitenant application in the provider's tenant and provision that identity within the customer's tenant. In this scenario, the identity is a service principal. The [architecture](./cross-tenant-communication-using-multitenanted-applications.md#architecture) earlier in this article shows how to set up and provision a service principal from the provider's tenant into the customer's tenant. The architecture also outlines the process to provision with multiple Microsoft Entra tenants. 

1. Choose the multitenant organization option.

1. Add the following website as the redirect URI: `https://entra.microsoft.com`. You can change this URI to suit your business needs.

1. Register and take note of the application (client) ID value.

#### Create a new client secret

1. After you create the multitenant application, create a client secret for this service principal.

1. Save the generated secret in a safe location. The secret combined with the client ID are your client credentials that are required to exchange the code, in authorization code flow, and for an ID token in the next step.

#### Azure Functions - HTTP-triggered

Use the HTTP function to start the deployment from the provider's tenant by sending a message into the customer's Service Bus deployment queue. (This HTTP-triggered function was the chosen method of delivery to kick off this proof-of-concept.) The service principal that was generated earlier acts as the credential to access the customer tenant and write to a specific queue within Service Bus. Note that you also need to finish the [customer setup](./cross-tenant-communication-using-multitenanted-applications.md#customer-setup) for this step to work properly.

#### Azure Functions - Timer-triggered

Use the timer-triggered function to poll the deployment status queue from within the customer's tenant. (We poll the deployment status queue every 10 seconds for demo purposes within this proof-of-concept). This approach removes the need for the customer to have a service principal to access the provider's tenant.

### Customer Setup

1. Provision the service principal by modifying and using the URL provided.

1. Scope the Provider service principal to use the appropriate RBAC controls.

1. Create a Service Bus triggered function to read a message off a Service Bus message queue and place a message into another queue. (for demo purposes this flow is optimal to test out the functionality).

1. Create a system-assigned managed identity for the Service Bus triggered function.

1. Assign the system-assigned managed identity Service Bus scope.

#### Provision the Service Principal from the Provider's Tenant to the Customer's Tenant

1. Visit the following URL with the `client_id` query string parameter replaced with your own client ID: `https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize?response_type=code&response_mode=query&scope=openid&client_id=your_client_ID`

*Provisioning the service principal into another Microsoft Entra tenant can also be achieved with an admin Graph API call, an Azure PowerShell command, or an Azure CLI command*

1. Sign in with an account from the Customer's tenant.

1. Once you see a consent screen. Click Accept to provision the Provider's application in the Customer tenant. *The URL will eventually redirect to microsoft.com, which still has the desired effect of provisioning the identity into the Customer tenant.*

1. Verify the identity within the Customer's Microsoft Entra tenant by navigating to "Enterprise Applications" to witness the newly provisioned service principal.

#### Setup RBAC for the Provisioned Service Principal

Scope the Provider service principal (from Provider service principal Setup) to have "Service Bus Data Owner" roles on the Service Bus. This service principal is used in both writing to a queue with an HTTP triggered function, and reading from a queue from a timer triggered function*.

1. Ensure "Azure Service Bus Data Owner" role is added to the service principal.

#### Azure Function - Service Bus Trigger

Generate an Azure Function from a Service Bus queue trigger from the following documentation was followed to define the function trigger from the Service Bus. [Identity Based Functions Tutorial](https://learn.microsoft.com/azure/azure-functions/functions-identity-based-connections-tutorial-2) The documentation also showcases how to set up a managed identity. This guidance is useful for the Azure function to get triggered from the Service Bus when a message has been added to the queue. The managed identity will also be utilized when we place a message into a different queue (for demo purposes, the same function was used to push the message through).

In your newly created Service Bus namespace, select Access Control (IAM). The control plane is where you can view and configure who has access to the resource.

#### Grant the Function App Access to the Service Bus Namespace using Managed Identities

1. Ensure "Azure Service Bus Data Receiver" role is added to the Managed Identity.

1. In the Managed identity selector, choose "Function App" from the "System-assigned managed identity" category. The label "Function App" may have a number in parentheses next to it, indicating the number of apps in the subscription with system-assigned identities.

#### Connect to Service Bus in your Function App

1. In the portal, search for your function app, or browse to it in the Function App page.

1. In Application settings, select " + New" application setting to create the new setting in the following table. "Service BusConnection__fullyQualifiedNamespace    <SERVICE_BUS_NAMESPACE>.Service Bus.windows.net".

### Service Principal Client Secret Lifecycle Management 

Introducing secrets into our cross-tenant architecture requires lifecycle management of that generated client secret. Refer to [Client Secret Best Practices](https://learn.microsoft.com/en-us/azure/key-vault/secrets/secrets-best-practices) to store, rotate, and monitor client secrets securely. 


### Local Settings

Each subdirectory contains a stubbed version of the local.settings.json files, which can be modified to run the Azure functions locally. To configure settings in Azure, update the Application Settings.

*The DefaultAzureCredential enumerates through multiple settings before hitting the Azure CLI credential!* To avoid confusion, we recommend doing an "az login -t <tenant ID>" to grant the correct credential when doing local Functions development.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

 * [Audrey Long](https://www.linkedin.com/in/aulong/) | "Senior Security Software Engineer"
 * [Ashton Mickey](https://www.linkedin.com/in/ashtonmickey/) | "Principal Software Engineer"
 * [John Garland](https://www.linkedin.com/in/avidgator/) | "Principal Software Engineer"


## Next steps

- [Cross-tenant communication using Azure Service Bus sample code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/edit/main/README.md)
<!--
- [Cross-tenant service communication in Microsoft Azure (YouTube, 18m)](https://www.youtube.com/watch?v=uHbuMqSFpVI)
-->
- [Identity-based functions tutorial](https://learn.microsoft.com/azure/azure-functions/functions-identity-based-connections-tutorial-2)
  
## Related resources

- [Cross-tenant communication using Azure Service Bus sample code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/edit/main/README.md)
- [Application and service principal objects in Microsoft Entra](https://learn.microsoft.com/en-us/entra/identity-platform/app-objects-and-service-principals?tabs=browser)
- [Azure Functions Service Bus trigger SDK issue](https://github.com/Azure/azure-sdk-for-net/issues/30961)
- [Service Bus Managed Identity limitation](https://learn.microsoft.com/dotnet/api/overview/azure/Microsoft.Azure.WebJobs.Extensions.ServiceBus-readme#managed-identity-authentication)
- [Client secret best practices](https://learn.microsoft.com/en-us/azure/key-vault/secrets/secrets-best-practices)
