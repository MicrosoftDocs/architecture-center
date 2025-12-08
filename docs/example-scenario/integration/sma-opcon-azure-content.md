This article describes two OpCon options for implementation in Azure. *OpCon Cloud* is a managed OpCon implementation that SMA sets up and manages. The *OpCon datacenter* is a cloud installation that you set up and manage.

Review both options to determine which approach best suits your scenario.

## Architecture: OpCon Cloud

The following architectural diagram shows an OpCon Cloud environment that uses Azure SQL Database for the database requirements. The OpCon environment can be deployed in an Azure environment or a hybrid environment.

This implementation uses a single virtual network and multiple subnets to support various functions. Network security groups (NSGs) filter network traffic between Azure resources in the virtual network.

:::image type="complex" source="./media/opcon-cloud-architecture.svg" alt-text="Architecture diagram that shows how to deploy OpCon in Azure or a hybrid environment." lightbox="./media/opcon-cloud-architecture.svg" border="false":::
The diagram has two main sections: the on-premises network and Azure. The environments are connected via the internet. The on-premises network includes various devices and servers such as Unisys ClearPath Forward, IBM zOS or AS400, and Windows and Linux servers. OpCon Relay points to these components via a green line that represents logical connections to OpCon agents. The on-premises network also contains an OpCon MFT server. Opcon Relay points to this component via a red line that represents logical REST API connections to applications. OpCon Relay connects to Opcon in the Azure environment via the internet. Users also reside in the on-premises network. The Azure virtual network contains the OpCon subnet, private endpoint subnet, and applications subnet. The OpCon subnet contains OpCon, which points to the opconconfig and opconlog components in the same subnet. It also points to SQL Database (via a black line) and Azure Storage (via a red line) in the private endpoint subnet. The applications subnet contains Unisys ClearPath Forward, Windows, Linux, Storage, an OpCon MFT server, and an application server. OpCon points to several components. It points to an OpCon MFT server and an application server via a red line. It also points to Unisys ClearPath Forward, Windows, and Linux via a green line. The OpCon MFT server points to Storage via a blue line that represents Logical Connector connections to applications. The OpCon subnet and applications subnet are connected via an NSG.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/opcon-architectures.vsdx) of this architecture.*

### Workflow: OpCon Cloud

1. You deploy the OpCon core services container within an Azure Kubernetes Service (AKS) cluster that you manage. PersistentVolumes (Azure Files CSI storage drivers) store logs and configuration information to ensure data persistence across container restarts.

   - The OpCon core services connect to the OpCon database through the configured Azure private endpoint, which provides secure access to the SQL Database server.

   - OpCon core services communicate with OpCon agents that are installed on virtual machines (VMs) within the virtual network environment. The services also communicate with on-premises systems via the Relay component.
   - Similarly, OpCon core services communicate directly with application REST API endpoints within the virtual network environment. The services also communicate with on-premises systems via the Relay component and a *connectionless* system.
   - OpCon core services provide Solution Manager, which is a web-based user interface that interacts with the entire OpCon environment.
   - NSGs limit traffic flow between subnets.

1. The OpCon database objects and data are installed within a SQL Database server, which is accessed through a private endpoint.

1. OpCon core services interact with Azure Storage via OpCon connector technology. This integration provides capabilities to manage Azure Blob Storage. OpCon Managed File Transfer (MFT) also supports interaction with Storage.

1. The applications subnet includes the VMs that provide the application infrastructure. The application servers could also be installed in multiple subnets or virtual networks to create separate environments for web servers, application servers, or other systems.

   - Application VMs or on-premises legacy systems require connections to the OpCon core services to manage their workloads. Applications that provide REST API endpoints don't require extra software.

   - The subnet includes an OpCon MFT server. This OpCon component provides full file transfer capabilities, such as compression, encryption, decryption, decompression, file watching, and automated file routing for the enterprise.
   - NSGs limit traffic flow between subnets.

