---
title: Data and AI
description: Compare Azure data and AI services to corresponding AWS services. Understand key differences in data integration, analytics, machine learning, and AI capabilities.
author: johnkoukgit
ms.author: johnkoukaras
ms.date: 11/13/2024
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
---

# Data and AI

This article compares core Azure data and AI services to corresponding Amazon Web Services (AWS) solutions.

For comparison of other Azure and AWS services, see [Azure for AWS professionals](./index.md).

## Data governance, management, and platforms

Both Microsoft Purview and the combination of AWS services described in the following table provide comprehensive data governance solutions. Use these solutions to manage, discover, classify, and secure your data assets.

| AWS services | Microsoft service | Description |
| --- |------- |--|
| [AWS Glue Data Catalog](https://aws.amazon.com/glue/), [AWS Lake Formation](https://aws.amazon.com/lake-formation/), [Amazon Macie](https://aws.amazon.com/macie/), [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/), [AWS Config](https://aws.amazon.com/config/) | [Microsoft Purview](https://www.microsoft.com/security/business/risk-management/microsoft-purview-data-governance/) | Both options provide data governance, cataloging, and compliance features. Microsoft Purview is a unified data governance solution. You can use it to discover, classify, and manage data across on-premises, multicloud, and software as a service (SaaS) environments. It also provides data lineage and compliance capabilities. <br><br> AWS delivers comparable features through several services, including [AWS Glue Data Catalog](https://aws.amazon.com/glue/) for metadata management, [AWS Lake Formation](https://aws.amazon.com/lake-formation/) for data lake creation and governance, [Amazon Macie](https://aws.amazon.com/macie/) for data classification and protection, [AWS IAM](https://aws.amazon.com/iam/) for access control, and [AWS Config](https://aws.amazon.com/config/) for configuration management and compliance tracking. |

## All-in-one platform vs. AWS services

Microsoft Fabric provides an all-in-one platform that unifies the data and AI services required for modern analytics solutions. It moves data efficiently between services, provides unified governance and security, and simplifies pricing models. This approach contrasts with the AWS approach, where you often use separate services and must invest more effort in integration. Fabric provides integration across these functions within the Azure ecosystem.

Both AWS and Fabric provide capabilities for data integration, processing, analytics, machine learning, and business intelligence.

| AWS service | Microsoft service | Description |
|--|------|--|
| [AWS Glue](https://aws.amazon.com/glue/) | [Fabric data integration with Azure Data Factory](/fabric/data-factory/) | AWS Glue provides capabilities to build data and analytics solutions. This approach provides flexibility but requires more effort to integrate each service into an end-to-end solution. Fabric combines capabilities within a single platform to simplify workflows, collaboration, and management. |

### Detailed comparison of AWS services and Fabric components

The following table compares key Fabric components and their corresponding AWS services. It helps architects and decision-makers understand how the Fabric data platform aligns or diverges from AWS offerings across data engineering, analytics, governance, and AI workloads.

| AWS services | Microsoft service |
|------|---- |
| [AWS Glue](https://aws.amazon.com/glue/) | [Data integration with Data Factory](/fabric/data-factory/) |
| [Amazon Elastic MapReduce (EMR)](https://aws.amazon.com/emr/), [AWS Glue interactive sessions](https://docs.aws.amazon.com/glue/latest/dg/interactive-sessions.html) | [Data engineering with Apache Spark](/fabric/data-engineering/) |
| [Amazon Redshift](https://aws.amazon.com/redshift/) | [Data warehousing with Synapse Data Warehouse](/fabric/data-warehouse/) |
| [Amazon SageMaker](https://aws.amazon.com/sagemaker/) | [Data Science (Azure Machine Learning integration)](/fabric/data-science/)      |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/), [Amazon Managed Service for Apache Flink](https://aws.amazon.com/kinesis/data-analytics/) | [Real-time analytics (KQL database)](/fabric/real-time-intelligence/) |
| [Amazon Quick Sight](https://aws.amazon.com/quicksight/) | [Power BI for business intelligence](https://powerbi.microsoft.com/) |
| [Amazon S3](https://aws.amazon.com/s3/) | [Fabric OneLake unified data lake storage](/fabric/onelake/) |
| [AWS Lake Formation](https://aws.amazon.com/lake-formation/), [AWS Glue Data Catalog](https://aws.amazon.com/glue/), [Amazon Macie](https://aws.amazon.com/macie/) | [Data governance (Microsoft Purview integration)](https://www.microsoft.com/security/business/risk-management/microsoft-purview-data-governance/)    |
| [Amazon Bedrock](https://aws.amazon.com/bedrock/), [Amazon SageMaker JumpStart](https://aws.amazon.com/sagemaker/jumpstart/) | [Generative AI (Azure OpenAI in Foundry Models)](https://azure.microsoft.com/products/ai-services/openai-service) |

## Data integration and ETL tools

Data integration and extract, transform, and load (ETL) tools help extract, transform, and load data from multiple sources into a unified system for analysis.

| AWS service | Microsoft service | Analysis |
|  ----  | --------  | ----------- |
| [AWS Glue](https://aws.amazon.com/glue/) | [Azure Data Factory](https://azure.microsoft.com/services/data-factory/), [Azure Data Factory in Fabric](/fabric/data-factory/) | The Data Factory service, the Azure Data Factory feature in Fabric, and AWS Glue are managed ETL services that facilitate data integration across various sources. |
| [Amazon Managed Workflows for Apache Airflow (MWAA)](https://aws.amazon.com/managed-workflows-for-apache-airflow/) | [Apache Airflow jobs in Fabric](/fabric/data-factory/apache-airflow-jobs-concepts) | Apache Airflow provides managed workflow orchestration for complex data pipelines. The Apache Airflow job feature in Fabric serves as the next generation of the Data Factory Workflow Orchestration Manager. You can use this feature to create and manage Apache Airflow jobs and run directed acyclic graphs (DAGs). As part of Azure Data Factory in Fabric, the Airflow job feature provides data integration, preparation, and transformation from data sources like databases, data warehouses, lakehouses, and real-time data. AWS MWAA is a managed Airflow solution. |
| [AWS Database Migration Service (DMS)](https://aws.amazon.com/dms/) | [Fabric Migration Assistant for Data Warehouse](/fabric/data-warehouse/migration-assistant) | These services help you migrate databases from AWS to Azure. The Fabric Migration Assistant is a built-in tool in Fabric that guides you through migrating data and metadata from source databases in AWS to Fabric Data Warehouse. It converts schemas, uses AI to resolve migration problems, and supports migration from SQL-based sources. AWS DMS focuses on migrations within the AWS environment and provides ongoing replication features for hybrid architectures. |
| [AWS DMS](https://aws.amazon.com/dms/) | [Azure Database Migration Service](https://azure.microsoft.com/services/database-migration/) | These services help you migrate databases to the cloud with minimal downtime. The Azure service focuses on migrating to Azure databases and includes assessment and recommendation tools. <br><br>AWS DMS focuses on migrations within the AWS environment and provides ongoing replication features for hybrid architectures. |
| [Amazon AppFlow](https://aws.amazon.com/appflow/) | [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) | These services automate data flows between cloud applications and services without requiring code. Logic Apps provides integration capabilities through a wide range of connectors and a visual designer. AppFlow provides secure data transfer between specific SaaS applications and AWS services and includes built-in data transformation features. |
| [AWS Step Functions](https://aws.amazon.com/step-functions/)   | [Data Factory](https://azure.microsoft.com/services/data-factory/) with [Logic Apps](https://azure.microsoft.com/services/logic-apps/) | These services provide workflow orchestration for coordinating distributed applications and microservices. Logic Apps supports both data integration and enterprise workflow automation. Step Functions orchestrates AWS services and microservices in serverless applications.   |

## Data warehousing

The following solutions store and manage large volumes of structured data optimized for querying and reporting.

| AWS service | Microsoft service | Analysis |
| ------  | --------- |  --- |
| [Amazon Redshift](https://aws.amazon.com/redshift/) | [Fabric Data Warehouse](/fabric/data-warehouse/) | Fabric Data Warehouse and Amazon Redshift are managed, cloud-based, and petabyte (PB)-scale data warehouses designed for high-performance analytics at scale. Fabric Data Warehouse integrates with Fabric and provides a unified platform that combines storage, analytics, governance, and AI. <br><br>Redshift uses the AWS ecosystem and focuses on data warehousing. Both services support massive parallel processing. Fabric has a lake-first architecture and deep integration across Microsoft data and AI services. |
| [Amazon Redshift Spectrum](https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html) | [OneLake shortcuts](/fabric/onelake/onelake-shortcuts), [Direct Lake in Power BI](/fabric/fundamentals/direct-lake-overview), and [pipeline connectors in Azure Data Factory](/fabric/data-factory/connector-overview) | Amazon Redshift Spectrum enables querying external data in Amazon S3. In contrast, Fabric provides a lake-first approach. Use OneLake shortcuts to virtualize data from multiple sources into a single logical lake without movement. Direct Lake mode in Power BI delivers instant analytics on open Delta and Parquet files in OneLake without import. Fabric Data Factory pipelines provide native connectors to ingest, transform, and orchestrate data flows. |
| [AWS Lake Formation](https://aws.amazon.com/lake-formation/) | [OneLake](/fabric/onelake/onelake-overview), [Microsoft Purview in Fabric](/fabric/governance/microsoft-purview-fabric), and [Fabric permission model](/fabric/security/permission-model/) | AWS Lake Formation provides governance and access controls on top of Amazon S3-based data lakes. In contrast, Fabric delivers these capabilities through OneLake combined with Microsoft Purview for cataloging, lineage, and data governance. You use role-based access control (RBAC) and fine-grained security to provide access across workspaces, tables, and columns. |
| [Amazon Relational Database Service (RDS)](https://aws.amazon.com/rds/) with [Amazon Redshift Federated Query](https://docs.aws.amazon.com/redshift/latest/dg/federated-overview.html) | [Fabric SQL Database](/fabric/database/sql/overview/), [Amazon Redshift connector in Dataflow Gen2](/fabric/data-factory/connector-amazon-redshift), [Fabric data pipelines](/fabric/data-factory/create-first-pipeline-with-sample-data), and [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) | Amazon RDS with Amazon Redshift Federated Query enables Amazon Redshift to run SQL queries directly on live RDS data. This setup provides real-time access across operational and analytical stores. <br><br>Fabric SQL Database introduces a SaaS-native SQL engine with autoscaling, built-in governance, and integration with the Fabric platform. Fabric data pipelines support ingestion from Amazon RDS and Amazon Redshift into lakehouses or SQL databases. OneLake shortcuts virtualize external data, such as Azure Data Lake Storage Gen2 and Amazon S3, into Fabric without duplication. |
| [Amazon RDS](https://aws.amazon.com/rds/) with [Amazon Redshift Federated Query](https://docs.aws.amazon.com/redshift/latest/dg/federated-overview.html) | [Azure SQL Database](https://azure.microsoft.com/services/sql-database/) | These services support querying across operational databases and data warehouses. SQL Database can integrate with Azure analytics services. In contrast, AWS requires you to combine RDS and Amazon Redshift for cross-service querying capabilities through federated queries. |
| [Amazon Aurora](https://aws.amazon.com/rds/aurora/) with Amazon Redshift integration | [SQL Database in Fabric](/fabric/database/sql/overview/)| Amazon Aurora handles operational data, and Amazon Redshift performs large-scale analytics through federated queries and batch ingestion. Fabric SQL Database provides a managed, autoscaling relational engine that integrates natively with OneLake and Power BI. This setup supports unified analytics and governance. |
| [Amazon Aurora](https://aws.amazon.com/rds/aurora/) with Amazon Redshift integration | [SQL Database Serverless](/azure/azure-sql/database/serverless-tier-overview) | These managed, cloud-native relational databases separate compute from storage, automatically scale resources based on demand, and ensure high availability. Both services use SQL-based engines and extend into cost-efficient solutions for transactional and analytical workloads. SQL Database Serverless automatically pauses during inactivity to optimize cost while providing the full SQL Server engine. |

## Data lake solutions

The following platforms store vast amounts of raw structured and unstructured data in its native format for future processing.

| AWS service | Microsoft service | Analysis |
| ------------- | ----- | -------------- |
| [Amazon S3](https://aws.amazon.com/s3/) | [OneLake](/fabric/onelake/onelake-overview), [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) | Data Lake Storage and Amazon S3 are scalable object storage solutions designed for big data analytics. They support formats like Parquet, comma-separated values (CSV), and JSON. Data Lake Storage is optimized for Azure-native tools, while Amazon S3 integrates with AWS services. <br><br>OneLake unifies structured and unstructured data across clouds into a single, governed lake. With OneLake shortcuts, Fabric can virtualize data from Amazon S3, Data Lake Storage, and Google Cloud without duplication, which supports access and analytics. OneLake supports multicloud flexibility, zero-ETL integration, and Delta Lake. |
| [AWS Lake Formation](https://aws.amazon.com/lake-formation/) | [OneLake](/fabric/onelake/onelake-overview) | AWS Lake Formation manages data lakes within the AWS ecosystem. OneLake provides a SaaS-native data lake that supports all Fabric workloads, including lakehouses, warehouses, Real-Time Intelligence, and Power BI. OneLake requires no extra setup and includes built-in governance through Microsoft Purview. It also has native support for Delta Lake and shortcuts for multicloud virtualization, including Amazon S3. | 
| [Amazon Athena](https://aws.amazon.com/athena/)   | [Fabric lakehouse](/fabric/data-engineering/lakehouse-overview/) | Amazon Athena is a serverless query engine that enables real-time SQL analysis directly on data stored in Amazon S3. A Fabric lakehouse provides an integrated environment for both data engineering and analytics. It stores data in OneLake by using the Delta Lake format, and supports Spark, T-SQL, and Python. |
| [AWS Glue Data Catalog](https://aws.amazon.com/glue/) | [Microsoft Purview](https://www.microsoft.com/security/business/risk-management/microsoft-purview-data-governance/) | AWS Glue Data Catalog centralizes metadata for analytics and machine learning. It serves as a metadata store and schema registry and requires other services to manage lineage, policy, and governance. <br><br>Microsoft Purview is a unified data governance service that spans Azure, OneLake, and on-premises and multicloud environments. It catalogs data in OneLake, Data Lake Storage, and other sources. It provides data classification, lineage visualization, policy management, and glossary integration through its Unified Catalog. From a data lake perspective, Microsoft Purview delivers a governance-first approach by connecting metadata, security, and compliance in one platform. |

## Big data analytics

These services process and analyze large and complex datasets to uncover patterns, insights, and trends. The following table provides direct comparisons of individual big data services. Fabric is an all-in-one service for big data and analytics. It provides the following services and more.

| AWS service | Microsoft service | Analysis |
| ------------- | ----- | -------------- |
| [Amazon EMR](https://aws.amazon.com/emr/) | [Fabric Data Engineering workloads](/fabric/data-engineering/data-engineering-overview/) that use [Spark](/fabric/data-engineering/runtime/) | Amazon EMR is a managed big data service that runs frameworks like Spark, Hadoop, and Hive. You must provision and tune clusters. The Fabric Data Engineering workload uses Spark to remove the need for cluster management. It provides a serverless, integrated, and governed experience within the Fabric ecosystem. |
| [Amazon EMR](https://aws.amazon.com/emr/) | [Azure Databricks](/azure/databricks/introduction/) | These services support big data processing via Spark in a managed environment. Amazon EMR runs Spark clusters and provides flexible configuration and scaling options. Azure Databricks provides an optimized Spark platform that includes collaborative notebooks and integrated workflows. |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/) | [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) | These services provide real-time data streaming and analytics for processing and analyzing high-volume data streams. |
| [AWS Glue with AWS Glue Studio](https://aws.amazon.com/glue/) | [Fabric Data Engineering workloads](/fabric/data-engineering/data-engineering-overview/) that use [Spark](/fabric/data-engineering/runtime/) | AWS Glue Studio combined with Amazon Kinesis provides data integration and real-time streaming pipelines, but it requires managing data movement between services. Fabric Data Engineering workloads use Spark to deliver these capabilities directly into the Fabric platform. Batch and streaming transformations, orchestration, and governance integrate with OneLake, Purview, and Power BI. Fabric delivers a single experience for data integration and engineering, without management of separate services for ETL, streaming, and analytics. |
| [AWS Glue with AWS Glue Studio](https://aws.amazon.com/glue/) | [Azure Databricks](/azure/databricks/introduction/) and [Data Factory](/azure/data-factory/introduction/) | Both service combinations provide big data processing capabilities that include integrated data transformation and analytics. |

## Business intelligence and reporting

The following services provide data visualization, reporting, and dashboards to help you make informed decisions.

| AWS service | Microsoft service | Analysis |
| ------------- | ----- | -------------- |
| [Amazon Quick Sight](https://aws.amazon.com/quicksight/) | [Power BI](https://powerbi.microsoft.com/) | Power BI and Amazon Quick Sight provide business analytics tools for data visualization and interactive dashboards. |
| [Amazon Managed Grafana](https://aws.amazon.com/grafana/) | [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana/) | These services provide managed Grafana to visualize metrics, logs, and traces across multiple data sources. |
| [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | [External data sharing in Fabric](/fabric/governance/external-data-sharing-overview#supported-fabric-item-types) and [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) | AWS Data Exchange provides a marketplace where your organization can subscribe to and consume external datasets. The service handles licensing and secure delivery. In Fabric, external collaboration is available through OneLake shortcuts and cross-tenant sharing. External data becomes available across Spark, SQL, KQL, and Power BI. |
| [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | [Azure Data Share](https://azure.microsoft.com/services/data-share/) | These services facilitate the secure sharing and exchange of data between organizations. AWS Data Exchange provides a marketplace model. Data Share focuses on cross-tenant data sharing. |
| [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) with Kibana | [Fabric KQL database](/fabric/real-time-intelligence/create-database/) with [Power BI](https://powerbi.microsoft.com/) | Amazon OpenSearch Service with Kibana provides a managed search and analytics platform for indexing, querying, and visualizing large datasets, commonly used for log analytics and observability. Fabric delivers similar capabilities through its KQL database for real-time data exploration, combined with Power BI for interactive reporting. |
| [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) with Kibana | [Azure AI Search](/azure/search/search-what-is-azure-search/), [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/), and dashboards | These services provide real-time data exploration and interactive analytics over large volumes of data. Amazon OpenSearch uses Kibana for search and visualization. AI Search provides intelligent full-text search. Azure Data Explorer uses KQL to power high-performance, real-time analytics with interactive dashboards for visualization. |

## Real-time data processing

The following systems ingest and analyze data as it's generated to provide immediate insights and responses.

| AWS service | Microsoft service | Analysis |
| ---  | ------- |  ---- |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/)  | [Fabric Real-Time Intelligence hub](/fabric/real-time-hub/real-time-hub-overview/), [Fabric eventstream](/fabric/real-time-intelligence/event-streams/overview/) with [Fabric KQL database](/fabric/real-time-intelligence/create-database/) | Amazon Kinesis enables real-time data streaming, ingestion, and processing across services like Amazon S3, Amazon Redshift, and AWS Lambda. Fabric provides streaming architecture with the Real-Time Intelligence hub, which supports ingestion from multiple sources, including Amazon Kinesis, Apache Kafka, Event Hubs, and Google Pub/Sub. Fabric eventstreams manage stream routing, transformation, and alerting. |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/) | [Event Hubs](https://azure.microsoft.com/services/event-hubs/) and [Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) | These services process and analyze data from Internet of Things (IoT) devices in real time. Amazon Kinesis provides streaming ingestion and processing capabilities. Azure provides modular services. Event Hubs handles data ingestion, and Stream Analytics processes the data. | 
| [Amazon Managed Streaming for Kafka (MSK)](https://aws.amazon.com/msk/) | [Fabric eventstream](/fabric/real-time-intelligence/event-streams/overview/) with Kafka endpoints | Amazon MSK is a managed Kafka service in AWS. Fabric eventstreams support Kafka endpoints for publishing and consuming data via the Kafka protocol. These eventstreams can also ingest data directly from Amazon MSK into the Fabric Real‑Time Intelligence hub for downstream processing and analytics, such as with an eventhouse with Power BI. Azure provides both a managed Kafka‑compatible ingestion plane (Event Hubs) and a managed Kafka cluster (Azure HDInsight). Fabric provides an end‑to‑end, real‑time analytics hub that integrates with Kafka. |
| [Amazon MSK](https://aws.amazon.com/msk/) | [Event Hubs for Kafka](/azure/event-hubs/azure-event-hubs-apache-kafka-overview/) | These services provide managed Kafka clusters for creating real-time streaming data pipelines and applications. Event Hubs for Kafka exposes a Kafka‑compatible endpoint, and existing clients can connect with minimal changes. It also supports Kafka streams in Premium and Dedicated tiers. |
| [AWS Lambda](https://aws.amazon.com/lambda/) | [Fabric notebooks](/fabric/data-engineering/author-execute-notebook/) with [Fabric data pipelines](/fabric/data-factory/create-first-pipeline-with-sample-data) for serverless data processing | AWS Lambda is a serverless, event‑driven compute for running code without managing servers. For analytics‑focused, serverless-style processing in Fabric, you can use Fabric notebooks with Azure Data Factory pipelines. Notebooks run managed Spark jobs for data ingestion, cleanup, and transformation. Pipelines orchestrate and schedule those notebooks as part of end‑to‑end data workflows, which provides on‑demand compute and no cluster management inside Fabric. |
| [AWS Lambda](https://aws.amazon.com/lambda/) | [Azure Functions](https://azure.microsoft.com/services/functions/) with Azure API Management for API triggers | These serverless compute platforms run code in response to events and automatically manage the underlying compute resources. Azure Functions delivers the same event‑driven, autoscaling implementation model and commonly pairs with API Management and other Azure triggers. Microsoft also provides a [migration guide from Lambda to Azure Functions](/azure/azure-functions/migration/migrate-aws-lambda-to-azure-functions/) to facilitate parity and code moves. |
| [Amazon DynamoDB streams](https://aws.amazon.com/pm/dynamodb/)  | [Fabric mirroring (Azure Cosmos DB)](/fabric/mirroring/azure-cosmos-db/) with [Fabric eventstreams](/fabric/real-time-intelligence/event-streams/overview/) | Amazon DynamoDB streams provide a real-time feed of item-level changes in Amazon DynamoDB tables, which enables event-driven processing and downstream analytics. In Fabric, mirroring Azure Cosmos DB into OneLake for analytics eliminates ETL overhead. Combine Fabric eventstreams with this setup to route real-time events and integrate with Fabric KQL databases or lakehouses. |
| [Amazon DynamoDB streams](https://aws.amazon.com/pm/dynamodb/)  | [Azure Cosmos DB change feed](/azure/cosmos-db/change-feed) | These services enable real-time data processing by capturing and providing a stream of data modifications. |
| [Amazon ElastiCache with Redis streams](https://aws.amazon.com/elasticache/) | [Azure Cache for Redis with Redis streams](https://azure.microsoft.com/services/cache/) | These services provide managed Redis instances that support Redis streams for real-time data ingestion and processing. |
| [Amazon IoT Analytics](https://aws.amazon.com/iot-analytics/) | [Fabric eventstreams](/fabric/real-time-intelligence/event-streams/overview/) with [Fabric KQL database](/fabric/real-time-intelligence/create-database/) | Amazon IoT Analytics is a managed service that collects, processes, and analyzes IoT device data at scale. Fabric eventstreams ingest IoT telemetry and route it to the Fabric KQL database for real-time querying and analytics. |
| [AWS IoT Analytics](https://aws.amazon.com/iot-analytics/)   | [Azure IoT Hub with Stream Analytics](https://azure.microsoft.com/services/iot-hub/) | These services enable you to process and analyze data from IoT devices in real time. Amazon IoT Analytics provides built-in data storage and analysis capabilities. Azure provides modular services. IoT Hub handles ingestion, and Stream Analytics processes the data. |

## Machine learning services

The following tools and platforms enable the development, training, and deployment of machine learning models.

| AWS service | Microsoft service | Analysis |
| ---  | ------- |  ---- |
| [Amazon SageMaker](https://aws.amazon.com/sagemaker/) | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | Amazon SageMaker is a managed platform for building, training, and deploying machine learning models at scale. Azure provides an equivalent through Machine Learning, an end-to-end managed service that supports data preparation, automated machine learning, model deployment, and machine learning operations. The Fabric Data Science workload provides model development and enrichment. It integrates with Machine Learning for training, GPU acceleration, and enterprise-grade deployment. |
| [AWS deep learning Amazon machine images (AMIs)](https://aws.amazon.com/machine-learning/amis/) | [Data Science virtual machines (VMs)](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines/) with [Machine Learning](https://azure.microsoft.com/services/machine-learning/) | AWS deep learning AMIs provide prebuilt VM images with popular deep learning frameworks, GPU drivers, and libraries to accelerate AI model development. Azure provides a similar experience through Data Science VMs, which come preconfigured with Python, R, Jupyter, and deep learning frameworks like TensorFlow and PyTorch. Combine Machine Learning with Data Science VMs to create a managed platform for training, deployment, and machine learning operations. |
| [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/autopilot/) | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | Amazon SageMaker Autopilot automates the machine learning life cycle by handling data preprocessing, algorithm selection, and hyperparameter tuning with minimal manual effort. The Fabric Data Science workload provides automated machine learning-driven model development and integrates with Machine Learning for training and operationalization. |
| [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/autopilot/) | [Automated machine learning](https://azure.microsoft.com/solutions/automated-machine-learning/) | These services provide automated machine learning for building and training models. |
| [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/)  | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/services/machine-learning/) | Amazon SageMaker Studio is an integrated development environment for machine learning in AWS. It provides a single web-based interface to build, train, and deploy models. The Fabric Data Science workload combines collaborative notebooks and Spark-based environments into a unified analytics platform and integrates with Machine Learning for training and deployment. |
| [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/studio/)  | [Azure Machine Learning studio](https://azure.microsoft.com/services/machine-learning/) | These services provide integrated development environments for machine learning. Amazon SageMaker Studio provides a unified interface for all machine learning development steps, including debugging and profiling tools. |

## AI services

AI services provide prebuilt, customizable AI capabilities for applications, including vision, speech, language, and decision making capabilities.

| AWS service | Azure service | Analysis |
|  -------  | ------  |--|
| [Amazon Rekognition](https://aws.amazon.com/rekognition/)               | [Azure AI Vision](/azure/ai-services/computer-vision/overview/) with [Azure AI Custom Vision](/azure/ai-services/custom-vision-service/overview/)  | Amazon Rekognition is a computer vision service for image and video analysis. It provides object detection, facial recognition, and text extraction. Azure AI Vision delivers prebuilt models for image and video understanding. You can use Custom Vision to train domain-specific models with your own data. |
| [Amazon Polly](https://aws.amazon.com/polly/) | [Azure AI Speech text-to-speech](https://azure.microsoft.com/products/ai-services/ai-speech) | Amazon Polly is a text-to-speech service that converts text into lifelike speech by using neural voices across multiple languages. AI Speech text-to-speech provides high-quality neural voices, real-time streaming, and batch synthesis for applications such as voice assistants, interactive voice response (IVR) systems, and accessibility solutions. AI Speech also supports custom neural voice creation to build unique, brand-specific voices while maintaining enterprise-grade security and compliance. | 
| [Amazon Transcribe](https://aws.amazon.com/transcribe/) | [Azure AI Speech speech-to-text](https://azure.microsoft.com/products/ai-services/ai-speech/) | Amazon Transcribe provides speech-to-text with real-time transcription and custom vocabularies, commonly used for call analytics and captions. AI Speech speech-to-text provides real-time and batch transcription, speaker diarization, and custom models for domain-specific accuracy. |
| [Amazon Translate](https://aws.amazon.com/translate/) | [Azure AI Translator](https://azure.microsoft.com/products/ai-services/ai-translator) | Amazon Translate is a neural machine translation service that delivers translations across multiple languages for websites, apps, and multilingual content. Azure AI Translator provides similar capabilities with real-time and batch translation in more than 100 languages. It also includes features like transliteration, language detection, and custom glossaries for domain-specific accuracy. |
| [Amazon Comprehend](https://aws.amazon.com/comprehend/) | [Azure AI Language](https://azure.microsoft.com/products/ai-services/ai-language) | Amazon Comprehend is a natural language processing (NLP) service that extracts insights from text, including sentiment, key phrases, and entities. These capabilities help analyze customer feedback and documents. Azure AI Language (text analytics) provides similar capabilities with features like sentiment analysis, key phrase extraction, named entity recognition, and custom text classification. |
| [Amazon Lex](https://aws.amazon.com/lex/) | [Conversational language understanding in Microsoft Foundry](/azure/ai-services/language-service/conversational-language-understanding/overview) | These services create conversational interfaces that use natural language understanding. Azure takes a modular approach, where conversational language understanding handles intent recognition and entity extraction. Other components manage dialogue and integration. Amazon Lex provides an integrated solution for building conversational interfaces entirely within the AWS ecosystem. |
| [Amazon Textract](https://aws.amazon.com/textract/) | [Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence/) | Amazon Textract is a machine learning service that extracts text and data from scanned documents, including tables and forms, to automate document processing. Document Intelligence provides similar functionality with optical character recognition (OCR), prebuilt models for invoices, receipts and IDs, and the ability to train custom models for domain-specific forms. Document Intelligence supports multi-language extraction and provides layout analysis for complex documents. |
| [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) | [AI Search](https://azure.microsoft.com/products/ai-services/ai-search/) | Amazon OpenSearch Service is a managed search and analytics engine based on Elasticsearch, commonly used for log analytics, full-text search, and real-time data exploration. AI Search provides similar capabilities with built-in AI enrichment, hybrid search (keyword with vector), and integration with Azure services for security and compliance. It supports scenarios like semantic search and retrieval-augmented generation (RAG). |

## Generative AI services

The following AI services create new content or data that resembles human-generated output, like text, images, or audio.

| AWS service | Azure service | Analysis |
| ----  | --------  | ------  |
| [Amazon Bedrock](https://aws.amazon.com/bedrock/) | [Microsoft Foundry](https://azure.microsoft.com/products/ai-foundry/) | These services provide foundation models to create and deploy generative AI applications. |

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Regina Hackenberg](https://www.linkedin.com/in/reginahackenberg/) | Senior Technical Specialist

Other contributor:

- [Filipa Lobão](https://www.linkedin.com/in/filipalobao) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Fabric](/fabric/)
- [Microsoft Purview](/purview/purview)

## Related resources

- [Choose an Azure AI services technology](../data-guide/technology-choices/ai-services.md)
- [Compare Microsoft machine learning products and technologies](../ai-ml/guide/data-science-and-machine-learning.md)
