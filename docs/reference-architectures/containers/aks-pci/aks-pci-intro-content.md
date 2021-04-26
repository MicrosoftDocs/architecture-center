This reference architecture describes the considerations for an AKS cluster designed to run a workload that handles credit card payment. The guidance is tied to the regulatory requirements of the  Payment Card Industry (PCI) 
Data Security Standard (PCI-DSS 3.2.1). 

## Recommended learning approach
This series assumes:
- You're familiar with Kubernetes concepts and workings of an AKS cluster.
- You've read the AKS baseline reference architecture.
- You've deployed the AKS baseline reference implementation.
- You're well-versed with the official PCI DSS specification. 

This series is focused on the infrastructure and _not_ the workload. The starting point for the infrastructure is the AKS baseline secure architecture. That infrastructure is modified 
to move away from public cloud access to a private enviroment with sufficient controls to meet the requirements of the standard. Those controls are demonstrated in the accompanying reference implementation. This implementation includes an microservices application. It's included to help you experience the infrastructure and illustrate network and security controls in place. The application does not represent any the best practices for regulated workloads.

## Content structure
This series is broken into serveral articles that is categorized by requirements in the PCI standard.
Each article is clearly specifies the PCI requirement. The guidance outlines the shared responsibility model starting with the affordances provided by, Azure as the cloud platform; AKS as the container; and you as the cluster and workload owner. 

|Area of responsibility|Description|
|---|---|
|[Network segmentation](aks-pci-network.yml)|TBD |
|[Data protection](aks-pci-data.yml)|TBD|
|[Vulnerability management](aks-pci-malware.yml)|TBD|
|[Access controls](aks-pci-identity.yml)|TBD|
|[Monitoring operations](aks-pci-monitor.yml)|TBD|
|[Policy management](aks-pci-policy.yml)|TBD|


<trust center>
<zero trust model>
<Azure assurances>
<AKS assurances>
<RA material>
<diagram>
<connection to baseline and worklaod>
<structure of this content>
<table of linked articles>