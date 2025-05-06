---
title: Implement cross-directory communication in Azure
description: Learn how to implement bidirectional, secure communications between services that are hosted in Azure subscriptions that different Microsoft Entra directories manage.
author: aulong-msft
ms.author: aulong
ms.date: 04/24/2024
ms.topic: conceptual
ms.subservice: architecture-guide
products:
  - active-directory
  - azure-service-bus
  - entra
  - azure-functions
categories:
  - Identity
  - Security
---

# Implement cross-directory communication in Azure

This guide provides a solution to achieve bidirectional, secure communications between services that are hosted in Azure subscriptions that different Microsoft Entra directories manage.

Securing cross-directory communications in Azure can be challenging due to limitations that are inherent to many services. You can eliminate the need to manage credentials directly by using Azure managed identities to obtain tokens from Microsoft Entra ID. However, Azure managed identities don't work across directory boundaries, and the typical alternative is to use shared secrets, like shared access signature URLs. Remember that if you use shared secrets, you need to securely distribute and rotate the secrets across Microsoft Entra directory boundaries.

One option that avoids this overhead is to create a multitenant Microsoft Entra application to represent your workload's identity. Through a consent process, you can make this workload identity known to an external directory and ultimately allow the application to authenticate services in the external directory.

This article presents an example implementation of this pattern that uses [sample code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus).

This pattern can be reused for any scenario that has various services that need to communicate across Microsoft Entra directory boundaries.

## Architecture

:::image type="content" source="./_images/cross-tenant-communication-architecture.png" alt-text="A diagram of the cross-directory communication architecture." border="false" lightbox="./_images/cross-tenant-communication-architecture.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/cross-tenant-communication-architecture.pptx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

1. An admin on the provider side creates a multitenant Entra application registration and sets up a client secret for it.

1. An admin on the customer side provisions a service principal in its Microsoft Entra directory. This service principal is based on the application registration that the provider created. You can do this step in multiple ways. In the example, we chose to craft a URL to provide to the customer directory admin, but you can use the Microsoft Graph API instead.

1. The customer applies role-based access control (RBAC) roles to this new service principal so that it's authorized to access Azure Service Bus.

1. The provider's function app uses the client ID and client secret of the application registration to send an authenticated message to the customer's Service Bus queue.

1. The customer's function app uses a managed identity to read the provider's message from the queue via a Service Bus trigger.

1. After it receives the message, the customer's function app typically does some work before sending a status message back to the provider. In this case, for demo purposes, the function app immediately sends a status message to the provider on a separate queue in the same Service Bus.

1. This function app reads from the status queue from the customer's directory via a timer that Azure Functions triggers.

## Scenario details

A provider has multiple customers. The provider and each customer have their own individual Microsoft Entra ID directory and Azure resources. The provider and each customer need a secure, bidirectional method of communication so that they can exchange messages via Service Bus queues. The solution should have a compelling identity story that avoids introducing unnecessary credentials or secrets.

### What to know about multitenant Entra applications

- An application object is a globally unique instance of the application.

- When an application is registered in Microsoft Entra, an application object and a service principal object are automatically created in the directory.

- A service principal object is created in every directory that uses the application and references the application object. An application object has a one-to-many relationship with its corresponding service principal object.

- The application object is the global representation of your application and is used across all directories. The service principal object is the local representation that's used in a specific directory.

- A service principal object must be created in each directory where the application is used so that it can establish an identity to access resources that the directory secures. A single-directory application has only one service principal object in its home directory. This service principal object is created and permitted for use during application registration. A multitenant Entra application also has a service principal object that's created in each directory, and a user from that directory consented to its use.

- To access resources that are secured by a Microsoft Entra directory, a security principal must represent the entity that requires access.

- When an application is given permission to access resources in a directory upon registration or consent, a service principal object is created. This architecture is implemented with the consent flow.

## How does the provider message the customer?

