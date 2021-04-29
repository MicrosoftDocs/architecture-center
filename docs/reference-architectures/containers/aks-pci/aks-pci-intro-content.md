This reference architecture describes the considerations for an Azure Kubernetes Service (AKS) cluster designed to run a sensitive workload. The guidance is tied to the regulatory requirements of the Payment Card Industry Data Security Standard (PCI-DSS). 

## Shared responsibility model

**Microsoft Trust Center** provides specific principles for compliance-related cloud deployments. The security assurances&mdash;provided by Azure as the cloud platform and AKS as the host container&mdash;are regularly audited and attested by third-party auditors for PCI DSS compliance.

<placeholder art>

![Shared responsibility model](images\shared-responsibility.png)

- **Shared responsibility with Azure**

	The Microsoft Compliance team ensures all documentation of Microsoft Azure regulatory compliance is publicly available to our customers. Microsoft Azure’s PCI DSS Attestation of Compliance can be downloaded under the PCI DSS section at [audit reports](https://servicetrust.microsoft.com). The responsibility matrix outlines who, between Azure and the customer, is responsible for each of the PCI requirements. For more information, see [Managing compliance in the cloud](https://www.microsoft.com/trust-center/compliance/compliance-overview).

- **Shared responsibility with AKS**

	Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications. AKS makes it simple to deploy a managed Kubernetes cluster on Azure. The AKS fundamental infrastructure supports large-scale applications in cloud and is a natural choice for running enterprise-scale applications in the cloud, including PCI workloads. Applications deployed in AKS clusters have certain complexities when deploying PCI classified workloads.

As a workload owner, you're ultimately responsible for your own PCI DSS compliance. Have a clear understanding of your responsibilities by, reading the PCI requirements to understand the intent; studying the matrix for Azure; completing this series to understand the AKS nuances. This process will make your implementation ready for a successful assessment.

## Recommended learning approach
The [PCI audit report](https://servicetrust.microsoft.com) is great place to start, to understand the shared responsibility between Azure and you. This series aims to fill the gaps between the current PCI DSS responsibility matrix and what a PCI deployment would require on AKS. 

This series is split into several articles. Each article outlines the high-level PCI requirement and provides guidance about how to address AKS-specific requirement.

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
This series is focused on the infrastructure and _not_ the workload. The recommendations and examples are extracted from this accompanying reference implementation:

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does _not_ represent or implement an actual PCI DSS workload.

### Workload isolation
The main theme of the PCI standard is to isolate the PCI workload from other workloads in terms of operations and connectivity. In this series we differentiate between those concepts as:

- In-scope&mdash;The PCI workload, the environment in which it resides, and operations.

- Out-of-scope&mdash;Other workloads that may share services but are isolated from the in-scope components.

The key strategy is to provide the required level of  segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. The down side is increased costs for the added infrastructure and the maintenance overhead. Another approach is to colocate all components in a shared cluster. Use segmentation strategies to maintain the separation. 

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has  two sets of services; one set has in-scope pods and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate nodes and they never share a node VM.

> [!IMPORTANT]
>
> The reference architecture and implementation have not been certified by an official authority. By completing this series and deploying the code assets, you do not clear audit for PCI DSS. Acquire compliance attestations from third-party auditors.

## Next

Install and maintain a firewall configuration to protect cardholder data. Do not use vendor-supplied defaults for system passwords and other security parameters.

> [!div class="nextstepaction"]
> [Build and Maintain a Secure Network and Systems](aks-pci-network.yml)
	
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																							
