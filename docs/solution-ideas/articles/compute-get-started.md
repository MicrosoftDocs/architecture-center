---
title: Get Started with Compute Architecture Design
description: Learn about Azure compute technologies, from virtual machines to serverless functions. Review guidance, solution ideas, and reference architectures.
author: anaharris-ms
ms.author: anaharris
ms.date: 03/10/2026
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
ms.custom: arb-compute
---

# Get started with compute architecture design

Compute resources form the foundation of cloud workloads. Azure provides a wide range of compute options to meet diverse requirements, from virtual machines (VMs) that give you full control of the operating system to fully managed serverless functions that scale automatically. Azure compute services support workload migration, cloud-native application development, and high-performance computing (HPC) simulations. They also provide flexibility and scaling capabilities to improve workload performance.

Understanding your workload requirements is essential for choosing the right compute option. Consider the level of control that you need, how your application scales, your latency needs, and your cost optimization goals. The compute portfolio on Azure spans infrastructure as a service (IaaS), platform as a service (PaaS), and serverless models, so you can choose the approach that suits your architecture.

## Architecture

:::image type="complex" border="false" source="../media/compute-get-started-diagram.svg" alt-text="Diagram that shows the compute solution journey on Azure." lightbox="../media/compute-get-started-diagram.svg":::
   The diagram shows an Azure subscription at the top that includes a virtual network. On the left side, a workload client connects through the network ingress control layer, which has three options: Azure Front Door, Azure Application Gateway, or Azure Load Balancer. In the center is an application platform compute box that includes Azure Virtual Machines, Azure Virtual Machine Scale Sets, Azure Batch, Azure Container Apps, Azure Kubernetes Service (AKS), and Azure App Service. The application platform box connects to another box that has application dependencies, like databases and private endpoints. On the right side is a box labeled specialized compute. It includes Oracle on Virtual Machines, SAP on Azure, data science VMs, SQL Server on Virtual Machines, and Azure CycleCloud HPC. Below the specialized compute box, icons represent user-defined routes (UDRs), and network and application security groups. At the bottom left, an icon that represents on-premises connectivity connects via virtual private network (VPN) or Azure ExpressRoute to Azure Bastion and public IP addresses within the virtual network. Along the bottom of the diagram are platform services, including Azure Update Manager, Microsoft Entra managed identities, Azure Monitor, and Azure maintenance configurations. Below the Azure subscription box, a box labeled platform has Microsoft Entra ID, Microsoft Cost Management, Microsoft Defender for Cloud, Azure DevOps and GitHub, and Azure DNS.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/compute-get-started-diagram.vsdx) of this architecture.*

The previous diagram demonstrates a common basic or baseline compute implementation. For real-world solutions that you can build in Azure, see [Compute architectures](#compute-architectures).

## Explore compute architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These articles can help you decide how to use compute technologies in Azure. Solution ideas demonstrate implementation patterns and possibilities to consider when you plan your compute proof-of-concept (POC) development.

### Compute guides

**Technology choices:** The following articles help you evaluate and select the best compute technologies for your workload requirements:

- [Choose a compute service](../../guide/technology-choices/compute-decision-tree.md): Use a decision tree to help you choose the right compute option.
- [Shared access signatures (SAS) on Azure architecture](../../guide/sas/sas-overview.yml): Get guidance about running SAS analytics on Azure.
- [Build workloads by using Azure Spot Virtual Machines](../../guide/spot/spot-eviction.yml): Learn how to design workloads that take advantage of spare Azure capacity at reduced cost.
- [HPC on Azure](../../guide/compute/high-performance-computing.md): Learn about HPC capabilities and architectures on Azure.

### Compute architectures

The following production-ready architectures demonstrate comprehensive compute solutions that you can deploy and customize:

- [Azure Virtual Machines baseline architecture](../../virtual-machines/baseline.yml): See a foundational reference architecture for workloads deployed on Virtual Machines.
- [Virtual Machines baseline architecture in an Azure landing zone](../../virtual-machines/baseline-landing-zone.yml): Deploy VM workloads in an Azure landing zone context.
- [Siemens Teamcenter baseline architecture](../../example-scenario/manufacturing/teamcenter-baseline.yml): Deploy a Siemens Teamcenter product life cycle management (PLM) solution on Azure.
- [Multiregion load balancing](../../high-availability/reference-architecture-traffic-manager-application-gateway.yml): Learn how to load balance traffic across multiple Azure regions.
- [Multitier web application built for high availability and disaster recovery (HA/DR)](../../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml): Deploy a multitier application that has HA/DR.
- [Deploy IBM Maximo Application Suite (MAS)](../../example-scenario/apps/deploy-ibm-maximo-application-suite.yml): Run IBM MAS enterprise asset management on Azure.
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml): Learn about best practices for running a Linux VM on Azure.
- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml): Learn about best practices for running a Windows VM on Azure.

