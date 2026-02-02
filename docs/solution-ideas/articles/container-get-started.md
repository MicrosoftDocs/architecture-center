---
title: Container architecture design
description: Get an overview of Azure container technologies, guidance offerings, solution ideas, and reference architectures.
author: anaharris-ms
ms.author: anaharris
ms.date: 02/02/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Container architecture design

Containers have become the standard for packaging and deploying modern applications. Azure provides a comprehensive set of container services that range from fully managed Kubernetes clusters to serverless container platforms. Whether you're modernizing existing applications, building cloud-native microservices, or running stateful workloads, Azure container services offer the flexibility, portability, and scalability your organization needs.

Choosing the right container platform depends on your workload requirements, operational expertise, and business goals. Key considerations include orchestration complexity, scaling requirements, networking needs, and the level of control you want over the underlying infrastructure. Azure's container portfolio spans infrastructure as a service (IaaS), platform as a service (PaaS), and serverless models, allowing you to select the approach that best fits your architecture.


## Architecture

The typical approach to implementing container solutions on Azure starts with learning and organizational readiness, then moves to choosing the appropriate container platform based on workload requirements, followed by implementation best practices and production deployment. Refer to the [architectures](#explore-container-architectures-and-guides) provided in this section to find real-world solutions that you can build in Azure.

## Explore container architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These can help you make important decisions about how you use container technologies in Azure. You can also review solution ideas, which give you a taste of what is possible as you plan your container implementation.

### Guides

- [Choose an Azure container service](../../guide/choose-azure-container-service.md) - Decision tree for selecting the right container platform.
- [Azure container service considerations](../../guide/container-service-general-considerations.md) - Detailed considerations for container service selection.

### AKS

Azure Kubernetes Service (AKS) is the most comprehensive container platform on Azure. See the following resources for AKS:

#### AKS guides

- [Get started with AKS](../../reference-architectures/containers/aks-start-here.md) - Introduction to AKS architecture and design.
- [Choose a Kubernetes at the edge option](../../operator-guides/aks/choose-kubernetes-edge-compute-option.md) - Compare options for running Kubernetes at the edge.
- [High availability for multitier AKS apps](../../guide/aks/aks-high-availability.yml) - Design patterns for highly available AKS applications.
- [CI/CD for AKS apps via Azure Pipelines](../../guide/aks/aks-cicd-azure-pipelines.md) - Implement continuous integration and deployment for AKS.
- [GitOps for AKS](../../example-scenario/gitops-aks/gitops-blueprint-aks.yml) - Use GitOps practices to manage AKS deployments.
- [Access an AKS API server](../../guide/security/access-azure-kubernetes-service-cluster-api-server.yml) - Secure access patterns for AKS API servers.
- [Blue-green deployment of AKS clusters](../../guide/aks/blue-green-deployment-for-aks.yml) - Implement zero-downtime deployments with blue-green strategies.
- [Firewall protection for an AKS cluster](../../guide/aks/aks-firewall.yml) - Secure AKS clusters with Azure Firewall.
- [Use Azure Kubernetes Service to host GPU-based workloads](../../reference-architectures/containers/aks-gpu/gpu-aks.md) - Run GPU workloads on AKS for AI/ML scenarios.

#### AKS architectures

- [AKS baseline cluster](../../reference-architectures/containers/aks/baseline-aks.yml) - Production-ready baseline architecture for AKS.
- [AKS baseline for multi-region clusters](../../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml) - Deploy AKS across multiple regions for high availability.
- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml) - Design and deploy microservices on AKS.
- [Advanced microservices on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml) - Advanced patterns for complex microservices workloads.
- [CI/CD for microservices on Kubernetes](../../microservices/ci-cd-kubernetes.yml) - Build robust CI/CD pipelines for Kubernetes microservices.
- [Use Azure Red Hat OpenShift in the financial services industry](../../reference-architectures/containers/aro/azure-redhat-openshift-financial-services-workloads.yml) - OpenShift for regulated financial workloads.
- [Secure AKS workloads with Azure Front Door](../../example-scenario/aks-front-door/aks-front-door.yml) - Global load balancing and security for AKS.
- [Multitenancy with AKS and AGIC](../../example-scenario/aks-agic/aks-agic.yml) - Multi-tenant architectures using Application Gateway Ingress Controller.

