---
title: AKS triage - node health
titleSuffix: Azure Architecture Center
description: Learn about the triage step to examine the health of Azure Kubernetes Services (AKS) worker nodes and pods.
author: kevingbb
ms.date: 10/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - containers
products:
  - azure-kubernetes-service
  - azure-monitor
ms.custom:
  - e2e-aks
---

# Examine the node and pod health

If the cluster checks are clear, check the health of the AKS worker nodes. Determine the reason for the unhealthy node and resolve the issue.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

## 1- Check the overall health of the worker nodes

A node can be unhealthy because of various reasons. A common reason is when the control plane to node communication is broken as a result of misconfiguration of routing and firewall rules. As a fix, you can allow the necessary ports and fully qualified domain names through the firewall according to the [AKS egress traffic guidance](/azure/aks/limit-egress-traffic). Another reason can be kubelet pressures. In that case, add more compute, memory, or storage resources.

**Tools:**

You can check node health in one of these ways:

- **Azure Monitor - Containers health view**. In Azure portal, open Azure Monitor. Select **Containers**.  On the right pane, select **Monitored clusters**. Select the cluster to view the health of the nodes, user pods, and system pods.

    ![Azure Monitor - Containers Health View](images/azuremonitor-containershealth.png)

- **AKS - Nodes view:** In Azure portal, open navigate to the cluster. Select **Insights** under **Monitoring**. View **Nodes** on the right pane.
![AKS - Nodes View](images/aks-nodehealth.png)

- **Prometheus and Grafana Dashboard**. Open the **Node Conditions** dashboard.
![Prometheus and Grafana Dashboard - Node](images/node-conditions.png)

## 2- Verify the control plane and worker node connectivity

If worker nodes are healthy, examine the connectivity between the managed AKS control plane and the worker nodes. Depending on the age and type of cluster configuration, the connectivity pods are either **tunnelfront** or **aks-link**, and located in the **kube-system** namespace.

**Tools:**

- `kubectl`
- **Azure Monitor container insights**

![Sample aks-link Pod](images/aks-link-pod.png)

If **tunnelfront** or **aks-link** connectivity is not working, establish connectivity after checking that the appropriate AKS egress traffic rules have been allowed. Here are the steps:

1. Restart **tunnelfront** or **aks-link**.

   ```bash
   kubectl rollout restart deploy aks-link
   ```

   If restarting the pods doesn't fix the connection, continue to the next step.

2. Check the logs and look for abnormalities. This output shows logs for a working connection.

   ```bash
   kubectl logs -l app=aks-link -c openvpn-client --tail=50
   ```

   ![Sample `aks-link` logs](images/aks-link-logs.png)

You can also retrieve those logs by searching the container logs in the logging and monitoring service. This example searches [Azure Monitor container insights](/azure/azure-monitor/insights/container-insights-log-search) to check for **aks-link** connectivity errors.

```kusto
let ContainerIDs = KubePodInventory
| where ClusterId =~ "/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/RESOURCE_GROUP/providers/Microsoft.ContainerService/managedClusters/YOUR_CLUSTER_ID"
| where Name has "aks-link"
| distinct ContainerID;
ContainerLog
| where ContainerID in (ContainerIDs)
| project LogEntrySource, LogEntry, TimeGenerated, Computer, Image, Name, ContainerID
| order by TimeGenerated desc
| limit 200
```

Here's another example query to check for **tunnelfront** connectivity errors.

```kusto
let ContainerIDs = KubePodInventory
| where ClusterId =~ "/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/RESOURCE_GROUP/providers/Microsoft.ContainerService/managedClusters/YOUR_CLUSTER_ID"
| where Name has "tunnelfront"
| distinct ContainerID;
ContainerLog
| where ContainerID in (ContainerIDs)
| where LogEntry has "ssh to tunnelend is not connected"
| project LogEntrySource, LogEntry, TimeGenerated, Computer, Image, Name, ContainerID
| order by TimeGenerated desc
| limit 200
```

If you can't get the logs through the kubectl or queries, use [SSH into the node](/azure/aks/ssh). This example finds the **tunnelfront** pod after connecting to the node through SSH.

