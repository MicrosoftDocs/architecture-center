The recommended way to get started with internet-of-things (IoT) applications is to use [Azure IoT Central](/azure/iot-central), an IoT application platform-as-a-service (aPaaS) that simplifies and accelerates IoT solution development and operations. IoT Central preassembles, scales, and manages many of the Azure platform-as-a-service (PaaS) services this article describes. IoT Central provides an out-of-box, ready to use UX and API surface area, complete with the capabilities you need to connect, manage, and operate fleets of devices at scale.

Alternatively, you can create custom IoT solutions by assembling Azure PaaS (platform-as-a-service) components as this article outlines. The article and this diagram describe Azure components and services IoT solutions commonly use, but no single solution uses all of these components.

To help decide between IoT Central and a PaaS-based IoT approach, based on your solution's needs, see [Choose an Internet of Things (IoT) solution in Azure](../example-scenario/iot/iot-central-iot-hub-cheat-sheet.yml).

[ ![Diagram showing architecture for I O T applications using Azure PaaS components.](./iot/images/iot-refarch.svg) ](./iot/images/iot-refarch.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/azure-iot-reference-architecture.vsdx) of this architecture.*

## Workflow

Azure IoT solutions involve:

- **Things**, typically **devices** that generate data.
- **Insights** that you form about the data.
- **Actions** that you take based on insights.

For example, a motor sends temperature data. You use this data to evaluate whether the motor is performing as expected. You use the insight about the motor's performance to prioritize its maintenance schedule.

To see IoT architectures for industry-specific solutions, see [Industry specific IoT reference architectures](iot/industry-iot-hub-page.md).

### Devices

Azure IoT supports a large range of devices, from microcontrollers running Azure RTOS and [Azure Sphere](/azure-sphere/product-overview/what-is-azure-sphere) to developer boards like [MX Chip](/samples/azure-samples/mxchip-iot-devkit-get-started/sample) and Raspberry Pi. Azure IoT also supports smart server gateways capable of running custom code. Devices might perform some local processing through a service such as **Azure IoT Edge**, or just connect directly to Azure so that they can send data to and receive data from the IoT solution.

When devices are connected to the cloud, there are several services that assist with ingesting data. **Azure IoT Hub** is a cloud gateway service that can securely connect and manage devices. **IoT Hub Device Provisioning Service (DPS)** enables zero-touch, just-in-time provisioning that helps to register a large number of devices in a secure and scalable manner. **Azure Digital Twins** enables virtual models of real world systems.

### Insights

Once devices are connected to the cloud, you can process and explore their data to gain customized insights about their environment. At a high level, there are three ways to process data: hot path, warm path, and cold path. The paths differ in their requirements for latency and data access.

- The **hot path** analyzes data in near-real-time as it arrives. Hot path telemetry must be processed with very low latency. The hot path typically uses a stream processing engine. Consider using services such as **Azure Stream Analytics** or **HDInsight**. The output might trigger an alert, or be written to a structured format that can be queried using analytical tools.
- The **warm path** analyzes data that can accommodate longer delays for more detailed processing. Consider **Azure Data Explorer** for storing and analyzing large volumes of data.
- The **cold path** performs batch processing at longer intervals, like hourly or daily. The cold path typically operates over large volumes of data, which can be stored in **Azure Data Lake**. Results don't need to be as timely as in the hot or warm paths. Consider using **Azure Machine Learning** or **Azure Databricks** to analyze cold data.

### Actions

You can use the insights you gather about your data to manage and control your environment. Business integration actions might include:

- Storing informational messages.
- Raising alarms.
- Sending email or SMS messages.
- Integrating with business applications such as customer relationship management (CRM) and enterprise resource planning (ERP).

You can use the following services for management and business integration:

