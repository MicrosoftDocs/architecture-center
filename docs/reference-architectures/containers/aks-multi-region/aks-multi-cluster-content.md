This architecture details how to run multiple instances of an Azure Kubernetes Service (AKS) cluster across multiple regions in an active/active and highly available configuration.

This architecture builds on the [AKS baseline architecture](../aks/baseline-aks.yml), Microsoft's recommended starting point for AKS infrastructure. The AKS baseline details infrastructural features like Microsoft Entra Workload ID, ingress and egress restrictions, resource limits, and other secure AKS infrastructure configurations. These infrastructural details aren't covered in this document. We recommend that you become familiar with the AKS baseline before proceeding with the multi-region content.

## Architecture

:::image type="complex" border="false" source="./images/aks-multi-cluster.svg#lightbox" alt-text="Architecture diagram showing multi-region deployment." lightbox="./images/aks-multi-cluster.svg":::
   The diagram illustrates a multi-region Azure architecture with two distinct regions (Region A and Region B) and shared resources. Each region contains a similar structure with hub and spoke virtual networks. In the hub networks of both regions, there are subnets containing Azure Bastion and Azure Firewall services. The spoke virtual networks in both regions contain AKS clusters, load balancers, and Application Gateway components, with bidirectional connections between them indicated by green arrows. Each region has a Key Vault with an Azure Container Registry replica in the spoke networks. In the lower portion of the diagram, there's an additional spoke virtual network containing the fleet hub cluster. Various colored dotted lines (green, red, purple, and blue) connect components across regions, indicating network traffic flows and service relationships. Log Analytics instances appear in both regions and in the shared resources section to the right. The shared resources area also includes Container Registry, Azure Front Door, and the AKS fleet, which connect to both regions through green dotted lines.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-multi-cluster.vsdx) of this architecture.*

## Components

Many components and Azure services are used in this multi-region AKS architecture. Only those components unique to this multi-cluster architecture are listed here. For the remaining, refer to the [AKS Baseline architecture](../aks/baseline-aks.yml).