#### AKS solution ideas

- [Data streaming with AKS](./data-streaming-scenario.yml) - Real-time data streaming architectures using AKS.

### PaaS container hosting

Azure Container Apps and Azure Container Instances provide serverless container platforms that abstract infrastructure management. See the following resources:

#### PaaS architectures

- [Microservices with Container Apps](../../example-scenario/serverless/microservices-with-container-apps.yml) - Build microservices using Azure Container Apps.
- [Microservices with Dapr and KEDA](../../example-scenario/serverless/microservices-with-container-apps-dapr.yml) - Event-driven microservices with Dapr and KEDA on Container Apps.

## Learn about containers on Azure

If you're new to containers on Azure, the best place to learn more is with [Microsoft Learn](/training/?WT.mc_id=learnaka), a free, online training platform. You'll find videos, tutorials, and hands-on learning for specific products and services, plus learning paths based on your job role, such as developer or solutions architect.

Here are some resources to get you started:

- [Introduction to Kubernetes on Azure](/training/paths/intro-to-kubernetes-on-azure/)
- [Introduction to Azure Kubernetes Service](/training/modules/intro-to-azure-kubernetes-service/)
- [Deploy a containerized application on Azure Kubernetes Service](/training/modules/aks-deploy-container-app/)
- [Introduction to Docker containers](/training/modules/intro-to-docker-containers/)
- [Deploy and run a containerized web app with Azure App Service](/training/modules/deploy-run-container-app-service/)
- [Implement Azure Container Apps](/training/modules/implement-azure-container-apps/)

### Learning paths by role

- **Solutions architect**: [Architect compute infrastructure in Azure](/training/paths/architect-compute-infrastructure/)
- **Developer**: [Deploy containers by using Azure Kubernetes Service](/training/paths/deploy-manage-containers-azure-kubernetes-service/)
- **DevOps engineer**: [Build and deploy applications with Azure Kubernetes Service](/training/paths/build-applications-with-azure-devops/)

## Organizational readiness

If your organization is new to the cloud, the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) can help you get started. This collection of documentation and best practices offers proven guidance from Microsoft designed to accelerate your cloud adoption journey.

To help assure the quality of your container solution on Azure, we recommend following the [Azure Well-Architected Framework](/azure/well-architected/). It provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions.

## Implementation checklist

As you're looking to implement your own container solution on Azure, ensure you've reviewed the following topics:

