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

# Application telemetry and profiling

Enable [Application Insights](/azure/azure-monitor/app/app-insights-overview) for an application by installing an instrumentation package. 

After it's enabled, metrics and logs related to the performance and operation are collected Application Insights provides extensive telemetry out of the box. You can customize what is captured for greater visibility. View and analyze the captured data in [Azure Monitor](/azure/azure-monitor/overview). 


## Next
> [!div class="nextstepaction"] 
> [Monitor infrastructure](monitor-infrastructure.md)


## Related links

> [Back to the main article](monitor.md)