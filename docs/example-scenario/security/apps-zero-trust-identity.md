Contoso Media Product team has already migrated a couple of their applications into Azure App Service. These applications are currently using custom implemented Authentication and Authorization. 

Contoso Media applications and data are moving from on-premises to hybrid and cloud environments. Contoso Media can no longer rely on traditional network controls for security. Controls need to move to where the data is: on devices, inside apps, and with partners.

The Contoso Media team would like to increase their developers velocity and decrease costs while using serverless and PaaS technologies such as Azure Functions and Azure SQL Database. They have heard about Microsoft Zero Trust concept and would like to implement modern and more secure access to their services:

- Expose and provide their APIs to the partners through the Azure API Management (APIM). Partner developers shall have a limited access to the APIs during the development, partner pre-production and production environments, however should have unlimited access to the Contoso Media APIs
- Protect access to the API back-end so that only one particular APIM instance can access it
- Protect access to the Azure SQL database used by the API back-end so that only one particular identity of the REST API back-end can access it

Zero Trust will become a unified approach for Contoso Media operations team ensuring all their [applications, and the data they contain, are protected by](/security/zero-trust/deploy/applications):

- Applying controls and technologies to discover shadow IT.
- Ensuring appropriate in-app permissions.
- Limiting access based on real-time analytics.
- Monitoring for abnormal behavior.
- Controlling user actions.
- Validating secure configuration options.

Protecting API implementation and Azure SQL as described here, is just one scenario covering “Verify Explicitly” Zero Trust principle, further scenarios include user identity and device protection, but all of them will use the same framework and services provided by Azure Active Directory.

### Potential use cases

As [this document](/azure/active-directory/develop/zero-trust-for-developers) states "A secure network perimeter around the applications that are developed can't be assumed. Nearly every developed application, by design, will be accessed from outside the network perimeter. Applications can't be guaranteed to be secure when they're developed or will remain so after they're deployed. It's the responsibility of the application developer to not only maximize the security of the application, but also minimize the damage the application can cause if it's compromised."

This pattern can be applied for the variety of industries and architectures:

- A database service needs to trust only to a limited number of Web Applications or APIs
- An API back-end needs to trust only to a limited number of the API Management instances
- An API back-end needs to trust only to a limited number of the Web Applications

