[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes how to build and deploy a machine-learning model that recommends actions to maximize the purchase rate of leads targeted by a campaign.

## Architecture

![Architecture diagram that shows you how to develop and deploy models on a Data Science VM with R.](../media/campaign-optimization-with-sql-server.svg)

*Download a [Visio file](https://arch-center.azureedge.net/campaign-optimization-with-sql-server.vsdx) of this architecture.*

### Dataflow

This architecture includes the following services:

* [SQL Server Machine Learning Services](/sql/machine-learning/r/sql-server-r-services) is used for compute. Solutions are deployed to SQL Server 2016 by embedding calls to R in stored procedures.

* [SQL Server Integration Services](/sql/integration-services/sql-server-integration-services?view=sql-server-ver15) and [SQL Server Agent](/sql/ssms/agent/sql-server-agent?view=sql-server-ver15) can be used to automate these solutions.

* [Power BI](/power-bi/fundamentals/power-bi-overview) helps drive better decision making with data visualization. Visualizations help gain deeper data insight.

### Components

- [SQL Server](https://www.microsoft.com/sql-server)
- [Power BI](https://powerbi.microsoft.com)

## Scenario details

The ideas discussed in this article can be used in many industries, including retail, services, and finance.

### Potential use cases

When businesses launch a marketing campaign to attract customers to new or existing products, they often use a set of business rules to select leads for their campaign to target. Machine learning can be used to help increase the response rate from these leads.

For example, a machine-learning model can be used to predict actions that are expected to maximize the purchase rate of leads that are targeted by the campaign. The predictions then serve as the basis for recommendations to be used by a renewed campaign. Recommendations can be about *how* to contact the targeted leads, for example, with e-mail, SMS, or a cold call. Recommendations can be about *when* to contact targeted leads, for example, day of week and time of day.

### Business manager perspective

This solution template uses (simulated) historical data to predict how and when to contact leads for your campaign. The recommendations include the best channel to contact a lead (in our example, email, SMS, or cold call), the best day of the week, and the best time of day in which to make the contact.

SQL Server Machine Learning Services, which was previously called R Services, brings the compute to the data by allowing R to run on the same computer as the database. It includes a database service that runs outside'the SQL Server process and communicates securely with the R runtime.

This solution packet shows how to create and refine data, train R models, and perform predictions on the SQL Server machine. The final predictions table in SQL Server provides recommendations for how and when to contact each lead. This data is then visualized in Power BI.

Power BI also presents visual summaries of the effectiveness of the campaign recommendations (shown here with simulated data). You can try out this dashboard by clicking the Try it Now link.

The Recommendations tab of this dashboard shows the predicted recommendations. At the top is a table of individual leads for our new deployment. This table includes fields for the lead ID, campaign, and product, which are populated with leads that are applied to our business rules. This information is followed by the model predictions for the leads, giving the optimal channel and time to contact each one, and then the estimated probabilities that the leads will buy our product, by using these recommendations. These probabilities can be used to increase the efficiency of the campaign by limiting the number of leads contacted to the subset that is most likely to buy.

Also on the Recommendations tab are various summaries of recommendations and demographic information on the leads.

The Campaign Summary tab of the dashboard shows summaries of the historical data used to create the predicted recommendations. While this tab also shows values of Day of Week, Time of Day, and Channel, these values are actual past observations, not to be confused with the recommendations shown on the Recommendations tab.

### Data scientist perspective

Two roles in this solution idea are:

- **Business manager role**. Power BI can be used to present visual summaries of the effectiveness of the campaign recommendations. Power BI dashboards can be used by business managers or others who are making decisions, based on the predicted recommendations.

- **Data scientist role**. Data scientists can test and develop solutions from the convenience of their R IDE on their client machines while [pushing the compute to the SQL Server machine](/sql/advanced-analytics/r/getting-started-with-sql-server-r-services). The completed solutions are deployed to SQL Server 2016 by embedding calls to R in stored procedures. These solutions can then be further automated with SQL Server Integration Services and SQL Server agent.

## Deploy this scenario

The AI Gallery [campaign optimization with SQL Server solution](https://gallery.azure.ai/Solution/Campaign-Optimization-with-SQL-Server) implements this solution idea with [SQL Server 2016 R Services](/sql/machine-learning/r/sql-server-r-services) and [Power BI](https://powerbi.microsoft.com/what-is-power-bi) as an interactive visualization tool. The gallery solution uses simulated data, which can easily be configured to use custom data, to model the acquisition campaign response. The model uses predictors such as demographics, historical campaign performance, and product details. The solution predicts the probability of a lead conversion from each channel, at various times of the day and days of the week, for every lead in the database. The final recommendation for targeting each lead is decided based upon the combination of channel, day of week and time of day with the highest probability of conversion. The solution has been modeled after a standardized data science process, where the data preparation, model training and evaluation can be easily done by a data scientist and the insights visualized and correlated to KPIs by marketing via Power BI visualization.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Prabhjot Kaur](https://www.linkedin.com/in/kaur-profile) | Senior Cloud Solution Architect

## Next steps

Read product documentation:

- [SQL Server Machine Learning Services](/sql/machine-learning/r/sql-server-r-services)
- [SQL Server Integration Services](/sql/integration-services/sql-server-integration-services?view=sql-server-ver15)
- [SQL Server Agent](/sql/ssms/agent/sql-server-agent?view=sql-server-ver15)
- [SQL Server Machine Learning Services with R](/sql/machine-learning/sql-server-machine-learning-services?view=sql-server-ver15)
- [Install on Windows - SQL Server Machine Learning Services](/sql/machine-learning/install/sql-machine-learning-services-windows-install?view=sql-server-ver15)
- [What is Power BI](https://powerbi.microsoft.com/what-is-power-bi)
- [What is MicrosoftML?](/machine-learning-server/r/concept-what-is-the-microsoftml-package) - used inside SQL Server Machine Learning Services.

Try out some code:

- [Campaign optimization solution](https://gallery.azure.ai/Solution/Campaign-Optimization-with-SQL-Server) in the Azure AI Gallery
- [R tutorials for SQL machine learning](/sql/machine-learning/tutorials/r-tutorials)

## Related resources

* [Extract, transform, and load (ETL)](/azure/architecture/data-guide/relational-data/etl)
* [Hybrid ETL with Azure Data Factory](/azure/architecture/example-scenario/data/hybrid-etl-with-adf)
* [Enterprise business intelligence](/azure/architecture/reference-architectures/data/enterprise-bi-synapse)
* [Modern data warehouse for small and medium business](/azure/architecture/example-scenario/data/small-medium-data-warehouse)
* [Migrate master data services to Azure with CluedIn and Azure Purview](/azure/architecture/reference-architectures/data/migrate-master-data-services-with-cluedin)
* [Modernize mainframe and midrange data](/azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure)
* [Replicate and sync mainframe data in Azure](/azure/architecture/reference-architectures/migration/sync-mainframe-data-with-azure)
