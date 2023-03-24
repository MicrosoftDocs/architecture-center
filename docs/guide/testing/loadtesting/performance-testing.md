---
title: Extending Azure Load Testing using Custom Plugins
description: Guide on developing a custom plugin for Azure Load Test
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
# Extending Azure Load Testing using Custom Plugins

Azure Load Testing enables you to take an existing Apache JMeter script, and use it to run a load test at cloud scale on any Azure resources.
JMeter is a popular open-source load testing tool that is primarily used to test the performance of web applications. It was originally developed for testing web applications, but it can also be used to test other types of applications, such as SOAP and REST web services, FTP servers, databases, and more.
JMeter allows testers to create and execute load tests, stress tests, and functional tests. It simulates multiple users simultaneously accessing a web application, enabling testers to identify potential performance bottlenecks or other issues that might arise under heavy loads. JMeter can be used to measure a variety of performance metrics, such as response time, throughput, and error rate.
JMeter uses a GUI-based interface to allow users to create test plans, which can include multiple test scenarios, each with different settings and configurations. Testers can also customize JMeter using plugins or by writing custom code, allowing them to extend its functionality beyond what comes out of the box. The plugins can help us to work with services that use non-http protocols, such as AMQP and Websocket.
While JMeter provides a wide range of features and functions for load testing, there may be specific use cases or requirements that are not covered by the built-in functionality.
By developing custom plugins, testers can add new functionality or customize existing features to better suit their needs. For example, a custom plugin could be developed to simulate a specific type of user behavior or to generate more realistic test data. Additionally, custom plugins can be developed to integrate JMeter with other tools or systems, such as logging and reporting tools or continuous integration and deployment pipelines. This can help streamline the testing process and make it easier to incorporate load testing into the overall software development workflow. Overall, custom plugins allow testers to tailor JMeter to their specific needs and improve the accuracy and effectiveness of their load testing efforts.

## Custom Plugins

Custom plugins in the context of JMeter are additional software components that can be added to JMeter to extend its functionality beyond what comes out of the box. Custom plugins can be developed by users or third-party developers to add new features, functions, or integrations to JMeter. Custom plugins can be developed using Java programming language and the JMeter Plugin Development Kit (PDK). The PDK provides a set of tools and APIs that make it easier to create new plugins, including GUI elements, listeners, and samplers.
Custom plugins can add a wide range of functionality to JMeter, such as new load testing samplers, visualizers, and listeners. They can also integrate JMeter with other systems, such as logging and reporting tools, or enable the use of additional data sources for test data.

## Develop a new custom plugin for Event Hubs

Azure Event Hubs is a cloud-based event processing service that can be used to collect, process, and analyze events and telemetry data from various sources in real-time. Azure Event Hubs supports multiple protocols, including: AMQP (Advanced Message Queuing Protocol), HTTPS, Kafka Protocol, MQTT (Message Queuing Telemetry Transport) and AMQP over WebSockets. Choosing the right protocol depends on several factors, including the type of data you are working with, the specific requirements of your application, and the capabilities and limitations of the protocols themselves. If the protocol you are using to interact with Azure Event Hubs is not supported by JMeter, you may still be able to perform load testing using JMeter with the help of a custom JMeter plugin and Azure Event Hubs SDK.

To implement a custom sampler for Event hubs in JMeter, you need to follow these steps:

1. Create a new Java class named `EventHubPlugin` that extends the AbstractSampler class provided by JMeter. This class should implement the Sampler interface, which includes methods for initializing and executing the sampler.

1. Define the input parameters that are required for the sampler. You can do this by creating instance variables in your class and adding them to the GUI using JMeter GUI Designer. Our custom plugin will have three input parameters as below:
    1. eventHubConnectionVarName: to specify the connection string variable name for event hub that can passed to the plugin using environmental variable or as Key Vault,
    1. eventHubName: event hub name in the event hub name space
    1. liquidTemplateFileName: location of a liquid template file which will be used by plugin to render the content of a payload to send to event hub.

1. Implement the sample() method to simulate the desired request. This method should perform the necessary operations required to simulate the request. In our case, it will be rendering a message as per a liquid template and then sending it to Event hub.

