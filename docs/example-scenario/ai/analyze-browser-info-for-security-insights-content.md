This article focuses on showcasing a practical, scalable, and manageable solution to implement an architecture that analyzes browsers for security and accessibility insights. The solution automates image analysis of browser screenshots to identify potential phishing or malicious websites by using machine learning.

*Selenium is a trademark of its respective company. No endorsement is implied by the use of this mark.*

## Architecture

:::image type="content" source="media/analyze-browser-security-automation-architecture.png" alt-text="Diagram that shows the architecture to analyze browsers for security and accessibility insights." lightbox="media/analyze-browser-security-automation-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/analyze-browser-security-automation-architecture.vsdx) of this architecture.*

### Dataflow

1. Data is ingested when the user uploads files—in the form of flat files—that contain the URL of the presumed phishing link to Data Lake Storage for downstream processing.
2. After a new file lands in Data Lake Storage, Azure Data Factory pipelines work as an orchestration layer and trigger an Azure function. The function takes automated screenshots of the URLs by running a headless Selenium browser.
3. The screenshots taken by Azure Function are categorized by the website they're targeting. The Azure Data Factory pipelines persist the screenshot in Azure Blob Storage. The screenshots are kept in different folders for each company or website targeted.
4. If the company targeted by the phishing attempt is new, Azure Function takes a screenshot of the ground truth for the new company. The script saves the new ground truth for the company in the Azure SQL database.
5. In the image analysis phase, Machine Learning performs two steps. First, it reads each screenshot and the ground truth. Second, it runs the image similarity code. Each folder inside the blob storage is registered by the Machine Learning Python SDK as a datastore. Machine Learning also invokes the specific services and packages needed for scoring the model. The datastore, model registry, and deployment options in Machine Learning help with the model lifecycle management.
6. The results of the analysis are saved in the SQL database, which includes all of the previous modeling information related to all historical phishing attempts. Any necessary visualization data that’s used in the visualization layer, like Power BI, is also written to Azure SQL Database. This database becomes the data source for any reporting needs.  
7. As an alternative to storing model results in a SQL database, you can deploy Machine Learning models to containers by using Azure Kubernetes Services (AKS) as a web service, and then call the models via a REST API endpoint. The web service deploys by using Azure App Service. Then you can send data to the REST API endpoint and receive the prediction returned by the model within the web application.
8. Reports are visualized and manipulated through Power BI, Power Apps, or a custom web application that's hosted by App Service.

