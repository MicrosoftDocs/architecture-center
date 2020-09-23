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
This reference architecture illustrates an enterprise level cloud file sharing solution by using Azure provided services including Azure Files, Azure File Sync, Azure Private DNS and Azure Private Endpoint, it gives you the possibility to access Azure file shares in a hybrid work environment over virtual private network between on-premises and Azure virtual network(through ExpressRoute private peering/VPN tunnels) without traversing the internet, you can also control and limit file access through AD DS authentication.

This architecture can be generalized for any enterprise customer who is looking for saving the cost, outsourcing the management of file servers and infrastructure while remains the control of the data. 

## Potential use cases
- File server/share lift and shift - eliminates the need to restructure or reformat data. Keep legacy applications on-premises while benefiting from cloud storage.

- Accelerate cloud innovation with increased operational efficiency, reduce the cost to maintain hardware and physical space, protect data corruption and avoid data loss.

- Privately access Azure file shares and protect against data exfiltration.

## Architecture
![Enterprise level cloud file share diagram that shows how clients can access Azure file share locally through cloud tiering file server or remotely over ExpressRoute private peering or VPN tunnel in private network environment.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

The solution leverages Azure file sync to synchronize file/folder ACL between on-premise file servers and azure files share, uses cloud tiering feature from Azure file sync agent to cache frequently accessed files locally, enforces AD DS authentication over Azure files share, accesses file share and file sync service via private IP through Private Link & Private Endpoint over ExpressRoute private peering/VPN tunnel, to provide same user experience of traditional file sharing but with Azure files share.

By implementing private endpoint on Azure files and Azure file sync, accessing Azure files and Azure file sync are restricted from Azure virtual network (with public endpoint access are disabled on Azure files and Azure file sync). ExpressRoute private peering/VPN site to site tunnel extends on-premise network to Azure virtual network, Azure file sync and SMB traffics (from on-premises to Azure files and Azure file sync private endpoints) are restricted to private connection only. At transition, Azure Files will only allow the connection if it is made with SMB 3.0+, connections made from the Azure File Sync agent to Azure file share or Storage Sync Service are always encrypted. At rest, Azure Storage automatically encrypts your data when it is persisted to the cloud, it applys to Azure files as well.

DNS is a critical component in above solution. Each Azure service, in our case is Azure files or Azure file sync service, has a FQDN. Orginally, when a client accesses Azure files share, or an Azure file sync agent (deployed at on-premises file server) accesses Azure file sync service, those services' FQDNs will be resolved to their public IP addresses. After enabling private endpoint, private IP addresses will be allocated in Azure virtual network to allow accessing those services over private connection, same FQDNs need to resolve to private IP addresses now. To achieve that, Azure files and Azure file sync will create a canonical name DNS record (CNAME) to redirect the resolution to private domain name. 
- Azure file sync's public domain names \*.afs.azure.net will have CNAMEs redirect to private domain name \*.\<region\>.privatelink.afs.azure.net. 
- Azure files public domain name \<name\>.file.core.windows.net will have a CNAME redirect to private domain name \<name\>.privatelink.file.core.windows.net. 

It is important to correctly configure on-premise DNS settings to resolve private domain name to private IP address. In solution above, 
- Private DNS zones (component 11 and 12) are created from Azure to provide private name resolution for Azure file sync and Azure files
- Private DNS zones then get linked to Azure virtual network so a DNS server (component 8) deployed in virtual network can resolve private domain names.
- Respectively, DNS A records will also need to be created for Azure files and Azure file sync in private DNS zones. Those steps can be found from [Configuring Azure Files network endpoints][storage-files-networking-endpoints] and [Configuring Azure File Sync network endpoints][storage-sync-files-networking-endpoints].
- On-premises DNS server (component 3) needs to setup conditional forwarding to forward DNS query of domain afs.azure.net and file.core.windows.net to DNS server in Azure virtual network (componnet 8). 
- After receiving forwarded DNS query from on-premises DNS server, DNS server (component 8) in Azure virtual network uses Azure DNS recursive resolver to resolve private domain name and return private IP address to client.


## Components
- **Client** - Is a client that can 'talk' to file server or Azure files through SMB protocol, usually it is a Windows, Linux, or Mac OSX desktop.

- **DC & DNS Server** - Domain controller (DC) is a server that responds to authentication requests and verifies users on computer networks. DNS Server provide computer name-to-IP address mapping name resolution services to computers and users. DC and DC Server can be combined into one single server or can be separated into different servers.

- **File Server** - Is a server hosts file share and provides file share service through SMB protocol.

- **CE/VPN Device** - Customer edge router (CE) or VPN Device is used to establish ExpressRoute or VPN connection to Azure virtual network.

- **ExpressRoute/VPN Gateway** – ExpressRoute is a service lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. VPN Gateway is a specific type of virtual network gateway that is used to send encrypted traffic between an Azure virtual network and an on-premises location over the public Internet. ExpressRoute or VPN Gateway is used to establish ExpressRoute or VPN connection to customer’s on-premises network.

- **Azure File Sync & Cloud Tiering** – Azure File Sync is a service offered by Azure to centralize your organization's file shares in Azure, while keeping the flexibility, performance, and compatibility of an on-premises file server. Cloud tiering is an optional feature of Azure File Sync in which frequently accessed files are cached locally on the server while all other files are tiered to Azure Files based on policy settings.

- **Azure Files** - Is a fully managed service offers file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure files implement SMB v3 protocol and supports authentication through on-premises Active Directory Domain Services (AD DS) and Azure Active Directory Domain Services (Azure AD DS). File shares from Azure files can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS. Additionally, Azure file shares can be cached on Windows Servers with Azure File Sync for fast access near where the data is being used.

- **Azure Private DNS** - An Azure offered DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution.

- **Azure Private Endpoint** - is a network interface that connects you privately and securely to a service powered by Azure Private Link, in our case, Azure file sync private endpoint connects to Azure file sync, and Azure files private endpoint connects to Azure files.

## Traffic flows
After enabling Azure file sync and Azure files, Azure file shares can be accessed in two modes, local cache mode or remote mode, in both modes, client uses existing AD DS credentials to authenticate itself.

- Local cache mode - Client accesses files and file shares through cloud tiering enabled local file server. When a user opens a file from local file server, file data is either served from file server local cache, or Azure File Sync agent seamlessly recalls the file data from Azure Files. In above architecture diagram, it happens between component 1 and 4.

- Remote mode - Client accesses files and file shares directly from remote Azure file share. In above architecture diagram, the traffic flow travels through component 2, 5, 6, 7 and 10.
Azure file sync traffic travels between component 4, 5, 6, 7, for a reliable connection, express route circuit is recommended.

Private domain name resolution queries go through components 3, 5, 6, 8, 11, 12, it happens in below sequences
- Client sends query to on-premises DNS server to resolve Azure files or Azure file sync DNS name.
- On-premises DNS server has conditional forwarder, point Azure file and Azure file sync DNS name resolution to DNS server in Azure virtual network.
- Query is then redirected to DNS Server in Azure virtual network.
- DNS Server in Azure virtual network sends name query to Azure Provided DNS (168.63.129.16) recursive resolver.
- Because Azure virtual network is linked to Azure files and Azure file sync private DNZ Zone, Azure recursive resolver will return private IP after resolving private domain name to respective private DNS zone.

## Considerations
### Planning
For Azure file sync planning, refer to [Planning for an Azure File Sync deployment][storage-sync-files-planning]

For Azure files planning, refer to [Planning for an Azure Files deployment][storage-files-planning]

## Networking
For Azure files sync network considerations, refer to [Azure File Sync networking considerations][storage-sync-files-networking-overview]

For Azure files networking considerations, refer to [Azure Files networking considerations][storage-files-networking-overview]

### DNS
When dealing with name resolution for Private Endpoints, in order to resolve private domain name of Azure files and Azure file sync.

From Azure side, 
- If Azure-provided name resolution is used, Azure virtual network needs to link to provisioned private DNS zones.
- If "bring your own DNS server" is used, the virtual network where your own DNS server deployed, needs to link to provisioned private DNS zones.

From on-premises side, all it needs is to map private domain name to private IP address, 
- This can be done through DNS forwarding to a DNS server deployed in Azure virtual network which is described in above architectural design.
- Or, on-premises DNS server can setup zones for private domain \<region\>.privatelink.afs.azure.net and privatelink.file.core.windows.net, register Azure files and Azure file sync private endpoint's IP addresses as DNS A records into respective DNS zones, so on-premises client can resolve private domain name directly from local on-premises DNS server.

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
- Remotely, Azure Storage logs in Azure Monitor on Azure files contains StorageRead, StorageWrite, StorageDelete, and Transaction logs, Azure file access can be logged to storage account, log analytics workspace or stream to an event hub separately. For more information, please refer to [Monitoring Azure Storage][monitor-storage].

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