In all these cases the architecture needs implement identity based ["Verify explicitly"](/security/zero-trust/user-access-productivity-validate-trust#deployment-objectives-2) Zero Trust guiding principle – not only for the end-user identities, but also for the services included into the architecture.

## Architecture

image 

Figure 1. Building apps with a Zero Trust approach to identity. API Management

download link 

1a. After Contoso Media organization provided APIs through the APIM, external partner developers from the Fabrikam organization can start testing it by using APIM “Fabrikam Developer” Product key issued for the non-production purposes.

2a. Fabrikam can run developer tests through the APIM Developer Portal or through any HTTP client software and integrate it into their “Fabrikam Analytics” service. The requests will hit Contoso Media APIM Gateway which in turn will validate the “Fabrikam Developer” Product keys and apply associated policies. One of the common policies for such cases is a throttling policy.

1b. After the tests and the integration work is done by the Fabrikam developers, the “Fabrikam Analytics” solution will be deployed to the Fabrikam pre-production and production environments. These external services will be configured by the Fabrikam operations teams and will use “Production” APIM Product keys, provided to them by Contoso Media.

2b. The requests from “Fabrikam Analytics” will also hit Contoso Media APIM Gateway validating the “Fabrikam Production” APIM Product keys and applying associated APIM policies.   

3. APIM Gateway accesses the back-end API for both request sources – 2a and 2b. Since Azure Function based HTTP API backend is configured for the Active Directory authentication and trusts only the managed identity of the APIM Gateway, it can successfully access the Function. No other services can access Function apart of this particular APIM instance.

4. Azure Function accesses Azure SQL database. Since managed identity of the Azure Function was granted access to the Azure SQL database, only Azure Function can access the database 

Steps 3 and 4 demonstrate identity-based implementation of the Zero Trust principle.

Implementation steps

In order to implement this architecture manually and test it, you will need to implement the following steps

- [Create Azure Functions in VS Code](/azure/azure-functions/functions-develop-vs-code?tabs=csharp)
- [Create SQL Database](/azure/azure-sql/database/single-database-create-quickstart) and add [SQL Bindings to the Functions](https://www.nuget.org/packages/Microsoft.Azure.WebJobs.Extensions.Sql).
- Deploy Azure Function based back-end API into Azure [from VS Code](/azure/azure-functions/functions-develop-vs-code?tabs=csharp#republish-project-files)
- [Create an APIM instance](/azure/api-management/get-started-create-service-instance) and expose the [Azure Function based API back-end through the APIM](/azure/api-management/import-function-app-as-api). 
- Secure the back-end API through Azure Active Directory so that only this APIM identity can access the back-end API
  - Make sure that your APIM instance is assigned to a [Managed Identity](/azure/api-management/api-management-howto-use-managed-service-identity#create-a-system-assigned-managed-identity)
  - [Configure your Azure Functions app to use Azure AD login](https://microsoft-my.sharepoint.com/personal/chkittel_microsoft_com/Documents/Microsoft Teams Chat Files/Azure Functions app to use Azure AD login)
  - [Allow APIM to access the Function](/azure/api-management/api-management-authentication-policies#use-managed-identity-to-authenticate-with-a-backend-service)
  - Allow *APIM identity only* to access your Azure Function based back-end by [creating an App Role in Azure AD for it](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps#usage-scenario-of-app-roles)
  - [Limit access to the Function only to the users/roles in the App Role](/azure/active-directory/develop/howto-restrict-your-app-to-a-set-of-users#update-the-app-to-require-user-assignment)
  - [Add your APIM Managed Identity to the App Role](/azure/active-directory/managed-identities-azure-resources/how-to-assign-app-role-managed-identity-cli#assign-a-managed-identity-access-to-another-applications-app-role)
- Two APIM Products with two different API key sets need to be created
  - "Fabrikam Developer" for the partner developers and being exposed through the APIM Developer Portal with the [corresponding policies](/azure/api-management/api-management-sample-flexible-throttling#product-based-throttling)
  - "Fabrikam Production" for the partner IT department
- Protect access to Azure SQL through Azure AD while using Functions. [Based on this](/azure/azure-functions/functions-identity-access-azure-sql-with-managed-identity) and [this tutorial](/azure/azure-functions/functions-identity-access-azure-sql-with-managed-identity)

### Components

- [Azure AD]()
Azure AD provides critical functionality for your Zero Trust strategy. It enables strong authentication, a point of integration for device security, and the core of your user-centric policies to guarantee least-privileged access. Azure AD’s Conditional Access capabilities are the policy decision point for access to resources based on user identity, environment, device health, and risk—verified explicitly at the point of access.
- [Azure AD App Registrations](/azure/active-directory/develop/app-objects-and-service-principals#application-registration)
To delegate identity and access management functions to Azure AD, an application must be registered with an Azure AD tenant. When you register your application with Azure AD, you're creating an identity configuration for your application that allows it to integrate with Azure AD.
- [Azure AD Managed Identities](/azure/active-directory/managed-identities-azure-resources/overview)
Managed identities provide an automatically managed identity in Azure Active Directory for applications to use when connecting to resources that support Azure Active Directory (Azure AD) authentication. Applications can use managed identities to obtain Azure AD tokens without having to manage any credentials.
- [Azure API Management Developer Portal]
It is a website with the documentation of your APIs. It is where API consumers can discover your APIs, learn how to use them, request access, and try them out.
- [Azure API Management Gateway](/azure/api-management/api-management-howto-developer-portal)
All requests from client applications first reach the API gateway, which then forwards them to respective backend services. The API gateway acts as a façade to the backend services, allowing API providers to abstract API implementations and evolve backend architecture without impacting API consumers. The gateway enables consistent configuration of routing, security, throttling, caching, and observability.
- [Azure Functions](https://azure.microsoft.com/services/functions)
Azure Functions is a serverless solution that allows you to write less code, maintain less infrastructure, and save on costs. Instead of worrying about deploying and maintaining servers, the cloud infrastructure provides all the up-to-date resources needed to keep your applications running.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
Azure SQL is a family of managed, secure, and intelligent products that use the SQL Server database engine in the Azure cloud.

### Alternatives

Additionally, to the managed identities, it is also possible to limit access to the API Backend through:
- [Client Certificate Authentication](/azure/api-management/api-management-howto-mutual-certificates)
- [Private Endpoints](/azure/app-service/networking/private-endpoint)
- [IP Restrictions](/azure/app-service/app-service-ip-restrictions)

[Azure KeyVault]() could also be used to store Client certificates for the Client Certificate Authentication above and also to store the Azure SQL Database connection strings used by the API back-end. This, however, might require manual work or additional automation for rotating the information stored in the Key Vault.

Instead of deploying Azure Function from VS Code, [GitHub Actions]() or [Azure DevOps Pipelines]() must be considered for the production environments. You can generate your GitHub Actions or Azure DevOps Pipelines from the [Deployment Center](/azure/azure-functions/functions-continuous-deployment) of your Azure Function.
 
Instead of Azure AD App Roles limiting access to the Azure Functions based API back-end, Azure AD Security Groups can be used. However, this is a more sensitive configuration and might involve communication with the corporate Azure AD management team.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Azure API Management supports [Zones redundancy](/azure/api-management/zone-redundancy) and [Multi-Region deployment](/azure/api-management/api-management-howto-deploy-multi-region).

The active/active pattern with Azure Front Door is the [best cross-region deployment model](/azure/azure-functions/functions-geo-disaster-recovery#redundancy-for-http-trigger-functions) for the Azure Functions based API.

This scenario uses Azure SQL Database for storing data. SQL Database includes Zone redundant databases, failover groups, and geo-replication. For more information, see [Azure SQL Database availability capabilities](/azure/sql-database/sql-database-technical-overview#availability-capabilities).

### Security

This solution implements modern security perimeter ensuring that Contoso Media has a consistent set of controls (a perimeter) between their assets and the threats to them. Perimeters should be designed based on intercepting authentication requests for the resources (identity controls) versus intercepting network traffic on enterprise networks. This traditional approach isn't feasible for enterprise assets outside the network.

### Cost optimization

Cost optimization and developer velocity topics were the main drivers for the Contoso Media team moving towards Serverless technology for the components of their API implementation. All components in this solution have a consumption pricing tier:
- [API Management](/azure/api-management/api-management-features)
- [Azure Functions](/azure/azure-functions/functions-scale)
- [Azure SQL Serverless](/azure/azure-sql/database/serverless-tier-overview?view=azuresql)

Contoso Media team will use [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to model their projected costs and validate them with the [Azure Load Testing](/azure/load-testing/overview-what-is-azure-load-testing) service.

## Contributors

This article is maintained by Microsoft. It was originally written by the following contributors.

Principal author: 
- [Genady Belenky](https://www.linkedin.com/in/genady-belenky)
