---
title: Builders, developers, and operators
titleSuffix: Azure Example Scenarios
description: Learn about the typical roles involved in an Azure IoT solution and how they interact.
author: wamachine
ms.date: 08/03/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Builders, developers, and operators

Device builders, solution developers, and solution operators represent the typical roles surrounding the ongoing development, monitoring, and maintenance of an internet-of-things (IoT) solution throughout its lifecycle.

Device builders create the IoT-compatible devices that interact with applications. Solution developers develop the software that makes up IoT applications. Solution operators run and monitor IoT solutions during their lifecycles.

These roles may be fulfilled by different companies, organizations, or individuals, or by the same individuals taking on different roles as they interact with a solution during its lifetime. While many other roles can exist around an IoT solution, these three roles provide helpful perspectives for viewing a solution during its design and development.

## Device builder

The device builder is generally an Original Device Manufacturer (ODM) or Original Equipment Manufacturer (OEM). The builder may build IoT-compatible devices for either a specific solution or for a diverse set of solutions made by Independent Software Vendors (ISVs) or System Integrators (SIs). It's common for device builders and solution developers to work closely together in developing devices tailored to a solution.

In addition to providing the devices and their *firmware*, or built-in software, the device builder is responsible for publishing updates for devices to address bugs and security patches, and enabling any additional capabilities.

![A diagram showing activities of a device builder, and relationships with other roles in developing an IoT solution.](media/device-builder.png)

## Device builder considerations

Consider the following requirements when choosing or developing devices for an IoT solution:

- The device has appropriate security for target solutions. A good resource on secure device characteristics is [The Seven Properties of Highly Secure Devices](https://www.microsoft.com/research/publication/seven-properties-highly-secure-devices/).

- A fault-tolerant device update mechanism lets devices continue to function on failed or interrupted updates. Consider using Content Delivery Networks (CDNs) to publish device updates, or solutions that can programmatically consume updates on behalf of devices.

- An update mechanism that separates update publishing from update deployment, so solution operators can deploy the published updates in a controlled manner to devices in the field.

- Device monitoring and diagnostics that the device builder can access to monitor, identify, and remediate issues once devices are in the field.

- Setting expectations for how long to support a given version of device software, and how to replace devices in the field.

## Solution developer

The solution developer may be an ISV, SI, or an organization developing an IoT application. Solution developers may work closely with device builders to collaborate on new categories of devices, and with solution operators to ensure solutions can be monitored and maintained throughout their lifecycle.

Just as a device builder provides updates to devices in the field, solution developers provide updates to applications to fix issues, add new features, and improve stability and performance.

![A diagram showing activities of a solution developer, and relationships with other roles in developing an IoT solution.](media/solution-developer.png)

## Solution developer considerations

Consider the following requirements when developing an IoT application:

- Applications have an upgrade path that minimizes customer impact to key scenarios.
- Built-in live monitoring and diagnostics insights allow issues to be detected and diagnosed when they happen. These workflows include alerting and remediation.
- The solution has the ability to absorb future scale and traffic demands if device and user population continues to grow.

## Solution operator

The solution operator manages an IoT solution throughout its lifecycle. For cloud applications, the solution operator's workflow may include, or overlap with, the solution developer's workflow.

Distributing updates to devices can be complex, because they may need orchestration with a cloud application to ensure they happen when appropriate. If the device builder update workflow is highly decoupled from the cloud application, it's best to support a workflow that distributes device updates through the cloud application.

![A diagram showing activities of a solution operator, and relationships with other roles in developing an IoT solution.](media/solution-operator.png)

## Solution operator considerations

Consider the following requirements when operating an IoT application:

- The solution lets the device builder access device health and diagnostics data they can use to identify and create updates to device software.
- Device software updates are published to a repository or CDN that the operator can access through automated or manual interaction.
- A device update workflow can selectively distribute updates based on policies the operator sets.
- Whether devices are replaced or updated, solution planning accounts for device management.

## Related resources

- [Overview of device management with IoT Hub](https://docs.microsoft.com/azure/iot-hub/iot-hub-device-management-overview)
- [Streamlined IoT device certification with Azure IoT](https://azure.microsoft.com/blog/streamlined-iot-device-certification-with-azure-iot-certification-service/)
- [Azure DevOps integration](https://azure.microsoft.com/product-categories/devops/)
