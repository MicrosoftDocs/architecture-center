---
title: Azure for AWS professionals
description: Learn the basics of Microsoft Azure accounts, platform, and services, and key similarities and differences between the AWS and Azure platforms.
author: scaryghosts
ms.author: adamcerini
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
categories: azure
azureCategories:
  - analytics
  - compute
  - developer-tools
  - devops
  - networking
  - web
products:
  - azure-cloud-services
  - azure-devops
  - azure-managed-applications
---

# Azure for AWS professionals

This series of articles helps Amazon Web Services (AWS) experts understand the basics of Microsoft Azure accounts, platform, and services. These articles also cover key similarities and differences between AWS and Azure. Whether you are planning a multicloud solution with Azure and AWS or migrating to Azure, you can compare the capabilities of Azure and AWS services in all categories.

These articles describe:

- How Azure organizes accounts and resources.
- How Azure structures available solutions.
- How the major Azure services differ from AWS services or how they are similar.

Use the table of contents to select specific technology areas that are relevant to your workload. These articles compare services that are roughly comparable. Not every AWS service or Azure service is listed, and not every matched service has exact feature-for-feature parity.

## Similarities and differences

Like AWS, Microsoft Azure builds on a core set of compute, storage, database, and networking services. In many cases, the platforms offer similar products and services. For example, both AWS and Azure can use Linux distributions and open-source software technologies. Both platforms support building highly available solutions on Windows or Linux hosts.

While the capabilities of both platforms are similar, the resources that provide those capabilities are often organized differently. Azure and AWS built their capabilities independently over time, so the platforms have important implementation and design differences. Exact one-to-one correspondences between the services that you need to build a solution aren't always clear. Sometimes, only one of the platforms offers a particular service.

Not all Azure products and services are available in all regions. For details, see [Products available by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/). For Azure product and service uptime guarantees and downtime credit policies, see [Service Level Agreements (SLA) for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

## Primary topics

Use the following pages to learn about Azure technologies and how they map to technologies you are already familre with in Amazon Web Services (AWS). These articles go into a bit more details on how Azure works in these specific areas

- [Azure and AWS accounts and subscriptions](./accounts.md)
- [Compute services on Azure and AWS](./compute.md)
- [Data and AI](./data-ai.md)
- [Relational database technologies on Azure and AWS](./databases.md)
- [Messaging services on Azure and AWS](./messaging.md)
- [Networking on Azure and AWS](./networking.md)
- [Regions and zones on Azure and AWS](./regions-zones.md)
- [Resource management on Azure and AWS](./resources.md)
- [Multicloud security and identity with Azure and AWS](./security-identity.md)
- [Compare storage on Azure and AWS](./storage.md)

## Additional categories

There are some services not covered in the prior articles. Those services are mapped here from their AWS service to their matching Azure service.

### Marketplace

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [AWS Marketplace](https://aws.amazon.com/marketplace) | [Azure Marketplace](https://azure.microsoft.com/marketplace) | Easy-to-deploy and automatically configured third-party applications, including single virtual machine or multiple virtual machine solutions. |

### AI and machine learning

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Alexa Skills Kit](https://developer.amazon.com/alexa/alexa-skills-kit) | [Bot Framework](https://dev.botframework.com) | Build and connect intelligent bots that interact with your users using text/SMS, Skype, Teams, Slack, Microsoft 365 mail, Twitter, and other popular services. |
| [Skills Kit](https://developer.amazon.com/alexa/alexa-skills-kit) | [Virtual Assistant](/azure/bot-service/bot-builder-virtual-assistant-introduction?view=azure-bot-service-4.0&preserve-view=true) | The Virtual Assistant Template brings together a number of best practices we've identified through the building of conversational experiences and automates integration of components that we've found to be highly beneficial to Bot Framework developers. |

### Time series databases and analytics

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Amazon Timestream](https://aws.amazon.com/timestream) | [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer)<br/><br/> [Azure Time Series Insights](https://azure.microsoft.com/services/time-series-insights) | Fully managed, low latency, and distributed big data analytics platform that runs complex queries across petabytes of data. Highly optimized for log and time series data. <br/><br/> Open and scalable end-to-end IoT analytics service. Collect, process, store, query, and visualize data at Internet of Things (IoT) scale--data that's highly contextualized and optimized for time series. |

### Analytics and visualization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Elasticsearch Service](https://aws.amazon.com/elasticsearch-service/the-elk-stack) | [Elastic on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/elastic.ec-azure-pp) |  Use the Elastic Stack (Elastic, Logstash, and Kibana) to search, analyze, and visualize in real time. |

### DevOps and application monitoring

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [CloudWatch](https://aws.amazon.com/cloudwatch), [X-Ray](https://aws.amazon.com/xray/) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [CodeDeploy](https://aws.amazon.com/codedeploy) <br/><br/>[CodeCommit](https://aws.amazon.com/codecommit/) <br/><br/>[CodePipeline](https://aws.amazon.com/codepipeline) | [DevOps](https://azure.microsoft.com/services/devops/) | A cloud service for collaborating on code development. |
| [Developer Tools](https://aws.amazon.com/products/developer-tools) | [Developer Tools](https://azure.microsoft.com/services/devops/) | Collection of tools for building, debugging, deploying, diagnosing, and managing multiplatform scalable apps and services. |
| [CodeBuild](https://aws.amazon.com/codebuild) | [DevOps Pipeline](https://azure.microsoft.com/services/devops/pipelines) <br/><br/> [GitHub Actions](https://github.com/features/actions) | Fully managed build service that supports continuous integration and continuous deployment (CI/CD). |
| [Command-line interface](https://aws.amazon.com/cli) | [CLI](/cli/azure/install-azure-cli) <br/><br/>[PowerShell](/powershell/azure/overview) | Built on top of the native REST API across all cloud services, various programming language-specific wrappers provide easier ways to create solutions. |
| [`eksctl`](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) | [`az aks`](/cli/azure/aks) command group | Manage Azure Kubernetes Service (AKS) using these Azure CLI commands. |
| [AWS CloudShell](https://aws.amazon.com/cloudshell) | [Azure Cloud Shell](/azure/cloud-shell/overview) | Azure Cloud Shell is an interactive, authenticated, browser-accessible shell for managing Azure resources. It gives you the flexibility to choose the shell experience that best suits the way you work, either Bash or PowerShell. |
| [OpsWorks (Chef-based)](https://aws.amazon.com/opsworks) | [Automation](https://azure.microsoft.com/services/automation) | Configures and operates applications of all shapes and sizes, and provides templates to create and manage a collection of resources. |
| [CloudFormation](https://aws.amazon.com/cloudformation) | [Resource Manager](https://azure.microsoft.com/features/resource-manager) <br/><br/>[Bicep](/azure/azure-resource-manager/bicep/overview) <br/><br/>[VM extensions](/azure/virtual-machines/extensions/features-windows) <br/><br/>[Azure Automation](https://azure.microsoft.com/services/automation) | Provides a way for users to automate the manual, long-running, error-prone, and frequently repeated IT tasks.
| [Cloud Development Kit](https://aws.amazon.com/cdk) | [Azure Developer CLI](/azure/developer/azure-developer-cli/) <br/><br/>[Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/) | Developer-friendly imperative commands that enable consistent and repeatable work and standardized infrastructure-as-code modules. |

### Internet of Things (IoT)

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [IoT Core](https://aws.amazon.com/iot-core) | [IoT Hub](https://azure.microsoft.com/services/iot-hub) | A cloud gateway for managing bidirectional communication with billions of IoT devices, securely and at scale. |
| [Greengrass](https://aws.amazon.com/greengrass) | [IoT Edge](https://azure.microsoft.com/services/iot-edge) | Deploy cloud intelligence directly onto IoT devices, catering to on-premises scenarios. |
| [Kinesis Firehose](https://aws.amazon.com/kinesis/data-firehose), [Kinesis Streams](https://aws.amazon.com/kinesis/data-streams) | [Event Hubs](https://azure.microsoft.com/services/event-hubs) | Services that facilitate the mass ingestion of events (messages), typically from devices and sensors. The data can then be processed in real-time micro-batches or be written to storage for further analysis. |
| [IoT Things Graph](https://aws.amazon.com/iot-things-graph) | [Digital Twins](https://azure.microsoft.com/services/digital-twins) | Services you can use to create digital representations of real-world things, places, business processes, and people. Use these services to gain insights, drive the creation of better products and new customer experiences, and optimize operations and costs. |

### Management and governance

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [AWS Organizations](https://aws.amazon.com/organizations) | [Management Groups](/azure/governance/management-groups)| Azure management groups help you organize your resources and subscriptions.|
| [AWS Well-Architected Tool](https://docs.aws.amazon.com/wellarchitected/latest/userguide/intro.html)| [Azure Well-Architected Review](/assessments/?mode=pre-assessment)| Examine your workload through the lenses of reliability, cost management, operational excellence, security, and performance efficiency. |
| [Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor) | [Azure Advisor](https://azure.microsoft.com/services/advisor) | Provides analysis of cloud resource configuration and security, so that subscribers can ensure they're making use of best practices and optimum configurations. |
| [AWS Billing and Cost Management](https://docs.aws.amazon.com/account-billing/index.html) | [Microsoft Cost Management](/azure/cost-management-billing) | Microsoft Cost Management helps you understand your Azure invoice (bill), manage your billing account and subscriptions, monitor and control Azure spending, and optimize resource use. |
| [Cost and Usage Reports](https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html) | [Usage Details API](/azure/cost-management-billing/manage/consumption-api-overview#usage-details-api) | Services to help generate, monitor, forecast, and share billing data for resource usage by time, organization, or product resources. |
| [Management Console](https://aws.amazon.com/console) | [Portal](https://azure.microsoft.com/features/azure-portal) | A unified management console that simplifies building, deploying, and operating your cloud resources. |
| [Application Discovery Service](https://aws.amazon.com/application-discovery) | [Migrate](https://azure.microsoft.com/services/azure-migrate) | Assesses on-premises workloads for migration to Azure, performs performance-based sizing, and provides cost estimations. |
| [Systems Manager](https://aws.amazon.com/systems-manager) | [Monitor](https://azure.microsoft.com/services/monitor) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. |
| [Personal Health Dashboard](https://aws.amazon.com/premiumsupport/technology/personal-health-dashboard) | [Resource Health](/azure/resource-health/resource-health-overview) | Provides detailed information about the health of resources, as well as recommended actions for maintaining resource health. |
| [CloudTrail](https://aws.amazon.com/cloudtrail) | [Activity log](/azure/azure-monitor/essentials/activity-log) | The Activity log is a platform log in Azure that provides insight into subscription-level events, such as when a resource is modified or when a virtual machine is started. |
| [CloudWatch](https://aws.amazon.com/cloudwatch) | [Application Insights](/azure/azure-monitor/app/app-insights-overview) | A feature of Azure Monitor, Application Insights is an extensible Application Performance Management (APM) service for developers and DevOps professionals, which provides telemetry insights and information, in order to better understand how applications are performing and to identify areas for optimization. |
| [Config](https://aws.amazon.com/config) | [Application Change Analysis](/azure/azure-monitor/app/change-analysis) | Application Change Analysis detects various types of changes, from the infrastructure layer all the way to application deployment.|
| [Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer) | [Cost Management](https://azure.microsoft.com/services/cost-management) | Optimize costs while maximizing cloud potential. |
| [Control Tower](https://aws.amazon.com/controltower) | [Azure Lighthouse](/azure/lighthouse/overview) | Set up and govern a multi account/subscription environment. |
| [Resource Groups and Tag Editor](https://docs.aws.amazon.com/ARG) | [Resource Groups](/azure/azure-resource-manager/management/overview) and [Tags](/azure/azure-resource-manager/management/tag-resources) | A Resource Group is a container that holds related resources for an Azure solution. Apply tags to your Azure resources to logically organize them by categories. |
| [AWS AppConfig](https://aws.amazon.com/systems-manager/features/appconfig) | [Azure App Configuration](/azure/azure-app-configuration) | Azure App Configuration is a managed service that helps developers centralize their application and feature settings simply and securely. |
| [Service Catalog](https://aws.amazon.com/servicecatalog) | [Azure Managed Applications](/azure/azure-resource-manager/managed-applications/overview) | Offers cloud solutions that are easy for consumers to deploy and operate.
| [SDKs and tools](https://aws.amazon.com/getting-started/tools-sdks) | [SDKs and tools](https://azure.microsoft.com/downloads) | Manage and interact with Azure services the way you prefer, programmatically from your language of choice, by using the Azure SDKs, our collection of tools, or both. |

### Authentication and authorization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam) | [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory) | Allows users to securely control access to services and resources while offering data security and protection. Create and manage users and groups, and use permissions to allow and deny access to resources. |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam) | [Azure role-based access control (RBAC)](/azure/role-based-access-control/overview) | Azure role-based access control (RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. |
| [Organizations](https://aws.amazon.com/organizations) | [Subscription Management + Azure RBAC](/azure/azure-subscription-service-limits) | Security policy and role management for working with multiple accounts. |
| [Multi-Factor Authentication](https://aws.amazon.com/iam/features/mfa) | [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory) | Safeguard access to data and applications while meeting user demand for a simple sign-in process. |
| [Directory Service](https://aws.amazon.com/directoryservice) | [Microsoft Entra Domain Services](https://azure.microsoft.com/services/active-directory-ds) | Provides managed domain services, such as domain join, group policy, LDAP, and Kerberos/NTLM authentication, which are fully compatible with Windows Server Active Directory. |
| [Cognito](https://aws.amazon.com/cognito) | [Microsoft Entra External ID](https://azure.microsoft.com/products/active-directory/external-identities/) | A highly available, global identity management service for consumer-facing applications that scales to hundreds of millions of identities. |
| [AWS Config](https://aws.amazon.com/config/) | [Policy](https://azure.microsoft.com/services/azure-policy/) | Azure Policy is a service in Azure that you use to create, assign, and manage policies. These policies enforce different rules and effects over your resources so those resources stay compliant with your corporate standards and service-level agreements. |
| [Organizations](https://aws.amazon.com/organizations) | [Management Groups](/azure/governance/management-groups/) | Azure management groups provide a level of scope above subscriptions. You organize subscriptions into containers called "management groups" and apply your governance conditions to the management groups. All subscriptions within a management group automatically inherit the conditions applied to the management group. Management groups give you enterprise-grade management at a large scale, no matter what type of subscriptions you have. |

### Encryption

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Server-side encryption with Amazon S3 Key Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html) | [Azure Storage Service Encryption](/azure/storage/storage-service-encryption) | Helps you protect and safeguard your data and meet your organizational security and compliance commitments. |
| [Key Management Service (KMS)](https://aws.amazon.com/kms), [CloudHSM](https://aws.amazon.com/cloudhsm) | [Key Vault](https://azure.microsoft.com/services/key-vault) | Provides security solution and works with other services by providing a way to manage, create, and control encryption keys stored in hardware security modules (HSMs). |

### Firewalls

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
| [Shield](https://aws.amazon.com/shield) | [DDoS Protection Service](/azure/security/fundamentals/ddos-best-practices) | Provides cloud services with protection from distributed denial of services (DDoS) attacks. |

### Web applications

| AWS service | Azure service | Description |
|------|-------------|---------------|
| [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk) | [App Service](https://azure.microsoft.com/services/app-service) | Managed hosting platform providing easy to use services for deploying and scaling web applications and services. |
| [API Gateway](https://aws.amazon.com/api-gateway) | [API Management](https://azure.microsoft.com/services/api-management) | A turnkey solution for publishing APIs to external and internal consumers. |
| [CloudFront](https://aws.amazon.com/cloudfront) | [Azure Front Door](https://azure.microsoft.com/services/frontdoor) | Azure Front Door is a modern cloud content delivery network (CDN) service that delivers high performance, scalability, and secure user experiences for your content and applications. |
| [Global Accelerator](https://aws.amazon.com/global-accelerator) | [Azure Front Door](https://azure.microsoft.com/services/frontdoor) | Easily join your distributed microservices architectures into a single global application using HTTP load balancing and path-based routing rules. Automate turning up new regions and scale-out with API-driven global actions and independent fault-tolerance to your back-end microservices in Azure or anywhere. |
| [Global Accelerator](https://aws.amazon.com/global-accelerator) | [Cross-regional load balancer](/azure/load-balancer/cross-region-overview) | Distribute and load balance traffic across multiple Azure regions via a single, static, global anycast public IP address. |
| [Lightsail](https://aws.amazon.com/lightsail) | [App Service](https://azure.microsoft.com/services/app-service) | Build, deploy, and scale web apps on a fully managed platform. |
| [App Runner](https://aws.amazon.com/apprunner) | [Web App for Containers](https://azure.microsoft.com/services/app-service/containers) | Easily deploy and run containerized web apps on Windows and Linux. |
| [Amplify](https://aws.amazon.com/amplify) | [Static Web Apps](https://azure.microsoft.com/services/app-service/static) | Boost productivity with a tailored developer experience, CI/CD workflows to build and deploy your static content hosting, and dynamic scale for integrated serverless APIs. |

### End-user computing

| AWS service | Azure service | Description |
|------|-------------|---------------|
| [WorkSpaces](https://aws.amazon.com/workspaces), [AppStream 2.0](https://aws.amazon.com/appstream2) | [Azure Virtual Desktop](/azure/virtual-desktop) | Manage virtual desktops and applications to enable corporate network and data access to users, anytime, anywhere, from supported devices. Amazon WorkSpaces support Windows and Linux virtual desktops. Azure Virtual Desktop supports multi-session Windows 10 virtual desktops.|
| [WorkLink](https://aws.amazon.com/worklink) | [Application Proxy](/azure/active-directory/app-proxy/application-proxy) | Provides access to intranet applications without requiring VPN connectivity. Amazon WorkLink is limited to iOS and Android devices.|

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

> [!div class="nextstepaction"]
> [Azure and AWS accounts and subscriptions](./accounts.md)
