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
|------|--|--|
| [Data integration with Azure Data Factory](/fabric/data-factory/) | [AWS Glue](https://aws.amazon.com/glue/) | AWS Glue provides capabilities to build data and analytics solutions. This approach provides flexibility but requires more effort to integrate each service into an end-to-end solution. Fabric combines capabilities within a single platform to simplify workflows, collaboration, and management. |

### Detailed comparison of Fabric components and AWS services

The following table compares key Fabric components and their corresponding AWS services. It helps architects and decision-makers understand how the Fabric data platform aligns or diverges from AWS offerings across data engineering, analytics, governance, and AI workloads.

| Microsoft service  | AWS services|
|---- |------|
| [Data integration with Data Factory](/fabric/data-factory/)             | [AWS Glue](https://aws.amazon.com/glue/) |
| [Data engineering with Apache Spark](/fabric/data-engineering/)       | [Amazon Elastic MapReduce (EMR)](https://aws.amazon.com/emr/), [AWS Glue interactive sessions](https://docs.aws.amazon.com/glue/latest/dg/interactive-sessions.html)  |
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
| [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/)  | [Amazon AppFlow](https://aws.amazon.com/appflow/)  | These services automate data flows between cloud applications and services without requiring code. Logic Apps provides integration capabilities through a wide range of connectors and a visual designer. AppFlow provides secure data transfer between specific SaaS applications and AWS services and includes built-in data transformation features.   |
| [Data Factory](https://azure.microsoft.com/services/data-factory/) with [Logic Apps](https://azure.microsoft.com/services/logic-apps/) | [AWS Step Functions](https://aws.amazon.com/step-functions/)   | These services provide workflow orchestration for coordinating distributed applications and microservices. Logic Apps supports both data integration and enterprise workflow automation. Step Functions orchestrates AWS services and microservices in serverless applications.   |

## Data warehousing

These solutions store and manage large volumes of structured data optimized for querying and reporting.

| Microsoft service     | AWS service      | Analysis        |
| --------- | ------  |  --- |
| [Fabric Data Warehouse](/fabric/data-warehouse/)  | [Amazon Redshift](https://aws.amazon.com/redshift/)   | Fabric Data Warehouse and Amazon Redshift are cloud-based, managed, and petabyte (PB)-scale data warehouses designed for high-performance analytics at scale. Fabric Data Warehouse integrates with Fabric and provides a unified platform that combines storage, analytics, governance, and AI. Redshift uses the AWS ecosystem and focuses on data warehousing. Both services support massive parallel processing. Fabric has a lake-first architecture and deep integration across Microsoft data and AI services. |
| [Fabric OneLake Shortcuts](/fabric/onelake/onelake-shortcuts), [Direct Lake in Power BI](/fabric/fundamentals/direct-lake-overview) and [Pipeline connectors in Azure Data Factory](/fabric/data-factory/connector-overview) | [Amazon Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html)  | While Amazon Redshift Spectrum enables querying external data in S3, Fabric provides a lake-first approach. With OneLake shortcuts, you can virtualize data from multiple sources into a single logical lake without movement. Direct Lake mode in Power BI delivers instant analytics on open Delta and Parquet files in OneLake without import. Fabric Data Factory pipelines provide native connectors to ingest, transform, or orchestrate data flows. |
| [Fabric OneLake](/fabric/onelake/onelake-overview), [Microsoft Purview in Fabric](/fabric/governance/microsoft-purview-fabric) and [Fabric Permission Model](/fabric/security/permission-model/) | [AWS Lake Formation](https://aws.amazon.com/lake-formation/)    | AWS Lake Formation provides governance and access controls on top of S3-based data lakes. In contrast, Fabric delivers these capabilities through OneLake combined with Microsoft Purview for cataloging, lineage, and data governance. You use role-based access control (RBAC) and fine-grained security to provide access across workspaces, tables, and columns. |
| [Fabric SQL Database](/fabric/database/sql/overview/), [Amazon Redshift Connector in Dataflow Gen2](/fabric/data-factory/connector-amazon-redshift), [Fabric data pipelines](/fabric/data-factory/create-first-pipeline-with-sample-data), and [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) | [Amazon RDS](https://aws.amazon.com/rds/) with [Redshift Federated Query](https://docs.aws.amazon.com/redshift/latest/dg/federated-overview.html) | Amazon RDS with Redshift Federated Query enables Redshift to run SQL queries directly on live RDS data, which provides real-time access across operational and analytical stores. Fabric SQL Database introduces a SaaS-native SQL engine with autoscaling, built-in governance, and integration with the Fabric platform. Fabric data pipelines support ingestion from Amazon RDS and Redshift into lakehouses or SQL databases. OneLake shortcuts virtualize external data, such as Azure Data Lake Storage Gen2 and Amazon S3, into Fabric without duplication. |
| [Azure SQL Database](https://azure.microsoft.com/services/sql-database/) | [Amazon RDS](https://aws.amazon.com/rds/) with [Redshift Federated Query](https://docs.aws.amazon.com/redshift/latest/dg/federated-overview.html) | These services support querying across operational databases and data warehouses. Azure Synapse Analytics provides a unified, built-in analytics experience. AWS requires you to combine RDS and Redshift for similar cross-service querying capabilities. |
| [SQL Database in Fabric](/fabric/database/sql/overview/)| [Amazon Aurora](https://aws.amazon.com/rds/aurora/) with Redshift integration | Amazon Aurora handles operational data. Redshift performs large-scale analytics through federated queries and batch ingestion. In Fabric, SQL Database provides a managed, autoscaling relational engine that integrates natively with OneLake and Power BI. This setup supports unified analytics and governance. |
| [SQL Database Serverless](/azure/azure-sql/database/serverless-tier-overview) | [Amazon Aurora](https://aws.amazon.com/rds/aurora/) with Redshift integration | These managed, cloud-native relational databases separate compute from storage, automatically scale resources based on demand, and ensure high availability. Both services use SQL-based engines and extend into cost-efficient solutions for transactional and analytical workloads. SQL Database Serverless automatically pauses during inactivity to optimize cost while providing the full SQL Server engine. |

## Data lake solutions

These platforms store vast amounts of raw unstructured and structured data in its native format for future processing.

| Microsoft service | AWS service   | Analysis      |
| ----- | ------------- | -------------- |
| [Fabric OneLake](/fabric/onelake/onelake-overview), [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) | [Amazon S3](https://aws.amazon.com/s3/) | Data Lake Storage and Amazon S3 are both scalable object storage solutions designed for big data analytics. They support formats like Parquet, CSV, and JSON. Data Lake Storage is optimized for Azure-native tools, while S3 integrates with AWS services. Fabric OneLake unifies structured and unstructured data across clouds into a single, governed lake. With OneLake shortcuts, Fabric can virtualize data from Amazon S3, Data Lake Storage, and Google Cloud without duplication, which supports access and analytics. OneLake supports multicloud flexibility, zero-ETL integration, and Delta Lake. |
| [Fabric OneLake](/fabric/onelake/onelake-overview) | [AWS Lake Formation](https://aws.amazon.com/lake-formation/) | AWS Lake Formation manages data lakes within the AWS ecosystem. Fabric OneLake provides a SaaS-native data lake that supports all Fabric workloads, including lakehouses, warehouses, Real-Time Intelligence, and Power BI. OneLake requires no extra setup and includes built-in governance through Microsoft Purview. It also has native support for Delta Lake and shortcuts for multicloud virtualization, including Amazon S3. | 
| [Fabric lakehouse](/fabric/data-engineering/lakehouse-overview/) | [Amazon Athena](https://aws.amazon.com/athena/)   | Amazon Athena is a serverless query engine that enables real-time SQL analysis directly on data stored in Amazon S3. A Fabric lakehouse provides an integrated environment for both data engineering and analytics. It stores data in OneLake by using the Delta Lake format, and supports Spark, T-SQL, and Python. |
| [Microsoft Purview](https://azure.microsoft.com/services/purview/) | [AWS Glue Data Catalog](https://aws.amazon.com/glue/) | AWS Glue Data Catalog centralizes metadata for analytics and machine learning. It serves as a metadata store and schema registry and requires other services to manage lineage, policy, and governance. Microsoft Purview is a unified data governance service that spans Azure, Fabric OneLake, and on-premises and multicloud environments. It catalogs data in Fabric OneLake, Data Lake Storage, and other sources. It provides data classification, lineage visualization, policy management, and glossary integration through its Unified Catalog. From a data lake perspective, Microsoft Purview delivers a governance-first approach by connecting metadata, security, and compliance in one platform. |

## Big data analytics

These services process and analyze large and complex datasets to uncover patterns, insights, and trends. The following table provides direct comparisons of individual big data services. Fabric is an all-in-one service for big data and analytics. It provides the following services and more.

| Microsoft service | AWS service   | Analysis      |
| ----- | ------------- | -------------- |
| [Fabric Data Engineering workloads](/fabric/data-engineering/data-engineering-overview/) that use [Spark](/fabric/data-engineering/runtime/) | [Amazon EMR](https://aws.amazon.com/emr/) | Amazon EMR is a managed big data service for running frameworks like Spark, Hadoop, and Hive, with cluster provisioning and tuning requirements. In Fabric, the Data Engineering workload uses Spark to remove the need for cluster management. It provides a serverless, integrated, and governed experience within the Fabric ecosystem. |
| [Azure Databricks](/azure/databricks/introduction/) | [Amazon EMR](https://aws.amazon.com/emr/) | These services support big data processing via Spark in a managed environment. Amazon EMR runs Spark clusters and provides flexible configuration and scaling options. Azure Databricks provides an optimized Spark platform that includes collaborative notebooks and integrated workflows.  |
| [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) | [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | These services provide real-time data streaming and analytics for processing and analyzing high-volume data streams.    |
| [Fabric Data Engineering workloads](/fabric/data-engineering/data-engineering-overview/) that use [Spark](/fabric/data-engineering/runtime/) | [AWS Glue with AWS Glue Studio](https://aws.amazon.com/glue/) | AWS Glue Studio combined with Kinesis provides data integration and real-time streaming pipelines, but it requires managing data movement between services. Fabric Data Engineering workloads use Spark to deliver these capabilities directly into the Fabric platform. Batch and streaming transformations, orchestration, and governance integrate with OneLake, Purview, and Power BI. Fabric delivers a single experience for data integration and engineering, without management of separate services for ETL, streaming, and analytics. |
| [Azure Databricks](/azure/databricks/introduction/) and [Azure Data Factory](/azure/data-factory/introduction/) | [AWS Glue with AWS Glue Studio](https://aws.amazon.com/glue/) | Both service combinations provide big data processing capabilities that include integrated data transformation and analytics. |

## Business intelligence and reporting

These services provide data visualization, reporting, and dashboards to help you make informed decisions.

| Microsoft service         | AWS service   | Analysis      |
| ----- | ------------- | -------------- |
| [Power BI](https://powerbi.microsoft.com/)  | [Amazon QuickSight](https://aws.amazon.com/quicksight/)     |  Power BI and Amazon QuickSight provide business analytics tools for data visualization and interactive dashboards.|
| [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana/) | [Amazon Managed Grafana](https://aws.amazon.com/grafana/)   | These services provide managed Grafana to visualize metrics, logs, and traces across multiple data sources. |
| [External data sharing in Fabric](/fabric/governance/external-data-sharing-overview#supported-fabric-item-types) and [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) | [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | AWS Data Exchange provides a marketplace where your orgnization can subscribe to and consume external datasets. The service handles licensing and secure delivery. In Fabric, external collaboration is available through OneLake shortcuts and cross-tenant sharing. External data becomes available across Spark, SQL, KQL, and Power BI. |
| [Azure Data Share](https://azure.microsoft.com/services/data-share/) | [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | These services facilitate the secure sharing and exchange of data between organizations. AWS Data Exchange provides a marketplace model. Data Share focuses on cross-tenant data sharing. |
| [Fabric KQL database](/fabric/real-time-intelligence/create-database/) with [Power BI](https://powerbi.microsoft.com/) | [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) with Kibana | Amazon OpenSearch Service with Kibana provides a managed search and analytics platform for indexing, querying, and visualizing large datasets, commonly used for log analytics and observability. Fabric delivers similar capabilities through its KQL database for real-time data exploration, combined with Power BI for interactive reporting. |
| [Azure AI Search](/azure/search/search-what-is-azure-search/), [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/), and dashboards | [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) with Kibana | These services provide real-time data exploration and interactive analytics over large volumes of data. Amazon OpenSearch uses Kibana for search and visualization. AI Search provides intelligent full-text search. Azure Data Explorer uses KQL to power high-performance, real-time analytics with interactive dashboards for visualization. |

## Real-time data processing

These systems ingest and analyze data as it's generated to provide immediate insights and responses.

| Microsoft service     | AWS service    | Analysis     |
| ------- | ---  |  ---- |
| [Fabric Real-Time Intelligence hub](/fabric/real-time-hub/real-time-hub-overview/), [Fabric eventstream](/fabric/real-time-intelligence/event-streams/overview/) with [Fabric KQL database](/fabric/real-time-intelligence/create-database/) | [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | Amazon Kinesis enables real-time data streaming, ingestion, and processing across services like S3, Redshift, and Lambda. Fabric provides streaming architecture with the Real-Time Intelligence hub, which supports ingestion from multiple sources, including Amazon Kinesis, Kafka, Event Hubs, and Google Pub/Sub. Fabric eventstreams manage stream routing, transformation, and alerting. |
| [Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) | [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | These services process and analyze data from Internet of Things (IoT) devices in real time. Amazon Kinesis provides streaming ingestion and processing capabilities. Azure provides modular services. Event Hubs handles data ingestion, and Stream Analytics processes the data. | 
| [Fabric eventstream](/fabric/real-time-intelligence/event-streams/overview/) with Kafka endpoints | [Amazon Managed Streaming for Apache Kafka (MSK)](https://aws.amazon.com/msk/) | Amazon MSK is a managed Kafka service in AWS. Fabric eventstreams support Kafka endpoints for publishing and consuming via the Kafka protocol. They can also ingest directly from Amazon MSK into the Fabric Real‑Time Intelligence hub for downstream processing and analytics, such as eventhouse with Power BI. Azure provides both a managed Kafka‑compatible ingestion plane (Event Hubs) and a managed Kafka cluster (HDInsight). Fabric provides an end‑to‑end, real‑time analytics hub that integrates with Kafka. |
| [Event Hubs for Apache Kafka](/azure/event-hubs/azure-event-hubs-apache-kafka-overview/) | [Amazon MSK](https://aws.amazon.com/msk/) | These services provide managed Apache Kafka clusters for creating real-time streaming data pipelines and applications. Event Hubs for Apache Kafka exposes a Kafka‑compatible endpoint, and existing clients can connect with minimal changes. It also supports Kafka streams in Premium and Dedicated tiers. |
| [Fabric notebooks](/fabric/data-engineering/author-execute-notebook/) with [Fabric data pipelines](/fabric/data-factory/create-first-pipeline-with-sample-data) for serverless data processing | [AWS Lambda](https://aws.amazon.com/lambda/) | AWS Lambda is a serverless, event‑driven compute for running code without managing servers. For analytics‑focused, serverless-style processing in Fabric, you can use Fabric notebooks with Azure Data Factory pipelines. Notebooks run managed Spark jobs for data ingesting, cleanup, transformation. Pipelines orchestrate and schedule those notebooks as part of end‑to‑end data workflows, which provides on‑demand compute and no cluster management inside Fabric. |
| [Azure Functions](https://azure.microsoft.com/services/functions/) with Azure API Management for API triggers | [AWS Lambda](https://aws.amazon.com/lambda/) | These serverless compute platforms run code in response to events and automatically manage the underlying compute resources. Azure Functions delivers the same event‑driven, autoscaling implementation model and is commonly paired with API Management and other Azure triggers. Microsoft also provides a [migration guide from Lambda to Functions](/azure/azure-functions/migration/migrate-aws-lambda-to-azure-functions/) to streamline parity and code moves. |
| [Fabric mirroring (Azure Cosmos DB)](/fabric/mirroring/azure-cosmos-db/) with [Fabric eventstreams](/fabric/real-time-intelligence/event-streams/overview/) | [Amazon DynamoDB streams](https://aws.amazon.com/pm/dynamodb/)  | Amazon DynamoDB streams provide a real-time feed of item-level changes in DynamoDB tables, which enables event-driven processing and downstream analytics. In Fabric, mirroring Azure Cosmos DB into OneLake for analytics eliminates ETL overhead. Combined with Fabric eventstreams, this setup routes real-time events and integrates with Fabric KQL databases or lakehouses. |
| [Azure Cosmos DB change feed](/azure/cosmos-db/change-feed) | [Amazon DynamoDB streams](https://aws.amazon.com/pm/dynamodb/)  | These services enable real-time data processing by capturing and providing a stream of data modifications. |
| [Azure Cache for Redis with Redis streams](https://azure.microsoft.com/services/cache/)   | [Amazon ElastiCache with Redis streams](https://aws.amazon.com/elasticache/)   | These services provide managed Redis instances that support Redis streams for real-time data ingestion and processing.      |
| [Fabric eventstreams](/fabric/real-time-intelligence/event-streams/overview/) with [Fabric KQL database](/fabric/real-time-intelligence/create-database/) | [Amazon IoT Analytics](https://aws.amazon.com/iot-analytics/)   | Amazon IoT Analytics is a managed service that collects, processes, and analyzes IoT device data at scale. Fabric eventstreams ingest IoT telemetry and route it to the Fabric KQL database for real-time querying and analytics. |
| [Azure IoT Hub with Azure Stream Analytics](https://azure.microsoft.com/services/iot-hub/) | [Amazon IoT Analytics](https://aws.amazon.com/iot-analytics/)   | These services enable you to process and analyze data from IoT devices in real time. Amazon IoT Analytics provides built-in data storage and analysis capabilities. Azure provides modular services. IoT Hub handles ingestion, and Stream Analytics processes the data. |

## Machine learning services

These tools and platforms enable the development, training, and deployment of machine learning models.

| Microsoft service | AWS service    | Analysis     |
| ------- | ---  |  ---- |
| [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | [Amazon SageMaker](https://aws.amazon.com/sagemaker/) | Amazon SageMaker is a managed platform for building, training, and deploying machine learning models at scale. Azure provides an equivalent through Machine Learning, an end-to-end managed service that supports data preparation, automated machine learning , model deployment, and machine learning operations (MLOps). The Fabric Data Science workload provides model development and enrichment. It integrates with Machine Learning for training, GPU acceleration, and enterprise-grade deployment. |
| [Azure Data Science virtual machines](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines/) with [Machine Learning](https://azure.microsoft.com/services/machine-learning/) | [AWS deep learning Amazon machine images (AMIs)](https://aws.amazon.com/machine-learning/amis/) | AWS deep learning AMIs provide prebuilt virtual machine images with popular deep learning frameworks, GPU drivers, and libraries to accelerate AI model development. Azure provides a similar experience through Azure Data Science virtual machines, which come preconfigured with Python, R, Jupyter, and major deep learning frameworks like TensorFlow and PyTorch. Combined with Machine Learning, Data Science virtual machines become part of a managed platform for training, deployment, and MLOps. |
| [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/autopilot/) | Amazon SageMaker Autopilot automates the machine learning life cycle by handling data preprocessing, algorithm selection, and hyperparameter tuning with minimal manual effort. The Fabric Data Science workload provides automated machine learning-driven model development and integrates with Machine Learning for training and operationalization. |
| [Automated machine learning](https://azure.microsoft.com/solutions/automated-machine-learning/)  | [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/autopilot/) | These services provide automated machine learning for building and training models. |
| [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/)  | Amazon SageMaker Studio is an integrated development environment for machine learning in AWS. It provides a single web-based interface to build, train, and deploy models. The Fabric Data Science workload combines collaborative notebooks and Spark-based environments into a unified analytics platform and integrates with Machine Learning for training and deployment. |
| [Azure Machine Learning studio](https://azure.microsoft.com/services/machine-learning/) | [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/)  | These services provide integrated development environments for machine learning. Amazon SageMaker Studio provides a unified interface for all machine learning development steps, including debugging and profiling tools. |

## AI services

AI services provide prebuilt, customizable AI capabilities for applications, including vision, speech, language, and decision making capabilities.

| Azure service | AWS service     | Analysis   |
| ------  |  -------  |--|
| [Azure AI Vision](/azure/ai-services/computer-vision/overview/) with [Azure AI Custom Vision](/azure/ai-services/custom-vision-service/overview/)  | [Amazon Rekognition](https://aws.amazon.com/rekognition/)               | Amazon Rekognition is a computer vision service for image and video analysis. It provides object detection, facial recognition, and text extraction. Azure AI Vision delivers prebuilt models for image and video understanding. You can use Custom Vision to train domain-specific models with your own data. |
| [Azure AI Speech (Text-to-Speech)](https://azure.microsoft.com/products/ai-services/ai-speech)  | [Amazon Polly](https://aws.amazon.com/polly/)    | Amazon Polly is AWS's text-to-speech service that converts text into lifelike speech using neural voices across multiple languages. Azure AI Speech (Text-to-Speech) provides high-quality neural voices, real-time streaming, and batch synthesis for applications such as voice assistants, IVR systems, and accessibility solutions. Azure AI Speech also supports custom neural voice creation, enabling organizations to build unique, brand-specific voices while maintaining enterprise-grade security and compliance. | 
| [Azure AI Speech (speech-to-text)](https://azure.microsoft.com/products/ai-services/ai-speech/)  | [Amazon Transcribe](https://aws.amazon.com/transcribe/)    | Amazon Transcribe provides speech-to-text with real-time transcription and custom vocabularies, commonly used for call analytics and captions. Azure AI Speech provides real-time and batch transcription, speaker diarization, and custom models for domain-specific accuracy. |
| [Azure AI Translator](https://azure.microsoft.com/products/ai-services/ai-translator) | [Amazon Translate](https://aws.amazon.com/translate/) | Amazon Translate is a neural machine translation service that delivers translations across multiple languages for websites, apps, and multilingual content. Azure AI Translator provides similar capabilities with real-time and batch translation in more than 100 languages, plus features like transliteration, language detection, and custom glossaries for domain-specific accuracy. |
| [Azure AI Language](https://azure.microsoft.com/products/ai-services/ai-language)  | [Amazon Comprehend](https://aws.amazon.com/comprehend/)     | Amazon Comprehend is a natural language processing (NLP) service that extracts insights from text, including sentiment, key phrases, and entities, to analyze customer feedback and documents. Azure AI Language (text analytics) provides similar capabilities with features like sentiment analysis, key phrase extraction, named entity recognition, and custom text classification. |
| [Conversational language understanding in Azure AI Foundry](/azure/ai-services/language-service/conversational-language-understanding/overview) | [Amazon Lex](https://aws.amazon.com/lex/) | These services create conversational interfaces that use natural language understanding. Azure takes a modular approach, where conversational language understanding handles intent recognition and entity extraction. Other components manage dialogue and integration. Amazon Lex provides an integrated solution for building conversational interfaces entirely within the AWS ecosystem. |
| [Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence/) | [Amazon Textract](https://aws.amazon.com/textract/) | Amazon Textract is a machine learning service that extracts text and data from scanned documents, including tables and forms, to automate document processing. Document Intelligence provides similar functionality with optical character recognition (OCR), prebuilt models for invoices, receipts and IDs, and the ability to train custom models for domain-specific forms. Document Intelligence supports multi-language extraction and provides layout analysis for complex documents.  |
| [AI Search](https://azure.microsoft.com/products/ai-services/ai-search/)      | [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) |  Amazon OpenSearch Service is a managed search and analytics engine based on Elasticsearch, commonly used for log analytics, full-text search, and real-time data exploration. AI Search provides similar capabilities with built-in AI enrichment, hybrid search (keyword with vector), and integration with Azure services for security and compliance. It supports scenarios like semantic search and retrieval-augmented generation (RAG). |

## Generative AI services

These AI services create new content or data that resembles human-generated output, like text, images, or audio.

| Azure service    | AWS service     | Analysis   |
| --------  | ----  | ------  |
| [Azure AI Foundry](https://azure.microsoft.com/products/ai-foundry/) | [Amazon Bedrock](https://aws.amazon.com/bedrock/) | These services provide foundation models to create and deploy generative AI applications. |

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Regina Hackenberg](https://www.linkedin.com/in/reginahackenberg/) | Senior Technical Specialist

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini) | Director, Partner Technology Strategist
- [Filipa Lobão](https://www.linkedin.com/in/filipalobao) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Fabric](/fabric/)
- [Microsoft Purview](/purview/purview)

## Related resources

- [Choose an Azure AI services technology](../data-guide/technology-choices/ai-services.md)
- [Compare Microsoft machine learning products and technologies](../ai-ml/guide/data-science-and-machine-learning.md)
