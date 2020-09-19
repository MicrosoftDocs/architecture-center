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

## Enterprise Level Cloud File Share Solution on Azure
This reference architecture illustrates an enterprise level cloud file sharing solution by using Azure provided services including Azure Files, Azure File Sync, Azure Private DNS and Azure Private Endpoint, it gives you the possibility to access Azure file shares in a hybrid work environment over virtual private network between on-premises and Azure virtual network(through ExpressRoute private peering/VPN tunnels) without traversing the internet, you can also control and limit file access through AD DS authentication.

This architecture can be generalized for any enterprise customer who is looking for saving the cost, outsourcing the management of file servers and infrastructure while remains the control of the data. 

## Potential use cases
- File server/share lift and shift - eliminates the need to restructure or reformat data. Keep legacy applications on-premises while benefiting from cloud storage.

- Accelerate cloud innovation with increased operational efficiency, reduce the cost to maintain hardware and physical space, protect data corruption and avoid data loss.

- Privately access Azure file shares and protect against data exfiltration.

## Architecture
![Enterprise level cloud file share diagram that shows how clients can access Azure file share locally through cloud tiering file server or remotely over ExpressRoute private peering or VPN connection in private network environment.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

- The solution leverages Azure file sync to synchronize file/folder ACL between on-premise file servers and azure files share, uses cloud tiering feature from Azure file sync agent to cache frequently accessed files locally, enforces AD DS authentication over Azure file shares, accesses file share and file sync service via private IP through private link & private endpoint,  to provide same user experience of traditional mapped drives with fast local speeds, as well as secure file remote access user experience.

- ExpressRoute circuit or VPN connection extends on-premise network to Azure virtual network, by physically, both file sync traffics, and SMB traffics are restricted to private connection between on-premises and Azure, which is a trusted network environment. By implementing private endpoint on Azure files and Azure file sync, accessing Azure files and Azure file sync are restricted from private network only (with public endpoint access are disabled on Azure files and Azure file sync). By default, all Azure storage accounts have encryption in transit enabled. Connections made from the Azure File Sync agent to Azure file share or Storage Sync Service are always encrypted.

- When client access remote Azure file or Azure file sync agent communicate with Azure file sync service, DNS is used to resolve those service’s name to their IP addresses. After enabling private endpoint, private endpoint will add additional CNAME for Azure files and Azure file sync, Azure file sync related public DNS name *.afs.azure.net will resolve to CNAME *.\<region\>.privatelink.afs.azure.net, Azure files public DNS name \<name\>.file.core.windows.net will resolve to CNAME \<name\>.privatelink.file.core.windows.net, it is important to correctly configure on-premise DNS settings to resolve to the allocated private IP address, in solution above, private DNS zones (component 11 and 12) are created from Azure to provide name resolution for Azure file sync and Azure files PrivateLink DNS name, private DNS zones are linked to Azure virtual network so a DNS server (component 8) deployed in virtual network can resolve those PrivateLink DNS name, on-premises DNS server (component 3) need to setup conditional forwarding and point to DNS server (component 8) in Azure virtual network to resolve those DNS name under domain afs.azure.net and file.core.windows.net, DNS server (component 8) in Azure virtual network eventually resolves PrivateLink DNS name through Azure DNS recursive resolver from linked private DNS zone and return private IP address to client.

## Components
- Client - Is a client that can 'talk' to file server or Azure files through SMB protocol, usually it is a Windows, Linux, or Mac OSX desktop.
- DC & DNS Server - Domain controller (DC) is a server that responds to authentication requests and verifies users on computer networks. DNS Server provide computer name-to-IP address mapping name resolution services to computers and users. DC and DC Server can be combined into one single server or can be separated into different servers.
- File Server - is a server hosts file share and provides file share service through SMB protocol.
- CE/VPN Device - Customer edge router (CE) or VPN Device is used to establish ExpressRoute or VPN connection to Azure virtual network.
- ExpressRoute/VPN Gateway – ExpressRoute is a service lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. VPN Gateway is a specific type of virtual network gateway that is used to send encrypted traffic between an Azure virtual network and an on-premises location over the public Internet. ExpressRoute or VPN Gateway is used to establish ExpressRoute or VPN connection to customer’s on-premises network.
- Azure File Sync & Cloud Tiering – Azure File Sync is a service offered by Azure to centralize your organization's file shares in Azure, while keeping the flexibility, performance, and compatibility of an on-premises file server. Cloud tiering is an optional feature of Azure File Sync in which frequently accessed files are cached locally on the server while all other files are tiered to Azure Files based on policy settings.
- Azure Files - Is a fully managed service offers file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure files implement SMB v3 protocol and supports authentication through on-premises Active Directory Domain Services (AD DS) and Azure Active Directory Domain Services (Azure AD DS). File shares from Azure files can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS. Additionally, Azure file shares can be cached on Windows Servers with Azure File Sync for fast access near where the data is being used.
- Azure Private DNS - An Azure offered DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution. 
- Azure Private Endpoint - is a network interface that connects you privately and securely to a service powered by Azure Private Link, in our case, Azure file sync private endpoint connects to Azure file sync, and Azure files private endpoint connects to Azure files.

## Traffic flows
After enabling Azure file sync and Azure files, Azure file shares can be accessed in two ways, local cache mode or directly remote mode, in both modes, client uses existing AD DS credentials to authenticate itself.
- Local cache mode - Client accesses files and file shares through cloud tiering enabled local file server. When a user opens a file from local file server, file data is either served from file server local cache or Azure File Sync agent seamlessly recalls the file data from Azure Files. In above architecture diagram, it happens between component 1 and 4. 
- Remote mode - Client accesses files and file shares directly from remote Azure file share. In above architecture diagram, the traffic flow travels through component 2, 5, 6, 7 and 10.
Azure file sync traffic travels between component 4, 5, 6, 7, for a reliable connection, express route circuit is recommended.
PrivateLink DNS name resolution queries go through components 3, 5, 6, 8, 11, 12, it happens in below sequences
- Client sends query to on-premises DNS server to resolve Azure files or Azure file sync DNS name.
- On-premises DNS server has conditional forwarder, point Azure file and Azure file sync DNS name resolution to DNS server in Azure virtual network.
- Query is then redirected to DNS Server in Azure virtual network.
- DNS Server in Azure virtual network sends name query to Azure Provided DNS (168.63.129.16) recursive resolver.
- Because Azure virtual network is linked to Azure files and Azure file sync private DNZ Zone, Azure recursive resolver will return private IP after resolving to respective private DNS zone.

## Considerations
### Planning
For details, refer to [Planning for an Azure File Sync deployment][storage-sync-files-planning]
Networking
For details, refer to [Azure File Sync networking considerations][storage-sync-files-networking-overview]
### DFS
When it comes to enterprise level file sharing solution at on-premises, many administrators choose to use a distributed file system (DFS) rather than a traditional standalone file server, DFS allows administrators to consolidate file shares that may exist on multiple servers to appear as though they all live in the same location so that users can access them from a single point on the network. While move to cloud file share solution, traditional DFS-R deployment can be replaced by Azure File Sync deployment. For more information, please refer to [Migrate a DFS Replication (DFS-R) deployment to Azure File Sync][storage-sync-files-deployment-guide-dfs].
### Data Loss and Backup
Data loss is a serious problem for businesses of all sizes, Azure file share backup uses file share snapshots to provide cloud based backup solution that protects your data in the cloud and eliminates additional maintenance overheads involved in on-premises backup solutions. Key benefits of Azure file share backup include
- Zero infrastructure
- Customized retention
- Built in management capabilities
- Instant restores
- Alerting and reporting
- Protection against accidental deletion of file shares
For details, refer to [About Azure file share backup][azure-file-share-backup-overview]
### Security and File Access Auditing
Security Auditing is one of the most powerful tools to help maintain the security of an enterprise, industry standards require enterprises to follow a strict set of rules related to data security and privacy. File access auditing in solution above can be enabled locally and remotely
- Locally, leverage Dynamic Access Control, for more information, refer to [Plan for File Access Auditing][plan-for-file-access-auditing].
- Remotely, Azure Storage logs in Azure Monitor on Azure files contains StorageRead, StorageWrite, StorageDelete, and Transaction logs, Azure file access can be logged to storage account, log analytics workspace or stream to an event hub separately. For more information, refer to [Monitoring Azure Storage][monitor-storage].

## Related Resources
[Planning for an Azure Files deployment][storage-files-planning]

[How to deploy Azure Files][storage-files-deployment-guide]

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
[storage-files-planning]: https://docs.microsoft.com/en-us/azure/storage/files/storage-files-planning
[storage-files-deployment-guide]: https://docs.microsoft.com/en-us/azure/storage/files/storage-files-deployment-guide
[storage-files-networking-endpoints]: https://docs.microsoft.com/en-us/azure/storage/files/storage-files-networking-endpoints
[monitor-storage]: https://docs.microsoft.com/en-us/azure/storage/common/monitor-storage
[plan-for-file-access-auditing]: https://docs.microsoft.com/en-us/windows-server/identity/solution-guides/plan-for-file-access-auditing
[backup-afs]: https://docs.microsoft.com/en-us/azure/backup/backup-afs
[storage-files-identity-auth-active-directory-enable]: https://docs.microsoft.com/en-us/azure/storage/files/storage-files-identity-auth-active-directory-enable
[storage-sync-files-deployment-guide]: https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-deployment-guide
[storage-sync-files-networking-endpoints]: https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-networking-endpoints
[storage-sync-cloud-tiering]: https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-cloud-tiering
[vpn-gateway-howto-site-to-site-resource-manager-portal]: https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[expressroute-circuit-peerings]: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings
[expressroute-howto-routing-portal-resource-manager]: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-routing-portal-resource-manager
[azure-file-share-backup-overview]: https://docs.microsoft.com/en-us/azure/backup/azure-file-share-backup-overview
[storage-sync-files-deployment-guide-dfs]: https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal%2Cproactive-portal#migrate-a-dfs-replication-dfs-r-deployment-to-azure-file-sync
[storage-sync-files-planning]: https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-planning
[storage-sync-files-networking-overview]:https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-networking-overview