Skytap on Azure simplifies cloud migration for applications that run on IBM Power Systems. This example illustrates a migration of AIX logical partitions (LPARs) to Skytap on Azure and is based on best practices from recent customer experiences. A web app on Microsoft Azure gives users a modern interface for the resources running in LPARs on Skytap on Azure.

## Architecture

:::image type="content" border="false" source="media/migrate-aix-workloads-to-azure-with-skytap.svg" alt-text="Diagram of a self-service lift-and-shift of AIX workloads to Skytap on Azure." lightbox="media/migrate-aix-workloads-to-azure-with-skytap.svg" :::

*Download a [Visio file](https://arch-center.azureedge.net/migrate-aix-workloads-to-azure-with-skytap.vsdx) of this architecture.*
 
### Workflow

The numbers in the diagram correspond to the following data flow.

1.  A user on-premises uses a web browser to connect to Azure through [Azure ExpressRoute](/azure/expressroute/expressroute-introduction), which creates a private connection. This web-based app provides a modern interface for the services that run on the AIX LPARs in Skytap on Azure.

1.  Azure Data Box Gateway is deployed on-premises next to the datacenter's existing AIX infrastructure, which includes an AIX Network Installation Management (NIM) server. Data Box Gateway loads the data and completes the system restoration on Azure. AIX backups run using the operating system's native **mksyb** and **savevg** commands.

1.  Files that are backed up to Data Box Gateway are migrated to the organization's Azure Blob Storage account through Azure Private Link, an endpoint for privately accessing Azure services.

1.  In the Skytap on Azure environment, the NIM server running Unix is used to restore the base AIX operating system to the LPARs in Skytap on Azure.

1.  The AIX LPAR is rebooted. Any data volume groups are restored through the Data Box Gateway via the Network File System (NFS) protocol. This process is repeated for each LPAR to be restored.

### Components

The architecture uses these components:

-   [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1?tab=overview) is a service that runs IBM Power and x86 traditional workloads on hardware in Azure datacenters. Organizations that run applications on IBM Power–based AIX or Linux operating systems can migrate them to Azure with little upfront effort.

-   [Azure Virtual Machine](https://azure.microsoft.com/services/virtual-machines/) instances provide on-demand, scalable computing power. A virtual machine (VM) gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it.

-   [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for your private network in Azure. 
As a software defined network, a virtual network (VNet) provides an isolated environment for VMs and other Azure resources to communicate with each other, the internet, and on-premises networks. 
Learn more information on how Skytap on [Azure connectivity](https://www.skytap.com/skytap-on-azure-networking-considerations/) works in the [Skytap Well-Architected Framework](https://skytap.github.io/well-architected-framework/).

-   [Azure Private Link](/azure/private-link/private-link-overview) creates your own private link service in your virtual network so the web client can consume resources from Skytap on Azure.

-   [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) is an object storage solution designed for storing massive amounts of unstructured data, such as text and binary data.

-  [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) extends your on-premises networks to Microsoft cloud services, including Azure and Office 365, over a private connection facilitated by a connectivity provider.
Learn more information on how Azure ExpressRoute works with Skytap in the [Skytap Getting Started with Azure Networking guide](https://www.skytap.com/skytap-on-azure-networking-considerations/).

-   [Azure Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview) is a virtual device that you install on-premises. You write data to it using the NFS and Server Message Block (SMB) protocols, and Data Box Gateway sends the data to Azure.

### Alternatives

-   For access to the AIX instances running in Skytap on Azure, you can connect over a virtual private network (VPN) or the internet. For example, you can use SSH (Secure Shell) to access your AIX systems on Azure.

-   To maximize security and minimize the number of open ports, you can use VMs as bastion hosts for administrative access to the LPARs. The bastion host runs within the VNet on Azure.

-   To simplify user access, you can build modern front ends and apps on Azure for the AIX instances running in Skytap on Azure while continuing to run critical components or systems of record (SOR) on AIX.

## Scenario details

Since its introduction in 1986, the AIX operating system has been a top choice for large, mission-critical applications. AIX was designed for virtualization from the ground up using multiple LPARs that run in isolation on a given IBM Power System server. Until now, your choice was to rearchitect applications to move them to the cloud or bear the expense of maintaining them on-premises or in a co-located facility.

Skytap on Azure is dedicated hardware that provides a native IBM Power9 infrastructure with the AIX operating system. Full, cloud-based backup and recovery is provided with Azure Storage. You don't need to refactor or rearchitect applications to run them in Skytap on Azure, and the way you manage existing IBM Power applications on-premises changes very little.

After migration, you can start taking advantage of native Azure services to modernize applications, if desired, or continue to run systems on AIX. Either way, you immediately gain the resilience, flexibility, high availability, and scalability of Azure.

### Potential use cases

-   Start an easy, self-service lift-and-shift of AIX workloads to Skytap on Azure.

-   Improve business continuity with cost-effective Azure solutions for backup and disaster recovery.

-   Add scale by rapidly deploying AIX LPARs on demand.

-   Accelerate DevOps and increase your test coverage using on-demand resources.

-   Create virtual labs using Skytap on Azure templates and environments, so you can easily demo AIX applications to customers and users.

## Considerations

### Availability

Skytap on Azure has high reliability built on IBM Power9 Systems backed by SSD RAID 6+1 storage and 10 Gb/sec backplane networking.

Skytap on Azure is supported by a service-level agreement (SLA) of 99.95 percent availability.

### Performance

Skytap on Azure provides high performance and efficiency that support demanding workloads up to 16 vCPUs and 512 GB of memory, while providing the benefits of cloud scale. With capacity on demand and pay-as-you-go pricing, you save the expense of adding hardware on premises to support higher demands. You can use smaller LPARs instead of a few large ones and configure resources as needed.

Skytap on Azure promotes operational excellence through its native support for AIX on IBM Power9 systems that are hosted within Azure datacenters and managed by Microsoft.

### Scalability

One of the advantages of an Azure–based solution is the ability to scale out. Scaling makes nearly limitless compute capacity available to an application. Azure supports multiple methods to scale out compute power, such as [virtual machine scale sets](/azure/virtual-machine-scale-sets/overview) and
[load balancing](/azure/load-balancer/load-balancer-overview) across a cluster. Other platform as a service (PaaS) options scale compute resources dynamically. In addition, applications on Azure can also use
[Kubernetes clusters](/azure/aks/concepts-clusters-workloads) as compute services for specified resources.

To scale up on Azure, choose a [larger VM size](https://azure.microsoft.com/services/virtual-machines/) for your workload.

### Security

Skytap on Azure meets industry cloud security requirements, including System and Organization Controls for Service Organizations 2 (SOC 2) and SOC 3 attestations and compliance with ISO 27001 and PCI DSS 3.2.
To learn more about how Skytap secures your workloads, you can get more information in the [Skytap Well-Architected Framework Security Pillar](https://skytap.github.io/well-architected-framework/security/).

### Cost optimization

Running your AIX-based workloads in Skytap on Azure helps optimize costs compared to on-premises deployments. The consumption-based usage plans let you deploy AIX LPARs only as needed and scale them on demand to meet the needs of your workloads.

See more pricing information on the [Plans + Pricing](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1?tab=PlansAndPrice) tab of Skytap on Azure in Azure Marketplace.

## Deploy this scenario

To get started running AIX applications on Azure, check out the [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1?tab=overview) template in Azure Marketplace.
Learn more about the different Migration and Deployment options with the [Skytap Well-Architected Framework](https://skytap.github.io/well-architected-framework/).

## Next steps

To learn more about Skytap on Azure, contact <legacy2azure@microsoft.com> or check out the following resources:

-   See the [Cloud Migration for Apps Running IBM Power](https://techcommunity.microsoft.com/t5/video-hub/skytap-on-azure-cloud-migration-for-apps-running-ibm-power/m-p/1693588) demo.

-   Learn how to [accelerate your cloud strategy with Skytap on Azure](https://azure.microsoft.com/blog/accelerate-your-cloud-strategy-with-skytap-on-azure/).

-   Explore the [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1?tab=overview) template on Azure Marketplace.

-   Learn about [Skytap Migration options](https://skytap.github.io/well-architected-framework/resiliency).

- [Skytap Well-Architected Framework](https://skytap.github.io/well-architected-framework)

- [Skytap documentation](https://help.skytap.com/)

## Related resources

- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
- [Modernize mainframe & midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)