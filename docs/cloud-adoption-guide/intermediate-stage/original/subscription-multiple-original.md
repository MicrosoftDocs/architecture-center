---
title: "Guidance: managing multiple subscriptions"
description: Guidance for managing multiple subscriptions
author: alexbuckgit
---

## Multiple subscriptions

Organizations create multiple Azure subscriptions for a variety of reasons. While each additional Azure subscription does not incur a direct cost, it can increase the complexity of managing your Azure resources. Azure provides a number of capabilities to help larger enterprises and organizations manage deployments across multiple Azure subscriptions. The intermediate adoption stage discusses considerations for managing multiple Azure subscriptions. 

## Managing multiple subscriptions
Many organizations using Azure will have multiple subscriptions for a variety of reasons. While each additional Azure subscription does not incur a direct cost, it can increase the complexity of managing your Azure resources.
Many of your early decisions in architecting and planning your subscription model can affect future decisions and designs as your cloud environment grows. Get participation and input from several groups within your organization, including IT leadership and those responsible for networking, security, and identity within your organization. See the [subscription guidance](#guidance) later in this document for guidance on reasons you may need multiple subscriptions in your Azure environment. 

## Billing
Subscriptions determine how resource usage is reported and billed. Each subscription can be configured separately for billing and payment. Additionally, Azure Resource Manager provides the ability to assign resource tags to provide additional information for granular chargeback and showback scenarios; this can be done based on either a resource group or resource.

## Enterprises and governance
Organizations who have an Enterprise Agreement with Microsoft can manage multiple subscriptions through the Enterprise Portal. Azure enrollment hierarchies define how services are structured within an Enterprise Agreement. The Enterprise Portal allows customers to divide access to Azure resources associated with an Enterprise Agreement based on flexible hierarchies customizable to an organization's unique needs. The hierarchy pattern should match an organization's management and geographic structure so that the associated billing and resource access can be accurately tracked. For more information, see [Enterprise subscription guidance (TO BE ADDED)]().

## Offer types
An Azure offer is the type of Azure subscription you have. Each offer has different terms and some have special benefits. Azure provides a number of different offer types, such as Pay-As-You-Go, Enterprise Agreements, Visual Studio, and Dev/Test offers. You should evaluate the [available offers](https://azure.microsoft.com/en-us/support/legal/offer-details/) based on your organization's needs. If necessary, you can [change your subscription to a different offer][azure-change-subscription-offer].

## Subscriptions and tenants
As stated previously, each Azure subscription is associated with a single Azure Active Directory (AAD) tenant. Most of an organization's subscriptions will use the organization's primary AAD tenant. A few subscriptions may use a different tenant (e.g., development subscriptions with specific testing requirements). These tenants may be federated with the primary AAD tenant. For more information, see [Subscriptions, licenses, accounts, and tenants for Microsoft’s cloud offerings][docs-subscriptions-licenses-accounts-tenants].

## Guidance
1. Review the [subscription design patterns](subscription-design.md) commonly used to support workloads in Azure, and identify the pattern that best supports what you think you'll need for your Azure workload deployments. 
2. Larger organizations that need multiple subscriptions with robust governance and centralized financial control should review the [Enterprise subscription guidance](). To establish an Enterprise Agreement (EA) and an associated Azure enrollment, see [Licensing Azure for the enterprise][azure-licensing].
3. Define your organizational structure in Azure.
a. For larger organizations with an Enterprise Agreement, follow the [Azure Enterprise Portal Onboarding Guide][onboarding-guide] to define your organization's hierarchy of departments, accounts and subscriptions. You should enable EA Dev/Test subscriptions for your organization, to take advantage of lower costs for non-production environments. For more information, see [Enabling and creating EA Dev/Test subscriptions][enable-dev-test]. 
b. For smaller organizations, create an Azure account by creating your first subscription. If you need additional subscriptions for your design, decide for each subscription whether to associate it with your existing Azure account or a new account. **TODO: Add specific details** 
4. Begin creating subscriptions required for your workloads in alignment with your chosen subscription design pattern. Within this pattern, you will still need to decide when to create additional subscriptions to support your needs. Review the [guidance for multiple subscriptions](subscription-multiple.md). For each subscription, change the Service Administrator role to a different user account if the person responsible for managing access to Azure resources in that subscription is different from the person responsible as the billing owner of the subscription. 

<!-- links -->
[azure-get-started]: https://azure.microsoft.com/en-us/get-started/
[azure-offers]: https://azure.microsoft.com/en-us/support/legal/offer-details/
[azure-portal]: https://portal.azure.com
[azure-account-center]: https://account.azure.com/
[docs-manage-access]: /azure/active-directory/manage-access-to-azure-resources
[docs-rbac]: /azure/active-directory/role-based-access-control-what-is
[docs-subscription-limits]: /azure/azure-subscription-service-limits
[docs-subscriptions-licenses-accounts-tenants]: /office365/enterprise/subscriptions-licenses-accounts-and-tenants-for-microsoft-cloud-offerings
[docs-understanding-resource-access]: /azure/active-directory/active-directory-understanding-resource-access
[onboarding-guide]: https://eaportalonboardingvideos.blob.core.windows.net/onboardingvideos/AzureDirectEACustomerOnboardingGuide_En.pdf
[enable-dev-test]: https://channel9.msdn.com/blogs/EA.Azure.com/Enabling-and-Creating-EA-DevTest-Subscriptions-through-the-EA-Portal
[azure-change-subscription-offer]: /azure/billing/billing-how-to-switch-azure-offer
[azure-licensing]: https://azure.microsoft.com/en-us/pricing/enterprise-agreement/
