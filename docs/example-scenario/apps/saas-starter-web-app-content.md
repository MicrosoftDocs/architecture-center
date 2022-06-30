Software as a Service (SaaS) is a complex topic with many points to consider. Independent software vendors (ISVs) who build their SaaS solutions on Azure need to solve problems and make decisions such as:

- Which [tenancy model](../../guide/multitenant/considerations/tenancy-models.yml) should I use?
- How do I set up an identity solution for use in a multitenant architecture?
- How do I handle onboarding new customers?

This architecture aims to answer some of these questions and provide a starting place into the world of SaaS. This architecture is adaptable to fit a wide range of scenarios.

## Potential use cases

The following are some example use cases in which you could use this architecture:

- Modernize an existing application to support full multitenancy as part of a shift to a SaaS-based business model.
- Develop a completely new SaaS offering.
- Migrate a SaaS offering from another cloud service to Azure.

## Architecture

:::image type="content" alt-text="Architecture diagram that shows the control plane, identity framework, and end-user S a a S application." source="./media/saas-starter-web-app-architecture.svg" lightbox="./media/saas-starter-web-app-architecture.svg" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/saas-starter-web-app-architecture.pptx) of this architecture.*

### Terminology

The following table describes terms that appear in this article.

| Term         | Description                                                                             | Example |
| ------------ | --------------------------------------------------------------------------------------- | ------ |
| SaaS vendor or ISV  | The entity that owns the SaaS application and code and sells the SaaS product.| Contoso Inc, selling their SaaS application: Contoso Tickets. |
| Tenant       | A purchased instance of the SaaS application from SaaS Vendor. | Fourth Coffee Shop. |
| SaaS customer admin | People who purchase or administer an application tenant. | Joe, owner of Fourth Coffee Shop. |
| SaaS customer user | People who use an application tenant without administering it and usually belong to the same company or group as the SaaS customer admin. | Jill, event manager at Fourth Coffee Shop, and Susan, customer of Fourth Coffee Shop. |
| End user         | A SaaS customer admin, SaaS customer user, or any other user types that are introduced. This is a generic term to describe users who sign into the application. | Joe, Jill, and Susan are all end users (from the ISV perspective). |
| Front-end application | Any front-end application. | The Onboarding & admin app and SaaS app are both front-end applications. |

### Workflow

1. The *SaaS customer admin* navigates to the site that is hosted on the *Onboarding & admin app*.

