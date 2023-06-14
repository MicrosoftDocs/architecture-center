---
title: Azure and Dynamics 365 scenarios
description: Learn about architectures and solutions that use Azure together with Dynamics 365. 
author: martinekuan
ms.author: architectures
ms.date: 07/28/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - dynamics-365
  - dynamics-customer-engagement
  - dynamics-cust-insights
  - dynamics-sales
  - dynamics-cust-svc-insights
categories:
  - ai-machine-learning
  - analytics
  - web
  - databases
  - iot
  - storage
  - management-and-governance
  - identity 
  - migration
ms.custom: fcp
---

# Azure and Dynamics 365 scenarios

[Dynamics 365](https://dynamics.microsoft.com) is a suite of modern commerce solutions that work together to connect your entire business. Use any or all of these Dynamics 365 applications, according to your needs:

- **Customer data platform**
   - [Customer data platform](https://dynamics.microsoft.com/customer-data-platform). Increase your knowledge of your customers with a real-time customer data platform.
   - [Customer Insights](https://dynamics.microsoft.com/ai/customer-insights). Use AI and analytics to improve your customers' experiences.
   - [Customer Voice](https://dynamics.microsoft.com/customer-voice/overview). Collect, analyze, and track real-time feedback in a scalable feedback management solution.
- **Sales**
   - [Sales](https://dynamics.microsoft.com/sales/overview). Connect sales teams to customers and implement individualized selling.
   - [Microsoft Relationship Sales](https://dynamics.microsoft.com/sales/relationship-sales). Transform relationship selling by using Dynamics 365 Sales and LinkedIn Sales Navigator.
- **Service**
   - [Customer Service](https://dynamics.microsoft.com/customer-service/overview). Provide self-service support, tailor customer engagements, elevate agent effectiveness, and more.
   - [Field Service](https://dynamics.microsoft.com/field-service/overview). Move from reactive to proactive to predictive service by using data insights.
   - [Remote Assist](https://dynamics.microsoft.com/mixed-reality/remote-assist). 
Solve problems in real time, bring critical information into view, and walk through a site without being on location.
- [**Marketing**](https://dynamics.microsoft.com/marketing/overview). Engage customers in real time, gain customers and earn loyalty, and personalize customer experiences by using AI.
- **Commerce**
   - [Commerce](https://dynamics.microsoft.com/commerce/overview). Deliver unified and personalized buying experiences for customers and partners.
   - [Connected Spaces](https://dynamics.microsoft.com/connected-spaces/overview). Generate actionable insights from your space by using pre-built AI-powered skills.
   - [Fraud Protection](https://dynamics.microsoft.com/ai/fraud-protection). Implement adaptive AI that continuously learns in order to protect you against payment fraud, bots, account takeover, and returns and discounts fraud.
- **Supply chain**
   - [Supply Chain Management](https://dynamics.microsoft.com/supply-chain-management/overview). Ensure business continuity by using agile distribution and manufacturing processes in the cloud and at the edge.
   - [Supply Chain Insights](https://dynamics.microsoft.com/supply-chain-insights). Make better supply chain decisions by using proactive risk mitigation via AI-powered insights.
   - [Guides](https://dynamics.microsoft.com/mixed-reality/guides). Create step-by-step holographic instructions.
   - [Intelligent Order Management](https://dynamics.microsoft.com/intelligent-order-management/overview). Meet your digital commerce needs and scale easily while supporting the latest fulfillment methods.
- **Small and medium business**
   - [Business Central](https://dynamics.microsoft.com/business-central/overview). Connect operations across your small or medium-sized business. 
   - [Customer Service](https://dynamics.microsoft.com/customer-service/professional). Streamline support by using a solution that simplifies processes and improves customer experiences.
- [**Human Resources**](https://dynamics.microsoft.com/human-resources/overview). Create a workplace where people and business thrive. 
- [**Finance**](https://dynamics.microsoft.com/finance/overview). Maximize financial visibility and profitability.
- [**Project Operations**](https://dynamics.microsoft.com/project-operations/overview). Connect your project-centric business, from prospects to payments to profits, in one application. 

 This article provides summaries of solutions and architectures that use Dynamics 365 together with Azure services.

Watch this short video to learn how Dynamics 365 can help you streamline business operations, enhance inventory management, optimize order fulfillment, and more:
<br><br>

> [!VIDEO https://www.youtube.com/embed/HgX-GDWgs_I]

## Solutions across Azure and Dynamics 365

### Dynamics 365 CRM and ERP (general)

|Architecture|Summary|Technology focus|
|--|--|--|
|[Architectural approaches for the deployment and configuration of multitenant solutions](../guide/multitenant/approaches/deployment-configuration.yml)|Learn about deploying and configuring a multitenant solution. Use Dynamics 365 to trigger an onboarding process when a sale is made to a new customer.| Multitenancy|
|[Azure IoT reference architecture](../reference-architectures/iot.yml)|Review a recommended architecture for IoT applications on Azure. IoT devices provide insights to Dynamics 365. | IoT|
|[Create smart places by using Azure Digital Twins](../example-scenario/iot/smart-places.yml)|Use Azure Digital Twins to create models of smart places from IoT device data. You can use this data to inform Dynamics 365 applications.| IoT|
|[Enterprise bot for employee productivity](../solution-ideas/articles/enterprise-productivity-chatbot.yml) |Use Azure Bot Service and Azure Cognitive Services to build enterprise bots for internal productivity. Use data from Microsoft 365 calendars to access customer information in Dynamics 365.|AI|
|[Enterprise-scale disaster recovery](../solution-ideas/articles/disaster-recovery-enterprise-scale-dr.yml) |Review a large-enterprise architecture for SharePoint, Dynamics CRM, and Linux web servers that runs on an on-premises datacenter and fails over to Azure infrastructure.|Management|
|[Eventual consistency between multiple Power Apps instances](/azure/architecture/guide/power-platform/eventual-consistency)|Handle dependent data in a resilient way in Power Apps. Includes information about replicating data between Dynamics 365 instances.|Web|
|[Migrate master data services to Azure with CluedIn and Azure Purview](../reference-architectures/data/migrate-master-data-services-with-cluedin.yml)|Use CluedIn and Azure Purview to migrate your master data services solution to Azure. Dynamics 365 users can natively use data from CluedIn without any extra setup or integration.| Databases|
|[Multitenancy and identity management](../multitenant-identity/index.yml) |Learn authentication, authorization, and identity management best practices for multitenant applications. In these architectures, Dynamics CRM tenants store user profiles in Azure AD. |Identity|
|[SAP on Azure architecture design](../reference-architectures/sap/sap-overview.yml) |Review a set of guiding tenets that you can use to help ensure the quality of SAP workloads that run on Azure. A recommended identity management system, Azure Active Directory, integrates with Dynamics CRM Online.|SAP|
|[Serverless computing solution for LOB apps](../solution-ideas/articles/onboarding-customers-with-a-cloud-native-serverless-architecture.yml)|Build and run customer onboarding applications without managing or maintaining infrastructure. Customer information is stored in Dynamics 365. |Serverless|

### Dynamics 365 Customer Engagement

|Architecture|Summary|Technology focus|
|--|--|--|
|[Clinical insights with Microsoft Cloud for Healthcare](../example-scenario/mch-health/medical-data-insights.yml)|Learn about an architecture that you can use to gather insights from clinical and medical data by using Microsoft Cloud for Healthcare. Dynamics 365 components include an application that stores a list of patients together with scores that indicate the urgency of their cases.| Web|
|[Virtual health on Microsoft Cloud for Healthcare](../example-scenario/mch-health/virtual-health-mch.yml) |Learn about an architecture that you can use to develop a virtual health solution by using Microsoft Cloud for Healthcare. One component of the solution is an application deployed via Dynamics 365 that presents an aggregated view of patient data in Teams.|Web|

### Dynamics 365 Customer Insights

|Architecture|Summary|Technology focus|
|--|--|--|
|[Customer 360 with Azure Synapse and Dynamics 365 Customer Insights](../example-scenario/analytics/synapse-customer-insights.yml)|Build an end-to-end Customer 360 solution by using Azure Synapse Analytics and Customer Insights.| Analytics|
|[Enhanced customer dimension with Dynamics 365 Customer Insights](../solution-ideas/articles/customer-insights-synapse.yml) |Use Customer Insights to create an enhanced customer dataset and make it available in Azure Data Lake for consumption by Azure Synapse Analytics.|Analytics|

### Dynamics 365 Sales

|Architecture|Summary|Technology focus|
|--|--|--|
|[Clinical insights with Microsoft Cloud for Healthcare](../example-scenario/mch-health/medical-data-insights.yml)|Learn about an architecture that you can use to gather insights from clinical and medical data by using Microsoft Cloud for Healthcare. Dynamics 365 components include an application that stores a list of patients together with scores that indicate the urgency of their cases.|Web|

### Service

|Architecture|Summary|Technology focus|
|--|--|--|
|[Scalable cloud applications and SRE](../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)| Build scalable cloud applications by using performance modeling and other principles and practices of site reliability engineering (SRE). Dynamics 365 is used for product catalog and customer service management.|Web|

### Small and medium business

|Architecture|Summary|Technology focus|
|--|--|--|
|[Modern data warehouse for small and medium business](../example-scenario/data/small-medium-data-warehouse.yml) |Use Azure Synapse Analytics, Azure SQL Database, and Data Lake Storage to modernize SMB legacy and on-premises data. These solutions integrate easily with Dynamics 365.|Analytics|

## Related resources

- [Browse all Dynamics 365 architectures](/azure/architecture/browse/?terms=dynamics%20365)