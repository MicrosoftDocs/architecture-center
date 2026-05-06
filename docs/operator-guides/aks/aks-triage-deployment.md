---
title: AKS triage—Workload deployments
description: Learn how to check whether workload deployments and DaemonSet features are running properly. This step is part of the triage practices for an AKS cluster.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
---

# Monitor workload deployments

*This article is part of a series. Start with the [overview](aks-triage-practices.md).*

It's important to monitor the health and performance of your Kubernetes workloads to ensure that they run optimally. Azure Kubernetes Service (AKS) has several tools that you can use to check the health and performance of your deployments, `DaemonSet` features, and services.

## Tools

It's important to determine whether all deployments and `DaemonSet` features are running. This article describes how to determine whether the replicas in the *ready* and *available* states match the expected replica count by using:  

- The Azure portal.
- The container insights feature of Azure Monitor.
- The kubectl command-line tool.
- Prometheus and Grafana.

### The Azure portal

You can use the Azure portal to verify the health of the following components in your workloads. For more information, see [Access Kubernetes resources from the Azure portal](/azure/aks/kubernetes-portal).

#### Deployment, `ReplicaSet`, `StatefulSet`, and `DaemonSet`

Verify that the number of replicas that are in a *ready* state matches the number of desired replicas. The portal shows:

- The number of replicas that are currently available and ready to serve traffic. These replicas have been successfully scheduled onto worker nodes, completed their startup process, and passed their readiness checks.

- The desired number of replicas specified for the deployment, or the number of replicas that the deployment aims to maintain. The Kubernetes deployment controller constantly monitors the state of the deployment and ensures that the actual number of replicas matches the desired number.

#### Services and ingresses

Ensure that the status is *ok* for all services and ingresses.

#### Storage

Ensure that the status is *bound* for all the persistent volume claims and persistent volumes.

### Container insights

[Container insights](/azure/azure-monitor/containers/container-insights-overview) is a feature of [Monitor](/azure/azure-monitor/overview) that provides monitoring capabilities for container workloads that are deployed to AKS or managed by [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview). This feature gathers performance and health information, like memory and processor metrics from controllers, nodes, and containers. It also captures container logs for analysis.

> [!IMPORTANT]
> While Container Insights can be used for metric gathering, we suggest utilizing the [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview) to improve metric collection and use Container Insights solely for log collection.

You can use Container Insights to analyze collected data and understand the performance and behavior of components within your cluster. Here are some ways you can use Container Insights:

- Identify resource bottlenecks by analyzing processor and memory usage of containers on each node.
- Examine the performance of container groups and their containers in container instances.
- View the overall performance of controllers or pods by identifying the location of containers within them.
- Review resource usage of workloads on the host that are unrelated to supporting the pod's standard processes.
- Understand how the cluster behaves under average and heavy loads to determine capacity needs and maximum load.
- Access live container logs and metrics to troubleshoot issues in real time.
- Set up alerts to be notified or record CPU and memory usage exceeding thresholds, and health state changes in the cluster.

In the Azure portal, Container Insights provides tools to monitor and analyze the health and performance of an AKS cluster:

- **Cluster**: Gives an overview of the AKS cluster, including metrics like CPU and memory usage, pod and node counts, and network traffic.
- **Reports**: Provides prebuilt reports to visualize and analyze cluster performance, resource usage, pod health, and container insights.
- **Nodes**: Provides detailed information about nodes in the cluster, including CPU and memory usage, disk and network I/O, and node condition and status.
- **Controllers**: Offers visibility into Kubernetes controllers in the AKS cluster, showing the number of instances, current state, and status of controller operations.
- **Containers**: Provides insights into containers running in the AKS cluster, including resource usage, restarts, and lifecycle events.
- **Live logs**: Gives a live stream of log events from running containers, allowing real-time viewing of container logs for monitoring and troubleshooting applications.

For more information, see the following resources:

