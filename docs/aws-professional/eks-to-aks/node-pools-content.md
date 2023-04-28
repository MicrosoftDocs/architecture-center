Kubernetes architecture is based on two layers: The [control plane](/azure/aks/concepts-clusters-workloads#control-plane) and one or more [nodes in node pools](/azure/aks/concepts-clusters-workloads#nodes-and-node-pools). This article describes and compares how Amazon Elastic Kubernetes Service (Amazon EKS) and Azure Kubernetes Service (AKS) manage agent or worker nodes.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

In both Amazon EKS and AKS, the cloud platform provides and manages the control plane layer, and the customer manages the node layer. The following diagram shows the relationship between the control plane and nodes in AKS Kubernetes architecture.

![Diagram that shows the control plane and nodes in AKS architecture.](./media/control-plane-and-nodes.png)

## Amazon EKS managed node groups

Amazon EKS [managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) automate the provisioning and lifecycle management of Amazon Elastic Compute Cloud (EC2) worker nodes for Amazon EKS clusters. Amazon Web Services (AWS) users can use the [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) command-line utility to create, update, or terminate nodes for their EKS clusters. Node updates and terminations automatically cordon and drain nodes to ensure that applications remain available.

Every managed node is provisioned as part of an [Amazon EC2 Auto Scaling group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that Amazon EKS operates and controls. The [Kubernetes cluster autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html#cluster-autoscaler) automatically adjusts the number of worker nodes in a cluster when pods fail or are rescheduled onto other nodes. Each node group can be configured to run across multiple [Availability Zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-availability-zones) within a region.

For more information about Amazon EKS managed nodes, see [Creating a managed node group](https://docs.aws.amazon.com/eks/latest/userguide/create-managed-node-group.html) and [Updating a managed node group](https://docs.aws.amazon.com/eks/latest/userguide/update-managed-node-group.html).

You can also run Kubernetes pods on [AWS Fargate](https://aws.amazon.com/fargate). Fargate provides on-demand, right-sized compute capacity for containers. For more information on how to use Fargate with Amazon EKS, see [AWS Fargate](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html).

## AKS nodes and node pools

Creating an AKS cluster automatically creates and configures a control plane, which provides [core Kubernetes services](https://kubernetes.io/docs/concepts/overview/components) and application workload orchestration. The Azure platform provides the AKS control plane at no cost as a managed Azure resource. The control plane and its resources exist only in the region where you created the cluster.

The [nodes](/azure/aks/concepts-clusters-workloads#nodes-and-node-pools), also called *agent nodes* or *worker nodes*, host the workloads and applications. In AKS, customers fully manage and pay for the agent nodes attached to the AKS cluster.

To run applications and supporting services, an AKS cluster needs at least one node: An Azure virtual machine (VM) to run the Kubernetes node components and container runtime. Every AKS cluster must contain at least one [system node pool](/azure/aks/use-system-pools) with at least one node.

AKS groups nodes of the same configuration into *node pools* of VMs that run AKS workloads. System node pools serve the primary purpose of hosting critical system pods such as CoreDNS. User node pools serve the primary purpose of hosting workload pods. If you want to have only one node pool in your AKS cluster, for example in a development environment, you can schedule application pods on the system node pool.

![Diagram showing a single Kubernetes nodes.](./media/aks-node-resource-interactions.png)

You can also create multiple user node pools to segregate different workloads on different nodes to avoid the [noisy neighbor problem](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor), or to support applications with different compute or storage demands.

Every agent node of a system or user node pool is a VM provisioned as part of [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) and managed by the AKS cluster. For more information, see [Nodes and node pools](/azure/aks/concepts-clusters-workloads#nodes-and-node-pools).
 
You can define the initial number and [size](/azure/virtual-machines/sizes) for worker nodes when you create an AKS cluster, or when you add new nodes and node pools to an existing AKS cluster. If you don't specify a VM size, the default size is Standard_D2s_v3 for Windows node pools and Standard_DS2_v2 for Linux node pools.

> [!IMPORTANT]
> To provide better latency for intra-node calls and communications with platform services, select a VM series that supports [Accelerated Networking](/azure/virtual-network/create-vm-accelerated-networking-cli).

### Node pool creation

You can add a node pool to a new or existing AKS cluster by using the Azure portal, [Azure CLI](/cli/azure), the [AKS REST API](/rest/api/aks), or infrastructure as code (IaC) tools such as [Bicep](/azure/azure-resource-manager/bicep/overview), [Azure Resource Manager (ARM) templates](/azure/azure-resource-manager/templates/overview), or [Terraform](https://www.terraform.io). For more information on how to add node pools to an existing AKS cluster, see [Create and manage multiple node pools for a cluster in Azure Kubernetes Service (AKS)](/azure/aks/use-multiple-node-pools).

When you create a new node pool, the associated virtual machine scale set is created in the [node resource group](/azure/aks/faq#why-are-two-resource-groups-created-with-aks), an [Azure resource group](/azure/azure-resource-manager/management/overview) that contains all the infrastructure resources for the AKS cluster. These resources include the Kubernetes nodes, virtual networking resources, managed identities, and storage.

By default, the node resource group has a name like `MC_<resourcegroupname>_<clustername>_<location>`. AKS automatically deletes the node resource group when deleting a cluster, so you should use this resource group only for resources that share the cluster's lifecycle.

### Add a node pool

The following code example uses the Azure CLI [az aks nodepool add](/cli/azure/aks/nodepool#az_aks_nodepool_add) command to add a node pool named `mynodepool` with three nodes to an existing AKS cluster called `myAKSCluster` in the `myResourceGroup` resource group.

```azurecli-interactive
az aks nodepool add \
      --resource-group myResourceGroup \
      --cluster-name myAKSCluster \
      --node-vm-size Standard_D8ds_v4 \
      --name mynodepool \
      --node-count 3
```

### Spot node pools

A spot node pool is a node pool backed by a [spot virtual machine scale set](/azure/virtual-machine-scale-sets/use-spot). Using spot virtual machines for nodes with your AKS cluster takes advantage of unutilized Azure capacity at a significant cost savings. The amount of available unutilized capacity varies based on many factors, including node size, region, and time of day.

When deploying a spot node pool, Azure allocates the spot nodes if there's capacity available. But there's no SLA for the spot nodes. A spot scale set that backs the spot node pool is deployed in a single fault domain and offers no high availability guarantees. When Azure needs the capacity back, the Azure infrastructure evicts spot nodes, and you get at most a 30-second notice before eviction. Be aware that a spot node pool can't be the cluster's default node pool. A spot node pool can be used only for a secondary pool.

Spot nodes are for workloads that can handle interruptions, early terminations, or evictions. For example, batch processing jobs, development and testing environments, and large compute workloads are good candidates for scheduling on a spot node pool. For more details, see the [spot instance's limitations](/azure/virtual-machines/spot-vms#limitations).

The following `az aks nodepool add` command adds a spot node pool to an existing cluster with autoscaling enabled.

  ```azurecli-interactive
    az aks nodepool add \
        --resource-group myResourceGroup \
        --cluster-name myAKSCluster \
        --name myspotnodepool \
        --node-vm-size Standard_D8ds_v4 \
        --priority Spot \
        --eviction-policy Delete \
        --spot-max-price -1 \
        --enable-cluster-autoscaler \
        --min-count 1 \
        --max-count 3 \
        --no-wait
  ```

For more information on spot node pools, see [Add a spot node pool to an Azure Kubernetes Service (AKS) cluster](/azure/aks/spot-node-pool).

### Ephemeral OS disks

By default, Azure automatically replicates the VM operating system (OS) disk to Azure Storage to avoid data loss if the VM needs to be relocated to another host. But because containers aren't designed to persist local state, keeping the OS disk in storage offers limited value for AKS. There are some drawbacks, such as slower node provisioning and higher read/write latency.

By contrast, ephemeral OS disks are stored only on the host machine, like a temporary disk, and provide lower read/write latency and faster node scaling and cluster upgrades. Like a temporary disk, an ephemeral OS disk is included in the VM price, so you incur no extra storage costs.

> [!IMPORTANT]
> If you don't explicitly request managed disks for the OS, AKS defaults to an ephemeral OS if possible for a given node pool configuration.

To use ephemeral OS, the OS disk must fit in the VM cache. Azure VM documentation shows VM cache size in parentheses next to IO throughput as **cache size in GiB**.

For example, the AKS default Standard_DS2_v2 VM size with the default 100-GB OS disk size supports ephemeral OS, but has only 86 GB of cache size. This configuration defaults to managed disk if you don't explicitly specify otherwise. If you explicitly request ephemeral OS for this size, you get a validation error.

If you request the same Standard_DS2_v2 VM with a 60-GB OS disk, you get ephemeral OS by default. The requested 60-GB OS size is smaller than the maximum 86-GB cache size.

Standard_D8s_v3 with a 100-GB OS disk supports ephemeral OS and has 200 GB of cache space. If a user doesn't specify the OS disk type, a node pool gets ephemeral OS by default.

The following `az aks nodepool add` command shows how to add a new node pool to an existing cluster with an ephemeral OS disk. The `--node-osdisk-type` parameter sets the OS disk type to `Ephemeral`, and the `--node-osdisk-size` parameter defines the OS disk size.

  ```azurecli-interactive
    az aks nodepool add \
        --resource-group myResourceGroup \
        --cluster-name myAKSCluster \
        --name mynewnodepool \
        --node-vm-size Standard_D8ds_v4 \
        --node-osdisk-type Ephemeral \
        --node-osdisk-size 48
  ```

For more information about ephemeral OS disks, see [Ephemeral OS](/azure/aks/cluster-configuration#ephemeral-os).

### Virtual nodes

You can use virtual nodes to quickly scale out application workloads in an AKS cluster. Virtual nodes give you quick pod provisioning, and you only pay per second for execution time. You don't need to wait for the cluster autoscaler to deploy new worker nodes to run more pod replicas. Virtual nodes are supported only with Linux pods and nodes. The virtual nodes add-on for AKS is based on the open-source [Virtual Kubelet](https://github.com/virtual-kubelet/virtual-kubelet) project.

Virtual node functionality depends on [Azure Container Instances](/azure/container-instances). For more information about virtual nodes, see [Create and configure an Azure Kubernetes Services (AKS) cluster to use virtual nodes](/azure/aks/virtual-nodes?msclkid=dd523912ab5b11ec9eaa4f3e842760f0).

### Taints, labels, and tags

When you create a node pool, you can add Kubernetes [taints](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration) and [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels), and [Azure tags](/azure/azure-resource-manager/management/tag-resources), to that node pool. When you add a taint, label, or tag, all nodes within that node pool get that taint, label, or tag.

To create a node pool with a taint, you can use the `az aks nodepool add` command with the `--node-taints` parameter. To label the nodes in a node pool, you can use the `--labels` parameter and specify a list of labels, as shown in the following code:

```azurecli-interactive
  az aks nodepool add \
      --resource-group myResourceGroup \
      --cluster-name myAKSCluster \
      --name mynodepool \
      --node-vm-size Standard_NC6 \
      --node-taints sku=gpu:NoSchedule \
      --labels dept=IT costcenter=9999
```

For more information, see [Specify a taint, label, or tag for a node pool](/azure/aks/use-multiple-node-pools#specify-a-taint-label-or-tag-for-a-node-pool).

### Reserved system labels

Amazon EKS adds automated Kubernetes labels to all nodes in a managed node group like `eks.amazonaws.com/capacityType`, which specifies the capacity type. AKS also automatically adds system labels to agent nodes.

The following prefixes are reserved for AKS use and can't be used for any node:

- `kubernetes.azure.com/`
- `kubernetes.io/`

For other reserved prefixes, see [Kubernetes well-known labels, annotations, and taints](https://kubernetes.io/docs/reference/labels-annotations-taints).

The following table lists labels that are reserved for AKS use and can't be used for any node. In the table, the **Virtual node usage** column specifies whether the label is supported on virtual nodes.

In the **Virtual node usage** column:

- **N/A** means the property doesn't apply to virtual nodes because it would require modifying the host.
- **Same** means the expected values are the same for a virtual node pool as for a standard node pool.
- **Virtual** replaces VM SKU values, because virtual node pods don't expose any underlying VM.
- **Virtual node version** refers to the current version of the [virtual Kubelet-ACI connector release](https://github.com/virtual-kubelet/azure-aci/releases).
- **Virtual node subnet name** is the subnet that deploys virtual node pods into Azure Container Instances.
- **Virtual node virtual network** is the virtual network that contains the virtual node subnet.

| Label | Value | Example, options | Virtual node usage |
| ---- | --- | --- | --- |
| kubernetes.azure.com/agentpool| `<agent pool name>` | `nodepool1` | Same |
| kubernetes.io/arch | amd64 | `runtime.GOARCH` | N/A |
| kubernetes.io/os| `<OS Type>` | `Linux` or `Windows` | `Linux` |
| node.kubernetes.io/instance-type| `<VM size>` | `Standard_NC6` | `Virtual` |
| topology.kubernetes.io/region| `<Azure region>` | `westus2` | Same |
| topology.kubernetes.io/zone| `<Azure zone>` | `0` | Same |
| kubernetes.azure.com/cluster| `<MC_RgName>` | `MC_aks_myAKSCluster_westus2` | Same |
| kubernetes.azure.com/mode| `<mode>` | `User` or `System` | `User` |
| kubernetes.azure.com/role | agent | `Agent` | Same |
| kubernetes.azure.com/scalesetpriority| `<scale set priority>` | `Spot` or `Regular` | N/A |
| kubernetes.io/hostname| `<hostname>` | `aks-nodepool-00000000-vmss000000` | Same |
| kubernetes.azure.com/storageprofile| `<OS disk storage profile>` | `Managed` | N/A |
| kubernetes.azure.com/storagetier| `<OS disk storage tier>` | `Premium_LRS` | N/A |
| kubernetes.azure.com/instance-sku| `<SKU family>` | `Standard_N` | `Virtual` |
| kubernetes.azure.com/node-image-version| `<VHD version>` | `AKSUbuntu-1804-2020.03.05` | Virtual node version |
| kubernetes.azure.com/subnet| `<nodepool subnet name>` | `subnetName` | Virtual node subnet name |
| kubernetes.azure.com/vnet| `<nodepool virtual network name>` | `vnetName` | Virtual node virtual network |
| kubernetes.azure.com/ppg | `<nodepool ppg name>` | `ppgName` | N/A |
| kubernetes.azure.com/encrypted-set| `<nodepool encrypted-set name>` | `encrypted-set-name` | N/A |
| kubernetes.azure.com/accelerator| `<accelerator>` | `Nvidia` | N/A |
| kubernetes.azure.com/fips_enabled| `<fips enabled>` | `True` | N/A |
| kubernetes.azure.com/os-sku| `<os/sku>` | See [Create or update OS SKU](/rest/api/aks/agent-pools/create-or-update#ossku) | Linux SKU |

### Windows node pools

AKS supports creating and using Windows Server container node pools through the [Azure CNI](/azure/aks/concepts-network#azure-cni-advanced-networking) network plugin. To plan the required subnet ranges and network considerations, see [configure Azure CNI networking](/azure/aks/configure-azure-cni).

The following `az aks nodepool add` command adds a node pool that runs Windows Server containers.

```azurecli-interactive
  az aks nodepool add \
      --resource-group myResourceGroup \
      --cluster-name myAKSCluster \
      --name mywindowsnodepool \
      --node-vm-size Standard_D8ds_v4 \
      --os-type Windows \
      --node-count 1
```

The preceding command uses the default subnet in the AKS cluster virtual network. For more information about how to build an AKS cluster with a Windows node pool, see [Create a Windows Server container in AKS](/azure/aks/windows-container-cli).

### Node pool considerations

The following considerations and limitations apply when you create and manage node pools and multiple node pools:

- [Quotas, VM size restrictions, and region availability](/azure/aks/quotas-skus-regions) apply to AKS node pools.

- System pools must contain at least one node. You can delete a system node pool if you have another system node pool to take its place in the AKS cluster. User node pools can contain zero or more nodes.

- You can't change the VM size of a node pool after you create it.

- For multiple node pools, the AKS cluster must use the Standard SKU load balancers. Basic SKU load balancers don't support multiple node pools.

- All cluster node pools must be in the same virtual network, and all subnets assigned to any node pool must be in the same virtual network.

- If you create multiple node pools at cluster creation time, the Kubernetes versions for all node pools must match the control plane version. You can update versions after the cluster has been provisioned by using per-node-pool operations.

## Node pool scaling

As your application workload changes, you might need to change the number of nodes in a node pool. You can scale the number of nodes up or down manually by using the [az aks nodepool scale](/cli/azure/aks/nodepool#az_aks_nodepool_scale) command. The following example scales the number of nodes in `mynodepool` to five:

```azurecli-interactive
az aks nodepool scale \
    --resource-group myResourceGroup \
    --cluster-name myAKSCluster \
    --name mynodepool \
    --node-count 5
```

### Scale node pools automatically by using the cluster autoscaler

AKS supports scaling node pools automatically with the [cluster autoscaler](/azure/aks/cluster-autoscaler). You enable this feature on each node pool, and define a minimum and a maximum number of nodes.

The following `az aks nodepool add` command adds a new node pool called `mynodepool` to an existing cluster. The `--enable-cluster-autoscaler` parameter enables the cluster autoscaler on the new node pool, and the `--min-count` and `--max-count` parameters specify the minimum and maximum number of nodes in the pool.

```azurecli-interactive
  az aks nodepool add \
  --resource-group myResourceGroup \
  --cluster-name myAKSCluster \
  --name mynewnodepool \
  --node-vm-size Standard_D8ds_v4 \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 5
```

The following [az aks nodepool update](/cli/azure/aks/nodepool#az-aks-nodepool-update) command updates the minimum number of nodes from one to three for the `mynewnodepool` node pool.

```azurecli-interactive
  az aks nodepool update \
  --resource-group myResourceGroup \
  --cluster-name myAKSCluster \
  --name mynewnodepool \
  --update-cluster-autoscaler \
  --min-count 1 \
  --max-count 3
```

You can disable the cluster autoscaler with `az aks nodepool update` by passing the `--disable-cluster-autoscaler` parameter.

```azurecli-interactive
  az aks nodepool update \
  --resource-group myResourceGroup \
  --cluster-name myAKSCluster \
  --name mynodepool \
  --disable-cluster-autoscaler
```

To re-enable the cluster autoscaler on an existing cluster, use `az aks nodepool update`, specifying the `--enable-cluster-autoscaler`, `--min-count`, and `--max-count` parameters.

For more information about how to use the cluster autoscaler for individual node pools, see [Automatically scale a cluster to meet application demands on Azure Kubernetes Service (AKS)](/azure/aks/cluster-autoscaler).

## Updates and upgrades

Azure periodically updates its VM hosting platform to improve reliability, performance, and security. These updates range from patching software components in the hosting environment to upgrading networking components or decommissioning hardware. For more information about how Azure updates VMs, see [Maintenance for virtual machines in Azure](/azure/virtual-machines/maintenance-and-updates).

VM hosting infrastructure updates don't usually affect hosted VMs, such as agent nodes of existing AKS clusters. For updates that affect hosted VMs, Azure minimizes the cases that require reboots by pausing the VM while updating the host, or live-migrating the VM to an already updated host.

If an update requires a reboot, Azure provides notification and a time window so you can start the update when it works for you. The self-maintenance window for host machines is typically 35 days, unless the update is urgent.

You can use Planned Maintenance to update VMs, and manage planned maintenance notifications with [Azure CLI](/azure/virtual-machines/maintenance-notifications-cli), [PowerShell](/azure/virtual-machines/maintenance-notifications-powershell), or the [Azure portal](/azure/virtual-machines/maintenance-notifications-portal). Planned Maintenance detects if you're using Cluster Auto-Upgrade, and schedules upgrades during your maintenance window automatically. For more information about Planned Maintenance, see the [az aks maintenanceconfiguration](/cli/azure/aks/maintenanceconfiguration) command and [Use Planned Maintenance to schedule maintenance windows for your Azure Kubernetes Service (AKS) cluster](/azure/aks/planned-maintenance).

### Kubernetes upgrades

Part of the AKS cluster lifecycle is periodically upgrading to the latest Kubernetes version. It's important to apply upgrades to get the latest security releases and features. To upgrade the Kubernetes version of existing node pool VMs, you must cordon and drain nodes and replace them with new nodes that are based on an updated Kubernetes disk image.

By default, AKS configures upgrades to surge with one extra node. A default value of one for the `max-surge` settings minimizes workload disruption by creating an extra node to replace older-versioned nodes before cordoning or draining existing applications. You can customize the `max-surge` value per node pool to allow for a tradeoff between upgrade speed and upgrade disruption. Increasing the `max-surge` value completes the upgrade process faster, but a large value for `max-surge` might cause disruptions during the upgrade process.

For example, a `max-surge` value of 100% provides the fastest possible upgrade process by doubling the node count, but also causes all nodes in the node pool to be drained simultaneously. You might want to use this high value for testing, but for production node pools, a `max-surge` setting of 33% is better.

AKS accepts both integer and percentage values for `max-surge`. An integer such as `5` indicates five extra nodes to surge. Percent values for `max-surge` can be a minimum of `1%` and a maximum of `100%`, rounded up to the nearest node count. A value of `50%` indicates a surge value of half the current node count in the pool.

During an upgrade, the `max-surge` value can be a minimum of `1` and a maximum value equal to the number of nodes in the node pool. You can set larger values, but the maximum number of nodes used for `max-surge` won't be higher than the number of nodes in the pool.

> [!IMPORTANT]
> For upgrade operations, node surges need enough subscription quota for the requested `max-surge` count. For example, a cluster that has five node pools, each with four nodes, has a total of 20 nodes. If each node pool has a `max-surge` value of 50%, you need additional compute and IP quota of 10 nodes, or two nodes times five pools, to complete the upgrade.
>
> If you use Azure Container Networking Interface (CNI), also make sure you have enough IPs in the subnet to [meet CNI requirements for AKS](/azure/aks/configure-azure-cni).

### Upgrade node pools

To see available upgrades, use [az aks get-upgrades](/cli/azure/aks#az_aks_get_upgrades).

```azurecli-interactive
az aks get-upgrades --resource-group <myResourceGroup> --name <myAKSCluster>
```

To see the status of node pools, use [az aks nodepool list](/cli/azure/aks/nodepool#az_aks_nodepool_list).

```azurecli-interactive
  az aks nodepool list -g <myResourceGroup> --cluster-name <myAKSCluster>
```

The following command uses [az aks nodepool upgrade](/cli/azure/aks/nodepool#az_aks_nodepool_upgrade) to upgrade a single node pool. 

```azurecli-interactive
  az aks nodepool upgrade \
      --resource-group <myResourceGroup> \
      --cluster-name <myAKSCluster> \
      --name <mynodepool> \
      --kubernetes-version <KUBERNETES_VERSION>
```

For more information about how to upgrade the Kubernetes version for a cluster control plane and node pools, see:

- [Azure Kubernetes Service (AKS) node image upgrade](/azure/aks/node-image-upgrade)
- [Upgrade a cluster control plane with multiple node pools](/azure/aks/use-multiple-node-pools#upgrade-a-cluster-control-plane-with-multiple-node-pools)

### Upgrade considerations

Note these best practices and considerations for upgrading the Kubernetes version in an AKS cluster.

- It's best to upgrade all node pools in an AKS cluster to the same Kubernetes version. The default behavior of `az aks upgrade` upgrades all node pools and the control plane.

- Manually upgrade, or set an auto-upgrade channel on your cluster. If you use Planned Maintenance to patch VMs, auto-upgrades also start during your specified maintenance window. For more information, see [Upgrade an Azure Kubernetes Service (AKS) cluster](/azure/aks/upgrade-cluster).

- The `az aks upgrade` command with the `--control-plane-only` flag upgrades only the cluster control plane and doesn't change any of the associated node pools in the cluster. To upgrade individual node pools, specify the target node pool and Kubernetes version in the `az aks nodepool upgrade` command, 

- An AKS cluster upgrade triggers a cordon and drain of your nodes. If you have low compute quota available, the upgrade could fail. For more information about increasing your quota, see [Increase regional vCPU quotas](/azure/azure-portal/supportability/regional-quota-requests).

- Configure the `max-surge` parameter based on your needs, using an integer or a percentage value. For production node pools, use a `max-surge` setting of 33%. For more information, see [Customize node surge upgrade](/azure/aks/upgrade-cluster#customize-node-surge-upgrade).

- When you upgrade an AKS cluster that uses CNI networking, make sure the subnet has enough available private IP addresses for the extra nodes the `max-surge` settings create. For more information, see [Configure Azure CNI networking in Azure Kubernetes Service (AKS)](/azure/aks/configure-azure-cni).

- If your cluster node pools span multiple Availability Zones within a region, the upgrade process can temporarily cause an unbalanced zone configuration. For more information, see [Special considerations for node pools that span multiple Availability Zones](/azure/aks/upgrade-cluster#special-considerations-for-node-pools-that-span-multiple-availability-zones).

## Node virtual networks

When you create a new cluster or add a new node pool to an existing cluster, you specify the resource ID of a subnet within the cluster [virtual network](/azure/virtual-network/virtual-networks-overview) where you deploy the agent nodes. A workload might require splitting a cluster's nodes into separate node pools for logical isolation. You can achieve this isolation with separate subnets, each dedicated to a separate node pool. The node pool VMs each get a private IP address from their associated subnet.

AKS supports two networking plugins:

- [Kubenet](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/#kubenet) is a basic, simple network plugin for Linux. With `kubenet`, nodes get a private IP address from the Azure virtual network subnet. Pods get an IP address from a logically different address space. Network address translation (NAT) lets the pods reach resources on the Azure virtual network by translating the source traffic's IP address to the node's primary IP address. This approach reduces the number of IP addresses you need to reserve in your network space for pods.

- [Azure Container Networking Interface (CNI)](https://github.com/Azure/azure-container-networking/blob/master/docs/cni.md) gives every pod an IP address to call and access directly. These IP addresses must be unique across your network space. Each node has a configuration parameter for the maximum number of pods that it supports. The equivalent number of IP addresses per node are then reserved for that node. This approach requires advance planning, and can lead to IP address exhaustion or the need to rebuild clusters in a larger subnet as application demands grow.

  When you create a new cluster or add a new node pool to a cluster that uses Azure CNI, you can specify the resource ID of two separate subnets, one for the nodes and one for the pods. For more information, see [Dynamic allocation of IPs and enhanced subnet support](/azure/aks/configure-azure-cni#dynamic-allocation-of-ips-and-enhanced-subnet-support-preview).

### Dynamic IP allocation

Pods that use [Azure CNI](/azure/aks/configure-azure-cni) get private IP addresses from a subnet of the hosting node pool. Azure CNI [dynamic IP allocation](/azure/aks/configure-azure-cni#dynamic-allocation-of-ips-and-enhanced-subnet-support-preview) can allocate private IP addresses to pods from a subnet that's separate from the node pool hosting subnet. This feature provides the following advantages:

- The pod subnet dynamically allocates IPs to pods. Dynamic allocation provides better IP utilization compared to the traditional CNI solution, which does static allocation of IPs for every node.

- You can scale and share node and pod subnets independently. You can share a single pod subnet across multiple node pools or clusters deployed in the same virtual network. You can also configure a separate pod subnet for a node pool.

- Because pods have virtual network private IPs, they have direct connectivity to other cluster pods and resources in the virtual network. This ability supports better performance for very large clusters.

- If pods have a separate subnet, you can configure virtual network policies for pods that are different from node policies. Separate policies allow many useful scenarios, such as allowing internet connectivity only for pods and not for nodes, fixing the source IP for a pod in a node pool by using NAT Gateway, and using [Network Security Groups (NSGs)](/azure/virtual-network/network-security-groups-overview) to filter traffic between node pools.

- Both *Network Policy* and *Calico* Kubernetes network policies work with dynamic IP allocation.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal System Engineer

Other contributors:

- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Software Engineer
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
- [Cost management for Kubernetes](cost-management.yml)
- [Cluster governance](governance.md)
- [Azure Kubernetes Service (AKS) solution journey](../../reference-architectures/containers/aks-start-here.md)
- [Azure Kubernetes Services (AKS) day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)
- [Choose a Kubernetes at the edge compute option](../../operator-guides/aks/choose-kubernetes-edge-compute-option.md)
- [GitOps for Azure Kubernetes Service](../../example-scenario/gitops-aks/gitops-blueprint-aks.yml)

## Related resources

- [AKS cluster best practices](/azure/aks/best-practices)
- [Create a Private AKS cluster with a Public DNS Zone](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/private-aks-cluster-with-public-dns-zone)
- [Create a private Azure Kubernetes Service cluster using Terraform and Azure DevOps](https://github.com/azure-samples/private-aks-cluster-terraform-devops)
- [Create a public or private Azure Kubernetes Service cluster with Azure NAT Gateway and Azure Application Gateway](https://github.com/Azure-Samples/aks-nat-agic)
- [Use Private Endpoints with a Private AKS Cluster](https://github.com/azure-samples/private-aks-cluster)
- [Create an Azure Kubernetes Service cluster with the Application Gateway Ingress Controller](https://github.com/Azure-Samples/aks-agic)
- [Introduction to Kubernetes](/learn/modules/intro-to-kubernetes/)
- [Introduction to Kubernetes on Azure](/learn/paths/intro-to-kubernetes-on-azure/)
- [Implement Azure Kubernetes Service (AKS)](/learn/modules/implement-azure-kubernetes-service/)
- [Develop and deploy applications on Kubernetes](/learn/paths/develop-deploy-applications-kubernetes/)
- [Optimize compute costs on Azure Kubernetes Service (AKS)](/learn/modules/aks-optimize-compute-costs/)

