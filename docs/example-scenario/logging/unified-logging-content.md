This solution provides logging, tracing, and monitoring for microservices apps. It shows you how to run synthetic logging for testing and how to create structured logs for analysis.

## Architecture

:::image type="content" border="false" source="./media/paas-tracing-logging.svg" alt-text="Diagram of Azure architecture for PaaS microservices applications." lightbox="./media/paas-tracing-logging.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/unified-logging-for-microservices.vsdx) of this architecture.*

### Workflow

The architecture uses Azure services to build a unified logging and monitoring system:

1. The application emits events from both the API and the user interface to Event Hubs and Application Insights.
1. Application Insights queries short-term logging, tracing, and monitoring data.
1. Stream Analytics jobs can use the Event Hubs data to trigger Logic Apps workflows.
1. A Logic Apps job calls the representational state transfer (REST) endpoint of an Information Technology Service Management (ITSM) system, and sends notifications to the development team.
1. Microsoft Sentinel automation uses Playbooks powered by Azure Logic Apps to generate security alerts.
1. Keeping event logs in long-term storage allows later analysis and diagnostics with Log Analytics.

For applications that use Azure VMs, the following infrastructure-as-a-service (IaaS) architecture includes Azure Monitor to monitor the performance and health of the VMs that run the application.

:::image type="content" border="false" source="./media/iaas-tracing-logging.svg" alt-text="Diagram of Azure architecture for IaaS applications that use VMs." lightbox="./media/iaas-tracing-logging.svg":::

### Components

When building a cloud-native distributed microservices architecture, teams can use the following Azure services to build an effective logging, tracing, and monitoring solution. Teams can view near real-time metrics and gain insight into application health through Application Insights.

#### Event Hubs

[Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) is a fully managed, real-time ingestion service that can stream large volumes of events per second. As such, Event Hubs is the perfect candidate for a central log ingestion pipeline. Event Hubs can send event messages to Azure Data Lake or Azure Blob Storage to use for later analysis.

#### Blob Storage

[Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) is a cloud scalable storage layer for storing unstructured text or binary object data. Event Hubs can store events as Avro files within Blob Storage. Azure [Log Analytics](/azure/azure-monitor/log-query/log-query-overview) can then query the log data for insights.

#### Azure Data Lake Storage

[Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) is built on Azure Blob Storage. Data Lake Storage is a cloud scalable storage repository that can store data in any format for long periods of time. Developers can then query the objects stored within the Data Lake for investigation.

#### Azure Stream Analytics

[Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) is a real-time, serverless analytics engine designed for critical machine workloads. Stream Analytics can process event messages that meet critical indicators.

#### Logic Apps

[Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) is a serverless cloud service that lets developers schedule and orchestrate common task workflows with a visual designer. The power of Logic Apps is the connectors that integrate with a number of first and third-party services with little or no code.

#### Azure Monitor

[Azure Monitor](/azure/azure-monitor/overview) is a service that maximizes availability and performance by collecting, analyzing, and acting on telemetry from cloud-native applications. With Azure Monitor, teams can create operational dashboards that detect issues and alert teams of critical situations.

If the team uses an ITSM system, Logic Apps can call the REST endpoint of the system and create an issue with the appropriate severity level. This process provides quick notification to all relevant teams and ensures that triaging is immediate and useful. For more information, see [Stream Analytics and Azure Logic Apps](/archive/blogs/vinaysin/consuming-azure-stream-analytics-output-in-azure-logic-apps).

#### Application Insights

[Application Insights](/azure/azure-monitor/app/app-insights-overview), a feature of Azure Monitor, is an extensible Application Performance Management (APM) service for developers and DevOps teams. Application Insights can monitor live services, detect anomalies in performance and analytics tools, diagnose and trace problems, and query log data. You can use Application Insights to do [distributed tracing](/azure/azure-monitor/app/distributed-tracing-telemetry-correlation) through the Application Insights SDK. You can also use Application Insights from [within Visual Studio](/azure/azure-monitor/app/visual-studio).

#### Microsoft Sentinel

