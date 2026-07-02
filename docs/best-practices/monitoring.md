---
title: Best Practices for Monitoring and Diagnostics
description: Learn how to track how customers use your distributed applications and services, trace resource utilization, and monitor health and performance.
ms.author: pnp
author: claytonsiemens77
ms.date: 03/27/2026
ms.topic: best-practice
ms.subservice: best-practice
---

<!-- cSpell:ignore SIEM SSDT -->

# Best practices for monitoring and diagnostics

Distributed applications and services that run in the cloud are complex pieces of software that comprise many moving parts. In a production environment, it's important to track how customers use your system, trace resource utilization, and monitor the health and performance of your system. You can use this information to detect and correct problems and to catch potential problems before they occur.

## Monitoring and diagnostics scenarios

You can use monitoring to gain insight into how well a system functions. Monitoring is a crucial part of maintaining quality of service (QoS) targets. Collect monitoring data for the following common scenarios:

- Ensure that the system remains healthy.

- Track the availability of the system and its components.

- Maintain performance to ensure that the system's throughput doesn't degrade unexpectedly as the volume of work increases.

- Guarantee that the system meets service-level agreements (SLAs).

- Protect the privacy and security of the system, users, and their data.

- Track auditing or regulatory operations.

- Monitor the day-to-day usage of the system and address trends that might lead to problems.

- Track problems that occur, from the initial report to analysis of possible causes, rectification, software updates, and deployment.

- Trace operations and debug software releases.

> [!NOTE]
> This article focuses on the most common situations for monitoring. Other scenarios might be less common or specific to your environment.

The following sections describe these scenarios in more detail.

## Health monitoring

A healthy system runs and can process requests. Use health monitoring to generate a snapshot of the current health of the system so that you can verify that all components function as expected.

### Set up alerts

The system should raise an alert within seconds if any part is unhealthy. Alerts can highlight system health via traffic-light signals:

- Red for unhealthy (the system stopped)
- Yellow for partially healthy (the system runs with reduced functionality)
- Green for healthy

A comprehensive health-monitoring system shows you the health status of each subsystem and component so that you can determine which parts are functioning normally and which parts are experiencing problems.

### Collect health data

The following sources can generate the raw data required to support health monitoring:

- Trace the execution of user requests. You can use this information to determine which requests succeed or fail and to measure how long each request takes.

- Monitor synthetic users. This process simulates the actions that a user performs and follows a predefined series of steps. Capture the results of each step.

- Log exceptions, faults, and warnings. You can capture this information from trace statements embedded in the application code and from the event logs of services that the system references.

- Monitor the health of non-Microsoft services that the system uses. You might need to retrieve and parse health data that these services supply.

- Monitor endpoints.

- Collect ambient performance information, such as background CPU utilization or input/output (I/O) operations, including network activity.

### Analyze health data

The primary focus of health monitoring is to quickly indicate whether the system is running. Hot analysis of immediate data can trigger an alert if a critical component is unhealthy.

A more advanced system might include a predictive element that performs a cold analysis over recent and current workloads. A cold analysis can identify trends and determine whether the system is likely to remain healthy or needs more resources. Base this predictive element on the following critical performance metrics:

- The rate of requests directed at each service or subsystem
- The response times of these requests
- The volume of data that flows into and out of each service

If the value of any metric exceeds a defined threshold, the system can raise an alert to scale up. You might also add resources, restart failing services, or throttle lower-priority requests to maintain system health.

## Availability monitoring

In a healthy system, all components and subsystems are available. Availability monitoring is closely related to health monitoring. Health monitoring provides an immediate view of the current health of the system. Availability monitoring tracks the availability of the system and its components to generate statistics about uptime.

In many systems, some components, such as databases, are configured with built-in redundancy to permit rapid failover if a serious fault or loss of connectivity occurs. Gather as much information as possible about these failures to determine the cause and take corrective actions to prevent recurrence.

The data required to track availability might depend on multiple lower-level factors that might be specific to the application, system, and environment. An effective monitoring system captures the availability data that corresponds to these low-level factors and then aggregates them to provide an overall picture of the system. For example, in an e-commerce system, the business functionality that enables a customer to place orders might depend on the repository that stores order details and the payment system that handles monetary transactions. The availability of the order-placement feature depends on the availability of the repository and the payment subsystem.

The availability monitoring solution provides current and historical views of the availability status of each subsystem. It quickly alerts you when one or more services fail or when users can't connect to services. Use this information to identify trends that might cause subsystems to fail. For example, you can use availability data to detect which services fail during peak processing hours.

<!-- markdownlint-disable MD024 -->

### Collect availability data

Monitor synthetic users, log exceptions, faults, and warnings, and monitor endpoints to generate the raw data required to support availability monitoring. The application can expose one or more health endpoints that each test access to a functional area within the system. The monitoring system follows a defined schedule to ping each endpoint and collect the results, like success or fail.

Record all timeouts, network connectivity failures, and connection retry attempts, and time stamp all data.

### Analyze availability data

Aggregate and correlate the data to support the following types of analysis:

- The immediate availability of the system and subsystems.

- The availability failure rates of the system and subsystems. Correlate failures with specific activities to understand the causes of system failure.

- A historical view of failure rates across a specified period and the load on the system, such as the number of user requests, when a failure occurs.

- The reasons for unavailability of the system or subsystems. These reasons include the service not running, lost connectivity, timeouts, or error code responses.

You can calculate the percentage availability of a service over a period of time by using the following formula:

```console
%Availability =  ((Total Time – Total Downtime) / Total Time ) * 100
```