Ideally, the provider is able to assign a managed identity to the Azure compute resource that's responsible for sending messages to a customer's queue. The customer's directory is configured to trust managed identities from the provider's directory. However, a true federation between two Microsoft Entra tenants, which would essentially allow the "sharing" of identities from one directory to another, isn't currently possible. So, the provider needs to authenticate by using an identity that the customer recognizes. The provider needs to authenticate to the customer's Microsoft Entra tenant as a service principal that the customer knows about.

We recommend that the provider registers a multitenant Entra application in its own directory and then has each customer provision an associated service principal into their directory. The provider can then authenticate to the customer's directory and the customer-hosted APIs by using this service principal. The provider never needs to share a client secret in this approach. Credential management is the sole responsibility of the provider.

## How does the customer message the provider?

We recommend that the customer creates or hosts a queue from which the provider can read. The customer writes a message into the queue. The provider repeatedly polls each customer queue for messages by using a service principal object. The downside of this approach is that it introduces polling latency when the provider receives a message. Code also needs to run more often in the provider because it must wake up and perform polling logic instead of waiting for an event to trigger it. However, credential management remains the sole responsibility of the provider, which bolsters security.

Another possible solution is to have the provider create or host a queue for each of its customers. Each customer creates their own multitenant Entra application and requests that the provider provision it in its directory as a service principal object. The customer then uses this service principal object to send messages to a customer-specific queue on the provider side. Credential management remains the sole responsibility of the customer. One downside to this approach is that the provider must provision service principals that are associated with customer applications into its directory. This process is manual, and providers likely don't want manual steps to be part of the flow for onboarding a new customer.

## Sample code setup

The following steps guide you through the process of setting up cross-directory communication between a provider and customer.

### Provider setup

The provider setup includes the steps to generate and provision a multitenant Entra application service principal and the steps to provision the customer directory.

1. Create an HTTP-triggered function app to send a message to write to the customer's Service Bus command queue within the customer directory.

1. Create a time-triggered function app to periodically check a status queue within the customer's Service Bus within the customer directory.

#### Create a multitenant Entra application within the provider's directory

