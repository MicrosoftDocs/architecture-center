The Contoso Media product team has migrated some applications into Azure App Service. These applications use custom-implemented authentication and authorization.

Contoso Media applications and data are moving from on-premises to hybrid and cloud environments. Contoso Media can no longer rely on traditional network controls for security. Controls need to move to where the data is: on devices, inside apps, and with partners.

The Contoso Media team wants to increase developer speed and decrease costs while using serverless and PaaS technologies like Azure Functions and Azure SQL Database. They've heard about Microsoft Zero Trust and want to implement more modern and secure access to their services:

- Expose and provide their APIs to partners through Azure API Management. Partner developers need to have limited access to the APIs during the development. Partner pre-production and production environments, however, should have unlimited access to the Contoso Media APIs.
- Protect access to the API back end so that only one specific API Management instance can access it.
- Protect access to the Azure SQL database used by the API back end so that only one specific identity of the REST API back end can access it.

Zero Trust provides a unified approach for the Contoso Media operations team to ensure all their [applications, and the data they contain, are protected](/security/zero-trust/deploy/applications). Zero Trust:

- Applies controls and technologies to discover shadow IT.
- Ensures appropriate in-app permissions.
- Limits access based on real-time analytics.
- Monitors for abnormal behavior.
- Controls user actions.
- Validates secure configuration options.

Protecting API implementation and Azure SQL, as described here, is just one facet of the *verify explicitly* Zero Trust principle. Other elements include user identity and device protection. All elements use the framework and services provided by Azure Active Directory (Azure AD).

### Potential use cases

You can't assume a secure network perimeter around applications. Nearly every application, by design, is accessed from outside the network perimeter. You also can't assume that applications are secure when they're developed or will remain secure after they're deployed. It's the responsibility of the application developer to maximize the security of the application and also to minimize the damage that can occur if it's compromised. For more information, see [Increase application security using Zero Trust principles](/azure/active-directory/develop/zero-trust-for-developers).

This pattern can be applied for many industries and architectures:

- A database service needs to trust only a limited number of web applications or APIs.
- An API back end needs to trust only a limited number of the API Management instances.
- An API back end needs to trust only a limited number of the web applications.

In all of these cases, the architecture needs to implement the identity-based [verify explicitly](/security/zero-trust/user-access-productivity-validate-trust#deployment-objectives-2) Zero Trust principle, for end-user identities and also for the services included in the architecture.

## Architecture

alt text Diagram that shows an architecture for building apps with a Zero Trust approach to identity.

*Download a [Visio file]() of this architecture.*

### Workflow

(1a) After Contoso Media provides APIs through API Management, external partner developers from Fabrikam can test it by using the API Management Fabrikam Developer product key, issued for non-production purposes.

(2a) Fabrikam runs developer tests through the API Management developer portal or through any HTTP client software. They can integrate it into the Fabrikam Analytics service. The requests hit the Contoso Media API Management gateway, which validates the Fabrikam Developer product key and applies associated policies. A [throttling policy](/azure/api-management/api-management-sample-flexible-throttling#rate-limits-and-quotas) is commonly used in cases like this one.

(1b) After Fabrikam developers complete the tests and the integration work, the Fabrikam Analytics solution is deployed to the Fabrikam pre-production and production environments. These external services are configured by the Fabrikam operations teams and use Production API Management product keys, provided by Contoso Media.

(2b) The requests from Fabrikam Analytics also hit the Contoso Media API Management gateway, which validates the Fabrikam Production API Management product keys and applies associated API Management policies.

(3) The API Management gateway accesses the back-end API for both request sources: 2a and 2b. Because the HTTP API back end, which is based on Azure Functions, is configured for Active Directory authentication and trusts only the managed identity of the API Management gateway, it can access the function. No services can access the function, other than this particular API Management instance.

(4) Azure Functions accesses Azure SQL Database. Because the managed identity of the Azure function was granted access to the SQL database, only the Azure function can access the database.

Steps 3 and 4 demonstrate an identity-based implementation of the Zero Trust principle.

### Implementation steps

To implement this architecture manually and test it, you need to complete these steps:

1. [Create Azure functions in Visual Studio Code](/azure/azure-functions/functions-develop-vs-code?tabs=csharp).
2. [Create a SQL database](/azure/azure-sql/database/single-database-create-quickstart) and add [SQL bindings to the functions](https://www.nuget.org/packages/Microsoft.Azure.WebJobs.Extensions.Sql).
3. Deploy the back-end API, based on Azure Functions, into Azure [from Visual Studio Code](/azure/azure-functions/functions-develop-vs-code?tabs=csharp#republish-project-files).
4. [Create an API Management instance](/azure/api-management/get-started-create-service-instance) and expose the [API back end by using API Management](/azure/api-management/import-function-app-as-api). 
5. Secure the back-end API via Azure AD so that only this API Management identity can access the back-end API.
   - Be sure that your API Management instance is assigned to a [managed identity](/azure/api-management/api-management-howto-use-managed-service-identity#create-a-system-assigned-managed-identity).
   - [Configure your Azure Functions app to use Azure AD login](https://microsoft-my.sharepoint.com/personal/chkittel_microsoft_com/Documents/Microsoft Teams Chat Files/Azure Functions app to use Azure AD login)
   - [Allow API Management to access the Function](/azure/api-management/api-management-authentication-policies#use-managed-identity-to-authenticate-with-a-backend-service)
   - Allow *API Management identity only* to access your Azure Function based back-end by [creating an App Role in Azure AD for it](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps#usage-scenario-of-app-roles)
   - [Limit access to the Function only to the users/roles in the App Role](/azure/active-directory/develop/howto-restrict-your-app-to-a-set-of-users#update-the-app-to-require-user-assignment)
   - [Add your API Management Managed Identity to the App Role](/azure/active-directory/managed-identities-azure-resources/how-to-assign-app-role-managed-identity-cli#assign-a-managed-identity-access-to-another-applications-app-role)
6. Two API Management Products with two different API key sets need to be created
   - "Fabrikam Developer" for the partner developers and being exposed through the API Management Developer Portal with the [corresponding policies](/azure/api-management/api-management-sample-flexible-throttling#product-based-throttling)
   - "Fabrikam Production" for the partner IT department
7. Protect access to Azure SQL through Azure AD while using Functions. [Based on this](/azure/azure-functions/functions-identity-access-azure-sql-with-managed-identity) and [this tutorial](/azure/azure-functions/functions-identity-access-azure-sql-with-managed-identity)

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
