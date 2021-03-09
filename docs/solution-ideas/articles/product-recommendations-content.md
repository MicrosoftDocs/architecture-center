


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

A deep understanding between customer interests and purchasing patterns is a critical component of any retail business intelligence operation. This solution implements a process of aggregating customer data into a complete profile, and uses advanced machine learning models backed by the reliability and processing power of Azure to provide predictive insights on simulated customers.

## Architecture

![Architecture diagram](../media/product-recommendations.png)
*Download an [SVG](../media/product-recommendations.svg) of this architecture.*

## Description

For more details on how this solution is built, visit the solution guide in [GitHub](https://github.com/Azure/cortana-intelligence-customer360).

A typical retail business collects customer data through a variety of channels, including web-browsing patterns, purchase behaviors, demographics, and other session-based web data. Some of the data originates from core business operations, but other data must be pulled and joined from external sources like partners, manufacturers, public domain, etc.

Many businesses leverage only a small portion of the available data, but in order to maximize ROI, a business must integrate relevant data from all sources. Traditionally, the integration of external, heterogeneous data sources into a shared data processing engine has required significant effort and resources to set up. This solution describes a simple, scalable approach to integrating analytics and machine learning to predict customer purchasing activity.

This solution addresses the above problems by:

* Uniformly accessing data from multiple data sources while minimizing data movement and system complexity in order to boost performance.
* Performing ETL and feature engineering needed to use a predictive Machine Learning model.
* Creating a comprehensive customer 360 profile enriched by predictive analytics running across a distributed system backed by Microsoft R Server and Azure HDInsight.

## Data Flow

1. A Data Generator pipes simulated customer events to an Event Hub
1. A Stream Analytics job reads from the EventHub, performs aggregations
1. Stream Analytics persists time-grouped data to an Azure Storage Blob
1. A Spark job running in HDInsight merges the latest customer browsing data with historical purchase and demographic data to build a consolidated user profile
1. A second Spark job scores each customer profile against a machine learning model to predict future purchasing patterns (in other words, is a given customer likely to make a purchase in the next 30 days, and if so, in which product category?)
1. Predictions and other profile data are visualized and shared as charts and tables in Power BI Online

## Components

* [Azure Blob Storage](/azure/storage/blobs/)
* [Azure Event Hub](/azure/event-hubs/)
* [Azure Machine Learning](https://azure.microsoft.com/en-us/services/machine-learning/)
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database/)
* [Azure Stream Analytics](/azure/stream-analytics/)
* [Power BI Dashboard](/power-bi/create-reports/)

## Next steps

* [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
* [Azure Machine Learning documentation](/azure/machine-learning/)
* [Movie recommendations on Azure](/azure/architecture/reference-architectures/ai/movie-recommendations)
* [Personalized marketing solutions](/azure/architecture/solution-ideas/articles/personalized-marketing)
* [Personalized Offers](/azure/architecture/solution-ideas/articles/personalized-offers)
* [Build a Real-time Recommendation API on Azure](/azure/architecture/reference-architectures/ai/real-time-recommendation)
