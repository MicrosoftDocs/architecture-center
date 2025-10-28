---
title: Data and AI
description: Compare Azure data and AI services to corresponding AWS services. Explore the differences between services and tools.
author: johnkoukgit
ms.author: johnkoukaras
ms.date: 11/13/2024
ms.topic: conceptual
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
---

# Data and AI

This article compares the core Azure data and AI services to the corresponding Amazon Web Services (AWS) solutions.

For comparison of other Azure and AWS services, see [Azure for AWS professionals](./index.md).

## Data governance, management, and platforms

Both Microsoft Purview and the combination of AWS services described in the following table provide comprehensive data governance solutions. Use these solutions to manage, discover, classify, and secure your data assets.

| Microsoft service  | AWS services   | Description      |
| ------- |--- |--|
| [Microsoft Purview](https://azure.microsoft.com/services/purview/) | [AWS Glue Data Catalog](https://aws.amazon.com/glue/), [AWS Lake Formation](https://aws.amazon.com/lake-formation/), [Amazon Macie](https://aws.amazon.com/macie/), [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/), [AWS Config](https://aws.amazon.com/config/) | Both options provide data governance, cataloging, and compliance features. Microsoft Purview is a unified data governance solution that you can use to discover, classify, and manage data across on-premises, multicloud, and software as a service (SaaS) environments. It also provides data lineage and compliance capabilities. AWS provides similar functionalities with multiple services: [AWS Glue Data Catalog](https://aws.amazon.com/glue/) for metadata management, [AWS Lake Formation](https://aws.amazon.com/lake-formation/) for data lake creation and governance, [Amazon Macie](https://aws.amazon.com/macie/) for data classification and protection, [AWS IAM](https://aws.amazon.com/iam/) for access control, and [AWS Config](https://aws.amazon.com/config/) for configuration management and compliance tracking. |

## All-in-one platform vs. AWS services

Microsoft Fabric provides an all-in-one platform that unifies the data and AI services required for modern analytics solutions. It moves data efficiently between services, provides unified governance and security, and simplifies pricing models. This approach contrasts with the AWS approach, where you often use separate services and must invest more effort in integration. Fabric provides integration across these functions within the Azure ecosystem.

Both Fabric and AWS provide capabilities for data integration, processing, analytics, machine learning, and business intelligence.

| Fabric | AWS service | Description |
|  ------  |  --| -- |
| [Data integration with Azure Data Factory](/fabric/data-factory/) | [AWS Glue](https://aws.amazon.com/glue/) | AWS Glue provides capabilities to build data and analytics solutions. This approach provides flexibility but requires more effort to integrate each service into an end-to-end solution. Fabric combines capabilities within a single platform to simplify workflows, collaboration, and management. |

### Detailed comparison of Fabric components and AWS services

The following table compares key Fabric components and their corresponding AWS services. It helps architects and decision-makers understand how the Fabric data platform aligns or diverges from AWS offerings across data engineering, analytics, governance, and AI workloads.

| Microsoft service  | AWS services|
|---- |------|
| [Data integration with Data Factory](/fabric/data-factory/)             | [AWS Glue](https://aws.amazon.com/glue/) |
| [Data engineering with Apache Spark](/fabric/data-engineering/)       | [Amazon EMR](https://aws.amazon.com/emr/), [AWS Glue interactive sessions](https://docs.aws.amazon.com/glue/latest/dg/interactive-sessions.html)  |
| [Data warehousing with Synapse Data Warehouse](/fabric/data-warehouse/) | [Amazon Redshift](https://aws.amazon.com/redshift/)    |
| [Data Science (Azure Machine Learning integration)](/fabric/data-science/)      | [Amazon SageMaker](https://aws.amazon.com/sagemaker/)     |
| [Real-time analytics (KQL database)](/fabric/real-time-analytics/)   | [Amazon Kinesis](https://aws.amazon.com/kinesis/), [Amazon Managed Service for Apache Flink](https://aws.amazon.com/kinesis/data-analytics/)      |
| [Power BI for business intelligence](https://powerbi.microsoft.com/)          | [Amazon QuickSight](https://aws.amazon.com/quicksight/)       |
| [OneLake unified data lake storage](/fabric/onelake/)       | [Amazon S3](https://aws.amazon.com/s3/)     |
| [Data governance (Microsoft Purview integration)](https://azure.microsoft.com/services/purview/)    | [AWS Lake Formation](https://aws.amazon.com/lake-formation/), [AWS Glue Data Catalog](https://aws.amazon.com/glue/), [Amazon Macie](https://aws.amazon.com/macie/) |
| [Generative AI (Azure OpenAI in Foundry Models)](https://azure.microsoft.com/products/ai-services/openai-service)        | [Amazon Bedrock](https://aws.amazon.com/bedrock/), [Amazon SageMaker JumpStart](https://aws.amazon.com/sagemaker/jumpstart/)         |

## Data integration and ETL tools

Data integration and extract, transform, and load (ETL) tools help extract, transform, and load data from multiple sources into a unified system for analysis.

| Microsoft service    | AWS service    | Analysis    |
| --------  |  ----  | ----------- |
| [Azure Data Factory](https://azure.microsoft.com/services/data-factory/), [Azure Data Factory in Fabric](/fabric/data-factory/)   | [AWS Glue](https://aws.amazon.com/glue/)    | The Data Factory service, the Azure Data Factory feature in Fabric, and AWS Glue are managed ETL services that facilitate data integration across various sources. |
| [Apache Airflow Jobs in Fabric](/fabric/data-factory/apache-airflow-jobs-concepts)   | [Amazon Managed Workflows for Apache Airflow (MWAA)](https://aws.amazon.com/managed-workflows-for-apache-airflow/) | Apache Airflow provides managed workflow orchestration for complex data pipelines. In Fabric, the Apache Airflow job feature serves as the next generation of the Data Factory Workflow Orchestration Manager. You can use this feature to create and manage Apache Airflow jobs and run Directed Acyclic Graphs (DAGs). As part of Azure Data Factory in Fabric, the Airflow job feature provides data integration, preparation, and transformation from data sources like databases, data warehouses, lakehouses, and real-time data. AWS MWAA is a managed Airflow solution. |
| [Fabric Migration Assistant for Data Warehouse](/fabric/data-warehouse/migration-assistant) | [AWS Database Migration Service (DMS)](https://aws.amazon.com/dms/)   | These services help you migrate databases from AWS to Azure. The Fabric Migration Assistant is a built-in tool in Fabric that guides you through migrating data and metadata from source databases in AWS to Fabric Data Warehouse. It converts schemas, uses AI to resolve migration problems, and supports migration from SQL-based sources. AWS DMS focuses on migrations within the AWS environment and provides ongoing replication features for hybrid architectures. |
| [Azure Database Migration Service](https://azure.microsoft.com/services/database-migration/) | [AWS DMS](https://aws.amazon.com/dms/)   | These services help you migrate databases to the cloud with minimal downtime. The Azure service focuses on migrating to Azure databases and includes assessment and recommendation tools. AWS DMS focuses on migrations within the AWS environment and provides ongoing replication features for hybrid architectures. |
| [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/)  | [Amazon AppFlow](https://aws.amazon.com/appflow/)  | These services enable automated data flows between cloud applications and services without requiring code. Logic Apps provides integration capabilities through many connectors and a visual designer. AppFlow focuses on secure data transfer between specific SaaS applications and AWS services and provides built-in data transformation features.   |
| [Data Factory](https://azure.microsoft.com/services/data-factory/) with [Logic Apps](https://azure.microsoft.com/services/logic-apps/) | [AWS Step Functions](https://aws.amazon.com/step-functions/)   | These services provide workflow orchestration for coordinating distributed applications and microservices. Logic Apps supports both data integration and enterprise workflow automation. Step Functions orchestrates AWS services and microservices in serverless applications.   |

## Data warehousing

These solutions store and manage large volumes of structured data optimized for querying and reporting.

| Microsoft service     | AWS service      | Analysis        |
| --------- | ------  |  --- |
| [Fabric Data Warehouse](/fabric/data-warehouse/)  | [Amazon Redshift](https://aws.amazon.com/redshift/)   | Fabric Data Warehouse and Amazon Redshift are cloud-based, fully managed and petabyte-scale data warehouses designed for high-performance analytics at scale. Fabric Data Warehouse is integrated with Microsoft Fabric, offering a unified platform that combines storage, analytics, governance, and AI. Redshift uses the AWS ecosystem and focuses on data warehousing. Both support massive parallel processing. Fabric has a lake-first architecture and deep integration across Microsoft's data and AI services. |
| [Fabric OneLake Shortcuts](/fabric/onelake/onelake-shortcuts), [Direct Lake in Power BI](/fabric/fundamentals/direct-lake-overview) and [Pipeline connectors in Data Factory](/fabric/data-factory/connector-overview) | [Amazon Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html)  | While Amazon Redshift Spectrum enables querying external data in S3, Microsoft Fabric offers a lake-first approach. With OneLake shortcuts, data from multiple sources can be virtualized into a single logical lake without movement. Direct Lake mode in Power BI delivers instant analytics on open Delta/Parquet files in OneLake without import. Fabric Data Factory pipelines provide native connectors to ingest, transform, or orchestrate data flows. |
| [Fabric OneLake](/fabric/onelake/onelake-overview), [Microsoft Purview in Fabric](/fabric/governance/microsoft-purview-fabric) and [Fabric Permission Model](/fabric/security/permission-model/) | [AWS Lake Formation](https://aws.amazon.com/lake-formation/)    | Amazon Lake Formation provides governance and access controls on top of S3-based data lakes. In contrast, Microsoft Fabric delivers these capabilities through OneLake combined with Purview for cataloging, lineage, and data governance. You use RBAC (Role-Based Access Control) and fine-grained security to provide access across workspaces, tables and columns. |
| [Fabric SQL Database](/fabric/database/sql/overview/), [Amazon Redshift Connector in Dataflow Gen2](/fabric/data-factory/connector-amazon-redshift), [Fabric Data Pipelines](/fabric/data-factory/create-first-pipeline-with-sample-data), and [OneLake Shortcuts](/fabric/onelake/onelake-shortcuts) | [Amazon RDS](https://aws.amazon.com/rds/) with [Redshift Federated Query](https://docs.aws.amazon.com/redshift/latest/dg/federated-overview.html) | Amazon RDS with Redshift Federated Query enables Redshift to run SQL queries directly on live RDS data, offering real-time access across operational and analytical stores. Fabric SQL Database introduces a SaaS-native SQL engine with autoscaling, built-in governance and integration into the Fabric platform. Fabric Data Pipelines support ingestion from Amazon RDS and Redshift into Lakehouses or SQL databases. OneLake Shortcuts virtualize external data (for example, ADLS Gen2, Amazon S3) into Fabric without duplication. |
| [Azure SQL Database](https://azure.microsoft.com/services/sql-database/) | [Amazon RDS](https://aws.amazon.com/rds/) with [Redshift Federated Query](https://docs.aws.amazon.com/redshift/latest/dg/federated-overview.html) | These services support querying across operational databases and data warehouses. Azure Synapse Analytics provides a unified, built-in analytics experience. AWS requires you to combine RDS and Redshift for similar cross-service querying capabilities. |
| [SQL Database in Fabric](/fabric/database/sql/overview/)| [Amazon Aurora](https://aws.amazon.com/rds/aurora/) with Redshift integration | Amazon Aurora handles operational data and Redshift performs large-scale analytics through federated queries and batch ingestion. In Microsoft Fabric, the SQL Database offers a fully managed, auto-scaling relational engine natively integrated with OneLake and Power BI, ideal for unified analytics and governance. |
| [Azure SQL Database Serverless](/azure/azure-sql/database/serverless-tier-overview) | [Amazon Aurora](https://aws.amazon.com/rds/aurora/) with Redshift integration | These services are fully managed, cloud-native relational databases that separate compute from storage, automatically scale resources based on demand, and ensure high availability. Both use SQL-based engines and can extend into cost-efficient solutions for transactional and analytical workloads. |

Amazon Aurora handles operational data and Redshift performs large-scale analytics through federated queries and batch ingestion. Azure SQL Database Serverless automatically scales compute based on demand, pausing during inactivity to optimize cost while providing the full SQL Server engine.

## Data lake solutions

These platforms store vast amounts of raw unstructured and structured data in its native format for future processing.

| Microsoft service | AWS service   | Analysis      |
| ----- | ------------- | -------------- |
| [Fabric OneLake](/fabric/onelake/onelake-overview), [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) | [Amazon S3](https://aws.amazon.com/s3/) | Azure Data Lake Storage (ADLS) and Amazon S3 are both scalable object storage solutions designed for big data analytics, offering support for formats like Parquet, CSV, and JSON. ADLS is optimized for Azure-native tools, while S3 integrates with AWS services. Microsoft Fabric OneLake unifies structured and unstructured data across clouds into a single, governed lake. With OneLake Shortcuts, Fabric can virtualize data from Amazon S3, ADLS and Google Cloud without duplication, enabling access and analytics. OneLake supports multicloud flexibility, zero-ETL integration, and native support for Delta Lake. |
| [Fabric OneLake](/fabric/onelake/onelake-overview) | [AWS Lake Formation](https://aws.amazon.com/lake-formation/) | AWS Lake Formation manages data lakes within the AWS ecosystem. Microsoft Fabric OneLake offers a SaaS-native data lake that supports all Fabric workloads: Lakehouse, Warehouse, Real-Time Intelligence, and Power BI. OneLake requires no extra setup and brings built-in governance through Microsoft Purview, with native support for Delta Lake and Shortcuts for multicloud virtualization (including Amazon S3). | 
| [Fabric Lakehouse](/fabric/data-engineering/lakehouse-overview/) | [Amazon Athena](https://aws.amazon.com/athena/)   | Amazon Athena is a serverless query engine that enables ad-hoc SQL analysis directly on data stored in Amazon S3. The Microsoft Fabric Lakehouse offers an integrated environment for both data engineering and analytics. It stores data in OneLake using the Delta Lake format, supports Spark, T-SQL, and Python. |
| [Microsoft Purview](https://azure.microsoft.com/services/purview/) | [AWS Glue Data Catalog](https://aws.amazon.com/glue/) | AWS Glue Data Catalog centralizes metadata for analytics and ML, primarily acting as a metadata store and schema registry, requiring other services for lineage, policy, and governance. Microsoft Purview, on the other hand, is a unified data governance service spanning Azure, Microsoft Fabric OneLake, on-premises and multicloud environments. It not only catalogs data in Fabric OneLake, ADLS and other sources, but also provides data classification, lineage visualization, policy management and glossary integration in its Unified Catalog. From a data lake perspective, Purview delivers a governance-first approach—connecting metadata, security, and compliance in one platform. |

## Big data analytics

These services process and analyze large and complex datasets to uncover patterns, insights, and trends. The following table provides direct comparisons of individual big data services. Microsoft Fabric is an all-in-one service for big data and analytics. It provides the following services and more.

| Microsoft service | AWS service   | Analysis      |
| ----- | ------------- | -------------- |
| [Fabric Data Engineering workloads](/fabric/data-engineering/data-engineering-overview/) powered by [Apache Spark](/fabric/data-engineering/runtime/) | [Amazon EMR](https://aws.amazon.com/emr/) | Amazon EMR is a managed big data service for running frameworks like Spark, Hadoop, and Hive, with cluster provisioning and tuning requirements. In Microsoft Fabric, Data Engineering workload, powered by Apache Spark, removes the need to manage clusters, providing a serverless, integrated, and governed experience within the Fabric ecosystem. |
| [Azure Databricks](/azure/databricks/introduction/) | [Amazon EMR](https://aws.amazon.com/emr/) | These services enable big data processing via Apache Spark in a managed environment. Amazon EMR enables you to run Apache Spark clusters with flexible configuration and scaling options. Azure Databricks provides an optimized Apache Spark platform with collaborative notebooks and integrated workflows.  |
| [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) | [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | These services provide real-time data streaming and analytics for processing and analyzing high-volume data streams.    |
| [Fabric Data Engineering workloads](/fabric/data-engineering/data-engineering-overview/) powered by [Apache Spark](/fabric/data-engineering/runtime/) | [AWS Glue with AWS Glue Studio](https://aws.amazon.com/glue/) | AWS Glue Studio combined with Kinesis provides data integration and real-time streaming pipelines, but it requires managing data movement between services. Microsoft Fabric Data Engineering workloads, powered by Apache Spark, bring these capabilities directly into the Fabric platform: batch and streaming transformations, orchestration, and governance are integrated with OneLake, Purview, and Power BI. Fabric delivers a single experience for data integration and engineering, without management of separate services for ETL, streaming, and analytics. |
| [Azure Databricks](/azure/databricks/introduction/) and [Azure Data Factory](/azure/data-factory/introduction/) | [AWS Glue with AWS Glue Studio](https://aws.amazon.com/glue/) | Both services provide big data processing capabilities with integrated data transformation and analytics. |

## Business intelligence and reporting

These services provide data visualization, reporting, and dashboards to help businesses make informed decisions.

| Microsoft service         | AWS service   | Analysis      |
| ----- | ------------- | -------------- |
| [Power BI](https://powerbi.microsoft.com/)  | [Amazon QuickSight](https://aws.amazon.com/quicksight/)     |  Power BI and Amazon QuickSight provide business analytics tools for data visualization and interactive dashboards.|
| [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana/) | [Amazon Managed Grafana](https://aws.amazon.com/grafana/)   | These services provide managed Grafana, which enables you to visualize metrics, logs, and traces across multiple data sources. |
| [External data sharing in Microsoft Fabric](/fabric/governance/external-data-sharing-overview#supported-fabric-item-types) and [OneLake Shortcuts](/fabric/onelake/onelake-shortcuts) | [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | AWS Data Exchange provides a marketplace where organizations can subscribe to and consume third-party datasets, handling licensing and secure delivery. In Microsoft Fabric, external collaboration is available through OneLake shortcuts and cross-tenant sharing, where external data becomes available across Spark, SQL, KQL, and Power BI. |
| [Azure Data Share](https://azure.microsoft.com/services/data-share/) | [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | These services facilitate the secure sharing and exchange of data between organizations. AWS Data Exchange provides a marketplace model. Azure Data Share focuses on cross-tenant data sharing. |
| [Fabric KQL database](/fabric/real-time-intelligence/create-database/) with [Power BI](https://powerbi.microsoft.com/) | [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) with Kibana | Amazon OpenSearch Service with Kibana provides a managed search and analytics platform for indexing, querying, and visualizing large datasets, commonly used for log analytics and observability. Microsoft Fabric delivers experience through its KQL database for real-time data exploration combined with Power BI for interactive reporting. |
| [Azure AI Search](/azure/search/search-what-is-azure-search/) with [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/) with dashboards | [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) with Kibana | These services provide real-time data exploration and interactive analytics over large volumes of data. Amazon OpenSearch uses Kibana for search and visualization. Azure offers Azure AI Search for intelligent full-text search and Azure Data Explorer uses Kusto for high-performance, real-time analytics, paired with interactive dashboards for visualization. |

## Real-time data processing

These systems ingest and analyze data as it's generated to provide immediate insights and responses.

| Microsoft service     | AWS service    | Analysis     |
| ------- | ---  |  ---- |
| [Fabric Real-Time hub](/fabric/real-time-hub/real-time-hub-overview/), [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities/) with [Fabric KQL database](/fabric/real-time-intelligence/create-database/) | [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | Amazon Kinesis enables real-time data streaming, ingestion and processing across services like S3, Redshift, and Lambda. Microsoft Fabric offers streaming architecture with the Real-Time hub, which supports ingestion from multiple sources, including Amazon Kinesis, Kafka, and Azure Event Hubs, and Google Pub/Sub, while Fabric Eventstream enables stream routing, transformation and alerting. |
| [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) | [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | These services enable you to process and analyze data from IoT devices in real time. Amazon Kinesis provides streaming ingestion and processing capabilities. Azure provides modular services: Event Hubs handles data ingestion, and Stream Analytics processes the data. | 
| [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview/) with Kafka endpoints | [Amazon Managed Streaming for Apache Kafka (MSK)](https://aws.amazon.com/msk/) | Amazon Managed Streaming for Apache Kafka (MSK) is AWS's fully managed Kafka service. In Microsoft Fabric, Eventstream with Kafka endpoints lets you publish/consume via the Kafka protocol, and also ingest directly from Amazon MSK into Fabric's Real‑Time hub for downstream processing and analytics (for example, Eventhouse with Power BI). Azure offers both a fully managed Kafka‑compatible ingestion plane (Event Hubs) and a managed Kafka cluster (HDInsight), while Fabric provides a Kafka‑integrated, end‑to‑end real‑time analytics hub. |
| [Azure Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-apache-kafka-overview/) | [Amazon Managed Streaming for Apache Kafka (MSK)](https://aws.amazon.com/msk/) | These services provide managed Apache Kafka clusters for creating real-time streaming data pipelines and applications. Azure Event Hubs for Apache Kafka exposes a Kafka‑compatible endpoint and existing clients can connect with minimal changes. It also supports Kafka Streams in Premium/Dedicated tiers. |
| [Fabric Notebooks](/fabric/data-engineering/author-execute-notebook/) with [Fabric Data Pipelines](/fabric/data-factory/create-first-pipeline-with-sample-data) for serverless data processing | [AWS Lambda](https://aws.amazon.com/lambda/) | AWS Lambda is a serverless, event‑driven compute for running code without managing servers. For analytics‑focused, serverless-style processing in Microsoft Fabric, you can use Fabric notebooks with Data Factory pipelines: notebooks run managed Apache Spark jobs for data ingest/cleanup/transform, and pipelines orchestrate and schedule those notebooks as part of end‑to‑end data workflows, providing on‑demand compute and no cluster management inside Fabric. |
| [Azure Functions](https://azure.microsoft.com/services/functions/) (with APIM for API triggers) | [AWS Lambda](https://aws.amazon.com/lambda/) | These serverless compute platforms run code in response to events and automatically manage the underlying compute resources. Azure Functions delivers the same event‑driven, autoscaling execution model and is commonly paired with API Management and other Azure triggers. Microsoft also provides a [migration guide from Lambda to Functions](/azure/azure-functions/migration/migrate-aws-lambda-to-azure-functions/) to streamline parity and code moves. |
| [Fabric Mirroring(Cosmos DB)](/fabric/mirroring/azure-cosmos-db/) with [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities/) | [Amazon DynamoDB Streams](https://aws.amazon.com/pm/dynamodb/)  | Amazon DynamoDB Streams provides a real-time feed of item-level changes in DynamoDB tables, enabling event-driven processing and downstream analytics. In Microsoft Fabric, mirroring Cosmos DB into OneLake for analytics brings no ETL overhead, combined with Fabric Eventstream for real-time event routing and integration with Fabric's KQL database or Lakehouse. |
| [Azure Cosmos DB change feed](/azure/cosmos-db/change-feed) | [Amazon DynamoDB Streams](https://aws.amazon.com/pm/dynamodb/)  | These services enable real-time data processing by capturing and providing a stream of data modifications. |
| [Azure Cache for Redis with Redis streams](https://azure.microsoft.com/services/cache/)   | [Amazon ElastiCache with Redis streams](https://aws.amazon.com/elasticache/)   | These services provide managed Redis instances that support Redis streams for real-time data ingestion and processing.      |
| [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities/) with [Fabric KQL database](/fabric/real-time-intelligence/create-database/) | [Amazon IoT Analytics](https://aws.amazon.com/iot-analytics/)   | Amazon IoT Analytics is a managed service that collects, processes and analyzes IoT device data at scale. Fabric Eventstream ingests IoT telemetry and routes it to the Fabric KQL database for real-time querying and analytics. |
| [Azure IoT Hub with Azure Stream Analytics](https://azure.microsoft.com/services/iot-hub/) | [Amazon IoT Analytics](https://aws.amazon.com/iot-analytics/)   | These services enable you to process and analyze data from IoT devices in real time. Amazon IoT Analytics provides built-in data storage and analysis capabilities. Azure provides modular services: IoT Hub handles ingestion, and Stream Analytics processes the data. |

## Machine learning services

These tools and platforms enable the development, training, and deployment of machine learning models.
| Microsoft service | AWS service    | Analysis     |
| ------- | ---  |  ---- |
| [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Azure Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | [Amazon SageMaker](https://aws.amazon.com/sagemaker/) | Amazon SageMaker is AWS's fully managed platform for building, training, and deploying machine learning models at scale. Azure provides an equivalent through Azure Machine Learning, an end-to-end managed service that supports everything from data preparation and automated ML to model deployment and MLOps. The Fabric Data Science workload brings model development and enrichment, integrating with Azure Machine Learning for training, GPU acceleration and enterprise-grade deployment. |
| [Azure Data Science Virtual Machines](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines/) with [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) | [AWS Deep Learning AMIs](https://aws.amazon.com/machine-learning/amis/) | AWS Deep Learning AMIs provide prebuilt virtual machine images with popular deep learning frameworks, GPU drivers, and libraries to accelerate AI model development. Azure offers a similar experience through the Azure Data Science Virtual Machine (DSVM), which comes preconfigured with Python, R, Jupyter, and major deep learning frameworks like TensorFlow and PyTorch. Combined with Azure Machine Learning, DSVMs become part of a fully managed platform for training, deployment and MLOps. |
| [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Azure Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/autopilot/) | Amazon SageMaker Autopilot automates the machine learning lifecycle by handling data preprocessing, algorithm selection, and hyperparameter tuning with minimal manual effort. Microsoft Fabric's Data Science workload brings AutoML-driven model development, while integrating with Azure Machine Learning for training and operationalization. |
| [Automated Machine Learning (AutoML)](https://azure.microsoft.com/solutions/automated-machine-learning/)  | [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/autopilot/) | These services provide automated machine learning for building and training models. |
| [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Azure Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/)  | Amazon SageMaker Studio is AWS's integrated development environment for machine learning, providing a single web-based interface to build, train, and deploy models. Microsoft Fabric's Data Science workload brings collaborative notebooks and Spark-based environments into a unified analytics platform, integrating with Azure Machine Learning for training and deployment. |
| [Azure Machine Learning studio](https://azure.microsoft.com/services/machine-learning/) | [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/)  | These services provide integrated development environments for machine learning. Amazon SageMaker Studio provides a unified interface for all machine learning development steps, including debugging and profiling tools. |

## AI services

AI services provide prebuilt, customizable AI capabilities to applications, including vision, speech, language, and decision making.

| Azure service | AWS service     | Analysis   |
| ------  |  -------  |--|
| [Azure AI Vision](/azure/ai-services/computer-vision/overview/) with [Custom Vision](/azure/ai-services/custom-vision-service/overview/)  | [Amazon Rekognition](https://aws.amazon.com/rekognition/)               | Amazon Rekognition is AWS's computer vision service for image and video analysis, offering capabilities like object detection, facial recognition, and text extraction. Azure AI Vision delivers prebuilt models for image and video understanding. Azure Custom Vision allows you to train domain-specific models with your own data. |
| [Azure AI Speech (Text-to-Speech)](https://azure.microsoft.com/products/ai-services/ai-speech)  | [Amazon Polly](https://aws.amazon.com/polly/)    | Amazon Polly is AWS's text-to-speech service that converts text into lifelike speech using neural voices across multiple languages. Azure AI Speech (Text-to-Speech) provides high-quality neural voices, real-time streaming, and batch synthesis for applications such as voice assistants, IVR systems, and accessibility solutions. Azure AI Speech also supports custom neural voice creation, enabling organizations to build unique, brand-specific voices while maintaining enterprise-grade security and compliance. | 
| [Azure AI Speech (Speech-to-Text)](https://azure.microsoft.com/products/ai-services/ai-speech/)  | [Amazon Transcribe](https://aws.amazon.com/transcribe/)    | Amazon Transcribe provides speech-to-text with real-time transcription and custom vocabularies, commonly used for call analytics and captions. Azure AI Speech (Speech-to-Text) offers real-time and batch transcription, speaker diarization, and custom models for domain-specific accuracy. |
| [Azure AI Translator](https://azure.microsoft.com/products/ai-services/ai-translator) | [Amazon Translate](https://aws.amazon.com/translate/) | Amazon Translate is a neural machine translation service that delivers translations across multiple languages for websites, apps, and multilingual content. Azure AI Translator offers similar capabilities with real-time and batch translation in 100+ languages, plus features like transliteration, language detection, and custom glossaries for domain-specific accuracy. |
| [Azure AI Language](https://azure.microsoft.com/products/ai-services/ai-language)  | [Amazon Comprehend](https://aws.amazon.com/comprehend/)     | Amazon Comprehend is a Natural Language Processing (NLP) service that extracts insights from text, including sentiment, key phrases, and entities, useful for analyzing customer feedback and documents. Azure AI Language (Text Analytics) offers similar capabilities with features like sentiment analysis, key phrase extraction, named entity recognition, and custom text classification. |
| [Conversational Language Understanding (CLU) in AI Foundry](/azure/ai-services/language-service/conversational-language-understanding/overview) | [Amazon Lex](https://aws.amazon.com/lex/) | You can use these services to create conversational interfaces that leverage natural language understanding. Azure takes a modular approach, where Conversational Language Understanding (CLU) handles intent recognition and entity extraction, while other components manage dialogue and integration. In contrast, Amazon Lex offers an integrated solution for building conversational interfaces entirely within the AWS ecosystem. |
| [Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence/) | [Amazon Textract](https://aws.amazon.com/textract/) | Amazon Textract is a machine learning service that extracts text and data from scanned documents, including tables and forms, to automate document processing. Azure AI Document Intelligence offers similar functionality with OCR, prebuilt models for invoices, receipts and IDs, and the ability to train custom models for domain-specific forms. Azure AI Document Intelligence supports multi-language extraction and provides layout analysis for complex documents.  |
| [Azure AI Search](https://azure.microsoft.com/products/ai-services/ai-search/)      | [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) |  Amazon OpenSearch Service is a managed search and analytics engine based on Elasticsearch, commonly used for log analytics, full-text search, and real-time data exploration. Azure AI Search offers similar capabilities with built-in AI enrichment, hybrid search (keyword with vector), and integration with Azure services for security and compliance. It supports scenarios like semantic search and retrieval-augmented generation (RAG). |

## Generative AI services

These AI services create new content or data that resembles human-generated output, like text, images, or audio.

| Azure services    | AWS service     | Analysis   |
| --------  | ----  | ------  |
| [Azure AI Foundry](https://azure.microsoft.com/products/ai-foundry/) | [Amazon Bedrock](https://aws.amazon.com/bedrock/) | Amazon Bedrock and Azure AI Foundry provide foundation models for creating and deploying generative AI applications. |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Regina Hackenberg](https://www.linkedin.com/in/reginahackenberg/) | Senior Technical Specialist

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | Director, Partner Technology Strategist
- [Filipa Lobão](https://www.linkedin.com/in/filipalobao) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Fabric](/fabric/)
- [Microsoft Purview](/purview/purview)

## Related resources

- [Choose an Azure AI services technology](../data-guide/technology-choices/ai-services.md)
- [Compare Microsoft machine learning products and technologies](../ai-ml/guide/data-science-and-machine-learning.md)
