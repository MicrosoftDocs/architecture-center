---
title: Azure and Microsoft 365 scenarios
description: Read this article to learn about architectures and solutions that use Azure together with Microsoft 365. 
author: martinekuan
ms.author: pnp
ms.date: 07/28/2022
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
- [Teams](https://www.microsoft.com/microsoft-teams/group-chat-software). Bring everyone together in one place to meet, chat, call, and collaborate.
- [Outlook](https://www.microsoft.com/microsoft-365/outlook/email-and-calendar-software-microsoft-outlook). Manage your email, calendar, tasks, and contacts in one place.
- [OneDrive](https://www.microsoft.com/microsoft-365/onedrive/online-cloud-storage). Save, access, edit, and share files.
- [Exchange](https://www.microsoft.com/microsoft-365/exchange/email). Work smarter with business-class email and calendaring.
- [SharePoint](https://www.microsoft.com/microsoft-365/sharepoint/collaboration). Share and manage content, knowledge, and applications to enhance teamwork, make information easy to find, and collaborate across your organization.
- [Access](https://www.microsoft.com/microsoft-365/access). Create database apps easily in formats that best serve your business.
- [Publisher](https://www.microsoft.com/microsoft-365/publisher). Create professional layouts and publish content in a way that suits your audience.
- [Intune](https://www.microsoft.com/security/business/microsoft-endpoint-manager). Secure, deploy, and manage all users, apps, and devices without disrupting your processes.

This article provides a summary of architectures and solutions that use Azure together with Microsoft 365.

Watch this short video to learn how Microsoft 365 apps and services can help your organization work, learn, connect, and create: 

<br>

> [!VIDEO https://www.youtube.com/embed/d6p_aKM1M3o]

## Solutions across Azure and Microsoft 365

The following articles provide detailed analysis of solutions that feature integration between Azure and Microsoft 365.

### Microsoft 365 (general)

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure AD security for AWS](../reference-architectures/aws/aws-azure-ad-security.yml)|Learn how Azure Active Directory (Azure AD) can help secure and protect Amazon Web Services (AWS) identity management and account access. If you already use Azure AD for Microsoft 365, this solution is easy to deploy.| Identity|
|[Defender for Cloud Apps and Microsoft Sentinel for AWS](../guide/aws/aws-azure-security-solutions.yml)|Learn how Microsoft Defender for Cloud Apps and Microsoft Sentinel can help secure and protect AWS account access and environments. If you already use Azure AD for Microsoft 365, this solution is easy to deploy.| Security|
|[Manage Microsoft 365 tenant configuration with Azure DevOps](../example-scenario/devops/manage-microsoft-365-tenant-configuration-microsoft365dsc-devops.yml)|Learn how to manage Microsoft 365 tenant configuration by using Microsoft365DSC and Azure DevOps.| Web|
|[Power Automate deployment at scale](../example-scenario/power-automate/power-automate.yml)|Learn how to use a hub-and-spoke architectural model to deploy Power Automate parent and child flows. This architecture is for Power Automate workflows that replace SharePoint 2010 workflows, and for new SharePoint Online sites.| Integration|
|[Virtual health on Microsoft Cloud for Healthcare](../example-scenario/mch-health/virtual-health-mch.yml) |Learn how to develop a virtual health solution by using Microsoft Cloud for Healthcare. Microsoft Cloud for Healthcare brings together capabilities from Microsoft 365, Azure, and other technologies to help healthcare organizations create fast, efficient, and highly secure healthcare solutions.|Web|

### Excel

|Architecture|Summary|Technology focus|
|--|--|--|
|[Interactive price analytics](../solution-ideas/articles/interactive-price-analytics.yml) |Use transaction history data to develop a pricing strategy that shows how the demand for your products responds to your prices.|Analytics|

### Exchange Online

|Architecture|Summary|Technology focus|
|--|--|--|
|[Enhanced-security hybrid messaging—client access](../example-scenario/hybrid/secure-hybrid-messaging-client.yml) |Use Azure AD Multi-Factor Authentication to enhance your security in a client access scenario that uses Exchange.|Hybrid|
|[Enhanced-security hybrid messaging—mobile access](../example-scenario/hybrid/secure-hybrid-messaging-mobile.yml)|Use Azure AD Multi-Factor Authentication to enhance your security in a mobile access scenario that uses Exchange.|Hybrid|
|[Enhanced-security hybrid messaging—web access](../example-scenario/hybrid/secure-hybrid-messaging-web.yml) |Use Azure AD Multi-Factor Authentication to enhance your security in a web access scenario that uses Exchange.|Hybrid|

### SharePoint

|Architecture|Summary|Technology focus|
|--|--|--|
|[Enterprise-scale disaster recovery](../solution-ideas/articles/disaster-recovery-enterprise-scale-dr.yml)|Learn about a large-enterprise architecture for SharePoint, Dynamics CRM, and Linux web servers that runs on an on-premises datacenter and fails over to Azure infrastructure.| Management/Governance|
|[Highly available SharePoint farm](../solution-ideas/articles/highly-available-sharepoint-farm.yml)|Deploy a highly available SharePoint farm that uses Azure AD, a SQL Server Always On instance, and SharePoint resources.|Web|
|[Hybrid SharePoint farm with Microsoft 365](../solution-ideas/articles/sharepoint-farm-microsoft-365.yml)| Deliver highly available intranet capability and share hybrid workloads with Microsoft 365 by using SharePoint servers, Azure AD, and SQL Server.|Web|
|[SharePoint farm for development testing](../solution-ideas/articles/sharepoint-farm-devtest.yml)|Deploy a SharePoint farm for development testing. Use Azure AD, SQL Server, and SharePoint resources for this agile development architecture.| DevOps|

### Teams

|Architecture|Summary|Technology focus|
|--|--|--|
|[Governance of Teams guest users](../example-scenario/governance/governance-teams-guest-users.yml)| Learn how to use Teams and Azure AD entitlement management to collaborate with other organizations while maintaining control over resource use.|Identity|
|[Provide security for your Teams channel bot and web app behind a firewall](../example-scenario/teams/securing-bot-teams-channel.yml) |Provide security for the connection to a Teams channel bot's web app by using Azure Private Link and a private endpoint.|Security|
|[Teacher-provisioned virtual labs in Azure](../example-scenario/devops/teacher-provisioned-virtual-labs-azure.yml)|Learn how you can use Azure Lab Services to set up identical VMs from templates for use in training, customer demos, and software development. Students and stakeholders can access the VMs via Teams integration.| DevOps|


## Related resources

- [Browse our Microsoft 365 architectures](/azure/architecture/browse/?products=m365)
