---
title: Overview of Microsoft Machine Learning Products and Technologies
description: Compare options for building, deploying, and managing your machine learning models. Decide which Microsoft products to choose for your solution.
author: claytonsiemens77
ms.author: pnp
ms.date: 01/27/2025
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
---

# Compare Microsoft machine learning products and technologies

Learn about the machine learning products and technologies from Microsoft. Compare options to help you choose how to most effectively build, deploy, and manage your machine learning solutions.

## Cloud-based machine learning products

The following options are available for machine learning in the Azure cloud.

| Cloud&nbsp;option | Description | Features and uses |
|-|-|-|
| [Azure&nbsp;Machine&nbsp;Learning](#azure-machine-learning) | Managed platform for machine learning  | Use a pretrained model, or train, deploy, and manage models on Azure by using Python and a CLI. Machine Learning includes features like automated machine learning (AutoML), model catalog, and MLflow integration. You can track and understand model performance during the production stage. |
| [Microsoft Fabric](#microsoft-fabric) | Unified analytics platform | Manage the entire data lifecycle, from ingestion to insights, by using a comprehensive platform that integrates various services and tools for data professionals, including data engineers, data scientists, and business analysts. |
| [Azure&nbsp;AI&nbsp;services](#azure-ai-services) | Prebuilt AI capabilities that are implemented through REST APIs and SDKs  | Build intelligent applications by using standard programming languages. These languages call APIs that provide inferencing. Although you should ideally have machine learning and data science expertise, engineering teams that don't have these skills can also adopt this platform. |
| [Azure SQL Managed Instance machine learning services](#sql-machine-learning) | In-database machine learning for SQL | Train and deploy models inside SQL Managed Instance. |
| [Azure Databricks](#azure-databricks) | Apache Spark-based analytics platform | Build and deploy models and data workflows by integrating with open-source machine learning libraries and the [MLflow](/azure/databricks/applications/mlflow/) platform. |

## On-premises machine learning product

The following option is available for machine learning on-premises. On-premises servers can also run in a virtual machine (VM) in the cloud.

| On-premises product | Description | Features and uses |
|-|-|-|
| [SQL Server machine learning services](#sql-machine-learning) | In-database machine learning for SQL | Train and deploy models inside SQL Server by using Python and R scripts. |

## Development platforms and tools

The following development platforms and tools are available for machine learning.

| Platform or tool | Description | Features and uses |
|-|-|-|
| [Azure&nbsp;AI&nbsp;Microsoft Foundry&nbsp;portal](#microsoft-foundry) | Unified development environment for AI and machine learning scenarios | Develop, evaluate, and deploy AI models and applications. The [Microsoft Foundry portal](https://ai.azure.com?cid=learnDocs) facilitates collaboration and project management across various Azure AI services. You can even use it as a common environment across multiple workload teams. |
| [Azure&nbsp;Machine&nbsp;Learning&nbsp;studio](#azure-machine-learning-studio) | Collaborative, drag-and-drop tool for machine learning | Build, test, and deploy predictive analytics solutions by using minimal coding. Machine Learning studio supports a wide range of machine learning algorithms and AI models. It provides tools for data preparation, model training, and evaluation. |
| [Azure&nbsp;Data&nbsp;Science Virtual Machine](#azure-data-science-virtual-machine) | VM image that includes preinstalled data science tools | Use a preconfigured environment with tools like Jupyter, R, and Python to develop machine learning solutions on your own VMs.|
| [Microsoft ML.NET](#mlnet) | Open-source, cross-platform machine learning SDK | Develop machine learning solutions for .NET applications. |
| [AI for Windows apps](#ai-for-windows-apps) | Inference engine for trained models on Windows devices | Integrates AI capabilities into Windows applications by using components like [Windows Machine Learning (WinML)](/windows/ai/windows-ml/overview) and [Direct Machine Learning (DirectML)](/windows/ai/directml/dml) for local, real-time AI model evaluation and hardware acceleration. |
| [SynapseML](#synapseml) | Open-source, distributed machine learning and microservices framework for Apache Spark | Create and deploy scalable machine learning applications for Scala and Python. |
| [Machine learning extension for Azure Data Studio](#sql-machine-learning) | Open-source and cross-platform machine learning extension for Azure Data Studio | Manage packages, import machine learning models, make predictions, and create notebooks to run experiments for your SQL databases. |

## Azure Machine Learning

[Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) is a fully managed cloud service that you can use to train, deploy, and manage machine learning models at scale. It fully supports open-source technologies, so you can use tens of thousands of open-source Python packages, such as TensorFlow, PyTorch, and scikit-learn. 

Rich tools, such as [compute instances](/azure/machine-learning/concept-compute-instance), [Jupyter notebooks](/azure/machine-learning/tutorial-1st-experiment-sdk-setup), or the [Azure Machine Learning for Visual Studio Code (VS Code) extension](/azure/machine-learning/tutorial-setup-vscode-extension), are also available. The Machine Learning for VS Code extension is a free extension that allows you to manage your resources and model training workflows and deployments in VS Code. Machine Learning includes features that automate model generation and tuning with ease, efficiency, and accuracy.

Use Python SDK, Jupyter notebooks, R, and the CLI for machine learning at cloud scale. If you want a low-code or no-code option, use [Designer](/azure/machine-learning/service/concept-designer) in the studio. Designer helps you easily and quickly build, test, and deploy models by using prebuilt machine learning algorithms. Additionally, you can integrate Machine Learning with Azure DevOps and GitHub Actions for continuous integration and continuous deployment (CI/CD) of machine learning models.

|Machine Learning feature|Description|
|--------|-----------|
|**Type**                   |Cloud-based machine learning solution|
|**Supported languages**    |- Python<br>- R|
|**Machine learning phases**|- Data preparation<br>- Model training<br>- Deployment<br>- MLOps or management<br>- Responsible AI|
|**Key benefits**           |- Code-first (SDK) and studio and drag-and-drop designer web interface authoring options <br/>- Central management of scripts and run history, which makes it easy to compare model versions<br/>- Easy deployment and management of models to the cloud or edge devices<br/>- Scalable training, deployment, and management of machine learning models|
|**Considerations**         |Requires some familiarity with the model-management model.|

## Azure AI services

[AI services](/azure/ai-services/what-are-ai-services) is a comprehensive suite of prebuilt APIs that help developers and organizations create intelligent, market-ready applications rapidly. These services provide out-of-the-box and customizable APIs and SDKs that allow your apps to see, hear, speak, understand, and interpret user needs with minimal code. These capabilities make datasets or data science expertise to train models unnecessary. You can add intelligent features to your apps, such as:

- **Vision:** Includes object detection, face recognition, and optical character recognition. For more information, see [Azure AI Vision](/azure/ai-services/computer-vision/), [Azure AI Face](/azure/ai-services/computer-vision/overview-identity), and [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/).
- **Speech:** Includes speech-to-text, text-to-speech, and speaker recognition capabilities. For more information, see [Speech service](/azure/ai-services/speech-service/).
- **Language:** Includes translation, sentiment analysis, key phrase extraction, and language understanding. For more information, see [Azure OpenAI Service](/azure/ai-services/openai/), [Azure AI Translator](/azure/ai-services/translator/), [Azure AI Immersive Reader](/azure/ai-services/immersive-reader/), [Bot Framework Composer](/composer/), and [Azure AI Language](/azure/ai-services/language-service/).
- **Decision-making:** Detect unwanted content and make informed decisions. For more information, see [Azure AI Content Safety](/azure/ai-services/content-safety/).
- **Search and knowledge:** Bring AI-powered cloud search and knowledge mining capabilities to your apps. For more information, see [Azure AI Search](/azure/search/).

Use AI services to develop apps across devices and platforms. The APIs continuously improve and are easy to set up.

|AI services feature|Description|
|--------|-----------|
|**Type**                   |APIs for building intelligent applications|
|**Supported languages**    |Various options depending on the service. The standard options are C#, Java, JavaScript, and Python. |
|**Machine learning phases**|Deployment|
|**Key benefits**           |- Build intelligent applications by using pretrained models that are available through REST API and SDK<br/>- Use various models for natural communication methods that have vision, speech, language, and decision-making capabilities<br/>- No or minimal machine learning or data science expertise is required<br/>- The APIs are scalable and flexible<br/>- You can choose from various models|

## SQL machine learning

[SQL machine learning](/sql/machine-learning) adds statistical analysis, data visualization, and predictive analytics in Python and R for relational data, both on-premises and in the cloud. Current platforms and tools include:

- [SQL Server Machine Learning Services](/sql/machine-learning/sql-server-machine-learning-services).
- [SQL Managed Instance Machine Learning Services](/azure/azure-sql/managed-instance/machine-learning-services-overview).
- [Machine Learning extension for Azure Data Studio](/sql/azure-data-studio/machine-learning-extension).

Use SQL machine learning when you need built-in AI and predictive analytics on relational data in SQL.

|SQL machine learning feature|Description|
|--------|-----------|
|**Type**                   |On-premises predictive analytics for relational data|
|**Supported languages**    |-Python<br>- R<br>- SQL|
|**Machine learning phases**|- Data preparation<br>- Model training<br>- Deployment|
|**Key benefits**           |Encapsulate predictive logic in a database function. This process makes it easy to include data-tier logic.|
|**Considerations**         |Assumes that you use a SQL database as the data tier for your application.|

## Foundry

Foundry is a unified platform that you can use to develop and deploy generative AI applications and Azure AI APIs responsibly. It provides a comprehensive set of AI capabilities, a simplified user interface, and code-first experiences. These features make it a comprehensive platform for building, testing, deploying, and managing intelligent solutions.

Foundry helps developers and data scientists efficiently create and deploy generative AI applications by using Azure AI offerings. It emphasizes responsible AI development and embeds principles of fairness, transparency, and accountability. The platform includes tools for bias detection, interpretability, and privacy-preserving machine learning. These tools help ensure that AI models are powerful, trustworthy, and compliant with regulatory requirements.

As part of the Microsoft Azure ecosystem, Foundry provides robust tools and services that cater to various AI and machine learning needs, including natural language processing and computer vision. Its integration with other Azure services helps ensure scalability and performance, which makes it an ideal option for enterprises.

The [Foundry portal](https://ai.azure.com?cid=learnDocs) fosters collaboration and innovation by providing features like shared workspaces, version control, and integrated development environments. By integrating popular open-source frameworks and tools, Foundry accelerates the development process so that organizations can drive innovation and stay ahead in the competitive AI landscape.

|Foundry feature|Description|
|--------|-----------|
|**Type**                   |Unified development environment for AI|
|**Supported languages**    |Python and C#|
|**Machine learning phases**|- Data preparation<br>- Deployment (Models as a service (MaaS))|
|**Key benefits**           |- Facilitates collaboration and project management across various AI services<br/>- Provides comprehensive tools for building, training, and deploying AI models<br/>- Emphasizes responsible AI by providing tools for bias detection, interpretability, and privacy-preserving machine learning<br/>- Supports integration with popular open-source frameworks and tools|

## Azure Machine Learning studio

[Azure Machine Learning studio](/azure/machine-learning/overview-what-is-azure-ml#studio) is a collaborative, drag-and-drop tool for building, testing, and deploying predictive analytics solutions on your data. It's designed for data scientists, data engineers, and business analysts. Machine Learning studio supports a wide range of machine learning algorithms and tools for data preparation, model training, and evaluation. It also provides a visual interface for connecting datasets and modules on an interactive canvas.

|Machine Learning studio feature|Description|
|--------|-----------|
|**Type**                   |Collaborative, drag-and-drop tool for machine learning|
|**Supported languages**    |- Python<br>- R<br>- Scala<br>- Java (limited experience)|
| **Machine learning phases**|- Data preparation<br>- Model training<br>- Deployment|
|**Key benefits**           |- Requires no coding to build machine learning models<br/>- Supports a wide range of machine learning algorithms and tools for data preparation, model training, and evaluation<br/>- Provides a visual interface for connecting datasets and modules on an interactive canvas<br/>- Supports integration with Machine Learning for advanced machine learning tasks|

For a comprehensive comparison of Machine Learning studio and the [Foundry portal](https://ai.azure.com?cid=learnDocs), see [Foundry portal or Machine Learning studio](/ai/ai-studio-experiences-overview). The following table summarizes the key differences between them:

| Category             | Feature                         | Foundry portal                         | Machine Learning studio               |
|----------------------|---------------------------------|-------------------------------------------------|---------------------------------------------|
| **Data storage**     | Storage solution                | No                                              | Yes (cloud filesystem, OneLake, Azure Storage) |
| **Data preparation** | Data integration                | Yes (Azure Blob Storage, OneLake, Azure Data Lake Storage)               | Yes (copy and mount by using Azure storage accounts) |
| **Development**      | Code-first tools                | Yes (VS Code)                                   | Yes (Notebooks, Jupyter, VS Code, R Studio) |
| **Languages**        | Supported languages             | Python only                                     | Python, R, Scala, Java                      |
| **Training**         | AutoML                          | No                                              | Yes (regression, classification, forecasting, CV, NLP) |
| **Compute targets**  | Training compute                | No                                              | Spark clusters, machine learning clusters, Azure Arc            |
| **Generative AI**    | Language model catalog          | Yes (Azure OpenAI, Hugging Face, Meta)          | Yes (Azure OpenAI, Hugging Face, Meta)      |
| **Deployment**       | Real-time and batch serving     | Real-time (MaaS)                                | Batch endpoints, Azure Arc                  |
| **Governance**       | Responsible AI tools            | No                                              | Yes (Responsible AI dashboard)              |

## Microsoft Fabric

[Fabric](/fabric/get-started/microsoft-fabric-overview) is an end-to-end, unified analytics platform that brings together all the data and analytics tools that organizations need. It integrates various services and tools for data professionals, including data engineers, data scientists, and business analysts. Fabric provides capabilities for data integration, data engineering, data warehousing, data science, real-time analytics, and business intelligence.

Use Fabric when you need a comprehensive platform to manage your entire data lifecycle from ingestion to insights.

|Fabric feature|Description|
|--------|-----------|
|**Type**                   |Unified analytics platform|
|**Supported languages**    |- Python<br>- R<br>- SQL<br>- Scala|
|**Machine learning phases**|- Data preparation<br>- Model training<br>- Deployment<br>- Real-time analytics|
|**Key benefits**           |- Unified platform for all data and analytics needs<br>- Integration with other Microsoft services<br>- Scalable and flexible<br>- Supports a wide range of data and analytics tools<br>- Facilitates collaboration across different roles in an organization<br>- End-to-end data lifecycle management from ingestion to insights<br>- Real-time analytics and business intelligence capabilities<br>- Machine learning model training and deployment support<br>- Integration with popular machine learning frameworks and tools<br>- Tools for data preparation and feature engineering<br>- Real-time machine learning inference and analytics|

## Azure Data Science Virtual Machine

[Azure Data Science Virtual Machine](/azure/machine-learning/data-science-virtual-machine/overview) is a customized VM environment on the Microsoft Azure cloud. It's available in versions for both Windows and Linux Ubuntu. The environment is specifically for data science tasks and machine learning solution development. It has many popular data science functions, machine learning frameworks, and other tools that are preinstalled and preconfigured so that you can jump-start building intelligent applications for advanced analytics.

Use the Data Science VM when you need to run or host your jobs on a single node or if you need to remotely scale up your processing on a single machine.

|Azure Data Science Virtual Machine feature|Description|
|--------|-----------|
|**Type**                   |Customized VM environment for data science|
|**Key benefits**           |- Reduced time to install, manage, and troubleshoot data science tools and frameworks<br>- Includes the latest versions of commonly used tools and frameworks<br>- Includes highly scalable images and graphics processing unit (GPU) capabilities for intensive data modeling|
|**Considerations**         |- The VM can't be accessed when it's offline.<br>- Running a VM incurs Azure charges, so you should make sure that it runs only when you need it.|

## Azure Databricks

[Azure Databricks](/azure/azure-databricks/what-is-azure-databricks) is an Apache Spark-based analytics platform that's optimized for the Microsoft Azure cloud platform. Azure Databricks is integrated with Azure to provide one-click setup, streamlined workflows, and an interactive workspace that enables collaboration between data scientists, data engineers, and business analysts. Use Python, R, Scala, and SQL code in web-based notebooks to query, visualize, and model data.

Use Azure Databricks when you want to collaborate on building machine learning solutions on Apache Spark.

|Azure Databricks feature|Description|
|--------|-----------|
|**Type**                   |Apache Spark-based analytics platform|
|**Supported languages**    |- Python<br>- R<br>- Scala<br>- SQL|
|**Machine learning phases**|- Data preparation<br>- Data preprocessing<br>- Model training<br>- Model tuning<br>- Model inference<br>- Management<br>- Deployment|
|**Key benefits**| - One-click setup and streamlined workflows for easy use<br>- Interactive workspace for collaboration<br>- Scalability to handle large datasets and intensive computations<br>- Support for various languages and integration with popular tools|

## ML.NET

[ML.NET](/dotnet/machine-learning/) is an open-source, cross-platform machine learning framework. Use ML.NET to build custom machine learning solutions and integrate them into your .NET applications. ML.NET provides various levels of interoperability with popular frameworks like TensorFlow and ONNX for training and scoring machine learning and deep learning models. For resource-intensive tasks like training image classification models, you can use Azure to train your models in the cloud.

Use ML.NET when you want to integrate machine learning solutions into your .NET applications. Choose between the [API](/dotnet/machine-learning/how-does-mldotnet-work) for a code-first experience and [Model Builder](/dotnet/machine-learning/automate-training-with-model-builder) or the [CLI](/dotnet/machine-learning/automate-training-with-cli) for a low-code experience.

|ML.NET feature|Description|
|--------|-----------|
|**Type**                   |Open-source, cross-platform framework for developing custom machine learning applications with .NET |
|**Supported languages**    |- C#<br>- F#|
|**Machine learning phases**    |- Data preparation<br>- Training<br>- Deployment|
|**Key benefits**            |- No requirement for data science or machine learning experience<br>- Familiar languages and tools like Visual Studio and VS Code<br>- Deploys the application where .NET runs<br>- Extensible and scalable design<br>- Local-first experience<br>- AutoML for automated machine learning tasks|

## AI for Windows apps

Use [AI for Windows apps](/windows/ai/) to integrate AI capabilities into Windows applications Use WinML and DirectML capabilities to provide local, real-time AI model evaluation and hardware acceleration. WinML allows developers to integrate trained machine learning models directly into their Windows applications. It facilitates local, real-time evaluation of models and enables powerful AI capabilities without the need for cloud connectivity.

DirectML is a high-performance, hardware-accelerated platform for running machine learning models. It uses DirectX APIs to provide optimized performance across diverse hardware, including GPUs and AI accelerators.

Use AI for Windows apps when you want to use trained machine learning models within your Windows applications.

|AI for Windows apps feature|Description|
|--------|-----------|
|**Type**                   |Inference engine for trained models in Windows devices|
|**Supported languages**    |- C#/C++<br>- JavaScript|
|**Machine learning phases**|- Data preparation<br>- Model training<br>- Deployment|
|**Key benefits**            |- Local, real-time AI model evaluation<br>- High-performance AI processing across various hardware types, including CPUs, GPUs, and AI accelerators<br/>- Consistent behavior and performance across Windows hardware|

## SynapseML

[SynapseML](https://microsoft.github.io/SynapseML/), formerly known as MMLSpark, is an open-source library that simplifies the creation of massively scalable machine learning pipelines. SynapseML provides APIs for various machine learning tasks, such as text analytics, vision, and anomaly detection. SynapseML is built on the [Apache Spark](https://spark.apache.org/) distributed computing framework and shares the same API as the SparkML and MLlib libraries, so you can embed SynapseML models into existing Apache Spark workflows.

SynapseML adds many deep learning and data science tools to the Spark ecosystem, including integration of [Spark Machine Learning](https://spark.apache.org/docs/latest/ml-guide.html) pipelines with [Light Gradient Boosting Machine (LightGBM)](https://github.com/microsoft/LightGBM), [Local Interpretable Model-Agnostic Explanations](https://www.oreilly.com/learning/introduction-to-local-interpretable-model-agnostic-explanations-lime), and [OpenCV](https://opencv.org/). You can use these tools to create powerful predictive models on any Spark cluster, such as [Azure Databricks](#azure-databricks) or [Azure Cosmos DB](/azure/cosmos-db/spark-connector).

SynapseML also provides networking capabilities to the Spark ecosystem. With the HTTP on Spark project, users can embed any web service into their SparkML models. Additionally, SynapseML provides easy-to-use tools for orchestrating [AI services](https://azure.microsoft.com/products/ai-services/) at scale. For production-grade deployment, the Spark Serving project enables high throughput and submillisecond latency web services that are backed by your Spark cluster.

|SynapseML feature|Description|
|--------|-----------|
|**Type**                    |Open-source, distributed machine learning and microservices framework for Apache Spark|
|**Supported languages**     |- Scala<br>- Java<br>- Python<br>- R<br>- .NET|
|**Machine learning phases** |- Data preparation<br>- Model training<br>- Deployment|
|**Key benefits**            |- Scalability<br>- Streaming and serving compatible<br>- High fault tolerance|
|**Considerations**          |Requires Apache Spark|

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Mahdi Setayesh](https://www.linkedin.com/in/mahdi-setayesh-a03aa644/) | Principal Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AI development products available from Microsoft](https://www.microsoft.com/ai)
- [Microsoft Learn training in developing AI and machine learning solutions](/training/browse/?resource_type=learning+path&roles=ai-engineer%2cdata-scientist)
- [How Azure Machine Learning works](/azure/machine-learning/concept-azure-machine-learning-v2)

## Related resources  

- [Choose an Azure AI services technology](../../data-guide/technology-choices/ai-services.md)
- [AI architecture design](../../data-guide/big-data/ai-overview.md)
