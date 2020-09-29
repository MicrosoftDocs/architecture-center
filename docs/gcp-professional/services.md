---
title: GCP to Azure Services Comparison
description: Understand the differences between specific GCP and Azure services.
keywords: GCP experts, Azure comparison, GCP comparison, difference between Azure and GCP, Azure and GCP
author: doodlemania2
ms.date: 03/15/2020
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: fcp
---

# GCP to Azure services comparison

This article helps you understand how Microsoft Azure services compare to Google Cloud Platform (GCP). Whether you are planning a multi-cloud solution with Azure and GCP, or migrating to Azure, you can compare the IT capabilities of Azure and GCP services in all categories.

This article compares services that are roughly comparable. Not every GCP service or Azure service is listed, and not every matched service has exact feature-for-feature parity.

For an overview of Azure for GCP users, see Introduction to [Azure for GCP Professionals](./index.md).

## Marketplace

| GCP service | Azure service | Description |
| --- | --- | --- |
| [GCP Marketplace](https://cloud.google.com/marketplace) | [Azure Marketplace](https://azure.microsoft.com/marketplace/) | Easy-to-deploy and automatically configured third-party applications, including single virtual machine or multiple virtual machine solutions. |

## AI and Machine Learning

| GCP service | Azure service | Description |
| --- | --- | --- |
| [AI Hub](https://cloud.google.com/ai-hub) | [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning-services/) | A cloud service to train, deploy, automate, and manage machine learning models. |
| [TensorFlow](https://www.tensorflow.org/) | [ML.NET](https://dotnet.microsoft.com/apps/machinelearning-ai/ml-dotnet) | ML.NET is an open source and cross-platform machine learning framework for both machine learning & AI. |
| [TensorFlow](https://www.tensorflow.org/) | [ONNX (Open Neural Network Exchange)](http://onnx.ai/) | ONNX is an open format built to represent machine learning models that facilitates maximum compatibility and increased inference performance. |
| [AI Building blocks - Sight](https://cloud.google.com/vision) | [Azure Cognitive Services Computer Vision](https://azure.microsoft.com/services/cognitive-services/computer-vision/) | Use visual data processing to label content, from objects to concepts, extract printed and handwritten text, recognize familiar subjects like brands and landmarks, and moderate content. No machine learning expertise is required. |
| [AI Building blocks - Language](https://cloud.google.com/natural-language) | [Azure Cognitive Services Text Analytics](https://azure.microsoft.com/services/cognitive-services/text-analytics/) | Cloud-based services that provides advanced natural language processing over raw text, and includes four main functions: sentiment analysis, key phrase extraction, language detection, and named entity recognition. |
| [AI Building blocks - Language](https://cloud.google.com/natural-language) | [Azure Cognitive Services Language Understanding (LUIS)](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service/) | A machine learning-based service to build natural language understanding into apps, bots, and IoT devices. Quickly create enterprise-ready, custom models that continuously improve.|
| [AI Building blocks - Conversation](https://cloud.google.com/speech-to-text) | [Azure Cognitive Services Speech To Text](https://azure.microsoft.com/services/cognitive-services/speech-to-text/) | Swiftly convert audio into text from a variety of sources. Customize models to overcome common speech recognition barriers, such as unique vocabularies, speaking styles, or background noise. |
| [AI Building blocks – Structured Data](https://cloud.google.com/automl-tables) | [Azure ML - Automated Machine Learning](https://azure.microsoft.com/services/machine-learning/automatedml/) | Empower professional and non-professional data scientists to build machine learning models rapidly. Automate time-consuming and iterative tasks of model development using breakthrough research-and accelerate time to market. Available in Azure Machine learning, Power BI, ML.NET & Visual Studio. |
| [AI Building blocks – Structured Data](https://cloud.google.com/automl-tables) | [ML.NET Model Builder](https://dotnet.microsoft.com/apps/machinelearning-ai/ml-dotnet/model-builder) | ML.NET Model Builder provides an easy to understand visual interface to build, train, and deploy custom machine learning models. Prior machine learning expertise is not required. Model Builder supports AutoML, which automatically explores different machine learning algorithms and settings to help you find the one that best suits your scenario. |
| [AI Building blocks – Cloud AutoML](https://cloud.google.com/automl) | [Azure Cognitive Services Custom Vision](https://azure.microsoft.com/services/cognitive-services/custom-vision-service/) | Customize and embed state-of-the-art computer vision for specific domains. Build frictionless customer experiences, optimize manufacturing processes, accelerate digital marketing campaigns-and more. No machine learning expertise is required. |
| [AI Building blocks – Cloud AutoML](https://cloud.google.com/automl) | [Video Indexer](https://vi.microsoft.com/) | Easily extract insights from your videos and quickly enrich your applications to enhance discovery and engagement. |
| [AI Building blocks – Cloud AutoML](https://cloud.google.com/automl) | [Azure Cognitive Services QnA Maker](https://www.qnamaker.ai/) | Build, train and publish a sophisticated bot using FAQ pages, support websites, product manuals, SharePoint documents or editorial content through an easy-to-use UI or via REST APIs. |
| [AI Platform Notebooks](https://cloud.google.com/ai-platform-notebooks) | [Azure Notebooks](https://notebooks.azure.com/) | Develop and run code from anywhere with Jupyter notebooks on Azure. |
| [Deep Learning VM Image](https://cloud.google.com/deep-learning-vm) | [Data Science Virtual Machines](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines/) | Pre-Configured environments in the cloud for Data Science and AI Development. |
| [Deep Learning Containers](https://cloud.google.com/ai-platform/deep-learning-containers) | [GPU support on Azure Kubernetes Service (AKS)](/azure/aks/gpu-cluster) | Graphical processing units (GPUs) are often used for compute-intensive workloads such as graphics and visualization workloads. AKS supports the creation of GPU-enabled node pools to run these compute-intensive workloads in Kubernetes. |
| [Data Labeling Service](https://cloud.google.com/ai-platform/data-labeling/docs) | [Azure ML - Data Labeling](/azure/machine-learning/how-to-create-labeling-projects) | A central place to create, manage, and monitor labeling projects (public preview). Use it to coordinate data, labels, and team members to efficiently manage labeling tasks. Machine Learning supports image classification, either multi-label or multi-class, and object identification with bounded boxes. |
| [AI Platform Training](https://cloud.google.com/ai-platform/training/docs/overview) | [Azure ML – Compute Targets](/azure/machine-learning/concept-compute-target) | Designated compute resource/environment where you run your training script or host your service deployment. This location may be your local machine or a cloud-based compute resource. Using compute targets make it easy for you to later change your compute environment without having to change your code. |
| [AI Platform Predictions](https://cloud.google.com/ai-platform/prediction/docs/overview) | [Azure ML - Deployments](/azure/machine-learning/how-to-deploy-and-where) | Deploy your machine learning model as a web service in the Azure cloud or to Azure IoT Edge devices. Leverage serverless Azure Functions for model inference for dynamic scale. |
| [Continuous Evaluation](https://cloud.google.com/ai-platform/prediction/docs/continuous-evaluation/) | [Azure ML – Data Drift](/azure/machine-learning/how-to-monitor-data-drift) | Monitor for data drift between the training dataset and inference data of a deployed model. In the context of machine learning, trained machine learning models may experience degraded prediction performance because of drift. With Azure Machine Learning, you can monitor data drift and the service can send an email alert to you when drift is detected. |
| [What-If Tool](https://cloud.google.com/blog/products/ai-machine-learning/introducing-the-what-if-tool-for-cloud-ai-platform-models) | [Azure ML – Model Interpretability](/azure/machine-learning/how-to-machine-learning-interpretability) | Ensure machine learning model compliance with company policies, industry standards, and government regulations. |
| [Cloud TPU](https://cloud.google.com/tpu) | [Azure ML – FPGA (Field Programmable Gate Arrays)](/azure/machine-learning/how-to-deploy-fpga-web-service) | FPGAs contain an array of programmable logic blocks, and a hierarchy of reconfigurable interconnects. The interconnects allow these blocks to be configured in various ways after manufacturing. Compared to other chips, FPGAs provide a combination of programmability and performance. |
| [Kubeflow](https://www.kubeflow.org/docs/about/kubeflow/) | [Machine Learning Operations (MLOps)](https://azure.microsoft.com/services/machine-learning/mlops/) | MLOps, or DevOps for machine learning, enables data science and IT teams to collaborate and increase the pace of model development and deployment via monitoring, validation, and governance of machine learning models. |
| [Dialogflow](https://dialogflow.com/) | [Microsoft Bot Framework](https://dev.botframework.com/) | Build and connect intelligent bots that interact with your users using text/SMS, Skype, Teams, Slack, Microsoft 365 mail, Twitter, and other popular services. |

## Big data and analytics

### Data warehouse

| GCP service | Azure service | Description |
| --- | --- | --- |
| [BigQuery](https://cloud.google.com/bigquery) | [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) | Cloud-based Enterprise Data Warehouse (EDW) that uses Massively Parallel Processing (MPP) to quickly run complex queries across petabytes of data. |
| [BigQuery](https://cloud.google.com/bigquery) | [SQL Server Big Data Clusters](/sql/big-data-cluster/big-data-cluster-overview?view=sql-server-ver15) | Allow you to deploy scalable clusters of SQL Server, Spark, and HDFS containers running on Kubernetes. These components are running side by side to enable you to read, write, and process big data from Transact-SQL or Spark, allowing you to easily combine and analyze your high-value relational data with high-volume big data. |

### Big data processing

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Dataproc](https://cloud.google.com/dataproc) | [Azure HDInsight](/azure/hdinsight/) | Managed Apache Spark-based analytics platform. |

### Data Orchestration and ETL

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Cloud Data Fusion](https://cloud.google.com/data-fusion) | [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) | Processes and moves data between different compute and storage services, as well as on-premises data sources at specified intervals. Create, schedule, orchestrate, and manage data pipelines. |
| [Cloud Data Catalog](https://cloud.google.com/data-catalog) | [Azure Data Catalog](https://azure.microsoft.com/services/data-catalog/) | A fully managed service that serves as a system of registration and system of discovery for enterprise data sources |

### Analytics and visualization

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Cloud Dataflow](https://cloud.google.com/dataflow) | [Azure Databricks](https://azure.microsoft.com/services/databricks/#documentation) | Managed platform for streaming batch data based on Open Source Apache products. |
| [Datastudio](https://datastudio.google.com/overview) <br/><br/> [Looker](https://cloud.google.com/looker) | [Power BI](https://powerbi.microsoft.com/) | Business intelligence tools that build visualizations, perform ad hoc analysis, and develop business insights from data. |
| [Cloud Search](https://cloud.google.com/products/search) | [Azure Search](https://azure.microsoft.com/services/search/) | Delivers full-text search and related search analytics and capabilities. |
| [BigQuery](https://cloud.google.com/bigquery) | [SQL Server – ML Services](/sql/machine-learning/sql-server-machine-learning-services)<br/><br/> [Big Data Clusters (Spark)](/sql/big-data-cluster/big-data-cluster-overview) <br/><br/> [SQL Server Analysis Services](/analysis-services/analysis-services-overview) | Provides a serverless non-cloud interactive query service that uses standard SQL for analyzing databases. |

## Compute

### Virtual servers

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Compute Engine](https://cloud.google.com/compute#documentation) | [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) | Virtual servers allow users to deploy, manage, and maintain OS and server software. Instance types provide combinations of CPU/RAM. Users pay for what they use with the flexibility to change sizes. |
| [Batch](https://cloud.google.com/kubernetes-engine/docs/concepts/batch) | [Azure Batch](https://azure.microsoft.com/services/batch/) | Run large-scale parallel and high-performance computing applications efficiently in the cloud. |
| [Compute Engine Managed Instance Groups](https://cloud.google.com/compute/docs/instance-groups/) | [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview) | Allows you to automatically change the number of VM instances. You set defined metric and thresholds that determine if the platform adds or removes instances. |
| [VMware as a service](https://cloud.google.com/solutions/vmware-as-a-service) | [Azure VMware by CloudSimple](https://azure.microsoft.com/services/azure-vmware-cloudsimple/) | Redeploy and extend your VMware-based enterprise workloads to Azure with Azure VMware Solution by CloudSimple. Keep using the VMware tools you already know to manage workloads on Azure without disrupting network, security, or data protection policies. |

### Containers and container orchestrators

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Cloud Run](https://cloud.google.com/run#documentation) | [Azure Container Instances](https://azure.microsoft.com/services/container-instances/) | Azure Container Instances is the fastest and simplest way to run a container in Azure, without having to provision any virtual machines or adopt a higher-level orchestration service. |
| [Artifact Registry (beta)](https://cloud.google.com/artifacts/docs) <br/><br/> [Container Registry](https://cloud.google.com/container-registry/docs) | [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) | Allows customers to store Docker formatted images. Used to create all types of container deployments on Azure. |
| [Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine#documentation) | [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) | Deploy orchestrated containerized applications with Kubernetes. Simplify monitoring and cluster management through auto upgrades and a built-in operations console. |
| [Kubernetes Engine Monitoring](https://cloud.google.com/monitoring/kubernetes-engine) | [Azure Monitor for containers](/azure/azure-monitor/insights/container-insights-overview) | Azure Monitor for containers is a feature designed to monitor the performance of container workloads deployed to: Managed Kubernetes clusters hosted on Azure Kubernetes Service (AKS); Self-managed Kubernetes clusters hosted on Azure using [AKS Engine](https://github.com/Azure/aks-engine); Azure Container Instances, Self-managed Kubernetes clusters hosted on [Azure Stack](/azure-stack/user/azure-stack-kubernetes-aks-engine-overview?view=azs-1910) or on-premises; or [Azure Red Hat OpenShift](/azure/openshift/intro-openshift). |
| [Anthos Service Mesh](https://cloud.google.com/service-mesh/docs) | [Service Fabric Mesh](/azure/service-fabric-mesh/service-fabric-mesh-overview) | Fully managed service that enables developers to deploy microservices applications without managing virtual machines, storage, or networking. |

### Functions

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Cloud Functions](https://cloud.google.com/functions/#documentation) | [Azure Functions](https://azure.microsoft.com/services/functions/) | Integrate systems and run backend processes in response to events or schedules without provisioning or managing servers. |

##  Database

| Type | GCP Service | Azure Service | Description |
| --- | --- | --- | --- |
| Relational database (PaaS) | [Cloud SQL](https://cloud.google.com/sql#documentation) ( SQL Server, MySQL, PostgreSQL ) | [SQL Server Options](/azure/sql-database/sql-database-paas-vs-sql-server-iaas) <br/><br/>Azure Database for [MySQL](/azure/mysql/) <br/><br/>Azure Database for [PostgreSQL](/azure/postgresql/) | Managed relational database service where resiliency, security, scale, and maintenance are primarily handled by the platform. |
| | Cloud Spanner | [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) | Managed relational database service where resiliency, security, scale, and maintenance are primarily handled by the platform. |
| NoSQL (PaaS) | [Cloud Bigtable](https://cloud.google.com/bigtable/docs)<br/><br/> [Cloud Firestore](https://cloud.google.com/firestore/docs)<br/><br/> [Firebase Realtime Database](https://firebase.google.com/products/realtime-database/) | [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) | Globally distributed, multi-model database that natively supports multiple data models: key-value, documents, graphs, and columnar. |
| Caching | [Cloud Memorystore](https://cloud.google.com/memorystore/docs)<br/><br/> [Redis Enterprise Cloud](https://console.cloud.google.com/apis/library/gcp.redisenterprise.com?pli=1) | [Azure Cache for Redis](https://azure.microsoft.com/services/cache/) | An in-memory–based, distributed caching service that provides a high-performance store typically used to offload non-transactional work from a database. |

## DevOps and application monitoring

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](https://azure.microsoft.com/services/monitor/) | Maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing and proactively identifies issues affecting them and the resources on which they depend. |
| [Cloud Trace](https://cloud.google.com/trace) | [Azure Monitor](https://azure.microsoft.com/services/monitor/) | Maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing and proactively identifies issues affecting them and the resources on which they depend. |
| [Cloud Debugger](https://cloud.google.com/debugger) | [Azure Monitor](https://azure.microsoft.com/services/monitor/) | Maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing and proactively identifies issues affecting them and the resources on which they depend. |
| [Cloud Profiler](https://cloud.google.com/profiler) | [Azure Monitor](https://azure.microsoft.com/services/monitor/) | Maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing and proactively identifies issues affecting them and the resources on which they depend. |
| [Cloud Source Repositories](https://cloud.google.com/source-repositories) | [Azure DevOps Repos](https://azure.microsoft.com/services/devops/repos/?nav=min), [GitHub Repos](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/about-repositories) | A cloud service for collaborating on code development. |
| [Cloud Build](https://cloud.google.com/cloud-build) | [Azure DevOps Pipelines](https://azure.microsoft.com/services/devops/pipelines/?nav=min), [GitHub Actions](https://github.com/features/actions) | Fully managed build service that supports continuous integration and deployment. |
| [Artifact Registry](https://cloud.google.com/artifact-registry/docs/overview) | [Azure DevOps Artifacts](https://azure.microsoft.com/services/devops/artifacts/), [GitHub Packages](https://github.com/features/packages) | Add fully integrated package management to your continuous integration/continuous delivery (CI/CD) pipelines with a single click. Create and share Maven, npm, NuGet, and Python package feeds from public and private sources with teams of any size. |
| [Cloud Developer Tools](https://cloud.google.com/products/tools) (including Cloud Code) | [Azure Developer Tools](https://azure.microsoft.com/product-categories/developer-tools/) | Collection of tools for building, debugging, deploying, diagnosing, and managing multiplatform scalable apps and services. |
| [Gcloud SDK](https://cloud.google.com/sdk) | [Azure CLI](/cli/azure/?view=azure-cli-latest) | The Azure command-line interface (Azure CLI) is a set of commands used to create and manage Azure resources. The Azure CLI is available across Azure services and is designed to get you working quickly with Azure, with an emphasis on automation. |
| [Cloud Shell](https://cloud.google.com/shell) | [Azure Cloud Shell](/azure/cloud-shell/overview) | Azure Cloud Shell is an interactive, authenticated, browser-accessible shell for managing Azure resources. It provides the flexibility of choosing the shell experience that best suits the way you work, either Bash or PowerShell. |
| [PowerShell on GCP](https://cloud.google.com/tools/powershell/docs/quickstart) | [Azure PowerShell](/powershell/azure/?view=azps-3.7.0) | Azure PowerShell is a set of cmdlets for managing Azure resources directly from the PowerShell command line. Azure PowerShell is designed to make it easy to learn and get started with, but provides powerful features for automation. Written in .NET Standard, Azure PowerShell works with PowerShell 5.1 on Windows, and PowerShell 6.x and higher on all platforms. |
| [Cloud Deployment Manager](https://cloud.google.com/deployment-manager) | [Azure Automation](https://azure.microsoft.com/services/automation/) | Delivers a cloud-based automation and configuration service that supports consistent management across your Azure and non-Azure environments. It comprises process automation, configuration management, update management, shared capabilities, and heterogeneous features. Automation gives you complete control during deployment, operations, and decommissioning of workloads and resources. |
| [Cloud Deployment Manager](https://cloud.google.com/deployment-manager) | [Azure Resource Manager](https://azure.microsoft.com/features/resource-manager/) | Provides a way for users to automate the manual, long-running, error-prone, and frequently repeated IT tasks. |

## Internet of things (IoT)

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Cloud IoT Core](https://cloud.google.com/iot/docs) | [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/),[Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) | A cloud gateway for managing bidirectional communication with billions of IoT devices, securely and at scale. |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/#documentation),[HDInsight Kafka](/azure/hdinsight/) | Process and route streaming data to subsequent processing engine or storage or database platform. |
| [Edge Tpu](https://cloud.google.com/edge-tpu) | [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) | Deploy cloud intelligence directly on IoT devices to run in on-premises scenarios. |

## Management

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Cloud Billing](https://cloud.google.com/billing/docs) | [Azure Billing API](/azure/billing/billing-usage-rate-card-overview) | Services to help generate, monitor, forecast, and share billing data for resource usage by time, organization, or product resources. |
| Cloud Console | [Azure portal](https://azure.microsoft.com/features/azure-portal/) | A unified management console that simplifies building, deploying, and operating your cloud resources. |
| [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](https://azure.microsoft.com/services/monitor/) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |

## Messaging and eventing

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Service Bus](https://azure.microsoft.com/services/service-bus/) | Supports a set of cloud-based, message-oriented middleware technologies including reliable message queuing and durable publish/subscribe messaging. |
| [Cloud Pub/Sub](https://cloud.google.com/pubsub/docs) | [Azure Event Grid](https://azure.microsoft.com/services/event-grid/) | A fully managed event routing service that allows for uniform event consumption using a publish/subscribe model. |

## Networking

| Area | GCP service | Azure service | Description |
| --- | --- | --- | --- |
| Cloud virtual networking | [Virtual Private Network (VPC)](https://cloud.google.com/vpc) | [Azure Virtual Network (Vnet)](/azure/virtual-network/virtual-networks-overview) | Provides an isolated, private environment in the cloud. Users have control over their virtual networking environment, including selection of their own IP address range, adding/updating address ranges, creation of subnets, and configuration of route tables and network gateways. |
| DNS management | [Cloud DNS](https://cloud.google.com/dns) | [Azure DNS](/azure/dns/dns-overview) | Manage your DNS records using the same credentials and billing and support contract as your other Azure services |
| | [Cloud DNS](https://cloud.google.com/dns) | [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) | Azure Traffic Manager is a DNS-based load balancer that enables you to distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness. |
| Hybrid Connectivity | [Cloud Interconnect](https://cloud.google.com/interconnect/docs) | [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) | Establishes a private network connection from a location to the cloud provider (not over the Internet). |
| | [Cloud VPN Gateway](https://cloud.google.com/vpn/docs/concepts/overview) | [Azure Virtual Network Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) | Connects Azure virtual networks to other Azure virtual networks, or customer on-premises networks (site-to-site). Allows end users to connect to Azure services through VPN tunneling (point-to-site). |
| | [Cloud VPN Gateway](https://cloud.google.com/vpn/docs/concepts/overview) | [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about) | Azure virtual WAN simplifies large scale branch connectivity with VPN and ExpressRoute. |
| | [Cloud router](https://cloud.google.com/router/docs) | [Azure Virtual Network Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) | Enables dynamic routes exchange using BGP. |
| Load balancing | [Network Load Balancing](https://cloud.google.com/load-balancing) | [Azure Load Balancer](/azure/load-balancer/load-balancer-overview) | Azure Load Balancer load-balances traffic at layer 4 (all TCP or UDP). |
| | [Global load balancing](https://cloud.google.com/load-balancing) | [Azure Front door](/azure/frontdoor/front-door-overview) | Azure front door enables global load balancing across regions using a single anycast IP. |
| | [Global load balancing](https://cloud.google.com/load-balancing) | [Azure Application Gateway](/azure/application-gateway/overview) | Application Gateway is a layer 7 load balancer. IT takes backends with any IP that is reachable. It supports SSL termination, cookie-based session affinity, and round robin for load-balancing traffic. |
| | [Global load balancing](https://cloud.google.com/load-balancing) | [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) | Azure Traffic Manager is a DNS-based load balancer that enables you to distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness. |
| Content delivery network | [Cloud CDN](https://cloud.google.com/cdn) | [Azure CDN](/azure/cdn/cdn-overview) | A content delivery network (CDN) is a distributed network of servers that can efficiently deliver web content to users. |
| Firewall | [Firewall rules](https://cloud.google.com/vpc/docs/firewalls) | [Application security groups](/azure/virtual-network/application-security-groups) | Azure Application security groups allows you to group virtual machines and define network security policies based on those groups. |
| | [Firewall rules](https://cloud.google.com/vpc/docs/firewalls) | [Network Security groups](/azure/virtual-network/security-overview) | Azure network security group filters network traffic to and from Azure resources in an Azure virtual network. |
| | [Firewall rules](https://cloud.google.com/vpc/docs/firewalls) | [Azure Firewall](/azure/firewall/overview) | Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. |
| Web Application Firewall | [Cloud Armor](https://cloud.google.com/armor) | [Application Gateway - Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) | Azure Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities. |
| | [Cloud Armor](https://cloud.google.com/armor) | [Front door – Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview) | Azure Web Application Firewall (WAF) on Azure Front Door provides centralized protection for your web applications. |
| | [Cloud Armor](https://cloud.google.com/armor) | [CDN – Azure Web Application Firewall](/azure/web-application-firewall/cdn/cdn-overview) | Azure Web Application Firewall (WAF) on Azure Content Delivery Network (CDN) from Microsoft provides centralized protection for your web content. |
| NAT Gateway | [Cloud NAT](https://cloud.google.com/nat) | [Azure Virtual Network NAT](/azure/virtual-network/nat-overview) | Virtual Network NAT (network address translation) provides outbound NAT translations for internet connectivity for virtual networks. |
| Private Connectivity to PaaS | [VPC Service controls](https://cloud.google.com/vpc-service-controls) | [Azure Private Link](/azure/private-link/private-link-overview) | Azure Private Link enables you to access Azure PaaS Services and Azure hosted customer-owned/partner services over a private endpoint in your virtual network. |
| Telemetry | [VPC Flow logs](https://cloud.google.com/vpc/docs/using-flow-logs) | [NSG Flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview) | Network security group (NSG) flow logs are a feature of Network Watcher that allows you to view information about ingress and egress IP traffic through an NSG. |
| | [Firewall Rules Logging](https://cloud.google.com/vpc/docs/firewall-rules-logging) | [NSG Flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview) | Network security group (NSG) flow logs are a feature of Network Watcher that allows you to view information about ingress and egress IP traffic through an NSG. |
| | [Operations (formerly Stackdriver)](https://cloud.google.com/products/operations) | [Azure Monitor](/azure/azure-monitor/overview) | Azure Monitor delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. Log queries help you to fully leverage the value of the data collected in Azure Monitor Logs. |
| | [Network Intelligence Center](https://cloud.google.com/network-intelligence-center) | [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) | Azure Network Watcher provides tools to monitor, diagnose, view metrics, and enable or disable logs for resources in an Azure virtual network. |

## Security

| Area | GCP service | Azure service | Description |
| --- | --- | --- | --- |
| Authentication and Authorization | [Cloud IAM](https://cloud.google.com/iam) | [Azure Active Directory](https://azure.microsoft.com/services/active-directory/) | Allows users to securely control access to services and resources while offering data security and protection. Create and manage users and groups and use permissions to allow and deny access to resources. |
| | [Cloud IAM](https://cloud.google.com/iam) | [Azure Role Based Access Control](/azure/role-based-access-control/overview) | Role-based access control (RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. |
| | Resource Manager | [Azure Subscription Management](/azure/cloud-adoption-framework/decision-guides/subscriptions/) | Structure to organize and manage assets in Azure. |
| | Multi-factor Authentication | [Azure Active Directory Multi-factor Authentication](https://azure.microsoft.com/services/multi-factor-authentication/) | Safeguard access to data and applications while meeting user demand for a simple sign-in process. |
| | [Firebase Authentication](https://firebase.google.com/docs/auth) | [Azure Active Directory B2C](https://azure.microsoft.com/services/active-directory-b2c/) | A highly available, global, identity management service for consumer-facing applications that scales to hundreds of millions of identities. |
| Encryption | [Cloud KMS](https://cloud.google.com/kms) | [Azure Key Vault](https://azure.microsoft.com/services/key-vault/) | Provides security solution and works with other services by providing a way to manage, create, and control encryption keys stored in hardware security modules (HSM). |
| Data at rest encryption | [Encryption by default](https://cloud.google.com/security/encryption-at-rest) | [Azure Storage Service Encryption](/azure/storage/storage-service-encryption) - encryption by default | Azure Storage Service Encryption helps you protect and safeguard your data and meet your organizational security and compliance commitments. |
| Security | [Security Command Center](https://cloud.google.com/security-command-center) | [Azure Security Center](https://azure.microsoft.com/services/security-center/) | An automated security assessment service that improves the security and compliance of applications. Automatically assess applications for vulnerabilities or deviations from best practices. |
| | [Web Security Scanner](https://cloud.google.com/security-scanner) | [Azure Security Center](https://azure.microsoft.com/services/security-center/) | An automated security assessment service that improves the security and compliance of applications. Automatically assess applications for vulnerabilities or deviations from best practices. |
| | [Event Threat Detection](https://cloud.google.com/event-threat-detection) | [Azure Advanced Threat Protection](https://azure.microsoft.com/features/azure-advanced-threat-protection/) | Detect and investigate advanced attacks on-premises and in the cloud. |

## Storage

### Object storage

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Cloud Storage](https://cloud.google.com/storage#documentation)<br/><br/> [Cloud Storage for Firebase](https://firebase.google.com/products/storage/) | [Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction) | Object storage service, for use cases including cloud applications, content distribution, backup, archiving, disaster recovery, and big data analytics. |

### Virtual server disks

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Persistant Disk](https://cloud.google.com/compute/docs/disks/)<br/><br/> [Local SSD](https://cloud.google.com/compute/docs/disks/local-ssd) | [Azure managed disks](https://azure.microsoft.com/services/storage/disks/) | SSD storage optimized for I/O intensive read/write operations. For use as high-performance Azure virtual machine storage. |

### File Storage

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Filestore](https://cloud.google.com/filestore/docs) | [Azure Files](https://azure.microsoft.com/services/storage/files/),[Azure NetApp Files](https://azure.microsoft.com/services/netapp/#overview) | File based storage and hosted NetApp Appliance Storage. |
| [Drive Enterprise](https://cloud.google.com/drive-enterprise) | [OneDrive For business](https://products.office.com/onedrive/onedrive-for-business) | Shared files from from personal devices to cloud |

### Bulk data transfer

| GCP service | Azure service | Description |
| --- | --- | --- |
| [Transfer Appliance](https://cloud.google.com/transfer-appliance/docs/2.0) | [Import/Export](/azure/storage/common/storage-import-export-service) | A data transport solution that uses secure disks and appliances to transfer large amounts of data. Also offers data protection during transit. |
| [Transfer Appliance](https://cloud.google.com/transfer-appliance/docs/2.0) | [Azure Data Box](https://azure.microsoft.com/services/storage/databox/) | Petabyte- to exabyte-scale data transport solution that uses secure data storage devices to transfer large amounts of data to and from Azure. |

## Application services

| GCP service | Azure service | Description |
| --- | --- | --- |
| [App Engine](https://cloud.google.com/appengine/docs) | [Azure App Service](https://azure.microsoft.com/services/app-service) | Managed hosting platform providing easy to use services for deploying and scaling web applications and services. |
| Apigee | [Azure API Management](https://azure.microsoft.com/services/api-management/) | A turnkey solution for publishing APIs to external and internal consumers. |

## Miscellaneous

| Area | GCP service | Azure service | Description |
| --- | --- | --- | --- |
| Workflow | [Composer](https://cloud.google.com/composer) | [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) | Serverless technology for connecting apps, data and devices anywhere, whether on-premises or in the cloud for large ecosystems of SaaS and cloud-based connectors. |
| Enterprise application services | [G Suite](https://gsuite.google.com/) | [Microsoft 365](https://products.office.com/) | Fully integrated Cloud service providing communications, email, document management in the cloud and available on a wide variety of devices. |
| Gaming | [Game Servers](https://cloud.google.com/game-servers/docs) | [Azure PlayFab](https://playfab.com/) | Managed services for hosting dedicated game servers. |
| Hybrid | [Anthos](https://cloud.google.com/anthos) | [Azure Arc](https://azure.microsoft.com/services/azure-arc/) | For customers who want to simplify complex and distributed environments across on-premises, edge and multi-cloud, Azure Arc enables deployment of Azure services anywhere and extends Azure management to any infrastructure. |
| Blockchain | [Digital Asset](https://developers.google.com/digital-asset-links) | [Azure Blockchain Service](https://azure.microsoft.com/services/blockchain-service/) | Azure Blockchain Service is a fully managed ledger service that enables users the ability to grow and operate blockchain networks at scale in Azure. |

## Azure Migration Tools

| Type | Azure Service | Description |
| --- | --- | --- |
| Generic Database migrationGuide (SQL or Open Source Database) | [Database migration guide](https://datamigration.microsoft.com/) | Migration of database schema and data from one database format to a specific database technology in the cloud. |
| SQL Server Database Migration Assessment Tool | [Data MigrationAssistant](/sql/dma/dma-overview?view=sql-server-ver15) | Assessment of SQL Server database before migration |
| SQL Server Database Migration Tool | [Data Migration Service](/azure/dms/) | Actual migration of database to Azure |
| Open source Database Migration Tool | Database Native Tool likemysqldump,pg\dump | Actual Migration of open source database to Azure |
| Assessment and migration tool | [Azure Migrate](https://azure.microsoft.com/services/azure-migrate/) | Assesses on-premises workloads for migration to Azure, performs performance-based sizing, and provides cost estimations. |
| Migration tool | [Movere](https://www.movere.io/) | Movere is a discovery solution that provides the data and insights needed to plan cloud migrations and continuously optimize, monitor and analyze IT environments with confidence. |

## More learning

If you are new to Azure, review the interactive [Core Cloud Services - Introduction to Azure](/learn/modules/welcome-to-azure) module on [Microsoft Learn](/learn).