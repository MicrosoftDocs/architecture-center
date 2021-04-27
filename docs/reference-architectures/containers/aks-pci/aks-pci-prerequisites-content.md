This reference architecture describes the considerations for an AKS cluster designed to run a workload that handles credit card payment. The guidance is tied to the regulatory requirements of the Payment Card Industry (PCI) 
Data Security Standard (PCI-DSS 3.2.1). 

## Shared responsibility model

**Microsoft Trust Center** provides specific principles for compliance-related cloud deployments. The security assurances, provided by Azure as the cloud platform and AKS as the host container are regularly audited and attested by third-party auditors for PCI DSS compliance.

As a workload owner, you have a shared responsibility with Azure in some scenarios, such as application of  controls and upkeep of the container. For other controls such as data management, you are fully responsible. 

![Microsoft Trust Center - shared responsibility model](images/shared-responsibility.png)

Have a clear understanding of your responsibilities by studying the PCI DSS Shared Responsibility Matrix for Azure. This information is available in PCI DSS section of the [audit reports](https://servicetrust.microsoft.com/ViewPage/MSComplianceGuideV3). 

For more information, see these articles:

- [Managing compliance in the cloud](https://www.microsoft.com/trust-center/compliance/compliance-overview)
- [Azure security baseline for Azure Kubernetes Service](/security/benchmark/azure/baselines/aks-security-baseline)

> [!IMPORTANT]
>
> The reference architecture and implementation have not been certified by an official authority. By completing this series and deploying the code assets, you do not clear audit for PCI DSS. Acquire compliance attestations third-party auditors.

## Recommended learning approach
This series assumes:
- You're familiar with Kubernetes concepts and workings of an [AKS cluster](/azure/aks).
- You've read the [AKS baseline reference architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks).
- You've deployed the [AKS baseline reference implementation](https://github.com/mspnp/aks-secure-baseline).
- You're well-versed with the official [PCI DSS specification](https://www.pcisecuritystandards.org/documents/PCI_DSS_v3-2-1.pdf). 

This series is focused on the infrastructure and _not_ the workload. The starting point for the infrastructure is the AKS baseline secure architecture. That infrastructure is modified 
to move away from public cloud access to a private enviroment with sufficient controls to meet the requirements of the standard. 

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation includes a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent any the best practices for regulated workloads.

## Content structure
This series is broken into serveral articles that is categorized by requirements in the PCI standard.
Each article is clearly specifies the PCI requirement and provides guidance from a shared responsibility perspective. 

|Area of responsibility|Description|
|---|---|
|[Network segmentation](aks-pci-network.yml)|TBD |
|[Data protection](aks-pci-data.yml)|TBD|
|[Vulnerability management](aks-pci-malware.yml)|TBD|
|[Access controls](aks-pci-identity.yml)|TBD|
|[Monitoring operations](aks-pci-monitor.yml)|TBD|
|[Policy management](aks-pci-policy.yml)|TBD|

## Next

Understand how the cluster compute configuration differs from baseline architecture to create a regulated envrioment.

> [!div class="nextstepaction"]
> [Introduction to the regulated cluster](aks-pci-intro.yml)
