---
title: Computer vision with Azure IoT Edge
titleSuffix: Azure Architecture Center
description: Create an vision AI solution that uses Azure IoT Edge. Explore hardware recommendations, machine learning and storage requirements, alerting, and user interfaces.
author: MSKeith
ms.author: keith
ms.date: 01/27/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - fcp
products:
  - azure-iot-edge
ms.custom:
  - guide
---

# Vision AI solutions with Azure IoT Edge

This series of articles describes how to plan and design a computer vision workload with Azure IoT Edge. IoT Edge runtime devices and networks can integrate seamlessly with Azure Machine Learning, Azure Storage, and user interfaces like Power BI and Azure App Service.

Visually inspecting products, resources, and environments is an important process for many enterprises. Visual inspection and analytics were once manual processes. Human limitations made these processes potentially inefficient or inaccurate. Enterprises can now use deep learning artificial neural networks called *convolutional neural networks* (CNNs) to emulate human vision. Using CNNs for automated image input and analytics is commonly called *computer vision* or *vision AI*.

Internet of things (IoT) smart devices and networks can use vision AI solutions at the edge for optimal performance and cost savings. Cloud-native technologies like containerization support portability, and allow migrating computer vision technology to the network edge. You can train vision inference models in the cloud, containerize the models, and use them to create custom modules for Azure IoT Edge runtime-enabled devices.

## Use cases

Use cases for vision AI span manufacturing, retail, healthcare, and the public sector. Some typical use cases include:

### Quality assurance

In manufacturing environments, vision AI can inspect parts and processes fast and accurately. Automated quality inspection can:

- Monitor manufacturing process consistency.
- Check proper product assembly.
- Provide early defect notifications.
- Identify model drift that requires predictive maintenance changes.

### Safety and security

Automated visual monitoring can scan for potential safety and security issues. Automation can provide more time to respond to incidents, and more opportunities to reduce risk. For example, automated safety monitoring can:

- Track workforce compliance with personal protective equipment guidelines.
- Monitor entry into unauthorized work zones.
- Check proper product storage.
- Record unreported close calls or pedestrian-equipment near-misses.

## Considerations

Reasons to migrate computer vision workloads from the cloud to the edge include performance and cost.

### Performance considerations

- Exporting large quantities of data to the cloud can strain network infrastructure, causing performance issues.
- Retrieving results from the cloud can introduce unacceptable latency. For example, a person entering an unauthorized area might need immediate intervention. Positioning the scoring model near the data ingestion point allows near real-time image scoring.
- Alerting can happen locally or through the cloud, depending on network topology.

### Cost considerations

Sending all data to the cloud for analysis can significantly impact the return on investment (ROI) of a computer vision initiative. You can design IoT Edge vision modules to score image data and send only images considered relevant with a reasonable confidence level to the cloud. Sending only selected images significantly reduces the amount of data going to the cloud, lowering costs.

## Components and processes

Vision AI solutions for IoT Edge involve several components and processes. The following articles provide in-depth planning and design guidance for each area:

- Input camera. See [Camera selection for Azure IoT Edge vision AI](./camera.md).
- Edge hardware acceleration chips and processors. See [Hardware acceleration in Azure IoT Edge vision AI](./hardware.md).
- Training and machine learning for IoT Edge vision modules. See [Machine learning and data science in Azure IoT Edge vision AI](./machine-learning.md).
- Storing image data on IoT Edge devices and in the cloud. See [Image storage and management for Azure IoT Edge vision AI](./image-storage.md).
- Alerting for images that require attention. See [Alert persistence in Azure IoT Edge vision AI](./alerts.md).
- User interaction with the system. See [User interface in Azure IoT Edge vision AI](./user-interface.md).

## Next steps

To learn more about CNNs, vision AI, Azure Machine Learning, and Azure IoT Edge, see the following documentation:

- [Azure IoT Edge documentation](/azure/iot-edge/)
- [Azure Machine Learning documentation](/azure/machine-learning/)
- [Tutorial: Perform image classification at the edge with Custom Vision Service](/azure/iot-edge/tutorial-deploy-custom-vision)
- [What is Computer Vision?](/azure/cognitive-services/computer-vision/overview)
- [What is Azure Video Analyzer? (preview)](/azure/azure-video-analyzer/video-analyzer-docs/overview)
- [Azure Kinect DK developer kit documentation](/azure/kinect-dk/)
- [Open Neural Network Exchange (ONNX)](https://onnx.ai/)

## Related resources

For more computer vision architectures, examples, and ideas that use Azure IoT, see the following articles:

- [Getting started with Azure IoT solutions](/azure/architecture/reference-architectures/iot/iot-architecture-overview)
- [End-to-end manufacturing using computer vision on the edge](/azure/architecture/reference-architectures/ai/end-to-end-smart-factory)
- [Connected factory hierarchy service](/azure/architecture/solution-ideas/articles/connected-factory-hierarchy-service)
- [Connected factory signal pipeline](/azure/architecture/example-scenario/iot/connected-factory-signal-pipeline)
- [Create smart places by using Azure Digital Twins](/azure/architecture/example-scenario/iot/smart-places)
