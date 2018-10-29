---
title: Predictive Marketing with Machine Learning 
description: Learn how to build a machine-learning model with Microsoft R Server on Azure HDInsight Spark clusters to recommend actions to maximize the purchase rate.
author: adamboeglin
ms.date: 10/29/2018
---
# Predictive Marketing with Machine Learning 
Marketing campaigns are about more than the message being delivered; when and how that message is delivered is just as important. Without a data-driven, analytical approach, campaigns can easily miss opportunities or struggle to gain traction.
Through machine learning informed by historical campaign data, this solution architecture helps predict customer responses and recommends an optimized plan for connecting with your leadsincluding the best channel to use (by email, SMS, a cold call, etc.), the best day of the week, and the best time of the day.
Optimizing your campaigns with predictive marketing helps improve both sales leads and revenue generation and can provide strong ROI for your marketing investment.
This architecture enables efficient handling of big data on Spark with Microsoft R Server.

## Architecture
<img src="media/predictive-marketing-campaigns-with-machine-learning-and-spark.svg" alt='architecture diagram' />

## Components
* [Apache Spark for Azure HDInsight](href="http://azure.microsoft.com/services/hdinsight/apache-spark/): Microsoft R Server on HDInsight Spark clusters provides distributed and scalable machine learning capabilities for big data, combining the power of R Server and Apache Spark.
* [Power BI](https://powerbi.microsoft.com) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.
* Azure [Storage](http://azure.microsoft.com/services/storage/) stores campaign and lead data.
* [Machine Learning Studio](href="http://azure.microsoft.com/services/machine-learning-studio/): Machine Learning helps you easily design, test, operationalize, and manage predictive analytics solutions in the cloud.

## Next Steps
* [Learn more about Spark on HDInsight](https://docs.microsoft.com/azure/hdinsight/hdinsight-apache-spark-overview)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)
* [Learn more about Azure storage](https://docs.microsoft.com/azure/storage/storage-introduction)
* [Learn more about Machine Learning](https://docs.microsoft.com/azure/machine-learning/machine-learning-what-is-machine-learning)