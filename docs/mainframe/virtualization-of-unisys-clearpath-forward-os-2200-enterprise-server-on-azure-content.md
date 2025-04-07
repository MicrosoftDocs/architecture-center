This article describes how to use virtualization technologies from Unisys, a Microsoft partner, with an existing Unisys ClearPath Forward (CPF) Dorado enterprise server. You can use this approach to accelerate your move into Azure and eliminate the need to rewrite the application code or redesign the database architecture. Existing code is maintained in its original form. The application screens, user interactions, and data structures behind the scenes are unchanged, which eliminates the need to retrain your users.

## Architecture

**Example source (premigration) architecture:** The following architecture illustrates a typical, on-premises Unisys CPF Dorado (2200) enterprise server.

:::image type="complex" border="false" source="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-premigration.svg" alt-text="Diagram that shows the premigration architecture." lightbox="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-premigration.svg":::
   The image is divided into several sections that represent various components and their interactions. Each section uses labels and arrows to highlight the flow of data. Section 1 represents the on-premises datacenter. It includes on-premises admin users on-premises web interface users who access the system via web browsers over TLS 1.3, port 443. Solid arrows point from both user types to Section 2, which is Unisys ClearPath Forward Dorado (Series 2200). This section is further divided into several subsections. The Communications subsection includes communication standards such as IP, v4, v6, SSL/TLS, TP0, Telnet, FTP, and Sockets. The Integration middleware subsection includes three sections: loosely coupled middleware, environment integrators, and other middleware. The Operations and monitoring subsection includes the monitoring and operations server. The Printer subsystem section includes the printer subsystem. The Application servers section contains icons that represent Batch, TIP (transaction management), and two boxes labeled Application (COBOL, C, Fortran, PLUS, MASM). The File and DBMS facilities section contains an icon for RDMS/DMS that reads Hierarchical database system, XA compliant. The final subsection is OS 2200 operating system.
:::image-end:::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-premigration.vsdx) of this architecture.*

**Example Azure postmigration architecture:** The following architecture illustrates an example that uses virtualization technologies from Unisys that are related to the Unisys CPF Dorado enterprise server.

:::image type="complex" border="false" source="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-postmigration.svg" alt-text="Diagram that shows the postmigration architecture." lightbox="./images/unisys-clearpath-forward-os-2200-mainframe-rehost-diagram-postmigration.svg":::
   The image is divided into several sections that represent various components and their interactions. Each section uses labels and arrows to highlight the flow of data. The Azure ExpressRoute icon has a line that points to Peer virtual network and then to Unisys SAIL virtual machine. Section one depicts the on-premises infrastructure. It includes on-premises admin and web interface users, web browsing via TLS over port 443, and Bastion host TLS over port 443. Connecting lines lead to Section two that includes icons that represent the printer system. Section three includes several icons that represent Windows or Linux Virtual Machine. It also includes an icon that represents Private link for Azure storage accounts. Two lines point from this icon to the Azure storage icons in steps four and steps five. Another line points from this icon to a subsection in the Integration middleware section labeled Other middleware. The Communications section contains a Communication standards subsection with components that include IP v4, IP v6, SSL/TLS, TP0, Telnet, FTP, and Sockets. The Integration middleware section includes loosely coupled middleware, environment integrators, and other middleware sections. The Operations and monitoring section includes the monitoring and operations server subsection. The Printer subsystem section contains the printer subsystem section. The Application servers subsection includes icons that represent Batch, TIP (transaction management), four boxes labeled TX, and two boxes labeled Application (COBOL, C, Fortran, PLUS, MASM). The File and DBMS facilities subsection contains an icon for RDMS/DMS labeled Hierarchical database system, XA compliant. The final subsection is the OS 2200 operating system.
:::image-end:::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/unisys-clearpath-forward-OS-2200-mainframe-rehost-diagram-postmigration.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

Numbered callouts one, two, and three are used in both diagrams to highlight the similarities between the before states and the after states of the system.

