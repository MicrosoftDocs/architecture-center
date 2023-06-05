[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea illustrates how to deploy Azure Virtual Desktop rapidly in a *minimum viable product* (MVP) or a *proof of concept* (PoC) environment with the use of [Azure Active Directory Domain Services (Azure AD DS)](/azure/active-directory-domain-services/overview). Use this idea to both extend on-premises multi-forest AD DS identities to Azure without private connectivity and support [legacy authentication](/azure/active-directory-domain-services/concepts-resource-forest).

## Potential use cases

This solution idea also applies to mergers and acquisitions, organization rebranding, and multiple on-premises identities requirements.

## Architecture

:::image type="content" source="images/wvd-multi-forest-aadds-edited.svg" alt-text="Diagram of Azure Virtual Desktop with Azure AD Domain Services." lightbox="images/wvd-multi-forest-aadds-edited.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/wvd-multi-forest-aadds.vsdx) of this architecture.*

### Dataflow

The following steps show how the data flows in this architecture in the form of identity.

1. Complex hybrid on-premises Active Directory environments are present, with two or more Active Directory forests. Domains live in separate forests, with distinct User Principal Name (UPN) suffixes. For example, *CompanyA.local* with UPN suffix *CompanyA.com*, *CompanyB.local* with UPN suffix *CompanyB.com*, and an additional UPN suffix, *newcompanyAB.com*.
1. Instead of using customer-managed domain controllers, either on-premises or on Azure (that is, Azure infrastructure as a service [IaaS] domain controllers), the environment uses [the two cloud-managed domain controllers provided by Azure AD DS](/azure/active-directory-domain-services/overview#how-does-azure-ad-ds-work).
1. Azure Active Directory (Azure AD) Connect syncs users from both *CompanyA.com* and *CompanyB.com* to the Azure AD tenant, *newcompanyAB.onmicrosoft.com*. The user account is represented only once in Azure AD, and private connectivity isn't used.
1. Users then sync from Azure AD to the managed Azure AD DS as a one-way sync.
1. A custom and *routable* Azure AD DS domain name, *aadds.newcompanyAB.com*, is created. The newcompanyAB.com domain is a registered domain that supports LDAP certificates. We generally recommend that you *not* use non-routable domain names, such as contoso.local, because it can cause issues with DNS resolution.
1. The Azure Virtual Desktop session hosts join the Azure AD DS domain controllers.
1. Host pools and app groups can be created in a separate subscription and spoke virtual network.
1. Users are assigned to the app groups.
1. Users sign in by using either the [Azure Virtual Desktop application](/azure/virtual-desktop/connect-windows-7-10#install-the-windows-desktop-client) or the [web client](/azure/virtual-desktop/connect-web), with a UPN in a format such as john@companyA.com, jane@companyB.com, or joe@newcompanyAB.com, depending on their configured UPN suffix.
1. Users are presented with their respective virtual desktops or apps. For example, john@companyA.com is presented with virtual desktops or apps in host pool A, jane@companyB is presented with virtual desktops or apps in host pool B, and joe@newcompanyAB is presented with virtual desktops or apps in host pool AB.
1. The storage account (Azure Files is used for FSLogix) is joined to the managed domain AD DS. The FSLogix user profiles are created in Azure Files shares.

> [!NOTE]
> * For Group Policy requirements in Azure AD DS, you can install [Group Policy Management tools](/azure/active-directory-domain-services/manage-group-policy#before-you-begin) on a Windows Server virtual machine that's joined to Azure AD DS.
> * To extend Group Policy infrastructure for Azure Virtual Desktop from the on-premises domain controllers, you need to manually export and import it to Azure AD DS.

### Components

You implement this architecture by using the following technologies:

- [Azure Active Directory](https://azure.microsoft.com/services/active-directory)
- [Azure Active Directory Domain Services](https://azure.microsoft.com/services/active-directory-ds)
- [Azure Files](https://azure.microsoft.com/services/storage/files)
- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop)
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Tom Maher](https://www.linkedin.com/in/tommaherlink) | Senior Security and Identity Engineer

## Next steps

- [Multiple Active Directory forests architecture with Azure Virtual Desktop](./multi-forest.yml)
- [Azure Virtual Desktop for enterprises](./windows-virtual-desktop.yml)
- [Azure AD Connect topologies](/azure/active-directory/hybrid/plan-connect-topologies)
- [Compare different identity options](/azure/active-directory-domain-services/compare-identity-solutions)
- [Azure Virtual Desktop documentation](/azure/virtual-desktop)

## Related resources

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md)
- [Multiple forests with AD DS and Azure AD](multi-forest.yml)
