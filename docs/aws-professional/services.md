---
title: AWS to Azure services comparison
titleSuffix: Azure Architecture Center
description: Compare Azure cloud services to Amazon Web Services (AWS) for multicloud solutions or migration to Azure.
keywords: cloud services comparison, cloud services compared, multicloud, compare Azure AWS, compare Azure and AWS, compare AWS and Azure, IT capabilities
author: doodlemania2
ms.author: pnp
ms.date: 08/11/2020
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: fcp
---

<!-- cSpell:ignore Alexa Rekognition Cognito ElastiCache Greengrass Firehose -->

# AWS to Azure services comparison

This article helps you understand how Microsoft Azure services compare to Amazon Web Services (AWS). Whether you are planning a multicloud solution with Azure and AWS, or migrating to Azure, you can compare the IT capabilities of Azure and AWS services in all categories.

This article compares services that are roughly comparable. Not every AWS service or Azure service is listed, and not every matched service has exact feature-for-feature parity.

## Azure and AWS for multicloud solutions

As the leading public cloud platforms, Azure and AWS each offer a broad and deep set of capabilities with global coverage. Yet many organizations choose to use both platforms together for greater choice and flexibility, as well as to spread their risk and dependencies with a multicloud approach. Consulting companies and software vendors might also build on and use both Azure and AWS, as these platforms represent most of the cloud market demand.

For an overview of Azure for AWS users, see [Introduction to Azure for AWS professionals](./index.md).

<!-- markdownlint-disable MD033 -->

## Marketplace

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Marketplace](https://aws.amazon.com/marketplace) | [Azure Marketplace](https://azure.microsoft.com/marketplace) | Easy-to-deploy and automatically configured third-party applications, including single virtual machine or multiple virtual machine solutions. |

## AI and machine learning

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [SageMaker](https://aws.amazon.com/sagemaker/) | [Machine Learning](https://azure.microsoft.com/services/machine-learning-services/) | A cloud service to train, deploy, automate, and manage machine learning models. |
| [Alexa Skills Kit](https://developer.amazon.com/alexa/alexa-skills-kit) | [Bot Framework](https://dev.botframework.com/) | Build and connect intelligent bots that interact with your users using text/SMS, Skype, Teams, Slack, Microsoft 365 mail, Twitter, and other popular services. |
| [Lex](https://aws.amazon.com/lex/) | [Speech Services](https://azure.microsoft.com/services/cognitive-services/speech/) | API capable of converting speech to text, understanding intent, and converting text back to speech for natural responsiveness. |
| [Lex](https://aws.amazon.com/lex/) | [Language Understanding (LUIS)](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service/) | Allows your applications to understand user commands contextually. |
| [Polly](https://aws.amazon.com/polly/), [Transcribe](https://aws.amazon.com/transcribe/) | [Speech Services](https://azure.microsoft.com/services/cognitive-services/speech/) | Enables both Speech to Text, and Text into Speech capabilities. |
| [Rekognition](https://aws.amazon.com/rekognition/) | [Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) | [Computer Vision](https://azure.microsoft.com/services/cognitive-services/computer-vision/): Extract information from images to categorize and process visual data.<br/><br/> [Face](https://azure.microsoft.com/services/cognitive-services/face/): Detect, identify, and analyze faces in photos. <br/><br/> [Emotions](https://azure.microsoft.com/services/cognitive-services/emotion/): Recognize emotions in images. |
| [Skills Kit](https://developer.amazon.com/alexa/alexa-skills-kit) | [Virtual Assistant](/azure/bot-service/bot-builder-virtual-assistant-introduction?view=azure-bot-service-4.0) | The Virtual Assistant Template brings together a number of best practices we've identified through the building of conversational experiences and automates integration of components that we've found to be highly beneficial to Bot Framework developers.

### AI and machine learning architectures

<ul class="grid">

[!INCLUDE [Image classification on Azure](../../includes/cards/intelligent-apps-image-processing.md)]
[!INCLUDE [Predictive Marketing with Machine Learning](../../includes/cards/predictive-marketing-campaigns-with-machine-learning-and-spark.md)]
[!INCLUDE [Scalable personalization on Azure](../../includes/cards/scalable-personalization.md)]

</ul>

[view all](../browse/index.md#ai--machine-learning)

## Big data and analytics

### Data warehouse

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Redshift](https://aws.amazon.com/redshift/) | [Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) | Cloud-based Enterprise Data Warehouse (EDW) that uses Massively Parallel Processing (MPP) to quickly run complex queries across petabytes of data. |
| [Lake Formation](https://aws.amazon.com/lake-formation/) | [Data Share](https://azure.microsoft.com/services/data-share/) | A simple and safe service for sharing big data|

### Data warehouse architectures

<ul class="grid">

[!INCLUDE [Modern Data Warehouse Architecture](../../includes/cards/modern-data-warehouse.md)]
[!INCLUDE [Automated enterprise BI](../../includes/cards/enterprise-bi-adf.md)]

</ul>

[view all](../browse/index.md#databases)

### Big data processing

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [EMR](https://aws.amazon.com/emr/) | [Databricks](https://azure.microsoft.com/services/databricks/) | Apache Spark-based analytics platform. |
| [EMR](https://aws.amazon.com/emr/) | [HDInsight](https://azure.microsoft.com/services/hdinsight/) | Managed Hadoop service. Deploy and manage Hadoop clusters in Azure. |
| [EMR](https://aws.amazon.com/emr/) | [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) | Massively scalable, secure data lake functionality built on Azure Blob Storage. |

### Big data architectures

<ul class="grid">

[!INCLUDE [Azure data platform end-to-end](../../includes/cards/data-platform-end-to-end.md)]
[!INCLUDE [Campaign Optimization with Azure HDInsight Spark Clusters](../../includes/cards/campaign-optimization-with-azure-hdinsight-spark-clusters.md)]

</ul>

[view all](../browse/index.md#databases)

### Data orchestration / ETL

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Data Pipeline](https://aws.amazon.com/datapipeline/), [Glue](https://aws.amazon.com/glue/) | [Data Factory](https://azure.microsoft.com/services/data-factory/) | Processes and moves data between different compute and storage services, as well as on-premises data sources at specified intervals. Create, schedule, orchestrate, and manage data pipelines. |
| [Glue](https://aws.amazon.com/glue/) | [Data Catalog](https://azure.microsoft.com/services/data-catalog/) | A fully managed service that serves as a system of registration and system of discovery for enterprise data sources |
| [Dynamo DB](https://aws.amazon.com/dynamodb)| [Table Storage](https://azure.microsoft.com/services/storage/tables), [Cosmos DB](https://azure.microsoft.com/services/cosmos-db) | NoSQL key-value store for rapid development using massive semi-structured datasets.|

### Analytics and visualization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Kinesis Analytics](https://aws.amazon.com/kinesis/data-analytics/) | [Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) <br/><br/>[Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics/) <br/><br/>[Data Lake Store](https://azure.microsoft.com/services/data-lake-store/) | Storage and analysis platforms that create insights from large quantities of data, or data that originates from many sources. |
| [QuickSight](https://aws.amazon.com/quicksight/) | [Power BI](https://powerbi.microsoft.com/) | Business intelligence tools that build visualizations, perform ad hoc analysis, and develop business insights from data. |
| [CloudSearch](https://aws.amazon.com/cloudsearch/) | [Cognitive Search](https://azure.microsoft.com/services/search/) | Delivers full-text search and related search analytics and capabilities. |
| [Athena](https://aws.amazon.com/athena/) | [Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics/) | Provides a serverless interactive query service that uses standard SQL for analyzing databases. |

### Analytics architectures

<ul class="grid">

[!INCLUDE [Advanced Analytics Architecture](../../includes/cards/advanced-analytics-on-big-data.md)]
[!INCLUDE [Automated enterprise BI](../../includes/cards/enterprise-bi-adf.md)]
[!INCLUDE [Mass ingestion and analysis of news feeds on Azure](../../includes/cards/newsfeed-ingestion.md)]

</ul>

[view all](../browse/index.md#analytics)

## Compute

[!INCLUDE [Compute Services](../../includes/aws/compute.md)]

## Database

[!INCLUDE [Database Services](../../includes/aws/databases.md)]

## DevOps and application monitoring

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [CloudWatch](https://aws.amazon.com/cloudwatch/), [X-Ray](https://aws.amazon.com/xray/) | [Monitor](https://azure.microsoft.com/services/monitor/) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [CodeDeploy](https://aws.amazon.com/codedeploy/) <br/><br/>[CodeCommit](https://aws.amazon.com/codecommit/) <br/><br/>[CodePipeline](https://aws.amazon.com/codepipeline/) | [DevOps](https://azure.microsoft.com/services/devops/) | A cloud service for collaborating on code development. |
| [Developer Tools](https://aws.amazon.com/products/developer-tools/) | [Developer Tools](https://azure.microsoft.com/tools/) | Collection of tools for building, debugging, deploying, diagnosing, and managing multiplatform scalable apps and services. |
| [CodeBuild](https://aws.amazon.com/codebuild/) | [DevOps](https://azure.microsoft.com/services/devops/) | Fully managed build service that supports continuous integration and deployment. |
| [Command Line Interface](https://aws.amazon.com/cli/) | [CLI](/cli/azure/install-azure-cli) <br/><br/>[PowerShell](/powershell/azure/overview) | Built on top of the native REST API across all cloud services, various programming language-specific wrappers provide easier ways to create solutions. |
| [OpsWorks (Chef-based)](https://aws.amazon.com/opsworks/) | [Automation](https://azure.microsoft.com/services/automation/) | Configures and operates applications of all shapes and sizes, and provides templates to create and manage a collection of resources. |
| [CloudFormation](https://aws.amazon.com/cloudformation/) | [Resource Manager](https://azure.microsoft.com/features/resource-manager/) <br/><br/>[VM extensions](/azure/virtual-machines/extensions/features-windows?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json) <br/><br/>[Azure Automation](https://azure.microsoft.com/services/automation) | Provides a way for users to automate the manual, long-running, error-prone, and frequently repeated IT tasks.

### Devops architectures

<ul class="grid">

[!INCLUDE [Container CI/CD using Jenkins and Kubernetes on Azure Kubernetes Service (AKS)](../../includes/cards/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.md)]
[!INCLUDE [Run a Jenkins server on Azure](../../includes/cards/jenkins.md)]
[!INCLUDE [DevOps in a hybrid environment](../../includes/cards/devops-in-a-hybrid-environment.md)]

</ul>

[view all](../browse/index.md#devops)

## Internet of things (IoT)

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [IoT](https://aws.amazon.com/iot/) | [IoT Hub](https://azure.microsoft.com/services/iot-hub/) | A cloud gateway for managing bidirectional communication with billions of IoT devices, securely and at scale. |
| [Greengrass](https://aws.amazon.com/greengrass/) | [IoT Edge](https://azure.microsoft.com/services/iot-edge/) | Deploy cloud intelligence directly on IoT devices to run in on-premises scenarios. |
| [Kinesis Firehose](https://aws.amazon.com/kinesis/data-firehose/), [Kinesis Streams](https://aws.amazon.com/kinesis/data-streams/) | [Event Hubs](https://azure.microsoft.com/services/event-hubs/) | Services that allow the mass ingestion of small data inputs, typically from devices and sensors, to process and route the data. |
| [IoT Things Graph](https://aws.amazon.com/iot-things-graph/) | [Digital Twins](https://azure.microsoft.com/services/digital-twins/) | Azure Digital Twins is an IoT service that helps you create comprehensive models of physical environments. Create spatial intelligence graphs to model the relationships and interactions between people, places, and devices. Query data from a physical space rather than disparate sensors.

### IOT architectures

<ul class="grid">

[!INCLUDE [IoT Architecture – Azure IoT Subsystems](../../includes/cards/azure-iot-subsystems.md)]
[!INCLUDE [Azure IoT reference architecture](../../includes/cards/iot.md)]
[!INCLUDE [Process real-time vehicle data using IoT](../../includes/cards/realtime-analytics-vehicle-iot.md)]

</ul>

[view all](../browse/index.md#devops)

## Management

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor/) | [Advisor](https://azure.microsoft.com/services/advisor/) | Provides analysis of cloud resource configuration and security so subscribers can ensure they're making use of best practices and optimum configurations. |
| [Usage and Billing Report](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-reports-gettingstarted-turnonreports.html) | [Billing API](/azure/billing/billing-usage-rate-card-overview) | Services to help generate, monitor, forecast, and share billing data for resource usage by time, organization, or product resources. |
| [Management Console](https://aws.amazon.com/console/) | [Portal](https://azure.microsoft.com/features/azure-portal/) | A unified management console that simplifies building, deploying, and operating your cloud resources. |
| [Application Discovery Service](https://aws.amazon.com/application-discovery) | [Migrate](https://azure.microsoft.com/services/azure-migrate/) | Assesses on-premises workloads for migration to Azure, performs performance-based sizing, and provides cost estimations. |
| [EC2 Systems Manager](https://aws.amazon.com/systems-manager/) | [Monitor](https://azure.microsoft.com/services/monitor/) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [Personal Health Dashboard](https://aws.amazon.com/premiumsupport/technology/personal-health-dashboard/) | [Resource Health](/azure/resource-health/resource-health-overview) | Provides detailed information about the health of resources as well as recommended actions for maintaining resource health. |
| [CloudTrail](https://aws.amazon.com/cloudtrail/) | [Monitor](https://azure.microsoft.com/services/monitor/) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [CloudWatch](https://aws.amazon.com/cloudwatch) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) | Application Insights, is an extensible Application Performance Management (APM) service for developers and DevOps professionals.|
| [Cost Explorer](https://aws.amazon.com/aws-cost-management/) | [Cost Management](https://azure.microsoft.com/services/cost-management/) | Optimize cloud costs while maximizing cloud potential. |

## Messaging and eventing

[!INCLUDE [Messaging Components](../../includes/aws/messaging.md)]

## Mobile services

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Mobile Hub](https://aws.amazon.com/blogs/aws/aws-mobile-hub-build-test-and-monitor-mobile-applications/) | [App Center](https://azure.microsoft.com/services/app-center/) <br/><br/>[Xamarin Apps](https://azure.microsoft.com/features/xamarin/) | Provides backend mobile services for rapid development of mobile solutions, identity management, data synchronization, and storage and notifications across devices. |
| [Mobile SDK](https://docs.aws.amazon.com/mobile-sdk/) | [App Center](https://azure.microsoft.com/services/app-center/) | Provides the technology to rapidly build cross-platform and native apps for mobile devices. |
| [Cognito](https://aws.amazon.com/cognito/) | [App Center](https://azure.microsoft.com/services/app-center/) | Provides authentication capabilities for mobile applications. |
| [Device Farm](https://aws.amazon.com/device-farm/) | [App Center](https://azure.microsoft.com/services/app-center/) | Provides services to support testing mobile applications. |
| [Mobile Analytics](https://aws.amazon.com/mobileanalytics/) | [App Center](https://azure.microsoft.com/services/app-center/) | Supports monitoring, and feedback collection for the debugging and analysis of a mobile application service quality. |

### Device Farm

The AWS Device Farm provides cross-device testing services. In Azure, [Visual Studio App Center](https://appcenter.ms) provides similar cross-device front-end testing for mobile devices.

In addition to front-end testing, the [Azure DevTest Labs](https://azure.microsoft.com/services/devtest-lab) provides back-end testing resources for Linux and Windows environments.

### Mobile architectures

<ul class="grid">

[!INCLUDE [Scalable web and mobile applications using Azure Database for PostgreSQL](../../includes/cards/scalable-web-and-mobile-applications-using-azure-database-for-postgresql.md)]
[!INCLUDE [Social App for Mobile and Web with Authentication](../../includes/cards/social-mobile-and-web-app-with-authentication.md)]
[!INCLUDE [Task-Based Consumer Mobile App](../../includes/cards/task-based-consumer-mobile-app.md)]

</ul>

[view all](../browse/index.md#mobile)

## Networking

[!INCLUDE [Networking Services](../../includes/aws/networking.md)]

## Security, identity, and access

### Authentication and authorization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam/) | [Azure Active Directory](https://azure.microsoft.com/services/active-directory/) | Allows users to securely control access to services and resources while offering data security and protection. Create and manage users and groups, and use permissions to allow and deny access to resources. |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam/) | [Role Based Access Control](/azure/role-based-access-control/overview) | Role-based access control (RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. |
| [Organizations](https://aws.amazon.com/organizations/) | [Subscription Management + RBAC](/azure/azure-subscription-service-limits) | Security policy and role management for working with multiple accounts. |
| [Multi-Factor Authentication](https://aws.amazon.com/iam/features/mfa/) | [Multi-Factor Authentication](https://azure.microsoft.com/services/multi-factor-authentication/) | Safeguard access to data and applications while meeting user demand for a simple sign-in process. |
| [Directory Service](https://aws.amazon.com/directoryservice/) | [Azure Active Directory Domain Services](https://azure.microsoft.com/services/active-directory-ds/) | Provides managed domain services such as domain join, group policy, LDAP, and Kerberos/NTLM authentication that are fully compatible with Windows Server Active Directory. |
| [Cognito](https://aws.amazon.com/cognito/) | [Azure Active Directory B2C](https://azure.microsoft.com/services/active-directory-b2c/) | A highly available, global, identity management service for consumer-facing applications that scales to hundreds of millions of identities. |
| [Organizations](https://aws.amazon.com/organizations/) | [Policy](https://azure.microsoft.com/services/azure-policy/) | Azure Policy is a service in Azure that you use to create, assign, and manage policies. These policies enforce different rules and effects over your resources, so those resources stay compliant with your corporate standards and service level agreements. |
| [Organizations](https://aws.amazon.com/organizations/) | [Management Groups](/azure/governance/management-groups/) | Azure management groups provide a level of scope above subscriptions. You organize subscriptions into containers called "management groups" and apply your governance conditions to the management groups. All subscriptions within a management group automatically inherit the conditions applied to the management group. Management groups give you enterprise-grade management at a large scale, no matter what type of subscriptions you have. |

### Encryption

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Server-side encryption with Amazon S3 Key Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html) | [Azure Storage Service Encryption](/azure/storage/storage-service-encryption) | Helps you protect and safeguard your data and meet your organizational security and compliance commitments. |
| [Key Management Service (KMS)](https://aws.amazon.com/kms), [CloudHSM](https://aws.amazon.com/cloudhsm) | [Key Vault](https://azure.microsoft.com/services/key-vault) | Provides security solution and works with other services by providing a way to manage, create, and control encryption keys stored in hardware security modules (HSM). |

### Firewall

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Web Application Firewall](https://aws.amazon.com/waf/) | [Web Application Firewall](/azure/application-gateway/application-gateway-web-application-firewall-overview) | A firewall that protects web applications from common web exploits. |
| [Web Application Firewall](https://aws.amazon.com/waf/)| [Firewall](https://azure.microsoft.com/services/azure-firewall/) | Provides inbound protection for non-HTTP/S protocols, outbound network-level protection for all ports and protocols, and application-level protection for outbound HTTP/S. |

### Security

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Inspector](https://aws.amazon.com/inspector/) | [Security Center](https://azure.microsoft.com/services/security-center/) | An automated security assessment service that improves the security and compliance of applications. Automatically assess applications for vulnerabilities or deviations from best practices. |
| [Certificate Manager](https://aws.amazon.com/certificate-manager/) | [App Service Certificates available on the Portal](https://azure.microsoft.com/blog/internals-of-app-service-certificate/) | Service that allows customers to create, manage, and consume certificates seamlessly in the cloud. |
| [GuardDuty](https://aws.amazon.com/guardduty/) | [Advanced Threat Protection](https://azure.microsoft.com/features/azure-advanced-threat-protection/) | Detect and investigate advanced attacks on-premises and in the cloud. |
| [Artifact](https://aws.amazon.com/artifact/) | [Service Trust Portal](https://servicetrust.microsoft.com/) | Provides access to audit reports, compliance guides, and trust documents from across cloud services. |
| [Shield](https://aws.amazon.com/shield/) | [DDos Protection Service](/azure/security/azure-ddos-best-practices) | Provides cloud services with protection from distributed denial of services (DDoS) attacks. |

#### Security architectures

<ul class="grid">

[!INCLUDE [Real-time fraud detection](../../includes/cards/fraud-detection.md)]
[!INCLUDE [Securely managed web applications](../../includes/cards/fully-managed-secure-apps.md)]
[!INCLUDE [Threat indicators for cyber threat intelligence in Azure Sentinel](../../includes/cards/sentinel-threat-intelligence.md)]

</ul>

[view all](../browse/index.md#security)

## Storage

[!INCLUDE [Storage components](../../includes/aws/storage.md)]

## Web applications

| AWS service | Azure service | Description |
|------|-------------|---------------|-------------|
| [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) | [App Service](https://azure.microsoft.com/services/app-service) | Managed hosting platform providing easy to use services for deploying and scaling web applications and services. |
| [API Gateway](https://aws.amazon.com/api-gateway/) | [API Management](https://azure.microsoft.com/services/api-management/) | A turnkey solution for publishing APIs to external and internal consumers. |
| [CloudFront](https://aws.amazon.com/cloudfront/) | [Content Delivery Network](https://azure.microsoft.com/services/cdn/) | A global content delivery network that delivers audio, video, applications, images, and other files. |
| [Global Accelerator](https://aws.amazon.com/global-accelerator/) | [Front Door](https://azure.microsoft.com/services/frontdoor/) | Easily join your distributed microservices architectures into a single global application using HTTP load balancing and path-based routing rules. Automate turning up new regions and scale-out with API-driven global actions, and independent fault-tolerance to your back end microservices in Azure-or anywhere. |
| [LightSail](https://aws.amazon.com/lightsail/) | [App Service](https://azure.microsoft.com/services/app-service/) | Build, deploy, and scale web apps on a fully managed platform. |

#### Web architectures

<ul class="grid">

[!INCLUDE [Architect scalable e-commerce web app](../../includes/cards/scalable-ecommerce-web-app.md)]
[!INCLUDE [Multi-region N-tier application](../../includes/cards/multi-region-sql-server.md)]
[!INCLUDE [Serverless web application](../../includes/cards/web-app.md)]

</ul>

[view all](../browse/index.md#web)

## Miscellaneous

| Area | AWS service | Azure service | Description |
|------|-------------|---------------|-------------|
| Backend process logic | [Step Functions](https://aws.amazon.com/step-functions/) | [Logic Apps](https://azure.microsoft.com/services/logic-apps/) | Cloud technology to build distributed applications using out-of-the-box connectors to reduce integration challenges. Connect apps, data and devices on-premises or in the cloud. |
| Enterprise application services | [WorkMail](https://aws.amazon.com/workmail/), [WorkDocs](https://aws.amazon.com/workdocs/) | [Microsoft 365](https://products.office.com/) | Fully integrated Cloud service providing communications, email, document management in the cloud and available on a wide variety of devices. |
| Gaming | [GameLift](https://aws.amazon.com/gamelift/), [GameSparks](https://www.gamesparks.com/) | [PlayFab](https://playfab.com/) | Managed services for hosting dedicated game servers. |
| Media transcoding | [Elastic Transcoder](https://aws.amazon.com/elastictranscoder/) | [Media Services](https://azure.microsoft.com/services/media-services/) | Services that offer broadcast-quality video streaming services, including various transcoding technologies. |
| Workflow | [Simple Workflow Service (SWF)](https://aws.amazon.com/swf/) | [Logic Apps](https://azure.microsoft.com/services/logic-apps/) | Serverless technology for connecting apps, data and devices anywhere, whether on-premises or in the cloud for large ecosystems of SaaS and cloud-based connectors. |
| Hybrid | [Outposts](https://aws.amazon.com/outposts/) | [Stack](https://azure.microsoft.com/overview/azure-stack/) | Azure Stack is a hybrid cloud platform that enables you to run Azure services in your company's or service provider's datacenter. As a developer, you can build apps on Azure Stack. You can then deploy them to either Azure Stack or Azure, or you can build truly hybrid apps that take advantage of connectivity between an Azure Stack cloud and Azure. |
| Media | [Elemental MediaConvert](https://aws.amazon.com/media-services) | [Media Services](https://azure.microsoft.com/services/media-services/) | Cloud-based media workflow platform to index, package, protect, and stream video at scale.|

## More learning

If you are new to Azure, review the interactive [Core Cloud Services - Introduction to Azure](/learn/modules/welcome-to-azure) module on [Microsoft Learn](/learn).