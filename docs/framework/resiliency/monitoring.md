---
title: Monitoring application health for reliability
description: How to use application health monitoring to improve application reliability in Azure
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Monitoring application health for reliability

Monitoring and diagnostics are crucial for availability and resiliency. If something fails, you need to know *that* it failed, *when* it failed, and *why*.

*Monitoring* is not the same as *failure detection*. For example, your application might detect a transient error and retry, avoiding downtime. But it should also log the retry operation so that you can monitor the error rate to get an overall picture of application health. 

## Key points

- Define alerts that are actionable and effectively prioritized.
- Create alerts that poll for services nearing their limits and quotas.
- Use application instrumentation to detect and resolve performance anomalies.
- Track the progress of long-running processes.
-  Troubleshoot issues to gain an overall view of application health.

## Alerting

Alerts are notifications of system health issues that are found during monitoring. Alerts only deliver value if they are actionable and effectively prioritized by on-call engineers through defined operational procedures. Present telemetry data in a format that makes it easy for an operator to notice problems or trends quickly, such as a dashboard or email alert.

### Service level alerts

Use Azure Service Health to respond to *service level* events. Azure Service Health provides a view into the health of Azure services and regions, as well as issuing service impacting communications about outages, planned maintenance activities, and other health advisories.

Azure Service Health alerts should be configured to operationalize Service Health events. However, Service Health alerts should not be used to detect issues due to associated latencies. There is a 5 minute service level objective (SLO) for automated issues, but many issues require manual interpretation to define a root cause analysis (RCA}. Instead, they should be used to provide extremely useful information to help interpret issues that have already been detected and surfaced via the health model, to inform how to respond operationally.

