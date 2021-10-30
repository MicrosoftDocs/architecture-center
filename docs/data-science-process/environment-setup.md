---
title: Set up data science environments in Azure - Team Data Science Process
description: Set up data science environments on Azure for use in the Team Data Science Process.
services: machine-learning
author: marktab
manager: marktab
editor: marktab
ms.service: machine-learning
ms.subservice: team-data-science-process
ms.topic: article
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
# Set up data science environments for use in the Team Data Science Process
The Team Data Science Process uses various data science environments for the storage, processing, and analysis of data. They include Azure Blob Storage, several types of Azure virtual machines, HDInsight (Hadoop) clusters, and Machine Learning workspaces. The decision about which environment to use depends on the type and quantity of data to be modeled and the target destination for that data in the cloud. 

* For guidance on questions to consider when making this decision, see [Plan Your Machine Learning Studio (classic) Data Science Environment](plan-your-environment.md). 
* For a catalog of some of the scenarios you might encounter when doing advanced analytics, see [Scenarios for the Team Data Science Process](plan-sample-scenarios.md)

The following articles describe how to set up the various data science environments used by the Team Data Science Process.

* [Azure storage-account](/azure/storage/common/storage-account-create)
* [HDInsight (Hadoop) cluster](/azure/hdinsight/spark/apache-spark-jupyter-spark-sql)
* [Machine Learning Studio (classic) workspace](/azure/machine-learning/classic/create-workspace)

The **Microsoft Data Science Virtual Machine (DSVM)** is also available as an Azure virtual machine (VM) image. This VM is pre-installed and configured with several popular tools that are commonly used for data analytics and machine learning. The DSVM is available on both Windows and Linux. For more information, see [Introduction to the cloud-based Data Science Virtual Machine for Linux and Windows](/azure/machine-learning/data-science-virtual-machine/overview).

Learn how to create:

- [Windows DSVM](/azure/machine-learning/data-science-virtual-machine/provision-vm)
- [Ubuntu DSVM](/azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro)
- [CentOS DSVM](/azure/machine-learning/data-science-virtual-machine/release-notes)
