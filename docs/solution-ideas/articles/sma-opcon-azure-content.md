[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes two OpCon options for implementation in Azure. The first is a managed OpCon implementation supplied and managed by SMA called *OpCon Cloud* and the second is cloud installation created and managed by you called *OpCon Datacenter*.

Reviewing both options will help you make a decision on which approach is best suited for your specific scenario.

## Architecture: OpCon Cloud

Figure 1 provides an architectural diagram explaining how an *OpCon Cloud* environment using Azure SQL Database for the database requirements should be deployed within an Azure environment or a hybrid Azure on-premises environment.
The implementation uses a single virtual network and multiple subnets to support the various functions. Network security groups (NSGs) are used to filter network traffic between Azure resources in the virtual network.

:::image type="complex" source="../media/opcon-cloud-architecture.svg" alt-text="Architecture diagram that shows how to deploy OpCon in Azure or a hybrid environment." lightbox="../media/opcon-cloud-architecture.svg" border="false":::
The diagram has two main sections: the on-premises network and Azure. The environments are connected via the internet. The on-premises network includes various devices and servers such as Unisys ClearPath Forward, IBM zOS or AS400, and Windows and Linux servers. OpCon Relay points to these components via a green line that represents logical connections to OpCon agents. The on-premises network also contains an OpCon MFT server. Opcon Relay points to this component via a red line that represents logical REST API connections to applications. OpCon Relay connects to Opcon in the Azure environment via the internet. Users also reside in the on-premises network. The Azure virtual network contains the OpCon subnet and the applications subnet. The OpCon subnet contains OpCon, which points to Azure SQL Database and the opconconfig and opconlog components in the same subnet. The applications subnet contains Unisys ClearPath Forward, Windows, Linux, Azure Storage, an OpCon MFT server, and an application server. OpCon points to Azure Storage, an OpCon MFT server, and an application server via a red line that represents logical REST API connections to applications. OpCon points to Unisys ClearPath Forward, Windows, and Linux via a green line that represents logical connections to OpCon agents. The OpCon MFT server points to Azure Storage via a blue line that represents Logical Connector connections to applications. The OpCon subnet and applications subnet are connected via a network security group.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/opcon-architectures.vsdx) of this architecture.*

### Workflow: OpCon Cloud

1. You deploy the OpCon core services container within an Azure Kubernetes Service (AKS) cluster that you manage. PersistentVolumes (Azure Files CSI storage drivers) are used for the storage of logs and configuration information to ensure data persistence across container restarts.

   - Database connections between the OpCon Core services and the OpCon database are established through the configured Azure Private Endpoint that provides secure access to the Azure SQL Database server.

   - OpCon Core services communicate with OpCon Agents installed on virtual machines within the Virtual Network environment or with on-premises systems through the Relay Software component.
   - Similarly, OpCon Core services communicate directly with Application Rest-API endpoints within the Virtual Network environment or with on-premises systems through the Relay Software component using the 'Connectionless' system.
   - OpCon Core services provide Solution Manager which is the web-based user interface for interacting with the entire OpCon environment. 
   - NSGs are used to limit traffic flow between subnets.

1. The OpCon database objects and data are installed within an Azure SQL Database server which is reached through a private endpoint.

1. OpCon Connector technology allows OpCon Core services to interact with Azure Storage providing capabilities to manage Blob Storage. OpCon Managed File Transfer (MFT) also supports interaction with Azure Storage.

1. The application subnet includes the virtual machines that provide the application infrastructure. The application servers could also be installed into multiple subnets or virtual networks creating separate environments for web servers, application servers, etc.

   - Application virtual machines or on-premises legacy systems require connections to the OpCon Core services for the management of their workloads, while applications providing REST API endpoints don't require extra software.

   - The subnet includes an OpCon MFT server which is an OpCon component that provides full file transfer capabilities such as compression, encryption, decryption, decompression, file watching, and automated file routing for the enterprise.
   - NSGs are used to limit traffic flow between subnets.

