This reference architecture shows how to run an Azure Kubernetes Service (AKS) cluster in multiple regions to achieve high availability.

This architecture builds on the [AKS Baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks), Microsoft's recommended starting point for AKS infrastructure. The AKS baseline details infrastructural features like Azure Active Directory (Azure AD) pod identity, ingress and egress restrictions, resource limits, and other secure AKS infrastructure configurations. These infrastructural details are not covered in this document. It is recommended that you become familiar with the AKS baseline before proceeding with the microservices content.

![Mutli-region deployment](images/aks-ha.svg)

![GitHub logo](../../../_images/github.png) A reference implementation of this architecture is available on [GitHub](https://github.com/mspnp/aks-baseline-multi-region).

## Components

Many components and Azure services are used in the multi-region AKS reference architecture. Only those with uniqueness to this multi-cluster architecture are listed below. For the remaining, please reference the [AKS Baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks).

- **Multiple clusters / multiple regions** Multiple AKS clusters are deployed, each in a separate Azure region. During normal operations, network traffic is routed between all regions. If one region becomes unavailable, traffic is routed to a region closest to the user who issued the request.
- **Azure Front Door** Azure Front door is used to load balance and route traffic to each AKS cluster in the configuration. Azure Front Door allows for layer seven global routing, both of which are required for this reference architecture.
- **Azure Application Gateway** Each cluster in the solution is configured with an Azure Application Gateway instance sitting in front of it. These components are configured as the back ends for the Azure Front Door instance. The cluster networking configuration is fully detailed later in this document.
- **DNS** Azure DNS resolves the Azure Front Door requests to the IP address associated with Application Gateway. 
- **Key store** Azure Key Vault is provisioned in each region.  
- **Container registry** The container images for the workload are stored in a managed container registry. There's a single instance. Geo-replication for Azure Container Registry is enabled. It will automatically replicate images to the selected Azure regions and provide continued access to images even if a region is experiencing an outage.

## Design considerations

Consider the following items when designing a multi-region AKS deployment.

### Cluster deployment and configuration

When deploying multiple Kubernetes clusters in highly available and geographically distributed configurations, it is essential to consider the sum of each Kubernetes cluster as a single unit. You will want to develop code-driven strategies for automated deployment and configuration to ensure that the configuration of each individual cluster is as identical as possible. You will want to consider strategies for scaling out and in by adding or removing individual clusters. Finally, you want to think through regional failure and ensure that any byproduct of a failure is compensated for in your deployment and configuration plan.

Each of these topics is discussed in this section of this document.

#### Deployment

You have many options for deploying an Azure Kubernetes Service cluster. The Azure portal, Azure CLI, Azure PowerShell module are all decent options for deploying individual or non-coupled AKS clusters. These tools, however, can present some challenges when working with many tightly coupled AKS clusters. For example, using the Azure portal opens a genuine opportunity for miss-configuration due to missed steps. As well, the deployment and configuration of many groups using the portal is a timely process requiring the focus of one or more engineers. While you can construct a repeatable and automated process using the command line tools, the onus of things like idempotency, deployment failure control, and failure recovery is on you and the scripts you build. 

We recommend using a true infrastructure as code solutions, such and Azure Resource Manager or Bicep templates, or Terraform configurations. Infrastructure as code solutions will provide an automated, scalable, and idempotent deployment solution.

#### Configuration

#### Scale considerations

#### Regional failure considerations

### Cluster management

- Consideration related to management (overview)
- Issues with manual management
- Options and benefit for automated management and configuration (GitOps)

### Traffic management

- Traffic considerations (overview)
- Traffic flow (RI)

### Shared resources

- Shared resource considerations (overview)
- Container Registry
- Log Analytics
- Azure Front Door

### Cluster access

- Access considerations (overview)
- Considerations related to one vs. multiple access control groups

### Data and state

- Detail that state is not considered in the RI
- Options and considerations for state

### Failover

- TBD

### Cost considerations

- TDB