- [Monitor your Kubernetes cluster performance with container insights](/azure/azure-monitor/containers/container-insights-analyze)
- [Configure GPU monitoring with container insights](/azure/azure-monitor/containers/container-insights-gpu-monitoring)
- [Monitor and visualize network configurations with Azure network policy manager](/azure/virtual-network/kubernetes-network-policies#monitor-and-visualize-network-configurations-with-azure-npm)
- [Monitor deployments and HPA metrics with container insights](/azure/azure-monitor/containers/container-insights-deployment-hpa-metrics)
- [Monitor persistent volume (PV) metrics](/azure/azure-monitor/containers/container-insights-persistent-volumes)
- [Monitor security with Syslog](/azure/azure-monitor/containers/container-insights-syslog)
- [Reports in container insights](/azure/azure-monitor/containers/container-insights-reports)
- [Metrics collected by container insights](/azure/azure-monitor/containers/container-insights-custom-metrics)
- [View Kubernetes logs, events, and pod metrics in real time](/azure/azure-monitor/containers/container-insights-livedata-overview)
- [View cluster metrics in real time](/azure/azure-monitor/containers/container-insights-livedata-metrics)

### Command-line tool

To check the status of your workloads, you can use the kubectl command-line tool to communicate with a Kubernetes cluster's control plane via the Kubernetes API.

#### Pods

To list the pods running in all namespaces, run the following command:

```console
kubectl get pod -A
```

In the output from the command, the *READY* column provides important information about the readiness state of the pod's containers.

The first number signifies the count of containers that are currently in a *ready* state. These containers have passed the readiness probes and are prepared to handle incoming traffic. The second number represents the total count of containers that are defined within the pod, regardless of their readiness state. It includes containers that are ready and those that are still being initialized or experiencing issues.

Ensure that the first number (ready containers) matches the second number (total containers) for the pod. If they differ, some containers might not be ready or there might be issues preventing them from reaching the *ready* state.

#### Deployment, `StatefulSet`, `DaemonSet`, and `ReplicaSet`

Run the following command to retrieve the [deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment) in all namespaces:

```console
kubectl get deploy -A
```

In the output of the `kubectl get deploy` command, the numbers in the *READY* column indicate the current readiness state of the replicas in a deployment.

The first number represents the number of replicas that are ready and available to serve traffic. These replicas have successfully started and passed their readiness checks. The second number represents the desired number of replicas specified in the deployment configuration. It's the target number of replicas that the deployment aims to maintain.

It's important to ensure that the first number matches the second number. It indicates that the desired number of replicas are running and ready. Any discrepancy between the two numbers might indicate scaling or readiness issues that you must address.

Run the following command to retrieve the [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset) features in all namespaces:

```console
kubectl get statefulset -A
```

Run the following command to retrieve the [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/DaemonSet) features in all namespaces:

```console
kubectl get ds -A
```

You can run the `kubectl get ds` command to verify that a `DaemonSet` is running as expected. For example, you can run the following command to verify that the container insights agent is deployed successfully:

```console
kubectl get ds ama-logs --namespace=kube-system
```

Likewise, if you configure your AKS cluster to collect Prometheus metrics in [Monitor for managed Prometheus](/azure/azure-monitor/containers/prometheus-metrics-enable), you can run the following command to verify that the `DaemonSet` is deployed properly on the Linux node pools:

```console
kubectl get ds ama-metrics-node --namespace=kube-system
```

This output provides information about the `DaemonSet` features in your cluster. Examine the output to ensure that the number of pods in the *ready*, *current*, and *desired* states are the same. If they're the same, the desired number of pods specified in the `DaemonSet` configuration is equal to the number of pods that are currently running and ready.

We recommended that you perform the same check for [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset) features. You can use the following command to retrieve the `ReplicaSet` features in all namespaces:

```console
kubectl get rs -A
```

Ensure that the numbers in this output are the same for each state so that the intended number of pods or replicas are running as expected. Discrepancies might indicate a need for further investigation or troubleshooting by using one of the following commands.

**kubectl describe:** You can use the [kubectl describe](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-and-finding-resources) command to get detailed information about Kubernetes resources, such as pods, deployments, and services. You can get a comprehensive overview of the specified resource, including its current state, events, conditions, and related metadata. The information is retrieved from the Kubernetes API server. This command is useful for troubleshooting and understanding the status of a resource.

You can run `kubectl describe pod <pod-name>` to get detailed information about a specific pod, including its current state, events, labels, and the containers that are associated with it. The output shows information like pod status, events, volumes, and conditions.

**kubectl logs:** You can use the [kubectl logs](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#interacting-with-running-pods) command to retrieve logs that are generated by a container within a pod. This command is helpful for debugging and troubleshooting. You can view the logs in real time, or retrieve historical logs from a container.

To view container logs, you can use the command `kubectl logs <pod-name> -c <container-name>`. Replace `<pod-name>` with the name of the pod. Replace `<container-name>` with the name of the container from which you want to fetch the logs. If there's only one container in the pod, you don't need to specify the container name. You can also use the `-f` flag with `kubectl logs` to follow the logs in real time. This flag is similar to the `tail -f` Linux command.

**kubectl events:** You can use the [kubectl events](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-and-finding-resources) command for troubleshooting when a deployment, `DaemonSet`, `ReplicaSet`, or pod doesn't start or encounters an issue during startup. This command provides a chronological list of events that are associated with the specified resource. You can get insights into what might have caused the problem.

To use `kubectl events`, you can run the command `kubectl events` followed by a specific resource name. Or you can use selectors to filter events based on labels, namespaces, or other criteria.

For example, to retrieve events related to a specific pod, you can run `kubectl events --field-selector involvedObject.name=<pod-name> --field-selector involvedObject.kind=Pod`. Replace `<pod-name>` with the name of the pod that you want to investigate. The output of the `kubectl events` command displays information such as the event type (normal or warning), the event message, the reason for the event, and the time stamp when the event occurred. You can use this information to help determine what caused the failure or issue during startup.

If you suspect that a specific resource like a deployment, `DaemonSet`, or `ReplicaSet` is experiencing problems, you can filter events by using selectors. For example, `kubectl events --field-selector involvedObject.name=<deployment-name> --field-selector involvedObject.kind=Deployment` shows events related to a specific deployment. Examine events so you can gather important details about potential errors, failures, or other events that might have prevented the resource from starting properly. Use this data to help troubleshoot and resolve issues that affect the resource.

### In-cluster monitoring with Prometheus and Grafana

If you deploy [Prometheus](https://prometheus.io) and [Grafana](https://grafana.com) in your AKS cluster, you can use the [K8 Cluster Detail Dashboard](https://grafana.com/grafana/dashboards/10856-k8-cluster) to get insights. This dashboard presents information that's gathered from the Prometheus cluster metrics, such as CPU and memory usage, network activity, and file system usage. It also shows detailed statistics for individual pods, containers, and *systemd* services.

To ensure the health and performance of your deployments, jobs, pods, and containers, you can use the features in the dashboard. Select **Deployments** to view the number of replicas for each deployment and the total number of replicas. Select **Containers** to view a chart that shows the running, pending, failed, and succeeded containers.

### Monitor managed service for Prometheus and Azure Managed Grafana

You can use prebuilt dashboards to visualize and analyze Prometheus metrics. To do so, you must set up your AKS cluster to collect Prometheus metrics in [Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview), and connect your [Monitor workspace](/azure/azure-monitor/essentials/azure-monitor-workspace-manage#link-a-grafana-workspace) to an [Azure Managed Grafana](/azure/managed-grafana/overview) workspace.

Install the [prebuilt dashboards](https://github.com/Azure/prometheus-collector/tree/main/mixins) to get a comprehensive view of your Kubernetes cluster's performance and health. For detailed installation instructions, see [Prometheus monitoring mixin for Kubernetes](https://github.com/Azure/prometheus-collector/tree/main/mixins/kubernetes#how-to-use). The dashboards are provisioned in the specified Azure Managed Grafana instance in the *Managed Prometheus* folder. Some dashboards include:

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

These built-in dashboards are widely used in the open-source community for monitoring Kubernetes clusters with Prometheus and Grafana. Use these dashboards to see metrics, such as resource usage, pod health, and network activity. You can also create custom dashboards that are tailored to your monitoring needs. Dashboards help you to effectively monitor and analyze Prometheus metrics in your AKS cluster, which enables you to optimize performance, troubleshoot issues, and ensure smooth operation of your Kubernetes workloads.

You can use the *Kubernetes / Compute Resources / Node (Pods)* dashboard to see metrics for your Linux agent nodes. You can visualize the CPU usage, CPU quota, memory usage, and memory quota for each pod.

The *Kubernetes / Compute Resources / Pod* Grafana dashboard provides insights about the resource consumption and performance metrics of a selected cluster, namespace, and pod. You can use this dashboard to get metrics related to CPU usage, CPU throttling, the CPU quota, memory usage, the memory quota, networking metrics, and storage metrics. In the dashboard, select an AKS cluster, namespace, and pod within the chosen namespace to see the following details:

- **CPU usage**: This chart displays the CPU usage over time for the selected pod. You can review the CPU consumption pattern and identify potential spikes or abnormalities.

- **CPU throttling**: This chart provides insights into CPU throttling, which occurs when a pod exceeds its CPU resource limits. Monitor this metric to help identify areas where the pod's performance is restricted due to CPU throttling.
- **CPU quota**: This chart shows the allocated CPU quota for the selected pod. If the pod exceeds its assigned CPU quota, it might require resource adjustments.
- **Memory usage**: This chart presents the memory usage of the selected pod. Monitor the memory consumption pattern and identify any memory-related issues.
- **Memory quota**: This chart displays the allocated memory quota for the pod. If the pod exceeds its assigned memory quota, it might indicate a need for resource optimization.
- **Networking metrics**: These charts show the received and transmitted bandwidth, and the rate of received and transmitted packets. These metrics help you monitor network usage and detect any potential networking bottlenecks or anomalies.
- **Storage metrics**: This section provides information about storage-related metrics, such as I/O operations per second (IOPS) and throughput. Monitor these metrics to help gauge the performance and efficiency of the pod storage.

You can use the *Kubernetes / Compute Resources / Pod* Grafana dashboard to get insights about the resource usage, performance, and behavior of pods in your Kubernetes cluster. Use this information to optimize resource allocation, troubleshoot performance issues, and make informed decisions to ensure the smooth operation of your containerized workloads.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer

Other contributors:

- [Kevin Harris](https://www.linkedin.com/in/kevbhar) | Principal Solution Specialist
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Virtual machine disk limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#virtual-machine-disk-limits)
- [Virtual machines and disk performance](/azure/virtual-machines/linux/disk-performance-linux)

## Related resources

> [!div class="nextstepaction"]
> [Validate the admission controllers](aks-triage-controllers.md)
