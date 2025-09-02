This reference architecture implements a secure hybrid network that extends your on-premises network to Azure and uses [Active Directory Federation Services (AD FS)][active-directory-federation-services] to perform federated authentication and authorization for components that run in Azure.

## Architecture

:::image type="complex" border="false" source="./images/active-directory-federation-services.svg" alt-text="Diagram that shows an example of a secure hybrid network architecture with AD FS." lightbox="./images/active-directory-federation-services.svg":::
   The image contains four key sections. The on-premises network section contains contoso.com and a gateway. A dotted line labeled DDoS Protection encloses a section that contains five subsections. The jump box section contains a network security group (NSG). The gateway section connects to the gateway in the on-premises network. The AD FS proxy subnet section contains an NSG, AD FS WAP, and virtual machines (VMs). The AD FS subnet contains an NSG, AD FS servers, and two VMs. The AD DS subnet contains an NSG, AD DS servers, and two VMs. A dotted line points from AD FS subnet to the Federation server section. The Federation server section contains the partner network. An arrow labeled Federated authentication request points from the partner network to the public IP address section.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/identity-architectures.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:


- **Active Directory Domain Services (AD DS) subnet:** The AD DS servers are contained in their own subnet where network security group (NSG) rules serve as a firewall.

- **AD DS servers:** Domain controllers that run as virtual machines (VMs) in Azure. These servers provide authentication of local identities within the domain.

- **AD FS subnet:** The AD FS servers are located within their own subnet and use NSG rules as a firewall.

- **AD FS servers:** The AD FS servers provide federated authorization and authentication. In this architecture, they perform the following tasks:

  - Receive security tokens that contain claims made by a partner federation server on behalf of a partner user. AD FS verifies that the tokens are valid before it passes the claims to the web application running in Azure to authorize requests.

    The application that runs in Azure is known as the *relying party*. The partner federation server must issue claims that the web application understands. The partner federation servers are known as *account partners* because they submit access requests on behalf of authenticated accounts in the partner organization. The AD FS servers are known as *resource partners* because they provide access to resources (the web application).

  - Authenticate and authorize incoming requests from external users running a web browser or device that needs access to web applications by using AD DS and the [Active Directory device registration service (DRS)][ADDRS].

  The AD FS servers are configured as a farm accessed through an Azure load balancer. This implementation improves availability and scalability. The AD FS servers aren't exposed directly to the internet. All internet traffic is filtered through AD FS web application proxy (WAP) servers and a demilitarized zone (DMZ), also known as a *perimeter network*.

  For more information, see [AD FS overview][active-directory-federation-services-overview]. 

- **AD FS proxy subnet:** The AD FS proxy servers can be contained within their own subnet and use NSG rules for protection. The servers in this subnet are exposed to the internet through a set of network virtual appliances that provide a firewall between your Azure virtual network and the internet.

- **AD FS WAP servers:** These VMs serve as AD FS servers for incoming requests from partner organizations and external devices. The WAP servers act as a filter that shields the AD FS servers from direct access from the internet. As with the AD FS servers, deploying the WAP servers in a farm with load balancing gives you greater availability and scalability than deploying a collection of standalone servers. For more information, see [Install and configure the WAP server][install-and-configure-the-web-application-proxy-server].

- **Partner organization:** A partner organization runs a web application that requests access to a web application running in Azure. The federation server at the partner organization authenticates requests locally and submits security tokens that contain claims to AD FS running in Azure. AD FS in Azure validates the security tokens. If the tokens are valid, AD FS can pass the claims to the web application running in Azure to authorize them.

  > [!NOTE]
  > You can also configure a VPN tunnel by using an Azure gateway to provide direct access to AD FS for trusted partners. Requests received from these partners don't pass through the WAP servers.

### Components

This architecture extends the implementation described in [Deploy AD DS in an Azure virtual network][extending-ad-to-azure]. It contains the following components:

