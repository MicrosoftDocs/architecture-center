

This reference architecture demonstrates how Azure Arc extends Kubernetes cluster management and configuration across customer data centers, edge locations, and multiple cloud environments. You can use Azure Arc to register Kubernetes clusters hosted outside of Microsoft Azure, and use Azure tools to manage these clusters alongside clusters hosted in Azure Kubernetes Service (AKS).
![An Azure Arc for Kubernetes topology diagram.][Architecture diagram]

*Download a [Visio file][Architecture visio] of this architecture.*

Typical uses for this architecture include:

- Managing on-premises Kubernetes clusters alongside clusters hosted in AKS for inventory, grouping, and tagging.
- Monitoring Kubernetes clusters across hybrid environments using Azure Monitor.
- Deploying and enforcing policies for Kubernetes clusters across hybrid environments using Azure Policy.
- Deploying and enforcing GitOps using Azure Policy.

## Architecture

The architecture consists of the following components:

- **[Azure Arc enabled Kubernetes][Azure Arc enabled Kubernetes]**. Attach and configure Kubernetes clusters inside or outside of Azure by using Azure Arc enabled Kubernetes. When a Kubernetes cluster is attached to Azure Arc, it is assigned an Azure Resource Manager ID and a managed identity.
- **[Azure Kubernetes Service][Azure Kubernetes Service]**. Host Kubernetes clusters in Azure, reducing the complexity and operational overhead of Kubernetes cluster management.
- **[On-premises Kubernetes cluster][kubernetes]**. Attach Cloud Native Computing Foundation (CNCF)-certified Kubernetes clusters hosted in on-premises or third-party cloud environments.
- **[Azure Policy][Azure Policy]**. Deploy and manage policies for Arc enabled Kubernetes clusters.
- **[Azure Monitor][Azure Monitor]**. Observe and monitor Arc enabled Kubernetes clusters.

## Recommendations

The following sections are recommendations that apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Cluster registration

You can register any CNCF Kubernetes cluster that is running. You'll need a **kubeconfig** file to access the cluster and cluster-admin role on the cluster for deploying Arc-enabled Kubernetes agents. You'll use Azure Command-Line Interface (Azure CLI) to perform cluster registration tasks. The user or service principal used with the **az login** and **az connectedk8s connect** commands must have the Read and Write permissions on the Microsoft.Kubernetes/connectedClusters resource type. The Kubernetes Cluster - Azure Arc Onboarding role has these permissions and can be used for role assignments on either the user principal or the service principal. Helm 3 is required for onboarding the cluster using the connectedk8s extension. Azure CLI version 2.3 or later is required to install the Azure Arc-enabled Kubernetes command-line interface extensions.

#### Azure Arc agents for Kubernetes

Azure Arc enabled Kubernetes consists of a few agents (also referred to as *operators*) that run in the cluster deployed to the **azure-arc** namespace:

- **deployment.apps/config-agent**. Watches the connected cluster for source control configuration resources applied on the cluster, and updates the compliance state.
- **deployment.apps/controller-manager**. An operator of operators that orchestrates interactions between Azure Arc components.
- **deployment.apps/metrics-agent**. Collects metrics from other Arc agents to ensure that these agents are exhibiting optimal performance.
- **deployment.apps/cluster-metadata-operator**. Gathers cluster metadata, cluster version, node count, and Azure Arc agent version.
- **deployment.apps/resource-sync-agent**. Syncs the previously mentioned cluster metadata to Azure.
- **deployment.apps/clusteridentityoperator**. Maintains the Managed Service Identity (MSI) certificate used by other agents to communicate with Azure.
- **deployment.apps/flux-logs-agent**. Collects logs from the flux operators deployed as a part of source control configuration.

For more information, refer to [Connect an Azure Arc-enabled Kubernetes cluster][Connect an Azure Arc-enabled Kubernetes cluster].

### Monitoring clusters using Azure Monitor for containers

Monitoring your containers is critical. Azure Monitor for containers provides a rich monitoring experience for the AKS and AKS engine clusters. You can also configure Azure Monitor for containers to monitor Azure Arc enabled Kubernetes clusters hosted outside of Azure. This provides comprehensive monitoring of your Kubernetes clusters across Azure, on-premises, and third-party cloud environments.

Azure Monitor for containers can provide you with performance visibility by collecting memory and processor metrics from controllers, nodes, and containers available in Kubernetes through the Metrics application programming interface (API). Container logs are also collected. After you enable monitoring from Kubernetes clusters, metrics and logs are automatically collected for you through a containerized version of the Log Analytics agent. Metrics are written to the metrics store and log data is written to the logs store associated with your Log Analytics workspace. For more information about Azure Monitor for containers, refer to  [Azure Monitor for containers overview][Azure Monitor for containers overview].

