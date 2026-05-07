---
title: Kubernetes Monitoring and Logging
description: Understand monitoring and logging for an Azure Kubernetes Service (AKS) cluster and workloads, and compare Amazon EKS and AKS monitoring and logging.
author: swgriffith
ms.author: stgriffi
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-containers
ms.collection:
  - migration
  - aws-to-azure
---

# Kubernetes monitoring and logging

This article compares Azure Kubernetes Service (AKS) monitoring and Amazon Elastic Kubernetes Service (EKS) monitoring. It describes options that you can use to monitor and manage the logs of an AKS cluster and its workloads.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS monitoring and logging

Like other Kubernetes services, Amazon EKS has two main components, the control plane and worker nodes. Each layer has specific capabilities.

### Amazon EKS control plane and cluster monitoring

Amazon EKS integrates with [Amazon CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html) to provide logging and monitoring for the Amazon EKS control plane. This integration isn't enabled by default. You must configure the integration to gather logs on the following components:

- API server and API calls
- Audit logs and user interactions
- Authentication processes
- Scheduler and controller activities

Amazon EKS exposes [control plane metrics](https://aws.github.io/aws-eks-best-practices/reliability/docs/controlplane/#monitor-control-plane-metrics) at the `/metrics` endpoint, in Prometheus text format. CloudWatch Container Insights collects and stores [Prometheus metrics](https://prometheus.io/docs/introduction/overview). You can deploy and self manage Prometheus on top of your EKS cluster, or use [Amazon Managed Service for Prometheus](https://aws.amazon.com/prometheus).

Amazon EKS also integrates with Amazon Web Services (AWS) CloudTrail to track actions and API calls. For more information, see [Log Amazon EKS API calls by using AWS CloudTrail](https://docs.aws.amazon.com/eks/latest/userguide/logging-using-cloudtrail.html).

### Amazon EKS workload monitoring

[CloudWatch Container Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html) collects and aggregates metrics and logs from containerized applications that are deployed in EKS. To implement Container Insights on Amazon EKS, use a containerized version of the CloudWatch agent, or use [AWS Distro for OpenTelemetry](https://aws.amazon.com/otel) as a DaemonSet. You can use [Fluent Bit](https://fluentbit.io/) to send logs.

## AKS monitoring and logging

Like other Azure resources, AKS generates [platform metrics and resource logs](/azure/aks/monitor-aks-reference) that you can use to monitor its basic health and performance.

:::image type="complex" source="./media/monitor-containers-architecture.svg" border="false" lightbox="./media/monitor-containers-architecture.svg" alt-text="Diagram that shows an AKS logging and monitoring solution.":::
The flowchart shows observability in a cloud environment. Data from containers, AKS, and operating systems are collected as audit logs, control plane logs, inventory performance logs, and events. Inventory performance logs and events from all sources are categorized into logs. AKS audit logs, control plane logs, and metrics are categorized into diagnostic logs and metrics. Diagnostic logs are then categorized into general logs. The logs and metrics provide insights into containers and are visualized through workbooks, views, dashboards, and Power BI. System responses include autoscale and alerts. AKS observability connects directly to insights.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/eks-to-aks-monitoring.vsdx) of this architecture.*

### Azure Monitor

AKS natively integrates with [Azure Monitor](/azure/azure-monitor/overview). Azure Monitor stores metrics and logs in a central location called a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview). Azure Monitor processes and analyzes the metrics and logs to provide insights and alerts. For more information, see [Monitor AKS by using Azure Monitor](/azure/aks/monitor-aks).

[Container insights](/azure/azure-monitor/containers/container-insights-overview) is a feature of Azure Monitor that collects, indexes, and stores data that your AKS cluster generates. You can configure container insights to monitor managed Kubernetes clusters that are hosted on AKS. You can also monitor other cluster configurations. Container insights monitors AKS health and performance and presents that data via visualizations that are tailored to Kubernetes environments. Similar to EKS, when you enable container insights for your AKS cluster, it deploys a containerized version of the Log Analytics agent. The agent sends data to your Log Analytics workspace.

Container insights uses data from a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview) to power the visualizations in the Azure portal. Consider switching to [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview), which provides a cheaper and more efficient approach to metrics collection. You can use container insights to visualize metrics by using only managed Prometheus data. For more information, see [Switch to managed Prometheus visualizations for container insights](/azure/azure-monitor/containers/container-insights-experience-v2).

To help ensure comprehensive monitoring of your Kubernetes clusters, use the following services and Azure Monitor features:

- [Managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview) for effective metric collection
- [Container insights](/azure/azure-monitor/containers/container-insights-overview) to gather logs
- [Azure Managed Grafana](/azure/managed-grafana/overview) for advanced visualization capabilities

### Microsoft Sentinel

[Microsoft Sentinel](/azure/sentinel/overview) delivers intelligent security analytics and threat intelligence across enterprises. Microsoft Sentinel provides a single solution for attack detection, threat visibility, proactive hunting, and threat response.

