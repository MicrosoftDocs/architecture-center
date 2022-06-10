Retail competition amongst companies is intense, and retailers are
required to bring computational intelligence and smart insights into
their commercial, marketing and manufactory processes. Whilst increasing
and retaining their customers is paramount for the success of a company,
retailers also must align their inventory levels to customer demand to
maximize operational efficiency and reduce waste and costs.

Inventory Optimization is the process of providing the right inventory,
in the right quantities, at the right locations to meet the customer
demand. The objective is to lessen the carrying, storing, and
maintenance costs, while meeting customers' needs and maintaining a high
customer satisfaction level. Demand forecasting is one of the most
widely used inventory optimization techniques. It refers to making
predictions about future customer demand using a variety of historical
or third-party data. These predictions help business leaders make
informed decisions to meet customer needs and achieve desired business
outcomes.

Various inventory types can exist in a company, depending on the
industry and products sold. These inventory types can range from raw
materials, a work-in-progress inventory, finished goods ready to be
shipped and sold in stores, and maintenance and repair products or
parts. Additionally, these inventory types may be present only in
specific locations and/or handled by a certain subset of factories.
Therefore, for inventory management, the location of each inventory at
any given time needs to be taken into consideration, as well as its
forecasted demand, service level agreements, and other metrics
associated with that inventory. Generally, a successful inventory
management strategy requires the ability to perform accurate demand
forecasting simulations, utilization of distributed computing resources,
and forecasting methodologies that can handle and predict for different
time granularities, product types and locations.

Often, the data needed to perform inventory forecasting is sparse and
not centrally located, making it difficult to aggregate and analyze.
Most companies rely on commercial software and routines. However, such
systems hit scalability limits due to the ever-increasing amount of data
and the complexity of data storage systems.

Demand forecasting is the other critical component to be implemented.
Forecasting methods range from on-point predictions, probabilistic Monte
Carlo simulations, timeseries analysis, and data science methodologies.
Some of these methods can take historical sales and seasonality effects
into account, but the more complex the inventory and parameters, the
more sophisticated methodologies are needed.

This article focuses on showcasing a practical, scalable, and manageable
solution for implementing inventory optimization architectures for the
retail industry. The solution leverages the latest advancements in
forecasting, optimization, and parallel computing and offers the
following guidelines for transforming and scaling existing on-premises
solutions to better work with large volume of supply chain data:

-   Provide a customer interface using Power BI and PowerApps that can
    be used to launch the simulations and determine the parameters of
    the simulation/data, access results, etc.

-   Process, validate, and analyze data using Azure Machine Learning.

-   Generate probabilistic forecasts of inventory supply levels using
    advanced machine learning methods such as DeepAR.

-   Run parallel simulations for inventory generation and forecasting
    using Azure Kubernetes and Ray.

*Ray®, or Ray.io is® either registered trademark or trademarks of the
Anyscale, Inc. in the United States and/or other countries. No
endorsement by Anyscale, Inc. is implied by the use of these marks.*

## Potential use cases

This solution is designed for the retail industry, but it also applies
to the following scenarios:

-   Analyze product information across locations to assess demand levels
    > and decrease inventory costs.

-   Analyze stock variability and sales, by location and/or sales
    > channel, by using historical demand data to forecast demand in
    > future periods, across customers---such as a shipping/delivery
    > company that needs to predict the quantities of products at
    > different locations and at future times, or an insurer that wants
    > to know the number of products that will be returned because of
    > failures.

-   Identify the ideal amount of inventory to have in stock or as a
    > backup plan.

-   Predict how seasonal changes or regional/global events may affect
    > sales and restocking options.

-   Forecast the prices of commodities across locations and sales
    > channels, using historical transaction data in a retail context.

## Architecture

## ![](media/image1.jpg){width="6.5in" height="3.9270833333333335in"}

