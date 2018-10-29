---
title: Enterprise-scale disaster recovery
description: A large enterprise architecture for SharePoint, Dynamics CRM, and Linux web servers hosted on an on-premises datacenter with failover to Azure infrastructure.
author: adamboeglin
ms.date: 10/29/2018
---
# Enterprise-scale disaster recovery
A large enterprise architecture for SharePoint, Dynamics CRM, and Linux web servers hosted on an on-premises datacenter with failover to Azure infrastructure.
This solution is built on the Azure managed services: Traffic Manager, Azure Site Recovery, Azure Active Directory, VPN Gateway and Virtual Network. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/disaster-recovery-enterprise-scale-dr.svg" alt='architecture diagram' />

## Components
* DNS traffic is routed via [Traffic Manager](http://azure.microsoft.com/services/traffic-manager/) which can easily move traffic from one site to another based on policies defined by your organization.
* [Azure Site Recovery](http://azure.microsoft.com/services/site-recovery/) orchestrates the replication of machines and manages the configuration of the failback procedures.
* [Blob storage](http://azure.microsoft.com/services/storage/blobs/) stores the replica images of all machines that are protected by Site Recovery.
* [Azure Active Directory](http://azure.microsoft.com/services/active-directory/) is the replica of the on-premises [Azure Active Directory](http://azure.microsoft.com/services/active-directory/) services allowing cloud applications to be authenticated and authorized by your company.
* [VPN Gateway](href="http://azure.microsoft.com/services/vpn-gateway/): The VPN gateway maintains the communication between the on-premises network and the cloud network securely and privately.
* [Virtual Network](href="http://azure.microsoft.com/services/virtual-network/): The virtual network is where the failover site will be created when a disaster occurs.

## Next Steps
* [Configure Failover routing method](https://docs.microsoft.com/api/Redirect/documentation/articles/traffic-manager-configure-failover-routing-method/)
* [How does Azure Site Recovery work?](https://docs.microsoft.com/api/Redirect/documentation/articles/site-recovery-components/)
* [Introduction to Microsoft Azure Storage](https://docs.microsoft.com/api/Redirect/documentation/articles/storage-introduction/)
* [Integrating your on-premises identities with Azure Active Directory](https://docs.microsoft.com/api/Redirect/documentation/articles/active-directory-aadconnect/)
* [Create a VNet with a Site-to-Site connection using the Azure portal](https://docs.microsoft.com/api/Redirect/documentation/articles/vpn-gateway-howto-site-to-site-resource-manager-portal/)
* [Designing your network infrastructure for disaster recovery](https://docs.microsoft.com/api/Redirect/documentation/articles/site-recovery-network-design/)