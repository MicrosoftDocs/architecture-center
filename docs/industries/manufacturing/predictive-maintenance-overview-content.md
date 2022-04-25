Predictive maintenance (PdM) anticipates maintenance needs to avoid costs associated with unscheduled downtime. By connecting to devices and monitoring the data that the devices produce you can identify patterns that lead to potential problems or failures. You can then use these insights to address issues before they happen. This ability to predict when equipment or assets need maintenance allows you to optimize equipment lifetime and minimize downtime.

PdM extracts insights from the data that's produced by the equipment on the shop floor and then it acts on these insights. The idea of PdM goes back to the early 1990s. PdM augments regularly scheduled preventive maintenance. Early on, the unavailability of sensors to generate data, and a lack of computational resources to gather and analyze data, made it difficult to implement PdM. Today, because of advances in the Internet of Things (IoT), cloud computing, data analytics, and machine learning, PdM can go mainstream.

PdM requires data from sensors that monitor the equipment, and other operational data. The PdM system analyzes the data and stores the results. Humans act based on the analysis.

After introducing some background in this article, we discuss how to implement the various pieces of a PdM solution using a combination of on-premises data, Azure machine learning, and machine learning models. PdM relies heavily on data to make decisions, so we start by looking at data collection. The data must be collected and then used to evaluate what's happening now, as well as used to build up better predictive models in the future. Finally, we explain what an analysis solution looks like, including the visualizing of analysis results in a reporting tool like [Power BI](/power-bi).

## Maintenance strategies

Over the history of manufacturing, several maintenance strategies emerged:

- Reactive maintenance fixes issues after they occur.
- Preventive maintenance fixes issues before they occur by following a maintenance schedule based on prior failure experience.
- PdM also fixes issues before they occur, but considers the actual utilization of the equipment instead of working from a fixed schedule.

Of the three, PdM was the most difficult to achieve because of limitations on data collection, processing, and visualization. Let's look at each of these strategies in more detail.

### Reactive maintenance

Reactive maintenance services the asset only when the asset fails. For example, the motor of your 5-axis CNC machining center is serviced only when it stops working. Reactive maintenance maximizes the lifetime of components. It also introduces, among other issues, unknown amounts of downtime and unexpected collateral damage caused by failing components.

 ![Diagram that explains reactive maintenance.](images/predictive-maintenance-overview/maintenance-strategies-reactive.png)

### Preventive maintenance

Preventive maintenance services assets at pre-determined intervals. The interval for an asset is typically based on the asset's known failure frequency, historical performance, simulations, and statistical modeling. The advantage of preventive maintenance is that it increases uptime, results in fewer failures, and lets maintenance be planned. The downside in many cases is that the replaced component has some life left. This results in over-maintenance and waste. On the flip side, parts can fail before the scheduled maintenance. You probably know preventive maintenance well: after every set hours of operation (or some other metric), you stop the machine, inspect it, and replace any parts that are due to be replaced.

 ![Diagram that explains preventive maintenance.](./images/predictive-maintenance-overview/maintenance-strategies-preventative.png)

### PdM

PdM uses models to predict when an asset is likely to have a component fail, so that just-in-time maintenance can be scheduled. PdM improves on previous strategies by maximizing both uptime and asset life. Since you service the equipment close to the component maximum lifetimes, you spend less money replacing working parts. The downside is that the just-in-time nature of PdM is more difficult to execute since it requires a more responsive and flexible services organization. Back to the motor of the 5-axis CNC machining center, with PdM you schedule its maintenance at a convenient time that's close to the expected failure time of the motor.

 ![Diagram that explains PdM.](./images/predictive-maintenance-overview/maintenance-strategies-predictive.png)

## Different ways PdM can be offered

 A manufacturer can use PdM to monitor its own manufacturing operations. It can also use it in ways that provide new business opportunities and revenue streams. For example:

- A manufacturer adds value for its customers by offering PdM services for its products.
- A manufacturer offers its products under a Product-as-a-Service model in which customers subscribe to the product instead of purchasing it. Under this model, the manufacturer wants to maximize product uptime, since the product doesn't generate revenue when it doesn't work.
- A company provides PdM products and services for products manufactured by other manufacturers.

## Building a PdM solution

To build a PdM solution, we start with data. Ideally the data shows normal operation and what the the state of the equipment looked like before, during, and after a failure. The data comes from sensors, notes maintained by equipment operators, run information, environmental data, machine specifications, and so on. Systems of record can include historians, manufacturing execution systems, enterprise resource planning (ERP), and so on. The data is made available for analytics in a variety of ways. The following diagram illustrates [The Team Data Science Process (TDSP)](/azure/machine-learning/team-data-science-process). The process is customized for manufacturing and does an excellent job explaining the various concerns one has when building and executing machine learning models.

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

