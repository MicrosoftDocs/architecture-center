
Azure Active Directory B2C provides business-to-consumer identity as a service. An identity solution for a multitenant application is typically one of the biggest considerations when designing your application. Your identity solution will serve as the gatekeeper to your application, ensuring your tenants stay within the boundaries that you define for them. In this article, we describe different considerations and approaches for using Azure Active Directory B2C in a multitenant solution.

If you are brand new to this topic, please review the following recommended resources to assist in building some foundational knowledge required to understand the concept laid out in this document:

  - [Identity Approaches](../approaches/identity#authorization)
  - [Identity Considerations](../considerations/identity)
  - [Tenancy Models](../considerations/tenancy-models)

> [!NOTE]
> In this article, we will be discussing two very closely named topics: application tenants and Azure Active Directory B2C tenants.
>
> We use the term *application tenant* to refer to **your** tenants, which might be your customers or groups of users.
>
> Azure Active Directory B2C (B2C) also includes the concept of a tenant to refer to individual directories, and it uses the term *multitenancy* to refer to interactions between multiple B2C tenants. Although the terms are the same, the concepts are not. When we refer to an Azure Active Directory B2C tenant in this article, we disambiguate it by using the full term *B2C tenant*.

## Isolation Models

- When working with Azure Active Directory B2C, you need to decide how you are going to isolate your user pools from different application tenants.
- You need to consider things like:
  - Is the user going to need to access more than one application tenant?
  - Do you need complex permissions and/or Role Based Access Control (RBAC?)
  - Do you need to federate logins to your customer's Identity Provider(s)? (SAML, Azure Active Directory, Social Logins, etc)
  - Do you have data residency requirements?
  - What are your user personas? (ie who is logging into your software?)


| Consideration | Shared B2C tenant | B2C tenant per application tenant | Vertically partitioned B2C tenant |
|-|-|-|-|
| **Data isolation** | Low | High | Medium |
| **Deployment complexity** | Low | High | Medium to High, depending on your partition strategy |
| [**Limits to consider**](/azure/active-directory-b2c/service-limits?pivots=b2c-user-flow#userconsumption-related-limits) | Requests per B2C tenant and per IP | Number of B2C tenants per subscription, Maximum number of directories for a single user | N/A  |
| **Operational complexity** | Low | High | Medium to high, depending on your partition strategy |
| **Example scenario** | You do not have any strict data residency requirements | You need to support a high degree of separation between your application tenants| You need to meet data residency requirements or you'd like to enable custom federated identity providers for some or all of your application tenants |


### Shared B2C tenant

Using a single, shared B2C tenant is generally the easiest isolation model to manage if your requirements allow for it. There is only one tenant that you must maintain long term and comes with the lowest amount of overhead. A shared B2C tenant should be considered if the following apply to your scenario:

- You do not have complex data residency or data separation requirements
- You only have local accounts or only have a small number of federated identity providers or social logins you'd like to support (ie you do not need to allow each of your customers to bring a custom identity provider)
- You are okay with your customers using a common login page
- You do not need complex authorization, or are okay with building a custom roles/permissions system **(add link)**
- Your end users need access to more than one application tenant under the same account

Discuss here the pros/cons of a shared B2C tenant. Easier to manage, but have a theoretical limit of the number of identity providers you can enable (because of limit of custom policies). Also need to discuss limits here. https://learn.microsoft.com/en-us/azure/active-directory-b2c/service-limits?pivots=b2c-custom-policy#userconsumption-related-limits 

### B2C tenant per customer

Provisioning a B2C tenant per customer allows for more customization per tenant to be done, but comes at the cost of significantly increased overhead. You must consider how you will plan for and manage this type of deployment and upkeep long term. You will need a strategy to manage things such as policy deployments, key and certificate rotation, and more. Additionally, Azure subscriptions have a default [limit]() of 20 B2C tenants per subscription. If you have more than this, you will also need to consider an appropriate [subscription design pattern]() to allow you to "load balance" your customers onto more than one subscription. Provisioning a B2C tenant per customer should be considered if the following apply to your scenario:

- You have complex data residency or data separation requirements
- You need to allow your customers to bring their own identity provider(s) 
- Your application is or can be "tenant aware" and knows which B2C tenant your users will need to sign into
- Your end users do not need access to more than one application tenant under the same account

Discuss here the pros/cons of a B2C tenant per customer. More easily customizable per customer, but much more overhead to think about. Also have a theoretical limit of 200 (need to confirm number) B2C tenants per subscription. Not a great solution if customers must exist in multiple tenants. Another con is that your application must know which tenant to sign the user into. Also discuss here other limits such as aPI request limits as well as a single user can only belong to 500 tenants.  

### Vertically partitioned B2C tenants

Provisioning vertically partitioned B2C tenants is a "middle ground" between the other tenancy models. It offers greater flexibility in customization between tenants, while offering a decreased level of overhead from provisioning a tenant per customer. To vertically partition your B2C tenants, you will need to figure out how to organize your customers into logical groupings. This grouping can be many different things: region, size, custom requirements, etc. 
Discuss here the pros/cons of vertically partitioning B2C tenants based on regions, size of customers, or other factors. Application must be aware of which tenant to sign the user into.  


Will probably want to call out federation scenarios here too. Call out home realm discovery and maybe b2c white paper here.  

## Data Residency

Upon provisioning your B2C instance, you will be asked to select a region for your instance to be deployed to. This selection is important as this is the region that your customer data will reside in. If you have any specific data residency requirements for a subset of your customers, you should consider separating them into a dedicated tenant for their region. 

## User Journey Configuration

## Roles & permissions

Talk through pros/cons of the 2 main ways to do RBAC in B2C: App Roles and build-your-own. App roles being more basic and having a limit of (?) app roles per app. Building your own is much more complex.  

Link to identity approaches article here. [https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/identity#authorization](https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/identity#authorization)

Could link to Azure SaaS Dev Kit here maybe, as it has one of these built. Could also link to SaaS Starter Web App doc [https://learn.microsoft.com/en-us/azure/architecture/example-scenario/apps/saas-starter-web-app](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/apps/saas-starter-web-app).  

## Maintenance Overhead

Consider talking here about the maintenance overhead of b2c tenants. 

## Securing applications

Probably want to call out the B2C limitation of no web-api chaining here. Documented [here](https://github.com/AzureAD/microsoft-identity-web/wiki/b2c-limitations). Need to also document the workaround.  


## DevOps

Discuss here how a well configured DevOps pipeline should be used to manage this. Especially if configuring SSO per client. Will want to find or build other samples or resources to link here as well. 

This is one, but we need to validate it as it's a bit old. [https://github.com/azure-ad-b2c/samples/tree/master/policies/devops-pipeline](https://github.com/azure-ad-b2c/samples/tree/master/policies/devops-pipeline)

## Contributors

TBD

## Next Steps

TBD