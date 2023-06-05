---
title: Identify scenarios and plan the analytics process
description: Identify scenarios and plan for advanced analytics data processing by considering a series of key questions.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 12/14/2021
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Identify scenarios and plan for advanced analytics data processing

What resources are required for you to create an environment that can perform advanced analytics processing on a dataset? This article suggests a series of questions to ask that can help identify tasks and resources relevant your scenario.

To learn about the order of high-level steps for predictive analytics, see [What is the Team Data Science Process (TDSP)](overview.yml). Each step requires specific resources for the tasks relevant to your particular scenario.

Answer key questions in the following areas to identify your scenario:

* data logistics
* data characteristics
* dataset quality
* preferred tools and languages

## Logistic questions: data locations and movement

The logistic questions cover the following items:

* data source location
* target destination in Azure
* requirements for moving the data, including the schedule, amount, and resources involved

You may need to move the data several times during the analytics process. A common scenario is to move local data into some form of storage on Azure and then into [Azure Machine Learning](/azure/machine-learning).

### What is your data source?

Is your data local or in the cloud? Possible locations include:

* a publicly available HTTP address
* a local or network file location
* a SQL Server database
* an Azure Storage container

### What is the Azure destination?

Where does your data need to be for processing or modeling?

* Azure Machine Learning
* Azure Blob Storage
* SQL Azure databases
* SQL Server on Azure VM
* HDInsight (Hadoop on Azure) or Hive tables
* Mountable Azure virtual hard disks

### How are you going to move the data?

For procedures and resources to ingest or load data into a variety of different storage and processing environments, see:

* [Load data into storage environments for analytics](ingest-data.md)
* [Secure data access in Azure Machine Learning](/azure/machine-learning/concept-data)

### Does the data need to be moved on a regular schedule or modified during migration?

Consider using Azure Data Factory (ADF) when data needs to be continually migrated. ADF can be helpful for:

* a hybrid scenario that involves both on-premises and cloud resources
* a scenario where the data is transacted, modified, or changed by business logic in the course of being migrated

For more information, see [Move data from a SQL Server database to SQL Azure with Azure Data Factory](move-sql-azure-adf.md).

### How much of the data is to be moved to Azure?

Large datasets may exceed the storage capacity of certain compute clusters. In such cases, you might use a sample of the data during the analysis. For details of how to down-sample a dataset in various Azure environments, see [Sample data in the Team Data Science Process](sample-data.md).

## Data characteristics questions: type, format, and size

These questions are key to planning your storage and processing environments. They will help you choose the appropriate scenario for your data type and understand any restrictions.

### What are the data types?

* Numerical
* Categorical
* Strings
* Binary

### How is your data formatted?

* Comma-separated (CSV) or tab-separated (TSV) flat files
* Compressed or uncompressed
* Azure blobs
* Hadoop Hive tables
* SQL Server tables

### How large is your data?

* Small: Less than 2 GB
* Medium: Greater than 2 GB and less than 10 GB
* Large: Greater than 10 GB

As applied to Azure Machine Learning:

* [Data ingestion options for Azure Machine Learning workflows](/azure/machine-learning/concept-data-ingestion).
* [Optimize data processing with Azure Machine Learning](/azure/machine-learning/concept-optimize-data-processing).

## Data quality questions: exploration and pre-processing

### What do you know about your data?

Understand the basic characteristics about your data:

* What patterns or trends it exhibits
* What outliers it has
* How many values are missing

This step is important to help you:

* Determine how much pre-processing is needed
* Formulate hypotheses that suggest the most appropriate features or type of analysis
* Formulate plans for additional data collection

Useful techniques for data inspection include descriptive statistics calculation and visualization plots. For details of how to explore a dataset in various Azure environments, see [Explore data in the Team Data Science Process](explore-data.md).

### Does the data require preprocessing or cleaning?

You might need to preprocess and clean your data before you can use the dataset effectively for machine learning. Raw data is often noisy and unreliable. It might be missing values. Using such data for modeling can produce misleading results. For a description, see [Tasks to prepare data for enhanced machine learning](prepare-data.md).

## Tools and languages questions

There are many options for languages, development environments, and tools. Be aware of your needs and preferences.

### What languages do you prefer to use for analysis?

* R
* Python
* SQL
* Other

### What tools could you use for data analysis?

Azure Machine Learning uses [Jupyter notebooks for data analysis](/azure/machine-learning/samples-notebooks).  In addition to this recommended environment, here are other options often paired in intermediate to advanced enterprise scenarios.

* [Microsoft Azure PowerShell](/powershell/azure/) - a script language used to administer your Azure resources in a script language
* [RStudio](https://www.rstudio.com)
* [Python Tools for Visual Studio](/visualstudio/python/)
* [Microsoft Power BI](https://powerbi.microsoft.com)

## Identify your advanced analytics scenario

After you have answered the questions in the previous section, you are ready to determine which scenario best fits your case. The sample scenarios are outlined in [Scenarios for advanced analytics in Azure Machine Learning](/azure/architecture/data-science-process/overview).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

- [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> [!div class="nextstepaction"]
> [What is the Team Data Science Process (TDSP)?](overview.yml)

## Related resources

- [Execute data science tasks: exploration, modeling, and deployment](execute-data-science-tasks.md)
- [Set up data science environments for use in the Team Data Science Process](environment-setup.md)
- [Platforms and tools for data science projects](platforms-and-tools.md)
- [Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)
