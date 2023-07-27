---
title: Scenarios that feature Microsoft on-premises technologies on Azure
description: Review a list of architectures and solutions that use Microsoft on-premises technologies on Microsoft Azure.
author: martinekuan
ms.author: architectures
ms.date: 07/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - windows-server
  - office-exchange-server
  - sql-server
  - azure-active-directory
  - azure-virtual-machines-windows
categories:
  - mobile
  - hybrid
  - identity
  - windows-virtual-desktop
  - web
  - networking
  - management-and-governance
  - devops
  - databases
  - integration 
  - analytics
  - storage
ms.custom: fcp
---

# Scenarios featuring Microsoft on-premises technologies on Azure

This article describes scenarios that feature Microsoft on-premises technologies on Azure. These scenarios enable you to gain the benefits provided by the cloud when you use technologies that were historically used in a local environment. The following on-premises technologies are frequently used in Azure solutions: 
- [Windows Server 2022](https://www.microsoft.com/windows-server). The foundation of the Microsoft ecosystem. It continues to power the hybrid cloud network.
- [SQL Server 2019](https://www.microsoft.com/sql-server/sql-server-2019). The data platform that's known for performance, security, and availability.
- [Exchange Server](/exchange/new-features/new-features). The messaging platform that provides email, scheduling, and tools for custom collaboration and messaging service applications.
- [Active Directory Domain Services in Windows Server 2016](/windows-server/identity/whats-new-active-directory-domain-services). The service that stores information about user accounts and enables other authorized users on the same network to access it. Security is integrated with Active Directory through sign-in authentication and access control to objects in the directory.
- [Host Integration Server](/host-integration-server/what-is-his). Technologies and tools that enable enterprise organizations to integrate existing IBM host systems, programs, messages, and data with new Microsoft server applications. 

For information about solutions in which Azure services integrate with the other Microsoft cloud platforms, see these articles:
- [Azure and Power Platform scenarios](../solutions/power-platform-scenarios.md)
- [Azure and Microsoft 365 scenarios](../solutions/microsoft-365-scenarios.md)
- [Azure and Dynamics 365 scenarios](../example-scenario/analytics/synapse-customer-insights.yml)

## Active Directory

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure files secured by AD DS](../example-scenario/hybrid/azure-files-on-premises-authentication.yml)|Provide high-security file access with on-premises Windows Server Active Directory Domain Services (AD DS) and DNS.| Hybrid|
|[Create an AD DS resource forest](../reference-architectures/identity/adds-forest.yml)|Learn how to create a separate Active Directory domain on Azure that's trusted by domains in your on-premises Active Directory forest.| Identity|
|[Deploy AD DS in an Azure virtual network](../reference-architectures/identity/adds-extend-domain.yml)|Use this reference architecture to extend an on-premises Active Directory domain to Azure to provide distributed authentication services.| Identity|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-disaster-recovery.yml) |Learn about an optimized approach to disaster recovery of VM-based user workloads that are hosted on Azure Stack Hub. Azure Site Recovery integrates with Windows Server-based apps and roles, including Active Directory Domain Services.|Hybrid|
|[Extend on-premises AD FS to Azure](../reference-architectures/identity/adfs.yml) |Implement a highly secure hybrid network architecture by using Active Directory Federation Services (AD FS) authorization on Azure.|Identity|
|[Hybrid SharePoint farm with Microsoft 365](../solution-ideas/articles/sharepoint-farm-microsoft-365.yml)|Deliver highly available intranet capability and share hybrid workloads with Microsoft 365 by using SharePoint servers, Azure Active Directory (Azure AD), and SQL Server. Windows Server hosts Active Directory services for service and machine accounts.| Hybrid|
|[Integrate on-premises Active Directory with Azure](../reference-architectures/identity/index.yml) |Compare options for integrating your on-premises Active Directory environment with an Azure network.|Identity|
|[Multiple forests with AD DS and Azure AD](../example-scenario/wvd/multi-forest.yml)|Create multiple Active Directory forests by using Azure Virtual Desktop.|Virtual Desktop|
|[Multiple forests with AD DS, Azure AD, and Azure AD DS](../example-scenario/wvd/multi-forest-azure-managed.yml) |Create multiple Active Directory forests by using Azure Virtual Desktop and AD DS.|Virtual Desktop|
|[On-premises Active Directory domains with Azure AD](../reference-architectures/identity/azure-ad.yml) |Learn how to implement a secure hybrid network architecture that integrates on-premises Active Directory domains with Azure AD.|Identity|
|[Use Azure file shares in a hybrid environment](../hybrid/azure-file-share.yml) |Use identity-based authentication to control access to Azure file shares via AD DS users and groups.|Hybrid|

