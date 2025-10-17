This reference architecture describes how Azure Arc extends Kubernetes cluster management and configuration across customer datacenters, edge locations, and multiple cloud environments.

## Architecture

:::image type="complex" border="false" source="./images/arc-hybrid-kubernetes.svg" alt-text="Diagram that shows an Azure Arc for Kubernetes topology." lightbox="./images/arc-hybrid-kubernetes.svg":::
   This architecture diagram shows various Azure services and their functionalities. Two icons that represent Azure Arc-enabled Kubernetes clusters are in a section that's labeled on-premises. Four icons that represent Azure Monitor, Azure Policy, and Azure Kubernetes Service (AKS) are in a section that's labeled Azure. The AKS icon appears two times. Arrows indicate a connection between the Azure section and the two Azure Arc-enabled Kubernetes clusters in the on-premises section. Arrows also indicate a connection between Azure Policy, the clusters in both the on-premises and Azure sections, and Azure Monitor.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/arc-hybrid-kubernetes.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

- **[Azure Arc-enabled Kubernetes][Azure Arc-enabled Kubernetes]:** Attach and configure Kubernetes clusters inside or outside of Azure by using Azure Arc-enabled Kubernetes. When a Kubernetes cluster is attached to Azure Arc, it's assigned an Azure Resource Manager ID and a managed identity.

- **[Azure Kubernetes Service (AKS)][AKS]:** Host Kubernetes clusters in Azure to reduce the complexity and operational overhead of Kubernetes cluster management.

- **[On-premises Kubernetes cluster][kubernetes]:** Attach Cloud Native Computing Foundation (CNCF)-certified Kubernetes clusters that are hosted in on-premises or non-Microsoft cloud environments.

- **[Azure Policy][Azure Policy]:** Deploy and manage policies for Azure Arc-enabled Kubernetes clusters.

- **[Azure Monitor][Azure Monitor]:** Observe and monitor Azure Arc-enabled Kubernetes clusters.

### Components

- [Azure Arc](/azure/azure-arc/overview) is a service that extends the Azure platform to enable building applications and services that can run across datacenters, at the edge, and in multicloud environments. In this architecture, Azure Arc serves as the foundational platform that enables centralized management and governance of Kubernetes clusters regardless of where they're hosted. It provides a unified control plane for hybrid and multicloud scenarios.

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed service for deploying and scaling Kubernetes clusters in Azure. In this architecture, AKS provides fully managed Kubernetes clusters within Azure. The clusters can be managed alongside on-premises and other cloud clusters through the same Azure Arc control plane, which reduces operational complexity.

- [Azure Policy](/azure/governance/policy/overview) is a service that enables real-time cloud compliance at scale with consistent resource governance. In this architecture, Azure Policy provides centralized policy management and enforcement across all Arc-enabled Kubernetes clusters. It helps ensure consistent governance, security, and compliance policies whether clusters are running in Azure, on-premises, or in other clouds.

- [Azure Monitor](/azure/azure-monitor/overview) is a comprehensive monitoring solution that provides end-to-end observability for applications, infrastructure, and networks. In this architecture, Azure Monitor delivers unified monitoring and observability across all Kubernetes clusters in the hybrid environment. It collects metrics, logs, and performance data from both Azure-hosted and Azure Arc-enabled clusters for centralized analysis and alerting.

## Scenario details

You can use Azure Arc to register Kubernetes clusters that are hosted outside of Microsoft Azure. You can then use Azure tools to manage these clusters and AKS-hosted clusters.

### Potential use cases

Typical uses for this architecture include:

- Managing inventory, grouping, and tagging for on-premises Kubernetes clusters and AKS-hosted clusters.

- Using Azure Monitor to monitor Kubernetes clusters across hybrid environments.

- Using Azure Policy to help deploy and enforce policies for Kubernetes clusters across hybrid environments.

- Using Azure Policy to help deploy and enforce GitOps.

- Maximizing your on-premises graphics processing unit (GPU) investment by training and deploying Azure Machine Learning workflows.

- Using Azure Monitor managed service for Prometheus and Managed Grafana to monitor and visualize Kubernetes workloads.

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Cluster registration

