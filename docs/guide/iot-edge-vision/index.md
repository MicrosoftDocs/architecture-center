---
title: Azure IoT Edge Vision
titleSuffix: Azure Architecture Center
description: Create an AI solution using Azure IoT Edge Vision. Explore camera recommendations, hardware acceleration, machine learning, image storage, alerts, and UI.
author: MSKeith
ms.author: keith
ms.date: 10/22/2020
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

# Vision with Azure IoT Edge

Visual inspection of products, resources, and environments has been a core practice for most enterprises, and was until recently, a very manual process. An individual, or a group of individuals, would be responsible for manually inspecting the assets or the environment. Depending on the circumstances, this could become inefficient, inaccurate, or both, due to human error and limitations.

To improve the efficacy of visual inspection, enterprises began turning to deep learning artificial neural networks known as *convolutional neural networks* (or CNNs), to emulate human vision for analysis of images and video. Today this is commonly called computer vision, or simply *Vision AI*. Artificial intelligence for image analytics spans a wide variety of industries, including manufacturing, retail, healthcare, and the public sector, and an equally wide area of use cases.

- **Vision for quality assurance:** In manufacturing environments, Vision AI can be very helpful with quality inspection of parts and processes with a high degree of accuracy and velocity. An enterprise pursuing this path automates the inspection of a product for defects to answer questions such as:

    - Is the manufacturing process producing consistent results?
    - Is the product assembled properly?
    - Can there be an earlier notification of a defect to reduce waste?
    - How to leverage drift in the computer vision model to prescribe predictive maintenance?

- **Vision for safety:** In any environment, safety is a fundamental concern for every enterprise, and the reduction of risk is a driving force for adopting Vision AI. Automated monitoring of video feeds to scan for potential safety issues provides critical time to respond to incidents, and opportunities to reduce exposure to risk. Enterprises looking at Vision AI for this use case are commonly trying to answer questions such as:

    - How compliant is the workforce with using personal protective equipment?
    - How often are people entering unauthorized work zones?
    - Are products being stored in a safe manner?
    - Are there unreported close calls in a facility, or pedestrian/equipment "near misses"?

## Why vision on the Edge

Over the past decade, computer vision has become a rapidly evolving area of focus for enterprises, as cloud-native technologies such as containerization, have enabled portability and migration of this technology towards the network edge. For instance, custom vision inference models trained in the cloud can be easily containerized for use in an Azure IoT Edge runtime-enabled device.

The rationale behind migrating workloads from the cloud to the edge for Vision AI generally falls into two categories – performance and cost.

On the performance side of the equation, exfiltrating large quantities of data can cause an unintended performance strain on existing network infrastructure. Additionally, the latency of sending images and/or video streams to the cloud to retrieve results may not meet the needs of the use case. For instance, a person straying into an unauthorized area may require immediate intervention, and that scenario can affect latency when every second counts. Positioning the inferencing model near the point of ingestion, allows for near real-time scoring of the image. It also allows alerting to be performed either locally or through the cloud, depending on the network topology.

In terms of cost, sending all of the data to the cloud for analysis could significantly impact the ROI or return on investment of a Vision AI initiative. With Azure IoT Edge, a Vision AI module can be designed to only capture the relevant images with a reasonable confidence level based on the scoring. This significantly limits the amount of data being sent.

## Camera considerations

Camera is understandably a very important component of an Azure IoT Edge Vision solution. To learn what considerations should be taken for this component, proceed to [Camera selection in Azure IoT Edge Vision](./camera.md).

## Hardware acceleration

To bring AI to the edge, the edge hardware should be able to run the powerful AI algorithms. To know the hardware capabilities required for IoT Edge Vision, proceed to [Hardware acceleration in Azure IoT Edge Vision](./hardware.md).

## Machine learning

Machine learning can be challenging for the data on the edge, due to resource restrictions of edge devices, limited energy budget, and low compute capabilities. See [Machine learning and data science in Azure IoT Edge Vision](./machine-learning.md) to understand the key considerations in designing the machine learning capabilities of your IoT Edge Vision solution.

## Image storage

Your IoT Edge Vision solution cannot be complete without careful consideration of how and where the images generated will be stored. Read [Image storage and management in Azure IoT Edge Vision](./image-storage.md) for a thorough discussion.

## Alerts

Your IoT Edge device may need to respond to various alerts in its environment. See [Alert persistence in Azure IoT Edge Vision](./alerts.md) to understand the best practices in managing these alerts.

## User interface

The user interface or UI of your IoT Edge Vision solution will vary based on the target user. The article [User interface in Azure IoT Edge Vision](./user-interface.md) discusses the main UI considerations.

## Next steps

This series of articles demonstrate how to build a complete vision workload using Azure IoT Edge devices. For further information, you may refer to the product documentation as following:

- [Azure IoT Edge documentation](/azure/iot-edge/)
- [Tutorial: Perform image classification at the edge with Custom Vision Service](/azure/iot-edge/tutorial-deploy-custom-vision)
- [Azure Machine Learning documentation](/azure/machine-learning/)
- [Azure Kinect DK documentation](/azure/kinect-dk/)
- [MMdnn tool](https://github.com/Microsoft/MMdnn)
- [ONNX](https://onnx.ai/)
