## Aggregated view
Log aggregation technologies, such as Azure Log Analytics or Splunk, should be used to collate logs and metrics across all application components, including infrastructural components, for subsequent evaluation. Resources may include Azure IaaS and PaaS services as well as third-party appliances such as firewalls or Anti-Malware solutions used in the application. For example, if Azure Event Hub is used, the Diagnostic Settings should be configured to push logs and metrics to the data sink.


**Is resource level monitoring enforced throughout the application?**
***

All application resources should be configured to route diagnostic logs and metrics to the chosen log aggregation technology. [Azure Policy](/azure/governance/policy/overview) should also be used as a device to ensure the consistent use of diagnostic settings across the application, to enforce the desired configuration for each Azure service.

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


Azure Monitor Logs is a feature of Azure Monitor that collects and organizes log and performance data from monitored resources. Data from different sources such as platform logs from Azure services, log and performance data from virtual machines agents, and usage and performance data from applications can be consolidated into a single workspace so they can be analyzed together using a sophisticated query language that's capable of quickly analyzing millions of records.