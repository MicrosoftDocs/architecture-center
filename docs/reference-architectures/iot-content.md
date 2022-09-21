You can create custom IoT solutions by assembling Azure PaaS (platform-as-a-service) components as this article outlines. The article and this diagram describe Azure components and services IoT solutions commonly use, but no single solution uses all of these components.

## Architecture

:::image type="content" source="./iot/images/iot-refarch.svg" alt-text="Diagram showing architecture for IoT applications using Azure PaaS components." border="false" lightbox="./iot/images/iot-refarch.svg#lightbox":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-reference-architecture.vsdx) of this architecture.*

### Workflow

Azure IoT solutions involve:

- **Things**, typically **devices** that generate data.
- **Insights** that you form about the data.
- **Actions** that you take based on insights.

For example, a motor sends temperature data. You use this data to evaluate whether the motor is performing as expected. You use the insight about the motor's performance to prioritize its maintenance schedule.

#### Devices

Azure IoT supports a large range of devices, from microcontrollers running [Azure RTOS](/azure/rtos) and [Azure Sphere](/azure-sphere/product-overview/what-is-azure-sphere) to developer boards like [MX Chip](/samples/azure-samples/mxchip-iot-devkit-pnp-get-started/sample/) and Raspberry Pi. Azure IoT also supports smart server gateways capable of running custom code. Devices might perform some local processing through a service such as [Azure IoT Edge](/azure/iot-edge), or just connect directly to Azure so that they can send data to and receive data from the IoT solution.

When devices are connected to the cloud, there are several services that assist with ingesting data. [Azure IoT Hub](/azure/iot-hub) is a cloud gateway service that can securely connect and manage devices. [Azure IoT Hub Device Provisioning Service (DPS)](/azure/iot-dps/about-iot-dps) enables zero-touch, just-in-time provisioning that helps to register a large number of devices in a secure and scalable manner. [Azure Digital Twins](/azure/digital-twins) enables virtual models of real world systems.

#### Insights

Once devices are connected to the cloud, you can process and explore their data to gain customized insights about their environment. At a high level, there are three ways to process data: hot path, warm path, and cold path. The paths differ in their requirements for latency and data access.

- The **hot path** analyzes data in near-real-time as it arrives. Hot path telemetry must be processed with very low latency. The hot path typically uses a stream processing engine. Consider using services such as [Azure Stream Analytics](/azure/stream-analytics) or [Azure HDInsight](/azure/hdinsight). The output might trigger an alert, or be written to a structured format that can be queried using analytical tools.
- The **warm path** analyzes data that can accommodate longer delays for more detailed processing. Consider [Azure Data Explorer](/azure/data-explorer) for storing and analyzing large volumes of data.
- The **cold path** performs batch processing at longer intervals, like hourly or daily. The cold path typically operates over large volumes of data, which can be stored in [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction). Results don't need to be as timely as in the hot or warm paths. Consider using [Azure Machine Learning](/azure/machine-learning) or [Azure Databricks](/azure/databricks) to analyze cold data.

#### Actions

You can use the insights you gather about your data to manage and control your environment. Business integration actions might include:

- Storing informational messages.
- Raising alarms.
- Sending email or SMS messages.
- Integrating with business applications such as customer relationship management (CRM) and enterprise resource planning (ERP).

You can use the following services for management and business integration:

- [Power BI](/power-bi/connect-data) connects to, models, and visualizes your data. Power BI lets you collaborate on data and use artificial intelligence to make data-driven decisions.
- [Azure Maps](/azure/azure-maps) creates location-aware web and mobile applications by using geospatial APIs, SDKs, and services like search, maps, routing, tracking, and traffic.
- [Azure Cognitive Search](/azure/search) provides a search service over varied types of content. Cognitive Search includes indexing, AI enrichment, and querying capabilities.
- [Azure API Management](/azure/api-management) provides a single place to manage all of your APIs.
- [Azure App Service](/azure/app-service) deploys web applications that scale with your organization.
- [Azure Mobile Apps](/azure/developer/mobile-apps) builds cross platform and native apps for iOs, Android, Windows, or Mac.
- [Dynamics 365](/dynamics365) combines CRM and ERP in the cloud.
- [Microsoft Power Automate (Microsoft Flow)](/power-automate/getting-started) is a SaaS offering for automating workflows across applications and other SaaS services.
- [Azure Logic Apps](/azure/logic-apps) creates and automates workflows that integrate your apps, data, services, and systems.