You can register any active CNCF Kubernetes cluster. You need a `kubeconfig` file to access the cluster and a cluster-admin role on the cluster to deploy Azure Arc-enabled Kubernetes agents. Use the Azure CLI to perform cluster registration tasks. The user or service principal that you use for the `az login` and `az connectedk8s connect` commands requires Read and Write permissions on the `Microsoft.Kubernetes/connectedClusters` resource type. The Kubernetes Cluster - Azure Arc Onboarding role has these permissions and can be used for role assignments on either the user principal or the service principal. Helm 3 is required to onboard the cluster that uses the `connectedk8s` extension. The Azure CLI version 2.3 or later is required to install the Azure Arc-enabled Kubernetes CLI extensions.

#### Azure Arc agents for Kubernetes

Azure Arc-enabled Kubernetes consists of a few agents (or *operators*) that run in the cluster that's deployed to the `azure-arc` namespace:

- The `deployment.apps/config-agent` watches the connected cluster for source control configuration resources that are applied on the cluster and updates the compliance state.

- The `deployment.apps/controller-manager` is an operator of operators that orchestrates interactions between Azure Arc components.

- The `deployment.apps/metrics-agent` collects metrics from other Azure Arc agents to ensure that these agents perform optimally.

- The `deployment.apps/cluster-metadata-operator` gathers cluster metadata, including the cluster version, node count, and Azure Arc agent version.

- The `deployment.apps/resource-sync-agent` synchronizes the previously mentioned cluster metadata to Azure.

- The `deployment.apps/clusteridentityoperator` maintains the Managed Service Identity certificate that's used by other agents to communicate with Azure.

- The `deployment.apps/flux-logs-agent` collects logs from the flux operators that are deployed as a part of source control configuration.

- The `deployment.apps/extension-manager` installs and manages the lifecycle of extension Helm charts.

- The `deployment.apps/kube-aad-proxy` handles authentication for requests sent to the cluster via the AKS cluster connect feature.

- The `deployment.apps/clusterconnect-agent` is a reverse proxy agent that enables the cluster connect feature to provide access to the API server of the cluster. It's an optional component that's deployed only if the cluster connect feature is enabled on the cluster.

- The `deployment.apps/guard` is an authentication and authorization webhook server that's used for Microsoft Entra role-based access control (RBAC). It's an optional component that's deployed only if Azure role-based access control (Azure RBAC) is enabled on the cluster.

- The `deployment.apps/extension-events-collector` collects logs related to extensions lifecycle management. It aggregates these logs into events that correspond to each operation, such as Create, Upgrade, and Delete.  

- The `deployment.apps/logcollector` collects platform telemetry to help ensure the operational health of the platform.

For more information, see [Connect an existing Kubernetes cluster to Azure Arc][Connect an existing Kubernetes cluster to Azure Arc].

### Monitor clusters by using Azure Monitor container insights

Monitoring your containers is crucial. Azure Monitor container insights provides robust monitoring capabilities for AKS and AKS engine clusters. You can also configure Azure Monitor container insights to monitor Azure Arc-enabled Kubernetes clusters that are hosted outside of Azure. This configuration provides comprehensive monitoring of your Kubernetes clusters across Azure, on-premises, and in non-Microsoft cloud environments.

Azure Monitor container insights provides performance visibility by collecting memory and processor metrics from controllers, nodes, and containers. These metrics are available in Kubernetes through the Metrics API. Container logs are also collected. After you enable monitoring from Kubernetes clusters, a containerized version of the Log Analytics agent automatically collects metrics and logs. Metrics are written to the metrics store, and log data is written to the logs store that's associated with your Log Analytics workspace. For more information, see [Azure Monitor features for Kubernetes monitoring][Azure Monitor features for Kubernetes monitoring].

You can enable Azure Monitor container insights for one or more deployments of Kubernetes by using a PowerShell script or a Bash script.

For more information, see [Enable monitoring for Kubernetes clusters][Enable monitoring for Kubernetes clusters].

### Use Azure Policy to enable GitOps-based application deployment

Use Azure Policy to make sure that each GitOps–enabled `Microsoft.Kubernetes/connectedclusters` resource or `Microsoft.ContainerService/managedClusters` resource has specific `Microsoft.KubernetesConfiguration/fluxConfigurations` applied on it. For example, you can apply a baseline configuration to one or more clusters, or deploy specific applications to multiple clusters. To use Azure Policy, choose a definition from the [Azure Policy built-in definitions for Azure Arc-enabled Kubernetes][Azure Policy built-in definitions for Azure Arc-enabled Kubernetes] and then create a policy assignment. When you create the policy assignment, set the scope to an Azure resource group or subscription. Also set the parameters for the `fluxConfiguration` that's created. When the assignment is created, the Azure Policy engine identifies all `connectedCluster` or `managedCluster` resources that are in scope and then applies the `fluxConfiguration` to each resource.

