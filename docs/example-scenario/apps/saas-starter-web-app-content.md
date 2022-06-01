Software as a Service (SaaS) is a complex topic with many points to consider. Independent software vendors (ISVs) building their SaaS solutions on Azure need to solve similar problems and make decisions such as:

1. Which [tenancy model](../../guide/multitenant/considerations/tenancy-models.yml) should be used?
1. How do you set up an identity solution for use in a multitenant architecture?
1. How do you handle onboarding new customers?

This architecture aims to answer some of these questions and is meant to provide a starting place into the world of SaaS. However, as there is no "one size fits all" approach to this subject, this architecture is meant to be adaptable to fit a wide range of scenarios.

## Potential use cases

Here are some example use cases in which this architecture could be used:

- Modernizing an existing application to support full multitenancy as part of a shift to a SaaS based business model.
- Developing a greenfield SaaS offering for the first time.
- Migrating a SaaS offering from another cloud to Azure.

## Architecture

![Architecture diagram that shows the control plane, identity framework, and end user S a a S application.](./media/architecture-saas-starter-app.png)

### Terminology

This table outlines the meaning of common terms found in our workflows section below.

| Term         | Description                                                                             | Example |
| ------------ | --------------------------------------------------------------------------------------- | ------ |
| SaaS Vendor or ISV  | The entity that owns the SaaS application and code and sells the SaaS product.| Contoso Inc, selling their SaaS application: Contoso Tickets |
| Tenant       | A purchased instance of the SaaS application from SaaS Vendor. | Fourth Coffee Shop |
| SaaS Customer Admin | People who purchase or administer an application tenant. | Joe: Owner of Fourth Coffee Shop |
| SaaS Customer User | People who use an application tenant without administering it, usually belonging to the same company or group as SaaS Customer Admin. | Jill: event manager at Fourth Coffee Shop, Susan: Customer of Fourth Coffee Shop |
| End User         | Term includes SaaS Customer Admin, SaaS Customer User, or any other user types that get introduced. Used as a generic term to describe users who sign into the application. | Joe, Jill, and Susan are all End Users (from the ISV perspective) |
| Frontend Application | Used as a generic term to describe any frontend application. | The Onboarding & Admin App and SaaS App are both frontend applications.  |

### Workflow