[Microsoft Sentinel](https://azure.microsoft.com/services/azure-sentinel) is a Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) service. Sentinel provides a unified overview of the cloud estate through native integration of Azure services. Sentinel can collect information from the cloud as well as from downstream dependent systems in customers' data centers.

Microsoft Sentinel provides a dashboard view of the current security posture and allows administrators a global view on potentially malicious events such as failed logins, suspicious credentials, and the relevant connections from these events. Site reliability engineering (SRE) teams can use [Log Analytics](/azure/azure-monitor/log-query/log-query-overview) to query the data. You can also designate automation to trigger when Sentinel rules generate security alerts. Automation in Microsoft Sentinel uses Playbooks powered by Azure Logic Apps. For more information, see [Tutorial: Investigate incidents with Microsoft Sentinel](/azure/sentinel/tutorial-investigate-cases).

## Scenario details

*Logging* uses discrete event messages to track and report application data in a centralized way. Log events provide an overview of application execution state, track code errors or application failures, and deliver informational messages. Automation can read event logs and notify relevant parties if events meet a criterion or threshold.

*Tracing* focuses on the continuous flow of an application. Tracing follows program execution through various methods and services from beginning to end, while understanding data state and transitions.

*Monitoring* applies application instrumentation to both tracing or logging data to provide metrics that teams can use to make informed decisions. These metrics can aggregate log or trace data in a dashboard that gives a holistic view of application health, from utilization to error count.

Whenever an application fails, teams need to know:

- Why did the application fail?
- When did the application exception occur?
- Which method caused the exception?
- What were the events recorded up to the point of application failure?
- Did this exception lead to potential data corruption?

Logging, tracing, and monitoring can provide the answers to these questions, as well as monitor application usage and performance.

For traditional on-premises or monolithic applications, logging, tracing, and monitoring happen within a single process domain. The application consists of a single executable and its dependencies. The executable runs under the single process space on a single virtual machine (VM), or across multiple VMs to increase performance.

Cloud-native development differs from on-premises methodology. Many cloud-native applications consist of platform-as-a-service (PaaS) services built around the [microservices](../../microservices/index.yml) architectural paradigm. Microservices architectures involve discrete, loosely coupled services that work within their own process boundaries. Microservices architectures:

- Consist of discrete services that are easier to build and simpler to maintain.
- Focus on business capabilities.
- Work well with automated continuous integration (CI) and continuous delivery (CD) systems.
- Are more fault-tolerant, because a single service failure doesn't bring down the application.
- Allow services to scale independently of each other to provide better utilization and cost optimization.

Logging and tracing for cloud-native distributed applications can be complicated. A single application request can interact with many microservices. Each microservice generates its own logging, and determining the application execution process flow can be difficult. Because microservices can handle hundreds of requests concurrently, wading through logs to manually determine event correlations can be a laborious task.

Several Azure services and strategies can help automate and manage effective logging, tracing, and monitoring for microservices applications. With unified logging, development and operations teams can gain deep insights from within as well as from outside application domains. Unified logging and monitoring help ensure that deployed cloud-native applications remain reliable, scalable, redundant, resilient, and secure.

## Recommendations

The following practices help microservices architectures perform unified logging in a cloud-native environment:

- All application-generated requests should have a unique identifier, usually called a correlation ID, that they pass through each microservice. Each microservice accepts the correlation ID as part of the request, and all logs emitted by the microservice contain the correlation ID.
- When the application processes the request, it returns the correlation ID as part of the response. The application then uses the correlation ID when emitting its own logs.
- All logs, except audit logs, should be emitted to the same hub and stored in a central repository. If audit logs are required for security or compliance, it's best to store them in a separate data store. Make sure that recorded and stored information meets regulatory guidelines and doesn't contain any personal data.
- Log data should use JSON format.
- Logging should be asynchronous. Asynchronous logging helps to reduce overhead by delegating the call to a background task. The application doesn't need to await the results of the operation and can continue the logical program flow.
- Logging should use a logging framework if possible. Don't expend engineering effort creating a logging system unless there's a clear business need. [Serilog](https://github.com/serilog) is a popular open-source logging framework that provides support for the Azure ecosystem through community supported extensions.

### Logging levels

During application development and after deployment, make sure to use the common [logging levels](/dotnet/api/microsoft.extensions.logging.loglevel) appropriately:

- **Trace** is the most detailed and most verbose log level. The Trace level outputs detailed, possibly sensitive data about application state during program execution. Tracing can affect application performance, so don't use it in pre-production or production environments. Enable this level sparingly and locally, and only during development.
- **Debug** is for debugging code locally during software development. This level tends to have no long-term value.
- **Information** level describes the general application flow when users are interacting with the system in production.
- **Warning** level in production indicates that an event could be potentially problematic. Warn tells automated alerting tools to pick up the event and notify the relevant teams to investigate.
- **Error** level in production logs errors within the application, which could be logic errors.
- **Critical/Fatal** level means the application is unable to fulfill the request and has caused an unrecoverable error.

### Synthetic logging

Most application traffic is variable, and so are the generated logs. Applications that don't generate high traffic may not generate enough logs to test and diagnose issues. Synthetic logging uses automation to emulate user behavior and generate logs for the application's monitoring systems.

Using an automation tool like [Selenium](/azure/devops/pipelines/test/continuous-test-selenium), developers can create a test suite of user interactions. Microservices and API-first services can use [Apache JMeter](https://jmeter.apache.org/) to test the functional behavior of a service and understand performance.

For testing and development, [Postman](https://www.postman.com/) can test APIs locally and integrate with the CI/CD pipeline to automate API testing.

Synthetic transactions can simulate user behavior in your application or augment established traffic patterns. Tests can run scheduled or ad hoc.

Synthetic logging is a valuable tool for identifying problems and analyzing telemetry data. Synthetic logging helps development and operations teams ascertain that critical application processes are behaving as expected, and can also ensure that apps meet the non-functional requirements of availability, performance, response time, and resiliency.

### Structured logging

A key aspect of logging is the structure of the log itself. Log data is essentially unstructured, so it can be hard to query for specific events, implement automated alerting, or correlate related events.

A structured format makes event data readable and able to be parsed by automated systems. JSON is the data interchange format used by most web services today, and its familiar schema is well suited for structured logging.

When defining log structure, you can add context to every request with the following objects:

- Correlation ID for the request. The ID chains related log events together to provide a narrative for events and help establish where issues occur in distributed systems. The correlation ID should be a globally unique value.
- Date and time in UTC
- Service name
- HTTP status codes
- Browser type
- Event severity
- Pertinent information from the request type that can be used to help diagnose problems

The following code shows examples of the structured logging objects:

```json
{
  "CorrelationId": "715eec8f-fefc-45e2-a352-95aa389ddb8f",
  "Environment": "Live",
  "StatusCode": 500,
  "Severity": "Error",
  "Application": "Contso Web Shop",
  "Service": "PaymentsService",
  "EventTimeUTC": "2020-04-27T13:19Z",
  "BrowserType": "Chromium",
  "Data":{
      "Runtime":"Net Core",
      "Message": "System.NullReferenceException: Object reference not set to an instance of an object.",
      "Method": "PaymentProcesser"
  } 
}
```

Incorporating the preceding changes into a distributed application allows team members to retrieve logs from the complete lifecycle of the request by using the correlation ID. Structured logging makes it easier to search through logs when issues occur, as well as allowing automated alerting.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Lavan Nallainathan](https://www.linkedin.com/in/lavan-nallainathan-8771b05b/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Spring Apps reference architecture](/azure/spring-cloud/reference-architecture)
- [Training: Introduction to Event Hubs](/training/modules/intro-to-event-hubs)
- [Azure Event Hubs](/azure/event-hubs/event-hubs-about)
- [Application Insights overview](/azure/azure-monitor/app/app-insights-overview)
- [What is Microsoft Sentinel?](/azure/sentinel/overview)

## Related resources

- [Building microservices on Azure](../../microservices/index.yml)
- [Microservices architecture on Azure Service Fabric](../../reference-architectures/microservices/service-fabric.yml)
