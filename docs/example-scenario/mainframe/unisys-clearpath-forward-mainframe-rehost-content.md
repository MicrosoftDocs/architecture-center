<!-- cSpell:ignore Unisys ClearPath postmigration HDDs Tmax tmaxsoft openframe replatforming replatformed -->

The Unisys mainframe systems trace their lineage back to the first commercially available mainframes. The Unisys ClearPath Forward (CPF) Dorado (2200) and Libra (Master Control Program) systems are full-featured mainframe operating environments. They can scale vertically to handle mission-critical workloads. These systems can be emulated, converted, or modernized into Azure. Azure provides similar or improved performance characteristics and service-level agreement metrics.

This article describes how to use virtualization technologies from Unisys, a Microsoft partner, with a legacy Unisys CPF Libra mainframe. This approach helps you quickly migrate the mainframe to Azure. It eliminates the need to rewrite or recompile the application code or redesign the database architecture. Legacy code is maintained in its original form. The application screens, user interactions, and underlying data structures are unchanged, which eliminates the need to retrain your users.

Unisys replatforming lifts the entire Libra system from today's proprietary hardware to Azure as a virtual machine (VM). The Master Control Program (MCP) OS and all processors, libraries, and data appear just as they did on the proprietary environment. The software series MCP OS requires a license from Unisys. This architecture includes support VMs, which manage functions like virtual tape server operations and automation and workload management (OpCon). These VMs also handle web services and other support functions.

The benefit of this approach is a rapid move to Azure compared to other methodologies. You don't incur hardware maintenance and facility costs, so there's a quick return on investment (ROI). There's also no cost associated with retraining users or programmers because the MCP environment is unchanged.

Depending on the client's goal, the transitioned MCP is the final state or a first step toward modernizing applications within the MCP environment or within Azure. This migration approach lets you plan a measured path to update applications. It retains the investment that you made in existing application code. After conversion, you can also use other Azure data analytic services.

## Architecture

The following architecture diagram shows a typical, on-premises Unisys CPF Libra (MCP) mainframe before migration to Azure.

:::image type="complex" border="false" source="./media/unisys-clearpath-forward-mainframe-rehost-diagram-premigration.svg" alt-text="Diagram that shows a typical on-premises mainframe architecture on Unisys CPF Libra." lightbox="./media/unisys-clearpath-forward-mainframe-rehost-diagram-premigration.svg":::
   The diagram shows a typical on-premises mainframe architecture on Unisys CPF Libra. Arrows point from two user icons to a box that contains various operations in the mainframe. One icon represents on-premises admin users, who access the system via a terminal emulator. The other icon represents on-premises web interface users, who access the system via TLS port 443. Arrows also connect two icons that represent system output devices to the mainframe. The mainframe box contains smaller boxes for communications, integration middleware, operations and monitoring, the printer subsystem, application servers, and file and DBMS facilities.
:::image-end:::

The following architecture diagram shows how to apply Unisys virtualization technologies to the legacy Unisys CPF Libra mainframe.

:::image type="complex" border="false" source="./media/unisys-clearpath-forward-mainframe-rehost-diagram-postmigration.svg" alt-text="Diagram that shows a mainframe architecture after virtualization in Azure." lightbox="./media/unisys-clearpath-forward-mainframe-rehost-diagram-postmigration.svg":::
   The diagram shows the architecture and components of a mainframe architecture after virtualization in Azure. A dotted line divides the diagram into two main sections, on-premises and Azure. In the on-premises section, a user icon represents an on-premises user. The on-premises section also contains two icons that represent legacy system output devices. A solid line connects an icon that represents Azure ExpressRoute to the on-premises user, the legacy devices, and a peer virtual network that's in the Azure section. The Azure section also contains icons that represent various operations that have been migrated to external VMs. A line connects these icons to Azure Private Link for Azure Storage accounts. Another line connects the Storage accounts to a box that contains various systems on a Windows Server virtual machine. These systems include communications, integration middleware, operations and monitoring, application servers, file and DBMS facilities, and the MCP operating system. A box labeled Azure Site Recovery encompasses all of these components.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-premigration-3-6-25.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagrams. The first three steps correspond to both diagrams to highlight the similarities between the original and migrated states of the system.

