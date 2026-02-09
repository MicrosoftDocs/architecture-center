[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how merchandise distributors can use AI and machine learning to predict a customer's future order quantity for a specific stock-keeping unit (SKU). Distributors use next-order forecasting to provide product recommendations and suggest optimal order quantities to customers. This article builds on the concepts described in the [many-models machine learning architecture](../../ai-ml/idea/many-models-machine-learning-azure-machine-learning.yml). 

## Architecture

:::image type="complex" border="false" source="./_images/next-order-forecasting.svg" alt-text="Diagram that shows an architecture for forecasting orders." lightbox="./_images/next-order-forecasting.svg":::
   The diagram shows a next-order forecasting workflow that has seven stages connected by arrows. Stage 1, the data sources, shows the orders database, customers database, merchandise database, and partner data sources feeding into stage 2, ingestion, which includes Azure Data Factory. Stage 3, the staging area, includes Azure Data Lake Storage, Azure SQL Database, and OneLake for data preparation. Stage 4, model training, features an Azure Machine Learning compute cluster and a model instance for parallel processing. Stage 4 also shows Microsoft Fabric with Spark compute to train machine learning models. Stage 5, model inferencing, deploys the trained machine learning model to managed online endpoints and real-time model endpoints to process data. Stage 6, analytical workload, shows Data Lake Storage, SQL Database, and OneLake for storing the prediction results. Stage 7, customer model consumption, shows Power BI dashboards, Power Apps, and the Web Apps feature of Azure App Service for delivering forecasting insights to customers.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/next-order-forecasting.pptx) of this architecture.*

### Dataflow

1. Data sources

   To forecast future orders, you need comprehensive data about your customers' buying history for various SKUs at specific stores, including information about preferences and purchasing behavior. This kind of information is typically obtained from orders, merchandise, and customer databases. You also need to consider external factors like weather, holidays, and events. This data is usually obtained from partner sources.

   To create order forecasting models, you use data in a schema that includes several key variables:

   - Date and time 
   - Customer store location
   - Merchandise SKU 
   - Quantity ordered
   - Price per unit
   - Weather-related features, holidays, events, and other external factors
   
   By analyzing this data, you can gain insights into customer behavior and make informed SKU and quantity recommendations for the customer's next order. 

1. Ingestion

   Data ingestion is the process of transferring data from various sources to a designated destination. This process uses specific connectors for each data source and target destination.
   
   Azure Data Factory provides connectors that you can use to extract data from various sources, including databases, file systems, and cloud services. These connectors are created by Microsoft or by partner vendors and are designed to function effectively with multiple data sources. For example, you can use [SAP connectors](/azure/data-factory/industry-sap-connectors) for various SAP data ingestion scenarios. You can use the [Snowflake connector](/azure/data-factory/connector-snowflake?tabs=data-factory) to copy data from Snowflake.

1. Staging area 

   The staging area serves as a temporary storage location between the source and the destination. The main purpose of this staging area is to maintain data in a uniform and structured format while it undergoes transformations or quality checks before it's loaded into its destination.

   A consistent data format is critical for accurate analysis and modeling. If you consolidate and prepare the data in a staging area, Azure Machine Learning can process it more efficiently.

1. Machine learning model training

   Model training is a machine learning process that uses an algorithm to learn patterns from data and, in this solution, select a model that can accurately predict a customer's next order.

   In this solution, you can use Machine Learning or Fabric Data Science to train models.

   - [Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) is used to manage the entire machine learning project life cycle, including training models, deploying models, and managing machine learning operations.

      - [Parallel jobs](/azure/machine-learning/how-to-use-parallel-job-in-pipeline) are used to process large amounts of data in parallel and create models that can forecast the next order for every customer store and merchandise SKU combination. You can reduce processing time by dividing the dataset into smaller parts and processing them simultaneously on multiple virtual machines. You can use Machine Learning compute clusters to distribute workloads across multiple nodes.

      - After the data is prepared, Machine Learning can start the parallel model training process by using parallel jobs with a range of forecasting models, including exponential smoothing, elastic net, and Prophet. Each node or compute instance starts building the model, so the process is more efficient and faster.

   - Apache Spark, a part of Microsoft Fabric, enables machine learning with big data. By using Apache Spark, you can build valuable insights into large masses of structured, unstructured, and fast-moving data. You have several available open-source library options when you [train machine learning models with Apache Spark in Fabric](/fabric/data-science/model-training-overview), including Apache Spark MLlib and [SynapseML](/fabric/data-science/synapseml-first-model).

