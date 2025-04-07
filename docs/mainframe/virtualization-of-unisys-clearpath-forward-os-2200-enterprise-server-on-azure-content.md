This article describes how to use virtualization technologies from Unisys, a Microsoft partner, with an existing Unisys ClearPath Forward (CPF) Dorado enterprise server. With this approach, you can accelerate your move into Azure and eliminate the need to rewrite the application code or redesign the database architecture. Existing code is maintained in its original form. The application screens, user interactions, and data structures behind the scenes are unchanged, which eliminates the need to retrain your users.

## Architecture

**Example source (premigration) architecture**: The following architecture illustrates a typical, on-premises Unisys CPF Dorado (2200) enterprise server.

:::image type="content" source="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-premigration.svg" alt-text="Diagram of the premigration architecture." lightbox="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-premigration.svg" border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-premigration.vsdx) of this architecture.*

**Example Azure (postmigration) architecture**: The following architecture illustrates an example utilizing virtualization technologies from Unisys related to the Unisys CPF Dorado enterprise server.

:::image type="content" source="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-postmigration.svg" alt-text="Diagram of the postmigration architecture." lightbox="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-postmigration.svg" border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-postmigration.vsdx) of this architecture.*

### Workflow

Numeric callouts 1, 2, and 3 are used in both diagrams to highlight the similarities between the before and after states of the system.

