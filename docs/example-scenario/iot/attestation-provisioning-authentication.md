---
title: Attestation, provisioning, and authentication
titleSuffix: Azure Example Scenarios
description: Understand the concepts that are involved in connecting devices to an IoT platform and how device provisioning works.
author: wamachine
ms.date: 08/03/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# IoT Hub attestation, authentication, and provisioning

Connecting IoT devices to Azure IoT Hub involves the three primary concepts of *attestation*, *provisioning*, and *authentication*.

The [attestation mechanism](https://docs.microsoft.com/azure/iot-dps/concepts-security#attestation-mechanism) represents the method chosen for a device to confirm its identity when it connects to a service like IoT Hub. Azure IoT supports [symmetric key, X.509 thumbprint, and X.509 CA](https://azure.microsoft.com/blog/iot-device-authentication-options/) attestation methods.

[Authentication](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-security#authentication) is how the device identifies itself. IoT Hub grants access to a device based on the device's ability to prove itself using its unique device identity in combination with its attestation mechanism.

[Provisioning](https://docs.microsoft.com/azure/iot-dps/about-iot-dps#provisioning-process) a device is the act of enrolling the device into Azure IoT Hub. Provisioning makes IoT Hub aware of the device and the attestation mechanism the device uses.

## Azure IoT Hub Device Provisioning Service

Device provisioning can happen through the [Azure IoT Hub Device Provisioning Service (DPS)](https://docs.microsoft.com/azure/iot-dps/) or directly via [IoT Hub Registry Manager APIs](https://docs.microsoft.com/dotnet/api/microsoft.azure.devices.registrymanager). Using DPS confers the benefit of *late binding*, which allows removing and reprovisioning field devices to IoT Hub without changing the device software.

The following example shows how to implement a test-to-production environment transition workflow by using DPS.

![A diagram showing how to implement a test-to-production environment transition workflow by using DPS.](media/late-binding-with-dps.png) 

1. The solution developer links the Test and Production IoT clouds to the provisioning service.
2. The device implements the DPS protocol to find the IoT Hub if it's no longer provisioned. The device is initially provisioned to the Test environment.
3. Since the device is registered with the test environment, it connects there and testing is carried out.
4. The developer re-provisions the device to the Production environment through the solution control plane, and removes it from the Test hub. The Test hub rejects the device the next time it reconnects.
5. The device connects and re-negotiates the provisioning flow. The device is now directed to the Production environment, and connects and authenticates there.

## Considerations

Consider the combinations of [Azure IoT Hub supported protocols](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-protocols) when working through a solution end-to-end. Combinations indicated by red lines in the following diagram may be incompatible or have added considerations:

![A diagram showing authentication flows for various topologies connecting to Azure IoT Hub.](media/authentication-matrix.png) 

- Symmetric keys like SAS tokens are always registered as symmetric keys with IoT Hub.
- IoT Hub supports x.509 CA authentication. However, provisioning devices with x.509 CA through DPS provisions them to the IoT Hub as x.509 thumbprint.
- Web socket variants of AMQP and MQTT aren't supported with x.509 CA certificates in IoT Hub.
- Revoking certificates through DPS doesn't prevent currently provisioned devices from continuing to authenticate with IoT Hub. After revoking a certificate in DPS, individually remove the device from the IoT Hub, either manually through the dashboard or programmatically using [Registry Manager APIs](https://docs.microsoft.com/rest/api/iothub/service/registrymanager).
