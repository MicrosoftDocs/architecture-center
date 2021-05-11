This series is focused on the infrastructure and _not_ the workload. The recommendations and examples are extracted from this accompanying reference implementation:

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does _not_ represent or implement an actual PCI DSS workload.

## Dfferences from the AKS baseline architecture

This RI is built directly on top of the AKS Baseline, illustrating the promise that you can start with the AKS Baseline and evolve it into what you need it to be.

Key differentiators over Baseline:
- Private AKS API Server, with Azure Bastion-fronted ops access.
- Enhanced focus on Azure Defender for topic
- Introduction of Azure Sentinel into the solution, with call out to SIEMs in general
- Additional Azure Policy application
- Extended retention period on logs to match common 90-day requirements
    - Extended logging validation steps to help a customer acclimate to the logs emitted, including audit (-admin) logs and azure firewall logs
- Enhanced Azure Container Registry topics (Quarantine pattern, subnet-isolated task runner, for example)
- Addresses in-cluster ISV/OSS CNCF solutions like security agents (Falco, Prisma, etc, etc, etc)
- Zero-trust network policies (which are directly tested via violation attempts as part of the sample workload)
- mTLS throughout the sample workload (Baseline TLS was terminated at the ingress controller) – this is an example of something that goes beyond PCI requirements
    - This is implemented via OSM, not as a technology recommendation, but as an implementation detail – we call out plenty of CNCF alternatives there.
	Layer 7 network policies within the mesh, including Service Account-based auth.
    - TLS trust chain certification at all levels, so not just encrypted, but CA chain validated as well.
- Nodepool subnet isolation (for refined Firewall and NSG application), including extended NSGs on the nodepool subnets
- Flux v2 for GitOps (baseline is Flux v1)
- NGINX Ingress Controller (Baseline was Traefik.  This was NOT swapped out because of any technical reason, it was swapped out illustratively to show that customers can bring the solution that fits best for them, as is the promise [read: demand] of Kubernetes)
- Namespace Limits and Quotas
- Team/Organization Role suggestions (coming from the C12 project) and mapping to Azure AD.
- Followed by a list of further recommendations that cannot easily be presented in a “one size fits all that are going to be deploying this right from GitHub” solution
    - Encryption at Host
    - Azure AD Conditional Access Policies
    - RBAC JIT Access
    - Activating Azure Security center at scale (HT: @Yuri Diogenes for his tweet this morning with a link to the enterprise at-scale enrollment docs – perfectly timed!)
    - OCI artifact signing and validation (this is a stretch goal which we’d like to add before GA – Notary v2 + Azure Policy integration, where are you? 😊)
    - ACR BYOK Encryption
    - Azure DDoS (not specifically related to regulated)


### Workload isolation
The main theme of the PCI standard is to isolate the PCI workload from other workloads in terms of operations and connectivity. In this series we differentiate between those concepts as:

- In-scope&mdash;The PCI workload, the environment in which it resides, and operations.

- Out-of-scope&mdash;Other workloads that may share services but are isolated from the in-scope components.

The key strategy is to provide the required level of segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. The down side is increased costs for the added infrastructure and the maintenance overhead. Another approach is to colocate all components in a shared cluster. Use segmentation strategies to maintain the separation. 

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has  two sets of services; one set has in-scope pods and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate nodes and they never share a node VM.

> [!IMPORTANT]
>
> The reference architecture and implementation have not been certified by an official authority. By completing this series and deploying the code assets, you do not clear audit for PCI DSS. Acquire compliance attestations from third-party auditors.

## Next

Install and maintain a firewall configuration to protect cardholder data. Do not use vendor-supplied defaults for system passwords and other security parameters.

> [!div class="nextstepaction"]
> [Build and Maintain a Secure Network and Systems](aks-pci-network.yml)