*Download a \[Visio
file\](https://arch-center.azureedge.net/\[filename\].vsdx) of this
architecture.*

**Workflow**

1.  Azure Data Factory ingests related data into Azure Data Lake
    Storage. The source of this data can be ERP systems, SAP, Azure SQL,
    and potentially external sources such as weather and economic data.

2.  Raw data is stored in Data Lake Storage for further processing.

3.  Data is curated using Azure Data Factory Data Flows and stored in a
    relational format in an Azure SQL database. Additionally, in this
    use case SQL database is used to store intermediate results and
    other run information and simulation metrics. Alternatively, Azure
    Machine Learning can read the data directly from Azure Data Lake
    service.

4.  Use Azure Machine Learning to train the model using data in the SQL
    server and deploy the model/service to Kubernetes.

5.  Ray framework is installed on the same Kubernetes cluster to
    parallelize the execution of the scoring script during inferencing.
    Each execution runs the demand forecasting module for specified
    locations and products over a given forecast period. The forecasting
    results are read by the optimization module which calculates the
    optimal inventory levels. Finally, the results are stored in the
    Azure SQL Server.

6.  Power Apps is used to host a user interface for business users and
    analysts to collect parametric information such as service level,
    product, and location. Power Apps is also used to submit the
    collected parameters and launch executions of the deployed ML module
    hosted in Kubernetes clusters.

7.  Power BI ingests SQL Server data and allows users to analyze results
    and perform sensitive analysis. All Power BI dashboards are
    integrated into Power Apps to have a unified UI for calling the API,
    reading results, and performing downstream analysis.

**Components**

-   [Data Lake
    Storage](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction) is
    a scalable and secure data lake for high-performance analytics
    workloads. Using ADLS you can manage petabytes of data with high
    throughput. ADLS can accommodate multiple, heterogeneous sources and
    data coming in structured, semi-structured, or unstructured formats.

-   [Azure Data
    Factory](https://azure.microsoft.com/services/data-factory/) is a
    scalable and serverless service that provides a data integration and
    transformation layer that works with a variety of data stores.

-   [Power
    BI](https://docs.microsoft.com/power-bi/fundamentals/power-bi-overview) is
    a collection of software services, apps, and connectors that work
    together to turn your unrelated sources of data into coherent,
    visually immersive, and interactive insights.

-   [Azure Machine
    Learning](https://docs.microsoft.com/azure/machine-learning/overview-what-is-azure-machine-learning)
    is a cloud service for accelerating and managing the machine
    learning project lifecycle. Machine learning professionals, data
    scientists, and engineers can use it in their day-to-day workflows:
    Train and deploy models and manage MLOps.

-   [Azure SQL
    Database](https://docs.microsoft.com/azure/azure-sql/database/sql-database-paas-overview):
    Azure SQL Database is a fully managed platform as a service (PaaS)
    database engine that handles most of the database management
    functions such as upgrading, patching, backups, and monitoring
    without user involvement.

-   [Azure
    Kubernetes](https://docs.microsoft.com/azure/aks/intro-kubernetes):
    Azure Kubernetes Service (AKS) simplifies deploying a managed
    Kubernetes cluster in Azure by offloading the operational overhead
    to Azure. As a hosted Kubernetes service, Azure handles critical
    tasks, like health monitoring and maintenance.

-   [Azure Synapse
    Analytics](https://docs.microsoft.com/azure/synapse-analytics/overview-what-is):
    Azure Synapse Analytics is an enterprise analytics service that
    accelerates time to insight across data warehouses and big data
    systems. It brings together the best of SQL technologies used in
    enterprise data warehousing, Spark technologies used for big data,
    Data Explorer for log and time series analytics, Pipelines for data
    integration and ETL/ELT, and deep integration with other Azure
    services such as Power BI, CosmosDB, and AzureML.

**Alternatives**

-   In this solution we have presented Azure Machine Learning as a
    platform to perform forecasting and inventory management analytics.
    However, you can utilize
    [Azure](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-overview)
    Databricks or Synapse to perform the same type of analytics, when
    the amount of data you are handling is large.

-   To curate and perform ETL after the data is landed in Azure Data
    Lake, as an alternative to Azure Data Factory Data Flows you can use
    Azure Databricks for code first approach.

-   Depending on the specific use case and the choice of end user's
    analytics platform, instead of storing the data in SQL Server you
    can utilize other relational or storage services such as Azure
    Synapse Analytics or Azure Data Lake Storage Gen2. For instance, if
    the data is accumulated for a long period of time and there is a
    need to run analytics queries against this data, Azure Synapse
    analytics is a good option as part of the architecture.

-   Instead of running the Ray framework on Kubernetes, you can utilize
    Ray framework on Azure ML Compute to perform inferencing. You can
    use the [ray-on-ml](https://github.com/microsoft/ray-on-aml) package
    to easily incorporate ray framework on Azure ML Compute.

-   Alternatively, a custom Web App can be used instead or along with
    Power Apps to the user interface and Power Bi embedded reports for
    analysis.

**Forecasting with Deep Learning**

The implemented reference solution leverages advanced machine learning
and deep learning methods for time-series forecasting. Specifically,
multivariate probabilistic forecasting is used to account for
uncertainties common in supply chain. By using an ensemble modeling
approach blending Deep AutoRegression RNN (DeepAR) or Transformer models
with classical Monte Carlo Sampling method, the reference solution
achieved 99.9% Mean Square Error (MSE) improvement over a customer's
initial approach for high volume/high business impact products. For
ensembling, XGBClassifier and XGBRegressor model architectures were
explored.

![](media/image2.emf){width="6.5in" height="2.217361111111111in"}

**Considerations**

Consider following the [Microsoft Azure Well-Architected
Framework](https://www.microsoft.com/azure/partners/well-architected#well-architected-assets)
(WAF) when deploying the solution to production. WAF provides technical
guidance across five pillars of workload -- reliability, security, cost
optimization, operational excellence, and performance efficiency.

Follow MLOps guidelines to standardize and manage end-to-end Machine
Learning lifecycle scalable across multi workspaces. Before going into
production, ensure the implemented solution supports ongoing inference
with retraining cycles and automated redeployments of models.

Resource: [MLOps v2
(sharepoint.com)](https://microsoft.sharepoint.com/teams/CS_AzureDataAI/SitePages/Mlops.aspx?xsdata=MDV8MDF8fDVhM2M4ZDViNjM1ODRhMWFjMDM3MDhkYTFiZjIwYTkzfDcyZjk4OGJmODZmMTQxYWY5MWFiMmQ3Y2QwMTFkYjQ3fDB8MHw2Mzc4NTMwMjM1OTk4MzcyMzl8R29vZHxWR1ZoYlhOVFpXTjFjbWwwZVZObGNuWnBZMlY4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazkwYUdWeUlpd2lWMVFpT2pFeGZRPT18MXxNVGs2TXpCak9HUmlOR1JsTkRSbE5EVmlaR0UwWVRNMFpqQmpPV1kzT1RWa1pqaEFkR2h5WldGa0xuWXl8fA%3D%3D&sdata=czFMOUVSa3J1WjBSbm5haDc3NStGUVVGYTZyZE93MmF4d3U1cW92NlB2QT0%3D&ovuser=72f988bf-86f1-41af-91ab-2d7cd011db47%2Cchulahlou%40microsoft.com&OR=Teams-HL&CT=1649705566054&params=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyOC8yMjAzMjEwMDEwNyJ9)

Resource: [Azure/mlops-v2: Azure MLOps (v2) solution accelerators.
(github.com)](https://github.com/Azure/mlops-v2)

**Security**

Consider implementing the following security features in this
architecture:

-   [Secure Databricks cluster
    connectivity](https://docs.microsoft.com/en-us/azure/databricks/security/secure-cluster-connectivity)

```{=html}
<!-- -->
```
-   [Secure the credentials in Data Factory using Key
    Vault](https://docs.microsoft.com/en-us/azure/data-factory/store-credentials-in-key-vault)

-   [Deploy Azure services in Azure Virtual
    Network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-for-azure-services)

-   [Consider using Azure Databricks Premium for additional security
    features](https://azure.microsoft.com/en-us/pricing/details/databricks/)

-   [Follow the best practices for Databricks security and data
    governance](https://docs.microsoft.com/en-us/azure/databricks/security/secure-cluster-connectivity)

**Cost optimization**

-   To estimate the cost of implementing this solution, please utilize
    [Azure Pricing
    Calculator](https://azure.microsoft.com/pricing/calculator/) for the
    services mentioned above.

-   Power BI comes with different licensing offerings. Please refer to
    this [link](https://powerbi.microsoft.com/en-us/pricing/) for
    further information.

-   Depending on the volume of data and complexity of your geospatial
    analysis you may need to scale your Databricks cluster
    configurations that would affect your cost. Please refer to
    Databricks' [cluster
    sizing](https://docs.microsoft.com/en-us/azure/databricks/clusters/cluster-config-best-practices#--cluster-sizing-examples)
    examples for best practices on cluster configuration.

-   It's also valuable if you see [Overview of the cost optimization
    pillars](https://docs.microsoft.com/azure/architecture/framework/cost/overview).

**Performance efficiency**

-   If the input data is large, consider using [Ray
    Dataset](https://docs.ray.io/en/latest/data/dataset.html) along with
    Ray framework. Ray datasets provide distributed data transformations
    on a variety of file formats and are easily integrated with other
    Ray libraries and applications.

-   If Azure Data Factory Mapping Data Flows is used for ETL, please
    follow performance and tuning guide for mapping Data Flows to
    optimize your data pipeline and ensure that your data flows meet
    your performance benchmarks.

-   Often, for optimization and Operations Research problems, compute
    intensive calculations are run once the inferencing is invoked. If
    Ray framework is utilized for distributed compute as suggested in
    this article, make sure to utilize [Ray
    dashboard](https://docs.ray.io/en/latest/ray-core/ray-dashboard.html)
    to monitor the execution metrics and increase the node counts in
    Kubernetes cluster.

**Contributors**

*This article is being updated and maintained by Microsoft. It was
originally written by the following contributors.*

-   \[Giulia Gallo\](http://www.linkedin.com/in/giuliagallo) \| \[Senior
    Cloud Solution Architect, US National CSA Team\"\]

-   \[Chu Lahlou\](http://linkedin.com/chulahlou) \| \[Senior Cloud
    Solution Architect, CSU AI Ranger/AI Specialist Team\"\]

-   \[Arash Mosharraf\](http://linkedin.com/arashga) \| \[Senior Cloud
    Solution Architect, US National CSA Team\"\]

**Next steps**

-   [Copy and ingest data using Azure Data
    Factory](https://docs.microsoft.com/azure/data-factory/data-factory-tutorials#copy-and-ingest-data)

-   [Deploy Machine Learning Models using Azure Machine Learning
    Service](https://docs.microsoft.com/azure/machine-learning/how-to-deploy-and-where?tabs=azcli)

-   

[Install Ray on Kubernetes
cluster](https://docs.ray.io/latest/cluster/kubernetes.html)

**Related resources**

-   [Ray.io framework
    documentation](https://docs.ray.io/en/latest/index.html)

-   [Ray installation on
    Kubernetes](https://docs.ray.io/en/latest/cluster/kubernetes.html)

-   [Ray on
    Databricks](https://databricks.com/blog/2021/11/19/ray-on-databricks.html)

-   [Security baseline for Azure Machine Learning
    service](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/machine-learning-security-baseline?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
