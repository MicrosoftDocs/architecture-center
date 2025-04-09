[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

There are two OpCon options available for implementation in Azure. The first is a managed OpCon implementation supplied and managed by SMA called OpCon Cloud and the second is cloud installation created and managed by the customer called OpCon Datacenter.

OpCon Cloud  
OpCon Cloud is an Azure Cloud installed version of OpCon which is provisioned and managed by SMA. This includes software upgrades and monitoring services. It is also possible to purchase additional services to assist for creating workflows.
The following example architecture depicts an example of running SMA’s OpCon Cloud environment in Azure.   
From this single automation control point, OpCon automates workflows across the enterprise – both on-premises and in Azure - facilitating workflows amongst all servers/systems in the enterprise.  The OpCon Schedule Activity Monitor (SAM) is the core OpCon module and communicates with agents on target systems for scheduling and monitoring tasks as well as receiving external events. OpCon agents are supported for installation on Windows, Linux / Unix, Unisys ClearPath Forward mainframes (MCP and 2200), IBM z/OS, and IBM AIX drawing all these platforms under one automation umbrella. 
Relay, a new component, connects on-premises systems with the OpCon Cloud environment through a single point of contact. This eliminates the need for Azure VPN connections.
A new ‘Connectionless’ agent platform is also available that provides direct connectivity between OpCon Cloud systems and Rest-API implementations meaning no additional containers are required to support connections to applications. 

## Architecture

OpCon Cloud is provisioned within the SMA environment and managed by SMA. On-premises servers are connected to the Relay software component. It is possible to install multiple Relay components within the on-premises environment. 
For OpCon Cloud, the OpCon environment is deployed within a Kubernetes cluster using the Azure Kubernetes Service and an Azure SQL Server database.  
Figure 1 provides an architectural diagram explaining how an OpCon environment using Azure SQL for the database requirements can be deployed within an Azure environment or a hybrid Azure on-prem environment.  
The implementation uses a single virtual network and multiple subnets to support the various functions. Network security groups can be used to filter network traffic between Azure resources in the virtual network. 

:::image type="content" source="../media/sma-opcon-azure-architecture.svg" alt-text="Architecture diagram that shows how to deploy OpCon in Azure or a hybrid environment. Besides OpCon, components include SQL Database and VPN Gateway." lightbox="../media/sma-opcon-azure-architecture.svg" border="false":::
<Insert Figure 1: OpCon Cloud here>
*Download a [Visio file](https://arch-center.azureedge.net/sma-opcon-azure-architecture.vsdx) of this architecture.*

### Workflow

1. OpCon: An OpCon container provides the Core services which are deployed within an Azure Kubernetes Service. PersistentVolumes (Storage Class Azurefile) are used for the storage of logs and configuration information to ensure data persistence across container restarts. 
Database connections between the OpCon Core services and the OpCon database are established through the configured Azure Private Endpoint that provides secure access to the Azure SQL Server. 
OpCon Core services communicate with OpCon Agents installed on virtual machines within the Virtual Network environment or with on-premises systems through the Relay Software component. Similarly, OpCon Core services communicate directly with Application Rest-API endpoints within the Virtual Network environment or with on-premises systems through the Relay Software component using the new ‘Connectionless’ Systems.   
OpCon Core services provide Solution Manager which is the web-based user interface for interacting with the entire OpCon environment. 
Network Security Groups can be used to limit traffic flow between subnets should this be required. 


1. Azure SQL: The OpCon database is installed within an Azure SQL environment which is reached through a private endpoint.  

1. Azure Storage: OpCon Connector technology allows OpCon Core services to interact with Azure Storage providing capabilities to manage Blob Storage.  
OpCon Managed File Transfer (MFT) also supports interaction with Azure Storage. 

1. Applications: The application subnet includes the virtual machines that provide the application infrastructure. The application servers could also be installed into multiple subnets or virtual networks creating separate environments for web servers, application servers, etc.  
Application virtual machines or on-premises legacy systems require connections to the OpCon Core services for the management of their workloads, while applications providing Rest-API endpoints require no additional software.  
The subnet includes an OpCon MFT Server which is an OpCon component that provides full file transfer capabilities such as compression, encryption, decryption, decompression, file watching, and automated file routing for the enterprise.  
Network Security Groups can be used to limit traffic flow between subnets should this be required. 


1. Internet: In a hybrid environment, an Internet connection is required to link the on-premises environment to the OpCon Cloud instance.  

1. Relay: Relay is a software component that manages on-premises agents. The link between OpCon Cloud and Relay uses standard encrypted protocols via WebSockets. Agent configurations are ‘pushed’ out from OpCon to the defined Relay component meaning the configuration is only defined once within the OpCon environment. 
Once Relay receives its configuration, it establishes connections to the on-premises OpCon agents and reports the status of these agents to the OpCon environment. Messages to / from agents are passed across the defined connection.
It is also possible to install ‘Connectionless’ agents within the Relay environment.  


1.Users: All user requests are routed via the Internet connection to the OpCon Core services environment.   
User access utilizes the OpCon Solution Manager framework, a web-based user interface for  
•	OpCon Administration. 
•	OpCon MFT Administration. 
•	OpCon workflow development, execution, and monitoring. 
•	Self-Service. 
•	Vision (OpCon Task Dashboard). 
•	OpCon MFT Central Application (Dashboard & Query application).  


1. On-Premise network: OpCon Core services communicate with OpCon Agents installed on legacy systems within the on-premises systems through the Relay software component.  Similarly, OpCon Core services communicate directly with Application Rest-API endpoints within the on-premises systems through the Relay software component using Rest-API connectivity options.  

OpCon Datacenter
OpCon Datacenter is the on-premises version of OpCon and the software is installed and managed by the customer.
The following example architecture depicts an example of running SMA’s OpCon in Azure using a Kubernetes configuration.   
From this single automation control point, OpCon automates workflows across the enterprise – both on-premises and in Azure - facilitating workflows amongst all servers/systems in the enterprise.  The OpCon Schedule Activity Monitor (SAM) is the core OpCon module and communicates with agents on target systems for scheduling and monitoring tasks as well as receiving external events. OpCon agents are supported for installation on Windows, Linux / Unix, Unisys ClearPath Forward mainframes (MCP and 2200), IBM z/OS, and IBM AIX drawing all these platforms under one automation umbrella. 

Architecture 
It is possible to install OpCon within the Azure cloud environment supporting a hybrid cloud / on-premises infrastructure or a cloud-only infrastructure. 
For deployment in cloud environments, the OpCon software is available from Docker Hub as Docker images.  
For the Azure cloud, the OpCon environment is deployed within a Kubernetes cluster using the Azure Kubernetes Service and a SQL Server database.  

Figure 2 provides an architectural diagram explaining how an OpCon environment using Azure SQL for the database requirements can be deployed within an Azure environment or a hybrid Azure on-prem environment. The figure uses a VPN Gateway to provide a secure link between the cloud infrastructure and the on-premises infrastructure.  
<insert figure 2 - OpCon in Azure - here>

The implementation uses a single virtual network and multiple subnets to support the various functions. Network security groups can be used to filter network traffic between Azure resources in the virtual network. 

Workflow

1. OpCon : An OpCon container provides the Core services which are deployed within an Azure Kubernetes Service. PersistentVolumes (Storage Class Azurefile) are used for the storage of logs and configuration information to ensure data persistence across container restarts. 
Database connections between the OpCon Core services and the OpCon database are established through the configured Azure Private Endpoint that provides secure access to the Azure SQL Server. 
OpCon Core services communicate with OpCon Agents installed on virtual machines within the Virtual Network environment or with on-premises systems through the Virtual Network Gateway.  Similarly, OpCon Core services communicate directly with Application Rest-API endpoints within the Virtual Network environment or with on-premises systems through the Virtual Network Gateway using Rest-API connectivity options.  
OpCon Core services provide Solution Manager which is the web-based user interface for interacting with the entire OpCon environment. 
Network Security Groups can be used to limit traffic flow between subnets should this be required. 

1. Azure SQL : The OpCon database is installed within an Azure SQL environment which is reached through a private endpoint.

1. Azure Storage : OpCon Connector technology allows OpCon Core services to interact with Azure Storage providing capabilities to manage Blob Storage.  
OpCon Managed File Transfer (MFT) also supports interaction with Azure Storage. 

1. Applications : The application subnet includes the virtual machines that provide the application infrastructure. The application servers could also be installed into multiple subnets or virtual networks creating separate environments for web servers, application servers, etc.  
Application virtual machines or on-premises legacy systems require connections to the OpCon Core services for the management of their workloads, while applications providing Rest-API endpoints require no additional software.  
The subnet includes an OpCon MFT Server which is an OpCon component that provides full file transfer capabilities such as compression, encryption, decryption, decompression, file watching, and automated file routing for the enterprise.  
Network Security Groups can be used to limit traffic flow between subnets should this be required. 

1. VPN Gateway : In a hybrid environment, the Gateway Subnet provides a secure connection between the on-premises environment and the Azure Cloud environment through a Site-to-Site VPN tunnel connection.
   
1. Site-to-Site VPN Tunnel : The gateway includes a cross-premises IPsec/IKE VPN tunnel connection between the VPN gateway and an on-premises VPN device (Site-to-Site).  All data passed between the Azure Cloud and the on-premises environment is encrypted in the private tunnel as it crosses the internet.

Local Gateway : The Local Network Gateway is a representation of the gateway on the other end of the tunnel within the on-premises environment.  This holds configuration information that the tunnel needs to know about to build a VPN tunnel to the other end. 

1. Users : All user requests are routed via the gateway connection to the OpCon Core services environment.   
User access utilizes the OpCon Solution Manager framework, a web-based user interface for  
•	OpCon Administration. 
•	OpCon MFT Administration. 
•	OpCon workflow development, execution, and monitoring. 
•	Self-Service. 
•	Vision (OpCon Task Dashboard). 
•	 OpCon MFT Central Application (Dashboard & Query application).

1. On-Premise network :  OpCon Core services communicate with OpCon Agents installed on legacy systems within the on-premises systems through the Virtual Network Gateway.  Similarly, OpCon Core services communicate directly with Application Rest-API endpoints within the on-premises systems through the Virtual Network Gateway using Rest-API connectivity options.  

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) Azure Virtual Machine (VM) is one of several types of on-demand, scalable computing resources that Azure offers. An Azure VM gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it.  With Azure VMs, you have a choice of operating system which includes both Windows and Linux. 

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is like a traditional network that you would operate in your own data center but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation. 

- Azure Virtual Network Interface Cards - A network interface enables an Azure Virtual Machine to communicate with internet, Azure, and on-premises resources.  As shown in this architecture, you can add additional network interface cards to the same Azure VM, which allows the Solaris child-VMs to have their own dedicated network interface device and IP address.
- 
- [Storage](https://azure.microsoft.com/products/category/storage) Azure Files offers fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS. 

- Azure SSD Managed Disk - Azure managed disks are block-level storage volumes that are managed by Azure and used with Azure Virtual Machines.  The available types of disks are ultra disks, premium solid-state drives (SSD), standard SSDs, and standard hard disk drives (HDD). For this architecture, we recommend either Premium SSDs or Ultra Disk SSDs. 

- [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute) ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365. 

- [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery) Site Recovery helps ensure business continuity by keeping business apps and workloads running during outages. Site Recovery can replicate workloads running on physical and virtual machines (VMs) from a primary site to a secondary location. When an outage occurs at your primary site, you fail over to a secondary location, and access apps from there. After the primary location is running again, you can fail back to it. 

- Microsoft Azure SQL or SQL Managed Instance – The OpCon backend can utilize either Azure SQL or SQL MI to manage OpCon entries. 

-	OpCon [https://smatechnologies.com/product-opcon] - OpCon core services running in a Linux container within a Kubernetes replica-set using an Azure SQL Server for the OpCon database. 
-	OpCon Cloud [https://assets.smatechnologies.com/production/assets/files/Hosting-OpCon-in-the-Cloud-FAQ.pdf?dm=1709355517] - OpCon hosting service provided by SMA which includes an OpCon instance running in a Linux container within a Kubernetes replica-set, an Azure SQL Server for the OpCon database, and a virtual network with a gateway to provide site-to-site VPN communication.  The virtual network is private and has no accessible public interfaces.   
-	OpCon Self Service [https://help.smatechnologies.com/opcon/core/v21.0/Files/UI/Solution-Manager/Working-with-Self-Service] - OpCon Self Service is a web-based implementation that allows users to execute on-demand tasks, optionally entering arguments within the OpCon environment.  
-	OpCon Vision [https://smatechnologies.com/blog/opcon-18-3-process-monitoring-tool-vision] -gets-powerful-new-capabilities- OpCon Vision provides a dashboard capability for monitoring OpCon tasks. It is a logical representation of the tasks across all flows.  Tasks are grouped using tags, with each group representing all associated tasks.  When problems occur is it possible to ‘drill’ down from the dashboard to the failed task.  Vision also provides the ability to set SLA values for each group and provide early warning if defined SLA values will be exceeded.   
-	OpCon MFT [https://help.smatechnologies.com/opcon/agents/opconmft/introduction] - OpCon MFT provides Managed File Transfer within the OpCon environment. Providing file transfer and monitoring functionality across the enterprise using an integrated MFT Agent and a File Transfer Server. 


### Alternatives

The following sections describe alternatives to consider when you implement the solution.

#### Component placement

The placement of the VMs and OpCon database is flexible.

- The application subnet can include the application VMs. You can also install the application servers in multiple subnets or virtual networks. Use this approach when you want to create separate environments for different types of servers, such as web and application servers.

- You can place the database inside or outside the OpCon subnet.

#### SQL Managed Instance

Instead of using SQL Database, you can use SQL Managed Instance as the OpCon database. You can install the SQL managed instance in the OpCon subnet. Alternatively, you can install the managed instance in a separate subnet that you use exclusively for SQL managed instances in the existing virtual network.

#### ExpressRoute

Instead of using a VPN Gateway and a Site-to-Site VPN Tunnel, an ExpressRoute implementation that provides a private connection to the Microsoft Global Network using a connectivity provider could be used. ExpressRoute connections do not go over the public internet.  

ExpressRoute is recommended for hybrid applications running large-scale mission-critical workloads that require a high degree of scalability and resiliency. 

## AKS Kubernetes information  
The deployed OpCon environment consists of two pods (OpCon & Impex2) within a single replica set and an Azure-SQL database. Access to the pods is controlled through a load balancer that maps the external addresses and ports to the internal Rest-API server addresses ports. Figure 3 shows the configuration requirements and the relationship between the various definitions. 

insert figure 3 Kubernetes here

The above diagram shows the various definitions included in the Kubernetes configuration yaml file. 
Kind: Secret - dbpasswords 
Contains the database passwords required to connect to the OpCon database. 
Kind: ConfigMap - opcon 
The OpCon config map contains the OpCon database information (address, db name, db user), the OpCon Rest-API information, time zone and language information. 
Kind: ConfigMap - impex 
The Impex2 config map contains the OpCon database information (address, db name, db user) and the ImpEx2 Rest-API information. 
Kind: PersistentVolumeClaim - opconconfig 
The opcon config PVC contains the various .ini files as well as the OpCon license file. 
Kind: PersistentVolumeClaim - opconlog 
The opconlog PVC contains the log files associated with the OpCon environment. 
Kind: PersistentVolumeClaim - impexlog 
The impexlog PVC contains the log files associated with the ImpEx2 environment. 
Kind: ReplicaSet -opcon 
The OpCon and ImpEx2 container definitions referencing the previously defined secret, configmaps and PersistentVolumeClaim definitions. 
Kind: Service – loadbalancer 
Defines the mapping of the internal Rest-API ports for the OpCon and Impex2 Rest Servers to external addresses and ports. 

OpCon Cloud Potential Use Cases 
•	Workload automation and orchestration across the entire IT enterprise. 
•	Disaster Recovery automation. 
•	Cross platform file transfers. 
•	IT environment operations. 
•	Batch scheduler. 
•	Self-service automation workflows. 
•	Automation and deployment server updates. 
•	Automation and deployment of patch management. 
•	Automate provisioning / decommissioning of Azure resources. 
•	Monitor your entire IT environment from a single interface. 
•	Codify any repeatable or ad hoc process. 
•	Azure SQL or SQL MI to manage OpCon entries. 

Azure Well-Architected Framework 
 
These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see Microsoft Azure Well-Architected Framework - Azure Architecture Center | Microsoft Learn. 
•	Reliability ensures your application can meet the commitments you make to your customers.  For more information, see Microsoft Azure Well-Architected Framework - Azure Architecture Center | Microsoft Learn. OpCon Cloud reduces infrastructure and maintenance costs, while providing clients with the security and reliability of an always-on solution and fast recovery from unplanned system interruptions or disasters. OpCon has its own build in resiliency capability or Azure ASR can be utilized to maintain copies of the OpCon environment for use in DR situations. 
 
•	Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see Microsoft Azure Well-Architected Framework - Azure Architecture Center | Microsoft Learn. The OpCon configuration builds in security by using Gateway subnets to route only authorized traffic. Via OpCon automation, tasks such as security patch updating can be automated to ensure all target systems within the OpCon environment are kept current with the latest vulnerability patches. See Security baselines for Azure overview | Microsoft Learn for more information regarding Azure Security baseline recommendations. 
 
•	Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see Cost optimization documentation - Microsoft Azure Well-Architected Framework | Microsoft Learn. OpCon workload automation reduces manual steps ensuring that workflows are consistent with each iteration providing improved efficiency.  This reduces the amount of time and resources needed for re-runs due to human error or manual data inputs. See What is Workload Automation? | SMA Technologies for more examples. 
 
•	Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see Microsoft Azure Well-Architected Framework - Azure Architecture Center | Microsoft Learn. OpCon delivers enterprise power and scalability without the complexity or cost. OpCon enables companies to easily automate manual tasks and seamlessly orchestrate workloads across business-critical operations, saving time and reducing cost by eliminating human error and deploying IT resources on strategic initiatives. 
 
•	Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see Microsoft Azure Well-Architected Framework - Azure Architecture Center | Microsoft Learn. OpCon can be used to monitor workloads and use the scalability of Azure to increase resources in times of high demand or deprecate resources off peak.   


## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

- [Philip Brooks](https://www.linkedin.com/in/philipbbrooks) | Senior Program Manager
- [Bertie van Hinsbergen](https://www.linkedin.com/in/gys-bertie-van-hinsbergen-7802204) | Principal Automation Consultant

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps


For more information about this solution:

- Contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- Contact [SMA](https://smatechnologies.com/contact-us). A Microsoft Gold-level partner, [SMA Technologies](https://smatechnologies.com) is a leader in the IT automation space. SMA is dedicated to the single purpose of giving time back to clients and their employees by automating processes, applications, and workflows.

## Related resources

- [Unisys ClearPath Forward OS 2200 enterprise server virtualization on Azure](../../mainframe/virtualization-of-unisys-clearpath-forward-os-2200-enterprise-server-on-azure.yml)
- [Unisys ClearPath Forward MCP mainframe rehost to Azure using Unisys virtualization](../../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml)
