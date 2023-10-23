This article shows how to use virtualization technologies from Unisys, a Microsoft partner, with an existing Unisys ClearPath Forward (CPF) Dorado Enterprise Server. This approach allows an accelerated move into Azure and eliminates the need to rewrite the application code or redesign the database architecture. Existing code is maintained in its original form. The application screens, user interactions, and data structures behind the scenes are unchanged, which eliminates the need to retrain your users.

## Architecture

**Example source (premigration) architecture**: The following architecture illustrates a typical, on-premises Unisys ClearPath Forward Dorado (Sperry 1100/2200) Enterprise Server.

:::image type="content" source="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-premigration.svg" alt-text="Diagram of the premigration architecture." lightbox="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-premigration.svg" border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-premigration.vsdx) of this architecture.*

**Example Azure (postmigration) architecture**: The following architecture illustrates an example utilizing virtualization technologies from Unisys with respect to the Unisys CPF Dorado Enterprise Server.

:::image type="content" source="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-postmigration.svg" alt-text="Diagram of the postmigration architecture." lightbox="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-postmigration.svg" border="false":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-postmigration.vsdx) of this architecture.*

## Workflow

Numeric callouts 1, 2, and 3 are used in both diagrams to highlight the similarities between the before and after states of the system.

1. User access is provided over TLS port 443 for accessing web-based applications. The web-based applications presentation layer can be kept unchanged to minimize customer retraining. On the other hand, the web-application presentation layer can be updated with modern UX frameworks if desired. Further, for admin access to the virtual machines (VMs), [Azure Bastion hosts](https://azure.microsoft.com/services/azure-bastion/) can be used to maximize security by minimizing open ports.
1. Printers and other system output devices are supported as long as they're IP attached to the Azure network. Print functions on Dorado are retained so that application changes aren't needed.
1. The Operations function is moved out of the Dorado Enterprise Server to an Azure VM. You can achieve more automation by using an OpCon VM in the ecosystem to monitor and control the entire environment.
1. If physical tapes are in use, they're converted to virtual tape. Tape formatting and read and write functionality are retained. The tapes are written to Azure or offline storage. Tape functionality is maintained, eliminating the need to rewrite source code. Benefits include [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) accounts for backup of virtual tape files and faster access times because IO operations are conducted directly against disk media.
1. The Dorado storage construct is mapped onto Azure storage, maintaining the Dorado disk drive nomenclature. No application or operations changes are needed.
1. [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) provides disaster recovery capabilities by mirroring the Azure VMs to a secondary Azure region. Providing these capabilities allows for quick failover in the rare case of an Azure datacenter failure.

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) is one of several types of on-demand, scalable computing resources that Azure offers. An Azure virtual machine gives you the flexibility of virtualization without you having to buy and maintain physical hardware.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources, such as Azure Virtual Machines, to securely communicate with each other, the internet, and on-premises networks. Virtual Network is similar to a traditional network that you'd operate in your own datacenter but with the added benefits of Azure's infrastructure, such as scale, availability, and isolation. [Network interface cards (NICs)](/azure/virtual-network/virtual-network-network-interface) enable a VM to communicate with internet, Azure, and on-premises resources. For example, you can add more NICs to the same VM, which allows the Solaris child-VMs to have their own dedicated network interface device and IP address.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/) lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365.
- [Azure Site Recovery](/azure/site-recovery/) enables Azure region-to-region failover for disaster recover if a primary region outage occurs.

## Alternatives

The Unisys virtualization of the OS2200 environment provides a *lift and shift* approach to transitioning to Azure. Data, processes, and application code are all maintained and brought to Azure. Testing is minimal because all applications are carried over from the mainframe.

For other paths to Azure, you can:

- Refactor the application code to C# or Java by using automated tools. This path moves the functionality but provides for a code base in an Azure native form. This path is longer to implement and requires thorough testing to ensure a maintained functionality.
- Rewrite the application code to the language of your choice. This path is usually the longest and most expensive solution. Code is rewritten to account for the application needs. New functionality can be added. This path requires thorough testing to ensure that the new code performs as expected.

## Scenario details

The Unisys Enterprise Servers trace their heritage to the first commercially available enterprise servers. The Unisys CPF Dorado (Sperry 1100/2200) and Libra (Burroughs A Series/Master Control Program) systems are full-featured enterprise server operating environments. They can scale vertically to handle mission-critical workloads. You can emulate, convert, or modernized these systems into Azure. Azure offers similar or even improved performance characteristics and service-level agreement (SLA) metrics.

A Unisys transition lifts the entire Dorado system from today's hardware to Azure as a VM. The 2200 Exec OS and all processors, libraries, and data appear as they did on the physical environment. The OS requires a license from Unisys. The architecture includes support VMs, which handle functions such as virtual tapes operations, automation and workload management (OpCon), web services, and other support functions. The architecture also uses Azure storage features, including:

- [Azure SSD managed disks](/azure/virtual-machines/managed-disks-overview): block-level storage volumes managed by Azure and used with Azure Virtual Machines. The available types of disks are ultra disks, premium solid-state drives (SSDs), standard SSDs, and standard hard disk drives (HDDs). For this architecture, you should use either premium SSDs or ultra disk SSDs.
- [Azure Files](https://azure.microsoft.com/services/storage/files/): fully managed file shares in the cloud that are accessible by using the industry-standard Server Message Block (SMB) protocol. Cloud or on-premises deployments of Windows, Linux, and macOS can mount Azure file shares concurrently.

The benefit of this approach is a rapid move to Azure compared to other methodologies. Because hardware maintenance and facility costs are dropped, there's a quick return on investment (ROI). Because the Dorado environment is unchanged, there's no cost associated with retraining users and programmers.

Depending upon the client's end goal, the transitioned Azure Dorado could be the end state or a first step toward modernizing applications within the Dorado environment or within Azure. This approach to landing in Azure permits a measured, planned path to updating applications. It retains the investment made in the existing application code. After conversion, other Unisys Cloud Forte and Azure data analytic services can be employed as well.

## Potential use cases

- Moving existing Unisys ClearPath Forward Dorado workloads to Azure rapidly, with low risk.
- Using [Azure Arc](https://azure.microsoft.com/services/azure-arc/) so Azure can become the disaster recovery (DR) plan for an existing on-premises workload.
- Adding Unisys Cloud Forte or Azure data services to existing client capabilities.
- Using Azure based CPF to serve as a DR, test, or development environment without the need for more hardware or facility resources.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Unisys CPF in Azure uses Site Recovery to ensure system availability and consistency.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Unisys CPF is a very secure system on its own. Azure adds a layer of encryption for data at rest and in motion.

Unisys Stealth technology hides endpoints. Azure offers other security controls.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/C:/azure/architecture/framework/cost/overview).

Unisys CPF in Azure eliminates hardware maintenance and facility costs upfront. Further savings derive from not having to retrain staff on how to operate or use the system. The virtualized computer runs as it did on the datacenter floor.

You can also optimize your costs by following the process to right-size the capacity of your VMs from the beginning, along with simplified resizing as needed. For more information, see the Azure Well-Architected Framework's [Principles of cost optimization](/azure/architecture/framework/cost/overview).

To estimate the cost of Azure products and configurations, visit the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

To learn more about Unisys CPF offerings and pricing, visit the [Unisys ClearPath Forward Products webpage](https://www.unisys.com/offerings/clearpath-forward/clearpath-forward-products).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Unisys demonstrates operational excellence by presenting a known environment to the staff, while including new capabilities like Azure Site Recovery to provide DR failover.

You can optimize your operational efficiency by deploying your solution with Azure Resource Manager templates, and by using Azure Monitor to measure and improve your performance. See the Azure Well-Architected Framework's [Operational excellence principles](/azure/architecture/framework/devops/principles) and [Monitoring for DevOps](/azure/architecture/framework/devops/checklist).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/C:/azure/architecture/framework/scalability/overview).

Unisys matches operational performance in Azure with Developer Studio, Gold, and Platinum offerings to match client workload to operational needs. Developer Studio Gold and Platinum offerings quicken the generation of tasks including new code development, queries, report generation, and other tasks.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors

- [Philip Brooks](http://linkedin.com/in/philipbbrooks) | Senior Program Manager
- Adam Gallagher (Adam.Gallagher@Unisys.com) | Senior Solution Manager

## Next steps

For more information, please contact [**legacy2azure@microsoft.com**](mailto:legacy2azure@microsoft.com), or check out the following resources:

- [Unisys ClearPath Forward MCP mainframe rehost to Azure using Unisys virtualization](/azure/architecture/example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost)
- [SMA OpCon in Azure](/azure/architecture/solution-ideas/articles/sma-opcon-azure)
- [Azure Mainframe and midrange migration](https://azure.microsoft.com/migration/mainframe)
- [Mainframe rehosting on Azure virtual machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)
- [Unisys CloudForte for Azure in the Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/unisys-azuremp-stealth.cloudforte_for_azure?tab=Overview)
- [Unisys Cloud Management](https://www.unisys.com/solutions/cloud-management)
- [Unisys Cybersecurity](https://www.unisys.com/solutions/cybersecurity-solutions)
- [Azure Virtual Network documentation](/azure/virtual-network)
- [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface)
- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [What is Azure Files?](/azure/storage/files/storage-files-introduction)
- [Azure ExpressRoute documentation](/azure/expressroute/expressroute-introduction)

## Related resources

- [Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)
- [Azure Database Migration Guides](/data-migration/)
- [Modernize mainframe and midrange data](/azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure)