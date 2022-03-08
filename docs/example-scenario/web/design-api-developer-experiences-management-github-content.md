# Design great API Developer experiences using API Management and GitHub {#design-great-api-developer-experiences-using-api-management-and-github}

An API Developer Experience is the overall experience of a third-party
developer when using a platform or service. The success and adoption of
any API Platform is large dependent on how well it is perceived in the
marketplace. API Services and Products, also known as the Digital Assets
of an Enterprise, are important accelerators of innovation and revenue
thereby boosting the [API
economy](https://docs.microsoft.com/en-us/azure/api-management/monetization-overview)
for the enterprise.

For a digital enterprise, offering API Services, third party API
Developers can have a positive influence in brand promotion resulting in
significant opportunities for revenue generation through increase in
usage and consumption.

## Potential use cases {#potential-use-cases}

-   [Self-hosted
    gateway](https://docs.microsoft.com/en-us/azure/api-management/self-hosted-gateway-overview)

-   [Basic enterprise integration on
    Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/enterprise-integration/basic-enterprise-integration)

## Architecture {#architecture}

## ![Graphical user interface Description automatically generated](media/image1.png){width="5.905511811023622in" height="3.131783683289589in"} {#graphical-user-interface-description-automatically-generated}

The solution primarily comprises of the following building blocks:

-   **Monetized Backend APIs & API Gateway** -- at the core of the
    solution is the set of Backend APIs that will be monetized. The
    consumers (users, applications, devices, etc.) will access the API
    Platform through an API Gateway. The gateway will also apply rate
    leveling and throttle the requests as applicable.

-   **Consumer Portal / Applications** -- The consumers of the API
    Platform will browse the API offerings, register, and then generate
    subscription keys to access the various API End points. They can
    update their account and billing related information using the
    account management features of the solution.

-   **Administrative Portals / Applications** -- Platform administrators
    will publish the list of API Products, their pricing and rate plans.
    These portals will also offer rich analytics on the usage of the
    various API products, assisting in troubleshooting issues or
    offering support services as may be required.

-   **Line of Business Services** -- These are a list of services that
    is required to deliver the functionalities of the consumer portals &
    applications. These are purely required to support the various user
    journeys supported in the solution.

-   **API Consumption Tracking and Charges Calculation Engine** - The
    API consumption reports, captured at the API Gateway layer, will be
    periodically exported to a separate data store. There would be
    separate scheduled jobs, that will run on this data to calculate the
    charges that apply to any consumer account based on its list of
    subscriptions and associated pricing model.

The processing sequence in this solution flows as follows:

1.  API publishers imports the API specification(s) using the Azure
    Portal, groups them using Products and subsequently publishes them.

2.  API Publishers updates the Product related marketing information in
    the corresponding GitHub repository.

3.  API consumers access the marketplace portal, browse through the
    various products and narrow down on a specific API service.

4.  When attempting to view more details about the API service,
    consumers are redirected to the Enhanced Developer Portal hosted in
    GitHub (uses GitHub Pages capability).

5.  Consumers can browse through different API specifications, developer
    related information and even try invoking an endpoint using a sample
    payload.

6.  Consumers register with the platform and then activate a
    subscription for a particular API service they are interested in
    using.

7.  The consumers make use of the API service in their respective Apps
    or devices.

8.  The invocation of the APIs generates consumption related metrics
    which is stored within the Azure usage and consumption tracking
    databases.

9.  The consumption data is periodically exported and saved to a custom
    database (typically a data lake) for further analysis.

10. A backend job then correlates the consumption data against the
    various subscriptions and calculates the charges.

11. The invoice and payment related information is stored within the
    accounting database. This is used for generating revenue for the
    service.

### Components {#components}

The solution is composed of the following Azure and SaaS Services:

-   [API
    Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts):
    Azure API Management is a managed PaaS service that allows
    organizations to publish APIs to both internal and external
    consumers. With APIM, you can publish APIs, that may be hosted
    anywhere. Basically, it allows for decoupling of actual API hosting,
    from the published gateway that acts as the **single-entry point**
    ([**Gateway Routing
    Pattern**](https://docs.microsoft.com/en-us/azure/architecture/patterns/gateway-routing))
    for the full landscape of APIs published by the enterprise. It will
    also provide a governance layer on top of all published APIs. Using
    API Management policies, a variety of additional capabilities such
    as [rate limits and
    quotas](https://docs.microsoft.com/en-us/azure/api-management/api-management-sample-flexible-throttling)
    that can throttle API requests, based on a key or subscription. API
    Management also comes bundled with a [Developer
    Portal](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-developer-portal),
    that provides a fully customizable website to serve as the
    documentation of the APIs published through it.

-   [GitHub](https://docs.github.com/): It is a popular SaaS offering
    from Microsoft that is frequently used by the developer community to
    build, ship, and maintain their software projects. Important
    features of GitHub that can be leveraged for solution:

    -   [GitHub
        Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages)
        enables enterprises to host a rich [HTML based
        website](https://pages.github.com/) directly from within a
        [GitHub repository](https://docs.github.com/en/repositories).

    -   Activate community collaboration through [GitHub
        Discussions](https://docs.github.com/en/discussions) and [GitHub
        Issues](https://docs.github.com/en/issues).

-   [Azure App
    Service](https://docs.microsoft.com/en-us/azure/app-service/overview):
    Azure App Service is a fully managed compute platform for hosting
    custom Web Applications.

-   [Azure AD
    B2C](https://azure.microsoft.com/en-us/services/active-directory/external-identities/b2c/):
    Azure AD B2C (Business to Customer) is an extension of the Azure AD
    and preferably used when the application is required to manage
    External Customer or Partner Identities for access and
    authorization. You can make use of the [Microsoft Identify
    Platform](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-overview)
    to easily integrate identity and authorization in your custom
    applications.

## Recommendations {#recommendations}

This section gives more detailed recommendations on how to commercialize
your API Assets, and why building a rich API Developer experience is
important in the adoption and use of your API Products.

### The API Value Chain {#the-api-value-chain}

![Graphical user interface, text, application, chat or text message
Description automatically
generated](media/image2.png){width="5.133416447944007in"
height="2.2968744531933507in"}

At the top of the value chain is the API Service provider, followed by
the API Consumers or integrators, who design and build the amazing
experiences for the eventual target consumers which act as the final
beneficiary in the value chain.

API Developer experiences is quintessential to the success of this value
chain. It primarily revolves around accomplishing the following
objectives:

-   Easy to discover and understand the API product offerings.

-   Easy to subscribe and integrate with the various applications and
    channels.

-   Easy to get help, troubleshoot problems and remediate issues.

-   Promote community contribution, as well as exchange ideas and
    learnings.

### Functional Requirements {#functional-requirements}

At a high level, the overall functional requirements for an enterprise
scale API Platform can be broadly classified into 3 buckets, namely
Productization, Platform Administration and Consumer experiences.

![Diagram Description automatically
generated](media/image3.png){width="5.114129483814523in"
height="2.385398075240595in"}

The capabilities within each feature area are further expanded in the
following sections.

### Productization {#productization}

The goal of productization is to identify and define the monetized APIs,
their management and selling strategy as digital products. Hence, it
covers capabilities such as identifying variants of the products, and
their corresponding mapping to physical assets, definition of the
pricing and rate plans, along with the necessary metadata, and content
that must be created for driving the consumer experience.

Productization comprises of the following capabilities:

-   **API Products** -- this refers to the catalogue of APIs that will
    be made available to the consumers. The products may be chargeable
    or offered as a free service.

    -   **Variants** -- identify the variants of any API product that
        will be monetized.

    -   **Pricing Plans** - define the various pricing plans to make it
        attractive for the consumers.

    -   **Taxonomy and Content** - define and create the content
        (textual, PDFs, images, and so on) that is required for the
        marketing strategy for these API products.

-   **Physical Assets** -- this comprises of the actual cloud services
    that is part of the specific API product and their corresponding
    lifecycle management. The operations cost of maintaining these
    services must be considered while deriving the pricing plans.

### Platform Administration {#platform-administration}

Platform Administration feature focuses on the overall hosting,
management, and governance of the API platform, along with
administration of the various line of business applications / services
from an end-to-end solution perspective. The major focus areas under
this would be Subscription Management, Billing, and Invoicing, and
generating Business Insights & Analytics to present the overall health
of the service both from a financial, and operational aspects.

Platform Administration comprises of the following capabilities:

-   **User Registration** -- identify how users will register with the
    platform. Define any approval workflows that are necessary depending
    on the user segment.

-   **API Catalogue** -- identify the API assets that will be published
    through API Management. Apply policies to control access and usage
    of the APIs. Manage the subscriptions of the users.

-   **Insights and Analytics** -- capture telemetry data to generate the
    various metrices. Visualize the data using different dashboards
    (e.g., PowerBI) to derive the various insights that is required for
    Business and IT decision makers.

-   **Billing and Invoicing** -- Define the workflows related to
    subscriptions, order management, billing, and invoicing.

-   **Support** -- Establish tools and processes to handle support
    requests.

### Consumer Experiences {#consumer-experiences}

The adoption of the API platform is heavily dependent on the ease with
which consumers can discover the APIs they need, review the
specification and technical content (by browsing through the developer
portal), register to subscribe, and pay for their selected product, and
then start using the API in their applications.

Consumer experience is typically delivered through a web portal and/or a
mobile app. [Azure AD
B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/) can
be used to facilitate user registration and identity management
including support to make use of social OpenID identity providers such
as Microsoft, Google, etc.

Consumer experiences comprises of the following capabilities:

-   **Product (API) Catalogue** -- create the marketplace experience for
    the users (both anonymous and registered).

-   **Account & Subscription Management** -- establish the procedures
    for registration and login based on the type of user. Include
    preferences such to use existing social identify providers. Allow
    for self-service subscription management, activate/deactivate
    services and pay charges as invoiced.

-   **User Interface (UI) / User Experience (UX)** -- Identify and
    define experience for the channels that will be supported for the
    end user experience. Include multi device, multi form factor
    capabilities along with usage of modern UI design. Enrichen the
    experience through usability studies.

#### API Developer Experience {#api-developer-experience}

![Graphical user interface, diagram Description automatically
generated](media/image4.png){width="6.5in"
height="3.3330369641294837in"}

The API developer experience that must be part of the end-to-end
solution, will comprise of the following applications:

-   **A Consumer Portal** -- this will serve as a digital marketing
    website showcasing the various API products that is offered by the
    enterprise.

-   **A Developer Portal** -- this will offer third party developers
    review the documentation about the various API services, and how to
    use them in their applications.

-   **An Account Portal --** this will be used by the registered users
    to manage their subscriptions, along with other account related
    activities.

**Pricing**

The Consumer portal can be developed using the [Team or Enterprise
pricing plan](https://github.com/pricing) for GitHub. You can refer to
the feature matrix to identify what best suits for your enterprise.

For Azure API Management, you can make use of the Standard or the
Premium Tier. Explore the [API Management pricing
options](https://azure.microsoft.com/en-us/pricing/details/api-management/)
to better understand the differences.

For Azure App Service, refer the pricing options available for
[Windows](https://azure.microsoft.com/en-us/pricing/details/app-service/windows/)
or
[Linux](https://azure.microsoft.com/en-us/pricing/details/app-service/linux/)
environments for hosting your applications.

**Next Steps**

For more information on this, please refer the following additional
resources:

-   [Monetization with Azure API
    Management](https://docs.microsoft.com/en-us/azure/api-management/monetization-overview)

-   [Overview of the developer portal in Azure API
    Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-developer-portal)

-   [Self-host the developer portal - Azure API
    Management](https://docs.microsoft.com/en-us/azure/api-management/developer-portal-self-host)

-   [API-first SaaS business
    model](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/aks-api-first)

-   [Getting started with GitHub
    Pages](https://docs.github.com/en/pages/getting-started-with-github-pages)

**Related resources**

Please refer to the following related resources for additional
information:

-   [Protect APIs with Azure Application Gateway and Azure API
    Management](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/apis/protect-apis)

-   [Highly available multi-region web app - Azure Architecture
    Center](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/multi-region)
