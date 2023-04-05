[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how merchandise distributors can use AI and machine learning to predict a customer's future order quantity for a specific SKU (stock-keeping unit). By using these predictions, distributors can provide customized product recommendations and suggest optimal quantities. This article builds on the concepts described in the [many models machine learning architecture](../../example-scenario/ai/many-models-machine-learning-azure-machine-learning.yml). 

## Architecture

:::image type="content" source="../media/order-forecasting.png" alt-text="Diagram that shows an architecture for forecasting orders." lightbox="../media/order-forecasting.png":::

link 

### Dataflow

1. Data sources

   To forecast future orders, distributors need comprehensive data about their customers' buying history for various SKUs at specific stores, including information about preferences and purchasing behavior. This kind of information is typically obtained from orders, merchandise, and customer databases. Distributors also need to consider external factors like weather, holidays, and events. This data is usually obtained from third-party sources.

   To create order forecasting models, distributors use data with a schema that includes several key variables: 

   - Date and time 
   - Customer store location
   - Merchandise SKU 
   - Quantity ordered
   - Price per unit
   - Weather-related features, holidays, events, and other external factors
   
   By analyzing this data, distributors can gain valuable insights into customer behavior and make informed SKU and quantity recommendations for the customer's next order. 

1. Ingestion

   Data ingestion is the process of transferring data from various sources to a designated destination. This process involves using specific connectors for each data source and target destination.
   
   Azure Data Factory provides connectors that you can use to extract data from various sources, including databases, file systems, and cloud services. These connectors are created by Microsoft or third-party vendors and are designed to function effectively with multiple data sources. For example, you can use [SAP connectors](/azure/data-factory/industry-sap-connectors) for various SAP data ingestion scenarios. You can use the [Snowflake connector](/azure/data-factory/connector-snowflake?tabs=data-factory) to copy data from Snowflake.

1. Staging area 

   The staging area serves as a temporary storage location between the source and the destination. The main purpose of this staging area is to maintain data in a uniform and structured format while it undergoes transformations or quality checks, before it's loaded into its destination.

   A consistent data format is critical for accurate analysis and modeling. If you consolidate and prepare the data in a staging area, it can be processed more efficiently by Azure Machine Learning.

1. Machine learning model training

   Model training is a machine learning process that invloves using an algorithm to learn patterns from data and, in this case, selecting a model that can accurately predict a customer's next order.

   In this solution, [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) is used to manage the entire machine learning project lifecycle, including training models, deploying models, and managing Machine Learning Operations (MLOps).

   [ParallelRunStep](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep?view=azure-ml-py) is used to process large amounts of data in parallel and create models that can forecast the next order for every customer store and merchandise SKU combination. You can reduce processing time by dividing the dataset into smaller parts and processing them simultaneously on multiple virtual machines. You can use Azure Machine Learning compute clusters to accomplish this distribution of workloads across multiple nodes.

   After the data is prepared, Azure Machine Learning can start the parallel model training process by using ParallelRunStep with a range of forecasting models, including exponential smoothing, elastic net, and Prophet. Each node or compute instance starts building the model, so the process is more efficient and faster.

1. Machine learning model Inferencing

   Model inferencing is a process that uses a trained machine learning model to generate predictions for previously unseen data points. In this solution, it forecasts the quantity of the merchandise SKU that a customer is likely to purchase.

   Azure Machine Learning provides model registries for storing and versioning trained models. Model registries can help you organize and track trained models, ensuring that they're readily available for deployment.

   Deploying a trained machine learning model enables the model to process new data for inferencing. We recommend that you use [Azure managed endpoints](/azure/machine-learning/concept-endpoints) for the recommended deployment target. Endpoints enable easy scalability, performance tuning, and high availability.

   In this solution, there are two ways to deploy models on the [managed endpoints](/azure/machine-learning/how-to-deploy-online-endpoints?tabs=azure-cli#use-more-than-one-model). The first option is to deploy each model on a managed endpoint deployment. The second option is to bundle multiple models into a single model and deploy it on a managed endpoint deployment. The latter approach is more efficient, providing an easier way to deploy and manage multiple models simultaneously.

1. Analytical Workload 

   The scoring results of the model are stored in the analytics systems, specifically Azure Synapse Analytics, Azure Data Lake, or Azure SQL DB (databases), where the input data is collected and stored. This process facilitates the availability of Next Order prediction results for customer consumption, model monitoring, and retraining of the prediction models using the newly available data, thereby enhancing their learning capabilities.

1. End-user Consumption

   To present the scored model visually to customers, distributors can leverage Webapps platform, Power BI (Business Insights) Dashboard or PowerApps. By utilizing these tools, the recommendations for the SKU and predicted quantities can be represented graphically on a canvas, providing an intuitive and engaging customer experience.

   By using this approach, customers of these distributors can be alerted to the recommended SKU and predicted quantities, empowering them to place orders proactively. This can help streamline the ordering process, reduce the likelihood of stock-outs, and enhance customer satisfaction. By leveraging Power BI Dashboard or PowerApps, distributors can provide their customers with a seamless and efficient ordering experience.

### Components 

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems. Azure Synapse brings together the best of SQL technologies used in enterprise data warehousing, Spark technologies used for big data, Azure Data Explorer for log and time-series analytics, pipelines for data integration and ETL/ELT, and deep integration with other Azure services, like Power BI, Azure Cosmos DB, and Azure Machine Learning.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a cloud-based data integration service that automates data movement and transformation.
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) is a limitless data storage service for housing data in various shapes and formats. It provides easy integration with the analytics tools in Azure. It has enterprise-grade security and monitoring support. You can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. This solution provides a local data store for machine learning data and a premium data cache for training the machine learning model.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is an enterprise-grade machine learning service for easier model development and deployment to a wide range of machine learning compute targets. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various integrated development environments.
   - [Azure Machine Learning compute cluster](/azure/machine-learning/how-to-create-attach-compute-cluster?tabs=python) is a managed-compute infrastructure that allows you to easily create a single or multi-node compute. The compute cluster is a resource that can be shared with other users in your workspace. 
   - [Azure Machine Learning endpoints](/azure/machine-learning/concept-endpoints) are HTTPS endpoints that clients can call to receive the inferencing (scoring) output of a trained model. An endpoint provides a stable scoring URI with key-token authentication.
   - [Azure Machine Learning pipeline](/azure/machine-learning/concept-ml-pipelines) is an independently executable workflow of a complete machine learning task. An Azure Machine Learning pipeline helps to standardize the best practices of producing a machine learning model, enables the team to execute at scale, and improves the model building efficiency.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is an always-up-to-date, fully managed relational database service built for the cloud. Build your next app with the simplicity and flexibility of a multi-model database that scales to meet demand.
- [Power BI](https://powerapps.microsoft.com) is software as a service (SaaS) that provides business analytics and visually immersive and interactive insights. It provides a rich set of connectors to various data sources, easy transformation capabilities, and sophisticated visualization.
- [Power Apps](https://powerapps.microsoft.com) is a suite of apps, services, and connectors, together with a data platform, that provides a rapid development environment to build custom apps for your business needs. You can use Power Apps to quickly build business apps that connect to your data. Data can be stored in the underlying data platform ([Microsoft Dataverse](/powerapps/maker/data-platform/data-platform-intro)) or in various online and on-premises data sources, like SharePoint, Microsoft 365, Dynamics 365, and SQL Server.
- Building [web applications](/dotnet/architecture/modern-web-apps-azure) with ASP.NET Core, hosted in Azure, offers many competitive advantages over traditional alternatives. ASP.NET Core is optimized for modern web application development practices and cloud hosting scenarios. 

### Alternatives

- Azure Machine Learning offers data modeling and deployment capabilities as part of this solution. Alternatively, Azure Databricks can be chosen to construct the solution using a code-first approach. Using one tool over the other would depend on the preference and expertise of the user. On the one hand, Azure Machine Learning would cater to an audience who prefers a user-friendly graphical interface. On the other hand, Azure Databricks would suit well for a developer who wants the flexibility of the code-first approach as it enables them to achieve more customization. Instead of Azure Synapse, Azure Databricks can be leveraged to explore and manipulate data for this solution. Both options provide powerful data exploration and manipulation tools. From a data integration perspective, Azure Synapse provides a unified workspace that includes data integration capabilities, making it easier to connect and integrate data from a variety of sources (both azure native as well as third-party). In contrast, Azure Databricks is primarily focused on data processing and analysis. Also, Azure Synapse includes a SQL engine that allows users to query and manipulate data using a familiar SQL syntax, making it an ideal choice for those users who prefer using SQL for data exploration and manipulation. Azure Databricks uses a notebook-based interface that is flexible in writing code in different languages, as it supports Python, R, Scala, and SQL. 
- While Power BI is a popular tool for visualization, Grafana is also another option available. The main difference here is that Grafana is open source while Power BI is a SaaS product offered by Microsoft. If a user values customization and open-source factors more, then Grafana is the better approach. But if a user values more seamless integration with other Microsoft products as well as the support, then Microsoft Power BI would be a better fit.
- Rather than having multiple endpoints for each model, an option of bundling them into a single model for deployment on a managed endpoint is available. Building multiple models into a single model for deployment on a managed endpoint is known as Model Orchestration. Some of the potential drawbacks of using this approach include an increased complexity in managing multiple models within a single endpoint, potential conflicts between models, increased risk of downtime if a single endpoint goes down, amongst others.

## Scenario details

The distribution industry is vast, encompassing a range of products from perishables to manufacturing tools, and is worth billions of dollars. However, traditional manual processes have hindered the growth and profitability of this industry, leading to inefficiencies, higher costs, limited customer insights, reactive maintenance, and intense competition, among other challenges.

The merchandise distribution industry has historically struggled to gain insights into customer behavior and purchasing patterns, making it difficult to provide personalized product recommendations, improve customer satisfaction, and drive sales. But, with the advent of AI and ML, merchandise distributors are transforming the industry. They are now adopting and implementing Next Order Forecasting, a game-changing methodology that enables them to recommend products and quantities based on customers' historical purchasing patterns. This not only benefits customers by consolidating orders and reducing transportation and logistics costs but also allows distributors to establish smart contracts with regular customers. These contracts enable distributors to proactively recommend products and quantities at a regular cadence, manage inventory, influence manufacturing efficiencies, and promote sustainability. For example, in the case of distribution of perishable items, with accurate forecasting, these distributors can manage the optimum level of their inventory and therefore avoid dumping excess stock into landfills.

Next Order Forecasting is a technique that uses AI and ML algorithms to predict customer behavior, enabling businesses to forecast what products and quantities a customer is likely to purchase in the future by analyzing their previous orders and making a recommendation for their future orders. This approach provides invaluable insights into customer trends, preferences, and patterns, empowering companies to make informed decisions about inventory management and personalized product recommendations.

The architecture proposed in this AAC, takes Next Order Forecasting to new heights by presenting a solution that enables forecasting at an individual SKU (Stock Keeping Unit) and Store level using parallel processing technology. This powerful combination allows businesses to gain a comprehensive understanding of customer purchasing patterns, forecast demand for specific products at specific stores, optimize inventory, and reduce waste. With this methodology, businesses can unlock significant efficiencies and cost savings, while providing customers with personalized recommendations that meet their needs and exceed their expectations. The future of the distribution industry is bright, and with Next Order Forecasting, businesses can stay ahead of the competition and continue to drive growth and profitability.

### Potential use cases

Next Order Forecasting (NOF) can be applied in various industries where businesses need to predict customer demand and optimize their inventory management. Some of the alternative use cases of NOF are:

- **E-commerce.** Online retailers can leverage NOF to forecast customer demand and recommend products based on their purchase history, browsing behavior, and preferences. This can improve customer experience, increase sales, and reduce the cost of logistics and warehousing.
- **Hospitality.** Hotels and restaurants can use NOF to predict customer demand for different menu items, beverages, and other products. This can help them optimize their inventory, reduce food waste, and improve profitability.
- **Healthcare.** Hospitals and clinics can leverage NOF to forecast patient demand for various medical supplies, equipment, and medications. This can help them reduce inventory stockouts, avoid overstocking, and optimize their procurement processes.
- **Manufacturing.** Manufacturers can use NOF to forecast demand for their products and raw materials, optimize their inventory levels, and improve their supply chain resilience.
- **Energy.** Energy companies can use NOF to predict electricity demand and optimize their energy generation, transmission, and distribution. This can help them reduce their carbon footprint and improve their sustainability.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The technologies in this solution were chosen for their scalability and availability, with the aim of managing and controlling the costs.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario provides improved security that is built into the components. It also provides permissions that you can manage via Azure Active Directory authentication or role-based access control. Consider the following [Azure Machine learning best practices for enterprise security](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-enterprise-security) to establish suitable security levels.

Azure Synapse offers enterprise-grade and industry-leading security features that provide component isolation to protect data, improve network security, and improve threat protection. Component isolation can minimize exposure in the case of a security vulnerability. Azure Synapse also enables data obfuscation to protect sensitive personal data.

Azure Data Lake provides security capabilities at all levels, from improved data protection and data masking to improved threat protection. For more information, see [Azure Data Lake security](/azure/data-lake-store/data-lake-store-security-overview).

For more information about security features for this architecture, see the following resources:

- [Deploy dedicated Azure services into virtual networks](/azure/virtual-network/virtual-network-for-azure-services)
- [Enterprise security and governance for Azure Machine Learning](/azure/machine-learning/concept-enterprise-security)
 
### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. Three important aspects to highlight under this pillar are Observability, monitoring, and diagnostic settings. In terms of observability, this refers to the ability to understand how a system is functioning internally regarding data flow. Monitoring refers to the ongoing process of tracking the performance of a system over time. We can monitor specific metrics such as CPU (central processing units) usage, network traffic, response times, and other useful metrics. Diagnostic settings refer to the configuration options that allow to capture diagnostic information about a model. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Follow [MLOps (Machine Learning Ops) guidelines](/azure/machine-learning/concept-model-management-and-deployment) to standardize and manage an end-to-end machine learning lifecycle that is scalable across multiple workspaces. Before going into production, ensure that the implemented solution supports ongoing inference with retraining cycles and automated redeployments of models. 

Here are some resources to consider:

- [MLOps v2](../../data-guide/technology-choices/machine-learning-operations-v2.md)
- [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2)

### Performance efficiency

Performance efficiency is your workload's ability to scale and meet the demands placed on it by users efficiently. For more information, see [Performance efficiency pillar overview]().

Most components in this scenario can be scaled up or down depending on the analysis activity levels. Azure Synapse provides scalability and high performance and can be reduced or paused at low levels of activity.

You can scale [Azure Machine Learning]() based on the amount of data and the necessary compute resources for model training. You can scale the deployment and compute resources based on the expected load and scoring service. 

Load testing is a crucial step in ensuring the performance efficiency of the machine learning model deployed. This involves simulating a high volume of requests to your model to measure some metrics such as throughput, response time, and resource utilization. In this way, you can identify bottlenecks or issues that could affect the model’s performance in a production environment.

For more information about designing scalable solutions, see [Performance efficiency checklist].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

- [Manasa Ramalinga](https://www.linkedin.com/in/trmanasa) | Principal Cloud Solution Architect – US Customer Success

Other contributors:

- [Oscar Shimabukuro Kiyan]() | Senior Cloud Solution Architect – US Customer Success
- [Mick Alberts]() | Technical Writer 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Machine Learning?]()
- [Track ML models with MLflow and Azure Machine Learning]()
- [Azure Data Factory documentation]()
- [What is Azure Synapse Analytics?]()
- [What is Azure SQL Database?]()
- [What is Power BI?]()
- [Welcome to Stream Analytics]()

## Related resources
- [Many models machine learning (ML) at scale with Azure Machine Learning]()
- [Solutions for the energy and environment industries]()
- [Batch scoring with R models to forecast sales]()
- [Oil and gas tank level forecasting]()
- [Demand forecasting for shipping and distribution]() 
- [Forecast energy and power demand with machine learning]()
- [Interactive price analytics using transaction history data]()
- [MLOps for Python models using Azure Machine Learning]()