With Azure you can train and test the models on your technology of choice. You can use  GPUs, field-programmable gate arrays (FPGAs), CPUs, large-memory machines, and so on. Azure fully embraces the open-source tools that data scientists use, such as R and Python. As the analysis completes, the results can be displayed in other facets of the dashboard or in other reports. These reports can appear in custom tools or in reporting tools like [Power BI](/power-bi) or [Time Series Insights](/azure/time-series-insights).

Whatever your PdM needs, Azure has the tools, the scale, and the capabilities to build a solid solution.

## Getting started

A lot of equipment found on the factory floor generates data. Start collecting it as soon as possible. As failures occur, have the data scientists analyze the data to create models to detect future failures. As knowledge builds about failure detection, move to predictive mode where you fix components during planned downtime. The [Predictive Maintenance Modeling Guide](https://gallery.azure.ai/Collection/Predictive-Maintenance-Modelling-Guide-1) provides a solid walkthrough of building the machine learning pieces of the solution.

To see an example solution, review the solution, guide, and playbook for [PdM in Aerospace](https://github.com/Azure/cortana-intelligence-predictive-maintenance-aerospace). If you need to learn about building models, we recommend visiting [AI School](https://aischool.microsoft.com). The [Introduction to Machine Learning with Azure ML](https://aischool.microsoft.com/learning-paths/4ZYo4wHJVCsUSAKa2EoAk8) course will help provide familiarity with our tools..

## Components

- [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) stores from hundreds to billions of objects in hot, cool, or archive tiers, depending on how often data access is needed.
- [Azure Cosmos DB](/azure/cosmos-db) is a database for extremely low latency and massively scalable applications anywhere in the world, with native support for NoSQL.
- [Azure Data Lake Store](/azure/data-lake-store) includes all the capabilities required to make it easy for developers, data scientists, and analysts to store data of any size, shape, and speed, and do all types of processing and analytics across platforms and languages.
- [Azure Event Hubs](/azure/event-hubs) is a hyper-scale telemetry ingestion service that collects, transforms, and stores millions of events. As a distributed streaming platform, it gives you low latency and configurable time retention, which enables you to ingress massive amounts of telemetry into the cloud and read the data from multiple applications using publish-subscribe semantics.
- [Azure IoT Edge](/azure/iot-edge) is an Internet of Things (IoT) service that builds on top of IoT Hub. This service is meant for customers who want to analyze data on devices, also known as &quot;at the edge&quot;, instead of in the cloud. By moving parts of your workload to the edge, your devices can spend less time sending messages to the cloud and react more quickly to changes in status.
- [Azure IoT Hub](/azure/iot-hub) is a fully managed service that enables reliable and secure bidirectional communications between millions of IoT devices and a solution back end.
- [Azure Machine Learning](/azure/machine-learning) enables computers to learn from data and experiences and to act without being explicitly programmed. Customers can build Artificial Intelligence (AI) applications that intelligently sense, process, and act on information - augmenting human capabilities, increasing speed and efficiency, and helping organizations achieve more.
- [Azure Service Bus](/azure/service-bus) is a brokered communication mechanism. The core components of the Service Bus messaging infrastructure are queues, topics, and subscriptions.
- [Azure SQL Database](/azure/sql-database) is the intelligent, fully managed relational cloud database service that provides the broadest SQL Server engine compatibility, so you can migrate your SQL Server databases without changing your apps.
- [Power BI](/power-bi) is a suite of business analytics tools that deliver insights throughout your organization. Connect to hundreds of data sources, simplify data prep, and drive ad hoc analysis.
- [Time Series Insights](/azure/time-series-insights) is a fully managed analytics, storage, and visualization service for managing IoT-scale time-series data in the cloud.

## Conclusion

 PdM augments preventive maintenance schedules by identifying specific components to inspect and repair or replace. It requires machines that are instrumented and connected to provide data for us to build PdM solutions. Many resources exist to help you get started. Microsoft's infrastructure can help you build solutions that run on the device, at the edge, and in the cloud.

To begin, pick out the top one to three failures that you want to prevent and begin your discovery process with those items. Then, identify how to get the data that helps identify the failures. Combine that data with the skills that you get from the [Introduction to Machine Learning with Azure ML](https://aischool.microsoft.com/learning-paths/4ZYo4wHJVCsUSAKa2EoAk8) course to build your PdM models.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Scott Seely](https://www.linkedin.com/in/scottseely) | Software Architect

## Next steps

## Related resources
