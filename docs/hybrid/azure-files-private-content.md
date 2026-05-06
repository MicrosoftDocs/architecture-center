This reference architecture describes an enterprise-level cloud file sharing solution that uses Azure services, including [Azure Files](/azure/storage/files/storage-files-introduction), [Azure File Sync](/azure/storage/file-sync/file-sync-introduction), [Azure private DNS](/azure/dns/private-dns-overview), and the [Azure private endpoint](/azure/private-link/private-endpoint-overview) capability in [Azure Private Link](/azure/private-link/private-link-overview). The solution reduces costs by outsourcing file server and infrastructure management while you retain control of the data.

## Architecture

The following diagram shows how clients can access Azure file shares locally through a cloud tiering file server or remotely over Azure ExpressRoute private peering or a VPN tunnel in a private network environment.

:::image type="complex" border="false" source="./images/azure-files-private.svg" alt-text="Diagram that shows how clients can access Azure file shares locally through a cloud tiering file server or remotely over ExpressRoute private peering or a VPN tunnel in a private network environment." lightbox="./images/azure-files-private.svg":::
   The diagram shows an on‑premises section on the left and an Azure section on the right. The on‑premises section contains two clients, a domain controller and Domain Name System (DNS) server, a file server, and a customer edge (CE) device or VPN device. All arrows in this section are bidirectional and dotted. An arrow labeled SMB (file server) connects client-1 and the file server. An arrow labeled DNS query connects client-2 and the domain controller and DNS server. An arrow labeled forwarded DNS query connects the domain controller and DNS server to the CE/VPN device. An arrow labeled DNS query connects the file server and the domain controller and DNS server. An arrow labeled SMB (Azure file share) crosses it diagonally and connects client-1 and the CE/VPN device. An arrow labeled Azure File Sync traffic connects the file server and the CE/VPN device. An arrow labeled ExpressRoute circuit/VPN tunnel that includes SMB, DNS, and Azure File Sync traffic connects the on-premises and Azure sections. The Azure virtual network section includes ExpressRoute/Azure VPN Gateway, a DNS server/Azure DNS Private Resolver, and a private endpoint subnet. A bidirectional dotted arrow labeled SMB, Azure File Sync traffic connects ExpressRoute/VPN Gateway and the private endpoint subnet. A bidirectional dotted arrow labeled forwarded DNS query connects the DNS server/DNS Private Resolver. A line connects Azure File Sync and a private endpoint. Another line connects Azure Files and a private endpoint. An arrow labeled backup points from Azure Files to Azure Backup. A bidirectional dotted arrow labeled DNS connects the DNS server/DNS Private Resolver and Azure File Sync private DNS (region.privatelink.afs.azure.net). Another bidirectional dotted arrow labeled DNS connects the DNS server/DNS Private Resolver and Azure Files private DNS (privatelink.file.core.windows.net).
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-files-private.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram.

The enterprise-level cloud file sharing solution uses the following methods to replicate the traditional file sharing experience by using Azure file shares:

- Uses Azure File Sync to sync file and folder access control lists (ACLs) between on-premises file servers and Azure file shares

- Uses the Azure File Sync agent cloud tiering feature to cache frequently accessed files locally

- Enforces Active Directory Domain Services (AD DS) authentication over Azure file shares

- Accesses file share and file sync services via a private IP address by using Private Link and Azure private endpoints over an ExpressRoute private peering or VPN tunnel

To restrict access to private networks only, configure Azure private endpoints for Azure Files and Azure File Sync and disable or restrict public network access for these services so that clients connect only via Azure virtual network traffic.

The ExpressRoute private peering or VPN site-to-site tunnel extends the on-premises network to the Azure virtual network. Azure File Sync and Server Message Block (SMB) traffic from on-premises to Azure Files and Azure File Sync private endpoints travels over private connections only. During this transition, Azure Files allows only connections that use SMB 3.0 or later. The Azure File Sync agent encrypts every connection to an Azure file share or the Storage Sync Service. Azure Storage and Azure Files encrypt data at rest automatically when it persists to the cloud.

