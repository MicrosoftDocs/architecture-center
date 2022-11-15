---
title: Set up data science environments in Azure
description: Set up data science environments on Azure for use in the Team Data Science Process.
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
# Set up data science environments for use in the Team Data Science Process

The Team Data Science Process uses various data science environments for the storage, processing, and analysis of data. They include Azure Blob Storage, several types of Azure virtual machines, HDInsight (Hadoop) clusters, and Machine Learning workspaces. The decision about which environment to use depends on the type and quantity of data to be modeled and the target destination for that data in the cloud.

* See [Quickstart: Create workspace resources you need to get started with Azure Machine Learning](/azure/machine-learning/quickstart-create-resources).

The **Microsoft Data Science Virtual Machine (DSVM)** is also available as an Azure virtual machine (VM) image. This VM is pre-installed and configured with several popular tools that are commonly used for data analytics and machine learning. The DSVM is available on both Windows and Linux. For more information, see [Introduction to the cloud-based Data Science Virtual Machine for Linux and Windows](/azure/machine-learning/data-science-virtual-machine/overview).

Learn how to create:

- [Windows DSVM](/azure/machine-learning/data-science-virtual-machine/provision-vm)
- [Ubuntu DSVM](/azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro)
- [CentOS DSVM](/azure/machine-learning/data-science-virtual-machine/release-notes)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*
