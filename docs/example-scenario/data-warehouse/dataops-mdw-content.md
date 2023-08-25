This article describes how a fictional city planning office could use this solution. The solution provides an end-to-end data pipeline that follows the MDW architectural pattern, along with corresponding DevOps and DataOps processes, to assess parking use and make more informed business decisions.

## Architecture

The following diagram shows the overall architecture of the solution.

:::image type="content" source="./media/architecture-diagram-demonstrating-dataops-for-the-modern-data-warehouse.svg" lightbox="./media/architecture-diagram-demonstrating-dataops-for-the-modern-data-warehouse.svg" alt-text="Architecture diagram demonstrating DataOps for the modern data warehouse." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/architecture-diagram-demonstrating-dataops-for-the-modern-data-warehouse.vsdx) of this architecture.*

### Dataflow

Azure Data Factory (ADF) orchestrates and Azure Data Lake Storage (ADLS) Gen2 stores the data:

1. The Contoso city parking web service API is available to transfer data from the parking spots.

1. There's an ADF copy job that transfers the data into the Landing schema.

1. Next, Azure Databricks cleanses and standardizes the data. It takes the raw data and conditions it so data scientists can use it.

1. If validation reveals any bad data, it gets dumped into the Malformed schema.

    > [!IMPORTANT]
    > People have asked why the data isn't validated before it's stored in ADLS. The reason is that the validation might introduce a bug that could corrupt the dataset. If you introduce a bug at this step, you can fix the bug and replay your pipeline. If you dumped the bad data before you added it to ADLS, then the corrupted data is useless because you can't replay your pipeline.

1. There's a second Azure Databricks transform step that converts the data into a format that you can store in the data warehouse.

1. Finally, the pipeline serves the data in two different ways:

    1. Databricks makes the data available to the data scientist so they can train models.

    1. Polybase moves the data from the data lake to Azure Synapse Analytics and Power BI accesses the data and presents it to the business user.

### Components

The solution uses these components:

