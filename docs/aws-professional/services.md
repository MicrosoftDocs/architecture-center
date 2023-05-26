---
title: AWS to Azure services comparison
titleSuffix: Azure Architecture Center
description: Compare Azure cloud services to Amazon Web Services (AWS) for multicloud solutions or migration to Azure.
author: martinekuan
ms.author: yuanzhiqu
ms.date: 11/18/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom:
  - fcp
  - devx-track-jenkins
ms.category:
  - analytics
  - ai-machine-learning
keywords:
  - cloud services comparison
  - cloud services compared
  - multicloud
  - compare Azure AWS
  - compare Azure and AWS
  - compare AWS and Azure
  - IT capabilities
categories:
  - compute
  - storage
  - databases
  - networking
  - security
  - ai-machine-learning
products:
  - azure-cosmos-db
  - azure-functions
  - azure-storage
---

<!-- cSpell:ignore Alexa Rekognition Cognito ElastiCache Greengrass Firehose -->

# AWS to Azure services comparison

This article helps you understand how Microsoft Azure services compare to Amazon Web Services (AWS). Whether you are planning a multicloud solution with Azure and AWS, or migrating to Azure, you can compare the IT capabilities of Azure and AWS services in all categories.

This article compares services that are roughly comparable. Not every AWS service or Azure service is listed, and not every matched service has exact feature-for-feature parity.

## Azure and AWS for multicloud solutions

As the leading public cloud platforms, Azure and AWS each offer a broad and deep set of capabilities with global coverage. Yet many organizations choose to use both platforms together for greater choice and flexibility, as well as to spread their risk and dependencies with a multicloud approach. Consulting companies and software vendors might also build on and use both Azure and AWS, as these platforms represent most of the cloud market demand.

For an overview of Azure for AWS users, see [Introduction to Azure for AWS professionals](./index.md).