1. In a hybrid environment, an Internet connection is required to link the on-premises environment to the OpCon Cloud instance.

1. OpCon Relay is a software component that manages on-premises agents.
   - The link between OpCon Cloud and Relay uses standard encrypted protocols via WebSockets.

   - Agent configurations are 'pushed' out from OpCon to the defined relay component meaning the configuration is only defined once within the OpCon environment.
   - Once the OpCon Relay receives its configuration, it establishes connections to the on-premises OpCon agents and reports the status of these agents to the OpCon environment in Azure. Messages to and from agents are passed across the defined connection.
   - It's also possible to install 'Connectionless' agents within the Relay environment.

1. All user requests are routed via the Internet connection to the OpCon Core services environment.
   - User access utilizes the OpCon Solution Manager framework, a web-based user interface for  

     - OpCon administration
     - OpCon MFT administration
     - OpCon workflow development, execution, and monitoring
     - OpCon Self Service
     - Vision (OpCon Task Dashboard)
     - OpCon MFT Central Application (dashboard & query application)

1. OpCon Core services communicate with OpCon Agents installed on on-premises systems through the OpCon Relay software component.

   Similarly, OpCon Core services communicate directly with Application REST API endpoints within the on-premises systems through the OpCon Relay software component using REST API connectivity options.

## Scenario details

OpCon Cloud is an Azure Cloud installed version of OpCon which is provisioned and managed by SMA. SMA manages software upgrades and monitoring services. It's also possible to purchase more services to assist for creating workflows.

This example architecture depicts an example of running SMA's OpCon Cloud environment in Azure. From this single automation control point, OpCon automates workflows across the enterprise – both on-premises and in Azure - facilitating workflows among all servers/systems in the enterprise. The OpCon Schedule Activity Monitor (SAM) is the core OpCon module and communicates with agents on target systems for scheduling and monitoring tasks as well as receiving external events. OpCon agents are supported for installation on Windows, Linux / Unix, Unisys ClearPath Forward mainframes (MCP and 2200), IBM z/OS, and IBM AIX drawing all these platforms under one automation umbrella.

OpCon Relay connects on-premises systems with the OpCon Cloud environment through a single point of contact. This feature eliminates the need for Azure VPN connections.

A 'Connectionless' agent platform is also available that provides direct connectivity between OpCon Cloud systems and REST API implementations. With this platform, no extra containers are required to support connections to applications.

OpCon Cloud is provisioned within the SMA environment and managed by SMA. On-premises servers are connected to the Relay software component. It's possible to install multiple Relay components within the on-premises environment. For OpCon Cloud, the OpCon environment is deployed within a Kubernetes cluster using the Azure Kubernetes Service and an Azure SQL Database server.

## Architecture: OpCon Datacenter

If you want more control, you can install and manage OpCon yourself within the Azure cloud environment. You can design a hybrid cloud and on-premises infrastructure, or a cloud-only infrastructure.

The OpCon software is available from Docker Hub as Docker images.

You'll deploy the OpCon environment within your own Kubernetes cluster using the Azure Kubernetes Service and an Azure SQL Database server. The following example architecture depicts an example of running SMA's OpCon in Azure using a Kubernetes configuration.

Figure 2 provides an architectural diagram explaining how an OpCon environment using Azure SQL Database for the database requirements is deployed by you within an Azure environment or a hybrid Azure on-premises environment. The figure uses a site-to-site VPN Gateway to provide a secure link between the cloud infrastructure and the on-premises infrastructure.

