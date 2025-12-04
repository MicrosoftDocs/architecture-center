---
title: Google Cloud to Azure services comparison
description: Compare Google Cloud and Microsoft Azure services. Not every Google Cloud service or Azure service is listed, and not every matched service has exact feature parity.
author: ZacharyRiffle
ms.author: zriffle
ms.date: 07/11/2024
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - gcp-to-azure
---

# Google Cloud to Azure services comparison

This article helps you understand how Microsoft Azure services compare to Google Cloud. (Note that Google Cloud used to be called the Google Cloud Platform (GCP).) Whether you are planning a multi-cloud solution with Azure and Google Cloud, or migrating to Azure, you can compare the IT capabilities of Azure and Google Cloud services in all the technology categories.

This article compares services that are roughly comparable. Not every Google Cloud service or Azure service is listed, and not every matched service has exact feature-for-feature parity.

For an overview of Azure for Google Cloud users, see the introduction to [Azure for Google Cloud Professionals](./index.md).

## Marketplace

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Google Cloud Marketplace](https://cloud.google.com/marketplace) | [Azure Marketplace](https://azure.microsoft.com/marketplace/) | Preconfigured third-party applications that can be deployed to single or multiple virtual machines. |

## Data platform

### Database

| Type | Google Cloud service | Azure service | Azure service description |
| --- | --- | --- | --- |
| Relational database | [Cloud SQL](https://cloud.google.com/sql#documentation) - SQL Server | [Azure SQL family](/azure/azure-sql)</br></br> Azure SQL Database</br>Azure SQL Managed Instance</br>SQL Server on Azure VM</br> [Azure SQL Edge](/azure/azure-sql-edge) | Azure SQL family of SQL Server database engine products in the cloud</br></br>Azure SQL Database is a fully managed platform as a service (PaaS) database engine</br></br> Azure SQL Managed Instance is the intelligent, scalable cloud database service</br> that combines the broadest SQL Server database engine compatibility with all the benefits of a fully managed and evergreen platform as a service</br></br> SQL Server IaaS deployed on Azure Windows or Linux VM </br></br>Azure SQL Edge is an optimized relational database engine geared for IoT and edge deployments |
|| [Cloud SQL](https://cloud.google.com/sql#documentation) MySQL & PostgreSQL| [Azure Database for MySQL (Single & Flexible Server)](/azure/mysql/)<br/><br/> [Azure Database for PostgreSQL (Single & Flexible Server)](/azure/postgresql)<br/><br/> | Managed relational database service where resiliency, security, scale, and maintenance are primarily handled by the platform |
|Horizontally scalable relational database|[Cloud Spanner](https://cloud.google.com/spanner) | [Azure Cosmos DB for NoSQL](https://azure.microsoft.com/services/cosmos-db)<br/><br/> | A globally distributed database system that scales horizontally. Is multi-modal -- key-value, graph, and document data). Supports multiple APIs: SQL, JavaScript, Gremlin, MongoDB, and Azure Table storage. Compute and storage can be scaled independently |
|||[Azure Cosmos DB for PostgreSQL (Citus)](/azure/cosmos-db/postgresql/introduction) | Azure Database for PostgreSQL is a fully managed database-as-a-service based on the open-source Postgres relational database engine. The Hyperscale (Citus) deployment option scales queries across multiple machines using sharding, to serve applications that require greater scale and performance |
|NoSQL| [Cloud Bigtable](https://cloud.google.com/bigtable/docs)<br/><br/> | [Azure Table storage](/azure/storage/tables)|A highly scalable NoSQL key-value store for rapid development using massive semi-structured datasets. Store semi-structured data that's highly available. Supporting flexible data schema and OData-based queries |
|| [Cloud Firestore](https://cloud.google.com/firestore/docs) |[Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) | Globally distributed, multi-model database that natively supports multiple data models: key-value, documents, graphs, and columnar |
||[Firebase Realtime Database](https://firebase.google.com/products/realtime-database) | [Azure Cosmos DB change feed](/azure/cosmos-db/change-feed) | Change feed in Azure Cosmos DB is a persistent record of changes to a container in the order they occur. Change feed works by listening to an Azure Cosmos DB container for any changes. It then outputs the sorted list of documents that were changed in the order in which they were modified. The persisted changes can be processed asynchronously and incrementally, and the output can be distributed across one or more consumers for parallel processing |
| In-memory | [Cloud Memorystore](https://cloud.google.com/memorystore/docs) | [Azure Managed Redis](https://azure.microsoft.com/products/managed-redis/) | A secure data cache and messaging broker that provides high throughput and low-latency access to data for applications |

### Data warehouse

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [BigQuery](https://cloud.google.com/bigquery) | [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)<br/><br/> [SQL Server Big Data Clusters](/sql/big-data-cluster/big-data-cluster-overview?view=sql-server-ver15&preserve-view=true) <br/><br/> [Azure Databricks](https://azure.microsoft.com/services/databricks) | Cloud-based Enterprise Data Warehouse (EDW) that uses Massively Parallel Processing (MPP) to quickly run complex queries across petabytes of data.<br/><br/><br/> Allow you to deploy scalable clusters of SQL Server, Spark, and HDFS containers running on Kubernetes. These components are running side by side to enable you to read, write, and process big data from Transact-SQL or Spark, allowing you to combine and analyze relational data with high-volume big data. |

#### Data warehouse architectures

| Architecture | Description |
|----|----|
| [Databases architecture design](/azure/architecture/databases) | Overview of the Azure database solutions described in Azure Architecture Center. |

[view all](../browse/index.yml?azure_categories=databases)

### Data orchestration and ETL

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Data Fusion](https://cloud.google.com/data-fusion) | [Azure Data Factory](https://azure.microsoft.com/services/data-factory)<br/><br/>  [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) | Processes and moves data between different compute and storage services, as well as on-premises data sources at specified intervals. Create, schedule, orchestrate, and manage data pipelines.

## Big data and analytics

### Big data processing

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Dataproc](https://cloud.google.com/dataproc) | [Azure HDInsight](/azure/hdinsight) <br><br> [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) <br><br> [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) <br><br> [Microsoft Fabric Data Engineering](/fabric/data-engineering/data-engineering-overview)| Managed Apache Spark-based analytics platform. |

#### Big data architectures

| Architecture | Description |
|----|----|
| [Azure data platform end-to-end](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end) | Use Azure services to ingest, process, store, serve, and visualize data from different sources. |
| [Analytics architecture design](/azure/architecture/solution-ideas/articles/analytics-start-here) | Use analytics solutions to turn volumes of data into useful business intelligence, such as reports and visualizations, and inventive AI, such as forecasts based on machine learning. |

[view all](../browse/index.yml?azure_categories=databases)

### Analytics and visualization

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Dataflow](https://cloud.google.com/dataflow) | [Azure Databricks](https://azure.microsoft.com/services/databricks/#documentation) <br><br> [Azure HDInsight](/azure/hdinsight)| Managed platform for streaming and batch data processing using Apache Beam |
| [Data Studio](https://datastudio.google.com/overview) <br/><br/> [Looker](https://cloud.google.com/looker) | [Power BI](https://powerbi.microsoft.com) | Business intelligence tools that build visualizations, perform ad hoc analysis, and develop business insights from data. |
| [Cloud Search](https://cloud.google.com/products/search) | [Azure AI Search](https://azure.microsoft.com/services/search) | Delivers full-text search and related search analytics and capabilities. |
| [BigQuery](https://cloud.google.com/bigquery) | [SQL Server Analysis Services](/analysis-services/analysis-services-overview) | Provides a serverless non-cloud interactive query service that uses standard SQL for analyzing databases. |

#### Analytics architectures

| Architecture | Description |
|----|----|
| [Databases architecture design](/azure/architecture/databases) | Overview of the Azure database solutions described in Azure Architecture Center. |

[view all](../browse/index.yml?azure_categories=analytics)

### Time series & IoT data

| Google Cloud service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [BigQuery](https://cloud.google.com/bigquery) | [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer)<br/><br/> [Azure Time Series Insights](https://azure.microsoft.com/services/time-series-insights)<br/><br/> [Azure Cosmos DB](/azure/stream-analytics/stream-analytics-solution-patterns)<br><br> [Microsoft Fabric Real Time Intelligence](/fabric/real-time-hub/real-time-hub-overview)| Fully managed, low latency, and distributed big data analytics platform that runs complex queries across petabytes of data. Highly optimized for log and time series data. <br/><br/> Open and scalable end-to-end IoT analytics service. Collect, process, store, query, and visualize data at Internet of Things (IoT) scale--data that's highly contextualized and optimized for time series.


#### Time series architecture

| Architecture | Description |
|----|----|
| [IoT analytics with Azure Data Explorer](/azure/architecture/solution-ideas/articles/iot-azure-data-explorer) | IoT telemetry analytics with Azure Data Explorer demonstrates near real-time analytics over a fast flowing, high volume, wide variety of streaming data from IoT devices. |

## AI and machine learning

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [:::no-loc text="Vertex AI":::](https://cloud.google.com/vertex-ai) | [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning-services) | A cloud service to train, deploy, automate, and manage machine learning and foundation models, with notebook, designer, and automate options. |
| [TensorFlow](https://www.tensorflow.org) | [ML.NET](https://dotnet.microsoft.com/apps/machinelearning-ai/ml-dotnet) | ML.NET is an open source and cross-platform machine learning framework for both machine learning & AI. |
| [TensorFlow](https://www.tensorflow.org/) | [ONNX (Open Neural Network Exchange)](https://onnx.ai) | ONNX is an open format built to represent machine learning models that facilitate maximum compatibility and increased inference performance. |
| [Cloud Vision API - Computer Vision](https://cloud.google.com/vision) | [Azure AI Services Computer Vision](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-computer-vision/) | Use visual data processing to enable computers to identify and understand objects and people in images and videos, label content, from objects to concepts, extract printed and handwritten text, recognize familiar subjects like brands and landmarks, and moderate content. |
| [Natural Language AI](https://cloud.google.com/natural-language) | [Azure AI Language](https://azure.microsoft.com/services/cognitive-services/text-analytics) | Azure AI Language is a managed service for developing natural language processing applications. Identify key terms and phrases, analyze sentiment, summarize text, and build conversational interfaces. |
| [Natural Language AI](https://cloud.google.com/natural-language) | [Azure AI services conversational language understanding](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service) | A feature of AI Language that uses natural language understanding (NLU) so people can interact with your apps, bots, and IoT devices.|
| [Speech-to-Text](https://cloud.google.com/speech-to-text) | [Azure AI services speech to text](https://azure.microsoft.com/services/cognitive-services/speech-to-text) | Transcribe audio to text in more than 100 languages and variants. Customize models to enhance accuracy for domain-specific terminology. |
| [AutoML Tables – Structured Data](https://cloud.google.com/automl-tables) | [ML.NET Model Builder](https://dotnet.microsoft.com/apps/machinelearning-ai/ml-dotnet/model-builder) | ML.NET Model Builder provides a visual interface to build, train, and deploy custom machine learning models. Prior machine learning expertise isn't required. Model Builder supports AutoML, which automatically explores different machine learning algorithms and settings to help you find the one that best suits your scenario. |
| [AutoML Vision](https://cloud.google.com/automl) | [Azure AI Custom Vision](https://azure.microsoft.com/products/ai-services/ai-custom-vision) | Customize and embed computer vision models for specific domains. Example use cases include customer experience, manufacturing, and marketing. No machine learning expertise is required. |
| [AutoML Video Intelligence](https://cloud.google.com/video-intelligence) | [Azure Video Indexer](https://vi.microsoft.com) | Extract insights from your videos and enrich applications to enhance discovery and engagement. |
| [Dialogflow](https://cloud.google.com/dialogflow) | [Azure AI Language Question Answering](/azure/ai-services/language-service/question-answering/overview) | Build, train and publish a sophisticated bot using FAQ pages, support websites, product manuals, SharePoint documents or editorial content through a graphical user interface or via REST APIs. |
| [AI Platform Notebooks](https://cloud.google.com/ai-platform-notebooks) | [Azure Notebooks](https://notebooks.azure.com) | Develop and run code from anywhere with Jupyter notebooks on Azure. |
| [Deep Learning VM Image](https://cloud.google.com/deep-learning-vm) | [Data Science Virtual Machines](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines) | Preconfigured environments in the cloud for Data Science and AI Development. |
| [Deep Learning Containers](https://cloud.google.com/ai-platform/deep-learning-containers) | [GPU support on Azure Kubernetes Service (AKS)](/azure/aks/gpu-cluster) | Graphical processing units (GPUs) are often used for compute-intensive workloads such as graphics, visualization workloads, and AI inferencing. AKS supports the creation of GPU-enabled node pools to run these compute-intensive workloads in Kubernetes. |
| [Data Labeling Service](https://cloud.google.com/ai-platform/data-labeling/docs) | [Azure ML - Data Labeling](/azure/machine-learning/how-to-create-labeling-projects) | A central place to create, manage, and monitor labeling projects (public preview). Use it to coordinate data, labels, and team members to efficiently manage labeling tasks. Machine Learning supports image classification, either multi-label or multi-class, and object identification with bounded boxes. |
| [AI Platform Training](https://cloud.google.com/ai-platform/training/docs/overview) | [Azure ML – Compute Targets](/azure/machine-learning/concept-compute-target) | Designated compute resource/environment where you run your training script or host your service deployment. This location might be your local machine or a cloud-based compute resource. Using compute targets lets you later change your compute environment without changing your code. |
| [AI Platform Predictions](https://cloud.google.com/ai-platform/prediction/docs/overview) | [Azure ML - Deployments](/azure/machine-learning/tutorial-deploy-model) | Deploy your machine learning model as a web service for making real-time or batch predictions at scale. |
| [Continuous Evaluation](https://cloud.google.com/ai-platform/prediction/docs/continuous-evaluation) | [Azure ML – Data Drift](/azure/machine-learning/how-to-monitor-datasets) | Monitor for data drift between the training dataset and inference data of a deployed model. In the context of machine learning, trained machine learning models might experience degraded prediction performance because of drift. With Azure Machine Learning, you can monitor data drift and the service can send an email alert to you when drift is detected. |
| [Explainable AI](https://cloud.google.com/explainable-ai/) | [Azure ML – Model Interpretability](/azure/machine-learning/how-to-machine-learning-interpretability) | Understand and explain the behaviors of your machine learning models. |
| [Cloud TPU](https://cloud.google.com/tpu) | [FPGA accelerated virtual machines](/azure/virtual-machines/sizes/overview#fpga-accelerated) | Perform AI and machine learning inferencing tasks that are optimized for FPGA programming. FPGAs are based on Intel's FPGA devices. |
| [Vertex AI](https://cloud.google.com/vertex-ai/docs/start/introduction-unified-platform) | [Machine Learning Operations (MLOps)](https://azure.microsoft.com/solutions/machine-learning-ops) | A platform that streamlines the development and deployment of ML models and AI workflows, from data preparation and model training to deployment and monitoring. |
| [Dialogflow](https://cloud.google.com/dialogflow/docs/) | [Microsoft Bot Framework](https://dev.botframework.com) | Help build conversational AI experiences and integrate a conversational user interface. |

### AI and machine learning architectures

| Architecture | Description |
|----|----|
| [Image classification on Azure](/azure/architecture/ai-ml/idea/intelligent-apps-image-processing) | Learn how to build image processing into your applications by using Azure services such as the Computer Vision API and Azure Functions. |

[view all](../browse/index.yml?azure_categories=ai-machine-learning)

## Data catalog & governance

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Dataplex](https://cloud.google.com/dataplex) | [Microsoft Purview](/purview) | Microsoft Purview is a comprehensive portfolio of products spanning data governance, data security, and risk and compliance solutions. |

## Compute

### Virtual servers

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Compute Engine](https://cloud.google.com/compute#documentation) | [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) | Virtual servers allow users to deploy, manage, and maintain OS and server software. Instance types provide combinations of CPU/RAM. Users pay for what they use with the flexibility to change sizes. |
| [Sole-tenant nodes](https://cloud.google.com/compute/docs/nodes/sole-tenant-nodes) | [Azure Dedicated Host](https://azure.microsoft.com/services/virtual-machines/dedicated-host) | Host your VMs on hardware that's dedicated only to your project. |
| [Batch](https://cloud.google.com/batch/docs/get-started) | [Azure Batch](https://azure.microsoft.com/services/batch) | Run large-scale parallel and high-performance computing applications efficiently in the cloud. |
| [Compute Engine Autoscaler](https://cloud.google.com/compute/docs/autoscaler) <br/><br/>[Compute Engine managed instance groups](https://cloud.google.com/compute/docs/instance-groups) | [Azure virtual machine scale sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview) | Allows you to automatically change the number of VM instances. You set defined metric and thresholds that determine if the platform adds or removes instances. |
| [Cloud GPUs](https://cloud.google.com/gpu) | [GPU Optimized VMs](/azure/virtual-machines/sizes-gpu) | GPU-optimized VM sizes are specialized virtual machines that are available with single, multiple, or fractional GPUs. The sizes are designed for compute-intensive, graphics-intensive, and visualization workloads. |
| [VMware Engine](https://cloud.google.com/vmware-engine) | [Azure VMware Solution](https://azure.microsoft.com/services/azure-vmware) | Redeploy and extend your VMware-based enterprise workloads to Azure with Azure VMware Solution. Migrate VMware-based workloads from your datacenter to Azure and integrate your VMware environment with Azure. Continue managing existing environments with the same VMware tools while you modernize applications with Azure services. Azure VMware Solution is a Microsoft service verified by VMware and runs on Azure infrastructure. |

### Containers and container orchestrators

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Run](https://cloud.google.com/run#documentation) | [Azure Container Apps](https://azure.microsoft.com/products/container-apps) | Azure Container Apps is a service for running containers in Azure without provisioning virtual machines or adopting a higher-level orchestration service. |
| [Artifact Registry (beta)](https://cloud.google.com/artifacts/docs) <br/><br/> [Container Registry](https://cloud.google.com/container-registry/docs) | [Azure Container Registry](https://azure.microsoft.com/services/container-registry) | Allows customers to store Docker formatted images. Used to create all types of container deployments on Azure. |
| [Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine#documentation) | [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) | Deploy orchestrated containerized applications with Kubernetes. Provides cluster management and monitoring, including automatic upgrades and an operations console. See [AKS solution journey](../reference-architectures/containers/aks-start-here.md). |
| [Kubernetes Engine Monitoring](https://cloud.google.com/monitoring/kubernetes-engine) | [Azure Monitor container insights](/azure/azure-monitor/insights/container-insights-overview) | Azure Monitor container insights is a feature designed to monitor the performance of container workloads deployed to: Managed Kubernetes clusters hosted on Azure Kubernetes Service (AKS); Azure Container Instances, Self-managed Kubernetes clusters hosted on [Azure Stack](/azure-stack/user/azure-stack-kubernetes-aks-engine-overview) or on-premises; or [Azure Red Hat OpenShift](/azure/openshift/intro-openshift). |

#### Container architectures

Here are some architectures that use AKS as the orchestrator.

| Architecture | Description |
|----|----|
| [Baseline architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks/baseline-aks) | Deploy a baseline infrastructure that deploys an AKS cluster with focus on security. |
| [Microservices architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices) | Deploy a microservices architecture on Azure Kubernetes Service (AKS). |
| [CI/CD for AKS apps with GitHub Actions and GitFlow](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops) | This architecture is applicable to businesses that want to modernize end-to-end application development by using containers, continuous integration for build, and GitOps for continuous deployment. |

[view all](../browse/index.yml?azure_categories=containers)

### Functions

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Functions](https://cloud.google.com/functions/#documentation) | [Azure Functions](https://azure.microsoft.com/services/functions) | Integrate systems and run backend processes in response to events or schedules without provisioning or managing servers. |

#### Serverless architectures

| Architecture | Description |
|----|----|
| [Cross-cloud scaling pattern](/azure/adaptive-cloud/app-solutions/pattern-cross-cloud-scale) | Learn how to improve cross-cloud scalability with solution architecture that includes Azure Stack. A step-by-step flowchart details instructions for implementation. |

## DevOps and application monitoring

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Provides a solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing and identifies issues affecting them and the resources on which they depend. |
| [Cloud Trace](https://cloud.google.com/trace) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Provides a solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing and identifies issues affecting them and the resources on which they depend. |
| Snapshot Debugger (Cloud Debugger deprecated) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) (Azure Monitor) | Azure Monitor Application Insights, a feature of Azure Monitor, excels in Application Performance Management (APM) for live web applications. It helps you understand how your applications are performing and proactively identifies issues affecting them and the resources on which they depend. |
| [Cloud Profiler](https://cloud.google.com/profiler/docs/) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) (Azure Monitor) | Azure Monitor Application Insights, a feature of Azure Monitor, excels in Application Performance Management (APM) for live web applications. It helps you understand how your applications are performing and proactively identifies issues affecting them and the resources on which they depend. |
| [Cloud Source Repositories](https://cloud.google.com/source-repositories) | [Azure Repos](https://azure.microsoft.com/services/devops/repos), [GitHub Repos](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/about-repositories) | A cloud service for collaborating on code development. |
| [Cloud Build](https://cloud.google.com/build) | [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines/?nav=min), [GitHub Actions](https://github.com/features/actions) | Fully managed build service that supports continuous integration and deployment. |
| [Artifact Registry](https://cloud.google.com/artifact-registry/docs/overview) | [Azure Artifacts](https://azure.microsoft.com/services/devops/artifacts), [GitHub Packages](https://github.com/features/packages) | Add fully integrated package management to your continuous integration/continuous delivery (CI/CD) pipelines with a single click. Create and share Maven, npm, NuGet, and Python package feeds from public and private sources with teams of any size. |
| [Cloud Developer Tools](https://cloud.google.com/products/tools) (including Cloud Code) | [Azure Developer Tools](https://azure.microsoft.com/resources/developers/) | Collection of tools for building, debugging, deploying, diagnosing, and managing multiplatform scalable apps and services. |
| [gcloud SDK](https://cloud.google.com/sdk) | [Azure SDKs and Tools](https://azure.microsoft.com/downloads/) | The Azure SDKs are collections of libraries built to make it easier to use Azure services from your language of choice. These libraries are designed to be consistent, approachable, diagnosable, dependable, and idiomatic. The Azure command-line interface (CLI) is a set of commands used to create and manage Azure resources. The Azure CLI is available across Azure services and is designed to get you working quickly with Azure, with an emphasis on automation. |
| [Cloud Shell](https://cloud.google.com/shell) | [Azure Cloud Shell](/azure/cloud-shell/overview) | Azure Cloud Shell is an interactive, authenticated, browser-accessible shell for managing Azure resources. It provides the flexibility of choosing the shell experience that best suits the way you work, either Bash or PowerShell. |
| [PowerShell on Google Cloud](https://cloud.google.com/tools/powershell/docs/quickstart) | [Azure PowerShell](/powershell/azure/?view=azps-3.7.0&preserve-view=true) | Azure PowerShell is a set of cmdlets for managing Azure resources directly from the PowerShell command line. Azure PowerShell is designed to be approachable and includes features for automation. Azure PowerShell works all [platforms that support PowerShell version 7 or higher](/powershell/scripting/install/PowerShell-Support-Lifecycle#supported-platforms). |
| [Cloud Deployment Manager](https://cloud.google.com/deployment-manager) | [Azure Marketplace](https://azuremarketplace.microsoft.com) | The Marketplace is a catalog of software offerings validated to run on Azure. |
| [Cloud Deployment Manager](https://cloud.google.com/deployment-manager) | [Azure Resource Manager](https://azure.microsoft.com/features/resource-manager/) | Provides a way for users to automate the manual, long-running, error-prone, and frequently repeated IT tasks. |

### DevOps architectures

| Architecture | Description |
|----|----|
| [CI/CD for AKS apps with GitHub Actions and GitFlow](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops) | This architecture is applicable to businesses that want to modernize end-to-end application development by using containers, continuous integration for build, and GitOps for continuous deployment. |

[view all](../browse/index.yml?azure_categories=devops)

## Internet of things (IoT)

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud IoT Core](https://cloud.google.com/iot/docs) | [Azure Event Grid MQTT broker](/azure/event-grid/mqtt-overview)<br><br> [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) | Gateways for managing bidirectional communication with IoT devices, securely and at scale. |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | See [Messaging and eventing](#messaging-and-eventing) section | Process and route streaming data to a subsequent processing engine or to a storage or database platform. |
| [Edge TPU](https://cloud.google.com/edge-tpu) | [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge)<br><br> [Azure IoT Operations](/azure/iot-operations/) | Deploy cloud intelligence directly on IoT devices to run in on-premises scenarios. |

### IoT architectures

| Architecture | Description |
|----|----|
| [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot) | A recommended architecture for IoT applications on Azure by using platform as a service (PaaS) components. |

[view all](../browse/index.yml?azure_categories=iot)

## Management

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Billing](https://cloud.google.com/billing/docs) | [Azure Billing API](/azure/billing/billing-usage-rate-card-overview) | Services to help generate, monitor, forecast, and share billing data for resource usage by time, organization, or product resources. |
| [Cloud Console](https://cloud.google.com/cloud-console) | [Azure portal](https://azure.microsoft.com/features/azure-portal) | A unified management console that simplifies building, deploying, and operating your cloud resources. |
| [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [Cost Management](https://cloud.google.com/cost-management) | [Microsoft Cost Management](https://azure.microsoft.com/pricing/details/cost-management) | Microsoft Cost Management helps you understand your Azure invoice, manage your billing account and subscriptions, control Azure spending, and optimize resource use. |

## Messaging and eventing

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Service Bus](https://azure.microsoft.com/services/service-bus) | Supports a set of cloud-based, message-oriented middleware technologies including reliable message queuing and durable publish/subscribe messaging. |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Event Grid](https://azure.microsoft.com/services/event-grid) | A fully managed event routing service that allows for uniform event consumption using a publish/subscribe model. |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) | A real-time data ingestion and microbatching service used to build dynamic data pipelines and integrates with other Azure services. |

### Messaging architectures

| Architecture | Description |
|----|----|
| [Scalable web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant) | Use the proven practices in this reference architecture to improve scalability and performance in an Azure App Service web application. |
| [Enterprise integration by using queues and events](/azure/architecture/example-scenario/integration/queues-events) | A recommended architecture for implementing an enterprise integration pattern with Azure Logic Apps, Azure API Management, Azure Service Bus, and Azure Event Grid. |

## Networking

| Area | Google Cloud service | Azure service | Description |
| --- | --- | --- | --- |
| Cloud virtual networking | [Virtual Private Network (VPC)](https://cloud.google.com/vpc) | [Azure Virtual Network (Vnet)](/azure/virtual-network/virtual-networks-overview) | Provides an isolated, private environment in the cloud. Users have control over their virtual networking environment, including selection of their own IP address range, adding/updating address ranges, creation of subnets, and configuration of route tables and network gateways. |
| DNS management | [Cloud DNS](https://cloud.google.com/dns) | [Azure DNS](/azure/dns/dns-overview) | Manage your DNS records using the same credentials that are used for billing and support contract as your other Azure services |
| | [Cloud DNS](https://cloud.google.com/dns) | [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) | Azure Traffic Manager is a DNS-based load balancer that enables you to distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness. |
| | [Internal DNS](https://cloud.google.com/compute/docs/internal-dns) | [Azure Private DNS](/azure/dns/private-dns-overview) | Manages and resolves domain names in the virtual network, without the need to configure a custom DNS solution, and it provides a naming resolution for virtual machines (VMs) within a virtual network and any connected virtual networks. |
| Hybrid Connectivity | [Cloud Interconnect](https://cloud.google.com/interconnect/docs) | [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) | Establishes a private network connection from a location to the cloud provider (not over the Internet). |
| | [Cloud VPN Gateway](https://cloud.google.com/vpn/docs/concepts/overview) | [Azure Virtual Network Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) | Connects Azure virtual networks to other Azure virtual networks, or customer on-premises networks (site-to-site). Allows end users to connect to Azure services through VPN tunneling (point-to-site). |
| | [Cloud VPN Gateway](https://cloud.google.com/vpn/docs/concepts/overview) | [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about) | Azure virtual WAN simplifies large-scale branch connectivity with VPN and ExpressRoute. |
| | [Cloud router](https://cloud.google.com/router/docs) | [Azure Virtual Network Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) | Enables dynamic routes exchange using BGP. |
| Load balancing | [Network Load Balancing](https://cloud.google.com/load-balancing) | [Azure Load Balancer](/azure/load-balancer/load-balancer-overview) | Azure Load Balancer load-balances traffic at layer 4 (all TCP or UDP). |
| | [Cloud Load Balancing](https://cloud.google.com/load-balancing) | [Azure Front Door](/azure/frontdoor/front-door-overview) | Azure Front Door enables global load balancing across regions using a single anycast IP. |
| | [Cloud Load Balancing](https://cloud.google.com/load-balancing) | [Azure Application Gateway](/azure/application-gateway/overview) | Application Gateway is a layer 7 load balancer. It takes backends with any IP that is reachable. It supports SSL termination, cookie-based session affinity, and round robin for load-balancing traffic. |
| | [Cloud Load Balancing](https://cloud.google.com/load-balancing) | [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) | Azure Traffic Manager is a DNS-based load balancer that enables you to distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness. |
| Content delivery network | [Cloud CDN](https://cloud.google.com/cdn) | [Azure CDN](/azure/cdn/cdn-overview) | A content delivery network (CDN) is a distributed network of servers that can efficiently deliver web content to users. |
| Firewall | [Firewall rules](https://docs.cloud.google.com/firewall/docs/firewalls) | [Application security groups](/azure/virtual-network/application-security-groups) | Azure Application security groups allow you to group virtual machines and define network security policies based on those groups. |
| | [Firewall rules](https://docs.cloud.google.com/firewall/docs/firewalls) | [Network Security groups](/azure/virtual-network/security-overview) | Azure network security group filters network traffic to and from Azure resources in an Azure virtual network. |
| | [Firewall rules](https://docs.cloud.google.com/firewall/docs/firewalls) | [Azure Firewall](/azure/firewall/overview) | Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. |
| Web Application Firewall | [Cloud Armor](https://cloud.google.com/armor) | [Application Gateway - Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) | Azure Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities. |
| | [Cloud Armor](https://cloud.google.com/armor) | [Front door – Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview) | Azure Web Application Firewall (WAF) on Azure Front Door provides centralized protection for your web applications. |
| | [Cloud Armor](https://cloud.google.com/armor) | [CDN – Azure Web Application Firewall](/azure/web-application-firewall/cdn/cdn-overview) | Azure Web Application Firewall (WAF) on Azure Content Delivery Network (CDN) from Microsoft provides centralized protection for your web content. |
| NAT Gateway | [Cloud NAT](https://cloud.google.com/nat) | [Azure NAT Gateway](/azure/virtual-network/nat-overview) | NAT Gateway (network address translation) provides outbound NAT translations for internet connectivity for virtual networks. |
| Private Connectivity to PaaS | [Private Service Connect](https://cloud.google.com/vpc/docs/private-service-connect) | [Azure Private Link](/azure/private-link/private-link-overview) | Azure Private Link enables you to access Azure PaaS Services and Azure hosted customer-owned/partner services over a private endpoint in your virtual network. |
| Telemetry | [VPC Flow logs](https://cloud.google.com/vpc/docs/using-flow-logs) | [NSG Flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview) | Network security group (NSG) flow logs are a feature of Network Watcher that allows you to view information about ingress and egress IP traffic through an NSG. |
| | [Firewall Rules Logging](https://docs.cloud.google.com/firewall/docs/firewall-rules-logging) | [NSG Flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview) | Network security group (NSG) flow logs are a feature of Network Watcher that allows you to view information about ingress and egress IP traffic through an NSG. |
| | [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](/azure/azure-monitor/overview) | Azure Monitor delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. Log queries help you maximize the value of the data collected in Azure Monitor Logs. |
| | [Network Intelligence Center](https://cloud.google.com/network-intelligence-center) | [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) | Azure Network Watcher provides tools to monitor, diagnose, view metrics, and enable or disable logs for resources in an Azure virtual network. |
| Other Connectivity Options | [Direct Interconnect](https://cloud.google.com/network-connectivity/docs/direct-peering),[Partner Interconnect](https://cloud.google.com/network-connectivity/docs/interconnect/concepts/partner-overview),[Carrier Peering](https://cloud.google.com/network-connectivity/docs/carrier-peering) | [Azure S2S VPN](/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal),[Azure P2S VPN](/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal) | Point to Site lets you create a secure connection to your virtual network from an individual client computer. Site to Site is a connection between two or more networks, such as a corporate network and a branch office network. |

### Networking architectures

| Architecture | Description |
|----|----|
| [Deploy highly available NVAs](/azure/architecture/networking/guide/network-virtual-appliance-high-availability) | Learn how to deploy network virtual appliances for high availability in Azure. This article includes example architectures for ingress, egress, and both. |
| [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke) | Learn how to implement a hub-spoke topology in Azure, where the hub is a virtual network and the spokes are virtual networks that peer with the hub. |
| [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz) | See a secure hybrid network that extends an on-premises network to Azure with a perimeter network between the on-premises network and an Azure virtual network. |

[view all](/azure/architecture/browse/#networking)

## Security and identity

| Area | Google Cloud service | Azure service | Description |
| --- | --- | --- | --- |
| Authentication and authorization | [Cloud Identity](https://cloud.google.com/identity) | [Microsoft Entra ID](/entra/fundamentals/whatis) | The Microsoft Entra enterprise identity service provides single sign-on and multifactor authentication, which enables the central management of users/groups and external identities federation. |
| | [Identity platform](https://cloud.google.com/identity-platform) | [Microsoft Entra External ID](/entra/external-id/customers/overview-customers-ciam) | A highly available and global identity management service for consumer-facing applications, which scales to hundreds of thousands of identities. Manage customer, consumer, and citizen access to your applications. |
| Multifactor authentication | [Multifactor authentication](https://cloud.google.com/identity) | [Microsoft Entra multifactor authentication](/entra/identity/authentication/concept-mfa-howitworks) | Safeguard access to data and applications, while meeting user demand for a simple sign-in process. |
| Role-based access control | [Identity and Access Management](https://cloud.google.com/iam) | [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) | Azure RBAC helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. |
| ABAC | [Identity and Access Management](https://cloud.google.com/iam) | [Azure attribute-based access control](/azure/role-based-access-control/conditions-overview) | Attribute-based access control (ABAC) is an authorization system that defines access based on attributes associated with security principals, resources, and the environment of an access request. |
| Zero trust | [Chrome Enterprise Premium](https://cloud.google.com/beyondcorp-enterprise) | [Microsoft Entra Conditional Access](/entra/identity/conditional-access/overview) | Conditional Access is the tool used by Microsoft Entra ID to bring signals together, to make decisions, and to enforce organizational policies. |
| Resource management | [Resource Manager](https://cloud.google.com/resource-manager) | [Azure Resource Manager](/azure/azure-resource-manager/management/overview) | Provides a management layer that enables you to create, update, and delete resources in your Azure account, like access control, locks, and tags, to secure and organize your resources after deployment.|
| Encryption | [Cloud KMS](https://cloud.google.com/kms), [Secret Manager](https://cloud.google.com/secret-manager) | [Azure Key Vault](/azure/key-vault/general/overview) | Provides a security solution and works with other services by allowing you to manage, create, and control encryption keys that are stored in hardware security modules (HSM). |
| Data-at-rest encryption | [Encryption at rest](https://cloud.google.com/security/encryption-at-rest) | [Azure Storage Service Encryption](/azure/storage/storage-service-encryption) - encryption by default | Azure Storage Service Encryption helps you protect and safeguard your data and meet your organizational security and compliance commitments. |
| Data in-use | [Confidential Computing](https://cloud.google.com/confidential-computing) | [Azure Confidential Computing](/azure/confidential-computing/overview) | Encrypt data in-use. |
| Hardware security module (HSM) | [Cloud HSM](https://cloud.google.com/kms/docs/hsm) | [Azure Cloud HSM](/azure/cloud-hsm/overview) | Microsoft Azure Cloud HSM is FIPS 140-3 Level 3 validated single-tenant service. You retain complete administrative authority over your hardware security module and use it to store cryptographic keys and perform cryptographic operations. |
| Data loss prevention (DLP) | [Cloud Data Loss Prevention](https://cloud.google.com/dlp) | [Microsoft Purview Information Protection](/purview/information-protection) | Microsoft Purview Information Protection (formerly Azure Information Protection) helps you discover, classify, and protect sensitive information wherever it lives or travels. |
| Security | [Security Command Center](https://cloud.google.com/security-command-center), [Web Security Scanner](https://cloud.google.com/security-command-center/docs/concepts-web-security-scanner-overview) | [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) | Microsoft Defender for Cloud is a cloud-native application protection platform (CNAPP) that is made up of security measures and practices that are designed to protect cloud-based applications. |
| Threat detection | [Event Threat Detection](https://cloud.google.com/security-command-center/docs/how-to-use-event-threat-detection) | [Microsoft Defender for Identity](/defender-for-identity/what-is) | Microsoft Defender for Identity is a cloud-based security solution that helps secure your identity monitoring. |
| SIEM | [Chronicle](https://cloud.google.com/chronicle) | [Microsoft Sentinel](/azure/sentinel/overview) | A cloud-native security information and event manager (SIEM) platform that uses built-in AI to analyze large volumes of data from all sources, including users, applications, servers, and devices that are running on-premises or in any cloud. |
| Container security | [Container Security](https://cloud.google.com/containers/security) | [Container Security in Microsoft Defender for Cloud](/azure/security-center/container-security) | Microsoft Defender for Cloud is the Azure-native solution for securing your containers. |
| | [Artifact Registry](https://cloud.google.com/artifact-registry) | [Azure Container Registry](/azure/container-registry/container-registry-intro) | A managed, private Docker registry service that's based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your private Docker container images and related artifacts that allow you to only deploy trusted containers. |

### Security architectures

| Architecture | Description |
|----|----|
| [Securely managed web applications](/azure/architecture/example-scenario/apps/fully-managed-secure-apps) | Learn about deploying secure applications using the Azure App Service Environment, the Azure Application Gateway service, and Web Application Firewall. |

[view all](../browse/index.yml?azure_categories=security)

## Storage

### Object storage

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Storage](https://cloud.google.com/storage#documentation)<br/><br/> [Cloud Storage for Firebase](https://firebase.google.com/products/storage) | [Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction) | Object storage service, for use cases including cloud applications, content distribution, backup, archiving, disaster recovery, and big data analytics. |

### Block storage

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Persistent Disk](https://cloud.google.com/compute/docs/disks)<br/><br/> [Local SSD](https://cloud.google.com/compute/docs/disks/local-ssd) | [Azure Disk Storage](https://azure.microsoft.com/services/storage/disks) | SSD storage optimized for I/O intensive read/write operations. For use as high-performance Azure virtual machine storage. |

### File storage

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Filestore](https://cloud.google.com/filestore/docs) | [Azure Files](https://azure.microsoft.com/services/storage/files/), [Azure NetApp Files](https://azure.microsoft.com/services/netapp/#overview) | File based storage and hosted NetApp Appliance Storage. |
| [Google Drive](https://workspace.google.com/products/drive) | [OneDrive For business](https://products.office.com/onedrive/onedrive-for-business) | Cloud storage and file sharing solution for businesses to store, access, and share files anytime and anywhere. |

### Bulk data transfer

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Transfer Appliance](https://cloud.google.com/transfer-appliance/docs/2.0) | [Azure Import/Export](/azure/storage/common/storage-import-export-service) | A data transport solution that uses secure disks and appliances to transfer large amounts of data. Also offers data protection during transit. |
| [Transfer Appliance](https://cloud.google.com/transfer-appliance/docs/2.0) | [Azure Data Box](https://azure.microsoft.com/services/storage/databox) | Petabyte- to exabyte-scale data transport solution that uses secure data storage devices to transfer large amounts of data to and from Azure. |

## Application services

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [App Engine](https://cloud.google.com/appengine/docs) | [Azure App Service](https://azure.microsoft.com/services/app-service) | Managed hosting platform providing services for deploying and scaling web applications and services. |
| [Apigee](https://cloud.google.com/apigee) | [Azure API Management](https://azure.microsoft.com/services/api-management/) | A managed service for publishing APIs to external and internal consumers. |

### Web architectures

| Architecture | Description |
|----|----|
| [Serverless web application](/azure/architecture/web-apps/serverless/architectures/web-app) | This reference architecture shows a serverless web application, which serves static content from Azure Blob Storage and implements an API using Azure Functions. |

[view all](../browse/index.yml?azure_categories=web)

## Miscellaneous

| Area | Google Cloud service | Azure service | Description |
| --- | --- | --- | --- |
| Workflow | [Composer](https://cloud.google.com/composer) | [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) | Serverless technology for connecting apps, data and devices anywhere, whether on-premises or in the cloud for large ecosystems of SaaS and cloud-based connectors. |
| Enterprise application services | [G Suite](https://gsuite.google.com) | [Microsoft 365](https://products.office.com) | Fully integrated Cloud service providing communications, email, document management in the cloud and available on a wide variety of devices. |
| Gaming | [Game Servers](https://cloud.google.com/game-servers) | [Azure PlayFab](https://playfab.com) | Managed services for hosting dedicated game servers. |
| Hybrid | [Anthos](https://cloud.google.com/anthos) | [Azure Arc](https://azure.microsoft.com/services/azure-arc) | For customers who want to simplify complex and distributed environments across on-premises, edge and multi-cloud, Azure Arc enables deployment of Azure services anywhere and extends Azure management to any infrastructure. |
| Blockchain | [Digital Asset](https://developers.google.com/digital-asset-links) | [Azure Confidential Ledger](https://azure.microsoft.com/services/azure-confidential-ledger) | Tamperproof, unstructured data store hosted in trusted execution environments and backed by cryptographically verifiable evidence. |
| Monitoring | [Cloud Monitoring](https://cloud.google.com/monitoring) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) | Service that provides visibility into the performance, uptime, and overall health of cloud-powered applications. |
| Logging | [Cloud Logging](https://cloud.google.com/logging) | [Log Analytics](/azure/azure-monitor/log-query/get-started-portal) | Service for real-time log management and analysis. |

## Migration tools

| Area | Google Cloud service | Azure Service | Description |
| --- | --- | --- | --- |
| App migration to containers | Migrate for Anthos | [Azure Migrate: App Containerization tool](/azure/migrate/tutorial-app-containerization-aspnet-kubernetes) | Modernize your application by migrating it to AKS or App Services containers. |
| Migration of virtual machines | [Migrate for Compute Engine](https://cloud.google.com/migrate/compute-engine) | [Azure Migrate: Server Migration tool](/azure/migrate/tutorial-migrate-physical-virtual-machines) | Migrate servers from anywhere to Azure. |
| VMware migration | [Google Cloud VMware Engine](https://cloud.google.com/vmware-engine) | [Azure VMware Solution](/azure/migrate/vmware/start-here-vmware) | Move or extend on-premises VMware environments to Azure. |
| Migration of databases | [Database Migration Service](https://cloud.google.com/database-migration) | [Azure Database Migration Service (classic)](/azure/dms/migration-using-azure-data-studio?tabs=azure-sql-mi), [Azure SQL Migration extension for Azure Data Studio](/azure/dms/migration-using-azure-data-studio?tabs=azure-sql-mi) | Fully managed service designed to enable migrations from multiple database sources to Azure data platforms with minimal downtime. |
| Migration programs | [Google Cloud Rapid Assessment & Migration Program (RAMP)](https://cloud.google.com/solutions/cloud-migration-program) | [Azure Migration and Modernization Program](https://azure.microsoft.com/migration/migration-modernization-program/#overview) | Learn how to move your apps, data, and infrastructure to Azure using a proven cloud migration and modernization approach. |
| Server assessment | [Migrate to Google Cloud](https://cloud.google.com/architecture/migration-to-gcp-assessing-and-discovering-your-workloads) | [Azure Migrate](/azure/migrate/migrate-services-overview#azure-migrate-discovery-and-assessment-tool) | Increases business intelligence by accurately presenting entire IT environments within a single day. |
| Database assessment | [Migrate to Google Cloud](https://cloud.google.com/architecture/migration-to-gcp-assessing-and-discovering-your-workloads) | [Data Migration Assistant](/azure/migrate/concepts-azure-sql-assessment-calculation) |  It helps pinpoint potential problems blocking migration. It identifies unsupported features, new features that can benefit you after migration, and the right path for database migration. |
| Web app assessment and migration | [Google Cloud Application Migration](https://cloud.google.com/solutions/application-migration) | [Web app migration assistant](https://appmigration.microsoft.com), [Azure Migrate application and code assessment](/azure/migrate/appcat/), [Azure Migrate](/azure/migrate/concepts-migration-webapps) | Assess on-premises web apps and migrate them to Azure. |

## Next steps

If you are new to Azure, review the interactive [Core Cloud Services - Introduction to Azure](/training/modules/welcome-to-azure) module on [Microsoft Learn training](/training).

## Related resources

- [Discover Google Cloud instances](/azure/migrate/tutorial-discover-gcp)
- [Assess Google Cloud VM instances](/azure/migrate/tutorial-assess-gcp)
- [Migrate Google Cloud VMs to Azure](/azure/migrate/tutorial-migrate-gcp-virtual-machines)