1. A hybrid environment requires an internet connection to link the on-premises environment to the OpCon Cloud instance.

1. OpCon Relay is a software component that manages on-premises agents.
   - The link between OpCon Cloud and Relay uses standard encrypted protocols via WebSockets.

   - Agent configurations are defined one time in the OpCon environment and then pushed to the designated Relay component.
   - After Relay receives its configuration, it establishes connections to the on-premises OpCon agents and reports their status to the OpCon environment in Azure. Messages to and from agents are passed across the defined connection.
   - You can also install *connectionless* agents within the Relay environment.

1. All user requests are routed via the internet connection to the OpCon core services environment.
   - Users interact with OpCon Solution Manager, which is a web-based user interface for the following tools:

     - OpCon administration
     - OpCon MFT administration
     - OpCon workflow development, implementation, and monitoring
     - OpCon Self Service
     - OpCon Vision (task dashboard)
     - OpCon MFT central application (dashboard and query application)

1. OpCon core services communicate with OpCon agents that are installed on on-premises systems through Relay.

   Similarly, OpCon core services use Relay to communicate directly with on-premises systems via REST API endpoints. This approach uses REST API-based connectivity options.

## Scenario details

OpCon Cloud is an Azure-installed version of OpCon that SMA sets up and manages, including software upgrades and monitoring services. You can purchase more services to help create workflows.

This example architecture runs the SMA OpCon Cloud environment in Azure. It serves as a single automation control point to automate workflows across the enterprise, both on-premises and in Azure. OpCon facilitates workflows among all servers and systems in your enterprise. OpCon Schedule Activity Monitor (SAM) is the core OpCon module. It communicates with agents on target systems to schedule tasks, monitor tasks, and receive external events. These agents can be deployed across many platforms, including Windows, Linux/Unix, Unisys ClearPath Forward mainframes (MCP and 2200), IBM z/OS, and IBM AIX, which brings all systems under a unified automation framework.

OpCon Relay connects on-premises systems with the OpCon Cloud environment through a single point of contact. This feature removes the need for Azure VPN connections.

A *connectionless* agent platform can provide direct connectivity between OpCon Cloud systems and REST API implementations. You don't need extra containers to support connections to applications.

On-premises servers connect to the Relay software component. Multiple Relay components can be installed within the on-premises environment. The OpCon environment is deployed within a Kubernetes cluster by using AKS and a SQL Database server.

## Architecture: OpCon datacenter

If you want more control, you can install and manage OpCon yourself within the Azure environment. You can design a hybrid cloud and on-premises infrastructure, or a cloud-only infrastructure.

You can get the OpCon software from Docker Hub as Docker images. Deploy the OpCon environment within your Kubernetes cluster by using AKS and a SQL Database server.

The following example architecture runs SMA OpCon in Azure by using a Kubernetes configuration. It uses a site-to-site VPN gateway to securely connect the cloud infrastructure and the on-premises infrastructure. This implementation uses a single virtual network and multiple subnets to support various functions. NSGs filter network traffic between Azure resources in the virtual network.

:::image type="complex" source="./media/opcon-datacenter-architecture.svg" alt-text="Diagram that shows the OpCon datacenter architecture." lightbox="./media/opcon-datacenter-architecture.svg" border="false":::
The diagram has two main sections: the on-premises network and Azure. The environments are connected via a site-to-site VPN tunnel over the internet. The on-premises network includes a subnet that contains a local network gateway, VPN connection, and virtual network gateway. This subnet points to Unisys ClearPath Forward, IBM zOS or AS400, and Windows and Linux servers via a green line that represents logical connections to OpCon agents. The subnet points to an OpCon MFT server via a red line that represents logical REST API connections to applications. Users also reside in the on-premises network. The Azure virtual network contains the OpCon subnet, private endpoint subnet, gateway subnet, and applications subnet. The OpCon subnet contains OpCon, which points to the opconconfig and opconlog components in the same subnet. It also points to SQL Database (via a black line) and Storage (via a blue line) in the private endpoint subnet. The applications subnet contains Unisys ClearPath Forward, Windows, Linux, an OpCon MFT server, and an application server. OpCon points to Unisys ClearPath Forward, Windows, and Linux via a green line. OpCon points to an OpCon MFT server and application server via a red line. An OpCon MFT server points to Storage via a blue line that represents Logical Connector connections to applications. All subnets except the private endpoint subnet are connected via NSGs.
:::image-end:::