- **An [AD DS subnet](/entra/identity/domain-services/network-considerations#azure-virtual-network-design)** is an object that maps an IP address range to a site. This mapping allows domain controllers to efficiently direct authentication and replication based on a client's network location.

- **[AD DS servers](/windows-server/identity/ad-ds/plan/ad-ds-design-and-planning)** are domain controllers that host Active Directory Domain Services. They provide centralized authentication, policy enforcement, and directory data replication across enterprise networks.

- **[An AD FS subnet](/windows-server/identity/ad-fs/deployment/how-to-connect-fed-azure-adfs#template-for-deploying-ad-fs-in-azure)** is a defined IP address range within the network or virtual infrastructure that hosts AD FS servers or WAP servers. This IP address range enables secure traffic flow and site-aware authentication.

- **[AD FS servers](/defender-for-identity/active-directory-federation-services)** are internal federation servers that issue security tokens and handle authentication requests by using claims-based identity protocols.

- **[An AD FS proxy subnet](/windows-server/identity/ad-fs/overview/ad-fs-requirements)** is a network segment, typically in a DMZ, that hosts WAP servers. It enables secure relay of external authentication traffic to internal AD FS servers.

- **[AD FS WAP servers](/windows-server/identity/ad-fs/deployment/best-practices-securing-ad-fs)** are reverse proxy servers deployed in perimeter networks that preauthenticate external user requests and securely forward them to AD FS for federated access.

## Scenario details

AD FS can be hosted on-premises, but if your application is a hybrid in which some parts are implemented in Azure, it might be more efficient to replicate AD FS in the cloud.

The previous diagram shows the following scenarios:

- Application code from a partner organization accesses a web application hosted inside your Azure virtual network.

- An external, registered user with credentials stored inside Active Directory Domain Services (AD DS) accesses a web application hosted inside your Azure virtual network.

- A user connected to your virtual network using an authorized device runs a web application hosted inside your Azure virtual network.

This reference architecture focuses on *passive federation*, in which the federation servers decide how and when to authenticate a user. The user provides sign-in information when the application starts. This mechanism is most commonly used by web browsers and involves a protocol that redirects the browser to a site where the user authenticates. AD FS also supports *active federation*, where an application takes on responsibility for supplying credentials without further user interaction, but that scenario is outside the scope of this architecture.

For other considerations, see [Integrate on-premises Active Directory domains with Microsoft Entra ID][considerations].

### Potential use cases

Typical uses for this architecture include:

- Hybrid applications where workloads run partly on-premises and partly in Azure.

- Solutions that use federated authorization to expose web applications to partner organizations.

- Systems that support access from web browsers running outside of the organizational firewall.

- Systems that enable users to access to web applications by connecting from authorized external devices such as remote computers, notebooks, and other mobile devices.

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Networking recommendations

Configure the network interface for each of the VMs hosting AD FS and WAP servers that have static private IP addresses.

Don't give the AD FS VMs public IP addresses. For more information, see the [Security considerations](#security) section.

Set the IP address of the preferred and secondary domain name service (DNS) servers for the network interfaces for each AD FS and WAP VM to reference the AD DS VMs. The AD DS VMs should be running DNS. This step is necessary to enable each VM to join the domain.

### AD FS installation

The article [Deploy a federation server farm][deploy-a-federation-server-farm] provides detailed instructions for how to install and configure AD FS. Perform the following tasks before you configure the first AD FS server in your farm:

1. Obtain a publicly trusted certificate for performing server authentication. The *subject name* must contain the name that clients use to access the federation service. This identifier can be the DNS name registered for the load balancer, such as `adfs.contoso.com`. Avoid using wildcard names such as `*.contoso.com` for security reasons. Use the same certificate on all AD FS server VMs. You can purchase a certificate from a trusted certification authority, but if your organization uses Active Directory Certificate Services, you can create your own.

    The DRS uses the *subject alternative name* to enable access from external devices. This DNS name should follow the format `enterpriseregistration.contoso.com`.

    For more information, see [Obtain and configure a Secure Sockets Layer certificate for AD FS][adfs-certificates].

1. On the domain controller, generate a new root key for the Key Distribution Service (KDS). Set the effective time to the current time minus 10 hours. This configuration reduces the delay that can occur in distributing and synchronizing keys across the domain. This step is necessary to support creation of the group service account that's used to run the AD FS service. The following PowerShell command demonstrates how to generate a new KDS root key with a time offset:

    ```powershell
    Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)
    ```

1. Add each AD FS server VM to the domain.

> [!NOTE]
> To install AD FS, the domain controller that runs the primary domain controller emulator flexible single master operation role for the domain must be running and accessible from the AD FS VMs.

### AD FS trust

Establish federation trust between your AD FS installation and the federation servers of any partner organizations. Configure any required claims filtering and mapping.

- DevOps staff at each partner organization must add a relying party trust for the web applications accessible through your AD FS servers.

- DevOps staff in your organization must configure claims-provider trust to enable your AD FS servers to trust the claims that partner organizations provide.

- DevOps staff in your organization must also configure AD FS to pass claims on to your organization's web applications.

For more information, see [Establish a federation trust][establish-federation-trust].

Publish your organization's web applications and make them available to external partners by using preauthentication through the WAP servers. For more information, see [Publish applications by using AD FS preauthentication][publish-applications-by-using-AD-FS-preauthentication].

AD FS supports token transformation and augmentation. Microsoft Entra ID doesn't provide this feature. By using AD FS, when you set up the trust relationships, you can do the following tasks:

- Configure claim transformations for authorization rules. For example, you can map group security from a representation used by a non-Microsoft partner organization to something that AD DS can authorize in your organization.

- Transform claims from one format to another. For example, you can map from SAML 2.0 to SAML 1.1 if your application only supports SAML 1.1 claims.

### AD FS monitoring

The [Microsoft System Center Management Pack for AD FS 2012 R2][oms-adfs-pack] provides both proactive and reactive monitoring of your AD FS deployment for the federation server. This management pack monitors the following aspects of your AD FS deployment:

- Events that the AD FS service records in its event logs

- The performance data that the AD FS performance counters collect

- The overall health of the AD FS system and web applications (relying parties) and for critical problems and warnings

Another option is to [monitor AD FS by using Microsoft Entra Connect Health](/entra/identity/hybrid/connect/how-to-connect-health-adfs). [Connect Health](/entra/identity/hybrid/connect/whatis-azure-ad-connect) provides monitoring of your on-premises identity infrastructure. It enables you to maintain a reliable connection to Microsoft 365 and Microsoft online services. It achieves this reliability by providing monitoring capabilities for your key identity components. It also makes the key data points about these components accessible.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Create an AD FS farm with a minimum of two servers to increase availability of the service. Use different storage accounts for each AD FS VM in the farm. This approach helps ensure that a failure in a single storage account doesn't make the entire farm inaccessible.

Create separate Azure availability sets for the AD FS and WAP VMs. Ensure that there are a minimum of two VMs in each set. Each availability set must have a minimum of two update domains and two fault domains.

Configure the load balancers for the AD FS VMs and WAP VMs by doing the following steps:

- Use an Azure load balancer to provide external access to the WAP VMs and an internal load balancer to distribute the load across the AD FS servers in the farm.

- Only pass traffic that appears on port 443 (HTTPS) to the AD FS or WAP servers.

- Give the load balancer a static IP address.

- Create a health probe by using HTTP against `/adfs/probe`. For more information, see [Create a custom HTTP/HTTPS health probe for Azure Load Balancer](/azure/load-balancer/create-custom-http-health-probe-howto).

  > [!NOTE]
  > AD FS servers use the Server Name Indication protocol, which causes HTTPS endpoint probes from the load balancer to fail.

- Add a DNS *A* record to the domain for the AD FS load balancer. Specify the IP address of the load balancer and give it a name in the domain, such as `adfs.contoso.com`. This DNS record is the name that clients and the WAP servers use to access the AD FS server farm.

You can use either SQL Server or the Windows Internal Database to hold AD FS configuration information. The Windows Internal Database provides basic redundancy. Changes are written directly to only one of the AD FS databases in the AD FS cluster, while the other servers use pull replication to keep their databases up to date. Using SQL Server can provide full database redundancy and high availability by using failover clustering or mirroring.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

AD FS uses HTTPS, so make sure that the NSG rules for the subnet that contain the web tier VMs permit HTTPS requests. These requests can originate from the on-premises network, the subnets that contain the web tier, business tier, data tier, private DMZ, public DMZ, and the subnet that contains the AD FS servers.

Prevent direct exposure of the AD FS servers to the internet. AD FS servers are domain-joined computers that have full authorization to grant security tokens. If a server is compromised, a malicious user can issue full access tokens to all web applications and to all federation servers that are protected by AD FS. If your system must handle requests from guests not connecting from trusted partner sites, use WAP servers to handle these requests. For more information, see [Where to place a federation server proxy][where-to-place-an-fs-proxy].

Place AD FS servers and WAP servers in separate subnets that have their own firewalls. You can use NSG rules to define firewall rules. All firewalls should allow traffic on port 443 (HTTPS).

Restrict direct sign-in access to the AD FS and WAP servers. Only DevOps staff should be able to connect. Don't join the WAP servers to the domain.

Consider using a set of network virtual appliances that log detailed information about traffic traversing the edge of your virtual network for auditing purposes.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

#### Microsoft Entra Domain Services

Consider having Microsoft Entra Domain Services as a shared service that multiple workloads consume to lower costs. For more information, see [Domain Services pricing][microsoft-entra-domain-services-pricing].

<a name='azure-ad-federation-services'></a>

#### AD FS

For information about the editions that Microsoft Entra ID provides, see [Microsoft Entra pricing][Azure-AD-pricing]. The AD FS feature is available in all editions.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

DevOps staff should be prepared to perform the following tasks:

- Manage the federation servers, including managing the AD FS farm, managing trust policy on the federation servers, and managing the certificates that the federation services use

- Manage the WAP servers, including managing the WAP farm and certificates

- Manage web applications including configuring relying parties, authentication methods, and claims mappings

- Back up AD FS components

For other DevOps considerations, see [Deploy AD DS in an Azure virtual network](adds-extend-domain.yml#devops-considerations).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The following considerations, summarized from the article [Plan your AD FS deployment][plan-your-adfs-deployment], give a starting point for sizing AD FS farms:

- If you have fewer than 1,000 users, don't create dedicated servers. Instead, install AD FS on each of the AD DS servers in the cloud. Make sure that you have at least two AD DS servers to maintain availability. Create a single WAP server.

- If you have between 1,000 and 15,000 users, create two dedicated AD FS servers and two dedicated WAP servers.

- If you have between 15,000 and 60,000 users, create between three and five dedicated AD FS servers and at least two dedicated WAP servers.

These considerations assume that you're using dual quad-core VM (Standard D4_v2, or better) sizes in Azure.

If you use the Windows Internal Database to store AD FS configuration data, you're limited to eight AD FS servers in the farm. If you think that you might need more in the future, use SQL Server. For more information, see [The role of the AD FS configuration database][adfs-configuration-database].

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Sarah Parkes](https://www.linkedin.com/in/sarah-p-a06370/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Entra ID documentation](/entra/identity)
- [Azure identity management security overview](/azure/security/fundamentals/identity-management-overview)
- [Azure Firewall](/azure/firewall/overview)

## Related resources

- [Manage identity in multitenant applications](../../multitenant-identity/index.yml)
- [Microsoft Entra identity management and access management for AWS](../aws/aws-azure-ad-security.yml)

<!-- links -->

[extending-ad-to-azure]: ./adds-extend-domain.yml
[Azure-AD-pricing]: https://azure.microsoft.com/pricing/details/active-directory
[where-to-place-an-fs-proxy]: /previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dd807048(v=ws.11)
[microsoft-entra-domain-services-pricing]: https://azure.microsoft.com/pricing/details/microsoft-entra-ds/
[ADDRS]: /previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn486831(v=ws.11)
[plan-your-adfs-deployment]: /previous-versions/azure/azure-services/dn151324(v=azure.100)
[adfs-certificates]: /previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn781428(v=ws.11)
[adfs-configuration-database]: /previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/ee913581(v=ws.11)
[active-directory-federation-services]: /windows-server/identity/active-directory-federation-services
[active-directory-federation-services-overview]: /windows-server/identity/active-directory-federation-services
[establish-federation-trust]: /exchange/manage-a-federation-trust-exchange-2013-help
[deploy-a-federation-server-farm]: /windows-server/identity/ad-fs/deployment/deploying-a-federation-server-farm
[install-and-configure-the-web-application-proxy-server]: /previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn383662(v=ws.11)
[publish-applications-by-using-AD-FS-preauthentication]: /previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn383640(v=ws.11)
[oms-adfs-pack]: https://www.microsoft.com/download/details.aspx?id=54526
[adfs-intro]: /entra/identity/hybrid/whatis-hybrid-identity
[considerations]: ./index.yml
