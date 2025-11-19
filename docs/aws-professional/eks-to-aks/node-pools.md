---
title: Manage Kubernetes Nodes and Node Pools
description: Understand Kubernetes nodes and node pools, how to handle Azure Kubernetes Service (AKS) nodes and node pools, and node pool options for Amazon EKS and AKS.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - devx-track-azurecli
  - arb-containers
ms.collection:
  - migration
  - aws-to-azure
---

# Manage Kubernetes nodes and node pools

Kubernetes architecture consists of two layers: the [control plane](/azure/aks/concepts-clusters-workloads#control-plane) and at least one [node in a node pool](/azure/aks/concepts-clusters-workloads#nodes). This article describes and compares how Amazon Elastic Kubernetes Service (EKS) and Azure Kubernetes Service (AKS) manage agent nodes and worker nodes.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

In both Amazon EKS and AKS, the cloud platform provides and manages the control plane layer, and the customer manages the node layer. The following diagram shows the relationship between the control plane and nodes in AKS Kubernetes architecture.

:::image type="complex" source="./media/control-plane-and-nodes.svg" border="false" lightbox="./media/control-plane-and-nodes.svg" alt-text="Diagram that shows the control plane and nodes in AKS architecture.":::
The diagram is divided into two sections: Azure-managed and Customer-managed. The Azure-managed section includes the control plane, which has the components: the API server, scheduler, etcd (a key-value store), and controller manager. The API server connects to the other three components. The Customer-managed section includes nodes that have the components: kubelet, container runtime, kube-proxy, and a container. The scheduler in the control plane connects to kubelet. Kubelet connects to container runtime, which connects to the container. 
:::image-end:::

## Amazon EKS managed node groups

Amazon EKS [managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) automate the provisioning and lifecycle management of Amazon Elastic Compute Cloud (EC2) worker nodes for Amazon EKS clusters. Amazon Web Services (AWS) users can use the [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) command-line utility to create, update, or terminate nodes for their EKS clusters. Node updates and terminations automatically cordon and drain nodes to help ensure that applications remain available.

Every managed node is provisioned as part of an [Amazon EC2 auto scaling group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that Amazon EKS operates and controls. The [Kubernetes cluster autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html#cluster-autoscaler) automatically adjusts the number of worker nodes in a cluster when pods fail or are rescheduled onto other nodes. You can configure each node group to run across multiple [availability zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-availability-zones) within a region.

For more information, see [Create a managed node group](https://docs.aws.amazon.com/eks/latest/userguide/create-managed-node-group.html) and [Update a managed node group](https://docs.aws.amazon.com/eks/latest/userguide/update-managed-node-group.html).

You can also run Kubernetes pods on [AWS Fargate](https://aws.amazon.com/fargate). Fargate provides on-demand, right-sized compute capacity for containers. For more information, see [Simplify compute management](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html).

### Karpenter

[Karpenter](https://karpenter.sh/) is an open-source project that helps improve node lifecycle management within Kubernetes clusters. It automates provisioning and deprovisioning of nodes based on the specific scheduling needs of pods, which improves scaling and cost optimization. Use Karpenter for the following main functions:

- Monitor pods that the Kubernetes scheduler can't schedule because of resource constraints.

- Evaluate scheduling requirements, such as resource requests, node selectors, affinities, and tolerations, of the unschedulable pods.
- Configure new nodes that meet the requirements of the unschedulable pods.
- Remove nodes when you no longer need them.

You can use Karpenter to define node pools that have constraints on node provisioning, like taints, labels, requirements (instance types and zones), and limits on total provisioned resources. When you deploy workloads, specify various scheduling constraints in the pod specifications. For example, you can specify resource requests or limits, node selectors, node or pod affinities, tolerations, and topology spread constraints. Karpenter then configures right-sized nodes based on these specifications.

Before the launch of Karpenter, Amazon EKS users relied primarily on [Amazon EC2 auto scaling groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) and the [Kubernetes cluster autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) to dynamically adjust the compute capacity of their clusters. You don't need to create dozens of node groups to achieve the flexibility and diversity that Karpenter provides. Unlike the Kubernetes cluster autoscaler, Karpenter is less dependent on Kubernetes versions and doesn't require transitions between AWS and Kubernetes APIs.

Karpenter consolidates instance orchestration responsibilities within a single system, which is simpler, more stable, and more cluster-aware. Karpenter helps overcome challenges of the cluster autoscaler by providing simplified ways to:

- Configure nodes based on workload requirements.

- Create diverse node configurations by instance type by using flexible node pool options. Instead of managing several specific custom node groups, use Karpenter to manage diverse workload capacity by using a single, flexible node pool.
- Achieve improved pod scheduling at scale by quickly launching nodes and scheduling pods.

Compared to [auto scaling groups](https://aws.amazon.com/blogs/containers/amazon-eks-cluster-multi-zone-auto-scaling-groups/) and [managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html), Karpenter integrates scaling management more closely with Kubernetes-native APIs. Auto scaling groups and managed node groups are AWS-native abstractions that trigger scaling based on AWS level metrics, such as EC2 CPU load. Although the [cluster autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html#cluster-autoscaler) bridges Kubernetes abstractions to AWS abstractions, it sacrifices some flexibility, such as scheduling for a specific availability zone.

Karpenter simplifies node management by eliminating AWS-specific components, which provides greater flexibility directly within Kubernetes. Use Karpenter for clusters that run workloads that encounter periods of high, spiky demand or have diverse compute requirements. Use managed node groups and auto scaling groups for clusters that run more static and consistent workloads. Depending on your requirements, you can use a combination of dynamically and statically managed nodes.

### Kata Containers

[Kata Containers](https://katacontainers.io/) is an open-source project that provides a highly secure container runtime. It combines the lightweight nature of containers with the security benefits of virtual machines (VMs). Kata Containers enhances workload isolation and security by launching each container with a different guest operating system, unlike traditional containers that share the same Linux Kernel among workloads. Kata Containers runs containers in an Open Container Initiative (OCI)-compliant VM, which provides strict isolation between containers on the same host machine. Kata Containers provides the following features:

- **Enhanced workload isolation:** Each container runs in its own lightweight VM to help ensure isolation at the hardware level.

- **Improved security:** The use of VM technology provides an extra layer of security, which reduces the risk of container breakouts.
- **Compatibility with industry standards:** Kata Containers integrates with industry-standard tools, such as the OCI container format and Kubernetes Container Runtime Interface.
- **Support for multiple architectures and hypervisors:** Kata Containers supports AMD64 and ARM architectures, and you can use it with hypervisors like Cloud Hypervisor and Firecracker.
- **Easy deployment and management:** Kata Containers simplifies workload orchestration because it uses the Kubernetes orchestration system.

To set up and run Kata Containers on AWS, configure an [Amazon EKS](https://aws.amazon.com/eks/) cluster to use [Firecracker](https://firecracker-microvm.github.io/). Firecracker is an open-source virtualization technology from Amazon that helps you create and manage secure, multitenant container-based and function-based services. Use Firecracker to deploy workloads in lightweight VMs, called *microVMs*, which provide enhanced security and workload isolation compared to traditional VMs. MicroVMs also improve the speed and resource efficiency of containers. Follow the [steps to run Kata Containers on AWS EKS](https://aws.amazon.com/blogs/containers/enhancing-kubernetes-workload-isolation-and-security-using-kata-containers/).

### Dedicated hosts

When you use [Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) to deploy and run containers, you can run the containers on [Amazon EC2 dedicated hosts](https://aws.amazon.com/ec2/dedicated-hosts/). However, this feature is only available for self-managed node groups. So you must manually create a [launch template](https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-templates.html) and [auto scaling groups](https://aws.amazon.com/blogs/containers/amazon-eks-cluster-multi-zone-auto-scaling-groups/). Then register the dedicated hosts, launch template, and auto scaling groups with the EKS cluster. To create these resources, use the same method as general EC2 auto scaling.

For more information about how to use AWS EKS to run containers on EC2 dedicated hosts, see the following resources:

- [Amazon EKS nodes](https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html)
- [Dedicated host restrictions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-overview.html#dedicated-hosts-limitations)
- [Allocate dedicated hosts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-allocating.html)
- [Purchase dedicated host reservations](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-billing.html#dedicated-host-reservations)
- [Automatic placement](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-understanding.html)

## AKS nodes and node pools

When you create an AKS cluster automatically, it creates and configures a control plane, which provides [core Kubernetes services](https://kubernetes.io/docs/concepts/overview/components) and application workload orchestration. The Azure platform provides the AKS control plane at no cost as a managed Azure resource. The control plane and its resources exist only in the region where you create the cluster.

The [nodes](/azure/aks/concepts-clusters-workloads#nodes), also called *agent nodes* or *worker nodes*, host the workloads and applications. In AKS, you fully manage and pay for the agent nodes that are attached to the AKS cluster.

To run applications and supporting services, an AKS cluster needs at least one node, which is an Azure VM that runs the Kubernetes node components and container runtime. Every AKS cluster must contain at least one [system node pool](/azure/aks/use-system-pools) that has at least one node.

AKS combines nodes of the same configuration into node pools of VMs that run AKS workloads. Use system node pools to host critical system pods, such as CoreDNS. Use user node pools to host workload pods. If you want only one node pool in your AKS cluster, for example in a development environment, you can schedule application pods on the system node pool.

:::image type="complex" source="./media/node-resource-interactions.svg" border="false" lightbox="./media/node-resource-interactions.svg" alt-text="Diagram that shows a single Kubernetes node.":::
The Azure VM contains four components: kubelet, container runtime, kube-proxy, and a container. The Azure virtual network connects to the Azure virtual network interface, which connects to the kube-proxy component. Kubelet connects to container runtime, and container runtime connects to the container. Azure disk storage and Azure Files point to the container.
:::image-end:::

You can also create multiple user node pools to segregate different workloads on different nodes. This approach helps prevent the [noisy neighbor problem](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) and supports applications that have different compute or storage demands.

Every agent node within a system or user node pool is essentially a VM. [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) configures the VMs, and the AKS cluster manages them. For more information, see [Node pools](/azure/aks/concepts-clusters-workloads#node-pools).

You can define the initial number and [size](/azure/virtual-machines/sizes) for worker nodes when you create an AKS cluster or when you add new nodes and node pools to an existing AKS cluster. If you don't specify a VM size, the default size is Standard_D2s_v3 for Windows node pools and Standard_DS2_v2 for Linux node pools.

> [!IMPORTANT]
> To provide better latency for internal node calls and communications with platform services, choose a VM series that supports [Accelerated Networking](/azure/virtual-network/create-vm-accelerated-networking-cli).

### Create a node pool

When you create a new node pool, the associated virtual machine scale set is created in the [node resource group](/azure/aks/faq#why-are-two-resource-groups-created-with-aks-). This [Azure resource group](/azure/azure-resource-manager/management/overview) contains all the infrastructure resources for the AKS cluster. These resources include the Kubernetes nodes, virtual networking resources, managed identities, and storage.

By default, the node resource group has a name like `MC_<resourcegroupname>_<clustername>_<location>`. AKS automatically deletes the node resource group when it deletes a cluster. You should use this resource group only for resources that share the cluster's lifecycle.

For more information, see [Create node pools for a cluster in AKS](/azure/aks/create-node-pools).

### Add a node pool

To add a node pool to a new or existing AKS cluster, use the Azure portal, [Azure CLI](/cli/azure), or [AKS REST API](/rest/api/aks). You can also use infrastructure as code (IaC) tools, such as [Bicep](/azure/azure-resource-manager/bicep/overview), [Azure Resource Manager templates](/azure/azure-resource-manager/templates/overview), or [Terraform](https://www.terraform.io). 

The following code example uses the Azure CLI [az aks nodepool add](/cli/azure/aks/nodepool#az_aks_nodepool_add) command to add a node pool named `mynodepool` that has three nodes. It adds the node pool to an existing AKS cluster called `myAKSCluster` in the `myResourceGroup` resource group.

```azurecli-interactive
az aks nodepool add \
      --resource-group myResourceGroup \
      --cluster-name myAKSCluster \
      --node-vm-size Standard_D8ds_v4 \
      --name mynodepool \
      --node-count 3
```

### Spot node pools

A spot node pool is a node pool that a [spot virtual machine scale set](/azure/virtual-machine-scale-sets/use-spot) supports. Use spot VMs for nodes in your AKS cluster to take advantage of unused Azure capacity at a reduced cost. The amount of available unused capacity varies based on factors, such as node size, region, and time of day.

When you deploy a spot node pool, Azure allocates the spot nodes if capacity is available. But the spot nodes don't have a service-level agreement (SLA). A spot scale set that supports the spot node pool is deployed in a single fault domain and doesn't provide high-availability guarantees. When Azure needs the capacity, the Azure infrastructure evicts spot nodes. You receive a notice up to 30 seconds before eviction. You can't use a spot node pool as the cluster's default node pool. Use a spot node pool only as a secondary pool.

Use spot nodes for workloads that can handle interruptions, early terminations, or evictions. For example, schedule on a spot node pool for batch processing jobs, development and testing environments, and large compute workloads. For more information, see [Spot instance limitations](/azure/virtual-machines/spot-vms#limitations).

The following `az aks nodepool add` command adds a spot node pool to an existing cluster that has autoscaling enabled.

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

For more information, see [Add a spot node pool to an AKS cluster](/azure/aks/spot-node-pool).

### Ephemeral OS disks

By default, Azure automatically replicates the VM OS disk to Azure Storage. This approach prevents data loss if the VM needs to be relocated to another host. But containers aren't designed to retain local state, so storing the OS disk in Azure Storage provides limited benefits for AKS. This approach can lead to slower node provisioning and increased read and write latency.

By contrast, ephemeral OS disks are stored only on the host machine, like a temporary disk. They also provide lower read and write latency and faster node scaling and cluster upgrades. Like a temporary disk, the VM price includes an ephemeral OS disk, so you don't incur extra storage costs.

> [!IMPORTANT]
> If you don't explicitly request managed disks for the OS, AKS defaults to an ephemeral OS if possible for a given node pool configuration.

To use ephemeral OS, the OS disk must fit in the VM cache. Azure VM documentation shows VM cache size in parentheses next to input/output (I/O) throughput as **cache size in gibibytes (GiB)**.

For example, the AKS default Standard_DS2_v2 VM size with the default 100-GB OS disk size supports ephemeral OS but has only an 86-GB cache size. This configuration defaults to managed disks if you don't explicitly specify otherwise. If you explicitly request ephemeral OS for this size, you get a validation error.

If you request the same Standard_DS2_v2 VM with a 60-GB OS disk, you get ephemeral OS by default. The requested 60-GB OS size is smaller than the maximum 86-GB cache size.

Standard_D8s_v3 with a 100-GB OS disk supports ephemeral OS and has a 200-GB cache size. If you don't specify the OS disk type, a node pool gets ephemeral OS by default.

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

For more information, see [Ephemeral OS disk](/azure/aks/concepts-storage#ephemeral-os-disk).

### Azure Virtual Machines node pools in AKS

Every [managed node group in EKS](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) is backed by an [Amazon EC2 auto scaling group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) that Amazon EKS manages. This integration allows EKS to automatically configure and scale EC2 instances within the node group.

You can configure auto scaling groups to support multiple EC2 instance types, but you can't specify how many nodes to create or scale for each instance type. Instead, EKS manages the scaling of the node group based on your desired configuration and policies. This approach simplifies and automates the management process for the node group so that you can choose EC2 instance types that suit your workload requirements. You can also launch [self-managed Amazon Linux nodes](https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html) by using the `eksctl` command-line tool or the AWS Management Console.

For [Azure Virtual Machines node pools](/azure/aks/virtual-machines-node-pools), AKS configures and bootstraps each agent node. For Azure Virtual Machine Scale Sets node pools, AKS manages the model of Virtual Machine Scale Sets and uses it to achieve consistency across all agent nodes in the node pool. You can use Virtual Machines node pools to orchestrate your cluster with VMs that best fit your individual workloads. You can also specify how many nodes to create or scale for each VM size.

A node pool consists of a set of VMs that have different sizes. Each VM supports a different type of workload. These VM sizes, referred to as *SKUs*, are categorized into different families that are optimized for specific purposes. For more information, see [VM sizes in Azure](/azure/virtual-machines/sizes/overview).

To enable scaling of multiple VM sizes, the Virtual Machines node pool type uses a `ScaleProfile`. This profile configures how the node pool scales by specifying the desired VM size and count. A `ManualScaleProfile` is a scale profile that specifies the desired VM size and count. Only one VM size is allowed in a `ManualScaleProfile`. You need to create a separate `ManualScaleProfile` for each VM size in your node pool.

When you create a new Virtual Machines node pool, you need at least one `ManualScaleProfile` in the `ScaleProfile`. You can create multiple manual scale profiles for a single Virtual Machines node pool.

Advantages of Virtual Machines node pools include:

- **Flexibility:** You can update node specifications to suit your workloads and needs.

- **Fine-tuned control:** Single node-level controls help specify and combine nodes of different specifications to improve consistency.
- **Efficiency:** You can reduce the node footprint for your cluster to simplify your operational requirements.

Virtual Machines node pools provide a better experience for dynamic workloads and high-availability requirements. You can use them to set up multiple VMs of the same family in one node pool, and your workload is automatically scheduled on the available resources that you configure.

The following table compares Virtual Machines node pools with standard [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes) node pools.

| Node pool type                            | Capabilities                                                 |
| :---------------------------------------- | :----------------------------------------------------------- |
| Virtual Machines node pool                | You can add, remove, or update nodes in a node pool. VM types can be any VM of the same family type, such as D-series or A-series. |
| Virtual Machine Scale Sets node pool | You can add or remove nodes of the same size and type in a node pool. If you add a new VM size to the cluster, you need to create a new node pool. |

Virtual Machines node pools have the following limitations:

- The [cluster autoscaler](/azure/aks/cluster-autoscaler-overview) isn't supported.
- [InfiniBand](/azure/virtual-machines/extensions/enable-infiniband) isn't available.
- Windows node pools aren't supported.
- This feature isn't available in the Azure portal. Use the [Azure CLI](/cli/azure/get-started-with-azure-cli) or REST APIs to perform create, read, update, and delete (CRUD) operations or manage the pool.
- [Node pool snapshot](/azure/aks/node-pool-snapshot) isn't supported.
- All VM sizes in a node pool must be from the same VM family. For example, you can't combine an N-series VM type with a D-series VM type in the same node pool.
- Virtual Machines node pools allow up to five different VM sizes per node pool.

### Virtual nodes

You can use virtual nodes to quickly scale out application workloads in an AKS cluster. Virtual nodes provide quick pod provisioning, and you only pay per second for runtime. You don't need to wait for the cluster autoscaler to deploy new worker nodes to run more pod replicas. Only Linux pods and nodes support virtual nodes. The virtual nodes add-on for AKS is based on the open-source [Virtual Kubelet](https://virtual-kubelet.io/) project.

Virtual node functionality depends on [Azure Container Instances](/azure/container-instances). For more information, see [Create and configure an AKS cluster to use virtual nodes](/azure/aks/virtual-nodes).

### Taints, labels, and tags

When you create a node pool, you can add Kubernetes [taints](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration) and [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels) and [Azure tags](/azure/azure-resource-manager/management/tag-resources). Each taint, label, or tag applies to all nodes within that node pool.

To create a node pool that has a taint, you can use the `az aks nodepool add` command with the `--node-taints` parameter. To label the nodes in a node pool, use the `--labels` parameter and specify a list of labels, as shown in the following code:

```azurecli-interactive
  az aks nodepool add \
      --resource-group myResourceGroup \
      --cluster-name myAKSCluster \
      --name mynodepool \
      --node-vm-size Standard_NC6 \
      --node-taints sku=gpu:NoSchedule \
      --labels dept=IT costcenter=9999
```

For more information, see [Specify a taint, label, or tag for a node pool](/azure/aks/manage-node-pools?branch=main#specify-a-taint-label-or-tag-for-a-node-pool).

### Reserved system labels

Amazon EKS adds automated Kubernetes labels to all nodes in a managed node group like `eks.amazonaws.com/capacityType`, which specifies the capacity type. AKS also automatically adds system labels to agent nodes.

The following prefixes are reserved for AKS use and can't be used for nodes:

- `kubernetes.azure.com/`
- `kubernetes.io/`

For other reserved prefixes, see [Kubernetes well-known labels, annotations, and taints](https://kubernetes.io/docs/reference/labels-annotations-taints).

The following table lists labels that are reserved for AKS use and can't be used for nodes. In the table, the **Virtual node usage** column specifies whether virtual nodes support the label.

In the **Virtual node usage** column:

- **N/A** means that the property doesn't apply to virtual nodes because it requires modifying the host.
- **Same** means that the expected values are the same for a virtual node pool and a standard node pool.
- **Virtual** replaces VM SKU values, because virtual node pods don't expose underlying VMs.
- **Virtual node version** refers to the current version of the [virtual Kubelet-ACI connector release](https://github.com/virtual-kubelet/azure-aci/releases).
- **Virtual node subnet name** is the subnet that deploys virtual node pods into Container Instances.
- **Virtual node virtual network** is the virtual network that contains the virtual node subnet.

<!-- docutune:ignoredCasing io/os instance-sku os-sku -->

| Label | Value | Example or options | Virtual node usage |
| ---- | --- | --- | --- |
| `kubernetes.azure.com/agentpool` | `<agent pool name>` | `nodepool1` | Same |
| `kubernetes.io/arch` | `amd64` | `runtime.GOARCH` | N/A |
| `kubernetes.io/os` | `<OS type>` | `Linux` or `Windows` | `Linux` |
| `node.kubernetes.io/instance-type` | `<VM size>` | `Standard_NC6` | `Virtual` |
| `topology.kubernetes.io/region` | `<Azure region>` | `westus2` | Same |
| `topology.kubernetes.io/zone` | `<Azure zone>` | `0` | Same |
| `kubernetes.azure.com/cluster` | `<MC_RgName>` | `MC_aks_myAKSCluster_westus2` | Same |
| `kubernetes.azure.com/mode` | `<mode>` | `User` or `System` | `User` |
| `kubernetes.azure.com/role` | `agent` | `Agent` | Same |
| `kubernetes.azure.com/scalesetpriority` | `<scale set priority>` | `Spot` or `Regular` | N/A |
| `kubernetes.io/hostname` | `<hostname>` | `aks-nodepool-00000000-vmss000000` | Same |
| `kubernetes.azure.com/storageprofile` | `<OS disk storage profile>` | `Managed` | N/A |
| `kubernetes.azure.com/storagetier` | `<OS disk storage tier>` | `Premium_LRS` | N/A |
| `kubernetes.azure.com/instance-sku` | `<SKU family>` | `Standard_N` | `Virtual` |
| `kubernetes.azure.com/node-image-version` | `<VHD version>` | `AKSUbuntu-1804-2020.03.05` | Virtual node version |
| `kubernetes.azure.com/subnet` | `<nodepool subnet name>` | `subnetName` | Virtual node subnet name |
| `kubernetes.azure.com/vnet` | `<nodepool virtual network name>` | `vnetName` | Virtual node virtual network |
| `kubernetes.azure.com/ppg` | `<nodepool ppg name>` | `ppgName` | N/A |
| `kubernetes.azure.com/encrypted-set` | `<nodepool encrypted-set name>` | `encrypted-set-name` | N/A |
| `kubernetes.azure.com/accelerator` | `<accelerator>` | `nvidia` | N/A |
| `kubernetes.azure.com/fips_enabled` | `<fips enabled>` | `True` | N/A |
| `kubernetes.azure.com/os-sku` | `<os/sku>` | See [Create or update OS SKU](/rest/api/aks/agent-pools/create-or-update#ossku) | Linux SKU |

### Windows node pools

You can use AKS to create and use Windows Server container node pools through the [Azure Container Networking Interface](/azure/aks/concepts-network-cni-overview) network plugin. To plan the required subnet ranges and network considerations, see [Configure Azure Container Networking Interface](/azure/aks/configure-azure-cni).

The following `az aks nodepool add` command adds a node pool that runs Windows Server containers:

```azurecli-interactive
  az aks nodepool add \
      --resource-group myResourceGroup \
      --cluster-name myAKSCluster \
      --name mywindowsnodepool \
      --node-vm-size Standard_D8ds_v4 \
      --os-type Windows \
      --node-count 1
```

The preceding command uses the default subnet in the AKS cluster virtual network. For more information about how to build an AKS cluster that has a Windows node pool, see [Create a Windows Server container in AKS](/azure/aks/windows-container-cli).

### Node pool considerations

The following considerations and limitations apply when you create and manage single or multiple node pools:

- [Quotas, VM size restrictions, and region availability](/azure/aks/quotas-skus-regions) apply to AKS node pools.

- System pools must contain at least one node. You can delete a system node pool if you have another system node pool to take its place in the AKS cluster. User node pools can contain zero or more nodes.
- You can't change the VM size of a node pool after you create it.
- For multiple node pools, the AKS cluster must use Standard SKU load balancers. Basic SKU load balancers don't support multiple node pools.
- All cluster node pools must be in the same virtual network, and all subnets that are assigned to a node pool must be in the same virtual network.
- If you create multiple node pools when you create a cluster, the Kubernetes versions for all node pools must match the control plane version. To update versions after you configure the cluster, use per-node-pool operations.

## Scale node pools

As your application workload changes, you might need to change the number of nodes in a node pool. To manually scale the number of nodes up or down, use the [az aks nodepool scale](/cli/azure/aks/nodepool#az-aks-nodepool-scale) command. The following example scales the number of nodes in `mynodepool` to five:

```azurecli-interactive
az aks nodepool scale \
    --resource-group myResourceGroup \
    --cluster-name myAKSCluster \
    --name mynodepool \
    --node-count 5
```

### Scale node pools automatically

AKS supports scaling node pools automatically by using the [cluster autoscaler](/azure/aks/cluster-autoscaler). Enable this feature on each node pool, and define a minimum and a maximum number of nodes.

The following `az aks nodepool add` command adds a new node pool called `mynodepool` to an existing cluster. The `--enable-cluster-autoscaler` parameter enables the cluster autoscaler on the new node pool. The `--min-count` and `--max-count` parameters specify the minimum and maximum number of nodes in the pool.

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

To disable the cluster autoscaler, use the `az aks nodepool update` command with the `--disable-cluster-autoscaler` parameter.

```azurecli-interactive
  az aks nodepool update \
  --resource-group myResourceGroup \
  --cluster-name myAKSCluster \
  --name mynodepool \
  --disable-cluster-autoscaler
```

To re-enable the cluster autoscaler on an existing cluster, use the `az aks nodepool update` command, and specify the `--enable-cluster-autoscaler`, `--min-count`, and `--max-count` parameters.

For more information about how to use the cluster autoscaler for individual node pools, see [Use the cluster autoscaler in AKS](/azure/aks/cluster-autoscaler).

### Pod Sandboxing

To easily set up and run [Kata Containers](https://katacontainers.io/) on AKS as a fully managed solution, use [Pod Sandboxing](/azure/aks/use-pod-sandboxing). Pod Sandboxing is an AKS feature that creates an isolation boundary between the container application and the shared kernel and compute resources of the container host, like CPU, memory, and networking.

Pod Sandboxing complements other security measures or data protection controls to help tenant workloads secure sensitive information and meet regulatory, industry, or governance compliance requirements. These requirements include Payment Card Industry Data Security Standard (PCI DSS), International Organization for Standardization (ISO) 27001, and Health Insurance Portability and Accountability Act (HIPAA).

Deploy applications on separate clusters or node pools to help isolate the tenant workloads of different teams or customers. You might use multiple clusters and node pools if your organization or software as a service (SaaS) solution requires them. But some scenarios benefit from a single cluster that has shared VM node pools. For example, you might use a single cluster to run untrusted and trusted pods on the same node or colocate DaemonSets and privileged containers on the same node for faster local communication and functional grouping.

Pod Sandboxing can help you isolate tenant applications on the same cluster nodes without needing to run these workloads in separate clusters or node pools. Other methods might require that you recompile your code, or they might create other compatibility problems. Pod Sandboxing in AKS can run any unmodified container inside an enhanced security VM boundary.

Pod Sandboxing is based on [Kata Containers](https://katacontainers.io/) that runs on the [Azure Linux container host for AKS stack](/azure/aks/use-azure-linux) to provide hardware-enforced isolation. Kata Containers on AKS is built on a security-hardened Azure hypervisor. It achieves isolation for each pod via a nested, lightweight Kata VM that uses resources from a parent VM node. In this model, each Kata pod gets its own kernel in a nested Kata guest VM. Use this model to place several Kata containers in a single guest VM while continuing to run containers in the parent VM. This model provides a strong isolation boundary in a shared AKS cluster.

For more information, see [Support for Kata VM isolated containers on AKS for Pod Sandboxing](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/preview-support-for-kata-vm-isolated-containers-on-aks-for-pod/ba-p/3751557).

### Azure Dedicated Host

[Azure Dedicated Host](/azure/virtual-machines/dedicated-hosts) is a service that provides physical servers that are dedicated to a single Azure subscription to help ensure hardware isolation at the physical server level. You can provision these dedicated hosts within a region, availability zone, and fault domain. You can place VMs directly into the provisioned hosts.

Use Dedicated Host with AKS to provide the following benefits:

- Hardware isolation ensures that no other VMs are placed on the dedicated hosts, which provides an extra layer of isolation for tenant workloads. Dedicated hosts are deployed in the same datacenters and share the same network and underlying storage infrastructure as other nonisolated hosts.

- Dedicated Host provides control over maintenance events that the Azure platform initiates. You can choose a maintenance window to reduce the impact on services and help ensure the availability and privacy of tenant workloads.

Dedicated Host can help SaaS providers ensure that tenant applications meet regulatory, industry, and governance compliance requirements to secure sensitive information. For more information, see [Add Dedicated Host to an AKS cluster](/azure/aks/use-azure-dedicated-hosts).

### Karpenter

[Karpenter](https://karpenter.sh/) is an open-source, node-lifecycle management project built for Kubernetes. Add Karpenter to a Kubernetes cluster to improve the efficiency and cost of running workloads on that cluster. Karpenter watches for pods that the Kubernetes scheduler marks as unschedulable. It also dynamically provisions and manages nodes that can meet the pod requirements.

Karpenter provides fine-grained control over node provisioning and workload placement in a managed cluster. This control optimizes resource allocation, helps ensure isolation between each tenant's applications, and reduces operational costs, which improves multitenancy. When you build a multitenant solution on AKS, Karpenter provides useful capabilities to help manage diverse application requirements to support different tenants.

For example, you might need some tenants' applications to run on GPU-optimized node pools and others to run on memory-optimized node pools. If your application requires low latency for storage, you can use Karpenter to indicate that a pod requires a node that runs in a specific availability zone. Then you can colocate your storage and application tier.

AKS enables node autoprovisioning on AKS clusters via Karpenter. Most users should use the node autoprovisioning mode to enable Karpenter as a managed add-on. For more information, see [Node autoprovisioning](/azure/aks/node-autoprovision). If you need more advanced customization, you can self-host Karpenter. For more information, see [AKS Karpenter provider](https://github.com/Azure/karpenter-provider-azure).

### Confidential VMs

Confidential computing is a security measure that helps protect data while in use through software-assisted or hardware-assisted isolation and encryption. This technology adds an extra layer of security to traditional approaches, which helps safeguard data at rest and data in transit.

The AWS platform supports confidential computing through [Nitro Enclaves](https://aws.amazon.com/ec2/nitro/nitro-enclaves/), which are [available on EC2 instances and Amazon EKS](https://aws.amazon.com/about-aws/whats-new/2022/11/aws-nitro-enclaves-supports-amazoneks-kubernetes/). Amazon EC2 instances also support [AMD Secure Encrypted Virtualization Secure Nested Paging (SEV-SNP)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sev-snp.html). The [Runtime Attestation GitHub repository](https://github.com/aws-samples/howto-runtime-attestation-on-aws) provides artifacts to build and deploy an [Amazon Machine Image](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) for EKS with [AMD SEV-SNP](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sev-snp.html) support.

Azure provides customers with confidential VMs to help meet strict isolation, privacy, and security requirements within an AKS cluster. These confidential VMs use a hardware-based [trusted execution environment](https://en.wikipedia.org/wiki/Trusted_execution_environment). Specifically, Azure confidential VMs use AMD SEV-SNP technology. This technology denies hypervisor and other host-management code access to VM memory and state. Use this approach to add an extra layer of defense and protection against operator access. For more information, see [Use confidential VMs in an AKS cluster](/azure/aks/use-cvm) and [Overview of confidential VMs in Azure](/azure/confidential-computing/confidential-vm-overview).

### Federal Information Process Standards

[Federal Information Process Standards (FIPS) 140-3](https://csrc.nist.gov/publications/detail/fips/140/3/final) is a US government standard that defines minimum security requirements for cryptographic modules in information technology products and systems. Enable [FIPS compliance for AKS node pools](/azure/aks/enable-fips-nodes) to enhance the isolation, privacy, and security of your tenant workloads. [FIPS](/azure/compliance/offerings/offering-fips-140-2) compliance helps ensure the use of validated cryptographic modules for encryption, hashing, and other security-related operations. Use FIPS-enabled AKS node pools to employ robust cryptographic algorithms and mechanisms, which help meet regulatory and industry compliance requirements. For more information about how to strengthen the security posture of your multitenant AKS environments, see [Enable FIPS for AKS node pools](/azure/aks/enable-fips-nodes).

### Host-based encryption

In EKS, your architecture might use the following features to enhance data security:

- [Amazon Elastic Block Store (EBS) encryption](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html): You can encrypt data at rest on Amazon EBS volumes that are attached to your EKS worker nodes.

- [AWS Key Management Service (KMS)](https://aws.amazon.com/kms/): You can use AWS KMS to manage encryption keys and help enforce the encryption of your data at rest. If you enable [secrets encryption](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/), you can encrypt Kubernetes secrets by using your own AWS KMS key. For more information, see [Encrypt Kubernetes secrets with AWS KMS on existing clusters](https://docs.aws.amazon.com/eks/latest/userguide/enable-kms.html).
- [Amazon S3 server-side encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-encryption.html): If your EKS applications interact with Amazon S3, you can enable server-side encryption for your S3 buckets to help protect data at rest.

[Host-based encryption](/azure/aks/enable-host-encryption) on AKS further strengthens tenant workload isolation, privacy, and security. When you enable host-based encryption, AKS encrypts data at rest on the underlying host machines. This approach helps protect sensitive tenant information from unauthorized access. When you enable end-to-end encryption, temporary disks and ephemeral OS disks are encrypted at rest via platform-managed keys.

In AKS, OS disks and data disks use server-side encryption via platform-managed keys by default. The caches for these disks are encrypted at rest via platform-managed keys. You can use your own [key encryption key](/azure/security/fundamentals/encryption-atrest#envelope-encryption-with-a-key-hierarchy) to encrypt the data protection key. This method is called *envelope encryption*, or *wrapping*. The [encryption key](/azure/aks/azure-disk-customer-managed-keys) that you specify also encrypts the cache for the OS disks and data disks.

Host-based encryption adds a layer of security for multitenant environments. Each tenant's data in the OS disk and data disk caches is encrypted at rest via either customer-managed or platform-managed keys, depending on the selected disk encryption type. For more information, see the following resources:

- [Host-based encryption on AKS](/azure/aks/enable-host-encryption)
- [BYOK with Azure disks in AKS](/azure/aks/azure-disk-customer-managed-keys)
- [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption)

## Updates and upgrades

Azure periodically updates its VM-hosting platform to improve reliability, performance, and security. These updates range from patching software components in the hosting environment to upgrading networking components or decommissioning hardware. For more information, see [Maintenance for VMs in Azure](/azure/virtual-machines/maintenance-and-updates).

VM-hosting infrastructure updates don't usually affect hosted VMs, such as agent nodes of existing AKS clusters. For updates that affect hosted VMs, Azure minimizes the cases that require reboots by pausing the VM while updating the host or live migrating the VM to an already updated host.

If an update requires a reboot, Azure provides notification and a time window when you can start the update. The self-maintenance window for host machines is typically 35 days, unless the update is urgent.

You can use planned maintenance to update VMs. Manage planned maintenance notifications by using the [Azure CLI](/azure/virtual-machines/maintenance-notifications-cli), [Azure PowerShell](/azure/virtual-machines/maintenance-notifications-powershell), or the [Azure portal](/azure/virtual-machines/maintenance-notifications-portal). Planned maintenance detects whether you use the cluster auto-upgrade feature and schedules upgrades during your maintenance window automatically. For more information, see [Use planned maintenance to schedule maintenance windows for your AKS cluster](/azure/aks/planned-maintenance) and [az aks maintenanceconfiguration command](/cli/azure/aks/maintenanceconfiguration).

### Kubernetes upgrades

Part of the AKS cluster lifecycle includes periodically upgrading to the latest Kubernetes version. You should apply upgrades to get the latest security releases and features. To upgrade the Kubernetes version of existing node pool VMs, you must cordon and drain nodes and replace them with new nodes that are based on an updated Kubernetes disk image.

By default, AKS configures upgrades to surge with one extra node. A default value of one for the `max-surge` settings minimizes workload disruption. This configuration creates an extra node to replace older-versioned nodes before cordoning or draining existing applications. You can customize the `max-surge` value per node pool to optimize the trade-off between upgrade speed and upgrade disruption. A higher `max-surge` value increases the speed of the upgrade process, but a large value for `max-surge` might cause disruptions during the upgrade process.

For example, a `max-surge` value of 100% provides the fastest possible upgrade process by doubling the node count. But this value also drains all nodes in the node pool simultaneously. You might want to use this high value for testing, but for production node pools use a `max-surge` setting of 33%.

AKS accepts both integer and percentage values for the `max-surge` value. An integer such as `5` indicates five extra nodes to surge. You can set the percent value for `max-surge` from `1%` to `100%`, rounded up to the nearest node count. A value of `50%` indicates a surge value of half the current node count in the pool.

During an upgrade, you can set the `max-surge` value to a minimum of `1` and a maximum value that's equal to the number of nodes in the node pool. You can set larger values, but the maximum number of nodes for `max-surge` can't exceed the number of nodes in the pool.

> [!IMPORTANT]
> For upgrade operations, node surges need enough subscription quota for the requested `max-surge` count. For example, a cluster that has five node pools, each with four nodes, has a total of 20 nodes. If each node pool has a `max-surge` value of 50%, you need extra compute and an IP quota of 10 nodes, or two nodes times five pools, to complete the upgrade.
>
> If you use Azure Container Networking Interface, make sure you have enough IPs in the subnet to [meet the requirements for AKS](/azure/aks/configure-azure-cni).

### Upgrade node pools

To see available upgrades, use [az aks get-upgrades](/cli/azure/aks#az-aks-get-upgrades).

```azurecli-interactive
az aks get-upgrades --resource-group <myResourceGroup> --name <myAKSCluster>
```

To see the status of node pools, use [az aks nodepool list](/cli/azure/aks/nodepool#az-aks-nodepool-list).

```azurecli-interactive
  az aks nodepool list -g <myResourceGroup> --cluster-name <myAKSCluster>
```

To upgrade a single node pool, use [az aks nodepool upgrade](/cli/azure/aks/nodepool#az-aks-nodepool-upgrade).

```azurecli-interactive
  az aks nodepool upgrade \
      --resource-group <myResourceGroup> \
      --cluster-name <myAKSCluster> \
      --name <mynodepool> \
      --kubernetes-version <KUBERNETES_VERSION>
```

For more information, see the following resources:

- [AKS node image upgrade](/azure/aks/node-image-upgrade)
- [Upgrade a cluster control plane with multiple node pools](/azure/aks/manage-node-pools#upgrade-a-cluster-control-plane-with-multiple-node-pools)

### Upgrade considerations

Consider the following best practices when you upgrade the Kubernetes version in an AKS cluster:

- You should upgrade all node pools in an AKS cluster to the same Kubernetes version. The default behavior of `az aks upgrade` upgrades all node pools and the control plane.

- Manually perform upgrades, or set an automatic upgrade channel on your cluster. If you use planned maintenance to patch VMs, automatic upgrades also start during your specified maintenance window. For more information, see [Upgrade an AKS cluster](/azure/aks/upgrade-cluster).

- The `az aks upgrade` command with the `--control-plane-only` flag upgrades the cluster control plane and doesn't change the associated node pools in the cluster. To upgrade individual node pools, specify the target node pool and Kubernetes version in the `az aks nodepool upgrade` command.
- An AKS cluster upgrade triggers a cordon and drain of your nodes. If you have low compute quota available, the upgrade can fail. For more information, see [Increase regional vCPU quotas](/azure/azure-portal/supportability/regional-quota-requests).
- Configure the `max-surge` parameter based on your needs. Use an integer or percentage value. For production node pools, use a `max-surge` setting of 33%. For more information, see [Customize node surge upgrade](/azure/aks/upgrade-aks-cluster#customize-node-surge-upgrade).
- When you upgrade an AKS cluster that uses Azure Container Networking Interface networking, make sure the subnet has enough available private IP addresses for the extra nodes that the `max-surge` settings create. For more information, see [Configure Azure Container Networking Interface networking in AKS](/azure/aks/configure-azure-cni).
- If your cluster node pools span multiple availability zones within a region, the upgrade process can temporarily create an unbalanced zone configuration. For more information, see [Node pools that span multiple availability zones](/azure/aks/upgrade-cluster#special-considerations-for-node-pools-that-span-multiple-availability-zones).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal System Engineer

Other contributors:

- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Software Engineer
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS cluster best practices](/azure/aks/best-practices)
- [Use Azure Firewall to help protect an AKS cluster](../../guide/aks/aks-firewall.yml)
- [Training: Introduction to Kubernetes](/learn/modules/intro-to-kubernetes/)
- [Training: Introduction to Kubernetes on Azure](/learn/paths/intro-to-kubernetes-on-azure/)
- [Training: Develop and deploy applications on Kubernetes](/learn/paths/develop-deploy-applications-kubernetes/)
- [Training: Optimize compute costs on AKS](/learn/modules/aks-optimize-compute-costs/)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Cluster governance](governance.md)
- [AKS solution journey](../../reference-architectures/containers/aks-start-here.md)
- [AKS day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)
- [Choose a Kubernetes at the edge compute option](../../operator-guides/aks/choose-kubernetes-edge-compute-option.md)
- [GitOps for AKS](../../example-scenario/gitops-aks/gitops-blueprint-aks.yml)
