


This reference architecture shows a recommended architecture for IoT applications on Azure using PaaS (platform-as-a-service) components.

![Diagram of the architecture](./_images/iot-refarch.svg)

IoT applications can be described as **things** (devices) sending data that generates **insights**. These insights generate **actions** to improve a business or process. An example is an engine (the thing) sending temperature data. This data is used to evaluate whether the engine is performing as expected (the insight). The insight is used to proactively prioritize the maintenance schedule for the engine (the action).

This reference architecture uses Azure PaaS (platform-as-a-service) components. Another recommended option for building IoT solutions on Azure is:

- [Azure IoT Central](/azure/iot-central/). IoT Central is a fully managed SaaS (software-as-a-service) solution. It abstracts the technical choices and lets you focus on your solution exclusively. This simplicity comes with a tradeoff in being less customizable than a PaaS-based solution.

At a high level, there are two ways to process telemetry data, hot path and cold path. The difference has to do with requirements for latency and data access.

- The **hot path** analyzes data in near-real-time, as it arrives. In the hot path, telemetry must be processed with very low latency. The hot path is typically implemented using a stream processing engine. The output may trigger an alert, or be written to a structured format that can be queried using analytical tools.
- The **cold path** performs batch processing at longer intervals (hourly or daily). The cold path typically operates over large volumes of data, but the results don't need to be as timely as the hot path. In the cold path, raw telemetry is captured and then fed into a batch process.

## Architecture

This architecture consists of the following components. Some applications may not require every component listed here.

**IoT devices**. Devices can securely register with the cloud, and can connect to the cloud to send and receive data. Some devices may be **edge devices** that perform some data processing on the device itself or in a field gateway. We recommend [Azure IoT Edge](/azure/iot-edge/) for edge processing.

**Cloud gateway**. A cloud gateway provides a cloud hub for devices to connect securely to the cloud and send data. It also provides device management, capabilities, including command and control of devices. For the cloud gateway, we recommend [IoT Hub](/azure/iot-hub/). IoT Hub is a hosted cloud service that ingests events from devices, acting as a message broker between devices and backend services. IoT Hub provides secure connectivity, event ingestion, bidirectional communication, and device management.

**Device provisioning.** For registering and connecting large sets of devices, we recommend using the [IoT Hub Device Provisioning Service](/azure/iot-dps/) (DPS). DPS lets you assign and register devices to specific Azure IoT Hub endpoints at scale.

**Stream processing**. Stream processing analyzes large streams of data records and evaluates rules for those streams. For stream processing, we recommend [Azure Stream Analytics](/azure/stream-analytics/). Stream Analytics can execute complex analysis at scale, using time windowing functions, stream aggregations, and external data source joins. Another option is Apache Spark on [Azure Databricks](/azure/azure-databricks/).

**Machine learning** allows predictive algorithms to be executed over historical telemetry data, enabling scenarios such as predictive maintenance. For machine learning, we recommend [Azure Machine Learning](/azure/machine-learning/service/).

**Warm path storage** holds data that must be available immediately from device for reporting and visualization. For warm path storage, we recommend [Cosmos DB](/azure/cosmos-db/introduction). Cosmos DB is a globally distributed, multi-model database. 

**Cold path storage** holds data that is kept longer-term and is used for batch processing. For cold path storage, we recommend [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction). Data can be archived in Blob storage indefinitely at low cost, and is easily accessible for batch processing.

**Data transformation** manipulates or aggregates the telemetry stream. Examples include protocol transformation, such as converting binary data to JSON, or combining data points. If the data must be transformed before reaching IoT Hub, we recommend using a [protocol gateway](/azure/iot-hub/iot-hub-protocol-gateway) (not shown). Otherwise, data can be transformed after it reaches IoT Hub. In that case, we recommend using [Azure Functions](/azure/azure-functions/), which has built-in integration with IoT Hub, Cosmos DB, and Blob Storage.

**Business process integration** performs actions based on insights from the device data. This could include storing informational messages, raising alarms, sending email or SMS messages, or integrating with CRM. We recommend using [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) for business process integration.

**User management** restricts which users or groups can perform actions on devices, such as upgrading firmware. It also defines capabilities for users in applications. We recommend using [Azure Active Directory](/azure/active-directory/) to authenticate and authorize users.

