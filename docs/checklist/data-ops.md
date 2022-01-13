---
title: DataOps checklist
titleSuffix: Azure Design Review Framework
description: DataOps is a life-cycle approach to data analytics that uses agile practices to deliver high-quality data. Use this checklist as a starting point to assess your DataOps process. 
author: Katie-Novotny
ms.date: 01/18/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - checklist
---
# DataOps Checklist

DataOps is a life-cycle approach to data analytics that uses agile practices to orchestrate tools, code, and infrastructure in order to quickly and securely deliver high-quality data.  As DataOps processes are implemented and streamlined, businesses can more easily and cost effectively deliver analytical insights; this allows business to adopt advanced data techniques which can uncover insights and find new opportunities.  Use this checklist as a starting point to assess your DataOps process. 

## Data Governance and People
**Data Governance**: Central location to register data sources; data lineage and metadata also available.  Data is easily discoverable by users and sensitive data is secured.  Data and security officers have sightlines into how data is being used, who has access, and where sensitive data might lie.  

**Roles: Roles are defined and clear**.  DataOps is a team sport; engineers, testers, data scientists, operations, data analysts, business users, data officers must all work together and understand their role in the project.  Stakeholders should be identified and there should be an understanding of what is motivating stakeholders to start making data driven decisions. 

**Use Cases for Data Movement**: The use cases for streaming, interactive, and batch analytics have been resolved.  The different types of data for each case have been clarified and there are metrics defined motivate making data-driven decisions. 

**Data Tools**: Data tools needed to make data easier to access, share, analyze, and secure have been identified or developed.

**Security and Compliance**: All resources, data in transit, and data at rest have been audited and meet company security standards.

## Development
**Pipeline Design Patterns**: Data pipelines have been designed for reuse and make use of parameterization.  Pipelines solve common ETL problems. 

**Centralized Ingestion**: Centralized platform that hosts pipelines for all external and internal data sources.  This allows for simplified management, monitoring, security, and standardization of data movement.  Costs associated with handling data will also be centralized and central control can help processes can be put in place to minimize cost and maximize efficiency. 

**Centralized Computations**: Central team defines metrics and determines how to compute those metrics.  This allows for consistency across the organization and limits confusion about where updates to computations are to be made.  This creates one source for metrics definitions, governance, testing and quality controls. 

**Data Abstraction**: Reporting makes use of a data abstraction layer.  This allows for the use of consistent business terminology, a simplified view of the data, and for minimal impact to data consumers when new versions of the data are made available. 

**Source Control**: Data related infrastructure, database schemas and procedures, ETL processes, reports, are treated as code and managed in a repository.  All changes are deployed and tested up a DTaP stack. 

## Testing and Release
**DTaP Environments**: There are non-Production environments available which mimic the Production environment.  Builds and deployments are run and tested on the non-Production environment before a Production push.  Devs are able to deliver reproducible results in all environments. 

**Testing**: Unit, end-to-end, and regression tests are run at a specified frequency and interval.  All tests are in source control and run as part of a build and deploy process.  Post deployment end-user input is welcome and will be incorporated into future testing as appropriate. 

**Build and Deploy Process**: There is a gated process to deploy changes to the Production environment.  Changes are tested in the DT environments; there is a certification process before any changes can go to Production.  This process is as automated as possible. 

## Monitoring
**Alerting and Remediation**: Operations is alerted to any errors; there is the ability to respond to feedback rapidly and a process for rapidly addressing issues as they arise.  Pipelines are observable. 

**Efficiency**: Data movement is efficient; infrastructure can be scaled to meet volume and velocity needs.  Data is reusable wherever possible. 

**Statistical Process Control**: SPC is used to monitor and control the data pipelines.  Outputs of pipelines can be used to determine next step in the data flow.   

## Related resources

  - [Organize Data Operations Team Members](/azure/cloud-adoption-framework/scenarios/data-management/organize)
  - [DataOps for the Modern Data Warehouse](/azure/architecture/example-scenario/data-warehouse/dataops-mdw)
  - [Team Data Science Process for DevOps](/azure/architecture/data-science-process/team-data-science-process-for-devops)
