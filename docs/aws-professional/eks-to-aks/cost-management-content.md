This guide explains how pricing and cost management work in Azure Kubernetes Service (AKS) compared to Amazon Elastic Kubernetes Service (Amazon EKS). The article describes how to optimize costs and implement cost governance solutions for your AKS cluster.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS cost basics

In [Amazon EKS](https://aws.amazon.com/eks/pricing), you pay a fixed price per hour for each Amazon EKS cluster. You also pay for the networking, operations tools, and storage that the cluster uses.

Amazon EKS worker nodes are standard Amazon EC2 instances, so they incur regular Amazon EC2 prices. You also pay for other Amazon Web Services (AWS) resources that you provision to run your Kubernetes worker nodes.

There are no extra costs to use Amazon EKS [managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html). You pay only for the AWS resources you provision, including Amazon EC2 instances, Amazon EBS volumes, Amazon EKS cluster hours, and any other AWS infrastructure.

When creating a managed node group, you can choose to use the [On-Demand or Spot Instances capacity type](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html#managed-node-group-capacity-types) to manage the cost of agent nodes. Amazon EKS deploys a managed node group with an [Amazon EC2 Auto Scaling group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that contains either all On-Demand or all Spot Instances.

With On-Demand Instances, you pay for compute capacity by the second, with no long-term commitments. Amazon EC2 Spot Instances are spare Amazon EC2 capacity that offers discounts compared to On-Demand prices.

- Amazon EC2 Spot Instances can be interrupted with a two-minute interruption notice when EC2 needs the capacity back.

- Amazon provides Spot Fleet, a method to automate groups of On-Demand and Spot Instances, and Spot Instance Advisor to help predict which region or Availability Zone might provide minimal disruption.

- AWS Spot Instance prices vary. AWS sets the price depending on long-term supply and demand trends for Spot Instance capacity, and you pay the price in effect for the time period the instance is up.

## AKS cost basics

Kubernetes architecture is based on two layers, the control plane and one or more nodes or node pools. The AKS pricing model is based on the two Kubernetes architecture layers.

- The [control plane](/azure/aks/concepts-clusters-workloads#control-plane) provides [core Kubernetes services](https://kubernetes.io/docs/concepts/overview/components), such as the API server and `etcd`, and application workload orchestration. The Azure platform manages the AKS control plane, and for the AKS free tier, the control plane has [no cost](https://azure.microsoft.com/pricing/details/kubernetes-service).

- The [nodes](/azure/aks/concepts-clusters-workloads#nodes-and-node-pools), also called *agent nodes* or *worker nodes*, host Kubernetes workloads and applications. In AKS, customers fully manage and pay all costs for the agent nodes.

The following diagram shows the relationship between the control plane and nodes in an AKS Kubernetes architecture.

![Diagram that shows the control plane and nodes in AKS architecture.](./media/control-plane-and-nodes.png)

### Control plane

Azure automatically provisions and configures the control plane layer when you create an AKS cluster. For the AKS Free tier, the control plane is free.

For a higher control plane service-level agreement (SLA), you can create an AKS cluster in the [Standard tier](/azure/aks/free-standard-pricing-tiers). Uptime SLA is included by default in the Standard tier and is enabled per cluster. The pricing is $0.10 per cluster per hour. For more information, see [AKS pricing details](https://azure.microsoft.com/pricing/details/kubernetes-service/).

Clusters in the Standard tier have more control plane resources, such as the number of API server instances, Etcd resource limits, [scalability up to 5,000 nodes](https://azure.microsoft.com/updates/generally-available-5000-node-scale-in-aks/), and the existing financially-backed Uptime SLA support. AKS uses main node replicas across update and fault domains to meet availability requirements.

It's best to use the Standard tier in production workloads to provide higher control plane component availability. Free tier clusters have fewer replicas and limited control plane resources and aren't recommended for production workloads.

### Nodes

In AKS, you create agent or worker nodes in one or more node pools, which can use many Azure core capabilities within the Kubernetes environment. AKS charges only for the nodes attached to the AKS cluster.

AKS nodes use several Azure infrastructure resources, including virtual machine scale sets, virtual networks, and managed disks. For example, you can use most Azure virtual machine (VM) types directly within AKS. You can use [Azure Reservations](https://azure.microsoft.com/reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/) to get significant discounts on these resources.

AKS cluster pricing is based on the class, number, and size of the VMs in the node pools. VM cost depends on size, CPU type, number of vCPUs, memory, family, and storage type available, such as high-performance SSD or standard HDD. For more information, see [Virtual Machine Series](https://azure.microsoft.com/pricing/details/virtual-machines/series). Plan node size according to application requirements, number of nodes, and cluster scalability needs.

For more information about agent nodes and node pools, see the [Node pools](node-pools.yml) article in this series, and [Create and manage multiple node pools for a cluster in Azure Kubernetes Service (AKS)](/azure/aks/use-multiple-node-pools).

### AKS cluster deployment

Each AKS deployment spans two Azure resource groups.

- You create the first resource group, which contains only the Kubernetes service resource and has no costs associated with it.

- The AKS resource provider automatically creates the second or node resource group during deployment. The default name for this resource group is `MC_<resourcegroupname>_<clustername>_<location>`, but you can specify another name. For more information, see [Provide my own name for the AKS node resource group](/azure/aks/faq#can-i-provide-my-own-name-for-the-aks-node-resource-group).

  The node resource group contains all the cluster infrastructure resources and is the one that shows charges to your subscription. The resources include the Kubernetes node VMs, virtual networking, storage, and other services. AKS automatically deletes the node resource group when the cluster is deleted, so you should use it only for resources that share the cluster's lifecycle.

## Compute costs

You pay for Azure VMs according to their size and usage. For information about how Azure compute compares to AWS, see [Compute services on Azure and AWS](../compute.md).

Generally, the bigger the VM size you select for a node pool, the higher the hourly cost for the agent nodes. The more specialized the VM series you use for the node pool, for example graphics processing unit (GPU)-enabled or memory-optimized, the more expensive the pool.

When investigating Azure VM pricing, be aware of the following points:

- Pricing differs per region, and not all services and VM sizes are available in every region.

- There are multiple VM families, optimized for different types of workloads.

- Managed disks used as OS drives are charged separately, and you must add their cost to your estimates. Managed disk size depends on the class, such as Standard HDDs, Standard SSDs, Premium SSDs, or Ultra SSDs. Input-output operations per second (IOPS) and throughput in MB/sec depend on size and class. [Ephemeral OS disks](node-pools.yml#ephemeral-os-disks) are free and are included in the VM price.

- Data disks, including those created with persistent volume claims, are optional and are charged individually based on their class, such as Standard HDDs, Standard SSDs, Premium SSDs, and Ultra SSDs. You must explicitly add data disks to cost estimations. The number of allowed data disks, temporary storage SSDs, IOPS, and throughput in MB/sec depend on VM size and class.

- The more time that agent nodes are up and running, the higher the total cluster cost. Development environments don't usually need to run continuously.

- Network interfaces (NICs) are free.

## Storage costs

The Container Storage Interface (CSI) is a standard for exposing block and file storage systems to containerized workloads on Kubernetes. By adopting and using CSI, AKS can write, deploy, and iterate plug-ins that expose Kubernetes storage systems without touching the core Kubernetes code or waiting for its release cycles.

If you run workloads that use CSI persistent volumes on your AKS cluster, consider the associated cost of the storage your applications provision and use. CSI storage drivers on AKS provide native support for the following storage options:

- [Azure Disks](/azure/aks/azure-disk-csi) creates Kubernetes data disk resources. Disks can use Azure Premium Storage, backed by high-performance SSDs, or Azure Standard Storage, backed by regular HDDs or Standard SSDs. Most production and development workloads use Premium Storage. Azure disks are mounted as `ReadWriteOnce`, which makes them available to only one AKS node. For storage volumes that multiple pods can access simultaneously, use Azure Files. For cost information, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

- [Azure Files](/azure/aks/azure-files-csi) mounts server messaging block (SMB) 3.0/3.1 file shares backed by an Azure Storage account to AKS pods. You can share data across multiple nodes and pods. Azure Files can use Standard storage backed by regular HDDs, or Premium storage backed by high-performance SSDs. Azure Files uses an Azure Storage account, and accrues charges based on the following factors:

  - Service: Blob, File, Queue, Table or unmanaged disks
  - Storage account type: GPv1, GPv2, Blob, or Premium Blob
  - Resiliency: Locally redundant storage (LRS), zone-redundant storage (ZRS), geo-redundant storage (GRS), or read-access geo-redundant storage (RA-GRS)
  - Access tier: Hot, cool, or archive
  - Operations and data transfers
  - Used capacity in GB

- [Azure NetApp Files](https://azure.microsoft.com/pricing/details/netapp/) is available in several SKU tiers and requires a minimum provisioned capacity of 4 TiB, with 1 TiB increments. Azure NetApp Files charges are based on the following factors:

  - SKU
  - Resiliency: LRS, ZRS, or GRS
  - Size or capacity provisioned, not capacity used
  - Operations and data transfer
  - Backups and restores

## Networking costs

Several Azure networking services can provide access to your applications that run in AKS:

- [Azure Load Balancer](https://azure.microsoft.com/pricing/details/load-balancer). By default, Load Balancer uses Standard SKU. Load Balancer charges are based on:

  - Rules: The number of configured load-balancing and outbound rules. Inbound network address translation (NAT) rules don't count in the total number of rules.
  - Data processed: The amount of data processed inbound and outbound, independent of rules. There's no hourly charge for Standard Load Balancer with no rules configured.

- [Azure Application Gateway](https://azure.microsoft.com/pricing/details/application-gateway). AKS often uses Application Gateway through [Application Gateway Ingress Controller](/azure/application-gateway/ingress-controller-overview), or by fronting a different ingress controller with manually managed Application Gateway. Application Gateway supports gateway routing, transport-layer security (TLS) termination, and Web Application Firewall (WAF) functionality. Application Gateway charges are based on:

  - Fixed price set by hour or partial hour.
  - Capacity unit price, an added consumption-based cost. Each capacity unit has at most one compute unit, 2,500 persistent connections, and 2.22-Mbps throughput.

- [Public IP addresses](https://azure.microsoft.com/pricing/details/ip-addresses) have an associated cost that depends on:

  - Reserved vs. dynamic association.
  - Basic vs. secured and zone-redundant Standard tier.

## Scale-out costs

There are multiple options for scaling an AKS cluster to add extra capacity to node pools:

- On demand, you can manually update the number of VMs that are part of a node pool, or add more node pools.

- The AKS [cluster autoscaler](/azure/aks/cluster-autoscaler#about-the-cluster-autoscaler) watches for pods that can't be scheduled on nodes because of resource constraints, and automatically increases the number of nodes.

- AKS supports running containers on [Azure Container Instances](https://azure.microsoft.com/products/container-instances) by using the [virtual kubelet](https://github.com/virtual-kubelet/virtual-kubelet) implementation. An AKS virtual node provisions Container Instances pods that start in seconds, letting AKS run with just enough capacity for an average workload. As the AKS cluster runs out of capacity, you can scale out more Container Instances pods without managing any additional servers. You can combine this approach with the cluster autoscaler and manual scaling.

If you use on-demand scaling or the cluster autoscaler, account for the added VMs. Container Instances charges are based on the following factors:

- Usage-based metrics billing per container group
- Collection vCPU and memory
- Single container use or multiple container sharing
- Use of co-scheduled containers that share network and node lifecycle
- Usage duration calculated from image pull start or restart until stop
- Added charge for Windows container groups

## Upgrade costs

Part of the AKS cluster lifecycle involves periodic upgrades to the latest Kubernetes version. It's important to apply the latest security releases and get the latest features. You can upgrade AKS clusters and single node pools manually or automatically. For more information, see [Upgrade an Azure Kubernetes Service (AKS) cluster](/azure/aks/upgrade-cluster).

By default, AKS configures upgrades to surge with one extra node. A default value of `1` for the `max-surge` setting minimizes workload disruption by creating an extra node to replace older-versioned nodes before cordoning or draining existing applications. You can customize the `max-surge` value per node pool to allow for a tradeoff between upgrade speed and upgrade disruption. Increasing the `max-surge` value completes the upgrade process faster, but a large value for `max-surge` might cause disruptions during the upgrade process and incur added costs for extra VMs.

## Other costs

Depending on usage and requirements, AKS clusters can incur the following added costs:

- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) costs depending on [Basic, Standard, or Premium SKU](/azure/container-registry/container-registry-skus), image builds, and storage used. Deploy Container Registry on the same region as the cluster to avoid added data transfer charges. Use replication if needed, and reduce image sizes as much as possible to reduce storage costs and deployment times.

- Outbound [data transfers](https://azure.microsoft.com/pricing/details/bandwidth) from Azure, as well as inter-region traffic.

- Other storage or platform as a service (PaaS) services such as databases.

- Global networking services such as [Azure Traffic Manager](https://azure.microsoft.com/pricing/details/traffic-manager) or [Azure Front Door](https://azure.microsoft.com/pricing/details/frontdoor) that route traffic to the public endpoints of AKS workloads.

- Firewall and protection services like [Azure Firewall](/azure/firewall/overview) that inspect and allow or block traffic to and from AKS clusters.

- Monitoring and logging services such as [Azure Monitor Container Insights](/azure/azure-monitor/containers/container-insights-cost), [Azure Monitor Application Insights](https://azure.microsoft.com/pricing/details/monitor/), and [Microsoft Defender for Cloud](https://azure.microsoft.com/pricing/details/defender-for-cloud/). For more information, see [Understand monitoring costs for Container Insights](/azure/azure-monitor/containers/container-insights-cost#estimating-costs-to-monitor-your-aks-cluster).

- Costs associated with DevOps tools like [Azure DevOps Services](https://azure.microsoft.com/pricing/details/devops/azure-devops-services) or [GitHub](https://github.com/pricing).

## Cost optimization

The following recommendations help you optimize your AKS cluster costs:

- Review the [Cost optimization](/azure/architecture/framework/services/compute/azure-kubernetes-service/azure-kubernetes-service#cost-optimization) section of the Azure Well-Architected Framework for AKS.

- For multitenant solutions, physical isolation is more costly and adds management overhead. Logical isolation requires more Kubernetes experience and increases the surface area for changes and security threats, but shares the costs.

- [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) can help you save money by committing to one-year or three-year plans for several products, such as the VMs in your AKS cluster. You get discounts by reserving capacity. Use Azure Reservations for [Storage](/azure/storage/files/files-reserve-capacity) and [Compute](https://azure.microsoft.com/pricing/reserved-vm-instances) to reduce the cost of agent nodes.

  Reservations can reduce your resource costs by up to 72% from pay-as-you-go prices, and don't affect the runtime state of your resources. After you purchase a reservation, the discount automatically applies to matching resources. You can purchase reservations from the Azure portal, or by using Azure REST APIs, PowerShell, or Azure CLI. If you use operational tools that rely on [Log Analytics workspaces](https://azure.microsoft.com/updates/azure-monitor-log-analytics-new-capacity-based-pricing-option-is-now-available), consider using Reservations for this storage also.

- Add one or more spot node pools to your AKS cluster. A spot node pool is a node pool backed by [Azure Spot Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/use-spot). Using spot VMs for your AKS cluster nodes takes advantage of unused Azure capacity at significant cost savings. The amount of available unused capacity varies based on several factors, including node size, region, and time of day. Azure allocates the spot nodes if there's capacity available, but there's no SLA for spot nodes. A spot scale set that backs the spot node pool is deployed in a single fault domain, and offers no high availability guarantees. When Azure needs the capacity back, the Azure infrastructure evicts the spot nodes.

  When you create a spot node pool, you can define the maximum price to pay per hour and enable the cluster autoscaler, which is recommended for spot node pools. The cluster autoscaler scales out and scales in the number of nodes in the node pool based on the running workloads. For spot node pools, the cluster autoscaler scales out the number of nodes after an eviction if the nodes are still needed. For more information, see [Add a spot node pool to an Azure Kubernetes Service (AKS) cluster](/azure/aks/spot-node-pool).

- Choose the right [VM size](/azure/virtual-machines/sizes) for your AKS cluster node pools based on your workloads' CPU and memory needs. Azure offers many different VM instance types that match a wide range of use cases, with different combinations of CPU, memory, storage, and networking capacity. Every type comes in one or more sizes, so you can easily scale your resources.

  You can now deploy and manage containerized applications with AKS running on Ampere Altra ARM-based processors. For more information, see [Azure Virtual Machines with Ampere Altra ARM-based processors](https://azure.microsoft.com/blog/now-in-preview-azure-virtual-machines-with-ampere-altra-armbased-processors).
  
- Create multiple node pools with different VM sizes for special purposes and workloads. Use Kubernetes [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration) and [node labels](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node) to place resource-intensive applications on specific node pools to avoid noisy neighbor issues. Keep these node resources available for workloads that require them, and don't schedule other workloads on these nodes. Using different VM sizes for different node pools can also optimize costs. For more information, see [Use multiple node pools in Azure Kubernetes Service (AKS)](/azure/aks/use-multiple-node-pools).

- System-mode node pools must contain at least one node, while user-mode node pools can contain zero or more nodes. Whenever possible, you can configure a user-mode node pool to automatically scale from `0` to `N` nodes. You can configure your workloads to scale out and scale in by using a horizontal pod autoscaler. Base autoscaling on CPU and memory, or use [Kubernetes Event-driven Autoscaling (KEDA)](https://keda.sh) to base autoscaling on the metrics of an external system like Apache Kafka, RabbitMQ, or Azure Service Bus.

- Make sure to properly set [requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers) for your pods to improve application density and avoid assigning too many CPU and memory resources to your workloads. Observe the average and maximum consumption of CPU and memory by using Prometheus or Container Insights. Properly configure limits and quotas for your pods in the YAML manifests, Helm charts, and Kustomize manifests for your deployments.

- Use [ResourceQuota](https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/resource-quota-v1) objects to set quotas for the total amount of memory and CPU for all pods that are running in a given [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces). The systematic use of resource quotas avoids noisy neighbor issues, improves application density, and reduces the number of agent nodes and total costs. Also use [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range) objects to configure the default CPU and memory requests for pods in a namespace.

- Use Container Instances for bursting.

- Your AKS workloads might not need to run continuously, such as specific workloads in development cluster node pools. To optimize costs, you can completely turn off an AKS cluster or stop one or more node pools in your AKS cluster. For more information, see [Stop and start an Azure Kubernetes Service (AKS) cluster](/azure/aks/start-stop-cluster) and [Start and stop a node pool on Azure Kubernetes Service (AKS)](/azure/aks/start-stop-nodepools).
- Azure Policy integrates with AKS through built-in policies to apply centralized, consistent, at-scale enforcements and safeguards. Enable the Azure Policy add-on on your cluster, and apply the default CPU requests and limits and [memory resource limits](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace), which ensure that CPU and memory resource limits are defined on cluster containers.

- Use [Azure Advisor](/azure/advisor/advisor-overview) to monitor and release unused resources.

- Use [Microsoft Cost Management](https://azure.microsoft.com/products/cost-management) budgets and reviews to keep track of expenditures.

## Cost governance

The cloud can significantly improve the technical performance of business workloads. Cloud technologies can also reduce the cost and overhead of managing organizational assets. However, this business opportunity also creates risk, because cloud deployments can increase the potential for waste and inefficiencies.

Cost governance is the process of continuously implementing policies or controls to limit spending and costs. Native Kubernetes tooling and Azure tools both support cost governance with proactive monitoring and underlying infrastructure cost optimization.

- [Azure Cost Management + Billing](/azure/cost-management-billing/cost-management-billing-overview) is a suite of Microsoft tools that helps you analyze, manage, and optimize your Azure workload costs. Use the suite to help ensure that your organization is taking advantage of the benefits the cloud provides.

- Review the [Cloud Adoption Framework](/azure/architecture/framework/cost/design-governance) governance best practices for the [Cost Management Discipline](/azure/cloud-adoption-framework/govern/cost-management) to better understand how to manage and govern cloud costs.

- Explore open-source tools like [KubeCost](https://www.kubecost.com) to monitor and govern AKS cluster cost. You can scope cost allocation to a deployment, service, label, pod, and namespace, which provides flexibility in showing and charging cluster users.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Software Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal System Engineer

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer
- [Ed Price](https://www.linkedin.com/in/priceed) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.yml)
- [Kubernetes monitoring and logging](monitoring.yml)
- [Secure network access to Kubernetes](private-clusters.yml)
- [Storage options for a Kubernetes cluster](storage.md)
- [Kubernetes node and node pool management](node-pools.yml)
- [Cluster governance](governance.md)

## Related resources

- [Cost governance with Kubecost](/azure/cloud-adoption-framework/scenarios/app-platform/aks/cost-governance-with-kubecost)
- [Cost Management discipline overview](/azure/cloud-adoption-framework/govern/cost-management)
- [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator)
- [Plan and manage your Azure costs](/learn/modules/plan-manage-azure-costs)