If you use multiple source repositories for each cluster, such as one repository for the central IT or cluster operator and other repositories for application teams, activate this feature by using multiple policy assignments and configure each policy assignment to use a different source repository.

For more information, see [Deploy applications consistently at scale by using Flux v2 configurations and Azure Policy][Deploy applications at scale].

### Deploy applications by using GitOps

GitOps is the practice of defining the desired state of Kubernetes configurations, such as deployments and namespaces, in a source repository. This repository can be a Git or Helm repository, Buckets, or Azure Blob Storage. This process is followed by a polling and pull-based deployment of these configurations to the cluster by using an operator.

The connection between your cluster and one or more source repositories is enabled by deploying the `microsoft.flux` extension to your cluster. The `fluxConfiguration` resource properties represent where and how Kubernetes resources should flow from the source repository to your cluster. The `fluxConfiguration` data is stored encrypted at rest in an Azure Cosmos DB database to help ensure data confidentiality.

The `flux-config` agent that runs in your cluster monitors for new or updated `fluxConfiguration` extension resources on the Azure Arc-enabled Kubernetes resource, deploys applications from the source repository, and propagates all updates that are made to the `fluxConfiguration`. You can create multiple `fluxConfiguration` resources by using the `namespace` scope on the same Azure Arc-enabled Kubernetes cluster to achieve multi-tenancy.

The source repository can contain any valid Kubernetes resources, including Namespaces, ConfigMaps, Deployments, and DaemonSets. It can also contain Helm charts for deploying applications. Common source repository scenarios include defining a baseline configuration for your organization that can include common RBAC roles and bindings, monitoring agents, logging agents, and cluster-wide services.

You can also manage a larger collection of clusters that are deployed across heterogeneous environments. For example, you can have one repository that defines the baseline configuration for your organization, and then apply that configuration to multiple Kubernetes clusters simultaneously. You can also deploy applications to a cluster from multiple source repositories.

For more information, see [Deploy applications by using GitOps with Flux v2][Deploy applications by using GitOps with Flux v2].

### Run Machine Learning

In Machine Learning, you can choose an AKS (or Azure Arc-enabled Kubernetes) cluster as a compute target for your machine learning processes. This capability enables you to train or deploy machine learning models in your own, self-hosted (or multicloud) infrastructure. This approach allows you to combine your on-premises investments on GPUs with the ease of management that Machine Learning provides in the cloud.

### Monitor Kubernetes workloads with managed Prometheus and Grafana

Azure Monitor provides a managed service for both Prometheus and Grafana deployments, so that you can take advantage of these popular Kubernetes monitoring tools. This managed service allows you to use these tools without the need to manage and update the deployments yourself. To analyze Prometheus' metrics, use the [metrics explorer with PromQL](/azure/azure-monitor/essentials/metrics-explorer). 

### Topology, network, and routing

Azure Arc agents require the following protocols, ports, and outbound URLs to function.

|Endpoint (DNS)|Description|
| -------------|-------------|
|`https://management.azure.com:443`|Required for the agent to connect to Azure and register the cluster.|
|`https://[region].dp.kubernetesconfiguration.azure.com:443`|Data plane endpoint for the agent to push status and fetch configuration information, where [region] represents the Azure region that hosts the AKS instance.|
|`https://docker.io:443`|Required to pull container images.|
|`https://github.com:443`, `git://github.com:9418`|Example GitOps repos are hosted on GitHub. The configuration agent requires connectivity to the git endpoint that you specify.|
|`https://login.microsoftonline.com:443`, `https://<region>.login.microsoft.com`, `login.windows.net`|Required to fetch and update Azure Resource Manager tokens.|
|`https://mcr.microsoft.com:443` `https://*.data.mcr.microsoft.com:443`|Required to pull container images for Azure Arc agents. |

