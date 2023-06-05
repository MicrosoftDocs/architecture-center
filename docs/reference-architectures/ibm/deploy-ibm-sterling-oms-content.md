This architecture illustrates an implementation of a Sterling Order Management Software (OMS) environment in Azure. This article doesn't go into detail about how to install Sterling OMS. To learn more about the installation process, see [Installing Sterling Order Management Software](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=installing-sterling-order-management-software).

*The Red Hat logos are trademarks of Red Hat, Inc. No endorsement is implied by the use of these marks. Apache® and [Apache ActiveMQ](https://activemq.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" alt-text="Architecture diagram that shows the components and services that support deployment of a Sterling OMS IBM order management system on Azure." source="./media/deploy-ibm-sterling-oms-architecture.png" lightbox="./media/deploy-ibm-sterling-oms-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-2026672-deploy-ibm-sterling-oms-architecture.vsdx) of this architecture.*

You can deploy a workload so that it's internally or externally facing. Use the configuration that best suits your requirements.

### Workflow

The architecture meets infrastructure requirements in the following ways:

- A container-hosting platform is used to deploy highly available workloads across availability zones. We recommend Azure Red Hat OpenShift.
- A fully managed database service functions as the back-end database for the OMS system. Sterling OMS currently supports IBM Db2, Oracle Database, and PostgreSQL. We recommend Azure Database for PostgreSQL with the flexible server option.
- A scalable and highly available setup provides an environment for running a message broker like IBM MQ that's compliant with the Java Message Service (JMS) API. The diagram doesn't include this setup. Depending on your requirements, it might be within your cluster or external to your cluster.
- Private endpoints isolate and secure network traffic to all connected services.
- Additional, optional Azure virtual machines (VMs) are used for management and development purposes.
- Premium and standard Azure Files shares provide storage for log files and other application configuration data.

### Components

- [Azure Red Hat OpenShift](https://azure.microsoft.com/products/openshift) provides highly available, fully managed OpenShift clusters on demand. These clusters are monitored and operated jointly by Microsoft and Red Hat.

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks in Azure. Virtual networks are used for communication between nodes, Azure services, and hybrid connectivity needs.

- [Azure Files](https://azure.microsoft.com/services/storage/files) provides fully managed file shares in the cloud that are accessible via the SMB and NFS protocols. In this solution, Azure Files hosts the stateful data for the databases and systems that are inside the cluster.

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) is a fully managed service that provides secure and seamless RDP and SSH access to VMs without any exposure through public IP addresses. In this solution, Azure Bastion is optional. You can use Azure Bastion and a subnet to securely access any of the worker nodes or optional jump box machines.

- [Azure Database for PostgreSQL](https://azure.microsoft.com/products/postgresql) is a fully managed relational database service that's based on the PostgreSQL database engine. Azure Database for PostgreSQL offers predictable performance and dynamic scalability, and is appropriate for business-critical workloads. Its [flexible server deployment model](/azure/postgresql/flexible-server/overview) provides granular control and flexibility over database management functions and configuration settings.

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) is an infrastructure as a service (IaaS) offer. You can use Virtual Machines to deploy on-demand, scalable computing resources. This solution uses [Linux VMs in Azure](https://azure.microsoft.com/services/virtual-machines/linux) to provide a jump box for management of your OMS Azure-based resources and services.

### Alternatives

If you have network connectivity into your Azure environment, you can perform the installation from an existing machine instead of using an Azure Linux VM.

The following services typically aren't necessary, but they're effective alternatives:

- [IBM Db2 on Azure](https://www.ibm.com/docs/en/db2/11.5?topic=providers-db2-azure) is an optional alternative to the flexible server model of Azure Database for PostgreSQL. If you run IBM Db2 on VMs, familiarize yourself with using [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) and Pacemaker clustering software to achieve high availability for your database servers.
- [Azure NetApp Files](https://azure.microsoft.com/services/netapp) supports any workload type by providing high availability and high performance. Azure NetApp Files is ideal for IO-sensitive workloads, such as IBM Db2 workloads that run on Azure VMs.
- [Oracle Database on Azure](https://azure.microsoft.com/solutions/oracle) is an optional alternative to the flexible server model of Azure Database for PostgreSQL.

## Scenario details

IBM Sterling OMS is an order management system that delivers a complete omnichannel order fulfillment platform. This system includes features such as:

- Real-time inventory visibility and demand.
- Fully configurable order orchestration and workflows.
- Reverse logistics for multi-channel returns and return order status.

A partnership between Microsoft and the IBM Sterling OMS team ensures that this solution is configured to run optimally on Azure. This article provides a design for running Sterling OMS 10.0 and later versions on Azure for customers who have support from IBM and a partner for installation. For answers to product-specific questions, contact your IBM team.

### Potential use cases

Many industries and sectors use OMS solutions, including:

- Retail
- Ecommerce
- Manufacturing

For more OMS use cases, see [IBM Sterling Order Management](https://www.ibm.com/products/order-management).

## Recommendations

This guidance supports Sterling OMS 10.0 Q3 2022 and later versions. These versions provide the best integration options with Azure because they support PostgreSQL and the Azure Red Hat OpenShift container platform. Before you build out your own deployment, use [QuickStart Guide: Sterling Order Management on Azure](https://github.com/azure/sterling) to deploy Sterling OMS. When you then understand how the deployment and configuration work, you can more quickly determine your implementation's design requirements.

Microsoft works closely with IBM and other partners to ensure that the guidance, architecture, and quickstart guide give you the best experience on Azure. These resources follow the best practices as outlined in the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework). For support beyond this documentation, contact your IBM account team.

Before you proceed with your deployment, answer the following questions about your design:

- Is your deployment of Sterling OMS a new one, or are you migrating an existing deployment to Azure?
- What back-end database platform do you plan to use? What size database will you need for your data?
- What type of JMS-based message broker do you plan to use?
- Where do you plan to deploy the messaging system:
  - In the same OpenShift cluster?
  - External to the cluster on a different platform or on VMs?
- Do you have an existing container registry, and do you plan to keep using it?
- What number and sizes of VMs do you need for your worker nodes?
- What are your encryption-related security requirements?
- What are your access requirements, and what identity provider (IdP) integration considerations do you have?
- What are your connectivity needs? What firewall rules do you need to connect to internal and external (egress) services?
- What's your strategy for high availability and disaster recovery?

### Sterling OMS

Sterling OMS version 10.0.2209.0 has been tested on Azure. We recommend that you use the latest version of Sterling OMS. At the time of writing, that version is 10.0.2209.0.

Before deploying your Azure resources to support your Sterling OMS environment, familiarize yourself with the following requirements:

- For Sterling OMS system requirements, see [System Requirements](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=installing-system-requirements).
- Sterling OMS has a dependency on a relational database system for state and data management. A JMS-enabled message broker system is also required for service-to-service communication and order workflows. Sterling OMS supports several database and message broker options that you can deploy in your environment. For more information, see the following resources:
  - Database tier: [Installing and configuring database tier software on UNIX or Linux](https://www.ibm.com/docs/vi/order-management-sw/10.0?topic=tier-installing-configuring-database-software-unix-linux)
  - JMS message broker: [Integrating with JMS Systems](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=integrating-jms-systems)

### Azure Red Hat OpenShift

Sterling OMS has been tested with Azure Red Hat OpenShift version 4.10.15. Before you deploy Azure Red Hat OpenShift:

- Decide on a domain. When you deploy Azure Red Hat OpenShift, specify a domain name that gets appended to all services that get deployed in your cluster.
- Determine your API and ingress visibility. Decide how you want your OpenShift cluster API (for management) and ingress (for deployed applications and services) to be internet-facing. If you use private connectivity to hide your API or ingress, you can only reach these endpoints from a machine that can reach the network where you deploy your service.
- Calculate your master and worker VM sizes and counts. In Azure Red Hat OpenShift, the master count is a fixed number, with a minimum recommended size. Your worker nodes, which run your application workloads like Sterling OMS, are sized separately. When you deploy your instance, consider the required number of worker nodes in your cluster, plus the appropriate size of each. You might need to do some testing and validation to determine the correct numbers and sizes. These values depend on the number of agents in your deployment and the number of pods for each agent type that you run. After deploying, you can adjust these values when you need to scale.

For more information, see [Before Your Begin for Azure Red Hat OpenShift](/azure/openshift/tutorial-create-cluster#before-you-begin).

### Size your environment

We recommend that you use the latest *Ds* series VMs as your worker nodes. Examples are the [Dsv3](/azure/virtual-machines/dv3-dsv3-series#dsv3-series), [Dasv4](/azure/virtual-machines/dav4-dasv4-series#dasv4-series), [Dsv4](/azure/virtual-machines/dv4-dsv4-series#dsv4-series), [Dasv5](/azure/virtual-machines/dasv5-dadsv5-series#dasv5-series), and [Dsv5](/azure/virtual-machines/dv5-dsv5-series#dsv5-series) series. The latest versions of these VMs provide the best performance. When you deploy more nodes, only use VMs that have [premium storage](/azure/virtual-machines/premium-storage-performance).

### Database specifics

Because Sterling OMS has various back-end database options, it's important to first decide which platform to host your database on. Then you can make decisions about the size of that platform. Keep the following general guidelines in mind during this process:

- **Azure Database for PostgreSQL, flexible server deployment model**: Due to the nature of its scale and redundancy options, the flexible server model of Azure Database for PostgreSQL is the preferred method for hosting Sterling OMS workloads in Azure. When you deploy your instance:
  - Select the compute tier that matches your usage patterns. We recommend that you start with a general purpose tier and select an appropriate number of cores. Also note that your CPU, memory, and IOPs are tied to your compute size selection.
  - Add appropriate storage. Also remember that increased storage increases cost, and you can't shrink your provisioned storage. As a result, it's important to know your initial data size and predicted growth.
  - Adjust server parameters such as `max_connections` that affect your agents' ability to maintain connectivity to your database.
- **Db2 on VMs**: When you run Db2 on Azure VMs, there are several complex factors that you need to address, such as performance and availability. For a detailed article about a high-performance Db2 deployment on Azure, see [High availability of IBM Db2 LUW on Azure VMs on Red Hat Enterprise Linux Server](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-ibm-db2-luw). That article walks through sizing and performance considerations. It also shows you how to deploy a high availability Db2 cluster that uses Pacemaker.
- **Oracle**: If you currently use Oracle Database, or if you plan to migrate to Oracle, familiarize yourself with the following resources for running Oracle workloads on Azure:
  - [Design and implement an Oracle database in Azure](/azure/virtual-machines/workloads/oracle/oracle-design)
  - [Oracle Interconnect for Azure](https://www.oracle.com/cloud/azure/interconnect)

### Message queue specifics

Sterling OMS requires a JMS-based message broker. Most commonly, IBM MQ is used. The best way to run a highly available IBM MQ instance in Azure is to use the [IBM MQ Helm Charts for Kubernetes deployments](https://github.com/ibm-messaging/mq-helm). You can deploy these charts into your existing Azure Red Hat OpenShift cluster onto separate workers to isolate your workloads. You can also manually deploy and install IBM MQ onto VMs if you prefer.

As part of the standard deployment, you can define your queues at deployment time, which reduces the configuration time that's needed to spin up your instances. The standard deployment creates one active and two passive instances of your queue manager. When your deployment is complete, you can use SSH to connect to the current leader pod and define your JMS bindings file. You can then use that file to create your configuration map for your Sterling OMS deployment.

IBM also supports other JMS-based message queuing systems, such as Apache ActiveMQ. For more information, see [Message queues in Sterling Order Management Software](https://www.ibm.com/docs/en/configurepricequote/10.0?topic=site-message-queues-in-sterling-order-management-software). Your deployment options vary per solution.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Maintaining access and visibility into the maintenance lifecycle of your assets can be one of your organization's greatest opportunities to operate efficiently and maintain uptime. To help improve the security posture of your environment, it's important to use secure authentication and to keep your solutions up to date. Use encryption to help protect all data that moves in and out of your architecture.

Azure delivers Sterling OMS by using the models of IaaS and platform as a service (PaaS). Microsoft builds security protections into the service at the following levels:

- Physical datacenter
- Physical network
- Physical host
- Hypervisor

Carefully evaluate the services and technologies that you select for the areas above the hypervisor, such as the latest patched version of Azure Red Hat OpenShift for a major release. Be sure to provide the proper security controls for your architecture. You're responsible for patching and maintaining the security of the IaaS systems. Microsoft takes that role for the PaaS services like Azure Red Hat OpenShift. Even though you can initiate an upgrade for Azure Red Hat OpenShift, it's fully managed by Microsoft and Red Hat. For more information about patching and upgrading Azure Red Hat OpenShift, see [Upgrade an Azure Red Hat OpenShift cluster](/azure/openshift/howto-upgrade).

Use [network security groups](/azure/virtual-network/security-overview) to filter network traffic to and from resources in your [virtual network](/azure/virtual-network/virtual-networks-overview). With these groups, you can define rules that grant or deny access to your Sterling OMS services. Examples include:

- Blocking access to all other parts of your deployed infrastructure, such as specific ports and services that your message broker or back-end database uses.
- Controlling which locations have access to Sterling OMS and the OpenShift cluster.

The port numbers and ranges that you need to open depend on many factors. Some to consider are:

- Port 443, for service-to-service communication.
- Database-specific ports such as port 5432 for the flexible server option of Azure Database for PostgreSQL.
- Message queue ports such as port 1414 for IBM MQ.

Also consider these points:

- Azure Red Hat OpenShift cluster nodes must have outbound internet access. If you can't provide this access, these nodes need, at a minimum, access to the Azure Resource Manager and service logging endpoints.
- IBM provides guidance for implementing multiple Sterling OMS applications that share common services like a back-end database. Such deployments also have intra-application firewall considerations. For more information, see [Opening firewall ports for intra-app communication](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=deployment-opening-firewall-ports-intra-app-communication).

If you need access to your other, non–Azure Red Hat OpenShift nodes, you can optionally use [Azure Bastion](/azure/bastion/bastion-overview) to access your VMs. For security reasons, don't expose VMs to a network or the internet without configuring [network security groups](/azure/virtual-network/network-security-groups-overview) to control access to them.

[Server-side encryption (SSE) of Azure disk storage](/azure/virtual-machines/disk-encryption) helps protect your data. SSE also helps you meet organizational security and compliance commitments. With Azure managed disks, SSE encrypts the data at rest when persisting it to the cloud. This behavior applies by default to both OS and data disks. OpenShift uses SSE by default. Azure Red Hat OpenShift also supports customer-managed encryption keys (CMEK) for the OS disks in your cluster.

#### Authentication

You should configure OAuth for Azure Red Hat OpenShift. For more information, see [Overview of authentication and authorization](/azure/openshift/configure-azure-ad-ui) in the Azure Red Hat OpenShift documentation.

#### Protect your infrastructure

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship](/azure/active-directory/active-directory-how-subscriptions-associated-directory) with an Azure Active Directory (Azure AD) tenant. Use [Azure role-based access control](/azure/role-based-access-control/overview) to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope. The scope can be a subscription, a resource group, or a single resource. Be sure to audit all changes to infrastructure. For more information about auditing, see [Azure Monitor activity log](/azure/azure-resource-manager/resource-group-audit).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

A standard deployment of Sterling OMS consists of the following components. You can adjust many of these compute-based resources to meet your needs. For instance, you can scale up your IBM MQ agent nodes to allow greater throughput.

#### Azure Red Hat OpenShift (for OMS)

- Three control VMs (Standard_D8s_v5)
- Three worker VMs (Standard_D8s_v5)

#### Additional resources

- One virtual network (/16), with the following subnets considered:
  - Azure Red Hat OpenShift control node subnet (/24)
  - Azure Red Hat OpenShift worker node subnet (/24)
  - Data subnet, if needed (/27)
  - Additional VM subnet, if needed (/27)
  - Management subnet, if needed (/30)
- One instance of Azure Database for PostgreSQL with the flexible server option
- One instance of Azure Container Registry
- Two Azure Storage accounts
- Three DNS zones
- Two load balancers
- One jump box VM
- Azure Bastion

Individual deployments can differ, for instance, if you run Db2 on Azure VMs, or if you deploy IBM MQ into your Azure Red Hat OpenShift environment. To review an example estimate, use the [cost calculator](https://azure.com/e/fae03e2386cf46149273a379966e95b1). Configurations vary, so verify your configuration with your IBM sizing team before you finalize your deployment.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Azure Red Hat OpenShift has built-in capabilities for self-healing, scaling, and resilience to ensure that Azure Red Hat OpenShift and Sterling OMS work successfully. Azure Red Hat OpenShift and Sterling OMS have been designed for parts that fail and recover. A key requirement for self-healing is that there are enough worker nodes. To recover from a zone failure within an Azure region, your control and worker nodes must be balanced across availability zones.

Sterling OMS and Azure Red Hat OpenShift use database storage to persist state outside the Kubernetes cluster. Logs and other application resources are persisted to a storage account. To ensure that the storage dependencies continue to work during a failure, use [zone-redundant storage](/azure/virtual-machines/disks-deploy-zrs) whenever possible. This type of storage remains available when a zone fails. Your database deployment should also take multi-zone configurations into account.

Because human error is common, deploy Sterling OMS by using as much automation as possible. For some sample scripts for setting up full, end-to-end automation, see [QuickStart Guide: Sterling Order Management on Azure](https://github.com/Azure/sterling) on GitHub.

## Deploy this scenario

Before you start, review the requirements for Sterling OMS in [System Requirements](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=installing-system-requirements). Also ensure that you have the following resources available:

- Access to an Azure subscription with *Reader* permission.
- An application registration or service principal name that has *Contributor* and *User Access Administrator* permissions to the subscription.
- A domain or delegated subdomain to an Azure DNS zone.
- An IBM Sterling OMS entitlement key.
- IBM-recommended cluster sizing.
- An existing virtual network or a new virtual network, depending on your requirements. For an example of creating a new virtual network with two empty subnets, see [Tutorial: Create an Azure Red Hat OpenShift 4 cluster](/azure/openshift/tutorial-create-cluster#create-a-virtual-network-containing-two-empty-subnets).
- High availability and disaster recovery requirements for your specific deployment.
- An OMEnviroment configuration file, *omenvironment.yaml*, to use when you deploy Sterling OMS via the OpenShift Operator Catalog.

For a step-by-step guide for installing Azure Red Hat OpenShift and Sterling OMS on Azure, including how to address the prerequisites, see [QuickStart Guide: Sterling Order Management on Azure](https://github.com/Azure/sterling).

### Deployment considerations

The current best practice is to deploy workloads by using infrastructure as code (IaC) rather than manually deploying workloads, because manual deployment can result in misconfiguration. Container-based workloads can be sensitive to misconfiguration, which can reduce productivity.

Before you build your environment, review [QuickStart Guide: Sterling Order Management on Azure](https://github.com/azure/sterling#getting-started) to develop an understanding of the design parameters. The quickstart guide isn't intended for a production-ready deployment, but you can use the guide's assets to get to a production-grade mechanism for deployment.

IBM offers specialized services to help you with installation. Contact your IBM team for support.

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [David Baumgarten](https://www.linkedin.com/in/baumgarten-david) | Principal Cloud Solution Architect
- [Drew Furgiuele](https://www.linkedin.com/in/pittfurg) | Senior Cloud Solution Architect
- [Roeland Nieuwenhuis](https://www.linkedin.com/in/roelandnieuwenhuis) | Principal Cloud Solution Architect

Other contributors:

- [Aneesh AR](https://www.linkedin.com/in/aneesh-ar-tech) | Senior Cloud Services Black Belt
- [Vijaya Bashyam](https://www.linkedin.com/in/vijaya-bashyam-76a6837) | Senior Technical Staff Member
- [James Read](https://www.linkedin.com/in/jwread) | EMEA Principal Solution Architect
- [Andy Repton](https://www.linkedin.com/in/andy-repton) | Managed OpenShift Black Belt

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Prerequisites to deploying certified containers using Sterling Order Management Software Operator](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=dccusomso-prerequisites-deploying-certified-containers-using-sterling-order-management-software-operator)
- [Sterling Order Management - Best Practices Guide](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=operator-best-practices)
- [IBM Passport Advantage](https://www.ibm.com/software/passportadvantage/pao_customer.html)
- [Quickstart: Deploy an Azure Red Hat OpenShift cluster](/azure/openshift/quickstart-portal)
- [Quickstart: Create an Azure Database for PostgreSQL - Flexible Server](/azure/postgresql/flexible-server/quickstart-create-server-portal)
- [Secure access to Azure Red Hat OpenShift with Azure Front Door](/azure/openshift/howto-secure-openshift-with-front-door)
- [Use Azure Key Vault Provider for Secrets Store CSI Driver on Azure Red Hat OpenShift](/azure/openshift/howto-use-key-vault-secrets)
- [IBM MQ in Containers](https://www.ibm.com/docs/en/ibm-mq/9.1?topic=mq-in-containers)
- [Azure Red Hat OpenShift](/azure/openshift/intro-openshift)
- [What is Azure Database for PostgreSQL?](/azure/postgresql/single-server/overview)
- [Introduction to Red Hat on Azure](/training/modules/introduction-to-red-hat-azure)
- [Work with Azure Database for PostgreSQL](/training/paths/microsoft-learn-azure-database-for-postgresql)

## Related resources

- [Deploy IBM Maximo Application Suite on Azure](../../example-scenario/apps/deploy-ibm-maximo-application-suite.yml)
- [JBoss deployment with Red Hat on Azure](../../solution-ideas/articles/jboss-deployment-red-hat.yml)
- [Scalable order processing](../../example-scenario/data/ecommerce-order-processing.yml)
- [Run Oracle databases on Azure](../../solution-ideas/articles/reference-architecture-for-oracle-database-on-azure.yml)
