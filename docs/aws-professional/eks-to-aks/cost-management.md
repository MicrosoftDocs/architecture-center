---
title: Cost Management for Kubernetes
description: Understand Kubernetes cluster and workload costs, learn how to optimize and govern costs, and compare AKS and Amazon EKS options.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-containers
ms.collection:
  - migration
  - aws-to-azure
---

# Cost management for Kubernetes

This article explains pricing and cost management in Azure Kubernetes Service (AKS) compared to Amazon Elastic Kubernetes Service (EKS). It describes how to optimize costs and implement cost governance solutions for your AKS cluster.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS cost basics

For [Amazon EKS](https://aws.amazon.com/eks/pricing), you pay a fixed price per hour for each Amazon EKS cluster. You also pay for the networking, operations tools, and storage that the cluster uses.

Amazon EKS worker nodes are standard Amazon EC2 instances, which means that they incur the same costs as regular EC2 prices. You also pay for other Amazon Web Services (AWS) resources that you provision to run your Kubernetes worker nodes.

Amazon EKS [managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) don't incur extra costs. You pay only for the AWS resources that you provision. These resources include Amazon EC2 instances, Amazon Elastic Block Store volumes, Amazon EKS cluster hours, and other AWS infrastructure.

When you create a managed node group, you can use the [on-demand instances or spot instances capacity type](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html#managed-node-group-capacity-types) to manage the cost of agent nodes. Amazon EKS deploys a managed node group with an [Amazon EC2 auto scaling group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that contains either all on-demand instances or all spot instances.

On-demand instances incur compute capacity costs per second, with no long-term commitments. Amazon EC2 spot instances are unused Amazon EC2 capacity that's available at a lower cost compared to on-demand instances.

- Amazon EC2 spot instances can be interrupted. When Amazon EC2 requires the capacity elsewhere, you receive a two-minute interruption notice.

- Amazon provides tools called Spot Fleet and Spot Instance Advisor. Spot Fleet is a method that automates groups of on-demand instances and spot instances. These tools help predict which region or availability zone provides minimal disruption.

- AWS spot instance prices vary. AWS sets the price depending on long-term supply and demand trends for spot instance capacity. You pay the price that's in effect during the time period that the instance is operational.

## AKS cost analysis

An [AKS](/azure/aks/what-is-aks) cluster relies on various Azure resources such as virtual machines (VMs), virtual disks, load balancers, and public IP addresses. Multiple applications can use these resources. Different teams within an organization might manage each application. The consumption patterns of these resources can vary, which results in different contributions toward the total cluster resource cost. Some applications might span multiple clusters, which can complicate cost attribution and management.

For scenarios where a cluster contains a single workload, use [Microsoft Cost Management](/azure/cost-management-billing/cost-management-billing-overview) to measure cluster resource consumption under the cluster resource group. Some scenarios require other solutions beyond Cost Management, such as scenarios that require:

- A granular breakdown of resource usage, such as compute, network, and storage.

- Differentiating between individual application costs and shared costs.
- Cost analysis across multiple clusters within the same subscription scope.

To enhance cost observability, AKS integrates with Cost Management to provide detailed cost breakdowns at Kubernetes constructs, such as the cluster and namespace levels. This integration enables cost analysis across Azure compute, network, and storage categories.

The AKS cost analysis add-on is built on [OpenCost](https://www.opencost.io/), which is an open-source project for usage data collection. The add-on reconciles data with your Azure invoice, which provides cost visibility. You can view the post-processed data in the Cost Management cost analysis portal. For more information, see [AKS cost analysis](/azure/aks/cost-analysis).

### Cost definitions

The Kubernetes namespace and asset views show the following charges:

- **Idle charges** represent the cost of available resource capacity that workloads don't use.

- **Service charges** represent charges that are associated with services, like uptime service-level agreement (SLA) and Microsoft Defender for Containers charges.
- **System charges** represent the cost of capacity that AKS reserves on each node to run system processes that the cluster requires.
- **Unallocated charges** represent the cost of resources that can't be allocated to namespaces.

## AKS cost basics

Kubernetes architecture consists of two layers, the control plane and at least one node or node pool. The AKS pricing model is based on these layers.

The [control plane](/azure/aks/concepts-clusters-workloads#control-plane) provides [core Kubernetes services](https://kubernetes.io/docs/concepts/overview/components), such as the API server and `etcd`, and application workload orchestration. The Azure platform manages the AKS control plane. In the AKS Free tier, [the control plane doesn't incur costs](https://azure.microsoft.com/pricing/details/kubernetes-service).

The [nodes](/azure/aks/concepts-clusters-workloads#nodes-and-node-pools), also called *agent nodes* or *worker nodes*, host Kubernetes workloads and applications. In AKS, customers fully manage and pay all costs for the agent nodes.

The following diagram shows the relationship between the control plane and nodes in an AKS Kubernetes architecture.

:::image type="complex" source="./media/control-plane-and-nodes.svg" border="false" lightbox="./media/control-plane-and-nodes.svg" alt-text="Diagram that shows the control plane and nodes in AKS architecture.":::
The diagram is divided into two sections: Azure-managed and customer-managed. The Azure-managed section includes the control plane, which has the components: the API server, scheduler, etcd (a key-value store), and controller manager. The API server connects to the other three components. The customer-managed section includes nodes that have the components: kubelet, container runtime, kube-proxy, and a container. The scheduler in the control plane connects to kubelet. Kubelet connects to container runtime, which connects to the container. 
:::image-end:::

### Control plane

Azure automatically provisions and configures the control plane layer when you create an AKS cluster.

For a higher control plane SLA, you can create an AKS cluster in the [Standard tier](/azure/aks/free-standard-pricing-tiers). The Standard tier includes an uptime SLA and enables it for each cluster. The pricing is $0.10 per cluster per hour. For more information, see [AKS pricing details](https://azure.microsoft.com/pricing/details/kubernetes-service/).

Clusters in the Standard tier have more control plane resources, including a higher number of API server instances, increased `etcd` resource limits, [scalability up to 5,000 nodes](https://azure.microsoft.com/updates/generally-available-5000-node-scale-in-aks/), and financially backed uptime SLA support. AKS uses main node replicas across update and fault domains to meet availability requirements.

To provide higher control plane component availability, use the Standard tier in production workloads. Free tier clusters have fewer replicas and limited control plane resources, so they're not ideal for production workloads.

### Nodes

You can use AKS to create agent or worker nodes in one or more node pools. The node pools can use many Azure core capabilities within the Kubernetes environment. AKS charges for only the nodes that are attached to the AKS cluster.

AKS nodes use several Azure infrastructure resources, including virtual machine scale sets, virtual networks, and managed disks. For example, you can use most Azure VM types directly within AKS. Use [Azure reservations](https://azure.microsoft.com/reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/) to get discounts on these resources.

AKS cluster pricing is based on the class, number, and size of the VMs in the node pools. The VM cost depends on the size, CPU type, number of vCPUs, memory, family, and storage type available. For more information, see [VM series](https://azure.microsoft.com/pricing/details/virtual-machines/series). Plan your node size according to application requirements, number of nodes, and cluster scalability needs.

For more information, see [Node pools](node-pools.md) and [Create and manage multiple node pools for a cluster in AKS](/azure/aks/use-multiple-node-pools).

### AKS cluster deployment

Each AKS deployment spans two Azure resource groups.

- You create the first resource group, which contains only the Kubernetes service resource and doesn't incur costs.

- The AKS resource provider automatically creates the second resource group, also called the *node resource group*, during deployment. The default name for this resource group is `MC_<resourcegroupname>_<clustername>_<location>`, but you can specify another name. For more information, see [Provide my own name for the AKS node resource group](/azure/aks/faq#can-i-provide-my-own-name-for-the-aks-node-resource-group-).

  The node resource group contains the cluster infrastructure resources. This resource group incurs charges in your subscription. The resources include the Kubernetes node VMs, virtual networking, storage, and other services. AKS automatically deletes the node resource group when the cluster is deleted. So you should use it only for resources that share the cluster's lifecycle.

## Compute costs

You pay for Azure VMs based on their size and usage. For more information, see [Compute services on Azure and AWS](../compute.md).

Generally, the bigger the VM size for a node pool, the higher the hourly cost for the agent nodes. And the more specialized the VM series for the node pool, the more expensive the pool. Specializations include graphics processing unit (GPU)-enabled VMs or memory-optimized VMs.

Consider the following aspects of Azure VM pricing:

- Pricing differs for each region, and not every region supports all services and VM sizes.

- Different VM families are optimized for different types of workloads.

- Managed disks that you use as OS drives are charged separately. You must add their cost to your estimates. The managed disk size depends on the class, Standard SSD, Azure Premium SSD, or Azure Ultra Disk Storage. Input/output operations per second (IOPS) and throughput in MBps depend on the size and class. The VM price includes [ephemeral OS disks](node-pools.md#ephemeral-os-disks).

- Data disks, including those created by using persistent volume claims, are optional. Data disks are charged individually based on their class, such as Standard SSD, Premium SSD, and Ultra Disk Storage. You must explicitly add data disks to cost estimations. The number of allowed data disks, temporary storage SSDs, IOPS, and throughput in MBps depend on the VM size and class.

- The longer that agent nodes are operational, the higher the total cluster cost. Development environments don't usually need to run continuously.

- Network Interface Cards (NICs) are free.

## Storage costs

The Container Storage Interface (CSI) is a standard for exposing block and file storage systems to containerized workloads on Kubernetes. AKS can use the CSI to write, deploy, and iterate plug-ins that expose Kubernetes storage systems without touching the core Kubernetes code or waiting for its release cycles.

If you run workloads that use CSI persistent volumes on your AKS cluster, consider the associated cost of the storage that your applications provision and use. CSI storage drivers on AKS provide native support for the following storage options:

- [Azure disk storage](/azure/aks/azure-disk-csi) creates Kubernetes data disk resources. Disks can use Azure premium storage that's backed by Premium SSDs or Azure standard storage that's backed by Standard SSDs. Most production and development workloads use premium storage. Azure disks are mounted as `ReadWriteOnce`, which makes them available to only one AKS node. For storage volumes that multiple pods can access simultaneously, use Azure Files. For more information, see [Managed disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

- [Azure Files](/azure/aks/azure-files-csi) mounts Server Message Block (SMB) 3.0 and 3.1 file shares to your AKS pods. The file shares are backed by an Azure Storage account. You can share data across multiple nodes and pods. Azure Files can use premium storage that's backed by Premium SSDs. Azure Files uses a Storage account and accrues charges based on the following factors:

  - The service, such as Azure Blob Storage, Azure Files, Azure Queue Storage, Azure Table Storage, or unmanaged disks

  - The Storage account type, such as GPv1, GPv2, blob, or premium blob
  - The level of resiliency, such as locally redundant storage (LRS), zone-redundant storage (ZRS), geo-redundant storage (GRS), or read-access geo-redundant storage (RA-GRS)
  - The access tier, such as hot, cool, or archive
  - Operations and data transfers
  - The used capacity in GB

- [Azure NetApp Files](https://azure.microsoft.com/pricing/details/netapp/) has several SKU tiers. It requires a minimum provisioned capacity of 4 TiB that you can increase in 1-TiB increments. Azure NetApp Files charges are based on the following factors:

  - The SKU

  - The level of resiliency, such as LRS, ZRS, or GRS
  - The size or capacity provisioned, not the capacity used
  - Operations and data transfers
  - Backups and restores

## Networking costs

Several Azure networking tools can provide access to your applications that run in AKS:

- [Azure Load Balancer](https://azure.microsoft.com/pricing/details/load-balancer): By default, Load Balancer uses the Standard SKU. Load Balancer charges are based on:

  - The number of configured load-balancing and outbound rules. The total number of rules doesn't include inbound network address translation (NAT) rules.

  - The amount of inbound and outbound processed data, independent of rules. There's no hourly charge for a standard load balancer that has no rules configured.

- [Azure Application Gateway](https://azure.microsoft.com/pricing/details/application-gateway): AKS often uses Application Gateway through [Application Gateway Ingress Controller](/azure/application-gateway/ingress-controller-overview). Or you can front a different ingress controller with a manually managed Application Gateway instance. Application Gateway supports gateway routing, Transport Layer Security (TLS) termination, and Web Application Firewall functionality. Application Gateway charges are based on:

  - A fixed price. You pay for each hour or partial hour that Application Gateway runs.
  
  - A capacity unit price. You pay an extra consumption-based cost depending on the resources that Application Gateway uses. Each capacity unit has up to one compute unit, 2,500 persistent connections, and 2.22-Mbps throughput.

- [Public IP addresses](https://azure.microsoft.com/pricing/details/ip-addresses): Public IP addresses have an associated cost that depends on:

  - Reserved versus dynamic association.

  - The Basic tier versus the highly secure and zone-redundant Standard tier.

## Scale-out costs

You can use the following options to scale an AKS cluster, which adds extra capacity to node pools:

- As needed, you can manually update the number of VMs that are part of a node pool or add more node pools.

- The AKS [cluster autoscaler](/azure/aks/cluster-autoscaler#about-the-cluster-autoscaler) watches for pods that can't be scheduled on nodes because of resource constraints, and automatically increases the number of nodes.

- AKS supports running containers on [Azure Container Instances](https://azure.microsoft.com/products/container-instances) by using the [virtual kubelet](https://virtual-kubelet.io/) implementation. An AKS virtual node provisions Container Instances pods that start in seconds, which allows AKS to run with just enough capacity for an average workload. As the AKS cluster reaches its capacity limit, you can scale out more Container Instances pods without managing extra servers. You can combine this approach with the cluster autoscaler and manual scaling approaches.

If you use on-demand scaling or the cluster autoscaler, account for the added VMs. Container Instances charges are based on the following factors:

- Usage-based metrics billing per container group
- Collection vCPU and memory
- Single container use or multiple container sharing
- Use of co-scheduled containers that share the network and node lifecycle
- Usage duration that's calculated from the image pull start or restart until stop
- Added charges for Windows container groups

## Upgrade costs

Part of the AKS cluster lifecycle involves periodic upgrades to the latest Kubernetes version. Apply the latest security releases and get the latest features. You can upgrade AKS clusters and single node pools manually or automatically. For more information, see [Upgrade an AKS cluster](/azure/aks/upgrade-cluster).

By default, AKS configures upgrades to include one extra node. A default value of `1` for the `max-surge` setting minimizes workload disruption. This configuration creates an extra node to replace older-versioned nodes before cordoning or draining existing applications. You can customize the `max-surge` value for each node pool to balance upgrade speed and disruption. A higher `max-surge` value speeds up the upgrade process but might cause more disruptions and add costs for extra VMs.

## Other costs

Depending on usage and requirements, AKS clusters can incur the following added costs:

- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) costs depending on the [SKU](/azure/container-registry/container-registry-skus), image builds, and storage that you use. You can deploy Container Registry in the same region as the cluster to avoid added data transfer charges. Use replication if needed, and reduce image sizes as much as possible to reduce storage costs and deployment times.

- Outbound [data transfers](https://azure.microsoft.com/pricing/details/bandwidth) from Azure and from inter-region traffic.

- Other storage or platform as a service (PaaS) solutions, such as databases.

- Global networking services, such as [Azure Traffic Manager](https://azure.microsoft.com/pricing/details/traffic-manager) or [Azure Front Door](https://azure.microsoft.com/pricing/details/frontdoor), that route traffic to the public endpoints of AKS workloads.

- Firewall and protection services, like [Azure Firewall](/azure/firewall/overview), that inspect and allow or block traffic to and from AKS clusters.

- Monitoring and logging tools, such as [Azure Monitor container insights](/azure/azure-monitor/containers/container-insights-cost), [Application Insights](https://azure.microsoft.com/pricing/details/monitor/), and [Microsoft Defender for Cloud](https://azure.microsoft.com/pricing/details/defender-for-cloud/). For more information, see [Understand monitoring costs for container insights](/azure/azure-monitor/containers/container-insights-cost#estimating-costs-to-monitor-your-aks-cluster).

- Costs that are associated with DevOps tools, like [Azure DevOps Services](https://azure.microsoft.com/pricing/details/devops/azure-devops-services) or [GitHub](https://github.com/pricing).

## Cost optimization

The following recommendations help optimize your AKS cluster costs:

- Review the [Cost Optimization](/azure/architecture/framework/services/compute/azure-kubernetes-service/azure-kubernetes-service#cost-optimization) section of the Azure Well-Architected Framework for AKS.

- For multitenant solutions, physical isolation adds cost and management overhead. Logical isolation requires more Kubernetes experience and increases the surface area for changes and security threats but shares the costs.

- [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) can help you save money. To get discounts, you can commit to one-year or three-year plans for several products, such as the VMs in your AKS cluster. Use Azure reservations for [storage](/azure/storage/files/files-reserve-capacity) and [compute](https://azure.microsoft.com/pricing/reserved-vm-instances) to reduce the cost of agent nodes.

  Reservations can reduce your resource costs up to 72% compared to pay-as-you-go prices. And they don't affect the runtime state of your resources. After you purchase a reservation, the discount automatically applies to matching resources. To purchase reservations from the Azure portal, use Azure REST APIs, Azure PowerShell, or the Azure CLI. If you use operational tools that rely on [Log Analytics workspaces](https://azure.microsoft.com/updates/azure-monitor-log-analytics-new-capacity-based-pricing-option-is-now-available), consider using reservations for this storage.

- Add one or more spot node pools to your AKS cluster. A spot node pool is a node pool that [scale sets for Azure spot virtual machines](/azure/virtual-machine-scale-sets/use-spot) support. When you use spot VMs for your AKS cluster nodes, you can take advantage of unused Azure capacity at a reduced cost. The amount of available unused capacity varies based on several factors, including node size, region, and time of day. Azure allocates the spot nodes if capacity is available, but spot nodes don't have an SLA. A spot scale set that backs the spot node pool is deployed in a single fault domain and doesn't provide high-availability guarantees. When Azure needs the capacity, the Azure infrastructure evicts the spot nodes.

  When you create a spot node pool, you should define the maximum price to pay per hour and enable the cluster autoscaler. The cluster autoscaler scales out and scales in the number of nodes in the node pool based on the operational workloads. For spot node pools, the cluster autoscaler scales out the number of nodes after an eviction if the nodes are still needed. For more information, see [Add a spot node pool to an AKS cluster](/azure/aks/spot-node-pool).

- Choose the right [VM size](/azure/virtual-machines/sizes) for your AKS cluster node pools based on your workloads' CPU and memory needs. Azure provides many different VM instance types for a wide range of use cases. They have different combinations of CPU, memory, storage, and networking capacity. Every VM type comes in one or more sizes, so you can easily scale your resources.

  You can use AKS to [deploy and manage containerized applications that run on Ampere Altra ARM-based processors](https://azure.microsoft.com/blog/now-in-preview-azure-virtual-machines-with-ampere-altra-armbased-processors).

- Create multiple node pools that have different VM sizes for special purposes and workloads. Use Kubernetes [taints, tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration), and [node labels](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node) to place resource-intensive applications on specific node pools to avoid noisy neighbor problems. Keep these node resources available for workloads that require them, and don't schedule other workloads on these nodes. To optimize costs, use different VM sizes for different node pools. For more information, see [Use multiple node pools in AKS](/azure/aks/use-multiple-node-pools).

- System-mode node pools must contain at least one node. User-mode node pools can contain zero or more nodes. When possible, you can configure a user-mode node pool to automatically scale from `0` to `N` nodes. To configure your workloads to scale out and scale in, use a horizontal pod autoscaler. Determine your autoscaling needs based on CPU and memory. Or use [Kubernetes Event-driven Autoscaling (KEDA)](https://keda.sh) to implement autoscaling based on the metrics of an external system, like Apache Kafka, RabbitMQ, or Azure Service Bus.

- Set [requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers) properly for your pods to improve application density and avoid assigning too many CPU and memory resources to your workloads. To view the average and maximum consumption of CPU and memory, use Prometheus or container insights. Properly configure limits and quotas for your pods in the YAML manifests, Helm charts, and Kustomize manifests for your deployments.

- Use [ResourceQuota](https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/resource-quota-v1) objects to set quotas for the total amount of memory and CPU for all pods that run in a given [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces). Systematically use resource quotas to avoid noisy neighbor problems, improve application density, and reduce the number of agent nodes and total costs. To configure the default CPU and memory requests for pods in a namespace, use [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range) objects. 

- Use Container Instances for bursting.

- Your AKS workloads might not need to continuously run. For example, some workloads in development cluster node pools don't continuously run. To optimize costs, you can completely turn off an AKS cluster or stop one or more node pools in your AKS cluster. For more information, see [Stop and start an AKS cluster](/azure/aks/start-stop-cluster) and [Start and stop a node pool on AKS](/azure/aks/start-stop-nodepools).

- Azure Policy integrates with AKS through built-in policies to apply centralized, consistent, at-scale enforcements and safeguards. Enable the Azure Policy add-on for your cluster to apply default CPU requests and limits and [memory resource limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace). This feature helps ensure that the cluster containers have defined CPU and memory resource limits.

- Use [Azure Advisor](/azure/advisor/advisor-overview) to monitor and release unused resources.

- Use [Cost Management](https://azure.microsoft.com/products/cost-management) budgets and reviews to track expenditures.

## Cost governance

The cloud can significantly improve the technical performance of business workloads. Cloud technologies can also reduce the cost and overhead of managing organizational assets. However, this business opportunity also creates risk because cloud deployments can increase waste and inefficiencies.

Cost governance is the process of continuously implementing policies or controls to limit spending and costs. Native Kubernetes tooling and Azure tools both support cost governance by providing proactive monitoring and underlying infrastructure cost optimization.

- [Cost Management](/azure/cost-management-billing/cost-management-billing-overview) is a suite of Microsoft tools that help you analyze, manage, and optimize your Azure workload costs. Use the tools to help ensure that your organization takes advantage of the benefits that the cloud provides.

- Review the [Cloud Adoption Framework for Azure](/azure/architecture/framework/cost/design-governance) governance best practices to better understand how to manage and govern cloud costs.

- Explore open-source tools like [KubeCost](https://www.kubecost.com) to monitor and govern AKS cluster costs. You can scope cost allocation based on a deployment, service, label, pod, or namespace, which provides flexibility in how you display and charge cluster users.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal System Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Cloud Solution Architect

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Cost governance with Kubecost](/azure/cloud-adoption-framework/scenarios/app-platform/aks/cost-governance-with-kubecost)
- [Cost Management discipline overview](/azure/cloud-adoption-framework/govern/cost-management)
- [Video: Can cloud native architectures lower your long-term costs?](https://www.youtube.com/watch?v=5KVz_rz3P3w)
- [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator)
- [Plan and manage your Azure costs](/learn/modules/plan-manage-azure-costs)
- [AKS cost analysis](/azure/aks/cost-analysis)
- [Webinar: Tools and tips for unparalleled cost transparency on AKS](https://www.youtube.com/watch?v=p15XAKy14WQ)
- [OpenCost project on GitHub](https://github.com/opencost/opencost)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Kubernetes node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
