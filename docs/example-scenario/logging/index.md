---
title: title
titleSuffix: Azure Example Scenarios
description: description
author: lanallai
ms.date: 03/01/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
  - fcp
---

# Unified logging

In a traditional on-premises application, most applications are non-distributed, consisting of a single executable and relevant dependencies. The executable runs under a single process space on a single virtual machine (VM). For increased performance, the application can be horizontally scaled across multiple machines. For each instance, logging, tracing, and monitoring are bound to the single process domain.

Cloud-native development differs from on-premises methodology. Cloud-native applications consist of one or more PaaS services built around the [microservices]() architectural paradigm. Microservices entails the creation of discrete, loosely-coupled services that work within their process boundaries. This loosely distributed architecture has many benefits:

- Applications consist of discrete services that are easier to build and simpler to maintain.
- Microservices focus on business capabilities.
- Microservices naturally work well with automated continuous integration (CI) and continuous delivery (CD) systems.
- Microservices are more fault-tolerant to failures, so a single service failure won't bring down the application.
- Microservices can scale independently of each other and allow for better utilization and cost optimization.

Wherever an application fails, whether or not the failure is transient, teams need to know:

- Why did the application fail?
- When did the application exception occur?
- Which method caused the exception?
- What were the events recorded up to the point of application failure?
- Did this exception lead to potential data corruption?

Logging, tracing, and monitoring can provide the answers to these questions.

*Logging* is tracking and reporting related data in a centralized way. Log events can track code errors or application failures, or provide purely informational messages. Logging focuses on providing an overview of the state of an application execution by using discrete event messages. Automation can read event logs and notify relevant parties if a criterion or threshold is met.

*Tracing*, on the other hand, focuses on the continuous flow of the application. Tracing follows program execution through various methods and services from beginning to end, while understanding data state and transitions.

*Monitoring* can mean tracing or logging. Monitoring uses application instrumentation to provide metrics that operations teams can use to make informed decisions. These metrics can aggregate log or trace data in a dashboard that gives a holistic view of the application health, from utilization to error count.

For single-process applications that traditionally run on-premises, logging and tracing is a relatively straightforward process. The application and its dependencies are deployed together, logging and tracing within a single execution context. All relevant calls within the application happen within the same process boundary, and there's no need to cross application or process boundaries.

Logging and tracing for cloud-native distributed applications can be more complicated. Because a cloud-native application is distributed by design, a single request can interact with many microservices. Each microservice generates its own logging, and it becomes difficult to determine the process flow of execution. Teams tend to process each microservice log independently, and because microservices can handle hundreds of requests concurrently, wading through logs and manually determining event correlations can become a laborious task.

The following practices help a distributed architecture overcome the problems of logging in a cloud-native environment:

- All requests the application generates have a unique identifier, usually called a correlation ID, that they pass through each microservice. Each microservice accepts the correlation ID as part of the request, and all logs emitted by the microservice contain the correlation ID.
- When the application processes the request, it returns the correlation ID as part of the response. The application then uses the correlation ID when emitting its own logs.
- All logs, except audit logs, are emitted to a single hub and stored in a central repository. If audit logs are required for security or compliance, it's best to store them in a separate data store.
- Log data uses JSON format.
- Logging is done in an asynchronous manner. By performing logging asynchronously, it helps to reduce the overhead of the operation by delegating the call to a background task. The application does not need to await the results of the operation and thus is able to continue logical program flow. Logging frameworks should always be used first and foremost, engineering effort shouldn't always be expended in creating a logging system unless there is a clear business need. [Serilog](https://github.com/serilog) is one of the most popular open source logging frameworks, and provides considerable support for the Azure ecosystem through the use of community supported extensions.

Consideration should also be taken to ensure the common [logging levels](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.loglevel?view=dotnet-plat-ext-3.1) are being used appropriately once the application has been deployed, as well as during development.

- Trace
  - This is the most finest of detail and as such should never be used in a Pre Production or Production Environment 
  - Log data can contain sensitive application state.
  - The most verbose of log levels and can affect application performance.
  - The Trace level outputs very detailed data of the application state during program execution. As such, this should only be enabled sparingly and locally during development time.
- Debug
  - The Debug Logging level is most used during software development and used when debugging code and should be used when developing locally and tends to have no long term value.
