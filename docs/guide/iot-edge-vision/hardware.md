---
title: Hardware for IoT Edge vision AI
titleSuffix: Azure Architecture Center
description: Explore hardware acceleration for Azure IoT Edge vision solutions. Learn about hardware acceleration capabilities of CPUs, GPUs, FPGAs, and ASIC chips.
author: MSKeith
ms.author: keith
ms.date: 02/16/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories: iot
products:
  - azure-iot-edge
ms.custom:
  - guide
  - fcp
---

# Hardware acceleration for Azure IoT Edge vision AI

Computer graphics and artificial intelligence (AI) require large amounts of computing power. A critical factor in designing Azure IoT Edge vision AI projects is the degree of hardware acceleration the solution needs.

Hardware accelerators such as graphics processing units (GPUs), field programmable gate arrays (FPGAs), and application-specific integrated circuits (ASICs) are cost effective ways to improve performance.

## Computing hardware types

The following sections describe the main types of computing hardware for IoT Edge vision components.

### CPU

A central processing unit (CPU) is the default option for most general purpose computing. A CPU might be sufficient for vision workloads where timing isn't critical. However, workloads that involve critical timing, multiple camera streams, or high frame rates need specific hardware acceleration.

### GPU

A GPU is the default processor for high-end computer graphics cards. High performance computer (HPC) scenarios, data mining, and AI or machine learning (ML) workloads all use GPUs. Vision workloads use GPUs' massive parallel computing power to accelerate pixel data processing. The downside to a GPU is its higher power consumption, which is a critical consideration in edge workloads.

### FPGA

FPGAs are powerful, reconfigurable hardware accelerators that support the growth of deep learning neural networks. FPGA accelerators have millions of programmable gates and hundreds of I/O pins, and can do trillions of multiply accumulate (MAC) operations per second (TOPS). There are many FPGA libraries optimized for vision workloads. Some of these libraries include preconfigured interfaces to connect to downstream cameras and devices.

The usage of FGPAs in ML and IoT Edge workloads is still evolving. FPGAs tend to fall short in floating point operations, but manufacturers have made improvements in this area.

### ASIC

ASICs are manufactured to do a specific task. ASICs are by far the fastest accelerators available, but are the least configurable. ASIC chips are popular because of their small size, power per watt performance, and intellectual property (IP) protection. The IP is burned into ASIC chips, making it hard to reverse engineer proprietary algorithms.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Keith Hill](https://www.linkedin.com/in/keith-hill-072060102/) | Senior PM Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> [!div class="nextstepaction"]
> [Machine learning and data science in Azure IoT Edge vision AI](./machine-learning.yml)
