---
title: AKS Triage—Node and Pod Health
description: Learn about the triage step, in which you examine the health of Azure Kubernetes Service (AKS) worker nodes and pods and resolve problems.
author: samcogan
ms.author: samcogan
ms.date: 06/24/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
  - sfi-image-nochange
---

# Examine node and pod health

*This article is part of a series. Start with the [overview](aks-triage-practices.md).*

If the cluster checks that you performed in the previous step are clear, check the health of the Azure Kubernetes Service (AKS) worker nodes. Follow the six steps in this article to check the health of nodes, determine the reason for an unhealthy node, and resolve the problem.

> [!NOTE]
> Before you start manual triage, check whether AKS [node auto-repair](/azure/aks/node-auto-repair) is already attempting remediation. AKS automatically reboots, reimages, and finally redeploys any node that remains in a `NotReady` state for more than five minutes. The platform emits Kubernetes events from the `aks-auto-repair` source for each remediation step, including `NodeRebootStart`, `NodeReimageStart`, `NodeRedeployStart`, and their corresponding end events. If a node recently entered or exited auto-repair, factor that into your investigation. For repair failures, see [Troubleshoot node auto-repair errors](/troubleshoot/azure/azure-kubernetes/availability-performance/node-auto-repair-errors).

## Step 1: Check the health of worker nodes

Various factors can contribute to unhealthy nodes in an AKS cluster. One common reason is the breakdown of communication between the control plane and the nodes. This miscommunication is often caused by misconfigurations in routing and firewall rules.

