# Governance - Outline

> [!NOTE]
> VALIDATE THE GOAL: This document should supplant:
> https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-subscription-governance
> Other resources to replace?
>   - https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-subscription-examples
>   - https://blogs.technet.microsoft.com/dsilva/2017/11/10/azure-subscription-governance-resource-group-and-naming-convention-strategies/

## Foundational stage

* x. **Identity** _"Understand digital identity in Azure"_
    - _Explainer: "what is an Azure Active Directory Tenant?"_
        - Azure Active Directory
        - AD tenant
        - Privileged account
            - "Either an Azure account or an enterprise agreement"
            - "A privileged account owner"
        - Active Directory Domain Services
            - Sychronize or federate to Azure AD
    - _How To: "get an Azure Active Directory Tenant"_
    - _Guidance: "Azure AD tenant design guidance"_
        - (TODO: Remove "look-ahead" reference to subscription-explainer.md)
        - Start with a single Azure AD tenant
            - "existing Office 365 subscription or Azure subscription"
            - How To: "get an Azure Active Directory Tenant"
        - Add new users directly to Azure AD 
            - No AD DS synch during foundational stage
    - _How To_ "add new users to Azure Active Directory"
     
* x. **Subscriptions** _"Understand subscriptions in Azure"_
    - _Explainer: "what is an Azure subscription?"_
        - Subscription as container of resources
        - [Subscription service limits](/azure/azure-subscription-service-limits)
        - "manage costs and limit creation of resources"
    - _Guidance: "Azure subscription design"_
        - Start with a single Azure subscription
        - How To: create an Azure subscription
            - via [licensing Azure for the enterprise](https://azure.microsoft.com/pricing/enterprise-agreement)

* x. **Resource management** _"Understand resource management in Azure"_
    > - **Explainer:** [what is Azure Resource Manager?]
    > - **Explainer:** [what is an Azure resource group?]
    > - **Explainer:** [understanding resource access in Azure]
    > - **How to:** [create an Azure resource group using the Azure portal]
    > - **Guidance:** [Azure resource group design guidance]
    > - **Guidance:** [naming conventions for Azure resources]


## Intermediate stage

* x. Identity
    - AD Domain Services
        - Synchronization
        - Federation
    - [SECURITY: Identity management](https://docs.microsoft.com/en-us/azure/security/security-identity-management-overview)
        - Single sign-on
        - Password management
        - Multi-factor auth
        - Security monitoring
        - Privileged account management (**mentioned in foundational stage**)
            - /azure/security/azure-operational-security-best-practices
            - from 2015: https://cloudblogs.microsoft.com/microsoftsecure/2015/07/23/cloud-security-controls-series-azure-ad-privileged-identity-management/
        - ...
        - [SECURITY: Identity management best practices](https://docs.microsoft.com/en-us/azure/security/azure-security-identity-management-best-practices)
* x. Subscriptions 
    - Subscription controls
        - Subscription service limits
            - Default and maximum values
            - Increasing default values via support
                - /azure/azure-supportability/how-to-create-azure-support-request
        - (Mention): Role-based access control
        - (Mention): Azure Policy
        - (Mention): Azure Resource Manager deployment model
    - Administrative accounts
        - Azure AD account is associated to a subscription
            - [ACTIVE DIRECTORY: Understanding Azure resource access - Account Administrator and Service Administrator](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-understanding-resource-access)
            - [ACTIVE DIRECTORY: Associate an Azure subscription to Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-how-subscriptions-associated-directory)
                - "An account that has RBAC Owner access to the subscription"
            - [BILLING: Manage Azure subscription administrators](https://docs.microsoft.com/en-us/azure/billing/billing-add-change-azure-subscription-administrator)
                - **Significant inclusion of "classic" subscription admins**
                - "Service Administrator"
                - "To add someone as an admin for Azure subscription service administration, give them an RBAC Owner role to the subscription"
            - [BILLING: Transfer subscription ownership to another account](https://docs.microsoft.com/en-us/azure/billing/billing-subscription-transfer)
            - /office365/enterprise/subscriptions-licenses-accounts-and-tenants-for-microsoft-cloud-offerings
        - Account Administrator (AA)
            - Billing ownership for subscription
            - Manages subscription details - billing info, offer type, etc.
        - Service Administrator (SA)
            - Manages Azure resources and permissions
            - Initially the same account as the Account Administrator
            - Can be reassigned by the AA
        - Other administrator roles
            - [ACTIVE DIRECTORY: Assigning administrator roles in Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-assign-admin-roles-azure-portal)
                - "global administrator"
                - doesn't mention "Account Administrator"
                - implies multiple "Service Administrators"
        - RELEVANT? (from 2014)  https://blogs.msdn.microsoft.com/edutech/administration/microsoft-azure-how-subscription-administrators-directory-administrators-differ/
            - Classic model focused, but may apply to ARM model?
            - TODO: Contact James Evans
        - EA administrative accounts
    - - Billing and cost management
        - Resources
        - Resource groups
        - [Naming conventions](https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions)
            - **DIFFERENT GUIDANCE:**
                - https://docs.microsoft.com/en-us/azure/virtual-machines/windows/infrastructure-example
                - 
        - Tagging
        - Reporting
        - Azure Billing APIs
            - https://docs.microsoft.com/en-us/azure/billing/billing-usage-rate-card-overview
        - Offer types
            - Different cost structures for different needs (prod, dev/test, etc.)
            - https://azure.microsoft.com/en-us/support/legal/offer-details/
            - https://docs.microsoft.com/en-us/azure/azure/billing/billing-how-to-switch-azure-offer
    - Governance in the enterprise
        - Enterprise agreements & enrollments
            - [LICENSING: Enrollments](https://www.microsoft.com/en-us/Licensing/licensing-programs/enterprise.aspx)
                - "Enterprise Enrollment" vs "Server and Cloud Enrollment"?
            - [AZURE: Licensing Azure for the enterprise](https://azure.microsoft.com/en-us/pricing/enterprise-agreement/)
        - Defining your organizational hierarchy in Azure
            - [RESOURCE MANAGER: Subscription governance](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-subscription-governance)
                - **"Enterprise scaffold"**
                - **"Enterprise enrollment"**
                - Patterns for enterprise enrollment: functional vs. business unit vs. geographic
        - The EA portal
        - Azure Management Groups
            - "enterprise-grade management at a large scale no matter what type of subscriptions you might have"
            - https://docs.microsoft.com/en-us/azure/azure-resource-manager/management-groups-overview
            - https://docs.microsoft.com/en-us/azure/azure-resource-manager/management-groups-create
            - https://docs.microsoft.com/en-us/azure/azure-resource-manager/management-groups-manage
        - Naming standards
        - How to: Onboard your organization to the EA portal
    - Managing access to resources
        - [Role-based access control (RBAC)](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-control-what-is)
        - Resource locks
        - [Azure Policy](https://docs.microsoft.com/en-us/azure/azure-policy/azure-policy-introduction)
            - Geo-compliance & data sovereignty
            - Cost management
            - Default governance through required tags
        - [Auditing](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-audit)
        - Compliance
        - Azure Automation
        - Azure Security Center
    - Using multiple subscriptions
        - Reasons for using multiple subscriptions
            - Nearing or exceeding subscription service maximum limits
            - Separation of subscription responsibilities based on subscription patterns
                - Prod, non-prod, purpose-built, etc.
            - Restrict types of resources in different subscriptions
            - Special need for using different AD tenants
            - Trust issues with subscription/account owners
            - Geographic, geopolitical, or financial considerations
            - Data sovereignty
            - ...
        - How to: create another subscription for your account
    - Patterns for multiple subscriptions
        - **Pros and cons for each pattern**
        - Sandbox pattern
        - Sandbox-and-prodution pattern
        - Sandbox-and-production-with-purpose-built pattern
        - Continuous deployment pattern
        - **Relationship to CI/CD & DevOps**
        - Cost implications
        - Resource access implications

