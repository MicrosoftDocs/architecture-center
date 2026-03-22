---
title: Google Cloud to Azure Services Comparison
description: Compare Google Cloud and Microsoft Azure services. Not every Google Cloud service or Azure service is listed, and not every matched service has exact feature parity.
author: juanlldc
ms.author: juanll
ms.date: 03/25/2026
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - gcp-to-azure
---

# Google Cloud to Azure services comparison

This article compares Azure and Google Cloud services across different technology categories. Use it to plan a multicloud solution or to migrate from Google Cloud to Azure.

> [!NOTE]
> The former name for Google Cloud is *Google Cloud Platform (GCP)*.

This article compares roughly equivalent services between the two platforms. It doesn't include every service from either platform, and matched services might not have identical features.

For an overview of Azure for Google Cloud users, see [Azure for Google Cloud professionals](./index.md).

## Marketplace

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Google Cloud Marketplace](https://cloud.google.com/marketplace) | [Microsoft Marketplace](https://marketplace.microsoft.com) | Preconfigured external applications that you can deploy to single virtual machine (VM) or multiple VMs. |

## Data platform

### Database

| Type | Google Cloud service | Azure service | Azure service description |
| --- | --- | --- | --- |
| Relational database | [Cloud SQL](https://cloud.google.com/sql#documentation) - SQL Server | [Azure SQL family](/azure/azure-sql): <br><br> Azure SQL Database <br><br> Azure SQL Managed Instance <br><br> SQL Server on Azure VM <br><br> [Azure SQL Edge](/azure/azure-sql-edge) | Azure SQL family of SQL Server database engine products in the cloud. <br><br> Azure SQL Database is a managed platform as a service (PaaS) database engine. <br><br> Azure SQL Managed Instance is the intelligent, scalable cloud database service that combines the broadest SQL Server database engine compatibility with the benefits of a managed and evergreen PaaS. <br><br> SQL Server infrastructure as a service (IaaS) deployed on Azure Windows or Linux VMs. <br><br> Azure SQL Edge is an optimized relational database engine for Internet of Things (IoT) and edge deployments. |
|  | [Cloud SQL](https://cloud.google.com/sql#documentation) - MySQL and PostgreSQL | [Azure Database for MySQL flexible server](/azure/mysql/) <br><br> [Azure Database for PostgreSQL flexible server](/azure/postgresql) | Managed relational database service where the platform primarily handles resiliency, security, scale, and maintenance. |
| Horizontally scalable relational database | [Cloud Spanner](https://cloud.google.com/spanner) | [Azure Cosmos DB for NoSQL](https://azure.microsoft.com/services/cosmos-db) | A globally distributed database system that scales horizontally. Supports multiple data models, including key-value, graph, and document data. Supports multiple APIs, including SQL, JavaScript, Gremlin, MongoDB, and Azure Table Storage. You can scale compute and storage independently. |
|  |  | [Azure Cosmos DB for PostgreSQL (Citus)](/azure/cosmos-db/postgresql/introduction) | Azure Database for PostgreSQL is a managed database service based on the open-source Postgres relational database engine. The Hyperscale (Citus) deployment option scales queries across multiple machines through sharding to serve applications that require greater scale and performance. |
| NoSQL | [Cloud Bigtable](https://cloud.google.com/bigtable/docs) | [Azure Table Storage](/azure/storage/tables) | A highly scalable NoSQL key-value store that handles massive semistructured datasets and supports rapid development. Stores semistructured data that's highly available. Supports flexible data schemas and OData-based queries. |
|  | [Cloud Firestore](https://cloud.google.com/firestore/docs) | [Azure Cosmos DB](/azure/cosmos-db) | Globally distributed, multimodel database that natively supports multiple data models, including key-value, documents, graphs, and columnar. |
|  | [Firebase Realtime Database](https://firebase.google.com/products/realtime-database) | [Azure Cosmos DB change feed](/azure/cosmos-db/change-feed) | Azure Cosmos DB change feed captures changes to a container in order. It monitors for changes, outputs a sorted list of modified documents, and supports asynchronous, incremental processing across one or more consumers in parallel. |
| In-memory | [Cloud Memorystore](https://cloud.google.com/memorystore/docs) | [Azure Managed Redis](https://azure.microsoft.com/products/managed-redis/) | A secure data cache and messaging broker that provides high-throughput and low-latency data access for applications. |

Learn more about [database services in Azure](../guide/technology-choices/data-stores-getting-started.md).

### Data warehouse

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [BigQuery](https://cloud.google.com/bigquery) | [Fabric Data Warehouse](/fabric/data-warehouse/data-warehousing) <br><br> [Azure Databricks](https://azure.microsoft.com/services/databricks) | Cloud-based analytics and data warehousing platforms that use distributed processing to run large-scale SQL and Spark queries over structured and unstructured data. Fabric Data Warehouse provides a  managed, SQL-based data warehouse built on OneLake. Azure Databricks is an Apache Spark–based analytics platform for building lakehouse architectures and advanced analytics solutions. |

#### Data warehouse architectures

| Architecture | Description |
| --- | --- |
| [Databases architecture design](../databases/index.yml) | Overview of the Azure database solutions described in the Azure Architecture Center. |

View all [data warehouse architectures](../browse/index.yml?azure_categories=databases).

### Data orchestration and extract, transform, and load (ETL)

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Data Fusion](https://cloud.google.com/data-fusion) | [Azure Data Factory](https://azure.microsoft.com/services/data-factory) <br><br> [Data Factory in Microsoft Fabric](/fabric/data-factory/) | Processes and moves data between different compute and storage services, as well as on-premises data sources at specified intervals. Create, schedule, orchestrate, and manage data pipelines. |

## Big data and analytics

### Big data processing

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Dataproc](https://cloud.google.com/dataproc) | [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) <br><br> [Microsoft Fabric Data Engineering](/fabric/data-engineering/data-engineering-overview) | Managed Apache Spark-based analytics platform. |

Learn more about [big data services in Azure](../data-guide/technology-choices/data-storage.md).

#### Big data architectures

| Architecture | Description |
| --- | --- |
| [Analytics end-to-end with Microsoft Fabric](../example-scenario/dataplate2e/data-platform-end-to-end.yml) | Use Azure services to ingest, process, store, serve, and visualize data from different sources. |
| [Analytics architecture design](../solution-ideas/articles/analytics-get-started.md) | Use analytics solutions to turn volumes of data into useful business intelligence, such as reports and visualizations, and inventive AI, such as forecasts based on machine learning. |

### Analytics and visualization

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Dataflow](https://cloud.google.com/dataflow) | [Azure Databricks](https://azure.microsoft.com/services/databricks/#documentation) <br><br> [Azure HDInsight](/azure/hdinsight) | Managed platform for streaming and batch data processing using Apache Beam |
| [Looker Studio](https://lookerstudio.google.com/overview) <br><br> [Looker](https://cloud.google.com/looker) | [Power BI](https://powerbi.microsoft.com) | Business intelligence tools that build visualizations, perform on-demand analysis, and develop business insights from data. |
| [Cloud Search](https://cloud.google.com/products/search) | [Azure AI Search](https://azure.microsoft.com/services/search) | Delivers full-text search and related search analytics and capabilities. |
| [BigQuery](https://cloud.google.com/bigquery) | [SQL Server Analysis Services](/analysis-services/analysis-services-overview) | Provides a serverless noncloud interactive query service that uses standard SQL for analyzing databases. |

Learn more about [analytics and visualization services in Azure](../data-guide/technology-choices/analytical-data-stores.md).

#### Analytics architectures

| Architecture | Description |
| --- | --- |
| [Databases architecture design](../databases/index.yml) | Overview of the Azure database solutions described in the Azure Architecture Center. |

View all [analytics architectures](../browse/index.yml?azure_categories=analytics).

### Time series and IoT data

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [BigQuery](https://cloud.google.com/bigquery) | [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer) <br><br> [Fabric Real-Time Intelligence](/fabric/real-time-hub/real-time-hub-overview) | Managed, low latency, and distributed big data analytics platform that runs complex queries across petabytes of data. Highly optimized for log and time series data. Open and scalable end-to-end IoT analytics service that collects, processes, stores, queries, and visualizes data at IoT scale with contextual enrichment and time series optimization. |

#### Time series architecture

| Architecture | Description |
| --- | --- |
| [IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml) | IoT telemetry analytics with Azure Data Explorer demonstrates near real-time analytics over high-volume, fast-flowing, diverse streaming data from IoT devices. |

## AI and machine learning

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Vertex AI](https://cloud.google.com/vertex-ai) | [Azure Machine Learning](/azure/machine-learning/) | A cloud service that trains, deploys, automates, and manages machine learning and foundation models. Also provides notebook, designer, and automate options. |
| [TensorFlow](https://www.tensorflow.org) | [ML.NET](https://dotnet.microsoft.com/apps/machinelearning-ai/ml-dotnet) | ML.NET is an open-source and cross-platform machine learning framework for both machine learning and AI. |
| [TensorFlow](https://www.tensorflow.org/) | [Open Neural Network Exchange (ONNX)](https://onnx.ai) | ONNX is an open format for representing machine learning models that facilitates maximum compatibility and improves inference performance. |
| [Cloud Vision API - Computer Vision](https://cloud.google.com/vision) | [Foundry Tools Computer Vision](https://azure.microsoft.com/resources/cloud-computing-dictionary/what-is-computer-vision/) | Uses visual data processing to help computers identify and understand objects and people in images and videos, label content that ranges from objects to concepts, extract printed and handwritten text, recognize familiar subjects such as brands and landmarks, and moderate content. |
| [Natural Language AI](https://cloud.google.com/natural-language) | [Azure Language in Foundry Tools](/azure/ai-services/language-service/) | Azure Language is a managed service for developing natural language processing applications. Identify key terms and phrases, analyze sentiment, summarize text, and build conversational interfaces. |
| [Natural Language AI](https://cloud.google.com/natural-language) | [Foundry Tools conversational language understanding](/azure/ai-services/language-service/) | A feature of Azure Language that uses natural language understanding (NLU) so that people can interact with your apps, bots, and IoT devices. |
| [Speech-to-Text](https://cloud.google.com/speech-to-text) | [Foundry Tools speech to text](https://azure.microsoft.com/services/cognitive-services/speech-to-text) | Transcribe audio to text in more than 100 languages and variants. Customize models to enhance accuracy for domain-specific terminology. |
| [Vertex AI AutoML](https://docs.cloud.google.com/vertex-ai/docs/beginner/beginners-guide) | [Azure Machine Learning AutoML](/azure/machine-learning/concept-automated-ml) | AutoML in Azure Machine Learning automates the time-consuming, iterative tasks of machine learning model development. With automated machine learning, data scientists, analysts, and developers can build machine learning models efficiently at scale while maintaining model quality. |
| [Vertex AI AutoML](https://docs.cloud.google.com/vertex-ai/docs/beginner/beginners-guide) | [Azure Video Indexer](https://vi.microsoft.com) | Extract insights from your videos and enrich applications to enhance discovery and engagement. |
| [Dialogflow](https://cloud.google.com/dialogflow) | [Azure Language question answering](/azure/ai-services/language-service/question-answering/overview) | Build, train, and publish a sophisticated bot by using FAQ pages, support websites, product manuals, SharePoint documents, or editorial content through a GUI or REST APIs. |
| [Vertex AI Workbench](https://cloud.google.com/vertex-ai-notebooks) | [Azure Machine Learning studio notebooks](/azure/machine-learning/how-to-run-jupyter-notebooks) | Develop and run code by using Jupyter notebooks in Azure Machine Learning studio. Get access to managed compute resources and integration with Azure Machine Learning workflows. |
| [Vertex AI Workbench Instances](https://docs.cloud.google.com/vertex-ai/docs/workbench/introduction#reservations) | [Azure Data Science Virtual Machine](/azure/machine-learning/data-science-virtual-machine/overview) | Preconfigured environments in the cloud for data science and ai development. |
| [Deep Learning Containers](https://cloud.google.com/ai-platform/deep-learning-containers) | [GPU support on Azure Kubernetes Service (AKS)](/azure/aks/gpu-cluster) | GPUs support compute-intensive workloads such as graphics, visualization workloads, and AI inferencing. AKS supports the creation of GPU-enabled node pools to run these compute-intensive workloads in Kubernetes. |
| [Data Labeling Service](https://cloud.google.com/ai-platform/data-labeling/docs) | [Azure Machine Learning - data labeling](/azure/machine-learning/how-to-create-labeling-projects) | A central place to create, manage, and monitor labeling projects (preview). Use it to coordinate data, labels, and team members to efficiently manage labeling tasks. Azure Machine Learning supports multilabel and multiclass image classification and object identification by using bounded boxes. |
| [Vertex AI Training](https://docs.cloud.google.com/vertex-ai/docs/training/overview) | [Azure Machine Learning - compute targets](/azure/machine-learning/concept-compute-target) | Designated compute resource or environment where you run your training script or host your service deployment. This location might be your local machine or a cloud-based compute resource. Use compute targets to change your compute environment later without changing your code. |
| [Vertex AI Predictions](https://docs.cloud.google.com/vertex-ai/docs/predictions/overview) | [Azure Machine Learning - deployments](/azure/machine-learning/tutorial-deploy-model) | Deploy your machine learning model as a web service that makes real-time or batch predictions at scale. |
| [Continuous Evaluation](https://cloud.google.com/ai-platform/prediction/docs/continuous-evaluation) | [Azure Machine Learning - data drift](/azure/machine-learning/how-to-monitor-datasets) | Monitor for data drift between the training dataset and inference data of a deployed model. In the context of machine learning, trained machine learning models might experience degraded prediction performance because of drift. Use Azure Machine Learning to monitor data drift and receive email alerts when drift is detected. |
| [Explainable AI](https://cloud.google.com/explainable-ai/) | [Azure Machine Learning - model interpretability](/azure/machine-learning/how-to-machine-learning-interpretability) | Understand and explain the behaviors of your machine learning models. |
| [Cloud TPU](https://docs.cloud.google.com/tpu/docs/tpu7x) | [Field-Programmable Gate Array (FPGA)-accelerated VMs](/azure/virtual-machines/sizes/overview#fpga-accelerated) | Perform AI and machine learning inferencing tasks that are optimized for FPGA programming. FPGAs are based on Intel FPGA devices. |
| [Vertex AI](https://cloud.google.com/vertex-ai/docs/start/introduction-unified-platform) | [Machine learning operations (MLOps)](https://azure.microsoft.com/solutions/machine-learning-ops) | A platform that automates and coordinates the development and deployment of machine learning models and AI workflows, from data preparation and model training to deployment and monitoring. |
| [Dialogflow](https://cloud.google.com/dialogflow/docs/) | [Microsoft Bot Framework](https://dev.botframework.com) | Build conversational AI experiences and integrate a conversational UI. |
| [Gemini model family](https://ai.google.dev/gemini-api/docs/models) | [Azure OpenAI](https://azure.microsoft.com/products/ai-foundry/models/openai) | Prebuilt large language models (LLMs) available via API endpoints. |
| [Vertex AI Agent Builder](https://cloud.google.com/products/agent-builder) | [Foundry Agent Service](https://azure.microsoft.com/products/ai-foundry/agent-service/) | Build your own custom AI agents in the cloud. |
| [Imagen (image generation)](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/image/overview) | [Azure OpenAI image generation models](/azure/foundry/openai/how-to/dall-e) | Generate images by using AI models. |
| [Google Agentspace](https://cloud.google.com/blog/products/ai-machine-learning/google-agentspace-enables-the-agent-driven-enterprise) | [Microsoft Copilot Studio](https://www.microsoft.com/microsoft-365-copilot/microsoft-copilot-studio/) | Low-code tool for custom AI agent creation in the cloud. |
| [Gemini Code Assist](https://codeassist.google/) | [GitHub Copilot](https://github.com/features/copilot) | AI code creation assistance agent. |

Learn more about [AI and machine learning services in Azure](../data-guide/technology-choices/ai-services.md).

### AI and machine learning architectures

| Architecture | Description |
| --- | --- |
| [Image classification on Azure](../ai-ml/idea/intelligent-apps-image-processing.yml) | Learn how to build image processing into your applications by using Azure services such as the Computer Vision API and Azure Functions. |

View all [AI and machine learning architectures](../browse/index.yml?azure_categories=ai-machine-learning).

## Data catalog and governance

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Dataplex Universal Catalog](https://cloud.google.com/dataplex) | [Microsoft Purview](/purview) | Microsoft Purview is a portfolio of products for data governance, data security, and risk and compliance solutions. |

## Compute

### Virtual servers

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Compute Engine](https://cloud.google.com/compute#documentation) | [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) | Use virtual servers to deploy, manage, and maintain OS and server software. Instance types provide combinations of CPU and RAM. You pay for what you use and have the flexibility to change sizes. |
| [Sole-tenant nodes](https://cloud.google.com/compute/docs/nodes/sole-tenant-nodes) | [Azure Dedicated Host](https://azure.microsoft.com/services/virtual-machines/dedicated-host) | Host your VMs on hardware that's dedicated only to your project. This approach supports compliance and isolation. |
| [Batch](https://cloud.google.com/batch/docs/get-started) | [Azure Batch](https://azure.microsoft.com/services/batch) | Supports large-scale parallel and high-performance computing (HPC) workloads through VMs or containers. Includes built-in job scheduling, autoscaling, and support for HPC, AI, and machine learning scenarios. |
| [Compute Engine Autoscaler](https://cloud.google.com/compute/docs/autoscaler) <br><br> [Compute Engine managed instance groups](https://cloud.google.com/compute/docs/instance-groups) | [Azure virtual machine scale sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview) | Deploys and manages groups of identical or flexible VMs. Provides autoscaling, availability zone support, and automatic instance repair for both stateless and stateful workloads. |
| [Cloud GPUs](https://cloud.google.com/gpu) | [GPU-optimized VMs](/azure/virtual-machines/sizes-gpu) | GPU-optimized VM sizes are specialized VMs available in single, multiple, or fractional GPU configurations. The sizes support AI, compute-intensive, graphics-intensive, and visualization workloads. |
| [VMware Engine](https://cloud.google.com/vmware-engine) | [Azure VMware Solution](https://azure.microsoft.com/services/azure-vmware) | Redeploy and extend your VMware-based enterprise workloads to Azure by using Azure VMware Solution. Migrate VMware-based workloads from your datacenter to Azure and integrate your VMware environment into Azure. Continue to manage existing environments by using the same VMware tools while you modernize applications by using Azure services. Azure VMware Solution is a VMware-verified Microsoft service that runs on Azure infrastructure. |

Learn more about [compute services in Azure](../guide/technology-choices/compute-decision-tree.md).

### Containers and container orchestrators

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Run](https://cloud.google.com/run#documentation) | [Azure Container Apps](https://azure.microsoft.com/products/container-apps) | Azure Container Apps is a managed serverless container service built on Kubernetes and KEDA that supports event-driven applications, scale-to-zero, and microservices without managing clusters. |
| [Artifact Registry](https://cloud.google.com/artifacts/docs) <br><br> [Container Registry (legacy)](https://cloud.google.com/container-registry/docs) | [Azure Container Registry](https://azure.microsoft.com/services/container-registry) | You can store OCI-compatible container images and artifacts, such as Docker or OCI images and Helm charts. Create all types of container deployments on Azure. |
| [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine#documentation) | [AKS](https://azure.microsoft.com/services/kubernetes-service) | Deploy orchestrated containerized applications by using Kubernetes. Provides cluster management and monitoring, including automatic upgrades and an operations console. See [AKS solution journey](../reference-architectures/containers/aks-start-here.md). |
| [Kubernetes Engine Monitoring](https://cloud.google.com/monitoring/kubernetes-engine) | [Azure Monitor container insights](/azure/azure-monitor/insights/container-insights-overview) | Azure Monitor container insights is a feature that monitors the performance and health of container workloads. It supports managed Kubernetes clusters on AKS, Azure Container Instances, self-managed Kubernetes clusters on [AKS on Azure Stack HCI](/azure-stack/aks-hci/overview) or on-premises, and [Azure Red Hat OpenShift](/azure/openshift/intro-openshift). It integrates with Azure Monitor managed service for Prometheus (for Prometheus metrics collection) and with Azure managed Grafana for visualization.|

Learn more about [container services in Azure](../guide/choose-azure-container-service.md).

#### Container architectures

The following architectures use AKS as the orchestrator.

| Architecture | Description |
| --- | --- |
| [Baseline architecture on AKS](../reference-architectures/containers/aks/baseline-aks.yml) | Deploy a baseline infrastructure that deploys an AKS cluster and focuses on security. |
| [Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml) | Deploy a microservices architecture on AKS. |
| [Continuous integration and continuous deployment (CI/CD) baseline architecture that uses Azure Pipelines](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture) | This architecture supports businesses that want to modernize end-to-end application development by using containers, continuous integration for build, and GitOps for continuous deployment. |

View all [container architectures](../browse/index.yml?azure_categories=containers).

### Functions

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Functions](https://cloud.google.com/functions/#documentation) | [Azure Functions](https://azure.microsoft.com/services/functions) | Integrate systems and run back-end processes in response to events or schedules without provisioning or managing servers. |

#### Serverless architectures

| Architecture | Description |
| --- | --- |
| [Cross-cloud scaling pattern](/azure-stack/user/pattern-cross-cloud-scale) | Learn how to improve cross-cloud scalability by using a solution architecture that includes Azure Stack. A step-by-step flowchart details instructions for implementation. |

## DevOps and application monitoring

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Collect, analyze, and act on telemetry from your cloud and on-premises environments. Understand how your applications perform and identify problems that affect them and their dependent resources. |
| [Cloud Trace](https://cloud.google.com/trace) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Collect, analyze, and act on telemetry from your cloud and on-premises environments. Understand how your applications perform and identify problems that affect them and their dependent resources. |
| [Cloud Profiler](https://cloud.google.com/profiler/docs/) | [Application Insights in Azure Monitor](/azure/azure-monitor/app/app-insights-overview) | Supports application performance management (APM) for live web applications. It helps you understand how your applications perform and proactively identifies problems that affect them and their dependent resources. |
| [Cloud Source Repositories](https://cloud.google.com/source-repositories) | [Azure Repos](https://azure.microsoft.com/services/devops/repos) <br><br> [GitHub Repos](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/about-repositories) | A cloud service for collaborating on code development. |
| [Cloud Build](https://cloud.google.com/build) | [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines/?nav=min) <br><br> [GitHub Actions](https://github.com/features/actions) | Managed build service that supports CI/CD. |
| [Artifact Registry](https://cloud.google.com/artifact-registry/docs/overview) | [Azure Artifacts](https://azure.microsoft.com/services/devops/artifacts) <br><br> [GitHub Packages](https://github.com/features/packages) | Add fully integrated package management to your CI/CD pipelines. Create and share Maven, npm, NuGet, and Python package feeds from public and private sources for teams of any size. |
| [Cloud Developer Tools](https://cloud.google.com/products/tools) including Cloud Code | [Azure developer tools](https://azure.microsoft.com/resources/developers/) | Build, debug, deploy, diagnose, and manage multiplatform scalable apps and services. |
| [gcloud SDK](https://cloud.google.com/sdk) | [Azure SDKs and tools](https://azure.microsoft.com/downloads/) | Azure SDKs are collections of libraries for using Azure services from your preferred programming language. The Azure CLI provides commands for creating and managing Azure resources. Both tools support automation across Azure services. |
| [Cloud Shell](https://cloud.google.com/shell) | [Azure Cloud Shell](/azure/cloud-shell/overview) | Azure Cloud Shell is an interactive, authenticated, browser-friendly shell for managing Azure resources. You can use either Bash or PowerShell depending on your workload requirements. |
| [PowerShell on Google Cloud](https://cloud.google.com/tools/powershell/docs/quickstart) | [Azure PowerShell](/powershell/azure/) | Azure PowerShell is a set of cmdlets for managing Azure resources directly from the PowerShell command line. Azure PowerShell includes features for automation and works with all [platforms that support PowerShell version 7 or higher](/powershell/scripting/install/PowerShell-Support-Lifecycle#supported-platforms). |
| [Cloud Deployment Manager](https://cloud.google.com/deployment-manager) | [Microsoft Marketplace](https://marketplace.microsoft.com) | Marketplace is a catalog of software offerings validated to run on Azure. |
| [Cloud Deployment Manager](https://cloud.google.com/deployment-manager) | [Azure Resource Manager](https://azure.microsoft.com/features/resource-manager/) | Helps you automate manual, long-running, error-prone, and frequently repeated IT tasks. |

### DevOps architectures

| Architecture | Description |
| --- | --- |
| [CI/CD baseline architecture that uses Azure Pipelines](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture) | This architecture supports businesses that want to modernize end-to-end application development by using containers, continuous integration for build, and GitOps for continuous deployment. |

View all [DevOps architectures](../browse/index.yml?azure_categories=devops).

## IoT

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| ~~[Cloud IoT Core](https://cloud.google.com/iot/docs)~~ <br> Deprecated August 16, 2023 | [Azure Event Grid MQTT Broker](/azure/event-grid/mqtt-overview) <br><br> [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) | Gateways for managing bidirectional communication with IoT devices securely and at scale. |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | For more information, see [Messaging and eventing](#messaging-and-eventing). | Process and route streaming data to a subsequent processing engine or to a storage or database platform. |
| [Edge TPU](https://cloud.google.com/edge-tpu) | [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge) <br><br> [Azure IoT Operations](/azure/iot-operations/) | Deploy cloud intelligence directly on IoT devices to run in on-premises scenarios. |

### IoT architectures

| Architecture | Description |
| --- | --- |
| [Azure IoT reference architecture](/azure/iot/iot-introduction) | A recommended architecture for IoT applications on Azure by using PaaS components. |

View all [IoT architectures](../browse/index.yml?azure_categories=iot).

## Management

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Billing](https://cloud.google.com/billing/docs) | [Azure Billing API](/azure/cost-management-billing/automate/automation-overview) | Generate, monitor, forecast, and share billing data for resource usage by time, organization, or product resources. |
| [Cloud Console](https://cloud.google.com/cloud-console) | The [Azure portal](https://azure.microsoft.com/features/azure-portal) | A unified management console that simplifies building, deploying, and operating your cloud resources. |
| [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Collect, analyze, and act on telemetry from your cloud and on-premises environments. |
| [Cost Management](https://cloud.google.com/cost-management) | [Microsoft Cost Management](https://azure.microsoft.com/pricing/details/cost-management) | Understand your Azure invoice, manage your billing account and subscriptions, control Azure spending, and optimize resource use. |

## Messaging and eventing

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) | Supports a set of cloud-based, message-oriented middleware technologies including reliable message queuing and durable publish and subscribe messaging. |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Event Grid](/azure/event-grid/overview) | A  managed event routing service that provides uniform event consumption via a publish and subscribe model. |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Event Hubs](/azure/event-hubs/) | A real-time data ingestion and microbatching service that you can use to build dynamic data pipelines. Integrates with other Azure services. |

Learn more about [messaging services in Azure](../guide/technology-choices/messaging.md).

### Messaging architectures

| Architecture | Description |
| --- | --- |
| [Scalable web application](../web-apps/app-service/architectures/baseline-zone-redundant.yml) | Improve scalability and performance in an Azure App Service web application. |
| [Enterprise integration by using queues and events](../example-scenario/integration/queues-events.yml) | Implement an enterprise integration pattern by using Azure Logic Apps, Azure API Management, Azure Service Bus, and Azure Event Grid. |

## Networking

| Area | Google Cloud service | Azure service | Description |
| --- | --- | --- | --- |
| Cloud virtual networking | [Virtual Private Network (VPC)](https://cloud.google.com/vpc) | [Azure Virtual Network ](/azure/virtual-network/virtual-networks-overview) | Provides an isolated, private environment in the cloud. Provides control over your virtual networking environment. You can choose your own IP address range, add and update address ranges, create subnets, and set up route tables and network gateways. |
| Domain Name System (DNS) management | [Cloud DNS](https://cloud.google.com/dns) | [Azure DNS](/azure/dns/dns-overview) | Manage DNS records by using the same Azure account credentials for billing and support as your other Azure services. |
|  | [Cloud DNS](https://cloud.google.com/dns) | [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) | Azure Traffic Manager is a DNS-based load balancer that distributes traffic optimally to services across global Azure regions and provides high availability and responsiveness. |
|  | [Internal DNS](https://cloud.google.com/compute/docs/internal-dns) | [Azure Private DNS](/azure/dns/private-dns-overview) | Manages and resolves domain names in the virtual network without requiring a custom DNS solution. Provides a naming resolution for VMs within a virtual network and any connected virtual networks. |
| Hybrid connectivity | [Cloud Interconnect](https://cloud.google.com/interconnect/docs) | [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) | Establishes a private network connection from a location to the cloud provider, not over the internet. |
|  | [Cloud VPN Gateway](https://cloud.google.com/vpn/docs/concepts/overview) | [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) | Connects Azure virtual networks to other Azure virtual networks or customer on-premises networks (site-to-site). Connects users to Azure services through VPN tunneling (point-to-site). |
|  | [Cloud VPN Gateway](https://cloud.google.com/vpn/docs/concepts/overview) | [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about) | Azure Virtual WAN simplifies large-scale branch connectivity by using VPN and ExpressRoute. |
|  | [Cloud router](https://cloud.google.com/router/docs) | [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) | Supports dynamic routes exchange via Border Gateway Protocol (BGP). |
| Load balancing | [Network Load Balancing](https://cloud.google.com/load-balancing) | [Azure Load Balancer](/azure/load-balancer/load-balancer-overview) | Azure Load Balancer load balances Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) traffic at layer 4.
|  | [Cloud Load Balancing](https://cloud.google.com/load-balancing) | [Azure Front Door](/azure/frontdoor/front-door-overview) | Azure Front Door provides global load balancing across regions. Cloud Load Balancing uses a single anycast IP address. Azure Front Door uses unicast IP addresses to route traffic to an optimal point of presence. |
|  | [Cloud Load Balancing](https://cloud.google.com/load-balancing) | [Azure Application Gateway](/azure/application-gateway/overview) | Azure Application Gateway provides layer-7 load balancing to any reachable back-end IP address. It supports Secure Sockets Layer (SSL) termination, cookie-based session affinity, and round-robin traffic distribution. |
|  | [Cloud Load Balancing](https://cloud.google.com/load-balancing) | [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) | Azure Traffic Manager is a DNS-based load balancer that distributes traffic optimally to services across global Azure regions and provides high availability and responsiveness. |
| Content delivery network | [Cloud CDN](https://cloud.google.com/cdn) | [Azure Content Delivery Network](/azure/cdn/cdn-overview) | A content delivery network is a distributed network of servers that can efficiently deliver web content to users. |
| Firewall | [Firewall rules](https://docs.cloud.google.com/firewall/docs/firewalls) | [Application security groups](/azure/virtual-network/application-security-groups) | Azure application security groups organize VMs and into groups define network security policies based on those groups. |
|  | [Firewall rules](https://docs.cloud.google.com/firewall/docs/firewalls) | [Network security groups](/azure/virtual-network/security-overview) | Azure network security group filters network traffic to and from Azure resources in an Azure virtual network. |
|  | [Firewall rules](https://docs.cloud.google.com/firewall/docs/firewalls) | [Azure Firewall](/azure/firewall/overview) | Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a stateful firewall that has built-in high availability and unrestricted cloud scalability. |
| Web application firewall | [Cloud Armor](https://cloud.google.com/armor) | [Application Gateway - Azure Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) | Azure Web Application Firewall provides centralized protection of your web applications from common exploits and vulnerabilities. |
|  | [Cloud Armor](https://cloud.google.com/armor) | [Azure Front Door – Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview) | Azure Web Application Firewall on Azure Front Door provides centralized protection for your web applications. |
|  | [Cloud Armor](https://cloud.google.com/armor) | [Azure Content Delivery Network – Azure Web Application Firewall](/azure/web-application-firewall/cdn/cdn-overview) | Azure Web Application Firewall on Azure Content Delivery Network provides centralized protection for your web content. |
| NAT Gateway | [Cloud NAT](https://cloud.google.com/nat) | [Azure NAT Gateway](/azure/virtual-network/nat-overview) | Azure NAT Gateway provides outbound network address translation (NAT) to support internet connectivity for virtual networks. |
| Private connectivity to PaaS | [Private Service Connect](https://cloud.google.com/vpc/docs/private-service-connect) | [Azure Private Link](/azure/private-link/private-link-overview) | Azure Private Link provides access to Azure PaaS services and Azure hosted customer-owned or partner services over a private endpoint in your virtual network. |
| Telemetry | [VPC Flow logs](https://cloud.google.com/vpc/docs/using-flow-logs) | [Network security group (NSG) flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview) | NSG flow logs are a feature of Azure Network Watcher that provides visibility into ingress and egress IP traffic through an NSG. |
|  | [Firewall Rules Logging](https://docs.cloud.google.com/firewall/docs/firewall-rules-logging) | [NSG Flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview) | Network security group (NSG) flow logs are a feature of Network Watcher that provides visibility into ingress and egress IP traffic through an NSG. |
|  | [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](/azure/azure-monitor/overview) | Azure Monitor collects, analyzes, and acts on telemetry from your cloud and on-premises environments. Use log queries to analyze the collected data. |
|  | [Network Intelligence Center](https://cloud.google.com/network-intelligence-center) | [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) | Azure Network Watcher provides tools to monitor, diagnose, and view metrics and activate or deactivate logs for resources in an Azure virtual network. |
| Other connectivity options | [Direct Interconnect](https://cloud.google.com/network-connectivity/docs/direct-peering) <br><br> [Partner Interconnect](https://cloud.google.com/network-connectivity/docs/interconnect/concepts/partner-overview) <br><br> [Carrier Peering](https://cloud.google.com/network-connectivity/docs/carrier-peering) | [Azure site-to-site VPN](/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal) <br><br> [Azure point-to-site VPN](/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal) | Point to site creates a secure connection to your virtual network from an individual client computer. Site to site is a connection between two or more networks, such as a corporate network and a branch office network. |

Learn more about [networking services in Azure](../guide/technology-choices/load-balancing-overview.md).

### Networking architectures

| Architecture | Description |
| --- | --- |
| [Deploy highly available network virtual appliances (NVAs)](../networking/guide/network-virtual-appliance-high-availability.md) | Learn how to deploy NVAs for high availability in Azure. Includes example architectures for ingress, egress, and combined ingress-egress scenarios. |
| [Hub-spoke network topology in Azure](../networking/architecture/hub-spoke.yml) | Learn how to implement a hub-spoke topology in Azure, where the hub is a virtual network and the spokes are virtual networks that peer with the hub. |
| [Implement a secure hybrid network](../reference-architectures/dmz/secure-vnet-dmz.yml) | See a secure hybrid network that extends an on-premises network to Azure and includes a perimeter network between the on-premises network and an Azure virtual network. |

View all [networking architectures](../browse/index.yml?azure_categories=networking).

## Security and identity

| Area | Google Cloud service | Azure service | Description |
| --- | --- | --- | --- |
| Authentication and authorization | [Cloud Identity](https://cloud.google.com/identity) | [Microsoft Entra ID](/entra/fundamentals/whatis) | The Microsoft Entra enterprise identity service provides single sign-on and multifactor authentication, which supports central management of users or groups and external identities federation. |
|  | [Identity platform](https://cloud.google.com/identity-platform) | [Microsoft Entra External ID](/entra/external-id/customers/overview-customers-ciam) | A highly available and global identity management service for consumer-facing applications, which scales to hundreds of thousands of identities. Manage customer, consumer, and citizen access to your applications. |
| Multifactor authentication | [Multifactor authentication](https://cloud.google.com/identity) | [Microsoft Entra multifactor authentication (MFA)](/entra/identity/authentication/concept-mfa-howitworks) | Safeguards access to data and applications and provides a simple sign-in process for users. |
| Role-based access control (RBAC) | [Identity and Access Management](https://cloud.google.com/iam) | [Azure RBAC](/azure/role-based-access-control/overview) | Azure RBAC helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. |
| Attribute-based access control (ABAC) | [Identity and Access Management](https://cloud.google.com/iam) | [Azure ABAC](/azure/role-based-access-control/conditions-overview) | ABAC is an authorization system that defines access based on attributes associated with security principals, resources, and the environment of an access request. |
| Zero trust | [Chrome Enterprise Premium](https://chromeenterprise.google/products/chrome-enterprise-premium/) | [Microsoft Entra Conditional Access](/entra/identity/conditional-access/overview) | Microsoft Entra Conditional Access analyzes security signals and enforces access policies based on identity, device, location, and risk level. |
| Resource management | [Resource Manager](https://cloud.google.com/resource-manager) | [Azure Resource Manager](/azure/azure-resource-manager/management/overview) | Provides a management layer that helps you create, update, and delete resources in your Azure account. Manage access control, locks, and tags to secure and organize your resources after deployment. |
| Encryption | [Cloud KMS](https://cloud.google.com/kms) <br><br> [Secret Manager](https://cloud.google.com/secret-manager) | [Azure Key Vault](/azure/key-vault/general/overview) | Provides a security solution that integrates across Azure services to help you manage, create, and control encryption keys stored in hardware security modules (HSMs). |
| Data-at-rest encryption | [Encryption at rest](https://cloud.google.com/security/encryption-at-rest) | [Azure Storage service encryption](/azure/storage/storage-service-encryption) - encryption by default | Azure Storage service encryption helps you protect and safeguard your data and meet your organizational security and compliance commitments. |
| Data in use | [Confidential Computing](https://cloud.google.com/confidential-computing) | [Azure confidential computing](/azure/confidential-computing/overview) | Encrypt data in use. |
| Hardware security module (HSM) | [Cloud HSM](https://cloud.google.com/kms/docs/hsm) | [Azure Cloud HSM](/azure/cloud-hsm/overview) | Azure Cloud HSM is Federal Information Processing Standards (FIPS) 140-3 Level-3 validated single-tenant service. You retain complete administrative authority over your HSM and use it to store cryptographic keys and perform cryptographic operations. |
| Data loss prevention (DLP) | [Sensitive Data Protection](https://cloud.google.com/security/products/sensitive-data-protection) | [Microsoft Purview Information Protection](/purview/information-protection) | Microsoft Purview Information Protection (formerly Microsoft Information Protection) helps you discover, classify, and protect sensitive information wherever it lives or travels. |
| Security | [Security Command Center](https://cloud.google.com/security-command-center) <br><br> [Web Security Scanner](https://cloud.google.com/security-command-center/docs/concepts-web-security-scanner-overview) | [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) | Microsoft Defender for Cloud is a cloud-native application protection platform (CNAPP) that provides security for cloud-based applications. |
| Threat detection | [Event Threat Detection](https://cloud.google.com/security-command-center/docs/how-to-use-event-threat-detection) | [Microsoft Defender for Identity](/defender-for-identity/what-is) | Microsoft Defender for Identity is a cloud-based security solution that helps secure your identity monitoring. |
| security information and event management (SIEM) | [Google Security Operations](https://docs.cloud.google.com/chronicle/docs/overview) | [Microsoft Sentinel](/azure/sentinel/overview) | A cloud-native SIEM platform that uses built-in AI to analyze large volumes of data from all sources, including users, applications, servers, and devices that run on-premises or in a cloud. |
| Container security | [Container Security](https://cloud.google.com/containers/security) | [Container security in Microsoft Defender for Cloud](/azure/security-center/container-security) | Microsoft Defender for Cloud is the Azure-native solution for securing your containers. |
|  | [Artifact Registry](https://cloud.google.com/artifact-registry) | [Azure Container Registry](/azure/container-registry/container-registry-intro) | A managed, private Docker registry service based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your private Docker container images and related artifacts. This approach ensures that you deploy only trusted containers. |
| AI security assistant | [Sec-Gemini](https://secgemini.google/) <br><br> [Gemini in Security Operations](https://cloud.google.com/security/products/security-operations) | [Microsoft Security Copilot](/copilot/security/microsoft-security-copilot) | Microsoft Security Copilot is a generative AI-powered security solution that helps security teams investigate and remediate threats, build Kusto Query Language (KQL) queries from natural language, reverse-engineer scripts, and generate incident summaries that include step-by-step response guidance. |

### Security architectures

| Architecture | Description |
| --- | --- |
| [Securely managed web applications](../example-scenario/apps/fully-managed-secure-apps.yml) | Learn how to deploy secure applications by using an App Service Environment, Azure Application Gateway, and Azure Web Application Firewall. |

View all [security architectures](../browse/index.yml?azure_categories=security).

## Storage

### Object storage

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Cloud Storage](https://cloud.google.com/storage#documentation) <br><br> [Cloud Storage for Firebase](https://firebase.google.com/products/storage) | [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) | Object storage service for use cases including cloud applications, content distribution, backup, archiving, disaster recovery, and big data analytics. |

### Block storage

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Persistent Disk](https://cloud.google.com/compute/docs/disks) <br><br> [Local SSD](https://cloud.google.com/compute/docs/disks/local-ssd) | [Azure Disk Storage](https://azure.microsoft.com/services/storage/disks) | Solid-state drive (SSD) storage optimized for input/output (I/O)-intensive read and write operations. Provides high-performance Azure VM storage. |

### File storage

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Filestore](https://cloud.google.com/filestore/docs) | [Azure Files](https://azure.microsoft.com/services/storage/files/) <br><br> [Azure NetApp Files](https://azure.microsoft.com/services/netapp/#overview) | File-based storage and hosted NetApp appliance storage. |
| [Google Drive](https://workspace.google.com/products/drive) | [OneDrive for work or school](https://www.microsoft.com/microsoft-365/onedrive/onedrive-for-business) | Cloud storage and file sharing solution for businesses to store, access, and share files. |

### Bulk data transfer

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [Transfer Appliance](https://cloud.google.com/transfer-appliance/docs/2.0) | [Azure Import/Export service](/azure/storage/common/storage-import-export-service) | A data transport solution that uses secure disks and appliances to transfer large amounts of data. Also offers data protection during transit. |
| [Transfer Appliance](https://cloud.google.com/transfer-appliance/docs/2.0) | [Azure Data Box](https://azure.microsoft.com/services/storage/databox) | Petabyte-scale to exabyte-scale data transport solution that uses secure data storage devices to transfer large amounts of data to and from Azure. |

Learn more about [storage services in Azure](../guide/technology-choices/storage-options.md).

## Application services

| Google Cloud service | Azure service | Description |
| --- | --- | --- |
| [App Engine](https://cloud.google.com/appengine/docs) | [Azure App Service](/azure/app-service/overview) | Managed hosting platform that provides services for deploying and scaling web applications and services. |
| [Apigee](https://cloud.google.com/apigee) | [Azure API Management](/azure/api-management/api-management-key-concepts) | A managed service for publishing APIs to external and internal consumers. |

### Web architectures

| Architecture | Description |
| --- | --- |
| [Serverless web application](/azure/architecture/web-apps/serverless/architectures/web-app) | This reference architecture describes a serverless web application, which serves static content from Azure Blob Storage and implements an API by using Azure Functions. |

View all [web architectures](../browse/index.yml?azure_categories=web).

## Miscellaneous

| Area | Google Cloud service | Azure service | Description |
| --- | --- | --- | --- |
| Workflow | [Composer](https://cloud.google.com/composer) | [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) | Serverless technology that connects apps, data, and devices on-premises or in the cloud for large ecosystems of SaaS and cloud-based connectors. |
| Enterprise application services | [G Suite](https://gsuite.google.com) | [Microsoft 365](https://products.office.com) | Fully integrated cloud service that provides communications, email, document management in the cloud. Available on a wide range of devices. |
| Gaming | [Game Servers](https://cloud.google.com/game-servers) | [Azure PlayFab](https://playfab.com) | Managed services for hosting dedicated game servers. |
| Hybrid | [Anthos](https://cloud.google.com/anthos) | [Azure Arc](https://azure.microsoft.com/services/azure-arc) | For customers who want to simplify complex and distributed environments across on-premises, edge, and multicloud. Supports deployment of Azure services anywhere and extends Azure management to any infrastructure. |
| Blockchain | [Digital Asset](https://developers.google.com/digital-asset-links) | [Azure confidential ledger](https://azure.microsoft.com/services/azure-confidential-ledger) | Tamperproof, unstructured data store hosted in trusted execution environments and backed by cryptographically verifiable evidence. |
| Monitoring | [Cloud Monitoring](https://cloud.google.com/monitoring) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) | Service that provides visibility into the performance, uptime, and overall health of cloud-powered applications. |
| Logging | [Cloud Logging](https://cloud.google.com/logging) | [Log Analytics](/azure/azure-monitor/log-query/get-started-portal) | Service for real-time log management and analysis. |

## Migration tools

| Area | Google Cloud service | Azure Service | Description |
| --- | --- | --- | --- |
| App migration to containers | Migrate for Anthos | [Azure Migrate: app containerization tool](/azure/migrate/tutorial-app-containerization-aspnet-kubernetes) | Modernize your application by migrating it to AKS or Azure App Service containers. |
| Migration of VMs | [Migrate to Virtual Machines](https://docs.cloud.google.com/migrate/virtual-machines/docs/5.0) | [Azure Migrate: server migration tool](/azure/migrate/tutorial-migrate-physical-virtual-machines) | Migrate servers from anywhere to Azure. |
| VMware migration | [Google Cloud VMware Engine](https://cloud.google.com/vmware-engine) | [Azure VMware Solution](/azure/migrate/vmware/start-here-vmware) | Move or extend on-premises VMware environments to Azure. |
| Migration of databases | [Database Migration Service](https://cloud.google.com/database-migration) | [Azure Database Migration Service](/azure/dms/dms-overview) | Managed service that facilitates migrations from multiple database sources to Azure data platforms with minimal downtime. |
| Migration programs | [Google Cloud Rapid Assessment and Migration Program (RAMP)](https://cloud.google.com/solutions/cloud-migration-program) | [Azure Migration and Modernization Program](https://azure.microsoft.com/migration/migration-modernization-program/#overview) | Learn how to move your apps, data, and infrastructure to Azure using a proven cloud migration and modernization approach. |
| Server assessment | [Migrate to Google Cloud](https://cloud.google.com/architecture/migration-to-gcp-assessing-and-discovering-your-workloads) | [Azure Migrate](/azure/migrate/migrate-services-overview#azure-migrate-discovery-and-assessment-tool) | Increases business intelligence by accurately presenting entire IT environments within a single day. |
| Database assessment | [Migrate to Google Cloud](https://cloud.google.com/architecture/migration-to-gcp-assessing-and-discovering-your-workloads) | [Data Migration Assistant](/azure/migrate/concepts-azure-sql-assessment-calculation) | Helps identify potential problems that block migration. Identifies unsupported features, new features that can benefit you after migration, and the right path for database migration. |
| Web app assessment and migration | [Google Cloud Application Migration](https://cloud.google.com/solutions/application-migration) | [Web app migration assistant](https://appmigration.microsoft.com) <br><br> [Azure Migrate application and code assessment](/azure/migrate/appcat/) <br><br> [Azure Migrate](/azure/migrate/concepts-migration-webapps) | Assess on-premises web apps and migrate them to Azure. |

## Next steps

If you're new to Azure, review the interactive [Core Cloud Services Introduction to Azure](/training/modules/welcome-to-azure) module on [Microsoft Learn training](/training).

## Related resources

- [Discover Google Cloud instances](/azure/migrate/tutorial-discover-gcp)
- [Assess Google Cloud VM instances](/azure/migrate/tutorial-assess-gcp)
- [Migrate Google Cloud VMs to Azure](/azure/migrate/tutorial-migrate-gcp-virtual-machines)