When you configure your AKS cluster for [user-defined routing](/azure/aks/egress-outboundtype#outbound-type-user-defined-routes), you must configure egress paths through a network virtual appliance (NVA) or a firewall, such as an [Azure firewall](/azure/aks/limit-egress-traffic). To address a misconfiguration problem, configure the firewall to allow the necessary ports and fully qualified domain names (FQDNs) in accordance with the [AKS egress traffic guidance](/azure/aks/limit-egress-traffic).

Another reason for unhealthy nodes might be inadequate compute, memory, or storage resources that create kubelet pressures. In such cases, scaling up the resources can effectively resolve the problem.

In a [private AKS cluster](/azure/aks/private-clusters), Domain Name System (DNS) resolution problems can cause communication issues between the control plane and the nodes. You must verify that the Kubernetes API server DNS name resolves to the private IP address of the API server. Incorrect configuration of a custom DNS server is a common cause of DNS resolution failures. If you use custom DNS servers, ensure that you correctly specify them as DNS servers on the virtual network where nodes are provisioned. Also confirm that the AKS private API server can be resolved via the custom DNS server.

After you address these potential problems related to control plane communication and DNS resolution, you can effectively resolve node health problems within your AKS cluster.

You can evaluate the health of your nodes by using one of the following methods.

### AKS Diagnose and Solve Problems

[Diagnose and Solve Problems](/azure/aks/aks-diagnostics) in the Azure portal runs cluster-aware detectors against your cluster and returns findings and recommended actions. Use it as your first stop for node-health triage because it surfaces known issues, such as kubelet pressure, scheduled events, connectivity problems, and image-pull failures, without requiring you to run queries.

1. In the Azure portal, go to your AKS cluster.
1. In the navigation pane, select **Diagnose and solve problems**.
1. Select a category such as **Node Health** or **Cluster Insights** to view detected issues and the recommended next steps.

### Azure Copilot for AKS

[Azure Copilot](/azure/copilot/work-aks-clusters) runs AKS diagnostics in response to natural-language prompts and summarizes the findings. Prompts such as "How to check AKS node health?" or "diagnose my AKS cluster node health" trigger Copilot to run the relevant detectors on the target cluster and return links to further guidance. Copilot can also deploy diagnostic tools like [AKS Periscope](https://github.com/Azure/aks-periscope) and [CanIPull](https://github.com/Azure/aks-canipull) to the cluster on demand.

### Kubernetes events

[Kubernetes events](/azure/aks/events) capture lifecycle changes for nodes, pods, and other objects. Events from sources such as `aks-auto-repair`, `node-problem-detector`, `kubelet`, and the scheduler are the most direct signal of a node-level problem.

Run the following command to list cluster-wide events sorted by time:

```console
kubectl get events --all-namespaces --sort-by='.lastTimestamp'
```

To see events for a specific node, run:

```console
kubectl describe node <node-name>
```

You can also view events in the Azure portal under **Kubernetes resources** > **Events**. Kubernetes retains events for one hour by default. To retain events for longer, enable [Container insights](/azure/azure-monitor/containers/kubernetes-monitoring-enable). Events are then queryable from the `KubeEvents` table in the linked Log Analytics workspace, and you can build alerts on them by using [Azure Monitor log alerts](/azure/azure-monitor/alerts/alerts-types#log-search-alerts).

### Azure Monitor containers health view

To view the health of nodes, user pods, and system pods in your AKS cluster, follow these steps:

1. In the Azure portal, go to **Azure Monitor**.
1. In the **Insights** section of the navigation pane, select **Containers**.
1. Select **Monitored clusters** for a list of the AKS clusters that are being monitored.
1. Choose an AKS cluster from the list to view the health of the nodes, user pods, and system pods.

:::image type="content" source="images/azure-monitor-containers-health.png" alt-text="Screenshot that shows the Azure Monitor containers health view." lightbox="images/azure-monitor-containers-health.png":::

### AKS nodes view

To ensure that all nodes in your AKS cluster are in the ready state, follow these steps:

1. In the Azure portal, go to your AKS cluster.
1. In the **Settings** section of the navigation pane, select **Node pools**.
1. Select **Nodes**.
1. Verify that all nodes are in the ready state.

:::image type="content" source="images/aks-node-health.png" alt-text="Screenshot that shows the AKS nodes view." lightbox="images/aks-node-health.png":::

### In-cluster monitoring with Prometheus and Grafana

If you deployed [Prometheus](https://prometheus.io) and [Grafana](https://grafana.com) in your AKS cluster, you can use the [K8 Cluster Detail Dashboard](https://grafana.com/grafana/dashboards/10856-k8-cluster) to get insights. This dashboard shows Prometheus cluster metrics and presents vital information, such as CPU usage, memory usage, network activity, and file system usage. It also shows detailed statistics for individual pods, containers, and *systemd* services.

In the dashboard, select **Node conditions** to see metrics about the health and performance of your cluster. You can track nodes that might have problems, such as issues with their schedule, the network, disk pressure, memory pressure, proportional integral derivative (PID) pressure, or disk space. Monitor these metrics so that you can proactively identify and address any potential problems that affect the availability and performance of your AKS cluster.

:::image type="content" source="images/node-conditions.png" alt-text="Screenshot that shows the Prometheus and Grafana dashboard node." lightbox="images/node-conditions.png":::

### Azure Monitor managed service for Prometheus and Azure Managed Grafana

You can use prebuilt dashboards to visualize and analyze Prometheus metrics. To do so, set up your AKS cluster to collect Prometheus metrics in [Azure Monitor managed service for Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview), and connect your [Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-manage#link-a-grafana-workspace) to an [Azure Managed Grafana](/azure/managed-grafana/overview) workspace. [These dashboards](https://github.com/Azure/prometheus-collector/tree/main/mixins) provide a comprehensive view of your Kubernetes cluster's performance and health.

The dashboards are provisioned in the specified Azure Managed Grafana instance in the *Managed Prometheus* folder. Dashboards include:

- *Kubernetes / Compute Resources / Cluster*
- *Kubernetes / Compute Resources / Namespace (Pods)*
- *Kubernetes / Compute Resources / Node (Pods)*
- *Kubernetes / Compute Resources / Pod*
- *Kubernetes / Compute Resources / Namespace (Workloads)*
- *Kubernetes / Compute Resources / Workload*
- *Kubernetes / Kubelet*
- *Node Exporter / USE Method / Node*
- *Node Exporter / Nodes*
- *Kubernetes / Compute Resources / Cluster (Windows)*
- *Kubernetes / Compute Resources / Namespace (Windows)*
- *Kubernetes / Compute Resources / Pod (Windows)*
- *Kubernetes / USE Method / Cluster (Windows)*
- *Kubernetes / USE Method / Node (Windows)*

These built-in dashboards are widely used in the open-source community for monitoring Kubernetes clusters with Prometheus and Grafana. Use these dashboards to see metrics, such as resource usage, pod health, and network activity. You can also create custom dashboards that are tailored to your monitoring needs. Dashboards help you effectively monitor and analyze Prometheus metrics in your AKS cluster, which enables you to optimize performance, troubleshoot issues, and ensure smooth operation of your Kubernetes workloads.

You can use the *Kubernetes / Compute Resources / Node (Pods)* dashboard to see metrics for your Linux agent nodes. You can visualize the CPU usage, CPU quota, memory usage, and memory quota for each pod.

:::image type="content" source="images/azure-managed-grafana-node-dashboard.png" alt-text="Screenshot that shows the Azure Managed Grafana Kubernetes / Compute Resources / Node (Pods) dashboard." lightbox="images/azure-managed-grafana-node-dashboard.png":::

If your cluster includes Windows agent nodes, you can use the *Kubernetes / USE Method / Node (Windows)* dashboard to visualize the Prometheus metrics that are collected from these nodes. This dashboard provides a comprehensive view of resource consumption and performance for Windows nodes within your cluster.

Take advantage of these dedicated dashboards so you can monitor and analyze important metrics related to CPU, memory, and other resources in both Linux and Windows agent nodes. This visibility enables you to identify potential bottlenecks, optimize resource allocation, and ensure efficient operation across your AKS cluster.

## Step 2: Verify the control plane and worker node connectivity

If worker nodes are healthy, examine the connectivity between the managed AKS control plane and the cluster worker nodes. The connectivity model depends on whether your cluster uses [API Server VNet Integration](/azure/aks/api-server-vnet-integration):

- **With API Server VNet Integration (recommended for new clusters)**. The API server is projected into a delegated subnet in your virtual network behind an internal load balancer. Node-to-API-server traffic stays on private networking, and no tunnel is required. Konnectivity is still deployed when the cluster uses Azure CNI (Container Networking Interface) Overlay or Bring Your Own CNI (BYO CNI), because the API server needs a tunnel to reach pod IPs that aren't directly routable. With Azure CNI (including dynamic pod IP assignment), Konnectivity isn't deployed at all.

- **Without API Server VNet Integration**. AKS deploys a [Konnectivity](https://kubernetes.io/docs/tasks/extend-kubernetes/setup-konnectivity) tunnel (formerly *apiserver-network-proxy*) protected with mutual TLS to carry all traffic between the managed API server and the cluster nodes and pods.

To confirm which model your cluster uses, run:

```azurecli
az aks show --name <aks-name> --resource-group <resource-group-name> --query "apiServerAccessProfile.enableVnetIntegration" --output tsv
```

If `enableVnetIntegration` is `true` and `kubectl get deployment konnectivity-agent -n kube-system --no-headers` doesn't return any pods, this step doesn't apply: your cluster doesn't use Konnectivity. Validate node and pod connectivity directly by using `kubectl` commands and the `nslookup` steps in [Step 3](#step-3-validate-dns-resolution-when-restricting-egress) instead.

If Konnectivity is present, ensure that all network rules and FQDNs comply with the [required Azure network rules](/azure/aks/outbound-rules-control-egress), and use the [kubectl](https://kubernetes.io/docs/reference/kubectl) command-line tool to verify the tunnel.

To ensure that the Konnectivity agent pods work properly, run the following command:

```console
kubectl get deploy konnectivity-agent -n kube-system
```

Make sure that the pods are in a ready state.

If there's a problem with the connectivity between the control plane and the worker nodes, establish the connectivity after you ensure that the required AKS egress traffic rules are allowed.

Run the following command to restart the `konnectivity-agent` pods:

  ```console
  kubectl rollout restart deploy konnectivity-agent -n kube-system
  ```

If restarting the pods doesn't fix the connection, check the logs for any anomalies. Run the following command to view the logs of the `konnectivity-agent` pods:

  ```console
  kubectl logs -l app=konnectivity-agent -n kube-system --tail=50
  ```
  
The logs should show the following output:

  ```console
  I1012 12:27:43.521795       1 options.go:102] AgentCert set to "/certs/client.crt".
  I1012 12:27:43.521831       1 options.go:103] AgentKey set to "/certs/client.key".
  I1012 12:27:43.521834       1 options.go:104] CACert set to "/certs/ca.crt".
  I1012 12:27:43.521837       1 options.go:105] ProxyServerHost set to "sethaks-47983508.hcp.switzerlandnorth.azmk8s.io".
  I1012 12:27:43.521841       1 options.go:106] ProxyServerPort set to 443.
  I1012 12:27:43.521844       1 options.go:107] ALPNProtos set to [konnectivity].
  I1012 12:27:43.521851       1 options.go:108] HealthServerHost set to
  I1012 12:27:43.521948       1 options.go:109] HealthServerPort set to 8082.
  I1012 12:27:43.521956       1 options.go:110] AdminServerPort set to 8094.
  I1012 12:27:43.521959       1 options.go:111] EnableProfiling set to false.
  I1012 12:27:43.521962       1 options.go:112] EnableContentionProfiling set to false.
  I1012 12:27:43.521965       1 options.go:113] AgentID set to b7f3182c-995e-4364-aa0a-d569084244e4.
  I1012 12:27:43.521967       1 options.go:114] SyncInterval set to 1s.
  I1012 12:27:43.521972       1 options.go:115] ProbeInterval set to 1s.
  I1012 12:27:43.521980       1 options.go:116] SyncIntervalCap set to 10s.
  I1012 12:27:43.522020       1 options.go:117] Keepalive time set to 30s.
  I1012 12:27:43.522042       1 options.go:118] ServiceAccountTokenPath set to "".
  I1012 12:27:43.522059       1 options.go:119] AgentIdentifiers set to .
  I1012 12:27:43.522083       1 options.go:120] WarnOnChannelLimit set to false.
  I1012 12:27:43.522104       1 options.go:121] SyncForever set to false.
  I1012 12:27:43.567902       1 client.go:255] "Connect to" server="e9df3653-9bd4-4b09-b1a7-261f6104f5d0"
  ```

You can also search the container logs in the logging and monitoring service to retrieve the logs. For an example that searches for Konnectivity connectivity errors, see [Query logs from Container insights](/azure/azure-monitor/containers/container-insights-log-query).

Run the following query to retrieve the logs:

```kusto
ContainerLogV2 
| where _ResourceId =~ "/subscriptions/<subscription-ID>/resourceGroups/<resource-group-name>/providers/Microsoft.ContainerService/managedClusters/<cluster-ID>" // Use the IDs and names of your resources for these values.
| where ContainerName has "konnectivity-agent"
| project LogSource,LogMessage, TimeGenerated, Computer, PodName, ContainerName, ContainerId
| order by TimeGenerated desc
| limit 200
```

Run the following query to search container logs for any failed pod in a specific namespace:

```kusto
let KubePodInv = KubePodInventory
    | where TimeGenerated >= startTime and TimeGenerated < endTime
    | where _ResourceId =~ "<cluster-resource-ID>" // Use your resource ID for this value.
    | where Namespace == "<pod-namespace>" // Use your target namespace for this value.
    | where PodStatus == "Failed"
    | extend ContainerId = ContainerID
    | summarize arg_max(TimeGenerated, *)  by  ContainerId, PodStatus, ContainerStatus
    | project ContainerId, PodStatus, ContainerStatus;

    KubePodInv
    | join
    (
        ContainerLogV2
    | where TimeGenerated >= startTime and TimeGenerated < endTime
    | where PodNamespace == "<pod-namespace>" //update with target namespace
    ) on ContainerId
    | project TimeGenerated, PodName, PodStatus, ContainerName, ContainerId, ContainerStatus, LogMessage, LogSource
```

If you can't get the logs by using queries or the kubectl tool, use [kubectl debug](/azure/aks/node-access#connect-with-kubectl-debug) to connect to the node. This example inspects the `konnectivity-agent` pod after connecting to the node:

```bash
kubectl get pods -n kube-system -o wide | grep konnectivity-agent
kubectl debug node/<node-name> -it --image=mcr.microsoft.com/azurelinux/busybox:1.37
```

After connecting to the node through the debug pod, run the following commands:

```bash

chroot /host
crictl ps | grep konnectivity
crictl logs <konnectivity-container-id>
nslookup <api-server_fqdn>
```

## Step 3: Validate DNS resolution when restricting egress

DNS resolution is a crucial aspect of your AKS cluster. If DNS resolution isn't functioning correctly, it can cause control plane errors or container image pull failures. To ensure that DNS resolution to the [Kubernetes API server](https://kubernetes.io/docs/concepts/overview/kubernetes-api) is functioning correctly, follow these steps:

1. Run the [kubectl exec](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container) command to open a command shell in the container that's running in the pod.

    ```console
    kubectl exec --stdin --tty your-pod --namespace <namespace-name> -- /bin/bash
    ```

1. Check whether the [nslookup](https://linux.die.net/man/1/nslookup) or [dig](https://linux.die.net/man/1/dig) tool is installed in the container.

1. If neither tool is installed in the pod, run the following command to create a utility pod in the same namespace.

    ```console
    kubectl run -i --tty busybox --image=mcr.microsoft.com/azurelinux/busybox:1.36 --namespace <namespace-name> --rm=true -- sh
    ```

1. You can retrieve the API server address from the overview page of your AKS cluster in the Azure portal, or you can run the following command.

    ```azurecli-interactive
    az aks show --name <aks-name> --resource-group <resource-group-name> --query fqdn --output tsv
    ```

1. Run the following command to attempt to resolve the AKS API server. For more information, see [Troubleshoot DNS resolution failures from inside the pod but not from the worker node](/troubleshoot/azure/azure-kubernetes/connectivity/dns/troubleshoot-dns-failure-from-pod-but-not-from-worker-node).

    ```console
    nslookup myaks-47983508.hcp.westeurope.azmk8s.io
    ```

1. Check the upstream DNS server from the pod to determine whether the DNS resolution is working correctly. For example, for Azure DNS, run the `nslookup` command:

    ```console
    nslookup microsoft.com 168.63.129.16
    ```

1. If the previous steps don't provide insights, connect to one of the worker nodes and attempt DNS resolution from the node. This step helps to identify whether the problem is related to AKS or the networking configuration.

1. If DNS resolution is successful from the node but not from the pod, the problem might be related to Kubernetes DNS. For steps to debug DNS resolution from the pod, see [Troubleshoot DNS resolution failures](/troubleshoot/azure/azure-kubernetes/troubleshoot-dns-failure-from-pod-but-not-from-worker-node).

   If DNS resolution fails from the node, review the networking setup to ensure that the appropriate routing paths and ports are open to facilitate DNS resolution.

## Step 4: Check for kubelet errors

Verify the condition of the kubelet process that runs on each worker node, and ensure that it's not under any pressure. Potential pressure might pertain to CPU, memory, or storage. To verify the status of individual node kubelets, you can use one of the following methods.

### AKS kubelet workbook

To ensure that agent node kubelets work properly, follow these steps:

1. Go to your AKS cluster in the Azure portal.

1. In the **Monitoring** section of the navigation pane, select **Workbooks**.

1. Select the **Kubelet** workbook.
  
   :::image type="content" source="images/kubelet-workbook.png" alt-text="Screenshot that shows the Kubelet workbook icon." lightbox="images/kubelet-workbook.png":::
  
1. Select **Operations**, and make sure that the operations for all worker nodes are complete.

   :::image type="content" source="images/kubelet-workbook-detail.png" alt-text="Screenshot that shows the operations page." lightbox="images/kubelet-workbook-detail.png":::

### In-cluster monitoring with Prometheus and Grafana

If you deployed Prometheus and Grafana in your AKS cluster, you can use the [Kubernetes / Kubelet](https://grafana.com/grafana/dashboards/12123-kubernetes-kubelet) dashboard to get insights about the health and performance of individual node kubelets.

:::image type="content" source="images/kubelet-conditions.png" alt-text="Screenshot that shows the Prometheus and Grafana dashboard kubelet." lightbox="images/kubelet-conditions.png":::

### Azure Monitor managed service for Prometheus and Azure Managed Grafana

You can use the *Kubernetes / Kubelet* prebuilt dashboard to visualize and analyze the Prometheus metrics for the worker node kubelets. To set up this dashboard, configure your AKS cluster to collect Prometheus metrics in Azure Monitor managed service for Prometheus, and connect your Azure Monitor workspace to an Azure Managed Grafana workspace.

:::image type="content" source="images/azure-managed-grafana-kubelet-dashboard.png" alt-text="Screenshot that shows the Azure Managed Grafana kubelet dashboard." lightbox="images/azure-managed-grafana-kubelet-dashboard.png":::

Pressure increases when a kubelet restarts and causes sporadic, unpredictable behavior. Make sure that the error count doesn't increase continuously. An occasional error is acceptable, but a constant increase indicates an underlying problem that you must investigate and resolve.

## Step 5: Use the node problem detector (NPD) tool to check node health

[NPD](https://github.com/kubernetes/node-problem-detector) is a Kubernetes daemon that detects and reports node-level problems. AKS installs and enables NPD on Linux nodes by default through the AKS Linux extension, so no additional setup is required. For details, see [NPD in AKS nodes](/azure/aks/node-problem-detector).

NPD reports two categories of signals:

- **Node conditions.** Persistent states attached to the `Node` object, such as `KernelDeadlock`, `ReadonlyFilesystem`, `FilesystemCorruptionProblem`, `KubeletProblem`, `ContainerRuntimeProblem`, and `VMEventScheduled`. The Kubernetes scheduler uses these conditions to avoid placing new pods on nodes that report problems.

- **Events.** Discrete, time-bound occurrences like `OOMKilling`, `TaskHung`, `DNSProblem`, `KernelOops`, `EgressBlocked`, and scheduled-event notifications (`FreezeScheduled`, `RebootScheduled`, `RedeployScheduled`, `TerminateScheduled`, and `PreemptScheduled`).

View node conditions by using `kubectl describe node <node-name>`. View NPD-emitted events by using `kubectl get events --field-selector source=node-problem-detector`. These events also flow through the Kubernetes events pipeline described in step 1, so any retention or alerting that you configure there applies to NPD output.

### Prometheus metrics from NPD

NPD exposes a `problem_gauge` metric on port `20257` of each node. When this endpoint is scraped by Azure Monitor managed service for Prometheus, you can build dashboards and alerts on node conditions across the fleet. See [NPD in AKS nodes](/azure/aks/node-problem-detector) for a sample scrape configuration.

### GPU health monitoring

For GPU-enabled node pools, AKS extends NPD with GPU-specific detectors. NPD reports conditions such as `XIDErrors`, `NVLinkStatusInactive`, `IBLinkFlapping`, `GPUClockThrottling`, `GPUMissing`, and `UnhealthyNvidiaDevicePlugin`. You can combine these conditions with the `problem_gauge` metric to detect failing GPUs before training or inference workloads degrade. For details, see [GPU health monitoring](/azure/aks/gpu-health-monitoring).

## Step 6: Check for the DiskPressure node condition

The kubelet sets the `DiskPressure` node condition to `True` when available disk space or inodes on a node fall below the eviction threshold. It also taints the node with `node.kubernetes.io/disk-pressure:NoSchedule`, evicts pods to reclaim space, and stops the scheduler from placing new pods on the node until the condition clears.

To check `DiskPressure` on a single node, run this command:

```console
kubectl describe node <node-name>
```

Look at the `Conditions` section. A healthy node reports `DiskPressure: False`.

To check `DiskPressure` across all nodes at once, run this command:

```console
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.conditions[?(@.type=="DiskPressure")].status}{"\n"}{end}'
```

The kubelet evaluates two filesystems independently:

- `nodefs`. The root filesystem that holds kubelet state, container logs, and emptyDir volumes.
- `imagefs`. The filesystem that holds container images and writable container layers. On AKS, `imagefs` is the same volume as `nodefs`, unless you configure a separate image store.

For the default eviction thresholds, see [Node-pressure eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction).

To resolve `DiskPressure`:

1. Identify what's consuming the disk. Use `kubectl` debug to connect to the node, then run `df -h` and `du -sh /var/lib/* /var/log/*`. Common contributors include container logs under `/var/log/containers`, container images held by the container runtime, and emptyDir volumes.

1. If a workload is the cause, fix the application to bound its disk usage rather than increasing capacity. For example, cap log volume, ship logs off-node by using a sidecar, or move large working sets to a persistent volume.
1. If the legitimate working set exceeds the OS disk capacity, increase the OS disk size on the node pool. You can't change the OS disk size of an existing node pool in place. Create a new node pool with a larger `--node-osdisk-size`, or with a larger VM SKU when you use [ephemeral OS disks](/azure/aks/concepts-storage#ephemeral-os-disk), then migrate workloads by completing the [Resize node pools in AKS](/azure/aks/resize-node-pool) procedure before you delete the original pool.

## Step 7: Check disk I/O operations per second (IOPS) for throttling

To ensure that IOPS aren't being throttled and affecting services and workloads within your AKS cluster, you can use one of the following methods.

### AKS node disk I/O workbook

To monitor the disk I/O-related metrics of the worker nodes in your AKS cluster, you can use the [node disk I/O](/azure/azure-monitor/containers/kubernetes-workbooks#node-monitoring-workbooks) workbook. Follow these steps to access the workbook:

1. Go to your AKS cluster in the Azure portal.
1. In the **Monitoring** section of the navigation pane, select **Workbooks**.
1. Select the **Node Disk IO** workbook.
  
   :::image type="content" source="images/node-disk-io-workbook.png" alt-text="Screenshot that shows the Node Disk IO workbook icon." lightbox="images/node-disk-io-workbook.png":::
  
1. Review the I/O-related metrics.

   :::image type="content" source="images/node-disk-io-workbook-detail.png" alt-text="Screenshot that shows the disk IO metrics." lightbox="images/node-disk-io-workbook-detail.png":::

### In-cluster monitoring with Prometheus and Grafana

If you deployed Prometheus and Grafana in your AKS cluster, you can use the [USE Method / Node](https://grafana.com/grafana/dashboards/12136-use-method-node) dashboard to get insights about the disk I/O for the cluster worker nodes.

:::image type="content" source="images/node-diskio.png" alt-text="Screenshot that shows the Prometheus and Grafana dashboard node disk." lightbox="images/node-diskio.png":::

### Azure Monitor managed service for Prometheus and Azure Managed Grafana

You can use the *Node Exporter / Nodes* prebuilt dashboard to visualize and analyze disk I/O-related metrics from the worker nodes. To do so, set up your AKS cluster to collect Prometheus metrics in Azure Monitor managed service for Prometheus, and connect your Azure Monitor workspace to an Azure Managed Grafana workspace.

  :::image type="content" source="images/azure-managed-grafana-node-exporter-dashboard.png" alt-text="Screenshot that shows the Azure Managed Grafana Node Exporter / Nodes dashboard." lightbox="images/azure-managed-grafana-node-exporter-dashboard.png":::

### IOPS and Azure disks

Physical storage devices have inherent limitations in terms of bandwidth and the maximum number of file operations that they can handle. Azure disks are used to store the operating system that runs on AKS nodes. The disks are subject to the same physical storage constraints as the operating system.

Consider the concept of throughput. You can multiply the average I/O size by the IOPS to determine the throughput in megabytes per second (MBps). Larger I/O sizes translate to lower IOPS because of the fixed throughput of the disk.

When a workload surpasses the maximum IOPS service limits assigned to the Azure disks, the cluster might become unresponsive and enter an I/O wait state. In Linux-based systems, many components are treated as files, such as network sockets, CNI, the container runtime, and other services that rely on network I/O. Consequently, if the disk can't be read, the failure extends to all these files.

Several events and scenarios can trigger IOPS throttling, including:

- A substantial number of containers that run on nodes, because container runtime I/O shares the operating system disk.

- Custom or non-Microsoft tools that are employed for security, monitoring, and logging, which might generate additional I/O operations on the operating system disk.
- Node failover events and periodic jobs that intensify the workload or scale the number of pods. This increased load increases the likelihood of throttling occurrences, potentially causing all nodes to transition to a *not ready* state until the I/O operations conclude.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

Other contributor:

- [Sam Cogan](https://www.linkedin.com/in/samcogan82/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Virtual machine disk limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#virtual-machine-disk-limits)
- [Virtual machines and disk performance](/azure/virtual-machines/disks-performance)

## Related resource

> [!div class="nextstepaction"]
> [Monitor workload deployments](aks-triage-deployment.md)
