---
title: Compare AWS and Azure AI and machine learning services
description: Compare machine learning, generative AI, vision, speech, language, document intelligence, and AI search services on Azure and AWS.
author: claytonsiemens77
ms.author: csiemens
ms.date: 09/16/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
ms.collection: 
 - migration
 - aws-to-azure
---

# AI and machine learning services on Azure and AWS

This article compares machine learning and application AI services on Amazon Web Services (AWS) and Azure. It covers model development, automated machine learning, generative AI, vision, speech, language, document intelligence, conversational AI, and AI-powered search.

For data integration, data lakes, data warehouses, stream processing, and business intelligence, see [Analytics services on Azure and AWS](./analytics.md). For operational relational and non-relational data stores, see [Database services on Azure and AWS](./databases.md).

AWS and Azure package AI capabilities differently. A service in one cloud might map to a combination of services or models in the other. Compare model and language availability, supported modalities, customization, evaluation, responsible AI controls, regional availability, latency, throughput, data handling, networking, and pricing before you select a target service.

## Machine learning services

The following tools and platforms enable the development, training, and deployment of machine learning models.

| AWS service | Microsoft service | Analysis |
| --- | --- | --- |
| [Amazon SageMaker](https://aws.amazon.com/sagemaker/) | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/products/machine-learning/) | Amazon SageMaker is a managed platform for building, training, and deploying machine learning models at scale. Azure provides an equivalent through Machine Learning, an end-to-end managed service that supports data preparation, automated machine learning, model deployment, and machine learning operations. The Fabric Data Science workload provides model development and enrichment. It integrates with Machine Learning for training, GPU acceleration, and enterprise-grade deployment. |
| [AWS deep learning Amazon machine images (AMIs)](https://aws.amazon.com/ai/machine-learning/amis/) | [Data Science virtual machines (VMs)](https://azure.microsoft.com/products/virtual-machines/data-science-virtual-machines/) with [Machine Learning](https://azure.microsoft.com/products/machine-learning/) | AWS deep learning AMIs provide prebuilt VM images with popular deep learning frameworks, GPU drivers, and libraries to accelerate AI model development. Azure provides a similar experience through Data Science VMs, which come preconfigured with Python, R, Jupyter, and deep learning frameworks like TensorFlow and PyTorch. Combine Machine Learning with Data Science VMs to create a managed platform for training, deployment, and machine learning operations. |
| [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/ai/autopilot/) | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/products/machine-learning/) | Amazon SageMaker Autopilot automates the machine learning life cycle by handling data preprocessing, algorithm selection, and hyperparameter tuning with minimal manual effort. The Fabric Data Science workload provides automated machine learning-driven model development and integrates with Machine Learning for training and operationalization. |
| [Amazon SageMaker Autopilot](https://aws.amazon.com/sagemaker/ai/autopilot/) | [Automated machine learning](https://azure.microsoft.com/solutions/automated-machine-learning/) | These services provide automated machine learning for building and training models. |
| [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/ai/studio/) | [Fabric Data Science workload](/fabric/data-science/data-science-overview/) with [Machine Learning integration](https://azure.microsoft.com/products/machine-learning/) | Amazon SageMaker Studio is an integrated development environment for machine learning in AWS. It provides a single web-based interface to build, train, and deploy models. The Fabric Data Science workload combines collaborative notebooks and Spark-based environments into a unified analytics platform and integrates with Machine Learning for training and deployment. |
| [Amazon SageMaker Studio](https://aws.amazon.com/sagemaker/ai/studio/) | [Azure Machine Learning studio](https://azure.microsoft.com/products/machine-learning/) | These services provide integrated development environments for machine learning. Amazon SageMaker Studio provides a unified interface for all machine learning development steps, including debugging and profiling tools. |

## AI services

AI services provide prebuilt, customizable AI capabilities for applications, including vision, speech, language, and decision making capabilities.

| AWS service | Azure service | Analysis |
| --- | --- | --- |
| [Amazon Rekognition](https://aws.amazon.com/rekognition/) | [Microsoft Foundry Models](/azure/foundry/concepts/foundry-models-overview) and [computer vision AutoML in Azure Machine Learning](/azure/machine-learning/how-to-auto-train-image-models) | Amazon Rekognition provides prebuilt image and video analysis capabilities. Azure doesn't have one current service that maps to every Rekognition capability. Use multimodal Foundry models for supported image-understanding scenarios. Use Azure Machine Learning AutoML to train custom image classification or object detection models. Evaluate model support, accuracy, latency, responsible AI controls, and regional availability for your scenario. |
| [Amazon Polly](https://aws.amazon.com/polly/) | [Azure Speech in Foundry Tools text-to-speech](https://azure.microsoft.com/products/ai-foundry/tools/speech) | Amazon Polly is a text-to-speech service that converts text into lifelike speech by using neural voices across multiple languages. Speech text-to-speech provides high-quality neural voices, real-time streaming, and batch synthesis for applications such as voice assistants, interactive voice response (IVR) systems, and accessibility solutions. Custom neural voice can create a unique voice for a brand, but it's a Limited Access feature that requires customer eligibility, registration, and Microsoft approval for a specific use case. |
| [Amazon Transcribe](https://aws.amazon.com/transcribe/) | [Speech speech-to-text](https://azure.microsoft.com/products/ai-foundry/tools/speech) | Amazon Transcribe provides speech-to-text with real-time transcription and custom vocabularies, commonly used for call analytics and captions. Speech speech-to-text provides real-time and batch transcription, speaker diarization, and custom models for domain-specific accuracy. |
| [Amazon Translate](https://aws.amazon.com/translate/) | [Azure Translator in Foundry Tools](https://azure.microsoft.com/products/ai-foundry/tools/translator) | Amazon Translate is a neural machine translation service that delivers translations across multiple languages for websites, apps, and multilingual content. Translator provides similar capabilities with real-time and batch translation in more than 100 languages. It also includes features like transliteration, language detection, and custom glossaries for domain-specific accuracy. |
| [Amazon Comprehend](https://aws.amazon.com/comprehend/) | [Azure Language in Foundry Tools](https://azure.microsoft.com/products/ai-foundry/tools/language) | Amazon Comprehend is a natural language processing (NLP) service that extracts insights from text, including sentiment, key phrases, and entities. These capabilities help analyze customer feedback and documents. Language (text analytics) provides similar capabilities with features like sentiment analysis, key phrase extraction, named entity recognition, and custom text classification. |
| [Amazon Lex](https://aws.amazon.com/lex/) | [Conversational language understanding in Microsoft Foundry](/azure/ai-services/language-service/conversational-language-understanding/overview) | These services create conversational interfaces that use natural language understanding. Azure takes a modular approach, where conversational language understanding handles intent recognition and entity extraction. Other components manage dialogue and integration. Amazon Lex provides an integrated solution for building conversational interfaces entirely within the AWS ecosystem. |
| [Amazon Textract](https://aws.amazon.com/textract/) | [Azure Document Intelligence in Foundry Tools](https://azure.microsoft.com/products/ai-foundry/tools/document-intelligence) | Amazon Textract is a machine learning service that extracts text and data from scanned documents, including tables and forms, to automate document processing. Document Intelligence provides similar functionality with optical character recognition (OCR), prebuilt models for invoices, receipts and IDs, and the ability to train custom models for domain-specific forms. Document Intelligence supports multi-language extraction and provides layout analysis for complex documents. |
| [Amazon OpenSearch Service](https://aws.amazon.com/opensearch-service/) | [AI Search](https://azure.microsoft.com/products/ai-services/ai-search/) | For application-search workloads, both services support full-text and vector search. Azure AI Search also provides hybrid search, semantic ranking, and AI enrichment for search and retrieval-augmented generation (RAG). It doesn't replace OpenSearch log analytics or real-time analytics capabilities. For those workloads, see [Analytics services on Azure and AWS](./analytics.md#real-time-analytics). |

## Generative AI services

The following AI services create new content or data that resembles human-generated output, like text, images, or audio.

| AWS service | Azure service | Analysis |
| --- | --- | --- |
| [Amazon Bedrock](https://aws.amazon.com/bedrock/) | [Microsoft Foundry](https://azure.microsoft.com/products/ai-foundry/) | These services provide foundation models to create and deploy generative AI applications. |

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Regina Hackenberg](https://www.linkedin.com/in/reginahackenberg/) | Senior Technical Specialist

Other contributor:

- [Filipa Lobão](https://www.linkedin.com/in/filipalobao) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Microsoft Foundry?](/azure/foundry/what-is-foundry)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)

## Related resources

- [Analytics services on Azure and AWS](./analytics.md)
- [Database services on Azure and AWS](./databases.md)
- [Choose an AI services technology](../data-guide/technology-choices/ai-services.md)
- [Compare Microsoft machine learning products and technologies](../ai-ml/guide/data-science-and-machine-learning.md)
