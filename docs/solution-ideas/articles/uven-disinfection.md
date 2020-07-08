---
title: UVEN smart and secure disinfection and lighting
titleSuffix: Azure Solution Ideas
author: doodlemania2
description: See how BrainLit's UVEN system uses IoT and Azure Sphere to provide smart, safe, secure virus disinfection and healthy, human-optimized lighting.
ms.date: 07/06/2020
ms.custom: iot, fcp
ms.service: architecture-center
ms.subservice: solution-idea
ms.category:
  - iot
---

# Smart and secure lighting and disinfection

Smart, connected Internet of Things (IoT) devices can make life easier, healthier, and safer. For example, BrainLit's BioCentric Lighting™ (BCL) system is a dynamic, self-learning, IoT-based system that creates high-quality natural lighting for indoor environments. Research increasingly confirms the importance of high-quality light and natural light cycles for promoting human alertness, health, well-being, and productivity.

The BCL system can also deliver radiant energy in the non-visible ultraviolet (UV) spectrum. All UV radiation has antimicrobial capabilities. The shortest wavelength, 200-300 nm UVC radiation, is absorbed by biological organisms' DNA, RNA, and proteins, causing inactivation of the DNA and preventing replication of viruses. UVC radiation disinfection is an important weapon in the fight against COVID. BrainLit's new UVEN concept combines BCL light control with UVC disinfection to promote building occupants' health and well being and help kill virus.

Other UVC virus-killing technology that uses plug-in devices, robots, drones, and wands can't provide overall space coverage or performance and effectiveness data. Operating these devices safely and efficiently disrupts business and personnel, resulting in loss of productivity and lower space utilization. UVEN disinfection operates in unoccupied spaces during low-use times, providing safe, comprehensive, autonomous microbe deactivation in real time without business disruption.

