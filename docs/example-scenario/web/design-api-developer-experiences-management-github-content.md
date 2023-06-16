As the publisher of APIs, you need a website that effectively markets your APIs and helps customers to differentiate between offerings. When they've selected APIs, you need to be able to give access only to authenticated users, manage consumption, and deliver accurate invoices for use. This example scenario shows how you can use Azure service and GitHub to create a platform that does all of this and more.

## Architecture

:::image type="content" alt-text="Diagram of the components of this architecture and the workflow through the internet portals and Azure services that constitute the solution, including Azure A D  B 2 C, Azure A P I Management, the A P I gateway, and line-of-business services." source="media/design-api-developer-experiences-management-github-architecture.png" lightbox="media/design-api-developer-experiences-management-github-architecture.png":::

_Download a [PowerPoint file](https://arch-center.azureedge.net/design-api-developer-experiences-management-github.pptx) of this architecture._

### Dataflow

The solution primarily consists of the following building blocks:

- **Monetized back-end APIs & API gateway**. At the core of the solution is the set of back-end APIs that are monetized. The consumers, such as users, applications, and devices, access the API platform through an API gateway. The gateway throttles requests and applies rate leveling as needed.

- **Consumer portal and applications**. The consumers of the API platform browse the API offerings, register, and then generate subscription keys to access the various API end points. They can update information about their accounts and billing by using the account management features of the solution.

- **Administrative portals and applications**. Platform administrators publish the list of API products, their pricing, and rate plans. These portals also offer rich analytics on the use of the various API products, which help in troubleshooting issues and offering support services.

- **Line-of-business services**. These services are required to deliver the functionalities of the consumer portals and applications and to support the various user journeys that are supported in the solution.

- **API consumption tracking and charges calculation engine**. The API consumption reports, captured at the API gateway layer, are periodically exported to a separate data store. Scheduled jobs run on this data to calculate the charges that apply to any consumer account, based on its list of subscriptions and associated pricing model.

The processing sequence in this solution flows as follows:

1. The API publisher imports the API specifications by using the Azure portal, groups them by product, and publishes them.

1. The API publisher updates the product-related marketing information in the corresponding GitHub repository.

1. The API consumer accesses the marketplace portal, browses the various products, and selects a specific API service.

1. When the consumer attempts to view more information about the API service, the consumer portal redirects the consumer to the enhanced developer portal, which is hosted on GitHub and uses GitHub Pages.

1. The consumer can browse different API specifications, developer-related information, and even try invoking an endpoint by using a sample payload.

1. The consumer registers with the platform and then activates a subscription for the particular API service that they're interested in using.

1. The consumer makes use of the API service in their apps or devices.

1. The invocation of the API generates metrics about its use and consumption, which are stored by Azure in tracking databases.

1. The consumption data is periodically exported and saved to a custom database, typically a data lake, for further analysis.

1. A back-end job calculates charges from the consumption data and the various subscriptions.

1. The invoice and payment-related information is stored within the accounting database. This information is used to calculate the revenue for the service.

### Components

The solution is composed of the following software as a service (SaaS) offerings:

- [Azure API Management](https://azure.microsoft.com/services/api-management) is a managed platform as a service that allows organizations to publish APIs to both internal and external consumers. With API Management, you can publish APIs that may be hosted anywhere. Basically, API Management allows for decoupling of API hosting from the published gateway that acts as the single-entry point for the full landscape of APIs that your enterprise publishes. For more information, see [Gateway Routing pattern](../../patterns/gateway-routing.yml).

  API Management also provides a governance layer on top of all published APIs. By using API Management policies, various other capabilities, such as [rate limits and quotas](/azure/api-management/api-management-sample-flexible-throttling), you can throttle API requests based on a key or subscription. API Management includes a [developer portal](/azure/api-management/api-management-howto-developer-portal) that provides a fully customizable website to serve as the documentation of the APIs that you publish through it.

- [GitHub](https://docs.github.com) is a popular SaaS offering from Microsoft that's frequently used by developers to build, ship, and maintain their software projects. It provides important features that you can use in solutions:

  - [GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) enables your enterprise to host a rich [HTML-based website](https://pages.github.com) directly from within a [GitHub repository](https://docs.github.com/repositories).

  - [GitHub Discussions](https://docs.github.com/discussions) and [GitHub Issues](https://docs.github.com/issues) help you to activate community collaboration.

- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed compute platform for hosting custom web applications.

- [Azure Active Directory B2C (Azure AD B2C)](https://azure.microsoft.com/services/active-directory/external-identities/b2c) is an extension of Azure Active Directory (Azure AD) that your application can use to manage external customer or partner identities for access and authorization. You can make use of the [Microsoft identify platform](/azure/active-directory/develop/v2-overview) to easily integrate identity and authorization in your custom applications.

## Scenario details

The success and adoption of any API platform is largely dependent on how highly it's regarded in the marketplace. Beyond the digital assets offered by the platform, the ease of finding APIs and the ease of using them has a large effect on whether customers use a platform. Customers must be able to find documentation and receive support for issues. The platform should also facilitate community contribution to help your customers shape your APIs to their needs. As the publisher of APIs, you need a website that effectively markets your APIs and helps customers to differentiate between offerings. When they've selected APIs, you need to be able to give access only to authenticated users, manage consumption, and deliver accurate invoices for use. This example scenario shows how you can use Azure service and GitHub to create a platform that does all of this and more.

### Potential use cases

You can use this solution to make it easy for API developers to:

- Discover and understand your API product offerings.
- Subscribe and integrate with your various applications and channels.
- Get help, troubleshoot problems, and remediate issues.
- Promote community contribution and exchange ideas and knowledge.

### API value chain

:::image type="content" alt-text="Diagram that describes the A P I value chain." source="media/design-api-developer-experiences-management-github-value-chain.png":::

At the top of the value chain is the API service provider. Next are the API consumers or integrators, who design and build the experiences for the eventual target consumers. End users and customers are the final beneficiaries in the value chain.

### API developer experience

:::image type="content" alt-text="Diagram of features and capabilities of the enhanced A P I developer experience." source="media/design-api-developer-experiences-management-github-basic-features.png" lightbox="media/design-api-developer-experiences-management-github-basic-features.png":::

_Download a [PowerPoint file](https://arch-center.azureedge.net/design-api-developer-experiences-management-github.pptx) of this diagram._

The API developer experience features three portals:

- **Consumer portal**. The consumer portal serves as a marketing website that showcases the various API products that are offered by the enterprise.

- **Developer portal**. The developer portal provides third-party developers with documentation about the various API services and how to use them in their applications.

- **Account portal**. Registered users manage their subscriptions and perform other account-related activities by using the account portal.

### Functional requirements

At a high level, the functional requirements for an enterprise-scale API platform fit into three categories, namely _productization_, _platform administration_, and _consumer experiences_.

:::image type="content" alt-text="Diagram that shows three broad functional requirements of an enterprise-scale A P I platform." source="media/design-api-developer-experiences-management-github-functional-requirements.png":::

The following sections further describe the capabilities within each feature area.

#### Productization

The goal of productization is to identify and define the monetized APIs, their management, and a strategy for selling them as digital products. As a result, it covers:

- Capabilities, such as identifying variants of the products and their corresponding mapping to physical assets.
- A definition of the pricing and rate plans, along with the necessary metadata.
- Content that must be created for driving the consumer experience.

Productization comprises the following capabilities:

- **API products**. This catalog of APIs is made available to the consumers. A product may be offered for purchase or as a free service.

- **Variants**. The developer experience should identify the variants of any API product that's monetized.

- **Pricing plans**. Define the various pricing plans to make it attractive for the consumers.

- **Taxonomy and content**. Define and create the content—textual, PDFs, images, and so on—that's required for the marketing strategy for these API products.

- **Physical assets**. This comprises the actual cloud services that are part of the specific API product and their corresponding lifecycle management. Consider the operations cost of maintaining these services while deriving the pricing plans.

#### Platform administration

Platform administration focuses on the overall hosting, management, and governance of the API platform. It also provides an end-to-end solution for administration of the various line-of-business applications and services. Major areas of focus are subscription management, billing, and invoicing. Platform administration also provides generation of business insights and analytics to present the overall health of the service, including its financial and operational aspects.

Platform administration comprises the following capabilities:

- **User registration**. Identify how users register with the platform. Define any approval workflows that are necessary, depending on the user segment.

- **API catalog**. Identify the API assets that are published through API Management. Apply policies to control access and use of the APIs. Manage the subscriptions of the users.

- **Insights and analytics**. Capture telemetry data to generate various metrics. Visualize the data by using different dashboards, such as Power BI, to derive the various insights that are required for business and IT decision makers.

- **Billing and invoicing**. Define the workflows that are related to subscriptions, order management, billing, and invoicing.

- **Support**. Establish tools and processes to handle support requests.

#### Consumer experience

The adoption of the API platform is heavily dependent on how easily consumers can:

- Discover the APIs that they need.
- Review the specification and technical content by browsing through the developer portal.
- Register to subscribe.
- Pay for the API products that they selected.
- Start using the APIs in their applications.

A consumer experience is typically delivered through a web portal, a mobile app, or both. You can use [Azure AD B2C](/azure/active-directory-b2c) to facilitate user registration and identity management. Azure AD B2C includes support for OpenID identity providers, such as Microsoft and Google.

Consumer experiences comprise the following components:

- **Product (API) catalog**. Create a marketplace experience for users, both anonymous and registered.

- **Account and subscription management**. Establish procedures for registering and signing in based on the types of users whom you expect to use your API. Support user preferences, such as the use of existing social identity providers. Allow for self-service subscription management, activation and deactivation services, and payment of charges as invoiced.

- **User interface (UI) / User experience (UX)**. Identify and define the experiences for the channels that you support for end-user experiences. Include multi-device, multi-form-factor capabilities, along with modern UI design. Enrich the experience through usability studies.

## Considerations

The components in this scenario address issues of performance, reliability, and security.

API Management supports [autoscaling](/azure/api-management/api-management-howto-autoscale), which quickly expands API Management capabilities in response to growing numbers of incoming requests. API Management also supports zone redundancy and multi-region deployments to provide resiliency and high availability. For more information about zone redundancy, see [Availability zone support for Azure API Management](/azure/api-management/zone-redundancy). For more information about API Management security, see [Azure security baseline for API Management](/security/benchmark/azure/baselines/api-management-security-baseline).

App Service is a fully managed platform as a service that features built-in security and autoscaling with an [SLA](https://azure.microsoft.com//support/legal/sla/app-service/v1_5) that promises high availability. App Service is [ISO, SOC, and PCI compliant](https://www.microsoft.com/trustcenter), and it supports authenticating users with Azure Active Directory, Google, Facebook, Twitter, or Microsoft account. With App Service, you can also [create IP address restrictions](/azure/app-service/app-service-ip-restrictions).

Azure AD B2C offers high availability and scales to supporting hundreds of millions of users. Azure AD B2C supports [OpenID Connect](/azure/active-directory/develop/v2-protocols-oidc) and multiple identity providers so that customers can choose their preferred provider. Azure AD B2C also supports application-based and policy-based multi-factor authentication, adding additional layers of security. For more information about Azure AD B2C, see [What is Azure Active Directory B2C](/azure/active-directory-b2c/overview)? For more information about using external identities, see [External Identities in Azure Active Directory](/azure/active-directory/external-identities/external-identities-overview).

GitHub makes security reviews an automated part of code reviews, scanning every new commit for potential security issues. This service helps you to discover problems as soon as they're offered as additions to the code base. GitHub security allows you to customize searches for security concerns and integrate third-party scanning engines. For more features and details, see [Security](https://github.com/features/security) on GitHub.

### Cost optimization

You can develop the consumer portal by using the _Team_ or _Enterprise_ [pricing plan for GitHub](https://github.com/pricing). Refer to the feature matrix to identify which plan best suits your enterprise.

For API Management, you can use the _Standard_ or the _Premium_ tiers. To better understand the differences between the tiers, see [API Management pricing options](https://azure.microsoft.com/pricing/details/api-management).

For Azure App Service, refer to the pricing options that are available for [Windows](https://azure.microsoft.com/pricing/details/app-service/windows) and [Linux](https://azure.microsoft.com/pricing/details/app-service/linux) environments for hosting your applications.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Subhajit Chatterjee](https://www.linkedin.com/in/subhajit-chatterjee-b9b53b44) | Principal Software Engineer, Industry Clouds

## Next steps

- [Monetization with Azure API Management](/azure/api-management/monetization-overview)
- [Overview of the developer portal](/azure/api-management/api-management-howto-developer-portal) in Azure API Management
- [Self-host the API Management developer portal](/azure/api-management/developer-portal-self-host)
- [Self-hosted gateway](/azure/api-management/self-hosted-gateway-overview)
- [Getting started with GitHub Pages](https://docs.github.com/pages/getting-started-with-github-pages)

## Related resources

- [Protect APIs with Azure Application Gateway and Azure API Management](../../reference-architectures/apis/protect-apis.yml)
- [Baseline zone-redundant web app - Azure Architecture Center](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- [Highly available multi-region web app - Azure Architecture Center](../../web-apps/app-service/architectures/multi-region.yml)
- [Basic enterprise integration on Azure](../../reference-architectures/enterprise-integration/basic-enterprise-integration.yml)
