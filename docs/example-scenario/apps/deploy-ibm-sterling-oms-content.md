This architecture illustrates an OMS implementation of a Sterling OMS environment in Azure. It doesn't go into detail on how to install OMS. To learn more about the installation process, see [Installing Sterling Order Management Software](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=installing-sterling-order-management-software).

## Architecture

:::image type="content" alt-text="Architecture diagram that shows the components and services that support deployment of IBM Order Management on Azure." source="./media/deploy-ibm-order-management-architecture.svg" lightbox="./media/deploy-ibm-order-management-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/deploy-ibm-order-management.vsdx) of this architecture.*

The workload can be deployed internally or externally facing, depending on your requirements.

### Workflow

From the perspective of infrastructure, this architecture will solve for these requirements in the following ways:

- A container hosting platform to deploy highly available workloads across availability zones. We reccomend Azure Red Hat OpenShift.
- A fully managed database service designed to serve as the backend-database for the OMS system. Sterling Order Management currenly supports IBM DB2, Oracle, and PostgreSQL. This guide reccomends Azure PostgreSQL Flexible Server.
- A scalable and highly available setup for a JMS-compliant message broker, such as IBM MQ. While not shown on the diagram, this might exist within your cluster or external to the cluster depending on your requirements.
- Private Endpoints for all relative services to isolate and secure network traffic
- Additional, optional Azure Virtual Machines for both management and development purposes
- Azure Premium Files and standard files for storage of log files and other application configuration data

### Components

