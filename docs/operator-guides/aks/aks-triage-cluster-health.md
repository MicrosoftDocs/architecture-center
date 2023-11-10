---
title: AKS triage—Cluster health
titleSuffix: Azure Architecture Center
description: Learn how to check the overall health of an Azure Kubernetes Service (AKS) cluster, as part of a triage step for AKS clusters.
author: francisnazareth
ms.author: fnazaret
ms.date: 10/11/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories: compute
categories: compute
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---

# Check AKS cluster health

Start by checking the health of the overall cluster and networking.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

## Tools

To diagnose and solve problems in your Azure Kubernetes Service (AKS) cluster, you can utilize the following tools and features within the Azure portal:

- **AKS diagnose and solve problems**: In the Azure portal, go to your AKS cluster resource and select [diagnose and solve problems](/azure/aks/aks-diagnostics). This intelligent tool offers a self-diagnostic experience that helps identify and resolve issues within your cluster, without extra cost.

- **Resource health**: In the Azure portal, navigate to your AKS cluster resource and choose [resource health](/azure/service-health/resource-health-overview). This tool assists in diagnosing and obtaining support for service problems that might impact your Azure resources. It provides information on your resources' current and past health status.
- **Azure Advisor**: In the Azure portal, go to your AKS cluster resource, select the `Overview` tab, and click on the `Recommendations` section. Alternatively, you can click on the `Advisor Recommendations` link in the left navigation panel. [Azure Advisor](/azure/advisor/advisor-overview)  acts as a personalized cloud consultant, guiding you to follow best practices for optimizing your Azure deployments. It analyzes your resource configuration and usage telemetry, then suggests solutions to enhance cost-effectiveness, performance, reliability, and security of your Azure resources.
- **Log Analytics workspace**: In the Azure portal, navigate to your AKS cluster resource and choose the `Monitoring` tab. From there, select the `Logs` blade located in the left navigation panel to access the cluster logs and metrics stored in the [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) workspace. This feature allows you to monitor and analyze your cluster's logs and metrics for better insights and troubleshooting.

By utilizing these tools and features, you can effectively diagnose and resolve issues, optimize your AKS cluster deployment, and monitor the health and performance of your Azure resources.

[AKS diagnose and solve problems](/azure/aks/aks-diagnostics) provides a comprehensive suite of tools to aid in the identification and resolution of various issues related to your cluster. Depending on the issue you experience, you can check the description on each category tile and select the most relevant one to diagnose your problem. Based on the outcome, you might follow the detailed instructions or refer to the documentation to resolve the issue effectively.

![Screenshot that shows the diagnose and solve problems homepage.](images/aks-diagnostics.png)

You can use the following tiles in [AKS diagnose and solve problems](/azure/aks/aks-diagnostics) to check the cluster health:

- **Cluster and control plane availability and performance**: This tile helps to check if there are any service availability or throttling issues affecting the health of the cluster.
- **Connectivity issues**: This tile helps to verify if there are errors with cluster DNS resolution or if the outbound communication route has connectivity issues.

[Resource health](/azure/service-health/resource-health-overview) helps you identify and get support for cluster issues and service problems that can impact your cluster's health. By adding a resource alert, you can easily monitor the health of your cluster. This feature provides a report on the current and past health of your cluster. The health statuses are:

- **Available**. This status means that there are no events detected that affects the health of the cluster. If the cluster has recovered from unplanned downtime within the last 24 hours, you see a `recently resolved` notification.

- **Unavailable**. This status indicates that the service detected an ongoing platform or nonplatform event that affects the health of the cluster.
- **Unknown**. When resource health doesn't receive any information about the resource for over 10 minutes, this status appears. This usually happens when virtual machines are deallocated. Although this status isn't a definitive indication of the resource's state, it can be a useful data point for troubleshooting.
- **Degraded**. This status means that your cluster detected a loss in performance, but it's still available for use.

![Screenshot that shows the AKS resource health overview.](images/aks-resource-health.png)

For more information, see [Azure resource health overview](/azure/service-health/resource-health-overview).

**Azure Advisor** offers actionable recommendations to help you optimize your AKS clusters for reliability, security, operational excellence, and performance efficiency. Select a recommendation for detailed documentation to optimize your cluster. You can proactively take steps to improve your cluster's performance and avoid potential issues.

![Screenshot that shows the Azure Advisor for AKS overview.](images/aks-advisor.png)

![Screenshot that shows the Azure Advisor for AKS result with actions.](images/aks-advisor-action.png)
![Screenshot that shows the Azure Advisor for AKS result sample 2.](images/aks-advisor-result.png)

For more information, see [Azure Advisor overview](/azure/advisor/advisor-overview).

[Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) offers insights into the cluster's health. To access the [Log Analytics](/azure/aks/monitor-aks) workspace, navigate to your AKS cluster and select `Logs` under the `Monitoring` section in the left navigation panel.

In the `Logs` view, you can choose predefined queries in the following categories to analyze cluster health:

![Screenshot that shows logs.](images/aks-logs.png)

Here are some examples of built-in queries that you can use to query logs and metrics collected in the Log Analytics workspace:

- **Availability**
  - Readiness status per node: View the count of all nodes in the cluster by readiness status.
  - List all the pods count with phase: View the count of all pods by phase: phase: Failed, Pending, Unknown, Running, or Succeeded.
- **Containers**
  - Find a value in Container Logs Table: This query finds rows in the ContainerLogs table where LogEntry has a specified string parameter.
  - List container logs per namespace: View container logs from all namespaces in the cluster.
- **Diagnostics**
  - Cluster Autoscaler logs: Query for logs from the cluster autoscaler. This can help explain why the cluster unexpectedly scales up or down.
  - Kubernetes API server logs: Query for logs from the Kubernetes API server.
  - Image inventory: Lists all the container image with their status.
  - Prometheus disk read per second per node: View Prometheus disk read metrics from the default Kubernetes namespace as timechart.
  - Instances Avg CPU usage growth from last week: Shows the average CPU growth by instance in the last week by descending order.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

Other contributors:

- [Rong Zhang](https://www.linkedin.com/in/rong-zhang-7335561a) | Senior Product Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

> [!div class="nextstepaction"]
> [Examine the node and pod health](aks-triage-node-health.md)
