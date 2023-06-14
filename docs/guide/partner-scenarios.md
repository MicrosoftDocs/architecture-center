---
title: Microsoft partner and third-party scenarios on Azure
description: Review an extensive list of architectures and solutions that use Microsoft partner and third-party solutions.
author: martinekuan
ms.author: architectures
ms.date: 07/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-netapp-files
  - azure-virtual-machines
  - azure-active-directory
  - azure-virtual-desktop
categories:
  - databases
  - hybrid
  - analytics
  - web
  - iot
  - migration 
  - containers
  - integration 
  - media
  - compute
  - management-and-governance
  - storage
  - mobile
  - security
  - networking
  - windows-virtual-desktop
ms.custom: fcp
---

# Microsoft partner and third-party scenarios on Azure

This article explores Microsoft partner and third-party, non-open source scenarios on Microsoft Azure.

Microsoft partners make up a community of organizations that work with Microsoft to create innovative solutions for you. Driven by the opportunities of the intelligent cloud, Microsoft is prioritizing investments that support these opportunities.

The [Azure Sponsorship for ISVs program](https://azure.microsoft.com/partners/isv) helps independent software vendors (ISVs) use Azure services to drive platform innovation and develop new solutions that can accelerate your digital transformation. 

Visit [Azure Marketplace](https://azuremarketplace.microsoft.com) to discover, try, and deploy cloud software from Microsoft and Microsoft partners.

This article provides a summary of architectures and solutions that use Azure together with partner and third-party solutions.

We also recommend you browse our open-source solutions for Microsoft Azure:
- [Apache open-source scenarios on Azure](/azure/architecture/guide/apache-scenarios)
- [Open-source scenarios on Azure](/azure/architecture/guide/open-source-scenarios)

## Advanced

|Architecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe applications with Advanced](../example-scenario/mainframe/refactor-mainframe-applications-advanced.yml)|Learn how to use the automated COBOL refactoring solution from Advanced to modernize your mainframe COBOL applications, run them on Azure, and reduce costs.|Mainframe|

## Astadia

|Architecture|Summary|Technology focus|
|--|--|--|
|[Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](../example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus.yml)|Migrate Unisys Dorado mainframe systems with Astadia and Micro Focus products. Move to Azure without rewriting code, switching data models, or updating screens.|Mainframe|

## Avanade

|Architecture|Summary|Technology focus|
|--|--|--|
|[IBM z/OS mainframe migration with Avanade AMT](../example-scenario/mainframe/asysco-zos-migration.yml)|Learn how to use the Avanade Automated Migration Technology (AMT) framework to migrate IBM z/OS mainframe workloads to Azure.|Mainframe|
|[Unisys mainframe migration with Avanade AMT](../reference-architectures/migration/unisys-mainframe-migration.yml)|Learn options for using the AMT framework to migrate Unisys mainframe workloads to Azure.|Mainframe|

## CluedIn

|Architecture|Summary|Technology focus|
|--|--|--|
|[Master Data Management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations.|Databases|
|[Migrate master data services to Azure with CluedIn and Azure Purview](../reference-architectures/data/migrate-master-data-services-with-cluedin.yml)|Use CluedIn to migrate your master data services solution to Azure by using CluedIn and Azure Purview.|Databases|

## Confluent

|Architecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Kafka is used with Confluent Schema Registry for streaming.|Migration|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. Kafka, which is available via ConfluentCloud, is recommended for real-time message ingestion.  |Databases|

## Couchbase

|Architecture|Summary|Technology focus|
|--|--|--|
|[High availability in Azure public MEC](../example-scenario/hybrid/multi-access-edge-compute-ha.yml)|Learn how to deploy workloads in active-standby mode to achieve high availability and disaster recovery in Azure public multi-access edge compute. Couchbase can provide IaaS services that support geo-replication.|Hybrid|

## Double-Take

|Architecture|Summary|Technology focus|
|--|--|--|
|[SMB disaster recovery with Azure Site Recovery](../solution-ideas/articles/disaster-recovery-smb-azure-site-recovery.yml)|Learn how small and medium-sized businesses can inexpensively implement cloud-based disaster recovery solutions by using Azure Site Recovery or Double-Take DR.|Management|
|[SMB disaster recovery with Double-Take DR](../solution-ideas/articles/disaster-recovery-smb-double-take-dr.yml)|Learn how small and medium-sized businesses can inexpensively implement cloud-based disaster recovery solutions by using a partner solution like Double-Take DR.|Management|

## Episerver

|Architecture|Summary|Technology focus|
|--|--|--|
|[Scalable Episerver marketing website](../solution-ideas/articles/digital-marketing-episerver.yml)|Run multi-channel digital marketing websites on one platform. Start and stop campaigns on demand. Manage site and campaign performance by using Episerver.|Web|

## Gremlin

|Architecture|Summary|Technology focus|
|--|--|--|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use technologies like Kafka, Kubernetes, Gremlin, PostgreSQL, and Redis components.|Analytics|

## Infinite i

|Architecture|Summary|Technology focus|
|--|--|--|
|[IBM System i (AS/400) to Azure using Infinite i](../example-scenario/mainframe/ibm-system-i-azure-infinite-i.yml)|Use Infinite i to easily migrate your IBM System i (AS/400) workloads to Azure. You can lower costs, improve performance, improve availability, and modernize.|Mainframe|

## LzLabs

|Architecture|Summary|Technology focus|
|--|--|--|
|[Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](../example-scenario/mainframe/lzlabs-software-defined-mainframe-in-azure.yml)|Learn an approach for rehosting mainframe legacy applications in Azure by using the LzLabs SDM platform.|Mainframe|

## Micro Focus

|Architecture|Summary|Technology focus|
|--|--|--|
|[Micro Focus Enterprise Server on Azure VMs](../example-scenario/mainframe/micro-focus-server.yml)|Optimize, modernize, and streamline IBM z/OS mainframe applications by using Micro Focus Enterprise Server 6.0 on Azure VMs.|Mainframe|
|[Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](../example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus.yml)|Migrate Unisys Dorado mainframe systems with Astadia and Micro Focus products. Move to Azure without rewriting code, switching data models, or updating screens.|Mainframe|

## MongoDB

|Architecture|Summary|Technology focus|
|--|--|--|
|[Advanced AKS microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)|Learn about a scalable, highly secure AKS microservices architecture that builds on recommended AKS microservices baseline architectures and implementations. In this architecture, Azure Cosmos DB stores data by using the open-source Azure Cosmos DB for MongoDB. |Containers|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run MongoDB database workloads.|Containers|
|[Core startup stack architecture](../example-scenario/startups/core-startup-stack.yml)|Review the components of a simple core startup stack architecture. MongoDB is recommended for uses cases that require a NoSQL database.|Startup|
|[COVID-19 safe solutions with IoT Edge](../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)|Create a COVID-19 safe environment that monitors social distance, mask/PPE use, and occupancy requirements with CCTVs and IoT Edge, Stream Analytics, and Azure Machine Learning. MongoDB is used to store cloud data for Power BI analytics and visualizations.|IoT|
|[Data considerations for microservices](../microservices/design/data-considerations.yml)|Learn about managing data in a microservices architecture. The MongoDB API is used with Azure Cosmos DB in an example scenario.|Microservices|
|[High availability in Azure public MEC](../example-scenario/hybrid/multi-access-edge-compute-ha.yml)|Learn how to deploy workloads in active-standby mode to achieve high availability and disaster recovery in Azure public multiaccess edge compute. MongoDB can provide IaaS services that support geo-replication.|Hybrid|
|[Scalable web application](../reference-architectures/app-service-web-app/scalable-web-app.yml)|Use the proven practices in this reference architecture to improve scalability and performance in an App Service web application. MongoDB is recommended for non-relational data. |Web|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, MongoDB, PostgreSQL, and Redis components.|Analytics|
|[Virtual network integrated serverless microservices](../example-scenario/integrated-multiservices/virtual-network-integration.yml)|Learn about an end-to-end solution for health records management that uses Azure Functions microservices integrated with other services via a virtual network. In this solution, microservices store data in Azure Cosmos DB, using the MongoDB Node.js driver.|Security|

## NetApp

|Architecture|Summary|Technology focus|
|--|--|--|
|[AIX UNIX on-premises to Azure Linux migration](../example-scenario/unix-migration/migrate-aix-azure-linux.yml)|Migrate an on-premises IBM AIX system and web application to a highly available, highly secure Red Hat Enterprise Linux solution in Azure. Azure NetApp Files provides shared NAS.|Mainframe|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Storage|
|[SAP workload development and test settings](../example-scenario/apps/sap-dev-test.yml)|Learn how to establish non-production development and test environments for SAP NetWeaver in a Windows or Linux environment on Azure. Azure NetApp Files is recommended for storage of SAP executables and HANA data and logs.|SAP|
|[Enterprise file shares with disaster recovery](../example-scenario/file-storage/enterprise-file-shares-disaster-recovery.yml)|Learn how to implement resilient NetApp file shares. Failure of the primary Azure region causes automatic failover to the secondary Azure region.|Storage|
|[FSLogix configuration examples](/fslogix/concepts-configuration-examples)|Learn how to build virtual desktop infrastructure solutions at enterprise scale by using FSLogix. Azure NetApp Files is recommended for storing profiles.  |Hybrid|
|[General mainframe refactor to Azure](../example-scenario/mainframe/general-mainframe-refactor.yml)|Learn how to refactor mainframe applications to run more cost-effectively and efficiently on Azure. Azure NetApp Files is recommended for file storage. |Mainframe|
|[Moodle deployment with Azure NetApp Files](../example-scenario/file-storage/moodle-azure-netapp-files.yml)|Deploy Moodle with Azure NetApp Files for a resilient solution that offers high-throughput, low-latency access to scalable shared storage.|Storage|
|[Multiple forests with AD DS and Azure AD](../example-scenario/wvd/multi-forest.yml)|Learn how to create multiple Active Directory forests with Azure Virtual Desktop. Azure NetApp Files is one recommended storage solution for the scenario.|Virtual Desktop|
|[Oracle Database with Azure NetApp Files](../example-scenario/file-storage/oracle-azure-netapp-files.yml)|Implement a high-bandwidth, low-latency solution for Oracle Database workloads. Use Azure NetApp Files to get enterprise-scale performance and to reduce costs.|Storage|
|[Refactor mainframe computer systems that run Adabas & Natural](../example-scenario/mainframe/refactor-adabas-aks.yml)|Learn how to modernize mainframe computer systems that run Adabas & Natural and move them to the cloud. Azure NetApp Files is used to store persistent data.|Mainframe|
|[Run SAP BW/4HANA with Linux VMs](../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml)|Learn about the SAP BW/4HANA application tier and how it's suitable for a high-availability, small-scale production environment of SAP BW/4HANA on Azure. Azure NetApp Files is used by a high-availability cluster for shared file storage. |SAP|
|[SAP deployment in Azure using an Oracle database](../example-scenario/apps/sap-production.yml)|Learn proven practices for running SAP on Oracle in Azure, with high availability.|SAP|
|[SAP HANA for Linux VMs in scale-up systems](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml)|Learn proven practices for running SAP HANA in a high availability scale-up environment that supports disaster recovery.|SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/guide/sap/sap-s4hana)|Learn proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability.|SAP|
|[SAS on Azure architecture](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. Includes recommendations for using Azure NetApp Files.|Compute|
|[SQL Server on Azure Virtual Machines with Azure NetApp Files](../example-scenario/file-storage/sql-server-azure-netapp-files.yml)|Implement a high-bandwidth, low-latency solution for SQL Server workloads. Use Azure NetApp Files to get enterprise-scale performance and to reduce costs.|Storage|

## Oracle

|Architecture|Summary|Technology focus|
|--|--|--|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations. CluedIn takes input from on-premises accessible systems like Oracle.|Databases|
|[Migrate IBM mainframe apps to Azure with TmaxSoft OpenFrame](../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)|Migrate IBM zSeries mainframe applications to Azure. Use a no-code approach that TmaxSoft OpenFrame provides. OpenFrame can integrate with RDBMSs like Oracle.|Mainframe|
|[Oracle Database migration to Azure](../solution-ideas/articles/reference-architecture-for-oracle-database-migration-to-azure.yml)|Migrate an Oracle database and its applications to Azure. Use Oracle Active Data Guard for the database, and use Azure Load Balancer for the application tier.|Oracle|
|[Oracle Database migration: Cross-cloud connectivity](../example-scenario/oracle-migrate/oracle-migration-cross-cloud.yml)|Create a connection between your existing Oracle database and your Azure applications.|Oracle|
|[Oracle Database migration: Lift and shift](../example-scenario/oracle-migrate/oracle-migration-lift-shift.yml)|Lift and shift your Oracle database from an Oracle environment to Azure Virtual Machines.|Oracle|
|[Oracle Database migration: Refactor](../example-scenario/oracle-migrate/oracle-migration-refactor.yml)|Refactor your Oracle database by using Azure Database Migration Service, and move it to PostgreSQL.|Oracle|
|[Oracle Database migration: Rearchitect](../example-scenario/oracle-migrate/oracle-migration-rearchitect.yml)|Rearchitect your Oracle database by using Azure SQL Managed Instance.|Oracle|
|[Oracle Database with Azure NetApp Files](../example-scenario/file-storage/oracle-azure-netapp-files.yml)|Implement a high-bandwidth, low-latency solution for Oracle Database workloads. Use Azure NetApp Files to get enterprise-scale performance and to reduce costs.|Storage|
|[Overview of Oracle Database migration](../example-scenario/oracle-migrate/oracle-migration-overview.yml)|Learn about Oracle Database migration paths and the methods you can use to migrate your schema to SQL or PostgreSQL.|Oracle|
|[Refactor mainframe applications with Advanced](../example-scenario/mainframe/refactor-mainframe-applications-advanced.yml)|Learn how to use the automated COBOL refactoring solution from Advanced to modernize your mainframe COBOL applications, run them on Azure, and reduce costs. Use Oracle databases on VMs for persistent data.|Mainframe|
|[Run Oracle databases on Azure](../solution-ideas/articles/reference-architecture-for-oracle-database-on-azure.yml)|Use a canonical architecture to achieve high availability for Oracle Database Enterprise Edition on Azure.|Oracle|
|[Run SAP NetWeaver in Windows on Azure](/azure/architecture/guide/sap/sap-netweaver)|Learn proven practices for running SAP NetWeaver in a Windows environment on Azure, with high availability. Oracle is one recommended database.|SAP|
|[SAP deployment on Azure using an Oracle database](../example-scenario/apps/sap-production.yml)|Learn proven practices for running SAP on Oracle in Azure, with high availability.|Oracle|
|[Security considerations for highly sensitive IaaS apps in Azure](../reference-architectures/n-tier/high-security-iaas.yml)|Learn about VM security, encryption, NSGs, perimeter networks (also known as DMZs), access control, and other security considerations for highly sensitive IaaS and hybrid apps. A common replication scenario for IaaS architectures uses Oracle Active Data Guard. |Security|
|[SWIFT\'s Alliance Access with Alliance Connect Virtual on Azure](../example-scenario/finance/swift-alliance-access-vsrx-on-azure.yml)|View a reference architecture for deploying and running SWIFT Alliance Access with Alliance Connect Virtual on Azure. An Alliance Access component contains an embedded Oracle database.|Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect Virtual](../example-scenario/finance/swift-alliance-messaging-hub-vsrx.yml)|Run SWIFT AMH on Azure. This messaging solution helps financial institutions securely and efficiently bring new services to market. A key component, the AMH node, runs an Oracle database.|Networking|

## Postman

|Architecture|Summary|Technology focus|
|--|--|--|
|[Design APIs for microservices](../microservices/design/api-design.yml)|Learn about good API design in a microservices architecture. IDLs used to define APIs can be consumed by API testing tools like Postman.|Microservices|
|[Gridwich local development environment setup](../reference-architectures/media-services/set-up-local-environment.yml)|Set up a local development environment to work with Gridwich. Postman is an optional component in the configuration.|Media|
|[Unified logging for microservices apps](../example-scenario/logging/unified-logging.yml)|Learn about logging, tracing, and monitoring for microservices apps.|Microservices|

## Profisee

|Architecture|Summary|Technology focus|
|--|--|--|
|[Data governance with Profisee and Azure Purview](../reference-architectures/data/profisee-master-data-management-purview.yml)|Integrate Profisee master data management with Azure Purview to build a foundation for data governance and management.|Databases|
|[Master data management with Profisee and Azure Data Factory](../reference-architectures/data/profisee-master-data-management-data-factory.yml)|Integrate Profisee master data management with Data Factory to deliver high quality, trusted data for Azure Synapse and all analytics applications. Postman is recommended for synthetic logging.|Databases|

## Qlik

|Architecture|Summary|Technology focus|
|--|--|--|
|[Mainframe and midrange data replication to Azure using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)|Learn how Qlik Replication is a valuable tool for migrating mainframe and midrange systems to the cloud, or for extending such systems with cloud applications.|Mainframe|

## Raincode

|Architecture|Summary|Technology focus|
|--|--|--|
|[Rehost mainframe applications to Azure with Raincode compilers](../reference-architectures/app-modernization/raincode-reference-architecture.yml)|Learn how the Raincode COBOL compiler modernizes mainframe legacy applications.|Mainframe|

## SAP

|Architecture|Summary|Technology focus|
|--|--|--|
|[Add a mobile front end to a legacy app](../solution-ideas/articles/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.yml)|Learn about a solution that uses Azure SQL Database and SAP to consolidate data from multiple business systems and surface it through web and mobile front ends. |Mobile|
|[Custom mobile workforce app](../solution-ideas/articles/custom-mobile-workforce-app.yml)|Learn about a mobile workforce app architecture that uses Active Directory to secure corporate data from an SAP back-end system.|Mobile|
|[Development and test environments for SAP workloads on Azure](../example-scenario/apps/sap-dev-test.yml)|Learn how to establish non-production development and test environments for SAP NetWeaver in a Windows or Linux environment on Azure.|SAP|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations. CluedIn takes input from on-premises accessible systems like SAP.|Databases|
|[Multitier web application built for HA/DR](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)|Learn how to create a resilient multitier web application built for high availability and disaster recovery on Azure. Common scenarios include any mission-critical application that runs on Windows or Linux, including applications like SAP. |Networking|
|[Run SAP BW/4HANA with Linux VMs](../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml)|Learn about the SAP BW/4HANA application tier and how it's suitable for a high availability small-scale production environment of SAP BW/4HANA on Azure.|SAP|
|[Run SAP HANA for Linux VMs in scale-up systems](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml)|Learn proven practices for running SAP HANA in a high availability scale-up environment that supports disaster recovery.|SAP|
|[Run SAP HANA Large Instances](../reference-architectures/sap/hana-large-instances.yml)|Learn proven practices for running SAP HANA in a high availability environment on Azure Large Instances.|SAP|
|[Run SAP NetWeaver in Windows on Azure](/azure/architecture/guide/sap/sap-netweaver)|Learn proven practices for running SAP NetWeaver in a Windows environment on Azure, with high availability.|SAP|
|[SAP deployment on Azure using an Oracle database](../example-scenario/apps/sap-production.yml)|Learn proven practices for running SAP on Oracle in Azure, with high availability.|SAP|
|[SAP on Azure architecture design](../reference-architectures/sap/sap-overview.yml)|Review a set of guiding tenets to help ensure the quality of SAP workloads that run on Azure.|SAP|
|[SAP NetWeaver on SQL Server](../solution-ideas/articles/sap-netweaver-on-sql-server.yml)|Build an SAP landscape on NetWeaver by using Azure Virtual Machines to host SAP applications and a SQL Server database.|SAP|
|[SAP S/4HANA for Large Instances](../solution-ideas/articles/sap-s4-hana-on-hli-with-ha-and-dr.yml)|With large SAP HANA instances, use Azure Virtual Machines, OS clustering, and NFS storage for scalability, performance, high reliability, and disaster recovery.|SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/guide/sap/sap-s4hana)|Review proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability.|SAP|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation.|SAP|

## SAS

|Architecture|Summary|Technology focus|
|--|--|--|
|[SAS on Azure architecture](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. See guidelines for designing and implementing cloud solutions for SAS Viya and SAS Grid.|Compute|

## Sitecore

|Architecture|Summary|Technology focus|
|--|--|--|
|[Scalable Sitecore marketing website](../solution-ideas/articles/digital-marketing-sitecore.yml)|Learn how the Sitecore Experience Platform (XP) provides the data, integrated tools, and automation you need to engage customers throughout an iterative lifecycle.|Web|

## Skytap

|Architecture|Summary|Technology focus|
|--|--|--|
|[Migrate AIX workloads to Skytap on Azure](../example-scenario/mainframe/migrate-aix-workloads-to-azure-with-skytap.yml)|Learn now to migrate AIX logical partitions (LPARs) to Skytap on Azure.|Mainframe|
|[Migrate IBM i series to Azure with Skytap](../example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap.yml)|Learn how to use the native IBM i backup and recovery services with Azure components.|Mainframe|

## Software AG

|Architecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe computer systems that run Adabas & Natural](../example-scenario/mainframe/refactor-adabas-aks.yml)|Learn how to modernize mainframe computer systems that run Adabas & Natural and move them to the cloud.|Mainframe|

## Stromasys

|Architecture|Summary|Technology focus|
|--|--|--|
|[Stromasys Charon-SSP Solaris emulator on Azure VMs](../solution-ideas/articles/solaris-azure.yml)|Learn how the Charon-SSP cross-platform hypervisor emulates legacy Sun SPARC systems on industry standard x86-64 computer systems and VMs.|Mainframe|

## SWIFT

|Architecture|Summary|Technology focus|
|--|--|--|
|[SWIFT\'s Alliance Access with Alliance Connect Virtual on Azure](../example-scenario/finance/swift-alliance-access-vsrx-on-azure.yml)|View a reference architecture for deploying and running SWIFT Alliance Access with Alliance Connect Virtual on Azure.|Networking|
|[SWIFT Alliance Cloud on Azure](../example-scenario/finance/swift-alliance-cloud-on-azure.yml)|Deploy Azure infrastructure for SWIFT Alliance Cloud.|Networking|
|[SWIFT Alliance Connect Virtual on Azure](../example-scenario/finance/swift-on-azure-vsrx.yml)|View a series of articles about SWIFT Alliance Connect Virtual components that can be deployed on Azure.|Security|
|[SWIFT Alliance Lite2 on Azure](../example-scenario/finance/swift-alliance-lite2-on-azure.yml)|Deploy SWIFT Alliance Lite2 on Azure. Migrate an existing deployment from on-premises or create a new deployment.|Networking|
|[SWIFT\'s AMH with Alliance Connect Virtual](../example-scenario/finance/swift-alliance-messaging-hub-vsrx.yml)|Run SWIFT AMH on Azure. Use this messaging solution with the Alliance Connect Virtual networking solution, which also runs on Azure.|Networking|

## Syncier

|Architecture|Summary|Technology focus|
|--|--|--|
|[GitOps for Azure Kubernetes Service](../example-scenario/gitops-aks/gitops-blueprint-aks.yml)|View a GitOps solution for an AKS cluster. This solution provides full audit capabilities, policy enforcement, and early feedback. Syncier Security Tower provides an overview of all AKS clusters and helps manage policies. |Containers|

## TmaxSoft

|Architecture|Summary|Technology focus|
|--|--|--|
|[Migrate IBM mainframe apps to Azure with TmaxSoft OpenFrame](../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)|Migrate IBM zSeries mainframe applications to Azure. Use a no-code approach that TmaxSoft OpenFrame provides.|Mainframe|

## Unisys

|Architecture|Summary|Technology focus|
|--|--|--|
|[Unisys ClearPath Forward mainframe rehost to Azure using Unisys virtualization](../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml)|Use virtualization technologies from Unisys and Azure to migrate from a Unisys ClearPath Forward Libra (legacy Burroughs A Series/MCP) mainframe.|Mainframe|

## Related resources

- [Apache open-source scenarios on Azure](/azure/architecture/guide/apache-scenarios)
- [Open-source scenarios on Azure](/azure/architecture/guide/open-source-scenarios)
- [Scenarios featuring Microsoft on-premises technologies](../guide/on-premises-microsoft-technologies.md)
- [Architecture for startups](../guide/startups/startup-architecture.md)
- [Azure and Power Platform scenarios](../solutions/power-platform-scenarios.md)
- [Azure and Microsoft 365 scenarios](../solutions/microsoft-365-scenarios.md)
- [Azure and Dynamics 365 scenarios](../solutions/dynamics-365-scenarios.md)
- [Azure for AWS professionals](../aws-professional/index.md)
- [Azure for Google Cloud professionals](../gcp-professional/index.md)
