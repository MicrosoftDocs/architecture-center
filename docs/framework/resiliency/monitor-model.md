---
title: Health modeling for reliability
description: Use health modeling to improve application reliability in Azure. Differentiate between healthy and unhealthy states. Know how to quantify application states.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Health modeling for reliability

The health model should be able to surface the health of critical system flows or key subsystems to ensure appropriate operational prioritization is applied. For example, the health model should be able to represent the current state of the user login transaction flow.

The health model should not treat all failures the same. For example, the health model should distinguish between transient and non-transient faults. It should clearly distinguish between expected-transient but recoverable failures and a true disaster state.

> [!NOTE]
> The health model should clearly distinguish between expected-transient but recoverable failures and a true disaster state.

## Key points

- Know how to tell if an application is healthy or unhealthy.
- Understand the impact of logs in diagnostic data.
- Ensure the consistent use of diagnostic settings across the application.
- Use critical system flows in your health model.

## Healthy and unhealthy states

A health model qualifies what *healthy* and *unhealthy* states represent for the application. A holistic application health model should be used to quantify what healthy and unhealthy states represent across all application components. It's highly recommended that a "traffic light" model be used to indicate a green/healthy state when key non-functional requirements and targets are fully satisfied and resources are optimally utilized. For example, 95 percent of requests are processed in <= 500ms with AKS node utilization at x% etc. Once established, this health model should inform critical monitoring metrics across system components and operational sub-system composition.

The overall health state can be impacted by both application level issues and resource level failures. [Telemetry correlation](/azure/azure-monitor/app/correlation) should be used to ensure transactions can be mapped through the end-to-end application and critical system flows, as this is vital to root cause analysis for failures. Platform level metrics and logs such as CPU percentage, network in/out, and disk operations/sec should be collected from the application to inform a health model and detect/predict issues. This can also help to distinguish between transient and non-transient faults.

## Quantify application states

Application level events should be automatically correlated with resource level metrics to quantify the current application state. The overall health state can be impacted by both application level issues and resource level failures.

Telemetry correlation should be used to ensure transactions can be mapped through the end-to-end application and critical system flows, as this is vital to root cause analysis for failures. Platform level metrics and logs such as CPU percentage, network in/out, and disk operations/sec should be collected from the application to inform a health model and detect/predict issues(Telemetry correlation). This can also help to distinguish between transient and non-transient faults.

## Application logs

Application logs are an important source of diagnostics data. To gain insight when you need it most, follow these best practices for application logging:

- **Use semantic (structured) logging.** With structured logs, it's easier to automate the consumption and analysis of the log data, which is especially important at cloud scale. Generally, we recommend storing Azure resources metrics and diagnostics data in a Log Analytics workspace rather than in a storage account. This way, you can use [Kusto queries](/azure/data-explorer/kusto/concepts/#kusto-queries) to obtain the data you want quickly and in a structured format. You can also use Azure Monitor APIs and Azure Log Analytics APIs.

- **Log data in the production environment.** Capture robust telemetry data while the application is running in the production environment, so you have sufficient information to diagnose the cause of issues in the production state.

- **Log events at service boundaries.** Include a correlation ID that flows across service boundaries. If a transaction flows through multiple services and one of them fails, the correlation ID helps you track requests across your application and pinpoints why the transaction failed.

- **Use asynchronous logging.** Synchronous logging operations sometimes block your application code, causing requests to back up as logs are written. Use asynchronous logging to preserve availability during application logging.

- **Separate application logging from auditing.** Audit records are commonly maintained for compliance or regulatory requirements and must be complete. To avoid dropped transactions, maintain audit logs separately from diagnostic logs.

All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. [Azure Policy](https://azure.microsoft.com/services/azure-policy/) should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service.

Application level events should be automatically correlated with resource level metrics to quantify the current application state. The overall health state can be impacted by both application level issues as well as resource level failures. [Telemetry correlation](/azure/azure-monitor/app/correlation) should be used to ensure transactions can be mapped through the end-to-end application and critical system flows, as this is vital to root cause analysis (RCA) for failures. Platform level metrics and logs such as CPU percentage, network in/out, and disk operations/sec should be collected from the application to inform a health model and detect/predict issues. This can also help to distinguish between transient and non-transient faults.

### White-box and black-box monitoring

Use white box monitoring to instrument the application with semantic logs and metrics. Application level metrics and logs, such as current memory consumption or request latency, should be collected from the application to inform a health model and detect/predict issues.

Use black-box monitoring to measure platform services and the resulting customer experience. Black box monitoring tests externally visible application behavior without knowledge of the internals of the system. This is a common approach to measuring customer-centric service level indicators (SLIs), service level objectives (SLOs), and service level agreements (SLAs).

### Use critical system flows in the health model

The health model should be able to surface the respective health of critical system flows or key subsystems to ensure appropriate operational prioritization is applied. For example, the health model should be able to represent the current state of the user login transaction flow.

### Create good health probes

The health and performance of an application can degrade over time, and degradation might not be noticeable until the application fails.

Implement probes or check functions, and run them regularly from outside the application. These checks can be as simple as measuring response time for the application as a whole, for individual parts of the application, for specific services that the application uses, or for separate components.

Check functions can run processes to ensure that they produce valid results, measure latency and check availability, and extract information from the system.

:::image type="icon" source="../../_images/github.png" border="false"::: The [HealthProbesSample](https://github.com/mspnp/samples/tree/master/Reliability/HealthProbesSample) sample shows how to set up health probes. It provides an Azure Resource Manager (ARM) template to set up the infrastructure. A load balancer accepts public requests and load balance to a set of virtual machines. The health probe is set up so that it can check for service's path /Health.

## Next step

> [!div class="nextstepaction"]
> [Best practices](./monitor-best-practices.md)

## Related links

- For information on monitoring metrics, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics).
- For information on using Application Insights, see [What is Application Insights?](/azure/azure-monitor/app/app-insights-overview)

Go back to the main article: [Monitoring](monitor-checklist.md)