1. Machine learning model inferencing

   Model inferencing is a process that uses a trained machine learning model to generate predictions for previously unseen data points. In this solution, it forecasts the quantity of the merchandise SKU that a customer is likely to purchase.

   - Machine Learning provides model registries for storing and versioning trained models. Model registries can help you organize and track trained models and ensure that they're readily available for deployment.

      - Deploying a trained machine learning model enables the model to process new data for inferencing. We recommend that you use [managed online endpoints](/azure/machine-learning/concept-endpoints-online) for the deployment target. Managed online endpoints enable easy scalability, performance tuning, and high availability.

        In this use case, there are two ways to deploy models on [managed online endpoints](/azure/machine-learning/how-to-deploy-online-endpoints). The first option is to deploy each model on its own managed online endpoint, as shown in the diagram. The second option is to bundle multiple models into a single model and deploy it on a single managed online endpoint. The latter approach is more efficient and provides an easier way to deploy and manage multiple models simultaneously.

   - Fabric provides real-time predictions from machine learning models by using secure, scalable, and easy-to-use online endpoints. These endpoints are available as built-in properties of most Fabric models.

      - You can activate, configure, and query model endpoints by using a [public-facing REST API](/rest/api/fabric/mlmodel/endpoint). You can get started from the Fabric interface by using a low-code experience to activate model endpoints and preview predictions.

1. Analytical workload

   The output of the model is stored in analytics systems like OneLake, Azure Data Lake Storage, or Azure SQL Database, where the input data is also collected and stored. This stage facilitates the availability of the prediction results for customer consumption, model monitoring, and new data for retraining models to improve their accuracy.

1. Customer consumption

   To visually present the scored model to customers, you can use the Web Apps feature of Azure App Service, a Power BI dashboard, or Power Apps. These platforms allow you to display SKU recommendations and predicted quantities in a clear, graphical format.

   Customers are notified of recommended SKUs and predicted quantities, so they can place orders proactively. The recommendations can help streamline the ordering process, reduce the likelihood of stockouts, and enhance customer satisfaction. If you use a Power BI dashboard or Power Apps, you can provide an informative ordering experience to your customers.

### Components

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an enterprise-ready, end-to-end analytics platform. It unifies data movement, data processing, ingestion, transformation, real-time event routing, and report building. It supports these capabilities with integrated services like Fabric Data Engineer, Azure Data Factory, Data Science, Fabric Real-Time Intelligence, Fabric Data Warehouse, and Fabric Databases. In this architecture, Fabric workloads are used to process and transform data to create end-to-end data science workflows.

  - [OneLake](/fabric/onelake/onelake-overview) is a single, unified, logical data lake for the whole organization. Every Fabric tenant automatically includes OneLake with no infrastructure to manage. In this architecture, OneLake is used to store data that's ingested from various sources. It also serves as a repository for data that trains machine learning models. This centralized storage system ensures efficient data management and access for analytical processes.

  - A [Fabric lakehouse](/fabric/data-engineering/lakehouse-overview) is a data architecture platform for storing, managing, and analyzing structured and unstructured data in a single location. It's a flexible and scalable solution that allows organizations to handle large volumes of data by using various tools and frameworks to process and analyze that data. It integrates with other data management and analytics tools to provide a solution for data engineering and analytics. A lakehouse combines the scalability of a data lake with the performance and structure of a data warehouse to provide a unified platform for data storage, management, and analytics. In this architecture, the Fabric lakehouse is a central hub for both structured and unstructured data from diverse sources. It helps you ensure that you have a thorough dataset. It also stores model outputs so that applications can easily access and consume prediction results.

  - [Data Warehouse](/fabric/data-warehouse/data-warehousing) is the data warehousing solution within Fabric. The lake-centric warehouse is built on a distributed processing engine that enables industry-leading performance at scale while minimizing the need for configuration and management. In this architecture, you use Data Warehouse to store transformed and unified data during the analytical workload phase instead of relying on a lakehouse. Use this [decision guide](/fabric/fundamentals/decision-guide-data-store) to help you choose a data store for your Fabric workloads.

