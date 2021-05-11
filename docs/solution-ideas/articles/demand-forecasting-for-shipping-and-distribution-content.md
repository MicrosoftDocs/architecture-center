[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea uses historical demand data to forecast demand in future periods across various customers, products, and destinations. For instance, a shipping or delivery company wants to predict the quantities of the different products its customers want delivered at different locations at future times. A company can use demand forecasts as input to an allocation tool that optimizes operations, such as delivery vehicles routing, or to plan capacity in the longer term.  Similarly, a vendor or insurer wants to know the number of products that will be returned due to failures over the course of a year. A company can use demand forecasts as input to an allocation tool that optimizes operations, such as delivery vehicles routing, or to plan capacity in the longer term.

The demand forecasting process described in this solution can be operationalized and deployed in [Microsoft AI platform](https://www.microsoft.com/en-us/ai/ai-platform). Microsoft AI platform has advanced analytics tools for data ingestion, data storage, scheduling, and advanced analytics, which are all the essential tools for running a demand forecasting solution that can be integrated with your current production systems. This solution combines Azure services, such as Azure SQL Server to store forecasts and historical distribution data, Azure Machine Learning (AML) web service to host forecasting code, Azure Data Factory to orchestrate the entire workflow, and Power BI to visualize forecasts.

## Architecture

![Architecture diagram: demand forecasting for shipping and distribution](../media/demand-forecasting-for-shipping-and-distribution.png)
*Download an [SVG](../media/demand-forecasting-for-shipping-and-distribution.svg) of this architecture.*

## Details

For an example of a demand forecasting solution for shipping and distribution similar to the solution described in this article, see the [Azure AI Gallery](https://gallery.azure.ai/Solution/Demand-Forecasting-for-Shipping-and-Distribution-2). General characteristics of demand forecasting solutions like this solution are:

* There are numerous kinds of items with differing volumes, that roll up under one or more category levels.
* There is a history available for the quantity of the item at each time in the past.
* The volumes of the items differ widely, with possibly a substantial number that have zero volume at times.
* The history of items shows both trend and seasonality, possibly at multiple time scales.
* The quantities committed or returned are not strongly price sensitive. In other words, the delivery company cannot strongly influence quantities by short-term changes in prices, although there may be other determinants that affect volume, such as weather.

Under these conditions, you can take advantage of the hierarchy formed among the time series of the different items. By enforcing consistency so that the quantities lower in the hierarchy (for example, individual product quantities) sum to the quantities above (customer product totals), you can improve the accuracy of the overall forecast. The same applies if individual items are grouped into categories, even possibly categories that overlap. For example, you might be interested in forecasting demand of all products in total, by location, by product category, by customer, and so on.

The [AI Gallery solution](https://gallery.azure.ai/Solution/Demand-Forecasting-for-Shipping-and-Distribution-2) computes forecasts at all aggregation levels in the hierarchy for each time period specified. Remember that deployments of your demand forecasting solutions will incur consumption charges on the services used. Use the [Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to predict costs. When you are no longer using a deployed solution, delete it to stop incurring charges.

## Components

This demand forecasting solution idea uses the following resources hosted and managed in Azure:

* [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/) instance for persistent storage.
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) web service to host forecasting code.
* [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) for intermediate storage of generated forecasts.
* [Azure Data Factory](https://azure.microsoft.com/services/data-factory) to orchestrate regular runs of the Azure Machine Learning model.
* [Power BI](https://powerbi.microsoft.com) dashboard to display and drill down on the forecasts.

The solution entails automating the running of periodic forecasts, at a pace configured in Azure Data Lake (for example, monthly), where it learns a model with the current historical data, and predicts quantities for future periods for all products in the product hierarchy. Each forecast cycle consists of a round trip from the database, through the model, then back to the database. Each cycle measures forecast accuracy by conventional data holdout techniques. You can configure the number of periods, the product categories and the hierarchy among products. You need to load your current data in the Azure SQL database, and extract forecasts after each run from the same database. 

## Next steps

See product documentation:

* [Learn more about Data Factory](/azure/data-factory/data-factory-introduction)
* [Learn more about Power BI](/power-bi/fundamentals/power-bi-overview)

See related Azure Architecture Center articles:

* [Demand forecasting and price optimization](./demand-forecasting-price-optimization-marketing.yml)
* [Demand forecasting with Azure Stream Analytics and Machine Learning](./demand-forecasting.yml)

External links about forecasting:

* [Demand forecasting for shipping and distribution](https://gallery.azure.ai/Solution/Demand-Forecasting-for-Shipping-and-Distribution-2) in the Azure AI Gallery
* [Forecasting best practices](https://github.com/microsoft/forecasting) on GitHub
