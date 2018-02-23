---
title: Azure subscriptions in the enterprise
description: Guidance for Azure subscription design in the enterprise, as part of a cloud adoption strategy
author: alexbuckgit
---

# Azure subscriptions in the enterprise

## Overview

Organizations that are beginning to adopt Azure can use a standard [pay-as-you-go](https://azure.microsoft.com/en-in/offers/ms-azr-0003p/) subscription offer with no up-front commitment.  Larger  organizations should consider the purchase of a [Microsoft Enterprise Agreement](https://www.microsoft.com/en-us/Licensing/licensing-programs/enterprise.aspx), which provides the best pricing, discounts, and added benefits designed to support server and cloud technologies. Organizations migrating to Azure can add an (TBD: an Enterprise Enrollment / a Server and Cloud Enrollment) to their EA by making an up-front monetary commitment to Azure. In exchange, you get the best pricing and terms, plus other benefits such as cloud-optimized licensing options and simplified license management. This commitment is met throughout the year by consuming Azure cloud services across its global datacenters.

Once this enrollment is established, customers can access the Azure EA portal to centrally manage Azure subscriptions and associated licensing information. Through the portal, an organization can define an organizational hierarchy to help provide a structured approach to governance, balancing security and compliance with agility.

## Azure Hierarchy

An organization can define its Azure hierarchy to reflect the organization's operating model, providing granular administration and governance of Azure resources by defining a hierarchy of departments, accounts, and subscriptions. The definition of this hierarchy has important implications for billing, reporting, and controlling access to Azure resources.

A typical Azure enterprise hierarchy is shown below.

![An Azure enterprise hierarchy][enterprise-hierarchy]

## Enterprise roles

The Azure EA portal defines four distinct administrative roles:

- **Enterprise administrator:**
- **Department administrator:**
- **Account owner:**
- **Service administrator**

![Enterprise roles][enterprise-roles]

## Portals (TODO)

- Enterprise portal
- Account portal
- Management portal
-  
## Next Steps

For detailed guidance to onboard your organization to Azure via an enterprise enrollment, see [Onboarding to Azure]().

## TBD: Open Questions

- Where are the original source diagrams / PPTs?
- Most EA Portal collateral refers to an "Enterprise Enrollment" rather than a "Server and Cloud Enrollment". Why is this?
- Voice: "an organization" vs "your organization"?

## TBD: Related topics

TODO: Organize these links
- **ADD: Detailed EA guidance**

- [Azure licensing](https://www.microsoft.com/en-us/Licensing/product-licensing/azure.aspx)
- [Microsoft Enterprise Agreements](https://www.microsoft.com/en-us/licensing/licensing-programs/enterprise.aspx)
- [VIDEO: Enterprise Agreement - Server and Cloud Enrollment](https://www.microsoft.com/en-us/videoplayer/embed/eed0fe74-a5a5-4617-8c2c-6bb78e966a52)
- [Subscription governance](/azure/azure-resource-manager/resource-manager-subscription-governance)
- [Azure Onboarding Guide for IT Organizations](https://azure.microsoft.com/mediahandler/files/resourcefiles/d8e7430c-8f62-4bbb-9ca2-f2bc877b48bd/Azure%20Onboarding%20Guide%20for%20IT%20Organizations.pdf) 
- Azure Stack
- [Azure Government Onboarding Guides](https://blogs.msdn.microsoft.com/azuregov/2016/05/18/new-azure-government-onboarding-guides/)
- [Governance in Azure](/azure/security/governance-in-azure#subscription-controls)
- [Azure Enterprise Enrollment - prescriptive subscription governance](/azure/azure-resource-manager/resource-manager-subscription-governance)
- [Onboarding Guide to the Microsoft Azure Enterprise Portal](https://eaportalonboardingvideos.blob.core.windows.net/onboardingvideos/AzureDirectEACustomerOnboardingGuide_En.pdf)


## TBD: Relocate this

![TBD][enterprise-hierarchy-overview]

1. **Enterprise Agreement:** Assign administrative roles for an organization's enterprise enrollment.
2. **Subscriptions:** Once the roles are defined,  design your subscription model.
3. **Resource Groups:** Create resource groups to logically group related resources (for example, by function, geography, or workload).
4. **Naming Standards and Tags:** Categorize Azure resources to assist in security auditing, chargeback, and showback.
5. **Resource Policies & Locks:** Regulate the management of your organization's Azure resources.
6. **Role-based access Control (RBAC):** Assign permissions to allow management of and access to Azure resources.



<!-- links -->
[enterprise-hierarchy]: ../../images/enterprise-hierarchy.png
[enterprise-hierarchy-overview]: ../../images/enterprise-hierarchy-overview.png
[enterprise-roles]: ../../images/enterprise-roles.png