- [Azure Data Factory](/azure/data-factory/introduction) is a cloud-based data integration service that automates data movement and transformation. In this architecture, Azure Data Factory ingests data from diverse sources and moves it through the pipeline for processing and analysis.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a limitless data storage service for housing data in various shapes and formats. It provides easy integration with the analytics tools in Azure. This solution uses a local data store for machine learning data and a premium data cache for training the machine learning model.

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is an enterprise-grade machine learning service that facilitates model development and deployment to a wide range of machine learning compute targets. In this architecture, it provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter Notebook environment that supports various integrated development environments.

   - [Machine Learning compute clusters](/azure/machine-learning/how-to-create-attach-compute-cluster?tabs=python) are managed compute structures that you can use to easily create single-node or multiple-node compute resources. In this architecture, compute clusters enable parallel processing to train multiple forecasting models simultaneously for every customer store and merchandise SKU combination.

   - [Machine Learning endpoints](/azure/machine-learning/concept-endpoints) are HTTPS endpoints that clients can call to receive the inferencing (scoring) output of a trained model. An endpoint provides a stable scoring URI that's authenticated via key-and-token authentication. In this architecture, endpoints enable applications to get real-time predictions for customer order quantities.

   - [Machine Learning pipelines](/azure/machine-learning/concept-ml-pipelines) are independently executable workflows of complete machine learning tasks. In this architecture, pipelines can help you standardize the best practices of producing a machine learning model and improve model-building efficiency.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is an always-up-to-date, fully managed relational database service that's built for the cloud. In this architecture, it stores structured data, such as order history and model outputs, to support analytical workloads and reporting.

- [Power BI](/power-bi/fundamentals/power-bi-overview) provides business analytics and visually immersive and interactive insights. In this architecture, Power BI provides dashboards and reports that present insights and recommendations that the machine learning models generate.

- [Power Apps](/power-apps/powerapps-overview) is a platform for building custom business applications quickly. In this architecture, use Power Apps to create user-facing applications that display personalized order recommendations. Data can be stored in the underlying data platform ([Microsoft Dataverse](/powerapps/maker/data-platform/data-platform-intro)) or in various online and on-premises data sources, like SharePoint, Microsoft 365, Dynamics 365, and SQL Server.

- [Web applications](/dotnet/architecture/modern-web-apps-azure) that are built with ASP.NET Core and hosted in Azure provide competitive advantages over traditional alternatives. ASP.NET Core is optimized for modern web application development practices and cloud hosting scenarios. In this architecture, web applications can serve as portals for users to access forecasted recommendations and interact with the ordering system.

### Alternatives

