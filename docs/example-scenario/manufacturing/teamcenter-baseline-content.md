This article provides guidance for implementing Siemens Teamcenter Product Lifecycle Management (PLM) in Azure. It describes a baseline architecture for Siemens Teamcenter PLM deployments in Azure. [Siemens Teamcenter PLM](https://plm.sw.siemens.com/en-US/teamcenter/) is a software suite for managing the entire lifecycle of a product.

Many customers run multiple Teamcenter solutions across the enterprise, mixing multiple instances, multiple ISV vendors, and hybrid cloud and on-premises implementations. This fragmentation reduces the customer’s ability to uniformly access data. Consolidating Teamcenter on Azure provides a consistent and synchronized PLM experience across your enterprise.

| Benefits of Teamcenter on Azure | Details |
| --- | --- |
| Engineer anywhere | Enhances collaboration by eliminating data silos in multiple on-premises PLM instances.|
| Cost efficiency | Cuts down IT infrastructure and nonessential maintenance investments. |
| End-to-end workflow enablement | Interacts with core product design and simulation, and interconnects with CAD/CAM, simulation solvers, MES, ERP, and other IT/OT systems.|
| High performance tech & speed | Offers high-quality compute, storage, and networking capabilities. Delivers consistently maintained performance across all Teamcenter PLM instances on Azure, boosting innovation and market speed.|
| Scalability & global collaboration | Enables expansion across Azure’s global infrastructure with efficient internal and external enterprise collaboration.|
| Security & compliance | Ensures data protection and global standards adherence using Azure security controls and compliance policies.|
| Simplified management | Consolidates Teamcenter resources and accelerates the shift to a consistent, enterprise-wide PLM experience.|

## Architecture

Siemens Teamcenter PLM baseline architecture has four distributed tiers (client, web, enterprise, and resource) in a single availability zone. Each tier aligns to function, and communication flows between these tiers. All four tiers use their own virtual machines in a single virtual network. Teamcenter uses a client-server model. The Teamcenter core business functionality runs on a central server in the enterprise tier, and users access it through a web-based or thick-client interface. You can deploy multiple instances in Dev and Test environments (virtual networks) by adding extra virtual machines and storage.

[![Diagram that shows a Teamcenter PLM baseline architecture.](media/teamcenter-baseline-architecture.svg)](media/teamcenter-baseline-architecture.svg)
*Download a [Visio file](https://arch-center.azureedge.net/teamcenter-baseline-architecture.vsdx) of this architecture.*

### Workflow

1. Teamcenter users access the Teamcenter application via an HTTPS-based endpoint Public URL. Users access the application through two user interfaces: (1) a Rich client and (2) an Active workspace client.
1. User authenticates using a Teamcenter credential that a Teamcenter administrator creates in Teamcenter. Azure Active Directory with SAML configuration allows single sign-on to the Teamcenter application.
1. Azure Firewall backbone filters traffic and threat intelligence from Microsoft Cyber Security. HTTPS traffic directed to the Azure Application gateway. The Hub virtual network and Spoke virtual network are peered so they can communicate over the Azure backbone network.
1. Azure Application Gateway routes traffic to the Teamcenter web server virtual machines in the Web Tier. Azure Application Gateway with Azure Firewall inspects the incoming HTTP traffic to continuously monitor Teamcenter against exploits. For reliable performance of your application, the virtual machine size, disk configuration, and application installs should match across all virtual machines. Based on your requirements, you can consider the use of Azure Virtual Machines Scale Sets. With Virtual Machine Scale Sets, virtual machine instances have the same base OS image and configuration.
1. The Web subnet in the Web tier runs the following Teamcenter components on virtual machines:

    - *Teamcenter Security services (TCSS)* enable role-based access control (RBAC) for end users and secure access to resources. With TCSS, users can navigate between different Teamcenter applications without encountering multiple authentication challenges. It offers a unified framework for integration with a site's single sign-on solution and simplifies the authentication process

    - *Teamcenter HTTP servers (TC HTTP servers)* run third-party HTTP web servers, such as IIS (.NET) or Java-based servers, to support the Rich client or Active Workspace client. These web server virtual machines also host the Teamcenter servlet container. Network security groups (NSGs) secure inbound and outbound communication between the Application Gateway subnet, web subnet and enterprise subnets. NSGs ensure the necessary connectivity and security measures are in place for data transfer between the subnets.

    - *Active Workspace Gateway* provides the functionality for the Teamcenter Active Workspace client. It serves as the routing mechanism for static content, such as HTML, CSS, JavaScript, JSON, and dynamic content such as API routing. It directs these requests to the appropriate back-end services and microservices responsible for tasks such as Service-Oriented Architecture (SOA), File Management Services (FMS), Visualization, and GraphQL. This architecture ensures efficient delivery and processing of content within the Teamcenter Product Lifecycle Management application running on Azure.

    - Network security groups (NSGs) secure inbound and outbound communication between the Enterprise subnets, Database subnet & Storage subnet.

1. The Enterprise subnet runs the following core Teamcenter components:

    - *Enterprise tier virtual machines* run the business logic components of Teamcenter. These components include Teamcenter Foundation, Server Manager, Dispatcher, and Microservices.

    - *Active workspace* serves as the platform where Active Workspace users sign in to access information and perform tasks based on their assigned roles.

    - *Visualization virtual machines* run Teamcenter lifecycle visualization. This feature empowers every member of your organization to access and view design data that is commonly stored in CAD-data formats.

    - *File Management System (FMS) virtual machine* stores and retrieves user files (CAD, PDF) through SMB/NFS access protocols from file storage (ex. managed disks, Azure Files or Azure NetApp Files). It also supports caching and file distribution. FMS requires the installation of an FMS server cache (FSC) and FMS client cache (FCC) components. FCC resides on client desktop.

    - *File server cache virtual machine* is a volume server for file management. It's also a server-level performance cache server and provides shared data access for multiple users. All Teamcenter file access/update is via FMS server cache processes. The cache process reads and writes the files in volume servers. It also streams the file(s) to/from clients as required.

    - *Search server*, Apache Solr performs smart searches and supports real-time indexing of data.

    - *License server virtual machine* runs a valid Teamcenter FlexPLM license.

1. *Database subnet* runs a SQL Server database using an infrastructure-as-a-service deployment. It uses SQL Server Always On availability groups for asynchronous replication. The deployment could run an Oracle on this IaaS deployment.
1. *Storage subnet* uses Azure Files Premium and Azure NetApp Files.
1. *On-premises network* allows the customer support team and system administrators to connect to Azure via Azure VPN connection to gain access to any virtual machine instance via Remote Desktop Protocol (RDP) from a jump box (Bastion).

### Components

This architecture consists of the following Azure components.

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/): Azure Virtual Network is a service that facilitates secure communication between Azure resources, the internet, and on-premises networks. In a Siemens Teamcenter deployment, you can use it to create a secure network infrastructure for the Teamcenter services, allowing safe and reliable communication between them.
- [Virtual machines](https://azure.microsoft.com/services/virtual-machines/#overview): Azure Virtual Machines is an IaaS that provides on-demand, scalable computing resources without the need for physical hardware maintenance. Virtual machines provide the computing infrastructure that hosts the various Teamcenter services.
- [Azure Files](https://azure.microsoft.com/products/storage/files): Azure Files is a service that offers shared storage and allows you to create a hierarchical folder structure to upload files. In a Teamcenter deployment, it provides shared storage space for collaboration, document management, and version control.
- [Azure NetApp Files](https://azure.microsoft.com/services/netapp): Azure NetApp Files is a file-storage service developed jointly by Microsoft and NetApp. You can use Azure NetApp Files to host and manage file-based applications of Teamcenter.
- [Azure Active Directory](https://azure.microsoft.com/products/active-directory): Azure Active Directory provides on-premises directory synchronization and single sign-on features. You can use Azure Active Directory to manage and authenticate users, providing seamless access to Teamcenter services hosted on Azure.
- [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview): SQL Server on Azure Virtual Machines allows SQL Server workloads to be migrated to the cloud with full code compatibility. You can use this service to host the Teamcenter database, providing reliable, secure, and performant data services.
- [Network security groups](/azure/virtual-network/network-security-groups-overview): Network security groups are used to limit access to subnets within the Azure network. For a Teamcenter deployment, you use network security groups to secure the network infrastructure, ensuring that only authorized traffic can access the Teamcenter resources.
- [Azure Public IP](/azure/virtual-network/ip-services/public-ip-addresses): Azure Public IP is a service that connects Azure Virtual Machines to the internet via a public IP address. The public IP address provides internet access to the hosted Teamcenter services, facilitating remote access and collaboration.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) : Azure Monitor provides detailed, real-time monitoring data for any Azure resource. You use it to monitor the performance and usage of Teamcenter services, providing vital information for maintaining and improving the deployment.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault): Azure Key Vault is a service for securely storing and accessing secrets used by cloud apps and services. In a Teamcenter deployment, you use it to store sensitive information such as API keys, passwords, and certificates.
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway/): Azure Application Gateway is a web traffic load balancer that manages traffic to web applications. You use it to manage and distribute traffic to the Teamcenter services, improving performance and reliability.
- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop): Azure Virtual Desktop is a desktop and app virtualization service. You use it to provide users with a virtualized desktop environment for CAD workstation, facilitating access to Teamcenter services from anywhere.
- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall): Azure Firewall is a cloud-native network firewall security service that provides threat protection for cloud workloads. For a Teamcenter deployment, Azure Firewall can be used to protect the Teamcenter frontend services from threats.

