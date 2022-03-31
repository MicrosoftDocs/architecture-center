---
title: <Article title, which becomes the title metadata>
description: <Write a 100-160 character description that ends with a period and ideally starts with a call to action. This becomes the browse card description.>
author: <Contributor's GitHub username. If no GitHub account, use EdPrice-MSFT>
ms.author: <Contributor's Microsoft alias. Can include multiple contributors, separated by commas. If no alias, use edprice.>
ms.date: <Publish or major update date - mm/dd/yyyy>
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - <Choose 1-5 products from the list at https://review.docs.microsoft.com/en-us/help/contribute/architecture-center/aac-browser-authoring#products>
  - <1-5 products>
  - <1-5 products>
categories:
  - <Choose at least one category from the list at https://review.docs.microsoft.com/en-us/help/contribute/architecture-center/aac-browser-authoring#azure-categories>
  - <There can be more than one category>
ms.custom: fcp
---

# Scenarios featuring Microsoft on-premises technologies on Azure

intro 

For solutions where Azure services integrate with the other Microsoft Cloud platforms, see these articles:
- [Azure and Power Platform scenarios](../solutions/power-platform-scenarios.md)
- [Azure and Microsoft 365 scenarios](../solutions/microsoft-365-scenarios.md)
- [Azure and Dynamics 365 scenarios](../example-scenario/analytics/synapse-customer-insights.yml)

## Active Directory

|Architecture|Summary|Technology focus|
|--|--|--|
|[Add a mobile front end to a legacy app](../solution-ideas/articles/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.yml) |Learn about a solution that consolidates data from multiple business systems and then surfaces the data through web and mobile front ends. This consolidation helps improve employee productivity and speed up decision making.|Mobile|
|[Azure files secured by AD DS](../example-scenario/hybrid/azure-files-on-premises-authentication.yml)|Learn how provide cloud files to your on-premises users at low cost and provide high-security file access with your on-premises Active Directory Domain Services (AD DS) and DNS.| Hybrid|
|[Create an AD DS resource forest](../reference-architectures/identity/adds-forest.yml)|Learn how to create a separate Active Directory domain in Azure that's trusted by domains in your on-premises Active Directory forest.| Identity|
|[Deploy AD DS in an Azure virtual network](../reference-architectures/identity/adds-extend-domain.yml)|Use this reference architecture to extend an on-premises Active Directory domain to Azure to provide distributed authentication services.| Identity|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-dr.yml) |Learn about an optimized approach to disaster recovery of VM-based user workloads hosted on Azure Stack Hub.|Hybrid|
|[Extend on-premises AD FS to Azure](../reference-architectures/identity/adfs.yml) |Implement a highly secure hybrid network architecture by using Active Directory Federation Services (AD FS) authorization in Azure.|Identity|
|[Federate with a customer\'s AD FS](../multitenant-identity/adfs.yml) |Learn how a multitenant SaaS application can federate with a customer's AD FS.|Identity|
|[Hybrid SharePoint farm with Microsoft 365](../solution-ideas/articles/sharepoint-farm-microsoft-365.yml)|Deliver highly available intranet capability and share hybrid workloads with Microsoft 365 by using SharePoint servers, Azure Active Directory (Azure AD), and SQL Server.| Hybrid|
|[Integrate on-premises Active Directory with Azure](../reference-architectures/identity/index.yml) |Compare options for integrating your on-premises Active Directory environment with an Azure network.|Identity|
|[Multiple forests with AD DS and Azure AD](../example-scenario/wvd/multi-forest.yml)|Learn how to create multiple Active Directory forests by using Azure Virtual Desktop.|Virtual Desktop|
|[Multiple forests with AD DS, Azure AD, and Azure AD DS](../example-scenario/wvd/multi-forest-azure-managed.yml) |Learn how to create multiple Active Directory forests by using Azure Virtual Desktop and AD DS.|Virtual Desktop|
|[On-premises AD domains with Azure AD](../reference-architectures/identity/azure-ad.yml) |Learn how to implement a secure hybrid network architecture that integrates on-premises Active Directory domains with Azure Active Directory (Azure AD).|Identity|
|[Use Azure file shares in a hybrid environment](../hybrid/azure-file-share.yml) |With identity-based authentication, you can control access to Azure file shares by using Active Directory Directory Services users and groups.|Hybrid|

## Exchange Server

|Architecture|Summary|Technology focus|
|--|--|--|
|[Back up files and apps on Azure Stack Hub](../hybrid/azure-stack-backup.yml)|This solution delivers an optimized approach to backing up and restoring files and applications of VM-based user workloads hosted on Azure Stack Hub.| Hybrid|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-dr.yml) |This solution delivers an optimized approach to disaster recovery of virtual machine (VM)-based user workloads hosted on Azure Stack Hub.|Hybrid|
|[Enhanced-security hybrid messaging - client access](../example-scenario/hybrid/secure-hybrid-messaging-client.yml)|This article describes an architecture to enhance your security in a client access scenario by using Azure AD Multi-Factor Authentication.| Hybrid|
|[Enhanced-security hybrid messaging - mobile access](../example-scenario/hybrid/secure-hybrid-messaging-mobile.yml)|This article describes an architecture to enhance your security in a mobile access scenario by using Azure AD Multi-Factor Authentication.|Hybrid|
|[Enhanced-security hybrid messaging - web access](../example-scenario/hybrid/secure-hybrid-messaging-web.yml) |This article describes an architecture to help you enhance your security in a web access scenario by using Azure AD Multi-Factor Authentication.|Hybrid|

