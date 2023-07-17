In this Azure solution, [Azure API Management (APIM)](https://azure.microsoft.com/services/api-management) controls access to the API through a single managed endpoint. The application backend consists of two interdependent [Azure Functions](https://azure.microsoft.com/services/functions) microservice apps that create and manage patient records and audit records. APIM and the two function apps access each other through a locked-down [virtual network](https://azure.microsoft.com/services/virtual-network).

This article and the [associated code project](https://github.com/mspnp/vnet-integrated-serverless-microservices) distill the example scenario down to the main technical components, to serve as scaffolding for specific implementations. The solution automates all code and infrastructure deployments with [Terraform](https://www.terraform.io), and includes automated integration, unit, and load testing.

## Architecture

The following diagram shows the patient record creation request flow:

:::image type="content" alt-text="Diagram showing virtual network integrated microservices." source="virtual-network-microservices.png" lightbox="virtual-network-microservices.png":::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-network-microservices.vsdx) of this architecture.*

### Workflow

1. Outside services and clients make a POST request to APIM, with a data body that includes patient information.
1. APIM calls the `CreatePatient` function in the **Patient API** with the given patient information.
1. The `CreatePatient` function in **Patient API** calls the `CreateAuditRecord` function in the **Audit API** function app to create an audit record.
1. The **Audit API** `CreateAuditRecord` function creates the audit record in Azure Cosmos DB, and returns a success response to the **Patient API** `CreatePatient` function.
1. The `CreatePatient` function creates the patient document in Azure Cosmos DB, and returns a success response to APIM.
1. The outside services and clients receive the success response from APIM.

### Components

The solution uses the following components:

- [Azure API Management (APIM)](https://azure.microsoft.com/services/api-management) is a hybrid, multicloud platform for managing APIs across all environments. In this solution, APIM controls internal and third-party access to the Patient API that allows reading and/or writing data. APIM allows for easy integration with different authentication mechanisms.

- [Azure Functions](/azure/azure-functions/functions-overview) is a serverless compute platform that handles small, event-driven pieces of code. The cloud infrastructure provides the necessary updated servers to run the functions at scale. The current solution uses a set of two Azure Functions API microservices that create and manage operations for patient test results and auditing records.

- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) provides an isolated and highly secure application environment by restricting network access to specific IP addresses or subnets. Both APIM and Azure Functions support access restriction and deployment in virtual networks. This solution uses [regional virtual network integration](/azure/azure-functions/functions-networking-options#regional-virtual-network-integration) to deploy both function apps in the same virtual network in the same region.

- [Azure Key Vault](/azure/key-vault/general/overview) centrally stores, encrypts, and manages access to keys, certificates, and connection strings. This solution maintains the Azure Functions host keys and Azure Cosmos DB connection strings in a Key Vault that only specified identities can access.

- [Azure Cosmos DB](/azure/cosmos-db/mongodb-introduction) is a fully managed serverless database with instant, automatic scaling. In the current solution, both microservices store data in Azure Cosmos DB, using the [MongoDB Node.js driver](https://mongodb.github.io/node-mongodb-native). The services don't share data, and you can deploy each service to its own independent database.

- [Application Insights](/azure/azure-monitor/app/app-insights-overview), a feature of [Azure Monitor](/azure/azure-monitor/overview), reports on application performance, usage, availability, and behavior to detect and help diagnose anomalies.

  Failures in microservices-based architecture are often distributed over a variety of components, and can't be diagnosed by looking at the services in isolation. The ability to correlate telemetry across components is vital to diagnosing these issues. Application Insights telemetry centralizes logging along the whole request pipeline to detect performance anomalies. The telemetry shares a common operation ID, allowing correlation across components.

  APIM and the Azure Functions runtime have built-in support for Application Insights to generate and correlate a wide variety of telemetry, including standard application output. The function apps use the Application Insights Node.js SDK to manually track dependencies and other custom telemetry.

  For more information about the distributed telemetry tracing in this solution, see [Distributed telemetry](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/docs/distributed_telemetry.md).

### Alternatives

- The current solution requires a subscription key to access the APIM endpoint, but you can also use [Azure Active Directory (Azure AD) authentication](/azure/active-directory/authentication/overview-authentication).
- In addition to requiring API access keys, you can use Azure Functions' built-in [App Service authentication](/azure/app-service/configure-authentication-provider-aad) to enable Azure AD authorization for the APIs' managed identities.
- You can replace the Azure Cosmos DB endpoint in this solution with another MongoDB service without changing the code.
- For additional [Azure Cosmos DB security](/azure/cosmos-db/database-security), you can lock down traffic from the Azure Cosmos DB databases to the function apps.
- Components such as Azure Cosmos DB can send telemetry to [Azure Monitor](/azure/azure-monitor/overview), where it can be correlated with the telemetry from Application Insights.
- Instead of Terraform, you can use the Azure portal or Azure CLI for [Key Vault key rotation](/samples/azure-samples/serverless-keyvault-secret-rotation-handling/handling-keyvault-secret-rotation-changes-utilized-by-an-azure-function) tasks.
- Instead of Terraform, you can use a system like [Azure DevOps](/azure/devops/pipelines/get-started/what-is-azure-pipelines) or [GitHub Actions](https://docs.github.com/actions) to automate solution deployment.
- For higher availability, this solution can be deployed to multiple regions. [Set Azure Cosmos DB to multi-master](/azure/cosmos-db/how-to-multi-master), use APIM's built-in [multi-region support](/azure/api-management/api-management-howto-deploy-multi-region), and deploy the Azure Function apps to [paired regions](/azure/best-practices-availability-paired-regions).

## Scenario details

This article describes an integrated solution for patient records management. A health organization needs to digitally store large amounts of highly sensitive patient medical test data in the cloud. Internal and third-party systems must be able to securely read and write the data through an application programming interface (API). All interactions with the data must be recorded in an audit register.

### Potential use cases

- Access highly sensitive data from designated external endpoints.
- Implement secure auditing for data access operations.
- Integrate interdependent microservices apps with common access and security.
- Use virtual network security features while taking advantage of serverless cost savings and flexibility.

### Benefits

Some benefits of serverless applications like Azure Functions are the cost savings and flexibility of using only necessary compute resources, rather than paying up front for dedicated servers. This solution lets Azure Functions use virtual network access restrictions for security, without incurring the cost and operational overhead of full [Azure App Service Environments (ASEs)](/azure/app-service/environment/network-info).

APIM controls internal and third-party access to a set of API microservices built on Azure Functions. The **Patient API** provides *create, read, update, and delete (CRUD)* operations for patients and their test results. The **Audit API** function app provides operations to create auditing entries.

Each function app stores its data in an independent [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) database. [Azure Key Vault](https://azure.microsoft.com/services/key-vault) securely holds all keys, secrets, and connection strings associated with the apps and databases. Application Insights telemetry and Azure Monitor centralize logging across the system.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Consider the following aspects when implementing this solution.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Due to the sensitivity of the data, security is paramount in this solution. The solution uses several mechanisms to protect the data:
- APIM gateway management
- Virtual network access restrictions
- Service access keys and connections strings
- Key and connection string management in Key Vault
- Key Vault key rotation
- Managed service identities

You can protect your Azure API Management instance against distributed denial of service (DDoS) attacks using [Azure DDoS protection](/azure/api-management/protect-with-ddos-protection). Azure DDoS Protection provides enhanced DDoS mitigation features to defend against volumetric and protocol DDoS attacks.

For more details about the security pattern for this solution, see [Security pattern for communication between API Management, Functions apps, and Azure Cosmos DB](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/docs/security_pattern.md).

#### API gateway management
The system is publicly accessible only through the single managed APIM endpoint. The APIM subnet restricts incoming traffic to specified gateway node IP addresses.

APIM allows for easy integration with different authentication mechanisms. The current solution requires a subscription key, but you could also use Azure Active Directory to secure the APIM endpoint without needing to manage subscription keys in APIM.

#### Virtual network
To avoid exposing APIs and functions publicly, [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) restricts network access for APIs and functions to specific IP addresses or subnets. Both API Management and Azure Functions support access restriction and deployment in virtual networks.

Function apps can restrict IPv4, IPv6, and virtual network subnet access. By default, a function app allows all access, but once you add one or more address or subnet restrictions, the app denies all other network traffic.

In this solution, the function apps allow interactions only within their own virtual network. The Patient API allows calls from the APIM subnet by adding the APIM subnet to its access restriction allowlist. The Audit API allows communication with the Patient API by adding the Patient API subnet to its access restriction allowlist. The APIs reject traffic from other sources.

The solution uses [regional virtual network integration](/azure/azure-functions/functions-networking-options#regional-virtual-network-integration) to integrate APIM and the function apps with the same virtual network and Azure region. There are several important considerations for using regional virtual network integration:

- You need to use the [Azure Functions Premium SKU](https://azure.microsoft.com/pricing/details/functions) to have both regional virtual network integration and scalability.
- You need to use the [APIM Developer or Premium SKU](/azure/api-management/api-management-using-with-vnet#availability) to enable VNET connectivity
- Since you deploy the function apps in a subnet of the virtual network, you configure the function apps' access restrictions to allow traffic from other subnets in the virtual network.
- Regional virtual network integration only limits outbound traffic from the Azure Function to the virtual network. Inbound traffic is still routed outside of the virtual network, although limited by the app's access list.

Only [App Service Environments](/azure/app-service/environment/network-info) offer complete network-level virtual network isolation. ASEs can require considerably more expense and effort to implement than Azure Functions that support regional virtual network integration. ASE scaling is also less elastic.

#### Access keys

You can call APIM and function apps without using access keys. However, disabling the access keys isn't good security practice, so all components in this solution require keys for access.

- Accessing APIM requires a subscription key, so users need to include `Ocp-Apim-Subscription-Key` in HTTP headers.
- All functions in the Patient API function app require an API access key, so APIM must include `x-functions-key` in the HTTP header when calling the Patient API.
- Calling `CreateAuditRecord` in the Audit API function app requires an API access key, so Patient API needs to include `x-functions-key` in the HTTP header when calling the `CreateAuditRecord` function.
- Both Functions apps use Azure Cosmos DB as their data store, so they must use connection strings to access the Azure Cosmos DB databases.

#### Key Vault storage

Although it's possible to keep access keys and connection strings in the application settings, it's not good practice, because anyone who can access the app can see the keys and strings. The best practice, especially for production environments, is to keep the keys and strings in Azure Key Vault, and use the Key Vault references to call the apps. Key Vault allows access only to specified managed identities.

APIM uses an inbound policy to cache the Patient API host key for improved performance. For subsequent attempts, APIM looks for the key in its cache first.

- APIM retrieves the Patient API host key from Key Vault, caches it, and puts it into an HTTP header when calling the Patient API function app.
- The Patient API function app retrieves the Audit API host key from Key Vault and puts it into an HTTP header when calling the Audit API function app.
- The Azure Function runtime validates the keys in the HTTP headers on incoming requests.

#### Key rotation
Rotating Key Vault keys helps make the system more secure. You can automatically rotate keys periodically, or you can rotate keys manually or on demand in case of leakage.

Key rotation involves updating several settings:
- The function app host key itself
- The secret in Key Vault that stores the host key
- The Key Vault reference in the function app application settings, to refer to the latest secret version
- The Key Vault reference in the APIM caching policy for the Patient API

The current solution uses Terraform for most of the key rotation tasks. For more information, see [Key rotation pattern with Terraform](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/docs/key_rotation.md).

#### Managed identities
In this solution, APIM and the function apps use Azure [system-assigned managed service identities (MSIs)](/azure/active-directory/managed-identities-azure-resources) to access the Key Vault secrets. Key Vault has the following individual access policies for each service's managed identity:

- APIM can get the host key of the Patient API function app.
- The Patient API function app can get the Audit API host key and the Azure Cosmos DB connection string for its data store.
- The Audit API function app can get the Azure Cosmos DB connection string for its data store.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

One of the primary benefits of serverless applications like Azure Functions is the cost savings of paying only for consumption, rather than paying up front for dedicated servers. Virtual network support requires the [Azure Functions Premium](https://azure.microsoft.com/pricing/details/functions) plan, at additional charge. Azure Functions Premium has support for regional virtual network integration, while still supporting dynamic scaling. The Azure Functions Premium SKU includes virtual network integration on APIM.

For details and pricing calculator, see [Azure Functions pricing](https://azure.microsoft.com/pricing/details/functions).

Functions can also be hosted on [App Service virtual machines](https://azure.microsoft.com/pricing/details/app-service/windows). Only [App Service Environments (ASEs)](/azure/app-service/environment/network-info) offer complete network-level virtual network isolation. ASEs can be considerably more expensive than an Azure Functions plan that supports regional virtual network integration, and ASE scaling is less elastic.

## Deploy this scenario

The source code for this solution is at [Azure VNet-Integrated Serverless Microservices](https://github.com/mspnp/vnet-integrated-serverless-microservices).

The [TypeScript](https://www.typescriptlang.org) source code for the [PatientTest API](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/src/PatientTestsApi/readme.md) and the [Audit API](https://github.com/mspnp/vnet-integrated-serverless-microservices/blob/main/src/AuditApi/readme.md) are in the `/src` folder. Each API's source includes a [dev container](https://code.visualstudio.com/docs/remote/containers) that has all the prerequisites installed, to help you get going quickly.

Both APIs have a full suite of automated integration and unit tests to help prevent regressions when you make changes. The project is also configured for *linting* with ESLint, to maintain code styles and help guard against unintentional errors. The services' respective README files contain information on how to run the tests and linting.

### Terraform deployment

The code project's [/env](https://github.com/mspnp/vnet-integrated-serverless-microservices/tree/main/env) folder includes scripts and templates for [Terraform](https://www.terraform.io) deployment. Terraform deploys APIM and the function apps, and configures them to use the deployed Application Insights instance. Terraform also provisions all resources and configurations, including networking lockdown and the access key security pattern.

The deployment [README](https://github.com/mspnp/vnet-integrated-serverless-microservices/tree/main/env) explains how to deploy the Terraform environment in your own Azure subscription. The  `/env` folder also includes a [dev container](https://github.com/mspnp/vnet-integrated-serverless-microservices/tree/main/env/.devcontainer) that has all the prerequisites installed for Terraform deployment.

### Locust load testing

To gauge API performance, you can run load testing against the APIs with the included [Locust load tests](https://github.com/mspnp/vnet-integrated-serverless-microservices/tree/main/src/LoadTest). [Locust](https://locust.io) is an open-source load testing tool, and the tests are written in Python. You can run the load tests locally, or remotely in an Azure Kubernetes Service (AKS) cluster. The tests perform a variety of operations against the APIM endpoint, and verify behaviors against success and failure criteria.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Hannes Nel](https://nz.linkedin.com/in/hannesn) | Principal Software Engineering Lead

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Use Azure API Management with microservices deployed in Azure Kubernetes Service](/azure/api-management/api-management-kubernetes)
- [How to use Azure API Management with virtual networks](/azure/api-management/api-management-using-with-vnet)
- [How to use managed identities for App Service and Azure Functions](/azure/app-service/overview-managed-identity)
- [Use Key Vault references for App Service and Azure Functions](/azure/app-service/app-service-key-vault-references)
- [APIs and microservices e-book](https://azure.microsoft.com/mediahandler/files/resourcefiles/apis-microservices-ebook/Azure_API-Microservices_eBook.pdf)
- [API Management access restriction policies](/azure/api-management/api-management-access-restriction-policies)
- [Azure Functions networking options](/azure/azure-functions/functions-networking-options)
- [Azure Functions scale and hosting](/azure/azure-functions/functions-scale)

## Related resources

The following architectures cover key API Management scenarios:

- [Migrate a web app using Azure API Management](/azure/architecture/example-scenario/apps/apim-api-scenario)
- [Protect APIs with Application Gateway and API Management](/azure/architecture/web-apps/api-management/architectures/protect-apis)
- [Azure API Management landing zone accelerator](/azure/architecture/example-scenario/integration/app-gateway-internal-api-management-function)

The following articles cover key functions scenarios:

- [Integrate Event Hubs with serverless functions on Azure](/azure/architecture/serverless/event-hubs-functions/event-hubs-functions)
- [Monitor Azure Functions and Event Hubs](/azure/architecture/serverless/event-hubs-functions/observability)
- [Azure Functions in a hybrid environment](/azure/architecture/hybrid/azure-functions-hybrid)
- [Performance and scale for Event Hubs and Azure Functions](/azure/architecture/serverless/event-hubs-functions/performance-scale)
- [Code walkthrough: Serverless application with Functions](/azure/architecture/web-apps/serverless/architectures/code)
- [Azure App Service and Azure Functions considerations for multitenancy](/azure/architecture/guide/multitenant/service/app-service)
