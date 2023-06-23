---
title: Artificial intelligence (AI) architecture
description: Get started with artificial intelligence (AI). Use high-level architectural types, see Azure AI platform offerings, and find customer success stories.
author: martinekuan
ms.author: architectures
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-machine-learning
ms.custom:
  - guide
categories:
  - ai-machine-learning
---

<!-- cSpell:ignore maggsl scikit -->

# Artificial intelligence (AI) architecture design

*Artificial intelligence* (AI) is the capability of a computer to imitate intelligent human behavior. Through AI, machines can analyze images, comprehend speech, interact in natural ways, and make predictions using data.

![Illustration depicting the relationship of artificial intelligence as a parent concept. Within AI is machine learning. Within machine learning is deep learning.](./images/ai-overview-img-001.png)

## AI concepts

### Algorithm

An *algorithm* is a sequence of calculations and rules used to solve a problem or analyze a set of data. It is like a flow chart, with step-by-step instructions for questions to ask, but written in math and programming code. An algorithm may describe how to determine whether a pet is a cat, dog, fish, bird, or lizard. Another far more complicated algorithm may describe how to identify a written or spoken language, analyze its words, translate them into a different language, and then check the translation for accuracy.

### Machine learning

*Machine learning* (ML) is an AI technique that uses mathematical algorithms to create predictive models. An algorithm is used to parse data fields and to "learn" from that data by using patterns found within it to generate models. Those models are then used to make informed predictions or decisions about new data.

The predictive models are validated against known data, measured by performance metrics selected for specific business scenarios, and then adjusted as needed. This process of learning and validation is called *training*. Through periodic retraining, ML models are improved over time.

- [Machine learning at scale](../../data-guide/big-data/machine-learning-at-scale.md)

- [What are the machine learning products at Microsoft?](../../data-guide/technology-choices/data-science-and-machine-learning.md)

### Deep learning

*Deep learning* is a type of ML that can determine for itself whether its predictions are accurate. It also uses algorithms to analyze data, but it does so on a larger scale than ML.

Deep learning uses artificial neural networks, which consist of multiple layers of algorithms. Each layer looks at the incoming data, performs its own specialized analysis, and produces an output that other layers can understand. This output is then passed to the next layer, where a different algorithm does its own analysis, and so on.

With many layers in each neural network-and sometimes using multiple neural networks-a machine can learn through its own data processing. This requires much more data and much more computing power than ML.

- [Deep learning versus machine learning](/azure/machine-learning/concept-deep-learning-vs-machine-learning)

- [Distributed training of deep learning models on Azure](../../reference-architectures/ai/training-deep-learning.yml)

- [Batch scoring of deep learning models on Azure](../../reference-architectures/ai/batch-scoring-deep-learning.yml)

- [Training of Python scikit-learn and deep learning models on Azure](/azure/architecture/example-scenario/ai/training-python-models)

- [Real-time scoring of Python scikit-learn and deep learning models on Azure](../../reference-architectures/ai/real-time-scoring-machine-learning-models.yml)

### Bots

A *bot* is an automated software program designed to perform a particular task. Think of it as a robot without a body. Early bots were comparatively simple, handling repetitive and voluminous tasks with relatively straightforward algorithmic logic. An example would be web crawlers used by search engines to automatically explore and catalog web content.

Bots have become much more sophisticated, using AI and other technologies to mimic human activity and decision-making, often while interacting directly with humans through text or even speech. Examples include bots that can take a dinner reservation, chatbots (or conversational AI) that help with customer service interactions, and social bots that post breaking news or scientific data to social media sites.

Microsoft offers the Azure Bot Service, a managed service purpose-built for enterprise-grade bot development.

- [About Azure Bot Service](/azure/bot-service/bot-service-overview-introduction)

