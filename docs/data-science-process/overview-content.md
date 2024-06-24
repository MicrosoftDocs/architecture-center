The Team Data Science Process (TDSP) is an agile, iterative data science methodology that you can use to deliver predictive analytics solutions and AI applications efficiently. The TDSP helps improve team collaboration and learning by suggesting how team roles work best together. The TDSP includes best practices and structures from Microsoft and other industry leaders to help your team successfully implement data science initiatives and fully realize the benefits of your analytics program.

This article provides an overview of TDSP and its main components. It presents guidance about how to implement the TDSP by using Microsoft tools and infrastructure. You can find more detailed resources throughout the article.

## Key components of the TDSP

The TDSP has the following key components:

- A **data science lifecycle** definition
- A **standardized project structure**
- **Infrastructure and resources** recommended for data science projects
- **Responsible AI**: We are committed to the advancement of AI driven by ethical principles

### Data science lifecycle

The TDSP provides a lifecycle that you can use to structure the development of your data science projects. The lifecycle outlines the full steps that successful projects follow.

You can combine the task-based TDSP with other data science lifecycles, such as cross-industry standard process for data mining (CRISP-DM), the knowledge discovery in databases (KDD) process, or another custom process. At a high level, these different methodologies have much in common.

You should use this lifecycle if you have a data science project that's part of an intelligent application. Intelligent applications deploy machine learning or AI models for predictive analytics. You can also use this process for exploratory data science projects and improvised analytics projects.

The TDSP lifecycle is composed of five major stages that your team performs iteratively. These stages include:

- [Business understanding](lifecycle-business-understanding.md)
- [Data acquisition and understanding](lifecycle-data.md)
- [Modeling](lifecycle-modeling.md)
- [Deployment](lifecycle-deployment.md)
- [Customer acceptance](lifecycle-acceptance.md)

Here's a visual representation of the TDSP lifecycle:

[![Diagram that shows the stages of the TDSP lifecycle.](./media/lifecycle/tdsp-lifecycle2.png)](./media/lifecycle/tdsp-lifecycle2.png)

For information about the goals, tasks, and documentation artifacts for each stage, see [The Team Data Science Process lifecycle](lifecycle.md).

These tasks and artifacts are associated with project roles, for example:

- Solution architect.
- Project manager.
- Data engineer.
- Data scientist.
- Application developer.
- Project lead.

The following diagram shows the tasks (in blue) and artifacts (in green) associated with each stage of the lifecycle (on the horizontal axis) for these roles (on the vertical axis).

