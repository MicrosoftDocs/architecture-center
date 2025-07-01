---
title: Azure Load Testing with Custom Plugins for Event Hubs and IoT Hub to Simulate Device Behaviors
description: Learn how to design KPIs and develop a dashboard for Azure Load Testing with custom JMeter plugins to simulate device behaviors.
author: msetbar
ms.author: msetayesh
ms.date: 02/06/2025
ms.topic: solution-idea
ms.subservice: solution-idea
ms.custom: arb-iot
---

# Azure Load Testing with custom plugins for Event Hubs and IoT Hub

[!INCLUDE [header_file](../../../../includes/sol-idea-header.md)]

This solution provides guidance for how to use Azure Load Testing, a service that lets you run Apache JMeter scripts and custom plugins to simulate user and device behaviors. This solution also explains how to design key performance indicators (KPIs) and develop a dashboard for monitoring and analyzing the results of the load test in a sample application with Azure Functions and Azure Event Hubs. This example uses Event Hubs, but you can apply the same approach to Azure IoT Hub by changing the Event Hubs client to the IoT Hub client. This article assumes that you have some familiarity with JMeter, its plugins and custom plugins, and Functions and Event Hubs.

IoT Hub contains more core components than Event Hubs, including partitions. Therefore the load testing approach described in this article also applies to IoT Hub with minimal changes.

## Architecture

To perform load testing, you need a test plan, which is a set of instructions that tells JMeter what to do during the test. The test plan can include multiple test scenarios, and each scenario can have different settings and configurations. For example, you might have one scenario that simulates a single user accessing a web application and another scenario that simulates multiple users simultaneously accessing the same application.

:::image type="complex" source="images/load-testing-architecture.svg" alt-text="Diagram of a sample architecture for load testing." border="false" lightbox="images/load-testing-architecture.svg":::
   The diagram shows how data flows from Load Testing through Event Hubs and Azure Functions to downstream services like SQL Database and Azure Digital Twins. The data flows back to Azure Monitor. Load Testing collects the data from Azure Monitor and displays it in a dashboard.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/load-testing-architecture.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. A simulated device sends data to an event hub through a Load Testing agent. Any behavior of the device can be simulated by using JMeter custom plugins. The Load Testing agent sends data to the event hub after it runs the custom plugin for any type of simulated device.

1. The event hub triggers an Azure function app that processes the data and sends it to other downstream services, such as Azure SQL Database and Azure Digital Twins.

1. Azure Monitor monitors the function app and Event Hubs.

1. Load Testing collects the data from Azure Monitor and displays it in a dashboard.

### Components

This example uses the following components:

- **[Load Testing](/azure/load-testing/overview-what-is-azure-load-testing)**: Use Load Testing to run Apache JMeter scripts and custom plugins to simulate user and device behaviors. Load Testing provides a web-based interface to manage and run load tests and a set of APIs to automate the process. Load Testing is a fully managed service, which means that you don't need to manage servers or infrastructure. In this architecture, Load Testing uploads the JMeter scripts and custom plugins, and it's the compute where those scripts run.

- **[Event Hubs](/azure/well-architected/service-guides/event-hubs)**: Event Hubs is a cloud-based event processing service that you can use to collect, process, and analyze events and streaming data from various sources in real time. Event Hubs supports multiple protocols, including Advanced Message Queuing Protocol (AMQP), HTTPS, Kafka protocol, Message Queuing Telemetry Transport (MQTT), and AMQP over WebSocket. This architecture is event based, so Load Testing populates events to load test the workload.

- **[IoT Hub](/azure/well-architected/service-guides/azure-iot-hub)**: IoT Hub is a cloud-hosted managed service that serves as a central message hub for communication between an IoT application and its attached devices. You can connect millions of devices and their back-end solutions reliably and securely. Almost any device can be connected to an IoT hub. You can adapt this architecture to use IoT Hub by changing the Event Hubs client to the IoT Hub client.

