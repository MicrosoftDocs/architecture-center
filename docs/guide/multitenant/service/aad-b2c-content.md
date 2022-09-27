# Multitenancy and Azure Active Directory B2C

- Quick synopsis of AAD B2C.
- Quick overview of why multitenancy considerations are important for identity

## Isolation Models

- When working with Azure Active Directory B2C, you need to decide how you are going to isolate your user pools from different tenants.
- You need to consider things like:
  - Is the user going to need to access more than one tenant?
  - Do you need complex permissioning and Role Based Access Control (RBAC?)
  - Do you need to federate logins to your customer's Identity Provider(s)? (AAD, Social Logins, etc)
  - Do you have data residency requirements?

*Chart outlining the different Isolation Models*

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

## Securing applications

Probably want to call out the B2C limitation of no web-api chaining here. Documented [here](https://github.com/AzureAD/microsoft-identity-web/wiki/b2c-limitations). 

## Roles & permissions

Talk through pros/cons of the 2 main ways to do RBAC in B2C: App Roles and build-your-own. App roles being more basic and having a limit of (?) app roles per app. Building your own is much more complex  

## DevOps

Discuss here how a well configured DevOps pipeline should be used to manage this. Especially if configuring SSO per client. 

## Contributors

TBD

## Next Steps

TBD