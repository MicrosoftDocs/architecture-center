This example architecture shows how organizations can migrate IBM i workloads to Skytap on Azure by using native IBM i backup and recovery capabilities together with Azure services. Skytap on Azure provides IBM Power infrastructure within Azure, enabling organizations to move IBM i workloads to the cloud without refactoring or rewriting their applications. The architecture combines IBM i logical partitions (LPARs), private connectivity, and Azure Storage to support migration, backup, and recovery scenarios.

## Architecture

:::image type="content" source="media/migrate-ibm-i-series-to-azure-with-skytap.svg" alt-text="Diagram that shows the infographic of Microsoft Azure components used to migrate IBM i workloads to Skytap on Azure." lightbox="media/migrate-ibm-i-series-to-azure-with-skytap.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/migrate-ibm-i-series-to-azure-with-skytap.vsdx) of this architecture.*

### Workflow

The numbers in the diagram correspond to the following workflow:

1.  Users access an application hosted in Azure that provides an interface to services running on IBM i systems in Skytap on Azure. Azure ExpressRoute can provide private connectivity between the on-premises environment and Azure.
   
1.  Before migration, use native IBM i backup capabilities, such as GoSave or Backup, Recovery, and Media Services (BRMS), to create a backup of the source IBM i system. An FTP proxy and Azure Data Box Gateway are deployed on-premises near the existing IBM i infrastructure to support the transfer of the backup data.
   
1.  Data Box Gateway transfers the IBM i backup data to an Azure Blob Storage account. Azure Private Link provides private access to the storage account without exposing the storage traffic to the public internet.

1.  An FTP proxy and Data Box Gateway are deployed in the Skytap on Azure environment on the same network as the target IBM i systems.

1.  Restore the IBM i workload to the target LPAR in Skytap on Azure by using the appropriate IBM i restore method. Depending on the backup strategy, this process can use option 21 to restore system and user data, option 23 to restore user data, or BRMS-based recovery.
   
