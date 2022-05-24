Software as a Service (SaaS) is an extremely complex topic with many points to consider. Often times, ISVs attempting to run their SaaS platform on Azure all need to solve the same few problems. Things such as:

1. What [tenancy model](https://docs.microsoft.com/en-us/azure/architecture/guide/multitenant/considerations/tenancy-models) should be used?

2. How do you set up an identity solution for use in a multitenant architecture?

3. How do you handle onboarding new customers?

This reference architecture aims to answer some of these questions and is meant to provide a starting place into the world of SaaS. However, as there is no "one size fits all" approach to this subject, this architecture is meant to be adaptable to fit a wide range of scenarios.

## Potential Use Cases

Here are some example use cases in which this architecture could be used:

- Modernizing an existing application to support full multitenancy as part of a shift to a SaaS based business model

- Developing a greenfield SaaS offering for the first time

- Migrating a SaaS offering from another cloud to Azure

## Architecture

**This is a stub architecture for the PR review. The real architecture diagram is a WIP and is coming soon!**
![Architecture Diagram](./media/architecture-saas-starter-app.png)

### Workflow

*Sequence diagram showing different scenarios:
1. Onboarding new tenant
2. Signing Up and Signing In
3. Adding a user to a tenant

### Components

This architecture uses the following Azure services:

- [Azure App Service](https://azure.microsoft.com/services/app-service) enables you to build and host web apps and API apps in the programming language that you choose without needing to manage infrastructure

- [Azure Active Directory B2C](https://azure.microsoft.com/en-us/services/active-directory/external-identities/b2c/) easily enables identity and access management for end user applications

- [Azure SQL Database](https://azure.microsoft.com/en-us/products/azure-sql/database/) is a general-purpose relational database managed service that supports relational data, spatial data, JSON, and XML.

- [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/) lets you safely manage application keys, secrets, and certificates for your application

- [Azure Logic Apps](https://azure.microsoft.com/en-us/services/logic-apps/) lets you quickly build powerful integrations using a simple GUI tool

### Alternatives

>The effectiveness of any alternative choices will depend greatly on the [tenancy model](https://docs.microsoft.com/en-us/azure/architecture/guide/multitenant/considerations/tenancy-models) you're aiming for your SaaS application to support.

- The current solution uses Azure Active Directory B2C as the Identity Provider. Other identity providers, such as [Azure Active Directory](https://azure.microsoft.com/en-us/services/active-directory/), could be used instead as well.

- This solution uses two key vaults: One for the Identity Framework and another for the web and API modules. For tighter security, you could use one key vault per module.
  
- For stricter security requirements, you could move to using private networking for communication between microservices. The current solution relies solely on identity and access management as its security paradigm.

- Instead of using REST calls between services, another approach would be to use an [Event Driven Architecture](https://docs.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) for cross service messaging.

## Deploy this Scenario

If you'd like to deploy this scenario, the [Azure SaaS Dev Kit](https://github.com/Azure/azure-saas) is a deployable reference implementation of this architecture.

## Next Steps

Here are some additional recommended resources for building a SaaS application on Azure:

- [Best practices for architecting multitenant solutions on Azure](https://aka.ms/multitenancy)
- [ISV Considerations for Azure landing zones](https://aka.ms/isv-landing-zones)
- [Azure Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/)
- [WingTips Tickets SaaS Application](https://docs.microsoft.com/en-us/azure/azure-sql/database/saas-tenancy-welcome-wingtip-tickets-app) - Provides details into tradeoffs with various tenancy models within the database layer.