---
title: Data and AI
description: Compare Azure data and AI services with those of AWS. Explore the differences between services and tools.
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

This article compares the core Azure data and AI services to the corresponding Amazon Web Services (AWS) services.

For comparison of other AWS and Azure services, see [Azure for AWS professionals](./index.md).

## Data governance, management, and platforms

Both Microsoft Purview and the combination of AWS services described in the following table provide comprehensive data governance solutions. These solutions enable organizations to manage, discover, classify, and secure their data assets.

| Microsoft service  | AWS services   | Description      |
| ------- |--- |--|
| [Microsoft Purview](https://azure.microsoft.com/services/purview/) | [AWS Glue Data Catalog](https://aws.amazon.com/glue/), [AWS Lake Formation](https://aws.amazon.com/lake-formation/), [Amazon Macie](https://aws.amazon.com/macie/), [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/), [AWS Config](https://aws.amazon.com/config/) | Both options provide data governance, cataloging, and compliance features. Microsoft Purview is a unified data governance solution that allows organizations to discover, classify, and manage data across on-premises, multicloud, and SaaS environments. It also provides data lineage and compliance capabilities. AWS provides similar functionalities with multiple services: [AWS Glue Data Catalog](https://aws.amazon.com/glue/) for metadata management, [AWS Lake Formation](https://aws.amazon.com/lake-formation/) for data lake creation and governance, [Amazon Macie](https://aws.amazon.com/macie/) for data classification and protection, [AWS IAM](https://aws.amazon.com/iam/) for access control, and [AWS Config](https://aws.amazon.com/config/) for configuration management and compliance tracking. |

## All-in-one platform vs. AWS services

Microsoft Fabric provides an all-in-one platform that unifies the data and AI services required for modern analytics solutions. It streamlines the process of moving data between services, provides unified governance and security, and simplifies pricing models. This approach contrasts with the AWS approach, in which services are often used separately and require more integration effort. Fabric provides integration across these functions within the Azure ecosystem.

Both AWS and Fabric provide services for data integration, processing, analytics, machine learning, and business intelligence.

| AWS services | Fabric | Description          |
|  --| ------  |  -- |
| [AWS Glue](https://aws.amazon.com/glue/) | [Data integration with Azure Data Factory](/fabric/data-factory/) | AWS provides a service to build data and analytics solutions. This approach provides flexibility but requires more effort to integrate the services into an end-to-end solution. Fabric provides these capabilities within a single unified platform to simplify workflows, collaboration, and management. |

### Detailed comparison of AWS services with Fabric components

A comparison of key AWS services and their corresponding Microsoft Fabric components. It helps architects and decision-makers understand how Fabric's data platform aligns or diverges from AWS offerings across data engineering, analytics, governance, and AI workloads.

| AWS services| Microsoft service  |
|------|---- |
| [AWS Glue](https://aws.amazon.com/glue/) | [Data integration with Data Factory](/fabric/data-factory/)             |
| [Amazon EMR](https://aws.amazon.com/emr/), [AWS Glue interactive sessions](https://docs.aws.amazon.com/glue/latest/dg/interactive-sessions.html)  | [Data engineering with Spark](/fabric/data-engineering/)       |
| [Amazon Redshift](https://aws.amazon.com/redshift/)    | [Data warehousing  with Synapse Data Warehouse](/fabric/data-warehouse/) |
| [Amazon SageMaker](https://aws.amazon.com/sagemaker/)     | [Data science (Azure Machine Learning integration)](/fabric/data-science/)      |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/), [Amazon Managed Service for Apache Flink](https://aws.amazon.com/kinesis/data-analytics/)      | [Real-time analytics (KQL database)](/fabric/real-time-analytics/)   |
| [Amazon QuickSight](https://aws.amazon.com/quicksight/)       | [Power BI for business intelligence](https://powerbi.microsoft.com/)          |
| [Amazon S3](https://aws.amazon.com/s3/)     | [OneLake unified data lake storage](/fabric/onelake/)       |
| [AWS Lake Formation](https://aws.amazon.com/lake-formation/), [AWS Glue Data Catalog](https://aws.amazon.com/glue/), [Amazon Macie](https://aws.amazon.com/macie/) | [Data governance (Microsoft Purview integration)](https://azure.microsoft.com/services/purview/)    |
| [Amazon Bedrock](https://aws.amazon.com/bedrock/), [Amazon SageMaker JumpStart](https://aws.amazon.com/sagemaker/jumpstart/)         | [Generative AI (Azure OpenAI in Foundry Models)](https://azure.microsoft.com/products/ai-services/openai-service)        |

## Data integration and ETL tools

Data integration and extract, transform, load (ETL) tools help you extract, transform, load data from multiple sources into a unified system for analysis.

| AWS service    | Microsoft service    | Analysis    |
| ----  |  -------- |  ----------- |
| [AWS Glue](https://aws.amazon.com/glue/)    | [Azure Data Factory](https://azure.microsoft.com/services/data-factory/), [Data Factory in Fabric](/fabric/data-factory/)   | AWS Glue, Azure Data Factory, and Data Factory in Fabric are managed ETL services that facilitate data integration across various sources. |
| [Amazon Managed Workflows for Apache Airflow (MWAA)](https://aws.amazon.com/managed-workflows-for-apache-airflow/) | [Apache Airflow Jobs in Fabric](/fabric/data-factory/apache-airflow-jobs-concepts)   | Apache Airflow provides managed workflow orchestration for complex data pipelines. AWS MWAA is a managed Airflow solution. In Fabric, Apache Airflow job is the next generation of Azure Data Factory's Workflow Orchestration Manager. You use it to create and manage Apache Airflow jobs, so you can run Directed Acyclic Graphs (DAGs). As part of Microsoft Fabric's Data Factory, it provides data integration, preparation, and transformation from data sources like databases, data warehouses, Lakehouse, real-time data, and more. |
| [AWS Database Migration Service (DMS)](https://aws.amazon.com/dms/)   | [Fabric Migration Assistant for Data Warehouse](/fabric/data-warehouse/migration-assistant) | These services help you migrate databases from AWS to Azure. The Fabric Migration Assistant is a built-in tool in Fabric that guides users through migrating data and metadata from source databases in AWS to Fabric Data Warehouse. It converts schemas and uses AI to resolve migration issues and supports migrating from SQL-based sources. The AWS DMS focuses on migrations within the AWS environment and provides ongoing replication features for hybrid architectures. |
| [AWS Database Migration Service (DMS)](https://aws.amazon.com/dms/)   | [Azure Database Migration Service](https://azure.microsoft.com/services/database-migration/) | These services can help you migrate databases to the cloud with minimal downtime. The main difference is that the Azure service is optimized for migrating to Azure databases, providing assessment and recommendation tools, whereas AWS DMS focuses on migrations within the AWS environment. AWS DMS provides ongoing replication features for hybrid architectures. |
| [Amazon AppFlow](https://aws.amazon.com/appflow/)  | [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/)  | These services enable automated data flows between cloud applications and services without requiring code. Logic Apps provides extensive integration capabilities with a wide range of connectors and a visual designer. AppFlow focuses on secure data transfer between specific SaaS applications and AWS services and provides built-in data transformation features.   |
| [AWS Step Functions](https://aws.amazon.com/step-functions/)   | [Data Factory](https://azure.microsoft.com/services/data-factory/) with [Logic Apps](https://azure.microsoft.com/services/logic-apps/) | These services provide workflow orchestration for coordinating distributed applications and microservices. Step Functions is designed for orchestrating AWS services and microservices in serverless applications. Logic Apps is used for both data integration and enterprise workflow automation.   |

## Data warehousing

These solutions are designed to store and manage large volumes of structured data that's optimized for querying and reporting.

| AWS service      | Microsoft service     | Analysis        |
| ------ | --------- |  --- |
| [Amazon Redshift](https://aws.amazon.com/redshift/)   | [Fabric Data Warehouse](/fabric/data-warehouse/)  | Amazon Redshift and Microsoft Fabric Data Warehouse are cloud-based, fully managed and petabyte-scale data warehouses designed for high-performance analytics at scale. Fabric Data Warehouse is integrated with Microsoft Fabric, offering a unified platform that combines storage, analytics, governance, and AI. Redshift uses the AWS ecosystem and focuses on data warehousing. Both support massive parallel processing. Fabric has a lake-first architecture and deep integration across Microsoft's data and AI services. |
| [Amazon Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html)  | [Fabric OneLake Shortcuts](/fabric/onelake/onelake-shortcuts), [Direct Lake in Power BI](/fabric/fundamentals/direct-lake-overview) and [Pipeline connectors in Data Factory](/fabric/data-factory/connector-overview) | While Amazon Redshift Spectrum enables querying external data in S3, Microsoft Fabric offers a lake-first approach. With OneLake shortcuts, data from multiple sources can be virtualized into a single logical lake without movement. Direct Lake mode in Power BI delivers instant analytics on open Delta/Parquet files in OneLake without import. Fabric Data Factory pipelines provide native connectors to ingest, transform, or orchestrate data flows. |
| [AWS Lake Formation](https://aws.amazon.com/lake-formation/)    | [Fabric OneLake](/fabric/onelake/onelake-overview), [Microsoft Purview in Fabric](/fabric/governance/microsoft-purview-fabric) and [Fabric Permission Model](/fabric/security/permission-model/) | Amazon Lake Formation provides governance and access controls on top of S3-based data lakes. In contrast, Microsoft Fabric delivers these capabilities through OneLake combined with Purview for cataloging, lineage, and data governance. You use RBAC (Role-Based Access Control) and fine-grained security to provide access across workspaces, tables and columns. |
| [Amazon RDS](https://aws.amazon.com/rds/) with [Redshift Federated Query](https://docs.aws.amazon.com/redshift/latest/dg/federated-overview.html) | [Fabric SQL Database](/fabric/database/sql/overview/), [Amazon Redshift Connector in Dataflow Gen2](/fabric/data-factory/connector-amazon-redshift), [Fabric Data Pipelines](/fabric/data-factory/create-first-pipeline-with-sample-data), and [OneLake Shortcuts](/fabric/onelake/onelake-shortcuts) | Amazon RDS with Redshift Federated Query enables Redshift to run SQL queries directly on live RDS data, offering real-time access across operational and analytical stores. Fabric SQL Database introduces a SaaS-native SQL engine with autoscaling, built-in governance and integration into the Fabric platform. Fabric Data Pipelines support ingestion from Amazon RDS and Redshift into Lakehouses or SQL databases. OneLake Shortcuts virtualize external data (for example, ADLS Gen2, Amazon S3) into Fabric without duplication. |
| [Amazon RDS](https://aws.amazon.com/rds/) with [Redshift Federated Query](https://docs.aws.amazon.com/redshift/latest/dg/federated-overview.html) | [Azure SQL Database](https://azure.microsoft.com/services/sql-database/) | These services support querying across operational databases and data warehouses. Azure Synapse Analytics provides a unified, built-in analytics experience. AWS requires you to combine RDS and Redshift for similar cross-service querying capabilities. |
| [Amazon Aurora](https://aws.amazon.com/rds/aurora/) with Redshift integration | [SQL Database in Fabric](/fabric/database/sql/overview/)| Amazon Aurora handles operational data and Redshift performs large-scale analytics through federated queries and batch ingestion. In Microsoft Fabric, the SQL Database offers a fully managed, auto-scaling relational engine natively integrated with OneLake and Power BI, ideal for unified analytics and governance. |
| [Amazon Aurora](https://aws.amazon.com/rds/aurora/) with Redshift integration | [Azure SQL Database Serverless](/azure/azure-sql/database/serverless-tier-overview) | These services are fully managed, cloud-native relational databases that separate compute from storage, automatically scale resources based on demand, and ensure high availability. Both use SQL-based engines and can extend into cost-efficient solutions for transactional and analytical workloads. |

Amazon Aurora handles operational data and Redshift performs large-scale analytics through federated queries and batch ingestion. Azure SQL Database Serverless automatically scales compute based on demand, pausing during inactivity to optimize cost while providing the full SQL Server engine. |

## Data lake solutions

These platforms store vast amounts of raw unstructured and structured data in its native format for future processing.

| AWS service   | Microsoft service | Analysis      |
| ------------- | ----- | -------------- |
| [Amazon S3](https://aws.amazon.com/s3/) | [Fabric OneLake](/fabric/onelake/onelake-overview), [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) | Amazon S3 and Azure Data Lake Storage (ADLS) are both scalable object storage solutions designed for big data analytics, offering support for formats like Parquet, CSV, and JSON. S3 integrates with AWS services, while ADLS is optimized for Azure-native tools. Microsoft Fabric OneLake unifies structured and unstructured data across clouds into a single, governed lake. With OneLake Shortcuts, Fabric can virtualize data from Amazon S3, ADLS and Google Cloud without duplication, enabling access and analytics. OneLake supports multicloud flexibility, zero-ETL integration, and native support for Delta Lake. |
| [AWS Lake Formation](https://aws.amazon.com/lake-formation/) | [Fabric OneLake](/fabric/onelake/onelake-overview) | AWS Lake Formation manages data lakes within the AWS ecosystem. Microsoft Fabric OneLake offers a SaaS-native data lake that supports all Fabric workloads: Lakehouse, Warehouse, Real-Time Intelligence, and Power BI. OneLake requires no extra setup and brings built-in governance through Microsoft Purview, with native support for Delta Lake and Shortcuts for multicloud virtualization (including Amazon S3). | 
| [Amazon Athena](https://aws.amazon.com/athena/)   | [Fabric Lakehouse](/fabric/data-engineering/lakehouse-overview/) | Amazon Athena is a serverless query engine that enables ad-hoc SQL analysis directly on data stored in Amazon S3. The Microsoft Fabric Lakehouse offers an integrated environment for both data engineering and analytics. It stores data in OneLake using the Delta Lake format, supports Spark, T-SQL, and Python. |
| [AWS Glue Data Catalog](https://aws.amazon.com/glue/) | [Microsoft Purview](https://azure.microsoft.com/services/purview/) | AWS Glue Data Catalog centralizes metadata for analytics and ML, primarily acting as a metadata store and schema registry, requiring other services for lineage, policy, and governance. Microsoft Purview, on the other hand, is a unified data governance service spanning Azure, Microsoft Fabric OneLake, on-premises and multicloud environments. It not only catalogs data in Fabric OneLake, ADLS and other sources, but also provides data classification, lineage visualization, policy management and glossary integration in its Unified Catalog. From a data lake perspective, Purview delivers a governance-first approach—connecting metadata, security, and compliance in one platform. |

## Big data analytics

These services process and analyze large and complex datasets to uncover patterns, insights, and trends. The following table provides direct comparisons of individual big data services. Microsoft Fabric is an all-in-one service for big data and analytics. It provides the following services and more.

| AWS service   | Microsoft service | Analysis      |
| ------------- | ----- | -------------- |
| [Amazon EMR](https://aws.amazon.com/emr/) | [Fabric Data Engineering workloads](/fabric/data-engineering/data-engineering-overview/) powered by [Apache Spark](/fabric/data-engineering/runtime/) | Amazon EMR is a managed big data service for running frameworks like Spark, Hadoop, and Hive, with cluster provisioning and tuning requirements. In Microsoft Fabric, Data Engineering workload, powered by Apache Spark, removes the need to manage clusters, providing a serverless, integrated, and governed experience within the Fabric ecosystem. |
| [Amazon EMR](https://aws.amazon.com/emr/) | [Azure Databricks](/azure/databricks/introduction/) | These services enable big data processing via Apache Spark in a managed environment. EMR enables you to run Apache Spark clusters with flexible configuration and scaling options. Azure Databricks provides an optimized Apache Spark platform with collaborative notebooks and integrated workflows.  |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) | These services provide real-time data streaming and analytics for processing and analyzing high-volume data streams.    |
| [AWS Glue with AWS Glue Studio](https://aws.amazon.com/glue/) | [Fabric Data Engineering workloads](/fabric/data-engineering/data-engineering-overview/) powered by [Apache Spark](/fabric/data-engineering/runtime/) | AWS Glue Studio combined with Kinesis provides data integration and real-time streaming pipelines, but it requires managing data movement between services. Microsoft Fabric Data Engineering workloads, powered by Apache Spark, bring these capabilities directly into the Fabric platform: batch and streaming transformations, orchestration, and governance are integrated with OneLake, Purview, and Power BI. Fabric delivers a single experience for data integration and engineering, without management of separate services for ETL, streaming, and analytics. |
| [AWS Glue with AWS Glue Studio](https://aws.amazon.com/glue/) | [Azure Databricks](/azure/databricks/introduction/) and [Azure Data Factory](/azure/data-factory/introduction/) | Both services provide big data processing capabilities with integrated data transformation and analytics. |

## Business intelligence and reporting

These services provide data visualization, reporting, and dashboards to help businesses make informed decisions.

| AWS service   | Microsoft service         | Analysis      |
| ------------- | ----- | -------------- |
| [Amazon QuickSight](https://aws.amazon.com/quicksight/)     | [Power BI](https://powerbi.microsoft.com/)  |  QuickSight and Power BI provide business analytics tools for data visualization and interactive dashboards.|
| [Amazon Managed Grafana](https://aws.amazon.com/grafana/)   | [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana/) | These services provide managed Grafana, which enables you to visualize metrics, logs, and traces across multiple data sources. |
| [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | [External data sharing in Microsoft Fabric](/fabric/governance/external-data-sharing-overview#supported-fabric-item-types) and [OneLake Shortcuts](/fabric/onelake/onelake-shortcuts) | AWS Data Exchange provides a marketplace where organizations can subscribe to and consume third-party datasets, handling licensing and secure delivery. In Microsoft Fabric, external collaboration is available through OneLake shortcuts and cross-tenant sharing, where external data becomes available across Spark, SQL, KQL, and Power BI. |
| [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | [Azure Data Share](https://azure.microsoft.com/services/data-share/) | These services facilitate the secure sharing and exchange of data between organizations. Data Exchange provides a marketplace model. Data Share focuses on cross-tenant data sharing. |
| [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) with Kibana | [Fabric KQL database](/fabric/real-time-intelligence/create-database/) with [Power BI](https://powerbi.microsoft.com/) | Amazon OpenSearch Service with Kibana provides a managed search and analytics platform for indexing, querying, and visualizing large datasets, commonly used for log analytics and observability. Microsoft Fabric delivers experience through its KQL database for real-time data exploration combined with Power BI for interactive reporting. |
| [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) with Kibana | [Azure AI Search](/azure/search/search-what-is-azure-search/) with [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/) with dashboards | These services provide real-time data exploration and interactive analytics over large volumes of data. OpenSearch uses Kibana for search and visualization. Azure offers Azure AI Search for intelligent full-text search and Azure Data Explorer uses Kusto for high-performance, real-time analytics, paired with interactive dashboards for visualization. |

## Real-time data processing

These systems ingest and analyze data as it's generated to provide immediate insights and responses.

| AWS service    | Microsoft service     | Analysis     |
| ---  |  ------- |  ---- |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | [Fabric Real-Time hub](/fabric/real-time-hub/real-time-hub-overview/), [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities/) with [Fabric KQL database](/fabric/real-time-intelligence/create-database/) | Amazon Kinesis enables real-time data streaming, ingestion and processing across services like S3, Redshift, and Lambda. Microsoft Fabric offers streaming architecture with the Real-Time hub, which supports ingestion from multiple sources, including Amazon Kinesis, Kafka, and Azure Event Hubs, and Google Pub/Sub, while Fabric Eventstream enables stream routing, transformation and alerting. |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) | These services enable you to process and analyze data from IoT devices in real time. AWS IoT Analytics provides built-in data storage and analysis capabilities. Azure provides modular services: IoT Hub handles ingestion, and Stream Analytics processes the data. | 
| [Amazon Managed Streaming for Apache Kafka (MSK)](https://aws.amazon.com/msk/) | [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview/) with Kafka endpoints | Amazon Managed Streaming for Apache Kafka (MSK) is AWS's fully managed Kafka service. In Microsoft Fabric, Eventstream with Kafka endpoints lets you publish/consume via the Kafka protocol, and also ingest directly from Amazon MSK into Fabric's Real‑Time hub for downstream processing and analytics (for example, Eventhouse with Power BI). Azure offers both a fully managed Kafka‑compatible ingestion plane (Event Hubs) and a managed Kafka cluster (HDInsight), while Fabric provides a Kafka‑integrated, end‑to‑end real‑time analytics hub. |
| [Amazon Managed Streaming for Apache Kafka (MSK)](https://aws.amazon.com/msk/) | [Azure Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-apache-kafka-overview/) | These services provide managed Apache Kafka clusters for creating real-time streaming data pipelines and applications. Azure Event Hubs for Apache Kafka exposes a Kafka‑compatible endpoint and existing clients can connect with minimal changes. It also supports Kafka Streams in Premium/Dedicated tiers. |
| [AWS Lambda](https://aws.amazon.com/lambda/) | [Fabric Notebooks](/fabric/data-engineering/author-execute-notebook/) with [Fabric Data Pipelines](/fabric/data-factory/create-first-pipeline-with-sample-data) for serverless data processing | AWS Lambda is a serverless, event‑driven compute for running code without managing servers. For analytics‑focused, serverless-style processing in Microsoft Fabric, you can use Fabric notebooks with Data Factory pipelines: notebooks run managed Apache Spark jobs for data ingest/cleanup/transform, and pipelines orchestrate and schedule those notebooks as part of end‑to‑end data workflows, providing on‑demand compute and no cluster management inside Fabric. |
| [AWS Lambda](https://aws.amazon.com/lambda/) | [Azure Functions](https://azure.microsoft.com/services/functions/) (with APIM for API triggers) | These serverless compute platforms run code in response to events and automatically manage the underlying compute resources. Azure Functions delivers the same event‑driven, autoscaling execution model and is commonly paired with API Management and other Azure triggers. Microsoft also provides a [migration guide from Lambda to Functions](/azure/azure-functions/migration/migrate-aws-lambda-to-azure-functions/) to streamline parity and code moves. |
| [Amazon DynamoDB Streams](https://aws.amazon.com/pm/dynamodb/)  | [Fabric Mirroring(Cosmos DB)](/fabric/mirroring/azure-cosmos-db/) with [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities/) | Amazon DynamoDB Streams provides a real-time feed of item-level changes in DynamoDB tables, enabling event-driven processing and downstream analytics. In Microsoft Fabric, mirroring Cosmos DB into OneLake for analytics brings no ETL overhead, combined with Fabric Eventstream for real-time event routing and integration with Fabric's KQL database or Lakehouse. |
| [Amazon DynamoDB Streams](https://aws.amazon.com/pm/dynamodb/)  | [Azure Cosmos DB change feed](/azure/cosmos-db/change-feed)| These services enable real-time data processing by capturing and providing a stream of data modifications. |
| [Amazon ElastiCache with Redis streams](https://aws.amazon.com/elasticache/)   | [Azure Cache for Redis with Redis streams](https://azure.microsoft.com/services/cache/)   | These services provide managed Redis instances that support Redis streams for real-time data ingestion and processing.      |
| [Amazon IoT Analytics](https://aws.amazon.com/iot-analytics/)   | [Fabric Eventstream](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities/) with [Fabric KQL database](/fabric/real-time-intelligence/create-database/) | Amazon IoT Analytics is a managed service that collects, processes and analyzes IoT device data at scale. Fabric Eventstream ingests IoT telemetry and routes it to the Fabric KQL database for real-time querying and analytics. |
| [Amazon IoT Analytics](https://aws.amazon.com/iot-analytics/)   | [Azure IoT Hub with Azure Stream Analytics](https://azure.microsoft.com/services/iot-hub/) | These services enable you to process and analyze data from IoT devices in real time. AWS IoT Analytics provides built-in data storage and analysis capabilities. Azure provides modular services: IoT Hub handles ingestion, and Stream Analytics processes the data. |

## Machine learning services

These tools and platforms enable the development, training, and deployment of machine learning models.
| AWS service    | Microsoft service | Analysis     |
| ---  |  ------- |  ---- |
| [Amazon SageMaker](https://aws.amazon.com/sagemaker/) | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Azure Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | Amazon SageMaker is AWS's fully managed platform for building, training, and deploying machine learning models at scale. Azure provides an equivalent through Azure Machine Learning, an end-to-end managed service that supports everything from data preparation and automated ML to model deployment and MLOps. The Fabric Data Science workload brings model development and enrichment, integrating with Azure Machine Learning for training, GPU acceleration and enterprise-grade deployment. |
| [AWS Deep Learning AMIs](https://aws.amazon.com/machine-learning/amis/) | [Azure Data Science Virtual Machines](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines/) with [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) | AWS Deep Learning AMIs provide prebuilt virtual machine images with popular deep learning frameworks, GPU drivers, and libraries to accelerate AI model development. Azure offers a similar experience through the Azure Data Science Virtual Machine (DSVM), which comes preconfigured with Python, R, Jupyter, and major deep learning frameworks like TensorFlow and PyTorch. Combined with Azure Machine Learning, DSVMs become part of a fully managed platform for training, deployment and MLOps. |
| [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/autopilot/) | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Azure Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | Amazon SageMaker Autopilot automates the machine learning lifecycle by handling data preprocessing, algorithm selection, and hyperparameter tuning with minimal manual effort. Microsoft Fabric's Data Science workload brings AutoML-driven model development, while integrating with Azure Machine Learning for training and operationalization. |
| [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/autopilot/) | [Automated Machine Learning (AutoML)](https://azure.microsoft.com/solutions/automated-machine-learning/)  | These services provide automated machine learning for building and training models. |
| [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/)  | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Azure Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | Amazon SageMaker Studio is AWS's integrated development environment for machine learning, providing a single web-based interface to build, train, and deploy models. Microsoft Fabric's Data Science workload brings collaborative notebooks and Spark-based environments into a unified analytics platform, integrating with Azure Machine Learning for training and deployment. |
| [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/)  | [Azure Machine Learning studio](https://azure.microsoft.com/services/machine-learning/) | These services provide integrated development environments for machine learning. SageMaker Studio provides a unified interface for all machine learning development steps, including debugging and profiling tools. |

## AI services

AI services provide prebuilt, customizable AI capabilities to applications, including vision, speech, language, and decision making.

| AWS service     | Azure service | Analysis   |
|  -------  | ------  |--|
| [Amazon Rekognition](https://aws.amazon.com/rekognition/)               | [Azure AI Vision](/azure/ai-services/computer-vision/overview/) with [Custom Vision](/azure/ai-services/custom-vision-service/overview/)  | Amazon Rekognition is AWS's computer vision service for image and video analysis, offering capabilities like object detection, facial recognition, and text extraction. Azure AI Vision delivers prebuilt models for image and video understanding. Azure Custom Vision allows you to train domain-specific models with your own data. |
| [Amazon Polly](https://aws.amazon.com/polly/)    | [Azure AI Speech (Text-to-Speech)](https://azure.microsoft.com/products/ai-services/ai-speech)  | Amazon Polly is AWS's text-to-speech service that converts text into lifelike speech using neural voices across multiple languages. Azure AI Speech (Text-to-Speech) provides high-quality neural voices, real-time streaming, and batch synthesis for applications such as voice assistants, IVR systems, and accessibility solutions. Azure AI Speech also supports custom neural voice creation, enabling organizations to build unique, brand-specific voices while maintaining enterprise-grade security and compliance. | 
| [Amazon Transcribe](https://aws.amazon.com/transcribe/)    | [Azure AI Speech (Speech-to-Text)](https://azure.microsoft.com/products/ai-services/ai-speech/)  | Amazon Transcribe provides speech-to-text with real-time transcription and custom vocabularies, commonly used for call analytics and captions. Azure AI Speech (Speech-to-Text) offers real-time and batch transcription, speaker diarization, and custom models for domain-specific accuracy. |
| [Amazon Translate](https://aws.amazon.com/translate/) | [Azure AI Translator](https://azure.microsoft.com/products/ai-services/ai-translator)| Amazon Translate is a neural machine translation service that delivers translations across multiple languages for websites, apps, and multilingual content. Azure AI Translator offers similar capabilities with real-time and batch translation in 100+ languages, plus features like transliteration, language detection, and custom glossaries for domain-specific accuracy. |
| [Amazon Comprehend](https://aws.amazon.com/comprehend/)     | [Azure AI Language](https://azure.microsoft.com/products/ai-services/ai-language)  | Amazon Comprehend is a Natural Language Processing (NLP) service that extracts insights from text, including sentiment, key phrases, and entities, useful for analyzing customer feedback and documents. Azure AI Language (Text Analytics) offers similar capabilities with features like sentiment analysis, key phrase extraction, named entity recognition, and custom text classification. |
| [Amazon Lex](https://aws.amazon.com/lex/) | [Conversational Language Understanding (CLU) in AI Foundry](/azure/ai-services/language-service/conversational-language-understanding/overview) | You can use these services to create conversational interfaces that leverage natural language understanding. Azure takes a modular approach, where Conversational Language Understanding (CLU) handles intent recognition and entity extraction, while other components manage dialogue and integration. In contrast, Amazon Lex offers an integrated solution for building conversational interfaces entirely within the AWS ecosystem. |
| [Amazon Textract](https://aws.amazon.com/textract/) | [Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence/) |Amazon Textract is a machine learning service that extracts text and data from scanned documents, including tables and forms, to automate document processing. Azure AI Document Intelligence offers similar functionality with OCR, prebuilt models for invoices, receipts and IDs, and the ability to train custom models for domain-specific forms. Azure AI Document Intelligence supports multi-language extraction and provides layout analysis for complex documents.  |
| [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) | [Azure AI Search](https://azure.microsoft.com/products/ai-services/ai-search/)      |  Amazon OpenSearch Service is a managed search and analytics engine based on Elasticsearch, commonly used for log analytics, full-text search, and real-time data exploration. Azure AI Search offers similar capabilities with built-in AI enrichment, hybrid search (keyword with vector), and integration with Azure services for security and compliance. It supports scenarios like semantic search and retrieval-augmented generation (RAG). |

## Generative AI services

These AI services create new content or data that resembles human-generated output, like text, images, or audio.

| AWS service     | Azure services    | Analysis   |
| ----  | --------  | ------  |
| [Amazon Bedrock](https://aws.amazon.com/bedrock/) | [Azure AI Foundry](https://azure.microsoft.com/products/ai-foundry/) | Amazon Bedrock, Azure AI Foundry, and Azure OpenAI Service provide foundation models for creating and deploying generative AI applications. |

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
