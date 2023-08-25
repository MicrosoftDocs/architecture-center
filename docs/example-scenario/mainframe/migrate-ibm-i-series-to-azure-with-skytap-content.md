This example architecture shows how to use the native IBM i backup and recovery services with Microsoft Azure components to quickly migrate IBM i workloads to Skytap on Azure. This native IBM Power9 infrastructure is hosted in an Azure datacenter, minimizing the latency between traditional workloads and those running natively on Azure. You get the reliability and reach of Azure, the flexibility to deploy and scale IBM i logical partitions (LPARs) on demand, plus full backup and recovery services through Azure Storage.

## Architecture

:::image type="content" source="media/migrate-ibm-i-series-to-azure-with-skytap.svg" alt-text="Diagram that shows the infographic of Microsoft Azure components used to migrate IBM i workloads to Skytap on Azure." lightbox="media/migrate-ibm-i-series-to-azure-with-skytap.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/migrate-ibm-i-series-to-azure-with-skytap.vsdx) of this architecture.*

### Workflow

The numbers in the diagram correspond to the following data flow.

1.  A user on-premises uses a web browser to connect to Azure through a private Azure ExpressRoute connection. This web-based app provides a modern interface for the services that run on the IBM i instances running in Skytap on Azure.

1.  An FTP proxy and Azure Data Box Gateway are deployed on-premises next to the datacenter's existing IBM i infrastructure. Before migration, either GoSave or Backup, Recovery, and Media Services (BRMS) are used to back up the IBM i systems.

1.  Data Box Gateway sends the data from the IBM i system through an Azure Private Link endpoint to an Azure Blob Storage account.

1.  An FTP proxy and Data Box Gateway are deployed in the Skytap on Azure environment in the same network as the IBM i systems.

1.  The IBM i systems are restored on Skytap on Azure using option 21 (restore system and user data), option 23 (restore user data), or BRMS if used for the original backup.

### Components

The architecture uses these components:

-   [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1?tab=overview) is a service that runs IBM Power and x86 traditional workloads on hardware in Azure datacenters. Organizations of any size that run applications on IBM Power–based AIX, IBM i, or Linux operating systems can migrate them to Azure with little upfront effort.

