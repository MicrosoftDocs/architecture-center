---
title: Data sources for diagnostic data
description: Start by evaluating the data sources from which you need to capture monitoring data. 
author: PageWriter-MSFT
ms.date: 11/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure
categories:
  - management-and-governance
  - security
ms.custom:
  - article
---

# Data sources for diagnostic data

The information that the monitoring process uses can come from several sources: application code, frameworks, external sources with which the application communicates, and the underlying infrastructure. 

This article highlights some best practices of those sources and provides guidance on the types of  information that you should capture. 

## Application code

Developers add trace messages in the application code to track the flow of control. Here are some best practices:

- **Follow a standard approach**&mdash;For example, recording the entry and exit times can be useful. An entry to a method in the application can emit a trace message that specifies the name of the method, the current time, the value of each parameter, and any other pertinent information.

- **Log all exceptions and warnings**&mdash;Retain a full trace of any nested exceptions and warnings. Ideally, you should also capture information that identifies the user who is running the code, together with activity correlation information (to track requests as they pass through the system).

- **Log attempts to access all dependent resources**&mdash;An application will communicate with services such as message queues, databases, files, and other dependent services. This information can be used for metering and auditing purposes.

- **Capture information that identifies the user who is running the code**&mdash;This information with activity correlation information is useful in tracking requests as they pass through the system.


## Application frameworks

Many applications use libraries and frameworks to perform common tasks such as accessing a data store or communicating over a network. Consider configuring the frameworks to emit trace messages. These frameworks might be configurable to provide their own trace messages and raw diagnostic information, such as transaction rates and data transmission successes and failures.

> [!NOTE]
> Many modern frameworks automatically publish performance and trace events. Capturing this information is simply a matter of providing a means to retrieve and store it where it can be processed and analyzed.

## Dependent services 

The application will access external services such as a web server or database management system to complete business operations. Even a single business operation can result in multiple point-to-point calls among all services. The services might publish their own trace information, logs, and performance counters. Examples include SQL Server Dynamic Management Views for tracking operations performed against a SQL Server database, and IIS trace logs for recording requests made to a web server.


## Operating system

Another important source is the operating system where the application runs. It can be a source of low-level system-wide information, such as performance counters that indicate I/O rates, memory utilization, and CPU usage. Operating system errors such as the failure to open a file correctly might also be reported.

## Infrastructure metrics

> [!NOTE]
> As a workload owner, you may not be monitoring infrastructure metrics actively. However, this information can indicate systemic issues. Consider the underlying infrastructure and components on which your system runs. Virtual machines, virtual networks, and storage services can all be sources of important infrastructure-level performance counters and other diagnostic data.
>

- **Compute monitoring**&mdash;Collect metrics from  compute resources on which the application is running. This might be virtual machines, App Services, or Kubernetes. Knowing the state of your infrastructure will allow to react promptly if there are any issues.

- **Data tier monitoring**&mdash;Include metrics the databases, storage accounts, and other data sources that interact with the application. A low performance of the data tier of an application could have serious consequences.

