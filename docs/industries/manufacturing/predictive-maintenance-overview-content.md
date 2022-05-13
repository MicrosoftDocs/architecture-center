Predictive maintenance (PdM) anticipates maintenance needs to avoid costs associated with unscheduled downtime. By connecting to devices and monitoring the data that the devices produce you can identify patterns that lead to potential problems or failures. You can then use these insights to address issues before they happen. This ability to predict when equipment or assets need maintenance allows you to optimize equipment lifetime and minimize downtime.

PdM extracts insights from the data that's produced by the equipment on the shop floor and then it acts on these insights. The idea of PdM goes back to the early 1990s. PdM augments regularly scheduled preventive maintenance. Early on, the unavailability of sensors to generate data, and a lack of computational resources to gather and analyze data, made it difficult to implement PdM. Today, because of advances in the Internet of Things (IoT), cloud computing, data analytics, and machine learning, PdM can go mainstream.

PdM requires data from sensors that monitor the equipment, and other operational data. The PdM system analyzes the data and stores the results. Humans act based on the analysis.

After introducing some background in this article, we discuss how to implement the various pieces of a PdM solution using a combination of on-premises data, Azure Machine Learning, and machine learning models. PdM relies heavily on data to make decisions, so we start by looking at data collection. The data must be collected and then used to evaluate what's happening now, as well as used to build up better predictive models in the future. Finally, we explain what an analysis solution looks like, including the visualizing of analysis results in a reporting tool like [Microsoft Power BI](/power-bi).

## Maintenance strategies

Over the history of manufacturing, several maintenance strategies emerged:

- Reactive maintenance fixes issues after they occur.
- Preventive maintenance fixes issues before they occur by following a maintenance schedule based on prior failure experience.
- PdM also fixes issues before they occur, but considers the actual utilization of the equipment instead of working from a fixed schedule.

Of the three, PdM was the most difficult to achieve because of limitations on data collection, processing, and visualization. Let's look at each of these strategies in more detail.

### Reactive maintenance

Reactive maintenance services the asset only when the asset fails. For example, the motor of your 5-axis CNC machining center is serviced only when it stops working. Reactive maintenance maximizes the lifetime of components. It also introduces, among other issues, unknown amounts of downtime and unexpected collateral damage caused by failing components.

 ![Diagram that illustrates reactive maintenance.](images/predictive-maintenance-overview/maintenance-strategies-reactive.png)

### Preventive maintenance

Preventive maintenance services assets at pre-determined intervals. The interval for an asset is typically based on the asset's known failure frequency, historical performance, simulations, and statistical modeling. The advantage of preventive maintenance is that it increases uptime, results in fewer failures, and lets maintenance be planned. The downside in many cases is that the replaced component has some life left. This results in over-maintenance and waste. On the flip side, parts can fail before the scheduled maintenance. You probably know preventive maintenance well: after every set hours of operation (or some other metric), you stop the machine, inspect it, and replace any parts that are due to be replaced.

 ![Diagram that illustrates preventive maintenance.](images/predictive-maintenance-overview/maintenance-strategies-preventative.png)

### PdM

PdM uses models to predict when an asset is likely to have a component fail, so that just-in-time maintenance can be scheduled. PdM improves on previous strategies by maximizing both uptime and asset life. Since you service the equipment at times that are close to the component maximum lifetimes, you spend less money replacing working parts. The downside is that the just-in-time nature of PdM is more difficult to execute since it requires a more responsive and flexible services organization. Back to the motor of the 5-axis CNC machining center, with PdM you schedule its maintenance at a convenient time that's close to the expected failure time of the motor.

 ![Diagram that illustrates PdM.](images/predictive-maintenance-overview/maintenance-strategies-predictive.png)

## Different ways PdM can be offered

 A manufacturer can use PdM to monitor its own manufacturing operations. It can also use it in ways that provide new business opportunities and revenue streams. For example:

- A manufacturer adds value for its customers by offering PdM services for its products.
- A manufacturer offers its products under a Product-as-a-Service model in which customers subscribe to the product instead of purchasing it. Under this model, the manufacturer wants to maximize product uptime, since the product doesn't generate revenue when it doesn't work.
- A company provides PdM products and services for products manufactured by other manufacturers.

## Building a PdM solution

To build a PdM solution, we start with data. Ideally the data shows normal operation and the state of the equipment before, during, and after failures. The data comes from sensors, notes maintained by equipment operators, run information, environmental data, machine specifications, and so on. Systems of record can include historians, manufacturing execution systems, enterprise resource planning (ERP), and so on. The data is made available for analytics in a variety of ways. The following diagram illustrates [The Team Data Science Process (TDSP)](/azure/machine-learning/team-data-science-process). The process is customized for manufacturing and does an excellent job of explaining the various concerns that one has when building and executing machine learning models.

:::image type="content" source="images/predictive-maintenance-overview/data-science-diagram-inline.png" alt-text="The diagram summarizes the Team Data Science Process." lightbox="images/predictive-maintenance-overview/data-science-diagram-inline.png":::

Your first task is to identify the types of failures you want to predict. With that in mind, you then identify the data sources that have relevant data about that failure type. The pipeline gets the data into the system from your environment. The data scientists use their favorite machine learning tools to prepare the data. At this point, they're ready to create and train models that can identify diverse types of issues. The models answer questions like:

- *For the asset, what's the probability that a failure occurs within the next X hours?* Answer: 0-100%
- *What's the remaining useful life of the asset?* Answer: X hours
- *Is this asset behaving in an unusual way?* Answer: Yes or No
- *Which asset requires servicing most urgently?* Answer: Asset X

Once developed, the models can run in:

- The equipment itself for self-diagnostics.
- An edge device in the manufacturing environment.
- Azure.

After deployment, you continue to build and maintain the PdM solution.

With Azure you can train and test the models on your technology of choice. You can use  GPUs, field-programmable gate arrays (FPGAs), CPUs, large-memory machines, and so on. Azure fully embraces the open-source tools that data scientists use, such as R and Python. As the analysis completes, the results can be displayed in other facets of the dashboard or in other reports. These reports can appear in custom tools or in reporting tools like [Power BI](/power-bi) or [Azure Time Series Insights](/azure/time-series-insights).

Whatever your PdM needs, Azure has the tools, the scale, and the capabilities to build a solid solution.

## Getting started

