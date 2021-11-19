[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution provides a highly available deployment of SharePoint, by using a load balanced Azure Active Directory (Azure AD), a highly available SQL always-on instance, and highly available SharePoint resources.

## Potential use cases

This solution addresses the need to deliver a highly available intranet capability, by using the latest and greatest supported platforms.

## Architecture

![Architecture diagram](../media/sharepoint-farm-microsoft-365.png)
*Download an [SVG](../media/sharepoint-farm-microsoft-365.svg) of this architecture.*

### Data flow

1. Create resource group to host all Azure based infrastructure and services.
1. Create virtual network in Azure.
1. Deploy Windows Servers to host Active Directory services for SharePoint and SQL server service accounts and machine accounts.
1. Deploy SQL Server Always on for HA support for the SharePoint farm.
1. Deploy SharePoint Severs. In this scenario we are using 2 Frontend with Distributed Cache and 2 Application with Search roles. This give us high availability.
1. Install Azure AD Connect on an on-premises server to synchronize your identities to Azure Active Directory.
1. Optionally configure Active Directory Federation Services on premises to support federated authentication to Microsoft 365.
1. Deploy ExpressRoute or setup a site-to-site VPN link for administrative access to the servers hosted in Azure IaaS.
1. Setup and provision external access to the Hybrid farm hosted in Azure IaaS
1. Setup and configure Hybrid Workloads between Microsoft 365 and the SharePoint farm.

### Components

* [Azure Resource Group](https://azure.microsoft.com/features/resource-manager): Container that holds related resources for an Azure solution
* [Virtual Network](https://azure.microsoft.com/services/virtual-network): Provision private networks, optionally connect to on-premises datacenters
* [Storage Accounts](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory): Synchronize on-premises directories and enable single sign-on
* SharePoint Server: Microsoft's collaboration server product
* Host enterprise [SQL Server](https://azure.microsoft.com/services/virtual-machines/sql-server) apps in the cloud
* [Load Balancer](https://azure.microsoft.com/services/load-balancer): Deliver high availability and network performance to your applications
* [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute): Dedicated private network fiber connections to Azure
* [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway): Establish secure, cross-premises connectivity
* Azure AD Connect: Synchronize on-premises directories and enable single sign-on
* Active Directory Federation Services: Synchronize on-premises directories and enable single sign-on
* Hybrid Workloads: Scales between on-premises environments and the cloud

## Next steps

* [Azure Resource Group Documentation](/azure/azure-resource-manager/resource-group-overview)
* [Virtual Network Documentation](/azure/virtual-network/virtual-networks-overview)
* [Storage Documentation](/azure/storage/blobs/storage-blobs-introduction)
* [Active Directory Documentation](https://support.microsoft.com/help/2721672/microsoft-server-software-support-for-microsoft-azure-virtual-machines)
* [SharePoint Server Documentation](/sharepoint/administration/intranet-sharepoint-server-2016-in-azure-dev-test-environment)
* [SQL Server Documentation](/sql/relational-databases/databases/deploy-a-sql-server-database-to-a-microsoft-azure-virtual-machine?view=sql-server-2017)'
* [Load Balancer Documentation](/azure/load-balancer/load-balancer-standard-overview)
* [ExpressRoute Documentation](/azure/expressroute)
* [VPN Gateway Documentation](/azure/vpn-gateway)
* [Azure AD Connect Documentation](/azure/active-directory/connect/active-directory-aadconnect)
* [Active Directory Federation Services Documentation](/azure/active-directory/connect/active-directory-aadconnectfed-whatis)
* [Hybrid Workloads Documentation](/sharepoint/hybrid/hybrid)