> [!div class="checklist"]
>
> - Choose the appropriate [container platform](#choose-your-container-platform) based on your requirements
> - Understand [cluster configuration](#cluster-configuration) options for your workloads
> - Identify the right [scaling strategy](#scaling) that meets your needs
> - Design your [networking](#networking) architecture
> - [Secure](#security) your container infrastructure

### Choose your container platform

Selecting the right container platform is one of the most important decisions in your architecture. Consider these factors:

- **Orchestration complexity**: AKS provides full Kubernetes orchestration, while Container Apps abstracts Kubernetes complexity.
- **Scaling requirements**: All platforms support autoscaling, but with different granularity and configuration options.
- **Operational overhead**: Serverless options like Container Apps and Container Instances reduce operational burden compared to managing AKS clusters.
- **Portability**: Kubernetes-based platforms (AKS, OpenShift) offer greater portability across clouds and on-premises environments.
- **Ecosystem requirements**: Consider whether you need specific Kubernetes features, operators, or Helm charts.

Use the [container service decision tree](../../guide/choose-azure-container-service.md) to help guide your selection.

### Cluster configuration

For Kubernetes-based platforms, proper cluster configuration is essential for reliability and performance:

- **Node pools**: Configure [multiple node pools](/azure/aks/use-multiple-node-pools) to separate system and user workloads, and to support different VM sizes for varied workload requirements.
- **Availability zones**: Deploy nodes across [availability zones](/azure/aks/availability-zones) for high availability within a region.
- **Cluster autoscaler**: Enable the [cluster autoscaler](/azure/aks/cluster-autoscaler) to automatically adjust the number of nodes based on workload demand.
- **Resource quotas**: Set [resource quotas](/azure/aks/operator-best-practices-scheduler) to prevent resource exhaustion and ensure fair allocation across namespaces.

For serverless containers:

- **Azure Container Apps**: Configure [workload profiles](/azure/container-apps/workload-profiles-overview) to match container resources to your application requirements.
- **Azure Container Instances**: Select appropriate [container groups](/azure/container-instances/container-instances-container-groups) and resource allocations for your workloads.

### Scaling

Scaling strategies depend on your chosen container platform:

- **Azure Kubernetes Service**: Use the [Horizontal Pod Autoscaler](/azure/aks/concepts-scale) to scale pods based on CPU, memory, or custom metrics. Use the [cluster autoscaler](/azure/aks/cluster-autoscaler) to scale nodes. For event-driven scaling, use [KEDA](/azure/aks/keda-about).
- **Azure Container Apps**: Built-in [autoscaling rules](/azure/container-apps/scale-app) support HTTP traffic, event-driven scaling with KEDA, and CPU/memory-based scaling.
- **Azure Container Instances**: Use [Azure Logic Apps or Azure Functions](/azure/container-instances/container-instances-orchestrator-relationship) to orchestrate scaling of container groups for burst scenarios.

Learn more about [autoscaling best practices](../../best-practices/auto-scaling.md).

### Networking

Container networking requires careful planning based on your chosen platform:

**Azure Kubernetes Service**:

- **Network model**: Choose between [Azure CNI and kubenet](/azure/aks/concepts-network) based on your IP address requirements and network policies.
- **Ingress**: Select an [ingress controller](/azure/aks/concepts-network#ingress-controllers) (NGINX, Application Gateway, or others) to manage external access to services.
- **Service mesh**: Consider a [service mesh](/azure/aks/servicemesh-about) for advanced traffic management, security, and observability between services.
- **Private clusters**: Use [private AKS clusters](/azure/aks/private-clusters) to ensure the API server is only accessible from your private network.
- **Network policies**: Implement [network policies](/azure/aks/use-network-policies) to control traffic flow between pods.

**Azure Container Apps**:

- **Environments**: Deploy apps in [Container Apps environments](/azure/container-apps/environment) that provide network isolation and shared infrastructure.
- **Virtual network integration**: Use [VNet integration](/azure/container-apps/vnet-custom) to deploy Container Apps in your own virtual network for private connectivity.
- **Ingress**: Configure [built-in ingress](/azure/container-apps/ingress-overview) for HTTP/HTTPS traffic with automatic TLS termination.
- **Internal environments**: Create [internal-only environments](/azure/container-apps/vnet-custom-internal) for workloads that shouldn't be exposed to the internet.

### Security

Secure your container workloads using defense in depth:

- [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) - Threat protection for AKS clusters, Container Apps, container images, and runtime security.
- [Managed identities](/azure/container-apps/managed-identity) - Eliminate the need to manage credentials. Supported across AKS (workload identity), Container Apps, and Container Instances.
- [Azure Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes) - Enforce organizational standards and assess compliance of your AKS clusters.
- [Private container registries](/azure/container-registry/container-registry-private-link) - Secure access to container images with Azure Container Registry private endpoints.
- [Image scanning](/azure/defender-for-cloud/defender-for-containers-vulnerability-assessment-azure) - Scan container images for vulnerabilities before deployment.
- [Container Apps authentication](/azure/container-apps/authentication) - Built-in authentication with identity providers for Container Apps.

## Operations guide

Getting your workload deployed on Azure is a great milestone, and this is when [day-2 operations](https://dzone.com/articles/defining-day-2-operations) become critical.

### AKS operations

The **AKS day-2 operations guide** helps ensure you're ready to meet operational demands for Kubernetes workloads.

> [!div class="nextstepaction"]
> [AKS day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)

Key AKS operational areas:

- [Triage practices](../../operator-guides/aks/aks-triage-practices.md) - Systematic approach to troubleshooting AKS issues.
- [Backup and recovery for AKS](../../operator-guides/aks/aks-backup-and-recovery.md) - Protect your cluster configuration and workloads.
- [Patch and upgrade worker nodes](../../operator-guides/aks/aks-upgrade-practices.md) - Keep clusters secure and up to date.
- [Troubleshoot networking](../../operator-guides/aks/troubleshoot-network-aks.md) - Diagnose and resolve network issues.
- [Monitor AKS with Azure Monitor](/azure/aks/monitor-aks) - Collect and analyze telemetry from your clusters.

### Container Apps operations

Azure Container Apps reduces operational overhead with managed infrastructure, but you still need to monitor and manage your applications:

- [Monitor Container Apps](/azure/container-apps/observability) - Use Azure Monitor, Log Analytics, and Application Insights for observability.
- [Health probes](/azure/container-apps/health-probes) - Configure liveness, readiness, and startup probes for container health.
- [Revisions and traffic splitting](/azure/container-apps/revisions-manage) - Manage application versions and implement blue-green deployments.
- [Quotas and limits](/azure/container-apps/quotas) - Understand service limits and plan capacity accordingly.

## Best practices

Following best practices helps ensure your container solution on Azure is reliable, secure, and cost-effective.

- [Autoscaling best practices](../../best-practices/auto-scaling.md) - Learn about dynamic scaling to right-size your infrastructure.
- [Background jobs guidance](../../best-practices/background-jobs.md) - Implement background processing for long-running tasks.
- [Caching guidance](../../best-practices/caching.yml) - Improve performance and reduce load on backend systems.

### Cost optimization

Managing container costs on Azure requires understanding your usage patterns and selecting the right pricing models:

- [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) - Save up to 72% on AKS node VMs with 1-year or 3-year commitments.
- [Azure Spot VMs for AKS](/azure/aks/spot-node-pool) - Use spot node pools for interruptible workloads at significant discounts.
- [Azure Savings Plan for Compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview) - Flexible pricing across VMs, Container Instances, and other compute services.
- [Right-size resources](/azure/advisor/advisor-cost-recommendations) - Use Azure Advisor recommendations to identify underutilized nodes and optimize pod resource requests.
- [Container Apps consumption plan](/azure/container-apps/billing) - Pay only for resources consumed during request processing.

## Stay current with containers

Azure container services are evolving to address modern application challenges. Stay informed about the latest updates and planned features.

Get the latest updates on [Azure products and features](https://azure.microsoft.com/updates/).

To stay current with key container services, see:

- [AKS release notes](/azure/aks/release-tracker)
- [What's new in Azure Container Apps](/azure/container-apps/whats-new)

## Additional resources

Containers is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### Hybrid and multicloud

Many organizations need a hybrid approach to containers because they have workloads running both on-premises and in the cloud. Azure provides services to extend your container platforms across environments:

- [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) - Manage Kubernetes clusters running anywhere with Azure Arc.
- [AKS enabled by Azure Arc](/azure/aks/hybrid/aks-hybrid-options-overview) - Run AKS on Azure Local and Windows Server.
- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml) - Manage Kubernetes clusters across environments.

Key hybrid container scenarios:

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md) - Overview of hybrid solutions on Azure.
- [AKS on Azure Local baseline architecture](../../example-scenario/hybrid/aks-baseline.yml) - Production-ready AKS on Azure Local deployment.

### Microservices

Container platforms are commonly used to host microservices architectures:

- [Microservices architecture style](../../guide/architecture-styles/microservices.md) - Design principles for microservices.
- [Design a microservices architecture](../../microservices/design/index.md) - Step-by-step guidance for microservices design.
- [Microservices with AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml) - Reference architecture for microservices on AKS.

### Example solutions

Here are some additional sample implementations of containers on Azure to consider:

- [AKS baseline cluster](../../reference-architectures/containers/aks/baseline-aks.yml) - Start with the production-ready AKS baseline.
- [Browse more container examples in the Azure Architecture Center](../../browse/index.yml?azure_categories=containers)

## AWS or Google Cloud professionals

These articles can help you ramp up quickly by comparing Azure container options to other cloud services:

- [Containers and container orchestrators on Azure and AWS](../../aws-professional/compute.md#containers-and-container-orchestrators) - Compare Azure and AWS container services.
- [Azure for AWS professionals](../../aws-professional/index.md) - Overview of Azure for those familiar with AWS.
- [Google Cloud to Azure services comparison](../../gcp-professional/services.md#compute) - Compare Azure and Google Cloud container services.
