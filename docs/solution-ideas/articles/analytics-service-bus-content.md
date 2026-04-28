[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Cloud architects, data engineers, and retail solution strategists can use this architecture to build a scalable, secure, and intelligent real-time analytics solution by using Azure Service Bus and Fabric Real-Time Intelligence. This solution provides actionable insights from high-velocity data streams. It's ideal for scenarios like personalized product recommendations, dynamic pricing, and inventory optimization.

## Architecture

:::image type="complex" border="false" source="../media/fabric-real-time-intelligence-service-bus.svg" alt-text="Diagram that shows an architecture for implementing near real-time analytics in Fabric with Service Bus." lightbox="../media/fabric-real-time-intelligence-service-bus.svg":::
   The diagram shows a near real-time analytics architecture across Azure and Fabric. On the left, two source streams feed ingestion. User interaction events from mobile and inventory updates flow into Service Bus, and high-velocity clickstream and browsing data flow into an eventstream. Inside the Fabric boundary, an eventstream routes events to an eventhouse. From the eventhouse, one path stores data in OneLake through the lakehouse SQL endpoint for downstream consumption, and another path supports analysis through a KQL queryset. A Fabric data agent also connects to the stored and queried data to provide conversational access. On the right, analysis and action outputs branch to a Fabric activator and to real-time dashboards and Power BI for visualization. Microsoft Purview appears as a governance layer for the Fabric data estate.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/fabric-real-time-intelligence-service-bus.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram.

#### Ingestion

1. Service Bus receives discrete, transactional events like inventory updates, purchase transactions, loyalty program updates, and customer feedback submissions.

   *Example:* A customer redeems loyalty points at checkout. This action initiates a Service Bus message to update the customer profile and inventory.

2. The eventstream ingests continuous, high-velocity data with subsecond latency.

   *Example:* A user browses 20 products in 30 seconds. Clickstream data flows into the eventstream for immediate analysis.

3. The eventstream brings real-time events into Fabric, transforms them, and routes them to various destinations without requiring you to write any code.

   *Example:* Enrich clickstream data automatically with product metadata before routing to analytics.

#### Storage and querying

4. Eventhouse stores real-time event data and supports querying through the Kusto Query Language (KQL).

   *Example:* Query all purchases of *wireless headphones* in the last five minutes across Melbourne stores.

5. The Fabric lakehouse makes data available for other use cases like syncing to external systems or SQL endpoint compatibility. This step is optional.

   *Example:* Run monthly sales trend analysis by using SQL on historical data.

#### Action systems

6. Analytics that use KQL querysets support a wide range of data discovery capabilities, like time-series analysis, text parsing, geospatial queries, vector similarity search, anomaly detection, outlier detection, pattern discovery, and the creation of statistical models.

   *Example:* Detect anomalies in checkout behavior, like sudden spikes in cart abandonment.

7. Visualize insights and actions in near real-time by using real-time dashboards and Power BI.

   *Example:* Store managers view live dashboards that show top-selling items and customer sentiment.

8. Monitor live streams and trigger actions based on patterns. A Fabric activator monitors data at multiple stages, including from the eventstream during ingestion or from the reporting layer. Actions include Microsoft Teams notifications, email, Fabric items like running a pipeline or notebook, or Power Automate flows.

   *Example:* If a product's stock doesn't meet a specific threshold, trigger a restock workflow.

#### AI capabilities

9. Fabric data agents expose data connected to eventhouse for conversational experiences against real-time data. You can use Microsoft Copilot Studio to expose this chat experience directly in Teams, or use Microsoft Foundry for app-based chat experiences.

   *Example:* Provide a natural language interface for store managers to determine the top-selling items in the last five minutes.

### Components

- [Service Bus](/azure/well-architected/service-guides/azure-service-bus) is a managed message broker for decoupled communication between applications and services. In this architecture, Service Bus receives transactional events from mobile clients.

- A [Fabric eventstream](/fabric/real-time-intelligence/event-streams/overview) is a streaming data capability in Fabric that ingests, transforms, and routes real-time events. In this architecture, the Fabric eventstream ingests high-velocity clickstream and operational data and routes the processed stream to downstream analytics.

- A [Fabric eventhouse](/fabric/real-time-intelligence/eventhouse) is a KQL-based analytics store for real-time data exploration and querying. In this architecture, the Fabric eventhouse stores real-time events and supports KQL queries for operational and business insights.

- A [Fabric lakehouse](/fabric/data-engineering/lakehouse-overview) is a unified data platform for files, tables, and analytics workloads. In this architecture, a lakehouse optionally stores historical data for downstream SQL-based reporting and external integrations.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a business intelligence (BI) platform for interactive analytics and reporting. In this architecture, Power BI provides near real-time dashboards for store and operations teams.

- A [Fabric activator](/fabric/real-time-intelligence/data-activator/activator-introduction) is an event-driven capability that evaluates real-time signals and initiates actions when conditions are met. In this architecture, the Fabric activator monitors data patterns and triggers responses like notifications and automated workflows.

- [Fabric data agents](/fabric/data-science/how-to-create-data-agent) are conversational agents grounded in Fabric data sources. In this architecture, Fabric data agents provide natural language access to eventhouse data for real-time operational questions.

- [Copilot Studio](/microsoft-copilot-studio/fundamentals-what-is-copilot-studio) is a platform to build and publish copilots across channels. In this architecture, Copilot Studio exposes the data agent experience in Teams.

- [Foundry](/azure/foundry/what-is-foundry) is a platform to build and operate AI applications and agents. In this architecture, Foundry supports custom app-based chat experiences if solutions cannot be delivered through Copilot Studio.

- [Microsoft Purview](/purview/purview) is a data governance and compliance solution that supports data cataloging, classification, lineage, and policy management. In this architecture, Microsoft Purview helps govern Fabric data assets and enforce data access and compliance requirements.

### Security and governance

Security and governance are foundational to this architecture:

- **Microsoft Purview integration:** Use Microsoft Purview to apply data classification, lineage tracking, and access policies across Fabric workloads.

- **Role-based access control (RBAC):** Use RBAC to allow only authorized users to access sensitive data streams and dashboards.

- **Data encryption:** Encrypt data in transit and at rest by using Azure-native mechanisms.

- **Audit logging:** Monitor access and transformations to support compliance and operational transparency.

- **Event-level filtering:** Use Fabric activator to suppress or redirect sensitive events based on business rules.

- **Conditional access and private networking:** Use conditional access policies and private networking boundaries to reduce unauthorized access and data exposure.

## Resolve common challenges

This solution architecture resolves the following challenges:

- **Latency and scalability bottlenecks:** Real-Time Intelligence enables subsecond latency for streaming analytics, which allows organizations to ingest and process billions of events per day without manual scaling. It supports automatic scaling and low-latency ingestion from diverse sources like Internet of Things (IoT) devices, telemetry systems, and customer interactions.

- **Fragmented data streams:** Real-Time Intelligence unifies internal and external streaming sources into a central real-time hub, which eliminates silos and enables holistic operational visibility.

- **Delayed decision-making:** Real-time dashboards and alerting mechanisms in tools like Power BI, Teams, and automated workflows give teams immediate insight into anomalies, service-level agreement (SLA) breaches, or operational triggers. This immediate insight supports fast action and prevents delays.

- **Observability and monitoring gaps:** Real-Time Intelligence supports open telemetry standards, which enables cost-effective observability.

## Scenario details

A customer browses a retail app, selects products, adds items to a cart, or scans a loyalty card in-store. Each interaction streams in real time, which allows the system to immediately analyze behavior, recommend complementary products, apply targeted discounts, or notify staff to restock shelves.

### Potential use cases

Consider the following use cases.

#### E-commerce

- Monitor performance metrics and user behavior across platforms.

- Detect anomalies in transactions, page load times, and conversion funnels.

- Enable proactive problem resolution and personalized experiences.

#### Education

- Stream data from campus transport systems, security cameras, and access control points.

- Monitor student safety, optimize shuttle routes, and respond to incidents in real time.

#### Financial services

- Handle high-throughput transaction events from ATMs, mobile apps, and payment gateways.

- Use anomaly detection models to minimize fraud, improve compliance, and enhance trust.

#### Healthcare

- Transmit telemetry data from IoT-enabled medical devices to back-end systems.

- Analyze data streams for anomalies and trigger alerts for proactive care.

- Improve patient outcomes through real-time monitoring and intervention.

#### Hospitality

- Stream booking, occupancy, and housekeeping data to optimize room allocation and cleaning schedules.

- Enhance guest experience through real-time service coordination.

#### Manufacturing

- Stream telemetry from factory floor equipment to detect anomalies in vibration, temperature, and pressure.

- Enable predictive maintenance to reduce downtime and improve worker safety.

- Apply AI-powered video and image analysis to live camera feeds for defect detection and quality assurance. 

- Monitor production metrics and defect reports to detect bottlenecks and optimize throughput.

#### Quality and safety compliance

- Detect unsafe worker behavior, PPE violations, and hazardous conditions via environmental sensors and video feeds.

- Trigger real-time alerts and automate incident reports for regulatory compliance.

#### Site reliability and software engineering

- Stream deployment telemetry and error logs to detect regressions and failed rollouts.

- Unify application, infrastructure, and user telemetry into real-time dashboards.

- Monitor system health, detect bottlenecks, and correlate incidents.

- Expose real-time data streams via Fabric eventstreams and KQL for dynamic user experiences and operational insights.

#### Social media monitoring

- Ingest and analyze real-time social media streams to detect sentiment shifts, trending topics, and brand mentions.

- Trigger alerts for PR crises, customer complaints, or viral content.

- Support dynamic engagement strategies and campaign optimization.

#### Transportation

- Stream GPS and sensor data from vehicles, planes, and ships.

- Optimize routes, traffic, weather schedules, and fuel efficiency.

- Enhance customer experience through real-time updates and coordination.

#### Utilities and energy

- Collect smart meter data to identify outages, consumption anomalies, and peak load patterns.

- Enable dynamic pricing and predictive infrastructure maintenance.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Lauren Baird](https://www.linkedin.com/in/laurenkbaird/) | Cloud Solution Architect
- [Christopher Schmidt](https://www.linkedin.com/in/christophermschmidt/) | Enterprise AI & Data Strategy Leader

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Service Bus samples](/azure/service-bus-messaging/service-bus-samples)
- [Real-Time Intelligence end-to-end sample](/fabric/real-time-intelligence/sample-end-to-end)
- [Implement real-time intelligence with Fabric](/training/paths/explore-real-time-analytics-microsoft-fabric/)
- [Alert and act on data from the real-time hub](https://blog.fabric.microsoft.com/blog/alerting-and-acting-on-data-from-the-real-time-hub/)
- [Real-Time Intelligence documentation](/fabric/real-time-intelligence/)
- [Get events from Service Bus into real-time hub (preview)](/fabric/real-time-hub/add-source-azure-service-bus)
- [Create a data agent](/fabric/data-science/how-to-create-data-agent)