- [Azure Red Hat OpenShift](https://learn.microsoft.com/en-us/azure/openshift/) Azure Red Hat OpenShift (ARO) provides highly available, fully managed OpenShift clusters on demand, monitored and operated jointly by Microsoft and Red Hat.

- [Virtual Network](https://azure.microsoft.com/services/virtual-network) are uesd for communication between nodes, Azure services, and hybrid connectivity needs.  Virtual Network is the fundamental building block for private networks in Azure.

- [Azure Files](https://azure.microsoft.com/services/storage/files) is used for hosting the stateful data for the databases and systems inside the cluster. Azure Files provides fully managed file shares in the cloud that are accessible via the SMB and NFS protocols.

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) (optional) and a subnet can be used to securely access any of the worker nodes or optional JumpBox machines. Azure Bastion is a fully managed service that provides secure and seamless RDP and SSH access to VMs without any exposure through public IP addresses.

- [Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/overview) Azure Database for PostgreSQL Flexible Server is a fully managed PostgreSQL database as a service offering that can handle mission-critical workloads with predictable performance and dynamic scalability.

- [Linux virtual machines in Azure](https://azure.microsoft.com/services/virtual-machines/linux) is used to provide a jump box for management of your OMS Azure-based resources and services. Note: If you have network connectivity into your Azure environment, you can perform the installation from an existing machine instead.

### Alternatives

The following services typically aren't necessary, but they're effective alternatives:

- [IBM DB2 on Azure](https://azure.microsoft.com/en-us/solutions/oracle) is an optional alternative if you prefer that to Azure Database for PostgreSQL - Flexible Server.
- [Azure NetApp Files](https://azure.microsoft.com/en-us/services/netapp) NetApp Files supports any type of workload with high availability and high performance and is ideal for IO sensitive workloads, such as IBM DB2 on Azure Virtual Machines.
- [Azure Load Balancers](https://azure.microsoft.com/services/load-balancer) If you plan on running IBM DB2 on virtual machines, you should familiarize yourself with using Azure Load Balancers and Pacemaker clustering software to enable high availability for your database servers.
- [Oracle Database on Azure](https://azure.microsoft.com/en-us/solutions/oracle) is an optional alternative if you prefer that to Azure Database for PostgreSQL - Flexible Server.

## Scenario details

IBM's Sterling Order Management Software (OMS) is an order management system that delivers a complete omnichannel order fulfillment platform. It includes features such as real-time inventory visibility and demand, fully configurable order orchestration and workflows, reverse logistics for multi-channel returns and return order status, plus much more.

Microsoft and the IBM Sterling OMS team partnered to ensure this solution is configured to run optimally on Azure. This article provides a design for running OMS v10.0+ on Azure for customers who have support from IBM and a partner for installation. Please contact your IBM team for product-specific questions..

### Potential use cases

Many industries and sectors use the solutions in OMS, including:

- Retail
- Ecommerce
- Manufacturing

Find more information about use cases for OMS on IBM's website at [IBM Sterling Order Management](https://www.ibm.com/products/order-management).

## Recommendations

This guidance was written to support versions of OMS v 10.0, Q3 2022 and later because it provides the best integration options with Azure by offering support for PostgresSQL as well as the Azure Red Hat OpenShift container platform. Before building out your own deployment, we recommend using the quickstart guide to deploy OMS so that you understand how the deployment and configuration works. Knowing how this is done speeds creation of the design requirements for your implementation. For more information, see [QuickStart Guide: Sterling Order Management on Azure](https://github.com/azure/sterling).

We work closely with IBM and other partners to ensure that the guidance, architecture, and quickstart guide give you the best experience on Azure. They follow the best practices as outlined in the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework). Contact your IBM account team for support beyond this documentation.

Before you proceed with your deployment, you should answer the following questions about your design:

- Is this a new deployment of OMS, or are you migrating an existing deployment to Azure? 
- What backend database platform do you plan to use?
  - How big of a database will you need for your data?
- What sort of JMS-based message broker are you planning to use?
  - Where do you plan to deploy this messaging system? In the same OpenShift cluster? External to the cluster on a different platform/virtual machines?
- Do you have an existing container registry, and do you plan to keep using it?
- What number and sizes of VMs do you need for your worker nodes? 
- Security requirements around Encryption needs.
- Access requirements such as considerations about the IDP integration.
- Connectivity needs/firewall rules/ internal&external (egress) services to connect to.
- HA/DR strategy.

### Sterling Order Management (OMS)

Microsoft has tested OMS version 10.0.2209.0 on Azure. Our recommendation is to use the latest version of OMS, which (as of time of writing) is 10.0.2209.0

Before deploying your Azure resources to support your OMS environment, you should familiarize yourself with the different requirements for running OMS:

- [OMS System Requirements](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=installing-system-requirements)

OMS has a dependency on a relational database system for state and data management, and a JMS-enabled message broker system for service-to-service communication and order workflows. OMS supports several different database and message broker options that you can deploy in your environment. For more information, please refer to the appropriate requirements from IBM:

- Database Tier: [Installing and configuring database tier software on UNIX or Linux](https://www.ibm.com/docs/vi/order-management-sw/10.0?topic=tier-installing-configuring-database-software-unix-linux)
- JSM Message Broker: [Integrating with JMS Systems](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=integrating-jms-systems)

### Azure Red Hat OpenShift (ARO)

OMS has been tested with Azure Red Hat OpenShift v4.10.15. Before you deploy Azure Red Hat OpenShift (ARO), there are a few things you need to determine:

- Domain (Optional) - When you deploy ARO, you will need to specify a domain name that will be appended to all services that get deployed in your cluster
- API and Ingress Visibility - You should decide how you want your OpenShift cluster API (for management) and Ingress (for deployed applications and services) to be internet-facing. Note that if you decide to hide your API and/or Ingress with private connectivity, you will only be able to reach these endpoints from a machine that can reach the network where your service is deployed to.
- Master and Worker VM Size and count - In Azure Red Hat OpenShift, the master count is a fixed number, with a minimum reccomended size. Your worker node count which runs your application workloads like Sterling OMS are sized seperately. You should consider the required number of worker nodes in your cluster, plus the appropriate size of each, when deploying your instance. This may take testing and validation to arrive at due to the number of agents in your deployment and the number of pods for each agent type you choose to run. You can adjust this post-deployment as you need to scale as well.

For more information, please refer to the "Before Your Begin" documentation for Azure Red Hat OpenShift: https://learn.microsoft.com/en-gb/azure/openshift/tutorial-create-cluster#before-you-begin 

### Sizing your environment

We recommend using the latest *Ds* series VMs as your worker nodes. Examples are the [Dsv3](/azure/virtual-machines/dv3-dsv3-series#dsv3-series), [Dasv4](/azure/virtual-machines/dav4-dasv4-series#dasv4-series), [Dsv4](/azure/virtual-machines/dv4-dsv4-series#dsv4-series), [Dasv5](/azure/virtual-machines/dasv5-dadsv5-series#dasv5-series), or [Dsv5](/azure/virtual-machines/dv5-dsv5-series#dsv5-series). We recommend using the latest versions, when possible, because they provide better performance. When deploying new or additional nodes, only use VMs that have [premium storage](/azure/virtual-machines/premium-storage-performance).

### Database specifics

Due to OMS having different backend database options, it's important first to decide on which platform you'd like to host your database on, and then size the appropriate service or infrastructure accordingly. However, there are some general guidelines for each that should be considered:

* **Azure Database for PostgreSQL - Flexible Server**: Due to the nature of its scale and redundancy options, Azure Database for PostgreSQL - Flexible Server is the preferred method for hosting OMS workloads in Azure. When deploying your instance, you should take care to:
  * Compute: Select the compute tier that matches your usage patterns. It is recommended to start with "General Purpose" and select an appropriate number of cores. Also note that your CPU, memory, and IOPs are tied to your compute size selection.
  * Storage: When deploying your instance, make sure you add appropriate storage. Also remember that increased storage increases cost, and you cannot shrink your provisioned storage. Therefore, it's important to know your initial data size and predicted growth.
  * Server Parameters: Make sure you adjust server parameters, such as ```max_connections``` that will allow all your agents to maintain connectivity to your database
* **DB2 in Virtual Machines**: When running DB2 on Azure Virtual Machines, there are several complex factors that need to be addressed, such as performance and availability. A detailed write-up of a high-performance DB2 deployment on Azure is available here: https://learn.microsoft.com/en-us/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-ibm-db2-luw. This guide walks through sizing and performance considerations, as well as deploying a high availability DB2 cluster with Pacemaker.
* **Oracle**: Customers who are currently using (or wish to migrate to) an Oracle Database should familiarize themselves with the following options and guides for running Oracle workloads on Azure:
  * Design and implement an Oracle database in Azure: https://learn.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-design
  * Oracle Interconnect for Azure: https://www.oracle.com/cloud/azure/interconnect/


### Message Queue Specifics

Sterling Order Management requires a JMS-based message broker. Most commonly, this is IBM MQ. Running a highly available MQ instance in Azure can best be accomplished by utilizing the IBM MQ Helm Charts for Kubernetes deployments, available here: https://github.com/ibm-messaging/mq-helm. You can deploy these charts into your existing ARO cluster onto seperate workers to isolate your workloads. You can also manually deploy and install MQ onto virtual machines if you prefer.

As part of the standard deployment, you can define your queues at deployment time, reducing the configuration time needed to spin up your instances. Furthermore, the standard deployment will create one active and two passive instances of your queue manager. Once your deployment is complete, you can SSH into the current leader pod and define your JMS bindings file, which you can then use to create your configuration map for your OMS deployment.

Note that other JMS-based message queuing systems are supported by IBM, such as ActiveMQ, which you can read more about here: https://www.ibm.com/docs/en/configurepricequote/10.0?topic=site-message-queues-in-sterling-order-management-software. Your deployment options will vary per solution.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Maintaining access and visibility into the maintenance lifecycle of your assets can be one of your organization's greatest opportunities to operate efficiently and maintain uptime. To improve the security posture of your environment, it's important to use secure authentication and to keep your solutions up to date. Use encryption to protect all data that moves in and out of your architecture.

Azure delivers OMS by using the models of infrastructure as a service (IaaS) and PaaS. Microsoft builds security protections into the service at the following levels:

- Physical datacenter
- Physical network
- Physical host
- Hypervisor

Carefully evaluate the services and technologies that you select for the areas above the hypervisor, such as the latest patched version of OpenShift for a major release. Be sure to provide the proper security controls for your architecture. You're responsible for patching and maintaining the security of the IaaS systems. Microsoft takes that role for the PaaS services, like ARO which, although the upgrade is initiatied by the customer, is fully managed by Microsoft and Red Hat. More information about patching and upgrading ARO can be found here: https://learn.microsoft.com/en-us/azure/openshift/howto-upgrade 

Use [network security groups](/azure/virtual-network/security-overview) to filter network traffic to and from resources in your [virtual network](/azure/virtual-network/virtual-networks-overview). With these groups, you can define rules that grant or deny access to your OMS services. Examples include:

- Block access to all other parts of your deployed infrastructure, such as specific ports and services used by your message broker and/or backend database
- Control which locations can have access to OMS and the OpenShift cluster
- The port numbers and ranges you need to open depend on a number of factors, however some to consider are:
  - Service-to-service communcation (port 443)
  - Database-specific ports (example: port 5432 for Azure Postgres Flexible Server)
  - Message Queue ports (example: port 1414 for IBM MQ)

If you need access to your other, non-Red Hat OpenShift nodes for some reason you can access your VMs through [Azure Bastion](/azure/bastion/bastion-overview) (which is optional). For security reasons, you shouldn't expose VMs to a network or the internet without configuring [network security groups](/azure/virtual-network/network-security-groups-overview) to control access to them.

[Server-side encryption (SSE) of Azure Disk Storage](/azure/virtual-machines/disk-encryption) protects your data. It also helps you meet organizational security and compliance commitments. With Azure managed disks, SSE encrypts the data at rest when persisting it to the cloud. This behavior applies by default to both OS and data disks. OpenShift uses SSE by default. ARO also supports Customer Managed Encryption Keys (CMEK) for the OS disks in your cluster.

### Authentication

You should configure OAuth for Azure Red Hat OpenShift. For more information, see [Overview of authentication and authorization](https://learn.microsoft.com/en-us/azure/openshift/configure-azure-ad-ui) in the Azure Red Hat OpenShift documentation.

### Protect your infrastructure

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship](/azure/active-directory/active-directory-how-subscriptions-associated-directory) with an Azure AD tenant. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope. The scope can be a subscription, a resource group, or a single resource. Be sure to audit all changes to infrastructure. For more information about auditing, see [Azure Monitor activity log](/azure/azure-resource-manager/resource-group-audit).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

A standard deployment of OMS consists of the following components. Note that many of these compute-based resources can be adjusted to meet your needs (for instance scaling up your MQ agent nodes to allow greater throughput):

**Azure Red Hat OpenShift (OMS)**
 - 3 control VMs (Standard_D8s_v5)
 - 3 worker VMs (Standard_D8s_v5)

**Additional Resources**
- 1 Virtual Network (/16), with the following subnets considered:
  - ARO Control Node Subnet (/24)
  - ARO Worker Node Subnet (/24)
  - Data Subnet, if needed (/27)
  - Additional VM Subnet, if needed (/27)
  - Manamange Subnet, if needed (/30)
- 1 Azure Database for PostgreSQL - Flexible Server
- 1 Azure Container Registry
- 2 Azure Storage accounts
- 3 DNS zones
- 2 Load balancers
- 1 Jump Box Virtual Machine
- Azure Bastion

Note that your deployment will differ slightly (i.e. you decide to run DB2 in Azure VMs, or deploy IBM MQ into your ARO environment). You can review an example estimate by using our [cost calculator](https://azure.com/e/fae03e2386cf46149273a379966e95b1). Configurations vary, and you should verify your configuration with your IBM sizing team before finalizing your deployment.

### Reliability

Azure Red Hat OpenShift has built-in capabilities for self-healing, scaling, and resilience to ensure Auzre Red Hat OpenShift and OMS work successfully. Azure Red Hat OpenShift and OMS have been designed for parts that fail and recover. A key requirement for self-healing to work is that there are enough worker nodes. To recover from a zone failure within an Azure region, your control and worker nodes must be balanced across availability zones.

OMS and Azure Red Hat OpenShift use database storage to persist state outside of the Kubernetes cluster. Logs and other application resources are persisted to a storage account. To ensure that the storage dependencies continue to work during a failure, you should use [zone-redundant storage](/azure/virtual-machines/disks-deploy-zrs) whenever possible. This type of storage remains available when a zone fails. Your database deployment should also take multi-zone configurations into account.

Because human error is common, you should deploy OMS by using as much automation as possible. In our [quickstart guide](https://github.com/Azure/sterling), we provide some sample scripts for setting up full, end-to-end automation.

## Deploy this scenario

Before you start, we recommend that you review the [IBM Sterling Order Management system requirements](hhttps://www.ibm.com/docs/en/order-management-sw/10.0?topic=installing-system-requirements). In addition, be sure that you have the following resources available before starting the deployment:

- Access to an Azure Subscription with *Reader* permission
- Application Registration or service principal name that has *Contributor* and *User Access Administrator* permissions to the subscription
- Domain or delegated subdomain to an Azure DNS zone
- IBM OMS entitlement key
- IBM-recommended cluster sizing
- Existing virtual network or a new virtual depending on your requirements. For an example of createing a new virtual network with two empty subnets, you can see an example here: https://learn.microsoft.com/en-us/azure/openshift/tutorial-create-cluster#create-a-virtual-network-containing-two-empty-subnets
- High-availability and disaster-recovery requirements for your specific deployment
- OMEnviroment Configuration file, aka *omenvironment.yaml*, for use when deploying OMS via the OpenShift Operator Catalog

For a step-by-step guide for installing OpenShift and OMS on Azure, including how to address the prerequisites, see our [quickStart guide](https://github.com/Azure/sterling) on GitHub.

### Deployment considerations

The current best practice reccomendation is to deploy workloads by using infrastructure as code (IaC) rather than manually deploying workloads, because manual deployment can result in misconfiguration. Container-based workloads can be sensitive to misconfiguration, which can reduce productivity.

Before building your environment, review the [quickstart guide](https://github.com/azure/sterling#getting-started) to develop an understanding of the design parameters. The quickstart guide isn't intended for a production-ready deployment, but you can use the guide's assets to get to a production-grade mechanism for deployment.

IBM offers specialist services to help you with installation. Contact your IBM team for support. 

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [Drew Furgiuele](https://www.linkedin.com/in/pittfurg/) | Senior Cloud Solution Architect
- [David Baumgarten](https://www.linkedin.com/in/baumgarten-david) | Principal Cloud Solution Architect
- [Roeland Nieuwenhuis](https://www.linkedin.com/in/roelandnieuwenhuis) | Principal Cloud Solution Architect

Other contributors:

- [Vijaya Bashyam](https://www.linkedin.com/in/vijaya-bashyam-76a6837/) | Senior Technical Staff Member, IBM
- [Andy Repton](https://www.linkedin.com/in/andy-repton/) | Managed OpenShift Black Belt, Red Hat
- [James Read](https://www.linkedin.com/in/jwread/) | EMEA Principal Solution Architect, Red Hat 
- [Aneesh AR](https://www.linkedin.com/in/aneesh-ar-tech/) | Senior Cloud Services Black Belt, Red Hat 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next Steps

For help with getting started, see the following resources:

* [Prerequisites to deploying certified containers using Sterling Order Management Software Operator](/azure/architecture/example-scenario/apps/deploy-ibm-maximo-application-suite)
* [IBM Passport Advantage](https://www.ibm.com/software/passportadvantage/pao_customer.html)
* [Quickstart: Deploy an Azure Red Hat OpenShift cluster](/azure/openshift/quickstart-portal)
* [Quickstart: Create an Azure Database for PostgreSQL - Flexible Server](/azure/architecture/example-scenario/apps/deploy-ibm-maximo-application-suite)

## Related Resources

* [Secure access to Azure Red Hat OpenShift with Azure Front Door](/azure/openshift/howto-secure-openshift-with-front-door)
* [Use Azure Key Vault Provider for Secrets Store CSI Driver on Azure Red Hat OpenShift](/azure/openshift/howto-use-key-vault-secrets)
* [IBM MQ In Containers](https://www.ibm.com/docs/en/ibm-mq/9.1?topic=mq-in-containers)

