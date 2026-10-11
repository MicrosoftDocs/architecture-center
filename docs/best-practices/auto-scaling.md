---
title: Autoscaling Guidance
description: Review autoscaling guidance. Autoscaling is the process of dynamically allocating resources to match performance requirements.
ms.author: pnp
author: claytonsiemens77
ms.date: 10/09/2026
ms.topic: best-practice
ms.subservice: best-practice
ai-usage: ai-assisted
---

# Autoscaling

Autoscaling is the process of dynamically allocating resources to match performance requirements. As demand grows, your workload infrastructure might need to supply more resources to maintain performance and meet service-level objectives (SLOs). As demand decreases, autoscaling can deallocate unneeded resources to reduce costs.

Autoscaling takes advantage of the elasticity of cloud-hosted environments while easing management overhead. It reduces the need for an operator to continually monitor the performance of a system and make decisions about adding or removing resources.

There are two main ways that an application can scale:

- **Vertical scaling**, also called scaling up and down, means to change the capacity of a resource. For example, you could move an application to a larger virtual machine size. Vertical scaling often requires making the system temporarily unavailable while it's being redeployed. Therefore, it's less common to automate vertical scaling.

- **Horizontal scaling**, also called scaling out and in, means adding or removing instances of a resource. Existing instances can continue serving requests while new instances start, but continuity depends on application design, traffic routing, and safe instance removal. When demand drops, scale in only when the remaining instances can handle the load and departing instances can finish or safely hand off their work.

Many cloud-based systems, including Microsoft Azure, support automatic horizontal scaling. The rest of this article focuses on horizontal scaling.

> [!NOTE]
> This article focuses on horizontal scaling of compute resources. Evaluate the capacity of dependent data stores and messaging services separately. Their scaling models and limits can differ from those of compute services and can involve [data partitioning](/azure/well-architected/design-guides/partition-data).

## Autoscaling components

An autoscaling strategy typically involves the following components:

- Instrumentation and monitoring systems capture key metrics at the application, service, and infrastructure levels. These metrics include response times, queue lengths, CPU utilization, and memory usage.

- Decision-making logic evaluates these live usage metrics against predefined thresholds or schedules and decides whether to scale.
- Components and mechanisms perform the scaling action. Ideally, these components and mechanisms should be decoupled from the workload code itself and managed as an external process. Code that's idle or being overwhelmed shouldn't be responsible for scaling itself.
- Testing, monitoring, and tuning capabilities help verify that the autoscaling strategy functions as expected.

Azure provides built-in autoscaling mechanisms that address common scenarios. If a particular service or technology doesn't have built-in autoscaling functionality or if you have specific autoscaling requirements beyond its capabilities, consider a custom implementation. A custom implementation collects operational and system metrics, analyzes the metrics, and scales resources accordingly.

## Configure autoscaling for an Azure solution

Azure compute services provide different autoscaling mechanisms.

