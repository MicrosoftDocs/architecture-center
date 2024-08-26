---
title: Team Data Science Process for data scientists
description: Learn about the Team Data Science Process and Azure Machine Learning objectives that you can use to implement comprehensive data science solutions with Azure technologies.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 07/12/2024
ms.author: tdsp
ms.custom: arb-aiml
ai-usage: ai-assisted
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Team Data Science Process for data scientists

This article provides guidance and training on the objectives to set when you implement comprehensive data science solutions with Azure technologies.

## Objectives for data scientists

This list describes the key objectives for data scientists that use the Team Data Science Process (TDSP):

- [Understand an analytics workload](#understand-an-analytics-workload).
- [Use the TDSP lifecycle](#use-the-tdsp-lifecycle).
- [Use Azure Machine Learning](#use-azure-machine-learning).
- [Understand the foundations of data transfer and data storage](#understand-the-foundations-of-data-transfer-and-data-storage).
- [Provide data source documentation](#provide-data-source-documentation).
- [Use tools for analytics processing](#use-tools-for-analytics-processing).

These objectives are crucial for preparing to use the TDSP. The TDSP outlines a comprehensive approach to effectively manage and launch data science projects. This article describes the importance of each objective and provides links to the relevant Azure resources.

### Understand an analytics workload

- **Identify requirements**: This step includes understanding the specific needs and goals of the analytics workload. It helps identify the business questions to answer and the problems to solve.

- **Define scope**: This step is about clearly defining the scope of the project to help the team focus on relevant data and analytics tasks.

- **Allocate resources**: This step includes analyzing the workload to identify the required resources, such as computing power, storage, and human expertise.

#### Integration within the TDSP

Azure has many resources that you can use for analytics workloads. The following list provides recommended resources in Azure architectures.

- **Planning and execution**: Use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/innovate/ai) for strategic planning and governance. This framework ensures that your analytics workload aligns with business goals and compliance requirements. It also builds on the comparatively straightforward framework that you use in the TDSP. Features of the Cloud Adoption Framework include:

  - **Strategic planning**: Provides strategic guidance to align cloud adoption with business objectives. Strategic planning means that you design analytics workloads to meet organizational goals.

  - **Governance and compliance**: Provides frameworks for governance and compliance. Governance and compliance frameworks make data processing and analytics workloads adhere to regulatory requirements and organizational policies.

  - **Migration and modernization**: Guides the migration of existing analytics workloads to Azure to help ensure minimal disruption and optimal performance in the new environment.

  - **Management and operations**: Outlines best practices for managing and operating cloud resources, which helps ensure efficient and reliable analytics workloads operations.

  - **Optimization**: Provides tools and methodologies to continuously optimize workloads. Optimization means that you use resources efficiently and manage costs effectively.

- **Development and collaboration**: Use [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) to develop, test, and deploy analytics solutions and provide a collaborative environment for data scientists and engineers. We recommend that you use the Azure Synapse Analytics platform to handle big data, such as one terabyte and more, and for machine learning and artificial intelligence (AI) modeling. Features of Azure Synapse Analytics include:

  - **Unified experience**: Provides a unified experience to ingest, prepare, manage, and serve data for immediate business intelligence and machine learning needs.

  - **Data integration**: Integrates seamlessly with various data sources, which enables comprehensive data ingestion and data processing capabilities.

  - **Big data and data warehousing**: Combines big data and data warehousing capabilities, which lets you run complex queries on large datasets efficiently.

  - **Scalability**: Scales computational resources based on workload demands, which ensures that you can handle varying data processing loads effectively.

  - **Collaboration**: Facilitates collaboration within data science teams by providing shared workspaces and integrated development environments (IDEs).

  - **Analytics**: Supports advanced analytics and machine learning with built-in integration for services like Machine Learning and Power BI.

- **Monitoring and optimization**: Use [Azure Monitor](/azure/azure-monitor/overview) to track performance, identify problems, and optimize the analytics workload. Azure Monitor helps with high availability and reliability. Features of Azure Monitor include:

  - **Data collection**: Gathers metrics and logs from various sources, including Azure resources, applications, and the operating system.

  - **Monitoring**: Provides insights into the performance and health of your analytics workloads by monitoring metrics such as CPU usage, memory usage, and throughput.

  - **Diagnostics**: Helps identify problems and anomalies in your data processing pipelines and workloads through diagnostic logs and activity logs.

  - **Alerting**: Configures alerts based on specific metrics or log data, and promptly notifies you of potential problems that could affect the performance or reliability of your analytics workloads.

  - **Visualization**: Provides customizable dashboards and workbooks to visualize data, which helps you understand trends and patterns in your workload performance.

### Use the TDSP lifecycle

Use the TDSP lifecycle to structure the development of your data science projects.

- **Structured approach**: Provides a structured framework for running data science projects, and fosters a systematic and disciplined approach.

- **Collaboration**: Promotes collaboration among team members by defining clear roles and responsibilities.

- **Best practices**: Incorporates industry best practices and helps you conduct your projects efficiently and effectively.

#### Integration for data scientists

The TDSP is a peer-reviewed architectural framework that provides data scientists with a specific framework for producing AI and data science models.

- [TDSP overview](/azure/machine-learning/team-data-science-process/overview) introduces the TDSP and its lifecycle.

- [TDSP lifecycle and key components](/azure/machine-learning/team-data-science-process/lifecycle) details the lifecycle stages and key components of the TDSP.

### Use Azure Machine Learning

Use Machine Learning to build and deploy machine learning models. [Machine Learning](/azure/machine-learning) is the main recommended Azure resource for each of the five stages of the TDSP lifecycle: Business Understanding, Data Acquisition and Understanding, Modeling, Deployment, and Customer Acceptance. Features of Machine Learning include:

- **Advanced analytics**: Provides powerful tools and services to build, train, and deploy machine learning models.

- **Scalability**: Provides scalable computing resources that let teams handle large datasets and complex models.

- **Integration**: Integrates well with other Azure services and facilitates a seamless workflow from data ingestion to deployment.

 Here's how Machine Learning supports each stage of the TDSP:

#### Business understanding

In this initial stage, Machine Learning helps you understand your business requirements and define the objectives of your data science project.

- **Project workspaces**: Provides project workspaces where teams can collaborate and share documents. Collaboration helps everyone align with the business objectives.

- **Experiment tracking**: Supports documentation and the ability to track the initial hypotheses and business metrics that guide your data science project.

- **Integration with Azure DevOps**: Manages project workflows, user stories, and tasks. Azure DevOps helps map business understanding to actionable items.

#### Data acquisition and understanding

In this stage, Machine Learning helps you gather and explore data to understand its structure and relevance to the business problem.

- **Data integration**: Machine Learning integrates seamlessly with Azure Data Lake, Azure SQL Database, and other data services, facilitating easy data ingestion from various sources.

- **Data labeling**: Built-in data labeling tools that help you annotate datasets, which is useful for supervised learning models.

- **Exploratory Data Analysis (EDA)**: Jupyter notebooks and integrated Python/R environments in Machine Learning enable thorough EDA to understand data distributions, identify patterns, and detect anomalies.

#### Modeling

In this stage, data scientists build and train machine learning models to address business problems.

- **Automated machine learning**: Selects the best algorithms automatically and tunes hyperparameters that speed up the model development process.

- **Custom modeling**: Supports custom model development by using popular frameworks like TensorFlow, PyTorch, and scikit-learn.

- **Experimentation and versioning**: Supports running multiple experiments in parallel, tracking results, and versioning models, which make it easier to compare and select the best model.

- **Hyperparameter tuning**: Optimizes model performance with built-in support for automated hyperparameter tuning.

#### Deployment

In this stage, after you develop and validate your model, Machine Learning deploys it for use in production environments.

- **Model deployment**: Provides various deployment options, including Azure Kubernetes Service (AKS) and edge devices, which enable flexible deployment strategies.

- **Endpoint management**: Provides tools for managing endpoints for real-time and batch predictions and helps with scalable and reliable model serving.

- **Continuous integration and continuous deployment (CI/CD)**: Integrates with Azure DevOps, which enables CI/CD for machine learning models, to build repeatable transitions from development to production.

#### Customer acceptance

In this final stage, your focus is on using Machine Learning to make the deployed model meet the business requirements and deliver value.

- **Model monitoring**: Provides comprehensive monitoring capabilities to track model performance, detect drift, and keep models accurate and relevant over time.

- **Feedback loops**: Supports implementing feedback loops where you use and review predictions to retrain models and continuously improve model accuracy and relevance.

- **Reporting and visualization**: Integrates with notebooks, Power BI, and other visualization tools to create dashboards and reports and present model results and insights to stakeholders.

- **Security and compliance**: Helps keep models and data compliant with regulatory requirements and provides tools for managing your data privacy and security.

### Understand the foundations of data transfer and data storage

Effective data transfer and storage are critical foundations for securely managing large volumes of data.

- **Data management**: Helps you manage large volumes of data in the most effective, compliant, and efficient way.

- **Accessibility**: Helps make data easily accessible to team members and analytical tools, which is essential for collaboration and real-time processing.

- **Compliance and security**: Helps data handling comply with legal and regulatory requirements and protects sensitive data.

#### Integrate data transfer and data storage within the TDSP

Azure has many resources that you can use for data transfer and data storage. The following list provides recommended resources for Azure architectures.

[Azure data transfer options](/azure/architecture/data-guide/scenarios/data-transfer): Includes various methods and tools for moving data to and from Azure efficiently, which accommodates different data needs and data sizes.

- [Azure Data Box](/azure/databox/): Transfers large-scale, bulk data to Azure by using a physical device without relying on the internet. It securely transfers terabytes of data where network bandwidth is limited.

- [Azure Import/Export service](/azure/import-export/): Supports transferring large amounts of data to Azure by shipping hard drives directly to Azure datacenters. This service is useful for initial data migrations where uploading by way of a network is impractical.

- [Azure Data Factory](/azure/data-factory/): Automates and handles data transfer. Data Factory is a cloud-based data integration service that orchestrates and automates data movement and transformation. It enables complex ETL (extract, transform, load) processes and integrates data from various sources into Azure for analytics and machine learning tasks.

- [Network transfer](/azure/expressroute/): Includes high-speed, internet-based transfers by using Azure ExpressRoute. Network transfer provides a private connection between on-premises infrastructure and Azure that helps to transfer data securely and quickly.

[Azure Database Migration Service](/azure/dms/dms-overview): Handles migration of databases to Azure to minimize downtime and support data integrity. Database Migration Service is a fully managed service designed to enable seamless migrations from multiple database sources to Azure data platforms with minimal downtime (or online migrations). It provides the following benefits:

- **Automated migration**: Simplifies the migration process by providing automated workflows for moving on-premises databases to SQL Database, Azure Database for MySQL, and Azure Database for PostgreSQL.

- **Continuous replication**: Supports continuous data replication, which enables minimal downtime and keeps data up-to-date during the migration process.

- **Compatibility**: Supports compatibility checks and recommends optimizations for the target Azure environment to make the transition seamless and efficient.

- **Assessment tools**: Provides tools for assessing the readiness of databases for migration to identify potential problems and offer recommendations to resolve them.

[Azure Storage](/azure/storage): Provides scalable, secure, and durable storage solutions tailored for different types of data and use cases. The following storage types are supported:

- [Blob Storage](/azure/storage/blobs/): Stores unstructured data such as documents, images, videos, and backups. It's ideal for data scientists who need to store large datasets for machine learning models.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction): Handles big data analytics. Data Lake Storage provides hierarchical namespace and compatibility with Hadoop, which makes it suitable for large-scale data analytics projects.

- [Azure Table storage](/azure/storage/tables/): Stores NoSQL key-values for semi-structured data and is suitable for applications that require a schema-less design.

- [Azure Files storage](/azure/storage/files/): Manages file shares in the cloud that you access by way of standard SMB protocol, which is useful for shared storage needs.

- [Azure Queue Storage](/azure/storage/queues/): Provides messaging between application components, which is useful for decoupling and scaling services.

### Provide data source documentation

- **Data transparency**: Documentation on data sources provides transparency about where data comes from, its quality, and its limitations.

- **Reproducibility**: Proper documentation helps other team members or stakeholders understand and reproduce the data science process.

- **Data integration**: Data integration means effectively integrating various data sources by providing a clear understanding of the data's origin and structure.

#### Integrate data source documentation within the TDSP

Azure has many resources that you can use for data source documentation, including notebooks. The following list provides recommended resources for Azure architectures.

[Azure Data Catalog](/azure/data-catalog) is an enterprise-wide metadata catalog that makes data asset discovery straightforward. It helps document data sources and their characteristics and provides the following benefits:

- **Metadata management**: Enables users to register data sources and add metadata that includes descriptions, tags, and annotations.

- **Data source discovery**: Provides a searchable catalog for users to find and understand the data sources that are available within the organization.

- **Collaboration**: Enables users to share insights and documentation about data sources, which improves collaboration among team members.

- **Data source information**: Extracts and documents information about data sources automatically. Information it extracts includes schemas, tables, columns, and relationships.

[Azure Purview](/azure/purview) Provides a unified data governance service that helps manage and govern data across your organization. It provides the following functionality:

- **Data mapping and lineage**: Helps document the data flow and lineage across different systems, which provides a clear view of where data comes from and how it transforms.

- **Data catalog**: Provides a searchable data catalog enriched with metadata and data classifications, which is similar to Data Catalog in Azure.

- **Business glossary**: Helps create and maintain a business glossary to keep consistent terminology and foster understanding across the organization.

- **Insights and analytics**: Provides insights into data usage and helps identify data quality problems, which improve the documentation process.

### Use tools for analytics processing

- **Efficiency**: The right tools for analytics processing enhance the efficiency and speed of data analysis.

- **Capabilities**: Different tools offer various capabilities, such as data visualization, statistical analysis, and machine learning, which are essential for comprehensive data science.

- **Productivity**: Specialized tools can significantly improve productivity for data scientists by automating repetitive tasks and providing advanced analytical functions.

#### Integrate analytics processing within the TDSP

Azure has many services you can use for analytics processing, with Machine Learning as the primary recommended service. The following list provides recommended services for Azure architectures that require features beyond Machine Learning.

[**Azure Synapse Analytics**](/azure/synapse-analytics/overview-what-is) Enables you to process massive volumes of relational data and nonrelational data. It's an integrated analytics service that accelerates time to insight across data warehouses and big data systems. Azure Synapse Analytics provides the following functionality:

- **Data integration**: Integrates data from various sources that enables seamless data ingestion and data processing.

- **SQL Data Warehouse**: Provides enterprise data warehousing capabilities with high-performance querying.

- **Apache Spark**: Provides Spark pools for big data processing that supports large-scale data analytics and machine learning.

- **Synapse Studio**: Enables data scientists to collaboratively build end-to-end analytics solutions. Synapse Studio is an integrated development environment (IDE).

[**Azure Databricks**](/azure/databricks/introduction/) is an Apache Spark-based analytics platform optimized for Azure that provides the following features:

- **Collaborative notebooks**: Supports collaborative workspaces where data scientists can write code, run experiments, and share results.

- **Scalable compute**: Scales compute resources automatically based on workload demands and optimizes cost and performance.

- **Machine learning**: Provides built-in libraries for machine learning, including MLlib, TensorFlow, and Keras, to streamline model development and training.

[Data Factory](/azure/data-factory/introduction): Orchestrates data movement and transformation by way of its cloud-based data integration service. Data Factory supports the following functionality:

- **ETL pipelines**: Enables you to create ETL (extract, transform, load) pipelines to process and prepare data for analysis.

- **Data flow**: Provides visual data flow authoring to design and run data transformation processes without writing code.

- **Integration**: Connects to a wide range of data sources, including on-premises and cloud-based data stores. This function provides comprehensive data integration.

[Azure Stream Analytics](/azure/stream-analytics/stream-analytics-introduction) Processes fast-moving data streams. Stream Analytics is a real-time analytics service that provides the following features:

- **Stream processing**: Processes data from various sources such as IoT devices, sensors, and applications in real-time.

- **SQL-based querying**: Uses a familiar SQL-based language for defining stream processing logic to make it accessible for data scientists.

- **Integration**: Integrates with other Azure services like Event Hubs and IoT Hub for seamless data ingestion and processing.

### Summary

This sequential list helps you comprehensively prepare to use the TDSP:

1. Establish a clear understanding of the project requirements and scope.

1. Adopt a structured and collaborative approach to project execution.

1. Use advanced tools and services for machine learning and analytics.

1. Ensure efficient and secure data management.

1. Maintain transparency and reproducibility through documentation.

1. Use appropriate tools to enhance the efficiency and effectiveness of data processing.

Preparation is critical for delivering successful data science projects that meet business objectives and adhere to best practices.

## Training paths on Microsoft Learn

Whether you're just starting a career, or you're an experienced professional, our self-directed approach helps you arrive at your goals faster, with more confidence and at your own pace. Develop skills through interactive modules and paths or learn from an instructor. Learn and grow your way.

Microsoft Learn organizes its training content into three skill levels: beginner, intermediate, and advanced. Understanding these distinctions is essential for selecting the appropriate learning paths to match your skill level and career goals.

### Beginner

- **Target audience**: Individuals who are new to the technology or concepts being covered.
- **Content**: Basic introductions to the concepts, fundamental skills, and initial steps required to get started. It typically covers core principles and foundational knowledge.

**Purpose:**

- Build a solid foundation in a new area
- Help learners understand basic concepts and terminologies
- Prepare learners for more complex articles

#### Beginner learning paths

- [Explore Copilot foundations](/training/paths/copilot-foundations/).
- [Deploy and consume models with Machine Learning](/training/paths/deploy-consume-models-azure-machine-learning/).
- [Design a machine learning solution](/training/paths/design-machine-learning-solution/).
- [Experiment with Machine Learning](/training/paths/automate-machine-learning-model-selection-azure-machine-learning/).
- [Explore and configure the Machine Learning workspace](/training/paths/explore-azure-machine-learning-workspace/).
- [Implement a data science and machine learning solution for AI in Microsoft Fabric](/training/paths/implement-data-science-machine-learning-fabric/).
- [Manage and review models in Machine Learning](/training/paths/manage-review-models-azure-machine-learning/).
- [Optimize model training with Machine Learning](/training/paths/use-azure-machine-learning-pipelines-for-automation/).
- [Predict rocket launch delays with Machine Learning](/training/paths/machine-learning-predict-launch-delay-nasa/).
- [Train and manage a machine learning model with Machine Learning](/training/paths/train-deploy-machine-learning-model/).
- [Train models with scripts in Machine Learning](/training/paths/train-models-scripts-azure-machine-learning/).
- [Understand data science for Machine Learning](/training/paths/understand-machine-learning/).
- [Use notebooks for experimentation in Machine Learning](/training/paths/use-notebooks-for-experimentation-azure-machine-learning/).
- [Work with compute in Machine Learning](/training/paths/work-compute-azure-machine-learning/).
- [Work with data in Machine Learning](/training/paths/work-data-azure-machine-learning/).

### Intermediate

- **Target audience**: Individuals who have a basic understanding of the technology and are looking to deepen their knowledge.
- **Content**: More detailed and practical skills, including hands-on exercises and real-world scenarios. It requires a deeper dive into the subject matter.

**Purpose:**

- Bridge the gap between basic understanding and advanced proficiency
- Enable learners to handle more complex tasks and scenarios
- Prepare learners for certification exams or specialized roles

#### Intermediate learning paths

- [Create custom copilots with Azure AI Studio](/training/paths/create-custom-copilots-ai-studio/).
- [Create machine learning models](/training/paths/create-machine-learn-models/).
- [Develop custom object detection models with NVIDIA and Machine Learning](/training/paths/develop-custom-object-detection-models-with-nvidia-and-azure-machine-learning/).
- [Build end-to-end machine learning operations (MLOps) with Machine Learning](/training/paths/build-first-machine-operations-workflow/).
- [Implement a Machine Learning solution with Azure Databricks](/training/paths/build-operate-machine-learning-solutions-azure-databricks/).
- [Train models in Machine Learning with the CLI (v2)](/training/paths/train-models-azure-machine-learning-cli-v2/).
- [Work with generative AI models in Machine Learning](/training/paths/work-with-generative-models-azure-machine-learning/).

### Advanced

- **Target audience**: Experienced professionals who are looking to perfect their skills and tackle complex, high-level tasks.
- **Content**: In-depth technical training, advanced techniques, and comprehensive coverage of specialized subjects. It often includes expert-level problem-solving and optimization strategies.

**Purpose**:

- Provide expertise in a specific area
- Prepare learners for expert-level certifications and advanced career roles
- Enable learners to lead projects and innovate within their field

#### Expert learning path

- [Train compute-intensive models with Machine Learning](/training/paths/train-compute-intensive-models-azure-machine-learning/)

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
