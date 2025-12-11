[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution provides a highly available deployment of SharePoint using a load balanced Microsoft Entra ID, highly available SQL always on instance, and highly available SharePoint resources.

## Potential use cases

This solution addresses the capability to deliver highly available intranet capability to teams within your business, by using the latest and greatest support platforms.

## Architecture

![Architecture Diagram](../media/highly-available-sharepoint-farm.png)

<div class="architecture-tooltip-content" id="architecture-tooltip-9">
<p>Use ExpressRoute or VPN Gateway for management access to resource group.</p>
</div>

### Dataflow

1. Create resource group for the storage, network, and virtual machine, plus other dependent elements.
1. Create virtual network to host the virtual machines and load balancers for the deployment. Ensure the network has appropriate network security groups implemented to protect network traffic flow.
1. Create the storage accounts that will host the virtual hard disks (VHDs) for the machine images.
1. Create the Active Directory installation using either a new virtual machine or Microsoft Entra Domain Services. If using Microsoft Entra Domain Services,  consider synchronizing identities to Microsoft Entra ID with Microsoft Entra Connect.
1. Create a Windows failover cluster and install a supported version of SQL Server on an Azure virtual machine (VM) or deploy pay-as-you-go instances of SQL Server.
1. Deploy SharePoint onto multiple Azure VMs, or, use trial images from the gallery that already have SharePoint Server installed.
1. Create the SharePoint farm.
1. Set up an Azure external load balancer to direct incoming HTTPS traffic to the SharePoint server.
1. Use ExpressRoute or VPN Gateway for management access to resource group.
1. On-premises users can access the SharePoint sites via the internet, ExpressRoute, or VPN Gateway.
1. External users can be granted access as required to the SharePoint sites for testing.

### Components

* An [Azure resource group](/azure/azure-resource-manager/management/overview#resource-groups) is a logical container that holds related Azure resources for a solution. In this architecture, the resource group organizes and manages all components required for the SharePoint deployment, including networking, storage, and compute resources.
* [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a foundational networking service that enables secure communication between Azure resources and on-premises environments. In this architecture, the virtual network hosts the VMs and load balancers, and enforces traffic control through network security groups.
* [Azure Storage accounts](/azure/storage/common/storage-introduction) provide durable, highly available, and scalable cloud storage for various data types. In this architecture, Storage accounts host the virtual hard disks (VHDs) used by the VMs that run SharePoint and SQL Server.
* [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service that enables secure access to Azure resources. In this architecture, it synchronizes identities from on-premises directories and supports single sign-on for users that access SharePoint.
* Microsoft SharePoint Server is an enterprise collaboration platform for content management and intranet solutions. In this architecture, SharePoint Server is deployed across multiple Azure VMs to form a highly available SharePoint farm.
* [SQL Server](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) is a relational database management system that stores and manages structured data. In this architecture, SQL Server is installed on Azure VMs in a Windows failover cluster to support high availability for SharePoint databases.
* [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a layer-4 load balancing service that distributes network traffic across multiple resources. In this architecture, an external load balancer directs incoming HTTPS traffic to the SharePoint servers to ensure availability and performance.
* [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a dedicated private connection service that extends on-premises networks into Azure over a private fiber link. In this architecture, ExpressRoute provides secure and reliable management access to the resource group and enables connectivity for on-premises users that access SharePoint sites.

## Next steps

* [Azure Resource Group documentation](/azure/azure-resource-manager/resource-group-overview)
* [Virtual Network documentation](/azure/virtual-network/virtual-networks-overview)
* [Storage Documentation](/azure/storage/blobs/storage-blobs-introduction)
* [Microsoft server software support for VMs](https://support.microsoft.com/help/2721672/microsoft-server-software-support-for-microsoft-azure-virtual-machines)
* [SharePoint Server 2016 in Azure DevTest environment](/sharepoint/administration/intranet-sharepoint-server-in-azure-dev-test-environment)
* [Deploy a SQL Server database to an Azure VM](/azure/azure-sql/virtual-machines/windows/create-sql-vm-portal)
* [Load Balancer documentation](/azure/load-balancer/load-balancer-standard-overview)
* [ExpressRoute documentation](/azure/expressroute)
