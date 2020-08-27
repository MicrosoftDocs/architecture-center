---
title: Multiple forests with AD DS and AAD
titleSuffix: Azure Example Scenarios
description: This article describes an example workload of creating multiple AD forests with Windows Virtual Desktop.
author: GitHubAlias
ms.date: 08/12/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Multiple AD forests architecture with Windows Virtual Desktop

Many organizations desire to leverage Windows Virtual Desktop (WVD) and create environments with multiple on-premises Active Directory forests. This article expands on the architecture described in the [WVD at enterprise scale article](./windows-virtual-desktop.md) and helps understand how multiple domains and WVD can be integrated in a workload.

The following are some relevant use cases for this architecture:

- Mergers and acquisitions, organization re-branding, and multiple on-premises identities.
- [Complex on-premises active directory environments (multi-forest, multi-domains, GPO requirements and legacy authentication)](https://docs.microsoft.com/azure/active-directory-domain-services/concepts-resource-forest).
- Use of on-premises GPO infrastructure with Azure WVD.

> [!NOTE]
  > For using Azure Active Directory Domain Services (AAD DS) in multiple forests, and for developing a *minimum viable product* (MVP) and a *proof of concept* (POC) for such a use case, refer to the [solution idea for multiple forests with AAD DS](./multi-forest-w-AADDS.md).

## Architecture

![WVD Multiple AD Forests architecture diagram](images/WVD-two-forest-hybrid-Azure.png)

*Download the <a href="images/WVD-two-forest-hybrid-Azure.vsdx" download>Visio</a> diagram of this architecture*

## Scenario

This architecture diagram shows a typical scenario that involves the following:

- Azure AD tenant is available for the new company named as `NewCompanyAB.onmicrosoft.com`.
- [Azure AD Connect](https://docs.microsoft.com/azure/active-directory/hybrid/whatis-hybrid-identity) syncs users from on-premises AAD DS to AAD. (TBD: does this matter here since we are directing to the solution idea?)
- Different Azure subscriptions for company A and company B are available as *Shared Services Subscription*. (TBD: can we point to a link here?)
- [Azure hub-spoke architecture with shared services hub vNet](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) is implemented already. (TBD: is this correct inference?)
- Complex hybrid on-premises Active Directory environments are present with two or more AD (TBD: is AAD? we should be consistent in the abbreviations) forests. Domains live in separate forests. For example, *companyA.local with UPN suffix companyA.com*, *companyB.local with UPN suffix CompanyB.com*, and additional *UPN* suffix newcompanyAB. (TBD: as a newbie, I didn't get this. Should we provide more links or context here?)
- Domain controllers for both forests are located on-premises and in Azure.
- Verified domains are present in Azure for CompanyA.com, CompanyB.com, and NewCompanyAB.com.
- Group Policy (GPO) and legacy authentication such as [Kerberos](https://docs.microsoft.com/windows-server/security/kerberos/kerberos-authentication-overview), [NTLM](https://docs.microsoft.com/windows-server/security/kerberos/ntlm-overview), and [LDAP](https://social.technet.microsoft.com/wiki/contents/articles/2980.ldap-over-ssl-ldaps-certificate.aspx) are used.
- Azure environments that still have dependency on-premises infrastructure, private connectivity ([Site-to-site VPN or Azure ExpressRoute](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/)) is set up between on-premises and Azure.
- The [WVD environment](https://docs.microsoft.com/azure/virtual-desktop/environment-setup) consists of a WVD workspace, Azure subscription for each business unit, and two host pools per workspace.
- The WVD session hosts are joined to domain controllers in Azure, that is, companyA session hosts join the companyA.local domain, and CompanyB session hosts join the CompanyB.local domain.
- Separate Azure Storage accounts leverage [Azure Files for FSLogix profiles](https://docs.microsoft.com/azure/virtual-desktop/FSLogix-containers-azure-files). Azure Files domain joins the corresponding domains for companyA.local and companyB.local. (TBD: I changed from *corresponding domain* to *corresponding domains*, is this correct? Does the AF domain join both the domains?)

## Components

This architectures uses the same [components](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop#components-you-manage) as listed in [WVD at enterprise scale Architecture](./windows-virtual-desktop.md).

Additionally, the following components are also used in this architecture:

- **Azure AD connect in staging mode:** [Staging server for Azure AD Connect topologies](https://docs.microsoft.com/azure/active-directory/hybrid/plan-connect-topologies#staging-server) provides additional redundancy for the Azure AD connect instance.

- **Azure subscriptions, WVD workspaces and host pools:** Multiple subscriptions, WVD workspaces, and host pools can be leveraged for administration boundaries and business requirements.

## Data Flow

In this architecture, the identity flow works as follows.

1. Azure AD Connect syncs users from both CompanyA.com and CompanyB.com to Azure AD tenant (NewCompanyAB.onmicrosoft.com).
2. Host pools and app groups are created in the respective subscriptions and spoke virtual networks.
3. Workspaces and users are assigned to the app groups.
4. WVD session hosts in the host pools join the domains CompanyA.com and CompanyB.com using the domain controllers in Azure.  
5. Users sign in using either the [WVD Desktop](https://docs.microsoft.com/azure/virtual-desktop/connect-windows-7-10#install-the-windows-desktop-client) or a [web client](https://docs.microsoft.com/azure/virtual-desktop/connect-web) with the corresponding format: user@NewCompanyA.com, user@CompanyB.com, or user@NewCompanyAB.com, depending on the UPN suffix configured.
6. Users are presented with their respective virtual desktops or apps. For example, users in CompanyA will be presented with virtual desktops or apps in Workspace A, host pool 1 or 2.
7. FSLogix user profiles are created in Azure Files shares on the corresponding storage accounts.
8. Group Policy Objects (GPO) synced from on-premises are applied to users and WVD session hosts.

## Considerations

Keep in mind the following considerations while designing your workload based on this architecture.

### Group Policy Objects (GPO)

- To extend GPO infrastructure for WVD, the on-premises domain controllers should sync to the Azure IaaS domain controllers.
- Extending the GPO infrastructure to Azure IaaS domain controllers requires private connectivity.

### Network and Connectivity

- The *Landing Zone* (TBD: can we point to a link for this term?) is [Azure hub-spoke architecture with shared services hub vNet](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) for domain controllers. (TBD: I don't understand this statement)
- WVD session hosts join the domain controller in Azure over their respective hub-spoke vNet peering.

### Azure Storage

The following design considerations apply to user profile containers, cloud cache containers, and MSIX packages: (TBD: MSIX??)

- Both [Azure Files and NetApp files](https://docs.microsoft.com/azure/virtual-desktop/store-FSLogix-profile#azure-platform-details) can be used in this scenario. Choose the right solution based on factors such as expected performance, cost, and so on. (TBD: does this make sense?)
- Both Azure Storage accounts and NetApp files present the same limitation of being able to join to one single AD DS at a time. In these cases, multiple Azure Storage accounts or NetApp instances will be required.

### Azure Active Directory

In case of scenarios with users in multiple on-premises Active Directory forests, only one Azure AD Connect sync server connected to the same Azure AD Tenant is supported. An exception to this is an AD Connect used in staging mode. (TBD: restructured, does this make sense?)

![WVD Multiple AD Forests design considerations](images/wvd-multiple-forests.png)

The following identity topologies are supported:

- Multiple on-premises Active Directory forests.  
- One or more resource forest trusts all account forests.
- A full mesh topology allows users and resources to be in any forest. Commonly, there are two-way trusts between the forests.

For more details, read the [Staging server section of Azure AD Connect topologies](https://docs.microsoft.com/azure/active-directory/hybrid/plan-connect-topologies#staging-server).

## Next steps

For more information, refer to these articles:

- [Azure AD Connect topology](https://docs.microsoft.com/azure/active-directory/hybrid/plan-connect-topologies).
- [Compare different Identity options: Self-managed Active Directory Domain Services (AD DS), Azure Active Directory (Azure AD), and Azure Active Directory Domain Services (Azure AD DS)](https://docs.microsoft.com/azure/active-directory-domain-services/compare-identity-solutions).
- [Solution idea Multi forest with AAD DS](./multi-forest-w-AADDS.md).
- [Windows Virtual Desktop Documentation](https://docs.microsoft.com/azure/virtual-desktop/).
