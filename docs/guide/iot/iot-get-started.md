---
title: Get Started with IoT Architecture Design
description: Get started with IoT architecture design on Azure. Explore IoT technologies, guidance, solution ideas, and reference architectures.
author: anaharris-ms
ms.author: pnp
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: category-get-started
ms.date: 06/22/2026
ai-usage: ai-generated
---

# Get started with IoT architecture design

The Internet of Things (IoT) connects physical devices, sensors, and equipment to the cloud. By using IoT, organizations can collect operational data, automate processes, and gain real-time insights across industries such as manufacturing, energy, transportation, and smart buildings. Azure provides a comprehensive set of IoT services and capabilities to support both cloud-connected and edge-based solution patterns.

## Azure services for IoT

Azure provides a range of services for IoT architecture design:

- [Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub): Provides device-to-cloud messaging and device management.

- [Azure IoT Hub Device Provisioning Service](/azure/iot-dps/about-iot-dps): Provides provisioning for Azure IoT Hub.

- [Azure IoT Operations](/azure/iot-operations/overview-iot-operations): Provides a unified data plane that runs on Azure Arc-enabled Kubernetes clusters for edge-based systems.

- [MQTT broker feature in Event Grid](/azure/event-grid/mqtt-overview): Provides MQTT broker capabilities for scalable publish-subscribe messaging.

- [Azure Digital Twins](/azure/digital-twins/overview): Enables digital modeling of physical environments.

## Architecture

:::image type="complex" border="false" source="media/iot-get-started-diagram.svg" alt-text="Diagram that shows the IoT solution journey on Azure." lightbox="media/iot-get-started-diagram.svg":::
   The diagram has five vertical sections that represent layers of an IoT architecture. From left to right, the layer sections are: sensing, network, data ingestion, data processing, and application and presentation. The sensing layer contains IoT sensors, industrial endpoints, edge devices, and cameras and actuators. The network layer contains Azure IoT Edge and Azure IoT Operations. The data ingestion layer contains Azure IoT Hub, Azure Event Hubs, and Azure Event Grid. The data processing layer contains Azure Databricks, Azure Data Explorer, and Microsoft Fabric. The application and presentation layer contains Power BI, a mobile application, and a dashboard. Arrows connect the sections from left to right to show the data flow through the architecture. The last arrow on the right points left from the application and presentation layer to the data processing layer.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/iot-get-started-diagram.vsdx) of this architecture.*

