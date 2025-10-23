This article describes how to use virtualization technologies from Unisys, a Microsoft partner, with an existing Unisys ClearPath Forward (CPF) Dorado enterprise server. Use this approach to quickly move your system to Azure without having to rewrite your application code or redesign your database. Existing code is maintained in its original form. The application screens, user interactions, and data structures behind the scenes stay the same, which eliminates the need to retrain your users.

## Architecture

The following **example source premigration architecture** illustrates a typical, on-premises Unisys CPF Dorado (2200) enterprise server.

:::image type="complex" border="false" source="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-premigration.svg" alt-text="Diagram that shows the premigration architecture." lightbox="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-premigration.svg":::
   The image is divided into several sections that represent various components and their interactions. Each section uses labels and arrows to highlight the flow of data. The on-premises datacenter includes on-premises admin users and on-premises web interface users who access the system via web browsers over TLS 1.3, port 443. Solid arrows point from both user types to Unisys ClearPath Forward Dorado (Series 2200) and its components. This section is divided into several subsections. The Communications subsection includes communication standards such as IPv4, IPv6, SSL/TLS, TP0, Telnet, FTP, and sockets. The Integration middleware subsection includes three sections: loosely coupled middleware, environment integrators, and other middleware. The Operations and monitoring subsection includes the monitoring and operations server. The Printer subsystem section includes only the printer subsystem. The Application servers section contains icons that represent Batch, TIP (transaction management), and two boxes labeled Application (COBOL, C, Fortran, PLUS, MASM). The File and DBMS facilities section contains an icon for RDMS/DMS that reads Hierarchical database system, XA compliant. The final subsection is OS 2200 operating system. External printers point to the printer subsystem.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-premigration.vsdx) of this architecture.*

The following **example Azure postmigration architecture** uses virtualization technologies from Unisys that are related to the Unisys CPF Dorado enterprise server.

:::image type="complex" border="false" source="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-postmigration.svg" alt-text="Diagram that shows the postmigration architecture." lightbox="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-postmigration.svg":::
   The image is divided into several sections that represent various components and their interactions. Each section uses labels and arrows to highlight the flow of data. The Azure ExpressRoute icon has a line that points to Peer virtual network and then to Unisys SAIL virtual machine. Section one depicts the on-premises infrastructure. It includes on-premises admin and web interface users, web browsing via TLS over port 443, and Azure Bastion host TLS over port 443. Section two includes icons that represent the printer system. Azure ExpressRoute connects to section one and two. Section three includes several icons that represent Windows or Linux virtual machines. It also includes an icon that represents Private link for Azure storage accounts. Two lines point from this icon to the Azure storage icons in step four and step five. Another line points from this icon to a subsection in the Integration middleware section labeled Other middleware, which is a component in the Unisys SAIL virtual machine. This virtual machine also contains the following sections. The Communications section contains a Communication standards subsection with components that include IPv4, IPv6, SSL/TLS, TP0, Telnet, FTP, and sockets. The Integration middleware section includes loosely coupled middleware, environment integrators, and other middleware sections. The Operations and monitoring section includes the monitoring and operations server subsection. The Printer subsystem section contains only the printer subsystem. The Application servers subsection includes icons that represent Batch, TIP (transaction management), four boxes labeled TX, and two boxes labeled Application (COBOL, C, Fortran, PLUS, MASM). The File and DBMS facilities subsection contains an icon for RDMS/DMS labeled Hierarchical database system, XA compliant. The final subsection is the OS 2200 operating system.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-postmigration.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

Numbered callouts one, two, and three are used in both diagrams to highlight the similarities between the before states and the after states of the system.

