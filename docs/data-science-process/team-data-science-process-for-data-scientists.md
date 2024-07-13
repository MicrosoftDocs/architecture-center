---
title: Team Data Science Process for data scientists
description: Training guidance on a set of objectives that are typically used to implement comprehensive data science solutions with Azure technologies using the Team Data Science Process and Azure Machine Learning.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.date: 07/02/2024
ms.author: tdsp
ai-usage: ai-assisted
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Team Data Science Process for data scientists

This article provides training guidance for objectives that you set when you implement comprehensive data science solutions with Azure technologies.

## Objectives for Data Scientists

This list describes the key objectives for data scientists using TDSP:

- [Understand an analytics workload](#understand-an-analytics-workload)
- [Use the Team Data Science Process (TDSP)](#use-the-team-data-science-process-tdsp)
- [Use Azure Machine Learning](#use-azure-machine-learning)
- [Understand the foundations of data transfer and storage](#understand-the-foundations-of-data-transfer-and-storage)
- [Provide data source documentation](#provide-data-source-documentation)
- [Use tools for analytics processing](#use-tools-for-analytics-processing)

These objectives are crucial for preparing to use Microsoft's Team Data Science Process (TDSP) because it outlines a comprehensive approach to effectively managing and executing data science projects. Each objective includes its importance and links to these Azure resources.

### Understand an analytics workload

- **Identify requirements**: This step involves understanding the specific needs and goals of the analytics workload. It helps in identifying the business questions to be answered and the problems to be solved.

- **Define scope**: Clearly defining the scope of the project ensures that the team focuses on relevant data and analytics tasks.

- **Resource allocation**: Understanding the workload helps in determining the resources required, such as computing power, storage, and human expertise.

#### Integration within TDSP

Azure has many resources which could be used for analytics workloads. This list provides recommended resources often used in Azure architectures.

- **Planning and Execution**: Use the [Cloud Adoption Framework](/azure/cloud-adoption-framework/innovate/ai) for strategic planning and governance, ensuring that the analytics workload aligns with business goals and compliance requirements. Cloud Adoption Framework elaborates on the comparatively straightforward framework used in TDSP. Features of the Cloud Adoption Framework include:

  - **Strategic Planning**: Offers strategic guidance to align cloud adoption with business objectives, ensuring that analytics workloads are designed to meet organizational goals.

  - **Governance and compliance**: Provides frameworks for governance and compliance, ensuring that data processing and analytics workloads adhere to regulatory requirements and organizational policies.

  - **Migration and modernization**: Guides the migration of existing analytics workloads to Azure, ensuring minimal disruption and optimal performance in the new environment.

  - **Management and operations**: Outlines best practices for managing and operating cloud resources, ensuring the efficient and reliable operation of analytics workloads.

  - **Optimization**: Offers tools and methodologies to continuously optimize workloads, ensuring that resources are used efficiently, and costs are managed effectively.

- **Development and Collaboration**: Utilize [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) for developing, testing, and deploying analytics solutions, providing a collaborative environment for data scientists and engineers. Synapse Analytics is a recommended platform for big data (one terabyte and higher) machine learning and AI modeling.

  - **Unified Experience**: Provides a unified experience to ingest, prepare, manage, and serve data for immediate business intelligence and machine learning needs.

  - **Data Integration**: Seamlessly integrates with various data sources, enabling comprehensive data ingestion and processing capabilities.

  - **Big Data and Data Warehousing**: Combines big data and data warehousing capabilities, allowing you to run complex queries across large datasets efficiently.

  - **Scalability**: Scales computational resources based on workload demands, ensuring that you can handle varying data processing loads effectively.

  - **Collaboration**: Facilitates collaboration within data science teams by providing shared workspaces and integrated development environments (IDEs).

  - **Analytics**: Supports advanced analytics and machine learning with built-in integration for services like Azure Machine Learning and Power BI.

- **Monitoring and Optimization**: Leverage [Azure Monitor](/azure/azure-monitor/overview) to track performance, identify issues, and optimize the analytics workload, ensuring high availability and reliability.

  - **Data Collection**: Gathers metrics and logs from various sources, including Azure resources, applications, and the operating system.

  - **Monitoring**: Provides insights into the performance and health of your analytics workloads by monitoring metrics such as CPU usage, memory usage, and throughput.

  - **Diagnostics**: Helps identify issues and anomalies in your data processing pipelines and workloads through diagnostic logs and activity logs.

  - **Alerting**: Configures alerts based on specific metrics or log data, ensuring you are promptly notified of potential issues that could impact the performance or reliability of your analytics workloads.

  - **Visualization**: Offers customizable dashboards and workbooks to visualize data, helping you understand trends and patterns in your workload performance.

### Use the Team Data Science Process (TDSP)

- **Structured approach**: TDSP provides a structured framework for executing data science projects, ensuring a systematic and disciplined approach.

- **Collaboration**: TDSP promotes collaboration among team members by defining clear roles and responsibilities.

- **Best practices**: TDSP incorporates industry best practices, ensuring that projects are conducted efficiently and effectively.

#### Integration for Data Scientists

The Team Data Science Process is a peer-reviewed architectural framework providing data scientists with a specific framework for producing AI and data science models.

- [Team Data Science Process overview](/azure/machine-learning/team-data-science-process/overview) - Introduces the TDSP and its lifecycle.

- [TDSP lifecycle and key components](/azure/machine-learning/team-data-science-process/lifecycle) - Details the lifecycle stages and key components of TDSP.

### Use Azure Machine Learning

- **Advanced analytics**: Azure Machine Learning provides powerful tools and services for building, training, and deploying machine learning models.

- **Scalability**: Azure ML offers scalable computing resources, allowing teams to handle large datasets and complex models.

- **Integration**: It integrates well with other Azure services, facilitating a seamless workflow from data ingestion to deployment.

[Azure Machine Learning (Azure ML)](/azure/machine-learning) is the main recommended Azure resource for each of the five stages of Microsoft's Team Data Science Process (TDSP) lifecycle, which are: Business Understanding, Data Acquisition and Understanding, Modeling, Deployment, and Customer Acceptance. Here\'s how Azure ML supports each stage:

#### Business understanding

In this initial stage, the focus is on understanding the business requirements and defining the objectives of the data science project.

- **Project Workspaces**: Azure ML provides project workspaces where teams can collaborate and share documents, ensuring that everyone is aligned with the business objectives.

- **Experiment Tracking**: The platform allows for documentation and tracking of initial hypotheses and business metrics that will guide the data science project.

- **Integration with Azure DevOps**: Teams can use Azure DevOps to manage project workflows, user stories, and tasks, ensuring that the business understanding is clearly mapped to actionable items.

#### Data acquisition and understanding

This stage involves gathering and exploring data to understand its structure and relevance to the business problem.

- **Data integration**: Azure ML integrates seamlessly with Azure Data Lake, Azure SQL Database, and other data services, facilitating easy data ingestion from various sources.

- **Data labeling**: Built-in data labeling tools help in annotating datasets, which is particularly useful for supervised learning models.

- **Exploratory Data Analysis (EDA)**: Jupyter notebooks and integrated Python/R environments in Azure ML enable thorough EDA to understand data distributions, identify patterns, and detect anomalies.

#### Modeling

In the modeling stage, data scientists build and train machine learning models to address business problems.

- **Automated ML**: Azure ML's Automated ML capabilities can automatically select the best algorithms and tune hyperparameters, speeding up the model development process.

- **Custom modeling**: It supports custom model development using popular frameworks like TensorFlow, PyTorch, and Scikit-learn.

- **Experimentation and versioning**: Azure ML enables running multiple experiments in parallel, tracking results, and versioning models, making it easier to compare and select the best model.

- **Hyperparameter tuning**: Built-in support for automated hyperparameter tuning helps optimize model performance.

#### Deployment

Once a model is developed and validated, it needs to be deployed so it can be used in production environments.

- **Model deployment**: Azure ML provides various deployment options, including Azure Kubernetes Service (AKS) and edge devices, allowing for flexible deployment strategies.
- 
- **Endpoint management**: It offers tools for managing endpoints for real-time and batch predictions, ensuring scalable and reliable model serving.

- **CI/CD integration**: Azure ML integrates with Azure DevOps, enabling continuous integration and continuous deployment (CI/CD) for machine learning models, to build repeatable transitions from development to production.

#### Customer acceptance

In the final stage, the focus is on ensuring that the deployed model meets the business requirements and delivers value.

- **Model Monitoring**: Azure ML provides comprehensive monitoring capabilities to track model performance, detect drift, and ensure models remain accurate and relevant over time.

- **Feedback Loops**: It supports the implementation of feedback loops where predictions are reviewed and used to retrain models, continuously improving model accuracy and relevance.

- **Reporting and Visualization**: Integration with notebooks, Power BI and other visualization tools helps in creating dashboards and reports to present model results and insights to stakeholders.

- **Security and Compliance**: Azure ML ensures that models and data comply with regulatory requirements, providing tools for managing data privacy and security.

### Understand the foundations of data transfer and storage

- **Data management**: Effective data transfer and storage are critical for managing large volumes of data securely and efficiently.

- **Accessibility**: Ensures that data is easily accessible to team members and analytical tools, which is essential for collaboration and real-time processing.

- **Compliance and security**: Understanding these foundations helps in ensuring that data handling complies with legal and regulatory requirements and that sensitive data is protected.

#### Integration of data transfer and storage within TDSP

Azure has many resources which could be used for data transfer and storage. This list provides recommended resources often used in Azure architectures.

[**Azure Data Transfer Options**](/azure/architecture/data-guide/scenarios/data-transfer) encompass various methods and tools for moving data to and from Azure efficiently, catering to different needs and data sizes.

- **Azure Data Box**: A physical device for large-scale data transfer, ideal for transferring terabytes of data where network bandwidth is limited. This ensures that bulk data can be securely transported to Azure without relying on the internet.

- **Azure Import/Export Service**: Allows for transferring large amounts of data to Azure by shipping hard drives directly to Azure data centers. This is useful for initial data migrations where uploading via network is impractical.

- **Azure Data Factory**: A cloud-based data integration service that orchestrates and automates data movement and transformation. It enables complex ETL (extract, transform, load) processes, integrating data from various sources into Azure for analytics and machine learning tasks.

- **Network Transfer**: Includes high-speed internet-based transfers using Azure ExpressRoute, providing a private connection between on-premises infrastructure and Azure, ensuring secure and fast data transfer.

[**Azure Database Migration Service**](/azure/dms/dms-overview) facilitates the smooth migration of databases to Azure, ensuring minimal downtime and data integrity. Azure Database Migration Service is a fully managed service designed to enable seamless migrations from multiple database sources to Azure data platforms with minimal downtime (online migrations). It offers the following benefits:

- **Automated Migration**: Simplifies the migration process by providing automated workflows for moving on-premises databases to Azure SQL Database, Azure Database for MySQL, and Azure Database for PostgreSQL.

- **Continuous Replication**: Supports continuous data replication, allowing for minimal downtime and ensuring data is up-to-date during the migration process.

- **Compatibility**: Ensures compatibility checks and recommends optimizations for the target Azure environment, making the transition seamless and efficient.

- **Assessment Tools**: Provides tools for assessing the readiness of databases for migration, identifying potential issues, and offering recommendations to resolve them.

[**Azure Storage**](/azure/storage) offers scalable, secure, and durable storage solutions tailored for different types of data and use cases. The following storage types are supported:

- **Blob Storage**: Optimized for storing unstructured data such as documents, images, videos, and backups. It's ideal for data scientists needing to store large datasets used in machine learning models.

- **Azure Data Lake Storage**: Designed for big data analytics, it provides hierarchical namespace and compatibility with Hadoop, making it suitable for large-scale data analytics projects.

- **Table Storage**: NoSQL key-value store for semi-structured data, suitable for applications requiring a schema-less design.

- **File Storage**: Fully managed file shares in the cloud, accessible via standard SMB protocol, useful for shared storage needs.

- **Queue Storage**: Provides messaging between application components, useful for decoupling and scaling services.

### Provide data source documentation

- **Data transparency**: Documentation of data sources ensures transparency about where data comes from, its quality, and its limitations.

- **Reproducibility**: Proper documentation allows other team members or stakeholders to understand and reproduce the data science process.

- **Data integration**: Helps in integrating various data sources effectively by providing a clear understanding of the data's origin and structure.

#### Integration of data source documentation within TDSP

Azure has many resources which could be used for data source documentation (including notebooks). This list provides recommended resources often used in Azure architectures.

[**Azure Data Catalog**](/azure/data-catalog) is an enterprise-wide metadata catalog that makes data asset discovery straightforward. It helps document data sources and their characteristics and provides the following benefits:

- **Metadata Management**: Allows users to register data sources and add metadata, including descriptions, tags, and annotations.

- **Data Source Discovery**: Provides a searchable catalog for users to find and understand the data sources available within the organization.

- **Collaboration**: Enables users to share insights and documentation about data sources, improving collaboration among team members.

- **Data Source Information**: Automatically extracts and documents information about data sources, such as schemas, tables, columns, and relationships.

[**Azure Purview**](/azure/purview) is a unified data governance service that helps manage and govern data across your organization.

- **Data Mapping and Lineage**: Helps document the data flow and lineage across different systems, providing a clear view of where data comes from and how it's transformed.

- **Data Catalog**: Similar to Azure Data Catalog, it provides a searchable data catalog enriched with metadata and data classifications.

- **Business Glossary**: Helps create and maintain a business glossary to ensure consistent terminology and understanding across the organization.

- **Insights and Analytics**: Provides insights into data usage and helps identify data quality issues, improving the documentation process.

### Use tools for analytics processing

- **Efficiency**: Utilizing the right tools for analytics processing enhances the efficiency and speed of data analysis.

- **Capabilities**: Different tools offer various capabilities, such as data visualization, statistical analysis, and machine learning, which are essential for comprehensive data science.

- **Productivity**: Using specialized tools can significantly improve the productivity of data scientists by automating repetitive tasks and providing advanced analytical functions.

#### Integration of analytics processing within TDSP

Azure has many services that can be used for analytics processing, with Azure Machine Learning as the primary recommended service. However, this list provides recommended services often used in Azure architectures that require features beyond Azure Machine Learning.

[**Azure Synapse Analytics**](/azure/synapse-analytics/overview-what-is) is an integrated analytics service that accelerates time to insight across data warehouses and big data systems. It provides the following functionality:

- **Data Integration**: Integrates data from various sources, enabling seamless data ingestion and processing.

- **SQL Data Warehouse**: Provides enterprise data warehousing capabilities with high-performance querying.

- **Apache Spark**: Offers Spark pools for big data processing, supporting large-scale data analytics and machine learning.

- **Synapse Studio**: An integrated development environment (IDE) that allows data scientists to build end-to-end analytics solutions collaboratively.

[**Azure Databricks**](/azure/databricks/introduction/) is an Apache Spark-based analytics platform optimized for Azure, offering the following features:

- **Collaborative Notebooks**: Supports collaborative workspaces where data scientists can write code, run experiments, and share results.

- **Scalable Compute**: Automatically scales compute resources based on workload demands, optimizing cost and performance.

- **Machine Learning**: Provides built-in libraries for machine learning, including MLlib, TensorFlow, and Keras, to streamline model development and training.

[**Azure Data Factory**](/azure/data-factory/introduction) is a cloud-based data integration service that orchestrates data movement and transformation. It supports the following functionality:

- **ETL pipelines**: Enables the creation of ETL (extract, transform, load) pipelines to process and prepare data for analysis.

- **Data flow**: Provides visual data flow authoring to design and run data transformation processes without writing code.

- **Integration**: Connects to a wide range of data sources, including on-premises and cloud-based data stores, ensuring comprehensive data integration.

[**Azure Stream Analytics**](/azure/stream-analytics/stream-analytics-introduction) is a real-time analytics service designed for processing fast-moving data streams, providing the following features:

- **Stream Processing**: Processes data from various sources such as IoT devices, sensors, and applications in real-time.

- **SQL-based Querying**: Uses a familiar SQL-based language for defining stream processing logic, making it accessible for data scientists.

- **Integration**: Integrates with other Azure services like Event Hubs and IoT Hub for seamless data ingestion and processing.

### Summary

Following this sequential list ensures a comprehensive preparation for using TDSP by:

1. Establish a clear understanding of the project requirements and scope.

1. Adopt a structured and collaborative approach to project execution.

1. Use advanced tools and services for machine learning and analytics.

1. Ensure efficient and secure data management.

1. Maintain transparency and reproducibility through documentation.

1. Utilize appropriate tools to enhance the efficiency and effectiveness of data processing.

This preparation is critical for delivering successful data science projects that meet business objectives and adhere to best practices.

## Training paths on Microsoft Learn

Whether you're just starting a career, or you are an experienced professional, our self-directed approach helps you arrive at your goals faster, with more confidence and at your own pace. Develop skills through interactive modules and paths or learn from an instructor. Learn and grow your way.

Microsoft Learn organizes its training content into three skill levels: beginner, intermediate, and advanced. Understanding these distinctions is essential for selecting the appropriate learning paths to match your skill level and career goals.

### Beginner

- **Target audience:** Individuals who are new to the technology or concept being covered.
- **Content:** Basic introductions to concepts, fundamental skills, and initial steps required to get started. It typically covers core principles and foundational knowledge.

**Purpose:**

- To build a solid foundation in a new area.
- To ensure learners understand basic concepts and terminologies.
- To prepare learners for more complex topics.

#### Beginner learning paths

- [Copilot foundations](/training/paths/copilot-foundations/)
- [Deploy and consume models with Azure Machine Learning](/training/paths/deploy-consume-models-azure-machine-learning/)
- [Design a machine learning solution](/training/paths/design-machine-learning-solution/)
- [Experiment with Azure Machine Learning](/training/paths/automate-machine-learning-model-selection-azure-machine-learning/)
- [Explore and configure the Azure Machine Learning workspace](/training/paths/explore-azure-machine-learning-workspace/)
- [Implement a data science and machine learning solution for AI in Microsoft Fabric](/training/paths/implement-data-science-machine-learning-fabric/)
- [Manage and review models in Azure Machine Learning](/training/paths/manage-review-models-azure-machine-learning/)
- [Optimize model training with Azure Machine Learning](/training/paths/use-azure-machine-learning-pipelines-for-automation/)
- [Predict rocket launch delays with machine learning](/training/paths/machine-learning-predict-launch-delay-nasa/)
- [Train and manage a machine learning model with Azure Machine Learning](/training/paths/train-deploy-machine-learning-model/)
- [Train models with scripts in Azure Machine Learning](/training/paths/train-models-scripts-azure-machine-learning/)
- [Understand data science for machine learning](/training/paths/understand-machine-learning/)
- [Use notebooks for experimentation in Azure Machine Learning](/training/paths/use-notebooks-for-experimentation-azure-machine-learning/)
- [Work with compute in Azure Machine Learning](/training/paths/work-compute-azure-machine-learning/)
- [Work with data in Azure Machine Learning](/training/paths/work-data-azure-machine-learning/)

### Intermediate

- **Target audience:** Individuals who have a basic understanding of the technology and are looking to deepen their knowledge.
- **Content:** More detailed and practical skills, including hands-on exercises and real-world scenarios. It involves a deeper dive into the subject matter.

**Purpose:**

- To bridge the gap between basic understanding and advanced proficiency.
- To enable learners to handle more complex tasks and scenarios.
- To prepare learners for certification exams or specialized roles.

#### Intermediate learning paths

- [Create custom copilots with Azure AI Studio](/training/paths/create-custom-copilots-ai-studio/)
- [Create machine learning models](/training/paths/create-machine-learn-models/)
- [Develop custom object detection models with NVIDIA and Azure Machine Learning](/training/paths/develop-custom-object-detection-models-with-nvidia-and-azure-machine-learning/)
- [End-to-end machine learning operations (MLOps) with Azure Machine Learning](/training/paths/build-first-machine-operations-workflow/)
- [Implement a Machine Learning solution with Azure Databricks](/training/paths/build-operate-machine-learning-solutions-azure-databricks/)
- [Train models in Azure Machine Learning with the CLI (v2)](/training/paths/train-models-azure-machine-learning-cli-v2/)
- [Work with generative artificial intelligence (AI) models in Azure Machine Learning](/training/paths/work-with-generative-models-azure-machine-learning/)

### Advanced

- **Target audience:** Experienced professionals who are looking to master their skills and tackle complex, high-level tasks.
- **Content:** In-depth technical training, advanced techniques, and comprehensive coverage of specialized topics. It often includes expert-level problem-solving and optimization strategies.

**Purpose:**

- To provide expertise in a specific area.
- To prepare learners for expert-level certifications and advanced career roles.
- To enable learners to lead projects and innovate within their field.

#### Expert learning path

- [Train compute-intensive models with Azure Machine Learning](/training/paths/train-compute-intensive-models-azure-machine-learning/)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Continue your AI journey in the [AI learning hub](/ai/).

## Related resources

- [Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)
- [What is the Team Data Science Process?](overview.yml)
