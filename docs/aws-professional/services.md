---
title: AWS to Azure services comparison
titleSuffix: Azure Architecture Center
description: Compare Azure cloud services to Amazon Web Services (AWS) for multicloud solutions or migration to Azure. 
keywords: cloud services comparison, cloud services compared, multicloud, compare Azure AWS, compare Azure and AWS, compare AWS and Azure, IT capabilities
author: JasRobe
ms.author: pnp
ms.date: 01/06/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

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
| [AWS Marketplace](https://aws.amazon.com/marketplace) | [Azure Marketplace](https://azure.microsoft.com/marketplace/) | Easy-to-deploy and automatically configured third-party applications, including single virtual machine or multiple virtual machine solutions. |

## AI and machine learning

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [SageMaker](https://aws.amazon.com/sagemaker/) | [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning-services/) | A cloud service to train, deploy, automate, and manage machine learning models. |
| [SageMaker](https://aws.amazon.com/sagemaker/) | [Azure Machine Learning Studio (classic)](https://azure.microsoft.com/services/machine-learning/) | A collaborative, drag-and-drop tool to build, test, and deploy predictive analytics solutions on your data. |
| [Alexa Skills Kit](https://developer.amazon.com/alexa/alexa-skills-kit) | [Microsoft Bot Framework](https://dev.botframework.com/) | Build and connect intelligent bots that interact with your users using text/SMS, Skype, Teams, Slack, Office 365 mail, Twitter, and other popular services. |
| [Amazon Lex](https://aws.amazon.com/lex/) | [Speech Services](https://azure.microsoft.com/services/cognitive-services/speech/) | API capable of converting speech to text, understanding intent, and converting text back to speech for natural responsiveness. |
| [Amazon Lex](https://aws.amazon.com/lex/) | [Language Understanding (LUIS)](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service/) | Allows your applications to understand user commands contextually. |
| [Amazon Polly](https://aws.amazon.com/polly/), [Amazon Transcribe](https://aws.amazon.com/transcribe/) | [Speech Services](https://azure.microsoft.com/services/cognitive-services/speech/) | Enables both Speech to Text, and Text into Speech capabilities. |
| [Amazon Rekognition](https://aws.amazon.com/rekognition/) | [Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) | [Computer Vision](https://azure.microsoft.com/services/cognitive-services/computer-vision/): Extract information from images to categorize and process visual data.<br/><br/> [Face](https://azure.microsoft.com/services/cognitive-services/face/): Detect, identy, and analyze faces in photos. <br/><br/> [Emotions](https://azure.microsoft.com/services/cognitive-services/emotion/): Recognize emotions in images. |
| [Alexa Skills Kit](https://developer.amazon.com/alexa/alexa-skills-kit) | [Azure Virtual Assistant](https://docs.microsoft.com/azure/bot-service/bot-builder-virtual-assistant-introduction?view=azure-bot-service-4.0) | The Virtual Assistant Template brings together a number of best practices we've identified through the building of conversational experiences and automates integration of components that we've found to be highly beneficial to Bot Framework developers.

## Big data and analytics

### Data warehouse

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Redshift](https://aws.amazon.com/redshift/) | [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) | Cloud-based Enterprise Data Warehouse (EDW) that uses Massively Parallel Processing (MPP) to quickly run complex queries across petabytes of data. |

### Big data processing

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [EMR](https://aws.amazon.com/emr/) | [Azure Databricks](https://azure.microsoft.com/services/databricks/) | Apache Spark-based analytics platform. |
| [EMR](https://aws.amazon.com/emr/) | [HDInsight](https://azure.microsoft.com/services/hdinsight/) | Managed Hadoop service. Deploy and manage Hadoop clusters in Azure. |

### Data orchestration / ETL

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Data Pipeline](https://aws.amazon.com/datapipeline/), [AWS Glue](https://aws.amazon.com/glue/) | [Data Factory](https://azure.microsoft.com/services/data-factory/) | Processes and moves data between different compute and storage services, as well as on-premises data sources at specified intervals. Create, schedule, orchestrate, and manage data pipelines. |
| [AWS Glue](https://aws.amazon.com/glue/) | [Data Catalog](https://azure.microsoft.com/services/data-catalog/) | A fully managed service that serves as a system of registration and system of discovery for enterprise data sources |

### Analytics and visualization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Kinesis Analytics](https://aws.amazon.com/kinesis/data-analytics/) | [Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) <br/><br/>[Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics/) <br/><br/>[Data Lake Store](https://azure.microsoft.com/services/data-lake-store/) | Storage and analysis platforms that create insights from large quantities of data, or data that originates from many sources. |
| [QuickSight](https://aws.amazon.com/quicksight/) | [Power BI](https://powerbi.microsoft.com/) | Business intelligence tools that build visualizations, perform ad hoc analysis, and develop business insights from data. |
| [CloudSearch](https://aws.amazon.com/cloudsearch/) | [Azure Search](https://azure.microsoft.com/services/search/) | Delivers full-text search and related search analytics and capabilities. |
| [Amazon Athena](https://aws.amazon.com/athena/) | [Azure Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics/) | Provides a serverless interactive query service that uses standard SQL for analyzing databases. |

## Compute

### Virtual servers

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Compute Cloud (EC2) Instances](https://aws.amazon.com/ec2/) | [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) | Virtual servers allow users to deploy, manage, and maintain OS and server software. Instance types provide combinations of CPU/RAM. Users pay for what they use with the flexibility to change sizes. |
| [AWS Batch](https://aws.amazon.com/batch/) | [Azure Batch](https://azure.microsoft.com/services/batch/) | Run large-scale parallel and high-performance computing applications efficiently in the cloud. |
| [AWS Auto Scaling](https://aws.amazon.com/autoscaling/) | [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview) | Allows you to automatically change the number of VM instances. You set defined metric and thresholds that determine if the platform adds or removes instances. |
| [VMware Cloud on AWS](https://aws.amazon.com/vmware/) | [Azure VMware by CloudSimple](https://azure.microsoft.com/services/azure-vmware-cloudsimple/) | Redeploy and extend your VMware-based enterprise workloads to Azure with Azure VMware Solution by CloudSimple. Keep using the VMware tools you already know to manage workloads on Azure without disrupting network, security, or data protection policies. |

### Containers and container orchestrators

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Container Service (ECS)](https://aws.amazon.com/ecs/)<br/><br/>[Fargate](https://aws.amazon.com/fargate/) | [Azure Container Instances](https://azure.microsoft.com/services/container-instances/) | Azure Container Instances is the fastest and simplest way to run a container in Azure, without having to provision any virtual machines or adopt a higher-level orchestration service. |
| [Elastic Container Registry](https://aws.amazon.com/ecr/) | [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) | Allows customers to store Docker formatted images. Used to create all types of container deployments on Azure. |
| [Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/) | [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) | Deploy orchestrated containerized applications with Kubernetes. Simplify monitoring and cluster management through auto upgrades and a built-in operations console. |
| [App Mesh](https://aws.amazon.com/app-mesh/) | [Service Fabric Mesh](/azure/service-fabric-mesh/service-fabric-mesh-overview) | Fully managed service that enables developers to deploy microservices applications without managing virtual machines, storage, or networking.

### Serverless

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Lambda](https://aws.amazon.com/lambda/) | [Azure Functions](https://azure.microsoft.com/services/functions/) | Integrate systems and run backend processes in response to events or schedules without provisioning or managing servers. |

## Database

| Type | AWS Service | Azure Service | Description |
| -----| ----------- | ------------- | ----------- |
| Relational database | [RDS](https://aws.amazon.com/rds/) | [SQL Database](https://azure.microsoft.com/services/sql-database/)<br/><br/>[Azure Database for MySQL](https://azure.microsoft.com/services/mysql/)<br/><br/>[Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql/) | Managed relational database service where resiliency, scale, and maintenance are primarily handled by the platform. |
| NoSQL / Document | [DynamoDB](https://aws.amazon.com/dynamodb/)<br/><br/>[SimpleDB](https://aws.amazon.com/simpledb/)<br/><br/>[Amazon DocumentDB](https://aws.amazon.com/documentdb/) | [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) | A globally distributed, multi-model database that natively supports multiple data models: key-value, documents, graphs, and columnar. |
| Caching | [ElastiCache](https://aws.amazon.com/elasticache/) | [Azure Cache for Redis](https://azure.microsoft.com/services/cache/) | An in-memory–based, distributed caching service that provides a high-performance store typically used to offload nontransactional work from a database. |
| Database migration | [AWS Database Migration Service](https://aws.amazon.com/dms/) | [Azure Database Migration Service](https://azure.microsoft.com/campaigns/database-migration/) | Migration of database schema and data from one database format to a specific database technology in the cloud. |

## DevOps and application monitoring

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [CloudWatch](https://aws.amazon.com/cloudwatch/), [AWS X-Ray](https://aws.amazon.com/xray/) | [Azure Monitor](https://azure.microsoft.com/services/monitor/) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [CodeDeploy](https://aws.amazon.com/codedeploy/) <br/><br/>[CodeCommit](https://aws.amazon.com/codecommit/) <br/><br/>[CodePipeline](https://aws.amazon.com/codepipeline/) | [Azure DevOps](https://azure.microsoft.com/services/devops/) | A cloud service for collaborating on code development. |
| [AWS Developer Tools](https://aws.amazon.com/products/developer-tools/) | [Azure Developer Tools](https://azure.microsoft.com/tools/) | Collection of tools for building, debugging, deploying, diagnosing, and managing multiplatform scalable apps and services. |
| [AWS CodeBuild](https://aws.amazon.com/codebuild/) | [Azure DevOps](https://azure.microsoft.com/services/devops/) | Fully managed build service that supports continuous integration and deployment. |
| [Command Line Interface](https://aws.amazon.com/cli/) | [Azure CLI](/cli/azure/install-azure-cli) <br/><br/>[Azure PowerShell](/powershell/azure/overview) | Built on top of the native REST API across all cloud services, various programming language-specific wrappers provide easier ways to create solutions. |
| [OpsWorks (Chef-based)](https://aws.amazon.com/opsworks/) | [Azure Automation](https://azure.microsoft.com/services/automation/) | Configures and operates applications of all shapes and sizes, and provides templates to create and manage a collection of resources. |
| [CloudFormation](https://aws.amazon.com/cloudformation/) | [Azure Resource Manager](https://azure.microsoft.com/features/resource-manager/) <br/><br/>[VM extensions](/azure/virtual-machines/extensions/features-windows?toc=%2Fazure%2Fvirtual-machines%2Fwindows%2Ftoc.json) <br/><br/>[Azure Automation](https://azure.microsoft.com/services/automation/) | Provides a way for users to automate the manual, long-running, error-prone, and frequently repeated IT tasks. |

## Internet of things (IoT)

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS IoT](https://aws.amazon.com/iot/) | [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) | A cloud gateway for managing bidirectional communication with billions of IoT devices, securely and at scale. |
| [AWS Greengrass](https://aws.amazon.com/greengrass/) | [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) | Deploy cloud intelligence directly on IoT devices to run in on-premises scenarios. |
| [Kinesis Firehose](https://aws.amazon.com/kinesis/data-firehose/), [Kinesis Streams](https://aws.amazon.com/kinesis/data-streams/) | [Event Hubs](https://azure.microsoft.com/services/event-hubs/) | Services that allow the mass ingestion of small data inputs, typically from devices and sensors, to process and route the data. |
| [AWS IoT Things Graph](https://aws.amazon.com/iot-things-graph/) | [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/) | Azure Digital Twins is an IoT service that helps you create comprehensive models of physical environments. Create spatial intelligence graphs to model the relationships and interactions between people, places, and devices. Query data from a physical space rather than disparate sensors.

## Management

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor/) | [Azure Advisor](https://azure.microsoft.com/services/advisor/) | Provides analysis of cloud resource configuration and security so subscribers can ensure they’re making use of best practices and optimum configurations. |
| [AWS Usage and Billing Report](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-reports-gettingstarted-turnonreports.html) | [Azure Billing API](/azure/billing/billing-usage-rate-card-overview) | Services to help generate, monitor, forecast, and share billing data for resource usage by time, organization, or product resources. |
| [AWS Management Console](https://aws.amazon.com/console/) | [Azure portal](https://azure.microsoft.com/features/azure-portal/) | A unified management console that simplifies building, deploying, and operating your cloud resources. |
| [AWS Application Discovery Service](https://aws.amazon.com/application-discovery) | [Azure Migrate](https://azure.microsoft.com/services/azure-migrate/) | Assesses on-premises workloads for migration to Azure, performs performance-based sizing, and provides cost estimations. |
| [Amazon EC2 Systems Manager](https://aws.amazon.com/systems-manager/) | [Azure Monitor](https://azure.microsoft.com/services/monitor/) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [AWS Personal Health Dashboard](https://aws.amazon.com/premiumsupport/technology/personal-health-dashboard/) | [Azure Resource Health](/azure/resource-health/resource-health-overview) | Provides detailed information about the health of resources as well as recommended actions for maintaining resource health. |

## Messaging and eventing

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [Simple Queue Service (SQS)](https://aws.amazon.com/sqs/) | [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues/) | Provides a managed message queueing service for communicating between decoupled application components. |
| [Simple Queue Service (SQS)](https://aws.amazon.com/sqs/) | [Service Bus](https://azure.microsoft.com/services/service-bus/) | Supports a set of cloud-based, message-oriented middleware technologies including reliable message queuing and durable publish/subscribe messaging. |
| [Simple Notification Service](https://aws.amazon.com/sns/) | [Event Grid](https://azure.microsoft.com/services/event-grid/) | A fully managed event routing service that allows for uniform event consumption using a publish/subscribe model. |

## Mobile services

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Mobile Hub](https://aws.amazon.com/blogs/aws/aws-mobile-hub-build-test-and-monitor-mobile-applications/) | [App Center](https://azure.microsoft.com/services/app-center/) <br/><br/>[Xamarin Apps](https://azure.microsoft.com/features/xamarin/) | Provides backend mobile services for rapid development of mobile solutions, identity management, data synchronization, and storage and notifications across devices. |
| [Mobile SDK](https://docs.aws.amazon.com/mobile-sdk/) | [App Center](https://azure.microsoft.com/services/app-center/) | Provides the technology to rapidly build cross-platform and native apps for mobile devices. |
| [Cognito](https://aws.amazon.com/cognito/) | [App Center](https://azure.microsoft.com/services/app-center/) | Provides authentication capabilities for mobile applications. |
| [AWS Device Farm](https://aws.amazon.com/device-farm/) | [App Center](https://azure.microsoft.com/services/app-center/) | Provides services to support testing mobile applications. |
| [Mobile Analytics](https://aws.amazon.com/mobileanalytics/) | [App Center](https://azure.microsoft.com/services/app-center/) | Supports monitoring, and feedback collection for the debugging and analysis of a mobile application service quality. |

## Networking

| Area | AWS service | Azure service | Description |
| -----| ----------- | ------------- | ----------- |
| Cloud virtual networking | [Virtual Private Cloud (VPC)](https://aws.amazon.com/vpc/) | [Virtual Network](https://azure.microsoft.com/services/virtual-network/) | Provides an isolated, private environment in the cloud. Users have control over their virtual networking environment, including selection of their own IP address range, creation of subnets, and configuration of route tables and network gateways. |
| Cross-premises connectivity | [AWS VPN Gateway](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html) | [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) |Connects Azure virtual networks to other Azure virtual networks, or customer on-premises networks (Site To Site). Allows end users to connect to Azure services through VPN tunneling (Point To Site). |
| DNS management | [Route 53](https://aws.amazon.com/route53/) | [Azure DNS](https://azure.microsoft.com/services/dns/) | Manage your DNS records using the same credentials and billing and support contract as your other Azure services |
| &nbsp; | [Route 53](https://aws.amazon.com/route53/) | [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) | A service that hosts domain names, plus routes users to Internet applications, connects user requests to datacenters, manages traffic to apps, and improves app availability with automatic failover. |
Dedicated network | [Direct Connect](https://aws.amazon.com/directconnect/) | [ExpressRoute](https://azure.microsoft.com/services/expressroute/) | Establishes a dedicated, private network connection from a location to the cloud provider (not over the Internet). |
| Load balancing | [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) | [Load Balancer](https://azure.microsoft.com/services/load-balancer/)  | Azure Load Balancer load-balances traffic at layer 4 (TCP or UDP). |
| &nbsp; |  [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) | [Application Gateway](https://azure.microsoft.com/services/application-gateway/) | Application Gateway is a layer 7 load balancer. It supports SSL termination, cookie-based session affinity, and round robin for load-balancing traffic. |

## Security, identity, and access

### Authentication and authorization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam/) | [Azure Active Directory](https://azure.microsoft.com/services/active-directory/) | Allows users to securely control access to services and resources while offering data security and protection. Create and manage users and groups, and use permissions to allow and deny access to resources. |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam/) | [Azure Role Based Access Control](/azure/role-based-access-control/overview) | Role-based access control (RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. |
| [AWS Organizations](https://aws.amazon.com/organizations/) | [Azure Subscription Management + Azure RBAC](/azure/azure-subscription-service-limits) | Security policy and role management for working with multiple accounts. |
| [Multi-Factor Authentication](https://aws.amazon.com/iam/features/mfa/) | [Multi-Factor Authentication](https://azure.microsoft.com/services/multi-factor-authentication/) | Safeguard access to data and applications while meeting user demand for a simple sign-in process. |
| [AWS Directory Service](https://aws.amazon.com/directoryservice/) | [Azure Active Directory Domain Services](https://azure.microsoft.com/services/active-directory-ds/) | Provides managed domain services such as domain join, group policy, LDAP, and Kerberos/NTLM authentication that are fully compatible with Windows Server Active Directory. |
| [Cognito](https://aws.amazon.com/cognito/) | [Azure Active Directory B2C](https://azure.microsoft.com/services/active-directory-b2c/) | A highly available, global, identity management service for consumer-facing applications that scales to hundreds of millions of identities. |
| [AWS Organizations](https://aws.amazon.com/organizations/) | [Azure Policy](https://azure.microsoft.com/services/azure-policy/) | Azure Policy is a service in Azure that you use to create, assign, and manage policies. These policies enforce different rules and effects over your resources, so those resources stay compliant with your corporate standards and service level agreements. |
| [AWS Organizations](https://aws.amazon.com/organizations/) | [Management Groups](https://docs.microsoft.com/azure/governance/management-groups/) | Azure management groups provide a level of scope above subscriptions. You organize subscriptions into containers called "management groups" and apply your governance conditions to the management groups. All subscriptions within a management group automatically inherit the conditions applied to the management group. Management groups give you enterprise-grade management at a large scale, no matter what type of subscriptions you have. |

### Encryption

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Server-side encryption with Amazon S3 Key Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html) | [Azure Storage Service Encryption](/azure/storage/storage-service-encryption) | Helps you protect and safeguard your data and meet your organizational security and compliance commitments. |
| [Key Management Service (KMS)](https://aws.amazon.com/kms/), [CloudHSM](https://aws.amazon.com/cloudhsm/) | [Key Vault](https://azure.microsoft.com/services/key-vault/) | Provides security solution and works with other services by providing a way to manage, create, and control encryption keys stored in hardware security modules (HSM). |

### Firewall

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Web Application Firewall](https://aws.amazon.com/waf/) | [Application Gateway - Web Application Firewall](/azure/application-gateway/application-gateway-web-application-firewall-overview) | A firewall that protects web applications from common web exploits. |
| [Web Application Firewall](https://aws.amazon.com/waf/)| [Azure Firewall](https://azure.microsoft.com/services/azure-firewall/) | Provides inbound protection for non-HTTP/S protocols, outbound network-level protection for all ports and protocols, and application-level protection for outbound HTTP/S. |

### Security

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Inspector](https://aws.amazon.com/inspector/) | [Security Center](https://azure.microsoft.com/services/security-center/) | An automated security assessment service that improves the security and compliance of applications. Automatically assess applications for vulnerabilities or deviations from best practices. |
| [Certificate Manager](https://aws.amazon.com/certificate-manager/) | [App Service Certificates available on the Portal](https://azure.microsoft.com/blog/internals-of-app-service-certificate/) | Service that allows customers to create, manage, and consume certificates seamlessly in the cloud. |
| [GuardDuty](https://aws.amazon.com/guardduty/) | [Azure Advanced Threat Protection](https://azure.microsoft.com/features/azure-advanced-threat-protection/) | Detect and investigate advanced attacks on-premises and in the cloud. |
| [AWS Artifact](https://aws.amazon.com/artifact/) | [Service Trust Portal](https://servicetrust.microsoft.com/) | Provides access to audit reports, compliance guides, and trust documents from across cloud services. |
| [AWS Shield](https://aws.amazon.com/shield/) | [Azure DDos Protection Service](/azure/security/azure-ddos-best-practices) | Provides cloud services with protection from distributed denial of services (DDoS) attacks. |

## Storage

### Object storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Simple Storage Services (S3)](https://aws.amazon.com/s3/) | [Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction) | Object storage service, for use cases including cloud applications, content distribution, backup, archiving, disaster recovery, and big data analytics. |

### Virtual server disks

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic Block Store (EBS)](https://aws.amazon.com/ebs/) | [Azure managed disks](https://azure.microsoft.com/services/storage/disks/) | SSD storage optimized for I/O intensive read/write operations. For use as high-performance Azure virtual machine storage. |

### Shared files

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elastic File System](https://aws.amazon.com/efs/) | [Azure Files](https://azure.microsoft.com/services/storage/files/) | Provides a simple interface to create and configure file systems quickly, and share common files. Can be used with traditional protocols that access files over a network. |

### Archiving and backup

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [S3 Infrequent Access (IA)](https://aws.amazon.com/s3/storage-classes) | [Azure Storage cool tier](/azure/storage/blobs/storage-blob-storage-tiers) | Cool storage is a lower-cost tier for storing data that is infrequently accessed and long-lived. |
| [S3 Glacier](https://aws.amazon.com/s3/storage-classes) | [Azure Storage archive access tier](/azure/storage/blobs/storage-blob-storage-tiers) | Archive storage has the lowest storage cost and higher data retrieval costs compared to hot and cool storage. |
| [AWS Backup](https://aws.amazon.com/backup/) | [Azure Backup](https://azure.microsoft.com/services/backup/) | Back up and recover files and folders from the cloud, and provide offsite protection against data loss. |

### Hybrid storage

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Storage Gateway](https://aws.amazon.com/storagegateway/) | [StorSimple](https://azure.microsoft.com/services/storsimple/) | Integrates on-premises IT environments with cloud storage. Automates data management and storage, plus supports disaster recovery. |

### Bulk data transfer

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Import/Export Disk](https://aws.amazon.com/snowball/disk/details/) | [Import/Export](/azure/storage/common/storage-import-export-service) | A data transport solution that uses secure disks and appliances to transfer large amounts of data. Also offers data protection during transit. |
| [AWS Import/Export Snowball](https://aws.amazon.com/snowball/), [Snowball Edge](https://aws.amazon.com/snowball-edge/), [Snowmobile](https://aws.amazon.com/snowmobile/) | [Azure Data Box](https://azure.microsoft.com/services/storage/databox/) | Petabyte- to exabyte-scale data transport solution that uses secure data storage devices to transfer large amounts of data to and from Azure. |

## Web applications

| AWS service | Azure service | Description |
|------|-------------|---------------|-------------|
| [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) | [App Service](https://azure.microsoft.com/services/app-service) | Managed hosting platform providing easy to use services for deploying and scaling web applications and services. |
| [API Gateway](https://aws.amazon.com/api-gateway/) | [API Management](https://azure.microsoft.com/services/api-management/) | A turnkey solution for publishing APIs to external and internal consumers. |
| [CloudFront](https://aws.amazon.com/cloudfront/) | [Azure Content Delivery Network](https://azure.microsoft.com/services/cdn/) | A global content delivery network that delivers audio, video, applications, images, and other files. |
| [Global Accelerator ](https://aws.amazon.com/global-accelerator/) | [Azure Front Door](https://azure.microsoft.com/services/frontdoor/) | Easily join your distributed microservice architectures into a single global application using HTTP load balancing and path-based routing rules. Automate turning up new regions and scale-out with API-driven global actions, and independent fault-tolerance to your back end microservices in Azure—or anywhere. |


## Miscellaneous

| Area | AWS service | Azure service | Description |
|------|-------------|---------------|-------------|
| Backend process logic | [AWS Step Functions](https://aws.amazon.com/step-functions/) | [Logic Apps](https://azure.microsoft.com/services/logic-apps/) | Cloud technology to build distributed applications using out-of-the-box connectors to reduce integration challenges. Connect apps, data and devices on-premises or in the cloud. |
| Enterprise application services | [Amazon WorkMail](https://aws.amazon.com/workmail/), [Amazon WorkDocs](https://aws.amazon.com/workdocs/) | [Office 365](https://products.office.com/) | Fully integrated Cloud service providing communications, email, document management in the cloud and available on a wide variety of devices. |
| Gaming | [GameLift](https://aws.amazon.com/gamelift/), [GameSparks](https://www.gamesparks.com/) | [PlayFab](https://playfab.com/) | Managed services for hosting dedicated game servers. |
| Media transcoding | [Elastic Transcoder](https://aws.amazon.com/elastictranscoder/) | [Media Services](https://azure.microsoft.com/services/media-services/) | Services that offer broadcast-quality video streaming services, including various transcoding technologies. |
| Workflow | [Simple Workflow Service (SWF)](https://aws.amazon.com/swf/) | [Logic Apps](https://azure.microsoft.com/services/logic-apps/) | Serverless technology for connecting apps, data and devices anywhere, whether on-premises or in the cloud for large ecosystems of SaaS and cloud-based connectors. |
| Hybrid | [Outposts](https://aws.amazon.com/outposts/) | [Azure Stack](https://azure.microsoft.com/overview/azure-stack/) | Azure Stack is a hybrid cloud platform that enables you to run Azure services in your company's or service provider's datacenter. As a developer, you can build apps on Azure Stack. You can then deploy them to either Azure Stack or Azure, or you can build truly hybrid apps that take advantage of connectivity between an Azure Stack cloud and Azure. |

## More learning

If you are new to Azure, review the interactive [Core Cloud Services - Introduction to Azure](/learn/modules/welcome-to-azure) module on [Microsoft Learn](/learn).
