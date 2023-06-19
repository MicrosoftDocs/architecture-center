This article describes a distributed system that uses Azure Functions, Azure Event Hubs, and Azure Service Bus. It provides details about how to monitor the end-to-end system by using [OpenCensus for Python](https://github.com/census-instrumentation/opencensus-python) and Application Insights. This article also introduces distributed tracing and explains how it works by using Python code examples. The fictional company, Contoso, is used in the architecture to help describe the scenario.

> [!NOTE]
> OpenCensus and OpenTelemetry are merging, but OpenCensus is still the recommended approach to monitor Azure Functions. OpenTelemetry for Azure is in preview and [some features aren't available yet](/azure/azure-monitor/faq#what-s-the-current-release-state-of-features-within-the-azure-monitor-opentelemetry-distro-).

## Architecture

:::image type="content" source="images/monitor-with-opencensus-application-insights.png" alt-text="Diagram that shows the implemented architecture divided into three steps: query, process, and upsert." lightbox="images/monitor-with-opencensus-application-insights.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/monitor-with-opencensus-application-insights.vsdx) of this architecture.*

## Workflow

1) **Query.** A timer-triggered Azure function queries the Contoso internal API to get the latest sales data once a day. The function uses the [Azure Event Hubs output binding](/azure/azure-functions/functions-bindings-event-hubs-output?tabs=in-process%2Cfunctionsv2%2Cextensionv5&pivots=programming-language-python) to send the unstructured data as events.

1) **Process.** Event Hubs triggers an Azure function that processes and formats the unstructured data to a pre-defined structure. The function publishes one message to Service Bus per asset that needs to be imported by using the [Service Bus output binding](/azure/azure-functions/functions-bindings-service-bus-output?tabs=in-process%2Cextensionv5&pivots=programming-language-python).

1) **Upsert.** Service Bus triggers an Azure function that consumes messages from the queue and launches an upsert operation in the common company storage.

It's important to consider potential operation failures of this architecture. Some examples include:

- The internal API is unavailable, which leads to an exception that's raised by the query data Azure function in step one of the architecture.
- In step two, the process data Azure function, encounters data that falls under an edge-case, which is data that's outside of the conditions or parameters of the function.
- In step three, the upsert data Azure function fails. After several retries, the messages from the Service Bus queue go in the [dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues), which is a secondary queue that holds messages that can't be processed or delivered to a receiver after a pre-defined number of retries. Then the messages can follow an established automatic process, or they can be handled manually.

## Components