You must connect Microsoft Sentinel with AKS by using the [AKS connector](https://marketplace.microsoft.com/product/azuresentinel.azure-sentinel-solution-azurekubernetes). Then you can stream your AKS diagnostics logs into Microsoft Sentinel to continuously monitor activity in your instances.

After you connect your data sources to Microsoft Sentinel, you can [visualize and monitor the data](/azure/sentinel/monitor-your-data). Microsoft Sentinel and Azure Monitor workbooks provide versatility to create custom dashboards.

### AKS cluster and workload monitoring

An AKS deployment consists of cluster-level components, managed AKS components, Kubernetes objects and workloads, applications, and external resources. A common strategy to monitor an AKS cluster and workload applications consists of the following monitoring requirements.

| Level | Description | Monitoring requirements |
|---|---|---|
| Cluster-level components | Virtual machine scale sets represent AKS nodes and node pools | Node status and resource usage, including CPU, memory, disk, and network |
| Managed AKS components | AKS control plane components, including API servers, the cloud controller, and `kubelet` | Control plane logs and metrics from the `kube-system` namespace |
| Kubernetes objects and workloads | Kubernetes objects, such as deployments, containers, and replica sets | Resource usage and failures |
| Applications | Application workloads that run on the AKS cluster | Architecture-specific monitoring, including application logs and service transactions |
| External | External resources that aren't part of AKS but are required for cluster scalability and management | Specific to each component |

- **Cluster-level components:** You can use existing container insights views and reports to monitor cluster-level components to understand their health, readiness, performance, CPU and memory resource usage, and trends.

- **Managed AKS components:** You can use Azure Monitor metrics explorer to view the **Inflight Requests** counter. This view includes request latency and work queue processing time.
- **Kubernetes objects and workloads:** You can use existing container insights views and reports to monitor the deployment, controllers, pods, and containers. Use the **Nodes** and **Controllers** views to see the health and performance of the pods that run on nodes and controllers. You can also view their resource consumption in terms of CPU and memory.

  The container insights **Containers** view shows the health and performance of containers. Or you can select an individual container, and monitor its events and logs in real-time. For more information, see [Monitor your Kubernetes cluster performance by using container insights](/azure/azure-monitor/containers/container-insights-analyze).

- **Applications:** You can use [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor applications that run on AKS and other environments. Application Insights is an application performance management tool that provides support for many programming languages. Depending on your needs, you can instrument your application code to capture requests, traces, logs, exceptions, custom metrics, and end-to-end transactions. Then you can send this data to Application Insights. If you have a Java application, you can provide monitoring without instrumenting your code. For more information, see [Autoinstrumentation for AKS](/azure/azure-monitor/app/kubernetes-codeless).

- **External components**: You can use Azure Monitor features to monitor Azure platform as a service (PaaS) solutions that your workload applications use, such as databases and other Azure resources.

#### Azure Monitor managed service for Prometheus

Prometheus is a popular open-source metrics monitoring solution from the [Cloud Native Computing Foundation](https://www.cncf.io/). Prometheus collects and analyzes metric data from Kubernetes clusters. [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview) is a fully managed Prometheus-compatible monitoring solution in Azure. It stores data in an [Azure Monitor workspace](/azure/azure-monitor/essentials/azure-monitor-workspace-overview) that [links to an Azure Managed Grafana workspace](/azure/azure-monitor/essentials/azure-monitor-workspace-manage#link-a-grafana-workspace). You can use Azure Managed Grafana to analyze the data.

You can deploy Prometheus independently as a self-managed solution within AKS clusters. To integrate self-hosted Prometheus with Azure Monitor, configure container insights to collect Prometheus metrics. You can expose the Prometheus metrics endpoint through your exporters or pod applications. The containerized agent for container insights collects these metrics.

#### Azure Managed Grafana

[Azure Managed Grafana](/azure/managed-grafana/overview) is a data visualization platform that's built on top of [Grafana](https://grafana.com/). It's a fully managed Azure service that Microsoft operates and supports. Azure Managed Grafana has predefined Grafana dashboards to monitor Kubernetes and full-stack troubleshooting.

Azure Managed Grafana is optimized for the Azure environment, integrates with many Azure services, and provides simple integration features. You can also deploy Grafana independently as a self-managed solution. For more information, see [Monitor your Azure services in Grafana](/azure/azure-monitor/visualize/grafana-plugin).

### AKS monitoring costs

The Azure Monitor pricing model is primarily based on the amount of data that your Log Analytics workspace ingests each day. The cost varies depending on the plan and retention periods that you choose.

Before you enable container insights, estimate costs and understand how to control data ingestion and its costs. For more information, see [Estimate costs to monitor your AKS cluster](/azure/azure-monitor/containers/container-insights-cost#estimating-costs-to-monitor-your-aks-cluster).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer
- [Ketan Chawda](https://www.linkedin.com/in/ketanchawda1402/) | Senior Customer Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Cloud Solution Architect

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Use Azure Monitor Private Link Scope](/samples/azure-samples/azure-monitor-private-link-scope/azure-monitor-private-link-scope)
- [Enable monitoring for Kubernetes clusters](/azure/azure-monitor/containers/kubernetes-monitoring-enable)
- [Query logs from container insights](/azure/azure-monitor/containers/container-insights-log-query)
- [Azure Monitor data source for Grafana](https://grafana.com/grafana/plugins/grafana-azure-monitor-datasource/)
- [Training: Monitor and back up Azure resources](/learn/paths/az-104-monitor-backup-resources/)
- [Training: Troubleshoot solutions by using Application Insights](/learn/paths/az-204-instrument-solutions-support-monitoring-logging/)
- [Training: Design a solution to log and monitor Azure resources](/learn/modules/design-solution-to-log-monitor-azure-resources/)
- [Training: Azure Monitor fundamentals](/learn/paths/monitor-usage-performance-availability-resources-azure-monitor)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
