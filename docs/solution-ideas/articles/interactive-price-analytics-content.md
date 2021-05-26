
<!-- cSpell:ignore xlink -->



[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This pricing analytics solution idea shows you how you can develop a pricing model for products that is based on elasticity estimates from transaction history data. This solution is targeted at mid-size companies with small pricing teams who lack extensive data science support for bespoke pricing analytics models.

Interaction with the pricing model is via Excel where you can easily paste your sales data and analyze your prices without the need to integrate the data into the solution database first. In the spreadsheet, you can simulate promotions and plot demand curves (showing demand response to price), and access dashboard data in numerical form. The rich functionality of the pricing model can also be accessed from web services, integrating price analytics directly into your business applications.

[Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-ml) is the core logic in this solution from which elasticity models are created. Machine learning models can be set up with to avoid two common pitfalls of price modeling from historical data: confounding effects and data sparsity. 

An implementation of this pricing analytics solution idea is described in the [AI Gallery solution](https://gallery.azure.ai/Solution/Interactive-Price-Analytics) and [GitHub repro](https://github.com/Azure/cortana-intelligence-price-analytics). The AI Gallery solution uses your transactional history data to show how the demand for your products responds to the prices you offer, recommend pricing changes, and allow you to simulate how changes in price would affect your demand, at a fine granularity. The solution provides a dashboard, where you can see optimal pricing recommendations, item elasticities at an item-site-channel-segment level, estimates of related-product effects such "as cannibalization", forecasts given current process, and model performance metrics.

## Architecture of a pricing analytics solution

![Architecture diagram: overview of components for a pricing analytics solution using machine learning.](../media/interactive-price-analytics.png)
*Download an [SVG](../media/interactive-price-analytics.svg) of this architecture.*

The AI Gallery solution, which is an implementation of this solution idea, has two key roles, technical resources and end users such as pricing managers. Technical resources deploy the solution and connect it to a business data warehouse. For more information, they should read the [Technical Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/Technical%20Deployment%20Guide/TechnicalDeploymentGuide.md). End users using the model via a spreadsheet or integrated into a business application, should read the [User Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/User%20Guide/UserGuide.md).

## Components

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) enables building pricing models.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) stores model and any intermediate data generated.
- [Azure SQL Server](https://azure.microsoft.com/products/azure-sql/database/) stores transaction history data and generated model predictions.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) used to schedule periodic (for example, weekly) model refreshes.
- [Power BI](https://powerbi.microsoft.com/what-is-power-bi/) enables visualization of results.
- [Excel](https://www.microsoft.com/microsoft-365/excel) spreadsheet consumes predictive web services.

## Next steps

- [AI Gallery Interactive Pricing Solution](https://gallery.azure.ai/Solution/Interactive-Price-Analytics)
- [GitHub repo Interactive Price Analytics](https://github.com/Azure/cortana-intelligence-price-analytics)
  - [Technical Deployment Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/Technical%20Deployment%20Guide/TechnicalDeploymentGuide.md) - for a more detailed discussion of the architecture, connecting your own data and customization.
  - [User Guide](https://github.com/Azure/cortana-intelligence-price-analytics/blob/master/User%20Guide/UserGuide.md) - for end users of the solution such as pricing managers.
- Blog post [A Pricing Engine for Everyone built with AzureML and Python](https://docs.microsoft.com/archive/blogs/intel/building-a-pricing-engine-using-azureml-and-python)
- Microsoft Learn Path [Build AI solutions with Azure Machine Learning](/learn/paths/build-ai-solutions-with-azure-ml-service/)