## Exchange Server

|Architecture|Summary|Technology focus|
|--|--|--|
|[Back up files and apps on Azure Stack Hub](../hybrid/azure-stack-backup.yml)|Learn about an optimized approach to backing up and restoring files and applications of VM-based user workloads that are hosted on Azure Stack Hub. Includes backup and restore of Exchange Server servers and databases.| Hybrid|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-disaster-recovery.yml) |Learn about an optimized approach to disaster recovery of VM-based user workloads that are hosted on Azure Stack Hub. Includes a discussion of disaster recovery for Exchange workloads.|Hybrid|
|[Enhanced-security hybrid messaging - client access](../example-scenario/hybrid/secure-hybrid-messaging-client.yml)|Enhance your security in a client access scenario by using Azure AD Multi-Factor Authentication. Discusses scenarios for Exchange Online and Exchange on-premises.| Hybrid|
|[Enhanced-security hybrid messaging - mobile access](../example-scenario/hybrid/secure-hybrid-messaging-mobile.yml)|Enhance your security in a mobile access scenario by using Azure AD Multi-Factor Authentication. Discusses scenarios for Exchange Online and Exchange on-premises.|Hybrid|
|[Enhanced-security hybrid messaging - web access](../example-scenario/hybrid/secure-hybrid-messaging-web.yml) |Enhance your security in a web access scenario by using Azure AD Multi-Factor Authentication. Discusses scenarios for Exchange Online and Exchange on-premises.|Hybrid|

## Host Integration Server (HIS)

|Architecture|Summary|Technology focus|
|--|--|--|
|[Integrate IBM mainframe and midrange message queues with Azure](../example-scenario/mainframe/integrate-ibm-message-queues-azure.yml) |Learn about a data-first approach to middleware integration that enables IBM message queues. HIS is used in a VM-based IaaS approach.|Mainframe|
|[Mainframe file replication and sync on Azure](../solution-ideas/articles/mainframe-azure-file-replication.yml) |Learn several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and on Azure. HIS is used to convert EBCDIC files to make them compatible with Azure.|Mainframe|

## SharePoint Server

|Architecture|Summary|Technology focus|
|--|--|--|
|[Back up files and apps on Azure Stack Hub](../hybrid/azure-stack-backup.yml)|Learn about an optimized approach to backing up and restoring files and applications of VM-based user workloads that are hosted on Azure Stack Hub. Includes backup and restore of SharePoint farms and front-end web server content and restore of SharePoint databases, web apps, files, list items, and search components.|Hybrid|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-disaster-recovery.yml)|Learn about an optimized approach to disaster recovery of VM-based user workloads that are hosted on Azure Stack Hub. Includes information about disaster recovery for SharePoint workloads.| Hybrid|
|[Highly available SharePoint farm](../solution-ideas/articles/highly-available-sharepoint-farm.yml) |Deploy a highly available SharePoint farm for intranet capabilities that uses Azure AD, a SQL Server Always On instance, and SharePoint resources.|Web|
|[Hybrid SharePoint farm with Microsoft 365](../solution-ideas/articles/sharepoint-farm-microsoft-365.yml)|Deliver highly available intranet capability and share hybrid workloads with Microsoft 365 by using SharePoint servers, Azure AD, and SQL Server.|Hybrid|
|[Multitier web application built for HA/DR](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml) |Learn how to create a resilient multitier web application that's built for high availability and disaster recovery on Azure. Applies to applications like SharePoint.|Networking|
|[On-premises data gateway for Logic Apps](../hybrid/gateway-logic-apps.yml) |Review a reference architecture that illustrates a logic app that runs in Azure and connects to on-premises resources like SharePoint Server.|Hybrid|
|[Run a highly available SharePoint Server 2016 farm in Azure](../reference-architectures/sharepoint/index.yml) |Learn proven practices for deploying a highly available SharePoint Server 2016 farm on Azure.|Management|
|[SharePoint farm for development testing](../solution-ideas/articles/sharepoint-farm-devtest.yml)|Deploy a SharePoint farm for development testing. Use Azure AD, SQL Server, and SharePoint resources for this agile development architecture.|DevOps|

## SQL Server