- **[Azure Functions](/azure/well-architected/service-guides/azure-functions)**: Functions is a serverless compute service that you can use to run code without needing to manage servers or infrastructure. It supports multiple programming languages, including C#, F#, Java, JavaScript, PowerShell, Python, and TypeScript. This architecture uses Functions as the primary compute tier. Event data in Event Hubs triggers and scales out function apps.

- **[JMeter GUI](https://jmeter.apache.org/download_jmeter.cgi)**: JMeter GUI is an open-source load testing tool that's primarily used to test the performance of web applications. However, you can also use it to test other types of applications, such as SOAP and REST web services, FTP servers, and databases.

- **[Azure Monitor](/azure/azure-monitor/overview)**: Azure Monitor provides monitoring and alerting capabilities for Azure resources. Use it to monitor the performance and health of your applications and the underlying infrastructure. In this architecture, Azure Monitor monitors the health of Azure infrastructure components during the load test.

## Scenario details

You can use Load Testing to apply an existing Apache JMeter script and run a load test at cloud scale on any Azure resource.

JMeter lets testers create and run load tests, stress tests, and functional tests. It simulates multiple users simultaneously accessing a web application so that testers can identify potential performance bottlenecks or other problems that might arise under heavy loads. You can use JMeter to measure various performance metrics, such as response time, throughput, and error rate.

JMeter uses a GUI-based interface to allow users to create test plans, which can include multiple test scenarios that have different settings and configurations. Testers can also customize JMeter by using plugins or by writing custom code. The plugins can help users work with services that use non-HTTP protocols, such as AMQP and WebSocket.

JMeter provides a wide range of features and functions for load testing, but the built-in functionality might not cover specific use cases or requirements. By developing custom plugins, testers can add new functionality or customize existing features to better suit their needs.

For example, you can develop a custom plugin to simulate a specific type of user behavior or to generate more realistic test data. You can also develop custom plugins to integrate JMeter with other tools or systems, such as logging and reporting tools or continuous integration and continuous deployment (CI/CD) pipelines. The custom plugins can help streamline the testing process and make it easier to incorporate load testing into the overall software development workflow. They allow testers to tailor JMeter to their specific needs and improve the accuracy and effectiveness of their load testing efforts.

In this example, a device reports temperature and humidity over a specific period of time. The example simulates this behavior by using a custom JMeter plugin. The [current implementation of the custom plugin](https://github.com/Azure-Samples/load-testing-jmeter-plugins/blob/main/target/loadtestplugins-1.0.jar) generates random data by using a provided template. However, the plugin can contain any possible complex behavior for any device. In this example, the device sends the data to an event hub in Azure. The event hub triggers an Azure function app that processes the data and sends it to other downstream services, such as SQL Database. Azure Functions is the service that the architecture tests. The test plan is designed to simulate the behavior of the device and send data to the event hub.

### Potential use cases

Using Load Testing with custom plugins can be useful in various scenarios, such as:

- Testing the performance of an application that uses non-HTTP protocols, such as AMQP and WebSocket.
- Testing the performance of an application that uses a custom protocol.
- Testing the performance of an application that uses a non-Microsoft SDK.
- Simulating a specific type of user or device behavior.
- Generating more realistic test data.

### Custom plugins

In JMeter, custom plugins are software components that you can add to expand its default functionality. Custom plugins add new features, functions, or integrations to JMeter. You can develop custom plugins by using the Java programming language and the JMeter plugin development kit (PDK). The PDK provides a set of tools and APIs that help you create new plugins, including GUI elements, listeners, and samplers.

To implement a custom sampler for Event Hubs in JMeter, follow the instructions in [Load Testing JMeter plugins](https://github.com/Azure-Samples/load-testing-jmeter-plugins#how-to-setup-visual-studio-code-for-eventhub-plugin-development). After you implement your custom sampler, you can use it in your JMeter test plan in Load Testing just like any other sampler.

You can implement a test plan by using a thread group that controls the number of threads, like virtual users and devices, to run a specific scenario. Each thread group can have different settings for the number of threads, ramp-up period, loop count, and duration. Thread groups can run sequentially or in parallel, depending on the test plan configuration and the application requirements. You can add the sampler to a thread group, set its parameters, and configure it as needed. Custom samplers can be powerful tools in JMeter that allow you to simulate complex scenarios and requests that the built-in samplers don't support.

### Create an Apache JMeter script with a custom plugin

In this section, you create a sample JMeter test script to load test an application with Event Hubs.

To create a sample JMeter test script:

1. Create a *LoadTest.jmx* file in a text editor and paste the following code snippet into the file. This script simulates a load test of 36 virtual machines that simultaneously send events to an event hub. It takes 10 minutes to complete.

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <jmeterTestPlan version="1.2" properties="5.0" jmeter="5.5">
       <hashTree>
       <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="Test Plan" enabled="true">
           <stringProp name="TestPlan.comments"></stringProp>
           <boolProp name="TestPlan.functional_mode">false</boolProp>
           <boolProp name="TestPlan.tearDown_on_shutdown">true</boolProp>
           <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
           <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
               <collectionProp name="Arguments.arguments"/>
           </elementProp>
           <stringProp name="TestPlan.user_define_classpath"></stringProp>
       </TestPlan>
       <hashTree>
           <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Thread Group" enabled="true">
               <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
               <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
                   <boolProp name="LoopController.continue_forever">false</boolProp>
                   <intProp name="LoopController.loops">-1</intProp>
               </elementProp>
               <stringProp name="ThreadGroup.num_threads">36</stringProp>
               <stringProp name="ThreadGroup.ramp_time">20</stringProp>
               <boolProp name="ThreadGroup.scheduler">true</boolProp>
               <stringProp name="ThreadGroup.duration">600</stringProp>
               <stringProp name="ThreadGroup.delay"></stringProp>
               <boolProp name="ThreadGroup.same_user_on_next_iteration">false</boolProp>
           </ThreadGroup>
           <hashTree>
                <com.microsoft.eventhubplugin.EventHubPlugin guiclass="com.microsoft.eventhubplugin.EventHubPluginGui" estclass="com.microsoft.eventhubplugin.EventHubPlugin" testname="Azure Event Hubs Sampler" enabled="true">
                   <!-- Azure Event Hub connection configuration using Managed Identity (see repository for instructions) -->
                   <boolProp name="useManagedIdentity">true</boolProp>
                   <stringProp name="eventHubNamespace">telemetry-ehn.servicebus.windows.net</stringProp>
                   <stringProp name="eventHubName">telemetry-data-changed-eh</stringProp>
                   <stringProp name="liquidTemplateFileName">StreamingDataTemplate.liquid</stringProp>
               </com.microsoft.eventhubplugin.EventHubPlugin>
           </hashTree>
       </hashTree>
       </hashTree>
   </jmeterTestPlan>
   ```

   The implementation of `com.microsoft.eventhubplugin.EventHubPluginGui` and `com.microsoft.eventhubplugin.EventHubPlugin` are available at [Azure samples](https://github.com/Azure-Samples/load-testing-jmeter-plugins).

1. In the file, set the Event Hubs connection values by using the assigned managed identity of the test runners. That identity needs to have write access to the Event Hubs instance.

1. In the file, set the value of the `eventHubName` node to the event hub name, such as `telemetry-data-changed-eh`.

1. Set the value of the `liquidTemplateFileName` node to the file that contains the message that's sent to the event hub. For example, create a file named `StreamingDataTemplate.liquid` as:

   ```json
   {
       {% assign numberOfMachines = 36 %}
       {% assign machineId = dataGenerator.randomNaturalNumber | modulo: numberOfMachines %}
       "MachineId": "{{machineId | prepend: '0000000000000000000000000000000000000000' | slice: -27, 27 }}"
       "Temperature": {{dataGenerator.randomInt | modulo: 100 }},
       "Humidity": {{dataGenerator.randomInt | modulo: 100 }}
   }
   ```

   In this example, the payload for the event hub message is a JSON object that has three properties, `MachineId`, `Temperature`, and `Humidity`. `MachineId` is a randomly generated ID that's 27 characters long, and `Temperature` and `Humidity` are random integers that are less than 100. This file is a liquid template syntax. Liquid template is a popular templating language that's used in various web development frameworks. Liquid templates enable developers to create dynamic content that can be easily updated and modified. They allow you to insert variables, conditions, loops, and other dynamic elements into your event hub messages. The syntax is straightforward, and there are plenty of online resources available to help you get started. Liquid templates provide a powerful and flexible way to create dynamic, customizable messages.

1. Save and close the file.

    > [!IMPORTANT]
    > Don't include any personal data in the sampler name in the JMeter script. The sampler names appear in the Load Testing test results dashboard. A sample of a liquid template along with the JMeter script file is available to download at [Azure samples](https://github.com/Azure-Samples/load-testing-jmeter-plugins/tree/main/samples/eventhubplugin).

#### Update the custom plugin from Event Hubs to IoT Hub

The custom plugin uses Event Hubs as the primary target resource. The following configuration is the SDK client setup for Event Hubs:

```java
EventHubProducerClient producer = null;
EventHubClientBuilder producerBuilder = new EventHubClientBuilder();

producerBuilder.credential(getEventHubNamespace(), getEventHubName(), new DefaultAzureCredentialBuilder().build());
producer = producerBuilder.buildProducerClient();

EventDataBatch batch = producer.createBatch(new CreateBatchOptions());
batch.tryAdd(new EventData(msg));
producer.send(batch);
```

The following example shows how you can reuse the same solution, add the IoT dependencies, and change the SDK client to use IoT Hub:

```java
IotHubServiceClientProtocol protocol = IotHubServiceClientProtocol.AMQPS;
ServiceClient client = new ServiceClient(getIoTHostName(), new DefaultAzureCredentialBuilder().build(), protocol);
client.open();

Message message = new Message(msg);
client.send(getDeviceName(), message);

client.close();
```

### Run the load test by using the new plugin

When Load Testing starts your load test, it first deploys the JMeter script along with all the other files onto test engine instances. Before running the test, go to the parameter tab to define and set any required parameters. For more information, see [Customize a load test with Apache JMeter plugins and Load Testing](/azure/load-testing/how-to-use-jmeter-plugins).

### Set up performance testing for the environment

For performance testing, it's important that your test environment is similar to the production environment. This example uses the following environment for performance testing to better understand the system's capacity and performance.

| Service | Configuration |
| ----------- | ----------- |
| Event Hubs | Premium with one processing unit |
| Azure Functions | Linux with Premium Plan (EP1) - 210 ACU, 3.5 GB Memory, and 1 vCPU equivalent Standard_D1_v2 |
| Region | East US |

Choosing the right service tier for any Azure service, including Event Hubs and Azure Functions, is a complex process and depends on many factors. For more information, see [Event Hubs pricing](https://azure.microsoft.com/pricing/details/event-hubs/) and [Functions pricing](https://azure.microsoft.com/pricing/details/functions/).

### Design KPIs for performance testing

Before you can design KPIs for performance testing, you need to define the business requirements and the system architecture. The business requirements tell you which KPIs, such as response time, throughput, or error rate, that you want to measure. The system architecture tells you how to test the performance of each component, such as web servers, databases, or APIs. It also helps you choose the best performance testing strategy, such as load testing, stress testing, or endurance testing.

This example has the following business requirements:

- The system can handle 1,000 requests per second.
- The system reliability is higher than 0.99.
- The system can handle 1,000 concurrent devices reporting their personal data information.
- You can specify the maximum capacity of the system in terms of the number of devices that it can support. For example, the system can support 1,000 concurrent devices with three times the current capacity.

To measure whether the system meets these requirements, you can use the following KPIs for performance testing:

| KPI | Description |
| ----------- | ----------- |
| RPS |  Requests per second for an event hub  |
| LOAD |  Number of loads or requests sent to the event hub during performance testing |
| IR | Number of function invocations or ingestion rate |
| RT | Average time for Azure Functions run time |
| AMU | Average memory usage for Azure Functions |
| SR | Success rate of all function app invocations |
| ARS | Average downstream service response time for services like SQL server or a microservice |
| DF | Dependency failure count, including internal function app errors |
| MRPS | Maximum RPS with no backlog in the event hub (system capacity) |

### Measure KPIs

To measure KPIs, you need to have a performance testing strategy. The strategy defines the performance testing approach for each component. This example uses the following performance testing strategy.

- **Event Hubs:** The performance testing approach for the event hub is to send many messages to the event hub and then measure the RPS and LOAD. The RPS is the number of messages that are sent to the event hub per second. The LOAD is the total number of messages that are sent to the event hub during the performance testing. Load Testing can measure RPS and LOAD.

- **Azure Functions:** The performance testing approach for Functions is to measure the following metrics.

  - IR
  - RT
  - AMU
  - SR
  - ARS
  - DF
  
Azure Monitor can measure AMU, ARS, and DF, but not IR, RT, or SR. To measure KPIs by using Azure Monitor, enable Application Insights for Azure Functions. For more information, see [Enable Application Insights integration](/azure/azure-functions/functions-monitoring#application-insights-integration).

After you enable Azure Monitor, you can use the following queries to measure KPIs:

- IR: `FunctionAppLogs | where Category startswith "name-space-of-your-function" and Message startswith "Executed" | summarize count() by FunctionName, Level, bin(TimeGenerated, 1h) | order by FunctionName desc`

- RT: `FunctionAppLogs| where Category startswith "name-space-of-your-function" and Message startswith "Executed "| parse Message with "Executed " Name " ("  Result ", Id=" Id ", Duration=" Duration:long "ms)"| project  TimeGenerated, Message, FunctionName, Result, FunctionInvocationId, Duration`

- SR: `FunctionAppLogs| where Category startswith "name-space-of-your-function" and Message startswith "Executed" | summarize Success=countif(Level == "Information" ), Total=count() by FunctionName| extend Result=Success*100.0/Total| project FunctionName, Result| order by FunctionName desc`

### Azure Monitor dashboard sample

The following image shows a sample of the Azure Monitor dashboard. It shows the KPIs for Azure Functions based on the previous queries.

:::image type="content" source="images/load-testing-azure-monitor-dashboard.png" alt-text="Screenshot that shows samples of the Azure Monitor dashboard." border="false" lightbox="images/load-testing-azure-monitor-dashboard.png#lightbox":::

### Conclusion

In this article, you learned how to design KPIs and develop a dashboard for Load Testing. You also learned how to use custom plugins in JMeter to perform load testing on Azure Functions integrated with Event Hubs. You can use the same approach to perform load testing on other Azure services. You can also set up a CI/CD pipeline for your load testing scripts by using Azure DevOps.

For more information, see [Load Testing](/azure/load-testing/).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Mahdi Setayesh](https://www.linkedin.com/in/mahdi-setayesh-a03aa644/) | Principal Software Engineer
- [Oscar Fimbres](https://www.linkedin.com/in/ofimbres) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Load Testing](/azure/load-testing/)
- [Sample code for a custom JMeter plugin](https://github.com/Azure-Samples/load-testing-jmeter-plugins)
- [How to develop a new custom plugin](https://jmeter.apache.org/usermanual/jmeter_tutorial.html)
- [Customize a load test with Apache JMeter plugins and Load Testing](/azure/load-testing/how-to-use-jmeter-plugins)
- [What is Application Insights](/azure/azure-monitor/app/app-insights-overview)
- [Load testing your Azure App Service applications](/azure/load-testing/concept-load-test-app-service)
- [Quickstart: Create and run a load test with Load Testing](/azure/load-testing/quickstart-create-and-run-load-test)
- [Load test a website by using a JMeter script in Load Testing](/azure/load-testing/how-to-create-and-run-load-test-with-jmeter-script)
- [Quickstart: Automate an existing load test with CI/CD](/azure/load-testing/quickstart-add-load-test-cicd)
- [Tutorial: Run a load test to identify performance bottlenecks in a web app](/azure/load-testing/tutorial-identify-bottlenecks-azure-portal)
