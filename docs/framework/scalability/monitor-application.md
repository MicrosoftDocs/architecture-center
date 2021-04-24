## Application level monitoring

Application Performance Monitoring (APM) technology, such as [Application Insights](/azure/azure-monitor/app/app-insights-overview), can be used to manage the performance and availability of the application, aggregating application level logs and events for subsequent interpretation. It's designed to help you continuously improve performance and usability. For example, instrumentation of your code allows precise detection of under-performing pieces when load or stress tests are applied. It is critical to have this data available to improve and identify performance opportunities in the application code.

## Best practices for monitoring

- Know the minimum number of instances that should run at any given time.
- Determine what metrics are best for your solution to base your auto scaling rules.
- Configure the auto scaling rules for those services that include it.
- Create alert rules for the services that could be scaled manually.
- Monitor your environment to make sure that autoscaling is working as expected. For example, watch out for scaling events from the telemetry coming out of the management plane.
- Monitor web applications using Azure Application Insights.
- Monitor network performance.
  - Consider reviewing as applicable, [network performance monitor](/azure/azure-monitor/insights/network-performance-monitor-performance-monitor), [service connectivity monitor](/azure/azure-monitor/insights/network-performance-monitor-service-connectivity), and [ExpressRoute monitor](/azure/azure-monitor/insights/network-performance-monitor-expressroute).
- For long-term storage, consider archiving of the Monitoring Data.
- Track activities using [Azure Security and Audit Logs](/azure/security/fundamentals/log-audit).




Here are some questions that can help maximize your application level monitoring:

**Are application events correlated across all application components?**
***

Event correlation between the layers of the application will provide the ability to connect tracing data of the complete application stack. Once this connection is made, you can see a complete picture of where time is spent at each layer. This will typically mean having a tool that can query the repositories of tracing data in correlation to a unique identifier that represents a completed transaction that has flowed through the system.

**Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?**
***

Application level metrics should include end-to-end transaction times of key technical functions, such as database queries, response times for external API calls, failure rates of processing steps, etc.

**Is the end-to-end performance of critical system flows monitored?**
***

It should be possible to correlate application log events across critical system flows, such as user login, to fully assess the health of key scenarios in the context of targets and NFRs.

## Resource/Infrastructure Level Monitoring

Log aggregation technologies, such as Azure Log Analytics or Splunk, should be used to collate logs and metrics across all application components, including infrastructural components, for subsequent evaluation. Resources may include Azure IaaS and PaaS services as well as third-party appliances such as firewalls or Anti-Malware solutions used in the application. For example, if Azure Event Hub is used, the Diagnostic Settings should be configured to push logs and metrics to the data sink.

Here are some questions that can help maximize your resource/infrastructure level monitoring:

**Are you collecting Azure Activity Logs within the log aggregation tool?**
***

Azure Activity Logs provide audit information about when an Azure resource is modified, such as when a virtual machine is started or stopped. This information is useful for the interpretation and troubleshooting of issues. It provides transparency around configuration changes that can be mapped to adverse performance events.

**Is resource level monitoring enforced throughout the application?**
***

All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. [Azure Policy](/azure/governance/policy/overview) should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service.

**Are logs and metrics available for critical internal dependencies?**
***

To be able to build a robust application health model, ensure there is visibility into the operational state of critical internal dependencies, such as a shared NVA (network virtual appliance) or Express Route connection.

**Are critical external dependencies monitored?**
***

Monitor critical external dependencies, such as an API service, to ensure operational visibility of performance. For exaMple, a probe could be used to measure the latency of an external API.

## Data Interpretation & Health Modeling

To build a robust application health model, it is vital that application and resource level data be correlated and evaluated together to optimize the detection of issues and troubleshooting of detected issues. The overall performance can be impacted by both application-level issues as well as resource-level failures. This can also help to distinguish between transient and non-transient faults.

A holistic application health model should be used to quantify what "healthy" and "unhealthy" states represent across all application components. It is highly recommended that a *traffic light* model be used to indicate a healthy state (green light) when key non-functional requirements and targets are fully satisfied and resources are optimally utilized. For example, a healthy state can be 95% of requests are processed in <= 500ms with AKS node utilization at x% etc. Also, An [Application Map](/azure/azure-monitor/app/app-map?tabs=net) can to help spot performance bottlenecks or failure hotspots across components of a distributed application.

Here are some questions that can help maximize your data interpretation and health modeling monitoring:

**Are long-term trends analyzed to predict performance issues before they occur?**
***

Analytics should be performed across long-term operational data to provide the history of application performance and detect if there have been any regressions. An example of a regression is if the average response times have been slowly increasing over time and getting closer to the maximum target.

**Have retention times been defined for logs and metrics, with housekeeping mechanisms configured?**
***

Clear retention times should be defined to allow for suitable historic analysis but also control storage costs. Suitable housekeeping tasks should also be used to archive data to cheaper storage or aggregate data for long-term trend analysis.