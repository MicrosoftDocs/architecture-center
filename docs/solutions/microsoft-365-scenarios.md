---
title: Azure and Microsoft 365 scenarios
description: Learn about architectures and solutions that use Azure together with Microsoft 365. 
author: EdPrice-MSFT
ms.author: edprice
ms.date: 02/23/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - m365
  - office-excel
  - office-exchange-server
  - office-teams
  - office-word
categories:
  - integration
  - security
  - identity
  - web
  - devops
  - analytics
  - storage
  - hybrid
  - management-and-governance
ms.custom: fcp
---

# Azure and Microsoft 365 scenarios

Microsoft 365 is a suite of apps that help you stay connected and get things done. It includes these tools: 

- [Word](https://www.microsoft.com/microsoft-365/word). Create documents and improve your writing with built-in intelligent features.
- [Excel](https://www.microsoft.com/microsoft-365/excel). Simplify complex data and create easy-to-read spreadsheets.
- [PowerPoint](https://www.microsoft.com/microsoft-365/powerpoint). Easily create polished presentations.
- [Microsoft Teams](https://www.microsoft.com/microsoft-teams/group-chat-software). Bring everyone together in one place to meet, chat, call, and collaborate.
- [Outlook](https://www.microsoft.com/microsoft-365/outlook/email-and-calendar-software-microsoft-outlook). Manage your email, calendar, tasks, and contacts together in one place.
- [OneDrive](https://www.microsoft.com/microsoft-365/onedrive/online-cloud-storage). Save, access, edit, and share files and photos.
- [Exchange](https://www.microsoft.com/microsoft-365/exchange/email). Work smarter with business-class email and calendaring.
- [SharePoint](https://www.microsoft.com/microsoft-365/sharepoint/collaboration). Share and manage content, knowledge, and applications to enhance teamwork, make information easy to find, and collaborate across the organization.
- [Access](https://www.microsoft.com/microsoft-365/access). Create your own database apps easily in formats that serve your business best.
- [Publisher](https://www.microsoft.com/microsoft-365/publisher). Create polished, professional layouts and publish content in a way that suits your audience.
- [Intune](https://www.microsoft.com/security/business/microsoft-endpoint-manager). Secure, deploy, and manage all users, apps, and devices without disrupting existing processes.

this video... 

<br>

> [!VIDEO https://www.youtube.com/embed/d6p_aKM1M3o]

## Solutions across Azure and Microsoft 365

The following articles provide detailed analysis of solutions that feature integration between Azure and Microsoft 365.

### Microsoft 365 (general)

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure AD security for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security)|Learn how Azure Active Directory can help secure and protect Amazon Web Services (AWS) identity management and account access. | Identity|
|[Defender for Cloud Apps and Microsoft Sentinel for AWS](/azure/architecture/reference-architectures/aws/aws-azure-security-solutions)|Learn how Microsoft Defender for Cloud Apps and Microsoft Sentinel can help secure and protect Amazon Web Services (AWS) account access and environments.| Security|
|[Manage Microsoft 365 tenant configuration with Azure DevOps](/azure/architecture/example-scenario/devops/manage-microsoft-365-tenant-configuration-microsoft365dsc-devops)|Learn how to manage Microsoft 365 tenant configuration by using Microsoft365DSC and Azure DevOps.| Web|
|[Power Automate deployment at scale](/azure/architecture/example-scenario/power-automate/power-automate)|Learn how to use a hub-and-spoke architectural model to deploy Power Automate parent and child flows.| Integration|
|[Virtual health on Microsoft Cloud for Healthcare](/azure/architecture/example-scenario/mch-health/virtual-health-mch) |Learn how to develop a virtual health solution by using Microsoft Cloud for Healthcare.|Web|

### Excel

|Architecture|Summary|Technology focus|
|--|--|--|
|[Interactive price analytics](/azure/architecture/solution-ideas/articles/interactive-price-analytics) |Use transaction history data to develop a pricing strategy with a machine learning model accounting for confounding and data sparsity.|Analytics|

### Exchange Online

|Architecture|Summary|Technology focus|
|--|--|--|
|[Enhanced-security hybrid messaging—client access](/azure/architecture/example-scenario/hybrid/secure-hybrid-messaging-client) |This article describes an architecture to enhance your security in a client access scenario by using Azure AD Multi-Factor Authentication.|Hybrid|
|[Enhanced-security hybrid messaging—mobile access](/azure/architecture/example-scenario/hybrid/secure-hybrid-messaging-mobile)|This article describes an architecture to enhance your security in a mobile access scenario by using Azure AD Multi-Factor Authentication. |Hybrid|
|[Enhanced-security hybrid messaging—web access](/azure/architecture/example-scenario/hybrid/secure-hybrid-messaging-web) |This article describes an architecture to help you enhance your security in a web access scenario by using Azure AD Multi-Factor Authentication.|Hybrid|

### SharePoint

|Architecture|Summary|Technology focus|
|--|--|--|
|[Enterprise-scale disaster recovery](/azure/architecture/solution-ideas/articles/disaster-recovery-enterprise-scale-dr)|This large-enterprise architecture for SharePoint, Dynamics CRM, and Linux web servers runs on an on-premises datacenter and fails over to Azure infrastructure.| Management/Governance|
|[Highly available SharePoint farm](/azure/architecture/solution-ideas/articles/highly-available-sharepoint-farm)|Deploy a highly available SharePoint farm for intranet capabilities that uses Azure Active Directory, a SQL always on instance, and SharePoint resources.|Web|
|[Hybrid SharePoint farm with Microsoft 365](/azure/architecture/solution-ideas/articles/sharepoint-farm-microsoft-365)| Deliver highly available intranet capability and share hybrid workloads with Microsoft 365 by using SharePoint servers, Azure Active Directory, and SQL Server.|Web|
|[SharePoint farm for development testing](/azure/architecture/solution-ideas/articles/sharepoint-farm-devtest)|Deploy a SharePoint farm for development testing. Use Azure Active Directory, SQL Server, and SharePoint resources for this agile development architecture.| DevOps|


### Teams

|Architecture|Summary|Technology focus|
|--|--|--|
|[Governance of Teams guest users](/azure/architecture/example-scenario/governance/governance-teams-guest-users)| Learn how to use Microsoft Teams and Azure AD entitlement management to collaborate with other organizations, while maintaining control over resource use.|Identity|
|[Secure your Microsoft Teams channel bot and web app behind a firewall](/azure/architecture/example-scenario/teams/securing-bot-teams-channel) |Secure the connection to a Microsoft Teams channel bot’s web app, using Azure Private Link and Azure Private Endpoint.|Security|
|[Teacher-provisioned virtual labs in Azure](/azure/architecture/example-scenario/devops/teacher-provisioned-virtual-labs-azure)|Learn how you can use Azure Lab Services to set up identical VMs from templates, for use in training, customer demos, and software development.| DevOps|


## Related resources

- [Browse our Microsoft 365 architectures](/azure/architecture/browse/?products=m365)