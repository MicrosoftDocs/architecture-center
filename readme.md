# Multi-cloud Distributed Ledger (DLT)

Blockchain and DLT networks are multi-party systems. Each party has
their own tools, methodology and probably preferred cloud provider.
Although cloud Blockchain-as-a-service offerings (BaaS) can save a lot
of Infrastructure management efforts, it sometimes assumes that all parties will be
in the same Cloud or you may have limited region availability, scale or network segrargation.

If you want to build cross-cloud blockchain solutions with more control and portability in mind , this is what this article is trying to explore.

## Potential use cases

Imagine two parties join forces to build a blockchain network between
them. 'Party A' uses Azure, and "Party B" uses their own private cloud
infrastructure or other cloud provider.

In this scenario, managed blockchain is only useful if all party join
the same infrastructure. For these scenarios, we need to build a
standard platform across different infrastructure.

This platform must have standard visibility, operations, and compliance
across a wide range of resources and locations regardless of the hosting
infrastructure.

The benefits of using this approach are:

-   Supports heterogeneous deployments in a multi-cloud, multi-owner
    model where each node is completely owned and managed by separate
    organizations.

-   Centrally manage and monitor the Network status and compliance.

## Architecture

This reference Architecture provides a cloud agnostic & multi-party DLT
Network. It Supports heterogeneous deployments in a multi-cloud,
multi-owner model where each owner can host their nodes anywhere but be
part of the network.

This architecture uses a three-party example, each party host their
nodes in different location. As below:

-   Party A: Uses Azure Kubernetes Service.

-   Party B: Uses GCP GKE.

-   Party C: Uses AWS EKS.

<p align="center">
  <img src="images/MultiCloud-DLT.svg">
</p>


### Components

[Kubernetes](https://kubernetes.io/) as the standard infrastructure to
host both the Ledger and the Application.

-   This architecture assumes you have three managed Kubernetes clusters
    in [Azure
    AKS](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes),
    AWS EKS and GCP GKE already. You can have your cluster virtually
    anywhere.

Blockchain Automation Framework (BAF). BAF provides a consistent means
by which developers can deploy production-ready distributed networks
across public and private cloud providers.

-   BAF is a great framework for managing the deployment but it doesn't
    cater for central infrastructure management and monitoring.

-   BAF currently support the following DLT: Quorum, Corda &
    Hyperledger.

[Azure Arc enabled
Kubernetes](https://docs.microsoft.com/en-gb/azure/azure-arc/kubernetes/overview)
to centrally manage Kubernetes clusters in any location.

-   Azure Arc enabled Kubernetes works with any Cloud Native Computing
    Foundation (CNCF) certified Kubernetes cluster such as AKS-engine on
    Azure, AKS-engine on Azure Stack Hub, GKE, EKS and VMware vSphere
    cluster.

[Ambassador API](https://www.getambassador.io/) Gateway for cross-node
communication.

[HashiCorp Vault](https://www.hashicorp.com/products/vault). BAF use it
as the certificate and key storage solution; so to use BAF, at least one
Vault server should be available. BAF recommends one Vault per
organization for production-ready projects.

Shared Artifacts:

-   [Azure DevOps](https://dev.azure.com/) to provide Application &
    Infrastructure and lifecycle management.

-   [Ansible Controller on an Azure Linux VM](https://azuredevopslabs.com/labs/vstsextend/ansible/). This will be used as custom
    CI/CD agent on Azure DevOps.

-   Docker container registry: to pull ledger specific images.

-   Azure Container registry. To store & share private
    application-related container images.

## Considerations

Although Kubernetes clusters can be managed and monitor via Azure Arc,
each cluster must cater for High availability, scalability, and disaster
recovery independently.

For Azure AKS best practices, we recommend considering [AKS
Baseline](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks).
Similar best practices guidance can be found for other cloud providers.

### Security

Cross-node communication but you may use cloud native API Gateway over
internet. You may use cloud native API Gateway like [Azure API
Management](https://docs.microsoft.com/en-us/azure/api-management/how-to-deploy-self-hosted-gateway-azure-kubernetes-service)
or alternatively use
[External-DNS](https://github.com/kubernetes-sigs/external-dns) like
[AzureDNS](https://azure.microsoft.com/en-us/services/dns).

Private Connection can also be achieved over IPSec with tools like
\[Submariner\](<https://github.com/submariner-io/submariner)>)

## Deploy this scenario

1.  Create managed Kubernetes clusters. In this scenario, create one cluster in AKS, GKE and EKS.

2.  Onboard clusters to Azure Arc

      - [Onboard existing Cluster to Azure Arc](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/general/onboard_k8s/)

      - [Create & Onboard Amazon Elastic Kubernetes Service](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/eks/eks_terraform/)

      - [Create & Onboard Google Kubernetes Engine](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/gke/gke_terraform/)

3.  Follow steps for installing and configuring [BAF
    Prerequisites](https://blockchain-automation-framework.readthedocs.io/en/latest/prerequisites.html). 
    
4.  (Optional) [Create an Azure DevOps Org and
    project](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=azure-devops) then clone BAF repo into the new Azure DevOps project.

5.  (Optional) Create and [Ansible Controller VM in
    Azure](https://azuredevopslabs.com/labs/vstsextend/ansible/). This will be the custom build agent used to deply BAF components.


## Pricing

For Azure Resources costs, you can use [Azure pricing
calculator](https://azure.microsoft.com/en-gb/pricing/calculator/).

Note: Azure Arc enabled Kubernetes In the current preview phase. Azure
Arc enabled Kubernetes is offered at no additional cost.
