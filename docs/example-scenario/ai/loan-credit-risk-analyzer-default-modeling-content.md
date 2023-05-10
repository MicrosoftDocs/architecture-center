[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for a credit-risk analyzer. It uses Azure Machine Learning to run predictive analytics and Power BI to display results.

## Architecture

![Architecture diagram that shows the components of a credit-risk analyzer, such as Machine Learning, SQL Database, and Power BI.](../media/loan-credit-risk-analyzer-and-default-modeling.png)
*Download an [SVG](../media/loan-credit-risk-analyzer-and-default-modeling.svg) of this architecture.*

### Dataflow

1. Machine Learning is used for training, deploying, and managing the machine learning models.

1. Azure SQL Database stores financial history data and the generated model predictions.

1. Lenders view and interact with the prediction results and related data in Power BI dashboards.

### Components

- [Machine Learning](https://azure.microsoft.com/services/machine-learning) helps you design, test, operationalize, and manage predictive analytics solutions in the cloud.
- [SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed platform as a service (PaaS) database engine. It offers AI-powered, automated features and runs on the latest stable version of SQL Server.
- [Power BI](https://powerbi.microsoft.com) provides interactive dashboards that display data that's needed for business decisions. In this solution, the dashboards display predictive analytics data that's stored in SQL Database.

## Scenario details

Scoring credit risk is a complex process. Lenders carefully weigh various quantitative indicators to determine the probability of default and approve the best candidates based on the information available to them.

This solution acts as a credit-risk analyzer, helping you score credit risk and manage exposure by using advanced analytics models. Machine Learning equips you with predictive analytics that help assess credit or loan applications and accept only those applications that fall above certain criteria. For example, you might use the predicted scores to help determine whether to grant a loan. You can then easily visualize the guidance in a Power BI dashboard.

### Potential use cases

Data-driven credit risk modeling reduces the number of loans offered to borrowers who are likely to default, increasing the profitability of your loan portfolio. This solution is ideal for the finance industry.

## Next steps

- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Tutorial: Get started creating in the Power BI service](https://powerbi.microsoft.com/documentation/powerbi-service-get-started)

## Related resources

- [Demand forecasting](./demand-forecasting.yml)
- [Interactive price analytics using transaction history data](./interactive-price-analytics.yml)
- [Batch scoring of Python models on Azure](../../reference-architectures/ai/batch-scoring-python.yml)
- [Analyze browser information for security and accessibility insights](../../example-scenario/ai/analyze-browser-info-for-security-insights.yml)
