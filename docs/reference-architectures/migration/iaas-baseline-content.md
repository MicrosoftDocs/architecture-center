
Need intro paragraph that describes scenario and clarifies:
- focus IS on infrastructure
- focus IS NOT on workload
- data tier is out of scope - use database of choice

## Architecture

:::image type="content" source="./media/iaas-baseline.png" alt-text="IaaS baseline architectural diagram" lightbox="./media/iaas-baseline.png":::

*Download a [Visio file](https://arch-center.azureedge.net/iaas-baseline.vsdx) of this architecture.*

Need to convert to SVG, create Visio, create thumbnail

### Components

##### General

- [Resource groups](https://azure.microsoft.com/get-started/azure-portal/resource-manager) are used to group Azure resources so they can be managed by lifetime, owner, or other criteria.

- [Availability zones](https://azure.microsoft.com/explore/global-infrastructure/availability-zones) are separate physical locations within an Azure region, each with one or more datacenters that have independent power, cooling, and networking. By placing VMs across zones, the application becomes resilient to failures within a zone.

##### Compute

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines/) allow you to migrate your Windows and Linux workloads to Azure compute. [Multiple series options](https://azure.microsoft.com/pricing/details/virtual-machines/series/) are available to customize your configuration based on your web, API, and data layer workload requirements.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/products/virtual-machine-scale-sets) let you create and manage a group of heterogeneous load-balanced virtual machines (VMs). Increase or decrease the number of VMs automatically in response to demand or based on a schedule you define.

##### Networking and load balancing

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for private networks in Azure. Every Azure VM is deployed into a virtual network that can be segmented into subnets with one subnet for each tier.

- [Application Gateway](https://azure.microsoft.com/products/application-gateway) is a layer-7 load balancer. In this architecture, a zone-redundant Application Gateway instance routes HTTP requests to the web front end. Application Gateway also provides [Azure Web Application Firewall](https://azure.microsoft.com/products/web-application-firewall), which protects the application from common exploits and vulnerabilities. The v2 SKU of Application Gateway supports cross-zone redundancy. A single Application Gateway deployment can run multiple gateway instances. For production workloads, run at least two. For more information, see [Autoscaling and zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant) and [How does Application Gateway support high availability and scalability?](/azure/application-gateway/application-gateway-faq#how-does-application-gateway-support-high-availability-and-scalability).

- [Azure Load Balancer](https://azure.microsoft.com/products/load-balancer) is a layer-4 load balancer. In this architecture, a zone-redundant [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-standard-overview) directs network traffic from the web tier to SQL Server. Because a zone-redundant load balancer isn't pinned to a specific zone, the application continues to distribute the network traffic during a zone failure. A zone-redundant load balancer is used to provide availability when the active SQL Server instance becomes unavailable. The standard SKU of Load Balancer supports cross-zone redundancy. For more information, see [Standard Load Balancer and availability zones](/azure/load-balancer/load-balancer-standard-availability-zones).

- [Network security groups](https://azuremarketplace.microsoft.com/marketplace/apps/Microsoft.NetworkSecurityGroup) are used to restrict network traffic within a virtual network. In this architecture, the web tier only accepts traffic from the public IP endpoint. Also, the database tier doesn't accept traffic from any subnet other than the web-tier subnet.

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) provides secure and seamless Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to the VMs within a virtual network. This service provides access while limiting the exposed public IP addresses of the VMs within the virtual network. Azure Bastion provides a cost-effective alternative to a **provisioned** VM to provide access to all VMs within the same virtual network.

### Flow

Data/Work flow...

### Alternatives

## Scenario details

This reference architecture is directed at scenarios where an on-prem web app is being migrated to Azure IaaS ...

### Business continuity and disaster recovery (BCDR)

##### Guidance for VMs
##### Guidance for PaaS and other components

### Compute

##### Workload
- Structure of the workload
- VMSS scaling, availability zones
- Packaging/publishing workload artifacts
##### Management
- RDP via Bastion/Jumpbox
##### Managed disks

### DevOps

##### OS patching
##### Packaging/publishing workload artifacts
##### Guest OS config

### Identity and access management

##### Managed identities
##### Authorization for solution components
##### Role based access control (RBAC)

### Monitoring

##### VM insights (will we using other insights?)
##### Workload metrics and instrumentation
##### Health probes
##### Platform metrics
##### Logs
##### Log analytic workspace

### Networking

:::image type="content" source="./media/iaas-baseline-network-topology.png" alt-text="IaaS baseline architectural diagram" lightbox="./media/iaas-baseline-network-topology.png":::

- Update image to show overall network topology with components for each subsection below
- Q: Do we need to add Azure DDoS Protection?

##### Hub and spoke topology
##### Virtual network and subnets
##### Traffic to/from internet
##### Traffic to/from private network and on-premises
##### Traffic routing within workload
##### Traffic control
- Network Security Groups (NSG)
- Firewall
##### NIC/IPConfig + VM lifecycle
##### Accelerated Networking
##### Private DNS resolution

### Secret management

##### Certificate
##### Key rotation

### Storage
Generic guidance based on technology choice

### Potential use cases

Potential use cases include....

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

## Deploy this scenario

A deployment for a reference architecture that implements these recommendations and considerations is available on [GitHub](https://www.github.com/path-to-repo).

1. First step
1. Second step
1. Third step ...

## Next steps

See product documentation for details on specific Azure services:

- [Azure Virtual Machines](/azure/virtual-machines)
- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/)

## Related resources

IaaS reference architectures showing options for the data tier:

- [IaaS: Web application with relational database](/azure/architecture/high-availability/ref-arch-iaas-web-and-db)
- [Windows N-tier application using SQL Server on Azure](/azure/architecture/reference-architectures/n-tier/n-tier-sql-server)