To learn more, see [Azure Service Health](https://docs.microsoft.com/azure/service-health/service-health-overview).

### Resource level alerts

Use Azure Resource Health to respond to *resource level* events. Azure Resource Health provides information about the health of individual resources such as a specific virtual machine, and is highly useful when diagnosing unavailable resources.

Azure Resource Health alerts should be configured for specific resource groups and resource types and should be adjusted to maximize signal to noise ratios. For example, only distribute a notification when a resource becomes unhealthy according to the application health model or due to an Azure platform initiated event. It is important to consider transient issues when setting an appropriate threshold for resource unavailability. For example, configure an alert for a virtual machine with a threshold of 1 minute for unavailability before an alert is triggered.

To learn more, see [Azure Resource Health](https://docs.microsoft.com/azure/service-health/resource-health-overview).

### Dashboards

You can also get a full-stack view of application state by using [Azure dashboards](https://docs.microsoft.com/azure/azure-portal/azure-portal-dashboards) to create a consolidated view of monitoring graphs from Application Insights, Log Analytics, Azure Monitor metrics, and Service Health.

### Samples

:::image type="icon" source="../../_images/github.png" border="false"::: Here are some samples about creating and querying alerts:

- [HealthAlert](https://github.com/mspnp/samples/tree/master/Reliability/HealthAlerts). A sample about creating resource-level health activity log alerts. The sample uses Azure Resource Manager to create alerts.
- [GraphAlertsPsSample](https://github.com/mspnp/samples/tree/master/Reliability/GraphAlertsPsSample). A set of PowerShell commands that queries for alerts generated against your subscription.

## Azure subscription and service limits

Azure subscriptions have limits on certain resource types, such as number of resource groups, cores, and storage accounts. To ensure that your application doesn't run up against Azure subscription limits, create alerts that poll for services nearing their limits and quotas.

Address the following subscription limits with alerts.

:::image type="icon" source="../../_images/github.png" border="false"::: A reference implementation is available on [GitHub](https://github.com/mspnp/serverless-automation/blob/master/src/automation/throttling-responder/deployment.md).

### Individual services

Individual Azure services have consumption limits on storage, throughput, number of connections, requests per second, and other metrics. Your application will fail if it attempts to use resources beyond these limits, resulting in service throttling and possible downtime.

Depending on the specific service and your application requirements, you can often stay under these limits by scaling up (choosing another pricing tier, for example) or scaling out (adding new instances).

### Azure storage scalability and performance targets

Azure allows a maximum number of storage accounts per subscription. If your application requires more storage accounts than are currently available in your subscription, create a new subscription with additional storage accounts. For more information, see [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits).

### Scalability targets for virtual machine disks

An Azure infrastructure as a service (IaaS) virtual machine supports attaching a number of data disks, depending on several factors, including the virtual machine size and the type of storage account. If your application exceeds the scalability targets for virtual machine disks, provision additional storage accounts and create the virtual machine disks there. To learn more, see [Scalability and performance targets for VM disks](https://docs.microsoft.com/azure/virtual-machines/disks-scalability-targets).

### Virtual machine size

If the actual CPU, memory, disk, and I/O of your virtual machines approach the limits of the virtual machine size, your application may experience capacity issues. To correct the issues, increase the virtual machine size.

If your workload fluctuates over time, consider using virtual machine scale sets to automatically scale the number of virtual instances. Otherwise, you need to manually increase or decrease the number of virtual machines.

### Azure SQL Database

If your Azure SQL Database tier isn't adequate to handle your application's Database Transaction Unit (DTU) requirements, your data use will be throttled. For more information on selecting the correct service plan, see [Azure SQL Database purchasing models](https://docs.microsoft.com/azure/azure-sql/database/purchasing-models).

## Instrumentation

Applications should be instrumented to measure the customer experience. Effective instrumentation is vital to detecting and resolving performance anomalies that can impact customer experience and application availability.

Automated failover and failback systems depend on the correct functioning of monitoring and instrumentation. Dashboards to visualize system health and operator alerts also depend on having accurate monitoring and instrumentation. If these elements fail, miss critical information, or report inaccurate data, an operator might not realize that the system is unhealthy or failing. Make sure you include monitoring systems in your test plan.

Applications should be instrumented to track calls to dependent services. Dependency tracking and measuring the duration/status of dependency calls is also vital to measuring overall application health. It should be used to inform a health model for the application.

Provide rich instrumentation:

- For failures that are likely but have not yet occurred, provide enough data to determine the cause, mitigate the situation, and ensure that the system remains available.
- For failures that have already occurred, the application should return an appropriate error message to the user but should attempt to continue running, albeit with reduced functionality.

Monitoring systems should capture comprehensive details so that applications can be restored efficiently and, if necessary, designers and developers can modify the system to prevent the situation from recurring.

## Long-running workflow failures

Long-running workflows often include multiple steps, each of which should be independent.

Track the progress of long-running processes to minimize the likelihood that the entire workflow will need to be rolled back or that multiple compensating transactions will need to be executed.

>[!TIP]
> Monitor and manage the progress of long-running workflows by implementing a pattern such as [Scheduler Agent Supervisor](/azure/architecture/patterns/scheduler-agent-supervisor).

## Analysis and diagnosis

Analyze data consolidated in these data stores to troubleshoot issues and gain an overall view of application health. Generally, you can search for and analyze the data in [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview) and [Log Analytics](https://docs.microsoft.com/azure/azure-monitor/logs/log-analytics-overview) using Kusto queries or view preconfigured graphs using management solutions. Or use [Azure Advisor](https://docs.microsoft.com/azure/advisor/advisor-overview) to view recommendations with a focus on resiliency and performance.

## Next step

>[!div class="nextstepaction"]
>[Health modeling](/azure/architecture/framework/resiliency/monitor-model)

## Related links

- For information on dashboards, see [Azure dashboards](https://docs.microsoft.com/azure/azure-portal/azure-portal-dashboards).
- For information on virtual machine sizes, see [Sizes for virtual machines in Azure](https://docs.microsoft.com/azure/virtual-machines/sizes).
- For information on scale sets, see [virtual machine scale sets overview](https://docs.microsoft.com/azure/virtual-machine-scale-sets/overview).

Go back to the main article: [Monitoring](monitor-checklist.md)