---
title: Compute architecture design
description: Get an overview of Azure compute technologies, guidance offerings, solution ideas, and reference architectures.
author: anaharris-ms
ms.author: anaharris
ms.date: 01/30/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Compute architecture design

Compute resources are the foundation of cloud workloads. Azure provides a wide range of compute options to meet diverse requirements, from virtual machines that give you full control over the operating system to fully managed serverless functions that scale automatically. Whether you're migrating existing workloads, building new cloud-native applications, or running high-performance computing (HPC) simulations, Azure compute services provide the flexibility, scale, and performance your organization needs.

Understanding your workload requirements is essential for choosing the right compute option. Considerations include the level of control you need, how your application scales, latency requirements, and cost optimization goals. Azure's compute portfolio spans infrastructure as a service (IaaS), platform as a service (PaaS), and serverless models, allowing you to select the approach that best fits your architecture.


## Architecture

The typical approach to implementing compute solutions on Azure starts with learning and organizational readiness, then moves to choosing appropriate Azure compute services based on workload requirements, followed by implementation best practices and production deployment. Refer to the [architectures](#explore-compute-architectures-and-guides) provided in this section to find real-world solutions that you can build in Azure.

## Explore compute architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These can help you make important decisions about how you use compute technologies in Azure. You can also review solution ideas, which give you a taste of what is possible as you plan your compute implementation.

### Guides

- [Choose a compute service](../../guide/technology-choices/compute-decision-tree.md) - Decision tree for selecting the right compute option.
- [SAS on Azure architecture](../../guide/sas/sas-overview.yml) - Comprehensive guide to running SAS analytics on Azure.
- [Build workloads with Azure Spot Virtual Machines](../../guide/spot/spot-eviction.yml) - Design workloads that take advantage of spare Azure capacity at reduced costs.
- [High-performance computing](../../guide/compute/high-performance-computing.md) - Overview of HPC capabilities and architectures on Azure.

### Architectures

- [VM baseline](../../virtual-machines/baseline.yml) - Foundational reference architecture for workloads deployed on Azure Virtual Machines.
- [VM baseline in an Azure landing zone](../../virtual-machines/baseline-landing-zone.yml) - Deploy VM workloads in an Azure landing zone context.
- [Teamcenter baseline architecture](../../example-scenario/manufacturing/teamcenter-baseline.yml) - Deploy Siemens Teamcenter PLM solution on Azure.
- [Multi-region load balancing](../../high-availability/reference-architecture-traffic-manager-application-gateway.yml) - Load balance traffic across multiple Azure regions.
- [Multi-tier web application built for HA/DR](../../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml) - Deploy a multi-tier application with high availability and disaster recovery.
- [Deploy IBM Maximo Application Suite](../../example-scenario/apps/deploy-ibm-maximo-application-suite.yml) - Run IBM Maximo enterprise asset management on Azure.
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml) - Best practices for running a Linux virtual machine on Azure.
- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml) - Best practices for running a Windows virtual machine on Azure.

#### Mainframe

- [AIX UNIX to Azure Linux migration](../../example-scenario/unix-migration/migrate-aix-azure-linux.yml) - Migrate IBM AIX workloads to Azure Linux.
- [General mainframe refactor to Azure](../../example-scenario/mainframe/general-mainframe-refactor.yml) - Modernize mainframe applications using Azure services.
- [Rehost a general mainframe on Azure](../../example-scenario/mainframe/mainframe-rehost-architecture-azure.yml) - Rehost mainframe workloads on Azure infrastructure.
- [Micro Focus Enterprise Server on Azure](../../example-scenario/mainframe/micro-focus-server.yml) - Run Micro Focus Enterprise Server for mainframe modernization.
- [Solaris emulator on Azure VMs](./solaris-azure.yml) - Emulate legacy Sun SPARC systems on Azure virtual machines.

### SAP

