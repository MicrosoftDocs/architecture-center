## Overview and use cases  

Legacy applications running on mainframe computers have been at the core of most business operations going back almost 50 years.  While these mainframe systems have provided remarkable reliability over the years, they have become somewhat problematic as they are rigid and, in some cases, hard to maintain and costly to operate. 

Many businesses and government agencies (State, Local and Federal) are looking and planning for ways to modernize these critical system.  They are looking for ways to free up the constrained resources required to maintain these systems, controlling their costs, and providing more flexibility when interacting with these systems.  

Software AG is a software company that provides a 4GL mainframe platform based on the Natural programming language and the Adabas database.  They have many mainframe customers who use this popular platform.  If your mainframe is running Adabas & Natural and you are exploring ways to modernize and move these workloads to the cloud, please read on. 

While we have two patterns that allow you to keep running your Adabas & Natural applications in Azure, Re-Host and Re-factor, this article focuses on refactoring the application using Containers that are managed in Azure Kubernetes Service (AKS).   

 To make the most of Azure flexibility, reliability, and future capabilities, you must rearchitect your application. We recommend rewriting monolithic applications as microservices and using a container-based approach to deployment. A container bundles all the software needed for execution into one executable package and includes an application’s code together with the related configuration files, libraries, and the dependencies required for the app to run. Containerized applications are quick to deploy and support popular DevOps practices, such as continuous integration (CI) and continuous deployment.  

Adabas & Natural containers run in pods, each of which is focused on a task. Pods are units of one or more containers that stay together on the same node and share resources such as host name and IP address. Decoupled from the underlying platform, components in pods scale independently and support higher availability. A containerized application is also portable—it runs uniformly and consistently on any infrastructure.  

Containerized services and their associated networking and storage components need to be orchestrated and managed. We recommend Azure Kubernetes Service (AKS), a managed Kubernetes offering that automates cluster and resource management. You designate the number of nodes you need, and AKS fits your containers onto the right nodes to make the best use of resources. AKS also supports automated rollouts and rollbacks, service discovery, load balancing, storage orchestration, and self-healing—if a container fails, AKS starts a new one. In addition, you can safely store secrets and configuration settings outside of the containers. 

The accompanying architecture diagram shows a container-based implementation of Adabas & Natural. When you set up AKS, you specify the Azure VM size for your nodes, which defines the storage CPUs, memory, and type available, such as high-performance solid-state drives (SSDs) or regular hard disk drives (HDDs). In this example, Natural runs on three VM instances (nodes) to boost scalability and availability of the user interface (Natural online plus ApplinX) and the API layer (Natural services plus EntireX).  

In the data layer, Adabas runs in the AKS cluster, which scales out and in automatically based on resource use. Multiple components of Adabas can run in the same pod or, for greater scale, AKS can distribute them across multiple nodes in the cluster. Adabas uses Azure NetApp Files for all persistent data such as database files, protection logs, app data, and backup as a high-performance, metered file storage service. 

## Architecture 

### Legacy IBM z/OS architecture 

The following diagram illustrates an example of a mainframe with Software AG’s Adabas & Natural modules installed before migrations to Azure. 

diagram 

download link ?

a. Mapping annotations from source IBM z/OS with Adabas & Natural to Azure 

b. Input over TCP/IP including TN3270 and HTTP (S). 

Input into the mainframe using standard mainframe protocols. 

Receiving applications can be either batch or online systems. 

Natural, COBOL, PL/I or Assembler (or compatible languages) run in enabled environment. 

Data and Database services commonly used are hierarchical / network database systems and relational database types. 

Common services enabled include program execution, I/O operations, error detection, and protection within the environment. 

Middleware and utility services manage such services as tapes storage, queueing, output, and web services within the environment. 

Operating systems provide the specific interface between the engine and the and the software it’s running. 

Partitions utilized are needed to run separate workloads or segregate work types within environment. 

 Postmigration, Azure-based architecture 

This diagram shows how the legacy architecture can be migrated to Azure, taking a refactoring approach to modernize the system. 

diagram

link to diagram 

Architectural Annotations – Refactoring Adabas Natural to Azure AKS 

