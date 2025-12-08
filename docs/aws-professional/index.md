---
title: Azure for AWS Professionals
description: Learn about the basics of the Microsoft Azure platform, accounts, and services. Discover key similarities and differences between the AWS and Azure platforms.
author: splitfinity81
ms.author: yubaijna
ms.date: 02/07/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
---

# Azure for AWS professionals

This article introduces a series of articles that help Amazon Web Services (AWS) experts understand the basics of the Microsoft Azure platform, accounts, and services. This article describes key similarities and differences between AWS and Azure. Whether you're designing a multicloud solution that uses both Azure and AWS or migrating from AWS to Azure, you can compare the capabilities of Azure and AWS services in all categories.

The articles in this series describe:

- How to think about Azure capabilities from an AWS perspective.
- How Azure organizes accounts and resources.
- How core Azure services differ from AWS services and how they're similar.

Use the table of contents to select the technology areas that are relevant to your workload. These articles compare services that are roughly comparable. Not every AWS service or Azure service is listed, and not every matched service has exact feature-for-feature parity.

## Similarities and differences

AWS and Azure build on a core set of AI, compute, storage, database, and networking services. In many cases, the platforms provide similar products and services. For example, both AWS and Azure can use Linux distributions and open-source software technologies. Both platforms support building highly available solutions on Windows or Linux hosts.

The capabilities of both platforms are similar, but the resources that provide those capabilities are often organized differently. Azure and AWS built their capabilities independently over time, so the platforms have important implementation and design differences. For example, AWS relies heavily on its accounts to serve as a logical boundary for tasks like applying permissions or tracking spend. Azure uses subscriptions, which are similar to AWS accounts. Azure also uses resource groups to logically group and manage resources at a more granular level.

The services that each platform provide don't always clearly correspond. Sometimes, only one of the platforms provides a particular service. 

## Primary topics

Read the following articles to learn about Azure services and how they map to the services that you're already familiar with in AWS. The following articles go into more detail about how Azure works in these specific areas:

- [Accounts and subscriptions on Azure and AWS](./accounts.md)
- [Compute services on Azure and AWS](./compute.md)
- [Data and AI](./data-ai.md)
- [Relational database technologies on Azure and AWS](./databases.md)
- [Messaging services on Azure and AWS](./messaging.md)
- [Networking on Azure and AWS](./networking.md)
- [Regions and zones on Azure and AWS](./regions-zones.md)
- [Resource management on Azure and AWS](./resources.md)
- [Multicloud identity with Azure and AWS](./security-identity.md)
- [Storage on Azure and AWS](./storage.md)

## Other services

The preceding list doesn't include all services. The following tables describe some of the services that aren't included. They map each AWS service to its corresponding Azure service and provide a brief description of the service.

### Marketplace

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [AWS Marketplace](https://aws.amazon.com/marketplace) | [Azure Marketplace](https://azure.microsoft.com/marketplace) | These services present easy-to-deploy and automatically configured partner applications, including single virtual machine (VM) or multiple VM solutions. You can purchase software as a service (SaaS) products from either marketplace. Many of these offerings are eligible to count toward your Azure consumption commitment. To understand which offerings count toward your commitment, see [Azure consumption commitment benefit](/marketplace/azure-consumption-commitment-benefit#determine-which-offers-are-eligible-for-azure-consumption-commitments-maccctc). |

### Time series databases and analytics

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [Amazon Timestream](https://aws.amazon.com/timestream) | [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer) | Azure Data Explorer is a fully managed, low latency, and distributed big data analytics platform. It runs complex queries across petabytes of data and is optimized for log and time series data.|

### DevOps and application monitoring

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [Amazon CloudWatch](https://aws.amazon.com/cloudwatch) and [AWS X-Ray](https://aws.amazon.com/xray/) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Azure Monitor is a comprehensive solution that you can use to collect, analyze, and act on telemetry from your cloud and on-premises environments. Use [Application Insights](/azure/azure-monitor/app/app-insights-overview), a feature of Azure Monitor, to instrument your code for more in-depth application performance monitoring. In AWS, you typically use both X-Ray and CloudWatch. |
| [AWS CodeDeploy](https://aws.amazon.com/codedeploy) <br/><br/>[AWS CodeCommit (deprecated)](https://aws.amazon.com/codecommit/) <br/><br/>[AWS CodePipeline](https://aws.amazon.com/codepipeline) <br/><br/> [AWS CodeConnections](https://docs.aws.amazon.com/dtconsole/latest/userguide/welcome-connections.html) <br/><br/>[AWS CodeBuild](https://aws.amazon.com/codebuild)  | [Azure DevOps](https://azure.microsoft.com/services/devops/)<br/><br/> [GitHub](https://github.com) <br/><br/> [GitHub Actions](https://github.com/features/actions) | Azure DevOps is a single solution that focuses on collaboration, continuous integration and continuous delivery (CI/CD), code testing, code artifacts, security testing, and code management. <br/><br/> GitHub is a cloud-based platform that you can use to showcase, collaborate on, and manage code. <br/><br/> Use GitHub Actions to automate software development workflows. <br/><br/> AWS code products support many of these functions. AWS no longer provides a code repository to new customers, but it does allow integration with partner repositories via CodeConnections.|
| [AWS CLI](https://aws.amazon.com/cli) <br/><br/>[AWS Tools for PowerShell](https://aws.amazon.com/powershell/) <br/><br/>[AWS SDKs](https://aws.amazon.com/developer/tools/)| [Azure CLI](/cli/azure/install-azure-cli) <br/><br/>[Azure PowerShell](/powershell/azure/overview) <br/><br/>[Azure SDKs](https://azure.github.io/azure-sdk/) | These services are built on top of the native REST API across all cloud services. Various programming language-specific wrappers provide easier ways to create solutions. |
| [AWS CloudShell](https://aws.amazon.com/cloudshell) | [Azure Cloud Shell](/azure/cloud-shell/overview) | Azure Cloud Shell is an interactive, authenticated, browser-accessible shell that you can use to manage Azure resources. It gives you the flexibility to choose the shell experience, either Bash or PowerShell, that best suits the way you work. |
| [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/) | [Azure Automation](https://azure.microsoft.com/services/automation) | Automation configures and operates applications of all shapes and sizes. It provides templates to create and manage a collection of resources. |
| [AWS CloudFormation](https://aws.amazon.com/cloudformation) <br/><br/>[AWS Cloud Development Kit](https://aws.amazon.com/cdk) | [Azure Resource Manager](https://azure.microsoft.com/features/resource-manager) <br/><br/>[Bicep](/azure/azure-resource-manager/bicep/overview) <br/><br/>[VM extensions](/azure/virtual-machines/extensions/features-windows) <br/><br/>[Automation](https://azure.microsoft.com/services/automation)  <br/><br/> [Azure Developer CLI](/azure/developer/azure-developer-cli/) | These services provide ways for developers and cloud admins to build and deploy repeatable cloud environments by using declarative syntax or common programming languages to define infrastructure as code. |

### Internet of Things (IoT)

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [AWS IoT Core](https://aws.amazon.com/iot-core) | [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) | This service provides a cloud gateway for managing bidirectional communication more securely and at scale with billions of IoT devices. |
| [AWS IoT Greengrass](https://aws.amazon.com/greengrass) | [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge) | Use this service to deploy cloud intelligence directly onto IoT devices and cater to on-premises scenarios. |
| [Amazon Data Firehose](https://aws.amazon.com/firehose/) and [Kinesis Data Streams](https://aws.amazon.com/kinesis/data-streams) | [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) <br/><br/>[Azure Stream Analytics](https://azure.microsoft.com/products/stream-analytics) | These services facilitate the mass ingestion of events or messages, typically from devices and sensors. The data can then be processed in real-time microbatches or be written to storage for further analysis. Both Kinesis Data Streams and Stream Analytics have real-time data processing capabilities.|
| [AWS IoT TwinMaker](https://aws.amazon.com/iot-twinmaker) | [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins) | Use these services to create digital representations of real-world places, things, business processes, and people. Gain insights, drive the creation of better products and new customer experiences, and optimize operations and costs. |
| [AWS IoT Device Management](https://aws.amazon.com/iot-device-management/)<br/><br/>[AWS IoT FleetWise](https://aws.amazon.com/iot-fleetwise/) | [Azure IoT Central](https://azure.microsoft.com/products/iot-central/) | Use these services to connect and manage IoT devices at scale. Use Azure IoT Central for general use cases and vehicle-based use cases. AWS provides IoT FleetWise specifically for vehicles.  |
| [AWS IoT ExpressLink](https://aws.amazon.com/iot-expresslink/) | [Azure Sphere](/azure-sphere/product-overview/what-is-azure-sphere) | These services provide device modules and software that you can use to build custom internet-connected devices. |

### Management and governance

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [AWS Organizations](https://aws.amazon.com/organizations) | [Azure management groups](/azure/governance/management-groups)| Azure management groups help you organize your resources and subscriptions.|
| [AWS Well-Architected Tool](https://docs.aws.amazon.com/wellarchitected/latest/userguide/intro.html)| [Azure Well-Architected Review](/assessments/?mode=pre-assessment)| Examine your workload through the lenses of reliability, cost management, operational excellence, security, and performance efficiency. |
| [AWS Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor) | [Azure Advisor](https://azure.microsoft.com/services/advisor) | Advisor provides analysis of cloud resource configuration and security to help subscribers use best practices and optimum configurations. |
| [AWS Billing and Cost Management](https://docs.aws.amazon.com/account-billing/index.html) | [Microsoft Cost Management](/azure/cost-management-billing) | Cost Management helps you understand your Azure invoice or bill. It also helps you manage your billing account and subscriptions, monitor and control Azure spending, and optimize resource use. |
| [Cost and Usage Reports](https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html) | [Cost details APIs](/azure/cost-management-billing/manage/consumption-api-overview#cost-details-apis) | These services help you generate, monitor, forecast, and share billing data for resource usage by time, organization, or product resources. |
| [AWS Management Console](https://aws.amazon.com/console) | [Azure portal](https://azure.microsoft.com/features/azure-portal) | Azure portal is a unified management console that simplifies building, deploying, and operating your cloud resources. |
| [AWS Application Discovery Service](https://aws.amazon.com/application-discovery) | [Azure Migrate and Modernize](https://azure.microsoft.com/services/azure-migrate) | Azure Migrate and Modernize assesses on-premises workloads for migration to Azure, performs performance-based sizing, and provides cost estimates. |
| [AWS Systems Manager](https://aws.amazon.com/systems-manager) | [Azure Monitor](https://azure.microsoft.com/services/monitor) | Azure Monitor is a comprehensive solution that you can use to collect, analyze, and act on telemetry from your cloud and on-premises environments. |
| [AWS Health Dashboard](https://aws.amazon.com/premiumsupport/technology/personal-health-dashboard) | [Azure Resource Health](/azure/resource-health/resource-health-overview) | See detailed information about the health of resources. Get recommendations for how to maintain resource health. |
| [AWS CloudTrail](https://aws.amazon.com/cloudtrail) | [Activity log](/azure/azure-monitor/essentials/activity-log) | The activity log is a platform log in Azure that provides insight into subscription-level events, like when a resource is modified or when a VM is started. |
| [AWS Config](https://aws.amazon.com/config) | [Azure Policy](/azure/governance/policy/overview)<br/><br/>[Application change analysis](/azure/azure-monitor/app/change-analysis) | Azure Policy helps you implement governance for resource consistency, regulatory compliance, security, cost, and management. Use Azure Policy for bulk remediation for existing resources and automatic remediation for new resources. You typically use AWS Config to monitor for configuration changes or to identify and remediate noncompliant resources.  |
| [AWS Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer) | [Cost Management](https://azure.microsoft.com/services/cost-management) | Perform cost analysis and optimize cloud costs. |
| [AWS Control Tower](https://aws.amazon.com/controltower) | [Azure Lighthouse](/azure/lighthouse/overview) | Set up and govern multiple-account or multiple-subscription environments. |
| [AWS Resource Groups and Tag Editor](https://docs.aws.amazon.com/ARG) | [Resource Manager resource groups](/azure/azure-resource-manager/management/overview) and [tags](/azure/azure-resource-manager/management/tag-resources) | A resource group is a container that holds related resources for an Azure solution. Apply tags to your Azure resources to logically organize them by categories. |
| [AWS AppConfig](https://aws.amazon.com/systems-manager/features/appconfig) | [Azure App Configuration](/azure/azure-app-configuration) | App Configuration is a managed service that helps developers more securely and easily centralize their application and feature settings. |
| [AWS Service Catalog](https://aws.amazon.com/servicecatalog) | [Azure Managed Applications](/azure/azure-resource-manager/managed-applications/overview) | Azure Managed Applications provides cloud solutions that customers can easily deploy and operate. |

### Authentication and authorization

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [AWS IAM Identity Center](https://aws.amazon.com/iam/identity-center/)<br/><br/>[AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam) | [Microsoft Entra ID](https://www.microsoft.com/security/business/identity-access/microsoft-entra-id) | Use these services to more securely control access to services and resources and improve data security and protection. Create and manage users and groups, and use permissions to allow and deny access to resources. |
| [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam) | [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) | Azure RBAC helps you manage who can access Azure resources, which resources they can access, and what they can do with those resources. |
| [AWS Organizations](https://aws.amazon.com/organizations) | [Azure management groups](https://azure.microsoft.com/get-started/azure-portal/management-groups/) | These services provide security policy and role management when you work with multiple accounts. |
| [Multi-Factor Authentication (MFA) for IAM](https://aws.amazon.com/iam/features/mfa) | [Microsoft Entra ID](https://www.microsoft.com/en-us/security/business/identity-access/microsoft-entra-id) | Help safeguard access to data and applications while providing a simple sign-in process to users. |
| [AWS Directory Service](https://aws.amazon.com/directoryservice) | [Microsoft Entra Domain Services](/entra/identity/domain-services/overview) | Domain Services provides managed domain services, such as domain join, group policy, LDAP, and Kerberos/NTLM authentication, which are fully compatible with Windows Server Active Directory. |
| [Amazon Cognito](https://aws.amazon.com/cognito) | [Microsoft identity platform](/entra/identity-platform/v2-overview) and [Microsoft Entra External ID](/entra/external-id/external-identities-overview) | External ID is a highly available, global identity management service for consumer-facing applications in which you need to support "bring your own identity" scenarios, such as identities from Google or Meta. |

### Encryption

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [Server-side encryption with AWS Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html) | [Azure Storage service-side encryption](/azure/storage/storage-service-encryption) | Service-side encryption helps you protect your data and meet your organization's security and compliance commitments. |
| [AWS Key Management Service (KMS)](https://aws.amazon.com/kms), [AWS CloudHSM](https://aws.amazon.com/cloudhsm) | [Azure Key Vault](https://azure.microsoft.com/services/key-vault) <br/><br> [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview) | Improve security and work with other services by providing a way to manage, create, and control encryption keys that hardware security modules (HSMs) store. Key Vault provides a shared HSM or a dedicated HSM. On AWS, KMS uses a shared HSM. CloudHSM is a dedicated HSM. Both platforms provide Federal Information Processing Standards-validated options. |
| [AWS Nitro Enclaves](https://aws.amazon.com/ec2/nitro/nitro-enclaves/) | [Azure confidential computing](https://azure.microsoft.com/solutions/confidential-compute/) | Azure confidential computing provides platforms that have more controls to help protect data while it's being processed. It can also remotely verify platform trustworthiness. Azure also provides Azure SQL Always Encrypted and confidential VMs for Azure Virtual Desktop, Azure Data Explorer, and Azure Databricks. |

### Firewalls

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [AWS WAF](https://aws.amazon.com/waf) | [Azure web application firewall](https://azure.microsoft.com/products/web-application-firewall) | These firewalls help protect web applications from common web exploits. |
| [AWS Network Firewall](https://aws.amazon.com/network-firewall)| [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) | These services improve inbound protection and outbound network-level protection across all ports and protocols. Both solutions support the ability to inspect and apply rules for encrypted web traffic. |

### Security

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [Amazon Inspector](https://aws.amazon.com/inspector) | [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud/) | Defender for Cloud is an automated security assessment service that improves the security and compliance of applications. It automatically assesses applications for vulnerabilities or deviations from best practices. |
| [AWS Certificate Manager](https://aws.amazon.com/certificate-manager) | [Key Vault certificates](/azure/key-vault/certificates/about-certificates) <br/><br> [Microsoft Cloud PKI](https://www.microsoft.com/security/business/endpoint-management/microsoft-cloud-PKI)| Use these services to create and manage certificates and their keys. |
| [Amazon GuardDuty](https://aws.amazon.com/guardduty/) | [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel/) | Detect and investigate advanced attacks on-premises and in the cloud. |
| [AWS Artifact](https://aws.amazon.com/artifact) | [Microsoft Service Trust Portal](https://servicetrust.microsoft.com/) | Use these services to access to audit reports, compliance guides, and trust documents from across cloud services. |
| [AWS Shield](https://aws.amazon.com/shield) | [Azure DDoS Protection](/azure/security/fundamentals/ddos-best-practices) | These services provide cloud services that are better protected from distributed denial of services attacks. |

### Web applications

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk) | [Azure App Service](https://azure.microsoft.com/services/app-service) | App Service is a managed hosting platform that provides easy-to-use services for deploying and scaling web applications and services. |
| [Amazon API Gateway](https://aws.amazon.com/api-gateway) | [Azure API Management](https://azure.microsoft.com/services/api-management) | These services provide a turnkey solution for publishing APIs to internal and external customers. |
| [Amazon CloudFront](https://aws.amazon.com/cloudfront) | [Azure Front Door](https://azure.microsoft.com/services/frontdoor) | Azure Front Door is a modern cloud content delivery network service that delivers high performance, scalability, and more secure user experiences for your content and applications. |
| [AWS Global Accelerator](https://aws.amazon.com/global-accelerator) | [Azure Front Door](https://azure.microsoft.com/services/frontdoor) | Easily join your distributed microservices architectures into a single global application that uses HTTP load balancing and path-based routing rules. Automate turning up new regions and scale out by using API-driven global actions and independent fault-tolerance to your back-end microservices in Azure or anywhere. |
| [AWS Global Accelerator](https://aws.amazon.com/global-accelerator) | [Cross-regional load balancer](/azure/load-balancer/cross-region-overview) | Distribute and load balance traffic across multiple Azure regions via a single, static, global anycast public IP address. |
| [Amazon Lightsail](https://aws.amazon.com/lightsail) and [AWS Amplify](https://aws.amazon.com/amplify) | [App Service](https://azure.microsoft.com/services/app-service) | Build, deploy, and scale web apps on a fully managed platform. |
| [AWS App Runner](https://aws.amazon.com/apprunner) | [Web App for Containers](https://azure.microsoft.com/services/app-service/containers) | Easily deploy and run containerized web apps on Windows and Linux. |

### End-user computing

| AWS service | Azure service | Description |
| :---------- | :------------ | :---------- |
| [Amazon WorkSpaces Family](https://aws.amazon.com/workspaces), [Amazon AppStream 2.0](https://aws.amazon.com/appstream2) | [Azure Virtual Desktop](/azure/virtual-desktop) | Manage virtual desktops and applications to give users access to the corporate network and data anytime, anywhere, and on supported devices. WorkSpaces Family supports Windows and Linux virtual desktops. Azure Virtual Desktop supports single and multiple-session Windows virtual desktops.|

## Miscellaneous

| Area | AWS service | Azure service | Description |
|------|-------------|---------------|-------------|
| Back-end process logic | [AWS Step Functions](https://aws.amazon.com/step-functions) | [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) | Use these cloud technologies to build distributed applications by using out-of-the-box connectors to reduce integration challenges. Connect apps, data, and devices on-premises or in the cloud. |
| Enterprise application services | [Amazon WorkMail](https://aws.amazon.com/workmail), [Amazon WorkDocs (deprecated)](https://aws.amazon.com/workdocs), [Amazon Chime](https://aws.amazon.com/chime) | [Microsoft 365](https://www.microsoft.com/microsoft-365) | These fully integrated cloud services provide communications, email, and document management in the cloud. They're available on various devices. |
| Gaming | [Amazon GameLift](https://aws.amazon.com/gamelift) | [Microsoft Azure PlayFab](https://playfab.com) | These managed services host dedicated game servers. |
| Workflow | [AWS Step Functions](https://aws.amazon.com/step-functions) | [Logic Apps](https://azure.microsoft.com/services/logic-apps) | Use this serverless technology to connect apps, data, and devices anywhere, including on-premises or in the cloud, for large ecosystems of SaaS and cloud-based connectors. |
| Hybrid | [AWS Outposts Family](https://aws.amazon.com/outposts) | [Azure Arc](/azure/azure-arc/overview) <br/><br/>[Azure Local](/azure/azure-local/overview) | Use AWS Outposts and Azure Local to extend your cloud datacenter to the edge by using platforms that combine hardware and software. Use Azure Arc to extend Azure management capabilities to on-premises or multicloud environments. |
| Media | [Amazon Elastic Transcoder](https://aws.amazon.com/elastictranscoder)<br/><br> [AWS Elemental MediaConvert](https://aws.amazon.com/mediaconvert) | None | Azure doesn't provide media services, but we recommend several [partner solutions](/previous-versions/azure/media-services/latest/azure-media-services-retirement). |
| Satellite | [AWS Ground Station](https://aws.amazon.com/ground-station) | None | Microsoft doesn't provide fully managed ground stations. For global environmental data provided by Microsoft, see [Microsoft Planetary Computer](https://planetarycomputer.microsoft.com/). Or you can use [data provided by NASA](https://www.earthdata.nasa.gov/). |
| Quantum computing | [Amazon Braket](https://aws.amazon.com/braket) | [Azure Quantum](/azure/quantum/overview-azure-quantum) | Developers, researchers, and businesses can use these managed quantum computing services to run quantum computing programs.|
| Data sharing | [AWS Data Exchange](https://aws.amazon.com/data-exchange/) | [Azure Data Share](https://azure.microsoft.com/products/data-share/) | Securely share data with other organizations.|
| Contact center | [Amazon Connect](https://aws.amazon.com/connect/) | [Dynamics 365 Contact Center](/dynamics365/contact-center/implement/overview-contact-center) | Connect with customers by using these AI-powered cloud contact center capabilities.|

## Next step

> [!div class="nextstepaction"]
> [Azure and AWS accounts and subscriptions](./accounts.md)