### Workflow: OpCon datacenter

1. You deploy the OpCon core services container within an AKS cluster that you manage. PersistentVolumes (Azure Files CSI storage drivers) store logs and configuration information to ensure data persistence across container restarts.
   - The OpCon core services connect to the OpCon database through the configured Azure private endpoint, which provides secure access to the SQL Database server.

   - OpCon core services communicate with OpCon agents that are installed on VMs within the virtual network environment. The services also communicate with on-premises systems via the virtual network gateway.
  
   -  Similarly, OpCon core services communicate directly with application REST API endpoints within the virtual network environment. The services also communicate with on-premises systems via the virtual network gateway by using REST API connectivity options.
   - OpCon core services provide Solution Manager, which is a web-based user interface that interacts with the entire OpCon environment. 
   - NSGs limit traffic flow between subnets. 

1. The OpCon database objects and data are stored in a SQL database that's configured to communicate through a private endpoint.

1. OpCon core services interact with Storage via OpCon connector technology. This integration provides capabilities to manage Blob Storage. OpCon MFT also supports interaction with Storage.

1. The applications subnet includes the VMs that provide the application infrastructure. You could also install the application servers into multiple subnets or virtual networks to create separate environments for web servers, application servers, or other systems.
   - Application VMs or on-premises legacy systems require connections to the OpCon core services to manage their workloads. Applications that provide REST API endpoints don't require extra software.

   - The subnet includes an OpCon MFT server. This OpCon component provides full file transfer capabilities, such as compression, encryption, decryption, decompression, file watching, and automated file routing for the enterprise.
   - NSGs limit traffic flow between subnets. 

1. In this hybrid environment, the gateway subnet provides a secure connection between the on-premises environment and the Azure environment through a site-to-site VPN tunnel connection.
   
1. The gateway establishes a secure site-to-site VPN connection by using IPsec/IKE between the Azure VPN gateway and the on-premises VPN device. All data that passes between Azure and the on-premises network is encrypted within this private tunnel as it travels over the internet.

1. The local network gateway represents the gateway on the opposite end of the tunnel within the on-premises environment. This gateway contains configuration information required to establish and maintain the tunnel connection.

1. All user requests are routed via the VPN gateway connection to the OpCon core services environment.
   - Users interact with OpCon Solution Manager, which is a web-based user interface for the following tools:

     - OpCon administration 
     - OpCon MFT administration
     - OpCon workflow development, implementation, and monitoring  
     - OpCon Self Service
     - OpCon Vision (task dashboard)
     - OpCon MFT central application (dashboard and query application)

1. OpCon core services communicate with OpCon agents that are installed on on-premises systems through the virtual network gateway.  

   Similarly, OpCon core services use the virtual network gateway to communicate directly with on-premises systems via application REST API endpoints. This approach uses REST API-based connectivity options.

## Scenario details

The OpCon datacenter is the on-premises version of OpCon. You install and manage all software. This example architecture runs SMA OpCon in Azure by using a Kubernetes configuration. It serves as a single automation control point to automate workflows across the enterprise, both on-premises and in Azure. OpCon facilitates workflows among all servers and systems in an enterprise. OpCon SAM is the core OpCon module. It communicates with agents on target systems to schedule tasks, monitor tasks, and receive external events. You can deploy these agents across many platforms, including Windows, Linux/Unix, Unisys ClearPath Forward mainframes (MCP and 2200), IBM z/OS, and IBM AIX, which brings all systems under a unified automation framework.

