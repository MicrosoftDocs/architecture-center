## Monitoring for reliability

Improve the reliability of your workloads by implementing high availability, disaster recovery, backup, and monitoring in Azure. Monitoring systems should capture comprehensive details so that applications can be restored efficiently and, if necessary, designers and developers can modify the system to prevent the situation from recurring.

The raw data for monitoring can come from various sources, including:

- Application logs, such as those produced by [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview).
- Operating system performance metrics collected by [Azure monitoring agents](/azure/azure-monitor/platform/agents-overview).
- [Azure resources](/azure/azure-monitor/platform/metrics-supported), including metrics collected by Azure Monitor.
- [Azure Service Health](/azure/service-health/overview), which offers a dashboard to help you track active events.
- [Azure AD logs](/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-log-analytics) built into the Azure platform.

To learn more, see [Monitoring health for reliability](../resiliency/monitoring.md).

Monitor your application for early warning signs that might require proactive intervention. Tools that assess the overall health of the application and its dependencies help you to recognize quickly when a system or its components suddenly become unavailable. Use them to implement an early warning system. For more information, see [Monitoring application health for reliability](../resiliency/monitoring.md#early-warning-system).
