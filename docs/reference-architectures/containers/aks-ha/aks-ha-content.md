This reference architecture shows how to run an Azure Kubernetes Service (AKS) cluster in multiple regions to achieve high availability.

This architecture builds on the [AKS Baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks), Microsoft's recommended starting point for AKS infrastructure. The AKS baseline details infrastructural features like Azure Active Directory (Azure AD) pod identity, ingress and egress restrictions, resource limits, and other secure AKS infrastructure configurations. These infrastructural details are not covered in this document. It is recommended that you become familiar with the AKS baseline before proceeding with the microservices content.

![GitHub logo](../../../_images/github.png) A reference implementation of this architecture is available on [GitHub](https://github.com/mspnp/aks-baseline-multi-region).

![Mutli-region deployment](images/aks-ha.svg)

## Components

Many components and Azure services are used in the multi-region AKS reference architecture. Only those specific to this architecture are listed below. For the remaining, please reference the [AKS Baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks).

**Multiple clusters / multiple regions** Multiple AKS clusters are deployed, each in a separate Azure region. During normal operations, network traffic is routed between all regions. If one region becomes unavailable, traffic is routed to a region closest to the user who issued the request.

**Azure Front Door** 

**DNS** Azure DNS resolves the Azure Front Door requests to the IP address associated with Application Gateway. 

**Key store** Azure Key Vault is provisioned in each region.  

**Container registry** The container images for the workload are stored in a managed container registry. There's a single instance. Geo-replication for Azure Container Registry is enabled. It will automatically replicate images to the selected Azure regions and provide continued access to images even if a region is experiencing an outage.

## Design considerations

Consider the following items when designing a multi-region AKS deployment.

### Cluster deployment

### Cluster management

### Shared resources

### Access controll

### Data and state

### Failover

### Cost considerations