1. Input will typically come either via Express Route from remote clients, or by other applications currently running Azure. In either case, TCP/IP connections will be the primary means of connection to the system. User access provided over TLS port 443 for accessing web-based applications. Web-based Applications presentation layer can be kept virtually unchanged to minimize end user retraining. Alternatively, the web application presentation layer can be updated with modern UX frameworks as requirements necessitate. Further, for admin access to the VMs, Azure VM Bastion hosts can be used to maximize security by minimizing open ports.                                          

1. Once in Azure, access to the application compute clusters will be done using an Azure Load balancer. This approach allows for scale out compute resources to process the input work. Both level 7 (application level) and level 4 (network protocol level) load balancers are available. The type to use will depend on how the application input reaches the entry point of the compute cluster.  

1. Applications compute clusters – The architecture supports applications running in a container that can be deployed in a container `orchestrater` such as Kubernetes. Adabas & Natural components can run inside container technology operated on top of Linux operating system. Customers can re-architect their legacy applications to modern container-based architectures and operate on top of Azure Kubernetes Services. 

1. **ApplinX** – (Software AG) Terminal Emulation. Server-based technology that provides web connectivity and integration into core system applications without changing the applications. **Natural Online** – Allows online users to connect to Natural applications via a web browser. Without ApplinX users must connect with a terminal emulation software using SSH.  Both systems run in containers. 

1. **EntireX** - (Software AG) enables you to easily connect services that run on Integration Server to mission-critical programs written in languages like COBOL or Natural. **Natural Services** – Allows API access to business functions programmed in Natural. Both systems run in containers. 

1. **Adabas** – Software AG’s high performance NonSQL Database Management System. **Natural Batch** - (Software AG) Dedicated component to execute batch jobs. Natural Batch jobs which are scheduled by a batch job scheduling system of choice should be running close to the Adabas database, e.g., on the same node, to avoid performance impact. 

1. **Storage** - Data services use a combination of high-performance storage (ultra/premium SSD), file storage (NetApp) and standards storage (Blob, archive, backup) that can be either local redundant or geo-redundant depending on the usage. Managed Disk storage is used for node operating systems and Azure (NetApp) Files storage solution is used for all persistent data such as database files, protection logs, application data and backup. Operating system volumes stored in Managed Disk are managed by AKS. All business-critical data from the databases including ASSO, DATA, WORK files and Adabas protection logs should be written to separate volumes that can be provided by Azure NetApp Files (ANF). 

1. **CONNX** - The CONNX for Adabas module provides secure, real-time, read/write access to Adabas data sources on OS/390, z/OS, VSE, Linux, Solaris, HP-UX, AIX and Windows via .NET, ODBC, OLE DB, and JDBC. CONNX connectors provides access to Adabas data sources and exposing them to more common databases such as Azure SQL, PosgreSQL and MYSQL.   

### Components  

- [Azure ExpressRoute] - ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365. 

- [Azure Kubernetes Service] is a fully managed Kubernetes service to deploy and manage containerized applications. AKS offers serverless Kubernetes, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance. 

- [Azure SSD Managed Disk] - Azure managed disks are block-level storage volumes that are managed by Azure and used with Azure Virtual Machines.  The available types of disks are ultra disks, premium solid-state drives (SSD), standard SSDs, and standard hard disk drives (HDD).  

- [Azure NetApp Files] - provides enterprise-grade Azure file shares powered by NetApp. NetApp Files makes it easy for enterprises to migrate and run complex, file-based applications with no code changes. 

## Considerations 

The following considerations, based on the Azure Well-Architected Framework, apply to this solution:  

### Operations 

Refactoring not only supports faster cloud adoption, but also promotes adoption of DevOps and Agile working principles. You have full flexibility in development and production deployment options.. 

### Performance efficiency  

Kubernetes provides a cluster autoscaler, this feature adjusts the number of nodes required based on the requested compute resources in the node pool. The cluster autoscaler monitors the Metrics API server every 10 seconds for any required changes in node count. If the cluster autoscale determines that a change is required, the number of nodes in your AKS cluster is increased or decreased accordingly.  

### Security  

This architecture is primarily built on the Kubernetes which includes security components, such as pod security standards and Secrets.  In addition, Azure provides additional features such as Active Directory, Microsoft Defender for Containers, Azure Policy, Azure Key Vault, network security groups and orchestrated cluster upgrades. 

## Next steps  

For more information, please contact legacy2azure@microsoft.com.  

## Related sources