---
title: Overview of Microsoft Machine Learning Products and Technologies
description: Compare options for building, deploying, and managing your machine learning models. Decide which Microsoft products to choose for your solution.
author: RobBagby
ms.author: robbag
categories: azure
ms.date: 11/15/2024
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.service: azure-architecture-center
ms.subservice: architecture-guide
products:
  - azure-machine-learning
ms.custom:
  - guide
  - arb-aiml
---

# Compare Microsoft machine learning products and technologies

Learn about the machine learning products and technologies from Microsoft. Compare options to help you choose how to most effectively build, deploy, and manage your machine learning solutions.

## Cloud-based machine learning products

The following options are available for machine learning in the Azure cloud.

| Cloud&nbsp;options | What it is | What you can do with it |
|-|-|-|
| [Azure&nbsp;Machine&nbsp;Learning](#azure-machine-learning) | Managed platform for machine learning  | Use a pretrained model, or train, deploy, and manage models on Azure using Python and CLI. Includes features like automated machine learning (AutoML), prompt flow, model catalog, and MLflow integration. Track and understand model performance during production |
| [Microsoft Fabric](#microsoft-fabric) | Unified analytics platform | Manage the entire data lifecycle, from ingestion to insights, with a comprehensive platform that integrates various services and tools for data professionals, including data engineers, data scientists, and business analysts |
| [Azure&nbsp;AI&nbsp;Services](#azure-ai-services) | Pre-built AI capabilities implemented through REST APIs and SDKs  | Build intelligent applications using standard programming languages which call APIs that provide inferencing. While machine learning and data science expertise is still ideal to have, this platform can also be adopted by engineering teams without such skills |
| [Azure SQL Managed Instance Machine Learning Services](#sql-machine-learning) | In-database machine learning for SQL | Train and deploy models inside Azure SQL Managed Instance |
| [Machine learning in Azure Synapse Analytics](#sql-machine-learning) | Analytics service with machine learning | Train and deploy models inside Azure Synapse Analytics |
| [Azure Databricks](#azure-databricks) | Apache Spark-based analytics platform | Build and deploy models and data workflows using integrations with open-source machine learning libraries and the [MLflow](/azure/databricks/applications/mlflow/) platform. |

## On-premises machine learning product

The following option is available for machine learning on-premises. On-premises servers can also run in a virtual machine in the cloud.

| On-premises | What it is | What you can do with it |
|-|-|-|
| [SQL Server Machine Learning Services](#sql-machine-learning) | In-database machine learning for SQL | Train and deploy models inside SQL Server using Python and R scripts |

## Development platforms and tools

The following development platforms and tools are available for machine learning.

| Platforms/tools | What it is | What you can do with it |
|-|-|-|
| [Azure&nbsp;AI&nbsp;Studio](#azure-ai-studio) | Unified development environment for AI and ML scenarios | Develop, evaluate, and deploy AI models and applications. Facilitates collaboration and project management across various Azure AI services and can even be used as a common environment across multiple workload teams. |
| [Azure&nbsp;Machine&nbsp;Learning&nbsp;Studio](/azure/machine-learning) | Collaborative, drag-and-drop tool for machine learning | Build, test, and deploy predictive analytics solutions with minimal coding. Supports a wide range of machine learning algorithms and AI models. It has tools for data preparation, model training, and evaluation. |
| [Azure&nbsp;Data&nbsp;Science Virtual Machine](#azure-data-science-virtual-machine) | Virtual machine image with pre-installed data science tools | Develop machine learning solutions on your own VMs with this pre-configured environment with tools like Jupyter, R, and Python.|
| [ML.NET](#mlnet) | Open-source, cross-platform machine learning SDK | Develop machine learning solutions for .NET applications. |
| [Windows AI](#windows-ai) | Inference engine for trained models on Windows devices | A platform that integrates artificial intelligence capabilities into Windows applications using components like Windows Machine Learning ([WinML](/windows/ai/windows-ml/overview)) and Direct Machine Learning ([DirectML](/windows/ai/directml/dml)) for local, real-time AI model evaluation and hardware acceleration. |
| [SynapseML](#synapseml) | Open-source, distributed, machine learning and microservices framework for Apache Spark | Create and deploy scalable machine learning applications for Scala and Python. |
| [Machine Learning extension for Azure Data Studio](#sql-machine-learning) | Open-source and cross-platform machine learning extension for Azure Data Studio | Manage packages, import machine learning models, make predictions, and create notebooks to run experiments for your SQL databases |

## Azure Machine Learning

[Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) is a fully managed cloud service used to train, deploy, and manage machine learning models at scale. It fully supports open-source technologies, so you can use tens of thousands of open-source Python packages such as TensorFlow, PyTorch, and scikit-learn. Rich tools are also available, such as [Compute instances](/azure/machine-learning/concept-compute-instance), [Jupyter notebooks](/azure/machine-learning/tutorial-1st-experiment-sdk-setup), or the [Azure Machine Learning for Visual Studio Code (VS Code) extension](/azure/machine-learning/tutorial-setup-vscode-extension), a free extension that allows you to manage your resources, model training workflows and deployments in Visual Studio Code. Azure Machine Learning includes features that automate model generation and tuning with ease, efficiency, and accuracy.

Use Python SDK, Jupyter notebooks, R, and the CLI for machine learning at cloud scale. For a low-code or no-code option, use Azure Machine Learning's interactive [designer](/azure/machine-learning/service/concept-designer) in the studio to easily and quickly build, test, and deploy models using pre-built machine learning algorithms. Additionally, Azure Machine Learning provides integration with Azure DevOps and GitHub Actions for continuous integration and continuous deployment (CI/CD) of machine learning models.

|Item|Description|
|--------|-----------|
|**Type**                   |Cloud-based machine learning solution|
|**Supported languages**    |Python, R|
|**Machine learning phases**|Data Preparation<br>Model training<br>Deployment<br>MLOps/Management<br>Responsible AI|
|**Key benefits**           |Code first (SDK) and studio and drag-and-drop designer web interface authoring options. <br/>Central management of scripts and run history, making it easy to compare model versions.<br/>Easy deployment and management of models to the cloud or edge devices.<br/>Offers scalable training, deployment, and management of machine learning models.|
|**Considerations**         |Requires some familiarity with the model management model.|

## Azure AI services

[Azure AI services](/azure/ai-services/what-are-ai-services) is a comprehensive suite of pre-built APIs that enable developers and organizations to create intelligent, market-ready applications rapidly. These services offer out-of-the-box and customizable APIs and SDKs that allow your apps to see, hear, speak, understand, and interpret user needs with minimal code, making it unnecessary to bring datasets or data science expertise to train models. You can add intelligent features to your apps, such as:

- **Vision:** Object detection, face recognition, optical character recognition (OCR), and so on. For more information, see [Computer Vision](/azure/ai-services/computer-vision/), [Face](/azure/ai-services/computer-vision/overview-identity), [Document Intelligence](/azure/ai-services/document-intelligence/).
- **Speech:** Speech to text, text to speech, Speaker Recognition, and so on. For more information, see [Speech service](/azure/ai-services/speech-service/).
- **Language:** Translation, Sentiment analysis, key phrase extraction, language understanding, and so on. For more information, see [Azure OpenAI Services](/azure/ai-services/openai/), [Translator](/azure/ai-services/translator/), [Immersive Reader](/azure/ai-services/immersive-reader/), [Bot service](/composer/) and [Language services](/azure/ai-services/language-service/).
- **Decision:** detecting unwanted content and making informed decisions [Content Safety](/azure/ai-services/content-safety/).
- **Search and Knowledge:** Bring AI-powered cloud search and knowledge mining capabilities to your apps. For more information, see [Azure AI Search](/azure/search/).

Use Azure AI services to develop apps across devices and platforms. The APIs keep improving, and are easy to set up.

|Item|Description|
|--------|-----------|
|**Type**                   |APIs for building intelligent applications|
|**Supported languages**    |Various options depending on the service. Standard ones are C#, Java, JavaScript, and Python. |
|**Machine learning phases**|Deployment|
|**Key benefits**           |Build intelligent applications using pre-trained models available through REST API and SDK.<br/>Variety of models for natural communication methods with vision, speech, language, and decision.<br/>No or minimal machine learning or data science expertise required.<br/>Scalability and flexibility.<br/>Variety of models.|

## SQL machine learning

[SQL machine learning](/sql/machine-learning) adds statistical analysis, data visualization, and predictive analytics in Python and R for relational data, both on-premises and in the cloud. Current platforms and tools include:

- [SQL Server Machine Learning Services](/sql/machine-learning/sql-server-machine-learning-services)
- [Azure SQL Managed Instance Machine Learning Services](/azure/azure-sql/managed-instance/machine-learning-services-overview)
- [Machine learning in Azure Synapse Analytics](/azure/synapse-analytics/machine-learning/what-is-machine-learning)
- [Machine Learning extension for Azure Data Studio](/sql/azure-data-studio/machine-learning-extension)

Use SQL machine learning when you need built-in AI and predictive analytics on relational data in SQL.

|Item|Description|
|--------|-----------|
|**Type**                   |On-premises predictive analytics for relational data|
|**Supported languages**    |Python, R, SQL|
|**Machine learning phases**|Data preparation<br>Model training<br>Deployment|
|**Key benefits**           |Encapsulate predictive logic in a database function, making it easy to include in data-tier logic.|
|**Considerations**         |Assumes a SQL database as the data tier for your application.|

## Azure AI Studio

Azure AI Studio is a unified platform for developing and deploying generative AI applications and Azure AI APIs responsibly. It offers a comprehensive set of AI capabilities, a simplified user interface, and code-first experiences, making it a one-stop shop for building, testing, deploying, and managing intelligent solutions. Designed to help developers and data scientists efficiently create and deploy generative AI applications using the Azure extensive AI offerings, Azure AI Studio emphasizes responsible AI development with embedded principles of fairness, transparency, and accountability. The platform includes tools for bias detection, interpretability, and privacy-preserving machine learning, ensuring that AI models are powerful, trustworthy, and compliant with regulatory requirements. As part of Microsoft's Azure ecosystem, AI Studio provides robust tools and services catering to various AI and machine learning needs, from natural language processing to computer vision. Its integration with other Azure services ensures seamless scalability and performance, making it ideal for enterprises. Azure AI Studio also fosters collaboration and innovation, supporting a collaborative environment with features like shared workspaces, version control, and integrated development environments. By integrating popular open-source frameworks and tools, Azure AI Studio accelerates the development process, empowering organizations to drive innovation and stay ahead in the competitive AI landscape.

|Item|Description|
|--------|-----------|
|**Type**                   |Unified development environment for AI|
|**Supported languages**    |Python only|
|**Machine learning phases**|Data preparation<br>Deployment (Models as a service)|
|**Key benefits**           |Facilitates collaboration and project management across various Azure AI services.<br/>Provides comprehensive tools for building, training, and deploying AI models.<br/>Emphasizes responsible AI with tools for bias detection, interpretability, and privacy-preserving machine learning.<br/>Supports integration with popular open-source frameworks and tools.<br/>Includes Microsoft Prompt flow for creating and managing prompt-based workflows, simplifying the development cycle of AI applications powered by Large Language Models (LLMs).|

## Azure Machine Learning studio

[Azure Machine Learning Studio](/azure/machine-learning/overview-what-is-azure-ml) is a collaborative, drag-and-drop tool for building, testing, and deploying predictive analytics solutions on your data. It is designed for data scientists, data engineers, and business analysts. Azure Machine Learning studio supports a wide range of machine learning algorithms and tools for data preparation, model training, and evaluation. It also provides a visual interface for connecting datasets and modules on an interactive canvas.

|Item|Description|
|--------|-----------|
|**Type**                   |Collaborative, drag-and-drop tool for machine learning|
|**Supported languages**    |Python, R, Scala and Java (limited experience)|
| **Machine learning phases**|Data preparation<br>Model training<br>Deployment|
|**Key benefits**           |No coding required to build machine learning models.<br/>Supports a wide range of machine learning algorithms and tools for data preparation, model training, and evaluation.<br/>Provides a visual interface for connecting datasets and modules on an interactive canvas.<br/>Supports integration with Azure Machine Learning for advanced machine learning tasks.|

For a compressive comparison of Azure Machine Learning studio and Azure AI Studio, see [AI Studio or Azure Machine Learning Studio](/ai/ai-studio-experiences-overview). Here are some key differences between the two:

| Category             | Feature                         | Azure AI Studio                                  | Azure Machine Learning studio               |
|----------------------|---------------------------------|-------------------------------------------------|---------------------------------------------|
| **Data Storage**     | Storage solution                | No                                              | Yes (cloud filesystem, OneLake, Azure Storage) |
| **Data Preparation** | Data integration                | Yes (blob storage, OneLake, ADLS)               | Yes (copy and mount with Azure Storage Accounts) |
| **Development**      | Code-first tools                | Yes (Visual Studio Code (VS Code))                                   | Yes (Notebooks, Jupyter, VS Code, R Studio) |
| **Languages**        | Supported languages             | Python only                                     | Python, R, Scala, Java                      |
| **Training**         | AutoML                          | No                                              | Yes (regression, classification, forecasting, CV, NLP) |
| **Compute Targets**  | Training compute                | Serverless (MaaS, prompt flow)                  | Spark clusters, ML clusters, Azure Arc            |
| **Generative AI**    | LLM catalog                     | Yes (Azure OpenAI, Hugging Face, Meta)          | Yes (Azure OpenAI, Hugging Face, Meta)      |
| **Deployment**       | Real-time and batch serving     | Real-time (MaaS)                                | Batch endpoints, Azure Arc                  |
| **Governance**       | Responsible AI tools            | No                                              | Yes (Responsible AI dashboard)              |

## Microsoft Fabric

[Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) is an end-to-end, unified analytics platform that brings together all the data and analytics tools that organizations need. It integrates various services and tools to provide a seamless experience for data professionals, including data engineers, data scientists, and business analysts. Microsoft Fabric offers capabilities for data integration, data engineering, data warehousing, data science, real-time analytics, and business intelligence.

Use Microsoft Fabric when you need a comprehensive platform to manage your entire data lifecycle, from ingestion to insights.

|Item|Description|
|--------|-----------|
|**Type**                   |Unified analytics platform|
|**Supported languages**    |Python, R, SQL, Scala|
|**Machine learning phases**|Data preparation<br>Model training<br>Deployment<br>Real-time analytics|
|**Key benefits**           |Unified platform for all data and analytics needs.<br>Seamless integration with other Microsoft services.<br>Scalable and flexible.<br>Supports a wide range of data and analytics tools.<br>Facilitates collaboration across different roles in an organization.<br>End-to-end data lifecycle management from ingestion to insights.<br>Real-time analytics and business intelligence capabilities.<br>Supports machine learning model training and deployment.<br>Integration with popular machine learning frameworks and tools.<br>Provides tools for data preparation and feature engineering.<br>Enables real-time machine learning inference and analytics.|

## Azure Data Science Virtual Machine

The [Azure Data Science Virtual Machine](/azure/machine-learning/data-science-virtual-machine/overview) is a customized virtual machine environment on the Microsoft Azure cloud. It is available in versions for both Windows and Linux Ubuntu. The environment is built specifically for doing data science and developing machine learning solutions. It has many popular data science, machine learning frameworks, and other tools pre-installed and pre-configured to jump-start building intelligent applications for advanced analytics.

Use the Data Science VM when you need to run or host your jobs on a single node. Or if you need to remotely scale up your processing on a single machine.

|Item|Description|
|--------|-----------|
|**Type**                   |Customized virtual machine environment for data science|
|**Key benefits**           |Reduced time to install, manage, and troubleshoot data science tools and frameworks.<br/><br/>The latest versions of all commonly used tools and frameworks are included.<br/><br/>Virtual machine options include highly scalable images with graphics processing unit (GPU) capabilities for intensive data modeling.|
|**Considerations**         |The virtual machine cannot be accessed when offline.<br/><br/>Running a virtual machine incurs Azure charges, so you must be careful to have it running only when required.|

## Azure Databricks

[Azure Databricks](/azure/azure-databricks/what-is-azure-databricks) is an Apache Spark-based analytics platform optimized for the Microsoft Azure cloud platform. Databricks is integrated with Azure to provide one-click setup, streamlined workflows, and an interactive workspace that enables collaboration between data scientists, data engineers, and business analysts. Use Python, R, Scala, and SQL code in web-based notebooks to query, visualize, and model data.

Use Databricks when you want to collaborate on building machine learning solutions on Apache Spark.

|Item|Description|
|--------|-----------|
|**Type**                   |Apache Spark-based analytics platform|
|**Supported languages**    |Python, R, Scala, SQL|
|**Machine learning phases**|Data preparation<br>Data preprocessing<br>Model training<br>Model tuning<br>Model inference<br>Management<br>Deployment|
|**Key benefits**| One-click setup and streamlined workflows for easy use.<br>Interactive workspace for collaboration.<br>Seamless integration with Azure.<br>Scalability to handle large datasets and intensive computations.<br>Support for various languages and integration with popular tools.|

## ML.NET

[ML.NET](/dotnet/machine-learning/) is an open-source, and cross-platform machine learning framework. With ML.NET, you can build custom machine learning solutions and integrate them into your .NET applications. ML.NET offers varying levels of interoperability with popular frameworks like TensorFlow and ONNX for training and scoring machine learning and deep learning models. For resource-intensive tasks like training image classification models, you can take advantage of Azure to train your models in the cloud.

Use ML.NET when you want to integrate machine learning solutions into your .NET applications. Choose between the [API](/dotnet/machine-learning/how-does-mldotnet-work) for a code-first experience and [Model Builder](/dotnet/machine-learning/automate-training-with-model-builder) or the [CLI](/dotnet/machine-learning/automate-training-with-cli) for a low-code experience.

|Item|Description|
|--------|-----------|
|**Type**                   |Open-source cross-platform framework for developing custom machine learning applications with .NET |
|**Languages supported**    |C#, F#|
|**Machine learning phases**    |Data preparation<br>Training<br>Deployment|
|**Key benefits**            |Data science and machine learning experience not required<br>Use familiar tools (Visual Studio, Microsoft Visual Studio Code) and languages<br>Deploy where .NET runs<br>Extensible<br>Scalable<br>Local-first experience<br>AutoML for automated machine learning tasks|

## Windows AI

[Windows AI](/windows/ai/) Windows AI is a powerful platform that integrates artificial intelligence capabilities into Windows applications, using the strengths of Windows Machine Learning (WinML) and Direct Machine Learning (DirectML) to provide local, real-time AI model evaluation and hardware acceleration. WinML allows developers to integrate trained machine learning models directly into their Windows applications. It facilitates local, real-time evaluation of models, enabling powerful AI capabilities without the need for cloud connectivity.

DirectML is a high-performance, hardware-accelerated platform for executing machine learning models. It utilizes the DirectX API to provide optimized performance across diverse hardware, including GPUs and AI accelerators.

Use Windows AI when you want to use trained machine learning models within your Windows applications.

|Item|Description|
|--------|-----------|
|**Type**                   |Inference engine for trained models in Windows devices|
|**Machine learning phases**|Data preparation<br>Model training<br>Deployment|
|**Languages supported**    |C#/C++, JavaScript|
|**Key benefits**            |Local, real-time AI model evaluation<br>Achieve high-performance AI processing across various hardware types, including CPUs, GPUs, and AI accelerators<br/>Ensures consistent behavior and performance across different Windows hardware.|

## SynapseML

[SynapseML](https://aka.ms/spark/) (formerly known as MMLSpark) is an open-source library that simplifies the creation of massively scalable machine learning pipelines. SynapseML provides APIs for a variety of different machine learning tasks such as text analytics, vision, anomaly detection, and many others. SynapseML is built on the [Apache Spark](https://spark.apache.org/) distributed computing framework and shares the same API as the SparkML/MLLib library, allowing you to seamlessly embed SynapseML models into existing Apache Spark workflows.

SynapseML adds many deep learning and data science tools to the Spark ecosystem, including seamless integration of [Spark Machine Learning](https://spark.apache.org/docs/latest/ml-guide.html) pipelines with [Light Gradient Boosting Machine (LightGBM)](https://github.com/microsoft/LightGBM), [LIME (Model Interpretability)](https://www.oreilly.com/learning/introduction-to-local-interpretable-model-agnostic-explanations-lime), and [OpenCV](https://opencv.org/). You can use these tools to create powerful predictive models on any Spark cluster, such as [Azure Databricks](#azure-databricks) or [Cosmic Spark](/azure/cosmos-db/spark-connector).

SynapseML also brings networking capabilities to the Spark ecosystem. With the HTTP on Spark project, users can embed any web service into their SparkML models. Additionally, SynapseML provides easy-to-use tools for orchestrating [Azure AI services](https://azure.microsoft.com/products/ai-services/) at scale. For production-grade deployment, the Spark Serving project enables high throughput, submillisecond latency web services, backed by your Spark cluster.

|Item|Description|
|--------|-----------|
|**Type**                    |Open-source, distributed machine learning and microservices framework for Apache Spark|
|**Languages supported**     |Scala, Java, Python, R and .NET|
|**Machine learning phases** |Data preparation<br>Model training<br>Deployment|
|**Key benefits**            |Scalability<br>Streaming + Serving compatible<br>Fault-tolerance|
|**Considerations**          |Requires Apache Spark|

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Mahdi Setayesh](https://www.linkedin.com/in/mahdi-setayesh-a03aa644/) | Principal Software Engineer

## Next steps

- Learn about all the Artificial Intelligence (AI) development products available from Microsoft: [Microsoft AI platform](https://www.microsoft.com/ai).
- Get training in developing AI and Machine Learning solutions with Microsoft: [Microsoft Learn training](/training/browse/?resource_type=learning+path&roles=ai-engineer%2cdata-scientist).
- Explore more about Microsoft Fabric: [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview).
- Discover Azure AI services: [Azure AI services](/azure/ai-services/).
- Explore Azure Machine Learning: [Azure Machine Learning](/azure/machine-learning/).
- Learn about Azure Databricks: [Azure Databricks](/azure/azure-databricks/).
- Discover Azure Synapse Analytics: [Azure Synapse Analytics](/azure/synapse-analytics/).
- Explore Azure SQL Managed Instance Machine Learning Services: [Azure SQL Managed Instance Machine Learning Services](/azure/azure-sql/managed-instance/machine-learning-services-overview).

## Related resources

- [Choose a Microsoft Azure AI services technology](../../data-guide/technology-choices/ai-services.md)
- [Artificial intelligence (AI) architecture design](../../data-guide/big-data/ai-overview.md)
- [How Azure Machine Learning works: resources and assets](/azure/machine-learning/concept-azure-machine-learning-v2)
- [Microsoft Fabric](/fabric/)