1. *SaaS Customer Admin* navigates to the site hosted on the *Onboarding & Admin App*.
2. *SaaS Customer Admin* signs in using [user sign-in](#user-sign-in) workflow.
3. *SaaS Customer Admin* completes the [onboarding flow](#onboard-a-new-tenant).
4. *SaaS Customer Admin* navigates to the tenant admin area on the *Onboarding & Admin App* and [adds a *SaaS Customer User*](#add-a-user-to-tenant) to their newly created tenant.
5. *SaaS Customer User* navigates to the *SaaS Application App* and uses the SaaS application.

#### User sign-in

The user sign-in workflow consists of the following steps:

[ ![Sequence diagram that shows the user sign-in process](./media/saas-starter-app-sequence-diagram-sign-in.png)](./media/saas-starter-app-sequence-diagram-sign-in.png#lightbox)

1. *End User* navigates to a *Frontend Application* and clicks a "Login" button.
1. *Frontend Application* redirects *End User* to a sign in page hosted by the *Identity Provider*.
1. *End User* enters account information and submits the login form to the *Identity Provider*.
1. *Identity Provider* [issues a POST request](/azure/active-directory-b2c/api-connectors-overview?pivots=b2c-custom-policy) with the *End User*'s email and object ID to retrieve their permissions and roles.
1. *Permission Data API* looks up the *End User*'s information in the *Permission Data Storage* and returns a list of permissions and roles assigned to that *End User*.
1. *Identity Provider* adds the permissions and roles as custom claims to the JWT ID token.
1. *Identity Provider* returns a JWT ID token to the *End User* and initiates a redirect to the *Frontend Application*.
1. *End User* is redirected to the sign-in endpoint on the *Frontend Application* and presents the JWT ID token.
1. *Frontend Application* validates the JWT ID Token presented.
1. *Frontend Application* returns a successful sign-in page and the *End User* is now signed in.

See the documentation on the [OpenID Connect protocol](/azure/active-directory/develop/v2-protocols-oidc) for more information on how this sign-in flow works.

#### Onboard a new tenant

The tenant onboarding workflow consists of the following steps:

[ ![Sequence diagram that shows the tenant onboarding process](./media/saas-starter-app-sequence-diagram-onboarding.png)](./media/saas-starter-app-sequence-diagram-onboarding.png#lightbox)

1. *SaaS Customer Admin* navigates to the *Onboarding & Admin App* and completes a sign-up form.
1. *Onboarding & Admin App* issues a POST request to the *Tenant Data API* to create a new tenant.
1. *Tenant Data API* creates a new tenant in the Tenant Data Storage.
1. *Tenant Data API* issues a POST request to the *Permission Data API* grant the *SaaS Customer Admin* permissions to the newly created tenant.
1. *Permission Data API* creates a new permission record in the *Permission Data Storage*.
1. *Permission Data API* returns successfully.
1. *Tenant Data API* returns successfully.
1. *Onboarding & Admin App* issues a POST request to the *Email Notification Provider* to send a "tenant created" email to the *SaaS Customer Admin*.
1. *Email Notification Provider* sends the email.
1. *Email Notification Provider* returns successfully.
1. *Onboarding & Admin App* issues a request to the *Identity Provider* to refresh the *SaaS Customer Admin*'s JWT ID token so that it will include a JWT claim to the newly created tenant.
1. *Identity Provider* [issues a POST request](/azure/active-directory-b2c/api-connectors-overview?pivots=b2c-custom-policy) with the *SaaS Customer Admin*'s email and object ID to retrieve their permissions and roles.
1. *Permission Data API* looks up the *SaaS Customer Admin*'s information in the *Permission Data Storage* and returns a list of permissions and roles assigned to the *SaaS Customer Admin*.
1. *Identity Provider* adds the permissions and roles as custom claims to the JWT ID token.
1. *Identity Provider* returns the JWT ID token to the *Onboarding & Admin App*.
1. *Onboarding & Admin App* returns a Success Message and a new JWT ID token to the *SaaS Customer Admin*.

#### Add a user to tenant

The addition of a user to a tenant workflow consists of the following steps:

[ ![Sequence diagram that shows the addition of a new user to a tenant](./media/saas-starter-app-sequence-diagram-add-user.png)](./media/saas-starter-app-sequence-diagram-add-user.png#lightbox)

1. *SaaS Customer Admin* requests to see a list of tenants from the tenant admin area on the *Onboarding & Admin App*.
1. *Onboarding & Admin App* issues a GET request to the *Tenant Data API* to get a list of tenants for *SaaS Customer Admin*.
1. *Tenant Data API* issues a GET request to the *Permission Data API* to get a list of tenants *SaaS Customer Admin* has access to view.
1. *Permission Data API* returns a list of tenant permissions.
1. *Tenant Data API* looks up the tenant information in the Tenant Data Storage and returns a list of tenant data based on the list of tenant permissions received.
1. *Onboarding & Admin App* returns the list of tenant data to *SaaS Customer Admin*.
1. *SaaS Customer Admin* selects a tenant from the list to add a *SaaS Customer User* to and enters the email address for the *SaaS Customer User*.
1. *Onboarding & Admin App* issues a POST request to the *Tenant Data API* to add a permission for the *SaaS Customer User* on the specified tenant.
1. *Tenant Data API* verifies that the *SaaS Customer Admin* has a valid JWT claim to the specified tenant and has the users.write permission on it.
1. *Tenant Data API* issues a POST request to the *Permission Data API* to add a permission for the *SaaS Customer User* on the specified tenant.
1. *Permission Data API* issues a GET request to the *Identity Provider* to lookup the *SaaS Customer User* by the provided email.
1. *Identity Provider* returns the *SaaS Customer User*'s Object ID.
1. *Permission Data API* adds a permission record in the *Permission Data Storage* for the *SaaS Customer User* on the specified tenant using their Object ID.
1. *Permission Data API* returns successfully.
1. *Tenant Data API* returns successfully.
1. *Onboarding & Admin App* returns successfully.

### Components

This architecture uses the following Azure services:

- [Azure App Service](https://azure.microsoft.com/services/app-service) enables you to build and host web apps and API apps in the programming language that you choose without needing to manage infrastructure.
- [Azure Active Directory B2C](https://azure.microsoft.com/services/active-directory/external-identities/b2c/) easily enables identity and access management for end user applications.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/) is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) lets you quickly build powerful integrations using a simple GUI tool.

### Alternatives

The effectiveness of any alternative choices will depend greatly on the [tenancy model](../../guide/multitenant/considerations/tenancy-models.yml) you're aiming for your SaaS application to support. Here are some example alternative approaches you can follow when you implement this solution:

- The current solution uses Azure Active Directory B2C as the identity provider. Other identity providers, such as [Azure Active Directory](https://azure.microsoft.com/services/active-directory/), could be used instead as well.
- For stricter security and compliance requirements, you could choose to implement private networking for cross-service communication.
- Instead of using REST calls between services, another approach would be to use an [event-driven architectural style](/azure/architecture/guide/architecture-styles/event-driven) for cross-service messaging.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This solution relies on identity as its security paradigm. Authentication and authorization for the web apps and APIs is governed by the [Microsoft Identity Platform](/azure/active-directory/develop/v2-overview), which is responsible for issuing and verifying user JWT tokens.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The components in this solution have some cost associated with their operation, but the cost is modest for most web applications and SaaS solutions. Additionally, you can control the cost by managing the following resource settings:

- The [App Service plan](/azure/app-service/overview-hosting-plans) that runs the application can be scaled to fit the throughput that you need. In addition, you could run each app on a separate plan if you require a higher throughput, but you will incur a higher cost as a result.
- [Azure AD B2C provides two SKUs](https://azure.microsoft.com/pricing/details/active-directory/external-identities/), Premium P1 and Premium P2. Both SKUs include a free allowance for the number of monthly active users (MAUs), but you need to evaluate which features each SKU provides to determine which is required for your use case.
- [Azure SQL has several purchasing models](/azure/azure-sql/database/purchasing-models) to fit a wide array of use cases, including the ability to autoscale. You need to evaluate the usage on your own databases to ensure you size them correctly.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This architecture should be able to scale to meet most medium to medium/large workloads easily. Since it mostly uses Azure's platform (PaaS) services, you have many options to adjust the scale of the solution based on your requirements and load.

For high throughput scenarios, or scenarios in which you need to serve customers in multiple geographies, you could also consider deploying the applications and databases in multiple regions. See the [Multi-region web app with private database](../sql-failover/app-service-private-sql-multi-region.yml) for a great example of this architecture.

## Deploy this scenario

If you'd like to deploy this scenario, the [Azure SaaS Dev Kit](https://github.com/Azure/azure-saas) is a deployable reference implementation of this architecture.

## Next steps

Here are some additional recommended resources for building a SaaS application on Azure:

- [Best practices for architecting multitenant solutions on Azure](../../guide/multitenant/overview.md)
- [ISV Considerations for Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/isv-landing-zone)
- [Azure Well-Architected Framework](/azure/architecture/framework/)
- [WingTips Tickets SaaS Application](/azure/azure-sql/database/saas-tenancy-welcome-wingtip-tickets-app) - Provides details into tradeoffs with various tenancy models within the database layer.