For a complete list of URLs across Azure Arc services, see [Azure Arc network requirements][Azure Arc network requirements].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- In most scenarios, the location that you choose when you create the installation script should be the Azure region that's geographically closest to your on-premises resources. The rest of the data is stored within the Azure geography that contains the region you specify. This detail might affect your choice of region if you have data residency requirements. If an outage affects the Azure region that your machine is connected to, the outage doesn't affect the connected machine, but management operations that use Azure might not complete. If you have multiple locations that provide a geographically redundant service, connect the machines in each location to a different Azure region. This practice improves resiliency if a regional outage occurs. For more information, see [Supported regions for Azure Arc-enabled Kubernetes][Supported regions].

- You should ensure that the [services](#components) in your solution are supported in the region where Azure Arc is deployed.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- You can use Azure RBAC to manage access to Azure Arc-enabled Kubernetes across Azure and on-premises environments that use Microsoft Entra identities. For more information, see [Use Azure RBAC for Kubernetes Authorization][Use Azure RBAC for Kubernetes Authorization].

- Microsoft recommends that you use a service principal that has limited privileges to onboard Kubernetes clusters to Azure Arc. This practice is useful in continuous integration and continuous delivery pipelines such as Azure Pipelines and GitHub Actions. For more information, see [Create an Azure Arc-enabled onboarding service principal][Create an Azure Arc-enabled onboarding service principal].

- To simplify service principal management, you can use managed identities in AKS. However, clusters must be created by using the managed identity. The existing clusters, which include Azure and on-premises clusters, can't be migrated to managed identities. For more information, see [Use a managed identity in AKS][Use a managed identity in AKS].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For general cost considerations, see [Cost Optimization design principles][Principles of cost optimization].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Before you configure your Azure Arc-enabled Kubernetes clusters, review the Azure Resource Manager [subscription limits][subscription limits] and [resource group limits][resource group limits] to plan for the number of clusters.

- Use Helm, which is an open-source packaging tool, to install and manage the Kubernetes application lifecycles. Similar to Linux package managers such as APT and Yum, use Helm to manage Kubernetes *charts*, which are packages of preconfigured Kubernetes resources.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Pieter de Bruin](https://www.linkedin.com/in/pieterjmdebruin) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Arc documentation][Azure Arc]
- [Azure Arc-enabled Kubernetes documentation][Azure Arc-enabled Kubernetes]
- [AKS documentation][AKS]
- [Azure Policy documentation][Azure Policy]
- [Azure Monitor documentation][Azure Monitor]
- [Connect an existing Kubernetes cluster to Azure Arc][Connect an existing Kubernetes cluster to Azure Arc]

## Related resources

Related hybrid guidance:

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)

Related architectures:

- [Baseline architecture for AKS on Azure Local](../example-scenario/hybrid/aks-baseline.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](../hybrid/azure-arc-sql-server.yml)

[AKS]: /azure/aks
[Azure Arc]: /azure/azure-arc
[Azure Arc-enabled Kubernetes]: /azure/azure-arc/kubernetes
[Azure Arc network requirements]: /azure/azure-arc/network-requirements-consolidated
[Azure Monitor]: /azure/azure-monitor
[Azure Monitor features for Kubernetes monitoring]: /azure/azure-monitor/insights/container-insights-overview
[Azure Policy]: /azure/governance/policy
[Azure Policy built-in definitions for Azure Arc-enabled Kubernetes]: /azure/azure-arc/kubernetes/policy-reference
[Connect an existing Kubernetes cluster to Azure Arc]: /azure/azure-arc/kubernetes/quickstart-connect-cluster
[Create an Azure Arc-enabled onboarding service principal]: /azure/azure-arc/servers/onboard-service-principal#create-a-service-principal-for-onboarding-at-scale
[Deploy applications at scale]: /azure/azure-arc/kubernetes/use-azure-policy-flux-2
[Deploy applications by using GitOps with Flux v2]: /azure/azure-arc/kubernetes/tutorial-use-gitops-flux2
[Enable monitoring for Kubernetes clusters]: /azure/azure-monitor/containers/kubernetes-monitoring-enable
[Kubernetes]: https://kubernetes.io
[Principles of cost optimization]: /azure/well-architected/cost-optimization/principles
[Resource group limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-resource-group-limits
[Subscription limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#azure-subscription-limits
[Supported regions]: /azure/azure-arc/servers/overview#supported-regions
[Use Azure RBAC for Kubernetes Authorization]: /azure/aks/manage-azure-rbac
[Use a managed identity in AKS]: /azure/aks/use-managed-identity
