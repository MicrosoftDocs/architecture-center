Blockchain and Distributed Ledger Technology (DLT) networks are multi-party systems. Each party can have its own tools, methodology, and cloud provider. Although cloud providers' blockchain services can provide infrastructure management, they might require all parties to be in the same cloud or infrastructure. Blockchain service offerings might have limited region availability, scalability, or network segregation.

If several parties join forces to build a blockchain network, parties that use different cloud providers and infrastructures need a common management platform. This platform should offer standard visibility, operations, and compliance across a wide range of resources and locations, regardless of hosting infrastructure.

The open-source [Blockchain Automation Framework (BAF)](https://blockchain-automation-framework.readthedocs.io/) is a consistent way to deploy production-ready distributed networks across public and private clouds. But while BAF can manage deployments, it doesn't provide central infrastructure management and monitoring. This article explores how [Azure Arc enabled Kubernetes](/azure/azure-arc/kubernetes/overview) and the BAF can build a cross-cloud blockchain solution featuring portability and control.

## Potential use cases

This approach supports:

- Heterogeneous DLT deployments where separate organizations own and manage each node.

- Centralized deployment, monitoring, and compliance management across multi-party networks.

## Architecture

This solution provides a heterogeneous, multi-party, cloud-agnostic DLT network. Each party can host their nodes anywhere and still be part of the network.

![Diagram showing a three-party blockchain network with each party using a different cloud provider, managed and monitored through BAF and Azure Arc.](media/multi-cloud-blockchain-network.png)

1. [Kubernetes](https://kubernetes.io/) is the standard infrastructure that hosts both the ledger and the application. This example assumes three managed Kubernetes clusters.
   - Party A uses [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes).
   - Party B uses [GCP Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine).
   - Party C uses [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/).
   
   Each party hosts their nodes in a different location.
   
1. BAF deploys the distributed networks across the three cloud services.
   
1. Azure Arc enabled Kubernetes centrally manages and monitors all the Kubernetes clusters, with:
   
   - [GitOps-based cluster configuration deployment and management](/azure/azure-arc/kubernetes/conceptual-configurations).
   - [Azure Monitor Container insights](/azure/azure-monitor/containers/container-insights-analyze) monitoring.
   - [Azure Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes) policy management.
   
1. [Azure DevOps](https://dev.azure.com/) provides application and infrastructure lifecycle management. An [Ansible Controller on an Azure Linux virtual machine (VM)](https://azuredevopslabs.com/labs/vstsextend/ansible/) is the custom Azure DevOps continuous integration and continuous delivery (CI/CD) agent.
   
1. [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) stores and shares private, application-related container images. [Docker Registry](https://docs.docker.com/registry/) pulls ledger-specific images.

### Components

- [Kubernetes](https://kubernetes.io/) is the container-based infrastructure that hosts both the ledger and applications. This example assumes three managed Kubernetes clusters, one each in AKS, Amazon EKS, and GCP GKE. You can host your Kubernetes cluster almost anywhere.
  
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/services/kubernetes-service/) is a fully managed Kubernetes service that offers serverless Kubernetes, an integrated CI/CD experience, and enterprise-grade security and governance.
  
- The open-source [Blockchain Automation Framework (BAF)](https://blockchain-automation-framework.readthedocs.io/) is a way to deliver consistent, production-ready DLT networks on public and private cloud-based infrastructures. BAF supports [Quorum](https://consensys.net/quorum/), [Corda](https://www.corda.net/), and [Hyperledger](https://www.hyperledger.org/) DLTs.
  
- [Azure Arc](https://azure.microsoft.com/services/azure-arc/) standardizes visibility, operations, and compliance across resources and locations by extending the Azure control plane.
  
- [Azure Arc enabled Kubernetes](/azure/azure-arc/kubernetes/overview) centrally manages Kubernetes clusters in any location. Azure Arc-enabled Kubernetes works with any Cloud Native Computing Foundation (CNCF)-certified Kubernetes cluster, including AKS engine on Azure, AKS engine on Azure Stack Hub, GKE, EKS, and VMware vSphere clusters.
  
- [Azure Monitor](https://azure.microsoft.com/services/monitor/) is a comprehensive solution for collecting, analyzing, and acting on telemetry. [Azure Monitor Container insights](/azure/azure-monitor/containers/container-insights-overview) monitors the performance of container workloads deployed to Azure Arc enabled Kubernetes clusters.

- [Azure Policy](https://azure.microsoft.com/services/azure-policy/) helps enforce organizational standards and assess compliance at scale. [Azure Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes) can manage and report on the compliance state of all Azure Arc enabled Kubernetes clusters.
  
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) can build, store, and manage container images and artifacts for all types of container deployments.
  
- [Azure DevOps](https://azure.microsoft.com/services/devops/) is a set of developer services that provide comprehensive application and infrastructure lifecycle management. Azure DevOps includes work tracking, source control, build and CI/CD, package management, and testing services.

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
https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/aks/
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

