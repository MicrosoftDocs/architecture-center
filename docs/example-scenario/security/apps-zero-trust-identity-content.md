This article describes an architecture for incorporating a Zero Trust approach to identity for your custom apps.

## Architecture

:::image type="content" source="media/functions-api-management.png" alt-text="Diagram that shows an architecture for incorporating a Zero Trust approach to identity for custom apps." lightbox="media/functions-api-management.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/functions-api-management.vsdx) of this architecture.*

### Workflow

This scenario is based on a fictional company named Contoso Media that works with a company called Fabrikam.

(1a) After Contoso Media provides APIs via Azure API Management, external partner developers from Fabrikam can test it by using the API Management Fabrikam Developer product key, issued for non-production purposes.

(2a) Fabrikam runs developer tests through the API Management developer portal or through any HTTP client software. They can integrate it into the Fabrikam Analytics service. The requests hit the Contoso Media API Management gateway, which validates the Fabrikam Developer product key and applies associated policies. A [throttling policy](/azure/api-management/api-management-sample-flexible-throttling#rate-limits-and-quotas) is commonly used in cases like this one.

(1b) After Fabrikam developers complete the tests and the integration work, the Fabrikam Analytics solution is deployed to the Fabrikam pre-production and production environments. These external services are configured by the Fabrikam operations teams and use Production API Management product keys, provided by Contoso Media.

(2b) The requests from Fabrikam Analytics also hit the Contoso Media API Management gateway, which validates the Fabrikam Production API Management product keys and applies associated API Management policies.

(3) The API Management gateway accesses the back-end API for both request sources: 2a and 2b. Because the HTTP API back end, which is based on Azure Functions, is configured for Active Directory authentication and trusts only the managed identity of the API Management gateway, it can access the function. No services can access the function, other than this particular API Management instance.

(4) Azure Functions accesses SQL Database. Because the managed identity of the Azure function was granted access to the SQL database, only the Azure function can access the database.

Steps 3 and 4 demonstrate an identity-based implementation of the Zero Trust principle.

### Implementation steps

To implement this architecture manually and test it, you need to complete these steps:

1. [Create Azure functions in Visual Studio Code.](/azure/azure-functions/functions-develop-vs-code?tabs=csharp)
2. [Create a SQL database](/azure/azure-sql/database/single-database-create-quickstart) and add [SQL bindings to the functions.](https://www.nuget.org/packages/Microsoft.Azure.WebJobs.Extensions.Sql)
3. Deploy the back-end API, based on Azure Functions, into Azure [from Visual Studio Code](/azure/azure-functions/functions-develop-vs-code?tabs=csharp#republish-project-files).
4. [Create an API Management instance](/azure/api-management/get-started-create-service-instance) and expose the [API back end by using API Management](/azure/api-management/import-function-app-as-api). 
5. Secure the back-end API via Azure AD so that only this API Management identity can access the back-end API.
   - Be sure that your API Management instance is assigned to a [managed identity](/azure/api-management/api-management-howto-use-managed-service-identity#create-a-system-assigned-managed-identity).
   - Configure your Azure Functions app to use Azure AD sign in.
   - [Allow API Management to access the function.](/azure/api-management/api-management-authentication-policies#use-managed-identity-to-authenticate-with-a-backend-service)
   - Allow *API Management identity only* to access your back end by [creating an app role in Azure AD for it](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps#usage-scenario-of-app-roles).
   - [Limit access to the function to only the users/roles in the app role](/azure/active-directory/develop/howto-restrict-your-app-to-a-set-of-users#update-the-app-to-require-user-assignment).
   - [Add your API Management managed identity to the app role.](/azure/active-directory/managed-identities-azure-resources/how-to-assign-app-role-managed-identity-cli#assign-a-managed-identity-access-to-another-applications-app-role)
6. Create two API Management products with two different API key sets:
   - Fabrikam Developer for partner developers. This product is exposed via the API Management developer portal with the [corresponding policies](/azure/api-management/api-management-sample-flexible-throttling#product-based-throttling).
   - Fabrikam Production for the partner IT department.
7. [Provide improved-security function access to Azure SQL via Azure AD.](/azure/azure-functions/functions-identity-access-azure-sql-with-managed-identity)

### Components

- [Azure AD](https://azure.microsoft.com/services/active-directory)
provides critical functionality for your Zero Trust strategy. It enables strong authentication, a point of integration for device security, and the core of your user-centric policies to guarantee least-privileged access. Azure AD Conditional Access provides the policy decision point for access to resources based on user identity, environment, device health, and risk, verified explicitly at the point of access.
  - [Azure AD application registration](/azure/active-directory/develop/app-objects-and-service-principals#application-registration).
To delegate identity and access management functions to Azure AD, an application must be registered with an Azure AD tenant. When you register your application with Azure AD, you're creating an identity configuration for your application that allows it to integrate with Azure AD.
  - [Azure AD managed identities](/azure/active-directory/managed-identities-azure-resources/overview).
Managed identities provide an automatically managed identity for applications to use when they connect to resources that support Azure AD authentication. Applications can use managed identities to obtain Azure AD tokens without needing to manage credentials.
- [API Management](https://azure.microsoft.com/services/api-management) is a hybrid, multicloud management platform for APIs across all environments.
  - [API Management developer portal](/azure/api-management/api-management-howto-developer-portal). 
The developer portal is a website that provides the documentation of your APIs. On the portal, API consumers can discover your APIs, learn how to use them, request access, and try them out.
  - [API Management gateway](/azure/api-management/api-management-howto-developer-portal)
All requests from client applications first reach the API gateway, which then forwards them to appropriate back-end services. The API gateway acts as a façade to the back-end services, allowing you to abstract API implementations and evolve back-end architecture without affecting API consumers. The gateway enables consistent configuration of routing, security, throttling, caching, and observability.
- [Azure Functions](https://azure.microsoft.com/services/functions)
is a serverless solution that allows you to write less code, maintain less infrastructure, and save money. The cloud infrastructure provides all the up-to-date resources needed to keep your applications running so you don't have to deploy and maintain servers.
- [SQL Database](https://azure.microsoft.com/products/azure-sql/database)
is a family of managed, improved-security products that use the SQL Server database engine on Azure.

### Alternatives

In addition to using managed identities, you can also limit access to the API back end by using the following methods:
- [Client certificate authentication](/azure/api-management/api-management-howto-mutual-certificates)
- [Private endpoints](/azure/app-service/networking/private-endpoint)
- [IP restrictions](/azure/app-service/app-service-ip-restrictions)

You can use [Azure Key Vault](https://azure.microsoft.com/services/key-vault) to store client certificates for the client certificate authentication alternative. You can also use it to store the SQL Database connection strings that are used by the API back end. This alternative, however, might require manual work or additional automation for rotating the information stored in Key Vault.

As an alternative to deploying Azure functions from Visual Studio Code, you can use [GitHub Actions](https://github.com/features/actions) or [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) for the production environments. You can generate your GitHub Actions or Azure Pipelines from the [deployment center](/azure/azure-functions/functions-continuous-deployment) of your Azure function.
 
Instead of using Azure AD app roles to limit access to the functions-based API back end, you can use Azure AD security groups. This configuration, however, is more sensitive. It might involve communication with the corporate Azure AD management team.

## Scenario details

This scenario is based on a fictional company named Contoso Media.

The Contoso Media product team has migrated some applications into Azure App Service. These applications use custom-implemented authentication and authorization.

Contoso Media applications and data are moving from on-premises to hybrid and cloud environments. Contoso Media can no longer rely on traditional network controls for security. Controls need to move to where the data is: on devices, inside apps, and with partners.

The Contoso Media team wants to increase developer speed and decrease costs while using serverless and PaaS technologies like Azure Functions and Azure SQL Database. They've heard about Microsoft Zero Trust and want to implement more modern and secure access to their services:

- Expose and provide their APIs to partners through API Management. Partner developers need to have limited access to the APIs during the development. Partner pre-production and production environments, however, should have unlimited access to the Contoso Media APIs.
- Protect access to the API back end so that only one specific API Management instance can access it.
- Protect access to the Azure SQL database used by the API back end so that only one specific identity of the REST API back end can access it.

Zero Trust provides a unified approach for the Contoso Media operations team to help ensure that their [applications, and the data they contain, are protected](/security/zero-trust/deploy/applications). Zero Trust:

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

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

API Management supports [zone redundancy](/azure/api-management/zone-redundancy) and [multi-region deployment](/azure/api-management/api-management-howto-deploy-multi-region).

The active/active pattern with Azure Front Door is the [best cross-region deployment model](/azure/azure-functions/functions-geo-disaster-recovery#redundancy-for-http-trigger-functions) for the functions-based API.

This scenario uses SQL Database for storing data. SQL Database features include zone-redundant databases, failover groups, and geo-replication. For more information, see [SQL Database availability capabilities](/azure/sql-database/sql-database-technical-overview#availability-capabilities).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This solution implements a modern security perimeter to ensure a consistent set of controls (a perimeter) between enterprise assets and the threats to them. You should design perimeters to intercept authentication requests for the resources (identity controls) rather than intercepting network traffic on enterprise networks. The traditional approach isn't feasible for enterprise assets that are outside the network.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Cost optimization and development speed are the main drivers for this implementation of serverless technology for the components of the API. All components in this solution have a consumption pricing tier:
- [API Management](/azure/api-management/api-management-features)
- [Azure Functions](/azure/azure-functions/functions-scale)
- [Azure SQL Database serverless](/azure/azure-sql/database/serverless-tier-overview?view=azuresql)

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to model your projected costs and validate them by using [Azure Load Testing](/azure/load-testing/overview-what-is-azure-load-testing).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author: 
- [Genady Belenky](https://www.linkedin.com/in/genady-belenky) | Senior Cloud Solution Architect

Other contributor:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

## Related resources