### Components

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) provides scalable and secure object storage for unstructured data. You can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. In this solution, it provides a local data store for the Machine Learning data store and a premium data cache for training the Machine Learning model. The premium tier of Blob Storage is for workloads that require fast response times and high transaction rates, like the human-in-the-loop video labeling in this example.
- [Machine Learning](https://azure.microsoft.com/services/machine-learning) is an enterprise-grade machine learning service used to quickly build and deploy models. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various IDEs.
- [Azure Functions](https://azure.microsoft.com/services/functions) provides event-driven compute capabilities without requiring you to build the infrastructure.
- [SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed SQL server database engine with built-in security and access controls. It has automated patching, updating, and backup features with intelligent threat protection.
- [Power BI](https://powerbi.microsoft.com/) is a collection of software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, and interactive insights.
- [Power Apps](https://powerapps.microsoft.com/) is a suite of apps, services, and connectors that are available on a comprehensive data platform. You can use this suite of services to quickly create applications to meet custom business needs. In this solution, Power Apps is used for data updates and inserts in an intuitive UI. It also functions as a trigger for automation.

### Alternatives

- In this solution, we've presented Machine Learning as a platform to perform image recognition for phishing websites. However, you can use [Azure Databricks](https://azure.microsoft.com/services/databricks) or [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) to perform the same type of analytics when you handle a large amount of data.
- To curate and perform Extract, Transform, and Load (ETL) after the data lands in Data Lake Storage, you can use [Azure Databricks](https://azure.microsoft.com/services/databricks) for a code-first approach as an alternative to Data Factory data flows.
- Depending on the specific use case and the end-user analytics platform, you can use other relational or storage services such as Azure Synapse Analytics or Data Lake Storage instead of storing the data in SQL Server. For example, if the data accumulates for a long time and you need to run analytics queries against it, Azure Synapse Analytics is good to have as part of the architecture.

## Scenario details

Phishing is a cybercrime where you're contacted by email, telephone, or a messaging application by someone posing as a legitimate institution. This person lures you into providing sensitive data such as customer content, banking and credit card details, and passwords.

Phishing is a growing security threat. The ability to identify, catalog, and report phishing sites through proper channels is instrumental in reducing the number of individuals victimized by these crimes.

Browser accessibility is the practice of making websites more accessible to users with disabilities, such as those with impaired hearing or vision. Improving accessibility makes websites more approachable and empowers users to use the web.

Accessibility is becoming more important with the advent of a more digital future. AI can help identify gaps in accessibility and increase awareness in this area.

This article focuses on showcasing a practical, scalable, and manageable solution to implement an architecture that analyzes browsers for security and accessibility insights. The solution automates image analysis of browser screenshots to identify potential phishing or malicious websites by using machine learning.

This solution supports use cases like cyber security, physical security, compliance, and accessibility. It also offers a framework for ingestion, storage, and manipulation of imagery and metadata that comes from various sources. These sources include browsers, scanning devices, and security cameras.

This solution demonstrates how to interconnect several Azure technologies.

- Use Azure Data Lake and Azure Blob Storage to implement best practices for data operations.
- Use Microsoft Power Apps to provide image analysis—when requested by the user—coming from various request types, such as URLs, image locations, and websites.
- Load the inputs and store the analyzed images and results in Azure Data Lake Storage.
- Use Azure Machine Learning to train, validate, and deploy models.

*Selenium is a trademark of its respective company. No endorsement is implied by the use of this mark.*

### Potential use cases

You can apply this solution to the following scenarios:

- Analyze browser screenshots to identify phishing or malicious websites.
- Scan for use cases where you need to substitute human intervention with machine learning and automation.
- Recognize accessibility features on browsers to find accessibility problems.
- Determine General Data Protection Regulation (GDPR) compliance for browser information.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Follow machine learning operations guidelines to standardize and manage an end-to-end machine learning lifecycle that's scalable across multiple workspaces. Before going into production, ensure the solution you implement supports ongoing inference with retraining cycles and automated redeployments of models.

For more information, see [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Consider implementing the following security features in this architecture:

- [Secure the credentials in Data Factory by using Key Vault](/azure/data-factory/store-credentials-in-key-vault)
- [Deploy Azure services in Azure Virtual Network](/azure/virtual-network/virtual-network-for-azure-services)
- [Enterprise security and governance for Azure Machine Learning](/azure/machine-learning/concept-enterprise-security)
- [Secure cluster connectivity (No Public IP / NPIP)](/azure/databricks/security/secure-cluster-connectivity)
- [Azure Databricks Premium](https://azure.microsoft.com/pricing/details/databricks)
- [Azure SQL Database security capabilities](/azure/azure-sql/database/security-overview?view=azuresql)

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- To estimate the cost of implementing this solution, use the [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator).
- Power BI comes with various licensing offerings. For more information, see [Power BI pricing](https://powerbi.microsoft.com/pricing).
- Depending on the volume of data and the complexity of your geospatial analysis, you might need to scale your Databricks cluster configurations. See the Azure Databricks [cluster sizing](/azure/databricks/clusters/cluster-config-best-practices#--cluster-sizing-examples) examples for best practices on cluster configuration.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

If you use Azure Data Factory mapping data flows for ETL, follow the [performance and tuning guide](/azure/data-factory/concepts-data-flow-performance) to optimize your data pipeline and ensure that your data flows meet your performance benchmarks.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Charitha Basani](https://www.linkedin.com/in/charitha-basani-54196031) | Senior Cloud Solution Architect
- [Giulia Gallo](https://www.linkedin.com/in/giuliagallo) | Senior Cloud Solution Architect
- [Andrea Martini](https://www.linkedin.com/in/andreamartini) | Senior Cloud Solution Architect

Other contributors:

- [Ahmed Bham](https://www.linkedin.com/in/ahmedbham-solutionsarchitect) | Senior Cloud Solution Architect
- [Kevin Kraus](https://www.linkedin.com/in/kevin-w-kraus) | Senior Cloud Solution Architect
- [Jason Martinez](https://www.linkedin.com/in/jason-martinez-502766123) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure security baseline for Azure Machine Learning](/security/benchmark/azure/baselines/machine-learning-security-baseline)
- [Azure Synapse Analytics](/azure/synapse-analytics)
- [Consume data with Power BI](/learn/paths/consume-data-with-power-bi)
- [Copy and ingest data by using Azure Data Factory](/azure/data-factory/data-factory-tutorials#copy-and-ingest-data)
- [Deploy machine learning models to Azure](/azure/machine-learning/how-to-deploy-managed-online-endpoints)
- [Integrate data with Azure Data Factory or Azure Synapse Pipeline](/learn/modules/data-integration-azure-data-factory)
- [Power BI](/power-bi)
- [Send and receive data by using Azure Data Share and transform data by using Azure Data Factory](/learn/modules/receive-data-with-azure-data-share-transforming-with-azure-data-factory)

## Related resources

- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml)
- [Extract text from objects by using Power Automate and AI Builder](extract-object-text.yml)
- [Image classification on Azure](intelligent-apps-image-processing.yml)
- [Vision classifier model with Azure Custom Vision Cognitive Service](../dronerescue/vision-classifier-model-with-custom-vision.yml)