SAP workloads have specific architecture requirements. See the following resources for SAP on Azure:

#### SAP guides

- [SAP landscape architecture](../../guide/sap/sap-whole-landscape.yml) - Comprehensive guide to SAP landscapes on Azure.
- [Inbound and outbound internet connections for SAP on Azure](../../guide/sap/sap-internet-inbound-outbound.yml) - Network architecture for SAP internet connectivity.

#### SAP architectures

- [SAP BW/4HANA in Linux on Azure](../../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml) - Deploy SAP BW/4HANA data warehouse on Azure Linux VMs.
- [SAP deployment using an Oracle database](../../example-scenario/apps/sap-production.yml) - Run SAP production workloads with Oracle database on Azure.
- [SAP HANA scale-up on Linux](../../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml) - Scale-up SAP HANA deployment on Azure Linux VMs.
- [SAP NetWeaver in Windows on Azure](../../guide/sap/sap-netweaver.yml) - Deploy SAP NetWeaver on Windows virtual machines.
- [SAP S/4HANA in Linux on Azure](../../guide/sap/sap-s4hana.md) - Run SAP S/4HANA on Azure Linux VMs.

#### SAP solution ideas

- [SAP S/4 HANA for Large Instances](./sap-s4-hana-on-hli-with-ha-and-dr.yml) - Deploy SAP S/4HANA on Azure Large Instances with HA and DR.
- [Automate SAP workloads by using SUSE on Azure](./sap-workload-automation-suse.yml) - Automate SAP deployment and operations using SUSE tools.

## Learn about compute on Azure

If you're new to compute on Azure, the best place to learn more is with [Microsoft Learn](/training/?WT.mc_id=learnaka), a free, online training platform. You'll find videos, tutorials, and hands-on learning for specific products and services, plus learning paths based on your job role, such as developer or solutions architect.

Here are some resources to get you started:

- [Azure fundamentals: Describe Azure compute and networking services](/training/modules/describe-azure-compute-networking-services/)
- [Deploy and run a containerized web app with Azure App Service](/training/modules/deploy-run-container-app-service/)
- [Introduction to Azure Kubernetes Service](/training/modules/intro-to-azure-kubernetes-service/)
- [Implement Azure Functions](/training/paths/implement-azure-functions/)
- [Introduction to Azure Virtual Machines](/training/modules/intro-to-azure-virtual-machines/)

### Learning paths by role

- **Solutions architect**: [Architect compute infrastructure in Azure](/training/paths/architect-compute-infrastructure/)
- **Developer**: [Implement Azure Functions](/training/paths/implement-azure-functions/)
- **DevOps engineer**: [Build and deploy applications with Azure Kubernetes Service](/training/paths/build-applications-with-azure-devops/)

## Organizational readiness

If your organization is new to the cloud, the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) can help you get started. This collection of documentation and best practices offers proven guidance from Microsoft designed to accelerate your cloud adoption journey.

To help assure the quality of your compute solution on Azure, we recommend following the [Azure Well-Architected Framework](/azure/well-architected/). It provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions.

## Implementation checklist

As you're looking to implement your own compute solution on Azure, ensure you've reviewed the following topics:

> [!div class="checklist"]
>
> - Choose the appropriate [compute service](#choose-your-compute-service) based on your requirements
> - Identify the right [scaling strategy](#scaling) that meets your needs
> - Decide how you're going to [manage](#management-and-operations) all your resources
> - Optimize your [application](#application-optimization) for the cloud
> - [Secure](#security) your compute infrastructure

### Choose your compute service

Selecting the right compute service is one of the most important decisions in your architecture. Consider these factors:

- **Level of control**: VMs provide full OS control, while PaaS and serverless options abstract infrastructure management.
- **Scaling requirements**: Serverless and container platforms offer automatic scaling, while VMs require more manual configuration.
- **Cost model**: Pay-per-use (serverless) vs. reserved capacity (VMs) affects total cost of ownership.
- **Development model**: Some services support specific languages or frameworks better than others.

Use the [compute decision tree](../../guide/technology-choices/compute-decision-tree.md) to help guide your selection.

### Right-size your compute resources

Each compute service has its own sizing model. Understanding these options helps you balance performance and cost:

- **Virtual machines**: Choose from [VM sizes](/azure/virtual-machines/sizes/overview) optimized for general purpose, compute-intensive, memory-intensive, storage-intensive, GPU, or HPC workloads.
- **App Service**: Select an [App Service plan](/azure/app-service/overview-hosting-plans) tier (Free, Shared, Basic, Standard, Premium, Isolated) based on your scaling, networking, and feature requirements.
- **Azure Kubernetes Service**: Configure [node pools](/azure/aks/use-multiple-node-pools) with appropriate VM sizes for your containerized workloads, and use the cluster autoscaler to adjust capacity.
- **Azure Functions**: Choose between [Consumption, Premium, and Dedicated plans](/azure/azure-functions/functions-scale) based on execution duration, scaling needs, and network requirements.
- **Azure Container Apps**: Use [workload profiles](/azure/container-apps/workload-profiles-overview) to match container resources to your application requirements.

### Scaling

Scaling strategies depend on your chosen compute service:

- **Virtual Machine Scale Sets**: Automatically increase or decrease VM instances based on demand or a schedule. Learn about [autoscaling best practices](../../best-practices/auto-scaling.md).
- **Azure Kubernetes Service**: Use the [Horizontal Pod Autoscaler](/azure/aks/concepts-scale) and [cluster autoscaler](/azure/aks/cluster-autoscaler) to scale containerized workloads.
- **App Service**: Configure [autoscale rules](/azure/app-service/manage-scale-up) based on metrics or schedules.
- **Azure Functions**: Serverless functions scale automatically based on the number of incoming events.

### Management and operations

Effective management and operations are essential for maintaining healthy compute resources:

- [Azure Monitor](/azure/azure-monitor/overview) - Collect, analyze, and act on telemetry from your Azure and on-premises environments.
- [Azure Automation](/azure/automation/overview) - Automate frequent, time-consuming, and error-prone management tasks.
- [Azure Update Manager](/azure/update-manager/overview) - Manage and govern updates for Windows and Linux machines.
- [Azure Policy](/azure/governance/policy/overview) - Enforce organizational standards and assess compliance at scale.

### Application optimization

Optimize your applications to take full advantage of cloud compute:

- **Use managed services when possible**: Managed services reduce operational overhead and provide built-in high availability.
- **Design for horizontal scaling**: Build stateless applications that can scale out across multiple instances.
- **Implement caching**: Use [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) to reduce database load and improve response times.
- **Optimize cold start**: For serverless applications, minimize dependencies and use premium plans for latency-sensitive workloads.

### Security

Secure your compute resources using defense in depth:

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) - Unified security management and threat protection for VMs, containers, and App Service.
- [Managed identities](/entra/identity/managed-identities-azure-resources/overview) - Eliminate the need to manage credentials in your code. Supported across VMs, App Service, Functions, AKS, and Container Apps.
- [Private endpoints](/azure/private-link/private-endpoint-overview) - Secure network access to App Service, Functions, and other PaaS compute services.
- [Azure Bastion](/azure/bastion/bastion-overview) - Secure RDP and SSH connectivity to VMs without public IP addresses.
- [Azure confidential computing](/azure/confidential-computing/overview) - Protect data in use with hardware-based trusted execution environments.

## Best practices

Following best practices helps ensure your compute solution on Azure is reliable, secure, and cost-effective.

- [Autoscaling best practices](../../best-practices/auto-scaling.md) - Learn about dynamic scaling to right-size your infrastructure.
- [Background jobs guidance](../../best-practices/background-jobs.md) - Implement background processing for long-running tasks.
- [Caching guidance](../../best-practices/caching.yml) - Improve performance and reduce load on backend systems.
- [Content delivery network guidance](../../best-practices/cdn.yml) - Distribute content closer to users for better performance.

### Cost optimization

Managing compute costs on Azure requires understanding your usage patterns and selecting the right pricing models:

- [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) - Save up to 72% on VMs, App Service, AKS, and other compute services with 1-year or 3-year commitments.
- [Azure Spot VMs](/azure/virtual-machines/spot-vms) - Access unused Azure capacity at significant discounts for interruptible workloads.
- [Azure Savings Plan for Compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview) - Flexible pricing for compute across VMs, App Service, Container Instances, and Functions Premium.
- [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit/) - Use existing Windows Server, SQL Server, and Linux subscription licenses on Azure.
- [Right-size resources](/azure/advisor/advisor-cost-recommendations) - Use Azure Advisor recommendations to identify underutilized VMs, App Service plans, and other resources.

## Stay current with compute

Azure compute services are evolving to address modern application challenges. Stay informed about the latest updates and planned features.

Get the latest updates on [Azure products and features](https://azure.microsoft.com/updates/).

To stay current with key compute services, see:

- [What's new in Azure Virtual Machines](/azure/virtual-machines/whats-new)
- [AKS release notes](/azure/aks/release-tracker)
- [Azure App Service announcements](https://azure.github.io/AppService/feed.xml)
- [Azure Functions updates](/azure/azure-functions/functions-versions)

## Additional resources

Compute is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### Hybrid and multicloud

Many organizations need a hybrid approach to compute because they have workloads running both on-premises and in the cloud. Azure provides services to extend your datacenter to the cloud and run Azure services on-premises:

- [Azure Arc](/azure/azure-arc/overview) - Extend Azure management and services to any infrastructure.
- [Azure Local](/azure/azure-local/overview) - Run Azure services on-premises with a hyperconverged infrastructure solution.
- [Hybrid network architecture](../../reference-architectures/hybrid-networking/index.yml) - Connect on-premises networks to Azure.

Key hybrid compute scenarios:

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md) - Overview of hybrid solutions on Azure.
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml) - Manage Kubernetes clusters across environments.

### High-performance computing

High-performance computing (HPC) uses large clusters of computers to solve complex computational problems:

- [High-performance computing on Azure](../../topics/high-performance-computing.md) - Overview of HPC capabilities and architectures.
- [Azure Batch](/azure/batch/batch-technical-overview) - Run large-scale parallel and HPC applications efficiently.
- [Azure CycleCloud](/azure/cyclecloud/overview) - Create, manage, and optimize HPC clusters.

### Containers and Kubernetes

Container-based architectures are increasingly popular for building scalable, portable applications:

- [Choose an Azure container service](../../guide/choose-azure-container-service.md) - Guidance for container workloads.
- [AKS baseline architecture](../../reference-architectures/containers/aks/baseline-aks.yml) - Production-ready Kubernetes deployment.
- [Microservices architecture](../../guide/architecture-styles/microservices.md) - Design patterns for microservices.

### Example solutions

Here are some additional sample implementations of compute on Azure to consider:

- [Multi-region N-tier application](../../reference-architectures/n-tier/multi-region-sql-server.yml) - Deploy a highly available multi-tier application across regions.
- [Browse more compute examples in the Azure Architecture Center](../../browse/index.yml?azure_categories=compute)

## AWS or Google Cloud professionals

These articles can help you ramp up quickly by comparing Azure compute options to other cloud services:

- [Compute services on Azure and AWS](../../aws-professional/compute.md) - Compare Azure and AWS compute services.
- [Azure for AWS professionals](../../aws-professional/index.md) - Overview of Azure for those familiar with AWS.
- [Google Cloud to Azure services comparison](../../gcp-professional/services.md#compute) - Compare Azure and Google Cloud compute services.