- **Regional AKS clusters:** Multiple [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) clusters are deployed, each in a separate Azure region. During normal operations, network traffic is routed between all regions. If one region becomes unavailable, traffic is routed to a remaining region closest to the user who issued the request.
- **Regional hub-spoke networks:** A [regional hub-spoke virtual network](/azure/architecture/networking/architecture/hub-spoke) is deployed for each regional AKS instance. [Azure Firewall Manager](/azure/firewall-manager/overview) policies are used to manage firewall policies across all regions.
- **Regional key vault:** [Azure Key Vault](/azure/key-vault/general/overview) is provisioned in each region. Key vaults are used for storing sensitive values and keys specific to the AKS cluster and supporting services that are in that region.
- **Multiple log workspaces:** Regional [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics) workspaces are used for storing regional networking metrics and diagnostic logs. Additionally, a shared Log Analytics instance is used to store metrics and diagnostic logs for all AKS instances.
- **AKS fleet:** An [Azure Kubernetes Fleet Manager](/azure/kubernetes-fleet/concepts-fleet) is deployed to coordinate both Kubernetes cluster version updates and node image version updates across each of the regional AKS clusters.
- **Fleet hub cluster (Microsoft-managed):** *Optionally*, a single [Azure Kubernetes Fleet Manager hub cluster](/azure/kubernetes-fleet/concepts-fleet#what-are-hub-clusters) can be deployed to support specific features of fleets, such as workload propagation. The hub cluster is a regionally scoped Azure resource that helps to manage workload propagation and load balancing across multiple member clusters. It's best to deploy the hub cluster as a private hub cluster, which must be reachable from member clusters to support heartbeat signals and to perform configuration reconciliation processes.
- **Global Azure Front Door profile:** [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is used to load balance and route traffic to a regional Azure Application Gateway instance, which sits in front of each AKS cluster. Azure Front Door allows for layer 7 global routing, both of which are required for this architecture.
- **Global container registry:** The container images for the workload are stored in a managed container registry. In this architecture, a single Azure Container Registry is used for all Kubernetes instances in the cluster. Geo-replication for [Azure Container Registry](/azure/container-registry/container-registry-intro) enables replicating images to the selected Azure regions and providing continued access to images even if a region is experiencing an outage.

## Alternatives

This solution uses [Azure Kubernetes Fleet Manager](/azure/kubernetes-fleet/). Fleets enable a range of capabilities for managing multiple clusters, with a focus on reducing day-2 operational overhead by providing a control plane that can orchestrate activities across multiple clusters. The benefits of Fleet Manager increase as the number of clusters in your fleet grows.

In this solution, the fleet orchestrates Kubernetes version updates across multiple clusters, as well as node image version updates. These capabilities don't require a hub cluster to be deployed. You could choose to have each cluster perform Kubernetes version and node image updates independently, which doesn't require a fleet. However, if you do so, clusters are likely to get version updates at different times, and it can become difficult to validate your workload and configuration with multiple versions in your production environment simultaneously.

You can also optionally use a fleet for workload deployment coordination, which requires that you add a hub cluster. Workload deployments are discussed in more detail later in this article.

## Design patterns

This architecture uses two cloud design patterns:
- [Geodes (geographical nodes)](../../../patterns/geodes.yml), where any region can service any request.
- [Deployment Stamps](../../../patterns/deployment-stamp.yml), where multiple independent copies of an application or application component are deployed from a single source, such as a deployment template.

### Geode pattern considerations

When selecting regions to deploy each AKS cluster, consider regions close to the workload consumer or your customers. Also, consider utilizing [cross-region replication](/azure/reliability/cross-region-replication-azure). Cross-region replication asynchronously replicates the same applications and data across other Azure regions for disaster recovery protection. As your cluster scales beyond two regions, continue to plan for cross-region replication for each pair of AKS clusters.

Within each region, nodes in the AKS node pools are spread across multiple availability zones to help prevent issues due to zonal failures. Availability zones are supported in a limited set of regions, which influences regional cluster placement. For more information on AKS and availability zones, including a list of supported regions, see [AKS availability zones](/azure/aks/availability-zones).

### Deployment stamp considerations

When you manage a multi-region AKS solution, you deploy multiple AKS clusters across multiple regions. Each one of these clusters is considered a *stamp*. If there's a regional failure, or if you need to add more capacity or regional presence for your clusters, you might need to create a new stamp instance. When selecting a process for creating and managing deployment stamps, it's important to consider the following things:

- Select the appropriate technology for stamp definitions that allows for generalized configuration. For example, you might use Bicep for defining infrastructure as code.
- Provide instance-specific values using a deployment input mechanism such as variables or parameter files.
- Select deployment tooling that allows for flexible, repeatable, and idempotent deployment.
- In an active/active stamp configuration, consider how traffic is balanced across each stamp. This architecture uses Azure Front Door for global load balancing.
- As stamps are added and removed from the collection, consider capacity and cost concerns.
- Consider how to gain visibility of and monitor the collection of stamps as a single unit.

Each of these items is detailed with specific guidance in the following sections.   

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Cluster deployment and bootstrapping

When deploying multiple Kubernetes clusters in highly available and geographically distributed configurations, it's essential to consider the sum of each Kubernetes cluster as a coupled unit. You might want to develop code-driven strategies for automated deployment and configuration to ensure that each Kubernetes instance is as identical as possible. Consider strategies for scaling out and in, including by adding or removing other Kubernetes clusters. Your design, and deployment and configuration plan, should account for availability zone outages, regional failures, and other common scenarios.

#### Cluster definition

You have many options for deploying an Azure Kubernetes Service cluster. The Azure portal, the Azure CLI, and Azure PowerShell module are all decent options for deploying individual or noncoupled AKS clusters. These methods, however, can present challenges when working with many tightly coupled AKS clusters. For example, using the Azure portal opens the opportunity for misconfiguration due to missed steps or unavailable configuration options. The deployment and configuration of many clusters using the portal is a time-consuming process requiring the focus of one or more engineers. If you use the Azure CLI or Azure PowerShell, you can construct a repeatable and automated process using the command-line tools. However, the responsibility of idempotency, deployment failure control, and failure recovery is on you and the scripts you build.

When working with multiple AKS instances, we recommend considering infrastructure as code solutions, such as Bicep, Azure Resource Manager templates, or Terraform. Infrastructure as code solutions provide an automated, scalable, and idempotent deployment solution. For example, you might use one Bicep file for the solution's shared services, and another for the AKS clusters and other regional services. If you use infrastructure as code, a deployment stamp can be defined with generalized configurations such as networking, authorization, and diagnostics. A deployment parameter file can be provided with region-specific values. With this configuration, a single template can be used to deploy an almost identical stamp across any region.

The cost of developing and maintaining infrastructure as code assets can be costly. In some cases, the overhead of defining infrastructure as code might outweigh the benefits, such as when you have a very small (say, 2 or 3) and unchanging number of AKS instances. For these cases, it's acceptable to use a more imperative approach, such as with command-line tools or even manual approaches with the Azure portal.

#### Cluster deployment

After the cluster stamp is defined, you have many options for deploying individual or multiple stamp instances. Our recommendation is to use modern continuous integration technology such as GitHub Actions or Azure Pipelines. The benefits of continuous integration-based deployment solutions include:

- Code-based deployments that allow for stamps to be added and removed using code
- Integrated testing capabilities
- Integrated environment and staging capabilities
- Integrated secrets management solutions
- Integration with source control, for both application code and deployment scripts and templates
- Deployment history and logging
- Access control and auditing capabilities, to control who can make changes and under what conditions

As new stamps are added or removed from the global cluster, the deployment pipeline needs to be updated to stay consistent. One approach is to deploy each region's resources as an individual step within a GitHub Actions workflow. This configuration is straightforward because each cluster instance is clearly defined within the deployment pipeline. This configuration does include some administrative overhead in adding and removing clusters from the deployment.

Another option would be to create business logic to create clusters based on a list of desired locations or other indicating data points. For instance, the deployment pipeline could contain a list of desired regions; a step within the pipeline could then loop through this list, deploying a cluster into each region found in the list. The disadvantage to this configuration is the complexity in deployment generalization and that each cluster stamp isn't explicitly detailed in the deployment pipeline. The positive benefit is that adding or removing cluster stamps from the pipeline becomes a simple update to the list of desired regions.

Following the creation of a cluster, it needs to be enrolled into the fleet as a member cluster. This step can be completed by deploying a Resource Manager resource of type `Microsoft.ContainerService/fleets/members`, which references the member cluster's resource ID. After the member cluster is enrolled in the fleet, it can be added to update runs and use other fleet capabilities that you configure.

Also, removing a cluster stamp from the deployment pipeline doesn't always decommission the stamp's resources. Depending on your deployment solution and configuration, you might need an extra step to decommission the AKS instances and other Azure resources. Consider using [deployment stacks](/azure/azure-resource-manager/bicep/deployment-stacks) to enable full lifecycle management of Azure resources, including cleanup when you don't need them anymore.

#### Cluster bootstrapping

After each Kubernetes instance or stamp has been deployed, cluster components such as ingress controllers, identity solutions, and workload components need to be deployed and configured. You might need to create Kubernetes namespaces, and you also need to consider applying security, access, and governance policies across the cluster. These operations are referred to as *bootstrapping* the cluster to prepare for workloads that will be deployed to it.

Similar to deployment, bootstrapping configurations can become challenging to manage across several Kubernetes instances manually. If you use a hub cluster with Azure Kubernetes Fleet Manager, you can deploy some of the bootstrapping configuration across your fleet, such as namespaces. However, other bootstrapping components require a different deployment approach.

You should consider one of the following options for applying bootstrap configuration and policy at scale.

##### GitOps

Instead of manually configuring Kubernetes components on each cluster, it's recommended to use automated methods to apply configurations to a Kubernetes cluster, as these configurations are checked into a source repository. This process is often referred to as GitOps, and popular GitOps solutions for Kubernetes include Flux and Argo CD. For example, the Flux extension for AKS enables bootstrapping the clusters automatically and immediately after the clusters are deployed.

GitOps is detailed in more depth in the [AKS baseline reference architecture](/azure/architecture/reference-architectures/containers/aks/baseline-aks#cluster-bootstrapping). By using a GitOps based approach to configuration, you ensure that each Kubernetes instance is configured similarly without bespoke effort. A streamlined configuration process becomes even more important as the size of your fleet grows.

You can use a GitOps approach to deploy the base cluster configuration. You can enroll the cluster in the fleet to participate in fleet-wide activities like automated upgrade rollouts.

You can also optionally use GitOps to deploy your workloads. To learn more, see the following [workload deployment](#workload-deployment) section.

##### Azure Policy

As multiple Kubernetes instances are added, the benefit of policy-driven governance, compliance, and configuration increases. Utilizing policies, specifically Azure Policy, provides a centralized and scalable method for cluster control. The benefit of AKS policies is detailed in the [AKS baseline reference architecture](../aks/baseline-aks.yml#policy-management).

Azure Policy should be enabled when the AKS clusters are created. Initiatives should be assigned in Audit mode to gain visibility into noncompliance. You can also set more policies that aren't part of any built-in initiatives. Those policies are set in Deny mode. For example, there's a policy in place to ensure that only approved container images are run in the cluster. Consider creating your own custom initiatives. Combine the policies that are applicable for your workload into a single assignment.

*Policy scope* refers to the target of each policy and policy initiative. You might use Bicep to assign policies to the resource group into which each AKS cluster is deployed. As the footprint of the global cluster grows, it results in many duplicate policies. You can also scope policies to an Azure subscription or Azure management group. This method enables you to apply a single set of policies to all the AKS clusters within the scope of a subscription, or all the subscriptions found under a management group.

When designing policy for multiple AKS clusters, consider the following items:

- Apply policies that should apply globally to all AKS instances to a management group or subscription.
- Place each regional cluster in its own resource group, which allows for region-specific policies to be applied to the resource group.

See [Cloud Adoption Framework resource organization](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org) for materials that help you establish a policy management strategy.

#### Fleet enrollment

After a cluster is deployed and configured, you enroll it into the fleet as a *member cluster*. Each member cluster can be assigned to an *update group*, which can be used as part of an update strategy to determine where in an update run the cluster is updated. To learn more about cluster enrollment, groups, and update strategies, see [Define reusable update strategies using Azure Kubernetes Fleet Manager](/azure/kubernetes-fleet/update-create-update-strategy).

#### Workload deployment

Each AKS cluster in your architecture runs applications that support your workload. It's important to plan how you'll deploy and upgrade your workload components in a safe and controlled manner, and how you'll maintain consistency of application versions between each cluster. Therefore, in addition to AKS instance configuration, consider the workloads that are deployed into each regional instance or stamp. Your deployment solutions or pipelines require configuration to accommodate each regional stamp. As more stamps are added to the global cluster, the deployment process needs to be extended, or it needs to be flexible enough to accommodate the new regional instances.

There are several deployment approaches you can consider, including:

- **Pipelines:** For scenarios with a small number of clusters and relatively few, simple deployments, it's often best to use lightweight dedicated continuous delivery (CD) pipelines.

   A single pipeline typically deploys a workload to one or more clusters. This approach minimizes operational overhead and remains manageable in low-scale environments. When moving from a single-cluster to few-cluster model, you can evolve the deployment pipelines you already have in place.

- **Azure Kubernetes Fleet Manager workload propagation:** Fleet workload propagation helps orchestrate workload definitions across multiple member clusters from a centralized control plane. Fleets support a reliable and scalable approach to workload deployments, allowing for a large number of workloads and member clusters.

   Workload propagation requires the use of a hub cluster, which is a Microsoft-managed AKS cluster that helps to track the expected state of your member clusters. This hub cluster is a regional resource. If a regional outage affects the hub cluster, workload propagation might experience temporary disruption.

- **GitOps:** As your infrastructure matures further, adopting a GitOps-based strategy becomes increasingly beneficial. GitOps allows for declarative, auditable, and pull-based deployment mechanisms, offering scalability, governance, and team collaboration. Transitioning to this model is especially recommended when managing a large and dynamic fleet of clusters across multiple regions.

   To learn more, see [GitOps for Azure Kubernetes Service](../../../example-scenario/gitops-aks/gitops-blueprint-aks.yml).

To decide which approach makes sense for your solution, consider these questions:

- **Do you expect the number of clusters to remain fixed or increase over time?** If you plan to expand the number of clusters, or if you plan to adjust the number of clusters dynamically, it can quickly become unwieldy to maintain each cluster's configuration in your deployment pipelines.
- **How many deployable units do you have to manage?** If you have a small number of monolithic applications, you only have a small number of individual deployments to coordinate. However, if you have a distributed microservices-based architecture, a large number of workloads, or both. then  this can quickly grow into hundreds of deployable units. Creating a pipeline for each deployment might become infeasible.
- **What kind of deployment strategies do you need?** Common strategies include rolling updates, blue-green deployments, and canary deployments. Some deployment approaches must allow for "bake time" between rollouts, with close monitoring to check for any regressions introduced by the deployment. Evaluate each deployment approach to determine whether it supports your specific requirements.
- **What network security constraints do your clusters work within?** Azure Kubernetes Fleet Manager operates under a hub-and-spoke cluster topology, where member clusters maintain outbound connections to a central hub cluster for workload reconciliation and heartbeat monitoring. A GitOps-based strategy requires participating clusters establish outbound access to a Git repository. When you use pipelines, the pipeline agent typically requires connectivity to each cluster to perform deployment operations.

Regardless of how you'll orchestrate your deployments, aim to generalize each deployment, such as with a Helm chart, to ensure that a single deployment configuration can be used across multiple clusters (stamps). Also, consider how application diagnostic logging and distributed tracing can be configured for application-wide observability across each of your clusters.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

A significant motivation for choosing a multi-region Kubernetes architecture is service availability. That is, if a service or service component becomes unavailable in one region, traffic should be routed to a region where another instance of that service is still available. A multi-region architecture includes many different failure points. In this section, each of these potential failure points is discussed.

#### Application pod failures

A Kubernetes Deployment object is used to create a ReplicaSet, which manages multiple replicas of a pod. If one pod is unavailable, traffic is routed between the remaining. The Kubernetes ReplicaSet attempts to keep the specified number of replicas up and running. If one instance goes down, a new instance should be created automatically. Liveness probes can be used to check the state of the application or process running in the pod. If the service is unresponsive, the liveness probe removes the pod, which forces the ReplicaSet to create a new instance.

For more information, see [Kubernetes ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/).

#### Datacenter hardware failures

Localized failure can occasionally occur. For example, power might become unavailable to a single rack of Azure servers. To protect your AKS nodes from becoming a single point of failure, use Azure availability zones. By using availability zones, you ensure that AKS nodes in a one availability zone are physically separated from those nodes defined in another availability zone.

For more information, see [AKS and Azure availability zones](/azure/aks/availability-zones).

#### Azure region failures

When an entire region becomes unavailable, the pods in the cluster are no longer available to serve requests. In this case, Azure Front Door routes all traffic to the remaining healthy regions. The Kubernetes clusters and pods in the healthy regions continues to serve requests.

Take care in this situation to compensate for increased requests and traffic to the remaining cluster. Consider the following points:

- Ensure that network and compute resources are right-sized to absorb any sudden increase in traffic due to region failover. For example, when using Azure CNI, make sure you have a subnet that's large enough to support all Pod IP addresses while traffic is spiking.
- Use the Horizontal Pod Autoscaler to increase the pod replica count to compensate for the increased regional demand.
- Use the AKS Cluster Autoscaler to increase the Kubernetes instance node counts to compensate for the increased regional demand.

For more information, see [Horizontal Pod Autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler) and [AKS cluster autoscaler](/azure/aks/cluster-autoscaler).

### Network topology

Similar to the AKS baseline reference architecture, this architecture uses a hub-spoke network topology. In addition to the considerations specified in the [AKS baseline reference architecture](../aks/baseline-aks.yml#network-topology), consider the following best practices:

- Implement a hub-spoke set of virtual networks for each regional AKS instance. Within each region, peer each spoke to the hub virtual network.
- Route all outbound traffic through an Azure Firewall instance found in each regional hub network. Utilize Azure Firewall Manager policies to manage firewall policies across all regions.
- Follow the IP sizing found in the [AKS baseline reference architecture](../aks/baseline-aks.yml#plan-the-ip-addresses), and allow for more IP addresses for both node and pod scale operations in case you experience a regional failure in another region and traffic to the remaining regions increases substantially.

### Traffic management

With the AKS baseline reference architecture, workload traffic is routed directly to an Azure Application Gateway instance, then forwarded onto the backend load balancer and AKS ingress resources. When you work with multiple clusters, the client requests are routed through an Azure Front Door instance, which routes to the Azure Application Gateway instance.

![Architecture diagram showing workload traffic in multi-region deployment.](images/aks-ingress-flow.svg)

*Download a [Visio file](https://arch-center.azureedge.net/aks-multi-cluster-aks-ingress-flow.vsdx) of this diagram.*

1. The user sends a request to a domain name (such as `https://contoso-web-a1bc2de3fh4ij5kl.z01.azurefd.net`), which is resolved to the Azure Front Door profile. This request is encrypted with a wildcard certificate (`*.azurefd.net`) issued for all subdomains of Azure Front Door. Azure Front Door validates the request against web application firewall policies, selects the fastest origin (based on health and latency), and uses public DNS to resolve the origin IP address (Azure Application Gateway instance).

1. Azure Front Door forwards the request to the selected appropriate Application Gateway instance, which serves as the entry point for the regional stamp. The traffic flows over the internet. Azure Front Door ensures the traffic to the origin is encrypted.

   Consider a method to ensure that the Application Gateway instance only accepts traffic from the Front Door instance. One approach is to use a network security group on the subnet that contains the Application Gateway. The rules can filter inbound (or outbound) traffic based on properties such as Source, Port, Destination. The Source property allows you to set a built-in service tag that indicates IP addresses for an Azure resource. This abstraction makes it easier to configure and maintain the rule and keep track of IP addresses. Additionally, consider utilizing the `X-Azure-FDID` header, which Azure Front Door adds to the request before sending it to the origin, to ensure that the Application Gateway instance only accepts traffic from the Front Door instance. For more information on Front Door headers, see [Protocol support for HTTP headers in Azure Front Door](/azure/frontdoor/front-door-http-headers-protocol).

### Shared resource considerations

While the focus of this scenario is on having multiple Kubernetes instances spread across multiple Azure regions, it does make sense to share some resources across all regions. One approach is to use a single Bicep file to deploy all shared resources, and then another to deploy each regional stamp. This section details each of these shared resources and considerations for using each across multiple AKS instances.

#### Container Registry

Azure Container Registry is used in this architecture to provide container image services. The cluster pulls container images from the registry. Consider the following items when working with Azure Container Registry in a multi-region cluster deployment.

##### Geographic availability

Position a container registry in each region in which an AKS cluster is deployed. This approach allows for low-latency network operations, enabling fast, reliable image layer transfers. It also means that you have multiple image service endpoints to provide availability when regional services are unavailable. Using Azure Container Registry's geo-replication functionality allows you to manage one container registry that's automatically replicated to multiple regions.

Consider creating a single registry, with replicas into each Azure region that contains clusters. For more information on Azure Container Registry replication, see [Geo-replication in Azure Container Registry](/azure/container-registry/container-registry-geo-replication).

*Image showing multiple Azure Container Registry replicas from within the Azure portal.*

![Image showing multiple Azure Container Registry replicas from within the Azure portal.](./images/acr-replicas.png)

##### Cluster access

Each AKS cluster requires access to the container registry so that it can pull container image layers. There are multiple ways for establishing access to Azure Container Registry. In this architecture, a managed identity is created for each cluster, which is then granted the `AcrPull` role on the container registry. For more information and recommendations on using managed identities for Azure Container Registry access, see the [AKS baseline reference architecture](../aks/baseline-aks.yml#integrate-microsoft-entra-id-for-the-cluster).

This configuration is defined in the cluster stamp Bicep file, so that each time a new stamp is deployed, the new AKS instance is granted access. Because the container registry is a shared resource, ensure that your deployments include the resource ID of the container registry as a parameter.

#### Azure Monitor

When you're designing a monitoring solution for a multi-region architecture, it's important to consider the coupling between each stamp. You might deploy a single Log Analytics workspace, shared by each Kubernetes cluster. Like with the other shared resources, define your regional stamp to consume information about the single globally shared Log Analytics workspace, and connect each regional cluster to that one shared workspace. When each regional cluster emits diagnostic logs to that single Log Analytics workspace, you can use the data, along with resource metrics, to build reports and dashboards that help you understand how your whole multi-region solution is running.

#### Azure Front Door

Azure Front Door is used to load balance and route traffic to each AKS cluster. Azure Front Door also enables layer 7 global routing. These capabilities are required for this scenario.

##### Cluster configuration

As each regional AKS instance is added, the Application Gateway deployed alongside the Kubernetes cluster needs to be enrolled as an origin in Azure Front Door, which makes it available for routing. This operation requires an update to your infrastructure as code assets. Alternatively, this operation can be decoupled from the deployment configuration and managed by using tools such as the Azure CLI.

##### Certificates

Azure Front Door doesn't support origins using self-signed certificates, even in development or test environments. To enable HTTPS traffic, you need to create your TLS/SSL certificate signed by a certificate authority (CA). For information about other CAs that Front Door supports, see [Allowed certificate authorities for enabling custom HTTPS on Azure Front Door](/azure/frontdoor/end-to-end-tls?#supported-certificates).

For testing, or for non-production clusters, you might consider using [Certbot](https://certbot.eff.org/) to create a Let's Encrypt Authority X3 certificate for each of the application gateways.

When planning for a production cluster, use your organization's preferred method for procuring TLS certificates.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Cluster access control

As discussed in the [AKS baseline reference architecture](../aks/baseline-aks.yml#integrate-microsoft-entra-id-for-the-cluster), we recommend that you use Microsoft Entra ID as the identity provider for your clusters. The Microsoft Entra groups can then be used to control access to cluster resources.

When you manage multiple clusters, you need to decide on an access schema. Options include:

- Create a global cluster-wide access-group where members can access all objects across every Kubernetes instance in the cluster. This option provides minimal administration needs; however, it grants significant privilege to any group member.
- Create an individual access group for each Kubernetes instance that's used to grant access to objects in an individual cluster instance. With this option, the administrative overhead does increase; however, it also provides more granular cluster access.
- Define granular access controls for Kubernetes object types and namespaces, and correlate the results to a Microsoft Entra group structure. With this option, the administrative overhead increases significantly; however, it provides granular access to not only each cluster but the namespaces and Kubernetes APIs found within each cluster.

For administrative access, consider creating a Microsoft Entra group for each region. Grant each group full access to the corresponding cluster stamp in that region. Members of each group then have administrative access to the corresponding clusters.

For more information on managing AKS cluster access with Microsoft Entra ID, see [AKS Microsoft Entra integration](/azure/aks/azure-ad-rbac).

#### Security of your fleet resources

When you use a fleet to centralize aspects of your cluster management, it's important to protect the fleet resources to avoid misuse. [Fleet resources use Azure role-based access control (Azure RBAC)](/azure/kubernetes-fleet/concepts-rbac), and you can grant fleet permissions to a restricted set of administrators. Follow the principle of least privilege and grant the least possible access to the fleet resource (the *control plane* of the fleet).

If your fleet uses a hub cluster, consider the following extra recommendations:

- Evaluate the role assignments you create in your hub cluster (the *data plane* role assignments). These role assignments grant access to the Kubernetes resources that the fleet creates. Scope role assignments to an individual Kubernetes namespace where possible.
- Use a private hub cluster to restrict internet connectivity. However, ensure your network architecture allows the member clusters to reach the hub cluster.

### Data, state, and cache

When using a globally distributed set of AKS clusters, consider the architecture of the application, process, or other workloads that might run across the cluster. If state-based workloads are spread across the clusters, do they need to access a state store? If a process is recreated elsewhere in the cluster due to a failure, does the workload or process continue to have access to a dependent state store or caching solution? State can be stored in many ways, but it's complex to manage even in a single Kubernetes cluster. The complexity increases when adding in multiple Kubernetes clusters. Due to regional access and complexity concerns, consider designing your applications to use a globally distributed state store service.

This architecture's design doesn't include configuration for state concerns. If you run a single logical application across multiple AKS clusters, consider architecting your workload to use a globally distributed data service, such as Azure Cosmos DB. Azure Cosmos DB is a globally distributed database system that allows you to read and write data from the local replicas of your database, and the Cosmos DB service manages geo-replication for you. For more information, see [Azure Cosmos DB](/azure/cosmos-db).

If your workload utilizes a caching solution, ensure that you architect your caching services so that they remain functional even during failover events. Ensure that the workload itself is resilient to cache-related failover, and that the caching solutions are present on all regional AKS instances.

### Operational excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

When you operate a multi-cluster environment with a fleet resource, monitoring becomes more challenging. Similarly, consider how you'll coordinate updates to the AKS cluster components.

#### Monitor clusters and workloads

Manual review of dashboards and logs can become difficult as the number of clusters increases, so consider how you'll systematically aggregate logs and metrics.

The Azure Monitor Container insights feature is the recommended tool to monitor and understand the performance and health of your cluster and container workloads. [Container insights](/azure/azure-monitor/containers/container-insights-overview) utilizes both a Log Analytics workspace for storing log data, and [Azure Monitor Metrics](/azure/azure-monitor/essentials/data-platform-metrics) to store numeric time-series data. Prometheus metrics can also be collected by Container Insights and the data can be sent to either [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview) or [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs). For more information, see the [AKS baseline reference architecture](../aks/baseline-aks.yml#monitor-and-collect-metrics).

You can also configure your [AKS cluster diagnostic settings](/azure/aks/monitor-aks#aks-control-planeresource-logs) to collect and analyze resource logs from the AKS control plane components and forward them to a Log Analytics workspace.

To learn more about how to configure Azure Monitor workspaces in a multi-cluster environment, see [Azure Monitor](#azure-monitor).

#### Monitor the fleet's operations

When Fleet Manager orchestrates an update run, you can monitor the progress of the run as it progresses across clusters. Data are stored in Azure Resource Graph and [can be exported to Azure Monitor for alerting and storage](/azure/kubernetes-fleet/howto-monitor-update-runs).

If you choose to use Fleet Manager for workload propagation, you can monitor the rollout [by using the Azure portal or kubectl](/azure/kubernetes-fleet/quickstart-resource-propagation).

You can also collect [resource logs from the fleet resource](/azure/azure-monitor/reference/supported-logs/microsoft-containerservice-fleets-logs) and forward them to a Log Analytics workspace.

#### Apply updates across the fleet

In this reference architecture, Fleet Manager applies Kubernetes version updates and node image updates across your fleet. You can specify upgrade strategies that configure how upgrades are rolled out across your clusters. Also, Fleet Manager respects maintenance windows on each cluster, so it's a good practice to set the maintenance windows appropriate to each cluster. Maintenance windows on each cluster might be different when you use clusters across multiple geographies and therefore in different time zones.

For more information, see [Update Kubernetes and node images across multiple member clusters](/azure/kubernetes-fleet/concepts-update-orchestration).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs for the services used in the architecture. Other best practices are described in the [Cost Optimization](/azure/well-architected/cost-optimization/) section in Microsoft Azure Well-Architected Framework, and specific cost-optimization configuration options in the [Optimize costs](/azure/aks/best-practices-cost) article.

Consider enabling [AKS cost analysis](/azure/aks/cost-analysis) for granular cluster infrastructure cost allocation by Kubernetes-specific constructs.

## Next steps

- [AKS availability zones](/azure/aks/availability-zones)
- [Azure Kubernetes Fleet Manager](/azure/kubernetes-fleet/overview)
- [Geo-replication in Azure Container Registry](/azure/container-registry/container-registry-geo-replication)
- [Azure paired regions](/azure/best-practices-availability-paired-regions)

## Related resources

- [Azure Well-Architected Framework review for Azure Kubernetes Service (AKS)](/azure/architecture/framework/services/compute/azure-kubernetes-service/azure-kubernetes-service)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../aks/baseline-aks.yml)
- [CI/CD pipeline for container-based workloads](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops)
- [AKS Microsoft Entra integration](/azure/aks/azure-ad-rbac)
- [Azure Front Door documentation](/azure/frontdoor)
- [Azure Cosmos DB documentation](/azure/cosmos-db)
