## Introduction to IBM Maximo Application Suite

Maximo Application Suite, also MAS or Maximo, is an Enterprise Asset Management platform focused on operational resiliency and reliability that leverages condition-based asset maintenance. The suite consists of a core application platform, Maximo Application Suite, and applications on top of the platform. Each of the application performs a specific benefit:

- Manage: reduce downtime and costs through asset management to improve operational performance.
- Monitor: advanced AI-powered remote asset monitoring at scale using IoT.
- Health: manage asset health using IoT data from sensors, asset data and maintenance history.
- Visual Inspection: train and use visual inspection machine learning models to do use visual analysis of emerging issues.
- Predict: machine learning and data analytics focused on predicting future failures.

Maximo Application Suite 8.x and the applications above have been tested and validated for use on Azure. This guidance provides a design for running Maximo 8.x on Azure. It assumes you will have support from IBM and a partner for installation. If you have product questions, please reach out to your IBM team. 

<!-- TODO: Add the layer cake -->

MAS 8.x runs on OpenShift and it is beneficial to familiarize yourself with OpenShift and the suggested patterns for [installation on Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/preparing-to-install-on-azure.html). 

<!-- TODO: Introduce the reference architecture that is found on GitHub -->

## Architecture

:::image type="complex" source="./../images/ibm-azure-guide-architecture-diagram.png" alt-text="Architecture diagram showing how to deploy IBM Maximo Application Suite on Azure." border="false":::
   The diagram contains a large rectangle with the label Azure Virtual Network. Inside it, another large rectangle.
:::image-end:::

The architecture provides you with the following:

* Highly available workload across availability zones
* A privatized deployment of worker and control nodes with integrated with storage
* Azure Files Premium and Standard for storage (Openshift Data Foundation not required)
* Azure SQL running on a virtual machine or container based DB2WH
* Azure DNS for DNS management of OpenShift
* Azure Active Directory for Single Sign On into Maximo

The workload can be both deployed internally or externally facing, depending on your requirements. 

## Design choices and Azure recommendations

We recommend installing the latest stable version of IBM MAS as it will provide the best integration options with Azure. Pay close attention to the versions of Openshift supported as it will vary depending on the version of MAS. Currently the release cycle for Azure Redhat Openshift (ARO) is too frequent making this option unsupported by IBM.

