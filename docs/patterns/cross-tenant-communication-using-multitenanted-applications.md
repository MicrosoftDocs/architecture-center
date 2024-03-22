---
title: Cross Tenant Communication using Multi-Tenanted Applications
description: This pattern addresses the need to have bidirectional secure communications between services hosted in Azure subscriptions managed by different Entra tenants. It includes a compelling identity story that avoids introducing unnecessary credentials and rotation infrastructure. This pattern can be reused for any Azure multitenant scenario with various services that need to communicate across Azure AD tenant boundaries.
author: aulong-msft, ashtmMSFT, John-Garland
ms.author: aulong, ashtm, johngarland
ms.date: 2/23/2024
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

# Cross-Tenant Communication using Multi-Tenant Applications

The following guide provides a solution to achieve bidirectional secure communications between services hosted in Azure subscriptions managed by different Entra tenants.

Securing multi-tenanted communications in Azure can be challenging due to limitations inherent to many services. Azure managed identities obtain tokens from Microsoft Entra ID, eliminating the need to manage credentials directly. However, Azure managed identities don't work across tenant boundaries, and the typical alternative is to use shared secrets (like SAS URLs).

The issue with shared secrets is they introduce a need to securely distribute and rotate secrets across Entra tenant boundaries. One option that avoids this overhead is to create a multi-tenant application to represent your workload's identity. Through a consent process, this workload identity can be made known to an external tenant, ultimately allowing it to authenticate to services in the external tenant.

This article covers an example implementation of this pattern and is accompanied by [sample code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/edit/main/README.md).

This pattern can be reused for any multi-tenanted scenario with a variety of services that need to communicate across Entra tenant boundaries.