- Machine Learning provides data modeling and deployment in this solution. Alternatively, you can use [Data Science](/fabric/data-science/data-science-overview) experiences that empower users to build end-to-end data science workflows. You can complete a wide range of activities across the entire data science process. Your choice between Machine Learning and Fabric depends on factors such as the scale of your data science operations, the complexity of your machine learning tasks, and integration with other tools and services that you already use. Both platforms provide coverage across a range of requirements and features, which makes them suitable for a wide range of scenarios.

   You can also use Azure Databricks to explore and manipulate data in this solution. Azure Databricks uses a notebook-based interface that supports the use of Python, R, Scala, and SQL. Azure Databricks mainly provides data processing and analysis capabilities.

   Use [OneLake](/fabric/onelake/onelake-overview) to mount your existing platform as a service (PaaS) storage accounts by using the [shortcut](/fabric/onelake/onelake-shortcuts) feature. You don't migrate or copy your existing data. Shortcuts provide direct access to data in Data Lake Storage. They also enable data sharing between users and applications without duplicating files. You can also create shortcuts to other storage systems so that you can analyze cross-cloud data with intelligent caching that reduces egress costs and brings data closer to compute.

   [Fabric Data Factory](/fabric/data-factory/data-factory-overview) provides a modern data integration experience to ingest, prepare, and transform data from a rich set of data sources. It incorporates the simplicity of Power Query, and you can use more than 200 native connectors to connect to data sources on-premises and in the cloud. You can use Fabric data pipelines instead of Azure Data Factory pipelines for data integration, depending on several factors. For more information, see [Compare Azure Data Factory and Fabric Data Factory](/fabric/data-factory/compare-fabric-data-factory-and-azure-data-factory).

   Databases in Fabric are developer-friendly, transactional databases like SQL Database that help you create your operational database in Fabric. Use the mirroring capability to bring data from various systems together into OneLake. You can continuously replicate your existing data estate directly into OneLake, including data from SQL Database, Azure Cosmos DB, Azure Databricks, Snowflake, and Fabric SQL databases. For more information, see [SQL database in Fabric](/fabric/database/sql/overview) and [Mirroring in Fabric](/fabric/mirroring/overview).

- Power BI is a popular tool for visualization. Grafana is another option. The main difference is that Grafana is open source, while Power BI is a software as a service (SaaS) offering from Microsoft. If you prioritize customization and the use of open-source tools, Grafana is a better choice. If you prioritize integration with other Microsoft products and product support, Power BI is a better choice.

- Instead of using an endpoint for each model, you can bundle multiple models into a single model for deployment to a single managed online endpoint. Bundling models for deployment is known as *model orchestration*. Potential drawbacks of using this approach include increased complexity, potential conflicts between models, and increased risk of downtime if the single endpoint fails.

## Scenario details

The merchandise distribution industry historically struggles to gain insights into customer behavior and purchasing patterns, which makes it difficult to provide personalized product recommendations, improve customer satisfaction, and drive sales. By using AI and machine learning, merchandise distributors can transform the industry.

By adopting next-order forecasting, organizations can recommend products and quantities based on customer purchasing patterns. This methodology benefits customers by consolidating orders and reducing transportation and logistics costs. It also allows distributors to establish smart contracts with regular customers. These contracts enable distributors to proactively recommend products and quantities at a regular cadence, manage inventory, influence manufacturing efficiencies, save money, and promote sustainability. For example, by implementing accurate forecasting, distributors of perishable items can manage optimum levels of inventory and avoid dumping excess stock into landfills.

Next-order forecasting uses AI and machine learning algorithms to analyze customer orders and make recommendations for future orders. The architecture described in this article takes next-order forecasting to another level by enabling forecasting at the individual SKU and store level by using parallel processing. This combination enables businesses to forecast demand for specific products at specific stores. By using this methodology, you can provide your customers with personalized recommendations that meet their needs and exceed their expectations.

### Potential use cases

Organizations can use next-order forecasting to predict customer demand and optimize inventory management. The following examples are some specific use cases:

- **E-commerce:** Online retailers can forecast customer demand and recommend products based on customer purchase history, browsing behavior, and preferences. These predictions can improve the customer experience, increase sales, and reduce the cost of logistics and warehousing.

- **Hospitality:** Hotels and restaurants can predict customer demand for menu items, beverages, and other products. These predictions can help them optimize inventory, reduce food waste, and improve profitability.

- **Healthcare:** Hospitals and clinics can forecast patient demand for medical supplies, equipment, and medications. These forecasts can help them reduce inventory stockouts, avoid overstocking, and optimize procurement processes.

- **Manufacturing:** Manufacturers can forecast demand for products and raw materials, optimize inventory levels, and improve supply chain resilience.