## Considerations

These considerations align to the pillars of the Azure Well-Architected Framework. A set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Potential use cases

Teamcenter provides a broad and rich depth of many functional solutions for managing data across the product and service lifecycle. Teamcenter deployment on Azure supports the following use cases:

- Store product data assets in a single, secured, shared source of truth to streamline processes.
- Manage product complexity combining mechanical, electrical and software.
- Collaborate to manage product design, configuration (bill of material) and change management across the product lifecycle efficiently.
- Process connectivity across engineering, design, R&D and manufacturing.
- Increase competitive advantage by increasing speed to market for new products.
- Power digital thread and digital twins.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview). In general, consider Availability zones or Availability sets based on requirements of multisite implementations. For more information, see [High availability and disaster recovery for IaaS apps](/azure/architecture/example-scenario/infrastructure/iaas-high-availability-disaster-recovery).

#### Web tier and Enterprise tier reliability

**Use multiple virtual machines in the Web tier.** You should use multiple instances of the Teamcenter application to enhance the resiliency and scalability of the application. Run these instances on multiple virtual machines and load balance the traffic between them. A single web server Java Virtual Machine (JVM) can support several thousand concurrent sessions when properly tuned. However, you should run multiple parallel web servers for either load balancing and/or increased reliability.

**Use multiple virtual machines in the Enterprise tier.** You should install the Enterprise tier on multiple Azure virtual machines. This setup ensures fail-over support and enables load balancing to optimize performance. There are two load balancers. Application gateway load balances between virtual machines in the Web subnet and the Active Workspace Gateway load balances at the application level.

By distributing software functions over a network, the application can achieve high availability and improve overall system reliability. This configuration is beneficial for production environments where uninterrupted operation and efficient resource utilization are crucial. With multiple virtual machines, the Teamcenter application can handle increased demand and provide a robust and responsive user experience. It allows you to use the scalability and resilience capabilities of Azure and optimize the performance of Siemens Teamcenter application. It helps ensure uninterrupted access to critical product lifecycle management functionalities.

**Configure File Management System (FMS) configuration failover.** Configuration failover allows the client or the FMS network to fail over from one FSC configuration server to another. The failover happens based on the priority value of the FSC set in the FMS primary configuration file. Like other failovers in FMS configuration, the priority attribute determines the failover configuration. Zero is the highest priority. Numbers greater than zero represent a decreasingly lower priority. You should use [Siemens Support Center](https://support.sw.siemens.com) for more information for failover configuration for the following components:

- FSC volume server failover configuration
- FSC remote cache failover configuration
- FSC remote multiple-level cache failover configuration
- Microservices configuration

#### Resource tier reliability

**Configure database backups.** For SQL Server, one approach is to use [Azure Backup](/azure/backup/backup-azure-sql-database) using Recovery Services Vault to back up SQL Server databases that run on virtual machines. With this solution, you can perform most of the key backup management operations without being limited to the scope of an individual vault. For more information on Oracle, see [Oracle Database in Azure Virtual Machines backup strategies](/azure/virtual-machines/workloads/oracle/oracle-database-backup-strategies).

**Use Azure Backup.** When performing server-level backups, you should avoid backing up the active database files directly. The backup might not capture the complete state of the database files at the time of backup. Instead, server-level backups should focus on backing up the backup file generated by using the database backup utility. This approach ensures a more reliable and consistent backup of the application's database. You can protect the integrity and availability of their Teamcenter application data. You can safeguard critical information and enabling efficient recovery for any unforeseen issues or data loss.

**Configure volume backups.** Azure Files provides the capability to take snapshots of file shares, creating point-in-time, read-only copies of your data. By using Azure Files or Azure NetApp Files snapshots, establish a general-purpose backup solution that safeguards against accidental deletions or unintended changes to the data. For the Teamcenter volume server, use File volume backups. This configuration effectively backs up the volume server and enables easy recovery if there was data loss or system failures. Implementing these recommendations enhances the data protection and resilience of the Teamcenter application, mitigating the risks associated with data loss or unauthorized modifications.

**Test database and storage backups.** You should plan, document, and test the backup and recovery strategy for the Teamcenter database and file manager servers.

**Configure backup frequency.** Determine backup needs based on business requirements, considering the increasing number of users. A daily backup might not be sufficient for optimal protection, so adjust the frequency accordingly.

**Coordinate volume data with database backups.** Ensure that backups for the File Manager volume servers (FMS) are coordinated with database backups. . This configuration allows you to sync the actual files with the file metadata. The database contains metadata (pointers) to files within the FMS, making synchronization crucial.

**Enhance database reliability.** Deploy SQL Server virtual machines in Availability Sets to improve database reliability. Availability Sets deploy virtual machines across fault domains and update domains, mitigating downtime events within the datacenter. Create an availability set during virtual machine provisioning. Consider replicating Azure storage across different Azure datacenters for extra redundancy.

For Oracle databases, Azure offers availability zones and availability sets. You should only use availability sets in regions where availability zones are unavailable. In addition to Azure tools, Oracle provides Oracle Data Guard and GoldenGate solutions. For more information, see [Oracle databases on Azure Virtual Machines](/azure/virtual-machines/workloads/oracle/oracle-reference-architecture).

**Use Always On availability group.** Configure the database server with an "Always On" availability group for SQL Server on Azure Virtual Machines. This option uses the underlying Windows Server Failover Clustering (WSFC) service and helps ensure high availability. For more information, see [Overview of SQL Server Always On availability groups](/azure/azure-sql/virtual-machines/windows/availability-group-overview?view=azuresql) and [Windows Server Failover Clustering (WSFC)](/azure/azure-sql/virtual-machines/windows/hadr-windows-server-failover-cluster-overview?view=azuresql).

### Security

Azure Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

**Configure the Login Service and Identity Service.** Teamcenter provides the Teamcenter Security Services (TCSS) feature. The Login Service and Identity Service are essential components of TCSS and can be built using the Web Application Manager. Deploy these Java EE web applications on a supported Java EE web application server.

*Login Service*: The Login Service serves as a client interface and can be accessed using both IPv4 and IPv6 URLs. It also serves as the repository for active Security Services sessions, storing important state information required for the single sign-on capability of Security Services.

*Identity Service*: The Identity Service can only be accessed using IPv4 addressing. It includes a table that points to the application root URL. As a client interface, it must accept both IPv4 and IPv6 URLs. To utilize the Security Services, ensure the installation of the Security Services Session Agent in the Web tier.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

**Consider constrained vCPU virtual machines.** If your workload requires more memory and fewer CPUs, consider using one of [constrained vCPU virtual machine](/azure/virtual-machines/constrained-vcpu) sizes to reduce software licensing costs that are charged per vCPU.

**Use the right virtual machine SKUs.** You should use the virtual machine SKUs in the following table. Contact Siemens support team for the latest Teamcenter on Azure certification matrix and SKU recommendations.

|Role of the Server|SKUs|
| --- | --- |
|Enterprise server, FMS and ODS|[Standard F16s v2](/azure/virtual-machines/fsv2-series)|
|FSC, Apache Solr server| [Standard D8ds v5,DDv5](/azure/virtual-machines/ddv5-ddsv5-series#ddv5-series)|
|Visualization, CAD workstation| [Standard NV_A10_v5](/azure/virtual-machines/nva10v5-series)|
|Database servers |[Standard E32-16ds_v4](/azure/virtual-machines/constrained-vcpu)|
|Pool manager for 4T and AWC| [Dv4](/azure/virtual-machines/dv4-dsv4-series) and [Ev4](/azure/virtual-machines/ev4-esv4-series)|

**Use the Azure calculator.** The Azure calculator can help you estimate and optimize cost. For an estimated cost of the baseline architecture, see [estimated cost](https://azure.com/e/625cea91d4aa43bca73e0a8235817ba7). Your estimates might differ based on your Azure Teamcenter implementation.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

**Use proximity placement groups.** Use proximity placement groups to achieve optimal network latency, particularly for CAD applications. Employ proximity placement groups when significant network latency between the application layer and the database impacts the workload. Take note of the limitations on virtual machine type availability within the same datacenter. For more information, see [Proximity placement groups](/azure/virtual-machines/co-location).

When hosting volumes for the Teamcenter Volume Server, it's recommended to attach multiple premium disks to a Virtual Machine and stripe them together. This configuration enhances the combined I/O operations per second (IOPS) and throughput limit. On a DS series Virtual Machine, you can stripe up to 32 premium disks, and for GS series, up to 64 premium disks can be striped. Ensure that the combined input-output per second (IOPS) doesn't exceed the limit defined by the Virtual Machine SKU. For more information, see [Siemens Support Center](https://support.sw.siemens.com).

**Use asynchronous indexing flow.** For Full Text Search (FTS) indexing via the Apache Solr server, you should use an asynchronous file content indexing flow. It's important when indexing contents from CAD files associated with Teamcenter objects. Asynchronous indexing flow uses separate and independent Dispatcher processes to track requests. It reduces the need for resource-intensive processes requiring additional CPU and memory resources. The asynchronous indexing flow separates file content indexing from metadata indexing. Once metadata indexing is completed, your users can search for all indexable objects without waiting for file content indexing. This indexing flow improves search time.

## Contributors

Microsoft maintains this article that the following contributors wrote originally:

Principal authors:

- [Sunita Phanse](https://www.linkedin.com/in/sunita-phanse-176969/) | Senior Technical Program Manager

Other contributors:

- [Guy Bursell](https://www.linkedin.com/in/guybursell/) | Director Business Strategy
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar/) | Principal Program Manager
- [Geert van Teylingen](https://www.linkedin.com/in/geertvanteylingen/) | Azure NetApp Files Group Product Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

>[!div class="nextstepaction"]
> [Siemens Teamcenter with NetApp Files](teamcenter-plm-netapp-files.yml)

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Windows virtual machines on Azure](/azure/virtual-machines/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
