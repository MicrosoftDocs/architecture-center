---
title: IoT Architecture  Azure IoT Subsystems 
description: Learn about our recommended IoT application architecture that supports hybrid cloud and edge computing. A flowchart details how the subsystems function within the IoT application.
author: adamboeglin
ms.date: 10/29/2018
---
# IoT Architecture  Azure IoT Subsystems 

## Architecture
<img src="media/azure-iot-subsystems.svg" alt='architecture diagram' />

## Components
* [IoT Hub](href="http://azure.microsoft.com/services/iot-hub/): The cloud gateway for the system controls bidirectional, secure communication to and from devices.
* [Azure Cosmos DB](href="http://azure.microsoft.com/services/cosmos-db/): Used for warm storage for device data.
* [Virtual Machines](href="http://azure.microsoft.com/services/virtual-machines/): Hosts containers that contain microservices for processing data and hosting the UI.
* [Stream Analytics](href="http://azure.microsoft.com/services/stream-analytics/): Processes data coming into the system from devices.
* [Blob Storage](href="http://azure.microsoft.com/services/storage/blobs/): Cold storage of device data.
* [Azure Active Directory](href="http://azure.microsoft.com/services/active-directory/): Used for authentication and authorization of the system.

## Next Steps
* [IoT Hub Documentation](https://docs.microsoft.com/azure/iot-hub/)
* [Cosmos DB Documentation](https://docs.microsoft.com/azure/cosmos-db/)
* [Azure Virtual Machines Documentation](https://docs.microsoft.com/azure/virtual-machines/)
* [Azure Stream Analytics Documentation](https://docs.microsoft.com/azure/stream-analytics/)
* [Azure Blob Storage Documentation](https://docs.microsoft.com/azure/storage/)
* [Azure Active Directory application Documentation](https://docs.microsoft.com/azure/active-directory/)