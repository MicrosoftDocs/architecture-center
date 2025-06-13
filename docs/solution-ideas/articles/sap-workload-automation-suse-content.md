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
1. Tailor the example parameters—ssh-keys, network, SID, file-share, and so on—to your needs and values.
1. Run Terraform to deploy the SAP infrastructure into Azure.
   1. Terraform creates the infrastructure, including resource groups, networks, virtual machines, disks, availability groups, load balancers, and so on.
   1. Terraform starts configuration with Salt.
1. Salt performs the needed OS configuration:
   1. It installs SAP applications on the nodes.
   1. It installs and configures clusters if HA.
   1. It installs and configures the monitoring parts such as Prometheus, Grafana and exporters.

### Components

- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure Files](/azure/well-architected/service-guides/azure-files) offers simple, secure, and serverless enterprise-grade file shares in the cloud. The shares support access by the industry-standard Server Message Block (SMB) and Network File System (NFS) protocols. They can be mounted concurrently by cloud and on-premises deployments of Windows, Linux, and macOS.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) is a layer 4 (TCP, UDP) load balancer. In this architecture, it provides load balancing options for Spring Apps and AKS.
- [Linux virtual machines in Azure](/azure/well-architected/service-guides/virtual-machines) are on-demand, scalable Linux computing resources that give you the flexibility of virtualization but eliminate the maintenance demands of physical hardware.
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to on-premises networks.

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


