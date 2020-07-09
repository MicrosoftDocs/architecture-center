---
title: Builders, Developers, and Operators
titleSuffix: Azure Example Scenarios
description: The typical roles involved in an Azure IoT solution and how they interact.
author: wamachine
ms.date: 06/29/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---

# Builders, Developers, and Operators

**Device builders**, **solution developers**, and **solution operators**
represent the typical roles surrounding the ongoing development,
monitoring, and maintenance of an IoT Solution throughout its lifecycle.

| Role | Description |
|---|---|
| **Device builder** | Develops the IoT compatible devices that interact with an application. |
  **Solution developer** | Develops the cloud software that makes up the IoT application. |
  **Solution operator** | Monitors and operates the IoT solution during its lifecycle. |

While there can be a myriad of roles that exist around an IoT solution,
these three provide helpful perspectives from which to view a solution
during its design and development.

> **Note:** These roles may be fulfilled by different companies,
organizations, or individuals or the same individuals wearing different
hats in how they interact with a solution during its lifetime.

## Device builder

The **device builder** is generally an Original Device Manufacturer
(ODM) or Original Equipment Manufacturer (OEM) building IoT compatible
devices for either a specific solution or for a diverse set of solutions
made by Independent Software Vendors (ISV) or System Integrators (SI).
It's also common for a **device builder** and **solution developer** to
work closely together in developing devices tailored to a solution.

In addition to providing the devices and software (firmware) that will
run on a given device, the **device builder** is responsible for
publishing updates for devices to address bugs, security patches, and
enable additional capabilities.

![A diagram showing activities of a device builder and their relationships with other roles participating in the development of an IoT solution](media/device-builder.png)

**Considerations when choosing, or developing, devices for an IoT
solution:**

-   Appropriately secure devices for target solutions. A good resource
    on secure device characteristics is [The Seven Properties of Highly
    Secure
    Devices](https://www.microsoft.com/research/publication/seven-properties-highly-secure-devices/).

-   Ensuring a mechanism to update devices in the field. This should
    separate the publishing of updates from the act of applying those
    updates to devices in the field, enabling updates to be applied in a
    controlled manner by [solution operators](#solution-operator).

-   Monitoring for device health and diagnostics collection that is
    accessible to a device builder to monitor, identify, and remediate
    issues with devices once they are in the field.

-   Expectations on how long a given version of device software is
    expected to be supported. At the same time, accounting for being
    able to replace devices in the field is also a good thing to
    consider.

-   Ensuring device updates are fault tolerant and devices can continue
    to function on a failed, or interrupted update.

> **Note:** Content Delivery Networks (CDN) are good mechanisms for
publishing device updates. Even better is if they can programmatically
be consumed by solutions on-behalf of devices. </aside>

## Solution developer

The **solution developer** may be an Independent Software Vendor (ISV),
a System Integrator (SI), or an organization developing an IoT
application. **solution developers** may work closely with **device
builders** to collaborate on new categories of devices as well as with
**solution operators** to ensure a solution can be monitored and
maintained throughout its lifecycle.

Just as a **device builder** will provide updates to devices in the
field, **solution developers** will provide updates to the cloud
application to fix issues, add new features, and improve stability and
performance.

![A diagram showing activities of a solution developer and relationships with other roles participating in the development of an IoT solution](media/solution-developer.png)

**Considerations when developing an IoT application:**

-   Ensuring applications have an upgrade path that minimizes customer
    impact to key scenarios.

-   Building in live insights in the form of monitoring and diagnostics
    capabilities that allow issues to be detected and root caused when
    they happen. This includes alerting and remediation workflows.

-   Ability to absorb future scale and traffic demands should the
    solution continue to grow in device and user population over its
    lifetime.

## Solution operator

The **solution operator** manages an IoT Solution throughout its
lifetime. For cloud applications, the **solution developer** workflow
may include, or overlap with, the **solution operator** workflow. For
devices, things can be more complex, since distributing updates to
devices may need orchestration with a cloud application to ensure they
happen when most appropriate. Additionally, given the **device builder**
update workflow may be highly decoupled from the cloud application, it's
beneficial to support a workflow that allows device updates to be
distributed through the cloud application.

![A diagram showing activities of a solution operator and their relationships with other roles participating in the development of an IoT solution](media/solution-operator.png)

**Considerations when operating an IoT application:**

-   The solution enables device health and diagnostics to be made
    available to the Device Builder. The Device Builder uses this to
    identify and make updates to device software.

-   Device software updates are published to a repository or Content
    Delivery Network accessed through operator interaction with a
    solution, either automated, or manually.

-   Updates can be selectively distributed through a Device Update
    Workflow based on policies set by the Solution Operator.

**Note:** Devices may simply be replaced rather than updated. In both
cases ensuring device management is accounted for in solution planning,
will prevent a very painful series of events that arise from having to
solve the device update problem when it happens to a live solution. </aside>

**Additional resources for builders, developers, and operators**

-   [Overview of Device Management with IoT
    Hub](https://docs.microsoft.com/azure/iot-hub/iot-hub-device-management-overview)

-   [Streamlined IoT Device Certification with Azure
    IoT](https://azure.microsoft.com/blog/streamlined-iot-device-certification-with-azure-iot-certification-service/)

-   [Azure DevOps
    Integration](https://azure.microsoft.com/product-categories/devops/)
