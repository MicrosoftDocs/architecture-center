---
title: Predictive Marketing with Machine Learning
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: Learn how to build a machine-learning model with Microsoft R Server on Azure HDInsight Spark clusters to recommend actions to maximize the purchase rate.
ms.custom: acom-architecture, predictive marketing, ai-ml, analytics, predictive analytics software, predictive analytics marketing, 'https://azure.microsoft.com/solutions/architecture/predictive-marketing-campaigns-with-machine-learning-and-spark/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
  - analytics
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/predictive-marketing-campaigns-with-machine-learning-and-spark.png
---

# Predictive Marketing with Machine Learning

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Marketing campaigns are about more than the message being delivered; when and how that message is delivered is just as important. Without a data-driven, analytical approach, campaigns can easily miss opportunities or struggle to gain traction.

Through machine learning informed by historical campaign data, this solution architecture helps predict customer responses and recommends an optimized plan for connecting with your leads-including the best channel to use (by email, SMS, a cold call, etc.), the best day of the week, and the best time of the day.

Optimizing your campaigns with predictive marketing helps improve both sales leads and revenue generation and can provide strong ROI for your marketing investment.

This architecture enables efficient handling of big data on Spark with Microsoft R Server.

## Architecture

![Architecture Diagram](../media/predictive-marketing-campaigns-with-machine-learning-and-spark.png)
*Download an [SVG](../media/predictive-marketing-campaigns-with-machine-learning-and-spark.svg) of this architecture.*

## Components

* Microsoft R Server on [HDInsight](https://azure.microsoft.com/services/hdinsight) Spark clusters provides distributed and scalable machine learning capabilities for big data, combining the power of R Server and Apache Spark.
* [Power BI](https://powerbi.microsoft.com) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.
* [Storage Accounts](https://azure.microsoft.com/services/storage): Azure Storage stores campaign and lead data.
* [Machine Learning Studio](https://azure.microsoft.com/services/machine-learning-studio): Machine Learning helps you easily design, test, operationalize, and manage predictive analytics solutions in the cloud.

## Next steps

* [Learn more about Spark on HDInsight](https://docs.microsoft.com/azure/hdinsight/hdinsight-apache-spark-overview)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)
* [Learn more about Azure storage](https://docs.microsoft.com/azure/storage/common/storage-introduction)
* [Learn more about Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