You can enable Azure Monitor for containers for one or more existing deployments of Kubernetes by using either a PowerShell or a Bash script.

To enable monitoring for Arc enabled Kubernetes clusters, refer to [Enable monitoring of Azure Arc enabled Kubernetes cluster][Enable monitoring of Azure Arc enabled Kubernetes cluster]

### Using Azure Policy to apply cluster configuration

Use Azure Policy to enforce that each **Microsoft.Kubernetes/connectedclusters** resource or Git-Ops–enabled **Microsoft.ContainerService/managedClusters** resource has specific **Microsoft.KubernetesConfiguration/sourceControlConfigurations** applied on it. For example, you can apply a baseline configuration to one or more clusters, or deploy specific applications to multiple clusters. To use Azure Policy, select a definition from the [Azure Policy built-in definitions for Azure Arc enabled Kubernetes][Azure Policy built-in definitions for Azure Arc enabled Kubernetes], and then create a policy assignment.

 When creating the policy assignment, set the scope to an Azure resource group or subscription. Also set the parameters for the **sourceControlConfiguration** that will be created. When the assignment is created, the Policy engine will identify all **connectedCluster** or **managedCluster** resources that are located within the scope, and then apply the **sourceControlConfiguration** to each.

If you are using multiple GitHub repos for each cluster (for example, one repo for the central IT/cluster operator and other repos for application teams), activate this by using multiple policy assignments, with each policy assignment configured to use a different Git repo.

For more information, refer to [Use Azure Policy to apply cluster configurations at scale][Use Azure Policy to apply cluster configurations at scale].

### Deploying and enforcing GitOps using Azure Policy

GitOps is the practice of declaring the desired state of Kubernetes configuration (deployments, namespaces, and so on) in a Git repository. This is followed by a polling and pull-based deployment of these configurations to the cluster using an operator. Azure Policy and Flux work together to provide GitOps on Azure Arc enabled Kubernetes clusters.

The connection between your cluster and one or more Git repositories is tracked in Azure Resource Manager as a **sourceControlConfiguration** extension resource. The **sourceControlConfiguration** resource properties represent where and how Kubernetes resources should flow from Git to your cluster. The **sourceControlConfiguration** data is stored encrypted at rest in an Azure Cosmos DB database to ensure data confidentiality.

The **config-agent** running in your cluster is responsible for watching for new or updated **sourceControlConfiguration** extension resources on the Azure Arc enabled Kubernetes resource, deploying a flux operator to watch the Git repository, and propagating any updates made to the **sourceControlConfiguration**. It's even possible to create multiple **sourceControlConfiguration** resources with the **namespace** scope on the same Azure Arc enabled Kubernetes cluster to achieve multi-tenancy. In such a case, each operator can only deploy configurations to its respective namespace.

The Git repository can contain any valid Kubernetes resources, including Namespaces, ConfigMaps, Deployments, and DaemonSets.  It might also contain Helm charts for deploying applications. Common Git repository scenarios include defining a baseline configuration for your organization, which might include common role-base access control (RBAC) roles and bindings, monitoring or logging agents, or cluster-wide services.

You can also manage a larger collection of clusters, which might be deployed across heterogeneous environments. For example, you might have one repository that defines the baseline configuration for your organization, and then apply that to multiple Kubernetes clusters simultaneously. Azure policy can automate creation of a **sourceControlConfiguration** with a specific set of parameters on all Azure Arc enabled Kubernetes resources under a scope (subscription or resource group).

For more information, refer to [Deploy configurations using GitOps on an Arc enabled Kubernetes cluster][Deploy configurations using GitOps on an Arc enabled Kubernetes cluster].

### Topology, network, and routing

Azure Arc agents require the following protocols/ports/outbound URLs to function:

|Endpoint (DNS)|Description|
| -------------|-------------|
|`https://management.azure.com:443`|Required for the agent to connect to Azure and register the cluster.|
|`https://[region].dp.kubernetesconfiguration.azure.com:443`|Data plane endpoint for the agent to push status and fetch configuration information, where [region] represents the Azure region that hosts the AKS instance.|
|`https://docker.io:443`|Required to pull container images.|
|`https://github.com:443`, `git://github.com:9418`|Example GitOps repos are hosted on GitHub. The configuration agent requires connectivity to whichever git endpoint you specify.|
|`https://login.microsoftonline.com:443`|Required to fetch and update Azure Resource Manager tokens.|
|`https://azurearcfork8s.azurecr.io:443`|Required to pull container images for Azure Arc agents.

## Availability considerations

