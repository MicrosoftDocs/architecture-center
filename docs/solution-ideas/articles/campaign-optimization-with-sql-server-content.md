[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea describes building and deploying a machine learning model that recommends actions to maximize the purchase rate of leads targeted by a campaign. The ideas discussed can be used in many industries, including retail, services, and finance.

## Potential use cases

When businesses launch a marketing campaign to attract customers to new or existing products, they often use a set of business rules to select leads for their campaign to target. Machine learning can be used to help increase the response rate from these leads. 

For example, a machine learning model can be used to predict actions that are expected to maximize the purchase rate of leads targeted by the campaign. The predictions then serve as the basis for recommendations to be used by a renewed campaign. Recommendations can be about *how* to contact the targeted leads, for example, with e-mail, SMS, or a cold call. And recommendations can be about *when* to contact targeted leads, for example, day of week and time of day.

## Architecture

![Architecture diagram: develop and deploy models on a Data Science VM with R.](../media/campaign-optimization-with-sql-server.png)
*Download an [SVG](../media/campaign-optimization-with-sql-server.svg) of this architecture.*

Two roles in this solution idea are:

- **Business manager role**. Power BI can be used to present visual summaries of the effectiveness of the campaign recommendations. Power BI dashboards can be used by business managers or other making decisions based on the predicted recommendations.

- **Data scientist role**. Data scientists can test and develop solutions from the convenience of their R IDE on their client machines while [pushing the compute to the SQL Server machine](/sql/advanced-analytics/r/getting-started-with-sql-server-r-services). The completed solutions are deployed to SQL Server 2016 by embedding calls to R in stored procedures. These solutions can then be further automated with SQL Server Integration Services and SQL Server agent.

## Deploy this scenario

The AI Gallery [campaign optimization with SQL Server solution](https://gallery.azure.ai/Solution/Campaign-Optimization-with-SQL-Server) implements this solution idea with SQL [Server 2016 R Services](/sql/machine-learning/r/sql-server-r-services) and [Power BI](https://powerbi.microsoft.com/what-is-power-bi/) as an interactive visualization tool. The gallery solution uses simulated data, which can easily be configured to use custom data, to model the acquisition campaign response. The model uses predictors such as demographics, historical campaign performance, and product details. The solution predicts the probability of a lead conversion from each channel, at various times of the day and days of the week, for every lead in the database. The final recommendation for targeting each lead is decided based upon the combination of channel, day of week and time of day with the highest probability of conversion. The solution has been modeled after a standardized data science process, where the data preparation, model training and evaluation can be easily done by a data scientist and the insights visualized and correlated to KPIs by marketing via Power BI visualization.

## Next steps

Read product documentation:

- [What is SQL Server 2016 R Services?](/sql/machine-learning/r/sql-server-r-services)
- [What is Power BI](https://powerbi.microsoft.com/what-is-power-bi/)
- [What is MicrosoftML?](/machine-learning-server/r/concept-what-is-the-microsoftml-package) - used inside SQL Server Machine Learning Services.

Try out some code:

- [Campaign optimization solution](https://gallery.azure.ai/Solution/Campaign-Optimization-with-SQL-Server) in the Azure AI Gallery
- [R tutorials for SQL machine learning](/sql/machine-learning/tutorials/r-tutorials)
