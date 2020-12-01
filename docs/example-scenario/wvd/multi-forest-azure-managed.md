---
title: Multiple forests with AD DS, Azure AD, and Azure AD DS
titleSuffix: Azure Example Scenarios
description: This is a solution idea that builds on the multiple forests using Windows Virtual Desktop, using Azure Active Directory Domain Services or Azure AD DS.
author: nehalineogi
ms.date: 08/31/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
  - fcp
  - example-scenario
---

# Multiple AD forests with Windows Virtual Desktop and Azure AD DS

This solution idea shows how you can deploy WVD rapidly in a *minimum viable product* (MVP) or a *proof of concept* (PoC) environment with the use of Azure Active Directory Domain Services ([Azure AD DS](/azure/active-directory-domain-services/overview)). Use this idea to extend on-premises multi-forest AD DS identities to Azure without private connectivity and also support [legacy authentication](/azure/active-directory-domain-services/concepts-resource-forest).

This solution idea also applies to mergers and acquisitions, organization rebranding, and multiple on-premises identities requirements.

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

## Architecture

![WVD Multiple AD Forests architecture diagram](images/two-forest-to-azure-no-private-connectivity.png)
*Download a [Visio file][visio-download] of this architecture*

## Data flow

The following steps show how the data flows in this architecture in the form of identity.

1. Complex hybrid on-premises Active Directory environments are present, with two or more AD forests. Domains live in separate forests, with distinct UPN suffixes. For example, *companyA.local* with UPN suffix *companyA.com*, *companyB.local* with UPN suffix *CompanyB.com*, and an additional UPN suffix *newcompanyAB.com*.
1. Instead of using customer-managed domain controllers whether on-premises or on Azure (that is, Azure IaaS domain controllers), [the two cloud-managed domain controllers provided by Azure AD DS](/azure/active-directory-domain-services/overview#how-does-azure-ad-ds-work) are used.
1. Azure AD Connect syncs users from both CompanyA.com and CompanyB.com to the Azure AD tenant (NewCompanyAB.onmicrosoft.com). The user account is represented only once in Azure AD and private connectivity is not used.
1. Users then sync from Azure AD to the managed Azure AD DS as a one-way sync.
1. A custom and *routable* Azure AD DS domain name is created (aadds.newcompanyAB.com). The newcompanyAB.com is a registered domain to support LDAP certificates. It is generally recommended not to use non-routable domain names (such as, contoso.local) as it can cause issues with DNS resolution.
1. The WVD session hosts join the Azure AD DS domain controllers.
1. Host pools and app groups can be created in a separate subscription and spoke virtual network.
1. Users are assigned to the app groups.
1. Users sign in via [WVD Desktop](/azure/virtual-desktop/connect-windows-7-10#install-the-windows-desktop-client) or [web client](/azure/virtual-desktop/connect-web) with a format such as, john@companyA.com, jane@companyB.com, or joe@newcompanyAB.com, depending on the UPN suffix configured.
1. Users are presented with their respective virtual desktops or apps. For example, joe@companyA.com will be presented with virtual desktops or apps in host pool A, jane@companyB will be presented with virtual desktops or apps in host pool B, and joe@newcompanyAB will be presented with virtual desktops or apps in host pool AB.
1. The storage account (Azure Files used for FSLogix) is joined to the managed domain AD DS. The FSLogix user profiles are created in Azure Files shares.

> [!NOTE]
>
> 1. For Group Policy requirements in Azure AD DS, you can [install Group Policy Management tools](/azure/active-directory-domain-services/manage-group-policy#before-you-begin) on a Windows Server virtual machine that is joined to Azure AD DS.
> 2. To extend GPO infrastructure for WVD from the on-premises domain controllers, manual export and import to Azure AD DS is required.  

>

## Next steps

For more information, see these articles:

- [Multiple AD forests architecture with Windows Virtual Desktop](./multi-forest.md).
- [Windows Virtual Desktop for enterprises](./windows-virtual-desktop.md)
- [Azure AD Connect Topology](/azure/active-directory/hybrid/plan-connect-topologies).
- [Compare different Identity options: Self-managed Active Directory Domain Services (AD DS), Azure Active Directory (Azure AD), and Azure Active Directory Domain Services (Azure AD DS)](/azure/active-directory-domain-services/compare-identity-solutions).
- [Windows Virtual Desktop Documentation](/azure/virtual-desktop/).

<!-- links -->
[visio-download]: https://arch-center.azureedge.net/WVD-two-forest-to-Azure-AADDS-No-Private-Connectivity.vsdx
