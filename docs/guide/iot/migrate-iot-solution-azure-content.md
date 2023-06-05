This article provides guidance for architects, developers, and IT staff who plan to migrate Internet of Things (IoT) solutions to Azure. This guide reviews questions related to the following [IoT architecture layers](/azure/architecture/framework/iot/iot-overview?branch=main#iot-architecture-layers):

- Devices and gateways
- Ingestion and communications
- Event processing and analytics
- Other necessary layers

The best practices and recommendations align with the well-architected framework for IoT. For more information, see [Well-Architected Framework for IoT](/azure/architecture/framework/iot/iot-overview).

To learn more about pre-migration evaluations and discover common strategies, see [IoT solution to Azure IoT migration best practices](azure-iot-migration-best-practices.md).

## Architecture

The first step to migrating your IoT solution to Azure is understanding Azure IoT services. The following diagram describes Azure components and services that IoT solutions commonly use, but no single solution uses all of these components. For more information about key components and this reference architecture, see [Azure IoT reference architecture](../../reference-architectures/iot.yml).

:::image type="content" source="media/azure-iot-reference-architecture.png" alt-text="This diagram shows the Azure IoT reference architecture." lightbox="media/azure-iot-reference-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-reference-architecture.vsdx) of this architecture.*

## Components

Azure IoT solutions can include the following components:

- [Azure IoT SDK](/azure/iot-hub/iot-hub-devguide-sdks)
- [Azure RTOS](https://azure.microsoft.com/products/rtos)
- [Azure Sphere](https://azure.microsoft.com/products/azure-sphere)
- [Azure IoT Edge](https://azure.microsoft.com/products/iot-edge)
- [Azure IoT Hub](https://azure.microsoft.com/products/iot-hub)
- [Azure device provisioning service](/azure/iot-dps)
- [Azure Stream Analytics](https://azure.microsoft.com/products/stream-analytics)
- [HDInsight Spark and Storm](https://azure.microsoft.com/products/hdinsight)
- [Azure Data Explorer](https://azure.microsoft.com/products/data-explorer)
- [Azure Machine Learning](https://azure.microsoft.com/products/machine-learning)
- [Azure Databricks](https://azure.microsoft.com/products/databricks)

## Consideration to migrate your IoT solution to Azure

Azure IoT solutions involve:

- Things, typically devices that generate data
- Insights that you form about the data
- Actions that you take based on insights

For example, a motor sends temperature data. Use this data to evaluate whether the motor performs as expected. Use the insight about the motor's performance to prioritize its maintenance schedule. For more information, see [Azure IoT reference architecture](../../reference-architectures/iot.yml#architecture).

During a migration to Azure IoT, these elements are the main components that you must understand how to migrate:

- [Devices](#devices)
- [Device management](#device-management)
- [Cloud services](#cloud-services)

## Devices

To migrate, you need to create devices in IoT Hub, modify them as needed, and plan for authentication.

### Migration and recreation of devices in IoT Hub

Depending on the number of devices in your IoT solution, you might need a bulk process to create devices on IoT Hub.

You can create an application to automate the bulk migration without having the users perform manual actions. First, map the device metadata related to your current solution to the ones supported by Azure IoT. Consider the following elements for migration or equivalence of services:

Consult the following table:

| Other provider               | Azure IoT                                     |
|:-----------------------------------|:----------------------------------------------|
| IoT devices                        | Device (ID, name)                             |
| Device attributes                  | Device twins (tags)                           |
| Device configurations              | Device twins (desired properties)             |
| Device state                       | Device twins (reported properties)            |
| CA certificates                    | CA certificates (Azure IoT Hub)               |
| Device identity (X509 Certificate) | Device identity (X509 certificate thumbprint) |

The migration application gets a list of devices and their metadata from the current solution. Then it creates and registers new devices in IoT Hub by using the appropriate metadata mapping.

The following example describes a console application that uses the [IoT Hub Service SDK](/azure/iot-hub/iot-hub-devguide-sdks#azure-iot-hub-service-sdks). Cloud providers expose a function to obtain the list of devices through a REST service. First, the application connects to your current IoT service to obtain the list of devices, identities, device names, and other metadata by using a REST API. Store device data in case you must rerun the migration process.

After the application has the list of devices, it creates the devices in IoT Hub through the IoT Hub Service SDK. For more information about how to bulk-create devices on IoT Hub, see [this sample](https://github.com/Azure/azure-iot-hub-python/blob/main/samples/iothub_registry_manager_bulk_create_sample.py).

:::image type="content" source="media/bulk-migration-console-app.png" alt-text="Diagram shows a migration path from current IoT service by using a C# console application as described in the steps below." border="false":::

### Dataflow

1. The console application connects to the current IoT service by using a REST API to obtain the list of devices and metadata.

   Optionally, the application stores the device information.

1. The console application connects to Azure IoT Hub by using the IoT Hub SDKs and creates devices in bulk.

You can host the application in an [Azure Functions](/azure/azure-functions), [Azure App Service](/azure/app-service/overview), or console application. At the end of the migration, ensure that you have the same number of devices in both services and that the migration created the required metadata.

### Understand how devices communicate with Azure IoT Hub

Every IoT solution is different. One of the critical elements to consider is the code implemented in your devices, typically called *firmware*. Cloud providers usually support two mechanisms to connect devices to the service for connecting and managing IoT devices: *REST API* and *Message Queuing Telemetry Transport (MQTT)*. In addition to supporting both mechanisms, Azure provides an SDK to enrich the functionalities provided by the IoT solution.

To migrate your IoT solution, decide whether to make changes in the following areas:

- [Azure IoT Device SDKs](#azure-iot-device-sdks)
- [Device communications without SDK by using MQTT or HTTP](#device-communications-without-an-sdk-by-using-mqtt-or-http)
- [Endpoint](#endpoint)
- [Authentication](#authentication)

### Azure IoT Device SDKs

Azure IoT Hub provides SDKs in common languages like C#, Java, Node, C, and Python. Use an SDK to build applications that run on your IoT devices using device client or module client. These applications send telemetry to your IoT hub, and can receive messages, job, method, or twin updates from your IoT hub. For more information and examples in different languages, see [Microsoft Azure IoT SDKs](https://github.com/Azure/azure-iot-sdks).

IoT Hub allows devices to use the following protocols for device-side communications:

- [MQTT](https://docs.oasis-open.org/mqtt/mqtt/v3.1.1/mqtt-v3.1.1.pdf)
- MQTT over WebSockets
- [Advanced Message Queuing Protocol (AMQP)](https://docs.oasis-open.org/amqp/core/v1.0/os/amqp-core-complete-v1.0-os.pdf)
- AMQP over WebSockets
- HTTPS

For information about how these protocols support specific IoT Hub features, see [Device-to-cloud communications guidance](/azure/iot-hub/iot-hub-devguide-d2c-guidance) and [Cloud-to-device communications guidance](/azure/iot-hub/iot-hub-devguide-c2d-guidance).

### Device communications without an SDK by using MQTT or HTTP

You can use MQTT or HTTP for device communications.

#### MQTT communications

If the devices use MQTT to communicate with the current cloud provider, IoT Hub directly supports communication by using the MQTT protocol. For more information, see [Using the MQTT protocol directly](/azure/iot-hub/iot-hub-mqtt-support#using-the-mqtt-protocol-directly-as-a-device).

Direct communication by using MQTT protocol doesn't support anonymous communication. To communicate with IoT Hub, authenticate the devices through a shared access signature token or an X.509 certificate. The device application can specify a `Will` message in the `CONNECT` packet. The device app should use `devices/<device-id>/messages/events/` or `devices/<device-id>/messages/events/<property-bag>` as the `Will` topic name to define `Will` messages to be forwarded as a telemetry message.

Also, consider the supported topics for [sending telemetry device-to-cloud](/azure/iot-hub/iot-hub-mqtt-support#sending-device-to-cloud-messages) and [receiving cloud-to-device messages](/azure/iot-hub/iot-hub-mqtt-support#receiving-cloud-to-device-messages).

The [MQTT samples for Azure IoT](https://github.com/Azure-Samples/IoTMQTTSample) samples demonstrate how to connect and send messages to an Azure IoT Hub without using the Azure IoT SDKs.

#### HTTPS REST API

The REST API for IoT Hub offer programmatic access to the device, messaging, and job services in IoT Hub. It also offers access to the resource provider. You can access messaging services from within an IoT service running in Azure, or directly over the Internet from any application that can send an HTTPS request and receive an HTTPS response. For more information, see [IoT Hub REST](/rest/api/iothub).

If your device requires the use of the HTTPS REST API without IoT Hub SDKs, Azure IoT Hub supports an HTTP REST API. You can use this API for sending and receiving messages. Use these APIs from a device to send device-to-cloud messages to an IoT hub or receive cloud-to-device messages from an IoT hub. All task operations conform to the HTTP/1.1 protocol specification. Make sure that requests made to these resources are secure. For more information, see [Device](/rest/api/iothub/device).

### Endpoint

A key element in the devices code is the endpoint or URL of the IoT service. The IoT devices should connect to an endpoint that authenticates the device, receives the telemetry, and allows bi-directional communication. When you create an IoT Hub service on Azure, it generates an endpoint. By default, the DNS name of an IoT hub looks like the following pattern: `{your iot hub name}.azure-devices.net`. For more information, see [IoT Hub endpoints](/azure/iot-hub/iot-hub-devguide-endpoints).

### Authentication

When you're migrating your IoT solution to Azure, a key element to consider is authentication. Azure IoT Hub supports the following authentication methods:

- [X.509 certificate](/azure/iot-hub/iot-hub-x509ca-overview)

  The X.509 CA feature enables device authentication to IoT Hub using a certificate authority (CA). X.509 CA simplifies the initial device enrollment process and supply chain logistics during device manufacturing. For more information, see [Understand how X.509 CA certificates are used in IoT](/azure/iot-hub/iot-hub-x509ca-concept).

- [Symmetric key](/azure/iot-dps/concepts-symmetric-key-attestation)

  A symmetric key is known to both the device and the service. The key is used to both encrypt and decrypt messages sent between parties. Azure IoT supports shared access signature token-based symmetric key connections. The best way to protect symmetric keys is by using a hardware security module.

- [Trusted Platform Module (TPM)](/azure/iot-dps/concepts-tpm-attestation)

  TPM can refer to a standard for securely storing keys used to authenticate the platform, or it can refer to the I/O interface used to interact with the modules implementing the standard. TPMs can exist as discrete hardware, integrated hardware, firmware-based modules, or software-based modules.

- [Elliptic Curve-cryptography (ECC) server TSL](/azure/iot-hub/iot-hub-tls-support#elliptic-curve-cryptography-ecc-server-tls-certificate-preview) (public preview).

Analyze whether you can or should continue to use current device credentials to authenticate with IoT Hub. Verify whether your current IoT cloud provider allows you to regenerate and export X.509 certificates. You could implement the certificates in your IoT Hub or services like Azure Deployment Planning Services. You can create an application using your current cloud providers REST API to export device identities.

For more information, see [Security recommendations for Azure IoT deployment](/azure/iot-fundamentals/security-recommendations) and [Security in your IoT workload](/azure/architecture/framework/iot/iot-security).

### Example of migration implementation

This example uses devices that need to continue using the JSON Web Token (JWT) tokens and ECC certificates.

If the devices in your current solution use JWT tokens, you might want to continue using the tokens to authenticate because they're pre-installed in your devices. You can create a device provisioning flow that uses Azure IoT Hub and the Azure IoT Hub device provisioning service.

Create individual enrollment in the device provisioning service and assign an Azure Function to validate the JWT token using a public key. The function returns the IoT hub assigned to the device only when the JWT Token is validated. Then the device provisioning service returns the credentials to devices.

In that way, the device sends the symmetric key and the signed JWT token during the provisioning. Then the device uses the symmetric key to maintain the connectivity and transmit telemetry.

:::image type="content" source="media/example-iot-migration.png" alt-text="Diagram shows a migration path where devices continue to use current tokens to authenticate as described in the steps below." border="false":::

### Dataflow

1. A device sends the enrollment symmetric key and JWT token signed using an ECC private key to the Azure IoT Hub device provisioning service. See this [IoT migration sample](https://github.com/Azure-Samples/iot-migration/blob/main/ecc-jwt/sample-device/mydevice.py).
2. The device provisioning service validates the symmetric key and sends the provisioning payload to a function by using an HTTP trigger.
3. The Azure Function app gets the public key from a secure store, such as Azure Key Vault.
4. The function app verifies the JWT token using the public key, validates the content, and returns the linked `iotHubHostName`. For more information, see [this sample](https://github.com/Azure-Samples/iot-migration/blob/main/ecc-jwt/function/validatejwt/__init__.py).
5. The device provisioning service registers a new device in IoT Hub using the symmetric key.
6. The device provisioning service returns the IoT Hub device connection details.
7. The device code connects to IoT Hub using the connection details and starts sending messages.

To get example code to implement the solution, see [Connecting to Azure IoT using JWT tokens signed using ECC certificates](https://github.com/Azure-Samples/iot-migration/tree/main/ecc-jwt).

## Device management

The key concepts for IoT Device Management are:

- Device provisioning
- Device configuration
- Device monitoring and diagnostic
- Security
- Device maintenance
- End of Life

For more information, see [Manage IoT devices by using IoT Hub and apps](/training/paths/use-iot-hub-apps-manage-iot-devices) and [Examine device configuration best practices](/training/modules/device-management-scale/5-device-configuration-best-practices).

### Configure and control your devices

Using [IoT Hub device twins](/azure/iot-hub/iot-hub-devguide-device-twins), you can synchronize state information between devices and the cloud:

- A device twin *desired property* is sent from the cloud to the device to define a new configuration value.
- A device twin *reported property* is sent from the device to the cloud to communicate the device state.
- Device twins are stored in the cloud. They can be queried at any moment to get device states.
- Commands are sent to the device, for instance, to perform an action and, in some cases, report a result.

There are two options to send commands from the cloud to the devices, depending on the use case you implement:

- [IoT Hub direct methods](/azure/iot-hub/iot-hub-devguide-direct-methods) uses synchronous communication for commands that require immediate confirmation.
- [Cloud-to-device messages](/azure/iot-hub/iot-hub-devguide-messages-c2d) uses asynchronous communication with the device.

Commands are invoked by using an HTTP call from the cloud. Commands can be received over MQTT from the device. For direct methods, the device can receive and respond to the commands by using either the Azure IoT SDK or [the MQTT protocol directly](/azure/iot-hub/iot-hub-mqtt-support#respond-to-a-direct-method).

When you migrate your IoT solution to Azure, you can implement device twins and commands using the Azure IoT SDK or [MQTT protocol directly](/azure/iot-hub/iot-hub-mqtt-support#using-the-mqtt-protocol-directly-as-a-device). If your application is currently using the MQTT protocol to configure devices, change the topics the device is subscribed to using the topic filter supported by the IoT Hub MQTT broker:

| | MQTT topics / Device | MQTT topics / Cloud |
|:--|:--|:--|
| **Telemetry/Device-to-cloud messages** | Publish to `devices/<device-id>/messages/events/` or `devices/<device-id>/messages/events/<property-bag>` | |
| **Device Configuration / Desired properties** | Subscribe to `$iothub/twin/PATCH/properties/desired/#` | Publish to `$iothub/twin/PATCH/properties/desired/?$version=<new-version>` |
| **Device State / Reported properties** | Publish to `$iothub/twin/PATCH/properties/reported/?$rid=<request-id>` to send the property value. Subscribe to `$iothub/twin/res/#` to receive the response from IoT Hub | Publish to `$iothub/twin/res/<status>/?$rid=<request-id>` to send the response to the device |
| **Commands / Direct methods** | Subscribe to `$iothub/methods/POST/#` and publish to `$iothub/methods/res/<status>/?$rid=<request-id>` to send the command response | Publish to `$iothub/methods/POST/<method-name>/?$rid=<request-id>` |
| **Commands / Cloud-to-device messages** | Subscribe to `devices/<device-id>/messages/devicebound/#` | Publish to `devices/<device-id>/messages/devicebound/` or `devices/<device-id>/messages/devicebound/<property-bag>` |

### Provision devices

Device provisioning is key to scaling your solution, managing the life cycle of your device, and creating In an IoT solution.

Consider using the IoT Hub device provisioning service, which is a helper service for IoT Hub that enables zero-touch, just-in-time provisioning to the right IoT hub without requiring human intervention. This approach allows customers to provision millions of devices in a secure and scalable manner. For more information, see [What is Azure IoT Hub Device Provisioning Service?](https://learn.microsoft.com/azure/iot-dps/about-iot-dps)

### Onboard devices with a device provisioning service by using MQTT

You can use the Azure IoT SDK or the [MQTT protocol directly](/azure/iot-dps/iot-dps-mqtt-support) to provision your devices. This example uses the SDK.

:::image type="content" source="media/device-onboard-dps-mqtt.png" alt-text="Diagram shows device onboarding with DPS using MQTT as described in the steps below." border="false":::

### Dataflow

1. Create a shared access signature token to authenticate the device with the device provisioning service and updates it in the device.
1. The device connects with device provisioning service.
   1. The device publishes a `CONNECT` message to the device provisioning service.
   1. The device `Subscribes` to the device provisioning service with topic filter `$dps/registrations/res/#` to receive registration responses.
   1. The device `Publishes` a register message to the device provisioning service on topic `$dps/registrations/PUT/iotdps-register/?$rid=<request_id>`.
1. The device provisioning service authenticates the device, registers the device and defines `deviceId` and IoTHub endpoint.
1. The device gets the `deviceId` and IoT Hub endpoint.
   1. The device `Publishes` the device provisioning service on topic `$dps/registrations/GET/iotdps-get-operationstatus/?$rid=<request_id>&operationId=<operationId>` to pull for the registration result.
   1. When registration is completed, the `Subscriber` receives the deviceId and IoT Hub endpoint.
1. The device connects with IoT Hub and sends telemetry.
   1. The device sends a `CONNECT` message to the IoT Hub MQTT broker.
   1. The device starts publishing telemetry messages to the IoT Hub MQTT broker.

> [!IMPORTANT]
> Reserved topics are used for the device provisioning service provisioning process.

### Onboard devices without a device provisioning service by using MQTT without an SDK

This section describes the flow of the reserved topics to use to onboard with MQTT and the device provisioning service with no SDK required.

:::image type="content" source="media/device-onboard-mqtt.png" alt-text="Diagram shows device onboarding without DPS using MQTT as described in the steps below." border="false":::

### Dataflow

1. Generate credentials for the device on IoT Hub and updates them in the device. Credentials are either shared access signature or X.509 certificates.
1. The device publishes a `CONNECT` message to the IoT Hub MQTT broker with credentials. The device must know the `deviceId` and MQTT broker endpoint.
1. The device starts publishing telemetry messages to the IoT Hub MQTT broker.

For more information, see [Communicate with your IoT hub using the MQTT protocol](/azure/iot-hub/iot-hub-mqtt-support).

## Cloud services

As part of migration, you can integrate with other cloud services and third-party services, use Azure for data storage and other services, and create applications in Azure.

### Integrate with other cloud services by using IoT Hub message routing

Receiving data from IoT Hub isn't the final goal. You need to transform, store, and analyze messages.

IoT Hub has a default built-in-endpoint that's compatible with Azure Event Hubs. You can create custom endpoints to route messages to by linking other services in your subscription to IoT Hub. Each message is routed to all endpoints whose routing queries it matches. A message can be routed to multiple endpoints. For more information, see [Routing endpoints](/azure/iot-hub/iot-hub-devguide-messages-d2c#routing-endpoints).

Use Azure Functions for IoT to create IoT solutions that you can rapidly deploy. You don't have to provision a fixed infrastructure capacity in advance. Using this approach, you can create scalable IoT applications where the solution needs the business logic running with IoT devices. Use the Azure Function triggers to respond to an event sent to an IoT hub event stream.

You must have read access to the underlying event hub to set up the trigger. When the function is triggered, the message passed to the function is typed as a string. For an example that shows the integration between Azure Function and IoT Hub, see [Azure IoT Hub bindings for Azure Functions](/azure/azure-functions/functions-bindings-event-iot).

### Use Azure services for data storage and analytics

Azure offers services for a wide variety of data-related needs, including file storage and relational databases like [Azure SQL](https://azure.microsoft.com/products/azure-sql) and managed open-source databases like [Azure Database for PostgreSQL](https://azure.microsoft.com/products/postgresql). Azure also offers more specialized services, such as [Azure Data Explorer](https://azure.microsoft.com/products/data-explorer) and [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db).

[Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) offers a mix of data warehouse and data lake capabilities. If you need a data warehouse, create a SQL pool, which lets you run SQL queries on structured relational tables. If you want a data lake, create a Spark pool, which lets you use Spark to query both structured and unstructured data.

[Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) is built on [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs). It provides the capabilities needed for a modern data lake. It’s compatible with Hadoop and Spark, which are the most popular open-source software systems for doing data analytics.

[Microsoft Purview](https://azure.microsoft.com/products/purview) provides a unified data governance solution to help manage and govern your on-premises, multicloud, and software as a service (SaaS) data. Create a holistic, up-to-date map of your data landscape with automated data discovery, sensitive data classification, and end-to-end data lineage. Enable data consumers to access valuable, trustworthy data management.

### Options to create applications on Azure

This article focuses on migration. There are more services for you to consider that aren't covered in this article.

[Azure Digital Twins](https://azure.microsoft.com/products/digital-twins) is a platform as a service (PaaS) offering that enables the creation of twin graphs based on digital models of entire environments. Environments include buildings, factories, farms, energy networks, railways, stadiums, and even entire cities. Use these digital models to gain insights that drive better products, optimized operations, reduced costs, and breakthrough customer experiences. For more information, see [What is Azure Digital Twins?](/azure/digital-twins/overview) and [Get started with 3D Scenes Studio for Azure Digital Twins](/azure/digital-twins/quickstart-3d-scenes-studio).

[Azure Kubernetes Service (AKS)](https://azure.microsoft.com/products/kubernetes-service) is a managed container orchestration service based on the open-source Kubernetes system. AKS simplifies deploying a managed Kubernetes cluster by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance. Since Azure manages Kubernetes control nodes, you manage and maintain only the agent nodes. For information on how to integrate Azure services with IoT Hub and AKS to build an IoT application, see [IoT Connected Platform for COVID-19 detection and prevention](../../solution-ideas/articles/iot-connected-platform.yml). For more information, see [Introduction to Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/intro-kubernetes).

Consider these services in future iterations of the architecture design.

## Contributors
  
*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Chafia Aouissi](https://www.linkedin.com/in/caouissi ) | Senior PM Manager
- [Armando Blanco Garcia](https://www.linkedin.com/in/armbla) | Senior Program Manager
- [Valeria Naldi](https://www.linkedin.com/in/valerianaldi) | Principal Software Engineering

Other contributors:

- [Emmanuel Bertrand](https://www.linkedin.com/in/bertrandemmanuel) | Principal PM Manager
- [Peter Tuton](https://www.linkedin.com/in/petertuton) | Principal Cloud Solution Architect
- [Jomit Vaghela](https://www.linkedin.com/in/jomit) | Principal Program Manager
- [Ansley Yeo](https://www.linkedin.com/in/ansleyyeo) | Principal Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Here are examples of architectures and quick starts to understand how to use Azure services to build IoT solutions.

- [Overview of Well-Architected Framework for IoT](/azure/architecture/framework/iot/iot-overview)
- [Azure cloud migration best practices checklist](/azure/cloud-adoption-framework/migrate/azure-best-practices)
- [Introduction to the Azure migration guide](/azure/cloud-adoption-framework/migrate/azure-migration-guide/?tabs=MigrationTools)

## Related resources

- [Get started with Azure IoT solutions](../../reference-architectures/iot/iot-architecture-overview.md)
- [Azure IoT reference architecture](../../reference-architectures/iot.yml)
- [Create smart places by using Azure Digital Twins](../../example-scenario/iot/smart-places.yml)
- [Industrial IoT Patterns](../iiot-patterns/iiot-patterns-overview.yml)
- [Video capture and analytics for retail](../../solution-ideas/articles/video-analytics.yml)
