Rehosting is a way to run legacy mainframe applications, intact, on an open system. This path is the fastest way to take applications off your mainframe hardware and run them on a Windows or Linux platform in a cloud-native environment. Application code written in legacy languages like COBOL or PL/1 are migrated as is and recompiled in the new environment with no change to the business logic. Rehosting helps to preserve the application's logic. At the same time, rehosting minimizes the risk and cost that comes with recoding the application for the new environment.  

Rehosting is a cost-effective method to address the challenges of maintaining old mainframe hardware. Commonly referred to as *lift and shift*, rehosting moves mission-critical and core applications off the mainframe and migrates them to the cloud. With this approach, the underlying hardware changes, for example from an IBM mainframe to x86. However, the functional and business logic is untouched. This migration is the quickest and least impactful from an end-user perspective. The application retains the same interfaces and look and feel that the users are comfortable with.  

For teams exploring cloud features, rehosting applications is a great way to use cloud capabilities like auto-scaling, managed storage, and containers. This architecture shows a general rehosting example that highlights two methodologies to deploy workloads. You can use Azure Kubernetes Service (AKS) or Azure Virtual Machines. Which method you use depends on the portability of the application, and on your preference.

## Potential use cases

Many scenarios can benefit from rehosting on Azure. Here are some possible use cases:

- **Cost optimization**: You want to significantly reduce the high operating and maintenance costs of mainframes hardware and its associated licenses or software.
- **Location agnostic**: You're planning for a datacenter exit and want a highly available, secure, and reliable alternative platform to host your legacy applications.
- **Least disruption**: You need to migrate mission-critical mainframe applications while maintaining the continuity of day-to-day business operations.
- **Minimal user impact**: Move your applications from old hardware but continue to provide your users with the same or better interfaces.  
- **Negligible upskilling**: Applications are rehosted in the cloud with no significant code changes. They continue to provide your development team with the familiar code base, and at the same time eliminate costly development, testing, and reskilling on a newer language.

## Mainframe architecture

This is the pre-migration architecture.

:::image type="content" source="./media/azure-mainframe-rehost-premigration-diagram.svg" alt-text="Diagram that shows the mainframe applications before migration to Azure." lightbox="./media/azure-mainframe-rehost-premigration-diagram.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-mainframe-rehost-premigration-diagram.vsdx) of this architecture.*

### Mainframe dataflow

1. Input occurs over TCP/IP, including TN3270, HTTP, and HTTPS.  

2. Input into the mainframe uses standard mainframe communication protocols.

3. Receiving applications can be batch or online systems.

4. COBOL, PL/I, Assembler, and other compatible languages run in an enabled environment.

5. Data and database services used are hierarchical, network, and relational databases.

6. Common services include program execution, I/O operations, error detection, and protection within the environment.

7. Middleware and utilities manage services like tape storage, queueing, output, and web services within the environment.

8. Operating systems provide the interface between the engine and the software that it runs.

9. Partitions are necessary to run separate workloads and to segregate work types within the environment.

## Architecture

This architecture showcases a solution that is rehosted on Microsoft Azure.

:::image type="content" source="./media/azure-mainframe-rehost-postmigration-diagram.svg" alt-text="Diagram that shows the mainframe applications after migration to Azure." lightbox="./media/azure-mainframe-rehost-postmigration-diagram.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-mainframe-rehost-postmigration-diagram.vsdx) of this architecture.*

### Dataflow

1. Input typically comes via ExpressRoute from remote clients, or by other applications that currently run in Azure. In either case, TCP/IP connections are the primary means of connection to the system. User access is provided over TLS port 443 to access web-based applications. The presentation layer of the web-based application can be kept unchanged to minimize end user retraining. For admin access to the VMs, you can use Azure Bastion hosts to maximize security by minimizing open ports.

2. Access to the application compute clusters is done by using an Azure load balancer. With this approach, you can scale out compute resources to process the input work. Both the level 7 application level and level 4 network protocol level load balancers are available. The type you use depends on how the application input reaches the entry point of the computer cluster.

3. The use of application compute clusters depends on whether the application supports virtual machines (VMs) in a compute cluster, or the application runs in a container that you deploy in a container compute cluster like Kubernetes. Most mainframe partner software for applications written in legacy languages prefers to use VMs. Some mainframe systems partner software can also support deployment in containers.  

4. Application servers receive the input in the compute clusters and share application state and data using Azure Redis Cache or remote direct memory access (RDMA). The application servers host various COBOL or PL/1 application programs. A transaction system manager is an emulator on Azure that can handle customer information control systems (CICS) and information management systems (IMS) workloads. A batch system emulator on Azure does the role of job control language (JCL).  

5. You can use Azure services or other partner software hosted in VMs for system, utilities, and data management.

6. Mainframe data is migrated to Azure databases. Azure provides various efficient data storage services like Azure SQL Database, SQL Server on Azure Virtual Machines, and Azure SQL Managed Instance. There are many factors to consider when making a choice, like type of workload, cross-database queries, and two-phase commit requirements. Azure data services provide scalable and highly available data storage that you can share across multiple compute resources in a cluster. You can make these services geo-redundant, and then configure them so that if failover occurs, the disaster recovery database instance becomes active.

7. AKS enables you to scale out and scale down your mainframe modernization workloads in Azure, to take advantage of the cloud platform. When you deploy multiple AKS clusters, choose regions where AKS is available. Then you can use paired regions for a highly resilient architecture. It's important to run multiple instances of an AKS cluster across multiple regions and in highly available configurations.

8. Azure Data Factory provides data ingestion and synchronization with multiple data sources, both within Azure and from external sources. Azure Blob Storage is a common landing zone for external data sources.  

9. Use Azure Site Recovery for disaster recovery of the VM and container cluster components. Azure Site Recovery replicates and syncs the production environment to the failover region.