### Choose between OpCon Cloud and the OpCon datacenter

OpCon Cloud is a managed service that SMA provides within the SMA Azure environment. SMA handles the environment management, which ensures business continuity through OpCon database backups and disaster recovery capabilities, including failover to a separate region. SMA also provides software upgrades as part of the service.

The OpCon datacenter is the OpCon solution that you can install either on-premises or within your local cloud environment.

If you want to take advantage of the SMA service offering later, you can seamlessly transition from the OpCon datacenter to OpCon Cloud.

### Components

- [AKS clusters](/azure/well-architected/service-guides/azure-kubernetes-service) are managed environments that simplify deploying, managing, and scaling containerized applications that use Kubernetes.

  In the OpCon Cloud architecture, the OpCon core services are deployed within an AKS cluster to ensure efficient management and scalability of containerized workloads. PersistentVolumes within the AKS cluster provide storage, and an Azure private endpoint establishes secure database connections to maintain data integrity.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) provides the flexibility of virtualization without having to buy and maintain the physical hardware that runs it. Both Windows and Linux support Azure VMs.

  These architectures use Azure VMs to host OpCon agents that communicate with OpCon core services for workload management.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources, such as Azure VMs, to securely communicate with each other, the internet, and on-premises networks.

  In these architectures, Virtual Network supports multiple subnets for different functions and uses NSGs to filter traffic.

- [Azure network interface cards](/azure/virtual-network/virtual-network-network-interface) enable an Azure VM to communicate with the internet, Azure, and on-premises resources.

  In these architectures, network interface cards enable VMs to communicate within virtual networks and with external resources, which enhances security and performance. They also support high availability and load balancing by distributing traffic and ensuring service continuity.