- In most cases, the location you select when you create the installation script should be the Azure region geographically closest to your on-premises resources. The rest of the data will be stored within the Azure geography containing the region you specify. This might also affect your choice of region if you have data residency requirements. If an outage affects the Azure region to which your machine is connected, the outage will not affect the connected machine, but management operations using Azure might not be able to complete. For resilience in the event of a regional outage, if you have multiple locations that provide a geographically-redundant service, it's best to connect the machines in each location to a different Azure region. For available regions, consult [Supported regions][Supported regions] for Azure Arc enabled Kubernetes.
- You should ensure that services referenced in the **Architecture** section are supported in the region to which Azure Arc is deployed.

## Manageability considerations

- Before configuring your Azure Arc-enabled Kubernetes clusters, review the Azure Resource Manager [Subscription limits][subscription limits] and [Resource group limits][resource group limits] to plan for the number of clusters.

## DevOps Considerations

- Use Helm, the open-source packaging tool, to install and manage the Kubernetes application life cycles. Similar to Linux package managers such as APT and Yum, Helm is used to manage Kubernetes *charts*, which are packages of preconfigured Kubernetes resources. For more information, refer to [Deploy Helm Charts using GitOps on Arc enabled Kubernetes cluster][Deploy Helm Charts using GitOps on Arc enabled Kubernetes cluster].

## Security considerations

- You can use Azure RBAC to manage access to Azure Arc enabled Kubernetes across Azure and on-premises environments using Azure Active Directory (Azure AD) identities. For more information, refer to [Use Azure RBAC for Kubernetes Authorization][Use Azure RBAC for Kubernetes Authorization].
- We recommend using a service principal with limited privileges for onboarding Kubernetes clusters to Azure Arc. This is useful in CI/CD pipelines such as Azure Pipelines and GitHub Actions. For more information, refer to [Create an Azure Arc-enabled onboarding Service Principal][Create an Azure Arc-enabled onboarding Service Principal].
- To simplify service principal management, you can use managed identities in AKS. However, clusters must be created using the managed identity and existing clusters (including Azure and on-premises clusters) can't be migrated to managed identities. For more information, refer to [Use managed identities in Azure Kubernetes Service][Use managed identities in Azure Kubernetes Service].

## Cost considerations

- General cost considerations are described in the [Principles of cost optimization][Principles of cost optimization] section in the Microsoft Azure Well-Architected Framework.

## Next steps

* [Learn more about Azure Arc enabled Kubernetes][Azure Arc enabled Kubernetes]
* [Learn more about Azure Kubernetes Service][Azure Kubernetes Service]
* [Learn more about Azure Policy][Azure Policy]
* [Learn more about Azure Monitor][Azure Monitor]
* [Connect an Azure Arc-enabled Kubernetes cluster][Connect an Azure Arc-enabled Kubernetes cluster]

[Architecture diagram]: ./images/arc-hybrid-kubernetes.png
[Architecture visio]: https://arch-center.azureedge.net/arc-hybrid-kubernetes.vsdx
[Azure Arc enabled Kubernetes]: /azure/azure-arc/kubernetes/
[Azure Container Instances]: /azure/container-instances/container-instances-overview
[Azure Kubernetes Service]: /azure/aks/
[Azure Policy]: /azure/governance/policy/
[Azure Monitor]: /azure/azure-monitor/
[Connect an Azure Arc-enabled Kubernetes cluster]: /azure/azure-arc/kubernetes/connect-cluster
[Use Azure RBAC for Kubernetes Authorization]: /azure/aks/manage-azure-rbac
[Create an Azure Arc-enabled onboarding Service Principal]: /azure/azure-arc/servers/onboard-service-principal
[Azure Monitor for containers overview]: /azure/azure-monitor/insights/container-insights-overview
[Enable monitoring of Azure Arc enabled Kubernetes cluster]: /azure/azure-monitor/insights/container-insights-enable-arc-enabled-clusters?toc=%252fazure%252fazure-arc%252ftoc.json
[Azure Policy built-in definitions for Azure Arc enabled Kubernetes]: /azure/azure-arc/kubernetes/policy-samples
[Use Azure Policy to apply cluster configurations at scale]: /azure/azure-arc/kubernetes/use-azure-policy
[Deploy configurations using GitOps on an Arc enabled Kubernetes cluster]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[Supported regions]: /azure/azure-arc/kubernetes/overview#supported-regions
[Subscription limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#subscription-limits
[resource group limits]: /azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits
[Deploy Helm Charts using GitOps on Arc enabled Kubernetes cluster]: /azure/azure-arc/kubernetes/use-gitops-with-helm
[Use managed identities in Azure Kubernetes Service]: /azure/aks/use-managed-identity
[Principles of cost optimization]: ../framework/cost/overview.md
[kubernetes]: https://kubernetes.io
