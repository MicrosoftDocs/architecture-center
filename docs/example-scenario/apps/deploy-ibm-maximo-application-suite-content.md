This article describes IBM Maximo Application Suite (MAS) deployment on Azure. MAS runs on [Red Hat OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift). Azure Red Hat OpenShift (ARO) is the preferred OpenShift platform if it meets your operational, security, and networking requirements. Use self-managed Red Hat OpenShift on Azure only when you need control that ARO doesn't provide, such as specific disconnected deployment patterns or cluster-level customization.

This article doesn't go into detail on how to install MAS. For more information about installation, see [Installing Maximo Application Suite](https://www.ibm.com/docs/en/masv-and-l/cd?topic=installing).

## Architecture

The following diagram illustrates an ARO-based MAS deployment on Azure. 

:::image type="complex" border="false" source="./media/deploy-ibm-maximo-application-suite-architecture.svg" alt-text="Architecture diagram that shows the components and services that support an ARO MAS deployment." lightbox="./media/deploy-ibm-maximo-application-suite-architecture.svg":::
  Diagram that shows an ARO deployment of MAS with supporting components and services. A large box holds an Azure virtual network (VNet) that contains MAS and its supporting Azure components and services. To the left of the VNet box are a public DNS zone icon, a user icon connected to the ARO deployment subnets in the VNet via a public load balancer, and another user connected to the VNet through an Azure ExpressRoute circuit and a virtual network gateway. Inside the VNet, a box contains the ARO deployment, with boxes for the ARO control plane subnet and the ARO worker subnet. The control plane subnet has several nodes and an internal load balancer. The MAS worker nodes subnet contains nodes for applications. Another subnet box in the VNet holds endpoints and services such as an optional jump box, and connections to Azure Files Premium and Azure Files Standard outside the network. Another subnet box holds a delegated Azure SQL managed instance, and another subnet has Azure Bastion. All subnets have network security group icons. A cluster admin connects to Azure Bastion from outside the VNet. A private DNS zone icon also connects to the VNet, and a Twilio SendGrid icon also appears outside the VNet.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/deploy-ibm-maximo-application-suite.vsdx) of this architecture.*

You can deploy the workload as an internal or external facing deployment, depending on your requirements. This article doesn't prescribe a public or private ARO deployment model. Choose the control plane, ingress, and egress architecture based on your Azure landing zone architecture, including its networking topology, connectivity model, security controls, operational access requirements, compliance requirements, and MAS user access patterns.

When IBM supports external databases for the MAS applications that you deploy, try to externalize those databases to reduce state inside the OpenShift cluster and decouple database management from cluster management.

### Workflow

From an infrastructure perspective, this architecture provides the following capabilities:

- An Azure Red Hat OpenShift managed service to deploy highly available workloads across availability zones
- An OpenShift cluster integrated with Azure networking and storage
- Azure Files Premium and Azure Files Standard for supported MAS storage requirements
- Azure SQL Managed Instance or container-based IBM Db2 Warehouse
- Azure DNS for Domain Name System (DNS) management of OpenShift and its containers
- Microsoft Entra ID for single sign-on (SSO) into MAS

### Components

- [Azure Red Hat OpenShift (ARO)](/azure/openshift/intro-openshift) is the preferred OpenShift platform for MAS on Azure. ARO reduces your operational responsibility for running OpenShift, compared with a self-managed cluster on Azure virtual machines (VMs).

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) that deploys on-demand, scalable computing resources. Use Virtual Machines instead of ARO to deploy self-managed Red Hat OpenShift on Azure.

  Optionally, use Azure [Linux VMs](/azure/virtual-machines/linux/quick-create-portal) as jump boxes for MAS installation and OpenShift administration. If you have private network connectivity into your Azure environment, you can perform administration from an existing secured machine.

- [Red Hat Enterprise Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux) CoreOS provides the operating system image for OpenShift nodes.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) provides connectivity into the cluster. Load Balancer is a high-performance, ultra low-latency layer-4 load-balancing service for all inbound and outbound User Datagram Protocol (UDP) and Transmission Control Protocol (TCP) protocols. Load Balancer can handle millions of requests per second while ensuring your solution is highly available. Load Balancer is zone-redundant, ensuring high availability across availability zones.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for private networks in Azure. Use Virtual Network for communication between nodes and Azure services, and for hybrid connectivity.

