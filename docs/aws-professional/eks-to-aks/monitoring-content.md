The following article will guide you on the different options to monitor and manage the logs of an Azure Kubernetes Service (AKS) cluster and its workloads.

> [!NOTE]
> This article is part of a [series of articles](../index.md) that helps professionals who are familiar with Amazon Elastic Kubernetes Service (Amazon EKS) to understand Azure Kubernetes Service (AKS).

## Monitoring and Logging in Elastic Kubernetes Service (EKS)

Like any Kubernetes cluster, EKS has two major components: control plane and worker nodes and there are specific settings for each of these layers.

### Control Plane and Cluster components

EKS has an integration with CloudWatch logs that allows logging and monitoring for the Amazon EKS control plane. This integration is not enabled by default but if configured it will gather logs on:

- API server and API calls
- Audit logs and user interactions
- Authenticator logs
- Scheduler and controller logs

EKS is also integrated with AWS CloudTrail, to keep track of actions and API calls. For more information, see [Logging Amazon EKS API calls with AWS CloudTrail](https://docs.aws.amazon.com/eks/latest/userguide/logging-using-cloudtrail.html).

As for [control plane metrics](https://aws.github.io/aws-eks-best-practices/reliability/docs/controlplane/#monitor-control-plane-metrics), they are exposed at the `/metrics` endpoint, and they can be collected and stored in Prometheus in CloudWatch Container Insights. Prometheus can be self-managed and deployed on top of your EKS cluster or use Amazon Managed service for Prometheus.

### Workloads

CloudWatch Container Insights can be used to collect and aggregate both metrics and logs from your containerized applications deployed in EKS. The solution is deployed as a containerized version of CloudWatch agent or OpenTelemetry as daemonset, Fluent Bit or FluentD can be used to send logs.

## Monitoring and Logging in Azure Kubernetes Service (AKS) cluster

Azure Kubernetes Service (AKS) generates [platform metrics and resource logs](/azure/aks/monitor-aks-reference), like any other Azure resource, that you can use to monitor its basic health and performance. AKS has a native integration with [Azure Monitor](/azure/azure-monitor/overview), [Container Insights](/azure/azure-monitor/containers/container-insights-overview) is the feature within the product that monitors the health and performance of AKS with visualization completely tailored to Kubernetes environments. Enable [Container insights](/azure/azure-monitor/containers/container-insights-overview) to expand on this monitoring. Container insights is a feature in Azure Monitor that monitors the health and performance of managed Kubernetes clusters hosted on AKS in addition to other cluster configurations.

The following table shows a common strategy for monitoring an AKS cluster and workload applications. Each layer has distinct monitoring requirements.

| **Level** | **Description** | **Monitoring Requirements** |
|---|---|---|
| _1 - Cluster Level Components_ | VMSS abstracted as AKS nodes and node pools | Node status and resource utilization including CPU, memory, disk and network. |
| _2 - Managed AKS Components_ | AKS control plane components including API servers, cloud controller and kubelet | Control plane logs and metrics from kube-system namespace |
| _3 - Kubernetes Objects and Workloads_ | Kubernetes objects such as deployments, containers and replica sets | Resource utilization and failures |
| _4 - Applications_ | Application workloads running on your AKS cluster | Monitoring specific to architecture but includes application logs and service transactions |
| _5 - External to AKS_ | External resources that are not part of AKS but are required for scalability and management of the cluster | Specific to each component |

### Control Plane and Cluster components

Just like in EKS, AKS is composed on different layers that can be grouped into control plane and cluster components as well as workloads and external components:

- **Cluster level components**: you can use existing views and reports in Container Insights to monitor cluster level components such as nodes to understand their health, readiness, performance, resource utilization in terms of CPU and memory, and trends.  
- **Managed AKS components**: you can use metrics explorer to view the Inflight Requests counter, this includes such values as request latency and work queue processing time. If you are using 3rd party solutions like Grafana and Prometheus, they must be set up in your AKS node pools, for Grafana a dashboard that provides views of the critical metrics for the API server is available at [Grafana Labs](https://grafana.com/grafana/dashboards/12006). You can use this dashboard on your existing Grafana server or setup a new Grafana server in Azure using [Monitor your Azure services in Grafana](/azure/azure-monitor/visualize/grafana-plugin).

### Workloads

To monitor workloads and external components in Azure, follow these recommendations:

- **Kubernetes objects and workloads**: you can use existing views and reports in Container Insights to monitor deployment, controllers, pods, and containers. Use the Nodes and Controllers views to view the health and performance of the pods running on them and their resource consumption in terms of CPU and memory. You can view the health and performance of containers from the Containers view, select an individual container and monitor its events and logs in a real-time fashion. See [Monitor your Kubernetes cluster performance with Container insights](/azure/azure-monitor/containers/container-insights-analyze) for details on using this view and analyzing container health and performance.
- **Applications**: you can use [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor applications running on AKS and other environments. If you have a Java application, you can provide monitoring without instrumenting your code following [Zero instrumentation application monitoring for Kubernetes - Azure Monitor Application Insights](/azure/azure-monitor/app/kubernetes-codeless). Application Insights is an application performance management tool that provides support for many programming languages. Depending on your observability and monitoring needs, you could instrument your application code to capture requests, traces, logs, exceptions, custom metrics, and end-to-end transactions and send this data to Application Insights.
- **External components**: you should monitor also external components such as Service Mesh, Ingress, Egress with Prometheus and Grafana, or other proprietary tools. We strongly recommend monitoring any PaaS service used by workload applications such as databases and other Azure resources using other features of Azure Monitor.

The architecture of [Azure Monitor](/azure/aks/monitor-aks) consists of metrics and logs that are stored in a central storage called [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview) and this data is later processed and analyzed to provide insights as well as to be alerted.

![Azure Monitor for Containers Architecture](./media/monitor-containers-architecture.png)

Just like EKS monitoring, when you enable Container Insights for your AKS cluster a containerized version of the Log Analytics agent is deployed, and it is responsible to send data to your Log Analytics workspace.

[Prometheus](https://prometheus.io/) is a popular open source metric monitoring solution and is a part of the [Cloud Native Compute Foundation](https://www.cncf.io/). Container insights provides a seamless onboarding experience to collect Prometheus metrics. Typically, to use Prometheus, you need to set up and manage a Prometheus server with a store. By integrating with Azure Monitor, a Prometheus server is not required. You just need to expose the Prometheus metrics endpoint through your exporters or pods (application), and the containerized agent for Container insights can scrape the metrics for you. Container Insights complements and completes end-to-end monitoring of AKS including log collection which Prometheus as a stand-alone tool doesn’t provide. For more information, see [Configure scraping of Prometheus metrics with Container insights](/azure/azure-monitor/containers/container-insights-prometheus-integration).

## Costs

Azure Container Insights collects, indexes, and stores data generated by your Azure Kubernetes cluster, the Azure Monitor pricing model is primarily based on the amount of data that is ingested per day into your Log Analytics workspace. The cost will also be greatly influenced by the plan selected and retention periods.

Before enabling Container insights it is important to estimate costs and understand how to control the ingestion of data and to control these costs, review the [understand monitoring costs for Container insights](/azure/azure-monitor/containers/container-insights-cost#estimating-costs-to-monitor-your-aks-cluster) documentation for detailed guidance.

## Next Steps

> [!div class="nextstepaction"]
> [Secure network access to Kubernetes API](private-clusters.yml)

The following references provide documentation on the deployment and automation of monitoring on AKS:

- [Use Azure Monitor Private Link Scope](/samples/azure-samples/azure-monitor-private-link-scope/azure-monitor-private-link-scope/)
- [Monitoring Azure Kubernetes Service (AKS) with Azure Monitor](/azure/aks/monitor-aks)
- [Monitoring AKS data reference](/azure/aks/monitor-aks-reference)
- [Container Insights Overview](/azure/azure-monitor/containers/container-insights-overview)
- [Enable Container Insights](/azure/azure-monitor/containers/container-insights-onboard)
- [AKS Resource Logs](/azure/aks/monitor-aks-reference#resource-logs)
- [Configure scraping of Prometheus metrics with Container insights](/azure/azure-monitor/containers/container-insights-prometheus-integration)
- [How to query logs from Container insights](/azure/azure-monitor/containers/container-insights-log-query)
- [Azure Monitor Data Source For Grafana](https://grafana.com/grafana/plugins/grafana-azure-monitor-datasource/)
- [Monitor and backup Azure resources](/learn/paths/az-104-monitor-backup-resources/)
- [Instrument solutions to support monitoring and logging](/learn/paths/az-204-instrument-solutions-support-monitoring-logging/)
- [Design a solution to log and monitor Azure resources](/learn/modules/design-solution-to-log-monitor-azure-resources/)
- [Monitor the usage, performance, and availability of resources with Azure Monitor](/learn/paths/monitor-usage-performance-availability-resources-azure-monitor/)