First, create a multitenant Entra application in the provider's directory and provision that identity within the customer's directory. In this scenario, the identity is a service principal. The [architecture](./cross-tenant-communication-using-multitenanted-applications.md#architecture) earlier in this article shows you how to set up and provision a service principal from the provider's directory into the customer's directory. The architecture also outlines how to provision with multiple Microsoft Entra tenants.

1. Choose the multitenant organization option.

1. Add the following website as the redirect URI: `https://entra.microsoft.com`. You can change this URI to suit your business needs.

1. Register and take note of the application (client) ID value.

#### Create a new client secret

1. After you create the multitenant Entra application, create a client secret for this service principal.

1. Save the generated secret in a safe location. The secret and the client ID are your client credentials that are required to exchange the code, in authorization code flow, and for an ID token in the next step.

#### Azure Functions - HTTP-triggered

Use the HTTP function to start the deployment from the provider's directory by sending a message into the customer's Service Bus deployment queue. We chose the HTTP-triggered function as the method of delivery to start this proof-of-concept. The service principal that you generated earlier acts as the credential to access the customer directory and write to a specific queue within Service Bus. You also need to finish the [customer setup](./cross-tenant-communication-using-multitenanted-applications.md#customer-setup) for this step to work properly.

#### Azure Functions - Timer-triggered

Use the timer-triggered function to poll the deployment status queue from within the customer's directory. We poll the deployment status queue every 10 seconds for demo purposes in this proof-of-concept. This approach removes the need for the customer to have a service principal to access the provider's directory.

### Customer setup

1. Provision the service principal by modifying and using the provided URL.

1. Scope the provider service principal to use the appropriate RBAC controls.

1. Create a Service Bus triggered function to read a message from a Service Bus message queue and place a message into another queue. For demo purposes, this flow is optimal to test the functionality.

1. Create a system-assigned managed identity for the Service Bus triggered function.

1. Assign the system-assigned managed identity Service Bus scope.

#### Provision the service principal from the provider's directory to the customer's directory

1. Visit the following URL after replacing the `client_id` query string parameter with your own client ID: `https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize?response_type=code&response_mode=query&scope=openid&client_id=<your_client_ID>`.

   You can also provision the service principal into another Microsoft Entra tenant with an admin Microsoft Graph API call, an Azure PowerShell command, or an Azure CLI command.

1. Sign in with an account from the customer's directory.

1. On the consent screen, select **Accept** to provision the provider's application in the customer directory. The URL eventually redirects to `microsoft.com`, which still has the desired effect of provisioning the identity into the customer directory.

1. Verify the identity within the customer's Microsoft Entra tenant by going to **Enterprise Applications** to see the newly provisioned service principal.

#### Set up RBAC for the provisioned service principal

Scope the provider service principal from the provider service principal setup to have "Service Bus Data Owner" roles on the Service Bus. This service principal is used in both writing to a queue with an HTTP-triggered function and reading from a queue from a timer-triggered function. Make sure that you add the "Azure Service Bus Data Owner" role to the service principal.

#### Azure Functions - Service Bus trigger

Follow the steps in the [identity-based functions tutorial](/azure/azure-functions/functions-identity-based-connections-tutorial-2) to define the function trigger from the Service Bus queue and to learn how to set up a managed identity. This guidance helps you trigger the function app from the Service Bus queue when a message is added to the queue. You also use the managed identity when you place a message into a different queue. For demo purposes, we use the same function to push the message through.

In your newly created Service Bus namespace, select **Access Control (IAM)**. You can view and configure who has access to the resource in the control plane.

#### Grant the function app access to the Service Bus namespace by using managed identities

1. Make sure that you add the "Azure Service Bus Data Receiver" role to the managed identity.

1. In the managed identity selector, choose **Function App** from the **System-assigned managed identity** category. The label **Function App** might have a number in parentheses next to it. That number indicates how many apps that have system-assigned identities are in the subscription.

#### Connect to Service Bus in your function app

1. In the portal, search for your function app or go to it on the **Function App** page.

1. In **Application settings**, select **+ New** to create a new application setting in the table. `Service BusConnection__fullyQualifiedNamespace <SERVICE_BUS_NAMESPACE>.Service Bus.windows.net`.

### Service principal client secret lifecycle management

If you introduce secrets into your cross-directory architecture, then you need to manage the lifecycle of those generated client secrets. See [Best practices for secrets management](/azure/key-vault/secrets/secrets-best-practices) to learn how to store, rotate, and monitor client secrets securely.

### Local settings

Each subdirectory contains a stubbed version of the `local.settings.json` files, which can be modified to run the Azure functions locally. To configure settings in Azure, update the **Application Settings**.

The `DefaultAzureCredential` command enumerates multiple settings before it reaches the Azure CLI credential. To avoid confusion, we recommend running the `az login -t <tenant ID>` command to select the correct credentials when you develop local functions.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Audrey Long](https://www.linkedin.com/in/aulong/) | Senior Security Software Engineer
- [Ashton Mickey](https://www.linkedin.com/in/ashtonmickey/) | Principal Software Engineer
- [John Garland](https://www.linkedin.com/in/avidgator/) | Principal Software Engineer

## Next steps

- [Cross-directory communication using Azure Service Bus sample code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus)
- [Identity-based functions tutorial](/azure/azure-functions/functions-identity-based-connections-tutorial-2)
  
## Related resources

- [Application and service principal objects in Microsoft Entra](/entra/identity-platform/app-objects-and-service-principals?tabs=browser)
- [Service Bus managed identity limitation](/dotnet/api/overview/azure/Microsoft.Azure.WebJobs.Extensions.ServiceBus-readme)
- [Client secret best practices](/azure/key-vault/secrets/secrets-best-practices)