- **Container monitoring**&mdash;If your application run on Azure Kubernetes Service (AKS), you will need to monitor the state of your cluster, nodes, and pods. One option is to the [container insights](/azure/azure-monitor/containers/container-insights-overview) feature in Azure Monitor. This feature delivers quick, visual, and actionable information: from the CPU and memory pressure of your nodes to the logs of individual Kubernetes pods.

  Operators who prefer using the open-source Kubernetes monitoring tool Prometheus can take advantage of its integration with container insights.

  :::image type="icon" source="../../_images/github.png" border="false"::: The [Sidecar Pattern](https://github.com/mspnp/samples/blob/master/OperationalExcellence/Patterns/SidecarPattern/Sidecar-pattern.md) adds a separate container with responsibilities that are required by the main container. A common use case is for running logging utilities and monitoring agents.

- **Network monitoring**&mdash;Networking is key to an application running without issues. Consider using [Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview), a collection of network monitoring and troubleshooting tools. Some of these tools are:

  - [Traffic Analytics](/azure/network-watcher/traffic-analytics) shows the flows the virtual networks and uses Microsoft Threat Intelligence databases to give you percentage traffic from malicious IP addresses. You can identify identify bottlenecks by seeing the systems in your virtual networks that generate most traffic.
  - [Network Performance Monitor](/azure/azure-monitor/insights/network-performance-monitor) can generate synthetic traffic to measure the performance of network connections over multiple links, giving you a perspective on the evolution of WAN and Internet connections over time, as well as offering valuable monitoring information about Microsoft ExpressRoute circuits.
  - [VPN diagnostics](/azure/network-watcher/network-watcher-monitor-with-azure-automation) can help troubleshooting site-to-site VPN connections connecting your applications to users on-premises.

## Release pipeline

As the components of a system are modified and new versions are deployed, it's important to be able to attribute issues, events, and metrics to each version. 

- **Relate information about issues, events, and others to the release pipeline**&mdash;Problems with a specific version of a component can be tracked quickly and rectified.

- **Log security-related information for successful and failing requests**&mdash;Security issues might occur at any point in the system. For example, a user might attempt to sign in with an invalid user ID or password. An authenticated user might try to obtain unauthorized access to a resource. Or a user might provide an invalid or outdated key to access encrypted information. 

## Sources from application and system monitoring

This strategy uses internal sources within the application, application frameworks, operating system, and infrastructure. The application code can generate its own monitoring data at notable points during the lifecycle of a client request. The application can include tracing statements that might be selectively enabled or disabled as circumstances dictate. It might also be possible to inject diagnostics dynamically by using a diagnostics framework. These frameworks typically provide plug-ins that can attach to various instrumentation points in your code and capture trace data at these points.

Additionally, your code and/or the underlying infrastructure might raise events at critical points. Monitoring agents that are configured to listen for these events can record the event information.

## Real user monitoring 

This approach records the interactions between a user and the application and observes the flow of each request and response. This information can have a two-fold purpose: it can be used for metering usage by each user, and it can be used to determine whether users are receiving a suitable quality of service (for example, fast response times, low latency, and minimal errors). You can use the captured data to identify areas of concern where failures occur most often. You can also use the data to identify elements where the system slows down, possibly due to hotspots in the application or some other form of bottleneck. If you implement this approach carefully, it might be possible to reconstruct users' flows through the application for debugging and testing purposes.

> [!IMPORTANT]
> You should consider the data that's captured by monitoring real users to be highly sensitive because it might include confidential material. If you save captured data, store it securely. If you want to use the data for performance monitoring or debugging purposes, strip out all personally identifiable information first.

## Synthetic user monitoring 

In this approach, you write your own test client that simulates a user and performs a configurable but typical series of operations. You can track the performance of the test client to help determine the state of the system. You can also use multiple instances of the test client as part of a load-testing operation to establish how the system responds under stress, and what sort of monitoring output is generated under these conditions.

> [!NOTE]
> You can implement real and synthetic user monitoring by including code that traces and times the execution of method calls and other critical parts of an application.

## Application profiling

This approach is primarily targeted at monitoring and improving application performance. Rather than operating at the functional level of real and synthetic user monitoring, it captures lower-level information as the application runs. You can implement profiling by using periodic sampling of the execution state of an application (determining which piece of code that the application is running at a given point in time). You can also use instrumentation that inserts probes into the code at important junctures (such as the start and end of a method call) and records which methods were invoked, at what time, and how long each call took. You can then analyze this data to determine which parts of the application might cause performance problems.

## Endpoint monitoring

This technique uses one or more diagnostic endpoints that the application exposes specifically to enable monitoring. An endpoint provides a pathway into the application code and can return information about the health of the system. Different endpoints can focus on various aspects of the functionality. You can write your own diagnostics client that sends periodic requests to these endpoints and assimilate the responses. For more information, see the Health Endpoint Monitoring pattern.

For maximum coverage, you should use a combination of these techniques.


## Next steps

> [!div class="nextstepaction"]
> [Instrumentation](monitor-instrument.md)

