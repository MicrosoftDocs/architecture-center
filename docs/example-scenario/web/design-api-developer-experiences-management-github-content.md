An API developer experience is the overall experience of a third-party developer when using a platform or service. The success and adoption of any API platform is largely dependent on how highly it's regarded in the marketplace. API services and products, also known as the _digital assets_ of an enterprise, are important accelerators of innovation and revenue that boost the [API economy](/azure/api-management/monetization-overview) for the enterprise.

<!--
For a digital enterprise that offers API services, third-party API developers can have a positive influence in promoting a brand. Promotion results in significant opportunities for generating revenue through increased use and consumption.
-->

## Potential use cases

You can use this solution to make it easy for API developers to:

- Discover and understand the API product offerings.
- Subscribe and integrate with the various applications and channels.
- Get help, troubleshoot problems, and remediate issues.
- Promote community contribution and exchange ideas and knowledge.


## Architecture

:::image type="content" alt-text="Diagram of the architecture that's described in this article." source="media/design-api-developer-experiences-management-github-architecture.png" lightbox="media/design-api-developer-experiences-management-github-architecture.png":::

_Download a [PowerPoint file](https://arch-center.azureedge.net/design-api-developer-experiences-management-github.pptx) of this architecture._

### Workflow

The solution primarily consists of the following building blocks:

- **Monetized back-end APIs & API gateway**. At the core of the solution is the set of back-end APIs that will be monetized. The consumers (users, applications, devices, etc.) access the API platform through an API gateway. The gateway applies rate leveling and throttles requests as needed.

- **Consumer portal and applications**. The consumers of the API platform browse the API offerings, register, and then generate subscription keys to access the various API end points. They can update information about their accounts and billing by using the account management features of the solution.

- **Administrative portals and applications**. Platform administrators publish the list of API products, their pricing, and rate plans. These portals also offer rich analytics on the use of the various API products, which help troubleshooting issues and offering support services.

- **Line of business services**. These services are required to deliver the functionalities of the consumer portals & applications. These services are required to support the various user journeys that are supported in the solution.

- **API consumption tracking and charges calculation engine**. The API consumption reports, captured at the API gateway layer, are periodically exported to a separate data store. Scheduled jobs run on this data to calculate the charges that apply to any consumer account, based on its list of subscriptions and associated pricing model.

The processing sequence in this solution flows as follows:

1.  The API publisher imports the API specification(s) by using the Azure portal, groups them by product, and publishes them.

2.  The API publisher updates the product-related marketing information in the corresponding GitHub repository.

3.  The API consumer accesses the marketplace portal, browses the various products, and selects a specific API service.

4.  When the consumer attempts to view more information about the API service, the consumer portal redirects the consumer to the enhanced developer portal, which is hosted on GitHub and uses GitHub Pages.

5.  The consumer can browse different API specifications, developer-related information, and even try invoking an endpoint by using a sample payload.

6.  The consumer registers with the platform and then activates a subscription for the particular API service that they're interested in using.

7.  The consumer makes use of the API service in their apps or devices.

8.  The invocation of the API generates metrics about its use and consumption, which are stored by Azure in tracking databases.

9.  The consumption data is periodically exported and saved to a custom database (typically a data lake) for further analysis.

10. A back-end job then correlates the consumption data against the various subscriptions and calculates the charges.

11. The invoice and payment-related information is stored within the accounting database, which is used for generating revenue for the service.

### Components

The solution is composed of the following software as a service (SaaS) offerings:

- [API Management](https://azure.microsoft.com/services/api-management/): Azure API Management is a managed platform as a service that allows organizations to publish APIs to both internal and external consumers. With API Management, you can publish APIs that may be hosted anywhere. Basically, API Management allows for decoupling of API hosting from the published gateway that acts as the single-entry point (as described in [Gateway Routing pattern](/azure/architecture/patterns/gateway-routing)) for the full landscape of APIs that your enterprise publishes. 

  API Management also provides a governance layer on top of all published APIs. By using API Management policies, various other capabilities, such as [rate limits and quotas](/azure/api-management/api-management-sample-flexible-throttling), can throttle API requests based on a key or subscription. API Management includes a [developer portal](/azure/api-management/api-management-howto-developer-portal) that provides a fully customizable website to serve as the documentation of the APIs that you publish through it.

- [GitHub](https://docs.github.com/): GitHub is a popular SaaS offering from Microsoft that is frequently used by developers to build, ship, and maintain their software projects. Important features of GitHub that you can use for solutions include:

  - [GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) enables your enterprise to host a rich [HTML-based website](https://pages.github.com/) directly from within a [GitHub repository](https://docs.github.com/repositories).

  - [GitHub Discussions](https://docs.github.com/discussions) and [GitHub Issues](https://docs.github.com/issues) help you to activate community collaboration.

- [Azure App Service](https://azure.microsoft.com/services/app-service/): Azure App Service is a fully managed compute platform for hosting custom web applications.

- [Azure Active Directory B2C (Azure AD B2C)](https://azure.microsoft.com/services/active-directory/external-identities/b2c/): Azure AD B2C is an extension of Azure Active Directory (Azure AD) that your application can use to manage external customer or partner identities for access and authorization. You can make use of the [Microsoft Identify Platform](/azure/active-directory/develop/v2-overview) to easily integrate identity and authorization in your custom applications.


## API value chain

:::image type="content" alt-text="Diagram that describes the API value chain." source="media/design-api-developer-experiences-management-github-value-chain.png":::

At the top of the value chain is the API service provider. Next are the API consumers or integrators, who design and build the amazing experiences for the eventual target consumers. End users and customers are the final beneficiaries in the value chain.


## API developer experience

:::image type="content" alt-text="Diagram of features and capabilities of the enhanced API developer experience." source="media/design-api-developer-experiences-management-github-basic-features.png" lightbox="media/design-api-developer-experiences-management-github-basic-features.png":::

_Download a [PowerPoint file](https://arch-center.azureedge.net/design-api-developer-experiences-management-github.pptx) of this diagram._

The API developer experience that must be part of the end-to-end solution consists of the following applications:

- **Consumer portal**. The consumer portal serves as a marketing website that showcases the various API products that are offered by the enterprise.

- **Developer portal**. The developer portal provides third-party developers with documentation about the various API services and how to use them in their applications.

- **Account portal**. Registered users manage their subscriptions and perform other account-related activities by using the account portal.


## Functional requirements

At a high level, the overall functional requirements for an enterprise-scale API platform can be broadly classified into three buckets, namely _productization_, _platform administration_, and _consumer experiences_.

:::image type="content" alt-text="Diagram that shows three broad functional requirements of an enterprise-scale API platform." source="media/design-api-developer-experiences-management-github-functional-requirements.png":::

The following sections further describe the capabilities within each feature area.

### Productization

The goal of productization is to identify and define the monetized APIs, their management, and strategy for selling them as digital products. Hence, it covers:

- Capabilities, such as identifying variants of the products, and their corresponding mapping to physical assets
- Definition of the pricing and rate plans, along with the necessary metadata
- Content that must be created for driving the consumer experience

Productization comprises the following capabilities:

- **API products**. This catalog of APIs is made available to the consumers. A product may be offered for purchase or as a free service.

- **Variants**. The developer experience should identify the variants of any API product that's monetized.

- **Pricing plans**. Define the various pricing plans to make it attractive for the consumers.

- **Taxonomy and content**. Define and create the content (textual, PDFs, images, and so on) that is required for the marketing strategy for these API products.

- **Physical Assets**. This comprises the actual cloud services that are part of the specific API product and their corresponding lifecycle management. The operations cost of maintaining these services must be considered while deriving the pricing plans.

### Platform administration

Platform administration focuses on the overall hosting, management, and governance of the API platform. It also provides an end-to-end solution for administration of the various line-of-business applications and services. Major areas of focus are subscription management, billing, and invoicing. Platform administration also provides generation of business insights & analytics to present the overall health of the service, including its financial and operational aspects.

Platform administration comprises the following capabilities:

- **User Registration**. Identify how users register with the platform. Define any approval workflows that are necessary, depending on the user segment.

- **API Catalog**. Identify the API assets that will be published through API Management. Apply policies to control access and use of the APIs. Manage the subscriptions of the users.

- **Insights and Analytics**. Capture telemetry data to generate the various metrics. Visualize the data by using different dashboards (for example, Power BI) to derive the various insights that are required for business and IT decision makers.

- **Billing and Invoicing**. Define the workflows that are related to subscriptions, order management, billing, and invoicing.

- **Support**. Establish tools and processes to handle support requests.

### Consumer experience

The adoption of the API platform is heavily dependent on how easily consumers can:

- Discover the APIs that they need.
- Review the specification and technical content (by browsing through the developer portal).
- Register to subscribe. 
- Pay for the API products that they selected. 
- Start using the APIs in their applications.

A consumer experience is typically delivered through a web portal, a mobile app, or both. You can use [Azure AD B2C](/azure/active-directory-b2c/) to facilitate user registration and identity management. Azure AD B2C includes support for OpenID identity providers, such as Microsoft and Google.

Consumer experiences comprise the following capabilities:

- **Product (API) catalog**. Create the marketplace experience for the users, both anonymous and registered.

- **Account & subscription management**. Establish the procedures for registering and signing in based on the types of users. Support user preferences, such as use of existing social identity providers. Allow for self-service subscription management, activation and deactivation services, and to pay charges as invoiced.

- **User interface (UI) / User experience (UX)**. Identify and define the experiences for the channels that are supported for end-user experiences. Include multi-device, multi-form-factor capabilities, along with modern UI design. Enrich the experience through usability studies.


## Pricing

The consumer portal can be developed by using the _Team_ or _Enterprise_ [pricing plan for GitHub](https://github.com/pricing). You can refer to the feature matrix to identify which plan best suits your enterprise.

For API Management, you can use the _Standard_ or the _Premium_ tiers. Explore the [API Management pricing options](https://azure.microsoft.com/pricing/details/api-management/) to better understand the differences between the tiers.

For Azure App Service, refer to the pricing options that are available for [Windows](https://azure.microsoft.com/pricing/details/app-service/windows/) and [Linux](https://azure.microsoft.com/pricing/details/app-service/linux/) environments for hosting your applications.

## Next steps

For more information on this, see the following additional resources:

- [Monetization with Azure API Management](/azure/api-management/monetization-overview)
- [Overview of the developer portal](/azure/api-management/api-management-howto-developer-portal) in Azure API Management
- [Self-host the API Management developer portal](/azure/api-management/developer-portal-self-host)
- [API-first SaaS business model](/azure/architecture/solution-ideas/articles/aks-api-first)
- [Getting started with GitHub Pages](https://docs.github.com/pages/getting-started-with-github-pages)

## Related resources

For additional information, see the following related resources for additional information:

- [Protect APIs with Azure Application Gateway and Azure API Management](/azure/architecture/reference-architectures/apis/protect-apis)
- [Highly available multi-region web app - Azure Architecture Center](/azure/architecture/reference-architectures/app-service-web-app/multi-region)
- [Self-hosted gateway](/azure/api-management/self-hosted-gateway-overview)
- [Basic enterprise integration on Azure](/azure/architecture/reference-architectures/enterprise-integration/basic-enterprise-integration)