- [Azure Files](/azure/well-architected/service-guides/azure-files) provides fully-managed file shares in the cloud that are accessible via the Server Message Block (SMB) and Network File System (NFS) protocols. Use Azure Files to host the stateful data for the databases and systems inside the cluster.

- [Azure DNS](/azure/dns/dns-overview) manages DNS resolution for the containers inside and outside the solution. Azure DNS supports all common DNS records and provides high availability.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully-managed service that provides remote desktop protocol (RDP) and secure shell (SSH) access to VMs without any exposure through public IP addresses. Optionally use Azure Bastion and a subnet for enhanced-security access to any of the worker nodes or optional jump box machines.

- [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance) provides external data services to MAS when IBM supports SQL Server for the applications that you deploy. You can also choose another database, such as Oracle Exadata or IBM Db2 Warehouse. Azure SQL Database isn't supported.

- [Twilio SendGrid](https://www.twilio.com/docs/sendgrid/for-developers/partners/microsoft-azure-2021) sends emails from MAS to its consumers. If your MAS deployment needs an email service for notification and workforce dispatch scenarios, optionally incorporate an email service such as Twilio SendGrid into your design.

### Alternatives

The following services typically aren't necessary, but are effective alternatives:

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) as a replacement for Azure Files. Azure NetApp Files supports workloads that need high availability and high performance.
- [Oracle Database on Azure](/azure/oracle/oracle-db/database-overview) if supported and you prefer it.
- [OpenShift Data Foundation](https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation) if you want to use Db2 Warehouse on OpenShift Data Foundation.

## Scenario details

