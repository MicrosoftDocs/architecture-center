---
title: Choose a solution for integrating on-premises Active Directory with Azure.
description: Compares reference architectures for integrating on-premises Active Directory with Azure.
ms.date: 04/06/2017
---

# Choose a solution for integrating on-premises Active Directory with Azure

This article compares options for integrating your on-premises Active Directory (AD) environment with an Azure network. We provide a reference architecture and a deployable solution for each option.

## Integrate your on-premises domains with Azure AD

Use Azure Active Directory (Azure AD) to create a domain in Azure and link it to an on-premises AD domain. 

**Benefits**

* You don't need to maintain an AD infrastructure in the cloud. Azure AD is entirely managed and maintained by Microsoft.
* Azure AD provides the same identity information that is available on-premises.
* Authentication can happen in Azure, reducing the need for external applications and users to contact the on-premises domain.

**Challenges**

* Identity services are limited to users and groups. There is no ability to authenticate service and computer accounts.
* You must configure connectivity with your on-premises domain to keep the Azure AD directory synchronized. 
* Applications may need to be rewritten to enable authentication through Azure AD.

**[Read more...][aad]**

## AD DS in Azure joined to an on-premises forest

Deploy AD Domain Services (AD DS) servers to Azure. Create a domain in Azure and join it to your on-premises AD forest. 

Consider this option if you need to use AD DS features that are not currently implemented by Azure AD. 

**Benefits**

* Provides access to the same identity information that is available on-premises.
* You can authenticate user, service, and computer accounts on-premises and in Azure.
* You don't need to manage a separate AD forest. The domain in Azure can belong to the on-premises forest.
* You can apply group policy defined by on-premises Group Policy Objects to the domain in Azure.

**Challenges**

* You must deploy and manage your own AD DS servers and domain in the cloud.
* There may be some synchronization latency between the domain servers in the cloud and the servers running on-premises.

**[Read more...][ad-ds]**

## AD DS in Azure with a separate forest

Deploy AD Domain Services (AD DS) servers to Azure, but create a separate Active Directory [forest][ad-forest-defn] that is separate from the on-premises forest. This forest is trusted by domains in your on-premises forest.

Typical uses for this architecture include maintaining security separation for objects and identities held in the cloud, and migrating individual domains from on-premises to the cloud.

**Benefits**

* You can implement on-premises identities and separate Azure-only identities.
* You don't need to replicate from the on-premises AD forest to Azure.

**Challenges**

* Authentication within Azure for on-premises identities requires extra network hops to the on-premises AD servers.
* You must deploy your own AD DS servers and forest in the cloud, and establish the appropriate trust relationships between forests.

 **[Read more...][ad-ds-forest]**

## Extend AD FS to Azure

Replicate an Active Directory Federation Services (AD FS) deployment to Azure, to perform federated authentication and authorization for components running in Azure. 

Typical uses for this architecture:

* Authenticate and authorize users from partner organizations.
* Allow users to authenticate from web browsers running outside of the organizational firewall.
* Allow users to connect from authorized external devices such as mobile devices. 

**Benefits**

* You can leverage claims-aware applications.
* Provides the ability to trust external partners for authentication.
* Compatibility with large set of authentication protocols.

**Challenges**

* You must deploy your own AD DS, AD FS, and AD FS Web Application Proxy servers in Azure.
* This architecture can be complex to configure.

**[Read more...][adfs]**

<!-- links -->

[aad]: ./azure-ad.md
[ad-ds]: ./adds-extend-domain.md
[ad-ds-forest]: ./adds-forest.md
[ad-forest-defn]: https://msdn.microsoft.com/library/ms676906.aspx
[adfs]: /adfs.md