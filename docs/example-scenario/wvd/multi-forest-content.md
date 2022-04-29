Many organizations desire to leverage Azure Virtual Desktop (AVD) and create environments with multiple on-premises Active Directory forests. This article expands on the architecture described in the [AVD at enterprise scale article](./windows-virtual-desktop.yml) and helps understand how multiple domains and AVD can be integrated using [Azure AD Connect](/azure/active-directory/hybrid/whatis-hybrid-identity) to sync users from on-premises [Active Directory Domain Services (AD DS)](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) to [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis).

## Architecture
:::image type="content" source="images/wvd-multi-forest-adds.png" alt-text="Azure Virtual Desktop with AD Domain Services" lightbox="images/wvd-multi-forest-adds.png":::

### Dataflow

In this architecture, the identity flow works as follows.

1. Azure AD Connect syncs users from both CompanyA.com and CompanyB.com to Azure AD tenant (NewCompanyAB.onmicrosoft.com).
2. Host pools, workspaces, and app groups are created in the respective subscriptions and spoke virtual networks.
3. Users are assigned to the app groups.
4. AVD session hosts in the host pools join the domains CompanyA.com and CompanyB.com using the domain controllers in Azure.
5. Users sign in using either the [AVD Desktop](/azure/virtual-desktop/connect-windows-7-10#install-the-windows-desktop-client) or a [web client](/azure/virtual-desktop/connect-web) with the corresponding format: user@NewCompanyA.com, user@CompanyB.com, or user@NewCompanyAB.com, depending on the UPN suffix configured.
6. Users are presented with their respective virtual desktops or apps. For example, users in CompanyA will be presented with virtual desktops or apps in Workspace A, host pool 1 or 2.
7. FSLogix user profiles are created in Azure Files shares on the corresponding storage accounts.
8. Group Policy Objects (GPO) synced from on-premises are applied to users and AVD session hosts.

### Components

This architecture uses the same [components](./windows-virtual-desktop.yml#components-you-manage) as listed in [AVD at enterprise scale Architecture](./windows-virtual-desktop.yml).

Additionally, the following components are also used in this architecture:

- **Azure AD connect in staging mode:** [Staging server for Azure AD Connect topologies](/azure/active-directory/hybrid/plan-connect-topologies#staging-server) provides additional redundancy for the Azure AD connect instance.

- **Azure subscriptions, AVD workspaces, and host pools:** Multiple subscriptions, AVD workspaces, and host pools can be leveraged for administration boundaries and business requirements.

## Scenario

This architecture diagram shows a typical scenario that involves the following:

- Azure AD tenant is available for the new company named as `NewCompanyAB.onmicrosoft.com`.
- [Azure AD Connect](/azure/active-directory/hybrid/whatis-hybrid-identity) syncs users from on-premises AD DS to Azure Active Directory (Azure AD).
- Each of the company A and company B has a separate Azure subscription. They also have a [shared services subscription](/azure/cloud-adoption-framework/ready/azure-best-practices/initial-subscriptions#shared-services-subscription) referred to as the *Subscription 1* in the above diagram.
- [An Azure hub-spoke architecture](../../reference-architectures/hybrid-networking/hub-spoke.yml) is implemented with a shared services hub virtual network (VNet).
- Complex hybrid on-premises Active Directory environments are present with two or more AD forests. Domains live in separate forests, each with a different [UPN suffix](/microsoft-365/enterprise/prepare-a-non-routable-domain-for-directory-synchronization?view=o365-worldwide#add-upn-suffixes-and-update-your-users-to-them). For example, *companyA.local* with the UPN suffix companyA.com, *companyB.local* with the UPN suffix CompanyB.com, and an additional UPN suffix *newcompanyAB.com*.
- Domain controllers for both forests are located on-premises and in Azure.
- Verified domains are present in Azure for CompanyA.com, CompanyB.com, and NewCompanyAB.com.
- Group Policy (GPO) and legacy authentication such as [Kerberos](/windows-server/security/kerberos/kerberos-authentication-overview), [NTLM](/windows-server/security/kerberos/ntlm-overview), and [LDAP](https://social.technet.microsoft.com/wiki/contents/articles/2980.ldap-over-ssl-ldaps-certificate.aspx) are used.
- Azure environments that still have dependency on-premises infrastructure, private connectivity ([Site-to-site VPN or Azure ExpressRoute](../../reference-architectures/hybrid-networking/index.yml)) is set up between on-premises and Azure.
- The [AVD environment](/azure/virtual-desktop/environment-setup) consists of a AVD workspace for each business unit, and two host pools per workspace.
- The AVD session hosts are joined to domain controllers in Azure, that is, companyA session hosts join the companyA.local domain, and CompanyB session hosts join the CompanyB.local domain.
- Azure Storage accounts can leverage [Azure Files for FSLogix profiles](/azure/virtual-desktop/FSLogix-containers-azure-files). One account is created per company domain (that is, companyA.local and companyB.local), and joined to the corresponding domain.

### Potential use cases

The following are some relevant use cases for this architecture:

- Mergers and acquisitions, organization rebranding, and multiple on-premises identities.
- [Complex on-premises active directory environments (multi-forest, multi-domains, group policy (or GPO) requirements, and legacy authentication)](/azure/active-directory-domain-services/concepts-resource-forest).
- Use of on-premises GPO infrastructure with AVD.

> [!NOTE]
  > Active Directory Domain Services (AD DS) is a self-managed, on-premises component in many hybrid environments, whereas Azure Active Directory Domain Services (Azure AD DS) provides managed domain services with a subset of fully-compatible traditional AD DS features such as domain join, group policy, *LDAP*, and *Kerberos*/*NTLM* authentication. Read a detailed comparison of these components in [Compare self-managed Active Directory Domain Services, Azure Active Directory, and managed Azure Active Directory Domain Services](/azure/active-directory-domain-services/compare-identity-solutions). </br>
  > The solution idea [Multiple AVD forests using Azure Active Directory Domain Services](./multi-forest-azure-managed.yml) discusses this architecture using the cloud-managed [Azure AD DS](/azure/active-directory-domain-services/overview).

## Considerations

Keep in mind the following considerations while designing your workload based on this architecture.

### Group Policy Objects (GPO)

- To extend GPO infrastructure for AVD, the on-premises domain controllers should sync to the Azure IaaS domain controllers.
- Extending the GPO infrastructure to Azure IaaS domain controllers requires private connectivity.

### Network and connectivity

- The domain controllers are shared components, so they need to be deployed in a shared services hub VNet in this [hub-spoke architecture](../../reference-architectures/hybrid-networking/hub-spoke.yml).
- AVD session hosts join the domain controller in Azure over their respective hub-spoke vNet peering.

### Azure Storage

The following design considerations apply to user profile containers, cloud cache containers, and [MSIX](/windows/msix/overview) packages:

- Both [Azure Files and Azure NetApp Files](/azure/virtual-desktop/store-FSLogix-profile#azure-platform-details) can be used in this scenario. Choose the right solution based on factors such as expected performance, cost, and so on.
- Both Azure Storage accounts and Azure NetApp Files present the same limitation of being able to join to one single AD DS at a time. In these cases, multiple Azure Storage accounts or Azure NetApp Files instances will be required.

### Azure Active Directory

In scenarios with users in multiple on-premises Active Directory forests, only one Azure AD Connect sync server is connected to the Azure AD tenant. An exception to this is an AD Connect used in staging mode.

![AVD Multiple AD Forests design considerations](images/multiple-forests.png)

The following identity topologies are supported:

- Multiple on-premises Active Directory forests.
- One or more resource forests trust all account forests.
- A full mesh topology allows users and resources to be in any forest. Commonly, there are two-way trusts between the forests.

For more details, read the [Staging server section of Azure AD Connect topologies](/azure/active-directory/hybrid/plan-connect-topologies#staging-server).

## Next steps

For more information, see the following articles:

- [Azure AD Connect topology](/azure/active-directory/hybrid/plan-connect-topologies)
- [Compare different Identity options: Self-managed Active Directory Domain Services (AD DS), Azure Active Directory (Azure AD), and Azure Active Directory Domain Services (Azure AD DS)](/azure/active-directory-domain-services/compare-identity-solutions)
- [Azure Virtual Desktop Documentation](/azure/virtual-desktop)

## Related resources

- [Azure Virtual Desktop for the enterprise article](./windows-virtual-desktop.yml)
- [Solution idea: Multi forest with Azure AD DS](./multi-forest-azure-managed.yml)