:::image type="complex" source="../media/opcon-datacenter-architecture.svg" alt-text="Diagram that shows the OpCon Datacenter architecture." lightbox="../media/opcon-datacenter-architecture.svg" border="false":::
The diagram has two main sections: the on-premises network and Azure. The environments are connected via a site-to-site VPN tunnel over the internet. The on-premises network includes a subnet that contains a local network gateway, VPN connection, and Virtual Network gateway. This subnet points to Unisys ClearPath Forward, IBM zOS or AS400, and Windows and Linux servers via a green line that represents logical connections to OpCon agents. The subnet points to an OpCon MFT server via a red line that represents logical REST API connections to applications. Users also reside in the on-premises network. The Azure virtual network contains the OpCon subnet, applications subnet, and gateway subnet. The OpCon subnet contains OpCon, which points to Azure SQL Database and the opconconfig and opconlog components in the same subnet. The applications subnet contains Unisys ClearPath Forward, Windows, Linux, Azure Storage, an OpCon MFT server, and an application server. OpCon points to Unisys ClearPath Forward, Windows, and Linux via a green line that represents logical connections to OpCon agents. OpCon points to an OpCon MFT server and application server via a red line that represents logical REST API connections to applications. OpCon and an OpCon MFT server point to Azure Storage via a blue line that represents Logical Connector connections to applications. The subnets are connected via a network security group.
:::image-end:::

The implementation uses a single virtual network and multiple subnets to support the various functions. NSGs are used to filter network traffic between Azure resources in the virtual network.

### Workflow: OpCon Datacenter

1. You deploy the OpCon Core services container within an Azure Kubernetes Service (AKS) cluster you manage. PersistentVolumes (Azure Files CSI storage drivers) are used for the storage of logs and configuration information to ensure data persistence across container restarts.
   - Database connections between the OpCon Core services and the OpCon database are established through the configured Azure Private Endpoint that provides secure access to the Azure SQL Database server.

   - OpCon Core services communicate with OpCon Agents installed on virtual machines within the Virtual Network environment or with on-premises systems through the Virtual Network Gateway.
  
   -  Similarly, OpCon Core services communicate directly with Application Rest-API endpoints within the Virtual Network environment or with on-premises systems through the Virtual Network Gateway using Rest-API connectivity options.  
   - OpCon Core services provide Solution Manager which is the web-based user interface for interacting with the entire OpCon environment. 
   - NSGs are used to limit traffic flow between subnets. 

1. The OpCon database objects and data are stored in an Azure SQL Database that is configured to communicate through a private endpoint.

1. OpCon Connector technology allows OpCon Core services to interact with Azure Storage providing capabilities to manage Blob Storage. OpCon Managed File Transfer (MFT) also supports interaction with Azure Storage.

1. The application subnet includes the virtual machines that provide the application infrastructure. The application servers could also be installed into multiple subnets or virtual networks creating separate environments for web servers, application servers, etc.
   - Application virtual machines or on-premises legacy systems require connections to the OpCon Core services for the management of their workloads, while applications providing REST API endpoints don't require extra software.

   - The subnet includes an OpCon MFT server which is an OpCon component that provides full file transfer capabilities such as compression, encryption, decryption, decompression, file watching, and automated file routing for the enterprise.
   - NSGs are used to limit traffic flow between subnets. 

1. In a hybrid environment, the gateway subnet provides a secure connection between the on-premises environment and the Azure Cloud environment through a Site-to-Site VPN tunnel connection.
   
1. The gateway includes a cross-premises IPsec/IKE VPN tunnel connection between the VPN gateway and an on-premises VPN device (Site-to-Site). All data passed between the Azure Cloud and the on-premises environment is encrypted in the private tunnel as it crosses the internet.

1. The local network gateway is a representation of the gateway on the other end of the tunnel within the on-premises environment. This gateway holds configuration information that the tunnel needs to know about to build a VPN tunnel to the other end.

1. All user requests are routed via the VPN gateway connection to the OpCon Core services environment.
   - User access utilizes the OpCon Solution Manager framework, a web-based user interface for  

     - OpCon Administration.  
     - OpCon MFT Administration.  
     - OpCon workflow development, execution, and monitoring.  
     - Self-Service.  
     - Vision (OpCon Task Dashboard).  
     - OpCon MFT Central Application (Dashboard & Query application).

1. OpCon Core services communicate with OpCon Agents installed on on-premises systems through the Virtual Network Gateway.  

   Similarly, OpCon Core services communicate directly with Application Rest-API endpoints within the on-premises systems through the Virtual Network Gateway using Rest-API connectivity options.  