Because IoT devices operate directly on the physical environment and often use and collect sensitive data, device safety and security are paramount. UVEN double fail safe insurance ensures occupants are exposed to beneficial light only. [Azure Sphere](https://azure.microsoft.com/services/azure-sphere/) offers a standalone microprocessor (MCU)-based platform that securely runs IoT apps and connects directly to the cloud for complete Azure-based security and the latest OS and app updates.

The system can continually integrate new reearch developments and public health guidelines via its cloud connection, ensuring the best scientifically-based lighting and disinfection system for all needs.

UVEN combined BCL and UVC technology offers:
- A smart, safe, and secure integrated system solution for lighting and disinfection, with optimal usage of floor area.
- Long-term solutions that can adapt lighting and disinfection doses and recipes to changing circumstances.
- Overall better health for occupants through optimized lighting and a virus-free environment.

## Potential use cases

- UVEN cells can configure to fit any layout of a specific area, such as a reception counter, or be split between several areas, such as a number of washrooms.
- The system can scale to fit anything from individual rooms and homes to large campuses and public concourses.
- The Azure Sphere based infrastructure can easily integrate with existing IoT devices or building management systems.

## Architecture

![UVEN architecture](../media/bcl-4.png)

When people are present, the ceiling panels emit BCL light only. Whenever the space is unoccupied, the panels emit UV radiation to heavily reduce or eliminate viruses and bacteria.

1. One UVEN LCS can control both BCL light and UVC radiation emissions for up to 20 luminaires. The cell connects to radar sensors that secure its external perimeter as well as individual luminaire radar sensors. Each LCS requires only electrical power and a connection to the internet or to a larger LCS cluster.
1. Several cells can be connected in a cluster. Only one of the the clustered LCSs needs to be connected to the internet, for dose and recipe updates and real-time calibration. An LCS or cluster can operate standalone, or form an overall UVEN BCL Network System with other clusters.
3. A UVEN BCL Net is completely decentralized and offers unlimited scalability, control, and flexibility.

## Components

The UVEN system consists of LED luminaires that are controlled by Azure Sphere-powered lighting control systems.

### UVEN components

The basic UVEN ASK ceiling panel is made up of dynamic, adaptable light-emitting diodes (LEDs) that integrate BCL with disinfection in the same luminaire. As well as offering a large range of visible and UV emissions, the LEDs provide exceptional color and detail rendering, and the ability to dim smoothly down to 0.1%. LEDS are low-cost, long-lasting, and environmentally sustainable compared to traditional incandescent and fluorescent indoor light sources.

When people are present, the ceiling panels emit BCL light only. Whenever the space is unoccupied, the panels emit UV radiation to heavily reduce or eliminate viruses and bacteria. Separate drivers optimized to operate in their respective regimes maintain full BCL and UV functionality simultaneously.

Radar motion sensors, alarms, and manual overrides provide double fail safe insurance so users are exposed to beneficial light only. A flexible, scalable, updatable lighting control system (LCS) based on Azure Sphere technology controls luminaires, sensors, and safety and alarm mechanisms.

UV radiation can damage surfaces and equipment. UVEN advanced sensors and controllers ensure that the luminaires generate the minimum doses of UVC radiation to ensure disinfection. The system can continually integrate new reearch developments and public health guidelines via its cloud connection, ensuring the best scientifically-based lighting and disinfection system for all needs.

UVEN administrative support tools include an admin panel to maintain information about users and devices, and a dashboard to provide an overall view of user activity and exposure.

### Azure Sphere

[Azure Sphere](https://azure.microsoft.com/services/azure-sphere/) is a secured, high-level application platform with built-in cloud communication and security for IoT connected devices. The platform consists of an Azure Sphere-certified secured MCU chip that runs a custom high-level Linux-based microcontroller operating system (OS). The Azure Sphere OS provides a platform for IoT application development, including both high-level and real-time capable applications, and connects to the cloud-based Azure Sphere Security Service (A3) for continuous, renewable security.

A3 establishes a secure connection between a device and the internet or cloud, ensures secure boot, and enables maintenance, updates, and control for Azure Sphere-certified chips. A3 authenticates device identity, ensures the integrity and trust of the system software, and certifies that the device is running a trusted code base. The service also provides a secure channel to automatically download and install OS and customer application updates to deployed devices.

The MediaTek 3620 is the first Azure Sphere-certified chip, and includes an ARM Cortex-A7 500MHz processor, two ARM Cortex-M4F 200MHz I/O subsystems, Wi-Fi capability, and the Microsoft Pluton security subsystem with a dedicated ARM Cortex-M4F core. The Linux-based Azure Sphere OS lets developers write applications that can run on either the A7 core with access to external communications, or as real-time capable apps on one of the M4 processors. Developers can distribute applications to Azure Sphere devices through the same secure mechanism as the Azure Sphere OS updates.

Azure Sphere *greenfield* implementations involve designing and building new IoT devices with Azure Sphere-certified chips. *Brownfield* implementation allows existing IoT devices to securely connect to the internet through an Azure Sphere Guardian module. The guardian module contains an Azure Sphere certified chip, the Azure Sphere OS, and A3. The module connects to the IoT device through an existing peripheral, and then securely connects to the internet. The IoT device itself isn't exposed to the internet.

Pluton is the Microsoft-designed security subsystem that implements the hardware-based root of trust for Azure Sphere. It includes a security processor core, cryptographic engines for asymmetric and symmetric encryption, a hardware random number generator, public/private key generation, support for elliptic curve digital signature algorithm (ECDSA) verification for secured boot, measured boot to support remote attestation with a cloud service, and several anti-tampering controls.

## Next steps

- For more information, please contact [iotcovid@microsoft.com](mailto:iotcovid@microsoft.com).
- For more information about Azure Sphere, see the [Azure Sphere documentation](https://docs.microsoft.com/azure-sphere/).
- For Azure Sphere code samples, see [Azure Sphere Samples](https://github.com/Azure/azure-sphere-samples).