### Components

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) provides scalable compute resources in Azure. In this architecture, an Azure VM hosts the web application that provides users with access to services associated with the IBM i workloads running in Skytap on Azure.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) provides private network connectivity for Azure resources in this architecture. It enables the Azure-hosted application and related Azure services to communicate securely with resources associated with the Skytap on Azure environment.

  For more information about how Skytap on [Azure connectivity](https://www.skytap.com/blog/skytap-on-azure-networking-considerations/) works, see [Skytap well-architected framework](https://skytap.github.io/well-architected-framework/).

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) provides private connectivity between an organization's on-premises network and Microsoft cloud services. In this architecture, ExpressRoute can provide private connectivity between the on-premises environment, Azure resources, and workloads associated with the Skytap on Azure solution.

  For more information about how ExpressRoute works with Skytap, see [Skytap getting started with Azure networking guide](https://www.skytap.com/blog/skytap-on-azure-networking-considerations/).

- [Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview) provides a virtual data-transfer capability for moving data between an on-premises environment and Azure Storage. In this architecture, it facilitates the transfer of IBM i backup data to Azure Storage for subsequent restoration to IBM i LPARs running in Skytap on Azure.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage solution designed for storing unstructured data, such as text and binary data. In this architecture, Blob Storage serves as the destination for IBM i backup files transferred from Data Box Gateway during the migration process.

- [Private Link](/azure/private-link/private-link-overview) is a networking service that creates your own private link service in your virtual network so that the web client can consume resources from Skytap on Azure. In this architecture, Private Link enables secure data transfer from IBM i systems to Blob Storage through a private endpoint.

- [Kyndryl Cloud Uplift (formerly Skytap on Azure)](https://marketplace.microsoft.com/search/products?search=Kyndryl%20Cloud%20Uplift) is a service that runs IBM Power and x86 traditional workloads on hardware in Azure datacenters. Organizations of any size that run applications on IBM Power-based AIX, IBM i, or Linux operating systems can migrate them to Azure with little upfront effort. In this architecture, Skytap on Azure provides the native IBM Power9 infrastructure to host migrated IBM i LPARs without requiring application refactoring.

### Alternatives

-   You can connect to IBM i instances running in Skytap on Azure across a virtual private network (VPN) or the internet. For example, you can use SSH (Secure Shell) to access your IBM i applications on Azure.

-   To maximize security and minimize the number of open ports, you can use VMs as bastion hosts for administrative access to the LPARs. The bastion host runs within the VNet on Azure. For example, administrators can use a 5250 terminal emulator to access their IBM i systems.

-   You can use BRMS to back up your system before migration, and then use BRMS restore for incremental backups.

-   In a high availability scenario, you can replicate journal data over your organization's ExpressRoute or VPN connection in near real-time. In case of a failure, you can perform a role swap for a near immediate failover.

## Scenario details

The IBM System i family of midrange computers was first introduced in 1988 as the AS/400. Until now, your choice was to rearchitect iSeries applications before you move them to the cloud or maintain them on-premises or in a co-located facility—both expensive options.

In this example, a web app on Azure gives users a modern interface for the resources running in Skytap on Azure. You can continue to run critical components or systems of record (SOR) on IBM i on-premises. You can also migrate complete IBM i workloads and modernize them using native Azure services, such as advanced analytics and machine learning. In this type of all-cloud scenario, Skytap on Azure helps you optimize costs.

### Potential use cases

-   Enable easy, self-service lift-and-shift of on-premises workloads running IBM i to Azure.

-   Modernize applications using native Azure services in a hybrid configuration that connects to earlier systems and data running on IBM i.

-   Improve business continuity with cost-effective Azure solutions for backup and disaster recovery.

-   Add scale by rapidly deploying IBM i instances on demand.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Skytap on Azure has high reliability built on IBM Power9 Systems backed by SSD RAID 6+1 storage and 10 Gb/sec backplane networking.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Skytap on Azure meets industry cloud security requirements, including System and Organization Controls for Service Organizations 2 (SOC 2) and SOC 3 attestations and compliance with ISO 27001 and PCI DSS 3.2.
To learn more about how Skytap secures your workloads, you can get more information in the [Skytap Well-Architected Framework Security Pillar](https://skytap.github.io/well-architected-framework/security/).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Running IBM i series workloads in Skytap on Azure helps optimize costs compared to on-premises deployments. The consumption-based usage plans let you deploy LPARs only as needed and scale them on demand to meet the needs of your workloads.

See more pricing information on the [Plans + Pricing](https://marketplace.microsoft.com/search/products?search=Kyndryl%20Cloud%20Uplift) tab in the Microsoft Marketplace.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Skytap on Azure provides high performance and efficiency that support demanding workloads up to 44,000 CPWs and 512 GB of RAM, while providing the benefits of cloud scale. With capacity on demand and pay-as-you-go pricing, you save the expense of adding hardware on premises to meet changing demands. You can use smaller LPARs instead of a few large ones and configure resources as needed.

One of the advantages of an Azure–based solution is the ability to scale out. Scaling makes nearly limitless compute capacity available to an application. Azure supports multiple methods to scale out compute power, such as [virtual machine scale sets](/azure/virtual-machine-scale-sets/overview) and
[load balancing](/azure/load-balancer/load-balancer-overview) across a cluster. Other services scale compute resources dynamically. In addition, applications on Azure can also use [Kubernetes clusters](/azure/aks/core-aks-concepts) as compute services for specified resources.

Azure compute scale-up can be as simple as choosing the right [virtual machine](https://azure.microsoft.com/services/virtual-machines/) for your workload.

## Deploy this scenario

To get started running iSeries applications on Azure, check out the [Kyndryl Cloud Uplift (formerly Skytap on Azure)](https://marketplace.microsoft.com/search/products?search=Kyndryl%20Cloud%20Uplift) template in the Microsoft Marketplace.

Learn more about the different Migration and Deployment options with the [Skytap Well-Architected Framework](https://skytap.github.io/well-architected-framework/).

## Next steps

- See the [Cloud Migration for Apps Running IBM Power](https://techcommunity.microsoft.com/t5/video-hub/skytap-on-azure-cloud-migration-for-apps-running-ibm-power/m-p/1693588) demo.

- Learn how to [accelerate your cloud strategy with Skytap on Azure](https://azure.microsoft.com/blog/accelerate-your-cloud-strategy-with-skytap-on-azure).


- [Skytap Well-Architected Framework](https://skytap.github.io/well-architected-framework)

- [Skytap documentation](https://help.skytap.com)

## Related resources

- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
- [Modernize mainframe & midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