1. A web browser to access system resources in Azure replaces legacy Burroughs terminal emulation for on-demand and online users. Users access web-based applications via Transport Layer Security (TLS) port 443. The web-based applications presentation layer is unchanged to minimize the need to retrain users. If retraining users isn't a concern, you can update the web application presentation layer with modern UX frameworks. For admin access to the VMs, use [Azure Bastion hosts](https://azure.microsoft.com/products/azure-bastion/) to minimize open ports and improve security.

1. Printers and other legacy system output devices are supported if they're attached to the Azure network via an IP address. Print functions on MCP are retained so that no application changes are needed.

1. Operations are moved out of the MCP to an external VM. More automation can be achieved by using an OpCon VM in the ecosystem to monitor and control the entire environment.

1. If physical tapes are in use, they're converted to virtual tape. Tape formatting and read/write functionality are retained. The tapes are written to Azure or offline storage. Tape functionality is maintained, which eliminates the need to rewrite source code. The benefits of using this method include [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/) accounts for backup of virtual tape files and faster access times because input/output operations are conducted directly against disk media.

1. The MCP storage construct can be mapped onto Azure Storage. This approach maintains the MCP drive mapping naming conventions. No application or operations changes are needed.

1. [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery/) provides disaster recovery (DR) capabilities. It mirrors the Azure VMs to a secondary Azure region for quick failover if an Azure datacenter fails.

### Components

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is one of several types of on-demand, scalable computing resources that Azure provides. An Azure VM gives you the flexibility of virtualization without having to buy and maintain the physical hardware. In this architecture, Virtual Machines hosts the Unisys CPF Libra workloads. This approach helps ensure a seamless transition from proprietary hardware to Azure.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources, such as Virtual Machines, to more securely communicate with each other, the internet, and on-premises networks. Virtual Network is similar to a traditional network that you operate in your own datacenter, but it includes the benefits of Azure infrastructure, such as scale, availability, and isolation. In this architecture, Virtual Network facilitates communication between the migrated Unisys CPF Libra workloads and other Azure services. 

- [Virtual Network interface cards](/azure/virtual-network/virtual-networks-overview) enable an Azure VM to communicate with online, Azure, and on-premises resources. In this architecture, you can add more network interface cards to the same Azure VM. This setup enables Solaris child VMs to each have a dedicated network interface device and IP address.