```bash
kubectl pods -n kube-system -o wide | grep tunnelfront
ssh azureuser@<agent node pod is on, output from step above>
docker ps | grep tunnelfront
docker logs …
nslookup <ssh-server_fqdn>
ssh -vv azureuser@<ssh-server_fqdn> -p 9000
docker exec -it <tunnelfront_container_id> /bin/bash -c "ping bing.com"
kubectl get pods -n kube-system -o wide | grep <agent_node_where_tunnelfront_is_running>
kubectl delete po <kube_proxy_pod> -n kube-system
```

## 3- Validate DNS resolution when restricting egress

DNS resolution is a critical component of your cluster. If DNS resolution isn't working, then control plane errors or container image pull failures may occur.

**Tools:**

- `nslookup`
- `dig`

Follow these steps to make sure that DNS resolution is working.

1. Exec into the pod to examine and use `nslookup` or `dig` if those tools are installed on the pod.
2. If the pod doesn't have those tools, start a utility pod in the same namespace and retry with the tools.
3. If those steps don't show insights, SSH to one of the nodes and try resolution from there. This step will help determine if the issue is related to AKS related or networking configuration.
4. If DNS resolves from the node, then the issue is related to Kubernetes DNS and not a networking issue. Restart Kubernetes DNS and check whether the issue is resolved. If not, open a Microsoft support ticket.
5. If DNS doesn't resolve from the node, then check the networking setup again to make sure that the appropriate routing paths and ports are open.

## 4- Check for kubelet errors

Check the kubelet process running on each worker node and make sure it's not experiencing any pressures. Those pressures can be related to CPU, memory, or storage.

**Tools:**

- **AKS - Kubelet Workbook**
![AKS - Kubelet Workbook](images/aks-kubeletworkbook.png)

- **Prometheus and Grafana Dashboard:** Kubelet Dashboard
![Prometheus and Grafana Dashboard - Kubelet](images/kubelet-conditions.png)

The pressure increases when kubelet restarts and causes some sporadic, unpredictable behavior. Make sure that the error count isn't continuously growing. An occasional error is acceptable but a constant growth indicates an underlying issue that needs to be investigated and resolved.

## 5- Check disk IOPS for throttling

Check to see that file operations (IOPS) are not getting throttled and impacting services in the cluster.

**Tools:**

- **[Azure Monitor container insights Disk IO Workbook](/azure/azure-monitor/insights/container-insights-analyze#workbooks)**

    ![Azure Monitor container insights - Disk IO Workbook](images/aks-diskioworkbook.png)

- **Prometheus and Grafana Dashboard:** Node Disk Dashboard
    ![Prometheus and Grafana Dashboard - Node Disk](images/node-diskio.png)

Physical storage devices have limitations, bandwidth, and total number of file operations. Azure Disks are used to store the OS running on the AKS nodes. They are subject to the same physical storage limitations.

Another way is to look at the throughput. IOPSs is measured with the average IO size * IOPS as the throughput in MB/s. Large IO sizes will lead to lower IOPS because the throughput of a disk doesn't change.

When a workload exceeds Azure Disks' service limits on Max IOPS, the cluster becomes unresponsive and blocked in IO Wait. Everything on Linux is a file. This includes network sockets, CNI, Docker, and other services that use network I/O. All of those files will fail if they're unable to read the disk.

The events that can trigger IOPS throttle include:

- High volume of containers running on the nodes. Docker IO is shared on the OS disk.
- Custom or third-party tools used for security, monitoring, logging that are running on the OS disk.
- Node failover events, and periodic jobs. As the load increases or the pods are scaled, this throttling occurs more frequently until all nodes go to **NotReady** state while the IO completes.

## Related links

[Virtual machine disk limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#virtual-machine-disk-limits)

[Relationship between Virtual Machine and Disk Performance](/azure/virtual-machines/linux/disk-performance-linux)

## Next steps

> [!div class="nextstepaction"]
> [Check the workload deployments](aks-triage-deployment.md)
