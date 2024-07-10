---
title: Azure Load Testing with custom plugins to simulate device behaviors
description: Learn about designing KPIs and developing a dashboard for Azure Load Testing with custom JMeter plugins to simulate device behaviors.
author: msetbar
ms.author: msetayesh
ms.date: 01/19/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.custom: load-testing
categories: azure
products:
- load-testing
---

# Azure Load Testing with custom plugins

[!INCLUDE [header_file](../../../../includes/sol-idea-header.md)]

This solution provides guidance for how to use Azure Load Testing, a service that lets you run Apache JMeter scripts and custom plugins to simulate user and device behaviors. This solution also explains how to design Key Performance Indicators (KPIs) and develop a dashboard for monitoring and analyzing the results of the load test in a sample application with Azure Functions and Azure Event Hubs. The article assumes that you have some familiarity with JMeter, its plugins and custom plugins, as well as Azure Functions and Event Hubs.

## Architecture

To perform load testing, you need a test plan, which is a set of instructions that tells JMeter what to do during the test. The test plan can include multiple test scenarios, each with different settings and configurations. For example, you might have one scenario that simulates a single user accessing a web application, and another scenario that simulates multiple users simultaneously accessing the same application.

The test plan can also include multiple test cases, each with different settings and configurations. In our case, we assume that there's a device that is reporting temperature and humidity during a certain period of time. The device is sending the data to an event hub in Azure. The event hub triggers an Azure Function that is responsible for processing the data and then sending data to other downstream services such as Azure SQL Database. The Azure Function is the service that we want to test. The test plan is designed to simulate the behavior of the device and send data to the event hub.

:::image type="content" source="images/load-testing-architecture.svg" alt-text="Diagram of a sample architecture for load testing." border="false" lightbox="images/load-testing-architecture.svg#lightbox":::