- [Azure Functions](/azure/azure-functions) is a serverless service that manages your applications.
- [Application Insights](/azure/azure-monitor/app/app-insights-overview?tabs=net) is a feature of Azure Monitor that monitors applications in development, test, and production. Application Insights analyzes how an application performs, and it reviews application execution data to determine the cause of an incident.
- [Azure Table Storage](/azure/storage/tables/table-storage-overview) is a service that stores non-relational structured data (structured NoSQL data) in the cloud and provides a key/attribute store with a schemaless design.
- [Event Hubs](/azure/event-hubs/event-hubs-about) is a scalable event ingestion service that can receive and process millions of events per second.
- [OpenCensus](https://opencensus.io/quickstart/) is a set of open-source libraries where you can collect distributed traces, metrics, and logging telemetry. This article uses the Python implementation of OpenCensus.
- [Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) is a fully-managed message broker with message queues and publish-subscribe topics.

## Scenario details

Distributed systems are made of loosely coupled components. It can be difficult to understand how the components communicate and to fully perceive the end-to-end journey of a user request. This architecture helps you see how components are connected.

Like many companies, Contoso needs to ingest on-premises or third-party data in the cloud while also collecting data about their sales by using services and in-house tools. In this architecture, a department at Contoso built an internal API that exposes the unstructured data, and they ingest the data into common storage. The common storage contains structured data from every department. The architecture shows how Contoso extracts, processes, and ingests that metadata in the cloud.

When building a system, especially a distributed system, it's important to make it observable. An observable system:

- Provides a holistic view of the health of the distributed application.
- Measures the operational performance of the system.
- Identifies and diagnoses failures so you can quickly resolve an issue.

## Distributed tracing

In this architecture, the system is a chain of microservices. Each microservice can fail independently for various reasons. When that happens, it's important to understand what happened so you can troubleshoot. It’s helpful to isolate an end-to-end transaction and follow the journey through the app stack, which consists of different services or microservices. This method is called distributed tracing.

The following sections show you how to set up distributed tracing in Contoso’s architecture. Select the following Deploy to Azure button to deploy the infrastructure and the Azure function app.
> [!NOTE]
> There isn't an internal API in the architecture, so a read of an Azure file replaces the call to an API.

 [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://github.com/Azure/observable-python-azure-functions/tree/initial-branch-code)

### Traces and spans

A transaction is represented by a trace, which is a collection of [spans](https://opencensus.io/tracing/span/#span). For example, when you select the purchase button to place an order on an e-commerce website, several subsequent operations take place. Some possible operations include:

- A POST request submits to the API which then redirects you to a “waiting page”.
- Writing logs with contextual information.
- An external call to a SaaS to request a billing page.

Each of these operations can be part of a span. The trace is a complete description of what happens when you select the purchase button.

Similarly, in this architecture, when the query data Azure function triggers to start the daily ingestion of the sales data, a trace is created that contains multiple spans:

- A span to confirm the trigger details.
- A span to query the internal API.  
- A span to create and send an event to Event Hubs.

A span can have children spans. For example, the following image shows the query data Azure function as a trace:

:::image type="content" source="images/trace-example.png" alt-text="An image that shows a complete trace composed of spans and their child spans." lightbox="images/trace-example.png":::

- The sendMessages span is split into two children spans: splitToMessages and writeToEventHubs. The sendMessages span requires those two sub-operations to send messages.

- All spans are children of a root span.

- In the previous image, spans give you an easy way to describe all parts involved in the query step of the query data Azure function. Each Azure function is a trace. So an end-to-end pass through Contoso’s ingestion system is the union of three traces, which are the three Azure functions. When you combine the three traces and their telemetry, you build the end-to-end journey and describe all parts of the architecture.

### Tracers and the W3C trace context

A tracer is an object that holds contextual information. Ideally, that contextual information propagates as data transits through the Azure functions. To do this, the OpenCensus extension uses [the W3C trace context](https://www.w3.org/TR/trace-context).

As its official documentation states, the W3C trace context is a “specification that defines standard HTTP headers and a value format to propagate context information that enables distributed tracing scenarios.”

A component of the system, such as a function, can create a tracer with the context of the previous component that's making the call by reading the traceparent. The format of a trace is:

Traceparent: [*version*]-[*traceId*]-[*parentId*]-[*traceFlags*]

For instance, if traceparent = 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-00

base16(version) = 00

base16(traceId) = 0af7651916cd43dd8448eb211c80319c

base16(parentId) = b7ad6b7169203331

base16(traceFlags) = 00

The traceId and parentId are the most important fields. The traceId is a globally unique identifier of a trace. The parentId is a globally unique identifier of a span. That span is part of the trace that the traceId identifies.

For more information, see [Traceparent header](https://www.w3.org/TR/trace-context/#traceparent-header).

In what follows, base16(version) and base16(traceFlags) are set to 00.

### Create a tracer with the OpenCensus extension

Use the OpenCensus extension that's specific to Azure Functions. Don't use the OpenCensus package that you might use in other cases (for example, [Python Webapps](/azure/azure-monitor/app/opencensus-python#instrument-with-opencensus-python-sdk-with-azure-monitor-exporters)).

Azure Functions offers many input and output bindings, and each binding has a different way of embedding the traceparent. For this architecture, when events and messages are consumed, two Azure functions are triggered.

Before the two functions can trigger:

1) The context (characterized by the identifier of the trace and the identifier of the current span) must be embedded in a traceparent in the W3C trace context format. This embedding is dependant on the nature of the output binding. For instance, the architecture uses Event Hubs as a messaging system. The traceparent is encoded into bytes and embedded in the sent event(s) as the “Diagnostic-Id” property, which achieves the right trace context in the output binding.

   Two spans can be linked even if they're not parent and child. For distributed tracing, the current span points to the next one. Creating a [link](https://opencensus.io/tracing/span/link/) establishes this relationship.

   The [Azure Functions Worker](https://www.nuget.org/packages/Microsoft.Azure.Functions.Worker/1.15.0-preview1#readme-body-tab) package manages the embedding and linking for you.

1) An Azure function in the middle of the end-to-end flow extracts the contextual information from the passed on traceparent. Use the OpenCensus extension for Azure Functions for this step. Instead of adding this process in the code of each Azure function, the OpenCensus extension implements a pre-invocation hook on the function app level.

   The pre-invocation hook:

   - Creates a span_context object that holds the information of the previous span and triggers the Azure function. See a visual example of this step [in the next section](#understand-and-structure-the-code).
   - Creates a tracer that contains the span_context and creates a new trace for the triggered Azure function.
   - Injects the tracer in the [Azure function execution context](/azure/azure-functions/functions-reference?tabs=blob#function-app).

   To ensure the traces appear in Application Insights, you must call the configure() method to create and configure an [Azure exporter](https://github.com/census-instrumentation/opencensus-python/tree/master/contrib/opencensus-ext-azure#opencensus-azure-monitor-exporters), which exports telemetry.

   The extension is at app level, so the steps in this section apply to all Azure functions in a function app.

### Understand and structure the code

In this architecture, the code in the Azure functions are structured with spans. In Python, create an OpenCensus span by using the *with* statement to access the *span\_context* part of the tracer that's injected in the Azure function execution context. The following string provides the details of the current span and its parents:

```python
    with context.tracer.span("nameSpan"):
        # DO SOMETHING WITHIN THAT SPAN
```

The following code shows details of the query data Azure function:

```python
import datetime
import logging

import azure.functions as func
from opencensus.extension.azure.functions import OpenCensusExtension
from opencensus.trace import config_integration

OpenCensusExtension.configure()
config_integration.trace_integrations(['requests'])
config_integration.trace_integrations(['logging'])

def main(timer: func.TimerRequest, outputEventHubMessage: func.Out[str], context: func.Context) -> None:

    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    if timer.past_due:
        logging.info('The timer is past due!')

    logging.info(f"Query Data Azure Function triggered. Current tracecontext is:      {context.trace_context.Traceparent}")
    with context.tracer.span("queryExternalCatalog"):
        logging.info('querying the external catalog')
        content = {"key_content_1": "thisisavalue1"}
        content = json.dumps(content)

    with context.tracer.span("sendMessage"):
        logging.info('reading the external catalog')

        with context.tracer.span("splitToMessages"):
            # Do sthg
            logging.info('splitting to messages')

        with context.tracer.span("setMessages"): 
            logging.info('sending messages')
            outputEventHubMessage.set(content)

    logging.info('Python timer trigger function ran at %s', utc_timestamp)
```

The main points in this code are:

- An OpenCensusExtension.configure() call. Perform this call in only one Azure function per function app. This action configures the Azure exporter to export Python telemetry, such as logs, metrics, and traces to Application Insights.

- The OpenCensus “requests” and “logging” [integrations](/azure/azure-monitor/app/opencensus-python-dependency#dependencies-with-requests-integration) to configure the telemetry collection from the request and logging modules for HTTP calls.

- There are five spans:

  - A root span that's part of the tracer that's injected in the context before the execution
  - *queryExternalCatalog*
  - *sendMessage*
  - *splitToMessages* (a child of *sendMessage*)
  - *setMessages* (a child of *sendMessage*)

### Tracers and spans

The following diagram shows how every time a span is created, the *span\_context* of the tracer is updated.

:::image type="content" source="images/span-context-tracer.png" alt-text="An image that shows the code lines of the function." lightbox="images/span-context-tracer.png":::

In the previous diagram:

1. **An Azure function is triggered**. A traceparent is injected in the tracer context object with a pre-invocation hook, which is called by the Python worker before the function runs.
1. **An Azure function is run**. The OpenCensusExtension.configure() method is called, which initializes an Azure exporter and enables trace writing to Application Insights.

The following details explain the relationship between a tracer and a span in this architecture:

- The tracer object of the Azure function context contains a *span\_context* field that describes the root span.
- Every time you create a span in code, it creates a new globally unique identifier and updates the *span\_context* property in the tracer object of the execution context.
- The *span\_context* field contains the *trace\_id* and *id* fields.
- The *trace\_id* never gets updated, but the *id* updates to the generated unique identifier.  
- In the previous diagram, the root span has two children spans: queryExternalApi and sendMessage.
  - The queryExternalApi span and sendMessage span have a new span id that's different from the root_span_id.
  - The sendMessage span has two children spans: splitToMessages and setMessages. Their span ids update in the span\_context field of the tracer object of the context.
- To capture the relationship between a child span and its parent, the spans\_list field provides the lineage of spans in list form. In the splitToMessages span, the *spans\_list* field contains sendMessage (the parent span) and splitToMessages (the current span). This parent/child relationship is how you create the chain of isolated operations within the execution of an Azure function.

### Chain the functions by using the context field

Now that the chain of operations are organized in one Azure function, you can chain it to the subsequent operations performed by the next Azure function.

:::image type="content" source="images/set-messages-span.png" alt-text="A diagram that shows how the functions are chained." lightbox="images/set-messages-span.png":::

In the previous diagram:

- The setMessages span is the last span of the query data Azure function. The code within the span sends a message to Event Hubs and triggers the subsequent Azure function. The span\_context field of the context tracer object contains the information related to this span. That information is tied to the query data Azure function’s context.
- Azure Functions Worker adds a bytes-encoded Diagnostic-Id in the properties of the sent event and creates a [link](https://opencensus.io/tracing/span/link/#:~:text=A%20link%20describes%20a%20cross-relationship%20between%20spans%20in,span%20to%20another%20can%20help%20correlate%20related%20spans.) to the root span of the subsequent Azure function.
- The pre-invocation hook of the subsequent process data Azure function reads the Diagnostic-Id and sets the context, which chains the Azure functions, and they're executed separately.

When the process data Azure function sends a message to the Service Bus queue, context is passed in the same way.

When the monitoring configurations are in place, use the Application Insights features to query and visualize the end-to-end transactions.

### Types of telemetry

There are several types of telemetry available in Application Insights. The code in this architecture generates the following telemetry:

- **Request** telemetry emits when you call an HTTP or trigger an Azure function. The entry to Contoso’s system has a timer-trigger for the query data Azure function that emits a request telemetry.
- **Dependency** telemetry emits when you make a call to an Azure service or an external service. When the Azure function writes an event to Event Hubs, it emits a dependency telemetry.
- **Trace** telemetry emits from logs generated by Azure Functions runtime and Azure Functions. The logging inside the Azure function emits trace telemetry.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Raouf Aliouat](https://fr.linkedin.com/in/raouf-aliouat) | Software Engineer II

Other contributors:

- [Julien Corioland](https://www.linkedin.com/in/juliencorioland) | Principal Software Engineer
- [Benjamin Guinebertière](https://www.linkedin.com/in/benjguin) | Principal Software Engineering Manager
- [Jodi Martis](https://www.linkedin.com/in/jodimartis) | Technical Writer
- [Adina Stoll](https://www.linkedin.com/in/adina-stoll) | Software Engineer II

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- An example of a system that uses the presented approach: [Synchronization framework for metadata ingestion from external catalogs in Microsoft Purview](https://microsoft.sharepoint.com/:w:/t/CSEFTEFY19/ET9i4_ecx3tOnUSXR5P0NfMBSBFZxYq2iC67Lc-tYg2TtQ?e=BdG7pO)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Observability in microservices](https://microsoft.github.io/code-with-engineering-playbook/observability/microservices/)
- [Distributed tracing and telemetry correlation](/azure/azure-monitor/app/distributed-tracing-telemetry-correlation)
- [Understand operation IDs and operation links in Event Hubs](https://devblogs.microsoft.com/cse/2021/05/13/observability-for-event-stream-processing-with-azure-functions-event-hubs-and-application-insights/#2-understanding-operation-ids-operation-links-when-working-with-event-hubs)
- [OpenCensus Azure Monitor exporters](https://github.com/census-instrumentation/opencensus-python/tree/master/contrib/opencensus-ext-azure)
- [Metadata ingestion from external catalogs in Microsoft Purview](/azure/architecture/solution-ideas/articles/sync-framework-metadata-ingestion)

## Related resources

- [Integrate Event Hubs with serverless functions on Azure](/azure/architecture/serverless/event-hubs-functions/event-hubs-functions)
- [Monitor Azure Functions and Event Hubs](/azure/architecture/serverless/event-hubs-functions/observability)
- [Monitor serverless event processing](/azure/architecture/serverless/guide/monitoring-serverless-event-processing)
- [Performance and scale guidance for Event Hubs and Azure Functions](/azure/architecture/serverless/event-hubs-functions/performance-scale)