The previous diagram demonstrates a typical basic or baseline IoT implementation. For real-world solutions that you can build in Azure, see [IoT architectures](#iot-architectures).

## Explore IoT guides, architectures, and solution ideas

The articles in this section include guides and fully developed architectures that you can deploy in Azure and expand to production-grade solutions. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your IoT proof-of-concept (POC) development. These articles can help you decide how to use IoT technologies in Azure.

### IoT guides

The following articles help you evaluate and select the best IoT technologies for your workload requirements:

- [Choose an Azure IoT service](/azure/iot/iot-services-and-technologies): Compare Azure IoT services and technologies, including Azure IoT Hub, Azure IoT Operations, Azure IoT Edge, and Azure IoT Central, to choose the right solution type.

- [Connect IoT devices to Azure](/azure/iot-hub/iot-hub-compare-event-hubs): Compare Azure IoT Hub and Azure Event Hubs to choose the right ingestion service for your device connectivity and data streaming requirements.

- [Choose a stream processing technology in Azure](../../data-guide/technology-choices/stream-processing.md): Evaluate technologies for real-time IoT telemetry pipelines. Options include Azure Stream Analytics, Azure Functions, and Azure Spark Structured Streaming.

- [Enable machine learning inference on Azure IoT Edge](machine-learning-inference-iot-edge.yml): Deploy machine learning models to Azure IoT Edge devices for local inference at the edge.

- [Scale your Azure IoT Hub solutions](scale-iot-solution-azure.md): Plan and implement scaling strategies for high-scale Azure IoT Hub deployments.

- [Move Azure IoT Hub solutions to production](../../example-scenario/iot/iot-move-to-production.md): Follow best practices for transitioning Azure IoT Hub solutions from development to production.

- [Multitenant Azure IoT Hub-based solutions](../multitenant/approaches/iot.md): Design multitenant IoT solutions by using Azure IoT Hub or Azure IoT Central with appropriate tenancy models.

### IoT architectures

The following production-ready architecture demonstrates end-to-end IoT solutions that you can deploy and customize:

- [Automotive test data analytics](../../industries/automotive/automotive-telemetry-analytics.yml): Analyze automotive telemetry data by using an IoT-based architecture on Azure.

### IoT solution ideas

The following IoT solution ideas demonstrate implementation patterns and possibilities to explore:

- [Azure Load Testing for Azure IoT Hub](../testing/load-testing/load-testing-with-custom-plugins.md): Use Azure Load Testing with custom plugins to simulate IoT device traffic against Azure IoT Hub.

- [Azure IoT Hub analytics with Azure Data Explorer](../../solution-ideas/articles/iot-azure-data-explorer.yml): Use Azure Data Explorer to provide near real-time analytics on fast-flowing, high-volume streaming data from IoT devices.

- [Azure IoT Hub private file upload to Azure Storage](../../example-scenario/iot/iot-private-file-upload.yml): Use a private network to securely upload files from IoT devices to an Azure Storage account.

## Organizational readiness

Organizations at the beginning of the cloud adoption process can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption.

To help ensure the quality of your IoT solution on Azure, follow the guidance in the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions.

## Best practices

Follow these best practices to improve the security, reliability, performance, and operational quality of your IoT workloads on Azure.

- [Secure your IoT solutions](/azure/iot/iot-overview-security): Review comprehensive security guidance for cloud-connected and edge-connected IoT solutions. The guidance covers device security, connection security, and cloud security.

- [Secure your Azure IoT Hub deployment](/azure/iot-hub/secure-azure-iot-hub): Follow Azure IoT Hub-specific security best practices for network security, device security, and data protection.

- [Best practices for device configuration within an IoT solution](/azure/iot-hub/iot-hub-configuration-best-practices): Implement device management best practices for hardware manufacturers, solution developers, and solution operators by using automatic device configurations.

- [Best practices for large-scale IoT device deployments](/azure/iot-dps/concepts-deploy-at-scale): Design Azure IoT Hub Device Provisioning Service deployments that scale to millions of devices by following recommended patterns for provisioning and enrollment.

- [Security practices for Azure IoT device manufacturers](/azure/iot-dps/concepts-device-oem-security-practices): Select device authentication options and implement secure manufacturing processes for IoT devices used with Azure IoT Hub Device Provisioning Service.

- [Device implementation and best practices for Azure IoT Central](/azure/iot-central/core/concepts-device-implementation): Implement devices that connect to Azure IoT Central. Topics include provisioning, failover handling, and high-availability patterns.

- [Scale your Azure IoT Hub solutions](scale-iot-solution-azure.md): Plan and implement scaling strategies for high-scale Azure IoT Hub deployments.

- [Move Azure IoT Hub solutions to production](../../example-scenario/iot/iot-move-to-production.md): Follow best practices for transitioning Azure IoT Hub solutions from development to production.

- [Production deployment guidelines for Azure IoT Operations](/azure/iot-operations/deploy-iot-ops/concept-production-guidelines): Review requirements and recommendations for deploying Azure IoT Operations to a production edge environment.

- [Enable secure settings in Azure IoT Operations](/azure/iot-operations/secure-iot-ops/howto-enable-secure-settings): Configure secure settings, including secrets management and user-assigned managed identities, for Azure IoT Operations deployments.

## Stay current with IoT

Azure IoT services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key IoT services, see the following articles:

- [What's new in Azure IoT Hub?](/azure/iot-hub/iot-hub-what-is-new)
- [Azure Event Grid](/azure/event-grid/whats-new)

## Other resources

The following resources can help you discover more about IoT architecture design.

### Product documentation

Azure IoT product documentation provides comprehensive guidance for each service in the IoT portfolio, including setup, configuration, and operational best practices.

- [What's Azure IoT?](/azure/iot/iot-introduction): Understand the Azure IoT portfolio, including cloud-connected and edge-connected connectivity patterns, and how services like Azure IoT Hub, Azure IoT Operations, Azure Device Registry, and Microsoft Fabric work together.

- [Azure IoT Hub documentation](/azure/iot-hub/): Access the complete documentation for Azure IoT Hub, including device-to-cloud messaging, device management, and routing.

- [Azure IoT Operations documentation](/azure/iot-operations/): Explore the unified data plane for edge-connected IoT solutions that run on Azure Arc-enabled Kubernetes clusters.

- [Azure Digital Twins documentation](/azure/digital-twins/): Learn about modeling physical environments with digital representations and knowledge graphs.

- [Azure IoT Hub Device Provisioning Service documentation](/azure/iot-dps/): Learn about zero-touch device provisioning to Azure IoT Hub at scale.

### Device development

Develop IoT devices that connect to Azure by using SDKs, protocols, and development patterns for both cloud-connected and edge-connected solutions.

- [IoT device development overview](/azure/iot/iot-overview-device-development): Learn about device types, SDKs, connectivity protocols, and development patterns for both cloud-connected and edge-connected IoT solutions.

- [Choose an Azure IoT service](/azure/iot/iot-services-and-technologies): Compare Azure IoT services and technologies to select the right components for your solution.

### Industrial IoT scenarios

Industrial IoT solutions connect OT systems to cloud analytics and management platforms for industrial and manufacturing IoT implementations.

- [Implement the Azure industrial IoT reference solution architecture](/azure/iot/tutorial-iot-industrial-solution-architecture): Deploy an end-to-end industrial IoT solution by using Azure IoT Operations, [Azure Data Explorer](/azure/data-explorer/data-explorer-overview), and OPC UA for manufacturing scenarios such as condition monitoring, Overall Equipment Effectiveness (OEE) calculation, and anomaly detection.

### IoT security

Secure your IoT and OT environments by using unified security monitoring, threat detection, and vulnerability management for connected devices.

- [Microsoft Defender for IoT documentation](/azure/defender-for-iot/organizations/overview): Learn about unified security monitoring for IoT and OT devices, including agentless network monitoring and integration with security operations center tools.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure IoT options to other cloud services and provide migration guidance:

### Service comparison

- [Azure for AWS professionals](../../aws-professional/index.md#internet-of-things-iot)
- [Google Cloud to Azure services comparison - IoT](../../gcp-professional/services.md#iot)

### Migration guidance

If you're migrating from another cloud platform, see the following article:

- [Migrate workloads to Azure from other cloud platforms](/azure/migration/migrate-to-azure)
