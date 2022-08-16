Many organizations want to take advantage of Azure Virtual Desktop to create environments that have multiple on-premises Active Directory forests. 

This article expands on the architecture that's described in the [Azure Virtual Desktop at enterprise scale](./windows-virtual-desktop.yml) article. It's intended to help you understand how to integrate multiple domains and Azure Virtual Desktop by using [Azure Active Directory (Azure AD) Connect](/azure/active-directory/hybrid/whatis-hybrid-identity) to sync users from on-premises [Active Directory Domain Services (AD DS)](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) to [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis).

## Architecture

:::image type="content" source="images/azure-virtual-desktop-multi-forest-adds.png" alt-text="Diagram that shows Azure Virtual Desktop integration with Active Directory Domain Services." lightbox="images/azure-virtual-desktop-multi-forest-adds.png":::

*[Download a Visio file](https://arch-center.azureedge.net/azure-virtual-desktop-multi-forest-adds.vsdx) of this architecture.*

### Dataflow

In this architecture, the identity flow works as follows: 

1. Azure AD Connect syncs users from both CompanyA.com and CompanyB.com to an Azure AD tenant (NewCompanyAB.onmicrosoft.com).
1. Host pools, workspaces, and app groups are created in each user's own subscription and spoke virtual network.
1. Users are assigned to the app groups.
1. Azure Virtual Desktop session hosts in the host pools join the domains CompanyA.com and CompanyB.com by using the domain controllers in Azure.
1. Users sign in by using either the [Azure Virtual Desktop application](/azure/virtual-desktop/connect-windows-7-10#install-the-windows-desktop-client) or the [web client](/azure/virtual-desktop/connect-web) with a User Principal Name (UPN) in the following format: user@NewCompanyA.com, user@CompanyB.com, or user@NewCompanyAB.com, depending on their configured UPN suffix.
1. Users are presented with their respective virtual desktops or applications. For example, users in CompanyA are presented with a virtual desktop or application in Workspace A, host pool 1 or 2.
1. FSLogix user profiles are created in Azure Files shares on the corresponding storage accounts.
1. Group Policy Objects (GPOs) that are synced from on-premises are applied to users and Azure Virtual Desktop session hosts.

### Components

This architecture uses the same [components](./windows-virtual-desktop.yml#components-that-you-manage) as those listed in [Azure Virtual Desktop at enterprise scale architecture](./windows-virtual-desktop.yml).

Additionally, this architecture uses the following components:

- **Azure AD Connect in staging mode**: The [Staging server for Azure AD Connect topologies](/azure/active-directory/hybrid/plan-connect-topologies#staging-server) provides additional redundancy for the Azure AD Connect instance.

- **Azure subscriptions, Azure Virtual Desktop workspaces, and host pools**: You can use multiple subscriptions, Azure Virtual Desktop workspaces, and host pools for administration boundaries and business requirements.

## Scenario details

This architecture diagram represents a typical scenario that contains the following elements:

- The Azure AD tenant is available for a new company named *NewCompanyAB.onmicrosoft.com*.
- [Azure AD Connect](/azure/active-directory/hybrid/whatis-hybrid-identity) syncs users from on-premises AD DS to Azure Active Directory (Azure AD).
- Company A and Company B have separate Azure subscriptions. They also have a [shared services subscription](/azure/cloud-adoption-framework/ready/azure-best-practices/initial-subscriptions#shared-services-subscription), referred to as the *Subscription 1* in the diagram.
- [An Azure hub-spoke architecture](../../reference-architectures/hybrid-networking/hub-spoke.yml) is implemented with a shared services hub virtual network.
- Complex hybrid on-premises Active Directory environments are present with two or more Active Directory forests. Domains live in separate forests, each with a different [UPN suffix](/microsoft-365/enterprise/prepare-a-non-routable-domain-for-directory-synchronization?view=o365-worldwide#add-upn-suffixes-and-update-your-users-to-them). For example, *CompanyA.local* with the UPN suffix *CompanyA.com*, *CompanyB.local* with the UPN suffix *CompanyB.com*, and an additional UPN suffix, *NewCompanyAB.com*.
- Domain controllers for both forests are located on-premises and in Azure.
- Verified domains are present in Azure for CompanyA.com, CompanyB.com, and NewCompanyAB.com.
- GPO and legacy authentication, such as [Kerberos](/windows-server/security/kerberos/kerberos-authentication-overview), [NTLM (Windows New Technology LAN Manager)](/windows-server/security/kerberos/ntlm-overview), and [LDAP (Lightweight Directory Access Protocol)](https://social.technet.microsoft.com/wiki/contents/articles/2980.ldap-over-ssl-ldaps-certificate.aspx), is used.
- For Azure environments that still have dependency on-premises infrastructure, private connectivity ([Site-to-site VPN or Azure ExpressRoute](../../reference-architectures/hybrid-networking/index.yml)) is set up between on-premises and Azure.
- The [Azure Virtual Desktop environment](/azure/virtual-desktop/environment-setup) consists of an Azure Virtual Desktop workspace for each business unit and two host pools per workspace.
- The Azure Virtual Desktop session hosts are joined to domain controllers in Azure. That is, CompanyA session hosts join the CompanyA.local domain, and CompanyB session hosts join the CompanyB.local domain.
- Azure storage accounts can use [Azure Files for FSLogix profiles](/azure/virtual-desktop/FSLogix-containers-azure-files). One account is created per company domain (that is, CompanyA.local and CompanyB.local), and the account is joined to the corresponding domain.

> [!NOTE]
> Active Directory Domain Services is a self-managed, on-premises component in many hybrid environments, and Azure Active Directory Domain Services (Azure AD DS) provides managed domain services with a subset of fully compatible, traditional AD DS features such as domain join, group policy, LDAP, and Kerberos/NTLM authentication. For a detailed comparison of these components, see [Compare self-managed AD DS, Azure AD, and managed Azure AD DS](/azure/active-directory-domain-services/compare-identity-solutions). </br>
> 
> The solution idea [Multiple Azure Virtual Desktop forests using Azure Active Directory Domain Services](./multi-forest-azure-managed.yml) discusses architecture that uses cloud-managed [Azure AD DS](/azure/active-directory-domain-services/overview).

### Potential use cases

Here are a few relevant use cases for this architecture:

- Mergers and acquisitions, organization rebranding, and multiple on-premises identities
- [Complex on-premises active directory environments (multi-forest, multi-domains, group policy (or GPO) requirements, and legacy authentication)](/azure/active-directory-domain-services/concepts-resource-forest)
- On-premises GPO infrastructure with Azure Virtual Desktop

## Considerations

When you're designing your workload based on this architecture, keep the following ideas in mind.

### Group Policy Objects

- To extend GPO infrastructure for Azure Virtual Desktop, the on-premises domain controllers should sync to the Azure infrastructure as a service (IaaS) domain controllers.

- Extending GPO infrastructure to Azure IaaS domain controllers requires private connectivity.

### Network and connectivity

- The domain controllers are shared components, so they need to be deployed in a shared services hub virtual network in this [hub-spoke architecture](../../reference-architectures/hybrid-networking/hub-spoke.yml).

- Azure Virtual Desktop session hosts join the domain controller in Azure over their respective hub-spoke virtual network peering.

### Azure Storage

The following design considerations apply to user profile containers, cloud cache containers, and [MSIX](/windows/msix/overview) packages:

- You can use both [Azure Files and Azure NetApp Files](/azure/virtual-desktop/store-FSLogix-profile#azure-platform-details) in this scenario. You choose the right solution based on factors such as expected performance, cost, and so on.

- Both Azure storage accounts and Azure NetApp Files are limited to joining to one single AD DS at a time. In these cases, multiple Azure storage accounts or Azure NetApp Files instances are required.

### Azure Active Directory

In scenarios with users in multiple on-premises Active Directory forests, only one Azure AD Connect sync server is connected to the Azure AD tenant. An exception to this is an Azure AD Connect server that's used in staging mode.

![Diagram that shows design variations for multiple Active Directory forests for Azure Virtual Desktop.](images/multiple-forests.png)

The following identity topologies are supported:

- Multiple on-premises Active Directory forests.
- One or more resource forests trust all account forests.
- A full mesh topology allows users and resources to be in any forest. Commonly, there are two-way trusts between the forests.

For more details, see the [Staging server section of Azure AD Connect topologies](/azure/active-directory/hybrid/plan-connect-topologies#staging-server).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Tom Maher](https://www.linkedin.com/in/tommaherlink) | Senior Security and Identity Engineer

## Next steps

For more information, see the following articles:

- [Azure AD Connect topology](/azure/active-directory/hybrid/plan-connect-topologies)
- [Compare different identity options: Self-managed Active Directory Domain Services (AD DS), Azure Active Directory (Azure AD), and Azure Active Directory Domain Services (Azure AD DS)](/azure/active-directory-domain-services/compare-identity-solutions)
- [Azure Virtual Desktop documentation](/azure/virtual-desktop)

## Related resources

- [Azure Virtual Desktop for the enterprise](./windows-virtual-desktop.yml)
- [Solution idea: Multiple forests with Azure AD DS](./multi-forest-azure-managed.yml)
