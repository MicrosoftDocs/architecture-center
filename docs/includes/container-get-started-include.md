### Container guides

The following articles help you evaluate and select the best container technologies for your workload requirements:

- [Choose an Azure container service](../guide/choose-azure-container-service.md): Decision tree for selecting the right container platform.

- [Azure container service considerations](../guide/container-service-general-considerations.md): Detailed considerations for container service selection.

- [Microservices architecture style](../guide/architecture-styles/microservices.md): Design principles for microservices.

- [Design a microservices architecture](../microservices/design/index.md): Step-by-step guidance for microservices design.

Resources for getting started with Azure Kubernetes Service (AKS):

- [Get started with AKS](../reference-architectures/containers/aks-start-here.md): Introduction to AKS architecture and design.

- [Choose a Kubernetes at the edge option](../operator-guides/aks/choose-kubernetes-edge-compute-option.md): Compare options for running Kubernetes at the edge.

- [High availability (HA) for multitier AKS apps](../guide/aks/aks-high-availability.md): Design patterns for highly available AKS applications.

- [Continuous integration and continuous deployment (CI/CD) for AKS apps via Azure Pipelines](../guide/aks/aks-cicd-azure-pipelines.md): Implement CI/CD for AKS.

- [GitOps for AKS](../example-scenario/gitops-aks/gitops-blueprint-aks.yml): Use GitOps practices to manage AKS deployments.

- [Access an AKS API server](../security/access-azure-kubernetes-service-cluster-api-server.md): Secure access patterns for AKS API servers.

- [Blue-green deployment of AKS clusters](../guide/aks/blue-green-deployment-for-aks.yml): Implement zero-downtime deployments by using blue-green strategies.

- [Firewall protection for an AKS cluster](../guide/aks/aks-firewall.md): Secure AKS clusters by using Azure Firewall.

- [Use AKS to host GPU-based workloads](../reference-architectures/containers/aks-gpu/gpu-aks.md): Run GPU workloads on AKS for AI and machine learning scenarios.

Operational guidance for running and maintaining AKS in production:

- [Triage practices](../operator-guides/aks/aks-triage-practices.md): Systematic approach to troubleshooting AKS problems.

- [Backup and recovery for AKS](../operator-guides/aks/aks-backup-and-recovery.md): Protect your cluster configuration and workloads.

- [Patch and upgrade worker nodes](../operator-guides/aks/aks-upgrade-practices.md): Keep clusters secure and up-to-date.

- [Troubleshoot networking](../operator-guides/aks/troubleshoot-network-aks.md): Diagnose and resolve network problems.

- [Monitor AKS by using Azure Monitor](/azure/aks/monitor-aks): Collect and analyze telemetry from your clusters.

### Container architectures

The following production-ready architectures demonstrate end-to-end container solutions that you can deploy and customize.

Foundational AKS architectures that cover baseline production setups, multiple-region resiliency, security front ends, and multitenancy patterns:

- [AKS baseline cluster](../reference-architectures/containers/aks/baseline-aks.yml): Production-ready baseline architecture for AKS.

- [AKS baseline for multiple-region clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml): Deploy AKS across multiple regions for HA.

- [Secure AKS workloads by using Azure Front Door](../example-scenario/aks-front-door/aks-front-door.yml): Global load balancing and security for AKS.

- [Multitenancy that uses AKS and Application Gateway Ingress Controller (AGIC)](../example-scenario/aks-agic/aks-agic.yml): Multitenant architectures that use AGIC.

Architectures and pipelines for designing, deploying, and operating microservices workloads on AKS and Kubernetes:

- [Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml): Design and deploy microservices on AKS.

- [Advanced microservices on AKS](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml): Advanced patterns for complex microservices workloads.

- [CI/CD for microservices on Kubernetes](../microservices/ci-cd-kubernetes.md): Build robust CI/CD pipelines for Kubernetes microservices.

Architecture tailored for regulated industries or alternative Kubernetes platforms:

- [Use Azure Red Hat OpenShift in the financial services industry](../reference-architectures/containers/aro/azure-redhat-openshift-financial-services-workloads.yml): OpenShift for regulated financial workloads.

### Container solution ideas

The following container solution ideas demonstrate implementation patterns and possibilities to explore:

- [Data streaming that uses AKS](../solution-ideas/articles/data-streaming-scenario.yml): Real-time data streaming architectures that use AKS.

Azure Container Apps and Azure Container Instances provide serverless container platforms that abstract infrastructure management:

- [Microservices that use Container Apps](../example-scenario/serverless/microservices-with-container-apps.yml): Build microservices by using Container Apps.

- [Microservices that use Dapr and KEDA](../example-scenario/serverless/microservices-with-container-apps-dapr.yml): Event-driven microservices that use Dapr and KEDA on Container Apps.

