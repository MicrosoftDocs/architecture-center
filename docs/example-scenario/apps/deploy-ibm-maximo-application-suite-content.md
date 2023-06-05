IBM Maximo Application Suite (MAS) 8.*x* runs on OpenShift, and it's beneficial to familiarize yourself with OpenShift and the suggested patterns for installation on Azure. For more information, see [Preparing to install on Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/preparing-to-install-on-azure.html). This architecture illustrates an OpenShift cluster. It doesn't go into detail on how to install MAS. To learn more about the installation process, see [Installing Maximo Application Suite from OperatorHub](https://www.ibm.com/docs/en/mas87/8.7.0?topic=installing-maximo-application-suite-from-operatorhub).

## Architecture

[ ![Architecture diagram that shows the components and services that support deployment of IBM Maximo Application Suite on Azure.](./media/deploy-ibm-maximo-application-suite-architecture.svg)](./media/deploy-ibm-maximo-application-suite-architecture.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/deploy-ibm-maximo-application-suite.vsdx) of this architecture.*

The workload can be deployed internally or externally facing, depending on your requirements.

### Workflow

From the perspective of infrastructure, this architecture provides the following:

- A container hosting platform to deploy highly available workloads across availability zones
- A privatized deployment of worker and control nodes that are integrated with storage
- Azure Premium Files and standard files for storage (OpenShift Data Foundation not required)
- SQL Server on Azure VMs or container-based IBM Db2 Warehouse
- Azure DNS for DNS management of OpenShift and its containers
- Azure Active Directory (Azure AD) for single sign-on into MAS

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) to host the OpenShift platform and run the Maximo containers. Virtual Machines is an infrastructure-as-a-service (IaaS) offering. You can use Virtual Machines to deploy on-demand, scalable computing resources.

