---
  title: Getting started with Azure IoT solutions
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
    - azure-iot-central

---

# Getting started with Azure IoT solutions

IoT (Internet of Things) is a collection of managed and platform services that connect and control IoT assets. For example, consider an industrial motor connected to the cloud. The motor collects and sends temperature data. This data is used to evaluate whether the motor is performing as expected. This information can then be used to prioritize a maintenance schedule for the motor.

Azure IoT supports a large range of devices, including industrial equipment, microcontrollers, sensors, and so on. When connected to the cloud, these devices can send data to your IoT solution. The data can then be processed to gain insights about the device. You can use these insights to monitor, manage, and control your environment.

> [!div class="nextstepaction"]
> [IoT solution concepts](../../example-scenario/iot/introduction-to-solutions.yml)

## Learn about Azure IoT

If you are interested in learning about Azure IoT concepts in detail using a sandbox subscription, see the Introduction to Azure IoT. This is a five hour learning path that consists of eight training modules.

> [!div class="nextstepaction"]
> [Introduction to Azure IoT](/learn/paths/introduction-to-azure-iot)

## Understanding PaaS vs. aPaaS solutions

Microsoft enables you to create an IoT solution by using individual PaaS services or in an aPaaS IoT solution platform. PaaS (platform as a service) is a cloud computing model in which Microsoft delivers Azure hardware and software tools tailored to a specific task or job function. With PaaS services you are responsible for scaling and configuration, but the underlying infrastructure as a service (IaaS) is taken care of for you. aPaaS (application platform as a service) provides a cloud environment to build, manage, and deliver applications to customers. aPaaS offerings take care of scaling and most of the configuration, but still require developer input to build out a finished solution. 

## Start with Azure IoT Central (aPaaS)

Microsoft has an aPaaS IoT solution platform named **Azure IoT Central**. We recommend this as a starting point for all customers. It is designed to simplify and accelerate IoT solution assembly and operations by preassembling PaaS services from the IoT Platform, and across Azure, needed to build enterprise grade IoT solutions. The result is an out-of-the-box and ready to use UX and API surface area complete with the capabilities needed to connect, manage, and operate fleets of devices at scale. 

> [!div class="nextstepaction"]
> [Azure IoT Central](/azure/iot-central/core/overview-iot-central)

Microsoft also enables you to build solutions using a collection of Azure PaaS components. You can use these to connect and provision things, analyze the insights they collect, and act influenced by those insights. 

Compare IoT Central (aPaaS) to an Azure PaaS solution approach based on your solution needs.

> [!div class="nextstepaction"]
> [Compare solution approaches](/azure/architecture/example-scenario/iot/iot-central-iot-hub-cheat-sheet)

## Design an IoT architecture

A standard IoT solution architecture consists of five basic elements:

* **Devices** consist of industrial equipment, sensors, and microcontrollers that connect with the cloud to send and receive data.
* **Provisioning** connects the devices to the cloud.
* **Processing** analyzes data from devices to gather insights.
* **Business integration** performs actions based on insights from the device data.
* **Security monitoring** provides an end-to-end security solution for IoT workloads. Use Azure Defender for IoT.

These fundamentals exist whether you are using a PaaS or aPaaS solution.  However, we recommend all customers start with the aPaaS solution offered by Microsoft, [Azure IoT Central](/azure/iot-central/core/overview-iot-central). Its out-of-the-box UX and API surface simplify device connectivity, operations, and management so that you can spend more time and budget using IoT data to create business value. 


> [!div class="nextstepaction"]
> [Azure IoT reference architecture](../iot.yml)
> [!div class="nextstepaction"]
> [Azure IoT Central architecture](/azure/iot-central/core/concepts-architecture)

## Monitor and optimize your Azure IoT solution

You can use the insights gathered from your device data to monitor, manage, and control your environment. You can use services such as **Power BI** to visualize and inspect your data or services such as **Azure Logic Apps** and **Microsoft Flow** to set up automated actions.

## Next steps

* [Azure IoT documentation](/azure/iot-fundamentals)
* [Azure IoT Central documentation](/azure/iot-central)
* [Azure IoT Hub](/azure/iot-hub)
* [Azure IoT Hub Device Provisioning Service](/azure/iot-dps)
* [Azure IoT Edge documentation](/azure/iot-edge)

## Related resources

See the related IoT architecture guides:

* [IoT solutions conceptual overview](../../example-scenario/iot/introduction-to-solutions.yml)
* [Choose an Internet of Things (IoT) solution in Azure](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet.md)
* [Vision with Azure IoT Edge](../../guide/iot-edge-vision/index.md)
* [Azure Industrial IoT Analytics Guidance](../../guide/iiot-guidance/iiot-architecture.md)

See the related IoT reference architectures and example scenarios:

* [Azure IoT reference architecture](../iot.yml)
* [End-to-end manufacturing using computer vision on the edge](../ai/end-to-end-smart-factory.yml)
* [IoT and data analytics](../../example-scenario/data/big-data-with-iot.yml)
* [IoT using Cosmos DB](../../solution-ideas/articles/iot-using-cosmos-db.yml)
* [Retail - Buy online, pickup in store (BOPIS)](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml)
* [Predictive maintenance with the intelligent IoT Edge](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml)

See the related IoT solution ideas:

* [Condition Monitoring for Industrial IoT](../../solution-ideas/articles/condition-monitoring.yml)
* [Contactless IoT interfaces with Azure intelligent edge](../../solution-ideas/articles/contactless-interfaces.yml)
* [COVID-19 safe environments with IoT Edge monitoring and alerting](../../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)
* [Environment monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml)
* [IoT connected light, power, and internet for emerging markets](../../solution-ideas/articles/iot-power-management.yml)
* [UVEN smart and secure disinfection and lighting](../../solution-ideas/articles/uven-disinfection.yml)
* [Mining equipment monitoring](../../solution-ideas/articles/monitor-mining-equipment.yml)
* [Predictive Maintenance for Industrial IoT](../../solution-ideas/articles/iot-predictive-maintenance.yml)
* [Process real-time vehicle data using IoT](../../example-scenario/data/realtime-analytics-vehicle-iot.yml)
* [Cognizant Safe Buildings with IoT and Azure](../../solution-ideas/articles/safe-buildings.yml)