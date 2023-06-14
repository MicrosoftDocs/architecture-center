<!-- cSpell:ignore xlink -->

The Price Analytics solution utilizes your transactional history data to show you how the demand for your products responds to the prices you offer.

## Architecture

:::image type="content" alt-text="Screenshot showing interactive price analytics." source="../media/interactive-price-analytics.svg" lightbox="../media/interactive-price-analytics.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/interactive-price-analytics.vsdx) of this architecture.*

### Dataflow

1. [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) enables building pricing models.
1. [Azure Blob storage](https://azure.microsoft.com/services/storage/blobs) stores model and any intermediate data that's generated.
1. [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) stores transaction history data and any generated model predictions.
1. [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is used to schedule periodic (for example, weekly) model refreshes.
1. [Power BI](https://powerbi.microsoft.com/what-is-power-bi) enables a visualization of the results.
1. [Excel](https://www.microsoft.com/microsoft-365/excel) spreadsheets consume predictive web services.

### Components

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory)
- [Azure Machine Learning Services](https://azure.microsoft.com/services/machine-learning)
- [Microsoft Excel](https://www.microsoft.com/microsoft-365/excel) worksheets
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
- [Dashboard](https://powerbi.microsoft.com/diad) in [Power BI](https://powerbi.microsoft.com)

## Solution details

The Price Analytics solution utilizes your transactional history data to show you how the demand for your products responds to the prices you offer. It recommends pricing changes and allows you to simulate how changes in price would affect your demand, at a fine granularity.

The solution provides a dashboard where you can see:

- Optimal pricing recommendations.
- Item elasticities at an item-site-channel-segment level.
- Estimates of related-product effects such as cannibalization.
- Forecasts given current process.
- Model performance metrics.

Using direct interaction with the pricing model in Excel, you can:

- Paste your sales data there and analyze your prices without the need to integrate the data into the solution database first.
- Simulate promotions and plot demand curves (showing demand response to price).
- Work with dashboard data in numerical form.

The rich functionality isn't confined to Excel. It's driven by web services that you or your implementation partner can call directly from your business applications, integrating price analysis into your business applications.

### Potential use cases

This architecture is ideal for the retail industry, providing pricing recommendations, estimations, and forecasts.

### Solution description

At the core of a rigorous price analysis workflow is price elasticity modeling and optimal pricing recommendations. The state-of-the-art modeling approach mitigates the two worst pitfalls of modeling price sensitivity from historical data: confounding and data sparsity.

Confounding is the presence of factors other than price that affect demand. We use a "double-ML" approach that subtracts out the predictable components of price and demand variation before estimating the elasticity. This approach immunizes the estimates to most forms of confounding. The solution can also be customized by an implementation partner to use your data capturing potential external demand drivers other than price. Our [blog post](/archive/blogs/intel/building-a-pricing-engine-using-azureml-and-python) gives more detail on the data science of prices.

Data sparsity occurs because the optimal price varies at a fine grain: businesses can set prices by item, site, sales channel, and even customer segment. But pricing solutions often only give estimates at product category level, because the transaction history may only contain a few sales for each specific situation. Our pricing solution uses "hierarchical regularization" to produce consistent estimates in such data-poor situations: in absence of evidence, the model borrows information from other items in the same category, same items in other sites, and so on. As the amount of historical data on a given item-site-channel combination increases, its elasticity estimate will be fine-tuned more specifically.

This pricing analytics solution idea shows you how you can develop a pricing model for products that is based on elasticity estimates from transaction history data. This solution is targeted at mid-size companies with small pricing teams who lack extensive data science support for bespoke pricing analytics models.

Interaction with the pricing model is via Excel where you can easily paste your sales data and analyze your prices without the need to integrate the data into the solution database first. In the spreadsheet, you can simulate promotions and plot demand curves (showing demand response to price), and access dashboard data in numerical form. The rich functionality of the pricing model can also be accessed from web services, integrating price analytics directly into your business applications.

[Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-ml) is the core logic in this solution from which elasticity models are created. Machine learning models can be set up with to avoid two common pitfalls of price modeling from historical data: confounding effects and data sparsity.

The solution provides the following advantages:

* Shows you in one glance (via the dashboard) how elastic your product demand is.
* Provides pricing recommendations for every product in your item catalog.
* Discovers related products (replacements and complements).
* Lets you simulate promotional scenarios in Excel.

## Considerations

Considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To calculate a current estimate, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). The estimated solution should include the following service costs:

* S1 standard ML service plan
* S2 SQL Database
* App hosting plan
* Miscellaneous ADF data activities and storage costs

If you're just exploring the solution, you can delete it in a few days or hours. The costs will stop being charged when you delete the Azure components.

## Deploy this scenario

The AI Gallery solution, which is an implementation of this solution architecture, has two key roles: technical resources and end users (such as pricing managers).

Technical resources deploy the solution and connect it to a business data warehouse. For more information, read the [Technical Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/Technical%20Deployment%20Guide/TechnicalDeploymentGuide.md). End users using the model via a spreadsheet (or integrated into a business application), should read the [User Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/User%20Guide/UserGuide.md).

### Getting started

Deploy the solution with the button on the right. Instructions at the end of the deployment will have important configuration information. Leave them open.

The solution deploys with the same example data set of orange juice prices that you find behind the Try-It-Now button on the right.

While the solution is deploying, you can get a head start by testing and reviewing:

* The Try-It-Now dashboard.
* Read the [User Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/User%20Guide/UserGuide.md) for usage instructions from the perspective of a pricing analyst (MSFT login required).
* Review the [Technical Deployment Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/Technical%20Deployment%20Guide/TechnicalDeploymentGuide.md) for a technical implementation view (MSFT login required).
* Download the interactive Excel worksheet.

After the solution deploys, complete the [first walkthrough](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/Walkthrough%201%20-%20Promotion%20Simulation/PromoSimulationWalkthrough.md) (MSFT login required).

### Solution dashboard

The solution dashboard's most actionable part is the Pricing Suggestion tab. It tells you which of your items are underpriced or overpriced. The tab suggests an optimal price for each item and the predicted impact of adopting the suggestion. The suggestions are prioritized by the largest opportunity to earn incremental gross margin.

An implementation of this pricing analytics solution idea is described in the [AI Gallery solution](https://gallery.azure.ai/Solution/Interactive-Price-Analytics) and [GitHub repro](https://github.com/Azure/cortana-intelligence-price-analytics). The AI Gallery solution uses your transactional history data to show how the demand for your products responds to the prices you offer, recommend pricing changes, and allow you to simulate how changes in price would affect your demand, at a fine granularity. The solution provides a dashboard, where you can see optimal pricing recommendations, item elasticities at an item-site-channel-segment level, estimates of related-product effects such "as cannibalization", forecasts given current process, and model performance metrics.

### Solution architecture

The solution uses an Azure SQL Database instance to store your transactional data and the generated model predictions. There are a dozen elasticity modeling core services, which are authored in Azure ML using Python core libraries. Azure Data Factory schedules weekly model refreshes. The results display in a Power BI dashboard. The provided Excel spreadsheet consumes the predictive Web Services.

Read the [Technical Deployment Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/Technical%20Deployment%20Guide/TechnicalDeploymentGuide.md) for a more detailed discussion of the architecture, including the topic of connecting your own data and customization (GitHub login required).

## Next steps

Learn more about the component technologies:

- [Introduction to Azure Data Factory](/azure/data-factory/v1/data-factory-introduction)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [Introduction to Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Create dashboards in Power BI](/training/modules/create-dashboards-power-bi)

Learn more about pricing solutions:

- [AI Gallery Interactive Pricing Solution](https://gallery.azure.ai/Solution/Interactive-Price-Analytics)
- [GitHub repo for Interactive Price Analytics](https://github.com/Azure/cortana-intelligence-price-analytics)
  - [Technical Deployment Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/Technical%20Deployment%20Guide/TechnicalDeploymentGuide.md) - for a more detailed discussion of the architecture, connecting your own data and customization.
  - [User Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/User%20Guide/UserGuide.md) - for end users of the solution such as pricing managers.
- Blog post: [A Pricing Engine for Everyone built with AzureML and Python](/archive/blogs/intel/building-a-pricing-engine-using-azureml-and-python)
- Microsoft Learn Path: [Build AI solutions with Azure Machine Learning](/training/paths/build-ai-solutions-with-azure-ml-service)

## Related resources

Explore related architectures:

- [Demand forecasting for shipping and distribution](./demand-forecasting-for-shipping-and-distribution.yml)
- [Use a demand forecasting model for price optimization](./demand-forecasting-price-optimization-marketing.yml)
- [Predictive maintenance](./predictive-maintenance.yml)
- [Predictive insights with vehicle telematics](./predictive-insights-with-vehicle-telematics.yml)
- [Predictive aircraft engine monitoring](./aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)
