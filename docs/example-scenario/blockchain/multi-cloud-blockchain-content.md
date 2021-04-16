Blockchain and Distributed Ledger Technology (DLT) networks are multi-party systems. Each party can have its own tools, methodology, and cloud provider.

Cloud providers' blockchain services can provide infrastructure management, but might require all parties to be in the same cloud or infrastructure, or might have limited region availability, scalability, or network segregation.

If several parties join forces to build a blockchain network, parties that use different cloud providers and infrastructures need a common management platform. This platform must offer standard visibility, operations, and compliance across a wide range of resources and locations, regardless of hosting infrastructure.

This article explores how the open-source Blockchain Automation Framework (BAF) and Azure Arc-enabled Kubernetes can build a cross-cloud blockchain solution that emphasizes control and portability.

## Potential use cases

This approach supports:

- Heterogeneous deployments in a multi-cloud, multi-owner model, where separate organizations own and manage each node.
- Central network status and compliance management and monitoring.

## Architecture

This solution provides a cloud-agnostic, multi-party DLT network. The scenario supports heterogenous deployments in a multi-cloud, multi-owner model. Each owner can host their nodes anywhere and still be part of the network.

![Diagram showing a three-party blockchain network with each party using a different cloud provider, managed and monitored through BAF and Azure Arc.](media/multi-cloud-blockchain-network.png)

1. The example uses three parties. Party A uses [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes), Party B uses [GCP Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine), and Party C uses [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/). Each party hosts their nodes in a different location.
   
1. [Kubernetes](https://kubernetes.io/) is the standard infrastructure that hosts both the ledger and the application. This example assumes three managed Kubernetes clusters, one each in AKS, Amazon EKS, and GCP GKE.
   
1. [Blockchain Automation Framework (BAF)](https://blockchain-automation-framework.readthedocs.io/) deploys the distributed networks across public and private clouds.

1. While BAF manages deployments, it doesn't provide for central infrastructure management and monitoring. [Azure Arc enabled Kubernetes](/azure/azure-arc/kubernetes/overview) centrally manages and monitors the Kubernetes clusters in all locations.
   
   Azure Arc enabled Kubernetes supports the following scenarios:
   
   - [GitOps-based cluster configuration deployment and management](/azure/azure-arc/kubernetes/conceptual-configurations).
   - Cluster viewing and monitoring with [Azure Monitor Container insights](/azure/azure-monitor/containers/container-insights-analyze).
   - Policy deployment, monitoring, and reporting with [Azure Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes).
   
1. [Azure DevOps](https://dev.azure.com/) provides application and infrastructure lifecycle management. [Ansible Controller on an Azure Linux virtual machine (VM)](https://azuredevopslabs.com/labs/vstsextend/ansible/) acts as the custom continuous integration and continuous delivery (CI/CD) agent for Azure DevOps.
   
1. [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) stores and shares private, application-related container images. [Docker Registry](https://docs.docker.com/registry/) pulls ledger-specific images.

### Components

- [Kubernetes](https://kubernetes.io/) is the standard infrastructure that hosts both the ledger and the application. This example assumes three managed Kubernetes clusters, one each in AKS, Amazon EKS, and GCP GKE. You can host your cluster almost anywhere.
  
- [Blockchain Automation Framework (BAF)](https://blockchain-automation-framework.readthedocs.io/) provides a consistent means for developers to deploy production-ready distributed networks across public and private clouds. BAF supports [Quorum](https://consensys.net/quorum/), [Corda](https://www.corda.net/), and [Hyperledger](https://www.hyperledger.org/) DLTs.
  
- [Azure Arc enabled Kubernetes](/azure/azure-arc/kubernetes/overview) centrally manages Kubernetes clusters in any location. Azure Arc-enabled Kubernetes works with any Cloud Native Computing Foundation (CNCF)-certified Kubernetes cluster, including AKS engine on Azure, AKS engine on Azure Stack Hub, GKE, EKS, and VMware vSphere clusters.
  
- [Azure Monitor](https://azure.microsoft.com/services/monitor/) is a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. [Azure Monitor Container insights](/azure/azure-monitor/containers/container-insights-overview) monitors the performance of container workloads deployed to Azure Arc enabled Kubernetes.

- [Azure Policy](https://azure.microsoft.com/services/azure-policy/) helps enforce organizational standards and assess compliance at scale. [Azure Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes) makes it possible to manage and report on the compliance state of all Azure Arc enabled Kubernetes clusters from one location.

- [Azure DevOps](https://dev.azure.com/) is a modern set of developer services that provide comprehensive application and infrastructure lifecycle management. Azure DevOps includes Azure Pipelines, Azure Boards, Azure Repos, Azure Artifacts, and Azure Test Plans.
  
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) lets you build, store, and manage container images and artifacts in a private registry for all types of container deployments.

## Considerations

For AKS best practices, see the [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). You can find similar guidance for other cloud providers.

### Availability and scalability

Although Azure Arc can manage and monitor Kubernetes clusters, each cluster must independently implement scalability, high availability, and disaster recovery capabilities.

### Security

- BAF uses [HashiCorp Vault](https://www.hashicorp.com/products/vault) for certificate and key storage. To use BAF, you need at least one Vault server. BAF recommends one Vault per organization for production-ready projects.

- [Ambassador API Gateway](https://www.getambassador.io/products/api-gateway/) manages cross-node communications.

- For internet connections, you can deploy a self-hosted, cloud-native API gateway through [Azure API Management](/azure/api-management/how-to-deploy-self-hosted-gateway-azure-kubernetes-service).

- Alternatively, you can use an [External DNS](https://github.com/kubernetes-sigs/external-dns) like [Azure DNS](https://azure.microsoft.com/services/dns).

- You can achieve private connections using Internet Protocol Security (IPSec) with tools like [Submariner](https://submariner.io/).

## Deploy this scenario

1. For this example, create managed Kubernetes clusters in AKS, GKE, and EKS, and onboard the clusters to Azure Arc:
   - [Onboard an existing cluster to Azure Arc](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/general/onboard_k8s/)
   - [Create and onboard Amazon Elastic Kubernetes Service](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/eks/eks_terraform/)
   - [Create and onboard Google Kubernetes Engine](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/gke/gke_terraform/)
1.  Follow steps for installing and configuring [BAF prerequisites](https://blockchain-automation-framework.readthedocs.io/en/latest/prerequisites.html).
1.  (Optional) [Create an Azure DevOps organization and project](/azure/devops/organizations/accounts/create-organization), and clone the BAF repo into the new Azure DevOps project.
1.  (Optional) Create an [Ansible Controller VM](https://azuredevopslabs.com/labs/vstsextend/ansible/) in Azure as the custom build agent to deploy BAF components.

## Pricing

To estimate Azure resources costs, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

## Next steps

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)
- [Azure Arc Jumpstart](https://azurearcjumpstart.io/)
- [Blockchain workflow application](/azure/architecture/solution-ideas/articles/blockchain-workflow-application)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)
- [Deploy Hyperledger Fabric consortium on Azure Kubernetes Service](/azure/blockchain/templates/hyperledger-fabric-consortium-azure-kubernetes-service)
- [CI/CD workflow using GitOps - Azure Arc enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-gitops-ci-cd)
- [Containers and container orchestrators for AWS professionals](/azure/architecture/aws-professional/compute#containers-and-container-orchestrators)
- [Containers and container orchestrators for GCP professionals](/azure/architecture/gcp-professional/services#containers-and-container-orchestrators)

