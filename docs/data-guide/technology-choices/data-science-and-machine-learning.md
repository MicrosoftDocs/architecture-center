---
title: Choosing a machine learning technology
description: Compare options for building, deploying, and managing your machine learning models. Decide which Microsoft products to choose for your solution.
author: adamboeglin
ms.date: 07/30/2020
ms.topic: guide
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

<!-- markdownlint-disable MD026 -->

# What are the machine learning products at Microsoft?

In this article, you will learn about the machine learning options to prep, train, deploy, and manage your models at Microsoft. Compare these options and choose what will help you build your machine learning solutions most effectively.

## Cloud-based options

The following options are available for machine learning in the Azure cloud.

| Cloud&nbsp;options | What it is | What you can do with it |
|-|-|-|
| [Azure&nbsp;Machine&nbsp;Learning](#azure-machine-learning) | Cloud-based: Managed cloud service for machine learning  | Train, deploy, and manage models in Azure using Python and CLI |

## On-premises options

The following options are available for machine learning on-premises. On-premises servers can also run in a virtual machine in the cloud.

| On-premises&nbsp;options | What it is | What you can do with it |
|-|-|-|
| [SQL Server Machine Learning Services](#sql-server-machine-learning-services) | On-premises analytics engine embedded in SQL | Build and deploy models inside SQL Server |

## Development platforms and tools

The following development platforms and tools are available for machine learning.

| Platforms/tools | What it is | What you can do with it |
|-|-|-|
| [Azure&nbsp;Data&nbsp;Science Virtual Machine](#azure-data-science-virtual-machine) | Virtual machine with pre-installed data science tools | Develop machine learning solutions in a pre-configured environment |
| [Azure Databricks](#azure-databricks) | Spark-based analytics platform | Build and deploy models and data workflows |
| [ML.NET](#mlnet) | Open-source, cross-platform machine learning SDK | Develop machine learning solutions for .NET applications |
| [Windows ML](#windows-ml) | Windows 10 machine learning platform | Evaluate trained models on a Windows 10 device |
| [MMLSpark](#mmlspark) | Open-source, distributed, machine learning and microservices framework for Apache Spark | Create and deploy scalable machine learning applications for Scala and Python. |

## Azure Machine Learning

[Azure Machine Learning](https://docs.microsoft.com/azure/machine-learning/service/overview-what-is-azure-ml) is a fully managed cloud service used to train, deploy, and manage machine learning models at scale. It fully supports open-source technologies, so you can use tens of thousands of open-source Python packages such as TensorFlow, PyTorch, and scikit-learn. Rich tools are also available, such as [Azure notebooks](https://notebooks.azure.com/), [Jupyter notebooks](http://jupyter.org), or the [Azure Machine Learning for Visual Studio Code](https://aka.ms/vscodetoolsforai) extension to make it easy to explore and transform data, and then train and deploy models. Azure Machine Learning includes features that automate model generation and tuning with ease, efficiency, and accuracy.

Use Azure Machine Learning to train, deploy, and manage machine learning models using Python and CLI at cloud scale. For a low-code or no-code option, use the interactive, [designer](https://docs.microsoft.com/azure/machine-learning/service/concept-designer) (preview) to easily and quickly build, test, and deploy models using pre-built machine learning algorithms.

Try the [free or paid version of Azure Machine Learning](https://aka.ms/AMLFree).

<!-- markdownlint-disable MD033 -->

|||
|-|-|
|**Type**                   |Cloud-based machine learning solution|
|**Supported languages**    |Python, R|
|**Machine learning phases**|Data preparation<br>Model training<br>Deployment<br>Management|
|**Key benefits**           |Code first and studio web interface authoring options. Central management of scripts and run history, making it easy to compare model versions.<br/><br/>Easy deployment and management of models to the cloud or edge devices.|
|**Considerations**         |Requires some familiarity with the model management model.|

## Azure Cognitive Services

[Azure Cognitive Services](https://docs.microsoft.com/azure/cognitive-services/welcome) is a set of APIs that enable you to build apps that use natural methods of communication. These APIs allow your apps to see, hear, speak, understand, and interpret user needs with just a few lines of code. Easily add intelligent features to your apps, such as:

- Emotion and sentiment detection
- Vision and speech recognition
- Language understanding (LUIS)
- Knowledge and search

Use Cognitive Services to develop apps across devices and platforms. The APIs keep improving, and are easy to set up.

|||
|-|-|
|**Type**                   |APIs for building intelligent applications|
|**Supported languages**    |many options depending on the service|
|**Machine learning phases**|Deployment|
|**Key benefits**           |Incorporating machine learning capabilities in applications using pre-trained models.<br/><br/>Variety of models for natural communication methods with vision and speech.|

## SQL Server Machine Learning Services

[SQL Server Microsoft Machine Learning Service](https://docs.microsoft.com/sql/advanced-analytics/r/r-services) adds statistical analysis, data visualization, and predictive analytics in R and Python for relational data in SQL Server databases. R and Python libraries from Microsoft include advanced modeling and machine learning algorithms, which can run in parallel and at scale, in SQL Server.

Use SQL Server Machine Learning Services when you need built-in AI and predictive analytics on relational data in SQL Server.

|||
|-|-|
|**Type**                   |On-premises predictive analytics for relational data|
|**Supported languages**    |Python, R|
|**Machine learning phases**|Data preparation<br>Model training<br>Deployment|
|**Key benefits**           |Encapsulate predictive logic in a database function, making it easy to include in data-tier logic.|
|**Considerations**         |Assumes a SQL Server database as the data tier for your application.|

## Azure Data Science Virtual Machine

The [Azure Data Science Virtual Machine](https://docs.microsoft.com/azure/machine-learning/data-science-virtual-machine/overview) is a customized virtual machine environment on the Microsoft Azure cloud. The environment is built specifically for doing data science and developing ML solutions. It has many popular data science, ML frameworks, and other tools pre-installed and pre-configured to jump-start building intelligent applications for advanced analytics.

The Data Science Virtual Machine is supported as a target for Azure Machine Learning. It is available in versions for both Windows and Linux Ubuntu. For specific version information and a list of what's included, see [Introduction to the Azure Data Science Virtual Machine](https://docs.microsoft.com/azure/machine-learning/data-science-virtual-machine/overview).

Use the Data Science VM when you need to run or host your jobs on a single node. Or if you need to remotely scale up your processing on a single machine.

|||
|-|-|
|**Type**                   |Customized virtual machine environment for data science|
|**Key benefits**           |Reduced time to install, manage, and troubleshoot data science tools and frameworks.<br/><br/>The latest versions of all commonly used tools and frameworks are included.<br/><br/>Virtual machine options include highly scalable images with GPU capabilities for intensive data modeling.|
|**Considerations**         |The virtual machine cannot be accessed when offline.<br/><br/>Running a virtual machine incurs Azure charges, so you must be careful to have it running only when required.|

## Azure Databricks

[Azure Databricks](https://docs.microsoft.com/azure/azure-databricks/what-is-azure-databricks) is an Apache Spark-based analytics platform optimized for the Microsoft Azure cloud services platform. Databricks is integrated with Azure to provide one-click setup, streamlined workflows, and an interactive workspace that enables collaboration between data scientists, data engineers, and business analysts.
Use Python, R, Scala, and SQL code in web-based notebooks to query, visualize, and model data.

Use Databricks when you want to collaborate on building machine learning solutions on Apache Spark.

|||
|-|-|
|**Type**                   |Apache Spark-based analytics platform|
|**Supported languages**    |Python, R, Scala, SQL|
|**Machine learning phases**|Data query<br>Model training|

## ML.NET

[ML.NET](https://docs.microsoft.com/dotnet/machine-learning/) is a free, open-source, and cross-platform machine learning framework that enables you to build custom machine learning solutions and integrate them into your .NET applications.

Use ML.NET when you want to integrate machine learning solutions into your .NET applications.

|||
|-|-|
|**Type**                   |Open-source framework for developing custom machine learning applications|
|**Languages supported**    |.NET|

## Windows ML

[Windows ML](https://docs.microsoft.com/windows/uwp/machine-learning/) inference engine allows you to use trained machine learning models in your applications, evaluating trained models locally on Windows 10 devices.

Use Windows ML when you want to use trained machine learning models within your Windows applications.

|||
|-|-|
|**Type**                   |Inference engine for trained models in Windows devices|
|**Languages supported**    |C#/C++, JavaScript|

## MMLSpark

[Microsoft ML for Apache Spark](https://aka.ms/spark/) (MMLSpark) is an open source library that expands the distributed computing framework [Apache Spark](https://spark.apache.org/). MMLSpark adds many deep learning and data science tools to the Spark ecosystem, including seamless integration of [Spark Machine Learning](https://spark.apache.org/docs/latest/ml-guide.html) pipelines with [Microsoft Cognitive Toolkit (CNTK)](https://docs.microsoft.com/cognitive-toolkit/), [LightGBM](https://github.com/microsoft/LightGBM), [LIME (Model Interpretability)](https://www.oreilly.com/learning/introduction-to-local-interpretable-model-agnostic-explanations-lime), and [OpenCV](https://opencv.org/). You can use these tools to create powerful predictive models on any Spark cluster, such as [Azure Databricks](#azure-databricks) or [Cosmic Spark](https://docs.microsoft.com/azure/cosmos-db/spark-connector).

MMLSpark also brings new networking capabilities to the Spark ecosystem. With the HTTP on Spark project, users can embed any web service into their SparkML models. Additionally, MMLSpark provides easy-to-use tools for orchestrating [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) at scale. For production-grade deployment, the Spark Serving project enables high throughput, sub-millisecond latency web services, backed by your Spark cluster.

|||
|-|-|
|**Type**                    |Open-source, distributed machine learning and microservices framework for Apache Spark|
|**Languages supported**     |Scala 2.11, Java, Python 3.5+, R (beta)|
|**Machine learning phases** |Data preparation<br>Model training<br>Deployment|
|**Key benefits**            |Scalability<br>Streaming + Serving compatible<br>Fault-tolerance|
|**Considerations**          |Requires Apache Spark|

## Next steps

- To learn about all the Artificial Intelligence (AI) development products available from Microsoft, see [Microsoft AI platform](https://www.microsoft.com/ai)
    
- For training in developing AI and Machine Learning solutions with Microsoft, see [Microsoft Learn](https://docs.microsoft.com/learn/browse/?roles=ai-engineer%2Cdata-scientist&resource_type=learning%20path)