- **Energy:** Energy companies can predict demand and optimize energy generation, transmission, and distribution. Next-order forecasting can help them reduce their carbon footprint and improve sustainability.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

The technologies in this solution were chosen for scalability, availability, and cost optimization.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Improved security is built in to the components of this scenario. You can use Microsoft Entra authentication or role-based access control to manage permissions. Consider implementing [Machine Learning best practices for enterprise security](/azure/machine-learning/concept-enterprise-security) to establish appropriate security levels.

Fabric provides a complete [security](/fabric/security/security-fundamentals) package for the entire platform. Fabric minimizes the cost and responsibility of maintaining your security solution and transfers it to the cloud. By using Fabric, you can access the expertise and resources of Microsoft to keep your data more secure, patch vulnerabilities, monitor threats, and comply with regulations. You can also use Fabric to manage, control, and audit your security settings according to your requirements.

Data Lake provides improved data protection, data masking, and improved threat protection. For more information, see [Data Lake security](/azure/data-lake-store/data-lake-store-security-overview).

For more information about security for this architecture, see the following resources:

- [Integrate Azure services with virtual networks for network isolation](/azure/virtual-network/vnet-integration-for-azure-services)
- [Enterprise security and governance for Machine Learning](/azure/machine-learning/concept-enterprise-security)
 
### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist). Observability, monitoring, and diagnostic settings are important considerations to highlight under this pillar.

*Observability* refers to the ability to understand how the data flow of a system functions. *Monitoring* is the ongoing process of tracking the performance of a system over time. You can monitor metrics like CPU usage, network traffic, and response times. *Diagnostic settings* are configuration options that you can use to capture diagnostic information.

For more information, see [Overview of the Operational Excellence pillar](/azure/well-architected/operational-excellence).

Follow [machine learning operations guidelines](/azure/machine-learning/concept-model-management-and-deployment) to manage an end-to-end machine learning life cycle that's scalable across multiple workspaces. Before you deploy your solution to the production environment, make sure that it supports ongoing inference with retraining cycles and automated redeployment of models.

For more information, see the following resources:

- [Machine learning operations v2](../guide/machine-learning-operations-v2.md)
- [Azure machine learning operations v2 GitHub repository](https://github.com/Azure/mlops-v2)

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Most components in this architecture can be scaled up and down based on the analysis activity levels. The [Fabric Capacity Metrics app](/fabric/enterprise/metrics-app) is designed to provide monitoring capabilities for Fabric capacities. Use the app to monitor your capacity consumption and make informed decisions about how to use your capacity resources. For example, the app can help identify when to scale up your capacity or when to turn on autoscale.

You can scale [Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) based on the amount of data and the compute resources that you need for model training. You can scale the deployment and compute resources based on the expected load and scoring service.

Load testing is an important step for ensuring the performance efficiency of the machine learning model. This testing involves the simulation of a high volume of requests to the model to measure metrics like throughput, response time, and resource utilization. Load testing can help you identify bottlenecks and problems that can affect the model's performance in a production environment.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Manasa Ramalinga](https://www.linkedin.com/in/trmanasa) | Principal Cloud Solution Architect – US Customer Success

Other contributors:

- [Ekaterina Krivich](https://www.linkedin.com/in/kiote/) | Applied Scientist
- [Oscar Shimabukuro Kiyan](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect – US Customer Success
- [Veera Vemula](https://www.linkedin.com/in/veera-vemula-7a05279/) | Senior Cloud Solution Architect – US Customer Success

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Track experiments and models by using MLflow](/azure/machine-learning/how-to-use-mlflow-cli-runs)
- [Azure Data Factory documentation](/azure/data-factory/introduction)
- [What is Fabric?](/fabric/fundamentals/microsoft-fabric-overview)
- [What is SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Overview of Azure Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)

## Related resources

- [Many-models machine learning at scale with Machine Learning](../../ai-ml/idea/many-models-machine-learning-azure-machine-learning.yml)
- [Machine learning operations](../../ai-ml/guide/machine-learning-operations-v2.md)
