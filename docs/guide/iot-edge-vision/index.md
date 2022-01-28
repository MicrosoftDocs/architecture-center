---
title: Computer vision with Azure IoT Edge
titleSuffix: Azure Architecture Center
description: Create an AI solution using Azure IoT Edge Vision. Explore camera recommendations, hardware acceleration, machine learning, image storage, alerts, and UI.
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

# Video analytics with Azure IoT Edge

This series of articles describes how to build a computer vision workload that uses Azure IoT Edge devices.

Visually inspecting products, resources, and environments is an important activity for many enterprises. Visual inspection and analytics was a manual process until recently. But due to human limitations, manually inspecting assets or the environment can be inefficient and inaccurate. To improve visual inspection and analysis, enterprises now use deep learning artificial neural networks called *convolutional neural networks* (CNNs) that emulate human vision. Using CNNs for image analytics is commonly called *computer vision* or *vision AI*.

## Potential use cases

Use cases for image AI span manufacturing, retail, healthcare, and the public sector. Examples include:

Quality assurance: In manufacturing environments, vision AI can inspect parts and processes fast and accurately. Automating product inspection can answer questions like:

- Is the manufacturing process consistent?
- Is the product assembled properly?
- Can there be earlier notification of defects?
- Is there drift in the computer vision model that requires predictive maintenance changes?

Safety: Automated video feed monitoring can scan for potential safety issues. Automated monitoring provides more time to respond to incidents, and more opportunities to reduce risk. Automated safety monitoring can answer questions like:

- Is the workforce compliant with using personal protective equipment?
- Are people entering unauthorized work zones?
- Are products stored safely?
- Are there unreported close calls or pedestrian-equipment near-misses?

## Computer vision on the edge

Cloud-native technologies like containerization encourage portability and migration of computer vision technology toward the network edge. You can train vision inference models in the cloud, containerize them, and use them in Azure IoT Edge runtime-enabled devices.

Reasons to migrate computer vision workloads from the cloud to the edge include performance and cost.

Performance:

- Exporting large quantities of data to the cloud can strain network infrastructure and cause performance issues.
- Sending images or video streams to the cloud to retrieve results can cause unacceptable latency. For example, a person entering an unauthorized area might require immediate intervention. Positioning the scoring model near the data ingestion point allows near real-time image scoring.
- Fast results allow alerting either locally or through the cloud, depending on network topology.

Cost:

- Sending all of the data to the cloud for analysis could significantly impact the return on investment (ROI) of a computer vision initiative.
- You can design IoT Edge vision modules to capture only relevant images, based on the scoring. Sending only relevant images significantly limits the amount of data going to the cloud.

## Computer vision edge components and considerations

The following articles describe components and considerations for designing an IoT Edge computer vision solution:

- The *camera* is an important component of an IoT Edge vision solution. To learn about camera considerations, see [Camera selection for Azure IoT Edge vision AI](./camera.md).
- The edge *hardware* must be able to run the powerful AI algorithms. For the hardware acceleration capabilities IoT Edge vision AI requires, see [Hardware acceleration in Azure IoT Edge vision AI](./hardware.md).
- *Machine learning* can be challenging on edge devices because of resource restrictions, limited energy budget, and low compute capabilities. For key considerations in designing machine learning for IoT Edge vision AI, see [Machine learning and data science in Azure IoT Edge vision AI](./machine-learning.md).
- Carefully consider *image storage* for your IoT Edge vision AI solution. For more information, see [Image storage and management in Azure IoT Edge vision AI](./image-storage.md).
- IoT Edge devices might need to respond to *alerts* in the environment. For best practices in managing alerts, see [Alert persistence in Azure IoT Edge vision AI](./alerts.md).
- The *user interface* (UI) of an IoT Edge computer vision solution varies based on the target user. For UI considerations, see [User interface in Azure IoT Edge vision AI](./user-interface.md).

## Next steps

- [Azure IoT Edge documentation](/azure/iot-edge/)
- [Tutorial: Perform image classification at the edge with Custom Vision Service](/azure/iot-edge/tutorial-deploy-custom-vision)
- [Azure Machine Learning documentation](/azure/machine-learning/)
- [Azure Kinect DK documentation](/azure/kinect-dk/)
- [MMdnn tool](https://github.com/Microsoft/MMdnn)
- [ONNX](https://onnx.ai/)

## Related resources

- [Getting started with Azure IoT solutions](/azure/architecture/reference-architectures/iot/iot-architecture-overview)
- [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot)
- [End-to-end manufacturing using computer vision on the edge](/azure/architecture/reference-architectures/ai/end-to-end-smart-factory)
- [Connected factory hierarchy service](/azure/architecture/solution-ideas/articles/connected-factory-hierarchy-service)
- [Connected factory signal pipeline](/azure/architecture/example-scenario/iot/connected-factory-signal-pipeline)
- [Create smart places by using Azure Digital Twins](/azure/architecture/example-scenario/iot/smart-places)
