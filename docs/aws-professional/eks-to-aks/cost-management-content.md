The following article will guide you on how the pricing for AKS works, how you can optimize the cost for your cluster, and the different tools and solutions to implement a proper cost governance strategy.

Cost Governance is the continuous process of implementing policies or controls to limit spending or costs. Both native Kubernetes tooling and Azure tools can allow you to have proactive monitoring and optimize the underlying infrastructure costs.

> [!NOTE]
> This article is part of a [series of articles](../index.md) that helps professionals who are familiar with Amazon Elastic Kubernetes Service (Amazon EKS) to understand Azure Kubernetes Service (AKS).

## EKS Costs Basics

In [Amazon Elastic Kubernetes Service (Amazon EKS)](https://aws.amazon.com/eks/pricing/) you pay a fixed price per hour for each EKS cluster that you create. Then you pay for the additional AWS resources (e.g., EC2 instances or Amazon Elastic Block Store (EBS) volumes) you provision to run your Kubernetes worker nodes. Since EKS worker nodes are standard Amazon EC2 instances, you are charged for them based on regular EC2 prices. You are also charged for additional networking, operations tools, and storage used by the cluster.

## Azure Kubernetes Service (AKS) Cost Basics

To better understand AKS pricing model, it is essential to distinguish between two different layers of its architecture:

- Control plane: provides the [core Kubernetes services](https://kubernetes.io/docs/concepts/overview/components/) (e.g., API Server, Etcd, etc.) and orchestration of application workloads. The Azure platform manages the AKS control plane, and you only pay for the AKS nodes that run your applications. For more information, see [control plane](/azure/aks/concepts-clusters-workloads#control-plane).
- Agent Nodes: the nodes that will host your workloads, also known as worker Nodes. As shown in the following picture, agent nodes are fully-managed by customers. For more information on agent nodes and node pools, see [Create and manage multiple node pools for a cluster in Azure Kubernetes Service (AKS)](/azure/aks/use-multiple-node-pools).

![AKS architecture](./media/aks-architecture.png)

The control plane layer is automatically provisioned and configured whenever you deploy an AKS cluster. If you opt for the free tier, this is provided at [no cost](https://azure.microsoft.com/pricing/details/kubernetes-service/). Alternatively, you can create an AKS cluster with the [Uptime SLA](/azure/aks/uptime-sla) that enables a financially backed, higher SLA for the control plane. Uptime SLA is a paid feature and is enabled per cluster. Uptime SLA pricing is determined by the number of discrete clusters, and not by the size of the individual clusters. Clusters with Uptime SLA, also regarded as Paid tier in AKS REST APIs, come with greater amount of control plane resources and automatically scale to meet the load of your cluster. Uptime SLA guarantees 99.95% availability of the Kubernetes API server endpoint for clusters that use Availability Zones and 99.9% of availability for clusters that don't use Availability Zones. AKS uses master node replicas across update and fault domains to ensure SLA requirements are met. AKS recommends the use of Uptime SLA in production workloads to provide a higher availability of control plane components. Clusters on free tier by contrast come with fewer replicas and limited resources for the control plane and are not suitable for production workloads. Aside from the control plane, you will create agent or worker nodes as part of one or [multiple node pools](/azure/aks/use-multiple-node-pools), you only pay for these nodes attached to the AKS cluster.

AKS builds upon a number of Azure infrastructure resources, including virtual machine scale sets, virtual networks, and managed disks. This enables you to leverage many of the core capabilities of the Azure platform within the managed Kubernetes environment provided by AKS. For example, most Azure virtual machine types can be used directly with AKS and Azure Reservations can be used to receive discounts on those resources automatically.

To enable this architecture, each AKS deployment spans two resource groups:

- You create the first resource group. This group contains only the Kubernetes service resource and will not have any cost associated with it. The AKS resource provider automatically creates the second resource group during deployment. An example of the second resource group is *MC_myResourceGroup_myAKSCluster_westeurope*. For information on how to specify the name of this second resource group, see the next section.
- The second resource group, known as the node resource group, contains all of the infrastructure resources associated with the cluster and will be the one that show charges to your subscription. These resources include the Kubernetes node VMs, virtual networking, and storage. By default, the node resource group has a name like *MC_myResourceGroup_myAKSCluster_westeurope*. AKS automatically deletes the node resource group whenever the cluster is deleted, so it should only be used for resources that share the cluster's lifecycle. For more information on the node resource group and how to customize its name at provisioning time, see [node resource group](/azure/aks/faq#can-i-provide-my-own-name-for-the-aks-node-resource-group).

The pricing of the AKS cluster is associated with the number and VM size of the virtual machines that compose the node pools of your AKS cluster. The cost of virtual machines depends on their size (CPU type, the number of vCPUs, memory, family, etc.) and the storage type available (such as high-performance SSD or standard HDD). For more information, see [Virtual Machine Series](https://azure.microsoft.com/pricing/details/virtual-machines/series/). You should plan the node size according to your application requirements and the number of worker nodes based on the scalability needs of your AKS cluster.

### Compute costs

When looking into the pricing of Azure virtual machines and associated storage, keep in mind that:

- Service Pricing differs per region. For example, a VM in East US might be cheaper than in West Europe.
- Not all services and VM sizes are available in each region.
- There are multiple VM families optimized for different types of workloads.
- Virtual machines are charged according to their size and usage. Review this article for additional information on [how Azure compute compares to AWS](../../compute.md).
  - Generally speaking, the bigger the VM size you select for a node pool, the higher the hourly cost for the agent nodes.
  - Likewise, generally speaking, the more specialized (e.g., GPU enabled or memory-optimized) is the VM series used for a node pool, the more expensive will be the cost of the agent pool.
  - The more time agent nodes are up and running, the higher the total cost of ownership for a cluster. Development environments usually don't need to be running 24/7.
- Ephemeral OS disks are free and included in the VM price.
- When using managed disks as OS drives, they are charged separately, and you must add their cost to the total cost estimation.
- Data disks, including those created with persistent volume claims, are optional and charged individually based on their class (e.g., StandardHDDs, StandardSSDs, PremiumSSDs, and UltraSSDs) and size. When present, they must be explicitly added to your cost estimations.
- Number of data disks, IOPS, throughput in MB/sec, temporary storage SSD depend on the VM size.
- Likewise, the size of managed disks, IOPS, and throughput in MB/sec depends on the class (e.g., StandardHDDs, StandardSSDs, PremiumSSDs, and UltraSSDs) and size.
- Network interfaces, also known as NICs, are free of charge.

### Storage services costs

If you plan to run workloads that make use of CSI persistent volumes on you AKS cluster, you need to consider the associated cost of any additional storage provisioned and used by your applications. The Container Storage Interface (CSI) is a standard for exposing arbitrary block and file storage systems to containerized workloads on Kubernetes. By adopting and using CSI, Azure Kubernetes Service (AKS) can write, deploy, and iterate plug-ins to expose new or improve existing storage systems in Kubernetes without having to touch the core Kubernetes code and wait for its release cycles. The CSI storage driver support on AKS allows you to natively use:

- [Azure Disks](/azure/aks/azure-disk-csi) can be used to create a Kubernetes data disk resource. Disks can use Azure Premium Storage, backed by high-performance SSDs, or Azure Standard Storage, backed by regular HDDs or Standard SSDs. For most production and development workloads, use Premium Storage. Azure disks are mounted as ReadWriteOnce, which makes it available to one node in AKS. For storage volumes that can be accessed by multiple pods simultaneously, use Azure Files. For more information on costs, see [Managed Disks pricing](https://azure.microsoft.com/en-us/pricing/details/managed-disks/)

- [Azure Files](/azure/aks/azure-files-csi) can be used to mount an SMB 3.0/3.1 share backed by an Azure storage account to pods. With Azure Files, you can share data across multiple nodes and pods. Azure files can use Azure Standard storage backed by regular HDDs, or Azure Premium storage, backed by high-performance SSDs. Azure File service relies on a Storage Account, and it is priced based on:

  - Service: Blob, File, Queue, Table or Unmanaged Disks
  - Storage account type: GPv1, GPv2, Blob or Premium Blob
  - Resiliency: LRS, ZRS, GRS or RA-GRS
  - Access Tier: Hot, Cool or Archive
  - Operations and data transfers
  - Used capacity in GB

- [Azure NetApp Files:](https://azure.microsoft.com/pricing/details/netapp/) available in multiple SKU tiers and requires a minimum provisioned capacity of 4TiB and with 1 TiB increments. This solution is priced based on:
  - SKU
  - Redundancy option (LRS, ZRS or GRS)
  - Size or capacity provisioned, not used
  - Operations and data transfer
  - Backups and restores

### Networking services costs

You will also use multiple Azure networking services to provide access to your applications running in AKS

- [Azure Load Balancer](https://azure.microsoft.com/en-gb/pricing/details/load-balancer/): by default, the Load Balancer will be Standard SKU. The Load Balancer is priced based on:

  - Rules: number of configured load-balancing and outbound rules. Inbound NAT rules don't count in the total number of rules.
  - Data Processed: amount of data processed inbound and outbound independent of rules. There is no hourly charge for the Standard Load Balancer when no rules are configured.

- [Application Gateway](https://azure.microsoft.com/en-gb/pricing/details/application-gateway/): this component is often found in AKS architectures either through the use of AGIC or through customers that wish to front a different ingress controller with a manually-managed Application Gateway to support gateway routing, TLS termination and WAF functionality.

  - Fixed price : this is set hourly (or partial hour) price.
  - Capacity Unit price: this is an additional consumption-based cost. Each capacity unit is composed of at most: 1 compute unit, or 2,500 persistent connections, or 2.22-Mbps throughput.

- [Public IP addresses:](https://azure.microsoft.com/pricing/details/ip-addresses/) have also a cost associated depending on:

  - Reserved vs Dynamic association.
  - Basic vs Standard: secured and zone redundant.

### AKS Scale out

There are multiple options for scaling an AKS cluster and adding extra capacity to your node pools:

- On-demand: manually update the number of VMs part of a node pool or add more node pools.
- Cluster Autoscaler: the cluster autoscaler watches for pods that can't be scheduled on nodes because of resource constraints. The cluster then automatically increases the number of nodes.
- ACI (Azure Container Instance) integration: AKS support running containers on ACI using the [virtual kubelet](https://github.com/virtual-kubelet/virtual-kubelet) implementation. AKS virtual node to provision pods inside ACI that start in seconds. This enables AKS to run with just enough capacity for your average workload. As you run out of capacity in your AKS cluster, scale-out additional pods in ACI, without any additional servers to manage. This approach can be combined with the above strategies.

If using on-demand or cluster autoscaler you should account for the additional VMs as described in the computer section. If using Azure Container Instance, the solution is priced based on:

- Metric used: billing is based on container group
- Collection vCPU/Memory
- Used by a single container or shared by multiple
- Will be co-scheduled containers and share network and node lifecycle.
- There is an additional charge for Windows container groups.
- Metering: duration is calculated from image pull start on new deployments or container group is restarted (if already deployed), until the container group is stopped

### Costs due to AKS cluster upgrades

Part of the AKS cluster lifecycle involves performing periodic upgrades to the latest Kubernetes version. It’s important you apply for the latest security releases or upgrade to get the latest features. AKS clusters and single node pools can be upgraded manually or automatically. For more information, see [Upgrade an Azure Kubernetes Service (AKS) cluster](/azure/aks/upgrade-cluster).

By default, AKS configures upgrades to surge with one extra node. A default value of one for the max surge settings will enable AKS to minimize workload disruption by creating an extra node before the cordon/drain of existing applications to replace an older versioned node. The max surge value may be customized per node pool to enable a trade-off between upgrade speed and upgrade disruption. By increasing the max surge value, the upgrade process completes faster, but setting a large value for max surge may cause disruptions during the upgrade process and additional costs due to the extra VMs used during the upgrade process.

### Additional possible associated costs

Other additional costs to keep in mind:

- Azure Container registry: its price will change depending on the [SKU (Basic, Standard or Premium)](/azure/container-registry/container-registry-skus), image builds, and storage used.
- [Data Transfer:](https://azure.microsoft.com/en-gb/pricing/details/bandwidth/) outbound data transfers from Azure are charged, as well as inter-region traffic.
- Additional storage or PaaS services such as databases.
- Global networking services such as [Azure Traffic Manager](https://azure.microsoft.com/en-gb/pricing/details/traffic-manager/) or [Azure Front Door](https://azure.microsoft.com/en-gb/pricing/details/frontdoor/) used to route traffic to the public endpoints of workloads running on your AKS cluster.
- Firewall and protection services such as [Azure Firewall](/azure/firewall/overview) inspect, allow, or block traffic to and from your [Azure Kubernetes Service (AKS)](/azure/aks) cluster.
- Monitoring and logging services such as [Azure Monitor Container Insights](/azure/azure-monitor/containers/container-insights-cost), [Azure Monitor Application Insights](https://azure.microsoft.com/en-gb/pricing/details/monitor/), [Microsoft Defender for Cloud](https://azure.microsoft.com/en-gb/pricing/details/defender-for-cloud/), etc. Review the [understand monitoring costs for Container insights](/azure/azure-monitor/containers/container-insights-cost#estimating-costs-to-monitor-your-aks-cluster) documentation for detailed guidance.
- DevOps tools like ([Azure DevOps](https://azure.microsoft.com/en-gb/pricing/details/devops/azure-devops-services/) or [GitHub](https://github.com/pricing)

## Cost Optimizations

Now that cost items and metrics are understood here are some recommendations on how to optimize costs:

- Review the [WAF Service Guide for AKS for cost optimization](/azure/architecture/framework/services/compute/azure-kubernetes-service/azure-kubernetes-service#cost-optimization)
- If working with multitenant solutions physical isolation will be more costly in general and will add management overhead. Logical isolation requires more experience with Kubernetes and increases the surface area in case of changes and security threads but shares the costs.
- Leverage Azure reservations for [Storage](/azure/storage/files/files-reserve-capacity) and [Compute](https://azure.microsoft.com/en-gb/pricing/reserved-vm-instances/) resources, by reserving capacity you get discounts. Azure Reservations to reduce the cost of the agent nodes. [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) can help you save money by committing to one-year or three-year plans for multiple products, for example for the virtual machines that compose your AKS cluster. Committing allows you to get a discount on the resources you use. Reservations can significantly reduce your resource costs by up to 72% from pay-as-you-go prices. Reservations provide a billing discount and don't affect the runtime state of your resources. After you purchase a reservation, the discount automatically applies to matching resources. You can purchase reservations from the Azure portal, or using the Azure REST APIs, PowerShell, and Azure CLI.
- Add one or more spot node pools to your AKS cluster. As you know, a spot node pool is a node pool backed by a [spot Virtual Machine Scale Set (VMSS)](/azure/virtual-machine-scale-sets/use-spot). Using spot VMs for nodes with your AKS cluster allows you to take advantage of unutilized capacity in Azure at significant cost savings. The amount of available unutilized capacity will vary based on many factors, including node size, region, and time of day. When deploying a spot node pool, Azure will allocate the spot nodes if there's capacity available. But there's no SLA for the spot nodes. A spot scale set that backs the spot node pool is deployed in a single fault domain and offers no high availability guarantees.When Azure needs the capacity back, the Azure infrastructure will evict spot nodes. When you create a spot node pool, you can define the maximum price you want to pay per hour as well as enable the cluster autoscaler, which is recommended to use with spot node pools. Based on the workloads running in your cluster, the cluster autoscaler scales out and scales in the number of nodes in the node pool. For spot node pools, the cluster autoscaler will scale out the number of nodes after an eviction if additional nodes are still needed. For more information, see [Add a spot node pool to an Azure Kubernetes Service (AKS) cluster](/azure/aks/spot-node-pool).
- Choose the right [VM size](/azure/virtual-machines/sizes) for the node pools of your AKS cluster based on the needs in terms of CPU and memory of your workloads. Azure offers many different instance types matching a wide range of use cases, with entirely different combinations of CPU, memory, storage, and networking capacity. Every type comes in one or more sizes, so you can scale your resources easily.
- Create multiple node pools with different [VM sizes](/azure/virtual-machines/sizes) for special purposes and workloads and use Kubernetes [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) and [node labels](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) to place resource-intensive applications on specific node pools to avoid noisy neighbor issues. Keep node resources available for workloads that require them, and don't allow other workloads to be scheduled on the nodes. Using different VM sizes for different node pools can also be used to optimize costs. For more information, see [Use multiple node pools in Azure Kubernetes Service (AKS)](/azure/aks/use-multiple-node-pools?msclkid=4bcac87ab63c11eca58bba96cceafa21).
- System-mode node pools must contain at least one worker node, while user-mode node pools could contain zero or more nodes. Hence, whenever possible, you could configure a user-mode node pool to automatically scale from 0 to N node and you could configure your workloads to scale out and scale in based using a horizontal pod autoscaler based on CPU and memory or based on the metrics of an external system like Apache Kafka, RabbitMQ, Azure Service Bus, etc. using [Kubernetes Event-driven Autoscaling (KEDA)](https://keda.sh/).
- Leverage Azure Containers Instances for bursting. For more information, see [Bursting from AKS with ACI](/azure/architecture/solution-ideas/articles/scale-using-aks-with-aci).
Your AKS workloads may not need to run continuously, for example, a development cluster that has node pools running specific workloads. To optimize your costs, you can completely turn off an AKS cluster or stop one or more node pools in your AKS cluster, allowing you to save on compute costs. For more information, see [Stop and Start an Azure Kubernetes Service (AKS) cluster](/azure/aks/start-stop-cluster?tabs=azure-cli) and [Start and stop a node pool on Azure Kubernetes Service (AKS)](/azure/aks/start-stop-nodepools).
- Deploy and manage containerized applications with Azure Kubernetes Service (AKS) running on Ampere Altra ARM-based processors. For more information, see [Azure Virtual Machines with Ampere Altra Arm-based processors](https://azure.microsoft.com/blog/now-in-preview-azure-virtual-machines-with-ampere-altra-armbased-processors/).
- Makes sure to properly set [requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for your pods to avoid assigning too many resources in terms of CPU and memory to your workloads and improve application density. You should observe the average and maximum consumption of CPU and memory using Prometheus or Container Insights and properly configure limits and quotas for your pods in the YAML manifests, Helm charts, Kustomize manifests for your deployments.
- Use [ResourceQuota](https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/resource-quota-v1/) objects to set quotas for the total amount memory and CPU that can be used by all Pods running in a given [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces). The systematic use of Resource Quotas prevents the likelihood of the noisy neighbor's issue, improves the application density, and reduces the number of agent nodes and hence the total cost of ownership. Likewise, use [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/) objects to configure the default requests in terms of CPU and memory for pods running in a namespace. Azure Policy integrates with AKS through built-in policies to apply at-scale enforcements and safeguards on your cluster in a centralized, consistent manner. Follow the documentation to enable the Azure Policy add-on on your cluster and apply the Ensure [CPU](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/) and memory resource limits policy which ensures CPU and [memory](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/) resource limits are defined on containers in an Azure Kubernetes Service cluster.
- To optimize Azure Container registry costs deploy it on the same region as the cluster to avoid additional data transfer costs and use replication if needed, also reduce image sizes as much as possible to reduce storage costs and deployment times.
- If using operational tools that rely on [Log Analytics workspaces consider using reservations](https://azure.microsoft.com/updates/azure-monitor-log-analytics-new-capacity-based-pricing-option-is-now-available/) for this storage as well.
- Release and monitor unused resources, make sure to leverage [Azure Advisor](/azure/advisor/advisor-overview) for this purpose.
- Use Azure Cost Management budgets and reviews to keep track of expenditure.

## Cost Governance

By using the Microsoft cloud, you can significantly improve the technical performance of your business workloads. It can also reduce your costs and the overhead required to manage organizational assets. However, the business opportunity creates risk because of the potential for waste and inefficiencies that are introduced into your cloud deployments. [Azure Cost Management + Billing](/azure/cost-management-billing/cost-management-billing-overview) is a suite of tools provided by Microsoft that help you analyze, manage, and optimize the costs of your workloads. Using the suite helps ensure that your organization is taking advantage of the benefits provided by the cloud.

Review the [Cloud Adoption Framework](/azure/architecture/framework/cost/design-governance) governance best practices and specially the [Cost Management Discipline](/azure/cloud-adoption-framework/govern/cost-management/) to understand how to better manage and govern costs.

Examine open-source tools such as [KubeCost](https://www.kubecost.com/) to monitor and govern an AKS cluster cost. Cost allocation can be scoped to a deployment, service, label, pod, and namespace, which will give you flexibility in how you chargeback/showback users of the cluster.

## Next Steps

> [!div class="nextstepaction"]
> [Agent node management](../nodes/node-pools.yml)

The following references provide automation and documentation on AKS cost management:

- [Governance disciplines for AKS](/azure/cloud-adoption-framework/scenarios/aks/eslz-security-governance-and-compliance)
- [Cost Management Discipline](/azure/cloud-adoption-framework/govern/cost-management/)
- [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)
- [Plan and manage your Azure costs](/learn/modules/plan-manage-azure-costs/)