**Security monitoring** [Azure Security Center for IoT](/azure/asc-for-iot/overview) provides an end-to-end security solution for IoT workloads and simplifies their protection by delivering unified visibility and control, adaptive threat prevention, and intelligent threat detection and response across workloads from leaf devices through Edge as well as up through the clouds.

## Scalability considerations

An IoT application should be built as discrete services that can scale independently. Consider the following scalability points:

**IoTHub**. For IoT Hub, consider the following scale factors:

- The maximum [daily quota](/azure/iot-hub/iot-hub-devguide-quotas-throttling) of messages into IoT Hub.
- The quota of connected devices in an IoT Hub instance.
- Ingestion throughput &mdash; how quickly IoT Hub can ingest messages.
- Processing throughput &mdash; how quickly the incoming messages are processed.

Each IoT hub is provisioned with a certain number of units in a specific tier. The tier and number of units determine the maximum daily quota of messages that devices can send to the hub. For more information, see IoT Hub quotas and throttling. You can scale up a hub without interrupting existing operations.

**Stream Analytics**. Stream Analytics jobs scale best if they are parallel at all points in the Stream Analytics pipeline, from input to query to output. A fully parallel job allows Stream Analytics to split the work across multiple compute nodes. Otherwise, Stream Analytics has to combine the stream data into one place. For more information, see [Leverage query parallelization in Azure Stream Analytics](/azure/stream-analytics/stream-analytics-parallelization).

IoT Hub automatically partitions device messages based on the device ID. All of the messages from a particular device will always arrive on the same partition, but a single partition will have messages from multiple devices. Therefore, the unit of parallelization is the partition ID.

**Functions**. When reading from the Event Hubs endpoint, there is a maximum of function instance per event hub partition. The maximum processing rate is determined by how fast one function instance can process the events from a single partition. The function should process messages in batches.

**Cosmos DB**. To scale out a Cosmos DB collection, create the collection with a partition key and include the partition key in each document that you write. For more information, see [Best practices when choosing a partition key](/azure/cosmos-db/partitioning-overview#choose-partitionkey).

- If you store and update a single document per device, the device ID is a good partition key. Writes are evenly distributed across the keys. The size of each partition is strictly bounded, because there is a single document for each key value.
- If you store a separate document for every device message, using the device ID as a partition key would quickly exceed the 10-GB limit per partition. Message ID is a better partition key in that case. Typically you would still include device ID in the document for indexing and querying.

**Azure Time Series Insights (TSI)** is an analytics, storage and visualization service for time-series data, providing capabilities including SQL-like filtering and aggregation, alleviating the need for user-defined functions. [Time Series Insights](/azure/time-series-insights/overview-what-is-tsi) provides a data explorer to visualize and query data as well as REST Query APIs. In addition to time series data, TSI is also well-suited for solutions that need to query aggregates over large sets of data. With support for multi layered storage, rich APIs, model and it’s integration with Azure IoT ecosystem, explorer for visualizations, and extensibility through Power BI, etc. TSI is our recommendation for time series data storage and analytics.

## Security considerations

### Trustworthy and secure communication

All information received from and sent to a device must be trustworthy. Unless a device can support the following cryptographic capabilities, it should be constrained to local networks and all internetwork communication should go through a field gateway:

- Data encryption with a provably secure, publicly analyzed, and broadly implemented symmetric-key encryption algorithm.
- Digital signature with a provably secure, publicly analyzed, and broadly implemented symmetric-key signature algorithm.
- Support for either TLS 1.2 for TCP or other stream-based communication paths or DTLS 1.2 for datagram-based communication paths. Support of X.509 certificate handling is optional and can be replaced by the more compute-efficient and wire-efficient pre-shared key mode for TLS, which can be implemented with support for the AES and SHA-2 algorithms.
- Updateable key-store and per-device keys. Each device must have unique key material or tokens that identify it toward the system. The devices should store the key securely on the device (for example, using a secure key-store). The device should be able to update the keys or tokens periodically, or reactively in emergency situations such as a system breach.
- The firmware and application software on the device must allow for updates to enable the repair of discovered security vulnerabilities.

However, many devices are too constrained to support these requirements. In that case, a field gateway should be used. Devices connect securely to the field gateway through a local area network, and the gateway enables secure communication to the cloud.

### Physical tamper-proofing

It is strongly recommended that device design incorporates features that defend against physical manipulation attempts, to help ensure the security integrity and trustworthiness of the overall system.

For example:

- Choose microcontrollers/microprocessors or auxiliary hardware that provides secure storage and use of cryptographic key material, such as trusted platform module (TPM) integration.
- Secure boot loader and secure software loading, anchored in the TPM.
- Use sensors to detect intrusion attempts and attempts to manipulate the device environment with alerting and potentially "digital self-destruction" of the device.

For additional security considerations, see [Internet of Things (IoT) security architecture](/azure/iot-fundamentals/iot-security-architecture).

### Monitoring and logging

Logging and monitoring systems are used to determine whether the solution is functioning and to help troubleshoot problems. Monitoring and logging systems help answer the following operational questions:

- Are devices or systems in an error condition?
- Are devices or systems correctly configured?
- Are devices or systems generating accurate data?
- Are systems meeting the expectations of both the business and end customers?

Logging and monitoring tools are typically comprised of the following four components:

- System performance and timeline visualization tools to monitor the system and for basic troubleshooting.
- Buffered data ingestion, to buffer log data.
- Persistence store to store log data.
- Search and query capabilities, to view log data for use in detailed troubleshooting.

Monitoring systems provide insights into the health, security, and stability, and performance of an IoT solution. These systems can also provide a more detailed view, recording component configuration changes and providing extracted logging data that can surface potential security vulnerabilities, enhance the incident management process, and help the owner of the system troubleshoot problems. Comprehensive monitoring solutions include the ability to query information for specific subsystems or aggregating across multiple subsystems.

Monitoring system development should begin by defining healthy operation, regulatory compliance, and audit requirements. Metrics collected may include:

- Physical devices, edge devices, and infrastructure components reporting configuration changes.
- Applications reporting configuration changes, security audit logs, request rates, response times, error rates, and garbage collection statistics for managed languages.
- Databases, persistence stores, and caches reporting query and write performance, schema changes, security audit log, locks or deadlocks, index performance, CPU, memory, and disk usage.
- Managed services (IaaS, PaaS, SaaS, and FaaS) reporting health metrics and configuration changes that impact dependent system health and performance.

Visualization of monitoring metrics alert operators to system instabilities and facilitate incident response.

### Tracing telemetry

Tracing telemetry allows an operator to follow the journey of a piece of telemetry from creation through the system. Tracing is important for debugging and troubleshooting. For IoT solutions that use Azure IoT Hub and the [IoT Hub Device SDKs](/azure/iot-hub/iot-hub-devguide-sdks), tracing datagrams can be originated as Cloud-to-Device messages and included in the telemetry stream.

### Logging

Logging systems are integral in understanding what actions or activities a solution has performed, failures that have occurred, and can provide help in fixing those failures. Logs can be analyzed to help understand and remedy error conditions, enhance performance characteristics, and ensure compliance with governing rule and regulations.

Though plain-text logging is lower impact on upfront development costs, it is more challenging for a machine to parse/read. We recommend structured logging be used, as collected information is both machine parsable and human readable. Structured logging adds situational context and metadata to the log information. In structured logging, properties are first class citizens formatted as key/value pairs, or with a fixed schema, to enhance search and query capabilities.

## DevOps considerations

Use the Infrastructure as code (IaC). IaC is the management of infrastructure (networks, virtual machines, load balancers, and connection topology) with a declarative approach. Templates should be versioned and part of the release pipeline. The most reliable deployment processes are automated and idempotent. One way is to create [Azure Resource Manager template][arm-template] for provisioning the IoT resources and the infrastructure.

To automate infrastructure deployment, you can use Azure DevOps Services, Jenkins, or other CI/CD solutions. Azure [Pipelines][pipelines] is part of [Azure DevOps Services][az-devops] and runs automated builds, tests, and deployments.

Consider staging your workloads by deploying to various stages and running validations at each stage before moving on to the next one; that way you can push updates to your production environments in a highly controlled way and minimize unanticipated deployment issues. [Blue-green deployment][blue-green-dep] and [Canary releases][cannary-releases] are recommended deployment strategies for updating live production environments. Also consider having a good rollback strategy for when a deployment fails; for example you could automatically redeploy an earlier, successful deployment from your deployment history, the --rollback-on-error flag parameter in Azure CLI is good example. 

Consider monitoring your solution by using [Azure Monitor][az-monitor]. Azure Monitor is the main source of monitoring and logging for all your Azure services, it provides diagnostics information for Azure resources. You can for example, monitor the operations that take place within your IoT hub. There are specific metrics and events that Azure Monitor supports, as well as services, schemas, and categories for Azure Diagnostic Logs.

For more information, see the DevOps section in [Microsoft Azure Well-Architected Framework][AAF-devops].

## Cost considerations
In general, use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

There are ways to optimize costs associated the services used in this reference architecture. 

### Azure IoT Hub

In this architecture, IoT Hub is the cloud gateway that ingests events from devices. IoT Hub billing varies depending on the type of operation. Create, update, insert, delete are free. Successful operations such as device-to-cloud and cloud-to-device messages are charged. 

Device-to-cloud messages sent successfully are charged in 4-KB chunks on ingress into IoT Hub. For example, a 6-KB message is charged as two messages.

IoT Hub maintains state information about each connected device in a device twin JSON document. Read operations from a device twin document are charged. 

IoT Hub offers two tiers: **Basic** and **Standard**. 

Consider using the **Standard** tier if your IoT architecture uses bi-directional communication capabilities. This tier also offers a free edition that is most suited for testing purposes.

If you only need uni-directional communication from devices to the cloud, use the **Basic** tier, which is cheaper.

For more information, see [IoT Hub Pricing](/azure/iot-hub/iot-hub-devguide-pricing). 

### Azure Stream Analytics

Azure Stream Analytics is used for stream processing and rules evaluation. Azure Stream Analytics is priced by the number of Streaming Units (SU) per hour, which takes into compute, memory, and throughput required to process the data. Azure Stream Analytics on IoT Edge is billed per job. Billing starts when a Stream Analytics job is deployed to devices regardless of the job status, running, failed, or stopped.

For more information about pricing, see [Stream Analytics pricing](https://azure.microsoft.com/pricing/details/stream-analytics/).

### Azure Functions

Azure Functions is used to transform data after it reaches the IoT Hub. From a cost perspective, the recommendation is to use **consumption plan** because you pay only for the compute resources you use. You are charged based on per-second resource consumption each time an event triggers the execution of the function. Processing several events in a single execution or batches can reduce cost.

### Azure Logic Apps

In this architecture, Logic Apps is used for business process integration.

Logic apps pricing works on the pay-as-you-go model. Triggers, actions, and connector executions are metered each time a logic app runs. All successful and unsuccessful actions, including triggers, are considered as executions.

For instance, your logic app processes 1000 messages a day. A workflow of five actions will cost less than $6. 

For more information, see [Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/).

### Data Storage

For cold path storage, Azure Blob Storage is the most cost-effective option.

For warm path storage, consider using Azure Cosmos DB. For more information, see [Cosmos DB pricing](https://azure.microsoft.com/pricing/details/cosmos-db/).


## Next steps

- For a more detailed discussion of the recommended architecture and implementation choices, see [Microsoft Azure IoT Reference Architecture](https://download.microsoft.com/download/A/4/D/A4DAD253-BC21-41D3-B9D9-87D2AE6F0719/Microsoft_Azure_IoT_Reference_Architecture.pdf) (PDF).

- For detailed documentation of the various Azure IoT services, see [Azure IoT Fundamentals](/azure/iot-fundamentals/).

[AAF-devops]: ../framework/devops/overview.md
[az-devops]: /azure/devops/index?view=azure-devops&preserve-view=true
[az-monitor]: https://azure.microsoft.com/services/monitor/
[blue-green-dep]: https://martinfowler.com/bliki/BlueGreenDeployment.html
[cannary-releases]: https://martinfowler.com/bliki/CanaryRelease.html
[pipelines]: /azure/devops/pipelines/?view=azure-devops&preserve-view=true
[arm-template]: /azure/azure-resource-manager/resource-group-overview#resource-groups
[aaf-cost]: ../framework/cost/overview.md
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator