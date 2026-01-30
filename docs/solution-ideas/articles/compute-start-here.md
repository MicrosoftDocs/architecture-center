---
title: Compute architecture design
description: Get an overview of Azure compute technologies, guidance offerings, solution ideas, and reference architectures.
author: claytonsiemens77
ms.author: csiemens
ms.date: 01/30/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Compute architecture design

Compute resources are the foundation of cloud workloads. Azure provides a wide range of compute options to meet diverse requirements, from virtual machines that give you full control over the operating system to fully managed serverless functions that scale automatically. Whether you're migrating existing workloads, building new cloud-native applications, or running high-performance computing (HPC) simulations, Azure compute services provide the flexibility, scale, and performance your organization needs.

Understanding your workload requirements is essential for choosing the right compute option. Considerations include the level of control you need, how your application scales, latency requirements, and cost optimization goals. Azure's compute portfolio spans infrastructure as a service (IaaS), platform as a service (PaaS), and serverless models, allowing you to select the approach that best fits your architecture.

These are some of the key compute services available on Azure:

- [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md). Guidance on selecting the right compute option based on your workload requirements.
- [Azure Virtual Machines](/azure/virtual-machines/). IaaS offering that provides full control over the operating system and environment.
- [Azure Kubernetes Service (AKS)](/azure/aks/). Managed Kubernetes for deploying and scaling containerized applications.
- [Azure App Service](/azure/app-service/). PaaS for hosting web applications, REST APIs, and mobile backends.
- [Azure Functions](/azure/azure-functions/). Serverless compute for event-driven applications that scale automatically.
- [Azure Batch](/azure/batch/). Managed service for running large-scale parallel and HPC applications.

## Architecture

:::image type="complex" border="false" source="../media/compute-get-started-diagram.svg" alt-text="Diagram that shows the compute solution journey on Azure." lightbox="../media/compute-get-started-diagram.svg":::
   Diagram showing the solution journey for compute on Azure. The journey starts with learning and organizational readiness, then moves to choosing appropriate Azure compute services based on workload requirements, followed by implementation best practices and production deployment.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/compute-get-started-diagram.vsdx) of this architecture.*

The diagram demonstrates a typical approach to implementing compute solutions on Azure. Refer to the [architectures](#explore-compute-architectures-and-guides) provided in this section to find real-world solutions that you can build in Azure.

## Explore compute architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions. These can help you make important decisions about how you use compute technologies in Azure. You can also review solution ideas, which give you a taste of what is possible as you plan your compute implementation.

### Architectures

- [Baseline highly available zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) - Deploy a highly available web application using Azure App Service with zone redundancy.
- [Baseline Azure Kubernetes Service (AKS) architecture](../../reference-architectures/containers/aks/baseline-aks.yml) - Production-ready AKS cluster with security and operational best practices.
- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml) - Best practices for running a Windows virtual machine on Azure.
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml) - Best practices for running a Linux virtual machine on Azure.
- [Serverless web application](../../web-apps/serverless/architectures/web-app.yml) - Build a serverless web application using Azure Functions and other managed services.

### Solution ideas

- [Highly available SharePoint farm](./highly-available-sharepoint-farm.yml) - Deploy a highly available SharePoint farm for intranet capabilities using Azure VMs and SQL Always On.
- [Multilayered protection for Azure virtual machines](./multilayered-protection-azure-vm.yml) - Protect access to Azure VMs through a multilayer approach using Azure and Microsoft Entra ID security services.
- [Stromasys Charon-SSP Solaris emulator on Azure VMs](./solaris-azure.yml) - Emulate legacy Sun SPARC systems on Azure virtual machines.

### Guides

- [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md) - Decision tree for selecting the right compute option.
- [Compute services comparison](../../guide/technology-choices/compute-decision-tree.yml) - Compare Azure compute services side by side.
- [Virtual machines in Azure](../../guide/virtual-machines/overview.md) - Overview of VM options and scenarios.
- [Containers on Azure](../../guide/containers/overview.md) - Guidance for container-based workloads.

## Learn about compute on Azure

If you're new to compute on Azure, the best place to learn more is with [Microsoft Learn](/training/?WT.mc_id=learnaka), a free, online training platform. You'll find videos, tutorials, and hands-on learning for specific products and services, plus learning paths based on your job role, such as developer or solutions architect.

Here are some resources to get you started:

- [Azure fundamentals: Describe Azure compute and networking services](/training/paths/azure-fundamentals-describe-azure-compute-networking-services/)
- [Deploy and run a containerized web app with Azure App Service](/training/modules/deploy-run-container-app-service/)
- [Introduction to Azure Kubernetes Service](/training/modules/intro-to-azure-kubernetes-service/)
- [Create serverless applications](/training/paths/create-serverless-applications/)
- [Introduction to Azure Virtual Machines](/training/modules/intro-to-azure-virtual-machines/)

### Learning paths by role

- **Solutions architect**: [Architect compute infrastructure in Azure](/training/paths/architect-compute-infrastructure/)
- **Developer**: [Create serverless applications](/training/paths/create-serverless-applications/)
- **DevOps engineer**: [Build and deploy applications with Azure Kubernetes Service](/training/paths/build-applications-with-azure-devops/)

## Organizational readiness

If your organization is new to the cloud, the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) can help you get started. This collection of documentation and best practices offers proven guidance from Microsoft designed to accelerate your cloud adoption journey.

To help assure the quality of your compute solution on Azure, we recommend following the [Azure Well-Architected Framework](/azure/well-architected/). It provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions.

- [Reliability pillar - Compute](/azure/well-architected/reliability/identify-flows)
- [Cost Optimization pillar - Compute](/azure/well-architected/cost-optimization/optimize-compute)
- [Performance Efficiency pillar - Compute](/azure/well-architected/performance-efficiency/optimize-compute)

