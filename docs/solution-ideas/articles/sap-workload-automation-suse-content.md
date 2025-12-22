[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture demonstrates how to use the SUSE SAP automation solution on Azure.

SUSE and Microsoft have long term partnership in providing Azure-optimized solutions for SUSE Linux Enterprise Server (SLES). SLES for SAP Applications is the leading platform for SAP solutions on Linux, with over 90 percent of SAP HANA deployments and 70 percent of SAP NetWeaver applications running on SUSE.

Automating SAP workloads in the cloud leads to better business outcomes by bolstering productivity and facilitating innovation. The task of building and manually deploying SAP infrastructures in the cloud involves a range of technical processes that can be inefficient and time-consuming. These processes also require configuration management and entail many steps. With each step, the level of complexity and the amount of specialized knowledge that's required increases if extra high availability (HA) is needed. Most SAP systems are important and require HA. The manual implementation of each step generates many opportunities for error that can render the entire infrastructure defective and delay success. Automation helps organizations streamline deployment of SAP infrastructure and accelerate customer cloud migration on Azure. Successful cloud migration allows customers to quickly and easily benefit from the power and flexibility of the cloud.

The SUSE SAP solution excels at simplifying and modernizing SAP HANA and SAP NetWeaver deployments. You can configure it to set up and monitor both environments.

## Potential use cases

SLES4SAP is a bundle of software and services that addresses specific needs of SAP users, and delivers services faster, more efficiently, and with less risk. You can deploy SAP HANA and SAP NetWeaver applications in many different scenarios and combinations. The SUSE SAP solution features modular and reusable building blocks to support use cases ranging from single install to full cluster deployment.

SUSE provides support with:

- HANA single node
- HANA HA Scale-up System replication, including performance-optimized (active/passive and active/readonly) and cost-optimized scenarios
- NetWeaver
- NetWeaver HA with Enqueue Replication Version (ENSA1)
- S/4 HANA

:::image type="content" source="../media/sap-workload-automation-suse-sles4sap-benefits.png" alt-text="Data flow of workload automation using SUSE on Azure" :::

## Architecture

:::image type="content" source="../media/sap-workload-automation-suse.svg" alt-text="Architecture for SAP workload automation." lightbox="../media/sap-workload-automation-suse.svg":::

### Dataflow

:::image type="content" source="../media/sap-workload-automation-suse-flow.svg" alt-text="Data flow of workload automation using SUSE on Azure." :::

*Download a [Visio file](https://arch-center.azureedge.net/sap-workload-automation-suse.vsdx) of diagrams in this article.*

1. Download the SUSE automation git repository to your local machine or Azure Cloud Shell and install the needed Terraform version, which comes with SLES4SAP or Cloud Shell.
1. Create an Azure File Share instance and download SAP media to it.
1. Tailor the example parameters (such as ssh-keys, network, SID, and file-share) to your needs and values.
1. Run Terraform to deploy the SAP infrastructure into Azure.
   1. Terraform creates the infrastructure, including resource groups, networks, virtual machines, disks, availability groups, and load balancers.
   1. Terraform starts configuration with Salt.
1. Salt performs the needed OS configuration:
   1. It installs SAP applications on the nodes.
   1. It installs and configures clusters if HA.
   1. It installs and configures the monitoring parts such as Prometheus, Grafana and exporters.

### Components

- [Azure Storage](/azure/storage/common/storage-introduction) is a set of scalable and secure cloud services for storing data, apps, and workloads. In this architecture, Azure Storage, specifically [Azure Files](/azure/well-architected/service-guides/azure-files), hosts SAP media and supports file sharing across cloud and on-premises environments by using Server Message Block (SMB) and Network File System (NFS) protocols. Azure Files also enables the migration and deployment of SAP workloads by providing shared access to SAP installation media and configuration files.
- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a layer-4 load balancing service for Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) traffic. In this architecture, Load Balancer distributes traffic across Azure Spring Apps and Azure Kubernetes Service (AKS) components to ensure high availability and scalability.
- [Linux virtual machines in Azure](/azure/well-architected/service-guides/virtual-machines) are on-demand, scalable Linux computing resources that provide the flexibility of virtualization but eliminate the maintenance demands of physical hardware. In this architecture, Linux virtual machines host SAP HANA and SAP NetWeaver applications.
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service in Azure that enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, Virtual Network connects virtual machines, load balancers, and other resources, which enables secure communication between SAP components and integration with on-premises networks.

### Solution templates

Explore SUSE SAP deployment template to create SAP infrastructure on Azure:

- [Infrastructure for SAP NetWeaver and SAP HANA](https://azuremarketplace.microsoft.com/marketplace/apps/suse.sles-sap-15-sp6-byos?tab=Overview) (Azure Marketplace)
- [SUSE and Microsoft Solution Templates for SAP Applications](https://documentation.suse.com/sbp/all/single-html/SBP-SAP-AzureSolutionTemplates) (SUSE)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Michael Yen-Chi Ho](https://www.linkedin.com/in/yenchiho/) | Senior Product Manager

## Next steps

### SAP

- [SAP on Azure](https://azure.microsoft.com/solutions/sap/)
- [SAP workloads on Azure: planning and deployment checklist](/azure/virtual-machines/workloads/sap/sap-deployment-checklist?toc=/azure/architecture/toc.json&bc=/azure/architecture/bread/toc.json)
- [Automated SAP/HA Deployments in Public/Private Clouds with Terraform](https://github.com/SUSE/ha-sap-terraform-deployments) (GitHub project)


### SUSE

- [SUSE on Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps?search=SUSE)
- [Highly Available NFS Storage with DRBD and Pacemaker](https://documentation.suse.com/sle-ha/15-SP6/)
- [Run SAP](https://www.suse.com/solutions/run-sap-solutions)


