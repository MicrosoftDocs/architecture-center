Software as a Service (SaaS) is an extremely complex topic with many points to consider. Often times, ISVs attempting to run their SaaS platform on Azure all need to solve the same few problems. Things such as:

1. Which [tenancy model](../../guide/multitenant/considerations/tenancy-models.yml) should be used?
1. How do you set up an identity solution for use in a multitenant architecture?
1. How do you handle onboarding new customers?

This reference architecture aims to answer some of these questions and is meant to provide a starting place into the world of SaaS. However, as there is no "one size fits all" approach to this subject, this architecture is meant to be adaptable to fit a wide range of scenarios.

## Potential use cases

Here are some example use cases in which this architecture could be used:

- Modernizing an existing application to support full multitenancy as part of a shift to a SaaS based business model.
- Developing a greenfield SaaS offering for the first time.
- Migrating a SaaS offering from another cloud to Azure.

## Architecture

**This is a stub architecture for the PR review. The real architecture diagram is a WIP and is coming soon!**
![Architecture Diagram](./media/architecture-saas-starter-app.png)

### Workflow

*Sequence diagram showing different scenarios:
1. Onboarding new tenant
1. Signing up and signing in
1. Adding a user to a tenant

### Components

This architecture uses the following Azure services:

- [Azure App Service](https://azure.microsoft.com/services/app-service) enables you to build and host web apps and API apps in the programming language that you choose without needing to manage infrastructure
- [Azure Active Directory B2C](https://azure.microsoft.com/services/active-directory/external-identities/b2c/) easily enables identity and access management for end user applications
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/) is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/) lets you safely manage application keys, secrets, and certificates for your application
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) lets you quickly build powerful integrations using a simple GUI tool

### Alternatives

The effectiveness of any alternative choices will depend greatly on the [tenancy model](../../guide/multitenant/considerations/tenancy-models.yml) you're aiming for your SaaS application to support.

- The current solution uses Azure Active Directory B2C as the identity drovider. Other identity providers, such as [Azure Active Directory](https://azure.microsoft.com/services/active-directory/), could be used instead as well.
- This solution uses two key vaults: One for the Identity Framework and another for the web and API modules. For tighter security, you could use one key vault per module.

- For stricter security and compliance requirements, you could choose to also implement private networking for cross service communication.

- Instead of using REST calls between services, another approach would be to use an [Event Driven Architecture](https://docs.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) for cross service messaging.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This solution relies on identity as its security paradigm. Authentication and Authorization for the web apps and apis is governed by the [Microsoft Identity Platform](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-overview), which is responsible for issuing and verifying user JWT tokens.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost to run this solution is fairly average in comparison to other web applications. Here are some high level points with an explanation of a few of the "dials" you have when it comes to cost:

- The [App Service Plan](https://docs.microsoft.com/azure/app-service/overview-hosting-plans) that you run the app services in can be scaled to fit the SKU that is required to handle the amount of throughput you need. In addition, you could run each app on a separate app service plan if you require a higher throughput, but you will incur a higher cost as a result.
- The Azure AD B2C [pricing](https://azure.microsoft.com/pricing/details/active-directory/external-identities/) has two SKUs (Premium P1 and Premium P2). Both include a free tier (up to a number of Monthly Active Users (MAU)), but you will need to evaluate which features each SKU provides to determine which is required for your use case.

- Azure SQL has a few different [purchasing models](https://docs.microsoft.com/azure/azure-sql/database/purchasing-models?view=azuresql) to fit a wide array of use cases, including the ability to autoscale. You'll need to evaluate the usage on the databases to ensure you are rightsizing them.

### Performance Efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This architecture should be able to scale to meet most medium to medium/large workloads easily. Since it is taking advantage of mostly PaaS offerings, you have many "dials" to turn to scale the solution to fit demand. 

For high throughput scenarios, or scenarios in which you need to serve customers in multiple geographies, you could also consider deploying the applications and databases in multiple regions. See the [Multi-region web app with private database](../sql-failover/app-service-private-sql-multi-region-content.yml) for a great example of this architecture.

## Deploy this scenario

If you'd like to deploy this scenario, the [Azure SaaS Dev Kit](https://github.com/Azure/azure-saas) is a deployable reference implementation of this architecture.

## Next steps

Here are some additional recommended resources for building a SaaS application on Azure:

- [Best practices for architecting multitenant solutions on Azure](https://aka.ms/multitenancy)
- [ISV Considerations for Azure landing zones](https://aka.ms/isv-landing-zones)
- [Azure Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/)
- [WingTips Tickets SaaS Application](https://docs.microsoft.com/en-us/azure/azure-sql/database/saas-tenancy-welcome-wingtip-tickets-app) - Provides details into tradeoffs with various tenancy models within the database layer.