The [IBM Maximo Application Suite](https://www.ibm.com/docs/en/masv-and-l/cd?topic=overview) is an enterprise asset management platform with AI-based asset maintenance. MAS focuses on operational resiliency and reliability. The suite consists of the MAS core application platform and the following applications and industry-specific solutions that are built on the platform.

- **Maximo Manage**. Reduces downtime and costs by using asset management to improve operational performance.
- **Maximo Monitor**. Uses internet of things (IoT) for advanced AI-powered monitoring of remote assets at scale.
- **Maximo Health**. Manages asset health by using IoT data from sensors, asset data, and maintenance history.
- **Maximo Visual Inspection**. Trains machine learning models to use visual inspection for visual analysis of emerging issues.
- **Maximo Predict**. Predicts future failures by using machine learning and data analytics.
- **Maximo Collaborate**. Supports technicians with AI-powered guidance from a knowledge base of equipment maintenance data, and provides remote access to experts.
- **Maximo Health, Safety and Environment (HSE)**. Connects safety, environmental compliance, and control-of-work processes to assets, locations, and work orders.
- **Maximo Civil Infrastructure**. Integrates inspection, defect tracking, and maintenance activities to help improve asset life, keep critical systems operating, and lower total costs of ownership of civil infrastructure.
- **Maximo Real Estate and Facilities**. Manages real estate portfolios and facility assets with space management, reservations, capital projects, facility condition assessment, lease management, operations, and maintenance.

### Potential use cases

Many industries and sectors use MAS solutions, such as the following areas:

- Energy and utilities
- Oil and gas
- Manufacturing
- Travel, automotive, and transportation
- Public sector

For more information about MAS use cases, see [IBM Maximo Application Suite](https://www.ibm.com/products/maximo) at the IBM website.

## Recommendations

This article is written for current supported MAS 9.x deployments on Azure. Microsoft worked with the IBM MAS team and other partners to ensure that this solution is configured to run optimally and provide the best experience on Azure. This documentation, architecture, and guidance follow the best practices as outlined in the [Microsoft Azure Well-Architected Framework](/azure/well-architected/). Contact your IBM account team for product-specific questions and support beyond this documentation.

Use this article for architecture guidance when you have support from IBM and a partner for installation. Azure also offers an installation path for MAS that supports bringing your own license. For more information, see [IBM Maximo Application Suite (bring your own license (BYOL))](https://www.ibm.com/docs/en/masv-and-l/cd?topic=imas-installing-byol-maximo-application-suite).

Install a supported MAS version that IBM lists as compatible with your selected OpenShift version and MAS applications. For new Azure deployments, use ARO as the preferred OpenShift platform unless you require a self-managed cluster.

OpenShift support compatibility depends on three overlapping support boundaries: IBM MAS compatibility, Red Hat OpenShift lifecycle support, and ARO version availability. Using an OpenShift version that IBM doesn't list in the Software Product Compatibility Reports (SPCR) or that's outside Red Hat or ARO support can leave your MAS deployment unsupported.

Before you build your deployment, review the [IBM Maximo Application Suite overview](https://www.ibm.com/docs/en/masv-and-l/cd?topic=azure-overview), [Planning to install on Microsoft Azure](https://www.ibm.com/docs/en/masv-and-l/cd?topic=planning-install-microsoft-azure), and [Software Product Compatibility Reports (SPCR) documentation](https://www.ibm.com/docs/en/cta?topic=planning-software-product-compatibility-reports) to understand the current deployment and configuration requirements.

Before you proceed with your deployment, answer the following questions about your design:

- What MAS applications do you need?
- What dependencies do your applications have?
- Which OpenShift version does IBM support for your MAS version and applications?
- Does ARO meet your requirements, or do you need self-managed Red Hat OpenShift on Azure?
- What databases do you need?
- What number and sizes of VMs do you need?
- Do users need to connect from external networks?

### Maximo Application Suite

Use a current supported MAS 9.x release, and validate the supported OpenShift versions, databases, and dependencies in IBM SPCR before you finalize the architecture. If you're on an earlier version of Maximo Application Suite, review its IBM lifecycle status and plan an upgrade to a supported MAS 9.x release.

Review the MAS applications you need for your complete business scenario, and then review the requirements for each of the applications. For more information, see [IBM Maximo Application Suite system requirements](https://www.ibm.com/docs/en/masv-and-l/cd?topic=deploy-system-requirements). 

Each MAS application might need a separate database. Try to externalize databases if IBM supports an external database for the application, because that approach reduces the amount of state that you must operate inside OpenShift. Microsoft and IBM tested and support the following databases for MAS on Azure:

- [SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance)
- [IBM Db2 Warehouse on Cloud Pak for Data 5](https://www.ibm.com/docs/en/cloud-paks/cp-data/5.0.x?topic=services-db2-warehouse)

Azure SQL Database and Azure Cosmos DB aren't supported.

You might also choose to run Oracle Exadata on Oracle Cloud Infrastructure or on a VM by using an interconnection. This configuration isn't officially tested, but is reportedly successful. For more information about interconnection, see [Interconnecting Oracle Cloud with Microsoft Azure](https://docs.oracle.com/en/solutions/learn-azure-oci-interconnect/index.html).

> [!NOTE]
> In some cases, you can't reuse a database for multiple MAS applications because of conflicting database settings. For example, you can't use the same IBM Db2 Warehouse database for Maximo Health and Maximo Manage in combination with Maximo Monitor. You can mix different database products, such as using SQL Managed Instance and IBM Db2 Warehouse for two different applications.
>
> For more information about database requirements for the Health application, see [Configuring the database for Maximo Health](https://www.ibm.com/support/pages/configuring-database-maximo-health).

MAS and some of its applications are dependent on MongoDB and Kafka. Use the IBM default in-cluster MongoDB Community Edition and Strimzi Kafka deployments when they fit your support, backup, and recovery requirements. This choice is appropriate when Kafka and MongoDB are internal MAS dependencies and your solution doesn't use them outside MAS.

Try to use external managed services, such as MongoDB Atlas on Azure or Confluent Cloud on Azure, when you need stronger backup, scaling, or disaster recovery operations. Some MAS prerequisites, such as Behavior Analytics Services (BAS), use databases that can't be externalized but require persistent storage to be provided to the OpenShift cluster.

For state-based services that run inside the OpenShift cluster, regularly back up data and move the backups into another region. Design, plan, and decide on a recovery strategy for disasters, especially when you run Kafka or MongoDB inside OpenShift. For services that retain state, use external Azure platform as a service (PaaS) offerings if possible to improve supportability during an outage.

Some services might require other IBM tools and services, such as IBM Watson Machine Learning and IBM App Connect. You can deploy all these tools and services on the same OpenShift cluster.

### Azure Red Hat OpenShift

Use ARO as the preferred OpenShift platform for MAS on Azure. ARO provides a managed OpenShift service on Azure, which reduces your operational burden for installing, patching, and operating the OpenShift platform. You still own MAS and its application configuration, worker capacity planning, network integration, identity integration, storage choices, data protection, and disaster recovery.

Before you deploy MAS on ARO, consider the following recommendations:

- **Version compatibility**. Select an OpenShift version that IBM lists as supported for your MAS version and selected MAS applications. Confirm that the same OpenShift version is available and supported by ARO in your target Azure region. When possible, select an even-numbered OpenShift version for production MAS deployments, because these versions are [Extended Update Support (EUS)](https://access.redhat.com/support/policy/updates/openshift) releases.

  Cross-validate that IBM supports the selected OpenShift version for all selected MAS applications and dependencies. If a MAS component lists a newer odd-numbered OpenShift release as a requirement in IBM SPCR, validate the full component set against IBM SPCR, Red Hat lifecycle support, and ARO version availability before choosing the cluster version.

- **Deployment path**. Use an existing ARO cluster when you have preexisting Azure landing zone, networking, identity, storage, and operational controls. Use the IBM Azure Marketplace installation path when you want IBM-provided automation to create or reuse supported OpenShift infrastructure. Use self-managed Red Hat OpenShift on Azure only when ARO doesn't meet your requirements.

- **Region selection**. Use a region that has [availability zones](/azure/reliability/regions-list) if possible. Configure ARO worker nodes across zones when the target region supports that pattern. For self-managed OpenShift, configure the installation file, *install-config.yaml*, so OpenShift places nodes across zones. If there's an outage in a zone, your solution can continue functioning by having nodes in other zones take over the work.

- **Backup and recovery**. You can use the Azure Red Hat OpenShift backup and recovery instructions. For more information, see [Create an Azure Red Hat OpenShift 4 cluster Application Backup](/azure/openshift/howto-create-a-backup). If you use this method for backup and recovery, you must provide another method of disaster recovery for the database.

- **Failover**. Consider deploying OpenShift in two regions and using [Red Hat Advanced Cluster Management](https://www.redhat.com/en/technologies/management/advanced-cluster-management). If your solution has public endpoints, you can place [Azure Traffic Manager](/azure/traffic-manager/) between the endpoints and the internet to redirect traffic to the appropriate cluster in a regional outage. In that situation, you must also migrate your applications' states and persistent volumes.

### Self-managed OpenShift

Use self-managed Red Hat OpenShift on Azure if ARO doesn't meet your control, isolation, or disconnected deployment requirements. For self-managed deployments, choose between the following installation methods:

- **Installer Provisioned Infrastructure (IPI)**. This method uses an installer to deploy and configure the OpenShift environment on Azure. Use IPI when it meets your security and networking requirements.

- **User Provisioned Infrastructure (UPI)**. This method allows you fine-grained control over your deployment. UPI requires more steps and considerations to build your environment. Use UPI if IPI or ARO don't meet your needs. A private or disconnected installation is a common use case for UPI.

#### Air-gapped installation

Some cases, such as regulatory compliance, might require an *air-gapped* installation of MAS on Azure. Air-gapped means there's no inbound or outbound internet access. Without an internet connection, your installation can't retrieve the dependencies for MAS or OpenShift installation at runtime.

> [!NOTE]
> Air-gapped deployments require [UPI](https://github.com/openshift/installer/blob/main/docs/user/azure/install_upi.md) for installation, but aren't fully tested.

Use an air-gapped installation only if it's a security requirement. An air gap adds significant complexity to solution operations. Activities such as installing software, mirroring containers, updating mirrors to protect against security vulnerabilities, or managing firewalls can consume significant operational effort.

For more information about air-gapped installations, see the following Red Hat OpenShift documentation for disconnected installations and private clusters on Azure:

- [Mirroring images for a disconnected installation using oc-mirror](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/disconnected_environments/installing-mirroring-disconnected)
- [Installing a private cluster on Azure](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/installing_on_azure/preparing-to-install-on-azure#installing-azure-private)

After an air-gapped OpenShift installation, you can continue with the MAS documentation for guidance on [Disconnected environments](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/disconnected_environments/index).

### Node and environment sizing

For all workloads except Maximo Visual Inspection, start with current-generation *Ds* or *Das* series VM families, such as Dsv6, that are available as worker nodes in your chosen region. Choose VM sizes that support premium storage and meet the CPU, memory, and storage requirements for the MAS applications you deploy.

[Maximo Visual Inspection](https://www.ibm.com/products/maximo/asset-inspection) requires GPU nodes to perform its machine learning. The solution uses [CUDA](https://developer.nvidia.com/cuda) and only supports NVIDIA GPUs. For ARO, choose an NVIDIA GPU VM size from the current [ARO worker-node support list](/azure/openshift/support-policies-v4#gpu-workload), and then confirm that IBM supports it for your MAS and OpenShift versions. For self-managed OpenShift, choose an NVIDIA GPU VM size supported by IBM and Red Hat.

For GPU worker nodes, start with the smallest node and scale up as your requirements increase.

> [!IMPORTANT]
> If you need GPU machines, verify that the GPU node type, NVIDIA GPU Operator, OpenShift version, and MAS application support matrix are compatible before deployment. OpenShift 4.21 is the most recent version that IBM SPCR lists for Maximo Visual Inspection. If another MAS component or dependency requires an even-numbered OpenShift EUS release, choose a cluster version that satisfies the full deployed component set. Don't rely on older OpenShift minimum-version guidance for GPU enablement.

For ARO and self-managed OpenShift, use the same MAS workload sizing guidance for worker nodes. Configure worker nodes across [availability zones](/azure/reliability/availability-zones-overview) to support high availability. For self-managed OpenShift, also configure the control plane across availability zones. Use the following starting point:

- **Control nodes**. For ARO, the control plane is managed as part of the service. For self-managed OpenShift, use a minimum of one VM per availability zone within the selected region.

- **Worker nodes**. Use a minimum of two machines per availability zone within the selected region. Size worker nodes based on IBM guidance, selected MAS applications, and expected load.

MAS core requires 13 vCPUs for a standard-sized base installation. Sizing for the worker nodes varies based on which MAS applications your configuration deploys and the load on your environment. For example, Maximo Manage for 10 users requires another 2 vCPUs. Treat these values as starting points and validate sizing against the current [IBM Maximo Application Suite system requirements](https://www.ibm.com/docs/en/masv-and-l/cd?topic=deploy-system-requirements) for your MAS 9.x version, selected applications, and expected usage.

For self-managed OpenShift, try to keep VM types similar to each other to provide proximity with each of the availability zones between worker and control nodes. For ARO, align worker node pools to the same MAS workload requirements and Azure regional capacity.

If you need a jump box to use the OpenShift `oc` command-line interface or to install MAS, deploy a supported Linux VM that meets your organization's administrative and security requirements.

### Network configuration

For ARO, use the default OpenShift networking configuration that ARO deploys unless IBM, Red Hat, and your networking team validate another option. Plan the virtual network and separate subnets for ARO control plane nodes, worker nodes, Azure service dependencies, private endpoints, databases, and hybrid connectivity. Size the node subnets for the number of OpenShift worker nodes that you need, including upgrade capacity and future scale-out.

For self-managed OpenShift, also include bootstrap and installer-created infrastructure requirements. Keep administrative access to the OpenShift API and nodes limited to approved network paths, such as hybrid connectivity, secured jump hosts, or other controls that your organization requires. If you restrict cluster egress, plan the required outbound dependencies for OpenShift, MAS installation, container image pulls, updates, monitoring, and external services.

For a standard MAS production installation on ARO, don't start with a tightly packed virtual network. Reserve a larger address space, such as a Classless Inter-Domain Routing (CIDR) prefix of /16 when your landing zone allows it, and allocate dedicated subnets. Use at least a /24 planning size for the ARO control plane subnet and at least a /24 planning size for the worker node subnet. Add a /27 or larger subnet for private endpoints and external database services. If you optionally deploy Azure Bastion, add a subnet named *AzureBastionSubnet* with a prefix of /26. For more information about Azure Bastion requirements, see [Architecture](/azure/bastion/bastion-overview#architecture).

If you use self-managed OpenShift and are short on IP addresses, you can design a constrained highly available configuration with a minimum prefix of /27 for the control node subnet and /27 for the worker node subnet. Don't use this constrained sizing as the starting point for an ARO production deployment. Don't undersize the virtual network or node subnets. Readdressing an OpenShift deployment after installation is disruptive and might require redeployment.

If you want to use a different Container Network Interface (CNI), size your networks accordingly. MAS with some standard applications deploys over 800 pods, which probably require a CIDR prefix of /21 or larger.

### Database specifics

Some MAS components use MongoDB as a metadata store. The default guidance is to deploy MongoDB Community Edition inside the cluster. If you use that method, ensure that you have a proper procedure for backing up and restoring the database. Consider using MongoDB Atlas on Azure to provide an externalized store, backups, and scaling. Azure doesn't currently support using MongoDB APIs with Azure Cosmos DB.

If you deploy IoT services, you must also provide a Kafka endpoint. The default guidance is to use Strimzi to deploy Kafka inside the OpenShift cluster, but data inside Strimzi is likely lost during disaster recovery. If data loss within Kafka is unacceptable, consider using Confluent Kafka on Azure. Currently, Azure Event Hubs isn't supported with Kafka endpoints.

MAS includes several databases in its pods, and those databases retain their states on the file system provided for MAS. To absorb zone failures, use a zone-redundant storage (ZRS) mechanism to retain the states outside your clusters. The recommended pattern is to use Azure File Storage with the following configurations:

- **Standard** provides SMB shares for lower throughput and ReadWriteOnce (RWO) workloads. Use Standard for parts of the application that don't write to storage often and require a single persistent volume, such as IBM single-level storage.

- **Premium** provides NFS shares for higher throughput and ReadWriteMany (RWX) workloads. Volumes like these are used throughout the cluster for RWX workloads, such as Db2 Warehouse in Cloud Pak for Data or Postgres in Maximo Manage.

Azure Files NFS supports encryption in transit. If the MAS OpenShift client can't use NFS encryption, you can exempt the account from secure transfer enforcement policies. For more information, see [NFS Azure file shares: Encryption](/azure/storage/files/files-nfs-protocol#encryption). Use a [private endpoint](/azure/private-link/private-endpoint-overview) to provide private connectivity to your shares.

If you deploy Db2 Warehouse through Cloud Pak for Data, use OpenShift Data Foundation. For an OpenShift Data Foundation example that uses Ceph File System (CephFS) and RADOS Block Device (Ceph RBD) storage classes for different Db2 Warehouse data types, see [Creating the Db2 instance by using the Cloud Pak for Data console](https://www.ibm.com/docs/en/masv-and-l/cd?topic=SSRHPA_cd/appsuite/install/onprem/db2u_instance_from_cp4d.html).

Don't use Azure Blob Storage with Container Storage Interface (CSI) drivers, because it doesn't support hard links, which some pods require to run.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

OpenShift has built-in capabilities for self-healing, scaling, and resilience. OpenShift and MAS expect components to fail and recover. A key requirement for self-healing is that the cluster has enough worker nodes. To recover from a zone failure within an Azure region, your control and worker nodes must be balanced across availability zones.

MAS and OpenShift use storage to persist state outside the Kubernetes cluster. To ensure that the storage dependencies continue to work during a failure, use [zone-redundant storage](/azure/virtual-machines/disks-deploy-zrs) whenever possible. Zone-redundant storage remains available when a single zone fails.

To help prevent human error, deploy MAS by using as much automation as possible. Use the current IBM installation documentation and supported automation for your selected MAS version, OpenShift platform, and deployment path.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Maintaining access and visibility into the maintenance lifecycle of your assets can be one of your organization's greatest opportunities to operate efficiently and maintain uptime. To improve the security posture of your environment, it's important to use secure authentication and to keep your solutions up to date. Use encryption to help protect all data that moves in and out of your architecture.

By using ARO deployments, you benefit from the ARO shared responsibility model. Azure Red Hat OpenShift is jointly engineered, operated, and supported by Microsoft and Red Hat, who patch, update, and monitor the managed OpenShift platform on your behalf. You remain responsible for deployments on top of ARO. This responsibility includes MAS and its application configuration, identity integration, network controls, worker capacity planning, storage choices, backup and disaster recovery, secrets, data protection, and compliance requirements. For more information, see [Introduction to Azure Red Hat OpenShift](/azure/openshift/intro-openshift) and [Azure Red Hat OpenShift 4.0 support policy](/azure/openshift/support-policies-v4).

Microsoft builds security protections into the Azure platform at the following levels:

- Physical datacenter
- Physical network
- Physical host
- Hypervisor

Use an OpenShift version that your OpenShift platform supports and that IBM supports for your MAS version and applications. When possible, use a supported long-term support release. If you use self-managed OpenShift, you're responsible for patching and maintaining the OpenShift platform and the underlying VMs. If you use ARO, Microsoft handles the patching and management.

Use [network security groups](/azure/virtual-network/network-security-groups-overview) to filter network traffic to and from resources in your [virtual network](/azure/virtual-network/virtual-networks-overview). By using these groups, you can define rules that grant or deny access to your MAS services, such as:

- Allowing SSH access into the OpenShift nodes for troubleshooting.
- Blocking access to all other parts of the cluster.
- Controlling which locations can access MAS and the OpenShift cluster.

To access your VMs, you can connect through hybrid connectivity or through the OpenShift admin console. If you have an online deployment or don't want to rely on hybrid connectivity, you can access your VMs through [Azure Bastion](/azure/bastion/bastion-overview). For security reasons, don't expose VMs to a network or the internet without configuring network security groups to control access.

[Server-side encryption (SSE) of Azure Disk Storage](/azure/virtual-machines/disk-encryption) protects your data and helps you meet organizational security and compliance commitments. With Azure managed disks, SSE encrypts data at rest when persisting it to the cloud. This behavior applies by default to both OS and data disks. OpenShift uses SSE by default.

#### Authentication

MAS supports SSO with Security Assertion Markup Language (SAML). To use Microsoft Entra ID as the SAML identity provider, create an enterprise application in Microsoft Entra ID and configure MAS as the service provider. For more information, see [Microsoft Entra SSO integration with Maximo Application Suite](/entra/identity/saas-apps/maximo-application-suite-tutorial).

Before you set up SAML-based authentication, review both the IBM configuration and the Azure configuration. For information about SAML with MAS, see [Configuring SAML authentication](https://www.ibm.com/docs/en/masv-and-l/cd?topic=methods-configuring-saml-authentication). For information about SAML with Azure, see [Quickstart: Enable single sign-on for an enterprise application](/entra/identity/enterprise-apps/add-application-portal-setup-sso).

You should also configure OAuth for OpenShift administrative access. For ARO, see [Configure Microsoft Entra authentication for an Azure Red Hat OpenShift cluster](/azure/openshift/configure-azure-ad-cli). For self-managed OpenShift, see [Configuring identity providers in OpenShift Container Platform 4.21](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/authentication_and_authorization/configuring-identity-providers).

#### Resource access and auditing

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship](/entra/fundamentals/how-subscriptions-associated-directory) with a Microsoft Entra tenant. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope, such as a subscription, resource group, or single resource. Audit all changes to infrastructure. For more information about auditing, see [Azure Monitor activity log](/azure/azure-monitor/platform/activity-log).

### Cost optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

A standard MAS deployment on Azure includes the following primary cost drivers:

- ARO cluster costs, including worker nodes and any billable control-plane or cluster charges
- Worker node pools sized for MAS Core and the MAS applications that you deploy
- Optional GPU worker nodes for Maximo Visual Inspection
- Database services, such as SQL Managed Instance, Db2 Warehouse, or another IBM-supported database
- Storage accounts or managed storage services for persistent volumes, backups, and installation artifacts
- DNS zones, load balancing, private endpoints, and an optional instance of Azure Bastion

For both ARO and self-managed OpenShift, a standard MAS deployment typically uses the same worker-node sizing baseline. Use the following inventory as a starting point for cost estimation:

- Six worker VMs.
- Three worker VMs for Db2 Warehouse. You can substitute SQL Managed Instance in some configurations instead of using Db2 Warehouse.
- Two Azure Storage accounts.
- Two DNS zones.
- Two load balancers.
- Azure Bastion.
- One Maximo Visual Inspection GPU worker node, if you plan to run Maximo Visual Inspection inside MAS.

The control-plane cost differs by deployment model. For self-managed OpenShift deployments that use IPI or UPI, also include three control VMs. For ARO, account for the managed control plane and any ARO-specific cluster charges instead of adding customer-managed control VMs.

You can review an example estimate by using the [cost calculator](https://azure.com/e/fae03e2386cf46149273a379966e95b1). Configurations vary, so verify your configuration with your IBM sizing team before finalizing your deployment.

## Deploy this scenario

Before you start, review the [IBM Maximo Application Suite system requirements](https://www.ibm.com/docs/en/masv-and-l/cd?topic=premises-system-requirements) and IBM SPCR for your MAS version and applications. Have the following resources available before starting the deployment:

- Access to an Azure subscription with **Reader** permission
- An application registration or service principal name that has **Contributor** and **User Access Administrator** permissions to the subscription
- A domain or delegated subdomain to an Azure DNS zone
- A supported ARO cluster or the permissions and prerequisites to create one
- A pull secret from Red Hat if your deployment path creates or manages OpenShift infrastructure
- A MAS entitlement key
- A MAS license file that you create after MAS installation
- IBM-recommended cluster sizing
- An existing virtual network or a new virtual network that meets ARO and MAS requirements
- High availability and disaster recovery requirements for your specific deployment
- Configuration details for the selected deployment path, such as ARO cluster details or self-managed OpenShift installation parameters

Before building your environment, review the IBM [Planning to install on Microsoft Azure](https://www.ibm.com/docs/en/masv-and-l/cd?topic=planning-install-microsoft-azure) documentation to understand the design parameters. For current Azure installation guidance, see [Maximo Application Suite on Microsoft Azure overview](https://www.ibm.com/docs/en/masv-and-l/cd?topic=azure-overview). Validate your deployment process against current IBM documentation and the support matrix for your MAS version.

### Deployment considerations

Deploy workloads by using infrastructure as code (IaC) rather than manually. Manual deployment can result in misconfiguration. Container-based workloads can be sensitive to misconfiguration, which can reduce productivity.

IBM offers specialist services to help you with installation. Contact your IBM team for support.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [David Baumgarten](https://www.linkedin.com/in/baumgarten-david) | Chief Architect
- [Roeland Nieuwenhuis](https://www.linkedin.com/in/roelandnieuwenhuis) | Chief Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For help getting started, see the following resources:

- [Azure Red Hat OpenShift](https://azure.microsoft.com/products/openshift)
- [Maximo Application Suite on Microsoft Azure overview](https://www.ibm.com/docs/en/masv-and-l/cd?topic=azure-overview)
- [Planning to install on Microsoft Azure](https://www.ibm.com/docs/en/masv-and-l/cd?topic=planning-install-microsoft-azure)
- [Installing OpenShift on Azure](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/installing_on_azure/preparing-to-install-on-azure)
- [OpenShift UPI Guide](https://github.com/openshift/installer/blob/main/docs/user/azure/install_upi.md)
- [Requirements for Maximo](https://www.ibm.com/docs/en/masv-and-l/cd?topic=deploy-system-requirements)
- [IBM Software Product Compatibility Reports](https://www.ibm.com/software/reports/compatibility/clarity/index.html)
- [IBM Maximo Application Suite (BYOL)](https://www.ibm.com/docs/en/masv-and-l/cd?topic=imas-installing-byol-maximo-application-suite)

To learn more about the featured technologies, see the following resources:

- [IBM Passport Advantage](https://www.ibm.com/software/passportadvantage/pao-customer)
- [Introduction to Azure DNS](/training/modules/intro-to-azure-dns/)
- [Introduction to Azure NetApp Files](/training/modules/introduction-to-azure-netapp-files/)
- [Introduction to Azure Red Hat OpenShift](/training/modules/introduction-to-azure-red-hat-openshift/)
- [Red Hat Customer Portal](https://access.redhat.com/)

## Related resources

- [Azure enterprise cloud file share](/azure/architecture/hybrid/azure-files-private)
- [Deploy a Java application with JBoss enterprise application platform (EAP) on an ARO cluster](/azure/developer/java/ee/jboss-eap-on-aro)
