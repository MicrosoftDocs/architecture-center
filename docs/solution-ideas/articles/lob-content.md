[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This example shows how you can modernize your legacy systems that can't support new processes, therefore providing a better user experience.

## Architecture

![Architecture shows data from CDS to SQL via Data Factory and from ERP to SQL. Power Apps gets data, sends via CSV, Power BI shows trends.](../media/lob.png)

*Download a [Visio file](https://arch-center.azureedge.net/lob.vsdx) of this architecture.*

### Dataflow

The data flows through the solution as follows:

1. Supplier data stored in [Common Data Services (CDS)](https://learn.microsoft.com/en-us/business-applications-release-notes/april18/common-data-service-apps/) is moved to SQL via Data Factory.
1. Purchase order (PO) data stored in ERP system is sent to Azure SQL database.
1. Azure API Management is used to expose an Azure function to the Power Platform.
1. Power Apps retrieves data from Azure SQL Database through the Azure Function being exposed by Azure API Management.
1. User reviews and updates POs in Power Apps and sends this data to suppliers through CSV exports.
1. Power BI reports trends in supplier status.

### Components

Data is loaded from these different data sources using several Azure components:

- [Power Apps](/power-apps/): Increase agility across your organization by rapidly building low-code apps that modernize processes and solve tough challenges. In this architecture, this is the application development technology that provides the user interface for the solution.
- [Azure Functions](https://azure.microsoft.com/services/functions): Accelerate and simplify application development with serverless compute. The Azure function hosts the custom code that performs lookup and retrieval of data from the Azure SQL Database.
- [Azure API management](/azure/api-management/api-management-key-concepts): Hybrid, multicloud management platform for APIs across all environments.  In this architecture, The Power App interfaces with this this service which provides gateway offloading of security, monitoring, and control.
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database): Build apps that scale with the pace of your business with managed and intelligent SQL in the cloud. Data from the ERP system and the supplier data from CDS is stored here for easy access.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory): Hybrid data integration service that simplifies ETL at scale. Azure data factory is used to move and transform data from CDS to Azure SQL Database.
- [Power BI](/power-bi): a suite of business analytics tools to analyze data and share insights. Power BI can query a semantic model stored in Analysis Services, or it can query Azure Synapse directly.  Power BI is used to deliver interactive reports and dashboards to the users.

## Scenario details

Out-of-the-box or custom connectors can help simplify process automation and connect to third party data sources or legacy systems. Azure Functions can then schedule calculations on a scheduled basis to simplify your business processes. You can use Power Apps to process and share data with third parties via standard exports.

## Potential use cases

You can use this solution in scenarios like the following:

- You have legacy systems that can't be modernized or can't support new processes
- You need to automate connecting third-party data sources to Azure

## Next steps

- Learn more: [https://aka.ms/learnpowerapps](/training/browse/?products=power-apps)

## Related resources

- [Custom business processes](../../solution-ideas/articles/custom-business-processes.yml)
