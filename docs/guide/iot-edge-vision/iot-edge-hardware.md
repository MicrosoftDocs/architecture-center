---
title: Azure IoT Edge Vision
titleSuffix: Azure Architecture Center
description: 
author: MSKeith
ms.date: 09/30/2020
ms.topic: guide
ms.service: architecture-center
ms.author: kehilsch
ms.category:
  - fcp
ms.subservice: reference-architecture
---

# Hardware acceleration in Azure IoT Edge Vision

Along with the camera selection, one of the other critical decisions in Vision on the Edge projects is hardware acceleration. 

The following sections describe the key componenets of this underlying hardware.

## CPU 

The Central Processing Unit (CPU) is your default compute for most processes running on a computer, it is designed for general purpose compute. Some Vision Workloads where timing is not as critical this might be a good option. However, most workloads that involve critical timing, multiple camera streams, and/or high frame rates will require more specific hardware acceleration

## GPU 

Many people are familiar with the Graphics Processing Unit (GPU) as this is the de-facto processor for any high-end PC graphics card. In recent years the GPU has been leveraged in high performance computer (HPC) scenarios, and in data mining, and in computer AI/ML workloads. The GPU’s massive potential of parallel computing can be used in a vision workload to accelerate the processing of pixel data. The downside to a GPU is its higher power consumption, which is a critical factor to consider for your vision workload.

## FPGA 

Field Programmable Gate Arrays are reconfigurable hardware accelerators. These powerful accelerators allow for the growth of Deep Learning Neural networks, which are still evolving. These accelerators have millions of programmable gates, hundred of I/O pins, and exceptional compute power (in the Trillions of tera-MAC’s) There also a lot of different libraries available for FPGA’s to use that are optimized for vision workloads. Some of these libraries also include preconfigured interfaces to connect to downstream cameras and devices. One area that FPGA’s tend to fall short on is floating point operations, however, manufacturers are currently working on this issue and have made a lot of improvements in this area.

## ASIC 

Application Specific Integrated Circuit is by far the fastest accelerator on the market today.  While they are the fastest, they are the hardest to change as they are manufactured to function for a specific task.  These custom chips are gaining popularity due to size, power per watt performance, and IP protection (because the IP is burned into the ASIC accelerator it is much harder to backwards engineer proprietary algorithms).

## Next steps

Proceed to learn what considerations go into place for [Machine learning and data science in Azure IoT Edge Vision](./iot-edge-machine-learning).