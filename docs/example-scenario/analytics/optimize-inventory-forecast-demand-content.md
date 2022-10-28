This article showcases a practical, scalable, and manageable solution for implementing inventory optimization architectures for the retail industry. The solution uses the latest advancements in forecasting, optimization, and parallel computing.

*Ray® or Ray.io® is either a registered trademark or trademarks of the Anyscale, Inc. in the United States and/or other countries. No endorsement by Anyscale, Inc. is implied by the use of these marks.*

## Architecture

:::image type="content" alt-text="Diagram of a solution that ingests data from multiple sources and uses machine learning to optimize inventory and forecast demand." source="./media/optimize-inventory-forecast-demand-architecture.svg" lightbox="./media/optimize-inventory-forecast-demand-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/optimize-inventory-forecast-demand-architecture.vsdx) of this architecture.*

### Dataflow

1. Azure Data Factory ingests related data into Azure Data Lake Storage. The sources of this data can be enterprise resource planning (ERP) systems, SAP, and Azure SQL. Additional sources might include weather and economic data.

2. Data Lake Storage stores raw data for further processing.

3. Mapping data flows in Azure Data Factory produces curated data and stores it in a relational format in an Azure SQL database. Additionally, in this use case, the SQL database stores intermediate results, other run information, and simulation metrics. Alternatively, Azure Machine Learning can read the data directly from the Data Lake service.

4. Use Azure Machine Learning to train the model by using data in Azure SQL Database, and deploy the model and service to Kubernetes.

5. Install the Ray framework on the same Kubernetes cluster to parallelize the execution of the scoring script during inferencing. Each execution runs the demand-forecasting module for specified locations and products over a given forecast period. The forecasting results are read by the optimization module, which calculates the optimal inventory levels. Finally, the results are stored in Azure SQL Database.

6. Power Apps hosts a user interface for business users and analysts to collect parametric information, such as service level, product, and location. Users also use Power Apps to submit the collected parameters and to launch executions of the deployed machine learning module that is hosted in Kubernetes clusters.

7. Power BI ingests data from Azure SQL Database and allows users to analyze results and perform sensitive analysis. All Power BI dashboards are integrated into Power Apps to have a unified UI for calling the API, reading results, and performing downstream analysis.

### Components

- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) is a scalable and secure data lake for high-performance analytics workloads. By using Data Lake Storage, you can manage petabytes of data with high throughput. Data Lake Storage can accommodate multiple, heterogeneous sources and data coming in structured, semi-structured, or unstructured formats.

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a scalable and serverless service that provides a data-integration and transformation layer that works with various data stores.

- [Power BI](https://azure.microsoft.com/services/developer-tools/power-bi) is a collection of software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, and interactive insights.

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a cloud service for accelerating and managing the lifecycle of a machine learning project. Machine learning professionals, data scientists, and engineers can use Azure Machine Learning in their day-to-day workflows, to train and deploy models, and to manage Machine Learning Operations (MLOps).

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database): Azure SQL Database is a fully managed platform as a service (PaaS) that handles most of the database management functions, such as upgrading, patching, backups, and monitoring, without user involvement.

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service): AKS simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks like health monitoring and maintenance.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics): Azure Synapse Analytics is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems. Azure Synapse Analytics brings together the following technologies:

  - The best of the SQL technologies used in enterprise data warehousing
  - Spark technologies used for big data
  - Data Explorer for log and time-series analytics
  - Pipelines for data integration and ETL/ELT
  - Deep integration with other Azure services, such as Power BI, Azure Cosmos DB, and Machine Learning

### Alternatives

