---
title: Enterprise level cloud file sync and share solution on Azure
description: This reference architecture illustrates a enterprise level cloud file sharing solution with Azure provided services including Azure Files, Azure File Sync, Azure Private DNS and Azure Private Endpoint, secure file storage and sharing infrastructure with Azure private link as well as AD DS authentication.  
author: huangyingting
ms.date: 09/19/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.category:
  - hybrid
  - storage
ms.subservice: example-scenario
ms.custom: fcp
---

# Enterprise Level Cloud File Share Solution on Azure

This reference architecture illustrates an enterprise level cloud file sharing solution that uses Azure provided services including [Azure Files](https://azure.microsoft.com/services/storage/files/), [Azure File Sync](https://azure.microsoft.com/updates/azure-file-sync), [Azure Private DNS](https://docs.microsoft.com/azure/dns/private-dns-overview), and [Azure Private Endpoint](https://docs.microsoft.com/azure/private-link/private-endpoint-overview).

This solution allows you to access Azure file shares in a hybrid work environment over a virtual private network between on-premises and Azure virtual networks, through [ExpressRoute](https://azure.microsoft.com/services/expressroute/) private peering/VPN tunnels, without traversing the internet. It also allows you to control and limit file access through Azure Active Directory Domain Services (AD DS) authentication.

This architecture can be generalized for any enterprise customer who is looking for cost savings by outsourcing the management of file servers and infrastructure while retaining control of the data.

## Potential use cases

The enterprise level cloud file sharing solution has the following potential use cases:

- File server or file share lift and shift. By lifting and shifting, you eliminate the need to restructure or reformat data and keep legacy applications on-premises while benefiting from cloud storage.

- Accelerate cloud innovation with increased operational efficiency, reduce the cost to maintain hardware and physical space, protect data corruption and avoid data loss.

- Privately access Azure File shares and protect against data exfiltration.

## Architecture

![Enterprise level cloud file share diagram that shows how clients can access Azure file shares locally through a cloud tiering file server or remotely over ExpressRoute private peering or VPN tunnel in private network environment.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

The solution depicted in this architecture diagram makes use of Azure File Sync to synchronize file and folder Access Control Lists (ACL) between on-premises file servers and Azure file shares, uses the cloud tiering feature from the Azure File Sync agent to cache frequently accessed files locally, enforces AD DS authentication over Azure file shares, accesses file share and file sync service via private IP through Private Link & Private Endpoint over ExpressRoute private peering/VPN tunnel, to provide the same user experience as traditional file sharing but with Azure file shares.

By implementing private endpoint on Azure Files and Azure File Sync, accessing Azure Files and Azure File Sync are restricted from Azure virtual network (with public endpoint access are disabled on Azure Files and Azure File Sync). ExpressRoute private peering/VPN site to site tunnel extends on-premise network to Azure virtual network, Azure File Sync and SMB traffics (from on-premises to Azure Files and Azure File Sync private endpoints) are restricted to private connection only. At transition, Azure Files will only allow the connection if it is made with SMB 3.0+, connections made from the Azure File Sync agent to Azure file share or Storage Sync Service are always encrypted. At rest, Azure Storage automatically encrypts your data when it is persisted to the cloud, it applies to Azure Files as well.

A Domain Name System (DNS) Server is a critical component of the solution. Each Azure service, in this case Azure Files and Azure File Sync service, have a fully qualified domain name (FQDN). Originally, when a client accesses an Azure Files share, or an Azure File Sync agent (deployed on an on-premises file server) accesses the Azure File Sync service, the FQDNs of those services will be resolved to their public IP addresses. After enabling a private endpoint, private IP addresses will be allocated in the Azure virtual network to allow accessing those services over a private connection, and the same FQDNs must now resolve to private IP addresses. To achieve that, Azure Files and Azure File Sync will create a canonical name DNS record (CNAME) to redirect the resolution to a private domain name, as follows: 

- The Azure File Sync's public domain name `\*.afs.azure.net` will have a CNAME redirect to the private domain name `\*.\<region\>.privatelink.afs.azure.net`. 
- The Azure Files public domain name `\<name\>.file.core.windows.net` will have a CNAME redirect to the private domain name `\<name\>.privatelink.file.core.windows.net`.

It is important to correctly configure on-premise DNS settings to resolve private domain name to private IP address. In solution above,
 
- Private DNS zones (component 11 and 12) are created from Azure to provide private name resolution for Azure File Sync and Azure Files
- Private DNS zones then get linked to Azure virtual network so a DNS server (component 8) deployed in virtual network can resolve private domain names.
- Respectively, DNS A records will also need to be created for Azure Files and Azure File Sync in private DNS zones. Those steps can be found from [Configuring Azure Files network endpoints][storage-files-networking-endpoints] and [Configuring Azure File Sync network endpoints][storage-sync-files-networking-endpoints].
- On-premises DNS server (component 3) needs to setup conditional forwarding to forward DNS query of domain afs.azure.net and file.core.windows.net to DNS server in Azure virtual network (componnet 8). 
- After receiving forwarded DNS query from on-premises DNS server, DNS server (component 8) in Azure virtual network uses Azure DNS recursive resolver to resolve private domain name and return private IP address to client.

## Components

The enterprise level cloud file sharing solution uses the following components:

- **Client** - Typically, the client is a Windows, Linux, or Mac OSX desktop that can 'talk' to a file server or Azure Files through the Server Message Block (SMB) protocol.

- **DC and DNS Server** - A Domain Controller (DC) is a server that responds to authentication requests and verifies users on computer networks. A DNS server provides computer name-to-IP address mapping name resolution services to computers and users. A DC and DNS server can be combined into one single server or can be separated into different servers.

- **File Server** - A server that hosts file share and provides file share service through the SMB protocol.

- **CE or VPN Device** - A Customer edge router (CE) or VPN Device that establishes an ExpressRoute or VPN connection to Azure virtual network.

- **ExpressRoute/VPN Gateway** – ExpressRoute is a service lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. VPN Gateway is a specific type of virtual network gateway that is used to send encrypted traffic between an Azure virtual network and an on-premises location over the public Internet. ExpressRoute or VPN Gateway establishes ExpressRoute or VPN connection to your on-premises network.

- **Azure File Sync and Cloud tiering** – Azure File Sync is a service offered by Azure to centralize your organization's file shares in Azure, while keeping the flexibility, performance, and compatibility of an on-premises file server. Cloud tiering is an optional feature of Azure File Sync in which frequently accessed files are cached locally on the server while all other files are tiered to Azure Files based on policy settings.

- **Azure Files** - A fully managed service that offers file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure Files implements the SMB v3 protocol and supports authentication through on-premises Active Directory Domain Services (AD DS) and Azure Active Directory Domain Services (Azure AD DS). File shares from Azure Files can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS. Additionally, Azure file shares can be cached nearer to where the data is being used, on Windows Servers with Azure File Sync for fast access.

- **Azure Private DNS** - An Azure offered DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution.

- **Azure Private Endpoint** - A network interface that connects you privately and securely to a service powered by [Azure Private Link](https://azure.microsoft.com/services/private-link/). In this solution, Azure File Sync private endpoint connects to Azure File Sync, and Azure Files private endpoint connects to Azure Files.

## Traffic flows

After enabling Azure File Sync and Azure Files, Azure file shares can be accessed in two modes, *local cache mode* or *remote mode*. In both modes, the client uses existing AD DS credentials to authenticate itself.

- Local cache mode - The client accesses files and file shares through a local file server with cloud tiering enabled. When a user opens a file from the local file server, file data is either served from the file server local cache, or the Azure File Sync agent seamlessly recalls the file data from Azure Files. In above architecture diagram, it happens between component 1 and 4.

- Remote mode - The client accesses files and file shares directly from a remote Azure file share. In above architecture diagram, the traffic flow travels through component 2, 5, 6, 7 and 10.
Azure File Sync traffic travels between component 4, 5, 6, 7. For a reliable connection, an [ExpressRoute circuit](https://docs.microsoft.com/azure/expressroute/expressroute-circuit-peerings) is recommended.

Private domain name resolution queries go through components 3, 5, 6, 8, 11, 12 in the following sequence:

1. The client sends a query to an on-premises DNS server to resolve an Azure Files or Azure File Sync DNS name.
2. The on-premises DNS server has a conditional forwarder that points Azure File and Azure File Sync DNS name resolution to a DNS server in the Azure virtual network. 
3. The query is then redirected to a DNS Server in the Azure virtual network.
4. The DNS Server in the Azure virtual network sends a name query to the Azure Provided DNS (168.63.129.16) recursive resolver.
5. Because the Azure virtual network is linked to Azure Files and Azure File Sync private DNZ Zone, the Azure recursive resolver will return a private IP after resolving the private domain name to the respective private DNS zone.

## Considerations

The enterprise level cloud file sharing solution has the following considerations:

### Planning

For Azure File Sync planning, refer to [Planning for an Azure File Sync deployment][storage-sync-files-planning].

For Azure Files planning, refer to [Planning for an Azure Files deployment][storage-files-planning].

## Networking

For Azure Files sync network considerations, refer to [Azure File Sync networking considerations][storage-sync-files-networking-overview].

For Azure Files networking considerations, refer to [Azure Files networking considerations][storage-files-networking-overview.]

### DNS

When dealing with name resolution for Private Endpoints, in order to resolve private domain name of Azure Files and Azure File Sync

From the Azure side:
 
- If Azure-provided name resolution is used, Azure virtual network must link to provisioned private DNS zones.
- If "bring your own DNS server" is used, the virtual network where your own DNS server deployed, must link to provisioned private DNS zones.

From the on-premises side, all it needs is to map private domain name to private IP address:

- This can be done through DNS forwarding to a DNS server deployed in Azure virtual network which is described in above architectural design.
- Or, the on-premises DNS server can setup zones for private domain `\<region\>.privatelink.afs.azure.net` and `privatelink.file.core.windows.net`, register Azure Files and Azure File Sync private endpoint's IP addresses as DNS A records into respective DNS zones, so the on-premises client can resolve the private domain name directly from the local on-premises DNS server.

### DFS

When it comes to an on-premises file sharing solution, many administrators choose to use a distributed file system (DFS) rather than a traditional standalone file server, DFS allows administrators to consolidate file shares that may exist on multiple servers to appear as though they all live in the same location so that users can access them from a single point on the network. While move to cloud file share solution, traditional DFS-R deployment can be replaced by Azure File Sync deployment. For more information, please refer to [Migrate a DFS Replication (DFS-R) deployment to Azure File Sync][storage-sync-files-deployment-guide-dfs].

### Data Loss and Backup

Data loss is a serious problem for businesses of all sizes, Azure file share backup uses file share snapshots to provide cloud based backup solution that protects your data in the cloud and eliminates additional maintenance overheads involved in on-premises backup solutions. Key benefits of Azure file share backup include

- Zero infrastructure
- Customized retention
- Built in management capabilities
- Instant restores
- Alerting and reporting
- Protection against accidental deletion of file shares

For more information, please refer to [About Azure file share backup][azure-file-share-backup-overview]

### Security and File Access Auditing

Security Auditing is one of the most needed requirement to help maintain the security of an enterprise, industry standards require enterprises to follow a strict set of rules related to data security and privacy. File access auditing can be enabled locally and remotely

- Locally, leverage Dynamic Access Control, for more information, refer to [Plan for File Access Auditing][plan-for-file-access-auditing].
- Remotely, Azure Storage logs in Azure Monitor on Azure Files contains StorageRead, StorageWrite, StorageDelete, and Transaction logs, Azure file access can be logged to storage account, log analytics workspace or stream to an event hub separately. For more information, please refer to [Monitoring Azure Storage][monitor-storage].

## Related Resources

[Planning for an Azure Files deployment][storage-files-planning]

[How to deploy Azure Files][storage-files-deployment-guide]

[Azure Files networking considerations][storage-files-networking-overview]

[Configuring Azure Files network endpoints][storage-files-networking-endpoints]

[Monitoring Azure Storage][monitor-storage]

[Plan for File Access Auditing][plan-for-file-access-auditing]

[Back up Azure file shares][backup-afs]

[Overview - on-premises Active Directory Domain Services authentication over SMB for Azure file shares
][storage-files-identity-auth-active-directory-enable]

[Deploy Azure File Sync][storage-sync-files-deployment-guide]

[Configuring Azure File Sync network endpoints][storage-sync-files-networking-endpoints]

[Cloud Tiering Overview][storage-sync-cloud-tiering]

[Create a Site-to-Site connection in the Azure portal][vpn-gateway-howto-site-to-site-resource-manager-portal]

[ExpressRoute circuits and peering][expressroute-circuit-peerings]

[Create and modify peering for an ExpressRoute circuit][expressroute-howto-routing-portal-resource-manager]

[About Azure file share backup][azure-file-share-backup-overview]

[architectural-diagram]: ./images/azure-files-private.png
[architectural-diagram-visio-source]: ./diagrams/azure-files-private.vsdx
[storage-files-planning]: https://docs.microsoft.com/azure/storage/files/storage-files-planning
[storage-files-deployment-guide]: https://docs.microsoft.com/azure/storage/files/storage-files-deployment-guide
[storage-files-networking-endpoints]: https://docs.microsoft.com/azure/storage/files/storage-files-networking-endpoints
[monitor-storage]: https://docs.microsoft.com/azure/storage/common/monitor-storage
[plan-for-file-access-auditing]: https://docs.microsoft.com/windows-server/identity/solution-guides/plan-for-file-access-auditing
[backup-afs]: https://docs.microsoft.com/azure/backup/backup-afs
[storage-files-identity-auth-active-directory-enable]: https://docs.microsoft.com/azure/storage/files/storage-files-identity-auth-active-directory-enable
[storage-sync-files-deployment-guide]: https://docs.microsoft.com/azure/storage/files/storage-sync-files-deployment-guide
[storage-sync-files-networking-endpoints]: https://docs.microsoft.com/azure/storage/files/storage-sync-files-networking-endpoints
[storage-sync-cloud-tiering]: https://docs.microsoft.com/azure/storage/files/storage-sync-cloud-tiering
[vpn-gateway-howto-site-to-site-resource-manager-portal]: https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[expressroute-circuit-peerings]: https://docs.microsoft.com/azure/expressroute/expressroute-circuit-peerings
[expressroute-howto-routing-portal-resource-manager]: https://docs.microsoft.com/azure/expressroute/expressroute-howto-routing-portal-resource-manager
[azure-file-share-backup-overview]: https://docs.microsoft.com/azure/backup/azure-file-share-backup-overview
[storage-sync-files-deployment-guide-dfs]: https://docs.microsoft.com/azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal%2Cproactive-portal#migrate-a-dfs-replication-dfs-r-deployment-to-azure-file-sync
[storage-sync-files-planning]: https://docs.microsoft.com/azure/storage/files/storage-sync-files-planning
[storage-sync-files-networking-overview]: https://docs.microsoft.com/azure/storage/files/storage-sync-files-networking-overview
[storage-files-networking-overview]: https://docs.microsoft.com/azure/storage/files/storage-files-networking-overview