- Info
  - This logging level is generally used in production which describes the general application flow when users are interacting with the system.
- Warn
  - A logging level that is used in production that should be used when an event could be potentially problematic. This allows automated alerting tools to pick up Warn events and notify the relevant teams to begin investigation.
- Error
  - This level should be used to log errors within the application, this could be logic errors, and, should be used in production.
- Critical/Fatal
  - This level should be used when an application event occurs when it is unable to fulfil the request and has resulted in an unrecoverable error.

Most applications are created to meet the demand, or, potential demand of the user. As such, application traffic is somewhat variable and to that end, so are the logs that are generated. 

Application Development is a continuous process and at times, features and updates are released continuously. 

For applications that do not generate high volumes of traffic, which could be harder to diagnose issues, a process such as Synthetic Logging can be leveraged.

Synthetic Logging is the process of leveraging the monitoring systems of the application by emulating the behaviour of the user using automation tools. 

Using an automation tool such as [Selenium](https://docs.microsoft.com/en-us/azure/devops/pipelines/test/continuous-test-selenium?view=azure-devops) the development team can create a test suite of user interactions. 

For microservices and API First Services, [Apache JMeter](https://jmeter.apache.org/) can be utilised to test the functional behaviour of a service, as well as understand the performance curve continued loading. 

For testing and development [Postman](https://www.postman.com/), can be leveraged to test API's locally and through integration with the CI/CD pipeline provide a way to automate API testing. 

These tests can be scheduled, or run on an ad hoc basis. This allows for the continued monitoring of availability; response time and functionality. 

Synthetic logging is a valuable tool as it helps the Development and Operations Team to identify problems and through the analysis of the provided telemetry data ascertain whether the application is running slow, or experiencing other issues.

Synthetic transactions can be used to simulate behaviour in your application. Synthetic transactions should be leveraged to augment established traffic patterns, as well as critical application processes are behaving as expected. Synthetic transactions when used appropriately can to ensure that the non functional requirements of availability; performance and resilience are met.

Another key aspect that should be considered when logging, is the structure of the log itself. Log data is essentially unstructured data, due to the unstructured nature, it can be hard to query for specific events; implement automated alerting when an event condition occurs and correlate related events. 

For event data to be readable by automated systems, a structured format should be leveraged so that an event can be more easily passed. JSON is the current data interchange format used by most web services today, as such it has a well known schema and is well suited for structured logging.

When defining the structure of the log, context should be added to every request, and these objects can be:
- Correlation ID for the request
  - The ID can be used to chain related log events together and provide a narrative for event and help establish where issues occur when dealing with distributed systems. This should be a globally unique value.
- Date & Time in UTC
- Service name
- HTTP Codes
- Browser Type
- Severity of Event
- Pertinent information from the request type that can be used to help diagnose problems

<pre>

```json
{
  "CorrelationId": "715eec8f-fefc-45e2-a352-95aa389ddb8f"
  "Environment": "Live",
  "StatusCode: 500,
  "Severity: "Error",
  "Application": "Contso Web Shop",
  "Service": "PaymentsService",
  "EventTimeUTC:" "2020-04-27T13:19Z",
  "BrowserType": "Chromium",
  "Data":{
      "Runtime":"Net Core",
      "Message": "System.NullReferenceException: Object reference not set to an instance of an object.",
      "Method": "PaymentProcesser"
  } 
}
```

</pre>

With structured logging, it becomes easier to search through logs when issues occur as well as allow automated alerting to action on the severity of the message.

Care must be taken to ensure the recorded information does not contain PII data and meets any regulatory guidelines such as GDPR.

By incorporating the above changes to the distributed application, it now allows for any member of a team to retrieve logs from the complete lifecycle of the request through the correlation ID.

All logs should be stored in long term storage; this allows for analysis and diagnosis of issues and also allows the team to determine if there have been changes to system behaviour over time.

## Azure Services

Azure provides rich services to implement an effective Logging/Tracing and Monitoring Strategy.

### Event Hub

[Azure Event Hub](https://azure.microsoft.com/services/event-hubs/) is a fully managed, real-time ingestion service that is able to stream large volumes of events per second. As such, Event Hubs is the perfect candidate for a central log ingestion pipeline.

Event hub can be configured to send all event message to Azure Data Lake, or, Azure Blob Storage for long term archival for analysis.

### Azure Blob Storage

[Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) is a cloud scalable storage layer for storing unstructured object data. This data can be either text or binary. Event hub can be configured to store events as Avro files within Blob Storage. Azure Log Analytics can then be used to query the log data for insights.

### Data Lake

[Azure Data Lake](https://azure.microsoft.com/services/storage/data-lake-storage/) is a cloud scalable storage repository that can be used to store data in any format and for long periods of time. Developers can then query the objects stored within the Data Lake for investigational purposes. 

### Stream Analytics

[Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) is a real-time, serverless analytics engine designed for critical machine workloads. Stream analytics can be leveraged to process event messages if critical indicators are met.

### Logic Apps

[Azure Logic Apps](https://docs.microsoft.com/azure/logic-apps/logic-apps-overview) is a serverless cloud service that allows developers to schedule, orchestrate common tasks through a series of workflows via a visual designer. The power of logic apps is through the connectors that be used to integrate with a number of first and third party services in a low/no-code way.

For example, Stream Analytics Jobs can be used to trigger a Logic App workflow. The workflow can incorporate notification elements, to notify the development team as well as the ability to call RESTful APIs.

### Application Insights

[Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview) is an extensible Application Performance Management service for Developers and the DevOps team. Application Insights can be used to monitor live services, detect anomalies in performance and analytics tools to diagnose and trace problems and query log data as well as diagnose issues using telemetry from Application Insights [within Visual Studio](https://docs.microsoft.com/azure/azure-monitor/app/visual-studio).

Application Insights can be leveraged for [distributed tracing](https://docs.microsoft.com/azure/azure-monitor/app/distributed-tracing) through the use of the SDK.

### Azure Monitor

[Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/overview) is a service that maximizes the availability and performance of cloud-native applications. Collecting, analyzing and acting on telemetry from cloud-native applications. With Azure Monitor, teams can create operational dashboards and detect issues and the ability to Alert Teams of critical situations.

If the team leverages an IT Service Management (ITSM) system, Logic Apps can be used to call the REST endpoint of the ITSM system and create the relevant issue with the appropriate severity level. See [Stream Analytics and Azure Logic Apps](https://docs.microsoft.com/archive/blogs/vinaysin/consuming-azure-stream-analytics-output-in-azure-logic-apps) for further information. This allows for quicker notification to all relevant teams and ensures that triaging is more immediate and useful.

When building a cloud-native distributed microservices architecture, teams are able to leverage these Azure Services and build an effecting Logging, Tracing, and Monitoring Solution. The development team is able to view near real-time metrics through Application Insights and gain insight into application health. For long term storage the events can either be stored in Azure Blob Store, or Azure Data Lake. Log Analytics can then be used to 

The diagram below depicts an architecture in which the above services are leverages to build a logging and monitoring system. Application Events are emitted from both the API and the UI to Application Insights as well as Azure Event Hub.

![](Paas_Tracing_Logg.png)

For architectures that leverage Azure Virtual Machines, the following architecture includes Azure Monitor. Azure Monitor for VMs monitors the performance and health of the Virtual Machines that are used to run the application.
![](Iaas_Tracing_Logg.png)

Once an application has been deployed, the focus moves to ensure that cloud-native applications are highly reliable, scalable, redundant, resiliency and security.

## Security

From a security perspective, great work is invested in ensuring that the application is built as securely as possible using modern working methods and practices. However, cloud-native applications are not immune to security issues. Cloud-native applications are a target of attack from rogue agents as much as traditional on-premise systems.

[Azure Sentinel](https://azure.microsoft.com/services/azure-sentinel/) is a Security Information and Event Management (SIEM) tool. Sentinel provides a unified overview of the cloud estate, in which information is provided through the native integration of Azure Services. Not only is Sentinel able to collect information from the cloud, but it can also collect information from downstream dependant systems hosted within a customer's data center.

Azure Sentinel provides a dashboard view of the current security posture and allows administrators a global view on potentially malicious events such as failed logins (suspicious credentials) and the relevant connections from these events. SRE teams can leverage Azure Log Analytics to perform further analysis.

By creating a unified logging strategy, development and operations teams can gain deep and unified insight from within the application through application logging as well as gain insights from outside of the application domain through Azure Sentinel.