## Host Integration Server (HIS)

|Architecture|Summary|Technology focus|
|--|--|--|
|[Integrate IBM mainframe and midrange message queues with Azure](../example-scenario/mainframe/integrate-ibm-message-queues-azure.yml) |This example describes a data-first approach to middleware integration that enables IBM message queues (MQs).|Mainframe|
|[Mainframe file replication and sync on Azure](../solution-ideas/articles/mainframe-azure-file-replication.yml) |Learn about several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and in Azure.|Mainframe|

## SharePoint Server

|Architecture|Summary|Technology focus|
|--|--|--|
|[Back up files and apps on Azure Stack Hub](../hybrid/azure-stack-backup.yml)|This solution delivers an optimized approach to backing up and restoring files and applications of VM-based user workloads hosted on Azure Stack Hub.|Hybrid|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-dr.yml)|This solution delivers an optimized approach to disaster recovery of virtual machine (VM)-based user workloads hosted on Azure Stack Hub.| Hybrid|
|[Highly available SharePoint farm](../solution-ideas/articles/highly-available-sharepoint-farm.yml) |Deploy a highly available SharePoint farm for intranet capabilities that uses Azure Active Directory, a SQL always on instance, and SharePoint resources.|Web|
|[Hybrid SharePoint farm with Microsoft 365](../solution-ideas/articles/sharepoint-farm-microsoft-365.yml)|Deliver highly available intranet capability and share hybrid workloads with Microsoft 365 by using SharePoint servers, Azure Active Directory, and SQL Server.|Hybrid|
|[Multi-tier web application built for HA/DR](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml) |Learn how to create a resilient multitier web application built for high availability and disaster recovery on Azure.|Networking|
|[On-premises data gateway for Logic Apps](../hybrid/gateway-logic-apps.yml) |This reference architecture illustrates a logic app that's running in Microsoft Azure, which is triggered by Azure Spring Cloud.|Hybrid|
|[Run a highly available SharePoint Server 2016 farm in Azure](../reference-architectures/sharepoint/index.yml) |This reference architecture shows proven practices for deploying a highly available SharePoint Server 2016 farm on Azure, using MinRole topology and SQL Server Always On availability groups.|Management|
|[SharePoint farm for development testing](../solution-ideas/articles/sharepoint-farm-devtest.yml)|Deploy a SharePoint farm for development testing. Use Azure Active Directory, SQL Server, and SharePoint resources for this agile development architecture.|DevOps|

## SQL Server

|Architecture|Summary|Technology focus|
|--|--|--|
|[Back up files and apps on Azure Stack Hub](../hybrid/azure-stack-backup.yml) |This solution delivers an optimized approach to backing up and restoring files and applications of VM-based user workloads hosted on Azure Stack Hub.|Hybrid|
|[Campaign optimization with SQL Server](../solution-ideas/articles/campaign-optimization-with-sql-server.yml)|Optimize when and how to contact potential customers to improve marketing campaign success rates with machine learning and SQL Server 2016 with R Services.| Databases|
|[Data integration with Logic App and SQL Server](../example-scenario/integration/logic-apps-data-integration.yml) |Automate data integration tasks by using Azure Logic Apps. Configure API calls to trigger tasks like storing data in an on-premises SQL Server database.|Integration|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-dr.yml) |This solution delivers an optimized approach to disaster recovery of virtual machine (VM)-based user workloads hosted on Azure Stack Hub.|Hybrid|
|[Enterprise business intelligence](../reference-architectures/data/enterprise-bi-synapse.yml) |Learn how to implement an ELT pipeline that moves data from an on-premises SQL Server database into Azure Synapse and transforms the data for analysis.|Integration|
|[Hybrid ETL with Azure Data Factory](../example-scenario/data/hybrid-etl-with-adf.yml) |Create a hybrid ETL with existing on-premises SQL Server Integration Services (SSIS) deployments and Azure Data Factory.|Databases|
|[Hybrid SharePoint farm with Microsoft 365](../solution-ideas/articles/sharepoint-farm-microsoft-365.yml) |Deliver highly available intranet capability and share hybrid workloads with Microsoft 365 by using SharePoint servers, Azure Active Directory, and SQL Server.|Hybrid|
|[IaaS: Web app with relational database](../high-availability/ref-arch-iaas-web-and-db.yml) |Learn about the best practices for applying Availability Zones to a web application and Microsoft SQL Server database hosted on virtual machines (VMs).|Databases|
|[Loan chargeoff prediction with SQL Server](../solution-ideas/articles/loan-chargeoff-prediction-with-sql-server.yml) |Build and deploy a machine learning model with SQL Server 2016 with R Services to predict whether a bank loan will soon need to be charged off.|Databases|
|[Loan credit risk and default modeling](../solution-ideas/articles/loan-credit-risk-analyzer-and-default-modeling.yml) |SQL Server 2016 with R Services can help lenders issue fewer unprofitable loans by predicting borrower credit risk and default probability.|Databases|
|[Loan credit risk with SQL Server](../solution-ideas/articles/loan-credit-risk-with-sql-server.yml) |Lending institutions can use the predictive analytics of SQL Server 2016 with R Services to reduce the number of loans to borrowers most likely to default.|Databases|
|[Mainframe access to Azure databases](../solution-ideas/articles/mainframe-access-azure-databases.yml) |Give mainframe applications access to Azure data without changing code. Use Microsoft Service for DRDA to run Db2 SQL statements on a SQL Server database.|Mainframe|
|[Manage data across Azure SQL estate with Azure Purview](../solution-ideas/articles/azure-purview-sql-estate-architecture.yml) |Improve your organization's governance process by using Azure Purview in your Azure SQL estate.|Analytics|
|[Micro Focus Enterprise Server on Azure VMs](../example-scenario/mainframe/micro-focus-server.yml)|Optimize, modernize, and streamline IBM z/OS mainframe applications by using Micro Focus Enterprise Server 6.0 on Azure VMs.| Mainframe|
|[On-premises data gateway for Logic Apps](../hybrid/gateway-logic-apps.yml)|This reference architecture illustrates a logic app that's running in Microsoft Azure, which is triggered by Azure Spring Cloud.| Hybrid|
|[Optimize administration of SQL Server instances in on-premises and multi-cloud environments by using Azure Arc](../hybrid/azure-arc-sql-server.yml) |Learn how to leverage Azure Arc for management, maintenance, and monitoring of SQL Server instances in on-premises and multi-cloud environments.|Databases|
|[Oracle database migration: Rearchitect](../example-scenario/oracle-migrate/oracle-migration-rearchitect.yml) |Rearchitect your Oracle database with Azure SQL Managed Instance.|Migration|
|[Plan deployment for updating Windows VMs in Azure](../example-scenario/wsus/index.yml) |A discussion of how best to configure your environment for Windows Server Update Services (WSUS).|Management|
|[Run a highly available SharePoint Server 2016 farm in Azure](../reference-architectures/sharepoint/index.yml) |This reference architecture shows proven practices for deploying a highly available SharePoint Server 2016 farm on Azure, using MinRole topology and SQL Server Always On availability groups.|Management|
|[SAP NetWeaver on SQL Server](../solution-ideas/articles/sap-netweaver-on-sql-server.yml) |Build an SAP landscape on NetWeaver by using Azure Virtual Machines to host SAP applications and a SQL Server database.|SAP|
|[SharePoint farm for development testing](../solution-ideas/articles/sharepoint-farm-devtest.yml) |Deploy a SharePoint farm for development testing. Use Azure Active Directory, SQL Server, and SharePoint resources for this agile development architecture.|DevOps|
|[SQL Server 2008 R2 failover cluster in Azure](../example-scenario/sql-failover/sql-failover-2008r2.yml) |Learn how to rehost SQL Server 2008 R2 failover clusters on Azure virtual machines and see how to use an Azure shared disk to manage shared storage.|Databases|
|[SQL Server on Azure Virtual Machines with Azure NetApp Files](../example-scenario/file-storage/sql-server-azure-netapp-files.yml) |Implement a high-bandwidth, low-latency solution for SQL Server workloads. Use Azure NetApp Files for enterprise-scale performance and reduced costs.|Storage|
|[Web app private connectivity to Azure SQL Database](../example-scenario/private-web-app/private-web-app.yml) |Lock down access to an Azure SQL Database with Azure Private Link connectivity from a multi-tenant Azure App Service through regional VNet Integration.|Web|
|[Windows N-tier application on Azure](../reference-architectures/n-tier/n-tier-sql-server.yml) |Implement a multi-tier architecture on Azure for availability, security, scalability, and manageability.|Databases|

