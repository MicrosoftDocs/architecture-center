---
title: Virtual network integrated microservices
titleSuffix: Azure Example Scenarios
description: This reference architecture is an end-to-end sample derived from a customer engagement. It is an example of a microservices architecture, built using Azure Functions that can integrate with other services residing in a vnet. 
author: hannesne
ms.date: 08/24/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Virtual network integrated microservices

This article describes an integrated solution for patient records management. A health organization needs to digitally store large amounts of highly-sensitive patient medical test data. Internal and third-party systems must be able to securely read and write the data through an application programming interface (API). All interactions with the data must be recorded in an audit register.

In the Azure solution, [Azure API Management (APIM)](https://azure.microsoft.com/services/api-management/) controls access to the API through a single managed endpoint. The application backend consists of two interdependent [Azure Functions](https://azure.microsoft.com/services/functions/) microservice apps that create patient records and audit records. Each function app stores its data in an independent [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) database.

APIM and the two function apps reside in a restricted-access [virtual network](https://azure.microsoft.com/services/virtual-network/). All keys, secrets, and connection strings associated with the apps and databases are securely held in [Azure Key Vault](https://azure.microsoft.com/services/key-vault/). Application Insights telemetry in Azure Monitor centralizes logging across the system.

This article and the [associated code project](https://github.com/mspnp/vnet-integrated-serverless-microservices) distill the example scenario down to the main technical components, to serve as a scaffold for specific implementations. The solution automates all code and infrastructure deployments with [Terraform](https://www.terraform.io/), and includes automated integration, unit, and load testing.

## Potential use cases

- Highly-sensitive data that requires access from designated external endpoints
- Interdependent microservice apps that need to be integrated with common access and security

## Architecture

At the core of the solution is a set of API microservices built on Azure Functions. The **Patient API** provides the *create, read, update, and delete (CRUD)* operations for patients and test results. The **Audit API** function app provides operations to create auditing entries. APIM controls internal and third-party access to the APIs.

The following diagram shows the patient record creation data flow:

![Diagram showing virtual network integrated microservices.](./media/vnet-microservices.png)

1. Outside services and clients make a POST request to APIM, with a data body that includes patient information.
1. APIM calls the `CreatePatient` function in the **Patient API** with the given patient information.
1. The `CreatePatient` function in **Patient API** calls the `CreateAuditRecord` function in the **Audit API** function app to create an audit record.
1. The **Audit API** `CreateAuditRecord` function creates the audit record in Cosmos DB, and returns a success response to the **Patient API** `CreatePatient` function.
1. The `CreatePatient` function creates the patient document in Cosmos DB, and returns a success response to APIM.
1. The outside services and clients receive the success response from APIM.
1. Application Insights distributed telemetry centralizes logging along the whole request pipeline.

### Security

Due to the sensitivity of the data, security is paramount in this solution. The solution uses several mechanisms to protect the data:
- APIM gateway management
- Virtual network access restrictions
- Service access keys and connections strings
- Key Vault key and connection string management
- Key Vault key and secret rotation
- Managed service identity

For more details about the security pattern for this solution, see [Security pattern for communication between API Management, Functions apps, and Cosmos DB](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/docs/security_pattern.md).

#### API Management (APIM)
The system is publicly accessible only through the single managed APIM endpoint. The APIM subnet restricts incoming traffic to specified gateway node IP addresses. APIM allows for easy integration with different authentication mechanisms. The current solution requires a subscription key, but you could also use Azure Active Directory to secure the APIM endpoint.

#### Virtual network
To avoid exposing APIs and functions publicly, [Azure Virtual Networks] restrict network access for APIs and functions to only specific IP addresses or subnets. Both API Management and Azure Functions support access restriction and deployment in virtual networks. This solution uses [regional virtual network integration](https://docs.microsoft.com/azure/azure-functions/functions-networking-options#regional-virtual-network-integration) to deploy APIM and the function apps in the same virtual network in the same Azure region.

Function apps can restrict IPv4, IPv6, and virtual network subnet access. By default, a function app allows all access, but once you add one or more address or subnet restrictions, the app denies all other network traffic.

The function apps allow interactions only within their own virtual network. The Patient API allows the APIM subnet to call it by adding the APIM subnet to its access restriction allow list. The Audit API allows access only with the Patient API, by adding the Patient API virtual network subnet to its access restriction allow list. The APIs reject traffic from other sources.

There are two important considerations for using regional virtual network integration:

- You need an Azure Premium subscription to have both regional virtual network integration and scalability.
- Since you deploy the function apps in a subnet of the virtual network, you need to configure the IP address allow list in the subnet. Use one IP address for each service plan instance.

#### Access keys
You can call both APIM and function apps without using access keys. However, disabling the access keys isn't good security practice, so all components in this solution require access keys.

- Accessing APIM requires a subscription key, so users need to include `Ocp-Apim-Subscription-Key` in the HTTP header. Alternatively, you could use Azure Active Directory to secure the APIM endpoint without needing to manage subscription keys in APIM.
- All functions in the Patient API function app require an API access key, so APIM must include `x-functions-key` in the HTTP header when calling the Patient API.
- Calling `CreateAuditRecord` in the Audit API function app requires an API access key, so Patient API needs to include `x-functions-key` in the HTTP header when calling the `CreateAuditRecord` function.
- Both Functions apps use Cosmos DB as their data store, so they must use Cosmos DB connection strings to access the Cosmos DB databases.

#### Key Vault storage
Although it's possible to keep keys and connection strings in the application settings, it's not good practice, because anyone who can access the app can access the keys and strings. The best practice, especially for production environments, is to keep this information in Azure Key Vault. This solution maintains the service keys and connection strings in Azure Key Vault and uses the Key Vault references to call the apps.

APIM uses an advanced inbound policy to cache the Patient API host key for better performance. For subsequent attempts, APIM looks for the key in its cache first.

- APIM retrieves the Patient API host key from Key Vault, caches it, and puts it into an HTTP header when calling the Patient API function app.
- The Patient API function app retrieves the Audit API host key from Key Vault and puts it into an HTTP header when calling the Audit API function app.
- The Azure Function runtime validates the key in the HTTP header on incoming requests.

#### Key rotation
Rotating Key Vault keys helps make the system more secure. You can automatically rotate keys periodically, or you can rotate keys manually on demand in case of leakage.

Key rotation involves updating several settings:
- The host key itself in the function app
- The secret in Key Vault that stores the host key
- The Key Vault reference in the function app application settings, to refer to the latest secret version
- The Key Vault reference in the APIM caching policy for the Patient API

You can rotate the keys in the Azure Portal or with the Azure CLI. The current solution performs most of the tasks with Terraform. For more information, see [Key rotation pattern with Terraform](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/docs/key_rotation.md).

#### Managed identity
Only specified identities can access Key Vault data. APIM and the function apps use an Azure [system-assigned managed service identity (MSI)](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/), which is granted the following GET permissions:

- APIM can get the host key of the Patient API function app.
- The Patient API function app can get the Audit API host key and the Cosmos DB connection string.
- The Audit API function app can get the Cosmos DB connection string.

[system-assigned Managed Service Identity (MSI)](/azure/active-directory/managed-identities-azure-resources/overview)

More information on the security aspects can be found here. More information about key rotation can be found here.

## Components

The solution uses the following components:

- [Azure API Management (APIM)](https://azure.microsoft.com/services/api-management/) controls internal and third-party interactions with the data via a **Patient** API that allows reading and/or writing the data. The API is publicly accessible only through the single managed APIM endpoint. APIM allows for easy integration with different authentication mechanisms. [Azure API Management](https://docs.microsoft.com/azure/api-management/api-management-key-concepts)

- Azure Functions. At the core of the solution is a set of API microservices built on Azure Functions with [Typescript](https://www.typescriptlang.org/). The **PatientTests API** microservice provides the *create, read, update, and delete (CRUD)* operations for patients and test results. The **Audit API** function app provides operations to create auditing entries. The function apps are protected by service keys in the Azure Functions runtime. These keys are stored in Azure Key Vault and are only available to specified identities.

- [Azure Virtual Networks] let you restrict network access for APIs and functions to only specific IP addresses or subnets. Both API Management and Azure Functions support access restriction and deployment in virtual networks. The solution uses [regional virtual network integration](https://docs.microsoft.com/azure/azure-functions/functions-networking-options#regional-virtual-network-integration) to deploy both function apps in the same virtual network in the same region.

- Key Vault. Although it's technically possible to keep keys and connection strings in application settings, it's not good practice, because anyone who can access the app can access the keys and strings. The best practice, especially for production environments, is to keep this information in Azure Key Vault. This solution maintains the service keys and connection strings for access in Azure Key Vault. Only specified identities can access the Key Vault data.

- [Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/mongodb-introduction) is a fully managed and cost-effective serverless database with instant, automatic scaling. In the current solution, both microservices store data in Cosmos DB, using the [MongoDB Node.js driver](https://mongodb.github.io/node-mongodb-native/). The services don't share data, and you can deploy each service to its own independent database. You can replace the Cosmos DB endpoint with another MongoDB service without changing the code.

- Application Insights. Failures in microservices based architecture are often distributed over a variety of components, and can't be diagnosed by looking at the services in isolation. The ability to correlate telemetry across components is vital to diagnosing these issues. Application Insights telemetry can centralize logging along the whole request pipeline.
  
  APIM and the Azure Functions runtime have built-in support for Application Insights to generate and correlate a wide variety of telemetry, including standard application output. The telemetry shares a common operation ID, allowing correlation across components. The function apps use the Application Insights Node.js SDK to manually track dependencies and other custom telemetry.
  
  The Application Insights Telemetry can feed into a wider Azure Monitor workspace. Components like Cosmos DB can send telemetry to Azure Monitor, where it can be correlated with telemetry from Application Insights.
  
  For more information about the distributed telemetry tracing, see [Distributed telemetry](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/docs/distributed_telemetry.md).
## Deploy the solution

The source code for this solution is at [integrated-serverless-microservices](https://github.com/mspnp/vnet-integrated-serverless-microservices). 

The [Typescript](https://www.typescriptlang.org/) source code for the [PatientTest API](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/src/PatientTestsApi/readme.md) and the [Audit API](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/src/AuditApi/readme.md) are in the `/src` folder. Each API's source includes a [dev container](https://code.visualstudio.com/docs/remote/containers) that has all the prerequisites installed, to help you get going quicker.

Both APIs have a full suite of automated integration and unit tests to help prevent regressions when you make changes. The project is also configured for *linting* with ESLint, to maintain code styles and help guard against unintentional errors. The services' respective README files contain information on how to run the tests and linting.

### Terraform deployment

The code project's [/env](https://github.com/mspnp/vnet-integrated-serverless-microservices/tree/main/env) folder includes scripts and templates for [Terraform](https://www.terraform.io/) deployment. Terraform deploys APIM and the function apps and configures them to use the deployed Application Insights instance. Terraform also provisions all resources and configurations, including networking lockdown and the access key security pattern.

The deployment [README](https://github.com/mspnp/vnet-integrated-serverless-microservices/tree/main/env) explains how to deploy the Terraform environment in your own Azure subscription. The  `/env` folder also includes a [dev container](https://github.com/mspnp/vnet-integrated-serverless-microservices/tree/main/env/.devcontainer) for Terraform deployment.

You can also use a system like Azure DevOps or GitHub Actions to automate deployment.

### Locust load testing

To gauge API performance, you can run load testing against the APIs. The code project contains a [Locust load test](https://github.com/mspnp/vnet-integrated-serverless-microservices/tree/main/src/LoadTest). [Locust](https://locust.io/) is an open-source load testing tool, and the tests are written in Python. You can run the load tests locally, or remotely in an Azure Kubernetes Service (AKS) cluster. The tests perform a variety of operations against the APIM endpoint, and verify behaviors against success and failure criteria.

## Next steps
- [API Management access restriction policies](https://docs.microsoft.com/azure/api-management/api-management-access-restriction-policies)
- [How to use Azure API Management with virtual networks](https://docs.microsoft.com/azure/api-management/api-management-using-with-vnet)
- [IP addresses of Azure API Management](https://docs.microsoft.com/azure/api-management/api-management-howto-ip-addresses)
- [Azure App Service access restrictions](https://docs.microsoft.com/azure/app-service/app-service-ip-restrictions)
- [Azure Functions networking options](https://docs.microsoft.com/azure/azure-functions/functions-networking-options)
- [Subscriptions in Azure API Management](https://docs.microsoft.com/azure/api-management/api-management-subscriptions)
- [Function access keys](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp#authorization-keys)
- [How to use managed identities for App Service and Azure Functions](https://docs.microsoft.com/azure/app-service/overview-managed-identity)
- [Use Key Vault references for App Service and Azure Functions](https://docs.microsoft.com/azure/app-service/app-service-key-vault-references)
