---
title: Azure Kubernetes Service (AKS) and operational excellence
description: Focuses on the Azure Kubernetes Service (AKS) used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to operational excellence.
author: v-stacywray
ms.date: 11/11/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-kubernetes-service
categories:
  - compute
  - management-and-governance
---

# Azure Kubernetes Service (AKS) and operational excellence

[Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance.

To explore how AKS can bolster the operational excellence of your application workload, reference architecture guidance and best practices on the [AKS Solution architectures](/azure/architecture/reference-architectures/containers/aks-start-here) page.

The following sections include configuration checklists, recommended configuration options, and supporting source artifacts specific to AKS.

## Checklists

**Have you configured Azure Kubernetes Service (AKS) with operational excellence in mind?**
***

> [!div class="checklist"]
> - Review AKS best practices documentation.
> - Run multiple workloads in a single AKS cluster.
> - Reboot nodes when updates and patches require it.
> - Don't modify resources in the [node resource group (for example MC_)](/azure/aks/faq#why-are-two-resource-groups-created-with-aks). You should *only* make modifications at [cluster creation time](/azure/aks/faq#can-i-provide-my-own-name-for-the-aks-node-resource-group), or with assistance from [Azure Support](https://ms.portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade/supportPlans).
> - Use a central monitoring tool, such as [Azure Monitor and App Insights](/azure/azure-monitor/containers/container-insights-overview) to centrally collect metrics, logs, and diagnostics for troubleshooting purposes.
> - Enable and review [Kubernetes master node logs](/azure/azure-monitor/containers/container-insights-log-query#resource-logs).
> - Configure scraping of Prometheus metrics with Azure Monitor for containers.
> - Use the [AKS Uptime SLA](/azure/aks/uptime-sla) for production grade clusters.
> - Store container images within Azure Container Registry and enable [geo-replication](/azure/aks/operator-best-practices-multi-region#enable-geo-replication-for-container-images) to replicate container images across leveraged AKS regions.
> - Enable [Azure Defender for container registries](/azure/security-center/defender-for-container-registries-introduction) to enable vulnerability scanning for container images.
> - Authenticate with Azure AD to Azure Container Registry.
> - Use [Availability Zones](/azure/aks/availability-zones) to maximize resilience within an Azure region by distributing AKS agent nodes across physically separate data centers.
> - Use a template-based deployment using Terraform, Ansible, and others only. Make sure that all deployments are repeatable and traceable, and stored in a source code repo. Can be combined with GitOps.
> - Adopt a [multiregion strategy](/azure/aks/operator-best-practices-multi-region#plan-for-multiregion-deployment) by deploying AKS clusters deployed across different Azure regions to maximize availability and provide business continuity.

### Node pool design checklist

> [!div class="checklist"]
> - Use Virtual Machine Scale Set (VMSS) VM set type for AKS node pools.
> - Keep the System node pool isolated from application workloads.
> - Use dedicated node pools for infrastructure tools that require high resource utilization, such as Istio, or have a special scale, or load behavior.
> - Separate applications to dedicated node pools based on specific requirements.
> - Use [taints and tolerations](/azure/aks/operator-best-practices-advanced-scheduler#provide-dedicated-nodes-using-taints-and-tolerations) to provide dedicated nodes and limit resource intensive applications.
> - Consider the use of [Virtual Nodes](/azure/aks/virtual-nodes-cli) [(vKubelet)](https://github.com/virtual-kubelet/virtual-kubelet) with ACI for rapid, massive, and infinite scale.

### Scalability checklist

> [!div class="checklist"]
> - Enable [cluster autoscaler](/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.
> - Consider using [Azure Spot VMs](/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions.
> - Use the [Horizontal pod autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler) to adjust the number of pods in a deployment depending on CPU utilization or other select metrics.
> - Separate workloads into different node pools and consider scaling user node pools to zero.

### AKS roadmap and GitHub release notes checklist

> [!div class="checklist"]
> - Subscribe to the public [AKS Roadmap Release Notes](https://github.com/azure/aks) on GitHub to stay up to date on upcoming changes, improvements, Kubernetes version releases, and the deprecation of old releases.
> - Regularly upgrade to a supported version of Kubernetes.
> - Regularly process node image updates.
> - Leverage AKS Cluster auto-upgrade with [Planned Maintenance](/azure/aks/planned-maintenance).

### Security guidelines checklist

> [!div class="checklist"]
> - Use [Managed Identities](/azure/aks/use-managed-identity) to avoid managing and rotating service principles.
> - Use [AAD integration](/azure/aks/managed-aad) to take advantage of centralized account management, passwords, application access management, and identity protection.
> - Use Kubernetes RBAC with AAD for [least privilege](/azure/aks/azure-ad-rbac) and minimize granting administrator privileges to protect configuration, and secrets access.
> - Limit access to [Kubernetes cluster configuration](/azure/aks/control-kubeconfig-access) file with Azure role-based access control.
> - Limit access to [actions that containers can perform](/azure/aks/developer-best-practices-pod-security#secure-pod-access-to-resources). Provide the least number of permissions, and avoid the use of root, or privileged escalation.
> - Evaluate the use of the built-in [AppArmor security module](/azure/aks/operator-best-practices-cluster-security#app-armor) to limit actions that containers can perform such as read, write, or execute, or system functions such as mounting files systems.
> - Evaluate the use of the [seccomp (secure computing)](/azure/aks/operator-best-practices-cluster-security#secure-computing). Seccomp works at the process level and allows you to limit the process calls that containers can perform.
> - Use [Pod Identities](/azure/aks/operator-best-practices-identity#use-pod-identities) and [Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure#usage) with Azure Key Vault to protect secrets, certificates, and connection strings.
> - Use [Azure Security Center](/azure/security-center/defender-for-kubernetes-introduction) to provide AKS recommendations.
> - Secure clusters and pods with [Azure Policy](/azure/aks/use-azure-policy).

## AKS configuration recommendations

Explore the following table of recommendations to optimize your AKS configuration for operational excellence:

|AKS Recommendation|Description|
|------------------|-----------|
|Review AKS best practices documentation.|To build and run applications successfully in AKS, there are some key considerations to understand and implement. These areas include multi-tenancy and scheduler features, cluster, and pod security, or business continuity and disaster recovery.|
|Configure scraping of Prometheus metrics with Azure Monitor for containers.|Azure Monitor for containers provides a seamless onboarding experience to collect Prometheus metrics. Reference [Configure scraping of Prometheus metrics with Azure Monitor for containers](/azure/azure-monitor/containers/container-insights-prometheus-integration) for more information.|
|Authenticate with Azure AD to Azure Container Registry.|AKS and Azure AD enables authentication with Azure Container Registry without the use of K8s and `imagePullSecrets` secrets. Reference [Authenticate with Azure Container Registry from Azure Kubernetes Service](/azure/aks/cluster-container-registry-integration?tabs=azure-cli) for more information.|
|Adopt a [multiregion strategy](/azure/aks/operator-best-practices-multi-region#plan-for-multiregion-deployment) by deploying AKS clusters deployed across different Azure regions to maximize availability and provide business continuity.|Internet facing workloads should leverage [Azure Front Door](/azure/frontdoor/front-door-overview), [Azure Traffic Manager](/azure/aks/operator-best-practices-multi-region#use-azure-traffic-manager-to-route-traffic), or a third-party CDN to route traffic globally across AKS clusters.|

### Node pool design recommendations

The following table reflects node pool design recommendations and descriptions related to the overall AKS configuration recommendations:

|Node Pool Design Recommendations|Description|
|--------------------------------|-----------|
|Keep the System node pool isolated from application workloads.|System node pools require a VM SKU of at least `2` `vCPUs` and `4GB` memory. Reference [System and user node pools](/azure/aks/use-system-pools#system-and-user-node-pools) for detailed requirements.|
|Separate applications to dedicated node pools based on specific requirements.|Such as GPU, high memory VMs, scale-to-zero, Spot VMs, and so on. Avoid large numbers of node pools to reduce extra management overhead.|

### Scalability recommendations

The following table reflects scalability recommendations and descriptions related to the overall AKS configuration recommendations:

|Scalability Recommendations|Description|
|---------------------------|-----------|
|Enable [cluster autoscaler](/azure/aks/cluster-autoscaler) to automatically adjust the number of agent nodes in response to resource constraints.|The ability to automatically scale up or down the number of nodes in your AKS cluster lets you run an efficient, cost-effective cluster.|
|Consider using [Azure Spot VMs](/azure/aks/spot-node-pool) for workloads that can handle interruptions, early terminations, or evictions.|For example, workloads such as batch processing jobs, development, and testing environments, and large compute workloads may be good candidates for you to schedule on a spot node pool. Using spot VMs for nodes with your AKS cluster allows you to take advantage of unused capacity in Azure at a significant cost savings.|
|Separate workloads into different node pools and consider scaling user node pools to zero.|Unlike System node pools that always require running nodes, user node pools allow you to scale to `0`.|

### AKS roadmap and GitHub release notes recommendations

The following table reflects AKS roadmap and GitHub release notes recommendations, and descriptions related to the overall AKS configuration recommendations:

|Roadmap and Release Notes Recommendations|Description|
|----------------------------------------------------|-----------|
|Subscribe to the AKS Roadmap and Release Notes on GitHub|Make sure that you're subscribed to the [public AKS Roadmap Release Notes](https://github.com/azure/aks) on GitHub to stay up to date on upcoming changes, improvements, and most importantly Kubernetes version releases, and the deprecation of old releases.|
|Regularly upgrade to a supported version of Kubernetes|AKS supports three minor versions of Kubernetes. When a new minor patch version is introduced, the oldest minor version and patch releases supported are retired. Minor updates to Kubernetes happen on a periodic basis. It's important to have a governance process to check and upgrade as needed to not fall out of support. For more information, reference [Supported Kubernetes versions AKS](/azure/aks/supported-kubernetes-versions?tabs=azure-cli).|
|Regularly process node image updates|AKS supports [upgrading the images](/azure/aks/node-image-upgrade) on a node to be up to date with the newest OS and runtime updates without updating the version of Kubernetes. The AKS team provides one new image version per week with the latest updates, including Linux or Windows patches.|
|Leverage AKS Cluster auto-upgrade with Planned Maintenance|AKS supports different [auto-upgrade channels](/azure/aks/upgrade-cluster#set-auto-upgrade-channel) (08/18/21 in public preview) to upgrade AKS clusters to newer versions of Kubernetes and newer node images once available. [Planned Maintenance](/azure/aks/planned-maintenance) (08/18/21 in public preview) can be used to define maintenance windows for these operations.|

### Security guideline recommendations

The following table reflects security guideline recommendations and descriptions related to the overall AKS configuration recommendations:

|Security Guideline Recommendations|Description|
|----------------------------------|-----------|
|Secure clusters and pods with Azure Policy|[Azure Policy](/azure/aks/use-azure-policy) can help to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner. It can also control what functions pods are granted and if anything is running against company policy. This access is defined through built-in policies provided by the Azure Policy Add-on for AKS. By providing more control over the security aspects of your pod's specification, like root privileges, Azure Policy enables stricter security adherence and visibility into what you've deployed in your cluster. If a pod doesn't meet conditions specified in the policy, Azure Policy can disallow the pod to start or flag a violation.|

## Source artifacts

To identify AKS clusters *not* using **RBAC**, use the following query:

```sql
Resources
| where type =~ 'Microsoft.ContainerService/managedClusters'
| where properties.enableRBAC == false
```

To identify AKS clusters *not* deployed using a **Managed Identity**, use the following query:

```sql
Resources
| where type =~ 'Microsoft.ContainerService/managedClusters'
| where isnull(identity)
```

## Next step

> [!div class="nextstepaction"]
> [AKS and performance efficiency](./performance-efficiency.md)