- **Azure virtual machines** use [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) to scale as a group. Use [Azure Monitor autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to adjust the number of instances based on metrics or schedules. For more information, see [Autoscale with Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview).

- **Azure Container Apps** provides built-in scaling through Kubernetes Event-driven Autoscaling (KEDA). Scale based on HTTP traffic, event sources, or CPU and memory usage. Scaling to zero depends on the configured rules and minimum replica count. For more information, see [Set scaling rules in Azure Container Apps](/azure/container-apps/scale-app).

- **Azure App Service** supports two distinct scaling mechanisms. Azure Monitor autoscale uses metrics or schedules to scale an App Service plan, affecting all apps in that plan. App Service automatic scaling responds to HTTP traffic and supports per-app scaling settings. Use only one scaling method for an App Service plan. For more information, see [Configure Azure Monitor autoscale](/azure/azure-monitor/autoscale/autoscale-get-started) and [Automatic scaling in App Service](/azure/app-service/manage-automatic-scaling).

- **Azure Functions** scaling depends on the hosting plan. Flex Consumption and Premium plans provide event-driven scaling. Functions apps on a Dedicated plan use the manual or autoscale capabilities of their App Service plan. For more information, see [Azure Functions hosting options](/azure/azure-functions/functions-scale).

- **Azure Kubernetes Service (AKS)** separates workload scaling from node scaling. Use the Horizontal Pod Autoscaler to adjust pod replicas. Use node auto-provisioning (NAP) to address node-pool capacity when pods can't be scheduled or nodes can be removed. For more information, see [Node auto-provisioning in AKS](/azure/aks/node-auto-provisioning) and [AKS scaling options](/azure/aks/concepts-scale).

Before building a custom scaling controller, check whether your service supports the metrics or event-driven rules that you need. For example, Azure Monitor autoscale can use supported application metrics published to Application Insights. If built-in mechanisms can't meet your requirements, a custom controller can evaluate application metrics and use the target service's management APIs to adjust capacity. Account for the effort required to implement, operate, and maintain that controller. Grant the controller only the permissions needed for its scaling operations, scoped to the resources that it manages.

Use built-in autoscaling features when they meet your requirements. Requirements that might justify a custom controller include finer control over scaling decisions, different trigger events, scaling across subscriptions, or scaling other resource types.

## Use the Azure Monitor autoscale feature

The [Azure Monitor autoscale feature](/azure/azure-monitor/autoscale/autoscale-overview) supports resources such as Virtual Machine Scale Sets and App Service plans. Scale on a schedule or based on a metric that the resource supports, such as CPU usage.

Consider the following examples:

- Scale out to 10 instances on weekdays, and scale in to four instances on Saturday and Sunday.

- Scale out by one instance if average CPU usage is higher than 70%, and scale in by one instance if CPU usage falls below 50%.
- Scale out by one instance if the number of messages in a queue exceeds a certain threshold.

Scale out when load increases to maintain capacity, and scale in when demand decreases to reduce costs. Configure both scale-out and scale-in rules. Otherwise, autoscale acts in only one direction until it reaches the profile's maximum or minimum instance count.

Select a default instance count that's safe for your workload. If Azure Monitor can't read the resource metrics and the current instance count is below the default, autoscale scales out to the default count. It doesn't scale in if the current count is higher. Configure the minimum and maximum instance counts separately to define the permitted scaling range.

For a list of built-in metrics, see [Azure Monitor autoscaling common metrics](/azure/azure-monitor/autoscale/autoscale-common-metrics). You can also use custom metrics published through Application Insights. For Application Insights custom metrics, Azure Monitor autoscale supports only metrics in the `Standard` and `Azure.ApplicationInsights` namespaces.

Configure Azure Monitor autoscale by using PowerShell, the Azure CLI, an Azure Resource Manager template, or the Azure portal. For programmatic management of autoscale settings, use the [Azure Monitor autoscale REST API](/rest/api/monitor/autoscale-settings/create-or-update).

Keep scaling rules, schedules, and capacity limits in source control alongside your infrastructure configuration. Review and test changes before deploying them. If you adjust settings in the portal, update the version-controlled configuration so that later deployments don't overwrite those changes.

Consider the following points when you use autoscaling:

- Use scheduled autoscaling for predictable changes in demand and metric-based autoscaling for unpredictable changes. You can combine these approaches.

  For example, schedule instances to start before a busy period, allowing time for provisioning and application startup. Include metric-based rules in the scheduled profile to handle unexpected demand during that period.

- For Virtual Machine Scale Sets workloads with cyclical CPU usage patterns, evaluate [predictive autoscale](/azure/azure-monitor/autoscale/autoscale-predictive). Start in forecast-only mode and compare predicted usage with actual usage. If the predictions are accurate enough for your workload, enable predictive autoscale to scale out as early as one hour before a predicted demand increase. Complement this approach with metric-based rules for unexpected demand and scale-in.

- It's often difficult to understand the relationship between metrics and capacity requirements, especially when an application is initially deployed. Configure a little extra capacity headroom at the beginning, and then monitor and tune the autoscaling rules to bring the capacity closer to the actual load.

- Monitor application performance after you configure autoscaling rules, and use the results to tune them. Account for the time needed to detect changes in demand and complete scaling actions.

- Configure the metric lookback window and aggregation to distinguish sustained changes in demand from transient spikes. Configure a cooldown for each scaling rule to allow metrics to stabilize after a scaling action. Azure Monitor evaluates each rule's cooldown independently, based on the time since the most recent scaling action.

  These settings serve different purposes:

  - The lookback window determines which metric samples are evaluated.
  - The cooldown determines when a rule can initiate another scaling action.

  Measure provisioning and application startup time, and test the combined delay before choosing thresholds and timings.

- Avoid *flapping* where scale-in and scale-out actions continually go back and forth. Suppose there are two instances. The upper limit is 80% CPU and the lower limit is 60%. When the load is at 85%, another instance is added. After some time, the load decreases to 60%. Before the autoscale service scales in, it calculates the distribution of total load (of three instances) when an instance is removed, taking it to 90%. It would have to scale out again immediately. So, it skips scaling in and you might never see the expected scaling results.

  Choose an adequate margin between the scale-out and scale-in thresholds to avoid flapping.

- Autoscale restores manually set instance counts that fall outside the configured range. For example, if the range is three to six instances, autoscale increases a count of one to three and reduces a count of eight to six on its next run. Update the autoscale settings if you need to change the permitted range.

- The autoscale engine selects one profile for the current time, checking fixed-date profiles, recurring profiles, and the default profile in that order. It then evaluates the selected profile's rules. Keep baseline scaling rules in the default profile for periods that scheduled profiles don't cover. Within a profile, autoscale scales out if any scale-out rule is met and scales in only if all scale-in rules are met.

  For more information about how Azure Monitor scales, see [Understand autoscale settings](/azure/azure-monitor/autoscale/autoscale-understanding-settings) and [Best practices for autoscale](/azure/azure-monitor/autoscale/autoscale-best-practices).

- Use custom metrics when built-in metrics don't capture the demand that drives your scaling decisions. For example, measure requests per second or specific business processes, and use these metrics alone or alongside built-in metrics.

- When multiple rules trigger, autoscale resolves conflicts as follows:

  - Scale-out operations always take precedence over scale-in operations.

  - When scale-out operations conflict, the rule that initiates the largest increase in the number of instances takes precedence.
  - When scale-in operations conflict, the rule that initiates the smallest decrease in the number of instances takes precedence.

## Application design considerations

Autoscaling isn't an instant solution. Adding resources to a system or running more instances of a process doesn't guarantee improved performance. Consider the following points when you design an autoscaling strategy:

- Design the application to scale horizontally. Avoid dependencies on a specific instance, and don't assume that requests from the same source always reach the same instance. Design services to be stateless where possible. For queue-based processing, don't assume which instance handles a message: autoscaling can add consumers as demand grows. See the [Competing Consumers pattern](../patterns/competing-consumers.md).

- Set minimum capacity to meet baseline demand and reliability requirements. Maintain enough spare capacity to handle demand while new instances start. If startup latency would violate response-time targets, keep instances warm rather than rely on scaling from zero. For more information, see [Design a reliable scaling strategy](/azure/well-architected/reliability/scaling).

- Account for the instance lifecycle. Initialize new instances before routing traffic to them. During scale-in, stop assigning new work to departing instances and drain connections or checkpoint in-flight work.

- Identify the bottleneck before adding compute capacity. A database, message broker, or downstream API might limit throughput even when more compute instances are available. Define which components must scale together and check their capacity limits. For more information, see [Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning).

- Test scaling in a production-like environment before relying on it. Include gradual load increases, sudden bursts, sustained demand, and scale-in. Measure response time, throughput, errors, queue backlog, and the delay until new capacity can serve requests. Check whether additional instances overload dependencies. For more information, see [Test scaling](/azure/well-architected/performance-efficiency/scale-partition#test-scaling).

- Design long-running tasks to support both scale-out and scale-in. A task can prevent an instance from shutting down cleanly or lose progress if the instance is forcibly terminated. Where possible, split the task into smaller, discrete units of work. For an example, see the [Pipes and Filters pattern](../patterns/pipes-and-filters.yml).

- If you can't split a long-running task, persist checkpoints in durable storage that another instance can access. Record enough progress to resume from the last completed checkpoint, and account for work that might be replayed after an interruption. Make processing idempotent so that retries or duplicate message delivery don't repeat side effects. Test interruption and recovery.

- When background workers run on separate compute instances, use scaling policies that reflect each component's demand. For example, you might need more user interface (UI) instances without increasing the number of background workers, or the opposite. If you offer different service levels, such as basic and premium, align each component's scaling policy with the corresponding performance and availability targets.

### Other scaling criteria

- For queue-based processing, monitor queue depth and message arrival and completion rates. Select scaling signals that relate to your processing time targets. If messages arrive faster than consumers complete them, the backlog grows and latency increases.

  - A short burst might not require more consumers if existing capacity can drain the backlog within the processing time target.
  - Sustained backlog growth can require more consumers, but constrain their combined processing rate to avoid overloading downstream services. If those services can't accept more work, provide backpressure on incoming demand rather than move the bottleneck.

  For more information, see the [Queue-Based Load Leveling pattern](../patterns/queue-based-load-leveling.md).

- Relate business metrics to compute capacity requirements before using them to drive scaling. Examples include orders placed per hour or the average duration of a transaction. A change in one business metric might require scaling several components.

- Set a maximum instance count to bound resource use. Check service limits, subscription quotas, and downstream capacity before choosing that maximum. A configured maximum doesn't establish that the application or its dependencies can support the corresponding load. If demand exceeds the capacity you can safely provide, throttle incoming work or gracefully reduce nonessential functionality.

- Evaluate scaling costs against useful work and service targets. Compare cost per request or completed operation when you tune instance sizes, counts, and scaling thresholds. For more information, see [Optimize scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs).

- A demand spike might pass before new instances are ready. Use throttling to control demand while capacity is limited. For more information, see the [Throttling pattern](../patterns/throttling.md).

- If response time targets don't allow requests to wait for scaling, provision capacity ahead of predictable demand. For unpredictable demand, retain capacity headroom.

- Record scaling decisions, their triggers, requested capacity changes, completion times, and failures. Correlate these events with application performance to check whether scaling achieves its intended result.

- Alert operators when scaling fails, required metrics are unavailable, or the application reaches its configured maximum. For more information, see [Autoscale best practices](/azure/azure-monitor/autoscale/autoscale-best-practices).

## Next step

Validate your autoscaling strategy under realistic load. Start with a load test that measures whether your workload meets its performance targets as demand changes.

> [!div class="nextstepaction"]
> [Design performance tests for your workload](/azure/well-architected/performance-efficiency/performance-test)

## Related resources

The following patterns and guidance might also be relevant to your scenario when implementing autoscaling:

- The [Throttling pattern](../patterns/throttling.md) describes how an application can continue to function and meet SLAs when an increase in demand places an extreme load on resources. Throttling can be used with autoscaling to prevent a system from being overwhelmed while the system scales out.

- The [Competing Consumers pattern](../patterns/competing-consumers.md) describes how to implement a pool of service instances that can handle messages from any application instance. Autoscaling can start and stop service instances to match demand. This approach supports concurrent message processing to improve throughput, scalability, and availability.

- [Monitoring and diagnostics](./monitoring.md), including instrumentation and metrics, are vital for gathering the information that can drive the autoscaling process.
