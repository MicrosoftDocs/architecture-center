## Introduction to IBM Maximo Application Suite

The Maximo Application Suite (MAS) is an Enterprise Asset Management platform focused on operational resiliency and reliability that leverages condition-based asset maintenance. The suite has several core components:

- Manage - Reduce downtime and costs through asset management to improve operational performance.
- Monitor - Advanced AI-powered remote asset monitoring at scale.
- Health - Manage the health of assets using IoT data from sensors, asset data and maintenance history.
- Visual Inspection - Inspection of assets using mobile devices that focuses on identification of emerging issues.
- Predict - Machine learning and data analytics focused on predicting future failures.
- Mobile - Capability to integrate the various asset and facility management solutions.

<!-- TODO: Add the layer cake -->
The following components have been tested on Azure:

- Maximo Application Suite Core
- Manage
- Monitor

This guide provides general information for running MAS on Azure and assumes you will have support from an IBM Partner for installation. MAS 8.x runs on OpenShift and it is beneficial to familiarize yourself with the suggested patterns for [Preparing to install on Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/preparing-to-install-on-azure.html). For this guide, we will be focusing on the IPI pattern.

<!-- TODO: Explain IPI vs UPI or at least link to a resource that explains what it is -->

> [!NOTE]
> Air gapped patterns have not been tested but would require using the [User Provided Infrastructure (UPI)](https://github.com/openshift/installer/blob/master/docs/user/azure/install_upi.md) as a starting point.

<!-- TODO: Introduce the reference architecture that is found on GitHub -->

## Architecture

:::image type="complex" source="./../images/ibm-azure-guide-architecture-diagram.png" alt-text="Architecture diagram showing how to deploy IBM Maximo Application Suite on Azure." border="false":::
   The diagram contains a large rectangle with the label Azure Virtual Network. Inside it, another large rectangle.
:::image-end:::

<!-- TODO: Needs a bit more explanation and direction -->
The IPI install pattern along with a `install-config.yaml` file will produce the above architecture minus the following:

- Domain Name with DNS Zone
- BYO Virtual Network (Optional)
- Premium Storage (NFS) with a Private Endpoint
- Standard Storage (SMB) with a Private Endpoint
- JumpBox (used for access / installation)
- SQL Server (Optional)
- Virtual Network Gateway and other services outside of the Virtual Network

> [!NOTE]
> Example of a install-config-yaml file can be found in the official [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/Azure/maximo) under the path `/src/ocp/install-config.yaml`

## Prerequisites

1. Access to an Azure Subscription with User Access Administrator privileges
1. Application Registration (SPN) that has Contributor and User Access Administrator privileges
1. Domain or delegated Sub Domain to a Azure DNS Zone
1. RedHat OpenShift Service Agreement (Pull Secret and other keys)
1. IBM MAS Entitlement Key
1. IBM MAS License File
1. An idea of the size cluster you need, work with IBM for sizing
1. Determine if you will provide an existing VNet or let the IPI create one
1. Determine what your HA/DR requirements are

For a step-by-step guide for installing OpenShift and MAS on Azure, including how to address the prerequisites, pleas see our official [QuickStart Guide](https://github.com/Azure/maximo) on GitHub.

## Design recommendations

At this time, IBM MAS 8.7 supports OpenShift versions 4.8. It is recommended to use this version to avoid falling out of official support for either IBM MAS or RedHat OpenShift. Before, building out your own deployment, we strongly recommend deploying our [QuickStart Guide](https://github.com/Azure/maximo) reference architecture so that you have a good understanding of how the deployment and configuration works. This will speed up the process of creating the design requirements for your implementation.

We work closely with IBM and other Partners to ensure the guidance found in this document will give you the best experience on Azure. Please do not hesitate to reach out to your Account Team for support beyond this documentation.

<!-- TODO: This is the bestest practice and aligned with WAF -->
<!-- TODO: Merge parts with the intro -->

## Azure recommendations

Your IBM team can provide you a sizing recommendation based on your existing installation or business requirements. Once complete, you can calculate the number of control and worker nodes you will need for your cluster. A list of recommended Azure components is below.

### VM types

For all workloads except Visual Inspection we recommend using the Dsv4 Series

- Control nodes, you will want at minimum 1 Node per Availability Zone within the selected region. In our diagram above, we suggest 3 - D8s_v4 nodes.
- Worker nodes, you will want a minimum of 2 Nodes per Availability Zone within the selected region. In our diagram above, we suggest 6 - D8s_v4 nodes.

> [!NOTE]
> Sizing for the worker nodes will vary based on which MAS services are deployed and the expected load on your environment.

<!-- TODO: Add the minimum requirement number of nodes, which is 9 for an HA setup -->

If you need a JumpBox to do your installation, you should be able to get by with a `Standard_B2ms` running RHEL 8.4.

### GPU nodes

<!-- TODO: GPU nodes -->
<!-- TODO: Make sure you are on OpenShift 4.8.22 etc. -->

### Network and placement considerations

If there is already an existing support strategy in place for OpenShift then you can skip over the OpenShift specific considerations and handle MAS only. 

<!-- TODO: link to the MAS piece (#anchor)-->

### OpenShift

Considerations:

- **Region Selection** - Inside the OpenShift platform, it attempts to load balance workloads across all available nodes. When configuring the IPI for deployment, it will attempt to provision nodes across zones, when possible. In the event of a zone outage, OpenShift can still function by having nodes in other zones take over the work (assuming those nodes have enough room to schedule the pods). It is recommended to use a region with [availability zones](/azure/availability-zones/az-overview#azure-regions-with-availability-zones). 
- **Backup & Recover** - Although Azure RedHat OpenShift is not supported by MAS, you can use [their instructions](/azure/openshift/howto-create-a-backup) to do backups and recovery. 
- **Failover** - Consider deploying OpenShift into 2 regions and use [RedHat's Advanced Cluster Management platform](https://www.redhat.com/en/technologies/management/advanced-cluster-management). If your solution has public endpoints, you can either place Azure Front Door or Azure Traffic Manager in front of them to redirect traffic to the appropriate cluster in the event of an outage. In this situation, you would need to migrate your applications state and persistent volumes as well.

<!-- TODO: Added network sizing, this is only placement so far -->

### Maximo Application Suite

Considerations:

- **External Dependencies** - If MAS takes dependencies on any external services (databases, kafka, etc.) this should be a performance consideration in case the OpenShift cluster is deployed within another region. Consider reviewing that services' HA/DR options as well.
- **Backup and Restore** - For state based services running inside of the OpenShift cluster, it is necessary to frequently perform backups and move them into another region.
- **State** - For services that retain state, when possible, use external Azure PaaS offerings to improve upon the supportability in the event of an outage.

<!-- TODO: Sizing of network -->

### Data sources

Maximo has multiple data sources. Some are to persist state (e.g. a database) whereas others are used to provide data into and out of Maximo. Depending on the Maximo applications you are deploying you'll need a different setup.

When you need to use a relational database for Maximo Health and Maximo Manage please use the following:

- Microsoft SQL Server 2019 on a VM. Azure SQL DB is currently not supported. 
- IBM DB2 Warehouse which comes as part of IBM CloudPak for Data (CP4D)
- Oracle Exadata on a VM

For Maximo Manage, IBM BAS and IoT parts, Maximo uses MongoDB. The default is to deploy MongoDB CE inside of the cluster. While this may work for smaller deployments, it is not a recommended pattern for larger and/or production deployments. For those, please use at MongoDB Atlas on Azure. 

Maximo Application Suite comes packed with databases inside of its pods and those databases retain state on the filesystem provisioned for MAS. Use a zone redundant storage mechanism to retain the state outside of your clusters and be able to absorb zone failures. Our recommended pattern is to use Azure File Storage in the following patterns:

  - Standard: Provisions _SMB_ shares for lower throughput / rwo workloads. Great fit for parts of the application that are not chatty and only need a single persistent volume (e.g. IBM SLS)
  - Premium: Provisions _NFS_ shares for higher throughput / rwx workloads. Used throughout the cluster for RWX workloads, such as the DB2WH in CP4D or Postgres in Manage.
  
The Azure Files Premium with NFS can be used in place of the OpenShift Data Foundation (previously OCS). For cost, performance, scaling and reliability reasons you want avoid running ODF/OCS yourself.

<!-- TODO: disable https on blob because it breaks NFS -->

Avoid using Azure Blob, as it doesn't support required hardlinks. 

<!-- TODO: there was something with ANF here too -->

## Deployment

It's best to deploy workloads using an infrastructure as code (IaC) process. Container workloads can be sensitive to misconfigurations that often occur with manual deployments and reduce productivity.

Before building out your environment, review the [QuickStart Guide: Maximo Application Suite on Azure](https://github.com/azure/maximo#getting-started) to develop and understanding of the design parameters. 

<!-- TODO: dovetail with the work of Sean, we need to link to that -->
<!-- Work with your MSFT partner/GSI to carry this forward? -->

## Security

Maintaining access and visibility into yours assets maintenance lifecycle can be one of your organization's greatest opportunity to operate efficiently and maintain uptime. It's important, then, to secure access to your MAS architecture. To achieve this goal, use secure authentication and address network vulnerabilities. Use encryption to protect all data moving in and out of your architecture.

Azure delivers MAS by using an infrastructure as a service (IaaS) cloud model. Microsoft builds security protections into the service at the following levels:

- Physical datacenter
- Physical network
- Physical host
- Hypervisor

Carefully evaluate the services and technologies that you select for the areas above the hypervisor, such as the latest patched version of OpenShift for a major release. Make sure to provide the proper security controls for your architecture.

> [!NOTE]
> Once OpenShift has been installed, the control plane owner will be responsible for maintaining and scaling the worker nodes on Azure. You increase the cluster size through the admin console using MachineSets, not the Azure portal.

Use [network security groups](/azure/virtual-network/security-overview) to filter network traffic to and from resources in your [virtual network](/azure/virtual-network/virtual-networks-overview). With these groups, you can define rules that grant or deny access to your SAS services. Examples include:

- Allow SSH access into the OpenShift nodes for troubleshooting
- Blocking access to parts of the cluster

[Server-side encryption (SSE) of Azure Disk Storage](/azure/virtual-machines/disk-encryption) protects your data. It also helps you meet organizational security and compliance commitments. With Azure managed disks, SSE encrypts the data at rest when persisting it to the cloud. This behavior applies by default to both OS and data disks.

### Identity management

MAS currently supports the use of SAML via Azure Active Directory (Azure AD). You can find more information at the following locations: [IBM configuration](https://www.ibm.com/docs/en/mas83/8.3.0?topic=administration-configuring-suite#saml) and [Azure configuration](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/add-application-portal-setup-sso). When managing IaaS resources, you can use Azure AD for authentication and authorization to the Azure portal.

<!-- TODO: Needs to be fleshed out more, considerations for the SAML etc -->

### Protect your infrastructure

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship](/azure/active-directory/active-directory-how-subscriptions-associated-directory) with an Azure AD tenant. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope. The scope can be a subscription, a resource group, or a single resource. Make sure to [audit all changes to infrastructure](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-audit).

Manage remote access to your VMs through [Azure Bastion](/azure/bastion/bastion-overview). Don't expose any of these components to the internet:

- VMs
- Secure Shell Protocol (SSH) ports

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

- Bulleted list of third-party and other Docs and Microsoft links.
- Links shouldn't include en-us locale unless they don't work without it.
- Docs links should be site-relative, for example (/azure/feature/article-name).
- Don't include trailing slash in any links.

## Related resources

- OpenShift
- Related Azure Architecture Center articles.
- Links should be repo-relative, for example (../../solution-ideas/articles/article-name.yml).