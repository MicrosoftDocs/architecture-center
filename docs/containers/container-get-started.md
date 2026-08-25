---
title: Get Started with Container Architecture Design
description: Get an overview of Azure container technologies, guidance offerings, solution ideas, and reference architectures for container workloads on Azure.
ms.author: pnp
author: anaharris-ms
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: category-get-started
ai-usage: ai-assisted
ms.date: 02/02/2026
---

# Get started with container architecture design

Containers are the standard for packaging and deploying modern applications. Azure provides a comprehensive set of container services that range from fully managed Kubernetes clusters to serverless container platforms. Whether you're modernizing existing applications, building cloud-native microservices, or running stateful workloads, Azure container services provide the flexibility, portability, and scalability that your organization needs.

Choosing the right container platform depends on your workload requirements, operational expertise, and business goals. Key considerations include orchestration complexity, scaling requirements, networking needs, and the level of control that you want over the underlying infrastructure. Azure containers span infrastructure as a service (IaaS), platform as a service (PaaS), and serverless models, so you can select the approach that best suits your architecture.

## Azure services for containers

Azure provides a range of services for containers:

- [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes): Fully managed Kubernetes service for deploying and managing containerized applications with enterprise-grade security and governance.

- [Azure Container Apps](/azure/container-apps/overview): Serverless container platform for running microservices and containerized applications without managing infrastructure.

- [Azure Container Instances](/azure/container-instances/container-instances-overview): Fast and simple way to run containers without orchestration for event-driven applications and batch jobs.

- [Azure Container Registry](/azure/container-registry/container-registry-intro): Private registry service for building, storing, and managing container images and artifacts.

- [Azure Red Hat OpenShift](/azure/openshift/intro-openshift): Fully managed OpenShift service for enterprises that require Red Hat support and additional platform capabilities.

## Architecture

:::image type="complex" border="false" source="../reference-architectures/containers/aks/images/aks-baseline-architecture.svg" alt-text="Diagram that shows the container solution journey on Azure." lightbox="../reference-architectures/containers/aks/images/aks-baseline-architecture.svg":::
   The diagram shows a typical approach for implementing container solutions on Azure. At the top left, Azure Bastion creates a secure tunnel from the local kubectl client. The hub virtual network includes the Azure Bastion subnet (management), the Azure Firewall subnet (outbound), and the gateway subnet (to on-premises). An arrow labeled private IP address points from the Azure Bastion subnet to the internal load balancer in the spoke virtual network. An arrow points from the on-premises network to the gateway subnet. A double-sided arrow labeled virtual network peering connects the hub virtual network and the spoke (remote office). Virtual network peering connects the hub and spoke networks. Arrows point from Azure Key Vault and Azure Container Registry to the Azure Private Link endpoints subnet. The spoke virtual network includes the API server virtual network integration delegated subnet, the ingress resources subnet, and the Azure Application Gateway subnet. An arrow points from the internet to the Application Gateway subnet. The spoke virtual network section also includes the cluster nodes subnet. Azure Kubernetes Service (AKS), system node pool, and user node pool are in this cluster. The system node pool includes CoreDNS and metric-server. The user node pool includes Traefik ingress controller and the workload. An arrow points from the cluster nodes subnet to a section that includes Azure Monitor workspace, metrics, and Managed Prometheus.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-baseline-architecture.vsdx) of this architecture.*

The previous diagram demonstrates a typical basic or baseline container implementation. For real-world solutions that you can build in Azure, see [Container architectures](#container-architectures).

## Explore container guides, architectures, and solution ideas

The articles in this section include guides and fully developed architectures that you can deploy in Azure and expand to production-grade solutions. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your container proof-of-concept (POC) development. These articles can help you decide how to use container technologies in Azure.

[!INCLUDE [container-get-started](../includes/container-get-started-include.md)]

## Organizational readiness

Organizations at the beginning of the cloud adoption process can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption.

To help ensure the quality of your container solution on Azure, follow the guidance in the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions. For container-specific guidance, see the following Well-Architected Framework service guides:

- [Container Apps](/azure/well-architected/service-guides/azure-container-apps)
- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service)

## Best practices

Follow these best practices to improve the reliability, security, cost effectiveness, performance, and operational quality of your container workloads on Azure:

- [Autoscaling best practices](../best-practices/auto-scaling.md): Learn about dynamic scaling to rightsize your infrastructure.

- [Background jobs guidance](../best-practices/background-jobs.md): Implement background processing for long-running tasks.

- [Caching guidance](../best-practices/caching.md): Improve performance and reduce load on back-end systems.

### Cost Optimization

Managing container costs on Azure requires you to understand your usage patterns and select the right pricing models:

- [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations): Save up to 72% on AKS node virtual machines (VMs) with one-year or three-year commitments.

- [Azure spot VMs for AKS](/azure/aks/spot-node-pool): Use spot node pools for interruptible workloads at significant discounts.

- [Azure savings plan for compute](/azure/cost-management-billing/savings-plan/savings-plan-overview): Flexible pricing across VMs, Container Instances, and other compute services.

- [Rightsize resources](/azure/advisor/advisor-cost-recommendations): Use Azure Advisor recommendations to identify underutilized nodes and optimize pod resource requests.

- [Container Apps consumption plan](/azure/container-apps/billing): Pay only for resources consumed during request processing.

### Container Apps operations

Container Apps reduces operational overhead with managed infrastructure, but you need to monitor and manage your applications:

- [Monitor Container Apps](/azure/container-apps/observability): Use Azure Monitor, Log Analytics, and Application Insights for observability.

- [Health probes](/azure/container-apps/health-probes): Configure liveness, readiness, and startup probes for container health.

- [Revisions and traffic splitting](/azure/container-apps/revisions-manage): Manage application versions and implement blue-green deployments.

- [Quotas and limits](/azure/container-apps/quotas): Understand service limits and plan capacity accordingly.

## Stay current with containers

Azure container services evolve to address modern application challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key container services, see the following articles:

- [AKS release notes](/azure/aks/release-tracker)
- [What's new in Container Apps](/azure/container-apps/whats-new)

## Other resources

The following resources can help you discover more about containers.

- [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview): Manage Kubernetes clusters that run anywhere by using Azure Arc.

- [AKS enabled by Azure Arc](/azure/aks/hybrid/aks-hybrid-options-overview): Run AKS on Azure Local and Windows Server.

- [Azure Arc hybrid management and deployment for Kubernetes clusters](../hybrid/arc-hybrid-kubernetes.yml): Manage Kubernetes clusters across environments.

- [Hybrid architecture design](../hybrid/hybrid-start-here.md): Overview of hybrid solutions on Azure.

- [AKS on Azure Local baseline architecture](../example-scenario/hybrid/aks-baseline.yml): Production-ready AKS on Azure Local deployment.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure container options to other cloud services and provide migration guidance:

- [Containers and container orchestrators on Azure and AWS](../aws-professional/compute.md#containers-and-container-orchestrators): Compare Azure and AWS container services.

- [Azure for AWS professionals](../aws-professional/index.md): Overview of Azure for professionals familiar with AWS.

- [Google Cloud to Azure services comparison](../gcp-professional/services.md#compute): Compare Azure and Google Cloud container services.