- [Azure Files](/azure/well-architected/service-guides/azure-files) provides fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. You can mount Azure file shares concurrently on Windows, Linux, and macOS systems, whether they run in the cloud or on-premises. 

  In the OpCon Cloud architecture, OpCon core services store transaction records, such as financial or sales records, in Blob Storage for secure and scalable storage. The core services also use MFT to automate the secure transfer of these files to various departments. This integration enhances data security, reliability, and operational efficiency.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a fully managed relational database service for the cloud. It provides high availability, scalability, and built-in intelligence for single databases or elastic pools.

  [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a fully managed SQL Server instance in the cloud that provides almost complete compatibility with on-premises SQL Server.

  In these architectures, the OpCon database is hosted in a SQL Database instance and accessed through a private endpoint. The OpCon back end can use either SQL Database or SQL Managed Instance to manage OpCon entries.

- [OpCon](https://smatechnologies.com/product-opcon) is an enterprise-grade workload automation and orchestration platform that enables organizations to schedule, monitor, and manage IT processes across hybrid environments through centralized control and self-service interfaces.

  In these architectures, OpCon core services communicate with agents and REST API endpoints within the virtual network.
- [OpCon Cloud](https://assets.smatechnologies.com/production/assets/files/Hosting-OpCon-in-the-Cloud-FAQ.pdf) is a fully managed, cloud-hosted version of the OpCon automation platform deployed in Azure.

  In the OpCon Cloud architecture, OpCon Cloud automates workflows across the enterprise, both on-premises and in Azure. An OpCon instance runs in a Linux container within a Kubernetes replica-set and SQL Server serves as the OpCon database. The virtual network is private and secure.
- [OpCon Self Service](https://help.smatechnologies.com/opcon/core/v21.0/Files/UI/Solution-Manager/Working-with-Self-Service) is a web-based implementation that allows users to run on-demand tasks, often with the option to input arguments within the OpCon environment.

  These architectures use OpCon Self Service to provide a user interface for task implementation and monitoring.

- [OpCon Vision](https://smatechnologies.com/product-opcon/opcon-vision) provides a dashboard to monitor OpCon tasks. It shows a logical representation of the tasks across all flows. Tasks are grouped by using tags, and each group represents all associated tasks. When problems occur, you can drill down from the dashboard to the failed task.

  These architectures use OpCon Vision to set service-level objective (SLO) values for task groups and provide early warnings when SLO values are about to be exceeded.

- [OpCon MFT](https://help.smatechnologies.com/opcon/agents/opconmft/introduction) enables secure, managed file transfers within the OpCon environment. It integrates a dedicated MFT agent and File Transfer Server to provide enterprise-wide file transfer and monitoring capabilities.

  These architectures use OpCon MFT to support compression, decompression, encryption, decryption, file watching, and automated file routing. For example, a regional healthcare provider might process daily insurance claims and need to send files securely to multiple insurance partners by using different formats, encryption requirements, and delivery methods. OpCon MFT helps reduce errors, ensure encryption, and provide flexibility.

### Alternatives

The following sections describe alternatives to consider when you implement the solution.

#### Component placement

The placement of the VMs and OpCon database is flexible.

- The applications subnet can include the application VMs. You can also install the application servers in multiple subnets or virtual networks. Use this approach when you want to create separate environments for different types of servers, such as web servers and application servers.

- You can place the database inside or outside the OpCon subnet.

#### SQL Managed Instance

Instead of using SQL Database, you can use SQL Managed Instance as the OpCon database. You can install the SQL managed instance in the OpCon subnet. Alternatively, you can install the managed instance in a separate subnet that you use exclusively for SQL managed instances within the existing virtual network.

#### Azure ExpressRoute

Instead of using a VPN gateway and a site-to-site VPN tunnel, you can connect to the Microsoft global network through Azure ExpressRoute, which is established via a connectivity provider. ExpressRoute connections don't bypass the public internet.  

ExpressRoute suits hybrid applications that run large-scale, mission-critical workloads that require a high degree of scalability and resiliency. 

## AKS configuration

The deployed OpCon environment consists of two pods, OpCon and Impex, within a single replica set and an Azure SQL database. A load balancer controls access to the pods. The load balancer maps the external addresses and ports to the internal REST API server endpoints.

The following diagram shows configuration requirements and the relationship between various definitions in the Kubernetes YAML file.

:::image type="content" source="./media/opcon-kubernetes.svg" alt-text="Diagram that shows the Kubernetes configuration." lightbox="./media/opcon-kubernetes.svg" border="false":::

- Kind: Secret (dbpasswords) 

  The dbpasswords Secret contains the database passwords required to connect to the OpCon database.

- Kind: ConfigMap (opcon)  

  The opcon ConfigMap contains OpCon REST API information, the time zone, the language, and OpCon database information such as address, database name, and database user.

- Kind: ConfigMap (impex)  

  The impex ConfigMap contains Impex REST API information and OpCon database information such as address, database name, and database user.

- Kind: PersistentVolumeClaim (impexlog)  

  The impexlog PersistentVolumeClaim contains the log files associated with the Impex environment.

- Kind: PersistentVolumeClaim (opconlog)  

  The opconlog PersistentVolumeClaim contains the log files associated with the OpCon environment.

- Kind: PersistentVolumeClaim (opconconfig)  

  The opconconfig PersistentVolumeClaim contains the various .ini files and the OpCon license file.

- Kind: ReplicaSet (opcon)

  The opcon and impex container definitions reference the previously defined Secret, ConfigMaps, and PersistentVolumeClaim definitions.

- Kind: Service (LoadBalancer)

  The LoadBalancer Service defines the mapping of the internal REST API ports for the OpCon and Impex REST API servers to external addresses and ports.

### Potential use cases

- A global finance firm automates secure file transfers to ensure timely processing of end-of-day financial reports.

- A retail company centralizes IT operations control to enhance efficiency.
- A nationwide retail chain uses batch scheduling to automate nightly inventory reconciliation, which ensures that reports are ready by the start of the business day.
- An enterprise IT team builds self-service workflows to reduce dependency on admin access and empower staff.
- A healthcare provider coordinates server patch deployment to help ensure compliance.
- An insurance company automates Microsoft Patch Tuesday updates by using OpCon workflows, which helps ensure timely compliance.
- A software development team automates Azure resource management to optimize cloud spend.
- An enterprise uses OpCon's centralized interface to monitor workflows and server statuses, which improves service-level agreement adherence.
- HR automates onboarding to reduce onboarding time from hours to minutes.
- A logistics company tracks shipment events. OpCon monitors for specific database entries and automatically triggers the next workflow, such as invoice generation, email alerts, or updates.

## Considerations
 
These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

OpCon Cloud reduces infrastructure and maintenance costs, while providing you with the security and reliability of an always-on solution. It also provides fast recovery from unplanned system interruptions or disasters. OpCon has its own built-in recovery capability. Or you can use Azure Site Recovery to maintain copies of the OpCon environment for use in disaster recovery situations. 

For the Azure Files CSI driver in AKS, we recommend that you use the Premium_LRS tier. This tier provides locally redundant storage to ensure that your data is replicated within a single physical location. It also provides high performance and low latency, so it suits workloads that require fast and reliable storage.

For disaster recovery, OpCon can provide automated orchestration if you require strict recovery time objective (RTO) and recovery point objective (RPO) compliance for mission-critical systems. During datacenter outages or cyber incidents, you can use OpCon to automate your entire disaster recovery playbook. This approach ensures a graceful shutdown of primary site workloads and initiates failover sequences to the disaster recovery site or cloud environment. This process includes remapping storage, re-establishing database connections, and performing validation checks.

This approach provides the following benefits: 
- Faster and more reliable recovery with minimal human intervention
- Regular disaster recovery testing without disrupting production systems
- Assurance of regulatory compliance
- Reduced downtime

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The OpCon Cloud configuration doesn't require outbound connections because the Relay app manages these connections. The Relay app uses TLS 1.3 for secure communication.

The AKS configuration captures and encrypts the required passwords. Workload identity isn't supported.

The OpCon datacenter configuration builds in security by using gateway subnets to route only authorized traffic. To keep all target systems within the OpCon environment current with the latest vulnerability patches, you can use OpCon automation to update security patches. For more information, see [Security baselines for Azure](/security/benchmark/azure/security-baselines-overview). 

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

OpCon workload automation reduces manual steps to ensure consistent workflows that improve efficiency with each iteration. This feature helps prevent human error and manual data input, which saves time and resources that you spend on reruns. For more examples, see [What is workload automation?](https://smatechnologies.com/blog/what-is-workload-automation)

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

OpCon delivers enterprise power and scalability without the complexity or cost. It simplifies automation of manual tasks and seamlessly orchestrates workloads across business-critical operations. It helps you reduce human error, save time, and allow IT teams to focus on strategic initiatives.

For OpCon Cloud, SMA sets up, deploys, and manages the OpCon environment. These tasks include container life cycle management and disaster recovery options, which save time and reduce errors.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

You can use OpCon to monitor workloads and dynamically scale resources by using Azure. You can increase resources during high demand or shut down resources during off-peak times.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Bertie Vanhinsbergen](https://www.linkedin.com/in/gys-bertie-van-hinsbergen-7802204) | Principal Automation Consultant

Other contributor:

- [Philip Brooks](https://www.linkedin.com/in/philipbbrooks) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about this solution:

- Contact the [Legacy Migrations Engineering team](mailto:legacy2azure@microsoft.com).
- Contact [SMA](https://smatechnologies.com/contact-us). [SMA Technologies](https://smatechnologies.com) is a Microsoft Gold-level partner in the IT automation space.

## Related resources

- [Unisys ClearPath Forward OS 2200 enterprise server virtualization on Azure](../../mainframe/virtualization-of-unisys-clearpath-forward-os-2200-enterprise-server-on-azure.yml)
- [Unisys ClearPath Forward MCP mainframe rehost to Azure by using Unisys virtualization](../../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml)