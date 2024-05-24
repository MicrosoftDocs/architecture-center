---
title: Azure Data Factory baseline architecture
titleSuffix: Azure Architecture Center
description: Learn how to deploy a reference architecture for Azure Data Factory on Azure landing zones.
author: claytonsiemens77
ms.author: csiemens
ms.date: 12/31/2023
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
azureCategories:
  - data-services
  - storage
  - networking
  - security
products:
  - azure-data-factory
  - azure-key-vault
  - azure-databricks
  - azure-sql-server
---

# Medallion lakehouse with Data Factory

The [medallion lakehouse](/azure/databricks/lakehouse/medallion) architecture is a popular enterprise data design pattern. It logically organizes raw data in its native form, within a large, centralized repository. Data is then incrementally enriched as it flows through each layer of the architecture, improving the structure, quality, and insight that can be derived from it. 

[Azure Data Factory](/azure/data-factory) is Azure's platform-as-a-service (PaaS) solution for scale-out serverless data integration and data transformation. Within the medallion lakehouse, it performs the (ETL) extraction, transformation, and loading processes required across the various components to generate value from the raw data source.  

This series of designs follows a typical path for an enterprise implementation from an initial implementation, followed by enterprise-wide adoption, and finally mission-critical expansion for specific solutions. This guidance is intended to support customers starting a similar journey. 

## Get started

If you are embarking on your journey with the Medallion Lakehouse architecture, start with these training modules on the [Learn platform](https://learn.microsoft.com). 

- [Azure Data Factory](https://learn.microsoft.com/training/paths/data-integration-scale-azure-data-factory) for data ingestion 
- [Azure Databricks](https://learn.microsoft.com/training/paths/data-engineer-azure-databricks) for data processing at scale 
- [Azure SQL Server](https://learn.microsoft.com/training/paths/azure-sql-fundamentals) for data modelling  
- [Power BI](https://learn.microsoft.com/credentials/certifications/power-bi-data-analyst-associate) for serving and reporting 

Learn how to design and build secure, scalable, high-performing solutions in Azure using the pillars of the Microsoft Azure [Well-Architected Framework](https://learn.microsoft.com/training/paths/azure-well-architected-framework).  

This free online resource provides interactive training that includes knowledge checks to evaluate your learning. 

For product documentation; 

- [Azure Data Factory](/azure/data-factory/) 
- [Azure Databricks](/azure/databricks/) 
- [Azure SQL Server](/azure/azure-sql/) 
- [Power BI](https://learn.microsoft.com/power-bi/)

## Baseline implementation

Now that you have a solid understanding of deploying Azure Data Factory for data ingestion, Azure Databricks for developing your [Medallion Architecture](/azure/databricks/lakehouse/medallion) for data processing, and serving that data to Power BI using Azure SQL as the persisted store, apply your skills in designing a simple solution, establishing the solution using an on-premises data source.  

Refer to the baseline architecture that deploys Azure Data Factory instances for data ingestion, Azure Databricks for data processing, and Azure SQL for storing the processed data, all within a single region with zone redundancy.  

> [!div class="nextstepaction"] 
> [Reference architecture: Medallion Lakehouse with Data Factory baseline implementation](./azure-data-factory-on-azure-landing-zones-baseline.yml)

## Enterprise Adoption and Hardening 

In order to comply with common enterprise security and governance nonfunctional requirements, the baseline architecture should be expanded upon for production workloads using enterprise hardening patterns. An example of a NFR might be that the solution is required to use federated resources managed by central teams. Effective communication of your requirements with those teams is crucial to avoid disruptions. 

Refer to this architecture that deploys an enterprise hardened implementation, extending the ["Hub and spoke"](/azure/architecture/networking/architecture/hub-spoke-vwan-architecture) topology according to the principles of [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/).  

Some sample requirements that should be communicated with central teams are annotated with "Platform team" notes. 

> [!div class="nextstepaction"] 
> [Reference architecture: Enterprise Hardened Lakehouse with Data Factory](./azure-data-factory-on-azure-landing-zones-enterprise-hardening.yml)


## Mission Critical Uplift

The last step in this path is expanding an individual solution’s infrastructure and processes to support a mission-critical SLA. [Mission-critical](/azure/well-architected/mission-critical/mission-critical-overview) is used to describe solutions that have either business-critical or safety-critical impacts when they are unavailable or underperforming.  

The Solution must be highly-available, responsive to operational issues, have a consistent level of performance, and be highly secure. Mision-critical architectures must balance performance and resiliency requirements and targets with cost optimization.  

> [!div class="nextstepaction"] 
> [Reference architecture: Mission Critical with Data Factory](./azure-data-factory-on-azure-landing-zones-mission-critical.yml)

## Contributors
*Microsoft maintains this article. The following contributors originally wrote it.*

Principal authors:

- [Leo Kozhushnik](https://www.linkedin.com/in/leo-kozhushnik-ab16707/) | Cloud Solution Architect
- [Darren Turchiarelli](https://www.linkedin.com/in/darren-turchiarelli/) | Cloud Solution Architect
- [Scott Mckinnon](https://www.linkedin.com/in/scott-mckinnon-96756a83) | Cloud Solution Architect
- [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore/) | Cloud Solution Architect

Other contributors:

- [Justice Zisanhi](https://www.linkedin.com/in/justice-zisanhi/) | Cloud Solution Architect

  
*To see non-public LinkedIn profiles, sign into LinkedIn.*


## Related links

- [Azure Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/) 
- [Medallion Lakehouse Architecture](/azure/databricks/lakehouse/medallion) 
- [Azure Reference Architecture](/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture)
- [Azure Well-Architected Framework](/azure/well-architected/) 
- [Azure Mission-Critical Guidance](/azure/well-architected/mission-critical/mission-critical-overview) 
