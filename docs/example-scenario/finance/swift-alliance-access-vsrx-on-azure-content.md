> [!NOTE]
> For general updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This article provides an overview of deploying SWIFT Alliance Access on Azure. Alliance Access is one of the messaging interfaces that SWIFT offers for enhanced-security financial messaging. You can deploy the solution in a single Azure subscription. For better management and governance of the solution, however, we recommend that you use two Azure subscriptions: 
- One subscription contains the SWIFT Alliance Access components.
- The other subscription contains the resources to connect to SWIFT's network via Alliance Connect Virtual.

## Architecture

[![Diagram that shows the architecture for SWIFT Alliance Access.](media/alliance-access-with-alliance-connect-virtual.png)](media/alliance-access-with-alliance-connect-virtual.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/diagrams-swift-alliance-access-with-alliance-connect-virtual-in-azure.vsdx) that contains this architecture diagram.*

The Alliance Access subscription contains resources that you manage. To create the core infrastructure of Alliance Access resources shown in the diagram, you can use an Azure Resource Manager template (ARM template). Alliance Access deployments on Azure should follow the guidance in SWIFT's Customer Security Programme (CSP) - Customer Security Control Framework (CSCF). We recommend that you use SWIFT CSP-CSCF Azure policies in this subscription.

The Alliance Connect Virtual subscription contains the components that are required to enable connectivity with SWIFTNet. High availability is enabled because the vSRX components depicted in the preceding diagram are deployed redundantly in two Azure availability zones. Additionally, HA-VM 1 and HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improve the availability of the solution. 

The connection between SWIFTNet and these customer-specific networking components can use the dedicated Azure ExpressRoute line or the internet. SWIFT offers three connectivity options: Bronze, Silver, and Gold. You can choose the option that's best suited to message-traffic volumes and the required level of resilience. For more information about these options, see [Alliance Connect: Bronze, Silver and Gold packages](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).

For more information about resilience, see [Single-region multi-active resilience] and [Multi-region multi-active resilience] later in this article.

After you deploy the Alliance Access infrastructure on Azure, follow SWIFT's instructions for installing the Alliance Access software.

### Workflow

- **Azure subscription:** You need an Azure subscription to deploy Alliance Access. We recommend that you use a new Azure subscription to manage and scale Alliance Access.
- **Azure resource group:** The Alliance Access subscription contains an Azure resource group that hosts these Alliance Access components:
  - Alliance Web Platform, running on an Azure virtual machine (VM).
  - Alliance Access, running on an Azure VM. The Alliance Access software contains an embedded Oracle database.
  - SWIFTNet Link (SNL) and SWIFT Alliance Gateway (SAG), running together on an Azure VM.
- **Azure Virtual Network:** Virtual Network forms a private network boundary around the SWIFT deployment. You should choose a network address space that doesn't conflict with your on-premises sites, like back office, Hardware Security Module (HSM), and user sites.
- **Virtual Network subnet:** Alliance Access components should be deployed in separate subnets to allow traffic control between them via Azure network security groups.
- **Azure route table:** You can control network connectivity between Alliance Access VMs and your on-premises sites by using an Azure route table. 
- **Azure Firewall:** Any outbound connectivity from Alliance Access VMs to the internet should be routed by Azure Firewall. Typical examples of such connectivity are time syncs and antivirus definition updates.
- **Azure Virtual Machines:** Virtual Machines provides compute services for running Alliance Access. Use these guidelines for choosing the right SKU:
  - Use a compute-optimized SKU for the Alliance Web Platform front end.
  - Use a memory-optimized SKU for Alliance Access with an embedded Oracle database.
- **Azure managed disks:** If you use Premium SSD managed disks, Alliance Access components get high-throughput, low-latency disk performance. The components can also back up and restore disks that are attached to VMs.
- **Azure proximity placement groups:** Customers can consider using Azure [proximity placement groups](/azure/virtual-machines/co-location) to ensure that all Alliance Access VMs are close to each other. Proximity placement groups reduce network latency between Alliance Access components.

SWIFT customers establish an enhanced-security connection from their on-premises or colocation site to the Alliance Access subscription.

- ExpressRoute can be used to connect the customer's premises to Azure over a private connection.
- Site-to-site VPN can be used to connect the customer's premises to Azure over the internet.
- Remote Desktop Protocol (RDP) can be used over the internet to connect customers. (Alternatively, Azure Bastion can be used for these connections.) The customer's Azure environment can be peered.

[![Diagram that shows three connectivity methods.](media/secure-zone-alliance-connect-virtual.png)]

The SWIFT customer's business and application systems can connect with Alliance Access VMs as shown in the previous diagram. However, business users can connect only to the Alliance Web Platform. The recommended Azure firewall and Azure network security group are configured to allow only appropriate traffic to pass to the Alliance Web Platform.

### Components  

- [Virtual Network](https://azure.microsoft.com/products/virtual-network)  
- [Virtual Machines](https://azure.microsoft.com/products/virtual-machines)  
- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall) 
- [Azure managed disks](https://azure.microsoft.com/products/storage/disks)

### Alternatives

This architecture shows all SWIFT components running on Azure, except for HSM. You can also run SWIFT [Alliance Access with the Alliance Connect](swift-alliance-access-on-azure.yml) networking solution on Azure.

## Scenario details

Alliance Access is one of the messaging interfaces that SWIFT offers for enhanced-security financial messaging.

### Potential use cases

This solution is optimal for the finance industry.

This approach is intended for both existing and new SWIFT customers. It can be used for the following scenarios:

- Migrating Alliance Access from on-premises to Azure
- Creating a new Alliance Access environment on Azure

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

If you want more information about the following considerations, your account team at Microsoft can help guide your Azure implementation of SWIFT.

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

When you deploy SWIFT components on-premises, you need to make decisions about availability and resiliency. For on-premises resiliency, we recommend that you deploy components into at least two datacenters. This approach helps prevent a datacenter failure from compromising your business. The same considerations apply on Azure, although some different concepts apply.

Alliance Access/Entry and Alliance Web Platform with the embedded database can be deployed into an Azure cloud infrastructure. The Azure infrastructure needs to comply with the corresponding application's requirements for performance and latency.

For the database recovery process, refer to the Alliance Access administration guide, section 14. You can get this guide on the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

#### Azure resiliency concepts

Azure provides service level agreements (SLAs) for VM availability. These SLAs vary, depending on whether you deploy a single VM, multiple VMs in an [availability set](/azure/virtual-machines/availability-set-overview), or multiple VMs spread over multiple [availability zones](/azure/reliability/availability-zones-overview). To mitigate the risk of a regional outage, you should deploy SWIFT Alliance Access in multiple Azure regions.
 
For more information, see [Availability options for Azure Virtual Machines](/azure/virtual-machines/availability).