- [Ten guidelines for responsible bots](https://www.microsoft.com/research/publication/responsible-bots/)

- [Azure reference architecture: Enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)

- [Example workload: Conversational chatbot for hotel reservations on Azure](../../example-scenario/ai/commerce-chatbot.yml)

### Autonomous systems

*Autonomous systems* are part of an evolving new class that goes beyond basic automation. Instead of performing a specific task repeatedly with little or no variation (like bots do), autonomous systems bring intelligence to machines so they can adapt to changing environments to accomplish a desired goal.

Smart buildings use autonomous systems to automatically control operations like lighting, ventilation, air conditioning, and security. A more sophisticated example would be a self-directed robot exploring a collapsed mine shaft to thoroughly map its interior, determine which portions are structurally sound, analyze the air for breathability, and detect signs of trapped miners in need of rescue-all without a human monitoring in real time on the remote end.

- [Autonomous systems and solutions from Microsoft AI](https://www.microsoft.com/ai/autonomous-systems)

### General info on Microsoft AI

Learn more about Microsoft AI, and keep up-to-date with related news:

- [Microsoft AI School](https://aischool.microsoft.com/)

- [Azure AI platform page](https://azure.microsoft.com/overview/ai-platform/)

- [Microsoft AI platform page](https://www.microsoft.com/ai)

- [Microsoft AI Blog](https://blogs.microsoft.com/ai/)

- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI)

- [Azure Architecture Center](../../index.yml)

## High-level architectural types

### Prebuilt AI

*Prebuilt AI* is exactly what it sounds like-off-the-shelf AI models, services, and APIs that are ready to use. These help you add intelligence to apps, websites, and flows without having to gather data and then build, train, and publish your own models.

One example of prebuilt AI might be a pretrained model that can be incorporated as is or used to provide a baseline for further custom training. Another example would be a cloud-based API service that can be called at will to process natural language in a desired fashion.

#### Azure Cognitive Services

[Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) provide developers the opportunity to use prebuilt APIs and integration toolkits to create applications that can see, hear, speak, understand, and even begin to reason. The catalog of services within Cognitive Services can be categorized into five main pillars: Vision, Speech, Language, Web Search, and Decision/Recommendation.

- [Azure Cognitive Services documentation](/azure/cognitive-services/)

- [Try Azure Cognitive Services for free](https://azure.microsoft.com/try/cognitive-services/)

- [Choosing a Microsoft Cognitive Services technology](../../data-guide/technology-choices/cognitive-services.md)

- [Choosing a natural language processing technology in Azure](../../data-guide/technology-choices/natural-language-processing.yml)

#### Prebuilt AI models in AI Builder

AI Builder is a new capability in [Microsoft Power Platform](/power-platform/) that provides a point-and-click interface for adding AI to your apps, even if you have no coding or data science skills. (Some features in AI Builder have not yet released for general availability and remain in preview status. For more information, refer to the [Feature availability by region](/ai-builder/availability-region) page.)

You can build and train your own models, but AI Builder also provides [select prebuilt AI models](/ai-builder/prebuilt-overview) that are ready for use right away. For example, you can add a component in Microsoft Power Apps based on a prebuilt model that recognizes contact information from business cards.

- [Power Apps on Azure](https://powerapps.microsoft.com)

- [AI Builder documentation](/ai-builder/)

- [AI model types in AI Builder](/ai-builder/model-types)

- [Overview of prebuilt AI models in AI Builder](/ai-builder/prebuilt-overview)

### Custom AI

Although prebuilt AI is useful (and increasingly flexible), the best way to get what you need from AI is probably to build a system yourself. This is obviously a very deep and complex subject, but let's look at some basic concepts beyond what we've just covered.

#### Code languages

The core concept of AI is the use of algorithms to analyze data and generate models to describe (or *score*) it in ways that are useful. Algorithms are written by developers and data scientists (and sometimes by other algorithms) using programming code. Two of the most popular programming languages for AI development are currently Python and R.

[Python](https://www.python.org/) is a general-purpose, high-level programming language. It has a simple, easy-to-learn syntax that emphasizes readability. There is no compiling step. Python has a large standard library, but it also supports the ability to add modules and packages. This encourages modularity and lets you expand capabilities when needed. There is a large and growing ecosystem of AI and ML libraries for Python, including many that are readily available in Azure.

- [Python on Azure product home page](https://azure.microsoft.com/develop/python/)

- [Azure for Python developers](/azure/python/)

- [Azure Machine Learning SDK for Python](/python/api/overview/azure/ml/?view=azure-ml-py&preserve-view=true)

- [Introduction to machine learning with Python and Azure Notebooks](/training/paths/intro-to-ml-with-python/)

- [scikit-learn.](https://scikit-learn.org/stable/) An open-source ML library for Python

- [PyTorch.](https://pytorch.org/) An open-source Python library with a rich ecosystem that can be used for deep learning, computer vision, natural language processing, and more

- [TensorFlow.](https://www.tensorflow.org/) An open-source symbolic math library also used for ML applications and neural networks

- [Tutorial: Apply machine learning models in Azure Functions with Python and TensorFlow](/azure/azure-functions/functions-machine-learning-tensorflow?tabs=bash)

[R is a language and environment](https://www.r-project.org/) for statistical computing and graphics. It can be used for everything from mapping broad social and marketing trends online to developing financial and climate models.

Microsoft has fully embraced the R programming language and provides many different options for R developers to run their code in Azure.

- [Use R interactively on Azure Machine Learning](/azure/machine-learning/how-to-r-interactive-development).

- [Tutorial: Create a logistic regression model in R with Azure Machine Learning](/azure/machine-learning/tutorial-1st-r-experiment)

#### Training

Training is core to machine learning. It is the iterative process of "teaching" an algorithm to create models, which are used to analyze data and then make accurate predictions from it. In practice, this process has three general phases: training, validation, and testing.

During the training phase, a quality set of known data is tagged so that individual fields are identifiable. The tagged data is fed to an algorithm configured to make a particular prediction. When finished, the algorithm outputs a model that describes the patterns it found as a set of parameters. During validation, fresh data is tagged and used to test the model. The algorithm is adjusted as needed and possibly put through more training. Finally, the testing phase uses real-world data without any tags or preselected targets. Assuming the model's results are accurate, it is considered ready for use and can be deployed.

- [Train models with Azure Machine Learning](/azure/machine-learning/concept-train-machine-learning-model)

##### Hyperparameter tuning

*Hyperparameters* are data variables that govern the training process itself. They are configuration variables that control how the algorithm operates. Hyperparameters are thus typically set before model training begins and are not modified within the training process in the way that parameters are. Hyperparameter tuning involves running trials within the training task, assessing how well they are getting the job done, and then adjusting as needed. This process generates multiple models, each trained using different families of hyperparameters.

- [Tune hyperparameters for your model with Azure Machine Learning](/azure/machine-learning/how-to-tune-hyperparameters)

##### Model selection

The process of training and hyperparameter tuning produces numerous candidate models. These can have many different variances, including the effort needed to prepare the data, the flexibility of the model, the amount of processing time, and of course the degree of accuracy of its results. Choosing the best trained model for your needs and constraints is called *model selectio*n, but this is as much about preplanning before training as it is about choosing the one that works best.

##### Automated machine learning (AutoML)

*Automated machine learning*, also known as AutoML, is the process of automating the time-consuming, iterative tasks of machine learning model development. It can significantly reduce the time it takes to get production-ready ML models. Automated ML can assist with model selection, hyperparameter tuning, model training, and other tasks, without requiring extensive programming or domain knowledge.

- [What is automated machine learning?](/azure/machine-learning/concept-automated-ml)

#### Scoring

*Scoring* is also called *prediction* and is the process of generating values based on a trained machine learning model, given some new input data. The values, or scores, that are created can represent predictions of future values, but they might also represent a likely category or outcome. The scoring process can generate many different types of values:

- A list of recommended items and a similarity score

- Numeric values, for time series models and regression models

- A probability value, indicating the likelihood that a new input belongs to some existing category

- The name of a category or cluster to which a new item is most similar

- A predicted class or outcome, for classification models

***Batch scoring*** is when data is collected during some fixed period of time and
then processed in a batch. This might include generating business reports or analyzing customer loyalty.

***Real-time scoring*** is exactly that-scoring that is ongoing and performed as
quickly as possible. The classic example is credit card fraud detection, but real-time scoring can also be used in speech recognition, medical diagnoses, market analyses, and many other applications.

#### General info on custom AI on Azure

- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI)

- [Custom AI on Azure GitHub repo.](https://github.com/Azure/custom-ai-on-azure) A collection of scripts and tutorials to help developers effectively use Azure for their AI workloads

- [Azure Machine Learning SDK for Python](/python/api/overview/azure/ml/?view=azure-ml-py&preserve-view=true)

- [Azure Machine Learning service example notebooks (Python).](https://github.com/Azure/MachineLearningNotebooks) A GitHub repo of example notebooks demonstrating the Azure Machine Learning Python SDK

- [Azure Machine Learning SDK for R](https://azure.github.io/azureml-sdk-for-r/)

## Azure AI platform offerings

Following is a breakdown of Azure technologies, platforms, and services you can use to develop AI solutions for your needs.

### Azure Machine Learning

This is an enterprise-grade machine learning service to build and deploy models faster. Azure Machine Learning offers web interfaces and SDKs so you can quickly train and deploy your machine learning models and pipelines at scale. Use these capabilities with open-source Python frameworks, such as PyTorch, TensorFlow, and scikit-learn.

- [What are the machine learning products at Microsoft?](../../data-guide/technology-choices/data-science-and-machine-learning.md)

- [Azure Machine Learning product home page](https://azure.microsoft.com/services/machine-learning/)

- [Azure Machine Learning Data Architecture Guide overview](../../data-guide/big-data/machine-learning-at-scale.md)

- [Azure Machine Learning documentation overview](/azure/machine-learning/)

- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml) General orientation with links to many learning resources, SDKs, documentation, and more

#### Machine learning reference architectures for Azure

- [Training of Python scikit-learn and deep learning models on Azure](/azure/architecture/example-scenario/ai/training-python-models)

- [Distributed training of deep learning models on Azure](../../reference-architectures/ai/training-deep-learning.yml)

- [Batch scoring of Python machine learning models on Azure](../../reference-architectures/ai/batch-scoring-python.yml)

- [Batch scoring of deep learning models on Azure](../../reference-architectures/ai/batch-scoring-deep-learning.yml)

- [Real-time scoring of Python scikit-learn and deep learning models on Azure](../../reference-architectures/ai/real-time-scoring-machine-learning-models.yml)

- [Machine learning operationalization (MLOps) for Python models using Azure Machine Learning](../../reference-architectures/ai/mlops-python.yml)

- [Batch scoring of R machine learning models on Azure](../../reference-architectures/ai/batch-scoring-r-models.yml)

- [Real-time scoring of R machine learning models on Azure](../../reference-architectures/ai/realtime-scoring-r.yml)

- [Batch scoring of Spark machine learning models on Azure Databricks](../../reference-architectures/ai/batch-scoring-databricks.yml)

- [Enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)

- [Build a real-time recommendation API on Azure](../../reference-architectures/ai/real-time-recommendation.yml)

### Azure automated machine learning

Azure provides extensive support for automated ML. Developers can build models using a no-code UI or through a code-first notebooks experience.

- [Azure automated machine learning product home page](https://azure.microsoft.com/services/machine-learning/automatedml/)

- [Azure automated ML infographic (PDF)](https://aka.ms/automlinfographic/)

- [Tutorial: Create a classification model with automated ML in Azure Machine Learning](/azure/machine-learning/tutorial-first-experiment-automated-ml)

- [Tutorial: Use automated machine learning to predict taxi fares](/azure/machine-learning/tutorial-auto-train-models)

- [Configure automated ML experiments in Python](/azure/machine-learning/how-to-configure-auto-train)

- [Use the CLI extension for Azure Machine Learning](/azure/machine-learning/reference-azure-machine-learning-cli)

- [Automate machine learning activities with the Azure Machine Learning CLI](/azure/machine-learning/reference-azure-machine-learning-cli)

### Azure Cognitive Services

This is a comprehensive family of AI services and cognitive APIs to help you build intelligent apps. These domain-specific, pretrained AI models can be customized with your data.

- [Cognitive Services product home page](https://azure.microsoft.com/services/cognitive-services/)

- [Azure Cognitive Services documentation](/azure/cognitive-services/)

### Azure Cognitive Search

This is an AI-powered cloud search service for mobile and web app development. The service can search over private heterogenous content, with options for AI enrichment if your content is unstructured or unsearchable in raw form.

- [Azure Cognitive Search product home page](https://azure.microsoft.com/services/search/)

- [Getting started with AI enrichment](/azure/search/cognitive-search-concept-intro)

- [Azure Cognitive Search documentation overview](/azure/search/)

- [Choosing a natural language processing technology in Azure](../../data-guide/technology-choices/natural-language-processing.yml)

- [Quickstart: Create an Azure Cognitive Search cognitive skill set in the Azure portal](/azure/search/cognitive-search-quickstart-blob)

### Azure Bot Service

This is a purpose-built bot development environment with out-of-the-box templates to get started quickly.

- [Azure Bot Service product home page](https://azure.microsoft.com/services/bot-service/)

- [Azure Bot Service documentation overview](/azure/bot-service/bot-service-overview-introduction)

- [Azure reference architecture: Enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)

- [Example workload: Conversational chatbot for hotel reservations on Azure](../../example-scenario/ai/commerce-chatbot.yml)

- [Microsoft Bot Framework](https://dev.botframework.com/)

- [GitHub Bot Builder repo](https://github.com/Microsoft/BotBuilder)

### Apache Spark on Azure

Apache Spark is a parallel processing framework that supports in-memory processing to boost the performance of big data analytic applications. Spark provides primitives for in-memory cluster computing. A Spark job can load and cache data into memory and query it repeatedly, which is much faster than disk-based applications, such as Hadoop.

[Apache Spark in Azure HDInsight](/azure/hdinsight/spark/apache-spark-overview) is the Microsoft implementation of Apache Spark in the cloud. Spark clusters in HDInsight are compatible with Azure Storage and Azure Data Lake Storage, so you can use HDInsight Spark clusters to process your data stored in Azure.

The Microsoft Machine Learning library for Apache Spark is [MMLSpark](https://github.com/Azure/mmlspark) (Microsoft ML for Apache Spark). It is an open-source library that adds many deep learning and data science tools, networking capabilities, and production-grade performance to the Spark ecosystem. [Learn more about MMLSpark features and capabilities.](../../data-guide/technology-choices/data-science-and-machine-learning.md#mmlspark)

- [Azure HDInsight overview.](/azure/hdinsight/hdinsight-overview) Basic information about features, cluster architecture, and use cases, with pointers to quickstarts and tutorials.

- [Tutorial: Build an Apache Spark machine learning application in Azure HDInsight](/azure/hdinsight/spark/apache-spark-ipython-notebook-machine-learning)

- [Apache Spark best practices on HDInsight](/azure/hdinsight/spark/spark-best-practices)

- [Configure HDInsight Apache Spark Cluster settings](/azure/hdinsight/spark/apache-spark-settings)

- [Machine learning on HDInsight](/azure/hdinsight/hdinsight-machine-learning-overview)

- [GitHub repo for MMLSpark: Microsoft Machine Learning library for Apache Spark](https://github.com/Azure/mmlspark)

- [Create an Apache Spark machine learning pipeline on HDInsight](/azure/hdinsight/spark/apache-spark-creating-ml-pipelines)

### Azure Databricks Runtime for Machine Learning

[Azure Databricks](https://azure.microsoft.com/services/databricks/) is an Apache Spark–based analytics platform with one-click setup, streamlined workflows, and an interactive workspace for collaboration between data scientists, engineers, and business analysts.

[Databricks Runtime for Machine Learning (Databricks Runtime ML)](/azure/databricks/runtime/mlruntime) lets you start a Databricks cluster with all of the libraries required for distributed training. It provides a ready-to-go environment for machine learning and data science. Plus, it contains multiple popular libraries, including TensorFlow, PyTorch, Keras, and XGBoost. It also supports distributed training using Horovod.

- [Azure Databricks product home page](https://azure.microsoft.com/services/databricks/)

- [Azure Databricks documentation](/azure/azure-databricks/)

- [Machine learning capabilities in Azure Databricks](/azure/databricks/applications/machine-learning/)

- [How-to guide: Databricks Runtime for Machine Learning](/azure/databricks/runtime/mlruntime)

- [Batch scoring of Spark machine learning models on Azure Databricks](../../reference-architectures/ai/batch-scoring-databricks.yml)

- [Deep learning overview for Azure Databricks](/azure/databricks/applications/deep-learning/)

## Customer stories

Different industries are applying AI in innovative and inspiring ways. Following are a number of customer case studies and success stories:

- [ASOS: Online retailer solves challenges with Azure Machine Learning service](https://customers.microsoft.com/story/asos-retailers-azure)

- [KPMG helps financial institutions save millions in compliance costs with Azure Cognitive Services](https://customers.microsoft.com/story/754840-kpmg-partner-professional-services-azure)

- [Volkswagen: Machine translation speaks Volkswagen – in 40 languages](https://customers.microsoft.com/story/779468-volkswagen-azure-automotive-en)

- [Buncee: NYC school empowers readers of all ages and abilities with Azure AI](https://customers.microsoft.com/story/778859-the-young-womens-leadership-school-of-astoria-education-azure)

- [InterSystems: Data platform company boosts healthcare IT by generating critical information at unprecedented speed](https://customers.microsoft.com/story/778067-microsoft-startups-intersystems-professional-services-azure)

- [Zencity: Data-driven startup uses funding to help local governments support better quality of life for residents](https://customers.microsoft.com/story/742112-microsoft-m12-zencity-partner-professional-services-azure)

- [Bosch uses IoT innovation to drive traffic safety improvements by helping drivers avoid serious accidents](https://customers.microsoft.com/story/772105-microsoft-iot-ndrive-bosch-azure)

- [Automation Anywhere: Robotic process automation platform developer enriches its software with Azure Cognitive Services](https://customers.microsoft.com/story/761416-automation-anywhere-partner-professional-services-azure)

- [Wix deploys smart, scalable search across 150 million websites with Azure Cognitive Search](https://customers.microsoft.com/story/764974-wix-partner-professional-services-azure-cognitive-search)

- [Asklepios Klinik Altona: Precision surgeries with Microsoft HoloLens 2 and 3D visualization](https://customers.microsoft.com/story/770897-asklepios-apoqlar-azure-hololens-cognitive-services-health-en)

- [AXA Global P&C: Global insurance firm models complex natural disasters with cloud-based HPC](https://customers.microsoft.com/story/axa-global-p-and-c)

[Browse more AI customer stories](https://customers.microsoft.com/en-us/search?sq=&ff=story_product_categories%26%3EArtificial%20Intelligence&p=0&so=story_publish_date%20desc)

## Next steps

- To learn about the artificial intelligence development products available from Microsoft, refer to the [Microsoft AI platform](https://www.microsoft.com/ai) page.

- For training in how to develop AI solutions, refer to [Microsoft AI School](https://aischool.microsoft.com/learning-paths).

- [Microsoft AI on GitHub: Samples, reference architectures, and best practices](https://github.com/microsoft/AI) organizes the Microsoft open source AI-based repositories, providing tutorials and learning materials.