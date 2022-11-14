---
title: Load data into Azure Storage environments
description: Learn about how to ingest data into various target environments where the data is stored and processed.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 01/10/2020
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Load data into storage environments for analytics

The Team Data Science Process requires that data be ingested or loaded into the most appropriate way in each stage. Data destinations can include Azure Blob Storage, SQL Azure databases, SQL Server on Azure VM, HDInsight (Hadoop), Azure Synapse Analytics, and Azure Machine Learning.

The following articles describe how to ingest data into various target environments where the data is stored and processed.

* To/From [Azure Blob Storage](move-azure-blob.md)
* To [SQL Server on Azure VM](move-sql-server-virtual-machine.md)
* To [Azure SQL Database](move-sql-azure.md)
* To [Hive tables](move-hive-tables.md)
* To [SQL partitioned tables](parallel-load-sql-partitioned-tables.md)
* From [On-premises SQL Server](move-sql-azure-adf.md)

Technical and business needs, as well as the initial location, format, and size of your data will determine the best data ingestion plan. It is not uncommon for a best plan to have several steps. This sequence of tasks can include, for example, data exploration, pre-processing, cleaning, down-sampling, and model training.  Azure Data Factory is a recommended Azure resource to orchestrate data movement and transformation.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*
