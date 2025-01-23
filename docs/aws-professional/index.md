---
title: Azure for AWS professionals
description: Learn the basics of Microsoft Azure accounts, platform, and services, and key similarities and differences between the AWS and Azure platforms.
author: scaryghosts
ms.author: adamcerini
ms.date: 1/23/2025
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

- How to think about Azure capabilities coming from an AWS background.
- How Azure organizes accounts and resources.
- How the major Azure services differ from AWS services or how they are similar.

Use the table of contents to select specific technology areas that are relevant to your workload. These articles compare services that are roughly comparable. Not every AWS service or Azure service is listed, and not every matched service has exact feature-for-feature parity.

## Similarities and differences

Like AWS, Azure builds on a core set of AI, compute, storage, database, and networking services. In many cases, the platforms offer similar products and services. For example, both AWS and Azure can use Linux distributions and open-source software technologies. Both platforms support building highly available solutions on Windows or Linux hosts.

While the capabilities of both platforms are similar, the resources that provide those capabilities are often organized differently. Azure and AWS built their capabilities independently over time, so the platforms have important implementation and design differences. For instance, AWS relies heavily on AWS accounts to serve as a logical boundary for things like applying permissions or tracking spend. Azure has subscriptions which are similar to AWS accounts, it also and resource groups are used to logically group and manage resources at a more granular level.

Exact one-to-one correspondences between the services that you need to build a solution aren't always clear. Sometimes, only one of the platforms offers a particular service. 

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
| [AWS Marketplace](https://aws.amazon.com/marketplace) | [Azure Marketplace](https://azure.microsoft.com/marketplace) | Easy-to-deploy and automatically configured third-party applications, including single virtual machine or multiple virtual machine solutions. Both marketplaces also offer the ability purchase SaaS products. Many of these offers are eligible to count toward your consumption commitment. To understand which offers count toward your commitment, see [Azure consumption commitment benefit](/marketplace/azure-consumption-commitment-benefit#determine-which-offers-are-eligible-for-azure-consumption-commitments-maccctc). |


### Time series databases and analytics

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Amazon Timestream](https://aws.amazon.com/timestream) | [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer)<br/><br/> [Azure Time Series Insights](https://azure.microsoft.com/services/time-series-insights) | Fully managed, low latency, and distributed big data analytics platform that runs complex queries across petabytes of data. Highly optimized for log and time series data. <br/><br/> Open and scalable end-to-end IoT analytics service. Collect, process, store, query, and visualize data at Internet of Things (IoT) scale--data that's highly contextualized and optimized for time series. |


### Application monitoring, observability, and DevOps

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [CloudWatch](https://aws.amazon.com/cloudwatch), [X-Ray](https://aws.amazon.com/xray/) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It offers the ability to instrument your code for deeper application performance monitoring with a feature called [Application Insights](/azure/azure-monitor/app/app-insights-overview). In AWS, you typically use both X-Ray and CloudWatch. |
| [CodeDeploy](https://aws.amazon.com/codedeploy) <br/><br/>[CodeCommit (deprecated)](https://aws.amazon.com/codecommit/) <br/><br/>[CodePipeline](https://aws.amazon.com/codepipeline) <br/><br/> [CodeConnections](https://docs.aws.amazon.com/dtconsole/latest/userguide/welcome-connections.html) <br/><br/>[CodeBuild](https://aws.amazon.com/codebuild)  | [Azure DevOps](https://azure.microsoft.com/services/devops/)<br/><br/> [GitHub](https://github.com) <br/><br/> [GitHub Actions](https://github.com/features/actions) | Azure DevOps is a single solution focused on collaboration, CI/CD, code testing, code artifacts, security testing, and code management. Many of these functions are supported across the AWS code family of products. AWS no longer offers new customers a code repository, but it does allow integration with 3rd party repositories via CodeConnections.|
| [AWS CLI](https://aws.amazon.com/cli) <br/><br/>[AWS Tools for Powershell](https://aws.amazon.com/powershell/) <br/><br/>[AWS SDKs](https://aws.amazon.com/developer/tools/)| [Azure CLI](/cli/azure/install-azure-cli) <br/><br/>[PowerShell](/powershell/azure/overview) <br/><br/>[Azure SDKs](/downloads/) | Built on top of the native REST API across all cloud services, various programming language-specific wrappers provide easier ways to create solutions. |
| [AWS CloudShell](https://aws.amazon.com/cloudshell) | [Azure Cloud Shell](/azure/cloud-shell/overview) | Azure Cloud Shell is an interactive, authenticated, browser-accessible shell for managing Azure resources. It gives you the flexibility to choose the shell experience that best suits the way you work, either Bash or PowerShell. |
| [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/) | [Azure Automation](https://azure.microsoft.com/services/automation) | Configures and operates applications of all shapes and sizes. It provides templates to create and manage a collection of resources. |
| [CloudFormation](https://aws.amazon.com/cloudformation) <br/><br/>[Cloud Development Kit](https://aws.amazon.com/cdk) | [Resource Manager](https://azure.microsoft.com/features/resource-manager) <br/><br/>[Bicep](/azure/azure-resource-manager/bicep/overview) <br/><br/>[VM extensions](/azure/virtual-machines/extensions/features-windows) <br/><br/>[Azure Automation](https://azure.microsoft.com/services/automation)  <br/><br/> [Azure Developer CLI](/azure/developer/azure-developer-cli/) | Provides ways for developers and cloud admins to build and deploy repeatable cloud environments using declarative syntax or common programming languages to define infrastructure as code. |

### Internet of Things (IoT)

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [IoT Core](https://aws.amazon.com/iot-core) | [IoT Hub](https://azure.microsoft.com/services/iot-hub) | A cloud gateway for managing bidirectional communication with billions of IoT devices, securely and at scale. |
| [Greengrass](https://aws.amazon.com/greengrass) | [IoT Edge](https://azure.microsoft.com/services/iot-edge) | Deploy cloud intelligence directly onto IoT devices, catering to on-premises scenarios. |
| [Kinesis Firehose](https://aws.amazon.com/kinesis/data-firehose), [Kinesis Streams](https://aws.amazon.com/kinesis/data-streams) | [Event Hubs](https://azure.microsoft.com/services/event-hubs) <br/><br/>[Azure Stream Analytics](https://azure.microsoft.com/products/stream-analytics) | Services that facilitate the mass ingestion of events (messages), typically from devices and sensors. The data can then be processed in real-time micro-batches or be written to storage for further analysis. Both Kinesis Streaming and Azure Stream Analytics have real-time data processing capabilities.|
| [IoT Things Graph](https://aws.amazon.com/iot-things-graph) | [Digital Twins](https://azure.microsoft.com/services/digital-twins) | Services you can use to create digital representations of real-world things, places, business processes, and people. Use these services to gain insights, drive the creation of better products and new customer experiences, and optimize operations and costs. |
| [IoT Device Management](https://aws.amazon.com/iot-device-management/)<br/><br/>[IoT Fleetwise](https://aws.amazon.com/iot-fleetwise/) | [Azure IoT Central](https://azure.microsoft.com/products/iot-central/) | Services used for connecting and managing IoT devices at scale. Azure IoT Central is for general use cases and vehicle-based use cases. AWS offers IoT Fleetwise specifically for vehicles.  |
| [IoT ExpressLink](https://aws.amazon.com/iot-expresslink/) | [Azure Sphere](/azure-sphere/product-overview) | Device modules and software to build custom internet-connected devices. |

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
| [Config](https://aws.amazon.com/config) | [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/overview)<br/><br/>[Application Change Analysis](/azure/azure-monitor/app/change-analysis) | Azure Policy helps implement governance for resource consistency, regulatory compliance, security, cost, and management. It allows for bulk remediation for existing resources and automatic remediation for new resources. AWS config is typically used to either monitor for configuration changes or to identify and remediate non-compliant resources.  |
| [Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer) | [Cost Management](https://azure.microsoft.com/services/cost-management) | Perform cost analysis and optimize cloud costs. |
| [Control Tower](https://aws.amazon.com/controltower) | [Azure Lighthouse](/azure/lighthouse/overview) | Set up and govern a multi account/subscription environment. |
| [Resource Groups and Tag Editor](https://docs.aws.amazon.com/ARG) | [Resource Groups](/azure/azure-resource-manager/management/overview) and [Tags](/azure/azure-resource-manager/management/tag-resources) | A Resource Group is a container that holds related resources for an Azure solution. Apply tags to your Azure resources to logically organize them by categories. |
| [AWS AppConfig](https://aws.amazon.com/systems-manager/features/appconfig) | [Azure App Configuration](/azure/azure-app-configuration) | Azure App Configuration is a managed service that helps developers centralize their application and feature settings simply and securely. |
| [Service Catalog](https://aws.amazon.com/servicecatalog) | [Azure Managed Applications](/azure/azure-resource-manager/managed-applications/overview) | Offers cloud solutions that are easy for consumers to deploy and operate.


### Authentication and authorization

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [IAM Identity Center](https://aws.amazon.com/iam/identity-center/)<br/><br/>[Identity and Access Management (IAM)](https://aws.amazon.com/iam) | [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory) | Allows users to securely control access to services and resources while offering data security and protection. Create and manage users and groups, and use permissions to allow and deny access to resources. |
| [Identity and Access Management (IAM)](https://aws.amazon.com/iam) | [Azure role-based access control (RBAC)](/azure/role-based-access-control/overview) | Azure role-based access control (RBAC) helps you manage who has access to Azure resources, what they can do with those resources, and what areas they have access to. |
| [Organizations](https://aws.amazon.com/organizations) | [Azure Management Groups](https://azure.microsoft.com/get-started/azure-portal/management-groups/) | Security policy and role management for working with multiple accounts. |
| [Multi-Factor Authentication](https://aws.amazon.com/iam/features/mfa) | [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory) | Safeguard access to data and applications while meeting user demand for a simple sign-in process. |
| [Directory Service](https://aws.amazon.com/directoryservice) | [Microsoft Entra Domain Services](https://azure.microsoft.com/services/active-directory-ds) | Provides managed domain services, such as domain join, group policy, LDAP, and Kerberos/NTLM authentication, which are fully compatible with Windows Server Active Directory. |
| [Cognito](https://aws.amazon.com/cognito) | [Microsoft Entra External ID](/entra/external-id/external-identities-overview) | A highly available, global identity management service for consumer-facing applications where you need to support "bring your own identity" scenarios, such as identities from Google or Meta. |


### Encryption

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Server-side encryption with Amazon S3 Key Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html) | [Azure Storage Service Encryption](/azure/storage/storage-service-encryption) | Helps you protect and safeguard your data and meet your organizational security and compliance commitments. |
| [Key Management Service (KMS)](https://aws.amazon.com/kms), [CloudHSM](https://aws.amazon.com/cloudhsm) | [Key Vault](https://azure.microsoft.com/services/key-vault) <br/><br> [Azure Managed HSM](/azure/key-vault/managed-hsm/overview) | Provides security solution and works with other services by providing a way to manage, create, and control encryption keys stored in hardware security modules (HSMs). Azure Key Vault allows customers to choose to use a shared HSM or a dedicated HSM. On AWS, KMS uses a shared HSM and CloudHSM is a dedicated HSM. Both platforms offer FIPS validated options. |
| [Nitro Enclaves](https://aws.amazon.com/ec2/nitro/nitro-enclaves/) | [Azure Confidential Computing](https://azure.microsoft.com/solutions/confidential-compute/) | Provides platforms with additional controls to protect data while it is being processed and remotely verify platform trustworthiness. Beyond offering core confidential compute capabilities, Azure offers Azure SQL Always Encrypted and confidential VMs for Azure Virtual Desktop, Azure Data Explorer, and Azure Databricks. |


### Firewalls

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Web Application Firewall](https://aws.amazon.com/waf) | [Web Application Firewall](https://azure.microsoft.com/products/web-application-firewall) | A firewall that protects web applications from common web exploits. |
| [AWS Network Firewall](https://aws.amazon.com/network-firewall)| [Firewall](https://azure.microsoft.com/services/azure-firewall) | Provides inbound protection and outbound network-level protection across all ports and protocols. Both solutions support the ability to inspect and apply rules for encrypted web traffic. |

### Security

| AWS service | Azure service | Description |
| ----------- | ------------- | ----------- |
| [Inspector](https://aws.amazon.com/inspector) | [Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud/) | An automated security assessment service that improves the security and compliance of applications. Automatically assess applications for vulnerabilities or deviations from best practices. |
| [Certificate Manager](https://aws.amazon.com/certificate-manager) | [Azure Key Vault certificates](/azure/key-vault/certificates/about-certificates) <br/><br> [Cloud PKI](https://www.microsoft.com/security/business/endpoint-management/microsoft-cloud-PK)|Create and manage certificates and their keys. |
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
| [WorkSpaces](https://aws.amazon.com/workspaces), [AppStream 2.0](https://aws.amazon.com/appstream2) | [Azure Virtual Desktop](/azure/virtual-desktop) | Manage virtual desktops and applications to enable corporate network and data access to users, anytime, anywhere, from supported devices. Amazon WorkSpaces support Windows and Linux virtual desktops. Azure Virtual Desktop supports single and multi-session Windows virtual desktops.|


## Miscellaneous

| Area | AWS service | Azure service | Description |
|------|-------------|---------------|-------------|
| Backend process logic | [Step Functions](https://aws.amazon.com/step-functions) | [Logic Apps](https://azure.microsoft.com/services/logic-apps) | Cloud technology to build distributed applications using out-of-the-box connectors to reduce integration challenges. Connect apps, data, and devices on-premises or in the cloud. |
| Enterprise application services | [WorkMail](https://aws.amazon.com/workmail), [WorkDocs (deprecated)](https://aws.amazon.com/workdocs), [Chime](https://aws.amazon.com/chime) | [Microsoft 365](https://www.microsoft.com/microsoft-365) | Fully integrated cloud service that provides communications, email, and document management in the cloud and is available on a wide variety of devices. |
| Gaming | [GameLift](https://aws.amazon.com/gamelift) | [PlayFab](https://playfab.com) | Managed services for hosting dedicated game servers. |
| Workflow | [Step Functions](https://aws.amazon.com/step-functions) | [Logic Apps](https://azure.microsoft.com/services/logic-apps) | Serverless technology for connecting apps, data and devices anywhere, whether on-premises or in the cloud for large ecosystems of SaaS and cloud-based connectors. |
| Hybrid | [Outposts](https://aws.amazon.com/outposts) | [Azure Arc](azure/azure-arc/overview) <br/><br/>[Azure Local](azure/azure-local/overview) | AWS Outposts and Azure Local enable you to extend your cloud datacenter to the edge with platforms combining hardware and software. Azure Arc allows you to extend Azure management capabilities to on-premise or multi-cloud environments. |
| Media | [Elastic Transcoder](https://aws.amazon.com/elastictranscoder)<br/><br> [Elemental MediaConvert](https://aws.amazon.com/media-services) | [3rd Party solutions] (previous-versions/azure/media-services/latest/azure-media-services-retirement) | Azure does not have a media services offering and instead recommends 3rd party solutions. |
| Satellite | [Ground Station](https://aws.amazon.com/ground-station) | None | Microsoft does not have a fully managed ground station offering. Please visit https://planetarycomputer.microsoft.com/ for Microsoft provided data along with https://www.earthdata.nasa.gov/ for NASA provided data. |
| Quantum computing | [Amazon Braket](https://aws.amazon.com/braket) | [Azure Quantum](/azure/quantum/overview-azure-quantum) | Managed quantum computing service that developers, researchers, and businesses can use to run quantum computing programs.|
| Data Sharing | [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | [Azure Data Share](https://azure.microsoft.com/products/data-share/) | Securely share data with other organizations.|
| Contact Center | [Amazon Connect](https://aws.amazon.com/connect/) | [Dynamics 365 Contact Center](https://www.microsoft.com/dynamics-365/products/contact-center) | AI powered cloud contact center capabilities.|

## Next steps

> [!div class="nextstepaction"]
> [Azure and AWS accounts and subscriptions](./accounts.md)