## Scenario details

OpCon Datacenter is the on-premises version of OpCon and all of the software is installed and managed by you. This example architecture depicts an example of running SMA's OpCon in Azure using a Kubernetes configuration.

From this single automation control point, OpCon automates workflows across the enterprise – both on-premises and in Azure - facilitating workflows among all servers/systems in the enterprise. The OpCon Schedule Activity Monitor (SAM) is the core OpCon module and communicates with agents on target systems for scheduling and monitoring tasks as well as receiving external events. OpCon agents are supported for installation on Windows, Linux / Unix, Unisys ClearPath Forward mainframes (MCP and 2200), IBM z/OS, and IBM AIX drawing all these platforms under one automation umbrella. 

### Choose between OpCon Cloud and OpCon Datacenter

OpCon Cloud is a managed service provided by SMA within the SMA Azure environment. SMA handles the environment management, which ensures business continuity through OpCon database backups and disaster recovery capabilities, including failover to a separate region. SMA also provides software upgrades as part of the service.

OpCon Datacenter is the OpCon solution that you can install either on-premises or within your local cloud environment.

If you want to take advantage of the SMA service offering, you can seamlessly transition from OpCon Datacenter to OpCon Cloud.

### Components

- [AKS clusters](/azure/well-architected/service-guides/azure-kubernetes-service) are managed environments that simplify deploying, managing, and scaling containerized applications that use Kubernetes. In the OpCon Cloud architecture, the OpCon core services are deployed within an AKS cluster to ensure efficient management and scalability of containerized workloads. PersistentVolumes within the AKS cluster provide storage, and an Azure private endpoint establishes secure database connections to maintain data integrity.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) Azure virtual machines (VMs) give you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it. With Azure VMs, you have a choice of operating system which includes both Windows and Linux.

  These architectures use Azure VMs to host OpCon agents that communicate with OpCon core services for workload management.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) Azure Virtual Network is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks.

  In these architectures, Virtual Network supports multiple subnets for different functions and uses NSGs to filter traffic.

- [Azure network interface cards](/azure/virtual-network/virtual-network-network-interface) - A network interface enables an Azure Virtual Machine to communicate with internet, Azure, and on-premises resources.

  In these architectures, network interface cards enable VMs to communicate within virtual networks and with external resources, which enhances security and performance. They also support high availability and load balancing by distributing traffic and ensuring service continuity.

- [Azure Files](/azure/well-architected/service-guides/azure-files) Azure Files offers fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS. 

  In the OpCon Cloud architecture, OpCon core services store transaction records, such as financial or sales records, in Azure Blob Storage for secure and scalable storage. The core services also use MFT to automate the secure transfer of these files to various departments. This integration enhances data security, reliability, and operational efficiency.

- Microsoft Azure SQL Database or [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) – The OpCon backend can utilize either Azure SQL Database or SQL Managed Instances to manage OpCon entries.

  In these architectures, the OpCon database is hosted in an Azure SQL Database instance and accessed through a private endpoint.

