---
title: SMB disaster recovery with Azure Site Recovery
description: Small and medium businesses can inexpensively implement disaster recovery to the cloud by using Azure Site Recovery or a partner solution like Double-Take DR.
author: adamboeglin
ms.date: 10/29/2018
---
# SMB disaster recovery with Azure Site Recovery
Small and medium businesses can inexpensively implement disaster recovery to the cloud by using Azure Site Recovery or a partner solution like Double-Take DR.
This solution is built on the Azure managed services: Traffic Manager, Azure Site Recovery and Virtual Network. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/disaster-recovery-smb-azure-site-recovery.svg" alt='architecture diagram' />

## Components
* DNS traffic is routed via [Traffic Manager](http://azure.microsoft.com/services/traffic-manager/) which can easily move traffic from one site to another based on policies defined by your organization.
* [Azure Site Recovery](http://azure.microsoft.com/services/site-recovery/) orchestrates the replication of machines and manages the configuration of the failback procedures.
* [Virtual Network](href="http://azure.microsoft.com/services/virtual-network/): The virtual network is where the failover site will be created when a disaster occurs.
* [Blob storage](http://azure.microsoft.com/services/storage/blobs/) stores the replica images of all machines that are protected by Site Recovery.

## Next Steps
* [Configure Failover routing method](https://docs.microsoft.com/api/Redirect/documentation/articles/traffic-manager-configure-failover-routing-method/)
* [How does Azure Site Recovery work?](https://docs.microsoft.com/api/Redirect/documentation/articles/site-recovery-components/)
* [Designing your network infrastructure for disaster recovery](https://docs.microsoft.com/api/Redirect/documentation/articles/site-recovery-network-design/)
* [Introduction to Microsoft Azure Storage](https://docs.microsoft.com/api/Redirect/documentation/articles/storage-introduction/)