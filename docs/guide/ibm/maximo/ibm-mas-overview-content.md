Maximo Application Suite, also MAS or Maximo, is an Enterprise Asset Management platform that's focused on operational resiliency and reliability that uses condition-based asset maintenance. The suite consists of a core application platform, Maximo Application Suite, and applications on top of the platform. Each application performs a specific benefit:

- Manage: reduce downtime and costs through asset management to improve operational performance.
- Monitor: advanced AI-powered remote asset monitoring at scale using IoT.
- Health: manage asset health using IoT data from sensors, asset data and maintenance history.
- Visual inspection: train and use visual inspection machine learning models to do use visual analysis of emerging issues.
- Predict: machine learning and data analytics focused on predicting future failures.

Maximo Application Suite (MAS) 8.x and the applications above have been tested and validated for use on Azure. This guidance provides a design for running Maximo 8.x on Azure. It assumes you'll have support from IBM and a partner for installation. Reach out to your IBM team for Maximo product specific questions.

MAS 8.x runs on OpenShift and it's beneficial to familiarize yourself with OpenShift and the suggested patterns for [installation on Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/preparing-to-install-on-azure.html). This architecture illustrates an Openshift cluster. It doesn't go into detail on building the Maximo application. To learn more about that process, see [How to deploy and run IBM Maximo Asset Management on Red Hat OpenShift](https://www.ibm.com/support/pages/sites/default/files/inline-files/$FILE/deploy-run-maximo-on-openshift_0.pdf).

## Potential use cases

The solutions within the Maximo Application Suite are used in many industries such as:

* Energy and utilities
* Oil and gas
* Manufacturing
* Public sector
* Travel, automotive, and transportation

More information about use cases for Maximo can be found on [IBM's Maximo website](https://www.ibm.com/products/maximo).

## Architecture

:::image type="complex" source="./../images/ibm-azure-guide-architecture-diagram.png" alt-text="Architecture diagram showing how to deploy IBM Maximo Application Suite on Azure." border="false":::
   The diagram contains a large rectangle with the label Azure Virtual Network. Inside it, another large rectangle.
:::image-end:::

The workload can be both deployed internally or externally facing, depending on your requirements. 

### Workflow

This architecture will provide you with the following from an infrastructure perspective:

* A container hosting platform to deploy highly available workloads across availability zones
* A privatized deployment of worker and control nodes with integrated with storage
* Azure Files Premium and Standard for storage (OpenShift Data Foundation not required)
* Azure SQL running on a virtual machine or container based DB2WH
* Azure DNS for DNS management of OpenShift and its containers
* Azure Active Directory for Single Sign On into Maximo

### Components

* [Azure Virtual Machines](/azure/virtual-machines/linux/overview) used to host the OpenShift platform and run the Maximo containers
* [Custom Virtual Machine Image for OpenShift](https://docs.openshift.com/container-platform/4.8/architecture/architecture-rhcos.html)
* [Azure Load Balancers](/azure/load-balancer/load-balancer-overview) to provide connectivity into the cluster
* [Virtual Network](/azure/virtual-network/virtual-networks-overview) for communication between nodes, Azure services and hybrid connectivity needs
* [Azure Files](/azure/storage/files/storage-files-introduction) hosting the stateful data for the databases and systems inside the cluster 
* [Public and Private DNS Zones](/azure/dns/dns-overview) managing the DNS resolution for the containers inside and outside of the solution
* Optional [Azure Bastion](/azure/bastion/bastion-overview) and subnet to securely access any of the worker nodes or installation machines
* Optional [Azure SQL on a Virtual Machine](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql) providing data services to Maximo, the database can also be another, like Oracle Exadata or IBM DB2WH
* Optional [Twilio Send Grid](https://docs.sendgrid.com/for-developers/partners/microsoft-azure-2021) to send emails from Maximo to your consumers
* Optionally a [Linux jump box](/azure/virtual-machines/linux/overview) to do the OpenShift installation from

### Alternatives

While typically not necessary, you have other storage options available:
* [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) as a replacement for Azure Files with more performance
* [Oracle Database on Azure](/azure/virtual-machines/workloads/oracle/oracle-reference-architecture) if you want to use Oracle instead of SQL Server or DB2WH
* [OpenShift Data Foundation](https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation) if you want to use DB2WH on ODF

## Recommendations

We recommend installing the latest stable version of IBM MAS as it will provide the best integration options with Azure. Pay close attention to the versions of OpenShift supported as it will vary depending on the version of MAS. Currently the release cycle for Azure Redhat OpenShift (ARO) is too frequent making this option unsupported by IBM.

Usage of earlier or later major versions of OpenShift, like 4.6 or 4.9, can cause you to falling out of official support for IBM MAS. Before building out your own deployment, we strongly recommend deploying our [QuickStart Guide](https://github.com/Azure/maximo) so that you have a good understanding of how the deployment and configuration works. Your understanding gained will speed up the process of creating the design requirements for your implementation.

We work closely with IBM and other partners to ensure the guidance, architecture and our quickstart give you the best experience on Azure. It follows the best practices as outlined in the [Azure Well Architected Framework](/azure/architecture/framework/). Reach out to your IBM account team for support beyond the documentation provided.

Before you proceed with your deployment, you need to make a series of design decisions:

1. What applications do you need? What dependencies do your applications have?
1. What version of OpenShift is required?
1. How to install OpenShift? (IPI or UPI)
1. What databases will be needed?
1. What number and sizes of virtual machines do you need? 
1. Will users connect from external networks?

### Maximo Application Suite

Microsoft has tested Maximo Application Suite 8.5+ on Azure. Our recommendation is to use the latest version of Maximo Application Suite (8.7).

Review what applications you need to complete your business scenario and then review the [requirements for each of the applications](https://www.ibm.com/support/pages/node/6538166). Each of the applications may need separate databases. We have tested and support the following databases on Azure:

* [SQL Server](https://azure.microsoft.com/en-us/services/virtual-machines/sql-server/#overview) on Azure 2019 on Windows or Linux
* IBM [DB2Wh on Cloud Pak for Data 3.5](https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=services-db2-warehouse)

You may also choose to run Oracle Exadata on a VM or on Oracle Cloud Infrastructure using the [OCI Interconnect](https://docs.oracle.com/en/solutions/learn-azure-oci-interconnect/index.html), but we haven't tested this configuration. Currently not supported are Azure SQL DB and Azure Cosmos DB. These databases may be supported in future releases of Maximo.

> [!NOTE] 
> Some databases can not be mixed because you need different features. For example, you can't use the database for health + manage in combination with monitor. You can mix databases, i.e. use SQL Server and DB2WH in conjunction.

Maximo and some of its applications have dependencies on MongoDB and/or Kafka. How you deploy these solutions should be a performance and operations consideration. The defaults are to deploy MongoDB Community Edition and Strimzi Kafka inside the clusters. Maximo also uses Crunchy PostgreSQL inside OpenShift, a dependency that can't be externalized.

For state based services running inside of the OpenShift cluster, it's necessary to frequently perform backups and move them into another region. Plan and decide accordingly, especially when running Kafka or MongoDB inside of OpenShift.

For services that retain state, when possible, use external Azure PaaS offerings to improve upon the supportability during an outage.

Some of the services may require other IBM tooling and services like IBM Watson ML and AppConnect. All of the tools and services can be deployed on top of the same OpenShift cluster. 

### OpenShift

> [!NOTE]
> Running Maximo Application Suite on top of Azure RedHat OpenShift is not supported.

Before you install OpenShift, you'll need to determine which method you'll be using:
- **Installer Provisioned Infrastructure (IPI)**: this method uses an installer to deploy and configure the OpenShift environment on Azure. The IPI method is the most common method for deploying on Azure and should be used unless you have strict security requirements.
- **User Provisioned Infrastructure (UPI)**: this method allows fine grained control over the deployment, which is typically used when you require a private (air gapped) installation. This method should be chosen when you have no outbound internet access during the build of the environment. This method will require more steps and considerations to build your environment. 

Our recommendation is to use the IPI installer whenever possible as it significantly reduces the amount of work that needs to be done to complete the installation.

> [!NOTE]
> Once OpenShift has been installed, the control plane owner will be responsible for maintaining and scaling the worker nodes on Azure. You increase the cluster size through the admin console using MachineSets, not through the Azure portal.

During the installation of OpenShift, there are some considerations:

* **Region Selection**: it's recommended to use a region with [availability zones](/azure/availability-zones/az-overview#azure-regions-with-availability-zones). During deployment, OpenShift will automatically attempt to create nodes across zones based on the configuration found in your `install-config.yaml`. OpenShift itself will by default balance workloads across all available nodes across the availability zones. If there's a zone outage, your solution can keep on functioning by having nodes in other zones that can take over the work. 
* **Backup & Recovery**: although Azure RedHat OpenShift isn't supported by Maximo, you can use [their instructions](/azure/openshift/howto-create-a-backup) for backup and recovery. You'll need to take care of database disaster recovery separately. 
* **Failover**: consider deploying OpenShift into two regions and use [RedHat's Advanced Cluster Management platform](https://www.redhat.com/en/technologies/management/advanced-cluster-management). If your solution has public endpoints, you can place [Azure Traffic Manager](/azure/traffic-manager/) in front of them to redirect traffic to the appropriate cluster if there's an outage of a region. In this situation, you would need to migrate your applications state and persistent volumes as well.

#### Air gap installations

> [!NOTE]
> Air gapped patterns have not been tested in full but would require using the [User Provided Infrastructure (UPI)](https://github.com/openshift/installer/blob/master/docs/user/azure/install_upi.md) as a starting point.

In some cases, for example regulatory, you may require an air gap installation of Maximo on Azure. Air gapped means you have no inbound/outbound internet access to retrieve the install dependencies at runtime for the installation of Maximo or OpenShift. By default we don't recommend you do an air gap install as it creates significant complexity to the operations of your solution. Things such as mirroring containers, keeping the mirrors updated against security vulnerabilities, doing the install, firewall management, etc. can become very time consuming.

For air gap installations, we refer you to the OpenShift documentation for image mirroring and install details. Once OpenShift is up, refer to the IBM Maximo documentation for similar guidance.

### Sizing your environment

For all workloads (except visual inspection), we recommend using the latest Ds series VMs as your worker nodes. Examples are the [Dsv3](/azure/virtual-machines/dv3-dsv3-series#dsv3-series), [Dasv4](/azure/virtual-machines/dav4-dasv4-series#dasv4-series), [Dsv4](/azure/virtual-machines/dv4-dsv4-series#dsv4-series), [Dasv5](/azure/virtual-machines/dasv5-dadsv5-series#dasv5-series), or [Dsv5](/azure/virtual-machines/dv5-dsv5-series#dsv5-series). We recommend using the latest version when possible, as you get better performance. Only use SKUs with Premium Disks.

Visual Inspection needs GPU nodes to perform its machine learning. The solution uses CUDA and only supports Nvidia GPUs. Recommended machine types are the [NCv3](/azure/virtual-machines/ncv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series). If you need to train using YOLOv3, you'll need Ampere based GPUs. Use the [NVadsA10 v5](/azure/virtual-machines/nva10v5-series) or [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) for larger training tasks.

For the GPU machines, we recommend starting with the smallest node and scaling up as your requirements increase. For all other machines, we recommend a highly available, cross availability zone set-up:

> [!WARNING]
> If you need GPU machines, you need OpenShift 4.8.22 as a minimum version to enable the GPUs through the Nvidia Operator.

* Control nodes, you want at a minimum one machine per availability zone within the selected region. The minimum recommended vCPU count is 4. Our reference uses 3x `Standard_D8s_v4` nodes
* Worker nodes, you want a minimum of two machines per availability zone within the selected region. The minimum recommended vCPU count is 8. Our reference uses 6x `Standard_D8s_v4` nodes.

Maximo Application Suite core requires 23 vCPUs for a standard sized base install. Sizing for the worker nodes will vary based on which Maximo applications are deployed and the expected load on your environment. For example, manage for 10 users needs another 13 vCPUs.

Try to keep VM types similar to provide proximity with each of the availability zones between worker and control nodes. That is, if you use a v4 for your control nodes, use a v4 for your worker nodes.

If you need a jump box to do `oc` work or install Maximo, then we recommend deploying a `Standard_B2ms` running RHEL 8.4. It has been sufficient in our tests.

### Network

With OpenShift, we use the default [OpenShift SDN CNI provider](https://docs.openshift.com/container-platform/4.8/networking/cluster-network-operator.html). You need to size your network for the number of OpenShift control and worker nodes you need, as well as any requirements like databases, and storage accounts.

For a standard Maximo production install, we recommend a VNet with a /24 of address space. The VNet has two or three subnets. One is a /25 for the worker nodes and another is a /27 subnet for the control nodes. A third /27 may be needed for private endpoints and your database servers if desired.

If you're short on IP addresses, the minimum highly available set-up can use is a /27.

If you want to use a different CNI, size your networks accordingly. Maximo with some standard applications deploys many Pods (800+), you're likely going to need a /21 or larger. 

### Database specifics

Various components of the Maximo Application Suite use MongoDB as a metadata store. The default guidance is to deploy MongoDB CE inside of the cluster. If you deploy using that method, ensure that you have a proper backup/restore procedure in place. Consider using MongoDB Atlas on Azure as it provides you with an externalized store, backups, scaling and more. Azure Cosmos DB using MongoDB APIs is currently not supported.

If you're deploying IoT services, you'll be required to provide a Kafka endpoint as well. The default guidance is to deploy Strimzi Kafka inside the OpenShift cluster. During a DR activity, data inside Strimzi will most likely be lost. If data loss within Kafka is unacceptable, you should consider using Confluent Kafka on Azure. Currently, Azure EventHubs with Kafka endpoints aren't supported. 

Maximo comes packed with many databases inside of its pods and those databases retain state on the filesystem provided for Maximo. We recommend using a zone redundant storage mechanism to retain the state outside of your clusters and be able to absorb zone failures. Our recommended pattern is to use Azure File Storage with the following configurations:

* **Standard**: provides _SMB_ shares for lower throughput / rwo workloads. Great fit for parts of the application that aren't chatty and only need a single persistent volume (for example, IBM SLS)
* **Premium**: provides _NFS_ shares for higher throughput / rwx workloads. Volumes like these are used throughout the cluster for RWX workloads, such as the DB2WH in CP4D or Postgres in Manage.

Make sure policies for enforcing secure transfer on the Azure Blob Storage are disabled or the accounts exempted. Azure Files Premium with NFS requires secure transfer to be set to off. Ensure that Private Endpoints are used to guarantee private connectivity to your shares.

By default DB2WH wants to deploy on top of OpenShift Data Foundation (previously OCS). For cost, performance, scaling and reliability reasons it's recommended to use Azure Files Premium with NFS instead of ODF/OCS.

Don't use Azure Blob with CSI drivers, it doesn't support required hardlinks, which will prevent pods from running. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Authentication

Maximo currently supports the use of SAML via Azure Active Directory (Azure AD). To make this work, you'll need an enterprise application within Azure AD and permissions to modify the application or work with an Azure AD global administrator to do the work.

A [tutorial on how to set up SAML with Maximo](https://github.com/Azure/maximo#enabling-saml-authentication-against-azure-ad) is available in our [deployment guide](https://github.com/Azure/maximo#enabling-saml-authentication-against-azure-ad). 

Before you set up the authentication, we recommend you go through the [IBM configuration](https://www.ibm.com/docs/en/mas83/8.3.0?topic=administration-configuring-suite#saml) and [Azure configuration](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/add-application-portal-setup-sso). 

You should also configure OAuth for OpenShift as well. Please see these docs for more information: [the OpenShift documentation](https://docs.openshift.com/container-platform/4.8/authentication/index.html).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Maintaining access and visibility into yours assets maintenance lifecycle can be one of your organization's greatest opportunities to operate efficiently and maintain uptime. It's important to use secure authentication (for example, SAML) and keep your solutions up-to-date to give you a better security posture. Use encryption to protect all data moving in and out of your architecture.

Azure delivers Maximo by using an infrastructure as a service (IaaS) and Platform as a Service (PaaS) cloud model. Microsoft builds security protections into the service at the following levels:

- Physical datacenter
- Physical network
- Physical host
- Hypervisor

Carefully evaluate the services and technologies that you select for the areas above the hypervisor, such as the latest patched version of OpenShift for a major release. Make sure to provide the proper security controls for your architecture. You're responsible for patching and maintaining the security of the IaaS systems. Microsoft takes that role for the PaaS services used. 

Use [network security groups](/azure/virtual-network/security-overview) to filter network traffic to and from resources in your [virtual network](/azure/virtual-network/virtual-networks-overview). With these groups, you can define rules that grant or deny access to your Maximo services. Examples include:

- Allow SSH access into the OpenShift nodes for troubleshooting
- Blocking access to all others parts of the cluster
- Controlling from where you can access Maximo and OpenShift cluster

We recommend you control remote access to your VMs through [Azure Bastion](/azure/bastion/bastion-overview). Don't expose components like virtual machines to a network or internet without NSGs on them. 

[Server-side encryption (SSE) of Azure Disk Storage](/azure/virtual-machines/disk-encryption) protects your data. It also helps you meet organizational security and compliance commitments. With Azure managed disks, SSE encrypts the data at rest when persisting it to the cloud. This behavior applies by default to both OS and data disks. OpenShift uses SSE by default.

#### Protect your infrastructure

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship](/azure/active-directory/active-directory-how-subscriptions-associated-directory) with an Azure AD tenant. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope. The scope can be a subscription, a resource group, or a single resource. Make sure to [audit all changes to infrastructure](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-audit).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

A standard deployment of Maximo Application Suite will consist of the following components:
 - 3 x Control VMs
 - 6 x Worker VMs
 - 3 x Worker VMs (DB2WH)
   - You can substitute DB2WH with Azure SQL on a VM in some configurations
- 2 x Azure Storage Accounts
- 2 x DNS Zones
- 2 x Load Balancers
- Azure Bastion
- 1 x Visual Inspection VM
  - Not required unless you're planning to run Visual Inspection inside of MAS

You can review an example estimate using our [cost calculator](https://azure.com/e/fae03e2386cf46149273a379966e95b1). Configurations will vary and should be verified with your IBM sizing team before finalizing your deployment.

## Deploy this scenario

### Deployment prerequisites

Before you start, we recommend you review the [requirements of IBM for deploying Maximo](https://www.ibm.com/support/pages/node/6538166). Make sure you have the below resources available before starting the deployment:

1. Access to an Azure Subscription with Reader privileges
1. Application Registration (SPN) that has Contributor and User Access Administrator privileges to the subscription
1. Domain or delegated Sub Domain to an Azure DNS Zone
1. RedHat OpenShift Service Agreement (Pull Secret)
1. IBM MAS Entitlement Key
1. IBM MAS License File (Created after MAS install)
1. IBM recommended cluster sizing
1. Determine if you want to provide an existing VNet or let the IPI create one
1. Determine what your HA/DR requirements are
1. Create an install-config.yaml file for the installer

For a step-by-step guide for installing OpenShift and MAS on Azure, including how to address the prerequisites, pleas see our official [QuickStart Guide](https://github.com/Azure/maximo) on GitHub.

> [!NOTE]
> Example of a install-config-yaml file can be found in the official [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/Azure/maximo) under the path `/src/ocp/install-config.yaml`

### Deployment considerations

It's best to deploy workloads using an infrastructure as code (IaC) process. Container based workloads can be sensitive to misconfigurations that often occur with manual deployments and reduce productivity.

Before building out your environment, review the [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/azure/maximo#getting-started) to develop and understanding of the design parameters. The quickstart guide isn't intended for a production deploy, but assets in there can be reused to get to a production grade deployment mechanism.

IBM offers specialist services to help you with the installation. Reach out to your IBM team for support. 

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

 * [David Baumgarten](https://www.linkedin.com/in/baumgarten-david/) | Senior Cloud Solution Architect
 * [Roeland Nieuwenhuis](https://www.linkedin.com/in/roelandnieuwenhuis/) | Principal Cloud Solution Architect

<!-- 
Other contributors:

 * [Contributor 1 Name](http://linkedin.com/ProfileURL) | [Title, such as "Cloud Solution Architect"]
 * [Contributor 2 Name](http://linkedin.com/ProfileURL) | [Title, such as "Cloud Solution Architect"] -->

## Next steps

For help with getting started, see the following resources:

- [Installing OpenShift on Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/preparing-to-install-on-azure.html)
- [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/Azure/maximo)
- [OpenShift UPI Guide](https://github.com/openshift/installer/blob/master/docs/user/azure/install_upi.md)
- [Requirements for Maximo](https://www.ibm.com/support/pages/node/6538166)

To learn more about the featured technologies, see the following information:

- [IBM Passport Advantage](https://www.ibm.com/software/passportadvantage/pao_customer.html)
- [Red Hat Customer Portal](https://access.redhat.com/)

## Related resources

[Predictive maintenance for industrial IoT](/azure/architecture/solution-ideas/articles/iot-predictive-maintenance)