Use this formula for [SLA monitoring](#sla-monitoring). The definition of *downtime* depends on the service. For example, the Azure DevOps build service defines downtime as the period, in total accumulated minutes, during which the build service is unavailable. The service is considered unavailable for one minute if all continuous HTTP requests during that minute result in an error code or don't return a response.

## Performance monitoring

As the volume of users increases, the size of the datasets that users access grows and the possibility of failure of one or more components becomes more likely. Performance degradation often occurs before component failure. If you can detect degradation, you can take proactive steps to prevent failure.

System performance depends on multiple factors. You typically measure each factor through key performance indicators (KPIs), such as the number of database transactions per second or the volume of network requests successfully serviced in a specified time frame. Some of these KPIs might be available as specific performance measures, while other KPIs might be derived from a combination of metrics.

> [!NOTE]
> To determine whether the system's performance is good or bad, you need to know its typical performance level. Observe the system while it functions under a typical load and capture the data for each KPI over a period of time. Consider running the system under a simulated load in a test environment and gather the appropriate data before you deploy it to a production environment.
>
> You should also ensure that performance monitoring doesn't overload the system. Adjust the level of detail for the data that performance monitoring gathers to help optimize your performance.

### Requirements for performance monitoring

To evaluate system performance, you typically need the following information:

- The response rates for user requests
- The number of concurrent user requests
- The volume of network traffic
- The rates at which the system completes business transactions
- The average processing time for requests

Use tools that can help you identify the following correlations:

- The number of concurrent users versus request latency times, or how long it takes to start processing a request after the user sends it

- The number of concurrent users versus the average response time, or how long it takes to complete a request after it starts processing

- The volume of requests versus the number of processing errors

Along with this high-level functional information, obtain a detailed view of the performance for each component in the system. Low-level performance counters typically provide this data. They track the following information:

- Memory utilization
- Number of threads
- CPU processing time
- Request queue length
- Disk or network I/O rates and errors
- Number of bytes written or read
- Middleware indicators, such as queue length

All visualizations should allow you to specify a time period. The displayed data might be a snapshot of the current situation or a historical view of the performance. The system should raise alerts based on any performance measurement for any specified value during any specified time interval.

### Collect performance data

Gather high-level performance data, such as throughput, the number of concurrent users, the number of business transactions, and error rates, by monitoring the progress of users' requests. Incorporate tracing statements and timing information at key points in the application code. Capture all faults, exceptions, and warnings with sufficient data and correlate them with the requests that caused them.

If possible, capture performance data for any external systems that the application uses. These external systems might provide their own performance counters or other features for requesting performance data. If this method isn't possible, record information such as the start time and end time of each request to an external system and the success, fail, or warning status of the operation.

Low-level performance data for individual components in a system might be available through features and services such as Windows performance counters and Azure Diagnostics.

### Analyze performance data

Most analysis aggregates performance data by user request type or by the subsystem or service to which each request is sent. An example of a user request is adding an item to a shopping cart or the checkout process in an e-commerce system.

Another common requirement is to summarize performance data in percentiles. For example, you might determine the response times for 99% of requests, 95% of requests, and 70% of requests. You might set SLA targets or other goals for each percentile. Report ongoing results in near real time to help detect problems immediately. Aggregate results over time for statistical purposes.

Latency problems can also affect performance. To quickly identify the cause of bottlenecks, evaluate the latency of each step that each request performs. The performance data must provide a way to correlate performance metrics for each step to associate them with a specific request.

Depending on your visualization requirements, it might be useful to generate and store a data cube that contains views of the raw data. This data cube can allow complex, unplanned querying and analysis of performance information.

## Security monitoring

All commercial systems that include sensitive data must implement a security structure. The sensitivity of the data typically determines how complex the security mechanism is. In a system that requires users to be authenticated, record the following information:

- All sign-in attempts and whether they fail or succeed

- All operations performed by an authenticated user and the details of all resources that they access

- When a user ends a session and signs out

Monitoring might help detect attacks on the system. For example, several failed sign-in attempts might indicate a brute-force attack. An unexpected surge in requests might be the result of a DDoS attack. Be prepared to monitor all requests to all resources regardless of their source. A system that has a sign-in vulnerability might accidentally expose resources without requiring a user to sign in.

### Requirements for security monitoring

The data that security monitoring captures can help you:

- Detect attempted intrusions by an unauthenticated entity.

- Identify attempts by entities to perform operations on data that they don't have access to.

- Determine whether an unauthenticated user or a malicious authenticated user is attempting to attack the system.

To support these tasks, the system should send alerts if:

- One account makes repeated failed sign-in attempts within a specified period.

- One authenticated account repeatedly tries to access a prohibited resource during a specified period.

- A large number of unauthenticated or unauthorized requests occur during a specified period.

Set up alerts to include the host address of the source for each request. If security violations regularly occur from a specific range of addresses, you can block these hosts.

A key part of maintaining the security of a system is the ability to quickly detect actions that deviate from the usual pattern. You can display information such as the number of failed or successful sign-in requests visually to help detect spikes in activity at unusual times. You can also use this information to set up time-based autoscaling. For example, if you see that many users regularly sign in at a specific time, you can start extra authentication services to handle the volume of work. Shut down these services after the peak passes.

### Collect security data

Security is an all-encompassing aspect of most distributed systems, and monitoring generates pertinent data at multiple points throughout the system. Adopt a Security Information and Event Management (SIEM) approach to gather information that results from events raised by the application, network equipment, servers, firewalls, antivirus software, and other intrusion-prevention elements.

Security monitoring can incorporate data from tools outside your application. These tools include utilities that identify port-scanning activities by external agencies and network filters that detect attempts to gain unauthenticated access to your application and data. In some cases, continuous integration and continuous delivery (CI/CD) deployment tooling makes up an important part of the application life cycle. These tools should also flag anomalous behavior.

### Analyze security data

A key feature of security monitoring is that it collects data from many sources. The different formats and levels of detail often require complex analysis to compile the data into a coherent thread of information. You can detect failed sign-ins or repeated attempts to gain unauthorized access to resources, but complex automated processing of security data might not be feasible. In this scenario, you need to timestamp the data and write it to a secure repository in its original form for expert manual analysis.

## SLA monitoring

Commercial systems that support paying customers make commitments about system performance in the form of [SLAs](/azure/reliability/concept-service-level-agreements). SLAs state that the system can handle a defined volume of work within an agreed time frame and without losing critical information. SLA monitoring ensures that the system meets measurable SLAs.

> [!NOTE]
> SLA monitoring is closely related to performance monitoring. Performance monitoring ensures that the system functions optimally. A contractual obligation that defines what optimally means governs SLA monitoring.

The following metrics define SLAs:

- Overall system availability. For example, an organization might commit to the system being available 99.9% of the time. This percentage equates to no more than nine hours of downtime per year, or approximately 10 minutes per week.

- Operational throughput. This aspect is often expressed as one or more high-water marks, such as a commitment that the system can support up to 100,000 concurrent user requests or handle 10,000 concurrent business transactions.

- Operational response time. The system might also need to process requests at a defined rate. For example, 99% of all business transactions must finish within 2 seconds, and no single transaction takes longer than 10 seconds.

> [!NOTE]
> Some contracts for commercial systems might also include SLAs for customer support. For example, it must respond to all help-desk requests within five minutes, and it must resolve 99% of all problems within one working day. Effective [issue tracking](#issue-tracking) is key to meeting these SLAs.

### Requirements for SLA monitoring

You should be able to quickly determine whether the system meets an SLA. If it doesn't meet the SLA, you need to evaluate the underlying factors to find the cause of substandard performance.

You can depict the following high-level indicators visually:

- The percentage of service uptime

- The application throughput, measured in terms of successful transactions or operations per second

- The number of successful or failing application requests

- The number of application and system faults, exceptions, and warnings

Ensure that you can filter all of these indicators by a specified period of time.

Your cloud application likely comprises multiple subsystems and components. You should be able to select a high-level indicator, like overall system uptime, and determine which underlying elements affect its health status.

> [!NOTE]
> Define system uptime carefully. In a system that uses redundancy to ensure maximum availability, individual instances of elements might fail, but the system can remain functional. For health monitoring, system uptime indicates the aggregate uptime of each element and not necessarily whether the system has stopped. Also, failures might be isolated, so even if a specific system is unavailable, the remainder of the system might remain available with decreased functionality. In an e-commerce system, a failure might prevent a customer from placing orders, but the customer might still be able to browse the product catalog.

For alerting purposes, the system should raise an event if any of the high-level indicators exceed a specified threshold. Make the lower-level details available to the alerting system as contextual data.

### Collect SLA data

Take the following actions to capture the raw data required for SLA monitoring:

- Perform endpoint monitoring.
- Log exceptions, faults, and warnings.
- Trace the execution of user requests.
- Monitor the availability of any non-Microsoft services that the system uses.
- Use performance metrics and counters.

All data must be timed and timestamped.

### Analyze SLA data

Aggregate the SLA data to generate a picture of the overall performance of the system. You should also be able to drill down aggregated data to evaluate underlying subsystems. For example, you should be able to do the following tasks:

- Calculate the total number of user requests during a specified period and determine the success and failure rate of these requests.

- Combine the response times of user requests to generate an overall view of system response times.

- Analyze the progress of user requests to break down the overall response time into the response times of individual work items in the request.

- Determine the overall availability of the system as a percentage of uptime for a specific period.

- Analyze the percentage time availability of the individual components and services in the system. You might need to parse logs that non-Microsoft services generate.

Commercial systems must report real performance figures against SLAs for a specified period. You can use this information to calculate credits or other forms of repayments for customers if you don't meet SLAs during that period. You can calculate availability for a service by using the technique described in [Analyze availability data](#analyze-availability-data).

For internal purposes, an organization might also track the number and nature of incidents that cause services to fail. Learn how to resolve these problems quickly or eliminate them so that you can reduce downtime and meet SLAs.

## Auditing

Depending on the nature of the application, legal regulations might specify requirements for auditing users' operations and recording all data access. Auditing can provide evidence that links customers to specific requests. Nonrepudiation is an important factor in electronic business systems to help maintain trust between a customer and the organization responsible for the application or service.

### Requirements for auditing

You must be able to trace the sequence of business operations that users carry out so that you can reconstruct users' actions. This record might be necessary for documentation purposes or as part of a forensic investigation.

Audit information is highly sensitive. It likely includes data that identifies system users and the tasks that they perform. For this reason, audit information is most likely only available to trusted analysts, rather than as part of an interactive system. The analyst generates a range of reports like the following examples:

- Reports that list all users' activities during a specified time frame

- Reports that detail the chronology of activity for a single user

- Reports that list the sequence of operations performed against one or more resources

### Collect auditing data

The primary sources of information for auditing include:

- The security system that manages user authentication.
- Trace logs that record user activity.
- Security logs that track all identifiable and unidentifiable network requests.

Regulatory requirements might determine the format of the audit data and how you store it. If regulations require you to record the data in its original format, you might not be able to clean the data. As a result, access to the repository that stores it must be closely protected to prevent tampering.

### Analyze audit data

You must be able to access raw data in its entirety and in its original form. Aside from the requirement to generate common audit reports, the tools for analyzing this data are likely specialized and kept external to the system.

## Usage monitoring

Usage monitoring tracks how customers use an application's features and components. You can use the data to:

- Identify popular features and potential hotspots in the system. High-traffic elements might benefit from functional partitioning or replication to spread the load more evenly. You can also use this information to determine which features are infrequently used and are possible candidates for retirement or replacement in a future version of the system.

- Obtain information about the operational events of the system under normal use. For example, in an e-commerce site, you can record statistical information about the number of transactions and the volume of customers responsible for them. You can use this information for capacity planning as the number of customers grows.

- Detect user satisfaction with the performance and functionality of the system. For example, if many customers in an e-commerce system regularly abandon their shopping carts, there might be a problem with the checkout functionality.

- Generate billing information. A commercial application or multitenant service might charge customers for the resources that they use.

- Enforce quotas. If a user in a multitenant system exceeds their paid quota of processing time or resource usage during a specified period, you can limit their access or throttle processing.

- Detect noisy neighbor problems. To help drive error investigations or product decisions, determine whether traffic is evenly spread or if a small set of users generates most of the traffic. If a single user generates significant traffic, the feature might need performance tuning. Alternatively, you might decide to impose extra quotas to reduce traffic.

### Requirements for usage monitoring

To evaluate system usage, you typically need the following information:

- The number of requests that each subsystem processes and directs to each resource

- The work that each user performs

- The volume of data storage that each user occupies

- The resources that each user accesses

You should also be able to generate graphs. Common examples include graphs of users that consume the most resources and the most frequently accessed resources or system features.

### Collect usage data

You can perform high-level usage tracking by noting the start and end times of each request and the nature of each request, such as read or write. To capture this information, do the following tasks:

- Trace user activity.
- Capture performance counters that measure the utilization for each resource.
- Monitor each user's resource consumption.

For metering purposes, you also need to identify which users perform which operations and the resources that these operations use. Ensure that the information you gather is detailed enough to support accurate billing.

## Issue tracking

Customers and other users might report problems if unexpected events or behavior occurs in the system. Issue tracking manages these problems, associates problems with efforts to fix them, and informs customers of resolutions.

### Requirements for issue tracking

To track issues, use a separate system that lets you record and report the details of problems that users report. These details include the attempted tasks, symptoms of the problem, the sequence of events, and error or warning messages.

### Collect issue-tracking data

The initial data source for issue-tracking data is the user who reports the problem. This user might be able to provide the following details:

- A crash dump, if the application includes a component that runs on the user's desktop

- A screen snapshot

- The date and time when the error occurred and other environmental information, such as the user's location

Use this information to help you debug the system and construct a backlog for future software releases.

### Analyze issue-tracking data

Different users might report the same problem, and the issue-tracking system should associate common reports.

Record the progress of the debugging effort against each report. When you resolve the problem, inform the customer of the solution.

If a user reports a problem that has a known solution in the issue-tracking system, you can inform the user of the solution immediately.

## Tracing operations and debugging software releases

When a user reports a problem, they're typically only aware of the immediate effect it has on their operations. The user can only report the results of their own experience. These experiences are usually a visible symptom of one or more fundamental problems. In many cases, an analyst needs to analyze the chronology of the underlying operations to establish the problem's root cause. This process is called *root-cause analysis (RCA)*.

> [!NOTE]
> RCA might uncover inefficiencies in application design. In these scenarios, you might be able to rework the affected elements and deploy them as part of a subsequent release. This process requires careful control, and you should closely monitor the updated components.

### Requirements for tracing and debugging

To trace unexpected events and other problems, the monitoring data must provide enough information to allow an analyst to find the origin of the problem and reconstruct the sequence of events. Then a developer can make modifications to prevent the problem from reoccurring.

### Collect tracing and debugging data

To troubleshoot, trace all the methods and their parameters invoked as part of an operation. Then create a tree that depicts the logical flow through the system when a customer makes a specific request. Capture and log exceptions and warnings that the system generates as a result of this flow.

To support debugging, the system provides hooks that you can use to capture state information at crucial points in the system. Or the system can deliver detailed step-by-step information as selected operations progress. Capturing data at this level of detail can increase load on the system and should be a temporary process. Use this process when unusual and hard-to-replicate events occur or when a new release requires careful monitoring to ensure that the elements function as expected.

## The monitoring and diagnostics pipeline

Monitoring a large-scale distributed system poses a significant challenge. You shouldn't necessarily consider each of the scenarios described in the previous sections in isolation. The monitoring and diagnostic data required for each situation overlaps, but you might need to process and present this data in different ways. For these reasons, take a holistic view of monitoring and diagnostics.

You can imagine the entire monitoring and diagnostics process as a pipeline that comprises the stages shown in the following diagram.

:::image type="complex" source="./images/monitoring/pipeline-stages.png" border="false" lightbox="./images/monitoring/pipeline-stages.png" alt-text="Diagram that shows each stage of the monitoring and diagnostics pipeline.":::
    The diagram shows four sequential stages of a monitoring and diagnostics pipeline arranged horizontally from left to right. Vertical boxes that contain a header icon and label at the top and a stack of labeled tiles represent each stage. On the far left, the first stage is labeled data sources and instrumentation and contains a heartbeat monitor icon. Its tiles list the following sources from top to bottom: application, framework, operating system, infrastructure, dependent services, and release pipeline. An arrow points right to the second stage, collection and storage, which contains a database icon. Its tiles list performance metrics, activity and user traces, exceptions and warnings, availability information, and context information. An arrow points right to the third stage, analysis and diagnosis, which contains an eye icon. Its tiles list filtering, aggregation, correlation, reformatting, and comparison against KPIs. An arrow points right to the fourth and final stage, visualization and alerting, which contains a warning triangle icon. Its tiles list dashboards, alerts, reports, unplanned queries, and exploration. A curved arrow beneath the diagram points from the analysis and diagnosis stage to the collection and storage stage.
:::image-end:::

The diagram shows how monitoring and diagnostics data comes from various sources. The instrumentation and collection stages help you identify the data that you need to capture, where and how to capture it, and how to format the data so that you can easily analyze it. The analysis and diagnosis stage takes the raw data and uses it to generate meaningful information that you can use to determine the state of the system. You can use this information to determine which possible actions to take and then feed the results back into the instrumentation and collection stages. The visualization and alerting stage presents a consumable view of the system state. It can display information in near real time by using a series of dashboards. It can generate reports, graphs, and charts to provide a historical view of the data that can help you identify long-term trends. If information indicates that a KPI is likely to exceed acceptable bounds, this stage can also trigger an alert. In some cases, an alert can also trigger an automated process that attempts to take corrective actions, such as autoscaling.

These steps form a continuous-flow process in which the stages run in parallel. Ideally, all the phases should be dynamically configurable. At some points, especially when a system is newly deployed or is experiencing problems, you might need to gather extended data more frequently. At other times, you can continue to capture high-level, essential information to verify that the system is functioning properly.

Treat the entire monitoring process as a live, ongoing solution that needs fine-tuning and improvements based on feedback. For example, you might start by measuring many factors to determine system health and refine your analysis over time to discard measures that aren't relevant.

## Sources of monitoring and diagnostic data

The information that the monitoring process uses can come from several sources. At the application level, information comes from trace logs that you incorporate into the system code. Developers should follow a standard approach for tracking the flow of control through their code. For example, an entry to a method can emit a trace message that specifies the name of the method, the current time, the value of each parameter, and other pertinent information. You might also want to record the entry and exit times.

Log all exceptions and warnings, and ensure that you retain a full trace of any nested exceptions and warnings. Capture information that identifies the user who runs the code and activity correlation information to track requests as they pass through the system. Log attempts to access all resources such as message queues, databases, files, and other dependent services. You can use this information for metering and auditing purposes.

Many applications use libraries and frameworks to perform common tasks such as accessing a data store or communicating over a network. You might be able to configure these frameworks to provide their own trace messages and raw diagnostic information, such as transaction rates and data transmission successes and failures.

> [!NOTE]
> Many modern frameworks automatically publish performance and trace events. To capture this event information, you must provide a way to retrieve and store it until you can process and analyze the data.

The operating system on which the application runs can be a source of low-level, system-wide information, such as performance counters that indicate I/O rates, memory utilization, and CPU usage. It might also report operating system errors, such as the failure to open a file correctly.

Also consider the underlying infrastructure and components on which your system runs. Virtual machines (VMs), virtual networks, and storage services can all be sources of important infrastructure-level performance counters and other diagnostic data.

If your application uses other external services, such as a web server or database management system (DBMS), these services might publish their own trace information, logs, and performance counters. For example, dynamic management views (DMVs) in SQL Server track operations performed against a SQL Server database. Application Insights traces logs for recording requests made to Azure App Service.

As you modify system components and deploy new versions, it's important that you can attribute problems, events, and metrics to each version. Associate this information with the release pipeline so that you can track and fix problems with a specific version of a component quickly.

Use the following strategies to gather monitoring and diagnostic data:

- **Application and system monitoring** uses internal sources within the application, application frameworks, operating system, and infrastructure. The application code can generate its own monitoring data at notable points during the life cycle of a client request. The application can include tracing statements that you can turn on and off as needed. You might also inject diagnostics dynamically by using a diagnostics framework. These frameworks typically provide plugins that attach to various instrumentation points in your code and capture trace data at these points.

    Your code or the underlying infrastructure might also raise events at critical points. Monitoring agents configured to listen for these events can record the event information.

- **Real user monitoring** records the interactions between a user and the application and observes the flow of each request and response. Use this information to meter usage by each user and determine whether users receive a suitable QoS, including fast response times, low latency, and minimal errors. You can use the data to identify areas where failures occur most often. You can also use the data to identify areas where the system slows down because of hotspots in the application or other bottlenecks. If you implement this approach carefully, you might be able to reconstruct users' flows through the application for debugging and testing purposes.

  > [!IMPORTANT]
  > Treat data captured by real user monitoring as highly sensitive because it might include confidential material. If you save captured data, store it securely. If you want to use the data for performance monitoring or debugging purposes, remove all personal data first.

- **Synthetic user monitoring** requires you to write your own test client that simulates a user and performs a configurable but typical series of operations. You can track the performance of the test client to help determine the state of the system. You can also use multiple instances of the test client as part of a load-testing operation to establish how the system responds under stress and the monitoring output that these conditions generate.

  > [!NOTE]
  > You can implement real and synthetic user monitoring by including code that traces and times the execution of method calls and other critical parts of an application.

- **Profiling** helps you monitor and improve application performance. Unlike real user monitoring and synthetic user monitoring, which operate at the functional level, profiling captures lower-level information as the application runs. Implement profiling by periodically sampling the execution state of an application or by determining which piece of code the application runs at a specific time. You can also use instrumentation that inserts probes into the code at important junctures, such as the start and end of a method call. The probes record which methods the call invoked, at what time, and how long each call takes. You can then analyze this data to determine which parts of the application might cause performance problems.

- **Endpoint monitoring** uses one or more diagnostic endpoints that the application exposes specifically to enable monitoring. An endpoint provides a pathway into the application code and can return information about the health of the system. Different endpoints can focus on various aspects of the functionality. You can write your own diagnostics client that sends periodic requests to these endpoints and assimilates the responses. For more information, see the [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.yml).

- **User error dumps** rely on the application to provide a way to collect a snapshot of the application state if it can't recover. Users also need to voluntarily share that snapshot. You can't guarantee that an error dump runs, but you can use the low-level data that it provides to determine the root cause of errors. This scenario is common if the errors happen infrequently or if errors only occur in an infrequently used application feature.

For maximum coverage, you should use a combination of these techniques.

## Instrument an application

Instrumentation is a critical part of the monitoring process. You must capture data that helps you make meaningful decisions about your system's performance and health. Use instrumentation to gather enough information to assess performance, diagnose problems, and make decisions without signing in to a remote production server to trace and debug manually. Instrumentation data typically comprises metrics and information written to trace logs.

A trace log can contain textual data that the application writes or binary data that a trace event creates, if the application uses Event Tracing for Windows (ETW). System logs that record events that occur from parts of the infrastructure, such as a web server, can also generate trace log content. Textual log messages are often human-readable, but write them in a format that an automated system can also parse easily.

Also categorize logs. Don't write all trace data to a single log. Use separate logs to record the trace output from different operational aspects of the system. You can then quickly filter log messages by reading from the appropriate log rather than processing a single lengthy file. Never write information that has different security requirements, such as audit information and debugging data, to the same log.

> [!NOTE]
> You can implement a log as a file on the file system, or you can hold it in some other format, such as a blob in blob storage. You can also hold log information in more structured storage, such as rows in a table.

Metrics are generally a measure or count of some aspect or resource in the system at a specific time, with one or more associated tags or dimensions, also called a *sample*. A single instance of a metric isn't useful in isolation. Instead, capture metrics over time. Consider which metrics to record and how frequently. Generating data for metrics too often can put too much load on the system. But not capturing enough data might cause you to miss the circumstances that lead to a significant event. The considerations vary from metric to metric. For example, CPU utilization on a server might fluctuate from second to second, but high utilization becomes a concern only if it persists for several minutes.

### Information for correlating data

You can easily monitor individual system-level performance counters, capture metrics for resources, and obtain application trace information from various log files. But some forms of monitoring require the analysis and diagnostics stage in the monitoring pipeline to correlate data retrieved from several sources. This raw data might take several forms, and the analysis process must have sufficient instrumentation data to map these different forms. For example, at the application framework level, a thread ID might identify a task. Within an application, the same work might be associated with the user ID for the user who performs that task.

A one-to-one mapping likely doesn't exist between threads and user requests because asynchronous operations might reuse the same threads to perform operations for more than one user. More than one thread might also handle a single request as execution flows through the system. If possible, associate each request with a unique activity ID propagated through the system as part of the request context. The technique for generating and including activity IDs in trace information depends on the technology that you use to capture the trace data.

Timestamp all monitoring data in the same way. For consistency, record all dates and times by using UTC. This method helps you more easily trace sequences of events.

> [!NOTE]
> Computers that operate in different time zones and networks might not be synced. Don't depend on timestamps alone for correlating instrumentation data that spans multiple machines.

### Information to include in the instrumentation data

Consider the following points when you decide which instrumentation data to collect:

- Ensure that information captured by trace events is machine-readable and human-readable. Adopt well-defined schemas for this information to facilitate automated processing of log data across systems and to provide consistency to the operations and engineering staff that read the logs. Include environmental information, such as the deployment environment, the machine on which the process runs, the details of the process, and the call stack.

- Enable profiling only when necessary because it can add significant overhead to the system. Profiling by using instrumentation records an event, such as a method call, every time it occurs, while sampling only records selected events. The selection can be time-based, once every *n* seconds, or frequency-based, once every *n* requests. If events occur frequently, profiling by instrumentation might cause too much of a burden and affect overall performance. In this case, the sampling approach is preferable. However, if the frequency of events is low, sampling might miss them. In this case, instrumentation might be the better approach.

- Provide sufficient context so that a developer or administrator can determine the source of each request. This context might include an activity ID that identifies a specific instance of a request or information that correlates an activity with the computational work performed and the resources used. This work might cross process and machine boundaries. For metering, the context should also include, either directly or indirectly via other correlated information, a reference to the customer who raises the request. This context provides valuable information about the application state when you capture monitoring data.

- Record all requests, and the locations or regions from which these requests are made. This information can help you determine whether any location-specific hotspots exist. It can also help you determine whether to repartition an application or the data that it uses.

- Record and capture the details of exceptions carefully. Often, critical debug information is lost as a result of poor exception handling. Capture the full details of exceptions that the application throws, including any inner exceptions and other context information. Include the call stack if possible.

- Be consistent in the data that the different elements of your application capture. Consistency can help you analyze events and correlate them with user requests. Consider using a comprehensive and configurable logging package to gather information, rather than depending on developers to adopt the same approach as they implement different parts of the system. Gather data from key performance counters, such as I/O volume, network utilization, number of requests, memory use, and CPU utilization. Some infrastructure services might provide their own performance counters, such as the number of connections to a database, the rate at which the system performs transactions, and the number of transactions that succeed or fail. Applications might also define their own specific performance counters.

- Log all calls made to external services, such as database systems, web services, or other system-level services that are part of the infrastructure. Record information about the time it takes to perform each call, and whether the call succeeds or fails. If possible, capture information about all retry attempts and failures for any transient errors that occur.

### Ensure compatibility with telemetry systems

In many cases, the information that instrumentation produces is generated as a series of events and passed to a separate telemetry system for processing and analysis. A telemetry system is typically independent of specific applications or technologies, but it expects information to follow a specific format defined by a schema. The schema specifies a contract that defines the data fields and types that the telemetry system can ingest. Generalize the schema to allow data from a range of platforms and devices. One example of a widely used framework and schema is [OpenTelemetry](https://opentelemetry.io/).

A common schema should include fields that all instrumentation events have in common, such as the event name, the event time, the IP address of the sender. It should also include the details required for correlating with other events, such as a user ID, a device ID, and an application ID. Remember that any number of devices might raise events, so the schema shouldn't depend on the device type. Also, various devices might raise events for the same application, and the application might support roaming or some other form of cross-device distribution.

The schema might also include domain fields that are relevant to a particular scenario that's common across different applications. These scenarios include information about exceptions, application start and end events, and success or failure of web service API calls. All applications that use the same set of domain fields should emit the same set of events to build a set of common reports and analytics.

Finally, a schema might contain custom fields for capturing the details of application-specific events.

### Best practices for instrumenting applications

The following list summarizes best practices for instrumenting a distributed application that runs in the cloud:

- Make logs easy to read and parse. Use structured logging where possible. Be concise and descriptive in log messages.

- In all logs, identify the source and provide context and timing information as each log record is written.

- Use the same time zone and format for all timestamps. This practice helps correlate events for operations that span hardware and services that run in different geographic regions.

- Categorize logs and write messages to the appropriate log file.

- Don't disclose sensitive information about the system or personal information about users. Scrub this information before you log it, but ensure that you retain the relevant details. For example, remove the ID and password from database connection strings. Write the remaining information to the log so that you can determine whether the system accesses the correct database. Log all critical exceptions but allow the administrator to turn logging on and off for lower levels of exceptions and warnings. Also, capture and log all retry logic information. You can use this data to monitor the transient health of the system.

- Trace out-of-process calls, such as requests to external web services or databases.

- Don't mix log messages with different security requirements in the same log file. For example, don't write debug and audit information to the same log.

- Initiate logging calls that continue to operate autonomously. These types of operations don't block the progress of business operations. Auditing events are an exception because they're critical to the business. Classify them as a fundamental part of business operations.

- Ensure that logging is extensible and doesn't have any direct dependencies on a concrete target. For example, rather than writing information by using *System.Diagnostics.Trace*, define an abstract interface, such as *ILogger*, that exposes logging methods and that you can implement through any suitable means.

- Ensure that all logging is fail-safe and never triggers cascading errors. Logging must not raise any exceptions.

- Treat instrumentation as an ongoing iterative process and review logs regularly, not only when a problem occurs.

## Collect and store data

The collection stage retrieves the information that instrumentation generates, formats this data to make it easier to consume during the analysis and diagnosis stage, and saves the transformed data in reliable storage. You can store the instrumentation data that you gather from different parts of a distributed system in various locations and formats. For example, your application code might generate trace log files and application event log data. Other technologies can capture performance counters that monitor key aspects of the infrastructure that your application uses. Any non-Microsoft components and services that your application uses might provide instrumentation information in different formats by using separate trace files, blob storage, or even a custom data store.

A collection service that runs autonomously from the application that generates the instrumentation data typically collects the data. The following diagram shows an example of this architecture and highlights the instrumentation data-collection subsystem.

:::image type="complex" source="./images/monitoring/telemetry-service.png" border="false" lightbox="./images/monitoring/telemetry-service.png" alt-text="Diagram that shows an example instrumentation data collection architecture.":::
    The diagram is divided into three sections labeled instrumentation sources, instrumentation data and collection subsystem, and analysis and visualization subsystem from left to right. In the instrumentation sources section, a box contains three stacked items: application code, infrastructure, and non-Microsoft components. Three labeled arrows extend from this box to the right. The arrow labeled counters points to a circle labeled ETW providers. The arrow labeled events points to a circle labeled event log service. The arrow labeled logs points directly to a rectangle labeled trace logs in the middle section, bypassing the two circular nodes. In the instrumentation data and collection subsystem in the middle of the diagram, three rectangles labeled Event Trace Log (ETL) files, event logs, and trace logs are stacked vertically. An arrow connects ETW providers and ETL files. Another arrow connects event log service and event logs. Arrows point from all three rectangles to a central circle labeled collection service. An arrow points from collection service to storage. A separate arrow labeled hot analysis path runs along the top of the middle section. It points to hot analysis in the analysis and visualization subsystem on the right. That section also includes visualization and alerting and warm and cold analysis.
:::image-end:::

This diagram shows a simplified view of data collection. The collection service typically comprises many parts that run on different machines. If you need to analyze telemetry data quickly, use local components that operate outside the collection service. After analytical processing, the components send the results directly to the visualization and alerting subsystem. Data subject to warm or cold analysis is held in storage while it waits for processing. For more information, see [Support hot, warm, and cold analysis](#support-hot-warm-and-cold-analysis).

For Azure applications and services, Diagnostics provides one possible solution for capturing data. Diagnostics gathers data from the following sources for each compute node, aggregates it, and then uploads it to Azure Storage:

- Internet Information Services (IIS) logs
- IIS failed request logs
- Windows event logs
- Performance counters
- Crash dumps
- Diagnostics infrastructure logs
- Custom error logs
- .NET EventSource
- Manifest-based ETW

### Strategies for collecting instrumentation data

Because of the elastic nature of the cloud, and to avoid manually retrieving telemetry data from every node in the system, arrange to consolidate the data and transfer it to a central location. In a system that spans multiple datacenters, you might want to collect, consolidate, and store data on a region-by-region basis first, and then aggregate the regional data into a single central system.

To optimize bandwidth use, you can transfer less urgent data as batches. Don't delay the transfer indefinitely, especially if the data contains time-sensitive information.

#### Pull and push instrumentation data

The instrumentation data-collection subsystem can actively retrieve instrumentation data from the various logs and other sources for each instance of the application. This method is called the *pull model*. Or it can act as a passive receiver that waits for the components that constitute each instance of the application to send the data. This method is called the *push model*.

One approach to the pull model is to use monitoring agents that run locally with each instance of the application. A monitoring agent is a separate process that periodically retrieves telemetry data collected at the local node and writes this information directly to centralized storage that all instances of the application share. The [Azure Monitor agent](/azure/azure-monitor/agents/azure-monitor-agent-overview) implements this mechanism. You can configure each compute instance to capture diagnostic and other trace information stored locally. The monitoring agent that runs alongside each instance collects the specified data and sends it to Azure Monitor. Some elements, such as IIS logs, crash dumps, and custom error logs, are written to blob storage. Data from the Windows event log, ETW events, and performance counters is recorded in table storage. The following diagram shows an example of this architecture.

:::image type="complex" source="./images/monitoring/pull-model.png" border="false" lightbox="./images/monitoring/pull-model.png" alt-text="Diagram that shows how a monitoring agent pulls information and writes to shared storage.":::
    The diagram illustrates the pull model for collecting instrumentation data across two compute nodes. The two nodes are arranged vertically, and each follows an identical structure. Each node consists of four stacked rectangles that represent local log stores, including ETL files, OS event logs, application trace logs, and custom trace logs. Arrows that represent incoming application activity point from the left edge of the diagram to each node. To the right of the log stores, arrows point from a monitoring agent to each of the log stores. Arrows point from the monitoring agent to shared storage on the far right.
:::image-end:::

> [!NOTE]
> A monitoring agent works well for capturing instrumentation data naturally pulled from a data source, such as information from SQL Server Dynamic Management Views or the length of an Azure Service Bus queue.

You can use the pull and push models to store telemetry data for a small-scale application that runs on a limited number of nodes in a single location. A complex, highly scalable, global cloud application might generate huge volumes of data from hundreds of compute instances, database shards, and other services. This flood of data can easily overwhelm the I/O bandwidth available with a single, central location. As a result, you must be able to scale your telemetry solution to prevent a bottleneck as the system expands. Ideally, your solution should incorporate a degree of redundancy to reduce the risks of losing important monitoring information, such as auditing or billing data, if part of the system fails.

To address these problems, implement queuing. In the following example architecture, the local monitoring agent or custom data-collection service posts data to a queue. The storage-writing service, a separate asynchronous process, takes the data in this queue and writes it to shared storage. A message queue is suitable for this scenario because it provides *at-least-once* semantics that help ensure that queued data isn't lost after it's posted. You can implement the storage-writing service by using a separate background process.

:::image type="complex" source="./images/monitoring/buffered-queue.png" border="false" lightbox="./images/monitoring/buffered-queue.png" alt-text="Diagram that shows how a queue buffers instrumentation data.":::
    The diagram shows how a message queue buffers instrumentation data between two data collection services and a shared storage destination. On the left side of the diagram, two identical node structures are stacked vertically. Each node contains local log stores, including ETL files, OS event logs, application trace logs, and custom trace logs. To the right of each set of log stores is a data collection service. Arrows point from each data collection service leftward to each log store, which indicates that the service pulls data from each log store. An arrow points from each data collection service to a central message queue, which contains icons that represent queued messages. Another arrow points from the message queue to a storage writing service. From the storage writing service, a final arrow points to a rectangle labeled shared storage. The overall structure shows that both data collection services on separate nodes feed into the same message queue, which acts as a buffer. The storage writing service then reads from the queue at its own pace and writes the data to shared storage.
:::image-end:::

The local data-collection service can add data to a queue immediately after receiving it. The queue acts as a buffer, and the storage-writing service can retrieve and write the data at its own pace. By default, a queue operates on a first-in, first-out basis. But you can prioritize messages to accelerate them through the queue if they contain data that you must handle quickly. For more information, see the [Priority Queue pattern](../patterns/priority-queue.yml). Alternatively, you can use different channels, such as Service Bus topics, to direct data to different destinations depending on the form of analytical processing required.

For scalability, you can run multiple instances of the storage-writing service. For high volumes of events, you can use an event hub to dispatch the data to different compute resources for processing and storage.

#### Consolidate instrumentation data

The instrumentation data that the data-collection service retrieves from a single instance of an application gives a localized view of the health and performance of that instance. To assess the overall health of the system, consolidate aspects of the data in the local views. You can perform this step after the data is stored, but in some cases you can also do it as the data is collected. Rather than writing directly to shared storage, the instrumentation data passes through a separate service that consolidates, filters, and cleans data. For example, instrumentation data that includes the same correlation information, such as an activity ID, can be amalgamated. A user might start a business operation on one node and then be transferred to another node if the node fails or because of load balancing. This process can also detect and remove duplicated data, which is possible if the telemetry service uses message queues to push instrumentation data out to storage. The following diagram shows an example of this structure.

:::image type="complex" source="./images/monitoring/data-consolidation.png" border="false" lightbox="./images/monitoring/data-consolidation.png" alt-text="Diagram that shows an architecture that uses a service to consolidate instrumentation data.":::
    The diagram shows an instrumentation data consolidation architecture that flows from left to right. On the left side of the diagram, two vertically stacked identical node structures represent separate compute nodes. Each node contains four stacked rectangles that represent local log stores, including ETL files, OS event logs, application trace logs, and custom trace logs. To the right of each set of log stores is a data collection service. Arrows extend leftward from each data collection service to each of the four log stores in its corresponding node, which indicates that the service pulls data from all local log sources. An arrow points from each data collection service to a central message queue, which contains icons that represent queued messages. An arrow points from the message queue to a storage writing service. From the storage writing service, an arrow points to a consolidation and cleanup service. The consolidation and cleanup service connects via a bidirectional arrow to a rectangle on the far right labeled shared storage. This arrow indicates that data flows into shared storage and that the service can read from shared storage during processing. This architecture shows how instrumentation data from both compute nodes flows through a shared queue and a dedicated storage writing service. Then, the consolidation and cleanup service amalgamates, filters, and deduplicates the data before final storage.
:::image-end:::

### Store instrumentation data

The previous sections show a simplified view of how to store instrumentation data. In practice, you should store different types of information by using the technologies that suit how you plan to use it.

For example, Azure Blob Storage and Azure Table Storage have similar access patterns, but the operations that they can perform are limited, and the granularity of the data that they store varies. If you need to perform analytical operations or require full-text search capabilities, you might need to use data storage that provides the following query and data-access capabilities:

- Store performance counter data in a SQL database to enable unplanned analysis.
- Store trace logs in Azure Cosmos DB.
- Write security information to the Hadoop Distributed File System (HDFS).
- Store information that requires full-text search by using Elasticsearch, which uses rich indexing to accelerate searches.

The following diagram shows how you can implement an extra service that periodically retrieves the data from shared storage, partitions and filters the data according to its purpose, and then writes it to an appropriate set of data stores. An alternative approach is to include this functionality in the consolidation and cleanup process and write the data directly to these stores as it's retrieved, rather than saving it in an intermediate shared storage area. Each approach has advantages and disadvantages. Implementing a separate partitioning service reduces the load on the consolidation and cleanup service. It also lets you regenerate at least some of the partitioned data if necessary, depending on how much data shared storage retains. However, this approach consumes more resources. It might also delay the receipt of instrumentation data from each application instance and the conversion of this data into actionable information.

:::image type="complex" source="./images/monitoring/data-storage.png" border="false" lightbox="./images/monitoring/data-storage.png" alt-text="Diagram that shows partitioning and data storage.":::
    The diagram shows a data partitioning and storage architecture that flows from left to right. On the far left, an arrow enters the diagram from outside the frame and points to a circular node labeled storage writing service. An arrow points from the storage writing service to a second circular node labeled consolidation and cleanup service. A bidirectional arrow connects the consolidation and cleanup service to shared storage, which indicates that data flows into shared storage and that the consolidation and cleanup service can also read from it. Another arrow points from shared storage to a data partitioning service. From the data partitioning service, arrows point downward to storage destinations, including a SQL database, a generic data store, and Azure Cosmos DB. This architecture shows how the data partitioning service retrieves consolidated instrumentation data from shared storage and routes it to specialized data stores based on the type and purpose of the data.
:::image-end:::

You might need the same instrumentation data for more than one purpose. For example, performance counters can provide a historical view of system performance over time. You can combine this information with other usage data to generate customer billing information. In these scenarios, send the same data to more than one destination, such as a document database that stores billing information and a multidimensional store that handles complex performance analytics.

Consider how urgently you need the data. Data that provides information for alerting must be accessed quickly, so you should store it in fast data storage and index or structure it to optimize alerting system queries. In some cases, the telemetry service that gathers the data on each node might need to format and save data locally so that a local instance of the alerting system can quickly notify you about problems. You can dispatch the same data to the storage-writing service that the previous diagrams show and store it centrally if you need it for other purposes.

Information that you use for more complex analysis, for reporting, and to identify historical trends is less urgent. Store it in a way that supports data mining and unplanned queries. For more information, see [Support hot, warm, and cold analysis](#support-hot-warm-and-cold-analysis).

#### Log rotation and data retention

Instrumentation generates a lot of data. In some cases, after the data is processed and transferred, you can remove the original raw source data from each node. Or you might need to save the raw information.

Performance data typically has a longer life so that you can use it to identify performance trends and plan capacity. Keep the consolidated view of this data online for a finite period so that you can access it quickly. You might need to save data gathered for metering and billing indefinitely. Also, regulatory requirements might require you to archive and save information collected for auditing and security purposes. Encrypt or otherwise protect this sensitive data to prevent tampering. Never record users' passwords or other personal information. Scrub these details from the data before you store it.

#### Data down-sampling

Store historical data to spot long-term trends. Rather than saving all old data, you can down-sample the data to reduce its resolution and save storage costs. As an example, rather than saving minute-by-minute performance indicators, you can consolidate data that's more than a month old to form an hour-by-hour view.

### Best practices for collecting and storing logging information

The following list summarizes best practices for capturing and storing logging information:

- The monitoring agent or data-collection service should run as an out-of-process service and be simple to deploy.

- All output from the monitoring agent or data-collection service should be an agnostic format that's independent of the machine, operating system, or network protocol. For example, emit information in a self-describing format such as JSON, MessagePack, or Protobuf rather than Event Trace Log (ETL) files on Linux or ETW. Use a standard format so that the system can construct processing pipelines. You can easily integrate components that read, transform, and send data in the agreed format.

- The monitoring and data-collection process must be fail-safe and must not trigger cascading errors.

- If a transient failure sends information to a data sink, the monitoring agent or data-collection service should be prepared to reorder telemetry data so that the newest information is sent first. The monitoring agent or data-collection service might elect to drop the older data or save it locally and transmit it later to catch up, at its own discretion.

## Analyze data and diagnose problems

An important part of monitoring and diagnostics is analyzing the gathered data to get a picture of the overall health of the system. Define your own KPIs and performance metrics, and learn how to structure the data to meet your analysis requirements. Understand how data captured in different metrics and log files correlates because this information is key to tracking a sequence of events and diagnosing problems.

The data for each part of the system is typically captured locally, but then you need to combine it with data generated at other sites that participate in the system. Correlate this information carefully to ensure that data is combined accurately. For example, the usage data for an operation might span the following nodes:

- A node that hosts a website that a user connects to
- A node that runs a separate service accessed as part of this operation
- A node that stores data storage

You need to tie this information together to provide an overall view of the resource and processing usage for the operation. The node that captures the data might preprocess and filter it, but central nodes typically aggregate and format the data. For more information, see [Consolidate instrumentation data](#consolidate-instrumentation-data).

### Support hot, warm, and cold analysis

Analyzing and reformatting data for visualization, reporting, and alerting purposes can be a complex process that consumes its own set of resources. Some forms of monitoring require immediate data analysis to be effective, also known as *hot analysis*. Examples include analysis for alerting and security monitoring. For hot analysis, make data available and structured for efficient processing. In some cases, you might need to move the analysis processing to the individual nodes that hold the data.

Other forms of analysis are less time-sensitive and might require computation and aggregation after the raw data is received. This method is called *warm analysis*. Performance analysis often falls into this category. In this case, a sudden spike or glitch might cause an isolated, single performance event that isn't statistically significant. The data from a series of events provides a more reliable picture of system performance.

You can also use warm analysis to help diagnose health problems. Use hot analysis to process a health event and raise an alert immediately. Then use warm analysis to analyze the data and find the cause of the health event.

Some types of monitoring generate more long-term data. You can perform this analysis at a later date, possibly according to a predefined schedule. In some cases, the analysis might need to filter large volumes of data captured over time. This method is called *cold analysis*. The key requirement is that you store the data safely after you capture it. For example, usage monitoring and auditing require an accurate picture of system state at regular intervals, but this state information doesn't have to be immediately available for processing.

You can also use cold analysis to provide the data for predictive health analysis. Gather historical information over a specified period and combine it with the current health data to see trends that might cause health problems. In these cases, you might need to raise an alert to correct the trend.

### Correlate data

The data that instrumentation captures can provide a snapshot of the system state, but the purpose of analysis is to make this data actionable. For example, you can determine the cause of intense I/O loading at the system level at a specific time and ensure that database response times, the number of transactions per second, and application response times at the same juncture confirm your findings.

One way to reduce the load is to shard the data over more servers. Exceptions can occur because of a fault at any level of the system. An exception at one level often triggers another fault at the level above it.

For these reasons, you need to correlate the different types of monitoring data at each level to produce an overall view of system state and the applications that run on it. Use this information to decide whether the system is functioning acceptably and determine what you can do to improve quality.

Ensure that the raw instrumentation data includes sufficient context and activity ID information to support the required aggregations for correlating events. This data might be held in different formats, so you might need to parse and convert it into a standardized format for analysis. For more information, see [Information for correlating data](#information-for-correlating-data).

### Troubleshoot and diagnose problems

To diagnose problems, you need to do RCA to determine the cause of faults or unexpected behavior. You typically need the following information for the entire system or for a specific subsystem during a specified time window:

- Detailed information from event logs and traces
- Complete stack traces from exceptions and faults of any specified level
- Crash dumps for any failed processes
- Activity logs that record the operations that all users or select users perform

To analyze data for troubleshooting purposes, you need a deep technical understanding of the system architecture and its components. You must interpret the data, establish the cause of problems, and recommend a strategy to correct them. Another strategy is to store a copy of this information in its original format and make it available for cold analysis by an expert.

## Visualize data and raise alerts

Monitoring systems must present data so that you can quickly identify trends or problems. They must also notify you immediately when an event that requires attention occurs.

Data presentation can take several forms, including visualization by using dashboards, alerting, and reporting.

### Visualization by using dashboards

The most common way to visualize data is to use dashboards that display information as a series of charts, graphs, or other illustrations. You can parameterize these items and select the important parameters, such as the time period, for a specific situation.

You can organize dashboards hierarchically. Top-level dashboards give an overall view of each aspect of the system and let you drill down to the details. For example, in a dashboard that depicts the overall disk I/O for the system, you can view the I/O rates for each individual disk to determine whether one or more specific devices account for a disproportionate volume of traffic. The dashboard should also display related information, such as the user or activity that generates this I/O. This information can help you spread the load more evenly across devices.

A dashboard might also use color-coding or other visual cues to indicate values that appear anomalous or that are outside an expected range. Consider the following color-coding examples:

- Red for a disk with an I/O rate approaching its maximum capacity over an extended period, or a hot disk

- Yellow for a disk with an I/O rate that periodically runs at its maximum limit over short periods, or a warm disk

- Green for a disk that exhibits normal usage

Dashboard systems must have the raw data to work effectively. If you build your own dashboard system or use a dashboard developed by another organization, you must understand which instrumentation data you need to collect, at what levels of granularity, and how to format it for the dashboard to consume.

An effective dashboard also lets you ask questions about information. Some systems provide management tools that you can use to perform these tasks and explore the underlying data. Depending on the repository that holds the information, you might be able to query data directly or import it into tools such as Excel for further analysis and reporting.

> [!NOTE]
> You should restrict access to dashboards to authorized personnel because this information might be commercially sensitive. You should also protect the underlying data for dashboards to prevent users from changing it.

### Raise alerts

Alerting analyzes the monitoring and instrumentation data and generates a notification if it detects a significant event.

Alerting helps ensure that the system remains healthy, responsive, and secure. It's an important part of any system that makes performance, availability, and privacy guarantees to users. Alerting can also notify you of events that trigger alerts. Use alerting to invoke system functions like autoscaling.

Alerting depends on the following instrumentation data:

- **Security events:** If the event logs indicate that repeated authentication or authorization failures occur. In this scenario, an alert should inform you that the system might be under attack.

- **Performance metrics:** The system must quickly respond if a performance metric exceeds a specified threshold.

- **Availability information:** If a fault is detected, you might need to quickly restart one or more subsystems or fail over to a backup resource. Repeated faults in a subsystem might indicate more serious problems.

You can receive alert information through many channels, such as email, a pager, or an SMS text message. An alert might also include an indication of how critical a situation is. Many alerting systems support subscriber groups, and all operators who are members of the same group receive the same set of alerts.

Make the alerting system customizable, and provide the appropriate values from the underlying instrumentation data as parameters. By using this approach, you can filter data for specific thresholds or combinations of values. In some cases, you can provide the raw instrumentation data to the alerting system. Or it might be more appropriate to supply aggregated data. For example, an alert triggers when the CPU utilization for a node exceeds 90% over the last 10 minutes. Provide the alerting system appropriate summary and context information to reduce the possibility that false-positive events trigger an alert.

### Reporting

Use reporting to generate an overall view of the system. It might incorporate historical data and current information. Reporting requirements fall into operational and security categories.

Operational reporting typically includes the following aspects for the overall system or specific subsystems during a specified time window:

- Aggregated statistics that you can use to understand resource utilization

- Trends in resource usage

- Exception monitoring

- Application efficiency in terms of the deployed resources and whether you can reduce the volume of resources without affecting performance

Security reporting tracks how customers use the system. It typically includes the following aspects:

- Audit user operations. Record individual requests that each user performs along with dates and times. Structure the data so that you can quickly reconstruct the sequence of operations that a user performs over a specified period.

- Track resource use for each user. Record how each request for a user accesses system resources and for how long. Use this data to generate a utilization report for each user over a specified period, possibly for billing purposes.

In many cases, batch processes can generate reports according to a defined schedule. Report generation typically doesn't increase latency, so you can generate reports on demand if needed. If you store data in a relational database such as Azure SQL Database, you can use a tool like SQL Server Reporting Services to extract and format data and present it as a set of reports.

## Next steps

- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- [Monitor, diagnose, and troubleshoot Storage](/troubleshoot/azure/azure-storage/blobs/alerts/storage-monitoring-diagnosing-troubleshooting)
- [Overview of alerts in Azure](/azure/azure-monitor/alerts/alerts-overview)
- [Overview of Application Insights](/azure/azure-monitor/app/app-insights-overview)
- [Performance diagnostics for Azure VMs](/azure/azure-monitor/vm/performance-diagnostics)

## Related resources

- [Autoscaling guidance](../best-practices/auto-scaling.md) describes how to decrease management overhead by reducing the need to continually monitor system performance and make decisions to add or remove resources.

- [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.yml) describes how to implement functional checks within an application that external tools can access through exposed endpoints at regular intervals.

- [Priority Queue pattern](../patterns/priority-queue.yml) describes how to prioritize queued messages so that systems receive and process urgent requests before less urgent messages.
