---
title: Cross Tenant Communication using Multi-Tenanted Applications
description: This pattern addresses the need to have bidirectional secure communications between services hosted in Azure subscriptions managed by different Entra tenants. It includes a compelling identity story that avoids introducing unnecessary credentials and rotation infrastructure. This pattern can be reused for any Azure multi-tenanted scenario with a variety of services that need to communicate across Azure AD tenant boundaries.
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

This pattern contains a sample solution for handling cross-tenant communication between a Provider and one or more of its Customers using Service Bus message queues. The problem is of a multi-tenanted nature: the Provider needs to communicate securely with each of its Customers, and each Customer needs to communicate securely with the Provider.

The implementation found in this pattern matches the use-case demonstrated in the image below. The [Cross Tenant Communication using an Azure Service Bus Sample Code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/edit/main/README.md) has been segmented to represent a Customer's infrastructure within a Customer tenant, as well as a Provider's infrastructure within a Provider tenant.

![PoC Infrastructure]([https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/blob/main/Docs/arch.png](https://github.com/aulong-msft/architecture-center-pr/blob/main/docs/patterns/_images/cross-tenant-communication-architecture.png)
                      

## The Problem Statement

A Provider has multiple Customers. The Provider and each Customer need a secure, bidirectional method of communication. Messages must be exchanged through Azure Service Bus queues from Provider to Customer and vice versa. The solution should have a compelling identity story that avoids introducing unnecessary credentials or secrets.

## How does the Provider message the Customer?

Ideally, a Provider would be able to assign a managed identity to whatever piece of its infrastructure is responsible for sending messages to a Customer's queue, and that Customer's tenant would be configured to trust managed identities from the Provider tenant. However, a true federation (which would essentially allow the "sharing" of identities from one tenant to another) like this between two Entra tenants is not currently possible. Support may be added later for it via Entra Workload Identities.
So, the Provider needs to authenticate using an identity the Customer will recognize. That is, the Provider needs to authenticate to the Customer's Entra as a service principal the Customer knows about. There are two ways this SP can be created:

1. The Customer creates a service principal for the Provider in its tenant, and then communicates the resulting credentials (clientId and clientSecret) to the Provider. The Provider can then authenticate to the Customer tenant and the Customer-hosted APIs using this SP. Unfortunately, if the credentials need to be regenerated/renewed, those fresh credentials must also be communicated from Customer to Provider.

1. (Chosen approach) The Provider can register a multi-tenanted application in its own tenant, then have each Customer follow a process to provision an associated service principal into their tenant. The Provider can then authenticate to the Customer tenant and the Customer-hosted APIs using this SP. No clientSecret needs to be communicated in this approach: the Provider never shares it. Credential management is the sole responsibility of the Provider.

## How does the Customer message the Provider?

### Viable Solutions

1. (Chosen approach) Customer creates/hosts a queue from which the Provider can read. Customer writes a message into the queue. Leveraging the existing service principal mentioned above, the Provider implements some process for repeatedly polling each Customer queue for messages. This has the downside of introducing polling latency when receiving a message. This also means code will need to run more often in the Provider, as it must wake up and perform polling logic vs. being triggered by an event. However, credential management remains the sole responsibility of the Provider, greatly bolstering security.

1. Provider creates/hosts a queue for each of its Customers. Provider provisions a single-tenant SP for each Customer and communicates those credentials to the Customer. The Customer then uses those credentials to send messages to their Customer-specific queue on the Provider side. Credential management/rotation is a pain point because secrets have to be communicated from one tenant to the other. One upside to this approach is that the Customer tenant is not required to register any apps/service principals in its own tenant.

1. Provider creates/hosts a queue for each of its Customers, generates a SAS token (per-Customer), and communicates that SAS token to the Customer. The Customer then uses that SAS token to send messages to a Customer-specific queue on the Provider side. Credential management/rotation is a pain point because secrets have to be communicated from one tenant to the other. One upside to this approach is that neither tenant is required to register any additional apps/service principals.

1. Provider creates/hosts a queue for each of its Customers. Each Customer provisions their own multi-tenant app and requests that the Provider provision it in its tenant. The Customer then uses this service principal to send messages to a Customer-specific queue on the Provider side. Credential management remains the sole responsibility of the Customer. One big downside is that the Provider must provision service principals associated with Customer applications into its tenant, which is a manual process, and Providers likely do not want manual steps to be part of the flow for onboarding a new customer.

### Non-viable Solutions

1. Provider deploys (per-Customer) an Azure Function with a Service Bus trigger using its multi-tenanted service principal to bind to a response queue in the Customer's Service Bus to listen for messages. This would be ideal, and is an optimization over the first viable solution listed above, but it isn't currently possible: [Service Bus Managed Identity Limitation](https://learn.microsoft.com/dotnet/api/overview/azure/Microsoft.Azure.WebJobs.Extensions.ServiceBus-readme#managed-identity-authentication)

## Sample Code Set-up

### Provider Setup

1. The Provider setup will include generating and provisioning a Service Principal as well as the provisioning steps for the Customer tenant.

1. Create an HTTP triggerd Azure Function to kick off a message to be written to Customer's Service Bus command queue within the Customer tenant.

1. Create a time-triggered Azure Function to periodically check a status queue within the Customer's Service Bus within the Customer tenant.

#### Create a Multi-Tenant Application within the Provider's Tenant

We first need to create a Service Principal in the Provider's tenant and provision that identity within the Customer's tenant. The architecture image above showcases how to setup and provision a Service Principal from the Provider's tenant into the Customer's tenant as well as the process of provisioning with multiple Entra tenant's 

1. Navigate to Entra click "New Registration".

1. Enter the name for the service principal and choose "Accounts in any organization (Any Entra directory - Multitenant)".

1. Add - Web - "https://entra.microsoft.com" as the redirect URI. *Please change this URI to suit your business needs*

1. Register and take note of the application (client) ID value.

#### Create a New Client Secret

1. Once you have created a Multi-Tenant application above navigate to "Clients&Secrets".

1. Create a new client secret by choosing "New Client Secret".

1. Enter secret details and generate the secret.

1. Save the generated secret in a safe location. This combined with the client ID is your client credentials that will be required to exchange the code, in authorization code flow, for an ID Token in the next step.

#### Azure Function - HTTP Triggered

This HTTP function is used to start off the deployment from the Provider's tenant by sending a message into the customer's Service Bus deployment queue. (This HTTP triggered function was the chosen method of delivery to kick off this proof-of-concept.) The Service Principal generated earlier will be used as the credential to access the Customer tenant and write to a specific queue within the service bus. *Note - Customer Setup also needs to be completed for this to work properly*

#### Azure Function - Timer Triggered

This timer triggered function is used to poll the deployment status queue from within the Customer's tenant (every 10 seconds for demo purposes within this proof-of-concept). This approach removes the need for the Customer to have a Service Principal to access the Provider's tenant.

### Customer Setup

1. Provision the Service Principal by modifying and using the URL provided.

1. Scope the Provider SP to use the appropriate RBAC controls.

1. Create a Service Bus triggered function to read a message off a Service Bus message queue and place a message into another queue. (for demo purposes this flow is optimal to test out the functionality).

1. Create a system-assigned managed identity for the service bus triggered function.

1. Assign the system-assigned managed identity service bus scope.

#### Provision the SP from the Provider's Tenant to the Customer's Tenant

1. Visit the following URL with the client_id query string parameter replaced with your own client ID: `https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize?response_type=code&response_mode=query&scope=openid&client_id=your_client_ID`

*Please note that provisioning the Service Principal into another Entra tenant can also be achieved with an admin Graph API call*

1. Sign in with an account from the Customer's tenant.

1. You will now see a consent screen. Click Accept to provision the Provider's application in the Customer tenant. *Note this will eventually redirect to microsoft.com -- this still has the desired effect of provisioning the identity into the Customer tenant*.

1. Verify the identity within the Customer's Entra tenant by navigating to "Enterprise Applications" to witness the newly provisioned service principal.

#### Set up RBAC for the Provisioned Service Principal

Scope the Provider SP (from Provider Service Principal Setup above) to have "Service Bus Data Owner" roles on the Service Bus. This Service Principal will be used in both writing to a queue with an HTTP triggered function, as well as reading from a queue from a timer triggered function*.

1. Navigate to the Customer Service Bus namespace.

1. Click on "Access Control (IAM).

1. Click on "Role Assignments" and "Add" at the top and "Add Role Assignment".

1. Select "Azure Service Bus Data Owner" and hit "Next".

1. Ensure "User, group, or Service Principal" is selected and click "+Select members" in the "Select" field type in the Service Principal name and select.

1. Select "Review + assign".

#### Azure Function - Service Bus Trigger

Generate an Azure Function from a Service Bus queue trigger from the following documentation was followed to define the function trigger from the service bus. [Identity Based Functions Tutorial](https://learn.microsoft.com/azure/azure-functions/functions-identity-based-connections-tutorial-2) This documentation also showcases how to setup a managed identity used for the azure function to get triggered from the service bus when a message has been added to the queue and we will continue to use that managed identity when putting a message into a different queue (for demo purposes, the same function was used to push the message through).

In your service bus namespace that you just created, select Access Control (IAM). This is where you can view and configure who has access to the resource.

#### Grant the Function App Access to the Service Bus Namespace using Managed Identities

1. Click "Add" and select "Add role assignment".

1. Search for "Azure Service Bus Data Receiver", select it, and click "Next".

1. On the" Members" tab, under Assign access to, choose Managed Identity.

1. Click "Select" members to open the Select managed identities panel.

Confirm that the Subscription is the one in which you created the resources earlier.

1. In the Managed identity selector, choose "Function App" from the "System-assigned managed identity" category. The label "Function App" may have a number in parentheses next to it, indicating the number of apps in the subscription with system-assigned identities.

Your app should appear in a list below the input fields. If you don't see it, you can use the Select box to filter the results with your app's name.

1. Click on your application. It should move down into the Selected member’s section. Click "Select".

1. Back on the Add role assignment screen, click "Review + assign". Review the configuration, and then click "Review + assign".

#### Connect to Service Bus in your function app

1. In the portal, search for the your function app, or browse to it in the Function App page.

1. In your function app, select "Configuration" under Settings.

1. In Application settings, select " + New" application setting to create the new setting in the following table. "Service BusConnection__fullyQualifiedNamespace    <SERVICE_BUS_NAMESPACE>.Service Bus.windows.net".

1. After you create the two settings, select "Save > Confirm".

### Local Settings

Each subdirectory contains a stubbed version of the local.settings.json files which can be modified to run the Azure functions locally. To configure settings in Azure, update the Application Settings.

*Note* The DefaultAzureCredential enumerates through multiple settings before hitting the Azure CLI credential! This is why we recommend doing an az login -t <tenant ID> to grant the correct credential when doing local Functions development.


## Contributors

> Start with the explanation text (same for every article), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Pricipal authors" list and the "Additional contributors" list (if there are additional contributors) (all in plain text, not italics or bold). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). (The profiles can be linked to from the person's LinkedIn page, and we hope to automate that on the platform in the future). 
> Implement this format:

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: > Only the primary authors. List them alphabetically, by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s).

 * [Audrey Long](https://www.linkedin.com/in/aulong/) | "Senior Security Software Engineer"
 * [Ashton Mickey](https://www.linkedin.com/in/ashtonmickey/) |  "Principal Software Engineer"
 * [John Garland](https://www.linkedin.com/in/avidgator/) |  "Principal Software Engineer"


## Next steps

- [Identity Based Functions Tutorial](https://learn.microsoft.com/azure/azure-functions/functions-identity-based-connections-tutorial-2)

## Related resources

- [Cross Tenant Communication using an Azure Service Bus Sample Code](https://github.com/Azure-Samples/Cross-Tenant-Communication-Using-Azure-Service-Bus/edit/main/README.md)
- [Azure Functions Service Bus trigger SDK Issue](https://github.com/Azure/azure-sdk-for-net/issues/30961)
- [Service Bus Managed Identity Limitation](https://learn.microsoft.com/dotnet/api/overview/azure/Microsoft.Azure.WebJobs.Extensions.ServiceBus-readme#managed-identity-authentication)
