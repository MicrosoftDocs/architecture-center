In recent years, many healthcare companies have moved to the cloud, opting to provide online services via telehealth solutions. This change has led to an increase in the amount of healthcare-centric audio data that's available to companies that provide these services. Manual analysis of this data can yield useful insights, such as the treatments that are prescribed. But the scale of this data makes manual analysis a time-consuming task.

It's possible to automate the analysis of sensitive healthcare data by using Azure-based tools. Specifically, this article describes a solution that you can use for the following tasks:

- Automating the transcription of audio data
- Running a healthcare-specific analysis of that data that includes medical terminology linkage
- Serving the data to end users

*Apache® and [Apache Spark](https://spark.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by the Apache Software Foundation is implied by the use of these marks.*

## Architecture

The solution consists of two pipelines:

- A transcription pipeline that converts audio to text
- An analysis and visualization pipeline that enriches and analyzes the transcribed text

### Transcription pipeline

:::image type="content" source="./media/healthcare-transcription-pipeline.svg" alt-text="Architecture diagram of a pipeline that automates the process of transcribing uploaded call center recordings." border="false" lightbox="./media/healthcare-transcription-pipeline.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/healthcare-transcription-pipeline.vsdx) of this architecture.*

#### Dataflow

1. Audio files are uploaded to an Azure Storage account. Supported upload methods include using a storage SDK, a storage API, and UI-based tools like Azure Storage Explorer.

1. The upload to Storage triggers an Azure logic app. The logic app accesses any necessary credentials in Azure Key Vault and makes a request to the Azure AI Speech batch transcription API.

1. The logic app submits the audio files to Azure AI Speech for a transcription. The call to the service specifies optional settings for speaker diarization.

1. Azure AI Speech completes the batch transcription and loads the transcription results into a Storage account.

### Analysis and visualization pipeline for healthcare analysis

:::image type="content" source="./media/healthcare-analysis-visualization-pipeline.svg" alt-text="Architecture diagram of a pipeline that automates the process of summarizing and extracting information from call center recordings." border="false" lightbox="./media/healthcare-analysis-visualization-pipeline.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/healthcare-analysis-visualization-pipeline.vsdx) of this architecture.*

#### Dataflow

1. An Azure Synapse Analytics pipeline runs to retrieve and process the transcribed audio text.

1. An Azure function app in the pipeline uses an API call to send the processed text to the text analytics for health feature of Azure AI Language. This feature runs a healthcare-centric analysis of the text. The analysis extracts the following information:

   - Entities such as medications and diagnoses
   - Related metadata like Systematized Nomenclature of Medicine (SNOMED) codes and International Classification of Diseases (ICD)-10 codes
   - Relationships among the entities that the feature identifies

1. An Azure function app in the Azure Synapse Analytics pipeline calls the Azure OpenAI Service API. That call uses GPT to generate a human-readable summary of the call content.

   - If needed, content that the text analytics for health feature extracts in the previous step is passed to the Open AI service and included in the summary.
   - If the call content is needed for machine learning, GPT is used to extract a machine language–friendly representation of the data. The Azure OpenAI embeddings API is used for that extraction.

1. The processed data is stored in a Storage account.

1. Azure Synapse Analytics is used to analyze the data at scale.

1. The resulting content is served to visualization tools like Power BI via a serving layer like a SQL dedicated pool.

### Components

- [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) provides massively scalable cloud-native object storage. As a data lake that's built on top of [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs), Data Lake Storage offers optimized cost and performance for data that's used in analytics, machine learning, and other applications.
- [Azure Functions](https://azure.microsoft.com/products/functions) is an Azure-native serverless solution that hosts lightweight code that's used in analytics pipelines. Functions supports various languages and frameworks, including .NET, Java, and Python. By using lightweight virtualization technology, Functions can quickly scale out to support a large number of concurrent requests while maintaining enterprise-grade service-level agreements (SLAs).
- [Key Vault](https://azure.microsoft.com/products/key-vault) stores secrets such as tokens, passwords, and client keys. To help control access to secrets, Key Vault provides fine-grained authorization and authentication that's based on Microsoft Entra ID. Key Vault also supports native integrations to many Azure services.
- [Azure AI Speech](https://azure.microsoft.com/products/ai-services/ai-speech) provides speech capabilities such as speech-to-text, text-to-speech, speech translation, and speaker recognition services. As part of [Azure AI Services](https://azure.microsoft.com/products/ai-services), this speech service helps you create applications by offering out-of-the-box, prebuilt, customizable APIs and models.
- [Text analytics for health](https://azure.microsoft.com/products/ai-services/text-analytics) is a feature of [Azure AI Language](https://azure.microsoft.com/products/ai-services/ai-language) that you can use to extract, classify, and understand text within healthcare documents. You can use text analytics for health to extract medical entities, medical entity metadata like SNOMED codes, and medical entity relationships from complex natural language that involves medicine, such as medical notes.
- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service) is a cloud-based service that offers advanced language AI by providing REST API access to OpenAI models like GPT-3, Codex, and DALL-E. The Azure OpenAI APIs are developed with OpenAI to help ensure compatibility with OpenAI. With Azure OpenAI, you benefit from the security capabilities of Azure during model runs. Azure OpenAI offers private networking, regional availability, and responsible AI content filtering. The completions endpoint is the core component of the API service. This API provides access to the model's text-in, text-out interface. When you provide an input prompt that contains an English text command, the model generates a text completion.
- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) is a full-featured enterprise analytics platform that provides data ingestion, orchestration, processing, and serving capabilities at scale.
- [Power BI](https://powerbi.microsoft.com) is a business dashboard and visualization tool with integrated semantic modeling capabilities.

### Alternatives

- You can use [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) instead of Functions. In particular, you can use Logic Apps if you schedule jobs and process recordings in batches instead of processing each recording as you receive it.
- Instead of Azure Synapse Analytics, you can use [Azure Databricks](/azure/databricks/introduction) for analysis.
- You can use [Azure Data Factory](/azure/data-factory/introduction) instead of an Azure Synapse Analytics pipeline.
- To process scheduled batches, you can use Data Factory or an Azure Synapse Analytics pipeline instead of a trigger-based approach.
- Some analyses require Electronic Health Records (EHR) data, Fast Healthcare Interoperability Resources (FHIR) data that's stored in the [Azure API for FHIR](/azure/healthcare-apis/azure-api-for-fhir/overview), or other data. In these scenarios, you can extract that data and ingest it into the Storage account or container that you use for analysis. In the [Analysis and visualization pipeline for healthcare analysis](#analysis-and-visualization-pipeline-for-healthcare-analysis) diagram, that account or container is pictured between steps four and five. You can then use the data as part of your analysis.
- You can apply machine learning methods to the data as part of the analysis. In the [Analysis and visualization pipeline for healthcare analysis](#analysis-and-visualization-pipeline-for-healthcare-analysis) diagram, the analysis is pictured as the fifth step. You can use Azure Synapse Analytics to directly apply the methods, or you can use an external service such as [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning?view=azureml-api-2).

## Scenario details

This solution is based on a real customer use case. Users first upload their audio data to a Storage account for analysis. An automated trigger kicks off an Azure function app to use Azure AI Speech to transcribe the data. This step uses keys that are stored in Key Vault. After the data is transcribed, an analysis pipeline extracts key health information from the data. The pipeline is based on an Azure Synapse Analytics pipeline. It uses text analytics for health and Azure OpenAI to summarize the overall content and extract information like diagnosis and patient medications. Azure Synapse Analytics then aggregates and transforms this data as needed for end-user consumption via Power BI dashboards.

The solution is based on several assumptions. Because the data is highly sensitive, it's assumed that you securely deploy all storage accounts and services by following available best practices for working with sensitive data in the cloud. For example, you should encrypt all data at rest, and you should securely store account keys. It's also assumed that you consult appropriate information-security personnel about enterprise security best practices.

### Potential use cases

You can use this solution for many purposes, including:

- Smart analysis of telehealth data. You can extract insights from the audio that you collect from telehealth sessions in which patients interact with providers remotely to discuss results.
- Smart analysis of healthcare-centric call center data. The solution can analyze call center data from healthcare providers who provide at-home or remote care to patients. As part of the analysis, you can extract valuable information about products, such as adverse results, that customers call about.
- Smart analysis of clinical trials data. You can collect valuable insights from external touchpoints of clinical trials. The solution can automatically extract and correlate medical terminology to produce desired insights for large-scale analysis.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Consider the following points if your scenario requires a solution for high availability and disaster recovery:

- The SLA for Azure Synapse Analytics guarantees the success of a certain percentage of client operations. For the SLA of this service, see [Service Level Agreements (SLA) for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1).
- For the availability guarantee of Logic Apps, see [Service Level Agreements (SLA) for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1).
- You can configure Blob Storage as geo-redundant storage (GRS) or as read-access geo-redundant storage (RA-GRS) that allows reads directly from an alternate region. Your selection depends on your recovery time objective (RTO) requirement. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy).
- Multiple layers of availability and redundancy are built into the Key Vault service. For more information, see [Azure Key Vault availability and redundancy](/azure/key-vault/general/disaster-recovery-guidance).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The type of customer call data that this solution uses is highly sensitive. To help ensure this sensitive data remains secure, enable security controls throughout the solution. Also use Key Vault as a scalable service that helps end users securely store keys and secrets that they need for the solution. Because the solution uses OpenAI to extract insights from unstructured data, ensure that the overall insights that you derive follow the Microsoft principles for responsible AI. For more information about responsible AI, see [Empowering responsible AI practices](https://www.microsoft.com/ai/responsible-ai).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

You can optimize the solution for cost in several ways:

- When you develop analytics or add new analytic results to the content, run pipelines that complete the speech-to-text transcription of the audio only once. Other services can then process the stored content as part of other pipelines.
- Run insights that you extract from text analytics for health only once. Store the results and reuse them for development. This approach provides a way for you to do OpenAI prompt engineering quickly and cost effectively.
- Use ephemeral compute resources, such as ephemeral Spark clusters, for analytics. You typically run these types of batch-based workloads periodically. Shutting down the cluster between runs can significantly reduce the overall cost of the solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Sumit Bhuttan](https://www.linkedin.com/in/sumitbhuttan) | Senior Cloud Solution Architect
- [DJ Dean](https://www.linkedin.com/in/deandaniel) | Principal Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure AI Services documentation](/azure/ai-services)
- [What is Azure OpenAI Service?](/azure/cognitive-services/openai/overview)
- [Tutorial: Explore OpenAI Service embeddings](/azure/cognitive-services/openai/tutorials/embeddings?tabs=command-line)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure Functions overview](/azure/azure-functions/functions-overview)
- [Azure Key Vault basic concepts](/azure/key-vault/general/basic-concepts)
- [What is the Speech service?](/azure/cognitive-services/speech-service/overview)
- [What is text analytics for health?](/azure/cognitive-services/language-service/text-analytics-for-health/overview?tabs=ner)
- [What is Azure OpenAI Service?](/azure/cognitive-services/openai/overview)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Power BI developer documentation](/power-bi/developer)

## Related resources

- [Build a telehealth system on Azure](../apps/telehealth-system.yml)
- [Clinical insights with Microsoft Cloud for Healthcare](../mch-health/medical-data-insights.yml)
- [Precision medicine pipeline with genomics](../precision-medicine/genomic-analysis-reporting.yml)
- [Other healthcare architectures](../../browse/index.yml?terms=healthcare)