## Implementation checklist

As you're looking to implement your own compute solution on Azure, ensure you've reviewed the following topics:

> [!div class="checklist"]
>
> - Choose the appropriate [compute service](#choose-your-compute-service) based on your requirements
> - Know which [VM sizes and families](#virtual-machine-sizing) are right for your workload
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

### Virtual machine sizing

Azure offers a wide range of VM sizes optimized for different workloads:

- [General purpose](/azure/virtual-machines/sizes-general) - Balanced CPU-to-memory ratio for testing, development, and small to medium databases.
- [Compute optimized](/azure/virtual-machines/sizes-compute) - High CPU-to-memory ratio for medium traffic web servers and batch processes.
- [Memory optimized](/azure/virtual-machines/sizes-memory) - High memory-to-CPU ratio for relational databases and in-memory analytics.
- [Storage optimized](/azure/virtual-machines/sizes-storage) - High disk throughput and I/O for big data and SQL databases.
- [GPU enabled](/azure/virtual-machines/sizes-gpu) - Specialized VMs for graphics rendering and deep learning.
- [High performance compute](/azure/virtual-machines/sizes-hpc) - Fastest and most powerful CPU VMs with optional RDMA network interfaces.

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

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) - Unified security management and threat protection.
- [Azure Bastion](/azure/bastion/bastion-overview) - Secure RDP and SSH connectivity to VMs without public IP addresses.
- [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview) - Eliminate the need to manage credentials in your code.
- [Azure confidential computing](/azure/confidential-computing/overview) - Protect data in use with hardware-based trusted execution environments.

## Best practices

Following best practices helps ensure your compute solution on Azure is reliable, secure, and cost-effective.

- [Autoscaling best practices](../../best-practices/auto-scaling.md) - Learn about dynamic scaling to right-size your infrastructure.
- [Background jobs guidance](../../best-practices/background-jobs.md) - Implement background processing for long-running tasks.
- [Caching guidance](../../best-practices/caching.md) - Improve performance and reduce load on backend systems.
- [Content delivery network guidance](../../best-practices/cdn.md) - Distribute content closer to users for better performance.

### Cost optimization

Managing compute costs on Azure requires understanding your usage patterns and selecting the right pricing models:

- [Azure Reserved VM Instances](/azure/cost-management-billing/reservations/save-compute-costs-reservations) - Save up to 72% compared to pay-as-you-go pricing with 1-year or 3-year commitments.
- [Azure Spot VMs](/azure/virtual-machines/spot-vms) - Access unused Azure capacity at significant discounts for interruptible workloads.
- [Azure Hybrid Benefit](/azure/virtual-machines/windows/hybrid-use-benefit-licensing) - Use existing Windows Server and SQL Server licenses on Azure.
- [Right-size VMs](/azure/advisor/advisor-cost-recommendations) - Use Azure Advisor recommendations to identify underutilized resources.

## Stay current with compute

Azure compute services are evolving to address modern application challenges. Stay informed about the latest updates and planned features.

Get the latest updates on [Azure products and features](https://azure.microsoft.com/updates/).

To stay current with key compute services, see:

- [What's new in Azure Virtual Machines](/azure/virtual-machines/whats-new)
- [AKS release notes](/azure/aks/release-notes)
- [Azure App Service announcements](https://azure.github.io/AppService/feed.xml)
- [Azure Functions updates](/azure/azure-functions/functions-versions)

## Additional resources

Compute is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### Hybrid and multicloud

Many organizations need a hybrid approach to compute because they have workloads running both on-premises and in the cloud. Azure provides services to extend your datacenter to the cloud and run Azure services on-premises:

- [Azure Arc](/azure/azure-arc/overview) - Extend Azure management and services to any infrastructure.
- [Azure Stack HCI](/azure/azure-stack/hci/overview) - Run Azure services on-premises with a hyperconverged infrastructure solution.
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

- [Containers on Azure](../../guide/containers/overview.md) - Guidance for container workloads.
- [AKS baseline architecture](../../reference-architectures/containers/aks/baseline-aks.yml) - Production-ready Kubernetes deployment.
- [Microservices architecture](../../guide/architecture-styles/microservices.yml) - Design patterns for microservices.

### Example solutions

Here are some additional sample implementations of compute on Azure to consider:

- [Multi-region N-tier application](../../reference-architectures/n-tier/multi-region-sql-server.yml) - Deploy a highly available multi-tier application across regions.
- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml) - Best practices for Windows virtual machines.
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml) - Best practices for Linux virtual machines.
- [Browse more compute examples in the Azure Architecture Center](../../browse/index.yml?azure_categories=compute)

## AWS or Google Cloud professionals

These articles can help you ramp up quickly by comparing Azure compute options to other cloud services:

- [Compute services on Azure and AWS](../../aws-professional/compute.md) - Compare Azure and AWS compute services.
- [Azure for AWS professionals](../../aws-professional/index.md) - Overview of Azure for those familiar with AWS.
- [Google Cloud to Azure services comparison](../../gcp-professional/services.md#compute) - Compare Azure and Google Cloud compute services.

## Next steps

- [Choose an Azure compute service](../../guide/technology-choices/compute-decision-tree.md)
- [Azure fundamentals: Describe Azure compute and networking services](/training/paths/azure-fundamentals-describe-azure-compute-networking-services/)
- [Architect compute infrastructure in Azure](/training/paths/architect-compute-infrastructure/)

## Related resources

- [Compute decision tree](../../guide/technology-choices/compute-decision-tree.md)
- [Virtual machines in Azure](../../guide/virtual-machines/overview.md)
- [Containers on Azure](../../guide/containers/overview.md)
- [Autoscaling best practices](../../best-practices/auto-scaling.md)