* [Azure Data Factory (ADF)](https://azure.microsoft.com/services/data-factory)

* [Azure Databricks](https://azure.microsoft.com/services/databricks)

* [Azure Data Lake Storage (ADLS) Gen2](/azure/storage/blobs/data-lake-storage-introduction)

* [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)

* [Azure Key Vault](https://azure.microsoft.com/services/key-vault)

* [Azure DevOps](https://azure.microsoft.com/services/devops)

* [Power BI](https://powerbi.microsoft.com)

## Scenario details

A modern data warehouse (MDW) lets you easily bring all of your data together at any scale. It doesn't matter if it's  structured, unstructured, or semi-structured data. You can gain insights to an MDW through analytical dashboards, operational reports, or advanced analytics for all your users.

Setting up an MDW environment for both development (dev) and production (prod) environments is complex. Automating the process is key. It helps increase productivity while minimizing the risk of errors.

This article describes how a fictional city planning office could use this solution. The solution provides an end-to-end data pipeline that follows the MDW architectural pattern, along with corresponding DevOps and DataOps processes, to assess parking use and make more informed business decisions.

### Solution requirements

* Ability to collect data from different sources or systems.

* Infrastructure as code: deploy new dev and staging (stg) environments in an automated manner.

* Deploy application changes across different environments in an automated manner:

  * Implement Continuous Integration/Continuous Delivery (CI/CD) pipelines.

  * Use deployment gates for manual approvals.

* Pipeline as Code: ensure the CI/CD pipeline definitions are in source control.

* Carry out integration tests on changes using a sample data set.

* Run pipelines on a scheduled basis.

* Support future agile development, including the addition of data science workloads.

* Support for both row-level and object-level security:

  * The security feature is available in SQL Database.

  * You can also find it in Azure Synapse Analytics, Azure Analysis Services (AAS) and Power BI.

* Support for 10 concurrent dashboard users and 20 concurrent power users.

* The data pipeline should carry out data validation and filter out malformed records to a specified store.

* Support monitoring.

* Centralized configuration in a secure storage like Azure Key Vault.

### Potential use cases

This article uses the fictional city of Contoso to describe the use case scenario. In the narrative, Contoso owns and manages parking sensors for the city. It also owns the APIs that connect to and get data from the sensors. They need a platform that will collect data from many different sources. The data then must be validated, cleansed, and transformed to a known schema. Contoso city planners can then explore and assess report data on parking use with data visualization tools, like Power BI, to determine whether they need more parking or related resources.

[![Street Parking Availability](./media/street-parking-availability.png)](./media/street-parking-availability.png#lightbox)

## Considerations

The following list summarizes key learnings and best practices demonstrated by this solution:

> [!NOTE]
> Each item in the list below links out to the related **Key Learnings** section in the docs for the parking sensor solution example on GitHub.

* [Use Data Tiering in your Data Lake](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#1-use-data-tiering-in-your-data-lake).

* [Validate data early in your pipeline](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#2-validate-data-early-in-your-pipeline).

* [Make your data pipelines replayable and idempotent](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#3-make-your-data-pipelines-replayable-and-idempotent).

* [Ensure data transformation code is testable](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#4-ensure-data-transformation-code-is-testable).

* [Have a CI/CD pipeline](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#5-have-a-cicd-pipeline).

* [Secure and centralize configuration](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#6-secure-and-centralize-configuration).

* [Monitor infrastructure, pipelines, and data](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#7-monitor-infrastructure-pipelines-and-data).

## Deploy this scenario

The following list contains the high-level steps required to set up the Parking Sensors solution with corresponding Build and Release Pipelines. You can find detailed setup steps and prerequisites in this [Azure Samples repository](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#how-to-use-the-sample).

### Setup and deployment

1. **Initial setup**: Install any prerequisites, import the Azure Samples GitHub repository into your own repository, and set required environment variables.
1. **Deploy Azure resources**: The solution comes with an automated deployment script. It deploys all necessary Azure resources and Microsoft Azure Active Directory service principals per environment. The script also deploys Azure Pipelines, variable groups, and service connections.
1. **Set up git integration in dev Data Factory**: Configure git integration to work with the imported GitHub repository.

1. **Carry out an initial build and release**: Create a sample change in Data Factory, like enabling a schedule trigger, then watch the change automatically deploy across environments.

### Deployed resources

If deployment is successful, there should be three resources groups in Azure representing three environments: dev, stg, and prod. There should also be end-to-end build and release pipelines in Azure DevOps that can automatically deploy changes across these three environments.

For a detailed list of all resources, see the [Deployed Resources](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#deployed-resources) section of the **DataOps - Parking Sensor Demo** README.

### Continuous integration and continuous delivery

The diagram below demonstrates the CI/CD process and sequence for the build and release pipelines.

:::image type="content" source="./media/ci-cd-process-diagram-new.svg" lightbox="./media/ci-cd-process-diagram-new.svg" alt-text="Diagram that shows the process and sequence for build and release." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ci-cd-process-diagram.vsdx) of this architecture.*

1. Developers develop in their own sandbox environments within the dev resource group and commit changes into their own short-lived git branches. For example, `<developer_name>/<branch_name>`.

1. When changes are complete, developers raise a pull request (PR) to the main branch for review. Doing so automatically kicks-off the PR validation pipeline, which runs the unit tests, linting, and data-tier application package (DACPAC) builds.

1. On completion of the PR validation, the commit to main will trigger a build pipeline that publishes all necessary build artifacts.

1. The completion of a successful build pipeline will trigger the first stage of the release pipeline. Doing so deploys the publish build artifacts into the dev environment, except for ADF.

    Developers manually publish to the dev ADF from the collaboration branch (main). The manual publishing updates the Azure Resource Manager (ARM) templates in the `adf_publish` branch.

1. The successful completion of the first stage triggers a manual approval gate.

    On Approval, the release pipeline continues with the second stage, deploying changes to the stg environment.

1. Run integration tests to test changes in the stg environment.

1. Upon successful completion of the second stage, the pipeline triggers a second manual approval gate.

    On Approval, the release pipeline continues with the third stage, deploying changes to the prod environment.

For more information, read the [Build and Release Pipeline](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#build-and-release-pipeline) section of the README.

### Testing

The solution includes support for both unit testing and integration testing. It uses pytest-adf and the Nutter Testing Framework. For more information, see the [Testing](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#testing) section of the README.

### Observability and monitoring

The solution supports observability and monitoring for Databricks and Data Factory. For more information, see the [Observability/Monitoring](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#observability--monitoring) section of the README.

## Next steps

If you'd like to deploy the solution, follow the steps in the [How to use the sample](https://github.com/Azure-Samples/modern-data-warehouse-dataops/tree/master/e2e_samples/parking_sensors#how-to-use-the-sample) section of the **DataOps - Parking Sensor Demo** README.

### Solution code samples on GitHub

* [Visit the project page on GitHub](https://github.com/Azure-Samples/modern-data-warehouse-dataops)

### Observability/monitoring

Azure Databricks

* [Monitoring Azure Databricks with Azure Monitor](../../databricks-monitoring/index.md)
* [Monitoring Azure Databricks Jobs with Application Insights](/archive/msdn-magazine/2018/june/azure-databricks-monitoring-azure-databricks-jobs-with-application-insights)

Data Factory

* [Monitor Azure Data Factory with Azure Monitor](/azure/data-factory/monitor-using-azure-monitor)
* [Create alerts to proactively monitor your data factory pipelines](https://azure.microsoft.com/blog/create-alerts-to-proactively-monitor-your-data-factory-pipelines)

Synapse Analytics

* [Monitoring resource utilization and query activity in Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-concept-resource-utilization-query-activity)
* [Monitor your Azure Synapse Analytics SQL pool workload using DMVs](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-manage-monitor)

Azure Storage

* [Monitor Azure Storage](/azure/storage/common/monitor-storage?tabs=azure-powershell)

### Resiliency and disaster recovery

Azure Databricks

* [Regional disaster recovery for Azure Databricks clusters](/azure/azure-databricks/howto-regional-disaster-recovery)

Data Factory

* [Create and configure a self-hosted integration runtime - High availability and scalability](/azure/data-factory/create-self-hosted-integration-runtime#high-availability-and-scalability)

Synapse Analytics

* [Geo-backups and Disaster Recovery](/azure/synapse-analytics/sql-data-warehouse/backup-and-restore#geo-backups-and-disaster-recovery)
* [Geo-restore for SQL Pool](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-restore-from-geo-backup)

Azure Storage

* [Disaster recovery and storage account failover](/azure/storage/common/storage-disaster-recovery-guidance?toc=/azure/storage/blobs/toc.json)
* [Best practices for using Azure Data Lake Storage Gen2 – High availability and Disaster Recovery](/azure/storage/blobs/data-lake-storage-best-practices#high-availability-and-disaster-recovery)
* [Azure Storage Redundancy](/azure/storage/common/storage-redundancy)

### Detailed walkthrough

For a detailed walk-through of the solution and key concepts, watch the following video recording: [DataDevOps for the Modern Data Warehouse on Microsoft Azure](https://www.youtube.com/watch?v=Xs1-OU5cmsw%22)

## Related resources

- [Monitoring Azure Databricks with Azure Monitor](../../databricks-monitoring/index.md)
- [Master data management with Profisee and Azure Data Factory](../../reference-architectures/data/profisee-master-data-management-data-factory.yml)
- [Hybrid ETL with Azure Data Factory](../../example-scenario/data/hybrid-etl-with-adf.yml)
- [DevTest and DevOps for PaaS solutions](../../solution-ideas/articles/dev-test-paas.yml)