A lot of equipment found on the factory floor generates data. Start collecting it as soon as possible. As failures occur, have the data scientists analyze the data to create models to detect future failures. As knowledge builds about failure detection, move to predictive mode where you fix components during planned downtime. The [Predictive Maintenance Modeling Guide](https://gallery.azure.ai/Collection/Predictive-Maintenance-Modelling-Guide-1) provides a solid walkthrough of building the machine learning pieces of the solution.

To see an example solution, review the solution, guide, and playbook for [PdM in Aerospace](https://github.com/Azure/cortana-intelligence-predictive-maintenance-aerospace). If you need to learn about building models, we recommend visiting [Foundations of data science for machine learning](/learn/paths/machine-learning-foundations-using-data-science). The [Introduction to Azure Machine Learning](/learn/modules/intro-to-azure-ml) Learn module introduces you to Azure tools.

## Components

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) is scalable and secure object storage for unstructured data. You can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed, highly responsive, scalable NoSQL database for modern app development. It provides enterprise-grade security and supports APIs for many databases, languages, and platforms. Examples include SQL, MongoDB, Gremlin, Table, and Apache Cassandra. Serverless, automatic scaling options in Azure Cosmos DB efficiently manage the capacity demands of applications.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) is a massively scalable and secure storage service for high-performance analytics workloads. The data typically comes from multiple heterogeneous sources and can be structured, semi-structured, or unstructured. Data Lake Storage Gen2 combines Data Lake Storage Gen1 capabilities with Blob Storage, and provides file system semantics, file-level security, and scale. It also offers the tiered storage, high availability, and disaster recovery capabilities of Blob Storage.
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a highly scalable data streaming platform and event ingestion service, capable of receiving and processing millions of events per second. Event Hubs can process and store events, data, or telemetry produced by distributed software and devices. Data sent to an event hub can be transformed and stored using any real-time analytics provider or batching and storage adapters. Event Hubs provides publish-subscribe capabilities with low latency at massive scale, which makes it appropriate for big data scenarios.
- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge) deploys cloud workloads to run on edge devices via standard containers. IoT Edge intelligent devices can respond quickly and offline, reducing latency and bandwidth usage, and increasing reliability. They can also limit costs by preprocessing and sending only necessary data to the cloud. Devices can run AI and machine learning modules, Azure and third-party services, and custom business logic.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) is a fully managed service that enables reliable and secure bidirectional communications between millions of IoT devices and a cloud-based back end. It provides per-device authentication, message routing, integration with other Azure services, and management features to control and configure the devices.
- [Machine Learning](https://azure.microsoft.com/services/machine-learning) is an enterprise-grade machine learning service for building and deploying models quickly. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various IDEs.

  Machine learning enables computers to learn from data and experiences and to act without being explicitly programmed. Customers can build AI applications that intelligently sense, process, and act on information, augmenting human capabilities, increasing speed and efficiency, and helping organizations achieve more.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a fully managed enterprise message broker with message queues and publish-subscribe topics. It's used to connect applications, services, and devices. Together with Azure Relay, Service Bus can connect to remotely hosted applications and services.
- [Azure SQL](https://azure.microsoft.com/services/azure-sql) is a family of SQL cloud databases that provides a unified experience for your entire SQL portfolio, and a wide range of deployment options from edge to cloud.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database), part of the Azure SQL family, is a fully managed platform as a service (PaaS) database engine. It always runs on the latest stable version of the SQL Server database engine and patched OS. It handles most database management functions for you, including upgrading, patching, backups, and monitoring. It provides the broadest SQL Server engine compatibility, so you can migrate your SQL Server databases without changing your apps.
- [Power BI](https://powerbi.microsoft.com/) is a suite of business analytics tools that provides the capabilities to create rich interactive data visualizations. It includes services, apps, and connectors that can turn unrelated sources of data into coherent, visually immersive, and interactive insights. Power BI can connect to hundreds of data sources, simplify data preparation, and support ad hoc analysis.
- [Time Series Insights](https://azure.microsoft.com/services/time-series-insights) is a fully managed analytics, storage, and visualization service for time series data. It provides visualizations such as overlays of different time series, dashboard comparisons, accessible tabular views, and heat maps. It can receive data from Event Hubs, IoT Hub or Blob storage, and provides SQL-like filtering and aggregation, alleviating the need for user-defined functions. All data in Time Series Insights is stored in-memory and in SSDs, which ensures that the data is always ready for interactive analytics. For example, a typical aggregation of over tens of millions of events completes in milliseconds. Time Series Insights can give you a global view of your data, so that you can quickly validate your IoT solution and avoid costly downtime to mission-critical devices.  

## Conclusion

 PdM improves on preventive maintenance schedules by identifying specific components to inspect and repair or replace. It requires machines that are instrumented and connected to provide data for building PdM solutions.

There are many resources to help you get started.

Microsoft's infrastructure can help you build solutions that run on the device, at the edge, and in the cloud.

To begin, pick out the top one to three failures that you want to prevent and begin your discovery process with those items. Then, identify how to get the data that helps identify the failures. Combine that data with the skills that you get from the [Foundations of data science for machine learning](/learn/paths/machine-learning-foundations-using-data-science) course to build your PdM models.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Scott Seely](https://www.linkedin.com/in/scottseely) | Software Architect

## Next steps

- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Azure Cosmos DB documentation](/azure/cosmos-db)
- [Azure Data Lake Storage Gen1 documentation](/azure/data-lake-store)
- [Azure Event Hubs documentation](/azure/event-hubs)
- [Azure IoT Edge documentation](/azure/iot-edge)
- [Azure IoT Hub Documentation](/azure/iot-hub)
- [Azure Machine Learning documentation](/azure/machine-learning)
- [Azure Service Bus Messaging documentation](/azure/service-bus-messaging)
- [Azure Relay documentation](/azure/azure-relay)
- [Azure SQL documentation](/azure/azure-sql?view=azuresql)
- [Power BI documentation](/power-bi)
- [Azure Time Series Insights Documentation](/azure/time-series-insights)

## Related resources

- [Predictive maintenance solution](predictive-maintenance-solution.yml)
- [Extract actionable insights from IoT data](extract-insights-iot-data.yml)
- [Azure industrial IoT analytics guidance](../../guide/iiot-guidance/iiot-architecture.yml)
- [Condition monitoring for industrial IoT](../../solution-ideas/articles/condition-monitoring.yml)
- [Connected factory hierarchy service](../../solution-ideas/articles/connected-factory-hierarchy-service.yml)
- [Connected factory signal pipeline](../../example-scenario/iot/connected-factory-signal-pipeline.yml)
- [IoT Edge railroad maintenance and safety system](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml)
- [Quality assurance](../../solution-ideas/articles/quality-assurance.yml)