A Domain Name System (DNS) resolver is a critical component of the solution. Each Azure service, including Azure Files and Azure File Sync, has a fully qualified domain name (FQDN). DNS resolves those FQDNs to public IP addresses in these cases:

- A client accesses an Azure Files share.

- An Azure File Sync agent that's deployed on an on-premises file server accesses Azure File Sync.

After you set up a private endpoint, Azure allocates private IP addresses in the Azure virtual network. These addresses provide access to those services over a private connection, and the same FQDNs resolve to private IP addresses. To achieve this private DNS resolution, Azure Files and Azure File Sync create a canonical name (CNAME) DNS record to redirect the resolution to a private domain name:

- The Azure File Sync public domain name `*.afs.azure.net` gets a CNAME redirect to the private domain name `*.<region>.privatelink.afs.azure.net`.

- The Azure Files public domain name `<name>.file.core.windows.net` gets a CNAME redirect to the private domain name `<name>.privatelink.file.core.windows.net`.

The solution in this architecture sets up on-premises DNS settings so that they resolve private domain names to private IP addresses in the following ways:

- Azure creates private DNS zones (components **11** and **12**) to provide private name resolution for Azure File Sync and Azure Files.

- Azure links the private DNS zones to the Azure virtual network so that a DNS server deployed in the virtual network or Azure DNS Private Resolver (component **8**) can resolve private domain names.

- Azure creates DNS `A` records for Azure Files and Azure File Sync in the private DNS zones. For the endpoint configuration steps, see [Configure Azure Files network endpoints](/azure/storage/files/storage-files-networking-endpoints) and [Configure Azure File Sync network endpoints](/azure/storage/file-sync/file-sync-networking-endpoints).

- The on-premises DNS server (component **3**) is configured with conditional forwarders that send DNS queries for `afs.azure.net` and `file.core.windows.net` to the DNS server in the Azure virtual network (component **8**).

- The DNS server in the Azure virtual network (component **8**) receives the forwarded DNS query from the on-premises DNS server, uses the Azure DNS recursive resolver to resolve private domain names, and returns the private IP addresses to the client.

### Components

- A client (component **1** or **2**) is typically a Windows, Linux, or macOS desktop that accesses file shares by using the SMB protocol. In this architecture, clients connect to Azure Files directly over a private network or through a local file server that has Azure File Sync and cloud tiering turned on.

- A domain controller (DC) and DNS server (component **3**) are network services. A DC handles authentication and a DNS server resolves names to IP addresses. You can run both the DC and DNS server on a single server or deploy them on separate servers. In this architecture, they authenticate users and forward DNS queries for Azure Files and Azure File Sync to the DNS infrastructure in Azure.

- A file server (component **4**) is an on-premises server that hosts file shares and integrates with Azure File Sync. In this architecture, it caches frequently accessed files locally and syncs data and ACLs with Azure Files.

- A customer edge router or VPN device (component **5**) connects an on-premises network to Azure. In this architecture, it establishes a secure ExpressRoute connection or VPN tunnel to the Azure virtual network for private access to Azure Files and Azure File Sync.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that creates private, dedicated network connections between on-premises or colocation environments and Azure. [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) (component **6**) is a service that creates encrypted tunnels between an on-premises network and an Azure virtual network. ExpressRoute or VPN Gateway provides private or encrypted connectivity between on-premises networks and Azure. In this architecture, it ensures secure, reliable communication for file access and sync traffic.

- An Azure private endpoint (component **7**) is a network interface that connects privately to Azure services via [Private Link](/azure/private-link/private-link-overview). In this architecture, an [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) private endpoint connects to Azure File Sync (**9**), and an [Azure Files](/azure/well-architected/service-guides/azure-files) private endpoint connects to Azure Files (**10**). Private endpoints support secure, private access by mapping FQDNs to private IP addresses.

- A DNS server or DNS Private Resolver (component **8**) functions as a DNS service within an [Azure virtual network](/azure/well-architected/service-guides/virtual-network). In this architecture, it uses the [Azure DNS](/azure/dns/dns-overview) recursive resolver to resolve the private domain name and return a private IP address to the client. It does this operation after it receives a forwarded DNS query from an on-premises DNS server.

- [Azure File Sync](/azure/storage/file-sync/file-sync-introduction) (component **9**) is a service that centralizes file shares in Azure, while maintaining the flexibility, performance, and compatibility of an on-premises file server. Cloud tiering caches frequently accessed files locally on the server while tiering all other files to Azure Files based on policy settings. In this architecture, this feature extends on-premises file servers to the cloud for hybrid file sharing.

- [Azure Files](/azure/well-architected/service-guides/azure-files) (component **10**) is a managed file share service that supports SMB access and integrates with on-premises AD DS and [Microsoft Entra Domain Services](/entra/identity/domain-services/overview). In this architecture, Azure Files functions as the cloud-based storage layer for enterprise file sharing, and both on-premises and cloud environments can access it.

  You can mount file shares from Azure Files concurrently from Windows, Linux, and macOS deployments in the cloud or on-premises. You can also cache SMB Azure file shares on Windows servers that run Azure File Sync, which places the data closer to where it's accessed.

- Azure private DNS (components **11** and **12**) is a DNS service that resolves domain names within a virtual network. In this architecture, it provides name resolution for private endpoints of Azure Files and Azure File Sync, which keeps traffic within the private network.

- [Azure Backup](/azure/backup/backup-overview) (component **13**) is a cloud-based backup service that protects Azure file shares by using snapshots. In this architecture, it protects and recovers Azure Files data without on-premises backup infrastructure. For more information, see [Data loss and backup](#data-loss-and-backup).

## Scenario details

Use this solution to access Azure file shares in a hybrid work environment over a virtual private network between on-premises and Azure virtual networks without traversing the internet. You can control and limit file access through identity-based authentication.

### Potential use cases

The cloud file sharing solution supports the following potential use cases:

- Lift and shift file servers or file shares to the cloud. This migration eliminates the need to restructure or reformat data. You also keep legacy applications on‑premises while you benefit from cloud storage.

- Accelerate cloud innovation and increase operational efficiency. This approach reduces the cost to maintain hardware and physical space. It also protects against data corruption and data loss.

- Provide private access to Azure file shares. This configuration protects against data exfiltration.

### Traffic flows

After you set up Azure File Sync and Azure Files, the client can access Azure file shares in *local cache mode* or *remote mode*. In both modes, the client uses existing AD DS credentials to authenticate:

- *Local cache mode:* The client accesses files and file shares through a local file server that has cloud tiering turned on. When a user opens a file from the local file server, file data is either served from the file server's local cache or the Azure File Sync agent recalls the file data from Azure Files. In the previous diagram, this process occurs between component **1** and **4**.

- *Remote mode:* The client accesses files and file shares directly from a remote Azure file share. In the previous diagram, the traffic flow travels through components **2**, **5**, **6**, **7**, and **10**.

Azure File Sync traffic travels between components **4**, **5**, **6**, and **7** by using an [ExpressRoute circuit](/azure/expressroute/expressroute-circuit-peerings) for a reliable connection.

Private domain name resolution queries go through components **3**, **5**, **6**, **8**, **11**, and **12** in the following order:

1. The client sends a query to an on-premises DNS server to resolve an Azure Files or Azure File Sync DNS name.

1. The on-premises DNS server has a conditional forwarder that points Azure File and Azure File Sync DNS name resolution to a DNS server in the Azure virtual network.

1. The on-premises DNS server forwards the query to a DNS server or DNS Private Resolver in the Azure virtual network.

1. The name resolution behavior depends on the virtual network's DNS configuration:

   - If a custom DNS server is configured, the DNS server in the Azure virtual network sends a name query to the Azure-provided DNS (`168.63.129.16`) recursive resolver.

   - If DNS Private Resolver is configured and the query matches the private DNS zones that are linked to the virtual network, the resolver uses those private DNS zones to resolve the name.

1. The DNS server or DNS Private Resolver returns a private IP address after it resolves the private domain name to the respective private DNS zone. It uses the Azure virtual network's links to the Azure Files DNS zone and the Azure File Sync private DNS zone.

For more information, see [Azure File Sync networking considerations](/azure/storage/file-sync/file-sync-networking-overview) and [Azure Files networking considerations](/azure/storage/files/storage-files-networking-overview).

### Planning

Use the following resources to plan your Azure File Sync and Azure Files deployments:

- [Plan for an Azure File Sync deployment](/azure/storage/file-sync/file-sync-planning)
- [Plan for an Azure Files deployment](/azure/storage/files/storage-files-planning)

### DNS

When you manage name resolution for private endpoints, Azure Files and Azure File Sync resolve private domain names by using different mechanisms in Azure and on‑premises environments. Azure resolves private domain names by linking the appropriate virtual network to the required private DNS zones:

- If you use Azure-provided name resolution, the Azure virtual network must link to the provisioned private DNS zones.

- If you use your own DNS server, the virtual network where you deploy it must link to provisioned private DNS zones.

On-premises environments resolve private domain names by mapping them to private IP addresses. On-premises DNS servers can forward DNS queries to a DNS server deployed in the Azure virtual network or to DNS Private Resolver, as shown in the previous diagram. They can also use the on-premises DNS server by setting up zones for the private domains `<region>.privatelink.afs.azure.net` and `privatelink.file.core.windows.net` and adding DNS `A` records that map the Azure Files and Azure File Sync private endpoint IP addresses to those zones. The on-premises client then resolves the private domain name directly from the local on-premises DNS server.

For more information, see [Private resolver architecture](/azure/dns/private-resolver-architecture).

### Distributed file system

For an on-premises file sharing solution, admins might choose a distributed file system (DFS) instead of relying on a single standalone file server. Admins can use a DFS to consolidate file shares from multiple servers into a single namespace that users can access from one network location. During migration to a cloud file share solution, Azure File Sync can replace traditional DFS Replication (DFS‑R). For more information, see [Migrate a DFS-R deployment to Azure File Sync](/azure/storage/file-sync/file-sync-deployment-guide#migrate-a-dfs-r-deployment-to-azure-file-sync).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Data loss and backup

Data loss poses a serious risk for businesses of all sizes. Azure file share backup uses file share snapshots to provide a cloud-based backup solution that protects your data in the cloud and reduces maintenance overhead compared to on-premises backup solutions. [Azure file share backup](/azure/backup/azure-file-share-backup-overview) provides these key benefits:

- Zero infrastructure
- Customized retention
- Built-in management capabilities
- Instant restores
- Alerting and reporting
- Protection against accidental deletion of file shares

Azure File Sync provides built-in redundancy by syncing files between on-premises servers and Azure Files. If an on-premises server fails, you can provision a new server, install the Azure File Sync agent, and connect it to the same sync group to restore access. When supported for your chosen storage account type and redundancy tier, configure the Azure Files storage account with geo-redundant storage (GRS) or geo-zone-redundant storage (GZRS) to protect against regional outages. For details about supported redundancy options, see [Planning for an Azure file share deployment](/azure/storage/files/storage-files-planning#redundancy-options).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

You can combine [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) with application-design best practices to enhance distributed denial-of-service (DDoS) mitigation features. Turn on [DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

Enterprises require security auditing to maintain security. Industry standards require enterprises to follow strict rules for data security and privacy.

#### Support for hybrid identities on Azure Files

This article describes how to use Active Directory to authenticate access to Azure Files. But you can also use Microsoft Entra ID to authenticate hybrid user identities. Azure Files supports identity-based authentication over SMB by using the [Kerberos authentication protocol](/azure/storage/files/storage-files-identity-auth-hybrid-identities-enable) through the following methods:

- On-premises AD DS
- Microsoft Entra Domain Services
- Microsoft Entra Kerberos (for hybrid user identities only)
- Active Directory authentication for Linux clients

#### File access auditing

You can set up [file access auditing](/windows-server/identity/solution-guides/plan-for-file-access-auditing) locally by using Dynamic Access Control or remotely by using Azure Storage logs in Azure Monitor on Azure Files. Azure Storage logs capture `StorageRead`, `StorageWrite`, `StorageDelete`, and `Transaction` events. You can log Azure file access to a storage account or a Log Analytics workspace, or stream it to an event hub separately. For more information, see [Monitor Azure Files](/azure/storage/files/storage-files-monitoring).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Azure Files provides premium and standard storage tiers, so you can rightsize your file shares based on performance and cost requirements.

- Azure File Sync cloud tiering reduces on-premises storage costs by keeping only frequently accessed files on the local server.

- Private endpoints add hourly charges and bandwidth premiums through Private Link. Factor these costs into your overall budget. For more information, see [Private Link pricing](https://azure.microsoft.com/pricing/details/private-link).

- ExpressRoute circuits have monthly charges based on bandwidth and pricing model. Use a VPN gateway as a lower-cost alternative when throughput requirements allow it.

To estimate the cost of this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use [Azure Monitor](/azure/azure-monitor/overview) to monitor Azure File Sync health, sync activity, and cloud tiering metrics. Turn on diagnostic settings on the storage account to collect storage metrics and logs.

- Review sync health and cloud tiering status regularly to detect problems early. Azure File Sync provides built-in monitoring through the Storage Sync Service in the Azure portal.

- Use [Backup](/azure/backup/backup-overview) reports and alerting to track backup status and restore operations for Azure file shares.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Scalability and performance targets for Azure Files and Azure File Sync depend on factors like SMB client behavior and network bandwidth. For example, your SMB client's behavior and available network bandwidth can affect the input and output (I/O) performance of a file. Test your usage pattern to determine whether those targets meet your needs. For more information, see [Scalability and performance targets for Azure Files and Azure File Sync](/azure/storage/files/storage-files-scale-targets).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Yingting Huang](https://www.linkedin.com/in/yingting-huang-9622bb20) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Plan for an Azure Files deployment](/azure/storage/files/storage-files-planning)
- [Deploy Azure Files](/azure/storage/files/storage-files-deployment-guide)
- [Azure Files networking considerations](/azure/storage/files/storage-files-networking-overview)
- [Set up Azure Files network endpoints](/azure/storage/files/storage-files-networking-endpoints)
- [Monitor Azure Files](/azure/storage/files/storage-files-monitoring)
- [Plan for file access auditing](/windows-server/identity/solution-guides/plan-for-file-access-auditing)
- [Back up Azure file shares](/azure/backup/backup-afs)
- [On-premises Active Directory Domain Services (AD DS) authentication over SMB for Azure file shares](/azure/storage/files/storage-files-identity-ad-ds-overview)
- [Deploy Azure File Sync](/azure/storage/file-sync/file-sync-deployment-guide)
- [Set up Azure File Sync network endpoints](/azure/storage/file-sync/file-sync-networking-endpoints)
- [Cloud tiering overview](/azure/storage/file-sync/file-sync-cloud-tiering-overview)
- [Create a site-to-site connection in the Azure portal](/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal)
- [ExpressRoute circuits and peering](/azure/expressroute/expressroute-circuit-peerings)
- [Create and modify peering for an ExpressRoute circuit](/azure/expressroute/expressroute-howto-routing-portal-resource-manager)
- [Azure file share backup overview](/azure/backup/azure-file-share-backup-overview)
- [DNS Private Resolver overview](/azure/dns/dns-private-resolver-overview)
- [Set up Microsoft Entra Kerberos authentication for hybrid identities on Azure Files](/azure/storage/files/storage-files-identity-auth-hybrid-identities-enable)

## Related resources

- [Azure files accessed on-premises and secured by AD DS](../example-scenario/hybrid/azure-files-on-premises-authentication.yml)
- [Hybrid file services](hybrid-file-services.yml)
