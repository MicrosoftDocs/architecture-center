[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to modernize legacy systems that can't support new processes. This modernization enhances the user experience.

## Architecture

:::image type="complex" border="false" source="../media/lob.svg" alt-text="Diagram that shows the Line of Business Extension architecture." lightbox="../media/lob.svg":::
   The Line of Business Extension architecture shows data from Microsoft Dataverse to SQL via Azure Data Factory and from ERP to SQL. Power Apps gets data and sends data via CSV. Power BI shows trends.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/lob.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Supplier data that's stored in [Microsoft Dataverse](/power-apps/maker/data-platform/data-platform-intro) is moved to Azure SQL Database via Azure Data Factory.

1. Purchase order (PO) data that's stored in the ERP system is sent to SQL Database.

1. Azure API Management exposes an Azure function to the Microsoft Power Platform.

1. Microsoft Power Apps retrieves data from SQL Database via the Azure function that API Management exposes.

1. The user reviews and updates POs in Power Apps and then sends this data to suppliers through CSV exports.

1. Power BI reports trends in supplier status.

### Components

Data is loaded from these different data sources by using the following Azure components:

- [Power Apps](/power-apps/) can help you increase agility across your organization by rapidly building low-code apps that modernize processes and solve problems. In this architecture, Power Apps is the application development technology that provides the user interface for the solution.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) can help you accelerate and simplify application development with serverless compute. The Azure function hosts the custom code that performs the lookup and retrieval of data from the SQL Database.

- [API Management](/azure/api-management/api-management-key-concepts) is a hybrid, multicloud management platform for APIs across all environments. In this architecture, the Power App interfaces with this service. It provides gateway offloading of security, monitoring, and control.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) lets you build apps that scale with the pace of your business with managed and intelligent SQL in the cloud. Data from the ERP system and the supplier data from Dataverse is stored here for easy access.

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a hybrid data integration service that simplifies extract, transform, and load process at scale. Azure Data Factory is used to move and transform data from Dataverse to SQL Database.

- [Power BI](/power-bi) is a suite of business analytics tools that you can use to analyze data and share insights. Power BI can query a semantic model that's stored in Microsoft Analysis Services, or it can query Azure Synapse directly. Power BI is used to deliver interactive reports and dashboards to users.

## Scenario details

Out-of-the-box or custom connectors can help simplify process automation and connect to non-Microsoft data sources or legacy systems. Azure Functions can then schedule calculations regularly to simplify your business processes. You can use Power Apps to process and share data with non-Microsoft parties via standard exports.

### Potential use cases

You can use this solution in the following scenarios:

- You have legacy systems that can't be modernized or can't support new processes.
- You need to automate the connection of non-Microsoft data sources to Azure.

## Next step

- [Training for Power Apps - Microsoft Learn](/training/browse/?products=power-apps)

## Related resource

- [Custom business processes](../../integration/integration-start-here.yml)
