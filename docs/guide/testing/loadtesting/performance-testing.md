---
title: Azure Load Testing for Azure Functions integrated with Event Hubs
description: Guide on designing KPIs and developing a dashboard for Azure Load Test
author: msetbar
ms.author: msetayesh
ms.date: 03/24/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
ms.custom: load-testing
categories: azure
products:
- load-testing
---
# Azure Load Testing for Azure Functions integrated with Event Hubs

Azure Load Testing enables you to take an existing Apache JMeter script, and use it to run a load test at cloud scale on any Azure resources.
JMeter is a popular open-source load testing tool that is primarily used to test the performance of web applications. It was originally developed for testing web applications. However it can also be used to test other types of applications, such as SOAP and REST web services, FTP servers, databases, and more.
JMeter allows testers to create and execute load tests, stress tests, and functional tests. It simulates multiple users simultaneously accessing a web application, enabling testers to identify potential performance bottlenecks or other issues that might arise under heavy loads. JMeter can be used to measure various performance metrics, such as response time, throughput, and error rate.
JMeter uses a GUI-based interface to allow users to create test plans, which can include multiple test scenarios, each with different settings and configurations. Testers can also customize JMeter using plugins or by writing custom code, allowing them to extend its functionality beyond what comes out of the box. The plugins can help us to work with services that use non-http protocols, such as AMQP and Websocket.

While JMeter provides a wide range of features and functions for load testing, there may be specific use cases or requirements that aren't covered by the built-in functionality.
By developing custom plugins, testers can add new functionality or customize existing features to better suit their needs. For example, a custom plugin could be developed to simulate a specific type of user behavior or to generate more realistic test data. Additionally, custom plugins can be developed to integrate JMeter with other tools or systems, such as logging and reporting tools or continuous integration and deployment pipelines. The custom plugins can help streamline the testing process and make it easier to incorporate load testing into the overall software development workflow. Overall, they allow testers to tailor JMeter to their specific needs and improve the accuracy and effectiveness of their load testing efforts.

## Sample of Architecture used for Load Testing

In order to perform load testing, you need to have a test plan, which is a set of instructions that tell JMeter what to do during the test. The test plan can include multiple test scenarios, each with different settings and configurations. For example, you might have one scenario that simulates a single user accessing a web application, and another scenario that simulates multiple users simultaneously accessing the same application. The test plan can also include multiple test cases, each with different settings and configurations. In our case, we assume that there is a device that is reporting temperature and humidity in a period of time. The device is sending the data to an Azure Event Hub. The Azure Function is triggered by Azure Event Hubs and is responsible for processing the data and then sending data to other downstream services such as Azure SQL Database or Azure Digital Twins. The Azure Function is the service that we want to test. The test plan is designed to simulate the behavior of the device and send data to the Event Hub.

:::image type="content" source="images/load-testing-architecture.png" alt-text="Sample Architecture for load testing." border="false":::

## Custom Plugins

Custom plugins in the context of JMeter are software components that can be added to JMeter to extend its functionality beyond what comes out of the box. Users or third-party developers can develop custom plugins to add new features, functions, or integrations to JMeter. Custom plugins can be developed using Java programming language and the JMeter Plugin Development Kit (PDK). The PDK provides a set of tools and APIs that make it easier to create new plugins, including GUI elements, listeners, and samplers.
Custom plugins can add a wide range of functionality to JMeter, such as new load testing samplers, visualizers, and listeners. They can also integrate JMeter with other systems, such as logging and reporting tools, or enable the use of other data sources for test data.

Azure Event Hubs is a cloud-based event processing service that can be used to collect, process, and analyze events and streaming data from various sources in real-time. Azure Event Hubs supports multiple protocols, including: AMQP (Advanced Message Queuing Protocol), HTTPS, Kafka Protocol, MQTT (Message Queuing Telemetry Transport) and AMQP over WebSockets. Choosing the right protocol depends on several factors, including the type of data you're working with, the specific requirements of your application, and the capabilities and limitations of the protocols themselves. If the protocol you're using to interact with Azure Event Hubs isn't supported by JMeter, you may still be able to perform load testing using JMeter with the help of a custom JMeter plugin and Azure Event Hubs SDK.

