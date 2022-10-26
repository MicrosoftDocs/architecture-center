
[Azure Active Directory B2C]() is a managed Identity Provider capable of performing... (need more info here for a synopsis)

An identity solution for a multitenant application is typically one of the biggest considerations when designing your application. Your identity solution will serve as the gatekeeper to your application, ensuring your tenants stay within the boundaries that you define for them.

If you are brand new to this topic, please review the following recommended resources to assist in building some foundational knowledge required to understand the concept laid out in this document: 

  - [Identity Approaches](../approaches/identity#authorization)
  - [Identity Considerations](../considerations/identity)
  - [Tenancy Models]()

## Isolation Models

- When working with Azure Active Directory B2C, you need to decide how you are going to isolate your user pools from different tenants.
- You need to consider things like:
  - Is the user going to need to access more than one tenant?
  - Do you need complex permissioning and Role Based Access Control (RBAC?)
  - Do you need to federate logins to your customer's Identity Provider(s)? (SAML, AAD, Social Logins, etc)
  - Do you have data residency requirements?
  - What are your user personas? (ie who is logging into your software?)

*Insert Table/Chart outlining the different Isolation Models*

- Shared B2C Tenant
- B2C Tenant per Customer
- Vertically partitioned B2C tenants

### Shared B2C tenant

Discuss here the pros/cons of a shared B2C tenant. Easier to manage, but have a theoretical limit of the number of identity providers you can enable (because of limit of custom policies). 

Also a bit more difficult to do permissions/roles and introduces the need to build a custom roles/permissions system (covered more below). 

### B2C tenant per customer

Discuss here the pros/cons of a B2C tenant per customer. More easily customizable per customer, but much more overhead to think about. Also have a theoretical limit of 200 (need to confirm number) B2C tenants per subscription. Not a great solution if customers must exist in multiple tenants. Another con is that your application must know which tenant to sign the user into. 

### Vertically partitioned B2C tenants

Discuss here the pros/cons of vertically partitioning B2C tenants based on regions, size of customers, or other factors. Application must be aware of which tenant to sign the user into.  


Will probably want to call out federation scenarios here too. 

## Securing applications

Probably want to call out the B2C limitation of no web-api chaining here. Documented [here](https://github.com/AzureAD/microsoft-identity-web/wiki/b2c-limitations). Need to also document the workaround.  

## Roles & permissions

Talk through pros/cons of the 2 main ways to do RBAC in B2C: App Roles and build-your-own. App roles being more basic and having a limit of (?) app roles per app. Building your own is much more complex.  

Link to identity approaches article here. [https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/identity#authorization](https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/identity#authorization)

Could link to Azure SaaS Dev Kit here maybe, as it has one of these built. Could also link to SaaS Starter Web App doc [https://learn.microsoft.com/en-us/azure/architecture/example-scenario/apps/saas-starter-web-app](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/apps/saas-starter-web-app).  

## DevOps

Discuss here how a well configured DevOps pipeline should be used to manage this. Especially if configuring SSO per client. Will want to find or build other samples or resources to link here as well. 

This is one, but we need to validate it as it's a bit old. [https://github.com/azure-ad-b2c/samples/tree/master/policies/devops-pipeline](https://github.com/azure-ad-b2c/samples/tree/master/policies/devops-pipeline)

## Contributors

TBD

## Next Steps

TBD