1. User access is provided over TLS port 443 for accessing web-based applications. The web-based applications presentation layer can be kept unchanged to minimize customer retraining. On the other hand, the web application presentation layer can be updated with modern UX frameworks if desired. Further, for admin access to the virtual machines (VMs), [Azure Bastion hosts](https://azure.microsoft.com/services/azure-bastion/) can be used to maximize security by minimizing open ports.
1. Printers and other system output devices are supported as long as they're IP attached to the Azure network. Print functions on Dorado are retained so that application changes aren't needed.
1. The Operations function is moved out of the Dorado enterprise server to an Azure VM. You can implement more automation by using an OpCon VM in the ecosystem to monitor and control the entire environment.
1. If physical tapes are in use, they're converted to virtual tapes. Tape formatting and read and write functionality are retained. The tapes are written to Azure or offline storage. Tape functionality is maintained, eliminating the need to rewrite source code. Benefits include [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) accounts for backup of virtual tape files and faster access times because IO operations are conducted directly against disk media.
1. The Dorado storage construct is mapped onto Azure storage, maintaining the Dorado disk drive nomenclature. No application or operations changes are needed.
1. [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) provides disaster recovery (DR) capabilities by mirroring the Azure VMs to a secondary Azure region. These capabilities ensure a quick failover in the rare case of an Azure datacenter failure.

### Components

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is one of several types of on-demand, scalable computing resources that Azure offers. In this architecture, an Azure VM gives you the flexibility of virtualization without the need to buy and maintain physical hardware. The VM hosts the Unisys ClearPath Forward OS 2200 enterprise server and performs the same function as the on-premises physical or virtual hardware that currently hosts the server.
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for your private network in Azure. In this architecture, Virtual Network enables many types of Azure resources, such as VMs, to securely communicate with each other, the internet, and on-premises networks. Virtual Network is similar to a traditional network that operates in your own datacenter but with the benefit of the Azure infrastructure, such as scale, availability, and isolation. [Network interface cards (NICs)](/azure/virtual-network/virtual-network-network-interface) enable a VM to communicate with the internet, Azure, and on-premises resources, replicating the network infrastructure of the on-premises environment. For example, you can add more NICs to the same VM, which allows the Solaris child VMs to have their own dedicated network interface device and IP address. 
- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. In this architecture, ExpressRoute provides a private connection between the on-premises networks and Azure or Microsoft 365. It allows secure and reliable connectivity for the migrated Unisys ClearPath Forward OS 2200 enterprise server.
- [Azure Site Recovery](/azure/site-recovery/) enables Azure region-to-region failover for disaster recovery (DR) if a primary region outage occurs. In this architecture, Site Recovery DR capabilities mirror the Azure VMs to a secondary Azure region. These capabilities facilitate a quick failover in the rare case of an Azure datacenter failure. 

### Alternatives

The Unisys virtualization of the OS2200 environment provides a *lift and shift* approach to transitioning to Azure. Data, processes, and application code are all maintained and transferred to Azure. Testing is minimal because all applications are carried over from the mainframe.

Other ways to transfer data and processes to Azure include:

- Refactoring the application code to C# or Java by using automated tools. This solution moves the functionality but provides for a code base in an Azure-native form. This solution takes longer to implement and requires thorough testing to ensure maintained functionality.
- Rewriting the application code to the language of your choice. This solution is usually the longest and most expensive solution. Code is rewritten to account for the application needs. New functionality can be added. This solution requires thorough testing to ensure that the new code performs as expected.

## Scenario details

The Unisys enterprise servers trace their heritage to the first commercially available enterprise servers. The Unisys CPF Dorado (2200) system is a full-featured enterprise server operating environment. It can scale vertically to handle mission-critical workloads. You can emulate, convert, or modernize the system into Azure. Azure offers similar or even improved performance characteristics and service-level agreement (SLA) metrics.

A Unisys transition moves the entire Dorado system from today's hardware to Azure via a VM. The 2200 Exec OS and all processors, libraries, and data appear as they did on the physical environment. The OS requires a license from Unisys. The architecture includes support VMs, which handle functions such as virtual tapes operations, automation and workload management (OpCon), web services, and other support functions. The architecture also uses Azure storage features, including:

- [Azure SSD managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes managed by Azure and used with Virtual Machines. The available types of disks are ultra disks, premium SSDs, standard SSDs, and standard HDDs. For this architecture, you should use either premium SSDs or ultra disk SSDs.
- [Azure Files](https://azure.microsoft.com/services/storage/files/) is a service that you can use to fully manage file shares in the cloud that are accessible by using the industry-standard Server Message Block (SMB) protocol. Cloud or on-premises deployments of Windows, Linux, and macOS can mount Azure file shares concurrently.

The benefit of this approach is a rapid move to Azure compared to other methodologies. Because hardware maintenance and facility costs are decreased, there's a quick return on investment (ROI). Because the Dorado environment is unchanged, there's no cost associated with retraining users and programmers.

Depending upon your end goal, a transition can be the end state or a first step toward modernizing applications within the Dorado environment or within Azure. This approach provides a measured, planned path for updating applications. It retains the investment in the existing application code. After conversion, you can use other Unisys and Azure data analytic services.

### Potential use cases

- Move existing Unisys CPF Dorado workloads to Azure rapidly, with low risk.
- Use [Azure Arc](https://azure.microsoft.com/services/azure-arc/) to create a DR plan for an existing on-premises workload.
- Add Azure data services to existing client capabilities.
- Use Azure-based CPF to serve as a DR, test, or development environment without the need for more hardware or facility resources.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Unisys CPF in Azure uses Azure Site Recovery to promote system availability and consistency.  Site Recovery enables Azure region-to-region failover for DR if a primary region outage occurs. DR capabilities mirror the Azure VMs to a secondary Azure region. These capabilities facilitate a quick failover in the rare case of an Azure datacenter failure.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Unisys CPF is a secure system on its own. Azure adds a layer of encryption for data at rest.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Unisys CPF in Azure eliminates hardware maintenance and facility costs up front. Further savings derive from not having to retrain staff on how to operate or use the system. The virtualized computer runs as it did on the datacenter floor.

You can also optimize your costs by following the process to right-size the capacity of your VMs from the beginning, along with simplified resizing as needed. For more information, see the Well-Architected Framework's [Principles of cost optimization](/azure/architecture/framework/cost/overview).

To estimate the cost of Azure products and configurations, visit the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

To learn more about Unisys CPF offerings and pricing, visit [Unisys CPF products](https://www.unisys.com/solutions/clearpath-forward/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Unisys demonstrates operational excellence by presenting a known environment to the staff, while including new services like Azure Site Recovery to provide DR failover.

You can optimize your operational efficiency by deploying your solution with Azure Resource Manager templates and by using Azure Monitor to measure and improve your performance. For more information, see [DevOps architecture design](/azure/architecture/guide/devops/devops-start-here).

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Unisys matches operational performance in Azure with Bronze, Silver, Gold, Platinum, and Titanium offerings to match client workload to operational needs.  Unisys virtualization on Azure enhances performance efficiency through Azure Monitor and [the Performance Diagnostics (PerfInsights) tool](/troubleshoot/azure/virtual-machines/windows/how-to-use-perfinsights). These tools enable real-time optimization and proactive issue resolution for improved workload management.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Philip Brooks](http://linkedin.com/in/philipbbrooks) | Senior Program Manager
- [Adam Gallagher](mailto:Adam.Gallagher@Unisys.com) | Senior Solution Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, contact [**legacy2azure@microsoft.com**](mailto:legacy2azure@microsoft.com), or see the following resources:

- [SMA OpCon in Azure](/azure/architecture/solution-ideas/articles/sma-opcon-azure)
- [Unisys cloud management](https://www.unisys.com/solutions/cloud-management)
- [Unisys CPF MCP mainframe rehost to Azure using Unisys virtualization](/azure/architecture/example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost)
- [Azure ExpressRoute documentation](/azure/expressroute/expressroute-introduction)
- [Azure mainframe and midrange migration](https://azure.microsoft.com/migration/mainframe)
- [Azure Virtual Network documentation](/azure/virtual-network)
- [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface)
- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [Mainframe rehosting on Azure Virtual Machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)
- [Unisys cybersecurity](https://www.unisys.com/solutions/cybersecurity-solutions)

## Related resources

- [Azure database migration guides](/data-migration)
- [Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)
- [Modernize mainframe and midrange data](/azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure)
