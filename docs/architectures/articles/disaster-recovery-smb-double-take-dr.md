---
title: SMB disaster recovery with Double-Take DR
description: Small and medium businesses can inexpensively implement disaster recovery to the cloud by using a partner solution like Double-Take DR.
author: adamboeglin
ms.date: 10/29/2018
---
# SMB disaster recovery with Double-Take DR
Small and medium businesses can inexpensively implement disaster recovery to the cloud by using a partner solution like Double-Take DR.
This solution is built on the Azure managed services: Traffic Manager, VPN Gateway and Virtual Network. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/disaster-recovery-smb-double-take-dr.svg" alt='architecture diagram' />

## Components
* DNS traffic is routed via [Traffic Manager](http://azure.microsoft.com/services/traffic-manager/) which can easily move traffic from one site to another based on policies defined by your organization.
* [Double-Take DR](http://azure.microsoft.com/marketplace/partners/vision-solutions/double-take-dr/) is a partner solution.
* [VPN Gateway](href="http://azure.microsoft.com/services/vpn-gateway/): The VPN gateway maintains the communication between the on-premises network and the cloud network securely and privately.
* [Virtual Network](href="http://azure.microsoft.com/services/virtual-network/): The virtual network is where the failover site will be created when a disaster occurs.

## Next Steps
* [Configure Failover routing method](https://docs.microsoft.com/api/Redirect/documentation/articles/traffic-manager-configure-failover-routing-method/)
* [Double-Take DR in Azure Marketplace](href="http://azure.microsoft.com/marketplace/partners/vision-solutions/double-take-dr/)
* [Create a VNet with a Site-to-Site connection using the Azure portal](https://docs.microsoft.com/api/Redirect/documentation/articles/vpn-gateway-howto-site-to-site-resource-manager-portal/)
* [Designing your network infrastructure for disaster recovery](https://docs.microsoft.com/api/Redirect/documentation/articles/site-recovery-network-design/)