|Architecture|Summary|Technology focus|
|--|--|--|
|[Back up files and apps on Azure Stack Hub](../hybrid/azure-stack-backup.yml) |Learn about an optimized approach to backing up and restoring files and applications of VM-based user workloads that are hosted on Azure Stack Hub. Includes backup and restore of SQL Server instances and their databases.|Hybrid|
|[Campaign optimization with SQL Server](../solution-ideas/articles/campaign-optimization-with-sql-server.yml)|Use machine learning and SQL Server 2016 with R Services to optimize when and how to contact potential customers to improve success rates for marketing campaigns.| Databases|
|[Data integration with Logic Apps and SQL Server](../example-scenario/integration/logic-apps-data-integration.yml) |Automate data integration tasks by using Azure Logic Apps. Configure API calls to trigger tasks like storing data in an on-premises SQL Server database.|Integration|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-disaster-recovery.yml) |Learn about an optimized approach to disaster recovery of VM-based user workloads that are hosted on Azure Stack Hub. Includes information about disaster recovery for SQL Server workloads.|Hybrid|
|[Enterprise business intelligence](/azure/architecture/example-scenario/analytics/enterprise-bi-synapse) |Learn how to implement an ELT pipeline that moves data from an on-premises SQL Server database into Azure Synapse Analytics and transforms the data for analysis.|Integration|
|[Hybrid ETL with Azure Data Factory](../example-scenario/data/hybrid-etl-with-adf.yml) |Use Azure Data Factory to create a hybrid ETL for existing on-premises SQL Server Integration Services (SSIS) deployments.|Databases|
|[Hybrid SharePoint farm with Microsoft 365](../solution-ideas/articles/sharepoint-farm-microsoft-365.yml) |Deliver highly available intranet capability and share hybrid workloads with Microsoft 365 by using SharePoint servers, Azure AD, and SQL Server.|Hybrid|
|[IaaS: Web app with relational database](../high-availability/ref-arch-iaas-web-and-db.yml) |Learn best practices for applying availability zones to a web application and SQL Server database that are hosted on VMs.|Databases|
|[Loan chargeoff prediction with SQL Server](../solution-ideas/articles/loan-chargeoff-prediction-with-sql-server.yml) |Build and deploy a machine learning model that uses SQL Server 2016 with R Services to predict whether a bank loan needs to be charged off soon.|Databases|
|[Loan credit risk and default modeling](../example-scenario/ai/loan-credit-risk-analyzer-default-modeling) |Learn how SQL Server 2016 with R Services can help lenders issue fewer unprofitable loans by predicting borrower credit risk and default probability.|Databases|
|[Loan credit risk with SQL Server](../solution-ideas/articles/loan-credit-risk-with-sql-server.yml) |Learn how lending institutions can use the predictive analytics of SQL Server 2016 with R Services to reduce the number of loans to borrowers who are most likely to default.|Databases|
|[Mainframe access to Azure databases](../solution-ideas/articles/mainframe-access-azure-databases.yml) |Give mainframe applications access to Azure data without changing code. Use Microsoft Service for DRDA to run Db2 SQL statements on a SQL Server database.|Mainframe|
|[Manage data across your Azure SQL estate with Azure Purview](../solution-ideas/articles/azure-purview-sql-estate-architecture.yml) |Improve your organization's governance process by using Azure Purview in your Azure SQL estate.|Analytics|
|[Micro Focus Enterprise Server on Azure VMs](../example-scenario/mainframe/micro-focus-server.yml)|Optimize, modernize, and streamline IBM z/OS mainframe applications by using Micro Focus Enterprise Server 6.0 on Azure VMs. This solution uses a SQL Server IaaS database in an Always On cluster.| Mainframe|
|[On-premises data gateway for Logic Apps](../hybrid/gateway-logic-apps.yml)|Review a reference architecture that illustrates a logic app that runs in Azure and connects to on-premises resources like SQL Server.| Hybrid|
|[Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](../hybrid/azure-arc-sql-server.yml) |Learn how to use Azure Arc for the management, maintenance, and monitoring of SQL Server instances in on-premises and multicloud environments.|Databases|
|[Oracle database migration: Rearchitect](../example-scenario/oracle-migrate/oracle-migration-rearchitect.yml) |Rearchitect your Oracle database by using Azure SQL Managed Instance.|Migration|
|[Plan deployment for updating Windows VMs on Azure](../example-scenario/wsus/index.yml)|Learn best practices for configuring your environment for Windows Server Update Services (WSUS). SQL Server is the recommended database for servers that support a high number of client computers.|Management|
|[Run a highly available SharePoint Server 2016 farm in Azure](../reference-architectures/sharepoint/index.yml) |Learn proven practices for deploying a highly available SharePoint Server 2016 farm on Azure by using MinRole topology and SQL Server Always On availability groups.|Management|
|[SAP NetWeaver on SQL Server](../solution-ideas/articles/sap-netweaver-on-sql-server.yml) |Build an SAP landscape on NetWeaver by using Azure Virtual Machines to host SAP applications and a SQL Server database.|SAP|
|[SharePoint farm for development testing](../solution-ideas/articles/sharepoint-farm-devtest.yml) |Deploy a SharePoint farm for development testing. Use Azure AD, SQL Server, and SharePoint resources for this agile development architecture.|DevOps|
|[SQL Server 2008 R2 failover cluster on Azure](../example-scenario/sql-failover/sql-failover-2008r2.yml) |Learn how to rehost SQL Server 2008 R2 failover clusters on Azure virtual machines. |Databases|
|[SQL Server on Azure Virtual Machines with Azure NetApp Files](../example-scenario/file-storage/sql-server-azure-netapp-files.yml) |Implement a high-bandwidth, low-latency solution for SQL Server workloads. Use Azure NetApp Files for enterprise-scale performance and reduced costs.|Storage|
|[Web app private connectivity to Azure SQL Database](../example-scenario/private-web-app/private-web-app.yml) |Lock down access to an Azure SQL database with Azure Private Link connectivity from a multitenant web app.|Web|
|[Windows N-tier application on Azure](../reference-architectures/n-tier/n-tier-sql-server.yml) |Implement a multitier architecture on Azure for availability, security, scalability, and manageability. SQL Server provides the data tier.|Databases|