- [Red Hat Enterprise Linux CoreOS](https://docs.openshift.com/container-platform/4.8/architecture/architecture-rhcos.html) to provide a custom VM image for OpenShift.

- [Azure Load Balancers](https://azure.microsoft.com/services/load-balancer) to provide connectivity into the cluster. Azure Load Balancer is a high-performance, ultra low-latency Layer 4 load-balancing service (inbound and outbound) for all UDP and TCP protocols. It is built to handle millions of requests per second while ensuring your solution is highly available. Azure Load Balancer is zone-redundant, ensuring high availability across Availability Zones.

- [Virtual Network](https://azure.microsoft.com/services/virtual-network) for communication between nodes, Azure services, and hybrid connectivity needs.  Virtual Network is the fundamental building block for private networks in Azure.

- [Azure Files](https://azure.microsoft.com/services/storage/files) hosting the stateful data for the databases and systems inside the cluster. Azure Files provides fully managed file shares in the cloud that are accessible via the SMB and NFS protocols.

- [Azure DNS](https://azure.microsoft.com/services/dns) to manage DNS resolution for the containers inside and outside of the solution. Azure DNS supports all common DNS records and provides high availability.

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) (optional) and a subnet to securely access any of the worker nodes or optional JumpBox machines. Azure Bastion is a fully managed service that provides secure and seamless RDP and SSH access to VMs without any exposure through public IP addresses.

- [SQL Server on Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/sql-server/) (optional) SQL Server on Azure Virtual Machines (VMs) to provide data services to MAS. The database can also be another, like Oracle Exadata or IBM Db2 Warehouse. Azure SQL Database and Azure SQL Managed Instance aren't supported right now.

- [Twilio Send Grid](https://docs.sendgrid.com/for-developers/partners/microsoft-azure-2021) (optional) to send emails from MAS to your consumers.

- [Linux virtual machines in Azure](https://azure.microsoft.com/services/virtual-machines/linux) (optional) to provide a jump box for installation of OpenShift. You can also use this VM to connect and manage the OpenShift cluster because it contains the Kubernetes configuration file after installation. If you have network connectivity into your Azure environment, you can perform the installation from an existing machine.

### Alternatives

The following services typically aren't necessary, but they're effective alternatives:

- [Azure NetApp Files](https://azure.microsoft.com/en-us/services/netapp) as a replacement for Azure Files. NetApp Files supports of any type of workload with high availability and high performance.
- [Oracle Database on Azure](https://azure.microsoft.com/en-us/solutions/oracle) if you prefer that to SQL Server or Db2 Warehouse.
- [OpenShift Data Foundation](https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation) if you want to use Db2 Warehouse on OpenShift Data Foundation.

## Scenario details

IBM's Maximo Application Suite (MAS), also known as *Maximo*, is an enterprise asset management platform with AI-based asset maintenance. MAS focuses on operational resiliency and reliability. The suite consists of a core application platform, MAS, and applications and industry-specific solutions on top of the platform. Each application provides a specific benefit:

- **Manage**. Reduce down time and costs by using asset management to improve operational performance.
- **Monitor**. Use IoT for advanced AI-powered monitoring of remote assets at scale.
- **Health**. Manage asset health by using IoT data from sensors, asset data, and maintenance history.
- **Visual inspection**. Train machine learning models to use visual inspection for visual analysis of emerging issues.
- **Predict**. Predict future failures by using machine learning and data analytics.
- **Assist**. Assist technicians by providing AI-powered guidance to a knowledge base of equipment maintenance data and by giving them remote access to experts.
- **Safety**. Collect and analyze data from sensors, provide contextual data, and derive meaningful analytics.
- **Civil**. Integrate inspection, defect tracking, and maintenance activities to help improve asset life, keep critical systems operating, and lower total costs of ownership of civil infrastructure.

These applications and MAS 8.*x* are tested for use on Azure. Microsoft and the IBM Maximo team partnered to ensure this solution is configured to run optimally on Azure. This article provides a design for running MAS 8.*x* on Azure for customers who have support from IBM and a partner for installation. Please contact your IBM team for product-specific questions. The Azure Marketplace offers an alternative installation for MAS that supports bringing your own license. For more information, see [IBM Maximo Application Suite (BYOL)](https://azuremarketplace.microsoft.com/marketplace/apps/ibm-usa-ny-armonk-hq-6275750-ibmcloud-asperia.ibm-maximo-application-suite-byol?tab=Overview).

### Potential use cases

Many industries and sectors use the solutions in MAS, such as:

- Energy and utilities
- Oil and gas
- Manufacturing
- Travel, automotive, and transportation
- Public sector

Find more information about use cases for MAS on IBM's website at [IBM Maximo Application Suite](https://www.ibm.com/products/maximo).

## Recommendations

We recommend installing the latest stable version of MAS because it provides the best integration options with Azure. Pay close attention to the versions of OpenShift that are supported, because the supported versions vary with the specific version of MAS. Currently the sliding window release cycle of Azure Red Hat OpenShift is too frequent for it to be supported by IBM Maximo Application Suite.

Use of earlier or later major versions of OpenShift can result in falling out of official support for MAS. Before building out your own deployment, we recommend using the quickstart guide to deploy MAS so that you understand how the deployment and configuration works. Knowing how this is done speeds creation of the design requirements for your implementation. For more information, see [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/Azure/maximo).

We work closely with IBM and other partners to ensure that the guidance, architecture, and quickstart guide give you the best experience on Azure. They follow the best practices as outlined in the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework). Contact your IBM account team for support beyond this documentation.

Before you proceed with your deployment, you need to answer the following questions about design:

- What MAS applications do you need? 
- What dependencies do your applications have?
- What version of OpenShift is required?
- Which method of installation of OpenShift should you use?
- What databases are needed?
- What number and sizes of VMs do you need? 
- Will users connect from external networks?

### Maximo Application Suite

Microsoft has tested MAS versions 8.5 and later on Azure. Our recommendation is to use the latest version of MAS, which is version 8.7.

Review the MAS applications that you need for your complete business scenario, and then review the requirements for each of the applications. For more information, see [IBM Maximo Application Suite system requirements](https://www.ibm.com/support/pages/node/6538166). Each of the applications might need separate databases. We have tested and support the following databases on Azure:

- [SQL Server on Azure VMs](https://azure.microsoft.com/en-us/services/virtual-machines/sql-server/) version 2019 using Windows or Linux
- IBM [Db2 Warehouse on Cloud Pak for Data 3.5](https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=services-db2-warehouse)

You might also choose to run Oracle Exadata on a VM or on Oracle Cloud Infrastructure by using interconnection, but this isn't a tested configuration. For more information about interconnection, see [Learn about interconnecting Oracle Cloud with Microsoft Azure](https://docs.oracle.com/en/solutions/learn-azure-oci-interconnect/index.html). Currently, Azure SQL Database, Azure SQL Managed Instance and Azure Cosmos DB aren't supported.

> [!NOTE]
> In some cases, you can't reuse a database for multiple MAS applications because of conflicting database settings. For example, you can't use the same IBM Db2 Warehouse for Health and Manage in combination with Monitor. However, you can mix different database products, such as using SQL Server for one application and IBM Db2 Warehouse for another.
>
> For more information about database requirements for the Health application, see [Configuring the database for Maximo Health](https://www.ibm.com/support/pages/configuring-database-maximo-health).

MAS and some of its applications have dependencies on MongoDB and Kafka. Decide how to deploy these solutions based on considerations of performance and operations. The defaults are to deploy MongoDB Community Edition and Strimzi Kafka inside the clusters. Some of the prerequisites of MAS, for example BAS, use databases that can't be externalized but that require persistent storage to be provided to the OpenShift cluster.

For state-based services that run inside of the OpenShift cluster, frequently backing up data and moving the backups into another region is necessary. Design and plan out a recovery strategy in case of disaster and decide accordingly, especially when running Kafka or MongoDB inside of OpenShift.

For services that retain state, use external Azure platform as a service (PaaS) offerings when possible. Doing so improves supportability during an outage.

Some of the services might require other IBM tools and services, such as IBM Watson Machine Learning and IBM App Connect. You can deploy all the tools and services on the same OpenShift cluster.

### OpenShift

> [!NOTE]
> Running MAS on Azure Red Hat OpenShift is not supported.

Before you install OpenShift, you need to determine which method you'll be using:

- **Installer Provisioned Infrastructure (IPI)**. This method uses an installer to deploy and configure the OpenShift environment on Azure. IPI is the most common method for deploying on Azure, and you should use IPI unless your security requirements are too strict to do so.

- **User Provisioned Infrastructure (UPI)**. This method allows fine-grained control over your deployment. UPI requires more steps and considerations to build your environment. Use UPI if IPI doesn't meet your needs. A common use case for UPI is for private, air-gapped installation. Choose UPI when you have no outbound internet access when building the environment.

We recommend using IPI whenever possible, because it significantly reduces the amount of work that's required to complete installation of OpenShift.

> [!NOTE]
> After you install OpenShift, the owner of the control plane is responsible for maintaining and scaling the worker nodes on Azure. You increase the cluster size by using machine sets in the admin console, not through the Azure portal. For more information, see [Creating a machine set on Azure](https://docs.openshift.com/container-platform/4.6/machine_management/creating_machinesets/creating-machineset-azure.html).

When installing OpenShift, you must resolve the following considerations:

- **Region selection**. We recommend using a region with [availability zones](/azure/availability-zones/az-overview#azure-regions-with-availability-zones). During deployment, OpenShift automatically attempts to create nodes across zones based on the configuration in the configuration file, *install-config.yaml*. By default, OpenShift balances workloads across all available nodes and across the availability zones. If there's an outage in a zone, your solution can continue functioning by having nodes in other zones that can take over the work.

- **Backup & recovery**. Although MAS isn't supported on Azure Red Hat OpenShift, you can use the instructions for Azure Red Hat OpenShift for backup and recovery. For more information, see [Create an Azure Red Hat OpenShift 4 cluster Application Backup](/azure/openshift/howto-create-a-backup). If you use this method for back-up and recovery, you must provide another method of disaster recovery for the database. 

- **Failover**. Consider deploying OpenShift in two regions and using [Red Hat Advanced Cluster Management](https://www.redhat.com/en/technologies/management/advanced-cluster-management). If your solution has public endpoints, you can place [Azure Traffic Manager](/azure/traffic-manager) between them and the internet to redirect traffic to the appropriate cluster when there's an outage of a region. In such a situation, you must also migrate your applications' states and persistent volumes.

#### Air-gapped installations

In some cases, such as for regulatory compliance, you might require an air-gapped installation of MAS on Azure. *Air gapped* means that there's no inbound or outbound internet access. Without an internet connection, your installation can't retrieve the installation dependencies at run time for the installation of MAS or OpenShift. 

> [!NOTE]
> Air-gapped deployments require [UPI](https://github.com/openshift/installer/blob/master/docs/user/azure/install_upi.md) for installation. However, they have not been fully tested.

We don't recommend that you do an air-gapped installation unless that's a security requirement. An air gap adds significant complexity to the operations of your solution. Activities such as installing software, mirroring containers, updating a mirror to protect against security vulnerabilities, and managing a firewall can become very time consuming.

For more information about air-gapped installations, see the following OpenShift documentation:
- [Mirroring images for a disconnected installation](https://docs.openshift.com/container-platform/4.11/installing/disconnected_install/installing-mirroring-installation-images.html)
- [Installing a private cluster on Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/installing-azure-private.html)

After you've installed OpenShift, see the MAS documentation for similar guidance.

### Sizing your environment

For all workloads (except visual inspection), we recommend using the latest *Ds* series VMs as your worker nodes. Examples are the [Dsv3](/azure/virtual-machines/dv3-dsv3-series#dsv3-series), [Dasv4](/azure/virtual-machines/dav4-dasv4-series#dasv4-series), [Dsv4](/azure/virtual-machines/dv4-dsv4-series#dsv4-series), [Dasv5](/azure/virtual-machines/dasv5-dadsv5-series#dasv5-series), or [Dsv5](/azure/virtual-machines/dv5-dsv5-series#dsv5-series). We recommend using the latest versions, when possible, because they provide better performance. Only use VMs that have [premium storage](/azure/virtual-machines/premium-storage-performance).

[Maximo Visual Inspection](https://www.ibm.com/products/maximo/visual-inspection) requires GPU nodes to perform its machine learning. The solution uses [CUDA](https://developer.nvidia.com/about-cuda) and only supports NVIDIA GPUs. The recommended types of VMs are [NCv3](/azure/virtual-machines/ncv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series). If you need to train by using [YOLOv3](https://pjreddie.com/darknet/yolo), you'll need [Ampere](https://www.nvidia.com/en-us/data-center/ampere-architecture)-based GPUs. Use the [NVadsA10 v5](/azure/virtual-machines/nva10v5-series) or [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) for larger training tasks.

For the GPU machines, we recommend starting with the smallest node and scaling up as your requirements increase. 

> [!WARNING]
> If you need GPU machines, you need OpenShift 4.8.22 as a minimum version to enable the GPUs through the NVIDIA GPU Operator.

For all other machines, we recommend configuring VMs across [availability zones](/azure/availability-zones/az-overview) to support high availability. Configure the nodes as follows:

- **Control nodes**. A minimum of one VM per availability zone within the selected region. We recommended a vCPU count of at least 4. Our reference uses 3x [Standard_D8s_v4](/azure/virtual-machines/dv4-dsv4-series#dsv4-series) nodes.

- **Worker nodes**. A minimum of two machines per availability zone within the selected region. We recommend a vCPU count of at least 8. Our reference uses 6x [Standard_D8s_v4](/azure/virtual-machines/dv4-dsv4-series#dsv4-series) nodes.

MAS core requires 13 vCPUs for a standard-sized base installation. Sizing for the worker nodes varies based on which MAS applications your configuration deploys and the load on your environment. For example, Manage for 10 users requires another 2 vCPUs. We recommend that you review the [IBM Maximo Application Suite system requirements](https://www.ibm.com/support/pages/ibm-maximo-application-suite-system-requirements) to get a good sizing estimate.

Try to keep the types of VMs similar to each other to provide proximity with each of the availability zones between worker and control nodes. That is, if you use a v4 VM for your control nodes, also use a v4 VM for your worker nodes.

If you need a jump box to use the OpenShift command-line interface (oc) or to install MAS, deploy a VM that's running Red Hat Enterprise Linux version 8.4.

### Network

With OpenShift, we use the default container network interface (CNI) provider of OpenShift's software-defined networking (SDN). For more information about the default OpenShift CNI, see [Cluster Network Operator in OpenShift Container Platform](https://docs.openshift.com/container-platform/4.8/networking/cluster-network-operator.html). You must size your network for the number of OpenShift control and worker nodes that you need, and also for any other requirements, such as databases and storage accounts.

For a standard MAS production installation, we recommend a virtual network with the address space that a CIDR prefix of /24 provides. The virtual network has three or four subnets (for Bastion). For OpenShift, the subnet for the worker nodes has a CIDR prefix of /25, and the control nodes have a prefix of /27. A subnet for endpoints and an optional external database server should have a prefix of /27. If you're deploying Azure Bastion, which is optional, you need a subnet named *AzureBastionSubnet* with a prefix of /26. For more information about the requirements for Azure Bastion, see [Architecture](/azure/bastion/bastion-overview#architecture).

If you're short on IP addresses, you can implement a highly available configuration with a minimum prefix of /27 for the subnet of control nodes and /27 for the subnet of worker nodes.

If you want to use a different CNI, size your networks accordingly. MAS with some standard applications deploys over 800 pods, which likely require a CIDR prefix of /21 or larger.

### Database specifics

Various components of MAS use MongoDB as a metadata store. The default guidance is to deploy MongoDB Community Edition inside of the cluster. If you deploy it by using that method, ensure that you have in place a proper procedure for backing up and restoring the database. Consider using MongoDB Atlas on Azure, because it provides an externalized store, backups, scaling, and more. Azure doesn't currently support using MongoDB APIs with Azure Cosmos DB.

If you deploy IoT services, you're required to also provide a Kafka endpoint. The default guidance is to use Strimzi to deploy Kafka inside the OpenShift cluster. During a disaster recovery, data inside Strimzi will most likely be lost. If data loss within Kafka is unacceptable, you should consider using Confluent Kafka on Azure. Currently, Azure EventHubs with Kafka endpoints aren't supported. 

MAS comes packed with many databases inside its pods, and those databases retain their states on the file system that's provided for MAS. We recommend using a zone-redundant storage mechanism to retain the states outside of your clusters to be able to absorb zone failures. Our recommended pattern is to use Azure File Storage with the following configurations:

- **Standard**. Provides Server Message Block (SMB) shares for lower throughput and ReadWriteOnce (RWO) workloads. Standard is a great fit for parts of the application that don't write to storage often and require a single persistent volume (for example, IBM single-level storage).

- **Premium**. Provides Network File System (NFS) shares for higher throughput and ReadWriteMany (RWX) workloads. Volumes like these are used throughout the cluster for RWX workloads, such as the Db2 Warehouse in Cloud Pak for Data or Postgres in Manage.

Be sure to disable policies for enforcing secure transfer on the Azure Blob Storage or exempt the accounts from such policies. Azure Premium Files with NFS requires that secure transfer be disabled. Be sure to use a [private endpoint](/azure/private-link/private-endpoint-overview) to guarantee private connectivity to your shares.

By default, Db2 Warehouse deploys on top of OpenShift Data Foundation (previously known as OpenShift Container Storage). For reasons of cost, performance, scaling, and reliability, we recommended using Azure Premium Files with NFS instead of OpenShift Data Foundation.

Don't use Azure Blob with CSI drivers, because it doesn't support hard links, which are required. Some pods can't run without hard links. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Maintaining access and visibility into the maintenance lifecycle of your assets can be one of your organization's greatest opportunities to operate efficiently and maintain uptime. To improve the security posture of your environment, it's important to use secure authentication and to keep your solutions up to date. Use encryption to protect all data that moves in and out of your architecture.

Azure delivers MAS by using the models of infrastructure as a service (IaaS) and PaaS. Microsoft builds security protections into the service at the following levels:

- Physical datacenter
- Physical network
- Physical host
- Hypervisor

Carefully evaluate the services and technologies that you select for the areas above the hypervisor, such as the latest patched version of OpenShift for a major release. Be sure to provide the proper security controls for your architecture. You're responsible for patching and maintaining the security of the IaaS systems. Microsoft takes that role for the PaaS services. 

Use [network security groups](/azure/virtual-network/security-overview) to filter network traffic to and from resources in your [virtual network](/azure/virtual-network/virtual-networks-overview). With these groups, you can define rules that grant or deny access to your MAS services. Examples include:

- Allow SSH access into the OpenShift nodes for troubleshooting
- Block access to all other parts of the cluster
- Control which locations can have access to MAS and the OpenShift cluster

If you need access to your VMs for some reason, you can connect through your hybrid connectivity or through the OpenShift admin console. If you have an online deployment or don't want to rely on connectivity, you can also access your VMs through [Azure Bastion](/azure/bastion/bastion-overview) (which is optional). For security reasons, you shouldn't expose VMs to a network or the internet without configuring [network security groups](/azure/virtual-network/network-security-groups-overview) to control access to them.

[Server-side encryption (SSE) of Azure Disk Storage](/azure/virtual-machines/disk-encryption) protects your data. It also helps you meet organizational security and compliance commitments. With Azure managed disks, SSE encrypts the data at rest when persisting it to the cloud. This behavior applies by default to both OS and data disks. OpenShift uses SSE by default.

#### Authentication

MAS currently supports the use of Security Assertion Markup Language (SAML) via Azure AD. To make this work, you need an enterprise application within Azure AD and either permission to modify the application or the assistance of a global administrator who can make the necessary changes.

The [quickstart guide](https://github.com/Azure/maximo) on GitHub has a tutorial on how to set up SAML with MAS. For more information, see [Enabling SAML authentication against Azure AD](https://github.com/Azure/maximo#enabling-saml-authentication-against-azure-ad). 

Before you set up SAML-based authentication, we recommend that you go through the IBM configuration and the Azure configuration. For information about SAML with MAS, see [SAML](https://www.ibm.com/docs/en/tfim/6.2.1?topic=overview-saml-20) in the documentation for MAS. For information about SAML with Azure, see [Quickstart: Enable single sign-on for an enterprise application](/azure/active-directory/manage-apps/add-application-portal-setup-sso).

You should also configure OAuth for OpenShift. For more information, see [Overview of authentication and authorization](https://docs.openshift.com/container-platform/4.8/authentication/index.html) in the OpenShift documentation.

#### Protect your infrastructure

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship](/azure/active-directory/active-directory-how-subscriptions-associated-directory) with an Azure AD tenant. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope. The scope can be a subscription, a resource group, or a single resource. Be sure to audit all changes to infrastructure. For more information about auditing, see [Azure Monitor activity log](/azure/azure-resource-manager/resource-group-audit).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

A standard deployment of MAS consists of the following components:
 - 3 control VMs
 - 6 worker VMs
 - 3 worker VMs for Db2 Warehouse
   - You can substitute SQL Server on Azure VMs in some configurations, rather than use Db2 Warehouse.
- 2 Azure Storage accounts
- 2 DNS zones
- 2 Load balancers
- Azure Bastion
- 1 Visual Inspection VM
  - This isn't required unless you're planning to run Visual Inspection inside of MAS.

You can review an example estimate by using our [cost calculator](https://azure.com/e/fae03e2386cf46149273a379966e95b1). Configurations vary, and you should verify your configuration with your IBM sizing team before finalizing your deployment.

### Reliability

OpenShift has built-in capabilities for self-healing, scaling, and resilience to make sure OpenShift and MAS work successfully. OpenShift and MAS have been designed for parts that fail and recover. A key requirement for self-healing to work is that there are enough worker nodes. To recover from a zone failure within an Azure region, your control and worker nodes must be balanced across availability zones. 

MAS and OpenShift use storage to persist state outside of the Kubernetes cluster. To ensure that the storage dependencies continue to work during a failure, you should use [zone-redundant storage](/azure/virtual-machines/disks-deploy-zrs) whenever possible. This type of storage remains available when a zone fails.

Because human error is common, you should deploy MAS by using as much automation as possible. In our [quickstart guide](https://github.com/Azure/maximo), we provide some sample scripts for setting up full, end-to-end automation.

## Deploy this scenario

Before you start, we recommend that you review the [IBM Maximo Application Suite system requirements](https://www.ibm.com/support/pages/ibm-maximo-application-suite-system-requirements). Be sure that you have the following resources available before starting the deployment:

- Access to an Azure Subscription with *Reader* permission
- Application Registration or service principal name that has *Contributor* and *User Access Administrator* permissions to the subscription
- Domain or delegated subdomain to an Azure DNS zone
- Pull secret from Red Hat to deploy OpenShift
- MAS entitlement key
- MAS license file (created after MAS installation)
- IBM-recommended cluster sizing
- Existing virtual network or a new virtual network created by IPI, depending on your requirements
- High-availability and disaster-recovery requirements for your specific deployment
- Configuration file, *install-config.yaml*, for the installer

For a step-by-step guide for installing OpenShift and MAS on Azure, including how to address the prerequisites, see our [quickStart guide](https://github.com/Azure/maximo) on GitHub.

> [!NOTE]
> [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/Azure/maximo) includes an example of an *install-config.yaml* file in [/src/ocp/](https://github.com/Azure/maximo/blob/main/src/ocp).

### Deployment considerations

It's best to deploy workloads by using infrastructure as code (IaC) rather than manually deploying workloads, because manual deployment can result in misconfiguration. Container-based workloads can be sensitive to misconfiguration, which can reduce productivity.

Before building your environment, review the [quickstart guide](https://github.com/azure/maximo#getting-started) to develop an understanding of the design parameters. The quickstart guide isn't intended for a production-ready deployment, but you can use the guide's assets to get to a production-grade mechanism for deployment.

IBM offers specialist services to help you with installation. Contact your IBM team for support. 

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [David Baumgarten](https://www.linkedin.com/in/baumgarten-david) | Senior Cloud Solution Architect
- [Roeland Nieuwenhuis](https://www.linkedin.com/in/roelandnieuwenhuis) | Principal Cloud Solution Architect

Other contributor:

- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For help with getting started, see the following resources:

- [Installing OpenShift on Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/preparing-to-install-on-azure.html)
- [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/Azure/maximo)
- [OpenShift UPI Guide](https://github.com/openshift/installer/blob/master/docs/user/azure/install_upi.md)
- [Requirements for Maximo](https://www.ibm.com/support/pages/node/6538166)
- [IBM Maximo Application Suite (BYOL)](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/ibm-usa-ny-armonk-hq-6275750-ibmcloud-asperia.ibm-maximo-application-suite-byol?tab=Overview)

To learn more about the featured technologies, see the following resources:

- [IBM Passport Advantage](https://www.ibm.com/software/passportadvantage/pao_customer.html)
- [Introduction to Azure DNS](/training/modules/intro-to-azure-dns)
- [Introduction to Azure NetApp Files](/training/modules/introduction-to-azure-netapp-files)
- [Introduction to Red Hat on Azure](/training/modules/introduction-to-red-hat-azure)
- [Red Hat Customer Portal](https://access.redhat.com)

## Related resources

- [Azure enterprise cloud file share](/azure/architecture/hybrid/azure-files-private)
- [Predictive maintenance for industrial IoT](/azure/architecture/solution-ideas/articles/iot-predictive-maintenance)
- [JBoss deployment with Red Hat on Azure](/azure/architecture/solution-ideas/articles/jboss-deployment-red-hat)
