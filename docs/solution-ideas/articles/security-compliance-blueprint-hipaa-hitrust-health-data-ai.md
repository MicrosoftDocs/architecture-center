---
title: HIPAA and HITRUST compliant health data AI
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: Manage HIPAA and HITRUST compliant health data and medical records with the highest level of built-in security.
ms.custom: acom-architecture, data, medical records management, medical records storage, medical data solutions, healthcare data storage, cloud storage in healthcare, medical data storage, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/security-compliance-blueprint-hipaa-hitrust-health-data-ai/'
ms.service: architecture-center
ms.category:
  - storage
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/security-compliance-blueprint-hipaa-hitrust-health-data-ai.png
---

# HIPAA and HITRUST compliant health data AI

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

## Architecture

![Architecture Diagram](../media/security-compliance-blueprint-hipaa-hitrust-health-data-ai.png)
*Download an [SVG](../media/security-compliance-blueprint-hipaa-hitrust-health-data-ai.svg) of this architecture.*

## Data Flow

1. Securely ingest bulk patient data into Azure Blob storage.
1. Event Grid publishes patient data to Azure Functions for processing, and securely stores patient data in SQL Database.
1. Analyze patient data using Machine Learning, and create a Machine Learning-trained model.
1. Ingest new patient data in HL7/FHIR format and publish to Azure Functions for processing. Store in SQL Database.
1. Analyze newly ingested data using the trained Machine Learning model.
1. Interact with patient data using Power BI while preserving Role-Based Access Control (RBAC).

## Components

* [Azure Functions](https://azure.microsoft.com/services/functions): Process events with serverless code
* [Event Grid](https://azure.microsoft.com/services/event-grid): Get reliable event delivery at massive scale
* [Storage Accounts](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database): Managed, intelligent SQL in the cloud
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Bring AI to everyone with an end-to-end, scalable, trusted platform with experimentation and model management
* [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded): Embed fully interactive, stunning data visualizations in your applications
* [Security Center](https://azure.microsoft.com/services/security-center): Unify security management and enable advanced threat protection across hybrid cloud workloads
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory): Synchronize on-premises directories and enable single sign-on
* [Key Vault](https://azure.microsoft.com/services/key-vault): Safeguard and maintain control of keys and other secrets
* Application Insights: Detect, triage, and diagnose issues in your web apps and services
* [Azure Monitor](https://azure.microsoft.com/services/monitor): Full observability into your applications, infrastructure, and network
* [Operation Management Suite](https://www.microsoft.com/cloud-platform/operations-management-suite): A collection of management services that were designed in the cloud from the start
* [RBAC and built-in roles](/azure/role-based-access-control/built-in-roles): Role-based access control (RBAC) has several built-in role definitions that you can assign to users, groups, and service principals.

## Next steps

* [Azure Functions Documentation](/azure/azure-functions)
* [Azure Event Grid Documentation](/azure/event-grid)
* [Azure Storage Documentation](/azure/storage)
* [Azure SQL Database Documentation](/azure/sql-database)
* [Azure Machine Learning Documentation](/azure/machine-learning)
* [Power BI Embedded Documentation](/azure/power-bi-embedded)
* [Azure Security Center Documentation](/azure/security-center)
* [Get started with Azure AD](/azure/active-directory/get-started-azure-ad)
* [What is Azure Key Vault?](/azure/key-vault/key-vault-overview)
* [What is Application Insights?](/azure/application-insights/app-insights-overview)
* [Monitoring Azure applications and resources](/azure/monitoring-and-diagnostics/monitoring-overview)
* [What is Operations Management Suite (OMS)?](/azure/operations-management-suite/operations-management-suite-overview)
* [Built-in roles for Azure role-based access control](/azure/role-based-access-control/built-in-roles)