Azure also provides several services to help you monitor your entire IoT solution and keep it secure. Diagnostic services include [Azure Monitor](/azure/azure-monitor). Security services such as [Azure Active Directory (Azure AD)](/azure/active-directory) and [Microsoft Defender for IoT](/azure/defender-for-iot) help you control, view, and manage security settings and threat detection and response.

### Components

- [Azure RTOS](https://azure.microsoft.com/services/rtos)
- [Azure Sphere](https://azure.microsoft.com/services/sphere)
- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge)
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub)
- [Azure IoT Hub Device Provisioning Service (DPS)](/azure/iot-dps)
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins)
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs)
- [Azure Functions](https://azure.microsoft.com/services/functions)
- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics)
- [Azure HDInsight](https://azure.microsoft.com/services/hdinsight)
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer)
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake)
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning)
- [Azure Databricks](https://azure.microsoft.com/services/databricks)
- [Power BI](https://powerbi.microsoft.com)
- [Azure Maps](https://azure.microsoft.com/services/azure-maps)
- [Azure Cognitive Search](https://azure.microsoft.com/services/search)
- [API Management](https://azure.microsoft.com/services/api-management)
- [Azure App Service](https://azure.microsoft.com/services/app-service)
- [Azure Mobile Apps](https://azure.microsoft.com/services/app-service/mobile)
- [Dynamics 365](https://dynamics.microsoft.com)
- [Microsoft Power Automate (Microsoft Flow)](https://powerautomate.microsoft.com)
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps)
- [Azure Monitor](https://azure.microsoft.com/services/monitor)
- [Azure AD](https://azure.microsoft.com/services/active-directory)
- [Microsoft Defender for IoT](https://azure.microsoft.com/services/iot-defender)

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Manageability

You can use Azure Digital Twins to control and monitor connected environments. A digital twin is a virtual model of a real-world environment that is driven with data from business systems and IoT devices. Businesses and organizations use digital twins to enable insights and actions. Developers and architects use digital twin solutions to help implement intelligent and connected environments such as:

- Predictive maintenance in manufacturing.
- Supply chain visibility.
- Smart shelves for real-time inventory.
- Connected homes and smart buildings.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview)."

A key area of consideration for resilient IoT solutions is business continuity and disaster recovery. Designing for High Availability (HA) and Disaster Recovery (DR) can help you define and achieve required uptime goals for your solution.

Different Azure services offer different options for redundancy and failover to help you achieve the uptime goals that best suit your business objectives. Incorporating any of these HA/DR alternatives into your IoT solution requires a careful evaluation of the trade-offs between the:

- Level of resiliency you require.
- Implementation and maintenance complexity.
- Cost of Goods Sold (COGS) impact.

You can find service-specific performance information in the documentation for each Azure IoT service.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview). This section contains considerations for building secure solutions.

#### Zero trust security model

Zero trust is a security model that assumes breaches will happen, and treats every access attempt as if it originates from an open network. Zero trust assumes that you've implemented the basics, such as securing identities and limiting access.

Basic security implementation includes explicitly verifying users, having visibility into their devices, and being able to make dynamic access decisions using real-time risk detection. After you do the basics, you can shift your focus to the following zero trust requirements for IoT solutions:

- Use strong identity to authenticate devices.
- Use least privileged access to mitigate blast radius.
- Monitor device health to gate access or flag devices for remediation.
- Perform updates to keep devices healthy.
- Monitor to detect and respond to emerging threats.

#### Trustworthy and secure communication

All information received from and sent to a device must be trustworthy. Unless a device can support the following cryptographic capabilities, it should be constrained to local networks, and all inter-network communication should go through a field gateway:

- Data encryption and digital signatures with a provably secure, publicly analyzed, and broadly implemented symmetric-key encryption algorithm.
- Support for either TLS 1.2 for TCP or other stream-based communication paths, or DTLS 1.2 for datagram-based communication paths. Support of X.509 certificate handling is optional. You can replace X.509 certificate handling with the more compute-efficient and wire-efficient pre-shared key mode for TLS, which you can implement with support for the AES and SHA-2 algorithms.
- Updateable key-store and per-device keys. Each device must have unique key material or tokens that identify it to the system. The devices should store the key securely on the device (for example, using a secure key store). The device should be able to update the keys or tokens periodically, or reactively in emergency situations such as a system breach.
- The firmware and application software on the device must allow for updates to enable the repair of discovered security vulnerabilities.

Many devices are too constrained to support these requirements. In that case, you should use a field gateway. Devices connect securely to the field gateway through a local area network, and the gateway enables secure communication to the cloud.

#### Physical tamper-proofing

Recommended device design incorporates features that defend against physical manipulation attempts, to help ensure the security, integrity, and trustworthiness of the overall system.

For example:

- Choose microcontrollers/microprocessors or auxiliary hardware that provides secure storage and use of cryptographic key material, such as trusted platform module (TPM) integration.
- Anchor secure boot loader and secure software loading in the TPM.
- Use sensors to detect intrusion attempts and attempts to manipulate the device environment, with alerting and potential "digital self-destruction" of the device.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

In general, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Build your solution to deploy at global scale. For optimal scalability, build your IoT application with discrete services that can scale independently. This section describes scalability considerations for several Azure services.

#### IoT Hub

Each IoT hub is provisioned with a certain number of units in a specific pricing and scale tier. The tier and number of units determine the maximum daily quota of messages that devices can send to the hub. For more information, see [IoT Hub quotas and throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling). You can scale up a hub without interrupting existing operations.

For IoT Hub, consider the following scale factors:

- The maximum [daily quota](/azure/iot-hub/iot-hub-devguide-quotas-throttling) of messages into IoT Hub.
- The quota of connected devices in an IoT Hub instance.
- Ingestion throughput: How quickly IoT Hub can ingest messages.
- Processing throughput: How quickly the incoming messages are processed.

IoT Hub automatically partitions device messages based on the device ID. All of the messages from a particular device will always arrive on the same partition, but a single partition will have messages from multiple devices. Therefore, the unit of parallelization is the partition ID.

#### Azure Functions

When [Azure Functions](/azure/azure-functions) reads from an [Azure Event Hubs](/azure/event-hubs) endpoint, there's a maximum number of function instances per event hub partition. The maximum processing rate is determined by how fast one function instance can process the events from a single partition. The function should process messages in batches.

#### Stream Analytics

Stream Analytics jobs scale best if they're parallel at all points in the Stream Analytics pipeline, from input to query to output. A fully parallel job allows Stream Analytics to split the work across multiple compute nodes. For more information, see [Leverage query parallelization in Azure Stream Analytics](/azure/stream-analytics/stream-analytics-parallelization).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Matthew Cosner](https://www.linkedin.com/in/matthew-cosner-447843225) | Principal Software Engineering Manager

Other contributor:

- [Armando Blanco Garcia](https://www.linkedin.com/in/armbla) | Senior Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Azure IoT Reference Architecture](https://azure.microsoft.com/resources/microsoft-azure-iot-reference-architecture)
- [Internet of Things (IoT) security architecture](/azure/iot-fundamentals/iot-security-architecture)
- [Zero Trust Cybersecurity for the Internet of Things](https://azure.microsoft.com/resources/zero-trust-cybersecurity-for-the-internet-of-things)
- [Azure Business Continuity Technical Guidance](/azure/architecture/framework/resiliency/overview)
- [Disaster recovery and high availability for Azure applications](/azure/architecture/framework/resiliency/backup-and-recovery)

## Related resources

- [IoT conceptual overview](../example-scenario/iot/introduction-to-solutions.yml)
- [Choose an Internet of Things (IoT) solution in Azure](../example-scenario/iot/iot-central-iot-hub-cheat-sheet.yml)
- [Azure industrial IoT analytics guidance](../guide/iiot-guidance/iiot-architecture.yml)
- [Industry specific Azure IoT reference architectures](iot/industry-iot-hub-page.md)
- [Create smart places by using Azure Digital Twins](../example-scenario/iot/smart-places.yml)
- [IoT and data analytics](../example-scenario/data/big-data-with-iot.yml)
