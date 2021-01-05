


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Scoring credit risk is a complex process. Lenders carefully weigh a variety of quantitative indicators to determine the probability of default and approve the best candidates based on the information available to them.

This solution acts as a credit-risk analyzer, helping you score credit risk and manage exposure using advanced analytics models. SQL Server 2016 with R Services equips you with predictive analytics that help assess credit or loan applications and accept only those that fall above certain criteria. For example, you might use the predicted scores to help determine whether to grant a loan, then easily visualize the guidance in a Power BI Dashboard.

Data-driven credit-risk modeling reduces the number of loans offered to borrowers who are likely to default, increasing the profitability of your loan portfolio.

## Architecture

![Architecture Diagram](../media/loan-credit-risk-analyzer-and-default-modeling.png)
*Download an [SVG](../media/loan-credit-risk-analyzer-and-default-modeling.svg) of this architecture.*

## Components

* [SQL Server R Services](/sql/machine-learning/r/sql-server-r-services?view=sql-server-2016): SQL Server stores the lender and borrower data. R-based analytics provide training and predicted models, as well as predicted results for consumption.
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Machine Learning helps you design, test, operationalize, and manage predictive analytics solutions in the cloud.
* [Power BI](https://powerbi.microsoft.com) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.

## Next steps

* [Get started with SQL Server R Services](/sql/advanced-analytics/r/getting-started-with-sql-server-r-services)
* [Learn more about Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-service-get-started)