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

*Device builders*, *application developers*, and *solution operators* are the typical roles surrounding the ongoing development, monitoring, and maintenance of an internet-of-things (IoT) solution throughout its lifecycle.

Device builders create the IoT-compatible devices that interact with applications. Application developers develop the software that makes up IoT applications. Solution operators run and monitor IoT solutions.

These roles may be filled by different companies, organizations, or individuals, or by the same individuals taking on different roles as they interact with IoT solutions during their lifetimes. While many other roles can exist around IoT solutions, these three roles provide helpful perspectives for viewing an IoT solution during its design, development, and deployment.

## Device builder

The device builder is usually an Original Device Manufacturer (ODM) or Original Equipment Manufacturer (OEM). The builder may build IoT-compatible devices for specific solutions or for sets of solutions made by Independent Software Vendors (ISVs) or System Integrators (SIs). It's common for device builders and application developers to work closely together in developing devices tailored to a solution.

In addition to providing devices and their *firmware*, or built-in software, the device builder is responsible for publishing updates for devices to address bugs and security patches and enable additional capabilities. Consider using Content Delivery Networks (CDNs) to publish device updates, or solutions that can programmatically consume updates on behalf of devices.

![A diagram showing activities of a device builder, and relationships with other roles in developing an IoT solution.](media/device-builder.png)

Devices for an IoT solution should have:

- Appropriate security for the target solution. For more information about secure device characteristics, see [The Seven Properties of Highly Secure Devices](https://www.microsoft.com/research/publication/seven-properties-highly-secure-devices/).
- A fault-tolerant device update mechanism that lets devices keep functioning on failed or interrupted updates.
- An update mechanism that separates update publishing from update deployment, so solution operators can control update deployment to devices in the field.
- Access for device builders to device monitoring and diagnostics data to monitor, identify, and remediate device issues.
- Clear expectations for how long to support given versions of device software, and how to replace devices in the field.

## Application developer

An IoT application developer can be an ISV, SI, or organization. Application developers might collaborate closely with device builders on new categories of devices, and with solution operators to ensure solution monitoring and maintenance.

Just as device builders provide updates to devices in the field, application developers provide application updates to fix issues, add new features, and improve stability and performance.

![A diagram showing activities of a solution developer, and relationships with other roles in developing an IoT solution.](media/solution-developer.png)

IoT applications should meet the following requirements:
- An upgrade mechanism that minimizes customer impact to key scenarios
- Built-in live monitoring and insights that include issue detection and diagnosis, alerting, and remediation.
- The ability to absorb future scale and traffic demands as device and user populations grow.

## Solution operator

The solution operator manages an IoT solution throughout its lifecycle. For cloud applications, the solution operator and solution developer workflows can interact or overlap.

![A diagram showing activities of a solution operator, and relationships with other roles in developing an IoT solution.](media/solution-operator.png)

Deploying updates to IoT devices is complex because they may need orchestration with cloud applications to ensure they happen when appropriate. If the device builder update workflow is highly decoupled from the cloud application, it's best to support a workflow that distributes device updates through the cloud application.

The IoT solution operator workflow should meet the following requirements:

- The solution lets the device builder access device health and diagnostics data to identify and create device software updates.
- The operator can access device software updates through automated or manual interaction with a repository or CDN.
- The device update workflow can selectively distribute updates based on policies the operator sets.
- Solution planning accounts for device management through updating and replacing devices.

## Related resources

- [Overview of device management with IoT Hub](https://docs.microsoft.com/azure/iot-hub/iot-hub-device-management-overview)
- [Streamlined IoT device certification with Azure IoT](https://azure.microsoft.com/blog/streamlined-iot-device-certification-with-azure-iot-certification-service/)
- [Azure DevOps integration](https://azure.microsoft.com/product-categories/devops/)
