---
title: Azure IoT Edge Vision
titleSuffix: Azure Architecture Center
description: These series of articles describe how to create an AI solution using Azure IoT Edge Vision.
author: MSKeith
ms.date: 10/12/2020
ms.topic: guide
ms.service: architecture-center
ms.author: kehilsch
ms.category:
  - fcp
ms.subservice: reference-architecture
---

# Vision with Azure IoT Edge

Visual inspection of products, resources, and environments has been a core practice for most enterprises, and was until recently, a very manual process. An individual, or a group of individuals, was responsible for performing a manual inspection of the asset or environment. Depending on the circumstances, this could become inefficient, inaccurate, or both, due to human error and limitations.

To improve the efficacy of visual inspection, enterprises began turning to deep learning artificial neural networks known as *convolutional neural networks* (or CNNs), to emulate human vision for analysis of images and video. Today this is commonly called computer vision, or simply *Vision AI*. Artificial intelligence for image analytics spans a wide variety of industries, including manufacturing, retail, healthcare, and the public sector, and an equally wide area of use cases.

- **Vision for quality assurance** - In manufacturing environments, Vision AI can be very helpful with quality inspection of parts and processes with a high degree of accuracy and velocity. An enterprise pursuing this path automates the inspection of a product for defects to answer questions such as:

    - Is the manufacturing process producing consistent results?
    - Is the product assembled properly?
    - Can I get notification of a defect sooner to reduce waste?
    - How can I leverage drift in my computer vision model to prescribe predictive maintenance?

- **Vision for safety** - In any environment, safety is a fundamental concern for every enterprise, and the reduction of risk is a driving force for adopting Vision AI. Automated monitoring of video feeds to scan for potential safety issues provides critical time to respond to incidents, and opportunities to reduce exposure to risk. Enterprises looking at Vision AI for this use case are commonly trying to answer questions such as:

    - How compliant is my workforce with using personal protective equipment?
    - How often are people entering unauthorized work zones?
    - Are products being stored in a safe manner?
    - Are there non-reported close calls in a facility, i.e. pedestrian/equipment “near misses?”

## Why vision on the Edge

Over the past decade, computer vision has become a rapidly evolving area of focus for Enterprises, as cloud-native technologies, such as containerization, have enabled portability and migration of this the technology toward the network edge. For instance, custom vision inference models trained in the Cloud can be easily containerized for use in an Azure IoT Edge runtime-enabled device.

The rationale behind migrating workloads from the cloud to the edge for Vision AI generally falls into two categories – performance and cost.

On the performance side of the equation, exfiltrating large quantities of data can cause an unintended performance strain on existing network infrastructure. Additionally, the latency of sending images and/or video streams to the Cloud to retrieve results may not meet the needs of the use case. For instance, a person straying into an unauthorized area may require immediate intervention, and that scenario can ill afford latency when every second counts. Positioning the inferencing model near the point of ingest allows for near-real time scoring of the image, and alerting can be performed either locally or through the cloud, depending on network topology.

In terms of cost, sending all of the data to the Cloud for analysis could significantly impact the ROI of a Vision AI initiative. With Azure IoT Edge, a Vision AI module could be designed to only capture the relevant images that have a reasonable confidence level based on the scoring, which significantly limits 
the amount of data being sent.

## Camera considerations

Camera is understandably the most important component of an Azure IoT Edge Vision solution. To learn what considerations should be taken for this component, see [Camera selection in Azure IoT Edge Vision](./iot-edge-camera.md).

## Hardware acceleration

When bringing AI to the edge, hardware should be able to run the powerful AI algorithms. To know the hardware capabilities required for IoT Edge Vision, see [Hardware acceleration in Azure IoT Edge Vision](./iot-edge-hardware.md).

## Machine learning

Machine learning can be challenging for the data on edge devices. See [Machine learning and data science in Azure IoT Edge Vision](./iot-edge-machine-learning.md) to understand the key considerations in designing your machine learning workflows.

## Image storage

Your Edge Vision solution cannot be complete without careful consideration of how and where the images generated will be stored. Read [Image storage and management in Azure IoT Edge Vision](./iot-edge-image-storage.md) for a thorough discussion.

## Alerts

Your IoT Edge device may need to respond to various alerts in its environment. See [Alerts persistence in Azure IoT Edge Vision](./iot-edge-alerts.md) to understand the best practice in managing these alerts.

## User interface

The user interface of your IoT Edge Vision solution will vary based on the target user. Read [User interface in Azure IoT Edge Vision](./iot-edge-user-interface.md) for the main considerations for the UI.