- [OpCon](https://smatechnologies.com/product-opcon) - OpCon core services running in a Linux container within a Kubernetes replica-set using an Azure SQL Server for the OpCon database.

  In these architectures, OpCon core services communicate with agents and Rest API endpoints within the virtual network.
- [OpCon Cloud](https://assets.smatechnologies.com/production/assets/files/Hosting-OpCon-in-the-Cloud-FAQ.pdf?dm=1709355517) - OpCon hosting service provided by SMA which includes an OpCon instance running in a Linux container within a Kubernetes replica-set, an Azure SQL Server for the OpCon database, and a virtual network with a gateway to provide site-to-site VPN communication. The virtual network is private and has no accessible public interfaces.

   These architectures use OpCon Cloud to automate workflows across the enterprise, both on-premises and in Azure.
- [OpCon Self Service](https://help.smatechnologies.com/opcon/core/v21.0/Files/UI/Solution-Manager/Working-with-Self-Service) - OpCon Self Service is a web-based implementation that allows users to execute on-demand tasks, optionally entering arguments within the OpCon environment.

  These architectures use OpCon Self Service to provide a user interface for task implementation and monitoring.

- [OpCon Vision](https://smatechnologies.com/product-opcon/opcon-vision) provides a dashboard capability for monitoring OpCon tasks. It's a logical representation of the tasks across all flows. Tasks are grouped using tags, with each group representing all associated tasks. When problems occur is it possible to 'drill' down from the dashboard to the failed task.

  These architectures use OpCon Vision to set SLO values for task groups and provide early warnings if SLO values will be exceeded.

- [OpCon MFT](https://help.smatechnologies.com/opcon/agents/opconmft/introduction) provides managed file transfer within the OpCon environment. Providing file transfer and monitoring functionality across the enterprise using an integrated MFT Agent and a File Transfer Server.

  These architectures use OpCon MFT to support compression, encryption, decryption, decompression, file watching, and automated file routing. For example, a regional healthcare provider might process daily insurance claims and need to send files securely to multiple insurance partners by using different formats, encryption requirements, and delivery methods. OpCon MFT helps reduce errors, ensure encryption, and provide flexibility.

### Alternatives

The following sections describe alternatives to consider when you implement the solution.

#### Component placement

The placement of the VMs and OpCon database is flexible.

- The application subnet can include the application VMs. You can also install the application servers in multiple subnets or virtual networks. Use this approach when you want to create separate environments for different types of servers, such as web and application servers.

- You can place the database inside or outside the OpCon subnet.

#### SQL Managed Instance

Instead of using SQL Database, you can use SQL Managed Instance as the OpCon database. You can install the SQL managed instance in the OpCon subnet. Alternatively, you can install the managed instance in a separate subnet that you use exclusively for SQL managed instances in the existing virtual network.

#### ExpressRoute

Instead of using a VPN Gateway and a Site-to-Site VPN Tunnel, an ExpressRoute connection to the Microsoft Global Network using a connectivity provider could be used. ExpressRoute connections don't go over the public internet.  

ExpressRoute is recommended for hybrid applications running large-scale mission-critical workloads that require a high degree of scalability and resiliency. 

## Azure Kubernetes Service configuration

The deployed OpCon environment consists of two pods (OpCon & Impex) within a single replica set and an Azure SQL database. Access to the pods is controlled through a load balancer that maps the external addresses and ports to the internal REST API server addresses ports. Figure 3 shows the configuration requirements and the relationship between the various definitions.

:::image type="content" source="../media/opcon-kubernetes.svg" alt-text="Diagram that shows the Kubernetes configuration." lightbox="../media/opcon-kubernetes.svg" border="false":::

The previous diagram shows the various definitions included in the Kubernetes configuration YAML file.

- Kind: Secret - dbpasswords   

  Contains the database passwords required to connect to the OpCon database.

- Kind: ConfigMap - opcon  

  The OpCon config map contains the OpCon database information (address, DB name, DB user), the OpCon REST API information, and time zone and language information.

- Kind: ConfigMap - impex  

  The Impex config map contains the OpCon database information (address, db name, db user) and the Impex REST API information.

- Kind: PersistentVolumeClaim - opconconfig  

  The opcon config PVC contains the various .ini files and the OpCon license file.

- Kind: PersistentVolumeClaim - opconlog  

  The opconlog PVC contains the log files associated with the OpCon environment.

- Kind: PersistentVolumeClaim - impexlog  

  The impexlog PVC contains the log files associated with the Impex environment.

- Kind: ReplicaSet - opcon

  The OpCon and Impex container definitions referencing the previously defined secret, configmaps, and PersistentVolumeClaim definitions.

- Kind: Service – loadbalancer

  Defines the mapping of the internal REST API ports for the OpCon and Impex REST servers to external addresses and ports.

### Potential Use Cases

- A global finance firm automates secure file transfers to ensure timely processing of end-of-day financial reports.

- A retail company centralizes IT operations control to enhance efficiency.
- A nationwide retail chain uses batch scheduling to automate nightly inventory reconciliation, which ensures that reports are ready by the start of the business day.
- An enterprise IT team builds self-service workflows to reduce dependency on admin access and empower staff.
- A healthcare provider coordinates server patch deployment to help ensure compliance.
- An insurance company automates Microsoft Patch Tuesday updates by using OpCon workflows, which helps ensure timely compliance.
- A software development team automates Azure resource management to optimize cloud spend.
- An enterprise uses OpCon's centralized interface to monitor workflows and server statuses, which improves SLA adherence.
- HR automates onboarding to reduce onboarding time from hours to minutes.
- A logistics company tracks shipment events. OpCon watches for specific database entries and automatically triggers the next workflow, such as invoice generation, email alerts, or updates.

## Considerations
 
These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

OpCon Cloud reduces infrastructure and maintenance costs, while providing clients with the security and reliability of an always-on solution and fast recovery from unplanned system interruptions or disasters. OpCon has its own built-in resiliency capability or Azure Site Recovery can be utilized to maintain copies of the OpCon environment for use in DR situations. 

For The Azure Files CSI driver in AKS, we recommend that you use the Premium_LRS tier. This tier provides locally redundant storage to ensure that your data is replicated within a single physical location. It also provides high performance and low latency, so it suits workloads that require fast and reliable storage.

For disaster recovery, OpCon can provide automated orchestration for organizations that require strict RTO and RPO compliance for their mission-critical systems. During datacenter outages or cyber incidents, you can use OpCon to automate your entire disaster recovery playbook. This approach ensures a graceful shutdown of primary site workloads and initiates failover sequences to the disaster recovery site or cloud environment. This process includes re-mapping storage, re-establishing database connections, and performing validation checks. The benefits of this approach include faster and more reliable recovery with minimal human intervention, regular disaster recovery testing without disrupting production systems, assurance of regulatory compliance, and reduced downtime.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The OpCon Cloud configuration doesn't require outbound connections because the Relay app manages these connections. The Relay app uses TLS 1.3 for secure communication.

The AKS configuration captures and encrypts the required passwords. Workload identity isn't supported.

The OpCon configuration builds in security by using Gateway subnets to route only authorized traffic. Via OpCon automation, tasks such as security patch updating can be automated to ensure all target systems within the OpCon environment are kept current with the latest vulnerability patches. For more information, see Security baselines for Azure overview. 

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

OpCon workload automation reduces manual steps ensuring that workflows are consistent with each iteration providing improved efficiency. This feature reduces the amount of time and resources needed for reruns due to human error or manual data inputs. See What is Workload Automation? | SMA Technologies for more examples. 

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

OpCon delivers enterprise power and scalability without the complexity or cost. OpCon enables companies to easily automate manual tasks and seamlessly orchestrate workloads across business-critical operations, saving time and reducing cost by eliminating human error and deploying IT resources on strategic initiatives.

For OpCon Cloud, SMA sets up, deploys, and manages the OpCon environment, including container life cycle management and disaster recovery options, which saves time and reduces errors.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

OpCon can be used to monitor workloads and use the scalability of Azure to increase resources in times of high demand or deprecate resources off peak.   

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Bertie van Hinsbergen](https://www.linkedin.com/in/gys-bertie-van-hinsbergen-7802204) | Principal Automation Consultant

Other contributor:

- [Philip Brooks](https://www.linkedin.com/in/philipbbrooks) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about this solution:

- Contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- Contact [SMA](https://smatechnologies.com/contact-us). A Microsoft Gold-level partner, [SMA Technologies](https://smatechnologies.com) is a leader in the IT automation space. SMA is dedicated to the single purpose of giving time back to clients and their employees by automating processes, applications, and workflows.

## Related resources

- [Unisys ClearPath Forward OS 2200 enterprise server virtualization on Azure](../../mainframe/virtualization-of-unisys-clearpath-forward-os-2200-enterprise-server-on-azure.yml)
- [Unisys ClearPath Forward MCP mainframe rehost to Azure using Unisys virtualization](../../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml)
