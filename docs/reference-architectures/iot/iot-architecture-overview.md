---
  title: Getting started
  titleSuffix: Azure Reference Architectures
  description: An overview of Azure IoT architectures.  Learn basic concepts around getting started with Azure IoT, how to get started building an IoT solution, or understand how to optimize an IoT solution for production.
  author: mcosner
  manager: lizross
  ms.service: architecture-center
  ms.subservice: reference-architecture
  ms.topic: conceptual
  ms.date: 9/01/2021
  ms.author: mcosner
  ms.category:
    - iot
  ms.custom:
    - internal-intro
  categories:
    - iot
  products:
    - azure-iot-hub

---

# Getting started with Azure IoT Solutions

IoT (Internet of Things) is a collection of managed and platform services that connect and control IoT assets. For example, consider an industrial motor connected to the cloud. The motor collects and sends temperature data. This data is used to evaluate whether the motor is performing as expected. This information can then be used to prioritize a maintenance schedule for the motor.

Azure IoT supports a large range of devices, including industrial equipment, microcontrollers, sensors, and so on. When connected to the cloud, these devices can send data to your IoT solution. The data can then be processed to gain insights about the device. You can use these insights to monitor, manage, and control your environment.

> [!div class="nextstepaction"]
> [IoT solution concepts](/azure/architecture/example-scenario/iot/introduction-to-solutions)

## Learn about Azure IoT

If you are interested in learning about Azure IoT concepts in detail using a sandbox subscription, see the Introduction to Azure IoT. This is a five hour learning path that consists of eight training modules.

> [!div class="nextstepaction"]
> [Introduction to Azure IoT](/learn/paths/introduction-to-azure-iot)

## Decide Between SaaS and PaaS solutions

Microsoft enables you to create an IoT solution using PaaS services or a SaaS application. PaaS (platform as a service) is a cloud computing model in which Microsoft delivers Azure hardware and software tools over the internet, enabling you to create solutions from individual services. SaaS (software as a service) is a software distribution model in which Microsoft makes Azure applications available to customers over the internet.

Microsoft has a fully managed, enterprise-ready SaaS offering named **Azure IoT Central**.  We recommend this as a starting point for all customers. Using **Azure IoT Central**, you can quickly deploy a new application, connect physical or simulated devices, and customize the application to your specific requirements.

> [!div class="nextstepaction"]
> [Azure IoT Central](/azure/iot-central/core/overview-iot-central)

Microsoft also also enables you to build solutions using Azure PaaS components. You can use these to connect and provision things, analyze the insights they collect , and take action about those insights. For more information, see the recommended IoT reference architecture.

> [!div class="nextstepaction"]
> [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot)

## Design an IoT Architecture

A standard IoT solution architecture consists of five basic elements.

* **Devices** consist of industrial equipment, sensors, and microcontrollers that connect with the cloud to send and receive data.
* **Provisioning** connects the devices to the cloud.
* **Processing** analyzes data from devices to gather insights.
* **Business integration** performs actions based on insights from the device data.
* **Security monitoring** provides an end-to-end security solution for IoT workloads. Use Azure Defender for IoT.

These fundamentals exist whether you are using a PaaS or a SaaS solution. However, the Saas solution offered by Microsoft, [Azure IoT Central](/azure/iot-central/core/overview-iot-central), abstracts many of the technical choices and allows you to focus exclusively on your solution. For more detailed information about the recommended architecture for PaaS solutions, see the following article.

> [!div class="nextstepaction"]
> [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot)

## Monitor and optimize your Azure IoT solution

You can use the insights gathered from your device data to monitor, manage, and control your environment. You can use services such as **Power BI** to visualize and inspect your data or services such as **Azure Logic Apps** and **Microsoft Flow** to set up automated actions.

> [!div class="nextstepaction"]
> [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot)

## Additional Resources

* [Azure IoT documentation](/azure/iot-fundamentals)
* [Azure IoT Central documentation](/azure/iot-central)
* [Azure IoT Hub](/azure/iot-hub)
* [Azure IoT Hub Device Provisioning Service](/azure/iot-dps)
* [Azure IoT Edge documentation](/azure/iot-edge)