1. User access is provided over transport layer security (TLS) port 443 for accessing web-based applications. The web-based applications presentation layer can be kept unchanged to minimize customer retraining. Alternatively, you can update the web application presentation layer with modern UX frameworks. For administrator access to the virtual machines (VMs), you can use [Azure Bastion hosts](https://azure.microsoft.com/services/azure-bastion/) to maximize security by minimizing open ports.

1. Printers and other system output devices are supported as long as they're attached to the Azure network by using an IP address. Print functions on Dorado are retained so that application changes aren't needed.

1. The Operations function is moved out of the Dorado enterprise server to an Azure VM. You can implement more automation by using an OpCon VM in the ecosystem to monitor and control the entire environment.

1. If physical tapes are in use, they're converted to virtual tapes. Tape formatting and read and write functionality are retained. The tapes are written to Azure or offline storage. Tape functionality is maintained, which eliminates the need to rewrite source code. Benefits include [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) accounts for backup of virtual tape files and faster access times because input/output operations are conducted directly against disk media.

1. The Dorado storage construct is mapped onto Azure storage. This mapping maintains the Dorado disk drive nomenclature. No application or operations changes are needed.

1. [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) provides disaster recovery (DR) capabilities by mirroring the Azure VMs to a secondary Azure region. These capabilities ensure a quick failover in the rare case of an Azure datacenter failure.

### Components

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is one of several types of on-demand, scalable computing resources that Azure provides. In this architecture, an Azure VM gives you the flexibility of virtualization without the need to buy and maintain physical hardware. The VM hosts the Unisys CPF OS 2200 enterprise server and performs the same function as the on-premises physical or virtual hardware that currently hosts the server.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service and the fundamental building block for your private network in Azure. In this architecture, Virtual Network enables many types of Azure resources, such as VMs, to more securely communicate with each other, the internet, and on-premises networks. Virtual Network operates like a traditional network in your datacenter but takes advantage of Azure infrastructure benefits, such as scalability, availability, and isolation. [Network interface cards (NICs)](/azure/virtual-network/virtual-network-network-interface) allow a VM to communicate with the internet, Azure, and on-premises resources. This capability replicates the functionality of an on-premises network infrastructure. For example, you can add more NICs to the same VM, which allows the Solaris child VMs to have their own dedicated network interface device and IP address.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that you can use to extend your on-premises networks into the Microsoft cloud via a private connection provided by a connectivity provider. In this architecture, ExpressRoute provides a private connection between the on-premises networks and Azure or Microsoft 365. It allows highly secure and reliable connectivity for the migrated Unisys CPF OS 2200 enterprise server.

- [Site Recovery](/azure/site-recovery/) is a disaster recovery (DR) solution that ensures business continuity by enabling Azure region-to-region failover during primary region outages. In this architecture, Site Recovery DR capabilities mirror the Azure VMs to a secondary Azure region. These capabilities facilitate a quick failover in the rare case of an Azure datacenter failure.

### Alternatives

The Unisys virtualization of the OS2200 environment provides a *lift and shift* approach to transitioning to Azure. Data, processes, and application code are all maintained and transferred to Azure. Testing is minimal because all applications are carried over from the mainframe.

Other ways to transfer data and processes to Azure include:

- Refactoring the application code to C# or Java by using automated tools. This solution moves the functionality but provides for a code base in an Azure-native form. This solution takes longer to implement and requires thorough testing to help ensure maintained functionality.

- Rewriting the application code to the language of your choice. This solution is usually the longest and most expensive solution. Code is rewritten to account for the application needs. New functionality can be added. This solution requires thorough testing to ensure that the new code performs as expected.

## Scenario details

The Unisys enterprise servers trace their heritage to the first commercially available enterprise servers. The Unisys CPF Dorado (2200) system is a full-featured enterprise server operating environment. It can scale vertically to handle mission-critical workloads. You can emulate, convert, or modernize the system into Azure. Azure provides similar or even improved performance characteristics and service-level agreement (SLA) metrics.

An Unisys transition moves the entire Dorado system from today's hardware to Azure via a VM. The 2200 Exec OS and all processors, libraries, and data appear as they did on the physical environment. The OS requires a license from Unisys. The architecture includes support VMs, which handle functions such as virtual tapes operations, automation and workload management (OpCon), web services, and other support functions. The architecture also uses Azure storage features, including:

- [Azure SSD managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes that Azure manages and Virtual Machines uses. The available types of disks are ultra disks, premium SSDs, standard SSDs, and standard HDDs. For this architecture, you should use either premium SSDs or ultra disk SSDs.

- [Azure Files](https://azure.microsoft.com/services/storage/files/) is a service that you can use to fully manage file shares in the cloud that are accessible by using the industry-standard Server Message Block protocol. Cloud or on-premises deployments of Windows, Linux, and macOS can mount Azure file shares concurrently.

The benefit of this approach is a rapid move to Azure compared to other methodologies. Because hardware maintenance and facility costs are decreased, there's a quick return on investment. Because the Dorado environment is unchanged, there's no cost associated with retraining users and programmers.

Depending upon your end goal, a transition can be the end state or a first step toward modernizing applications within the Dorado environment or within Azure. This approach provides a measured, planned path for updating applications. It retains the investment in the existing application code. After conversion, you can use other Unisys and Azure data analytic services.

### Potential use cases

- Move existing Unisys CPF Dorado workloads to Azure quickly and minimize risk during the migration.

- Use [Azure Arc](https://azure.microsoft.com/services/azure-arc/) to create a DR plan for an existing on-premises workload.

- Add Azure data services to existing client capabilities.

- Use Azure-based CPF to serve as a DR, test, or development environment without the need for more hardware or facility resources.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Unisys CPF in Azure uses Site Recovery to promote system availability and consistency. Site Recovery enables Azure region-to-region failover for DR if a primary region outage occurs. DR capabilities mirror the Azure VMs to a secondary Azure region. These capabilities facilitate a quick failover in the rare case of an Azure datacenter failure.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Unisys CPF is a secure system on its own. Azure adds a layer of encryption for data at rest.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Unisys CPF in Azure eliminates hardware maintenance and facility costs up front. Further savings derive from not having to retrain staff on how to operate or use the system. The virtualized computer runs as it did on the datacenter floor.

You can also optimize your costs by following the process to right-size the capacity of your VMs from the beginning, along with simplified resizing as needed. For more information, see the Well-Architected Framework's [Principles of Cost Optimization](/azure/architecture/framework/cost/overview).

To estimate the cost of Azure products and configurations, visit the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

To learn more about Unisys CPF offerings and pricing, visit [Unisys CPF products](https://www.unisys.com/solutions/clearpath-forward/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Unisys demonstrates operational excellence by presenting a known environment to the staff, while including new services like Site Recovery to provide DR failover.

You can optimize your operational efficiency by deploying your solution with Azure Resource Manager templates and by using Azure Monitor to measure and improve your performance. For more information, see [DevOps architecture design](/azure/architecture/guide/devops/devops-start-here).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Unisys matches operational performance in Azure with Bronze, Silver, Gold, Platinum, and Titanium offerings to match client workload to operational needs.  Unisys virtualization on Azure enhances performance efficiency through Azure Monitor and [the Performance Diagnostics (PerfInsights) tool](/troubleshoot/azure/virtual-machines/windows/how-to-use-perfinsights). These tools enable real-time optimization and proactive issue resolution for improved workload management.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Philip Brooks](http://linkedin.com/in/philipbbrooks) | Senior Program Manager
- [Adam Gallagher](mailto:Adam.Gallagher@Unisys.com) | Senior Solution Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, contact **[legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com)**, or see the following resources:

- [Azure mainframe and midrange migration](https://azure.microsoft.com/migration/mainframe)
- [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface)
- [ExpressRoute documentation](/azure/expressroute/expressroute-introduction)
- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [Mainframe rehosting on Virtual Machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)
- [SMA OpCon in Azure](/azure/architecture/solution-ideas/articles/sma-opcon-azure)
- [Unisys cloud management](https://www.unisys.com/solutions/cloud-management)
- [Unisys CPF MCP mainframe rehost to Azure by using Unisys virtualization](/azure/architecture/example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost)
- [Unisys cybersecurity](https://www.unisys.com/solutions/cybersecurity-solutions)
- [Virtual Network documentation](/azure/virtual-network)

## Related resources

- [Azure database migration guides](/data-migration)
- [Mainframe file replication and synchronization on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)
- [Modernize mainframe and midrange data](/azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure)
