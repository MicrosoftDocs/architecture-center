---
title: Demand Forecasting + Price Optimization 
description: Predict future customer demand and optimize pricing to maximize profitability using big-data and advanced-analytics services from Microsoft Azure.
author: adamboeglin
ms.date: 10/18/2018
---
# Demand Forecasting + Price Optimization 
Pricing is pivotal for many industries, but it can be one of the most challenging tasks. Companies often struggle to accurately forecast the fiscal impact of potential tactics, fully consider core business constraints, and fairly validate pricing decisions once theyve been made. As product offerings expand and complicate the calculations behind real-time pricing decisions, the process grows even more difficult.
This solution addresses those challenges by using historical transaction data to train a demand-forecasting model in a retail context. It also incorporates the pricing of products in a competing group to predict cannibalization and other cross-product impacts. A price-optimization algorithm then uses that model to forecast demand at various price points and factors in business constraints to maximize potential profit.
By using this solution to ingest historical transaction data, predict future demand, and regularly optimize pricing, youll have the opportunity to save time and effort around the process and improve your companys profitability.

## Architecture
<img src="media/demand-forecasting-price-optimization-marketing.svg" alt='architecture diagram' />

## Components
* [Azure Data Lake Storage](href="http://azure.microsoft.com/services/storage/data-lake-storage/): Data Lake Store stores the weekly raw sales data, which is read by Spark on HDInsight.
* [Apache Spark for Azure HDInsight](href="http://azure.microsoft.com/services/hdinsight/apache-spark/): Spark on HDInsight ingests the data and executes data preprocessing, forecasting modeling, and price-optimization algorithms.
* [Data Factory](http://azure.microsoft.com/services/data-factory/) handles orchestration and scheduling of the model retraining.
* [Power BI](https://powerbi.microsoft.com) visualizes sales results, the predicted future demand, and the recommended optimal prices for a variety of products sold in different stores.

## Next Steps
* [Learn more about Data Lake Store](https://docs.microsoft.com/azure/data-lake-store/data-lake-store-overview)
* [Get started with HDInsight using a Spark cluster with R Server](https://docs.microsoft.com/azure/hdinsight/hdinsight-apache-spark-overview)
* [Learn more about Data Factory](https://docs.microsoft.com/azure/data-factory/data-factory-introduction)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)