- [Azure managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes managed by Azure and used with Virtual Machines. The available types of disks are Azure Ultra Disk Storage, Azure Premium SSD, and Azure Standard SSD. For this architecture, we recommend either Premium SSD or Ultra Disk Storage to ensure high performance and reliability for the migrated workloads.

- [Azure Files](/azure/well-architected/service-guides/azure-files) provides fully managed file shares in the cloud that are accessible by using the industry-standard Server Message Block protocol. Cloud or on-premises deployments of Windows, Linux, and macOS can mount Azure file shares concurrently. Azure Files supports the migrated workloads by providing reliable and scalable file storage.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends your on-premises networks into the Microsoft Cloud over a private connection that a connectivity provider facilitates. Use ExpressRoute to establish connections to Microsoft cloud services, such as Azure and Microsoft 365. This approach makes connectivity between the migrated Unisys CPF Libra workloads and on-premises resources more secure and reliable. 

- [Site Recovery](/azure/site-recovery/site-recovery-overview) enables workloads to be replicated from a primary location to a secondary location. This architecture uses Site Recovery to ensure system availability and consistency for the migrated workloads.

## Scenario details

This scenario provides context for migrating Unisys CPF Libra workloads to Azure by using virtualization technologies from Unisys. The primary goal is to achieve a rapid and low-risk transition to Azure while maintaining the existing application code and user interactions. This approach eliminates the need to rewrite application code or redesign the database architecture and helps ensure a seamless transition for users and programmers.

The customer's goals are to:

- Rapidly migrate Unisys CPF Libra workloads to Azure.
- Minimize the risks associated with the migration process.
- Maintain existing application code and user interactions.
- Reduce hardware maintenance and facility costs.
- Achieve a quick ROI.

The benefits of implementing this solution include:

- Rapid migration to Azure compared to other methodologies.
- Elimination of hardware maintenance and facility costs.
- No cost associated with retraining users and programmers.
- Retention of investment in existing application code.
- Potential for further modernization of applications within the MCP environment or within Azure.

### Potential use cases

- Move existing Unisys CPF Libra workloads to Azure rapidly and with low risk.
- Use [Azure Arc](https://azure.microsoft.com/products/azure-arc/) to enable Azure to become a DR environment for an existing on-premises workload.
- Add Azure data services to existing client capabilities.
- Establish supplemental development and test environments for coding, application testing, and training purposes.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Unisys CPF in Azure uses Site Recovery to ensure system availability and consistency. Site Recovery establishes a baseline for backup systems or for DR purposes. You can think of the Site Recovery baseline as your DR system's blueprint that shows the environment's fully functional state. Site Recovery enables Azure region-to-region failover for DR if a primary region outage occurs. DR capabilities mirror the Azure VMs to a secondary Azure region. These capabilities ensure a quick failover if an Azure datacenter failure occurs.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Unisys CPF is inherently a highly secure system. The added value of Azure security measures with encryption of data at rest improves security for enterprise solutions.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Unisys CPF in Azure eliminates hardware maintenance and upfront facility costs. You save even more by not having to retrain staff to operate or use the system. The virtualized computer runs exactly as it did on the datacenter floor.

You can also optimize your costs by following the process to right-size the capacity of your VMs in the beginning and resize them as needed. For more information, see the Well-Architected Framework's [Cost Optimization design principles](/azure/well-architected/cost-optimization/principles).

To estimate the cost of Azure products and configurations, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/). VMs are used for the MCP. Supporting VMs are used for print or tape. Storage account types can range from premium SSD storage to standard blob storage, depending on your performance needs and data retention policies.

For more information about Unisys CPF offerings and pricing, see the [Unisys CPF solution catalog](https://www.unisys.com/solutions/clearpath-forward/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Unisys demonstrates Operational Excellence by presenting a known environment to the staff while introducing new capabilities like Site Recovery to provide DR failover.

You can optimize operational efficiency by deploying your solution with Azure Resource Manager templates and by using Azure Monitor to measure and improve performance. For more information, see [DevOps architecture design](/azure/architecture/guide/devops/devops-start-here) and [Monitoring for DevOps](/devops/operate/what-is-monitoring).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Unisys provides Gold, Platinum, and Titanium offerings to match client workload to operational needs. These offerings parallel operational performance in Azure. Unisys virtualization on Azure enhances performance efficiency through Azure Monitor and [Performance Diagnostics](/troubleshoot/azure/virtual-machines/windows/how-to-use-perfinsights). These tools enable real-time optimization and proactive problem resolution to improve workload management.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.* 

Principal author:

 - [Philip Brooks](https://www.linkedin.com/in/philipbbrooks/) | Senior TPM

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, see the following resources:

- [Azure mainframe and midrange migration](https://azure.microsoft.com/solutions/migration/mainframe/)
- [Mainframe rehosting on Azure virtual machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)
- [Unisys cloud migration services](https://www.unisys.com/solutions/cloud-management/)
- [Unisys documentation libraries](https://public.support.unisys.com/common/epa/documentationlibraries.aspx)
- [Virtual Network documentation](/azure/virtual-network)
- [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface)
- [What is Azure Files?](/azure/storage/files/storage-files-introduction)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [Azure Database Migration Guides](https://datamigration.microsoft.com)

## Related resources

- [Unisys CPF OS 2200 enterprise server virtualization on Azure](../../mainframe/virtualization-of-unisys-clearpath-forward-os-2200-enterprise-server-on-azure.yml)
- [SMA OpCon in Azure](../../example-scenario/integration/sma-opcon-azure.yml)
- [Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)
- [Micro Focus Enterprise Server on Azure VMs](./micro-focus-server.yml)
- [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