*Download a [Visio file](https://arch-center.azureedge.net/load-testing-architecture.vsdx) of this architecture.*

### Dataflow

In this example, the dataflow is as follows:

1. A simulated device sends data to an event hub through Azure Load Testing agent. Any behavior of the device can be simulated using JMeter custom plugins. Azure Load Test agent is responsible for sending data to the event hub after running the custom plugin for any types of simulated devices.
1. The event hub triggers an Azure Function that is responsible for processing the data and then sending data to other downstream services, such as Azure SQL Database and Azure Digital Twins.
1. Azure Monitor service is used to monitor the Azure Function and Event Hubs.
1. Azure Load Testing service collects the data from Azure Monitor service and then displays it in a dashboard.

### Components

In this example, the following components are used:

- **[Azure Load Testing](/azure/load-testing/overview-what-is-azure-load-testing)**: Azure Load Testing lets you run Apache JMeter scripts and custom plugins to simulate user and device behaviors. It provides a web-based interface for managing and running load tests and a set of APIs that can be used to automate the process. Azure Load Testing is a fully managed service, which means that you don't need to worry about managing servers or infrastructure. You can upload your JMeter scripts and custom plugins, and Azure Load Testing handles the rest.
- **[Azure Event Hubs](/azure/event-hubs/event-hubs-about)**: Azure Event Hubs is a cloud-based event processing service that can be used to collect, process, and analyze events and streaming data from various sources in real-time. Event Hubs supports multiple protocols, including AMQP (Advanced Message Queuing Protocol), HTTPS, Kafka Protocol, MQTT (Message Queuing Telemetry Transport), and AMQP over WebSockets. Choosing the right protocol depends on several factors, including the type of data you're working with, the specific requirements of your application, and the capabilities and limitations of the protocols themselves.
- **[Azure Functions](/azure/azure-functions/functions-overview)**: Azure Functions is a serverless compute service that lets you run code without having to manage servers or infrastructure. It supports multiple programming languages, including C#, F#, Java, JavaScript, PowerShell, Python, and TypeScript. Azure Functions can be used to process events and streaming data from Event Hubs, as well as other sources like Azure Storage and Azure Cosmos DB.
- **[JMeter GUI](https://jmeter.apache.org/download_jmeter.cgi)**: JMeter GUI is an open-source load testing tool that is primarily used to test the performance of web applications. It was originally developed for testing web applications. However it can also be used to test other types of applications, such as SOAP and REST web services, FTP servers, and databases.
- **[Azure Monitor](/azure/azure-monitor/overview)**: Azure Monitor provides monitoring and alerting capabilities for Azure resources. It lets you monitor the performance and health of your applications and the underlying infrastructure as well. Azure Monitor can be used to monitor Event Hubs and Azure Functions, as well as other Azure services like Azure Storage and Azure Cosmos DB.

## Scenario details

Azure Load Testing lets you take an existing Apache JMeter script, and use it to run a load test at cloud scale on any Azure resource.

JMeter lets testers create and execute load tests, stress tests, and functional tests. It simulates multiple users simultaneously accessing a web application, enabling testers to identify potential performance bottlenecks or other issues that might arise under heavy loads. JMeter can be used to measure various performance metrics, such as response time, throughput, and error rate.

JMeter uses a GUI-based interface to allow users to create test plans, which can include multiple test scenarios, each with different settings and configurations. Testers can also customize JMeter using plugins or by writing custom code, allowing them to extend its functionality beyond what comes out of the box. The plugins can help us to work with services that use non-HTTP protocols, such as AMQP and Websocket.

While JMeter provides a wide range of features and functions for load testing, there might be specific use cases or requirements that aren't covered by the built-in functionality. By developing custom plugins, testers can add new functionality or customize existing features to better suit their needs

For example, a custom plugin could be developed to simulate a specific type of user behavior or to generate more realistic test data. Additionally, custom plugins can be developed to integrate JMeter with other tools or systems, such as logging and reporting tools or continuous integration and deployment pipelines. The custom plugins can help streamline the testing process and make it easier to incorporate load testing into the overall software development workflow. Overall, they allow testers to tailor JMeter to their specific needs and improve the accuracy and effectiveness of their load testing efforts.

In this example, we assume that there's a device that is reporting temperature and humidity over a set period of time. We can simulate this simple behavior using a custom JMeter plugin. In the [current implementation of the custom plugin provided here](https://github.com/Azure-Samples/load-testing-jmeter-plugins/blob/main/target/loadtestplugins-1.0.jar), we generate a random data using a provided template. However, the plugin can contain any possible complex behavior for any devices. In this example, the device is sending the data to an event hub in Azure. The event hub triggers an Azure Function that is responsible for processing the data and then sending data to other downstream services, such as Azure SQL Database. The Azure Function is the service that we want to test. The test plan is designed to simulate the behavior of the device and send data to the event hub.

### Potential use cases

Using Azure Load Testing with custom plugins can be useful in various scenarios, such as:

- Testing the performance of an application that uses non-HTTP protocols, such as AMQP and Websocket.
- Testing the performance of an application that uses a custom protocol.
- Testing the performance of an application that uses a non-Microsoft SDK.
- Simulating a specific type of user or device behavior, or generating more realistic test data.

### Custom plugins

Custom plugins in the context of JMeter are software components that can be added to JMeter to extend its functionality beyond what comes out of the box. Users or non-Microsoft developers can develop custom plugins to add new features, functions, or integrations to JMeter. Custom plugins can be developed using Java programming language and the JMeter Plugin Development Kit (PDK). The PDK provides a set of tools and APIs that make it easier to create new plugins, including GUI elements, listeners, and samplers.

Custom plugins can add a wide range of functionality to JMeter. They can also integrate JMeter with other systems, such as logging and reporting tools, or enable the use of other data sources for test data. Overall, custom plugins let users extend JMeter to meet their specific needs and improve the accuracy and effectiveness of their load testing efforts.

To implement a custom sampler for Event Hubs in JMeter, follow the instruction provided at [Azure Load Testing Plugins](https://github.com/Azure-Samples/load-testing-jmeter-plugins#how-to-setup-visual-studio-code-for-eventhub-plugin-development). Once your custom sampler is implemented, you can use it in your JMeter test plan in Azure Load Test just like any other sampler.

A test plan can be implemented using a thread group that controls the number of threads (virtual users and devices) to execute a specific scenario. Each thread group can have different settings for the number of threads, ramp-up period, loop count, and duration. Thread groups can be run either sequentially or in parallel, depending on the test plan configuration and the application requirements. You can add the sampler to a thread group, set its parameters, and configure it as needed. Custom samplers can be powerful tools in JMeter, allowing you to simulate complex scenarios and requests that the built-in samplers don't support.

### Create an Apache JMeter script with custom plugin

In this section, you create a sample JMeter test script to load test an application with Event Hubs.

To create a sample JMeter test script:

1. Create a *LoadTest.jmx* file on your local machine:

   ```bash
   touch LoadTest.jmx
   ```

1. Open *LoadTest.jmx* in a text editor and paste the following code snippet in the file. This script simulates a load test of 36 virtual machines that simultaneously send events to an event hub, and takes 10 minutes to complete:

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
            <com.microsoft.eventhubplugin.EventHubPlugin guiclass="com.microsoft.eventhubplugin.EventHubPluginGui" testclass="com.microsoft.eventhubplugin.EventHubPlugin" testname="Azure Event Hubs Sampler" enabled="true">
                <stringProp name="eventHubConnectionVarName">EventHubConnectionString</stringProp>
                <stringProp name="eventHubName">telemetry-data-changed-eh</stringProp>
                <stringProp name="liquidTemplateFileName">StreamingDataTemplate.liquid</stringProp>
            </com.microsoft.eventhubplugin.EventHubPlugin>
            <hashTree/>
            </hashTree>
        </hashTree>
        </hashTree>
    </jmeterTestPlan>
    ```

   The implementation of `com.microsoft.eventhubplugin.EventHubPluginGui` and `com.microsoft.eventhubplugin.EventHubPlugin` are available at [Azure Samples](https://github.com/Azure-Samples/load-testing-jmeter-plugins).

1. In the file, set the value of the `eventHubConnectionVarName` node to the variable name that specifies Event Hubs connection string host. For example, if you want the environment variable that stores the connection string of Event Hubs to be `EventHubConnectionString`, set this variable to `EventHubConnectionString` and then set the value of the environmental variable.

    > [!IMPORTANT]
    > Make sure the value of `EventHubConnectionString` has been set as a part of Azure load test creation process before running the load test script.

1. In the file, set the value of the `eventHubName` node to the event hub name, such as `telemetry-data-changed-eh`.
1. Set the value of the `liquidTemplateFileName` node to the file containing the message that is sent to the event hub. For example, create a file named `StreamingDataTemplate.liquid` as:

   ```json
   {
       {% assign numberOfMachines = 36 %}
       {% assign machineId = dataGenerator.randomNaturalNumber | modulo: numberOfMachines %}
       "MachineId": "{{machineId | prepend: '0000000000000000000000000000000000000000' | slice: -27, 27 }}"
       "Temperature": {{dataGenerator.randomInt | modulo: 100 }},
       "Humidity": {{dataGenerator.randomInt | modulo: 100 }}
   }
   ```

   In this example, the payload for the event hub message is a JSON object with three properties including `MachineId`, `Temperature`, and `Humidity` where `MachineId` is a randomly generated ID with the length of 27, and `Temperature` and `Humidity` are random integers less than 100. This file is a liquid template syntax. Liquid template is a popular templating language that is used in various web development frameworks. Liquid templates enable developers to create dynamic content that can be easily updated and modified. They allow you to insert variables, conditions, loops, and other dynamic elements into your event hub messages. The syntax is straightforward, and there are plenty of online resources available to help you get started. Overall, Liquid templates offer a powerful and flexible way to create dynamic, customizable messages.

1. Save and close the file.

    > [!IMPORTANT]
    > Don't include any personal data in the sampler name in the JMeter script. The sampler names appear in the Azure Load Testing test results dashboard. A sample of a liquid template along with the JMeter script file is available to download at [Azure Samples](https://github.com/Azure-Samples/load-testing-jmeter-plugins/tree/main/samples/eventhubplugin)

### Run the load test using new plugin

When Azure Load Testing starts your load test, it first deploys the JMeter script along with all other files onto test engine instances, and then starts the load test as instructed at [Customize a load test with Apache JMeter plugins and Azure Load Testing](/azure/load-testing/how-to-use-jmeter-plugins?tabs=portal).
Before running the test, go to the parameter tab, define `EventHubConnectionString`, and then provide the connection string to the event hub.

:::image type="content" source="images/load-testing-configuration-parameters.png" alt-text="Screenshot that shows the parameters of the test." border="false" lightbox="images/load-testing-configuration-parameters.png#lightbox":::

### Performance testing setup for environment

In any performance testing, it's important to have a similar environment to the production environment. In this example, the following environment is used for performance testing in order to better understand the system capacity and the performance of the system.

Per the sample architecture, the following services could be used for performance testing:

| Service | Configuration |
| ----------- | ----------- |
| Eventhub | Premium with one Processing Unit (PU). |
| Azure Function | Linux with Premium Plan (EP1) - 210 ACU, 3.5 GB Memory and 1 vCPU equivalent Standard_D1_v2 |
| Region | East US |

Choosing the right service tier for any Azure services, including Event Hubs and Azure Functions, is a complex process and depends on many factors. For more information, see [Azure Event Hubs pricing](https://azure.microsoft.com/pricing/details/event-hubs/) and [Azure Functions pricing](https://azure.microsoft.com/pricing/details/functions/).

### Designing KPIs for performance testing

Before you can design Key Performance Indicators (KPIs) for performance testing, you need two things: the business requirements and the system architecture. The business requirements tell you what KPIs you want to measure, such as response time, throughput, or error rate. The system architecture tells you how to test the performance of each component, such as web servers, databases, or APIs. It also helps you choose the best performance testing strategy, such as load testing, stress testing, or endurance testing.

In this example, the business requirements are:

- The system should be able to handle 1,000 requests per second.
- The system reliability should be higher than 0.99.
- The system should be able to handle 1,000 concurrent devices reporting their personal data information.
- Specifying the maximum capacity of the system in terms of the number of devices that can be supported. For example, can the system with 3x of the current capacity support 1,000 concurrent devices?

As per these requirements, the KPIs for performance testing could be:

| KPI | Description |
| ----------- | ----------- |
| RPS |  Request Per Second for an event hub  |
| LOAD |  Number of loads or requests sent to the event hub during performance testing |
| IR | Number of function executions or ingestion rate |
| RT | Average time for Azure Function Execution Time |
| AMU | Average Memory Usage for Azure Functions |
| SR | Success Rate of all function executions |
| ARS | Average Downstream Service Response Time (for example, SQL server or a microservice) |
| DF | Dependency Failure count including internal Azure function errors |
| MRPS | Maximum RPS with no Backlog in the event hub (System Capacity) |

### How to measure KPIs

To measure KPIs, you need to have a performance testing strategy. The strategy defines the performance testing approach for each component. In this example, the following performance testing strategy is used:

- Event Hubs: The performance testing approach for the event hub is to send many messages to the event hub and then measure the RPS and LOAD. The RPS is the number of messages that are sent to the event hub per second. The LOAD is the total number of messages that are sent to the event hub during the performance testing. Azure Load Testing service can measure RPS and LOAD.
- Azure Functions: The performance testing approach for Azure Functions is to measure the following metrics:
  - The IR is the number of function executions or ingestion rate.
  - The RT is the average time for Azure Function Execution Time.
  - The AMU is the average memory usage for Azure Functions.
  - The SR is the success rate of all function executions.
  - The ARS is the average downstream service response time.
  - The DF is the dependency failure count including internal Azure function errors.
  - Azure Monitor service can measure AMU, ARS, and DF, but not IR, RT, or SR.

In order to measure KPIs using Azure Monitor service, we need to enable Application Insights for Azure Functions. For more information, see [Enable Application Insights integration](/azure/azure-functions/functions-monitoring?tabs=cmd#application-insights-integration).

After enabling Azure Monitor service, you can use the following queries to measure KPIs:

- IR: `FunctionAppLogs | where Category startswith "name-space-of-your-function" and Message startswith "Executed" | summarize count() by FunctionName, Level, bin(TimeGenerated, 1h) | order by FunctionName desc`
- RT: `FunctionAppLogs| where Category startswith "name-space-of-your-function" and Message startswith "Executed "| parse Message with "Executed " Name " ("  Result ", Id=" Id ", Duration=" Duration:long "ms)"| project  TimeGenerated, Message, FunctionName, Result, FunctionInvocationId, Duration`
- SR: `FunctionAppLogs| where Category startswith "name-space-of-your-function" and Message startswith "Executed" | summarize Success=countif(Level == "Information" ), Total=count() by FunctionName| extend Result=Success*100.0/Total| project FunctionName, Result| order by FunctionName desc`

### Sample of Azure Monitor dashboard

Here's a sample of Azure Monitor dashboard that shows the KPIs for Azure Functions based on the queries:

:::image type="content" source="images/load-testing-azure-monitor-dashboard.png" alt-text="Screenshot samples of the Azure Monitor dashboard." border="false" lightbox="images/load-testing-azure-monitor-dashboard.png#lightbox":::

### Conclusion

In this article, you learned how to design KPIs and develop a dashboard for Azure Load Test. You also learned how to use custom plugins in JMeter to perform load testing on Azure Functions integrated with Event Hubs. You can use the same approach to perform load testing on other Azure services. You can also set up a continuous integration and delivery (CI/CD) pipeline for your load testing scripts using Azure DevOps.

For more information, see [Azure Load Testing](/azure/load-testing/).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Mahdi Setayesh](https://www.linkedin.com/in/mahdi-setayesh-a03aa644/) | Principal Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Load Testing](/azure/load-testing/)
- [Sample code for a custom JMeter plugin](https://github.com/Azure-Samples/load-testing-jmeter-plugins)
- [How to develop a new custom plugin?](https://jmeter.apache.org/usermanual/jmeter_tutorial.html)
- [Customize a load test with Apache JMeter plugins and Azure Load Testing](/azure/load-testing/how-to-use-jmeter-plugins?tabs=portal)
- [What is Application Insights](/azure/azure-monitor/app/app-insights-overview)

## Related resources

- [Load testing your Azure App Service applications](/azure/load-testing/concept-load-test-app-service)
- [Quickstart: Create and run a load test with Azure Load Testing](/azure/load-testing/quickstart-create-and-run-load-test)
- [Load test a website by using a JMeter script in Azure Load Testing](/azure/load-testing/how-to-create-and-run-load-test-with-jmeter-script)
- [Quickstart: Automate an existing load test with CI/CD](/azure/load-testing/quickstart-add-load-test-cicd)
- [Tutorial: Run a load test to identify performance bottlenecks in a web app](/azure/load-testing/tutorial-identify-bottlenecks-azure-portal)