1. Build your custom sampler class into a JAR file and place as instructed [here](https://github.com/Azure-Samples/load-testing-jmeter-plugins#how-to-setup-visual-studio-code-for-eventhub-plugin-development)

1. Restart JMeter, and your custom Event hub sampler should now be available in the JMeter GUI. In order to setup Jmeter GUI, follow the instruction [here](https://github.com/Azure-Samples/load-testing-jmeter-plugins#how-to-setup-jmeter-in-gui-mode).

Once your custom sampler is implemented, you can use it in your JMeter test plan in Azure Load Test just like any other sampler. You can add it to a Thread Group, set its parameters, and configure it as needed. Custom samplers can be very powerful tools in JMeter, allowing you to simulate complex scenarios and requests that are not supported by the built-in samplers.

## Create an Apache JMeter script with custom plugin

In this section, you'll create a sample JMeter test script to load test an application with Event Hubs.

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

1. In the file, set the value of the `eventHubConnectionVarName` node to the variable name that specifies the Event hub connection string host. For example, if you want the environment variable that will be set to the connection string of the event hub to `EventHubConnectionString`, simply set this variable to `EventHubConnectionString` and then set the value of environmental variable.

    > [!IMPORTANT]
    > Make sure the value of `EventHubConnectionString` has been set as a part of Azure load test creation process before running the load test script.
1. In the file, set the value of the `eventHubName` node to the event hub name. For example, `telemetry-data-changed-eh`.
1. Set the value of the `liquidTemplateFileName` node to the file containing the message that will be sent to the event hub. For example, create a file named `StreamingDataTemplate.liquid` as below

```json
{
    {% assign numberOfMachines = 36 %}
    {% assign machineId = dataGenerator.randomNaturalNumber | modulo: numberOfMachines %}
    "MachineId": "{{machineId | prepend: '0000000000000000000000000000000000000000' | slice: -27, 27 }}"
    "Temperature": {{dataGenerator.randomInt | modulo: 100 }},
    "Humidity": {{dataGenerator.randomInt | modulo: 100 }}
}
```

In this example, the payload for the Event Hub message will be a json object with three properties including `MachineId`, `Temperture` and `Humidity` where `MachineId` will be a randomly generated id with the length of 27, `Temperature` and `Humidity` will be a random integer less than 100. The syntax of this file will be a liquid template. Liquid template is a popular templating language that is used in various web development frameworks. Liquid templates enable developers to create dynamic content that can be easily updated and modified. They allow you to insert variables, conditions, loops, and other dynamic elements into your Event hub messages. The syntax is straightforward, and there are plenty of online resources available to help you get started. Overall, Liquid templates offer a powerful and flexible way to create dynamic, customizable messages.

1. Save and close the file.

    > [!IMPORTANT]
    > Don't include any Personally Identifiable Information (PII) in the sampler name in the JMeter script. The sampler names appear in the Azure Load Testing test run results dashboard. A sample of a liquid template along with the JMeter script file is avaliable to download [here](https://github.com/Azure-Samples/load-testing-jmeter-plugins/tree/main/samples/eventhubplugin)

## Run the load test using new plugin

When Azure Load Testing starts your load test, it will first deploy the JMeter script along with all other files onto test engine instances, and then start the load test.

In order to run the JMeter script, you can follow the steps below: 

1. Go to your Load Testing resource, select **Tests** from the left pane, and then create a new test.

    :::image type="content" source="images/basic.png" alt-text="Screenshot that shows the test." :::

1. On the test plan tab, select and upload the JMeter script along with the liquid and JAR file containing the plugin. A pre-build JAR file for the Event hub sampler is available to download [here](https://github.com/Azure-Samples/load-testing-jmeter-plugins/blob/main/target/loadtestplugins-1.0.jar).

    :::image type="content" source="images/testplanuploaded.png" alt-text="Screenshot that shows the test plan page." :::

    > [!TIP]
    > The size for the JAR file should not be exceeded 10MB. If your file is larger than 10MB, you will need to split your JAR file to multiple files or try to use shaded version of your JAR file to minimize the file.

1. Create and then run and notice the test run details, statistics, and client metrics in the Azure portal.