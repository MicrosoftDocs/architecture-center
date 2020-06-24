---
title: DataOps for the Modern Data Warehouse 
description: How to apply DevOps principles to data pipelines built according to the Modern Data Warehouse (MDW) architectural pattern on Microsoft Azure 
author: tmmarshall
ms.date: 07/01/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---

# DataOps for the Modern Data Warehouse 

## Introduction

A modern data warehouse (MDW) lets you bring together all your data at any scale easily, whether structured, unstructured, or semi-structured data (logs, files, and media). It provides insights through analytical dashboards, operational reports, or advanced analytics for all your users.

Setting up an MDW environment both for development and production is complex. That is why automation is key for productivity and minimizing the risk of errors.

In this document, we will describe how a fictional city planning office could use this solution—which provides an end-to-end data pipeline that follows the MDW architectural pattern, along with a corresponding DevOps / DataOps processes—to assess parking utilization and make more informed business decisions.

### Business Scenario

In this scenario, Contoso city owns and manages parking sensors for the city and the APIs that enable them to connect to and get data from the sensors. They need a platform that will collect data from a variety of sources and then validate, cleanse, and transform the data to a known schema. Contoso city planners can then explore and assess report data on parking utilization with data visualization tools like Power BI to determine whether they need more parking or related resources.

![Figure 1 Street Parking Availability](./media/street-parking-availability.png)

<p style="text-align:center;font-style:italic;">Figure 1 - Street Parking Availability</p>

### Solution Requirements

* Ability to collect data from different sources or systems
* Infrastructure as Code: deploy new environments (Dev/Stage) in an automated manner
* Deploy application changes across different environments in an automated manner:
  * Implementation of Continuous Integration (CI) and Continuous Delivery (CD) pipelines
  * Use deployment gates for manual approvals
* Pipeline as Code: ensure the CI/CD pipeline definitions are source control (YAML)
* Perform integration tests on changes using a sample data set
* Run pipelines on a scheduled basis
* Support future agile development, including the enablement of data science workloads
* Support for both row-level and object-level security:  can be done through SQL Database, but is also available in SQL Data Warehouse (SQLDW), Azure Analysis Services (AAS) and Power BI
* Support for 10 concurrent dashboard users and 20 concurrent power users
* The data pipeline should perform data validation and filter out malformed records to a specified store
* Support for monitoring
* Centralized configuration in a secure storage (such as KeyVault)

## Technical Solution

### Overview

This solution builds on top of another system, which the city owns. That system collects data from the sensors underneath parking spots and exposes an API for consuming applications and systems. Our system pulls the near real-time parking data by calling that API and then saves it to Azure Data Lake Storage. It then validates, cleanses, and transforms the data to a known schema using Azure Databricks. A second Azure Databricks job then transforms the schema into a Star Schema, which is then loaded into Azure Synapse Analytics (formerly SQLDW) using Polybase. The entire pipeline is orchestrated with Azure Data Factory.

### Architecture

The following diagram shows the overall architecture of the solution.

![Figure 2 Architecture Diagram](./media/architecture-diagram.png)

<p style="text-align:center;font-style:italic;">Figure 2 - Architecture Diagram</p>

As shown in the architecture diagram, a copy of the parking data collected from the various sources is pulled into storage. The data pipeline manages the orchestration of cleaning and transforming the stored data for use by visualization tools. The visualized data is then available to city planners and data scientists.

### Technologies Used

The solution is comprised of the following Azure services:

* [Azure Data Factory (ADF)](https://azure.microsoft.com/services/data-factory/)
* [Azure Databricks](https://azure.microsoft.com/services/databricks/)
* [Azure Data Lake Storage Gen2 (ADLS)](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction)
* [Azure Synapse Analytics (formerly SQLDW)](https://azure.microsoft.com/services/synapse-analytics/)
* [Azure DevOps](https://azure.microsoft.com/services/devops/)
* [Power BI](https://powerbi.microsoft.com/)

### Solution Details

The following list contains the high-level steps required to set up the Parking Sensors solution with corresponding Build and Release Pipelines. Detailed setup steps and prerequisites can be found in [this Azure Samples repository](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#how-to-use-the-sample).

#### Setup and Deployment

1. Initial Setup. This includes ensuring all software pre-requisites are installed, importing the Azure Samples GitHub repository into your own repository, and setting required environment variables.
1. Deploy Azure resources. The solution comes with an automated deployment script, which deploys all necessary Azure resources and AAD service principals per environment, along with Azure DevOps pipelines, variable groups, and service connections.
1. Set up git integration in DEV Data Factory. Wire-up git integration with the imported GitHub repository from the previous step.
1. Perform an initial Build and Release. This includes creating a sample change in Data Factory (for example, enabling schedule trigger) then seeing the change automatically get deployed across environments.

#### Deployed Resources

If deployment is successful, there should be three resources groups in Azure representing three environments: Dev, Stage, and Production. There should also be an end-to-end Build and Release pipelines in Azure DevOps that can deploy changes across these three environments in an automated fashion.

For a detailed list of all resources, see [here](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#deployed-resources).

### Continuous Integration and Continuous Delivery (CI/CD)

The following diagram shows the overall CI/CD process end to end.

![Figure 3 CI/CD Process Diagram](./media/ci-cd-process-diagram.png)

<p style="text-align:center;font-style:italic;">Figure 3 - CI/CD Process Diagram</p>

#### Build and Release Pipeline

The diagram below demonstrates process and sequence for Build and Release.

![Figure 4 Process and Sequence for Build and Release](./media/process+sequence-for-build+release.png)

<p style="text-align:center;font-style:italic;">Figure 4 - Process and Sequence for Build and Release</p>

1. Developers develop in their own Sandbox environments within the DEV resource group and commit changes into their own short-lived git branches. (for example, `<developer_name>/<branch_name>`)
1. When changes are complete, developers raise a PR to master for review. Doing so automatically kicks-off the PR validation pipeline, which runs the unit tests, linting, and DACPAC builds.
1. On PR completion, the commit to master will trigger a Build pipeline -- publishing all necessary Build Artifacts.
1. The completion of a successful Build pipeline will trigger the first stage of the Release pipeline. Doing so deploys the publish build artifacts into the DEV environment, except for Azure Data Factory.
    1. Developers manually publish to the DEV ADF from the collaboration branch (master). This updates the ARM templates in the `adf_publish` branch.
1. The successful completion of the first stage triggers a Manual Approval Gate.
    1. On Approval, the release pipeline continues with the second stage, deploying changes to the Staging environment.
1. Integration tests are run to test changes in the Staging environment.
1. Upon successful completion of the second stage, a second Manual Approval Gate is triggered.
    1. On Approval, the release pipeline continues with the third stage, deploying changes to the Production environment.

For more information, read the CI/CD page for the parking sensor solution example on GitHub [here](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#build-and-release-pipeline).

### Testing

The solution includes support for both Unit Testing and Integration Testing. It uses pytest-adf and the Nutter Testing Framework. For more details, you can check [here](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#testing).

### Observability / Monitoring

The solution support Observability and Monitoring for Databricks and Data Factory. For more details, you can check [here](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#observability--monitoring).

## Conclusion

### Key Learnings

The following list summarizes key learnings and best practices demonstrated by this sample solution:

1. Use Data Tiering in your Data Lake.
    1. Generally, you want to divide your data lake into three major areas that contain your Bronze, Silver, and Gold datasets.
        1. *Bronze* - This is a landing area for raw datasets with minimal to no data transformation applied, and is optimized for writes or ingestion. Treat these datasets as an immutable, append-only store.
        1. *Silver* - These are cleansed, semi-processed datasets. These datasets conform to a known schema and predefined data invariants and might have further data augmentation applied. They are typically used by Data Scientists.
        1. *Gold* - These are highly processed, highly read-optimized datasets primarily for consumption of business users. Typically, they are structured in standard Fact and Dimension tables.

1. Validate data early in your pipeline.
    1. Add data validation between the Bronze and Silver datasets. Validating early in the pipeline helps ensure that all succeeding datasets conform to a specific schema and known data invariants. Early validation also potentially prevents data pipeline failures in cases of unexpected changes to the input data.
    1. Data that does not pass this validation stage can be rerouted to a Malformed Record store for diagnostic purpose.
    1. It may be tempting to add validation before landing in the Bronze area of the data lake. Doing so is not recommended. Bronze datasets are there to ensure you have as close of a copy of the source system data. This copy can be used to replay the data pipeline for both testing (testing data validation logic) and data recovery purposes (for example, data corruption is introduced due to a bug in the data transformation code, so the pipeline needs to be replayed).

1. Make your data pipelines replayable and idempotent.
    1. Silver and Gold datasets can get corrupted for several reasons such as unintended bugs, unexpected input data changes, and more. By making data pipelines replayable and idempotent, you can recover from this state through deployment of a code fix and replaying the data pipelines.
    1. Idempotency also ensures data-duplication is mitigated when replaying your data pipelines.

1. Ensure data transformation code is testable.
    1. Abstracting data transformation code from data access code is key to ensuring unit tests can be written against data transformation logic. An example of this is moving transformation code from notebooks into packages.
    1. While it is possible to run tests against notebooks, by shifting the tests left, you increase developer productivity by increasing the speed of the feedback cycle.

1. Have a CI/CD pipeline.
    1. The CI/CD pipeline includes all artifacts needed to build the data pipeline from scratch in source control. These artifacts include infrastructure-as-code files, database objects (such as schema definitions, functions, stored procedures, and so on), reference/application data, data pipeline definitions, and data validation and transformation logic.
    1. There should also be a safe, repeatable process to move changes through dev, test, and finally production.

1. Secure and centralize configuration.
    1. Maintain a central, secure location for sensitive configuration such as database connection strings that can be access by the appropriate services within the specific environment. For example, securing secrets in KeyVault per environment, then having the relevant services query KeyVault for the configuration.

1. Monitor infrastructure, pipelines, and data.
    1. A proper monitoring solution should be in place to ensure failures are identified, diagnosed, and addressed in a timely manner. Aside from the base infrastructure and pipeline runs, data should also be monitored. A common area that should have data monitoring is the malformed record store.

## Resources

### Links

#### Solution Code Samples on GitHub

* [Visit the project page on GitHub](https://github.com/Azure-Samples/modern-data-warehouse-dataops)

#### Observability and Monitoring

Azure Databricks

* [Monitoring Azure Databricks with Azure Monitor](https://docs.microsoft.com/azure/architecture/databricks-monitoring/)
* [Monitoring Azure Databricks Jobs with Application Insights](https://msdn.microsoft.com/magazine/mt846727.aspx)

Data Factory

* [Monitor Azure Data Factory with Azure Monitor](https://docs.microsoft.com/azure/data-factory/monitor-using-azure-monitor)
* [Alerting in Azure Data Factory](https://azure.microsoft.com/blog/create-alerts-to-proactively-monitor-your-data-factory-pipelines/)

Synapse Analytics

* [Monitoring resource utilization and query activity in Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-concept-resource-utilization-query-activity)
* [Monitor your Azure Synapse Analytics SQL pool workload using DMVs](https://docs.microsoft.com/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-manage-monitor)

Azure Storage

* [Monitor Azure Storage](https://docs.microsoft.com/azure/storage/common/monitor-storage?tabs=azure-powershell)

#### Resiliency and Disaster Recovery

Azure Databricks

* [Regional disaster recovery for Azure Databricks clusters](https://docs.microsoft.com/azure/azure-databricks/howto-regional-disaster-recovery)

Data Factory

* [Create and configure a self-hosted integration runtime - High availability and scalability](https://docs.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime#high-availability-and-scalability)

Synapse Analytics

* [Geo-backups and Disaster Recovery](https://docs.microsoft.com/azure/synapse-analytics/sql-data-warehouse/backup-and-restore#geo-backups-and-disaster-recovery)
* [Geo-restore for SQL Pool](https://docs.microsoft.com/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-restore-from-geo-backup)

Azure Storage

* [Disaster recovery and storage account failover](https://docs.microsoft.com/azure/storage/common/storage-disaster-recovery-guidance?toc=/azure/storage/blobs/toc.json)
* [Best practices for using Azure Data Lake Storage Gen2 – High availability and Disaster Recovery](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-best-practices#high-availability-and-disaster-recovery)
* [Azure Storage Redundancy](https://docs.microsoft.com/azure/storage/common/storage-redundancy)

#### Videos

For a detailed walk-through of the solution and key concepts, watch the following video recording: [DataDevOps for the Modern Data Warehouse on Microsoft Azure](https://www.youtube.com/watch?v=Xs1-OU5cmsw%22)