In this solution, Machine Learning performs forecasting and inventory management analytics. However, you can use [Azure Databricks](https://azure.microsoft.com/services/databricks) or Azure Synapse Analytics to perform the same type of analytics when the amount of data is large. For more information about using Azure Synapse Analytics, see [Apache Spark in Azure Synapse Analytics](/azure/synapse-analytics/spark/apache-spark-overview).

As an alternative to [mapping data flows](/azure/data-factory/concepts-data-flow-overview) in Azure Data Factory to curate and perform ETL on data in [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake), you can use Azure Databricks for a code-first approach.

Depending on your specific use case and your choice of analytics platform for end users, you can use other relational or storage services, such as Azure Synapse Analytics or [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction), instead of storing your data in Azure SQL. For example, if the data has accumulated for a long period of time and there's a need to run analytics queries against this data, Azure Synapse analytics is a good option as part of the architecture.

Instead of running the Ray framework on Kubernetes, you can use the Ray framework on a compute instance in Azure Machine Learning to perform inferencing. If you incorporate the Ray framework on Azure Machine Learning, you might find [ray-on-ml](https://github.com/microsoft/ray-on-aml), a package on GitHub, helpful.

You could use [Web Apps](https://azure.microsoft.com/services/app-service/web) instead of, or along with, Power Apps to create the user interface for access to the Power BI embedded reports.

## Scenario details

Retail competition between companies is intense, and retailers are required to bring computational intelligence and smart insights into their commercial, marketing, and manufactory processes. While increasing and retaining customers is paramount for the success of a company, retailers must also align their inventory levels to customer demand to maximize operational efficiency and reduce waste and costs.

*Inventory optimization* is the process of providing the right inventory, in the right quantities, at the right locations to meet the customer demand. The objective of optimization is to lessen the carrying, storing, and maintenance costs, while meeting the needs of customers and maintaining a high level of customer satisfaction. *Demand forecasting* is the process of making predictions about customer demand by using various historical and third-party data. Demand forecasting helps business leaders to make informed decisions and is one of the most widely used techniques of inventory optimization.

To better work with a large volume of supply chain data, this solution offers the following guidelines for transforming and scaling existing on-premises solutions:

- Provide a customer interface by using Power BI and PowerApps from which users can launch simulations and determine the parameters of the simulation and data, access results, and so on.

- Process, validate, and analyze data by using Azure Machine Learning.

- Generate probabilistic forecasts of inventory supply levels by using advanced machine learning methods, such as DeepAR.

- Run parallel simulations for generating and forecasting inventory by using Azure Kubernetes and Ray.

### Potential use cases

This solution is designed for the retail industry, but it also applies to the manufacturing industry and to the following scenarios:

- Analyze product information across locations to assess demand levels and decrease inventory costs.

- Analyze stock variability and sales by using historical demand data to forecast demand in future periods, across customers, and by location and sales channel. For example, a shipping and delivery company needs to predict the quantities of products at different locations, and an insurer might want to know the number of products that will be returned because of failures.

- Identify the ideal amount of inventory to have in stock.

- Predict how seasonal changes or other events might affect sales and restocking options.

- Forecast the prices of commodities across locations and sales channels by using historical transaction data in a retail context.

Companies can have a wide variety of inventory types, and specific types might be present only in specific locations or available from a subset of factories. Companies must also meet service level agreements and other relevant metrics. So, forecasts must account for the time at which a specific unit is available at a specific location, in addition to forecasting demand, service level agreements, and other relevant metrics. Successful inventory management requires accurate simulations for forecasting demand, utilization of distributed computing resources, and methodologies that can predict for multiple time granularities, product types, and locations.

Often, the data that's required to optimize inventory is sparse and not centrally located, which makes aggregating and analyzing it difficult. Most companies rely on commercial software. However, such systems hit scalability limits due to the ever-increasing amount of data and the complexity of data storage systems.

Methods of forecasting demand include on-point predictions, probabilistic Monte Carlo simulations, time-series analysis, and data science methodologies. Some of these methods can take historical sales and seasonality effects into account, but more complex parameters require sophisticated methodologies for high-quality forecasts.

### Forecasting with Deep Learning

The implemented reference solution uses advanced machine learning and deep learning methods for time-series forecasting. Specifically, this solution uses multivariate probabilistic forecasting to account for uncertainties that are common in supply chains. By using an ensemble modeling approach that blends Deep AutoRegression RNN (DeepAR) or Transformer models that use the classical Monte Carlo Sampling method, the reference solution achieved 99.9% mean square error (MSE) improvement over a customer's initial approach for high-volume/high-impact business products. For ensembling, this solution explored XGBClassifier and XGBRegressor model architectures.

:::image type="content" alt-text="Diagram of the components that ingest sales history and produce demand predictions in this example workload." source="media/optimize-inventory-forecast-demand-dataflow.svg":::

## Considerations

Consider following the Microsoft Azure Well-Architected Framework when deploying the solution to production. The Well-Architected Framework provides technical guidance across five pillars of workload: reliability, security, cost optimization, operational excellence, and performance efficiency. For more information, see [Azure Well-Architected](/training/paths/azure-well-architected-framework).

Follow MLOps guidelines to standardize and manage end to end a scalable Machine Learning lifecycle across multiple workspaces. Before going into production, ensure that the implemented solution supports ongoing inference with retraining cycles and automated redeployments of models. For more information about implementing MLOps in Azure, see [Machine learning DevOps guide](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-mlops) and [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2), a project on GitHub.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Consider using Azure Databricks Premium for more security features. For more information, see [Azure Databricks Pricing](https://azure.microsoft.com/pricing/details/databricks).

Follow the best practices for Databricks security and data governance. For more information, see [Secure cluster connectivity (No Public IP / NPIP)](/azure/databricks/security/secure-cluster-connectivity).

Consider implementing the following additional security features in this architecture:

- [Store credentials in Azure Key Vault](/azure/data-factory/store-credentials-in-key-vault)
- [Deploy dedicated Azure services into virtual networks](/azure/virtual-network/virtual-network-for-azure-services)

### Cost optimization

To estimate the cost of implementing this solution, use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) for the services mentioned in this article. You might also find [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview) to be helpful in planning your strategy to efficiently scale out your architecture and implementation.

Power BI comes with different licensing offerings. For more information, see [Power BI pricing](https://powerbi.microsoft.com/pricing).

Depending on the volume of data and complexity of your geospatial analysis, you might need to scale your Databricks cluster configurations that would affect your cost. For best practices on cluster configuration, see the Databricks [cluster sizing](/azure/databricks/clusters/cluster-config-best-practices#--cluster-sizing-examples) examples.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

If the amount of input data is large, consider using [Ray Dataset](https://docs.ray.io/en/latest/data/dataset.html) along with Ray framework. Ray datasets provide distributed data transformations on various file formats and are easily integrated with other Ray libraries and applications.

If you use mapping data flows in Azure Data Factory for ETL, follow [the performance and tuning guide](/azure/data-factory/concepts-data-flow-performance) to optimize your data pipeline and ensure that your dataflows meet your performance benchmarks.

Often, for optimization and Operations Research problems, compute-intensive calculations run after the inferencing is invoked. If you use the Ray framework for distributed computing, as suggested in this article, make sure to utilize [Ray Dashboard](https://docs.ray.io/en/latest/ray-core/ray-dashboard.html) to monitor the execution metrics and increase the node counts in Kubernetes cluster.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Giulia Gallo](https://www.linkedin.com/in/giuliagallo) | Senior Cloud Solution Architect

Other contributors:

- [Chu Lahlou](https://www.linkedin.com/in/chulahlou) | Senior Cloud Solution Architect
- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
- [Arash Mosharraf](https://www.linkedin.com/in/arashaga) | Senior Cloud Solution Architect

## Next steps

- [Copy and ingest data using Azure Data Factory](/azure/data-factory/data-factory-tutorials#copy-and-ingest-data)
- [Deploy machine learning models to Azure](/azure/machine-learning/how-to-deploy-managed-online-endpoints)
- [Install Ray on Kubernetes cluster](https://docs.ray.io/en/latest/cluster/kubernetes)
- [Ray.io framework documentation](https://docs.ray.io/en/latest/index.html)
- [Ray installation on Kubernetes](https://docs.ray.io/en/latest/cluster/kubernetes)
- [Ray on Databricks](https://databricks.com/blog/2021/11/19/ray-on-databricks.html)
- [Security baseline for Azure Machine Learning service](/security/benchmark/azure/baselines/machine-learning-security-baseline?bc=/azure/architecture/_bread/toc.json&toc=/azure/architecture/toc.json)

## Related resources

- [Demand forecasting for shipping and distribution](/azure/architecture/solution-ideas/articles/demand-forecasting-for-shipping-and-distribution)
- [Energy supply optimization](/azure/architecture/solution-ideas/articles/energy-supply-optimization)
- [Enterprise business intelligence](/azure/architecture/reference-architectures/data/enterprise-bi-synapse)
- [Forecast energy and power demand with machine learning](/azure/architecture/solution-ideas/articles/forecast-energy-power-demand)
- [Interactive price analytics using transaction history data](/azure/architecture/solution-ideas/articles/interactive-price-analytics)
- [MLOps for Python models using Azure Machine Learning](/azure/architecture/reference-architectures/ai/mlops-python)