## Marketplace

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Marketplace](https://aws.amazon.com/marketplace) | [Azure Marketplace](https://azure.microsoft.com/marketplace) | Easy-to-deploy and automatically configured third-party applications, including single virtual machine or multiple virtual machine solutions. |

## AI and machine learning

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [SageMaker](https://aws.amazon.com/sagemaker) | [Machine Learning](https://azure.microsoft.com/services/machine-learning-services) | A cloud service to train, deploy, automate, and manage machine learning models. |
| [Alexa Skills Kit](https://developer.amazon.com/alexa/alexa-skills-kit) | [Bot Framework](https://dev.botframework.com) | Build and connect intelligent bots that interact with your users using text/SMS, Skype, Teams, Slack, Microsoft 365 mail, Twitter, and other popular services. |
| [Lex](https://aws.amazon.com/lex) | [Speech Services](https://azure.microsoft.com/services/cognitive-services/speech) | API capable of converting speech to text, understanding intent, and converting text back to speech for natural responsiveness. |
| [Lex](https://aws.amazon.com/lex) | [Language Understanding (LUIS)](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service) | Allows your applications to understand user commands contextually. |
| [Polly](https://aws.amazon.com/polly), [Transcribe](https://aws.amazon.com/transcribe) | [Speech Services](https://azure.microsoft.com/services/cognitive-services/speech) | Enables both Speech to Text, and Text into Speech capabilities. |
| [Rekognition](https://aws.amazon.com/rekognition) | [Cognitive Services](https://azure.microsoft.com/services/cognitive-services) | [Computer Vision](https://azure.microsoft.com/services/cognitive-services/computer-vision/): Extract information from images to categorize and process visual data.<br/><br/> [Face](https://azure.microsoft.com/services/cognitive-services/face): Detect, identify, and analyze faces and facial expressions in photos. |
| [Skills Kit](https://developer.amazon.com/alexa/alexa-skills-kit) | [Virtual Assistant](/azure/bot-service/bot-builder-virtual-assistant-introduction?view=azure-bot-service-4.0&preserve-view=true) | The Virtual Assistant Template brings together a number of best practices we've identified through the building of conversational experiences and automates integration of components that we've found to be highly beneficial to Bot Framework developers.

### AI and machine learning architectures

<ul class="grid">

[!INCLUDE [Image classification on Azure](../../includes/cards/intelligent-apps-image-processing.md)]
[!INCLUDE [Predictive Marketing with Machine Learning](../../includes/cards/predictive-marketing-campaigns-with-machine-learning-and-spark.md)]
[!INCLUDE [Scalable personalization on Azure](../../includes/cards/scalable-personalization-with-content-based-recommendation-system.md)]

</ul>

[view all](../browse/index.yml?azure_categories=ai-machine-learning)

## Big data and analytics

### Data warehouse

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Redshift](https://aws.amazon.com/redshift) | [Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) | Cloud-based enterprise data warehouse (EDW) that uses massively parallel processing (MPP) to quickly run complex queries across petabytes of data. |
| [Lake Formation](https://aws.amazon.com/lake-formation) | [Data Share](https://azure.microsoft.com/services/data-share/) | A simple and safe service for sharing big data.|

### Data warehouse architectures

<ul class="grid">

[!INCLUDE [Modern Data Warehouse Architecture](../../includes/cards/modern-data-warehouse.md)]
[!INCLUDE [Automated enterprise BI](../../includes/cards/enterprise-bi-adf.md)]

</ul>

[view all](../browse/index.yml?azure_categories=databases)

### Time series

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Amazon Timestream](https://aws.amazon.com/timestream) | [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer)<br/><br/> [Azure Time Series Insights](https://azure.microsoft.com/services/time-series-insights) | Fully managed, low latency, and distributed big data analytics platform that runs complex queries across petabytes of data. Highly optimized for log and time series data. <br/><br/> Open and scalable end-to-end IoT analytics service. Collect, process, store, query, and visualize data at Internet of Things (IoT) scale--data that's highly contextualized and optimized for time series.

### Time series architectures

<ul class="grid">

[!INCLUDE [IoT analytics with Azure Data Explorer](../../includes/cards/iot-azure-data-explorer.md)]
[!INCLUDE [Azure Data Explorer interactive analytics](../../includes/cards/interactive-azure-data-explorer.md)]

</ul>

### Big data processing

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [EMR](https://aws.amazon.com/emr) | [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer) | Fully managed, low latency, distributed big data analytics platform to run complex queries across petabytes of data. |
| [EMR](https://aws.amazon.com/emr) | [Databricks](https://azure.microsoft.com/services/databricks) | Apache Spark-based analytics platform. |
| [EMR](https://aws.amazon.com/emr) | [HDInsight](https://azure.microsoft.com/services/hdinsight) | Managed Hadoop service. Deploy and manage Hadoop clusters in Azure. |
| [EMR](https://aws.amazon.com/emr) | [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) | Massively scalable, secure data lake functionality built on Azure Blob Storage. |

### Big data architectures

<ul class="grid">

[!INCLUDE [Azure data platform end-to-end](../../includes/cards/data-platform-end-to-end.md)]
[!INCLUDE [Campaign Optimization with Azure HDInsight Spark Clusters](../../includes/cards/campaign-optimization-with-azure-hdinsight-spark-clusters.md)]
[!INCLUDE [Big data analytics with Azure Data Explorer](../../includes/cards/big-data-azure-data-explorer.md)]

</ul>

[view all](../browse/index.yml?azure_categories=databases)

### Data orchestration / ETL

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Data Pipeline](https://aws.amazon.com/datapipeline), [Glue](https://aws.amazon.com/glue) | [Data Factory](https://azure.microsoft.com/services/data-factory) | Processes and moves data between different compute and storage services, as well as on-premises data sources at specified intervals. Create, schedule, orchestrate, and manage data pipelines. |
| [Glue](https://aws.amazon.com/glue) | [Azure Purview](https://azure.microsoft.com/services/purview) | A unified data governance service that helps you manage and govern your on-premises, multicloud, and software as a service (SaaS) data. |


### Analytics and visualization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Kinesis Analytics](https://aws.amazon.com/kinesis/data-analytics) | [Stream Analytics](https://azure.microsoft.com/services/stream-analytics) <br/><br/> [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer) <br/><br/> [Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics) <br/><br/>[Data Lake Store](https://azure.microsoft.com/services/data-lake-store) | Storage and analysis platforms that create insights from large quantities of data, or data that originates from many sources. |
| [QuickSight](https://aws.amazon.com/quicksight) | [Power BI](https://powerbi.microsoft.com/) | Business intelligence tools that build visualizations, perform ad hoc analysis, and develop business insights from data.
| [CloudSearch](https://aws.amazon.com/cloudsearch) | [Cognitive Search](https://azure.microsoft.com/services/search/) | Delivers full-text search and related search analytics and capabilities. |
| [Athena](https://aws.amazon.com/athena) | [Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics) <br/><br/> [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is)| Provides a serverless interactive query service that uses standard SQL for analyzing databases. <br/><br/> Azure Synapse Analytics is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. It gives you the freedom to query data on your terms, using either serverless or dedicated resources at scale.|
| [Elasticsearch Service](https://aws.amazon.com/elasticsearch-service/the-elk-stack) | [Elastic on Azure](https://azure.microsoft.com/overview/linux-on-azure/elastic) |  Use the Elastic Stack (Elastic, Logstash, and Kibana) to search, analyze, and visualize in real time. |

### Analytics architectures

<ul class="grid">

[!INCLUDE [Advanced Analytics Architecture](../../includes/cards/advanced-analytics-on-big-data.md)]
[!INCLUDE [Automated enterprise BI](../../includes/cards/enterprise-bi-adf.md)]
[!INCLUDE [Mass ingestion and analysis of news feeds on Azure](../../includes/cards/news-feed-ingestion-and-near-real-time-analysis.md)]

</ul>

[view all](../browse/index.yml?azure_categories=analytics)

## Compute

[!INCLUDE [Compute Services](../../includes/aws/compute.md)]

## Database

[!INCLUDE [Database Services](../../includes/aws/databases.md)]

## DevOps and application monitoring

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [CloudWatch](https://aws.amazon.com/cloudwatch), [X-Ray](https://aws.amazon.com/xray/) | [Monitor](https://azure.microsoft.com/services/monitor) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [CodeDeploy](https://aws.amazon.com/codedeploy) <br/><br/>[CodeCommit](https://aws.amazon.com/codecommit/) <br/><br/>[CodePipeline](https://aws.amazon.com/codepipeline) | [DevOps](https://azure.microsoft.com/services/devops/) | A cloud service for collaborating on code development. |
| [Developer Tools](https://aws.amazon.com/products/developer-tools) | [Developer Tools](https://azure.microsoft.com/services/devops/) | Collection of tools for building, debugging, deploying, diagnosing, and managing multiplatform scalable apps and services. |
| [CodeBuild](https://aws.amazon.com/codebuild) | [DevOps Pipeline](https://azure.microsoft.com/services/devops/pipelines) <br/><br/> [Github Actions](https://github.com/features/actions) | Fully managed build service that supports continuous integration and deployment. |
| [Command Line Interface](https://aws.amazon.com/cli) | [CLI](/cli/azure/install-azure-cli) <br/><br/>[PowerShell](/powershell/azure/overview) | Built on top of the native REST API across all cloud services, various programming language-specific wrappers provide easier ways to create solutions. |
| [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) | [az aks](/cli/azure/aks) | Manage Azure Kubernetes Service using these Azure CLI commands. |
| [AWS CloudShell](https://aws.amazon.com/cloudshell) | [Azure Cloud Shell](/azure/cloud-shell/overview) | Azure Cloud Shell is an interactive, authenticated, browser-accessible shell for managing Azure resources. It gives you the flexibility to choose the shell experience that best suits the way you work, either Bash or PowerShell. |
| [OpsWorks (Chef-based)](https://aws.amazon.com/opsworks) | [Automation](https://azure.microsoft.com/services/automation) | Configures and operates applications of all shapes and sizes, and provides templates to create and manage a collection of resources. |
| [CloudFormation](https://aws.amazon.com/cloudformation) | [Resource Manager](https://azure.microsoft.com/features/resource-manager) <br/><br/>[Bicep](/azure/azure-resource-manager/bicep/overview) <br/><br/>[VM extensions](/azure/virtual-machines/extensions/features-windows) <br/><br/>[Azure Automation](https://azure.microsoft.com/services/automation) | Provides a way for users to automate the manual, long-running, error-prone, and frequently repeated IT tasks.

### DevOps architectures

<ul class="grid">

[!INCLUDE [Container CI/CD using Jenkins and Kubernetes on Azure Kubernetes Service (AKS)](../../includes/cards/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.md)]
[!INCLUDE [Run a Jenkins server on Azure](../../includes/cards/jenkins.md)]
[!INCLUDE [DevOps in a hybrid environment](../../includes/cards/devops-in-a-hybrid-environment.md)]

</ul>

[view all](../browse/index.yml?azure_categories=devops)

## Internet of things (IoT)

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [IoT Core](https://aws.amazon.com/iot-core) | [IoT Hub](https://azure.microsoft.com/services/iot-hub) | A cloud gateway for managing bidirectional communication with billions of IoT devices, securely and at scale. |
| [Greengrass](https://aws.amazon.com/greengrass) | [IoT Edge](https://azure.microsoft.com/services/iot-edge) | Deploy cloud intelligence directly onto IoT devices, catering to on-premises scenarios. |
| [Kinesis Firehose](https://aws.amazon.com/kinesis/data-firehose), [Kinesis Streams](https://aws.amazon.com/kinesis/data-streams) | [Event Hubs](https://azure.microsoft.com/services/event-hubs) | Services that facilitate the mass ingestion of events (messages), typically from devices and sensors. The data can then be processed in real-time micro-batches or be written to storage for further analysis. |
| [IoT Things Graph](https://aws.amazon.com/iot-things-graph) | [Digital Twins](https://azure.microsoft.com/services/digital-twins) | Services you can use to create digital representations of real-world things, places, business processes, and people. Use these services to gain insights, drive the creation of better products and new customer experiences, and optimize operations and costs. |

### IoT architectures

<ul class="grid">

[!INCLUDE [IoT Architecture – Azure IoT Subsystems](../../includes/cards/azure-iot-subsystems.md)]
[!INCLUDE [Azure IoT reference architecture](../../includes/cards/iot.md)]
[!INCLUDE [Process real-time vehicle data using IoT](../../includes/cards/realtime-analytics-vehicle-iot.md)]

</ul>

[view all](../browse/index.yml?azure_categories=iot)

## Management and governance

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [AWS Organizations](https://aws.amazon.com/organizations) | [Management Groups](/azure/governance/management-groups)| Azure management groups help you organize your resources and subscriptions.|
| [AWS Well-Architected Tool](https://docs.aws.amazon.com/wellarchitected/latest/userguide/intro.html)| [Azure Well-Architected Review](/assessments/?mode=pre-assessment)| Examine your workload through the lenses of reliability, cost management, operational excellence, security, and performance efficiency. |
| [Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor) | [Advisor](https://azure.microsoft.com/services/advisor) | Provides analysis of cloud resource configuration and security, so that subscribers can ensure they're making use of best practices and optimum configurations. |
| [AWS Billing and Cost Management](https://docs.aws.amazon.com/account-billing/index.html) | [Azure Cost Management and Billing](/azure/cost-management-billing) | Azure Cost Management and Billing helps you understand your Azure invoice (bill), manage your billing account and subscriptions, monitor and control Azure spending, and optimize resource use. |
| [Cost and Usage Reports](https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html) | [Usage Details API](/azure/cost-management-billing/manage/consumption-api-overview#usage-details-api) | Services to help generate, monitor, forecast, and share billing data for resource usage by time, organization, or product resources. |
| [Management Console](https://aws.amazon.com/console) | [Portal](https://azure.microsoft.com/features/azure-portal) | A unified management console that simplifies building, deploying, and operating your cloud resources. |
| [Application Discovery Service](https://aws.amazon.com/application-discovery) | [Migrate](https://azure.microsoft.com/services/azure-migrate) | Assesses on-premises workloads for migration to Azure, performs performance-based sizing, and provides cost estimations. |
| [Systems Manager](https://aws.amazon.com/systems-manager) | [Monitor](https://azure.microsoft.com/services/monitor) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [Personal Health Dashboard](https://aws.amazon.com/premiumsupport/technology/personal-health-dashboard) | [Resource Health](/azure/resource-health/resource-health-overview) | Provides detailed information about the health of resources, as well as recommended actions for maintaining resource health. |
| [CloudTrail](https://aws.amazon.com/cloudtrail) | [Activity log](/azure/azure-monitor/essentials/activity-log) | The Activity log is a platform log in Azure that provides insight into subscription-level events, such as when a resource is modified or when a virtual machine is started. |
| [CloudWatch](https://aws.amazon.com/cloudwatch) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) | A feature of Azure Monitor, Application Insights is an extensible Application Performance Management (APM) service for developers and DevOps professionals, which provides telemetry insights and information, in order to better understand how applications are performing and to identify areas for optimization. |
| [Config](https://aws.amazon.com/config) | [Application Change Analysis](/azure/azure-monitor/app/change-analysis) | Application Change Analysis detects various types of changes, from the infrastructure layer all the way to application deployment.|
| [Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer) | [Cost Management](https://azure.microsoft.com/services/cost-management) | Optimize costs while maximizing cloud potential. |
| [Control Tower](https://aws.amazon.com/controltower) | [Blueprints](/azure/governance/blueprints) | Set up and govern a multi account/subscription environment by creating landing zones. |
| [Resource Groups and Tag Editor](https://docs.aws.amazon.com/ARG) | [Resource Groups](/azure/azure-resource-manager/management/overview) and [Tags](/azure/azure-resource-manager/management/tag-resources) | A Resource Group is a container that holds related resources for an Azure solution. Apply tags to your Azure resources to logically organize them by categories. |
| [AWS AppConfig](https://aws.amazon.com/systems-manager/features/appconfig) | [Azure App Configuration](/azure/azure-app-configuration) | Azure App Configuration is a managed service that helps developers centralize their application and feature settings simply and securely. |
| [Service Catalog](https://aws.amazon.com/servicecatalog) | [Azure Managed Applications](/azure/azure-resource-manager/managed-applications/overview) | Offers cloud solutions that are easy for consumers to deploy and operate.
| [SDKs and tools](https://aws.amazon.com/getting-started/tools-sdks) | [SDKs and tools](https://azure.microsoft.com/downloads) | Manage and interact with Azure services the way you prefer, programmatically from your language of choice, by using the Azure SDKs, our collection of tools, or both. |

## Messaging and eventing

[!INCLUDE [Messaging Components](../../includes/aws/messaging.md)]

## Mobile services

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Mobile Hub](https://aws.amazon.com/blogs/aws/aws-mobile-hub-build-test-and-monitor-mobile-applications) | [App Center](https://azure.microsoft.com/services/app-center) <br/><br/>[Xamarin Apps](https://azure.microsoft.com/features/xamarin) | Provides backend mobile services for rapid development of mobile solutions, identity management, data synchronization, and storage and notifications across devices. |
| [Mobile SDK](https://www.redfoundry.com/what-is-a-mobile-sdk) | [App Center](https://azure.microsoft.com/services/app-center) | Provides the technology to rapidly build cross-platform and native apps for mobile devices. |
| [Cognito](https://aws.amazon.com/cognito) | [Azure Active Directory](https://azure.microsoft.com/services/active-directory/) | Provides authentication capabilities for mobile applications. |
| [Device Farm](https://aws.amazon.com/device-farm) | [App Center](https://azure.microsoft.com/services/app-center) | Provides services to support testing mobile applications. |
| [Mobile Analytics](https://aws.amazon.com/mobileanalytics) | [App Center](https://azure.microsoft.com/services/app-center) | Supports monitoring, and feedback collection for the debugging and analysis of a mobile application service quality. |

### Device Farm

The AWS Device Farm provides cross-device testing services. In Azure, [Visual Studio App Center](https://appcenter.ms) provides similar cross-device front-end testing for mobile devices.

In addition to front-end testing, the [Azure DevTest Labs](https://azure.microsoft.com/services/devtest-lab) provides back-end testing resources for Linux and Windows environments.

### Mobile architectures

<ul class="grid">

[!INCLUDE [Scalable web and mobile applications using Azure Database for PostgreSQL](../../includes/cards/scalable-web-and-mobile-applications-using-azure-database-for-postgresql.md)]
[!INCLUDE [Social App for Mobile and Web with Authentication](../../includes/cards/social-mobile-and-web-app-with-authentication.md)]
[!INCLUDE [Task-Based Consumer Mobile App](../../includes/cards/task-based-consumer-mobile-app.md)]

</ul>

[view all](../browse/index.yml?azure_categories=mobile)

## Networking

[!INCLUDE [Networking Services](../../includes/aws/networking.md)]

## Security, identity, and access

### Authentication and authorization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam) | [Azure Active Directory](https://azure.microsoft.com/services/active-directory) | Allows users to securely control access to services and resources while offering data security and protection. Create and manage users and groups, and use permissions to allow and deny access to resources. |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam) | [Azure role-based access control](/azure/role-based-access-control/overview) | Azure role-based access control (Azure RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. |
| [Organizations](https://aws.amazon.com/organizations) | [Subscription Management + Azure RBAC](/azure/azure-subscription-service-limits) | Security policy and role management for working with multiple accounts. |
| [Multi-Factor Authentication](https://aws.amazon.com/iam/features/mfa) | [Azure Active Directory](https://azure.microsoft.com/services/active-directory) | Safeguard access to data and applications, while meeting user demand for a simple sign-in process. |
| [Directory Service](https://aws.amazon.com/directoryservice) | [Azure Active Directory Domain Services](https://azure.microsoft.com/services/active-directory-ds) | Provides managed domain services, such as domain join, group policy, LDAP, and Kerberos/NTLM authentication, which are fully compatible with Windows Server Active Directory. |
| [Cognito](https://aws.amazon.com/cognito) | [Azure Active Directory B2C](https://azure.microsoft.com/services/active-directory-b2c) | A highly available, global, identity management service for consumer-facing applications that scales to hundreds of millions of identities. |
| [AWS Config](https://aws.amazon.com/config/) | [Policy](https://azure.microsoft.com/services/azure-policy/) | Azure Policy is a service in Azure that you use to create, assign, and manage policies. These policies enforce different rules and effects over your resources, so those resources stay compliant with your corporate standards and service level agreements. |
| [Organizations](https://aws.amazon.com/organizations) | [Management Groups](/azure/governance/management-groups/) | Azure management groups provide a level of scope above subscriptions. You organize subscriptions into containers called "management groups" and apply your governance conditions to the management groups. All subscriptions within a management group automatically inherit the conditions applied to the management group. Management groups give you enterprise-grade management at a large scale, no matter what type of subscriptions you have. |

### Encryption

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Server-side encryption with Amazon S3 Key Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html) | [Azure Storage Service Encryption](/azure/storage/storage-service-encryption) | Helps you protect and safeguard your data and meet your organizational security and compliance commitments. |
| [Key Management Service (KMS)](https://aws.amazon.com/kms), [CloudHSM](https://aws.amazon.com/cloudhsm) | [Key Vault](https://azure.microsoft.com/services/key-vault) | Provides security solution and works with other services by providing a way to manage, create, and control encryption keys stored in hardware security modules (HSM). |

### Firewall

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Web Application Firewall](https://aws.amazon.com/waf) | [Web Application Firewall](https://azure.microsoft.com/products/web-application-firewall) | A firewall that protects web applications from common web exploits. |
| [AWS Network Firewall](https://aws.amazon.com/network-firewall)| [Firewall](https://azure.microsoft.com/services/azure-firewall) | Provides inbound protection for non-HTTP/S protocols, outbound network-level protection for all ports and protocols, and application-level protection for outbound HTTP/S. |

### Security

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Inspector](https://aws.amazon.com/inspector) | [Defender for Cloud](https://azure.microsoft.com/services/security-center) | An automated security assessment service that improves the security and compliance of applications. Automatically assess applications for vulnerabilities or deviations from best practices. |
| [Certificate Manager](https://aws.amazon.com/certificate-manager) | [App Service Certificates available on the Portal](https://azure.microsoft.com/blog/internals-of-app-service-certificate) | Service that allows customers to create, manage, and consume certificates seamlessly in the cloud. |
| [GuardDuty](https://aws.amazon.com/guardduty/) | [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel/) | Detect and investigate advanced attacks on-premises and in the cloud. |
| [Artifact](https://aws.amazon.com/artifact) | [Service Trust Portal](https://servicetrust.microsoft.com/) | Provides access to audit reports, compliance guides, and trust documents from across cloud services. |
| [Shield](https://aws.amazon.com/shield) | [DDos Protection Service](/azure/security/fundamentals/ddos-best-practices) | Provides cloud services with protection from distributed denial of services (DDoS) attacks. |

#### Security architectures

<ul class="grid">

[!INCLUDE [Real-time fraud detection](../../includes/cards/fraud-detection.md)]
[!INCLUDE [Securely managed web applications](../../includes/cards/fully-managed-secure-apps.md)]
[!INCLUDE [Threat indicators for cyber threat intelligence in Sentinel](../../includes/cards/sentinel-threat-intelligence.md)]

</ul>

[view all](../browse/index.yml?azure_categories=security)

## Storage

[!INCLUDE [Storage components](../../includes/aws/storage.md)]

## Web applications

| AWS service | Azure service | Description |
|------|-------------|---------------|
| [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk) | [App Service](https://azure.microsoft.com/services/app-service) | Managed hosting platform providing easy to use services for deploying and scaling web applications and services. |
| [API Gateway](https://aws.amazon.com/api-gateway) | [API Management](https://azure.microsoft.com/services/api-management) | A turnkey solution for publishing APIs to external and internal consumers. |
| [CloudFront](https://aws.amazon.com/cloudfront) | [Front Door](https://azure.microsoft.com/services/frontdoor) | Azure Front Door is a modern cloud content delivery network (CDN) service that delivers high performance, scalability, and secure user experiences for your content and applications. |
| [Global Accelerator](https://aws.amazon.com/global-accelerator) | [Front Door](https://azure.microsoft.com/services/frontdoor) | Easily join your distributed microservices architectures into a single global application using HTTP load balancing and path-based routing rules. Automate turning up new regions and scale-out with API-driven global actions, and independent fault-tolerance to your back end microservices in Azure-or anywhere. |
| [Global Accelerator](https://aws.amazon.com/global-accelerator) | [Cross-regional load balancer](/azure/load-balancer/cross-region-overview) | Distribute and load balance traffic across multiple Azure regions via a single, static, global anycast public IP address. |
| [LightSail](https://aws.amazon.com/lightsail) | [App Service](https://azure.microsoft.com/services/app-service) | Build, deploy, and scale web apps on a fully managed platform. |
| [App Runner](https://aws.amazon.com/apprunner) | [Web App for Containers](https://azure.microsoft.com/services/app-service/containers) | Easily deploy and run containerized web apps on Windows and Linux. |
| [Amplify](https://aws.amazon.com/amplify) | [Static Web Apps](https://azure.microsoft.com/services/app-service/static) | Boost productivity with a tailored developer experience, CI/CD workflows to build and deploy your static content hosting, and dynamic scale for integrated serverless APIs. |

### Web architectures

<ul class="grid">

[!INCLUDE [Architect scalable e-commerce web app](../../includes/cards/scalable-ecommerce-web-app.md)]
[!INCLUDE [Multi-region N-tier application](../../includes/cards/multi-region-sql-server.md)]
[!INCLUDE [Serverless web application](../../includes/cards/web-app.md)]

</ul>

[view all](../browse/index.yml?azure_categories=web)

## End-user computing

| AWS service | Azure service | Description |
|------|-------------|---------------|
| [WorkSpaces](https://aws.amazon.com/workspaces), [AppStream 2.0](https://aws.amazon.com/appstream2) | [Azure Virtual Desktop](/azure/virtual-desktop) | Manage virtual desktops and applications to enable corporate network and data access to users, anytime, anywhere, from supported devices. Amazon WorkSpaces support Windows and Linux virtual desktops. Azure Virtual Desktop supports multi-session Windows 10 virtual desktops.|
| [WorkLink](https://aws.amazon.com/worklink) | [Application Proxy](/azure/active-directory/app-proxy/application-proxy) | Provides access to intranet applications, without requiring VPN connectivity. Amazon WorkLink is limited to iOS and Android devices.|

## Miscellaneous

| Area | AWS service | Azure service | Description |
|------|-------------|---------------|-------------|
| Backend process logic | [Step Functions](https://aws.amazon.com/step-functions) | [Logic Apps](https://azure.microsoft.com/services/logic-apps) | Cloud technology to build distributed applications using out-of-the-box connectors to reduce integration challenges. Connect apps, data, and devices on-premises or in the cloud. |
| Enterprise application services | [WorkMail](https://aws.amazon.com/workmail), [WorkDocs](https://aws.amazon.com/workdocs), [Chime](https://aws.amazon.com/chime) | [Microsoft 365](https://products.office.com) | Fully integrated cloud service that provides communications, email, and document management in the cloud and is available on a wide variety of devices. |
| Gaming | [GameLift](https://aws.amazon.com/gamelift) | [PlayFab](https://playfab.com) | Managed services for hosting dedicated game servers. |
| Media transcoding | [Elastic Transcoder](https://aws.amazon.com/elastictranscoder) | [Media Services](https://azure.microsoft.com/services/media-services/) | Services that offer broadcast-quality video streaming services, including various transcoding technologies. |
| Workflow | [Step Functions](https://aws.amazon.com/step-functions) | [Logic Apps](https://azure.microsoft.com/services/logic-apps) | Serverless technology for connecting apps, data and devices anywhere, whether on-premises or in the cloud for large ecosystems of SaaS and cloud-based connectors. |
| Hybrid | [Outposts](https://aws.amazon.com/outposts) | [Stack](https://azure.microsoft.com/overview/azure-stack) | Azure Stack is a hybrid cloud platform that enables you to run Azure services in your company's or service provider's datacenter. As a developer, you can build apps on Azure Stack. You can then deploy them to either Azure Stack or Azure, or you can build truly hybrid apps that take advantage of connectivity between an Azure Stack cloud and Azure. |
| Media | [Elemental MediaConvert](https://aws.amazon.com/media-services) | [Media Services](https://azure.microsoft.com/services/media-services) | Cloud-based media workflow platform to index, package, protect, and stream video at scale.|
| Satellite | [Ground Station](https://aws.amazon.com/ground-station) | [Azure Orbital](/azure/networking/azure-orbital-overview) | Fully managed cloud-based ground station as a service.|
| Quantum computing | [Amazon Braket](https://aws.amazon.com/braket) | [Azure Quantum](/azure/quantum/overview-azure-quantum) | Managed quantum computing service that developers, researchers, and businesses can use to run quantum computing programs.|

## Next steps

If you are new to Azure, review the interactive [Core Cloud Services - Introduction to Azure](/training/modules/welcome-to-azure) module.
