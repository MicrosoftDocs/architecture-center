---
title: DataOps checklist
description: DataOps is a lifecycle approach to data analytics that uses agile practices to deliver high-quality data. Use this checklist to assess your DataOps process. 
author: Katie-Novotny
ms.author: katienovotny
ms.date: 01/14/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.custom:
  - checklist
  - fcp
products:
  - azure 
categories: 
- analytics
- management-and-governance
- databases
---

# DataOps checklist

DataOps is a lifecycle approach to data analytics. It uses agile practices to orchestrate tools, code, and infrastructure to quickly deliver high-quality data with improved security. When you implement and streamline DataOps processes, your business can more easily and cost effectively deliver analytical insights. This allows you to adopt advanced data techniques that can uncover insights and new opportunities. Use this checklist as a starting point to assess your DataOps process. 

## Data governance and people

**Data governance**
- A central location is used to register data sources.
- Data lineage and metadata are available.  
- Data is easily discoverable by users, and sensitive data is secured.  
- Data and security officers have sightlines into how data is being used, who has access, and where sensitive data might be located.  

**Defined, clear roles**  
- Engineers, testers, data scientists, operations, data analysts, business users, and data officers all work together and understand their roles in the project.  
- Stakeholders are identified, and you understand what's motivating stakeholders to start making data-driven decisions. 

**Use cases for data movement**
 - The use cases for streaming, interactive, and batch analytics are resolved.  
 - The various types of data for each case are clarified, and metrics are defined to motivate making data-driven decisions. 

**Data tools**
- Data tools needed to make data easier to access, share, analyze, and secure are identified or developed.

**Security and compliance**
- All resources, data in transit, and data at rest have been audited and meet company security standards.

## Development

**Pipeline design patterns**
- Data pipelines are designed for reuse and use parameterization.  
- Pipelines solve common ETL problems. 

**Centralized ingestion** 
- A centralized platform hosts pipelines for all external and internal data sources. This allows for simplified management, monitoring, security, and standardization of data movement.  
- Costs associated with handling data are also centralized. Central control can help minimize cost and maximize efficiency. 

**Centralized computations** 
- A central team defines metrics and determines how to compute those metrics. This allows for consistency across the organization and limits confusion about where to make updates to computations. It also creates one source for metrics definitions, governance, testing, and quality controls. 

**Data abstraction** 
- Reporting uses a data abstraction layer. This allows the use of consistent business terminology, a simplified view of data, and minimal effect on data consumers when new versions of the data are made available. 

**Source control** 
- Data-related infrastructure, database schemas and procedures, ETL processes, and reports are treated as code and managed in a repository.  
- All changes are deployed and tested via a Development, Testing, Acceptance, and Production (DTAP) stack. 

## Testing and release

**DTAP environments**
- Non-production environments that mimic the production environment are available.
- Builds and deployments are run and tested on the non-production environment before a production push.  
- Developers can deliver reproducible results in all environments. 

**Testing** 
- Unit, end-to-end, and regression tests run at a specified frequency and interval.
- All tests are in source control and run as part of a build and deploy process.  
- Post-deployment end-user input is welcome and incorporated into testing as appropriate. 

**Build and deploy process**
 - A gated process deploys changes to the production environment.  
 - Changes are tested in the development and test environments. Changes are certified before they go to production. This process is as automated as possible. 

## Monitoring

**Alerting and remediation** 
- Operations is alerted to any errors. 
- You can respond to feedback quickly and have a process for quickly addressing issues as they arise.  
- Pipelines are observable. 

**Efficiency**
- Data movement is efficient. 
- Infrastructure can be scaled to meet volume and velocity needs.  
- Data is reusable whenever possible. 

**Statistical process control (SPC)** 
- SPC is used to monitor and control the data pipelines.  
- You can use the outputs of pipelines to determine the next step in the data flow.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Katie Novotny](https://www.linkedin.com/in/katie-novotny/) | Senior Specialist GBB
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*  

## Next steps

- [Organize data operations team members](/azure/cloud-adoption-framework/scenarios/data-management/organize)
- [DevOps automation for data management and analytics in Azure](/azure/cloud-adoption-framework/scenarios/data-management/organize-data-operations)
- [Smart data pipelines to Azure: Ingesting and migrating data the DataOps way](/shows/ask-the-expert/ask-the-expert-smart-data-pipelines-to-azure-ingesting-and-migrating-data-the-dataops-way)

## Related resources

  - [DataOps for the modern data warehouse](/azure/architecture/example-scenario/data-warehouse/dataops-mdw)
  - [Team Data Science Process for DevOps](/azure/architecture/data-science-process/team-data-science-process-for-devops)
