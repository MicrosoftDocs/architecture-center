### Select a container service

The following articles help you evaluate and select the best container technologies for your workload requirements:

- [Choose an Azure container service](../guide/choose-azure-container-service.md): Decision tree for selecting the right container platform.

- [Architectural considerations for choosing an Azure container service](../guide/container-service-general-considerations.md): Detailed considerations for container service selection.

- [Choose a Kubernetes at the edge option](../operator-guides/aks/choose-kubernetes-edge-compute-option.md): Compare options for running Kubernetes at the edge.

### Container guides

- [Microservices architecture style](../guide/architecture-styles/microservices.md): Design principles for microservices.

- [Design a microservices architecture](../microservices/design/index.md): Step-by-step guidance for microservices design.

### Kubernetes-based hosting

- [Azure Kubernetes Service (AKS) - Plan your design and operations](../reference-architectures/containers/aks-start-here.md): Start here to plan your AKS design and operations.

#### Kubernetes solution ideas

- [Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml): Real-time data streaming architectures that use AKS.

#### Kubernetes architectures

Use the recommendations in the following architectures when designing your workload:

##### Application architectures

- [Microservices architecture on Azure Kubernetes Service](../reference-architectures/containers/aks-microservices/aks-microservices.yml): Design and deploy microservices on AKS.

- [Advanced Azure Kubernetes Service (AKS) microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml): Advanced patterns for complex microservices workloads.

##### Infrastructure architectures

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../reference-architectures/containers/aks/baseline-aks.yml): Production-ready baseline architecture for AKS.

- [AKS baseline for multiregion clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml): Deploy AKS across multiple regions for HA.

- [Use Azure Red Hat OpenShift in the financial services industry](../reference-architectures/containers/aro/azure-redhat-openshift-financial-services-workloads.yml): OpenShift for regulated financial workloads.

- [Build a CI/CD pipeline for microservices on Kubernetes by using Azure DevOps and Helm](../microservices/ci-cd-kubernetes.md): Build robust CI/CD pipelines for Kubernetes microservices.

#### Kubernetes guides

The following guides provide recommendations on cross-cutting concerns in your Kubernetes workload:

##### Application guides

- [High availability for multitier AKS applications](../guide/aks/aks-high-availability.md): Design patterns for highly available AKS applications.

- [Build a CI/CD pipeline for AKS apps by using Azure Pipelines](../guide/aks/aks-cicd-azure-pipelines.md): Implement CI/CD for AKS.

- [GitOps for Azure Kubernetes Service](../example-scenario/gitops-aks/gitops-blueprint-aks.yml): Use GitOps practices to manage AKS deployments.

##### Infrastructure guides

- [Access an Azure Kubernetes Service (AKS) API server](../security/access-azure-kubernetes-service-cluster-api-server.md): Secure access patterns for AKS API servers.

- [Blue-green deployment of AKS clusters](../guide/aks/blue-green-deployment-for-aks.yml): Implement zero-downtime deployments by using blue-green strategies.

- [Use Azure Firewall to help protect an AKS cluster](../guide/aks/aks-firewall.md): Secure AKS clusters by using Azure Firewall.

- [Use Azure Front Door to secure AKS workloads](../example-scenario/aks-front-door/aks-front-door.yml): Global load balancing and security for AKS.

- [Use Application Gateway for Containers with a multitenant Azure Kubernetes Service cluster](../example-scenario/aks-agic/aks-agc.yml): Use Application Gateway for Containers with your AKS cluster to expose microservice-based applications to the internet.

- [Use Azure Kubernetes Service to host GPU-based workloads](../reference-architectures/containers/aks-gpu/gpu-aks.md): Run GPU workloads on AKS for AI and machine learning scenarios.

###### AKS day-2 operations guide

- [Azure Kubernetes Service (AKS) day-2 operations guide](../operator-guides/aks/day-2-operations-guide.md): Learn about AKS day-2 operations, such as triage, patching, upgrading, and troubleshooting.

**Triage practices**

- [Overview](../operator-guides/aks/aks-triage-practices.md): Systematic approach to troubleshooting AKS problems.

- [1. Cluster health](../operator-guides/aks/aks-triage-cluster-health.md): Check the overall health of an AKS cluster as part of a triage step.

- [2. Node and pod health](../operator-guides/aks/aks-triage-node-health.md): Examine the health of AKS worker nodes and pods and resolve problems.

- [3. Workload deployments](../operator-guides/aks/aks-triage-deployment.md): Check whether workload deployments and DaemonSet features are running properly.

- [4. Admission controllers](../operator-guides/aks/aks-triage-controllers.md): Verify that the admission controllers are working as expected.

- [5. Container registry connectivity](../operator-guides/aks/aks-triage-container-registry.md): Verify the connection to a container registry.

- [Backup and recovery for AKS](../operator-guides/aks/aks-backup-and-recovery.md): Protect your cluster configuration and workloads.

- [Patch and upgrade worker nodes](../operator-guides/aks/aks-upgrade-practices.md): Keep clusters secure and up-to-date.

- [Troubleshoot networking](../operator-guides/aks/troubleshoot-network-aks.md): Diagnose and resolve network problems.

- [Monitor AKS by using Azure Monitor](/azure/aks/monitor-aks): Collect and analyze telemetry from your clusters.

- [Common issues](/azure/aks/troubleshooting): Troubleshoot common AKS issues.

### PaaS container hosting

Azure Container Apps and Azure Container Instances provide serverless container platforms that abstract infrastructure management:

#### PaaS container architectures

- [Deploy microservices to Azure Container Apps](../example-scenario/serverless/microservices-with-container-apps.yml): Build microservices by using Container Apps.

- [Deploy microservices with Azure Container Apps and Dapr](../example-scenario/serverless/microservices-with-container-apps-dapr.yml): Event-driven microservices that use Dapr and KEDA on Container Apps.