-   [Azure Virtual Machine](https://azure.microsoft.com/services/virtual-machines/) instances provide on-demand, scalable computing power. A virtual machine (VM) gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it.

-   [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for your private network in Azure. As a software defined network, a virtual network (VNet) provides an isolated environment for VMs and other Azure resources to communicate with each other, the internet, and on-premises networks.
Learn more information on how Skytap on [Azure connectivity](https://www.skytap.com/skytap-on-azure-networking-considerations/) works in the [Skytap Well-Architected Framework](https://skytap.github.io/well-architected-framework/).

-   [Azure Private Link](/azure/private-link/private-link-overview) creates your own private link service in your virtual network so the web client can consume resources from Skytap on Azure.

-   [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) is an object storage solution designed for storing massive amounts of unstructured data, such as text and binary data.

-   [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) extends your on-premises networks to Microsoft cloud services, including Azure and Office 365, over a private connection facilitated by a connectivity provider.
-  [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) extends your on-premises networks to Microsoft cloud services, including Azure and Office 365, over a private connection facilitated by a connectivity provider.
Learn more information on how Azure ExpressRoute works with Skytap in the [Skytap Getting Started with Azure Networking guide](https://www.skytap.com/skytap-on-azure-networking-considerations/).

-   [Azure Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview) is a virtual device that you install on-premises. You write data to it using the Network File System (NFS) and Server Message Block (SMB) protocols, and Data Box Gateway sends the data to Azure.

### Alternatives

-   You can connect to IBM i instances running in Skytap on Azure across a virtual private network (VPN) or the internet. For example, you can use SSH (Secure Shell) to access your IBM i applications on Azure.

-   To maximize security and minimize the number of open ports, you can use VMs as bastion hosts for administrative access to the LPARs. The bastion host runs within the VNet on Azure. For example, administrators can use a 5250 terminal emulator to access their IBM i systems.

-   You can use BRMS to back up your system before migration, and then use BRMS restore for incremental backups.

-   In a high availability scenario, you can replicate journal data over your organization's ExpressRoute or VPN connection in near real-time. In case of a failure, you can perform a role swap for a near immediate failover.

## Scenario details

The IBM System i family of midrange computers was first introduced in 1988 as the AS/400. Until now, your choice was to rearchitect iSeries applications before moving them to the cloud or maintain them on-premises or in a co-located facility—both expensive options.

In this example, a web app on Azure gives users a modern interface for the resources running in Skytap on Azure. You can continue to run critical components or systems of record (SOR) on IBM i on-premises. You can also migrate complete IBM i workloads and modernize them using native Azure services, such as advanced analytics and machine learning. In this type of all-cloud scenario, Skytap on Azure helps you optimize costs.

### Potential use cases

-   Enable easy, self-service lift-and-shift of on-premises workloads running IBM i to Azure.

-   Modernize applications using native Azure services in a hybrid configuration that connects to earlier systems and data running on IBM i.

-   Improve business continuity with cost-effective Azure solutions for backup and disaster recovery.

-   Add scale by rapidly deploying IBM i instances on demand.

## Considerations

### Availability

Skytap on Azure has high reliability built on IBM Power9 Systems backed by SSD RAID 6+1 storage and 10 Gb/sec backplane networking.

### Performance

Skytap on Azure provides high performance and efficiency that support demanding workloads up to 44,000 CPWs and 512 GB of RAM, while providing the benefits of cloud scale. With capacity on demand and pay-as-you-go pricing, you save the expense of adding hardware on premises to meet changing demands. You can use smaller LPARs instead of a few large ones and configure resources as needed.

### Scalability

One of the advantages of an Azure–based solution is the ability to scale out. Scaling makes nearly limitless compute capacity available to an application. Azure supports multiple methods to scale out compute power, such as [virtual machine scale sets](/azure/virtual-machine-scale-sets/overview) and
[load balancing](/azure/load-balancer/load-balancer-overview) across a cluster. Other services scale compute resources dynamically. In addition, applications on Azure can also use [Kubernetes clusters](/azure/aks/concepts-clusters-workloads) as compute services for specified resources.

Azure compute scale-up can be as simple as choosing the right [virtual machine](https://azure.microsoft.com/services/virtual-machines/) for your workload.

### Security

Skytap on Azure meets industry cloud security requirements, including System and Organization Controls for Service Organizations 2 (SOC 2) and SOC 3 attestations and compliance with ISO 27001 and PCI DSS 3.2.
To learn more about how Skytap secures your workloads, you can get more information in the [Skytap Well-Architected Framework Security Pillar](https://skytap.github.io/well-architected-framework/security/). 

### Cost optimization

Running IBM i series workloads in Skytap on Azure helps optimize costs compared to on-premises deployments. The consumption-based usage plans let you deploy LPARs only as needed and scale them on demand to meet the needs of your workloads.

See more pricing information on the [Plans + Pricing](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1?tab=PlansAndPrice) tab of Skytap on Azure in Azure Marketplace.

## Deploy this scenario

To get started running iSeries applications on Azure, check out the [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1?tab=overview) template in Azure Marketplace.
Learn more about the different Migration and Deployment options with the [Skytap Well-Architected Framework](https://skytap.github.io/well-architected-framework/).

## Next steps

To learn more about Skytap on Azure, contact <legacy2azure@microsoft.com> or check out the following resources:

-   See the [Cloud Migration for Apps Running IBM Power](https://techcommunity.microsoft.com/t5/video-hub/skytap-on-azure-cloud-migration-for-apps-running-ibm-power/m-p/1693588) demo.

-   Learn how to [accelerate your cloud strategy with Skytap on Azure](https://azure.microsoft.com/blog/accelerate-your-cloud-strategy-with-skytap-on-azure).

-   Explore the [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1?tab=overview) template on Azure Marketplace.

-   Learn about [Skytap Migration options](https://skytap.github.io/well-architected-framework/resiliency).

- [Skytap Well-Architected Framework](https://skytap.github.io/well-architected-framework)

- [Skytap documentation](https://help.skytap.com)

## Related resources

- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
- [Modernize mainframe & midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)