1. User access is provided over transport layer security (TLS) port 443 for accessing web-based applications. The web-based applications presentation layer can remain the same to minimize customer retraining. Alternatively, you can update the web application presentation layer with modern UX frameworks. For administrator access to the virtual machines (VMs), you can use [Azure Bastion hosts](https://azure.microsoft.com/services/azure-bastion/) to maximize security by minimizing open ports.

1. Printers and other system output devices are supported if they're attached to the Azure network via an IP address. Print functions on Dorado are retained so that application changes aren't needed.

1. The operations function is moved out of the Dorado enterprise server to an Azure VM. You can implement more automation by using an OpCon VM in the ecosystem to monitor and control the environment.

1. If physical tapes are in use, they're converted to virtual tapes. Tape formatting and read and write functionality are retained. The tapes are written to Azure or offline storage. Tape functionality is maintained, which eliminates the need to rewrite source code. Benefits include [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) accounts for backup of virtual tape files and faster access times because input/output operations are conducted directly against disk media.

1. The Dorado storage construct is mapped onto Azure storage. This mapping maintains the Dorado disk drive naming convention. No application or operations changes are needed.

### Components

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is one of several types of on-demand, scalable computing resources that Azure provides. In this architecture, an Azure VM gives you the flexibility of virtualization without the need to buy and maintain physical hardware. The VM hosts the Unisys CPF OS 2200 enterprise server and performs the same function as the on-premises physical or virtual hardware that hosts the server.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service and the fundamental building block for your private network in Azure. In this architecture, Virtual Network enables many types of Azure resources, such as VMs, to more securely communicate with each other, the internet, and on-premises networks. Virtual Network operates like a traditional network in your datacenter but takes advantage of Azure infrastructure benefits, such as scalability, availability, and isolation. [Network interface cards (NICs)](/azure/virtual-network/virtual-network-network-interface) enable a VM to communicate with the internet, Azure, and on-premises resources. This capability replicates the functionality of an on-premises network infrastructure. For example, you can add more NICs to the same VM, which allows the Solaris child VMs to have their own dedicated network interface device and IP address.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that you can use to extend your on-premises networks into the Microsoft Cloud via a private connection from a connectivity provider. In this architecture, ExpressRoute provides a private connection between the on-premises networks and Azure or Microsoft 365. It allows highly secure and reliable connectivity for the migrated Unisys CPF OS 2200 enterprise server.

- [Azure Site Recovery](/azure/site-recovery/) is a disaster recovery (DR) solution that helps ensure business continuity by enabling Azure region-to-region failover during primary region outages. In this architecture, Site Recovery DR capabilities mirror the Azure VMs to a secondary Azure region. These capabilities facilitate a quick failover if an Azure datacenter failure occurs.

### Alternatives

The Unisys virtualization of the OS 2200 environment provides a *lift and shift* approach to transitioning to Azure. Data, processes, and application code are all maintained and transferred to Azure. Testing is minimal because all applications are carried over from the mainframe.

Other ways to transfer data and processes to Azure include:

- Refactoring the application code to C# or Java by using automated tools. This solution transfers the application's capabilities while converting the code into an Azure-native format. This solution takes longer to implement and requires thorough testing to help ensure maintained functionality.

- Rewriting the application code to the language of your choice. This solution is typically the most time-consuming and costly approach. Code is rewritten to account for the application needs. New functionality can be added. This solution requires thorough testing to help ensure that the new code performs as expected.

## Scenario details

The Unisys enterprise servers trace their heritage to the first commercially available enterprise servers. The Unisys CPF Dorado OS 2200 system is a full-featured enterprise server operating environment. It can scale vertically to handle mission-critical workloads. You can emulate, convert, or modernize the system into Azure. Azure provides similar or improved performance characteristics and service-level agreement metrics.

A Unisys transition moves the entire Dorado system from today's hardware to Azure via a VM. The 2200 Exec OS and all processors, libraries, and data appear as they did on the physical environment. The OS requires a license from Unisys. The architecture includes support VMs, which handle functions such as virtual tapes operations, automation and workload management (OpCon), web services, and other support functions. The architecture also uses Azure storage features, including:

- [Azure managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes that Azure manages and Virtual Machines uses. The available types of disks are Azure Ultra Disks, Azure Premium SSDs, and Azure Standard SSDs. For this architecture, you should use either Premium SSDs or Ultra Disk SSDs.

- [Azure Files](https://azure.microsoft.com/services/storage/files/) is a service that you can use to fully manage file shares in the cloud that are accessible by using the industry-standard Server Message Block protocol. Cloud or on-premises deployments of Windows, Linux, and macOS can mount Azure file shares concurrently.

This approach provides a faster transition to Azure compared to other methods. Because hardware maintenance and facility costs are reduced, there's a quick return on investment. And because the Dorado environment remains the same, there's no cost associated with retraining users and programmers.

Depending on your end goal, a transition can be the end state or a first step toward application modernization within the Dorado environment or within Azure. This approach provides a measured, planned path for updating applications and retains the investment in the existing application code. After conversion is complete, you can use other Unisys and Azure data analytic services.

### Potential use cases

- Move existing Unisys CPF Dorado workloads to Azure quickly and minimize risk during the migration.

- Use [Azure Arc](https://azure.microsoft.com/services/azure-arc/) to create a DR plan for an existing on-premises workload.

- Add Azure data services to existing client capabilities.

- Use Azure-based CPF to serve as a DR, test, or development environment without the need for more hardware or facility resources.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Unisys CPF in Azure uses Site Recovery to promote system availability and consistency. Site Recovery enables Azure region-to-region failover for DR if a primary region outage occurs. DR capabilities mirror the Azure VMs to a secondary Azure region. These capabilities facilitate a quick failover if an Azure datacenter failure occurs.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Unisys CPF is a highly secure system, and Azure enhances this security by adding a layer of encryption for data at rest.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Unisys CPF in Azure eliminates hardware maintenance and facility costs up front. Further savings derive from not having to retrain staff on how to use the system. The virtualized computer runs as it did on the datacenter floor.

You can also optimize your costs by following the process to rightsize the capacity of your VMs from the start, along with simplified resizing as needed. For more information, see [Principles of Cost Optimization](/azure/architecture/framework/cost/overview).

To estimate the cost of Azure products and configurations, see [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

To learn more about Unisys CPF offerings and pricing, see [Unisys CPF products](https://www.unisys.com/solutions/clearpath-forward/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Unisys demonstrates operational excellence by maintaining a familiar environment to the staff, while including new services like Site Recovery to provide DR failover.

You can optimize your operational efficiency by deploying your solution with Azure Resource Manager templates and by using Azure Monitor to measure and improve your performance. For more information, see [DevOps architecture design](/azure/architecture/guide/devops/devops-start-here).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Unisys provides operational performance in Azure through its Bronze, Silver, Gold, Platinum, and Titanium tiers that are tailored to match the client workload to operational needs. Unisys virtualization on Azure enhances performance efficiency through Azure Monitor and [the Performance Diagnostics CLI tool](/troubleshoot/azure/virtual-machines/windows/how-to-use-perfinsights). These tools enable real-time optimization and proactive problem resolution for improved workload management.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Philip Brooks](https://www.linkedin.com/in/philipbbrooks/) | Senior Program Manager
- [Adam Gallagher](mailto:Adam.Gallagher@Unisys.com) | Senior Solution Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, contact **[legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com)**, or see the following resources:

- [Azure mainframe and midrange migration](https://azure.microsoft.com/migration/mainframe)
- [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface)
- [ExpressRoute documentation](/azure/expressroute/expressroute-introduction)
- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [Mainframe rehosting on Virtual Machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)
- [SMA OpCon in Azure](/azure/architecture/example-scenario/integration/sma-opcon-azure)
- [Unisys cloud management](https://www.unisys.com/solutions/cloud-management)
- [Unisys CPF MCP mainframe rehost to Azure by using Unisys virtualization](/azure/architecture/example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost)
- [Unisys cybersecurity](https://www.unisys.com/solutions/cybersecurity-solutions)
- [Virtual Network documentation](/azure/virtual-network)

## Related resources

- [Azure database migration guides](/data-migration)
- [Mainframe file replication and synchronization on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)
- [Modernize mainframe and midrange data](/azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure)