## Windows Server

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure files secured by AD DS](../example-scenario/hybrid/azure-files-on-premises-authentication.yml) |Learn how to provide secure Azure files that are secured by on-premises Windows Server Active Directory domain services (AD DS), and accessed on-premises.|Hybrid|
|[Back up files and apps on Azure Stack Hub](../hybrid/azure-stack-backup.yml) |This solution delivers an optimized approach to backing up and restoring files and applications of VM-based user workloads hosted on Azure Stack Hub.|Hybrid|
|[Connect standalone servers by using Azure Network Adapter](../hybrid/azure-network-adapter.yml) |Learn how to connect an on-premises standalone server to Microsoft Azure virtual networks by using the Azure Network Adapter that you deploy through Windows Admin Center (WAC).|Hybrid|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-dr.yml) |This solution delivers an optimized approach to disaster recovery of virtual machine (VM)-based user workloads hosted on Azure Stack Hub.|Hybrid|
|[Manage hybrid Azure workloads using Windows Admin Center](../hybrid/hybrid-server-os-mgmt.yml) |Learn how to design a hybrid Windows Admin Center solution to manage workloads that are hosted on-premises and in Microsoft Azure.|Hybrid|
|[Plan deployment for updating Windows VMs in Azure](../example-scenario/wsus/index.yml) |A discussion of how best to configure your environment for Windows Server Update Services (WSUS).|Management|
|[Run a highly available SharePoint Server 2016 farm in Azure](../reference-architectures/sharepoint/index.yml) |This reference architecture shows proven practices for deploying a highly available SharePoint Server 2016 farm on Azure, using MinRole topology and SQL Server Always On availability groups.|Management|
|[Run SAP NetWeaver in Windows on Azure](../reference-architectures/sap/sap-netweaver.yml)|Learn proven practices for running SAP NetWeaver in a Windows environment on Azure, with high availability.|SAP|
|[SQL Server 2008 R2 failover cluster in Azure](../example-scenario/sql-failover/sql-failover-2008r2.yml) |Learn how to rehost SQL Server 2008 R2 failover clusters on Azure virtual machines and see how to use an Azure shared disk to manage shared storage.|Databases|
|[Windows N-tier application on Azure](../reference-architectures/n-tier/n-tier-sql-server.yml) |Implement a multi-tier architecture on Azure for availability, security, scalability, and manageability.|Databases|

## Related resources
- [Microsoft partner and third-party scenarios on Azure](partner-scenarios.md)
- [Architecture for startups](../guide/startups/startup-architecture.md)
- [Azure and Power Platform scenarios](../solutions/power-platform-scenarios.md)
- [Azure and Microsoft 365 scenarios](../solutions/microsoft-365-scenarios.md)
- [Azure and Dynamics 365 scenarios](../solutions/dynamics-365-scenarios.md)
- [Azure for AWS professionals](../aws-professional/index.md)
- [Azure for Google Cloud professionals](../gcp-professional/index.md)