### Components

- [Virtual Machines](https://azure.microsoft.com/services/virtual-machines): Virtual Machines is an on-demand, scalable computing resource. An Azure VM gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it.

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network): Virtual Network is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources, like Virtual Machines, to securely communicate with each other, the internet, and on-premises networks. Virtual Network is like a traditional network that you operate in your own data center. However, it brings with it the benefits of Azure's infrastructure such as scale, availability, and isolation.

- [Azure Virtual Network Interface Cards](/azure/virtual-network/virtual-network-network-interface): A network interface enables an Azure VM to communicate with internet, Azure, and on-premises resources. As shown in this architecture, you can add more network interface cards to the same Azure VM. This way, the Solaris child-VMs have their own dedicated network interface device and IP address.

- [Azure Disk Storage](https://azure.microsoft.com/services/storage/disks): Managed disks are block-level storage volumes that are managed by Azure and used with Azure VMs. The available types of disks are Azure Ultra Disk Storage, Azure Premium SSD, Azure Standard SSD, and Azure Standard HDD.  For this architecture, we recommend either Premium SSD or Ultra Disk Storage.

- [Azure Files](https://azure.microsoft.com/services/storage/files): Azure Files offers fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. You can mount Azure file shares concurrently by cloud or on-premises deployments of Windows, Linux, and macOS.

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute): With ExpressRoute, you can extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. You can also establish connections to Microsoft cloud services, like Microsoft Azure and Microsoft 365.

- [AKS](https://azure.microsoft.com/services/kubernetes-service): Deploy and manage containerized applications more easily with a fully managed Kubernetes service. Azure Kubernetes Service (AKS) offers serverless Kubernetes, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance. Unite your development and operations teams on a single platform to rapidly build, deliver, and scale applications with confidence.

- [Azure Container Registry](https://azure.microsoft.com/services/container-registry): Build, store, secure, scan, replicate, and manage container images and artifacts with a fully managed, geo-replicated instance of OCI distribution. Connect across environments like AKS and Azure Red Hat OpenShift, and across Azure services like App Service, Machine Learning, and Batch.

- [Site Recovery](https://azure.microsoft.com/services/site-recovery): Site Recovery offers ease of deployment, cost effectiveness, and dependability. Deploy replication, failover, and recovery processes through Site Recovery to help keep your applications running during planned and unplanned outages.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- To make the most of Azure's capabilities, use a container-based approach to deployment. This approach helps if the application needs to scale on demand and achieve elastic provisioning of capacity without the need to manage the infrastructure. It also enables you to add event-driven autoscaling and triggers. A container bundles all the software that's needed for execution into one executable package. It includes an application's code together with the related configuration files, libraries, and dependencies necessary to run the app.
- You need to orchestrate and manage containerized services and their associated networking and storage components. AKS is an excellent option because it automates cluster and resource management. You designate the number of nodes you need, and AKS fits your containers onto the right nodes to make the best use of resources. AKS also supports automated rollouts and rollbacks, service discovery, load balancing, and storage orchestration. And AKS supports self-healing. If a container fails, AKS starts a new one. You can also safely store secrets and configuration settings outside of the containers.
- The architecture uses Site Recovery to mirror Azure VMs to a secondary Azure region for quick failover and disaster recovery if an Azure datacenter fails.
- To maximize the uptime of the workloads on the AKS deployment approach, it's a best practice for business continuity to deploy the application into multiple AKS clusters across different regions. Your application state can be available across multiple clusters because AKS allows storage replication across multiple regions.
- To maximize the uptime of the workloads on a VM-based deployment approach, consider using Azure Virtual Machine Scale Sets. With Virtual Machine Scale Sets, you can create and manage a group of load balanced VMs. The number of VM instances can automatically increase or decrease in response to demand or a defined schedule. Scale sets provide high availability to your applications, and allow you to centrally manage, configure, and update many VMs.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- This solution uses an Azure network security group to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).
- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) maximizes admin access security by minimizing open ports. Bastion provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS.

### Cost optimization

To help optimize costs, look for ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Azure provides cost optimization by running on Windows VMs. With Windows VMs, you can turn off the VMs when not in use and script a schedule for known usage patterns. Azure identifies the right number or resource types, analyzes spending over time, and scales to meet business needs without overspending.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of the services in this architecture.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- The target architecture is functional with Azure Cloud Services.
- The container-based deployment promotes adoption of DevOps and Agile working principles.
- You have full flexibility of development and production deployment options.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Performance efficiency is built into this solution because of the load balancers. If one presentation or transaction server fails, the server behind the load balancer shoulders the workload.
- Kubernetes provides a cluster autoscaler. The autoscaler adjusts the number of nodes based on the requested compute resources in the node pool.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Sunnyma Ghosh](https://www.linkedin.com/in/sunnymaghosh) | Senior program manager

Other contributor:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior program manager

## Next steps

- [Azure white papers about mainframe topics](/azure/virtual-machines/workloads/mainframe-rehosting/mainframe-white-papers)
- [Mainframe rehosting on Azure virtual machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)
- [Mainframe workloads supported on Azure](/azure/virtual-machines/workloads/mainframe-rehosting/partner-workloads)

For more information, contact **legacy2azure@microsoft.com**.

## Related resources

- [Azure mainframe and midrange architecture concepts and patterns](../../mainframe/mainframe-midrange-architecture.md)
- [Mainframe and midrange data replication to Azure using Qlik](mainframe-midrange-data-replication-azure-qlik.yml)
- [Mainframe modernization using Model9](mainframe-modernization-model9.yml)
- [Rehost mainframe applications by using NTT DATA UniKix](rehost-mainframe-ntt-data-unikix.yml)
