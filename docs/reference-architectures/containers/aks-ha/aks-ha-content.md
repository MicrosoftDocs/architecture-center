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

### Cluster Design

This reference architecture uses two cloud design patterns. [Geographical Node (geodes)](/azure/architecture/patterns/geodes), where any region can service any request, and [Deployment Stamps](/azure/architecture/patterns/deployment-stamp) where the multiple copies of an application component are deployed from a single source (deployment template). 

**Geographical Node pattern considerations:**

When selecting geographical regions for each individual AKS cluster, consider utilizing paired Azure regions. Paired regions consist of two regions within the same geography which influence how Azure maintenance is performed. As your cluster scales beyond two regions, continue to plan for regional pair placement for each pair of AKS clusters. For more information on pared regions, see [Azure Paired Regions](azure/best-practices-availability-paired-regions).

Within each individual region, the members of the AKS node pool are spread across multiple availability zones to help prevent issues due to zonal failures. AKS availability zones are specified during deployment and cannot be updated once deployed. AKS has a limited set of regional support for availability zones, which influences regional cluster placement. For more information on AKS and Availability zones, including a list of supported regions, see [AKS Availability Zones](/azure/aks/availability-zones).


**Deployment stamp considerations**

< add content >

### Cluster deployment and configuration

When deploying multiple Kubernetes clusters in highly available and geographically distributed configurations, it is essential to consider the sum of each Kubernetes cluster as a single unit. You will want to develop code-driven strategies for automated deployment and configuration to ensure that the configuration of each individual cluster is as identical as possible. You will want to consider strategies for scaling out and in by adding or removing individual clusters. Finally, you want to think through regional failure and ensure that any byproduct of a failure is compensated for in your deployment and configuration plan.

Each of these topics is discussed in this section of this document.

#### Deployment

You have many options for deploying an Azure Kubernetes Service cluster. The Azure portal, Azure CLI, Azure PowerShell module are all decent options for deploying individual or non-coupled AKS clusters. These tools, however, can present some challenges when working with many tightly coupled AKS clusters. For example, using the Azure portal opens the opportunity for miss-configuration due to missed steps. As well, the deployment and configuration of many clusters using the portal is a timely process requiring the focus of one or more engineers. While you can construct a repeatable and automated process using the command line tools, the onus of things like idempotency, deployment failure control, and failure recovery is on you and the scripts you build. 

We recommend using infrastructure as code solutions, such and Azure Resource Manager templates, Bicep templates or Terraform configurations. Infrastructure as code solutions will provide an automated, scalable, and idempotent deployment solution. This reference architecture includes an ARM Template for the solutions shared services and then another for the AKS clusters + regional services.

Example parameter file used to deploy an AKS cluster into the centralus region. Multiple parameter files can be provided, one for each region into which an ASK cluster needs to be created.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "location": {
        "value": "centralus"
      },
      "targetVnetResourceId": {
        "value": "<cluster-spoke-vnet-resource-id>"
      },
      "appInstanceId": {
        "value": "04"
      },
      "clusterAdminAadGroupObjectId": {
        "value": "<azure-ad-aks-admin-group-object-id>"
      },
      "k8sControlPlaneAuthorizationTenantId": {
        "value": "<tenant-id-with-user-admin-permissions>"
      },
      "clusterInternalLoadBalancerIpAddress": {
        "value": "10.244.4.4"
      },
      "logAnalyticsWorkspaceId": {
        "value": "<log-analytics-workspace-id>"
      },
      "containerRegistryId": {
        "value": "<container-registry-id>"
      },
      "acrPrivateDnsZonesId": {
        "value": "<acrPrivateDns-zones-id>"
      }
    }
  }
```

< Now discuss deployment pipelines >

```yaml
- name: Azure CLI - Deploy AKS cluster - Region 1
    id: aks-cluster-region1
    if: success() && env.DEPLOY_REGION1 == 'true'
    uses: Azure/cli@v1.0.0
    with:
    inlineScript: |
        az group create --name rg-bu0001a0042-03 --location eastus2
        az deployment group create --resource-group rg-bu0001a0042-03 \
        --template-file "cluster-stamp.json" \
            --parameters @azuredeploy.parameters.eastus2.json \
            appGatewayListenerCertificate=${{ secrets.APP_GATEWAY_LISTENER_REGION1_CERTIFICATE_BASE64 }} \
            aksIngressControllerCertificate=${{ secrets.AKS_INGRESS_CONTROLLER_CERTIFICATE_BASE64 }}
```

#### Configuration

#### Scale considerations

#### Avalibility and failure

Application failure
Zonal failure
Regional failure


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

### Avalibility / Failover

| Application Component | Supporting service | Interface | Documentation |
|---|---|---|---|
| Application pods regional | Deployment / Replica Set | Kubernetes Deployment API | Kubernetes docs |
| Application pods global | Horizontal Pod Autoscaler | Kubernetes HPA API | Kubernetes docs, AKS docs |
| AKS node pool regional (zonal failure) | Azure Availability Zones | Availability Zones API | AKS docs |
| AKS node pools global (regional failure) | Azure Front Door | Azure Front Door API | Front Door docs |

### Cost considerations

- TDB