This reference architecture describes the considerations for an Azure Kubernetes Service (AKS) cluster designed to run a sensitive workload. The guidance is tied to the regulatory requirements of the Payment Card Industry Data Security Standard (PCI-DSS). 

This series aims to get you started with your PCI-DSS infrastructure setup. It's _not_ our goal to replace your preparation for audit or self attestation with this series. Use this architecture and its implementation as a way to design your approach for fulfilling PCI-DSS requirements.

> [!IMPORTANT]
>
> The reference architecture and implementation have not been certified by an official authority. By completing this series and deploying the code assets, you do not clear audit for PCI DSS. Acquire compliance attestations from third-party auditors.

## Before you begin...

### Understand the shared responsibility model

**Microsoft Trust Center** provides specific principles for compliance-related cloud deployments. The security assurances&mdash;provided by Azure as the cloud platform and AKS as the host container&mdash;are regularly audited and attested by third-party auditors for PCI DSS compliance.

![Diagram of the shared responsibility model.](images\protection-everyone.svg)

- **Shared responsibility with Azure**

	The Microsoft Compliance team ensures all documentation of Microsoft Azure regulatory compliance is publicly available to our customers. You can download the PCI DSS Attestation of Compliance for Azure under the PCI DSS section at [audit reports](https://servicetrust.microsoft.com). The responsibility matrix outlines who, between Azure and the customer, is responsible for each of the PCI requirements. For more information, see [Managing compliance in the cloud](https://www.microsoft.com/trust-center/compliance/compliance-overview).

- **Shared responsibility with AKS**

	Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications. AKS makes it simple to deploy a managed Kubernetes cluster on Azure. The AKS fundamental infrastructure supports large-scale applications in the cloud, and is a natural choice for running enterprise-scale applications in the cloud, including PCI workloads. Applications deployed in AKS clusters have certain complexities when deploying PCI-classified workloads.

As a workload owner, you're ultimately responsible for your own PCI DSS compliance. Have a clear understanding of your responsibilities by reading the PCI requirements to understand the intent, studying the matrix for Azure, and completing this series to understand the AKS nuances. This process will make your implementation ready for a successful assessment.

### Recommended articles
This series assumes:
- You're familiar with Kubernetes concepts and workings of an [AKS cluster](/azure/aks).
- You've read the [AKS baseline reference architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks).
- You've deployed the [AKS baseline reference implementation](https://github.com/mspnp/aks-secure-baseline).
- You're well versed with the official [PCI DSS specification](https://www.pcisecuritystandards.org/documents/PCI_DSS_v3-2-1.pdf). 
- You've read the [Azure security baseline for Azure Kubernetes Service](/security/benchmark/azure/baselines/aks-security-baseline).

## In this series

This series is split into several articles. Each article outlines the high-level PCI requirement, and provides guidance about how to address the AKS-specific requirement.

|Area of responsibility|Description|
|---|---|
|[Network segmentation](aks-pci-network.yml)|Protect cardholder data with firewall configuration and other network controls. Remove vendor-supplied defaults.|
|[Data protection](aks-pci-data.yml)|Encrypt all information, storage objects, containers, and physical media. Add security controls when data that is being transferred between components.|
|[Vulnerability management](aks-pci-malware.yml)|Run antivirus software, file integrity monitoring tools, and container scanners to make sure the system as part of your vulnerability detection. |
|[Access controls](aks-pci-identity.yml)|Secure access through identity controls that deny attempts to the cluster or other components that are part of the cardholder data environment.|
|[Monitoring operations](aks-pci-monitor.yml)|Maintain the security posture through monitoring operations and regularly test your security design and implementation.|
|[Policy management](aks-pci-policy.yml)|Maintain thorough and updated documentation about your security processes and policies.|





	
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																
																							
