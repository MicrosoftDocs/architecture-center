---
title: Prepare data for Machine Learning Studio (classic)
description: Preprocess and clean data to prepare it to be used effectively for machine learning.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.date: 02/14/2024
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Prepare data for enhanced machine learning

Preprocessing and cleaning data are important tasks that must be conducted before a dataset can be used for model training. Raw data is often noisy and unreliable, and might be missing values. Using such data for modeling can produce misleading results. These tasks are part of the Team Data Science Process (TDSP) and typically follow an initial exploration of a dataset used to discover and plan the preprocessing required. For more information, [What is the Team Data Science Process?](overview.yml).

Preprocessing and cleaning tasks, like the data exploration task, can be carried out in a wide variety of environments, such as SQL or Hive or Azure Machine Learning studio (classic). You can also use various tools and languages, such as R or Python. Where your data is stored and how its format affects these decisions. Since the TDSP is iterative in nature, these tasks can take place at various steps in the workflow of the process.

This article introduces various data processing concepts and tasks that can be undertaken either before or after ingesting data into Azure Machine Learning studio (classic).

For an example of data exploration and preprocessing done inside Azure Machine Learning studio (classic), see the video, [Preprocessing data](https://azure.microsoft.com/documentation/videos/preprocessing-data-in-azure-ml-studio/).

## Why preprocess and clean data?

Real-world data is gathered from various sources and processes and it might contain irregularities or corrupt data compromising the quality of the dataset. The typical data quality issues that arise are:

* **Incomplete data**: Lacks attributes or containing missing values
* **Noisy data**: Contains erroneous records or outliers
* **Inconsistent data**: Contains conflicting records or discrepancies

Quality data is a prerequisite for quality predictive models. To avoid *garbage in, garbage out* and improve data quality and therefore model performance, it's imperative to conduct a data health screen to spot data issues early. You need to decide on the corresponding data processing and cleaning steps.

## What are some typical data health screens that are employed?

You can check the general quality of data by checking:

* The number of **records**.
* The number of **attributes** (or **features**).
* The attribute **data types**, such as nominal, ordinal, or continuous.
* The number of **missing values**.
* For **well-formed** data.
  * If the data is in TSV or CSV format, check that the column separators and line separators correctly separate columns and lines.
  * If the data is in HTML or XML format, check if the data is well-formed based on their respective standards.
  * Parsing might also be necessary to extract structured information from semi-structured or unstructured data.
* **Inconsistent data records**. Check the range of values are allowed. For example, if the data contains student grade point averages (GPAs), check if the GPAs are in the designated range, for example 0 to 4.

When you find issues with data, perform processing steps, for example cleaning missing values, data normalization, discretization, text processing to remove or replace embedded characters that might affect data alignment, mixed data types in common fields, and others.

**Azure Machine Learning consumes well-formed tabular data**.  If the data is already in tabular form, you can perform data preprocessing directly with Azure Machine Learning studio (classic).  If data isn't in tabular form, for example if it's in XML format, you might need to parse the data to convert it to tabular form.

## What are some of the major tasks in data preprocessing?

* **Data cleaning**:  Fill in missing values, detect, and remove noisy data and outliers.
* **Data transformation**:  Normalize data to reduce dimensions and noise.
* **Data reduction**:  Sample data records or attributes for easier data handling.
* **Data discretization**:  Convert continuous attributes to categorical attributes for ease of use with certain machine learning methods.
* **Text cleaning**: Remove embedded characters that might cause data misalignment. For example, they might be embedded tabs in a tab-separated data file or embedded new lines that break records.

The following sections detail some of these data processing steps.

## How to deal with missing values?

To deal with missing values, first identify the reason for the missing values. Typical missing value handling methods are:

* **Deletion**: Remove records with missing values.
* **Dummy substitution**: Replace missing values with a dummy value, such as *unknown* for categorical values or *0* for numerical values.
* **Mean substitution**: If the missing data is numerical, replace the missing values with the mean.
* **Frequent substitution**: If the missing data is categorical, replace the missing values with the most frequent item.
* **Regression substitution**: Use a regression method to replace missing values with regressed values.

## How to normalize data?

Data normalization rescales numerical values to a specified range. Popular data normalization methods include:

* **Min-max normalization**: Linearly transform the data to a range, such as 0 to 1, where the minimum value is scaled to 0 and the maximum value is scaled to 1.
* **Z-score normalization**: Scale data based on mean and standard deviation. Divide the difference between the data and the mean by the standard deviation.
* **Decimal scaling**: Scale the data by moving the decimal point of the attribute value.

## How to discretize data?

Data can be discretized by converting continuous values to nominal attributes or intervals. You can use the following methods:

* **Equal-width binning**: Divide the range of all possible values of an attribute into *N* groups of the same size, and assign the values that fall in a bin with the bin number.
* **Equal-height binning**: Divide the range of all possible values of an attribute into *N* groups, each containing the same number of instances. Then assign the values that fall in a bin with the bin number.

## How to reduce data?

There are various methods to reduce data size for easier data handling. Depending on data size and the domain, you can apply the following methods:

* **Record sampling**: Sample the data records and only choose the representative subset from the data.
* **Attribute sampling**: Select only a subset of the most important attributes from the data.
* **Aggregation**: Divide the data into groups and store the numbers for each group. For example, the daily revenue numbers of a restaurant chain over the past 20 years can be aggregated to monthly revenue to reduce the size of the data.

## How to clean text data?

**Text fields in tabular data** might include characters that affect column alignment or record boundaries. For example, embedded tabs in a tab-separated file cause column misalignment, and embedded new line characters break record lines. While writing or reading text, properly handle text encoding to prevent information loss, inadvertently introducing unreadable characters (like nulls), or negatively affecting text parsing. You might have to carefully parse and edit data. You can clean text fields to ensure proper alignment and extract structured data from unstructured or semi-structured data.

**Data exploration** provides an early view into data. You can uncover many data issues during this step, and apply  corresponding methods to address those issues. It's important to ask questions, such as what the source of the issue is and how the issue was introduced. This process also helps you decide the data processing steps that need to be taken to resolve them. To prioritize the data processing effort, you can identify the final use cases and personas.

## References

> *Data Mining: Concepts and Techniques*, Third Edition, Morgan Kaufmann, 2011, Jiawei Han, Micheline Kamber, and Jian Pei

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Preprocess large datasets with Azure Machine Learning](/training/modules/preprocesses-large-datasets-azure-machine-learning/)
- [Azure Machine Learning studio](/shows/ai-show/azure-machine-learning-studio)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)

## Related resources

- [Process Azure Blob Storage data with advanced analytics](data-blob.md)
- [What is the Team Data Science Process?](overview.yml)
