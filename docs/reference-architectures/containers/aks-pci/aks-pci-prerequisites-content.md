This reference architecture describes the considerations for an Azure Kubernetes Service (AKS) cluster designed to run a workload that handles credit card payment. The guidance is tied to the regulatory requirements of the Payment Card Industry Data Security Standard (PCI-DSS). 

## Shared responsibility model

**Microsoft Trust Center** provides specific principles for compliance-related cloud deployments. The security assurances&mdash;provided by Azure as the cloud platform and AKS as the host container&mdash;are regularly audited and attested by third-party auditors for PCI DSS compliance.

The Microsoft Compliance team works hard to ensure that all documentation of Microsoft Azure regulatory compliance is publicly available to our customers. Microsoft Azure’s 2020 PCI DSS 3.2.1 Attestation of Compliance can be downloaded under the PCI section at [audit reports](https://servicetrust.microsoft.com). The responsibility matrix outlines who, between Azure and the customer, is responsible for each of the PCI requirements.  

For more information, see [Managing compliance in the cloud](https://www.microsoft.com/trust-center/compliance/compliance-overview).


As a workload owner, you're ultimately responsible for your own PCI DSS compliance. Have a clear understanding of your responsibilities by reading the PCI requirements to understand their intent, studying the matrix for Azure so that the implementation is ready for a successful assessment.


## Recommended learning approach

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications. Azure Kubernetes Service (AKS) makes it simple to deploy a managed Kubernetes cluster in Microsoft Azure. The AKS fundamental infrastructure supports large scale applications in cloud and is a natural choice to run enterprise-scale  applications in cloud, including PCI workloads. Make sure that PCI DSS compliance is followed appropriately.

The [PCI audit report](https://servicetrust.microsoft.com) is great place to start in understanding the shared responsibity between Azure and you. Applications deployed to AKS typically have complexities and nuances when deploying PCI classified workloads. This series aims to fill the gaps between the current PCI DSS 3.2.1 responsibility matrix and what a PCI deployment would require on AKS. Each article outlines the high level PCI requirement and provides guidance about how to address AKS-specific requirement.

|Area of responsibility|Description|
|---|---|
|[Network segmentation](aks-pci-network.yml)|TBD |
|[Data protection](aks-pci-data.yml)|TBD|
|[Vulnerability management](aks-pci-malware.yml)|TBD|
|[Access controls](aks-pci-identity.yml)|TBD|
|[Monitoring operations](aks-pci-monitor.yml)|TBD|
|[Policy management](aks-pci-policy.yml)|TBD|

This series assumes:
- You're familiar with Kubernetes concepts and workings of an [AKS cluster](/azure/aks).
- You've read the [AKS baseline reference architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks).
- You've deployed the [AKS baseline reference implementation](https://github.com/mspnp/aks-secure-baseline).
- You're well versed with the official [PCI DSS specification](https://www.pcisecuritystandards.org/documents/PCI_DSS_v3-2-1.pdf). 
- You've read the [Azure security baseline for Azure Kubernetes Service](/security/benchmark/azure/baselines/aks-security-baseline).

## Code assets
This series is focused on the infrastructure and _not_ the workload. The recommendations and examples are extracted from an accompanying reference implementation:

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

### Workload isolation
A main theme of the PCI standard is to isolate the PCI workload from other workloads in terms of operations and connectivity. In this series we differenciate between those concepts as:

- In-scope

    The PCI workload, the environment in which it resides, and operations.

- Out-of-scope
    Other workloads that may share services but are isolated from the in-scope components.

The key strategy is to provide the required level of  segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. The down side is increased costs for the additional infrastructure and the maintenance overhead. Another approach is to colocate the in-scope and out-of-scope components in a shared cluster. Use segmetation strategies to maintain the separation. 

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has  two sets of services; one set has in-scope pods and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate nodes and they never share a node VM.

> [!IMPORTANT]
>
> The reference architecture and implementation have not been certified by an official authority. By completing this series and deploying the code assets, you do not clear audit for PCI DSS. Acquire compliance attestations third-party auditors.

## Next

Understand how the cluster compute configuration differs from baseline architecture to create a regulated environment.

> [!div class="nextstepaction"]
> [Network segmentation](aks-pci-network.yml)