To implement a custom sampler for Event hubs in JMeter, follow the instruction provided [here](https://github.com/Azure-Samples/load-testing-jmeter-plugins#how-to-setup-visual-studio-code-for-eventhub-plugin-development). Once your custom sampler is implemented, you can use it in your JMeter test plan in Azure Load Test just like any other sampler. You can add it to a Thread Group, set its parameters, and configure it as needed. Custom samplers can be powerful tools in JMeter, allowing you to simulate complex scenarios and requests that aren't supported by the built-in samplers.

## Create an Apache JMeter script with custom plugin

In this section, you create a sample JMeter test script to load test an application with Event Hubs.

To create a sample JMeter test script:

1. Create a *SampleTest.jmx* file on your local machine:

```bash
touch LoadTest.jmx
```

1. Open *LoadTest.jmx* in a text editor and paste the following code snippet in the file:

    This script simulates a load test of 36 virtual machines that simultaneously send events to an Event hub, and takes 10 minutes to complete.

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

The implementation of `com.microsoft.eventhubplugin.EventHubPluginGui` and `com.microsoft.eventhubplugin.EventHubPlugin` are available [here](https://github.com/Azure-Samples/load-testing-jmeter-plugins).

1. In the file, set the value of the `eventHubConnectionVarName` node to the variable name that specifies Event Hubs connection string host. For example, if you want the environment variable that stores the connection string of Event Hubs to be `EventHubConnectionString`, set this variable to `EventHubConnectionString` and then set the value of environmental variable.

    > [!IMPORTANT]
    > Make sure the value of `EventHubConnectionString` has been set as a part of Azure load test creation process before running the load test script.
1. In the file, set the value of the `eventHubName` node to the event hub name. For example, `telemetry-data-changed-eh`.
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

In this example, the payload for the event hub message is a json object with three properties including `MachineId`, `Temperture` and `Humidity` where `MachineId` is a randomly generated ID with the length of 27, `Temperature` and `Humidity` is a random integer less than 100. This file is a liquid template syntax. Liquid template is a popular templating language that is used in various web development frameworks. Liquid templates enable developers to create dynamic content that can be easily updated and modified. They allow you to insert variables, conditions, loops, and other dynamic elements into your Event hub messages. The syntax is straightforward, and there are plenty of online resources available to help you get started. Overall, Liquid templates offer a powerful and flexible way to create dynamic, customizable messages.

1. Save and close the file.

    > [!IMPORTANT]
    > Don't include any personal data in the sampler name in the JMeter script. The sampler names appear in the Azure Load Testing test results dashboard. A sample of a liquid template along with the JMeter script file is available to download [here](https://github.com/Azure-Samples/load-testing-jmeter-plugins/tree/main/samples/eventhubplugin)

## Run the load test using new plugin

When Azure Load Testing starts your load test, it first deploys the JMeter script along with all other files onto test engine instances, and then start the load test as instructed [here](https://learn.microsoft.com/en-us/azure/load-testing/how-to-use-jmeter-plugins?tabs=portal).
Before running the test, go to the parameter tab, define `EventHubConnectionString` and then provide the connection string to Event Hub.

:::image type="content" source="images/load-testing-configuration-parameters.png" alt-text="Screenshot that shows the parameters of the test." :::

## Performance Testing Setup for Environment

In any performance testing, it is important to have a similar environment to the production environment. In this example, the following environment is used for performance testing in order to better understand the system capacity and the performance of the system.

As per the sample architecture, the following services could be used for performance testing:

| Service | Configuration |
| ----------- | ----------- |
| Eventhub | Premium with 1 PU. |
| Azure Function | Linux with Premium Plan (EP1) - 210 ACU, 3.5 GB Memory and 1 vCPU equivalent Standard_D1_v2 |
| Region | West US 2 |

Note than choosing of a service tier for any Azure services including Azure Event Hubs and Azure Functions is a complex process and depends on many factors. For more information, see [Azure Event Hubs pricing](https://azure.microsoft.com/en-us/pricing/details/event-hubs/) and [Azure Functions pricing](https://azure.microsoft.com/en-us/pricing/details/functions/).


## Designing KPIs for Performance Testing

In order to design KPIs for performance testing, you need to understand the business requirements and the system architecture. The business requirements are the key performance indicators (KPIs) that you need to measure. The system architecture is the foundation for the performance testing strategy. It defines the components that you need to test and the performance testing approach for each component.

In this example, the business requirements are:

- The system should be able to handle 1000 requests per second.
- The system reliability should be higher than 0.99.
- The system should be able to handle 1000 concurrent devices reporting their telemetry information.
- What is the maximum capacity of the system in terms of the number of devices that can be supported?

As per these requirements, the KPIs for performance testing could be:

| KPI | Description |
| ----------- | ----------- |
| RPS |  Request Per Second for Eventhub  |
| LOAD |  Number of loads/requests sent to Eventhub during performance testing |
| IR | Number of function executions or ingestion rate |
| RT | Average time for Azure Function Execution Time |
| AMU | Average Memory Usage for Azure Functions |
| SR | Success Rate of all function executions |
| ARS | Average Downstream Service Response Time (e.g. Sql server or a microservice) |
| DF | Dependency Failure count including internal Azure function errors |
| MRPS | Maximum RPS with no Backlog in Eventhub (System Capacity) |

### How to measure KPIs

In order to measure KPIs, you need to have a performance testing strategy. The strategy defines the performance testing approach for each component. In this example, the following performance testing strategy is used:

- Eventhub: The performance testing approach for Eventhub is to send a number of messages to Eventhub and then measure the RPS and LOAD. The RPS is the number of messages that are sent to Eventhub per second. The LOAD is the total number of messages that are sent to Eventhub during the performance testing. The RPS and LOAD are measured by the Azure Load Testing service.
- Azure Function: The performance testing approach for Azure Function is to measure the IR, RT, AMU and SR. The IR is the number of function executions or ingestion rate. The RT is the average time for Azure Function Execution Time. The AMU is the average memory usage for Azure Functions. The SR is the success rate of all function executions. The ARS is the average downstream service response time. The DF is the dependency failure count including internal Azure function errors. The IR, RT and SR are measured by the Azure Monitor service. The AMU, ARS and DF are measured by the Azure Load Test service.

In order to measure KPIs using Azure Monitor service, we need to enable Application Insights for Azure Functions. For more information, see [Enable Application Insights for Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring?tabs=cmd#enable-application-insights).

After enabling Azure Monitor service, you can use the following queries to measure KPIs:

- IR: `FunctionAppLogs | where Category startswith "your-function-name" and Message startswith "Executed" | summarize count() by FunctionName, Level Aggregate by hour | order by FunctionName desc`
- RT: `FunctionAppLogs\n| where Category startswith "your-function-name" and Message startswith "Executed "| parse Message with "Executed " Name " ("  Result ", Id=" Id ", Duration=" Duration:long "ms)\n| project  TimeGenerated, Message, FunctionName, Result, FunctionInvocationId, Duration\n`
- SR: `FunctionAppLogs\n| where Category startswith "Function." and Message startswith "Executed" | summarize Success=countif(Level == "Information" ), Total=count() by FunctionName| extend Result=Success*1.0/Total| project FunctionName, Result| order by FunctionName desc`