#### Mainframe

- [AIX UNIX to Azure Linux migration](../../example-scenario/unix-migration/migrate-aix-azure-linux.yml): Migrate IBM AIX workloads to Azure Linux.
- [General mainframe refactor to Azure](../../example-scenario/mainframe/general-mainframe-refactor.yml): Modernize mainframe applications by using Azure services.
- [Solaris emulator on Azure virtual machines](./solaris-azure.yml): Emulate legacy Sun SPARC systems on Azure virtual machines.

### SAP

SAP workloads have specific architecture requirements. See the following resources for SAP on Azure.

#### SAP guides

- [SAP landscape architecture](../../guide/sap/sap-whole-landscape.yml): Review guidance about SAP landscapes on Azure.
- [Inbound and outbound internet connections for SAP on Azure](../../guide/sap/sap-internet-inbound-outbound.yml): See a network architecture for SAP internet connectivity.

#### SAP architectures

- [SAP BW/4HANA in Linux on Azure](../../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml): Deploy an SAP BW/4HANA data warehouse on Azure Linux VMs.
- [SAP deployment by using an Oracle database](../../example-scenario/apps/sap-production.yml): Run SAP production workloads by using an Oracle database on Azure.
- [SAP HANA scale-up systems on Linux](../../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml): Scale up SAP HANA deployments on Azure Linux VMs.
- [SAP NetWeaver in Windows on Azure](../../guide/sap/sap-netweaver.md): Deploy SAP NetWeaver on Windows VMs.
- [SAP S/4HANA in Linux on Azure](../../guide/sap/sap-s4hana.md): Run SAP S/4HANA on Azure Linux VMs.

#### SAP solution ideas

The following solution ideas demonstrate implementation patterns and possibilities to explore:

- [SAP S/4HANA for Azure Large Instances for Epic](./sap-s4-hana-on-hli-with-ha-and-dr.yml): Deploy SAP S/4HANA on Azure Large Instances for Epic with HA/DR.
- [Automate SAP workloads by using SUSE on Azure](./sap-workload-automation-suse.yml): Automate SAP deployment and operations by using SUSE tools.

## Learn about compute on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training resources for Azure compute technologies. The platform offers videos, tutorials, and interactive labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for compute implementations on Azure:

- [Describe Azure compute and networking services](/training/modules/describe-azure-compute-networking-services/)
- [Run a custom container in Azure](/azure/app-service/quickstart-custom-container)
- [Introduction to Azure Kubernetes Service (AKS)](/training/modules/intro-to-azure-kubernetes-service/)
- [Implement Azure Functions](/training/paths/implement-azure-functions/)
- [Introduction to Azure virtual machines](/training/modules/intro-to-azure-virtual-machines/)

### Learning paths by role

- **Solutions architect:** [Architect compute infrastructure in Azure](/training/paths/architect-compute-infrastructure/)
- **Developer:** [Implement Azure Functions](/training/paths/implement-azure-functions/)
- **DevOps engineer:** [Deploy and monitor applications on AKS](/training/paths/deploy-monitor-apps-azure-kubernetes-service/)

## Organizational readiness

Organizations that start their cloud adoption can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption. For cloud-scale compute guidance, see [Cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics).

To help ensure the quality of your compute solution on Azure, follow the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions.

For compute-specific guidance, see the following Well-Architected Framework service guides:

- [Virtual Machines and scale sets](/azure/well-architected/service-guides/virtual-machines)
- [App Service (Web Apps)](/azure/well-architected/service-guides/app-service-web-apps)
- [Azure Functions](/azure/well-architected/service-guides/azure-functions)
- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service)
- [Azure Container Apps](/azure/well-architected/service-guides/azure-container-apps)
- [Azure Service Fabric](/azure/well-architected/service-guides/azure-service-fabric)

## Best practices

Follow best practices to help ensure that your compute solution on Azure is reliable, secure, and cost-effective.

- [Autoscaling best practices](../../best-practices/auto-scaling.md): Learn about dynamic scaling to rightsize your infrastructure.
- [Background jobs guidance](../../best-practices/background-jobs.md): Implement background processing for long-running tasks.
- [Caching guidance](../../best-practices/caching.yml): Improve performance and reduce load on back-end systems.
- [Content delivery network guidance](../../best-practices/cdn.yml): Distribute content closer to users for better performance.

### Cost optimization

To manage compute costs on Azure, you must understand your usage patterns and choose the right pricing models.

- [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations): Make 1-year or 3-year commitments and save up to 72% on VMs, App Service, AKS, and other compute services compared to pay-as-you-go prices.
- [Spot Virtual Machines](/azure/virtual-machines/spot-vms): Access unused Azure capacity at significant discounts for interruptible workloads.
- [Azure savings plan for compute](/azure/cost-management-billing/savings-plan/buy-savings-plan): Take advantage of flexible pricing for compute across VMs, App Service, Azure Container Instances, and Functions Premium.
- [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit/): Use existing Windows Server, SQL Server, and Linux subscription licenses on Azure.
- [Reduce service costs by using Azure Advisor](/azure/advisor/advisor-cost-recommendations): Use Advisor recommendations to identify underutilized VMs, App Service plans, and other resources.

## Stay current with compute

Azure compute services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key compute services, see the following articles:

- [AKS release notes](/azure/aks/release-tracker)
- [App Service announcements](https://azure.github.io/AppService/feed.xml)
- [Azure Functions updates](/azure/azure-functions/functions-versions)

## Other resources

Compute covers a range of solutions. The following resources can help you discover more about Azure.

### Hybrid and multicloud

Many organizations need a hybrid approach to compute because their workloads run on-premises and in the cloud. Organizations typically [extend on-premises compute solutions to the cloud](/azure/architecture/databases/guide/hybrid-on-premises-and-cloud). To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/index).

Review the following key hybrid compute scenarios:

- [Azure Arc](/azure/azure-arc/overview): Extend Azure management and services to any infrastructure.
- [Azure Local](/azure/azure-local/overview): Run Azure services on-premises by using a hyperconverged infrastructure (HCI) solution.
- [Hybrid network architecture](../../reference-architectures/hybrid-networking/index.yml): Connect on-premises networks to Azure.

The following articles describe key hybrid compute scenarios:

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md): See an overview of hybrid solutions on Azure.
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml): Manage Kubernetes clusters across environments.

### HPC

HPC uses large clusters of computers to solve complex computational problems. For more information, see the following articles:

- [HPC on Azure](../../guide/compute/high-performance-computing.md): Learn about HPC capabilities and architectures.
- [Azure Batch](/azure/batch/batch-technical-overview): Run large-scale parallel and HPC applications efficiently.
- [Azure CycleCloud](/azure/cyclecloud/overview): Create, manage, and optimize HPC clusters.

### Containers and Kubernetes

Container-based architectures are increasingly popular for building scalable, portable applications. For more information, see the following articles:

- [Choose an Azure container service](../../guide/choose-azure-container-service.md): Review guidance for container workloads.
- [AKS baseline architecture](../../reference-architectures/containers/aks/baseline-aks.yml): See an example of a production-ready Kubernetes deployment.
- [Microservices architecture](../../guide/architecture-styles/microservices.md): See design patterns for microservices.

## AWS or Google Cloud professionals

To help you ramp up quickly, the following articles compare Azure compute options to other cloud services:

- [Compute services on Azure and Amazon Web Services (AWS)](../../aws-professional/compute.md): Compare Azure and AWS compute services.
- [Azure for AWS professionals](../../aws-professional/index.md): See this overview of Azure if you're familiar with AWS.
- [Google Cloud to Azure services comparison](../../gcp-professional/services.md#compute): Compare Azure and Google Cloud compute services.
