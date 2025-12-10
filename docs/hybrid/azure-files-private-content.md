This reference architecture illustrates an enterprise-level cloud file sharing solution that uses Azure services including [Azure Files](https://azure.microsoft.com/services/storage/files/), [Azure File Sync](https://azure.microsoft.com/updates/azure-file-sync), [Azure Private DNS](/azure/dns/private-dns-overview), and [Azure Private Endpoint](/azure/private-link/private-endpoint-overview). The solution generates cost savings by outsourcing the management of file servers and infrastructure while retaining control of the data.

## Architecture

The following diagram shows how clients can access Azure file shares:

- Locally through a cloud tiering file server.
- Remotely over [ExpressRoute](https://azure.microsoft.com/services/expressroute/) private peering or VPN tunnels in a private network environment.

[![Enterprise-level cloud file share diagram that shows how clients can access Azure file shares locally through a cloud tiering file server or remotely over ExpressRoute private peering or VPN tunnel in a private network environment.](./images/azure-files-private.svg)](./images/azure-files-private.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/azure-files-private.vsdx) of this architecture.*

### Workflow

The enterprise-level cloud file sharing solution uses the following methods to provide the same user experience as traditional file sharing but with Azure file shares:

- Makes use of Azure File Sync to synchronize file and folder Access Control Lists (ACL) between on-premises file servers and Azure file shares.
- Uses the cloud tiering feature from the Azure File Sync agent to cache frequently accessed files locally.
- Enforces AD DS authentication over Azure file shares.
- Accesses file share and file sync services via private IP through Azure Private Link and Private Endpoint over an ExpressRoute private peering or VPN tunnel.

By implementing Azure Private Endpoint on Azure Files and Azure File Sync, public endpoint access is disabled so that access to Azure Files and Azure File Sync is restricted from the Azure virtual network.

The ExpressRoute private peering VPN site-to-site tunnel extends the on-premises network to the Azure virtual network. Azure File Sync and Server Message Block (SMB) traffic from on-premises to Azure Files and Azure File Sync private endpoints is restricted to private connection only. During transition, Azure Files will only allow the connection if it's made with SMB 3.0+. Connections made from the Azure File Sync agent to an Azure File share or Storage Sync Service are always encrypted. At rest, Azure Storage automatically encrypts your data when it's persisted to the cloud, as does Azure Files.

A Domain Name System (DNS) resolver is a critical component of the solution. Each Azure service, in this case Azure Files and Azure File Sync, have a fully qualified domain name (FQDN). The FQDNs of those services are resolved to their public IP addresses in these cases:

- When a client accesses an Azure Files share.
- When an Azure File Sync agent, deployed on an on-premises file server, accesses the Azure File Sync service.

After enabling a private endpoint, private IP addresses are allocated in the Azure virtual network. These addresses allow access to those services over a private connection, and the same FQDNs must now resolve to private IP addresses. To achieve that, Azure Files and Azure File Sync create a canonical name DNS record (CNAME) to redirect the resolution to a private domain name:

- The Azure File Sync's public domain name `*.afs.azure.net` gets a CNAME redirect to the private domain name `*.<region>.privatelink.afs.azure.net`.
- The Azure Files public domain name `<name>.file.core.windows.net` gets a CNAME redirect to the private domain name `<name>.privatelink.file.core.windows.net`.

The solution shown in this architecture correctly configures on-premises DNS settings so that they resolve private domain names to private IP addresses, by using the following methods:

- Private DNS zones (components **11** and **12**) are created from Azure to provide private name resolution for Azure File Sync and Azure Files.
- Private DNS zones are linked to the Azure virtual network so that a DNS server deployed in the virtual network or Azure DNS private resolver(component **8**)  can resolve private domain names.
- DNS A records are created for Azure Files and Azure File Sync in private DNS zones. For the endpoint configuration steps, see [Configuring Azure Files network endpoints](/azure/storage/files/storage-files-networking-endpoints) and [Configuring Azure File Sync network endpoints](/azure/storage/files/storage-sync-files-networking-endpoints).
- The on-premises DNS server (component **3**) sets up conditional forwarding to forward the DNS query of `domain afs.azure.net` and `file.core.windows.net` to the DNS server in the Azure virtual network (component **8**).
- After receiving the forwarded DNS query from the on-premises DNS server, the DNS server (component **8**) in the Azure virtual network uses the Azure DNS recursive resolver to resolve private domain names and return private IP addresses to the client.

### Components

The solution uses the following components:

- A **client** (component **1** or **2**) is typically a Windows, Linux, or macOS desktop that accesses file shares by using the SMB protocol. In this architecture, clients connect to Azure Files either directly over a private network or through a local file server that has Azure File Sync and cloud tiering enabled.

- **Domain controller (DC) and DNS servers** (component **3**) include a DC that handles authentication and a DNS server that resolves names to IP addresses. You can combine DC and DNS servers into a single server or separate them into different servers. In this architecture, they authenticate users and forward DNS queries for Azure Files and Azure File Sync to the DNS infrastructure in Azure.

- A **file server** (component **4**) is an on-premises server that hosts file shares and integrates with Azure File Sync. In this architecture, it enables local caching of frequently accessed files and synchronizes data and ACLs with Azure Files.

- A **customer edge router or VPN device** (component **5**) connects an on-premises network to Azure. In this architecture, it establishes a secure ExpressRoute or VPN tunnel to the Azure virtual network for private access to Azure Files and Azure File Sync.

- **[ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) or [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways)** (component **6**) provides private or encrypted connectivity between on-premises networks and Azure. In this architecture, it ensures secure, reliable communication for file access and synchronization traffic.

- An **Azure private endpoint** (component **7**) is a network interface that connects privately to Azure services via [Private Link](/azure/private-link/private-link-overview). In this solution, an [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) private endpoint connects to Azure File Sync (**9**), and an [Azure Files](/azure/well-architected/service-guides/azure-files) private endpoint connects to Azure Files (**10**). Private endpoints enable secure, private access by mapping FQDNs to private IP addresses.

- A **DNS server or Azure DNS Private Resolver** (component **8**) serves as a DNS service within an [Azure virtual network](/azure/well-architected/service-guides/virtual-network). In this architecture, it uses the [Azure DNS](/azure/dns/dns-overview) recursive resolver to resolve the private domain name and return a private IP address to the client. It does this operation after it receives a forwarded DNS query from an on-premises DNS server.

- **Azure File Sync** (component **9**) is a service that centralizes file shares in Azure, while maintaining the flexibility, performance, and compatibility of an on-premises file server. Cloud tiering is a feature of Azure File Sync in which frequently accessed files are cached locally on the server while all other files are tiered to Azure Files based on policy settings. In this architecture, this feature enables hybrid file sharing by extending on-premises file servers to the cloud.

- **[Azure Files](/azure/well-architected/service-guides/azure-files)** (component **10**) is a managed file share service that supports SMB access and integrates with on-premises AD DS and [Microsoft Entra Domain Services](/entra/identity/domain-services/overview). In this architecture, Azure Files serves as the cloud-based storage layer for enterprise file sharing and can be accessed from both on-premises and cloud environments.

  You can mount file shares from Azure Files concurrently by cloud or on-premises deployments of Windows, Linux, and macOS. And you can cache SMB Azure file shares nearer to where the data is used, on Windows servers that have Azure File Sync for fast access.

- **Azure Private DNS** (components **11** and **12**) is a DNS service that resolves domain names within a virtual network. In this architecture, it provides name resolution for private endpoints of Azure Files and Azure File Sync, which ensures that traffic stays within the private network.

- **[Azure Backup](/azure/backup/backup-overview)** (component **13**) is a cloud-based backup service that protects Azure file shares by using snapshots. In this architecture, it enables data protection and recovery for Azure Files without requiring on-premises backup infrastructure. For more information, see [Data loss and backup](#data-loss-and-backup).

## Scenario details

This solution allows you to access Azure file shares in a hybrid work environment over a virtual private network between on-premises and Azure virtual networks without traversing the internet. It also allows you to control and limit file access through identity-based authentication.

### Potential use cases

The cloud file sharing solution supports the following potential use cases:

- File server or file share lift and shift. By lifting and shifting, you eliminate the need to restructure or reformat data. You also keep legacy applications on-premises while benefiting from cloud storage.
- Accelerate cloud innovation with increased operational efficiency. Reduces the cost to maintain hardware and physical space, protects against data corruption and data loss.
- Private access to Azure file shares. Protects against data exfiltration.

### Traffic flows

After enabling Azure File Sync and Azure Files, Azure file shares can be accessed in two modes, *local cache mode* or *remote mode*. In both modes, the client uses existing AD DS credentials to authenticate itself.

- Local cache mode - The client accesses files and file shares through a local file server with cloud tiering enabled. When a user opens a file from the local file server, file data is either served from the file server local cache, or the Azure File Sync agent seamlessly recalls the file data from Azure Files. In the architecture diagram for this solution, it happens between component **1** and **4**.

- Remote mode - The client accesses files and file shares directly from a remote Azure file share. In the architecture diagram for this solution, the traffic flow travels through components **2**, **5**, **6**, **7** and **10**.

Azure File Sync traffic travels between components **4**, **5**, **6**, and **7**, using an [ExpressRoute circuit](/azure/expressroute/expressroute-circuit-peerings) for a reliable connection.

Private domain name resolution queries go through components **3**, **5**, **6**, **8**, **11** and **12** using the following sequence:

1. The client sends a query to an on-premises DNS server to resolve an Azure Files or Azure File Sync DNS name.
2. The on-premises DNS server has a conditional forwarder that points Azure File and Azure File Sync DNS name resolution to a DNS server in the Azure virtual network.
3. The query is redirected to a DNS Server or Azure private DNS resolver in the Azure virtual network.
4. Depending on the virtual network's DNS configuration:
   - If a custom DNS server is configured, the DNS Server in the Azure virtual network sends a name query to the Azure provided DNS (168.63.129.16) recursive resolver.
   - If the Azure DNS private resolver is configured, and the query matches the private DNS zones that are linked to the virtual network, those zones are consulted.
5. The DNS server/Azure DNS private resolver returns a private IP, after resolving the private domain name to the respective private DNS zone. It uses the Azure virtual network's links to the Azure Files DNS zone and the Azure File Sync private DNS zone.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

Consider the following points when implementing this solution.

### Planning

- For Azure File Sync planning, refer to [Planning for an Azure File Sync deployment](/azure/storage/files/storage-sync-files-planning).
- For Azure Files planning, refer to [Planning for an Azure Files deployment](/azure/storage/files/storage-files-planning).

### Networking

- For Azure File Sync network considerations, refer to [Azure File Sync networking considerations](/azure/storage/files/storage-sync-files-networking-overview).
- For Azure Files networking considerations, refer to [Azure Files networking considerations](/azure/storage/files/storage-files-networking-overview).

### DNS

When managing name resolution for private endpoints, the private domain names of Azure Files and Azure File Sync are resolved in the following way:

From the Azure side:

- If Azure-provided name resolution is used, the Azure virtual network must link to provisioned private DNS zones.
- If "bring your own DNS server" is used, the virtual network where your own DNS server is deployed must link to provisioned private DNS zones.

From the on-premises side, the private domain name is mapped to a private IP address in one of the following ways:

- Through DNS forwarding to a DNS server deployed in the Azure virtual network or Azure private DNS resolver, as the diagram shows.
- Through the on-premises DNS server that sets up zones for the private domain `<region>.privatelink.afs.azure.net` and `privatelink.file.core.windows.net`. The server registers the IP addresses of Azure Files and Azure File Sync private endpoints as DNS A records into their respective DNS zones. The on-premises client resolves the private domain name directly from the local on-premises DNS server.

For more information, see [Private resolver architecture](/azure/dns/private-resolver-architecture).

### Distributed File System (DFS)

When it comes to an on-premises file sharing solution, many administrators choose to use a DFS rather than a traditional standalone file server. DFS allows administrators to consolidate file shares that might exist on multiple servers so that they appear as though they all live in the same location, allowing users to access them from a single point on the network. During migration to a cloud file share solution, Azure File Sync can replace traditional DFS-R. For more information, see [Migrate a DFS Replication (DFS-R) deployment to Azure File Sync](/azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal%2Cproactive-portal#migrate-a-dfs-replication-dfs-r-deployment-to-azure-file-sync).

### Data loss and backup

Data loss is a serious problem for businesses of all sizes. Azure file share backup uses file share snapshots to provide a cloud-based backup solution that protects your data in the cloud and eliminates additional maintenance overhead involved in on-premises backup solutions. The key benefits of Azure file share backup include:

- Zero infrastructure
- Customized retention
- Built-in management capabilities
- Instant restores
- Alerting and reporting
- Protection against accidental deletion of file shares

For more information, see [About Azure file share backup](/azure/backup/azure-file-share-backup-overview)

### Support for hybrid identities on Azure Files

Although this article describes Active Directory for authenticating on Azure Files, it's possible to use Microsoft Entra ID for authenticating hybrid user identities. Azure Files supports identity-based authentication over Server Message Block (SMB), by using the Kerberos authentication protocol through the following methods:

- On-premises Active Directory Domain Services (AD DS)
- Microsoft Entra Domain Services
- Microsoft Entra Kerberos (for hybrid user identities only)
- AD authentication for Linux clients

For more information, see [Enable Microsoft Entra Kerberos authentication for hybrid identities on Azure Files](/azure/storage/files/storage-files-identity-auth-hybrid-identities-enable).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

[Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable [Azure DDOS Protection](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

Security auditing is a necessary requirement for helping to maintain the security of an enterprise. Industry standards require enterprises to follow a strict set of rules related to data security and privacy.

#### File access auditing

File access auditing can be enabled locally and remotely:

- Locally, by using Dynamic Access Control. For more information, see [Plan for File Access Auditing](/windows-server/identity/solution-guides/plan-for-file-access-auditing).
- Remotely, by using Azure Storage logs in Azure Monitor on Azure Files. Azure Storage logs contains StorageRead, StorageWrite, StorageDelete, and Transaction logs. Azure file access can be logged to a storage account, log analytics workspace, or streamed to an event hub separately. For more information, see [Monitor Azure Files](/azure/storage/files/storage-files-monitoring).

### Scalability and performance

Scalability and performance targets for Azure Files and Azure File Sync depend on various factors like SMB client behavior and network bandwidth. For example, the performance of I/O for a file might be affected by your SMB client's behavior and by your available network bandwidth. Testing your usage pattern helps determine if they meet your needs. For more information, see [Scalability and performance targets for Azure Files and Azure File Sync](/azure/storage/files/storage-files-scale-targets).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Yingting Huang](https://www.linkedin.com/in/yingting-huang-9622bb20) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Planning for an Azure Files deployment](/azure/storage/files/storage-files-planning)
- [How to deploy Azure Files](/azure/storage/files/storage-files-deployment-guide)
- [Azure Files networking considerations](/azure/storage/files/storage-files-networking-overview)
- [Configuring Azure Files network endpoints](/azure/storage/files/storage-files-networking-endpoints)
- [Monitor Azure Files](/azure/storage/files/storage-files-monitoring)
- [Plan for File Access Auditing](/windows-server/identity/solution-guides/plan-for-file-access-auditing)
- [Back up Azure file shares](/azure/backup/backup-afs)
- [Overview - on-premises Active Directory Domain Services authentication over SMB for Azure file shares](/azure/storage/files/storage-files-identity-auth-active-directory-enable)
- [Deploy Azure File Sync](/azure/storage/files/storage-sync-files-deployment-guide)
- [Configuring Azure File Sync network endpoints](/azure/storage/files/storage-sync-files-networking-endpoints)
- [Cloud Tiering Overview](/azure/storage/files/storage-sync-cloud-tiering)
- [Create a Site-to-Site connection in the Azure portal](/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal)
- [ExpressRoute circuits and peering](/azure/expressroute/expressroute-circuit-peerings)
- [Create and modify peering for an ExpressRoute circuit](/azure/expressroute/expressroute-howto-routing-portal-resource-manager)
- [About Azure file share backup](/azure/backup/azure-file-share-backup-overview)
- [What is Azure DNS Private Resolver](/azure/dns/dns-private-resolver-overview)
- [Enable Microsoft Entra Kerberos authentication for hybrid identities on Azure Files](/azure/storage/files/storage-files-identity-auth-hybrid-identities-enable)

## Related resources

- [Azure enterprise cloud file share](/azure/architecture/hybrid/azure-files-private)
- [Azure files accessed on-premises and secured by AD DS](/azure/architecture/example-scenario/hybrid/azure-files-on-premises-authentication)
- [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services)