2. The *SaaS customer admin* signs in by using the [user sign-in](#user-sign-in) workflow.

3. The *SaaS customer admin* completes the [onboarding flow](#onboard-a-new-tenant).

4. The *SaaS customer admin* navigates to the tenant admin area on the *Onboarding & admin app* and [adds a *SaaS Customer User*](#add-a-user-to-a-tenant) to their newly created tenant.

5. The *SaaS customer user* navigates to the *SaaS application app* and uses the SaaS application.

#### User sign-in

The user sign-in workflow consists of the following steps:

:::image type="content" alt-text="Sequence diagram that shows the sign-in process for a user." source="./media/saas-starter-app-sequence-diagram-sign-in.png" lightbox="./media/saas-starter-app-sequence-diagram-sign-in.png":::

1. The *End user* navigates to a *front-end application* and selects a **Login** button.

1. The *Front-end application* redirects the *end user* to a sign-in page that is hosted by the *identity provider*.

1. The *End User* enters account information and submits the sign-in form to the *Identity provider*.

1. The *Identity provider* [issues a POST request](/azure/active-directory-b2c/api-connectors-overview?pivots=b2c-custom-policy) with the *end user*'s email address and object ID to retrieve their permissions and roles.

1. The *Permission data API* looks up the *end user*'s information in the *Permission data storage* and returns a list of permissions and roles that are assigned to that *end user*.

1. The *Identity provider* adds the permissions and roles as custom claims to the [ID token](/azure/active-directory/develop/id-tokens), which is a JSON web token (JWT).

1. The *Identity provider* returns an ID token to the *end user* and initiates a redirect to the *front-end application*.

1. The *End user* is redirected to the sign-in endpoint on the *front-end application* and presents the ID token.

1. The *Front-end application* validates the presented ID token.

1. The *Front-end application* returns a successful sign-in page and the *end user* is now signed in.

For more information about how this sign-in flow works, see [OpenID Connect protocol](/azure/active-directory/develop/v2-protocols-oidc).

#### Onboard a new tenant

The tenant onboarding workflow consists of the following steps:

:::image type="content" alt-text="Sequence diagram that shows the process for tenant onboarding." source="./media/saas-starter-app-sequence-diagram-onboarding.png" lightbox="./media/saas-starter-app-sequence-diagram-onboarding.png":::

1. The *SaaS customer admin* navigates to the *Onboarding & admin app* and completes a sign-up form.

1. The *Onboarding & admin app* issues a POST request to the *Tenant data API* to create a new tenant.

1. The *Tenant data API* creates a new tenant in the tenant data storage.

1. The *Tenant data API* issues a POST request to the *Permission data API* to grant the *SaaS customer admin* permissions to the newly created tenant.

1. The *Permission data API* creates a new permission record in the *Permission data storage*.

1. The *Permission data API* returns successfully.

1. The *Tenant data API* returns successfully.

1. The *Onboarding & admin app* issues a POST request to the *Email notification provider* to send a "tenant created" email message to the *SaaS customer admin*.

1. The *Email notification provider* sends the email.

1. The *Email notification provider* returns successfully.

1. The *Onboarding & admin app* issues a request to the *Identity provider* to refresh the *SaaS customer admin*'s ID token so that it will include a JWT claim to the newly created tenant.

1. The *Identity provider* [issues a POST request](/azure/active-directory-b2c/api-connectors-overview?pivots=b2c-custom-policy) with the *SaaS customer admin*'s email address and object ID to retrieve their permissions and roles.

1. The *Permission data API* looks up the *SaaS customer admin*'s information in the *Permission data storage* and returns a list of permissions and roles assigned to the *SaaS customer admin*.

1. The *Identity provider* adds the permissions and roles as custom claims to the ID token.

1. The *Identity provider* returns the ID token to the *Onboarding & Admin App*.

1. The *Onboarding & admin app* returns a success message and a new ID token to the *SaaS Customer Admin*.

#### Add a user to a tenant

The addition of a user to a tenant workflow consists of the following steps:

:::image type="content" alt-text="Sequence diagram that shows the addition of a new user to a tenant." source="./media/saas-starter-app-sequence-diagram-add-user.png" lightbox="./media/saas-starter-app-sequence-diagram-add-user.png":::

1. The *SaaS customer admin* requests to see a list of tenants from the tenant admin area on the *Onboarding & admin app*.

1. The *Onboarding & admin app* issues a GET request to the *Tenant data API* to get a list of tenants for the *SaaS customer admin*.

1. The *Tenant data API* issues a GET request to the *Permission data API* to get a list of tenants that the *SaaS customer admin* has access to view.

1. The *Permission data API* returns a list of tenant permissions.

1. The *Tenant data API* looks up the tenant information in the Tenant data storage and returns a list of tenant data based on the list of tenant permissions received.

1. The *Onboarding & admin app* returns the list of tenant data to *SaaS customer admin*.

1. The *SaaS customer admin* selects a tenant from the list to add a *SaaS customer user* to and enters the email address for the *SaaS customer user*.

1. The *Onboarding & admin app* issues a POST request to the *Tenant data API* to add a permission for the *SaaS customer user* on the specified tenant.

1. The *Tenant data API* verifies that the *SaaS customer admin* has a valid JWT claim to the specified tenant and has the user's write permission on it.

1. The *Tenant data API* issues a POST request to the *Permission data API* to add a permission for the *SaaS customer user* on the specified tenant.

1. The *Permission data API* issues a GET request to the *Identity provider* to look up the *SaaS customer user* by the provided email address.

1. The *Identity provider* returns the *SaaS customer user*'s object ID.

1. The *Permission data API* adds a permission record in the *Permission data storage* for the *SaaS customer user* on the specified tenant by using their object ID.

1. The *Permission data API* returns successfully.

1. The *Tenant data API* returns successfully.

1. The *Onboarding & admin app* returns successfully.

### Components

This architecture uses the following Azure services:

- [App Service](https://azure.microsoft.com/services/app-service) enables you to build and host web apps and API apps in the programming language that you choose without needing to manage infrastructure.

- [Azure Active Directory B2C](https://azure.microsoft.com/services/active-directory/external-identities/b2c/) easily enables identity and access management for end user applications.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/) is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.

- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) lets you quickly build powerful integrations using a simple GUI tool.

### Alternatives

The effectiveness of any alternative choices depends greatly on the [tenancy model](../../guide/multitenant/considerations/tenancy-models.yml) that you intend for your SaaS application to support. The following are some examples of alternative approaches that you can follow when you implement this solution:

- The current solution uses Azure Active Directory B2C as the identity provider. You could instead use other identity providers, such as [Azure Active Directory](https://azure.microsoft.com/services/active-directory/).

- For stricter security and compliance requirements, you could choose to implement private networking for cross-service communication.

- Instead of using REST calls between services, you could implement an [event-driven architectural style](/azure/architecture/guide/architecture-styles/event-driven) for cross-service messaging.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can follow to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This solution relies on identity as its security paradigm. Authentication and authorization for the web apps and APIs is governed by the [Microsoft Identity Platform](/azure/active-directory/develop/v2-overview), which is responsible for issuing and verifying user ID tokens (JWTs).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The components in this solution have some cost associated with their operation, but the cost is modest for most web applications and SaaS solutions. Also, you can control the cost by managing the following resource settings:

- You can scale the App Service plan that runs the application to fit the throughput that you need. In addition, you could run each app on a separate plan if you require higher throughput, but you'll incur a higher cost as a result. For more information, see [Azure App Service plan overview](/azure/app-service/overview-hosting-plans).

- Azure AD B2C provides two SKUs: Premium P1 and Premium P2. Both SKUs include a free allowance for the number of monthly active users (MAUs), but you need to evaluate which features that each SKU provides to determine which is required for your use case. For more information, see [Azure Active Directory External Identities pricing](https://azure.microsoft.com/pricing/details/active-directory/external-identities/).

- Azure SQL has several purchasing models to fit a wide array of use cases, including the ability to autoscale. You need to evaluate the usage on your own databases to ensure you size them correctly. For more information, see [Compare vCore and DTU-based purchasing models of Azure SQL Database](/azure/azure-sql/database/purchasing-models).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

This architecture should be able to scale to easily meet most medium to medium-large workloads. Since the architecture mostly uses Azure's platform (PaaS) services, you have many options to adjust the scale of the solution based on your requirements and load.

For high-throughput scenarios, or scenarios in which you need to serve customers in multiple geographies, you can also consider deploying the applications and databases in multiple regions. For a great example of this architecture, see [Multi-region web app with private connectivity to a database](../sql-failover/app-service-private-sql-multi-region.yml).

## Deploy this scenario

If you'd like to deploy this scenario, see the [Azure SaaS Dev Kit](https://github.com/Azure/azure-saas) on GitHub. It's a deployable reference implementation of this architecture.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Landon Pierce](https://www.linkedin.com/in/landon-pierce-a84b37b6) | Customer Engineer

Other contributors: 

 - [Chris Ayers](https://www.linkedin.com/in/chris-l-ayers/) | Senior Customer Engineer
 - [John Downs](https://www.linkedin.com/in/john-downs) | Senior Customer Engineer
 - [LaBrina Loving](https://www.linkedin.com/in/chixcancode/) | Principal SVC Engineering Manager
 - [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 - [Nick Pinheiro](https://www.linkedin.com/in/nickpinheiro/) | Senior Consultant
 - [William Salazar](https://www.linkedin.com/in/whsalazar/) | Senior Customer Engineer
 - [Ali Sanjabi](https://www.linkedin.com/in/alisanjabi/) | Senior Customer Engineer
 - [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer
 - [Jason Young](https://www.linkedin.com/in/jasony) | Principal SVC Engineering Manager

## Next steps

Here are some additional recommended resources for building a SaaS application on Azure:

- [Architect multitenant solutions on Azure](../../guide/multitenant/overview.md) - Describes best practices.
- [ISV Considerations for Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/isv-landing-zone)
- [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/)
- [WingTips Tickets SaaS application](/azure/azure-sql/database/saas-tenancy-welcome-wingtip-tickets-app) - Provides details about tradeoffs between various tenancy models within the database layer.

## Related resources

- [Tenancy models to consider for a multitenant solution](/azure/architecture/guide/multitenant/considerations/tenancy-models)
- [Architectural approaches for compute in multitenant solutions](/azure/architecture/guide/multitenant/approaches/compute)
- [Architectural approaches for storage and data in multitenant solutions](/azure/architecture/guide/multitenant/approaches/storage-data)
- [Azure App Service and Azure Functions considerations for multitenancy](/azure/architecture/guide/multitenant/service/app-service)
- [Multitenant SaaS on Azure](/azure/architecture/example-scenario/multi-saas/multitenant-saas)
- [Tenancy models for SaaS applications](/azure/architecture/isv/application-tenancy)
- [Cloud Design Patterns](/azure/architecture/patterns/)