- **Power BI** connects to, models, and visualizes your data. Power BI lets you collaborate on data and use artificial intelligence to make data-driven decisions.
- **Azure Maps** creates location-aware web and mobile applications by using geospatial APIs, SDKs, and services like search, maps, routing, tracking, and traffic.
- **Azure Cognitive Search** provides a search service over varied types of content. Cognitive Search includes indexing, AI enrichment, and querying capabilities.
- **Azure API Management** provides a single place to manage all of your APIs.
- **Azure Web Apps** deploys web applications that scale with your organization.
- **Mobile Apps** builds cross platform and native apps for iOs, Android, Windows, or Mac.
- **Dynamics 365** combines CRM and ERP in the cloud.
- **Microsoft Flow** is a SaaS offering for automating workflows across applications and other SaaS services.
- **Azure Logic Apps** creates and automates workflows that integrate your apps, data, services, and systems.

Azure also provides several services to help you monitor your entire IoT solution and keep it secure. Diagnostic services include **Azure Monitor**. Security services such as **Azure Active Directory (Azure AD)** and **Microsoft Defender for IoT** help you control, view, and manage security settings and threat detection and response.

## Manageability considerations

You can use **Azure Digital Twins** to control and monitor connected environments. A digital twin is a virtual model of a real-world environment that is driven with data from business systems and IoT devices. Businesses and organizations use digital twins to enable insights and actions. Developers and architects use digital twin solutions to help implement intelligent and connected environments such as:

- Predictive maintenance in manufacturing.
- Supply chain visibility.
- Smart shelves for real-time inventory.
- Connected homes and smart buildings.

## Scalability considerations

Build your solution to deploy at global scale. For optimal scalability, build your IoT application with discrete services that can scale independently. This section describes scalability considerations for several Azure services.

**Functions**. When functions read from the Event Hubs endpoint, there's a maximum number of function instances per event hub partition. The maximum processing rate is determined by how fast one function instance can process the events from a single partition. The function should process messages in batches.

**IoT Hub**. For IoT Hub, consider the following scale factors:

- The maximum [daily quota](/azure/iot-hub/iot-hub-devguide-quotas-throttling) of messages into IoT Hub.
- The quota of connected devices in an IoT Hub instance.
- Ingestion throughput: How quickly IoT Hub can ingest messages.
- Processing throughput: How quickly the incoming messages are processed.

Each IoT hub is provisioned with a certain number of units in a specific pricing and scale tier. The tier and number of units determine the maximum daily quota of messages that devices can send to the hub. For more information, see [IoT Hub quotas and throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling). You can scale up a hub without interrupting existing operations.

**Stream Analytics**. Stream Analytics jobs scale best if they're parallel at all points in the Stream Analytics pipeline, from input to query to output. A fully parallel job allows Stream Analytics to split the work across multiple compute nodes. For more information, see [Leverage query parallelization in Azure Stream Analytics](/azure/stream-analytics/stream-analytics-parallelization).

IoT Hub automatically partitions device messages based on the device ID. All of the messages from a particular device will always arrive on the same partition, but a single partition will have messages from multiple devices. Therefore, the unit of parallelization is the partition ID.

## Security considerations

This section contains considerations for building secure solutions.

### Zero trust security model

Zero trust is a security model that assumes breaches will happen, and treats every access attempt as if it originates from an open network. Zero trust assumes that you've implemented the basics, such as securing identities and limiting access. Basic security implementation includes explicitly verifying users, having visibility into their devices, and being able to make dynamic access decisions using real-time risk detection. After you meet the basics, you can shift your focus to the following zero trust requirements for IoT solutions:

- Use strong identity to authenticate devices.
- Use least privileged access to mitigate blast radius.
- Monitor device health to gate access or flag devices for remediation.
- Perform updates to keep devices healthy.
- Monitor to detect and respond to emerging threats.

Read the [Zero Trust Cybersecurity for the Internet of Things](https://azure.microsoft.com/en-us/resources/zero-trust-cybersecurity-for-the-internet-of-things/) whitepaper for full details.

### Trustworthy and secure communication

All information received from and sent to a device must be trustworthy. Unless a device can support the following cryptographic capabilities, it should be constrained to local networks, and all inter-network communication should go through a field gateway:

- Data encryption and digital signatures with a provably secure, publicly analyzed, and broadly implemented symmetric-key encryption algorithm.
- Support for either TLS 1.2 for TCP or other stream-based communication paths, or DTLS 1.2 for datagram-based communication paths. Support of X.509 certificate handling is optional. You can replace X.509 certificate handling with the more compute-efficient and wire-efficient pre-shared key mode for TLS, which you can implement with support for the AES and SHA-2 algorithms.
- Updateable key-store and per-device keys. Each device must have unique key material or tokens that identify it to the system. The devices should store the key securely on the device (for example, using a secure key-store). The device should be able to update the keys or tokens periodically, or reactively in emergency situations such as a system breach.
- The firmware and application software on the device must allow for updates to enable the repair of discovered security vulnerabilities.

Many devices are too constrained to support these requirements. In that case, a field gateway should be used. Devices connect securely to the field gateway through a local area network, and the gateway enables secure communication to the cloud.

### Physical tamper-proofing

Recommended device design incorporates features that defend against physical manipulation attempts, to help ensure the security integrity and trustworthiness of the overall system.

For example:

- Choose microcontrollers/microprocessors or auxiliary hardware that provides secure storage and use of cryptographic key material, such as trusted platform module (TPM) integration.
- Secure boot loader and secure software loading anchored in the TPM.
- Use sensors to detect intrusion attempts and attempts to manipulate the device environment with alerting and potential "digital self-destruction" of the device.

For more security considerations, see [Internet of Things (IoT) security architecture](/azure/iot-fundamentals/iot-security-architecture).

## Availability considerations

A key area of consideration for resilient IoT solutions is business continuity and disaster recovery. Designing for High Availability (HA) and Disaster Recovery (DR) can help you define and achieve required uptime goals for your solution.

Different Azure services offer different options for redundancy and failover to help you achieve the uptime goals that best suit your business objectives. Incorporating any of these HA/DR alternatives into your IoT solution requires a careful evaluation of the trade-offs between the:

- Level of resiliency you require
- Implementation and maintenance complexity
- Cost of Goods Sold (COGS) impact

The article [Azure Business Continuity Technical Guidance](/azure/architecture/resiliency) describes a general framework to help you think about business continuity and disaster recovery. The [Disaster recovery and high availability for Azure applications](/azure/architecture/reliability/disaster-recovery) paper provides architecture design guidance on strategies for Azure applications to achieve High Availability (HA) and Disaster Recovery (DR).

You can also find service-specific performance information in the documentation for each Azure IoT service.

## Cost considerations

In general, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview).

## Next steps

For more information about the individual pieces of a solution architecture, see the following product pages:

- [Azure IoT Edge](/azure/iot-edge/)
- [Azure IoT Hub](/azure/iot-hub/)
- [Azure IoT Hub Device Provisioning Service (DPS)](/azure/iot-dps/)
- [Azure Digital Twins](/azure/digital-twins/)
- [Azure Stream Analytics](/azure/stream-analytics/)
- [Azure HDInsight](/azure/hdinsight/)
- [Azure Data Explorer](/azure/data-explorer/)
- [Azure Machine Learning](/azure/machine-learning/)
- [Azure Databricks](/azure/databricks/)
- [Power BI](/power-bi/connect-data/)
- [Azure Maps](/azure/azure-maps/)
- [Azure Cognitive Search](/azure/search/)
- [API Management](/azure/api-management/)
- [Azure App Service](/azure/app-service/)
- [Azure Mobile Apps](/azure/developer/mobile-apps/)
- [Dynamics 365](/dynamics365/)
- [Microsoft Power Automate (Microsoft Flow)](/power-automate/getting-started)
- [Azure Logic Apps](/azure/logic-apps/)
