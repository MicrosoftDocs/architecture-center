[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This example shows how you can modernize your legacy systems that cannot support new processes and provide better user experience.

## Potential use cases

Out-of-box or custom connectors can help simplify process automation and connect to 3rd party data sources or legacy systems. Azure Functions can then schedule calculations on a scheduled basis to simplify your business processes. Power Apps can be used to process and share data with third parties via standard exports.

## Architecture

![Architecture Diagram](../media/lob.png)

### Data flow

The data flows through the solution as follows:

1. Supplier data stored in CDS is moved to SQL via Data Factory.
2. Purchase order (PO) data stored in ERP system is sent to Azure SQL database.
3. Azure Functions uses API to surface PO data monthly and creates a task for user to review.
4. Power Apps retrieves data from Azure SQL Database through API.
5. User reviews and updates POs in Power Apps and sends this data to suppliers through CSV export.
6. Power BI reports trends in supplier status.

### Components

Data is loaded from these different data sources using several Azure components:

- [Power Apps](https://powerapps.microsoft.com): Increase agility across your organization by rapidly building low-code apps that modernize processes and solve tough challenges.
- [Azure Functions](https://azure.microsoft.com/services/functions): Accelerate and simplify application development with serverless compute
- [Azure API management](https://azure.microsoft.com/services/api-management): Hybrid, multi-cloud management platform for APIs across all environments
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database): Build apps that scale with the pace of your business with managed and intelligent SQL in the cloud
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory): Hybrid data integration service that simplifies ETL at scale
- [Power BI](/power-bi): a suite of business analytics tools to analyze data and share insights. Power BI can query a semantic model stored in Analysis Services, or it can query Azure Synapse directly.

## Next steps

- Learn more: [https://aka.ms/learnpowerapps](/learn/browse/?products=power-apps)