![PoC Infrastructure]([https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/blob/main/Docs/arch.png](https://github.com/aulong-msft/architecture-center-pr/blob/main/docs/patterns/_images/cross-tenant-communication-architecture.png)
                      

## The Problem Statement

A Provider has multiple Customers. The Provider and each Customer need a secure, bidirectional method of communication. Messages must be exchanged through Azure Service Bus queues from Provider to Customer and vice versa. The solution should have a compelling identity story that avoids introducing unnecessary credentials or secrets.

## How does the Provider message the Customer?

Ideally, a Provider would be able to assign a managed identity to Azure resources, infrastructure, or workload applications hosted by infrastructure resources to be responsible for sending messages to a Customer's queue. The Customer's tenant would be configured to trust managed identities from the Provider tenant. However, a true federation (which would essentially allow the "sharing" of identities from one tenant to another) like this between two Entra tenants isn't currently possible. 
So, the Provider needs to authenticate using an identity the Customer recognizes. That is, the Provider needs to authenticate to the Customer's Entra as a service principal the Customer knows about. There are two ways this Service Principal can be created:

1. (Chosen approach) The Provider can register a multi-tenanted application in its own tenant, then have each Customer follow a process to provision an associated service principal into their tenant. The Provider can then authenticate to the Customer tenant and the Customer-hosted APIs using this Service Principal. No clientSecret needs to be communicated in this approach: the Provider never shares it. Credential management is the sole responsibility of the Provider.
  - when an application is registered in Entra, an application object (globally unique instance of the app) and a service principal object are automatically created in the tenant.
  - A service principal is created in every tenant where the application is used and references the globally unique app object. An application object has a one-to-many relationship with its corresponding service principal object(s).
  - The application object is the global representation of your application for use across all tenants, and the service principal is the local representation for use in a specific tenant.
  - A service principal must be created in each tenant where the application is used, enabling it to establish an identity for sign-in and/or access to resources being secured by the tenant. A single-tenant application has only one service principal (in its home tenant), created and consented for use during application registration. A multi-tenant application also has a service principal created in each tenant where a user from that tenant has consented to its use.
  - To access resources that are secured by a Microsoft Entra tenant, the entity (app or any other) that requires access must be represented by a security principal.
  - When an application is given permission to access resources in a tenant (upon registration or consent), a service principal object is created. This architecture is implemented with the consent flow.

1. The Customer creates a service principal for the Provider in its tenant, and then communicates the resulting credentials (clientId and clientSecret) to the Provider. The Provider can then authenticate to the Customer tenant and the Customer-hosted APIs using this Service Principal. Unfortunately, if the credentials need to be regenerated/renewed, those fresh credentials must also be communicated from Customer to Provider.


## How does the Customer message the Provider?

### Viable Solutions

1. (Chosen approach) Customer creates/hosts a queue from which the Provider can read. Customer writes a message into the queue. Using a service principal, the Provider implements some process for repeatedly polling each Customer queue for messages. This has the downside of introducing polling latency when receiving a message. This also means code needs to run more often in the Provider, as it must wake up and perform polling logic vs. being triggered by an event. However, credential management remains the sole responsibility of the Provider, greatly bolstering security.

1. Provider creates/hosts a queue for each of its Customers. Provider provisions a single-tenant Service Principal for each Customer and communicates those credentials to the Customer. The Customer then uses those credentials to send messages to their Customer-specific queue on the Provider side. Credential management/rotation is a pain point because secrets have to be communicated from one tenant to the other. One upside to this approach is that the Customer tenant isn't required to register any apps/service principals in its own tenant.

1. Provider creates/hosts a queue for each of its Customers, generates a SAS token (per-Customer), and communicates that SAS token to the Customer. The Customer then uses that SAS token to send messages to a Customer-specific queue on the Provider side. Credential management/rotation is a pain point because secrets have to be communicated from one tenant to the other. One upside to this approach is that neither tenant is required to register any extra apps/service principals.

1. Provider creates/hosts a queue for each of its Customers. Each Customer provisions their own multitenant app and requests that the Provider provision it in its tenant. The Customer then uses this service principal to send messages to a Customer-specific queue on the Provider side. Credential management remains the sole responsibility of the Customer. One significant downside is that the Provider must provision service principals associated with Customer applications into its tenant. By nature this is a manual process, and Providers likely don't want manual steps to be part of the flow for onboarding a new customer.

### Nonviable Solutions

1. Provider deploys (per-Customer) an Azure Function with a Service Bus trigger using its multitenanted service principal to bind to a response queue in the Customer's Service Bus to listen for messages. This solution would be ideal, and is an optimization over the first viable solution, but it isn't currently possible: [Service Bus Managed Identity Limitation](https://learn.microsoft.com/dotnet/api/overview/azure/Microsoft.Azure.WebJobs.Extensions.ServiceBus-readme#managed-identity-authentication)

## Sample Code Setup

### Provider Setup

1. The Provider setup includes generating and provisioning a Multi-Tenant Application Service Principal and the provisioning steps for the Customer tenant.

1. Create an HTTP triggered Azure Function to kick off a message to be written to Customer's Service Bus command queue within the Customer tenant.

1. Create a time-triggered Azure Function to periodically check a status queue within the Customer's Service Bus within the Customer tenant.

#### Create a Multitenant Application within the Provider's Tenant

We first need to create a Service Principal in the Provider's tenant and provision that identity within the Customer's tenant. The architecture image provided showcases how to setup and provision a Service Principal from the Provider's tenant into the Customer's tenant. This architecture also demonstrates the process of provisioning with multiple Entra tenants's. 

1. Ensure Multitenant organization option is chosen.

1. Add the following website as the redirect URI: "https://entra.microsoft.com". *Change this URI to suit your business needs*

1. Register and take note of the application (client) ID value.

#### Create a New Client Secret

1. After the Multi-Tenant application has been created, create a client secret for this Service Principal.

1. Save the generated secret in a safe location. The secret combined with the client ID is your client credentials that will be required to exchange the code, in authorization code flow, for an ID Token in the next step.

#### Azure Function - HTTP Triggered

The HTTP function is used to start off the deployment from the Provider's tenant by sending a message into the customer's Service Bus deployment queue. (This HTTP triggered function was the chosen method of delivery to kick off this proof-of-concept.) The Service Principal generated earlier act as the credential to access the Customer tenant and write to a specific queue within the service bus. *Customer Setup also needs to be completed for this step to work properly.*

#### Azure Function - Timer Triggered

This timer triggered function is used to poll the deployment status queue from within the Customer's tenant (every 10 seconds for demo purposes within this proof-of-concept). This approach removes the need for the Customer to have a Service Principal to access the Provider's tenant.

### Customer Setup

1. Provision the Service Principal by modifying and using the URL provided.

1. Scope the Provider Service Principal to use the appropriate RBAC controls.

1. Create a Service Bus triggered function to read a message off a Service Bus message queue and place a message into another queue. (for demo purposes this flow is optimal to test out the functionality).

1. Create a system-assigned managed identity for the service bus triggered function.

1. Assign the system-assigned managed identity service bus scope.

#### Provision the Service Principal from the Provider's Tenant to the Customer's Tenant

1. Visit the following URL with the client_id query string parameter replaced with your own client ID: `https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize?response_type=code&response_mode=query&scope=openid&client_id=your_client_ID`

*Provisioning the Service Principal into another Entra tenant can also be achieved with an admin Graph API call, an Azure Powershell command, or an Azure CLI command*

1. Sign in with an account from the Customer's tenant.

1. You'll see a consent screen. Click Accept to provision the Provider's application in the Customer tenant. *The URL will eventually redirect to microsoft.com which still has the desired effect of provisioning the identity into the Customer tenant.*

1. Verify the identity within the Customer's Entra tenant by navigating to "Enterprise Applications" to witness the newly provisioned service principal.

#### Setup RBAC for the Provisioned Service Principal

Scope the Provider Service Principal (from Provider Service Principal Setup) to have "Service Bus Data Owner" roles on the Service Bus. This Service Principal is used in both writing to a queue with an HTTP triggered function, and reading from a queue from a timer triggered function*.

1. Ensure "Azure Service Bus Data Owner" role is added to the Service Principal.

#### Azure Function - Service Bus Trigger

Generate an Azure Function from a Service Bus queue trigger from the following documentation was followed to define the function trigger from the service bus. [Identity Based Functions Tutorial](https://learn.microsoft.com/azure/azure-functions/functions-identity-based-connections-tutorial-2) The documentation also showcases how to setup a managed identity. This guidance will be useful for the azure function to get triggered from the service bus when a message has been added to the queue. The managed identity will also be utilized when we place a message into a different queue (for demo purposes, the same function was used to push the message through).

In your newly created service bus namespace, select Access Control (IAM). The control plane is where you can view and configure who has access to the resource.

#### Grant the Function App Access to the Service Bus Namespace using Managed Identities

1. Ensure "Azure Service Bus Data Receiver" role is added to the Managed Identity.

1. In the Managed identity selector, choose "Function App" from the "System-assigned managed identity" category. The label "Function App" may have a number in parentheses next to it, indicating the number of apps in the subscription with system-assigned identities.

#### Connect to Service Bus in your function app

1. In the portal, search for your function app, or browse to it in the Function App page.

1. In Application settings, select " + New" application setting to create the new setting in the following table. "Service BusConnection__fullyQualifiedNamespace    <SERVICE_BUS_NAMESPACE>.Service Bus.windows.net".

### Service Principal Client Secret Lifecycle Management 

Introducing secrets into our cross tenant architecture requires lifecycle management of that generated client secret. Please refer to [Client Secret Best Practices](https://learn.microsoft.com/en-us/azure/key-vault/secrets/secrets-best-practices) to store, rotate, and monitor client secrets securely. 


### Local Settings

Each subdirectory contains a stubbed version of the local.settings.json files, which can be modified to run the Azure functions locally. To configure settings in Azure, update the Application Settings.

*The DefaultAzureCredential enumerates through multiple settings before hitting the Azure CLI credential!* To avoid confusion, we recommend doing an "az login -t <tenant ID>" to grant the correct credential when doing local Functions development.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

 * [Audrey Long](https://www.linkedin.com/in/aulong/) | "Senior Security Software Engineer"
 * [Ashton Mickey](https://www.linkedin.com/in/ashtonmickey/) |  "Principal Software Engineer"
 * [John Garland](https://www.linkedin.com/in/avidgator/) |  "Principal Software Engineer"


## Next steps

- [Cross Tenant Communication using an Azure Service Bus Sample Code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/edit/main/README.md)
- [Identity Based Functions Tutorial](https://learn.microsoft.com/azure/azure-functions/functions-identity-based-connections-tutorial-2)
  
## Related resources

- [Cross Tenant Communication using an Azure Service Bus Sample Code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/edit/main/README.md)
- [Application and Service Principal Objects in Entra](https://learn.microsoft.com/en-us/entra/identity-platform/app-objects-and-service-principals?tabs=browser)
- [Azure Functions Service Bus trigger SDK Issue](https://github.com/Azure/azure-sdk-for-net/issues/30961)
- [Service Bus Managed Identity Limitation](https://learn.microsoft.com/dotnet/api/overview/azure/Microsoft.Azure.WebJobs.Extensions.ServiceBus-readme#managed-identity-authentication)
- [Client Secret Best Practices](https://learn.microsoft.com/en-us/azure/key-vault/secrets/secrets-best-practices)