Using earlier or later major versions of Openshift (e.g. 4.6 or 4.9) can cause you to falling out of official support for IBM MAS. Before building out your own deployment, we strongly recommend deploying our [QuickStart Guide](https://github.com/Azure/maximo) so that you have a good understanding of how the deployment and configuration works. This will speed up the process of creating the design requirements for your implementation.

We work closely with IBM and other partners to ensure the guidance found in this document and our quickstart gives you the best experience on Azure. It follows the best practices as outlined in the [Azure Well Architected Framework](/azure/architecture/framework/). Please do not hesitate to reach out to your IBM account team for support beyond the documentation provided.

Before you proceed with your deployment, you need to make a series of design decisions:

1. What applications do you need? What dependencies do your applications have?
1. What version of OpenShift is required?
1. How to install OpenShift? (IPI or UPI)
1. What databases will be needed?
1. What number and sizes of virtual nachines do you need? 
1. Will users connect from external networks?

### Maximo Application Suite

Microsoft has tested Maximo Application Suite 8.5+ on Azure. Our recommendation is to use the lastest version of Maximo Application Suite (8.7).

Review what applications you need to complete your business scenario and then review the [requirements for each of the applications](https://www.ibm.com/support/pages/node/6538166). For each of the applications you may need separate databases. We have tested and support the following databases on Azure:

* [SQL Server](https://azure.microsoft.com/en-us/services/virtual-machines/sql-server/#overview) on Azure 2019 on Windows or Linux
* IBM [DB2Wh on Cloud Pak for Data 3.5](https://www.ibm.com/docs/en/cloud-paks/cp-data/3.5.0?topic=services-db2-warehouse)

You may also choose to run Oracle Exadata on a VM or on Oracle Cloud Infrastructure using the [OCI Interconnect](https://docs.oracle.com/en/solutions/learn-azure-oci-interconnect/index.html), but we have not tested this configuration. Currently not supported are Azure SQL DB and Azure CosmosDB. These databases may be supported in future releases of Maximo.

> [!NOTE] 
> Some databases can not be mixed because you need different features. For example, you can't use the database for health + manage in combination with monitor. You can mix databases, i.e. use SQL Server and DB2WH in conjunction.

Maximo and some of its application have dependencies on MongoDB and/or Kafka. How you deploy these solutions should be a performance and operations consideration. The defaults are to deploy MongoDB Community Edition and Strimzi Kafka inside the clusters. Maximo also uses Crunchy PostgreSQL inside OpenShift, this dependency can not be externalized.

For state based services running inside of the OpenShift cluster, it is necessary to frequently perform backups and move them into another region. Plan and decide accordingly, especially when running Kafka or MongoDB inside of OpenShift.

For services that retain state, when possible, use external Azure PaaS offerings to improve upon the supportability in the event of an outage.

Some of the services may require other IBM tooling such as IBM Watson ML or AppConnect. All of these can be deployed on top of the same OpenShift cluster. 

### OpenShift

> [!NOTE]
> Running Maximo Application Suite on top of Azure RedHat OpenShift is not supported.

Before you install Openshift, you will need to determine which method you will be using:
- **Installer Provisioned Infrastructure (IPI)** - This method uses an installer to deploy and configure the Openshift environment on Azure. This is the most common method for deploying on Azure and should be used unless you have strict security requirements.
- **User Provisioned Infrastructure (UPI)** - This method allows fine grained control over the deployment which is typically used when you require a completely private (air gapped) installation. This method should be chosen when you have no outbound internet access for provisioning. This method will require additional steps and considerations to build the environment. 


> [!NOTE]
> Once OpenShift has been installed, the control plane owner will be responsible for maintaining and scaling the worker nodes on Azure. You increase the cluster size through the admin console using MachineSets, not the Azure portal.


Considerations:

- **Region Selection**: it is recommended to use a region with [availability zones](/azure/availability-zones/az-overview#azure-regions-with-availability-zones). During deployment, OpenShift will automatically attempt to provision nodes across zones based on the configuration found in your `install-config.yaml`. OpenShift itself will by default balance workloads across all available nodes across the availability zones. In the event of a zone outage, your solution can keep on functioning by having nodes in other zones that can take over the work. 
- **Backup & Recovery**: although Azure RedHat OpenShift is not supported by Maximo, you can use [their instructions](/azure/openshift/howto-create-a-backup) for backup and recovery. 
- **Failover** - Consider deploying OpenShift into 2 regions and use [RedHat's Advanced Cluster Management platform](https://www.redhat.com/en/technologies/management/advanced-cluster-management). If your solution has public endpoints, you can place Azure Traffic Manager in front of them to redirect traffic to the appropriate cluster in the event of an outage. In this situation, you would need to migrate your applications state and persistent volumes as well.

#### Air gap installations

> [!WARN]
> Air gapped patterns have not been tested in full but would require using the [User Provided Infrastructure (UPI)](https://github.com/openshift/installer/blob/master/docs/user/azure/install_upi.md) as a starting point.

In some cases you may requirean air gap installation of Maximo on Azure. Air gapped means you have no inbound/outbound internet access to retrieve the install dependancies at runtime for the installation of Maximo or OpenShift. By default we do not recommend you do an air gap install as it creates very significant complexity to the operations of your solution. Things such as mirroring containers, keeping the mirrors updated against security vulnerabilities, doing the install, firewall management, etc can become very time consuming.

For air gap installations, please refer to the OpenShift documentation for image mirroring and install details. Once OpenShift is up, refer to the IBM Maximo documentation for simliar guidance.

### Sizing your environment

For all workloads (except visual inspection), we recommend using the latest Ds series VMs as your worker nodes. These can be [Dsv3](/azure/virtual-machines/dv3-dsv3-series#dsv3-series), [Dasv4](/azure/virtual-machines/dav4-dasv4-series#dasv4-series), [Dsv4](/azure/virtual-machines/dv4-dsv4-series#dsv4-series), [Dasv5](/azure/virtual-machines/dasv5-dadsv5-series#dasv5-series), or [Dsv5](/azure/virtual-machines/dv5-dsv5-series#dsv5-series). We recommend using the latest version when possible, as you get better performance. Only use SKUs with Premium Disks.

Visual Inspection needs GPU nodes to perform its machine learing. The solution uses CUDA and only supports Nvidia GPUs. Recommended machine types are the [NCv3](/azure/virtual-machines/ncv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series). If you need to train using YOLOv3, you'll need Ampere based GPUs. Use the [NVadsA10 v5](/azure/virtual-machines/nva10v5-series) or [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) for larger training tasks.

For the GPU machines, we recommend starting with the smallest node and working your way up as your requirements increase. For all other machines, we recommend a highly available, cross availability zone set up:

> [!WARN]
> If you need GPU machines, you need OpenShift 4.8.22 as a minimum version to enable the GPUs through the Nvidia Operator.

* Control nodes, you will want at a minimum 1 machine per availability zone within the selected region. The minimum recommended vCPU count is 4. Our reference uses 3x `Standard_D8s_v4` nodes
- Worker nodes, you will want a minimum of 2 machines per availability zone within the selected region. The minimum recommended vCPU count is 8. Our reference uses 6x `Standard_D8s_v4` nodes.

Maximo Application Suite core requires 23 vCPUs for a standard sized base install. Sizing for the worker nodes will vary based on which Maximo applications are deployed and the expected load on your environment. For example, manage for 10 users needs an additional 13 vCPUs.

Try to keep VM types similar to provide proximity with each of the availability zones between worker and control nodes. I.e. if you use a v4 for your control nodes, use a v4 for your worker nodes.

If you need a jump box to do `oc` work or install Maximo, than we recommend to deploy a `Standard_B2ms` running RHEL 8.4. It has been sufficient in our tests.

### Network

With OpenShift we use the default [OpenShift SDN CNI provider](https://docs.openshift.com/container-platform/4.8/networking/cluster-network-operator.html). You need to size your network for the number of OpenShift control and worker nodes you need, as well as any requirements like databases, and storage accounts.

For a standard Maximo production install, we recommend a VNet with a /24 of address space with a /25 for the worker nodes and a /27 subnet for the control nodes. An additional /27 is needed for private endpoints and your database servers if required. 

If you are short on IP addresses, the minimum highly available set up can use is a /27.

If you want to use a different CNI, size your networks accordingly. Maximo with some standard applications deploys a lot of Pods (800+), you are likely going to need a /21 or larger. 

### Database specifics

Various components of the Maximo Application Suite leverage MongoDB as a metadata store. The default guidance is to deploy MongoDB CE inside of the cluster. When using this method, ensure that you have a proper backup/restore procedure in place. Consider using MongoDB Atlas on Azure as it provides you with an externalized store, backups, scaling and more. Azure CosmosDB using MongoDB APIs is currently not supported.

If you are deploying IoT services, you will be required to provide a Kafka endpoint as well. The default guidance is to deploy Strimzi Kafka inside the OpenShift cluster. In the event of a DR scenario, data inside Strimzi will most likley be lost. If this is unacceptable, consider using Confluent Kafka on Azure. Currently, Azure EventHubs with Kafka endpoints isn't supported. 

Maximo comes packed with many databases inside of its pods and those databases retain state on the filesystem provisioned for Maximo. We recommend using a zone redundant storage mechanism to retain the state outside of your clusters and be able to absorb zone failures. Our recommended pattern is to use Azure File Storage with the following configurations:

* **Standard**: Provision _SMB_ shares for lower throughput / rwo workloads. Great fit for parts of the application that are not chatty and only need a single persistent volume (e.g., IBM SLS)
* **Premium**: Provision _NFS_ shares for higher throughput / rwx workloads. Used throughout the cluster for RWX workloads, such as the DB2WH in CP4D or Postgres in Manage.

Make sure policies for enforcing secure transfer on the Azure Blob Storage are disabled or the accounts exempted. Azure Files Premium with NFS requires secure transfer to be set to off. Ensure that Private Endpoints are used to guarantee private connectivity to your shares.

By default DB2WH wants to deploy on top of OpenShift Data Foundation (previously OCS). For cost, performance, scaling and reliability reasons it is recommended to use Azure Files Premium with NFS instead of ODF/OCS.

Do not use Azure Blob with CSI drivers, it doesn't support required hardlinks which will prevent pods from running. 

### Security and authentication

MAS currently supports the use of SAML via Azure Active Directory (Azure AD). You can find more information at the following locations: [IBM configuration](https://www.ibm.com/docs/en/mas83/8.3.0?topic=administration-configuring-suite#saml) and [Azure configuration](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/add-application-portal-setup-sso). When managing IaaS resources, you can use Azure AD for authentication and authorization to the Azure portal.

<!-- TODO: Needs to be fleshed out more, considerations for the SAML etc -->
<!-- TODO: add details around certificates and authentication patterns (SAML) -->

## Deployment Prerequisites

Before you start, please review the [requirements of IBM for deploying Maximo](https://www.ibm.com/support/pages/node/6538166). Make sure you have the below resources available before starting the deployment:

1. Access to an Azure Subscription with Reader privileges
1. Application Registration (SPN) that has Contributor and User Access Administrator privileges to the subscription
1. Domain or delegated Sub Domain to a Azure DNS Zone
1. RedHat OpenShift Service Agreement (Pull Secret)
1. IBM MAS Entitlement Key
1. IBM MAS License File (Created after MAS install)
1. IBM recommended cluster sizing
1. Determine if you will provide an existing VNet or let the IPI create one
1. Determine what your HA/DR requirements are
1. Create an install-config.yaml file for the installer

For a step-by-step guide for installing OpenShift and MAS on Azure, including how to address the prerequisites, pleas see our official [QuickStart Guide](https://github.com/Azure/maximo) on GitHub.

> [!NOTE]
> Example of a install-config-yaml file can be found in the official [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/Azure/maximo) under the path `/src/ocp/install-config.yaml`

### Deploying

It's best to deploy workloads using an infrastructure as code (IaC) process. Container based workloads can be sensitive to misconfigurations that often occur with manual deployments and reduce productivity.

Before building out your environment, review the [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/azure/maximo#getting-started) to develop and understanding of the design parameters. 

<!-- TODO: dovetail with the work of Sean, we need to link to that -->
<!-- Work with your MSFT partner/GSI to carry this forward? -->

## Security

Maintaining access and visibility into yours assets maintenance lifecycle can be one of your organization's greatest opportunity to operate efficiently and maintain uptime. It's important to secure access to your Maximo deployment. To achieve this goal, use secure authentication (e.g., SAML) and keep your solutions up-to-date. Use encryption to protect all data moving in and out of your architecture.

Azure delivers Maximo by using an infrastructure as a service (IaaS) and Platform as a Service (PaaS) cloud model. Microsoft builds security protections into the service at the following levels:

- Physical datacenter
- Physical network
- Physical host
- Hypervisor

Carefully evaluate the services and technologies that you select for the areas above the hypervisor, such as the latest patched version of OpenShift for a major release. Make sure to provide the proper security controls for your architecture.

Use [network security groups](/azure/virtual-network/security-overview) to filter network traffic to and from resources in your [virtual network](/azure/virtual-network/virtual-networks-overview). With these groups, you can define rules that grant or deny access to your Maximo services. Examples include:

- Allow SSH access into the OpenShift nodes for troubleshooting
- Blocking access to parts of the cluster

[Server-side encryption (SSE) of Azure Disk Storage](/azure/virtual-machines/disk-encryption) protects your data. It also helps you meet organizational security and compliance commitments. With Azure managed disks, SSE encrypts the data at rest when persisting it to the cloud. This behavior applies by default to both OS and data disks.

### Protect your infrastructure

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship](/azure/active-directory/active-directory-how-subscriptions-associated-directory) with an Azure AD tenant. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope. The scope can be a subscription, a resource group, or a single resource. Make sure to [audit all changes to infrastructure](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-audit).

Manage remote access to your VMs through [Azure Bastion](/azure/bastion/bastion-overview). Don't expose components like virtual machines without NSGs on them. 

## Contributors

<!-- > (Expected, but this section is optional if the principal authors would prefer to not include it)

> Start with the explanation text (same for every article), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Pricipal authors" list and the "Additional contributors" list (if there are additional contributors). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). (The profiles can be linked to from the person's LinkedIn page, and we hope to automate that on the platform in the future). 
> Implement this format: -->

_This article is being updated and maintained by Microsoft. It was originally written by the following contributors._
<!-- 
**Principal authors:** > Only the primary authors. List them alphabetically, by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s). -->

 * [David Baumgarten](https://www.linkedin.com/in/baumgarten-david/) | Senior Cloud Solution Architect
 * [Roeland Nieuwenhuis](https://www.linkedin.com/in/roelandnieuwenhuis/) | Principal Cloud Solution Architect
<!-- * > Continue for each primary author (even if there are 10 of them). -->

<!-- 
**Additional contributors:** > Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. List them alphabetically, by last name. Use this format: Fname Lname. It's okay to add in newer contributors.

 * [Contributor 1 Name](http://linkedin.com/ProfileURL) | [Title, such as "Cloud Solution Architect"]
 * [Contributor 2 Name](http://linkedin.com/ProfileURL) | [Title, such as "Cloud Solution Architect"] -->

## Next steps

For help getting started, see the following resources:

- [Installing Openshift on Azure docs](https://docs.openshift.com/container-platform/4.6/installing/installing_azure/installing-azure-default.html)
- [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/azure/maximo)
- [Openshift UPI Guide](https://github.com/openshift/installer/blob/master/docs/user/azure/install_upi.md)

## Related resources

- [IBM Passport Advantage](https://www.ibm.com/software/passportadvantage/pao_customer.html)
- [Red Hat Customer Portal](https://access.redhat.com/)