[![Diagram that shows the tasks and artifacts for each stage.](./media/overview/tdsp-tasks-by-roles.png)](./media/overview/tdsp-tasks-by-roles.png#lightbox)

### Standardized project structure

Your team can use the Azure infrastructure to organize your data science assets.

Azure Machine Learning supports the open-source [MLflow](/azure/machine-learning/concept-mlflow?view=azureml-api-2). We recommend using MLflow for data science and AI project management. MLflow is designed to manage the complete machine learning lifecycle. It trains and serves models on different platforms, so you can use a consistent set of tools regardless of where your experiments run. You can use MLflow locally on your computer, on a remote compute target, on a virtual machine, or on a Machine Learning compute instance.

MLflow consists of several key functionalities:

- **Track experiments**: With MLflow, you can keep track of experiments, including parameters, code versions, metrics, and output files. This feature helps you compare different runs and manage the experimentation process efficiently.

- **Package code**: It offers a standardized format for packaging machine learning code, which includes dependencies and configurations. This packaging makes it easier to reproduce runs and share code with others.

- **Manage models**: MLflow provides functionalities for managing and versioning models. It supports various machine learning frameworks, so you can store, version, and serve models.

- **Serve and deploy models**: MLflow integrates model serving and deployment capabilities, so you can easily deploy models in diverse environments.

- **Register models**: You can manage the lifecycle of a model, including versioning, stage transitions, and annotations. MLflow is useful for maintaining a centralized model store in a collaborative environment.

- **Use an API and UI**: Inside Azure, MLflow is bundled within the Machine Learning API version 2, so you can interact with the system programmatically. You can use the Azure portal to interact with a UI.

MLflow aims to simplify and standardize the process of machine learning development, from experimentation to deployment.

Machine Learning [integrates with Git repositories](/azure/machine-learning/concept-train-model-git-integration?view=azureml-api-2&tabs=python), so you can use Git-compatible services:  GitHub, GitLab, Bitbucket, Azure DevOps, or another Git-compatible service. In addition to the assets already tracked in Machine Learning, your team can develop their own taxonomy within their Git-compatible service to store other project information, such as:

- Documentation
    - Project, for example the final project report
    - Data report, for example the data dictionary or data quality reports
    - Model, for example model reports
- Code
    - Data preparation
    - Model development
    - Operationalization, including security and compliance

### Infrastructure and resources

The TDSP provides recommendations for managing shared analytics and storage infrastructure, in these categories:

- Cloud file systems for storing datasets
- Cloud Databases
- Big data clusters, for example SQL or Spark
- AI and machine learning services

#### Cloud file systems for storing datasets

Cloud file systems are crucial for Microsoft\'s Team Data Science
Process (TDSP) for several reasons:

**1. Centralized Data Storage**

Cloud file systems provide a centralized location for storing datasets,
which is essential for collaboration among data science team members.
This centralization ensures that all team members have access to the
most up-to-date data, reducing the risk of working with outdated or
inconsistent datasets.

**2. Scalability**

Cloud file systems can handle large volumes of data, which is common in
data science projects. They offer scalable storage solutions that can
grow with the needs of the project, allowing teams to store and process
massive datasets without worrying about hardware limitations.

**3. Accessibility**

With cloud file systems, data can be accessed from anywhere with an
internet connection. This is particularly important for distributed
teams or when team members need to work remotely. It facilitates
seamless collaboration and ensures that data is always available when
needed.

**4. Security and Compliance**

Cloud providers often offer robust security measures, including
encryption, access controls, and compliance with industry standards and
regulations. This ensures that sensitive data is protected and that the
team can meet legal and regulatory requirements.

**5. Version Control**

Cloud file systems often include version control features, which allow
teams to track changes to datasets over time. This is crucial for
maintaining the integrity of the data and for reproducing results in
data science projects. It also helps in auditing and troubleshooting any
issues that arise.

**6. Integration with Tools**

Cloud file systems can integrate seamlessly with various data science
tools and platforms. This integration allows for smooth data ingestion,
processing, and analysis. For example, Microsoft Azure\'s cloud storage
integrates well with Azure Machine Learning, Databricks, and other data
science tools.

**7. Collaboration and Sharing**

These systems make it easy to share datasets with other team members or
stakeholders. They support collaborative features such as shared folders
and permissions management, which facilitate teamwork and ensure that
the right people have access to the data they need.

**8. Cost Efficiency**

Using cloud file systems can be more cost-effective than maintaining
on-premises storage solutions. Cloud providers offer flexible pricing
models, including pay-as-you-go options, which can help manage costs
based on the actual usage and storage requirements of the data science
project.

**9. Disaster Recovery**

Cloud file systems typically include features for data backup and
disaster recovery. This ensures that data is not lost in the event of
hardware failures, accidental deletions, or other disasters. It provides
peace of mind and ensures continuity in data science operations.

**10. Automation and Workflow Integration**

Cloud storage systems can be integrated into automated workflows,
enabling the seamless transfer of data between different stages of the
data science process. This automation can improve efficiency and reduce
the manual effort required to manage data.

In summary, cloud file systems are integral to the TDSP because they
enhance collaboration, scalability, security, and efficiency in managing
and processing data, ultimately leading to more effective and successful
data science projects.

**Recommended Azure Resources

1. [Azure Blob Storage](/azure/storage/blobs/) - Comprehensive documentation on Azure Blob Storage, a scalable object storage service for unstructured data.

2. [Azure Data Lake Storage](/azure/storage/data-lake-storage/) - Information on Azure Data Lake Storage Gen2, designed for big data analytics and supporting large-scale datasets.

3. [Azure Files](/azure/storage/files/) - Details on Azure Files, providing fully managed file shares in the cloud.

#### Cloud Databases

Cloud databases play a critical role in Microsoft\'s Team Data Science
Process (TDSP) for several reasons:

**1. Scalability**

Cloud databases offer scalable solutions that can easily grow with the
increasing data needs of a project. This is essential for data science
projects that often involve large and complex datasets. Cloud databases
can handle varying workloads without the need for manual intervention or
hardware upgrades.

**2. Performance Optimization**

Cloud databases are optimized for performance, with capabilities such as
automatic indexing, query optimization, and load balancing. These
features help ensure that data retrieval and processing are fast and
efficient, which is crucial for data science tasks that require
real-time or near-real-time data access.

**3. Accessibility and Collaboration**

Data stored in cloud databases can be accessed from anywhere,
facilitating collaboration among team members who may be geographically
dispersed. This is particularly important for distributed teams or those
working remotely. Cloud databases support multi-user environments,
enabling simultaneous access and collaboration.

**4. Integration with Data Science Tools**

Cloud databases seamlessly integrate with various data science tools and
platforms. For example, Microsoft Azure\'s cloud databases integrate
well with Azure Machine Learning, Power BI, and other data analytics
tools. This integration streamlines the data pipeline, from ingestion
and storage to analysis and visualization.

**5. Security and Compliance**

Cloud providers implement robust security measures, including data
encryption, access controls, and compliance with industry standards and
regulations. This ensures that sensitive data is protected and that the
team can meet legal and regulatory requirements. Security features are
critical for maintaining data integrity and privacy.

**6. Cost Efficiency**

Cloud databases often operate on a pay-as-you-go model, which can be
more cost-effective than maintaining on-premises database systems. This
pricing flexibility allows organizations to manage their budgets
effectively, paying only for the storage and computing resources they
use.

**7. Automatic Backups and Disaster Recovery**

Cloud databases provide automatic backup and disaster recovery
solutions, ensuring that data is not lost in the event of hardware
failures, accidental deletions, or other disasters. This reliability is
crucial for maintaining data continuity and integrity in data science
projects.

**8. Real-Time Data Processing**

Many cloud databases support real-time data processing and analytics,
which is essential for data science tasks that require up-to-date
information. This capability allows data scientists to make timely
decisions based on the latest data available.

**9. Data Integration**

Cloud databases can easily integrate with other data sources, including
other databases, data lakes, and external data feeds. This integration
capability allows data scientists to combine data from multiple sources,
providing a more comprehensive view and enabling more sophisticated
analysis.

**10. Flexibility and Variety**

Cloud databases come in various forms, such as relational databases,
NoSQL databases, and data warehouses. This variety allows data science
teams to choose the best type of database for their specific needs,
whether they require structured data storage, unstructured data
handling, or large-scale data analytics.

**11. Support for Advanced Analytics**

Cloud databases often come with built-in support for advanced analytics
and machine learning. For example, Azure SQL Database offers built-in
machine learning services, enabling data scientists to perform advanced
analytics directly within the database environment.

In summary, cloud databases are essential for TDSP because they provide
scalable, secure, and efficient data storage and processing
capabilities. They enhance collaboration, integration, and performance,
ultimately leading to more effective and efficient data science
projects.

** Azure Resources

- [Azure SQL Database](/azure/azure-sql/database/) - Documentation on Azure SQL Database, a fully managed relational database service.
- [Azure Cosmos DB](/azure/cosmos-db/) - Information on Azure Cosmos DB, a globally distributed, multi-model database service.
- [Azure Database for PostgreSQL](/azure/postgresql/) - Guide to Azure Database for PostgreSQL, a managed database service for app development and deployment.
- [[Azure Database for MySQL]](/azure/mysql/) - Details on Azure Database for MySQL, a managed service for MySQL databases.

#### Big data clusters (SQL or Spark)

Big data clusters, such as those using SQL or Spark, are fundamental to
Microsoft\'s Team Data Science Process (TDSP) for several reasons:

**1. Handling Large Volumes of Data**

Big data clusters are designed to handle large volumes of data
efficiently. Data science projects often involve massive datasets that
exceed the capacity of traditional databases. SQL-based big data
clusters and Spark can manage and process this data at scale.

**2. Distributed Computing**

Big data clusters utilize distributed computing, spreading data and
computational tasks across multiple nodes. This parallel processing
capability significantly speeds up data processing and analysis tasks,
which is essential for timely insights in data science projects.

**3. Scalability**

These clusters offer high scalability, both horizontally (adding more
nodes) and vertically (adding more power to existing nodes). This
scalability ensures that the data infrastructure can grow with the needs
of the project, accommodating increasing data sizes and complexity.

**4. Integration with Data Science Tools**

Big data clusters integrate well with various data science tools and
platforms. For example, Spark integrates seamlessly with Hadoop, and SQL
clusters can work with a variety of data analysis tools. This
integration facilitates a smooth workflow from data ingestion to
analysis and visualization.

**5. Advanced Analytics**

Big data clusters support advanced analytics and machine learning. For
instance, Spark provides built-in libraries for machine learning
(MLlib), graph processing (GraphX), and stream processing (Spark
Streaming). These capabilities allow data scientists to perform complex
analytics directly within the cluster.

**6. Real-Time Data Processing**

Big data clusters, especially those using Spark, support real-time data
processing. This capability is crucial for projects that require
up-to-the-minute data analysis and decision-making. Real-time processing
helps in scenarios like fraud detection, real-time recommendations, and
dynamic pricing.

**7. Data Transformation and ETL**

Big data clusters are ideal for data transformation and Extract,
Transform, Load (ETL) processes. They can efficiently handle complex
data transformations, cleaning, and aggregation tasks, which are often
necessary before data can be analyzed.

**8. Cost Efficiency**

Utilizing big data clusters can be cost-effective, especially when
leveraging cloud-based solutions like Azure Databricks or Amazon EMR.
These services offer flexible pricing models, including pay-as-you-go,
which can be more economical than maintaining on-premises big data
infrastructure.

**9. Fault Tolerance**

Big data clusters are designed with fault tolerance in mind. They
replicate data across nodes, ensuring that the system remains
operational even if some nodes fail. This reliability is critical for
maintaining data integrity and availability in data science projects.

**10. Data Lake Integration**

Big data clusters often integrate seamlessly with data lakes, allowing
data scientists to access and analyze diverse data sources in a unified
manner. This integration supports more comprehensive analyses by
enabling the combination of structured and unstructured data.

**11. SQL-Based Processing**

For data scientists familiar with SQL, big data clusters that support
SQL queries (such as Spark SQL or SQL on Hadoop) provide a familiar
interface for querying and analyzing big data. This ease of use can
accelerate the analysis process and make it more accessible to a broader
range of users.

**12. Collaboration and Sharing**

Big data clusters support collaborative environments where multiple data
scientists and analysts can work together on the same datasets. They
offer features for sharing code, notebooks, and results, fostering
teamwork and knowledge sharing.

**13. Security and Compliance**

Big data clusters provide robust security features, including data
encryption, access controls, and compliance with industry standards.
This ensures that sensitive data is protected and that the team can meet
regulatory requirements.

In summary, big data clusters are crucial for TDSP because they offer
scalable, efficient, and powerful data processing capabilities. They
enhance the ability to handle large datasets, perform advanced
analytics, and integrate with various data tools and sources, ultimately
leading to more effective and impactful data science projects.

** Azure Resources

- [Apache Spark in Azure Machine Learning](/azure/machine-learning/apache-spark-azure-ml-concepts) - Azure Machine Learning integration with Azure Synapse Analytics provides easy access to distributed computation resources through the Apache Spark framework.
- [Azure Synapse Analytics](/azure/synapse-analytics/) - Comprehensive documentation for Azure Synapse Analytics, integrating big data and data warehousing.
- [Azure HDInsight](/azure/hdinsight/) - Information on Azure HDInsight, a cloud distribution of Hadoop components including Spark.

#### AI and machine learning services

AI and machine learning (ML) services are integral to Microsoft\'s Team
Data Science Process (TDSP) for several reasons:

**1. Advanced Analytics**

AI and ML services enable advanced analytics, allowing data scientists
to uncover complex patterns, make predictions, and generate insights
that are not possible with traditional analytical methods. These
advanced capabilities are crucial for creating high-impact data science
solutions.

**2. Automation of Repetitive Tasks**

AI and ML services can automate repetitive tasks such as data cleaning,
feature engineering, and model training. This automation saves time and
allows data scientists to focus on more strategic aspects of the
project, improving overall productivity.

**3. Improved Accuracy and Performance**

Machine learning models can improve the accuracy and performance of
predictions and analyses by learning from data. These models can
continuously improve as they are exposed to more data, leading to better
decision-making and more reliable results.

**4. Scalability**

AI and ML services offered by cloud platforms, such as Azure Machine
Learning, are highly scalable. They can handle large volumes of data and
complex computations, enabling data science teams to scale their
solutions to meet growing demands without worrying about underlying
infrastructure limitations.

**5. Integration with Other Tools**

AI and ML services integrate seamlessly with other tools and services
within the Microsoft ecosystem, such as Azure Data Lake, Azure
Databricks, and Power BI. This integration facilitates a streamlined
workflow from data ingestion and processing to model deployment and
visualization.

**6. Model Deployment and Management**

These services provide robust tools for deploying and managing machine
learning models in production. Features such as version control,
monitoring, and automated retraining ensure that models remain accurate
and effective over time, simplifying the maintenance of ML solutions.

**7. Real-Time Processing**

AI and ML services support real-time data processing and
decision-making, which is essential for applications that require
immediate insights and actions, such as fraud detection, dynamic
pricing, and recommendation systems.

**8. Customizability and Flexibility**

These services offer a range of customizable options, from pre-built
models and APIs to frameworks for building custom models from scratch.
This flexibility allows data science teams to tailor solutions to
specific business needs and use cases.

**9. Access to Cutting-Edge Algorithms**

Using AI and ML services, data scientists have access to cutting-edge
algorithms and technologies developed by leading researchers. This
access ensures that the team can leverage the latest advancements in AI
and machine learning for their projects.

**10. Collaboration and Sharing**

AI and ML platforms support collaborative development environments,
where multiple team members can work together on the same project, share
code, and reproduce experiments. This collaboration enhances teamwork
and ensures consistency in model development.

**11. Cost Efficiency**

Leveraging AI and ML services on the cloud can be more cost-effective
than building and maintaining on-premises solutions. Cloud providers
offer flexible pricing models, including pay-as-you-go options, which
can reduce costs and optimize resource usage.

**12. Enhanced Security and Compliance**

These services come with robust security features, including data
encryption, secure access controls, and compliance with industry
standards and regulations. This ensures that data and models are
protected, and legal and regulatory requirements are met.

**13. Pre-built Models and APIs**

Many AI and ML services offer pre-built models and APIs for common tasks
such as natural language processing, image recognition, and anomaly
detection. These pre-built solutions can accelerate development and
deployment, allowing teams to quickly integrate AI capabilities into
their applications.

**14. Experimentation and Prototyping**

AI and ML platforms provide environments for rapid experimentation and
prototyping. Data scientists can quickly test different algorithms,
parameters, and data sets to find the best solution, facilitating an
iterative approach to model development.

In summary, AI and machine learning services are crucial for TDSP
because they enhance the capabilities of data science teams, improve the
efficiency and effectiveness of their work, and enable the development
of sophisticated, scalable, and high-performing data science solutions.

** Azure Resources
- [Azure Machine Learning](/azure/machine-learning/) - The main documentation page for Azure Machine Learning, covering setup, model training, deployment, and more.
- [Azure AI Services](/azure/ai-services/) - Information on AI Services, offering pre-built AI models for vision, speech, language, and decision-making tasks.

### Responsible AI

With AI or machine learning solutions, Microsoft promotes [responsible AI tools](/azure/machine-learning/concept-responsible-ai), which helps achieve Microsoft's [Responsible AI Standard](https://www.microsoft.com/ai/principles-and-approach/). Your workload must still individually address AI-related harms.

## Peer-reviewed citations

TDSP is a well-established methodology used across Microsoft engagements, and therefore has been documented and studied in peer-reviewed literature. These citations provide an opportunity to investigate TDSP features and applications. See the [lifecycle overview page](lifecycle.md) for a list of citations.

## Related resources

[Roles and tasks in the Team Data Science Process](roles-tasks.md)
