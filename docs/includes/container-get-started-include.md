### Container guides

The following articles help you evaluate and select the best container technologies for your workload requirements:

- [Choose an Azure container service](../guide/choose-azure-container-service.md): Decision tree for selecting the right container platform.

- [Azure container service considerations](../guide/container-service-general-considerations.md): Detailed considerations for container service selection.

- [Choose a Kubernetes at the edge option](../operator-guides/aks/choose-kubernetes-edge-compute-option.md): Compare options for running Kubernetes at the edge.

- [Microservices architecture style](../guide/architecture-styles/microservices.md): Design principles for microservices.

- [Design a microservices architecture](../microservices/design/index.md): Step-by-step guidance for microservices design.

#### Kubernetes-based hosting

- [Get started with AKS](../reference-architectures/containers/aks-start-here.md): Introduction to AKS architecture and design.

##### Application

- [High availability (HA) for multitier AKS apps](../guide/aks/aks-high-availability.md): Design patterns for highly available AKS applications.

- [CI/CD for AKS apps via Azure Pipelines](../guide/aks/aks-cicd-azure-pipelines.md): Implement CI/CD for AKS.

- [GitOps for AKS](../example-scenario/gitops-aks/gitops-blueprint-aks.yml): Use GitOps practices to manage AKS deployments.

##### Infrastructure

- [Access an AKS API server](../security/access-azure-kubernetes-service-cluster-api-server.md): Secure access patterns for AKS API servers.

###### AKS day-2 operations guide

- [Introduction](../operator-guides/aks/day-2-operations-guide.md): Learn about AKS day-2 operations, such as triage, patching, upgrading, and troubleshooting.

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

- [Blue-green deployment of AKS clusters](../guide/aks/blue-green-deployment-for-aks.yml): Implement zero-downtime deployments by using blue-green strategies.

- [Firewall protection for an AKS cluster](../guide/aks/aks-firewall.md): Secure AKS clusters by using Azure Firewall.

- [Secure AKS workloads with Azure Front Door](../example-scenario/aks-front-door/aks-front-door.yml): Global load balancing and security for AKS.

- [Multitenancy with AKS and Application Gateway for Containers (AGC)](../example-scenario/aks-agic/aks-agc.yml): Use Application Gateway for Containers with your AKS cluster to expose microservice-based applications to the internet.

- [Use AKS to host GPU-based workloads](../reference-architectures/containers/aks-gpu/gpu-aks.md): Run GPU workloads on AKS for AI and machine learning scenarios.

### Container architectures

The following production-ready architectures demonstrate end-to-end container solutions that you can deploy and customize.

#### Kubernetes-based hosting

##### Application

- [Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml): Design and deploy microservices on AKS.

- [Advanced microservices on AKS](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml): Advanced patterns for complex microservices workloads.

##### Infrastructure

- [AKS baseline cluster](../reference-architectures/containers/aks/baseline-aks.yml): Production-ready baseline architecture for AKS.

- [AKS baseline for multiple-region clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml): Deploy AKS across multiple regions for HA.

- [Use Azure Red Hat OpenShift in the financial services industry](../reference-architectures/containers/aro/azure-redhat-openshift-financial-services-workloads.yml): OpenShift for regulated financial workloads.

- [CI/CD for microservices on Kubernetes](../microservices/ci-cd-kubernetes.md): Build robust CI/CD pipelines for Kubernetes microservices.

#### PaaS container hosting

Azure Container Apps and Azure Container Instances provide serverless container platforms that abstract infrastructure management:

- [Microservices that use Container Apps](../example-scenario/serverless/microservices-with-container-apps.yml): Build microservices by using Container Apps.

- [Microservices that use Dapr and KEDA](../example-scenario/serverless/microservices-with-container-apps-dapr.yml): Event-driven microservices that use Dapr and KEDA on Container Apps.

### Container solution ideas

The following container solution ideas demonstrate implementation patterns and possibilities to explore:

#### Kubernetes-based hosting

- [Data streaming that uses AKS](../solution-ideas/articles/data-streaming-scenario.yml): Real-time data streaming architectures that use AKS.
