---
title: AKS triage—Cluster health
description: Learn how to check the overall health of an Azure Kubernetes Service (AKS) cluster, as part of a triage step for AKS clusters.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
  - sfi-image-nochange
---

# Evaluate AKS cluster health

*This article is part of a series. Start with the [overview](aks-triage-practices.md).*

To begin your triage practice, evaluate the overall health of the cluster and networking.

## Tools

There are many tools and features that you can use to diagnose and solve problems in your Azure Kubernetes Service (AKS) cluster.

In the Azure portal, select your AKS cluster resource. These tools and features are in the navigation pane.

- [*Diagnose and solve problems*](/azure/aks/aks-diagnostics): You can use this tool to help identify and resolve issues within your cluster.

- [*Resource health*](/azure/service-health/resource-health-overview): You can use this tool to help diagnose and obtain support for service problems that might affect your Azure resources. This tool provides information about your resources' current and past health status.
- *Advisor recommendations*: [Azure Advisor](/azure/advisor/advisor-overview) provides best-practice guidance for optimizing your Azure deployments. You can use Advisor to analyze your resource configuration and usage telemetry. Advisor suggests actions to improve cost-effectiveness, performance, reliability, and security.
- *Logs*: Use this feature to access the cluster logs and metrics that are stored in the [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) workspace. You can monitor and analyze your cluster's logs and metrics to provide insight and improve troubleshooting.

Use these tools and features so you can effectively diagnose and resolve issues, optimize your AKS cluster deployment, and monitor the health and performance of your Azure resources.

### Diagnose and solve problems

The [diagnose and solve problems](/azure/aks/aks-diagnostics) feature provides a comprehensive suite of tools to aid in the identification and resolution of various issues related to your cluster. Select the troubleshooting category that's the most relevant to your problem.

:::image type="content" source="images/aks-diagnostics.png" alt-text="Screenshot that shows the Diagnose and solve problems page." lightbox="images/aks-diagnostics.png" border="false":::

To check the cluster health, you might choose:

- **Cluster and control plane availability and performance**: Check if there are any service availability or throttling issues affecting the health of the cluster.
- **Connectivity issues**: Check if there are errors with cluster Domain Name System (DNS) resolution or if the outbound communication route has connectivity issues.

### Resource health

Use the [resource health](/azure/service-health/resource-health-overview) feature to identify and get support for cluster issues and service problems that can affect your cluster's health. Set up a resource alert so you can monitor the health of your cluster. The resource health feature provides a report on the current and past health of your cluster. There are four health statuses:

- **Available**: This status indicates that there are no events detected that affect the health of the cluster. If the cluster has recovered from unplanned downtime within the last 24 hours, a *recently resolved* notification appears.

- **Unavailable**: This status indicates that an ongoing platform or nonplatform event that affects the health of the cluster has been detected.
- **Unknown**: This status indicates that the feature hasn't received any information about the resource for over 10 minutes. This status usually appears when a virtual machine is deallocated. This status isn't a definitive indication of the resource's state, but it can be a useful data point for troubleshooting.
- **Degraded**: This status indicates that there's a loss in performance for your cluster, but the cluster is still available for use.

The following screenshot shows the resource health overview.

:::image type="content" source="images/aks-resource-health.png" alt-text="Screenshot that shows the AKS resource health overview." lightbox="images/aks-resource-health.png" border="false":::

For more information, see [Azure resource health overview](/azure/service-health/resource-health-overview).

### Advisor

Advisor provides actionable recommendations to help you optimize your AKS clusters for reliability, security, operational excellence, and performance efficiency. You can use Advisor to proactively improve your cluster's performance and avoid potential issues. Select a recommendation for detailed information about how to optimize your cluster.

:::image type="content" source="images/aks-advisor-action.png" alt-text="Screenshot that shows the Advisor for AKS result with actions." lightbox="images/aks-advisor-action.png" border="false":::

The following screenshot shows the resources for the selected recommendation.

:::image type="content" source="images/aks-advisor-result.png" alt-text="Screenshot that shows the Advisor for AKS result sample 2." lightbox="images/aks-advisor-result.png" border="false":::
For more information, see [Advisor overview](/azure/advisor/advisor-overview).

### Log Analytics

[Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) provides insights into the cluster's health. To access the [Log Analytics workspace](/azure/aks/monitor-aks#resource-logs), go to your AKS cluster and select **Logs** in the navigation pane.

You can choose predefined queries to analyze cluster health.

:::image type="content" source="images/aks-logs.png" alt-text="Screenshot that shows queries." lightbox="images/aks-logs.png" border="false":::

Use built-in queries to query logs and metrics collected in the Log Analytics workspace. The following list describes the functions of some of the queries in the availability, container logs, and diagnostics categories.

- **Availability**
  - *Readiness status per node* query: View the count of all nodes in the cluster by the readiness status.
  
  - *List all the pods count with phase* query: View the count of all pods by the phase, such as failed, pending, unknown, running, or succeeded.

- **Container logs**
  - *Find a value in Container Logs Table* query: Find rows in the ContainerLogs table where LogEntry has a specified string parameter.
  
  - *List container logs per namespace* query: View container logs from the namespaces in the cluster.
- **Diagnostics**
  - *Cluster Autoscaler logs* query: Query for logs from the cluster autoscaler. This query can provide information about why the cluster unexpectedly scales up or down.
  
  - *Kubernetes API server logs* query: Query for logs from the Kubernetes API server.
  - *Image inventory* query: List all container images and their status.
  - *Prometheus disk read per second per node* query: View Prometheus disk read metrics from the default Kubernetes namespace as a timechart.
  - *Instances Avg CPU usage growth from last week* query: Show the average CPU growth by instance in the past week, in descending order.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

Other contributor:

- [Rong Zhang](https://www.linkedin.com/in/rong-zhang-7335561a) | Senior Product Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

> [!div class="nextstepaction"]
> [Examine node and pod health](aks-triage-node-health.md)
