---
title: Microsoft machine learning products
description: Compare options for building, deploying, and managing your machine learning models. Decide which Microsoft products to choose for your solution.
author: martinekuan
ms.author: architectures
categories: azure
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-machine-learning
ms.custom:
  - contperf-fy21q1
  - guide
---

# Compare Microsoft machine learning products and technologies

Learn about the machine learning products and technologies from Microsoft. Compare options to help you choose how to most effectively build, deploy, and manage your machine learning solutions.

## Cloud-based machine learning products

The following options are available for machine learning in the Azure cloud.

| Cloud&nbsp;options | What it is | What you can do with it |
|-|-|-|
| [Azure&nbsp;Machine&nbsp;Learning](#azure-machine-learning) | Managed platform for machine learning  | Use a pretrained model. Or, train, deploy, and manage models on Azure using Python and CLI |
| [Azure&nbsp;Cognitive&nbsp;Services](#azure-cognitive-services) | Pre-built AI capabilities implemented through REST APIs and SDKs  | Build intelligent applications quickly using standard programming languages. Doesn't require machine learning and data science expertise   |
| [Azure SQL Managed Instance Machine Learning Services](#sql-machine-learning) | In-database machine learning for SQL | Train and deploy models inside Azure SQL Managed Instance |
| [Machine learning in Azure Synapse Analytics](#sql-machine-learning) | Analytics service with machine learning | Train and deploy models inside Azure Synapse Analytics |
| [Machine learning and AI with ONNX in Azure SQL Edge](#sql-machine-learning) | Machine learning in SQL on IoT | Train and deploy models inside Azure SQL Edge |
| [Azure Databricks](#azure-databricks) | Apache Spark-based analytics platform | Build and deploy models and data workflows using integrations with open-source machine learning libraries and the [MLFlow](/azure/databricks/applications/mlflow/) platform. |

## On-premises machine learning products

The following options are available for machine learning on-premises. On-premises servers can also run in a virtual machine in the cloud.

| On-premises&nbsp;options | What it is | What you can do with it |
|-|-|-|
| [SQL Server Machine Learning Services](#sql-machine-learning) | In-database machine learning for SQL | Train and deploy models inside SQL Server |
| [Machine Learning Services on SQL Server Big Data Clusters](#sql-machine-learning) | Machine learning in Big Data Clusters | Train and deploy models on SQL Server Big Data Clusters |

## Development platforms and tools

The following development platforms and tools are available for machine learning.

| Platforms/tools | What it is | What you can do with it |
|-|-|-|
| [Azure&nbsp;Data&nbsp;Science Virtual Machine](#azure-data-science-virtual-machine) | Virtual machine with pre-installed data science tools | Develop machine learning solutions in a pre-configured environment |
| [ML.NET](#mlnet) | Open-source, cross-platform machine learning SDK | Develop machine learning solutions for .NET applications |
| [Windows ML](#windows-ml) | Windows 10 machine learning platform | Evaluate trained models on a Windows 10 device |
| [MMLSpark](#mmlspark) | Open-source, distributed, machine learning and microservices framework for Apache Spark | Create and deploy scalable machine learning applications for Scala and Python. |
| [Machine Learning extension for Azure Data Studio](#sql-machine-learning) | Open-source and cross-platform machine learning extension for Azure Data Studio | Manage packages, import machine learning models, make predictions, and create notebooks to run experiments for your SQL databases |

## Azure Machine Learning

[Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) is a fully managed cloud service used to train, deploy, and manage machine learning models at scale. It fully supports open-source technologies, so you can use tens of thousands of open-source Python packages such as TensorFlow, PyTorch, and scikit-learn. Rich tools are also available, such as [Compute instances](/azure/machine-learning/concept-compute-instance), [Jupyter notebooks](/azure/machine-learning/tutorial-1st-experiment-sdk-setup), or the [Azure Machine Learning for Visual Studio Code extension](/azure/machine-learning/tutorial-setup-vscode-extension), a free extension that allows you to manage your resources, model training workflows and deployments in Visual Studio Code. Azure Machine Learning includes features that automate model generation and tuning with ease, efficiency, and accuracy.

Use Python SDK, Jupyter notebooks, R, and the CLI for machine learning at cloud scale. For a low-code or no-code option, use Azure Machine Learning's interactive [designer](/azure/machine-learning/service/concept-designer) in the studio to easily and quickly build, test, and deploy models using pre-built machine learning algorithms.

[Try Azure Machine Learning for free](https://aka.ms/AMLFree).

|Item|Description|  
|--------|-----------|
|**Type**                   |Cloud-based machine learning solution|
|**Supported languages**    |Python, R|
|**Machine learning phases**|Model training<br>Deployment<br>MLOps/Management|
|**Key benefits**           |Code first (SDK) and studio & drag-and-drop designer web interface authoring options. <br/><br/>Central management of scripts and run history, making it easy to compare model versions.<br/><br/>Easy deployment and management of models to the cloud or edge devices.|
|**Considerations**         |Requires some familiarity with the model management model.|

## Azure Cognitive Services

[Azure Cognitive Services](/azure/cognitive-services/welcome) is a set of *pre-built* APIs that enable you to build apps that use natural methods of communication. The term pre-built suggests that you do not need to bring datasets or data science expertise to train models to use in your applications. That's all done for you and packaged as APIs and SDKs that allow your apps to see, hear, speak, understand, and interpret user needs with just a few lines of code. You can easily add intelligent features to your apps, such as:

- **Vision:** Object detection, face recognition, OCR, etc. See [Computer Vision](/azure/cognitive-services/computer-vision/), [Face](/azure/cognitive-services/face/), [Form Recognizer](/azure/cognitive-services/form-recognizer/).
- **Speech:** Speech-to-text, text-to-speech, speaker recognition, etc. See [Speech Service](/azure/cognitive-services/speech-service/).
- **Language:** Translation, Sentiment analysis, key phrase extraction, language understanding, etc. See [Translator](/azure/cognitive-services/translator/), [Text Analytics](/azure/cognitive-services/text-analytics/), [Language Understanding](/azure/cognitive-services/luis/), [QnA Maker](/azure/cognitive-services/qnamaker/)
- **Decision:** Anomaly detection, content moderation, reinforcement learning. See [Anomaly Detector](/azure/cognitive-services/anomaly-detector/), [Content Moderator](/azure/cognitive-services/content-moderator/), [Personalizer](/azure/cognitive-services/personalizer/).

Use Cognitive Services to develop apps across devices and platforms. The APIs keep improving, and are easy to set up.

|Item|Description|  
|--------|-----------|
|**Type**                   |APIs for building intelligent applications|
|**Supported languages**    |Various options depending on the service. Standard ones are C#, Java, JavaScript, and Python. |
|**Machine learning phases**|Deployment|
|**Key benefits**           |Build intelligent applications using pre-trained models available through REST API and SDK.<br/>Variety of models for natural communication methods with vision, speech, language, and decision.<br/>No machine learning or data science expertise required. |

## SQL machine learning

[SQL machine learning](/sql/machine-learning) adds statistical analysis, data visualization, and predictive analytics in Python and R for relational data, both on-premises and in the cloud. Current platforms and tools include:

- [SQL Server Machine Learning Services](/sql/machine-learning/sql-server-machine-learning-services)
- [Machine Learning Services on SQL Server Big Data Clusters](/sql/big-data-cluster/machine-learning-services)
- [Azure SQL Managed Instance Machine Learning Services](/azure/azure-sql/managed-instance/machine-learning-services-overview)
- [Machine learning in Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/what-is-machine-learning)
- [Machine learning and AI with ONNX in Azure SQL Edge](/azure/azure-sql-edge/onnx-overview)
- [Machine Learning extension for Azure Data Studio](/sql/azure-data-studio/machine-learning-extension)

Use SQL machine learning when you need built-in AI and predictive analytics on relational data in SQL.

|Item|Description|  
|--------|-----------|
|**Type**                   |On-premises predictive analytics for relational data|
|**Supported languages**    |Python, R, SQL|
|**Machine learning phases**|Data preparation<br>Model training<br>Deployment|
|**Key benefits**           |Encapsulate predictive logic in a database function, making it easy to include in data-tier logic.|
|**Considerations**         |Assumes a SQL database as the data tier for your application.|

## Azure Data Science Virtual Machine

The [Azure Data Science Virtual Machine](/azure/machine-learning/data-science-virtual-machine/overview) is a customized virtual machine environment on the Microsoft Azure cloud. It is available in versions for both Windows and Linux Ubuntu. The environment is built specifically for doing data science and developing ML solutions. It has many popular data science, ML frameworks, and other tools pre-installed and pre-configured to jump-start building intelligent applications for advanced analytics.

Use the Data Science VM when you need to run or host your jobs on a single node. Or if you need to remotely scale up your processing on a single machine.

|Item|Description|  
|--------|-----------|
|**Type**                   |Customized virtual machine environment for data science|
|**Key benefits**           |Reduced time to install, manage, and troubleshoot data science tools and frameworks.<br/><br/>The latest versions of all commonly used tools and frameworks are included.<br/><br/>Virtual machine options include highly scalable images with GPU capabilities for intensive data modeling.|
|**Considerations**         |The virtual machine cannot be accessed when offline.<br/><br/>Running a virtual machine incurs Azure charges, so you must be careful to have it running only when required.|

## Azure Databricks

[Azure Databricks](/azure/azure-databricks/what-is-azure-databricks) is an Apache Spark-based analytics platform optimized for the Microsoft Azure cloud services platform. Databricks is integrated with Azure to provide one-click setup, streamlined workflows, and an interactive workspace that enables collaboration between data scientists, data engineers, and business analysts. Use Python, R, Scala, and SQL code in web-based notebooks to query, visualize, and model data.

Use Databricks when you want to collaborate on building machine learning solutions on Apache Spark.

|Item|Description|  
|--------|-----------|
|**Type**                   |Apache Spark-based analytics platform|
|**Supported languages**    |Python, R, Scala, SQL|
|**Machine learning phases**|Data preparation<br>Data preprocessing<br>Model training<br>Model tuning<br>Model inference<br>Management<br>Deployment|

## ML.NET

[ML.NET](/dotnet/machine-learning/) is an open-source, and cross-platform machine learning framework. With ML.NET, you can build custom machine learning solutions and integrate them into your .NET applications. ML.NET offers varying levels of interoperability with popular frameworks like TensorFlow and ONNX for training and scoring machine learning and deep learning models. For resource-intensive tasks like training image classification models, you can take advantage of Azure to train your models in the cloud.

Use ML.NET when you want to integrate machine learning solutions into your .NET applications. Choose between the [API](/dotnet/machine-learning/how-does-mldotnet-work) for a code-first experience and [Model Builder](/dotnet/machine-learning/automate-training-with-model-builder) or the [CLI](/dotnet/machine-learning/automate-training-with-cli) for a low-code experience.

|Item|Description|  
|--------|-----------|
|**Type**                   |Open-source cross-platform framework for developing custom machine learning applications with .NET |
|**Languages supported**    |C#, F#|
|**Machine learning phases**    |Data preparation<br>Training<br>Deployment|
|**Key benefits**            |Data science & ML experience not required<br>Use familiar tools (Visual Studio, VS Code) and languages<br>Deploy where .NET runs<br>Extensible<br>Scalable<br>Local-first experience<br>|

## Windows ML

[Windows ML](/windows/uwp/machine-learning/) inference engine allows you to use trained machine learning models in your applications, evaluating trained models locally on Windows 10 devices.

Use Windows ML when you want to use trained machine learning models within your Windows applications.

|Item|Description|  
|--------|-----------|
|**Type**                   |Inference engine for trained models in Windows devices|
|**Languages supported**    |C#/C++, JavaScript|

## MMLSpark

[Microsoft ML for Apache Spark](https://aka.ms/spark/) (MMLSpark) is an open-source library that expands the distributed computing framework [Apache Spark](https://spark.apache.org/). MMLSpark adds many deep learning and data science tools to the Spark ecosystem, including seamless integration of [Spark Machine Learning](https://spark.apache.org/docs/latest/ml-guide.html) pipelines with [Microsoft Cognitive Toolkit (CNTK)](/cognitive-toolkit/), [LightGBM](https://github.com/microsoft/LightGBM), [LIME (Model Interpretability)](https://www.oreilly.com/learning/introduction-to-local-interpretable-model-agnostic-explanations-lime), and [OpenCV](https://opencv.org/). You can use these tools to create powerful predictive models on any Spark cluster, such as [Azure Databricks](#azure-databricks) or [Cosmic Spark](/azure/cosmos-db/spark-connector).

MMLSpark also brings new networking capabilities to the Spark ecosystem. With the HTTP on Spark project, users can embed any web service into their SparkML models. Additionally, MMLSpark provides easy-to-use tools for orchestrating [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) at scale. For production-grade deployment, the Spark Serving project enables high throughput, submillisecond latency web services, backed by your Spark cluster.

|Item|Description|  
|--------|-----------|
|**Type**                    |Open-source, distributed machine learning and microservices framework for Apache Spark|
|**Languages supported**     |Scala 2.11, Java, Python 3.5+, R (beta)|
|**Machine learning phases** |Data preparation<br>Model training<br>Deployment|
|**Key benefits**            |Scalability<br>Streaming + Serving compatible<br>Fault-tolerance|
|**Considerations**          |Requires Apache Spark|

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- To learn about all the Artificial Intelligence (AI) development products available from Microsoft, see [Microsoft AI platform](https://www.microsoft.com/ai).
- For training in developing AI and Machine Learning solutions with Microsoft, see [Microsoft Learn training](/training/browse/?resource_type=learning+path&roles=ai-engineer%2cdata-scientist).

## Related resources

- [Azure Machine Learning decision guide for optimal tool selection](../../example-scenario/mlops/aml-decision-tree.yml)
- [Choose a Microsoft cognitive services technology](../../data-guide/technology-choices/cognitive-services.md)
- [Artificial intelligence (AI) architecture design](../../data-guide/big-data/ai-overview.md)
- [How Azure Machine Learning works: resources and assets](/azure/machine-learning/concept-azure-machine-learning-v2)
- [Machine learning at scale](../../data-guide/big-data/machine-learning-at-scale.md)