[Browse all our SQL Server solutions](/azure/architecture/browse/?products=sql-server).

## Windows Server

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure files secured by AD DS](../example-scenario/hybrid/azure-files-on-premises-authentication.yml) |Provide high-security file access with on-premises Windows Server AD DS and DNS.|Hybrid|
|[Back up files and apps on Azure Stack Hub](../hybrid/azure-stack-backup.yml) |Learn about an optimized approach to backing up and restoring files and applications of VM-based user workloads that are hosted on Azure Stack Hub. Supports backup and restore of various resources on VMs that run Windows Server. |Hybrid|
|[Connect standalone servers by using Azure Network Adapter](../hybrid/azure-network-adapter.yml) |Learn how to connect an on-premises standalone server to Azure virtual networks by using Azure Network Adapter. Deploy Network Adapter by using Windows Admin Center on Windows Server.|Hybrid|
|[Disaster recovery for Azure Stack Hub VMs](../hybrid/azure-stack-vm-disaster-recovery.yml) |Learn about an optimized approach to disaster recovery of VM-based user workloads that are hosted on Azure Stack Hub. Includes information about providing disaster recovery for Azure Stack Hub VMs that run Windows Server operating systems.|Hybrid|
|[Manage hybrid Azure workloads using Windows Admin Center](../hybrid/hybrid-server-os-mgmt.yml) |Learn how to design a hybrid Windows Admin Center solution to manage workloads that are hosted on-premises and on Azure.|Hybrid|
|[Plan deployment for updating Windows VMs on Azure](../example-scenario/wsus/index.yml)|Learn best practices for configuring your environment for WSUS.|Management|
|[Run a highly available SharePoint Server 2016 farm on Azure](../reference-architectures/sharepoint/index.yml) |Learn proven practices for deploying a highly available SharePoint Server farm on Azure. Windows Server Active Directory domain controllers run in the virtual network and have a trust relationship with the on-premises Windows Server Active Directory forest.|Management|
|[Run SAP NetWeaver in Windows on Azure](/azure/architecture/guide/sap/sap-netweaver)|Learn proven practices for running SAP NetWeaver in a Windows environment on Azure.|SAP|
|[SQL Server 2008 R2 failover cluster on Azure](../example-scenario/sql-failover/sql-failover-2008r2.yml) |Learn how to rehost SQL Server 2008 R2 failover clusters on Azure virtual machines. Use the Azure shared disks feature and a Windows Server 2008 R2 failover cluster to replicate your on-premises deployment on Azure.|Databases|
|[Windows N-tier application on Azure](../reference-architectures/n-tier/n-tier-sql-server.yml) |Implement a multitier architecture on Azure for availability, security, scalability, and manageability.|Databases|

## Related resources

- [Microsoft partner and third-party scenarios on Azure](partner-scenarios.md)
- [Architecture for startups](../guide/startups/startup-architecture.md)
- [Azure and Power Platform scenarios](../solutions/power-platform-scenarios.md)
- [Azure and Microsoft 365 scenarios](../solutions/microsoft-365-scenarios.md)
- [Azure and Dynamics 365 scenarios](../solutions/dynamics-365-scenarios.md)
- [Azure for AWS professionals](../aws-professional/index.md)
- [Azure for Google Cloud professionals](../gcp-professional/index.md)
