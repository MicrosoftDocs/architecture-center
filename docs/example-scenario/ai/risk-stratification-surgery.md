Advancements in data collection technologies and developments in data standards (transport, content, terminology, and security) have created a growing AI and machine learning transformation in the healthcare industry. This transformation has been particularly groundbreaking in patient care and provider administration. It has also provided an opportunity for insurance and pharmaceutical companies to offer digitally connected systems that enable a holistic view of a patient's wellbeing and overall healthcare history.

AI and machine learning play a pivotal role when it comes to surgical intervention.  For  patients, the decision to undergo surgery can be life changing. The ability to predict individual outcomes enables patients and doctors to take appropriate actions and better understand the associated risks.

Risk stratification can be either a binary or a multiclass classification model. In the case of binary classification, outcomes would be a surgery resulting in either a successful or a risky outcome. In the multiclass classification approach, there's an opportunity to further refine outcomes as successful, moderate, and severe/death. In either approach, one needs patient-centric data, including demographic information, comorbidities, current medication plan, blood test reports, and anything else that can shed light on a patient's overall health.

Developing a transparent system that provides the ability to explain potential surgical outcomes to a patient must be the primary goal of models like this one. Transparency and interpretability help clinicians have meaningful conversations with patients and lets them establish a treatment plan before surgery takes place. 

It's also important to acknowledge that patients come from diverse backgrounds. Creating a model that's free from bias toward gender and race is a necessity. An unbiased model provides unbiased medical support for patients, irrespective of their backgrounds, to maximize their chances of a positive surgical outcome. The architecture in this article uses interpretability and bias-detection tools from the Responsible AI Toolbox.

One of the largest healthcare organizations in the world, National Health Services in the United Kingdom, uses the Azure machine learning platform and the Responsible AI Toolbox for risk stratification models for orthopedic surgery. For more information, see  [Two NHS surgeons are using Azure AI to spot patients facing increased risks during surgery](https://news.microsoft.com/en-gb/features/two-nhs-surgeons-are-using-azure-ai-to-spot-patients-facing-increased-risks-during-surgery).

video intro 

> [!VIDEO https://www.youtube.com/watch?v=LRZHcipcweY]

Details about how to implement this model and architecture are the topic of this article.

### Potential use cases

Risk stratification models apply to these scenarios:

- **Clinical medicine.**  Predict surgical outcomes for patients undergoing orthopedic surgery, heart surgery, eye surgery, and other types of surgeries.
- **Public health.** Help medical professionals and policy makers understand the spread of specific diseases among residents in geographical areas. For example, to determine how many residents are susceptible to COVID.
- **Epidemiology.** Implement clinical trials to better understand the outcomes of a treatment as compared to a placebo.

## Architecture

:::image type="content" source="media/surgery-risk-models.png" alt-text="Diagram that shows an architecture for implementing surgery risk stratification." lightbox="media/surgery-risk-models.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/surgery-risk-models.vsdx) of this architecture.*

### Workflow

1. Data source 

   Patient-centric data is sourced from [Fast Healthcare Interoperability Resources (FHIR)](https://www.hl7.org/fhir/index.html), real-time Electronic Health Records (EHR), on-premises, and third-party data sources.
   
   > [!IMPORTANT]
   > When you use patient-centric data, you need to be sure personally identifiable data is carefully handled and is excluded from the training and test dataset.

   For surgery risk prediction, below are some of the data features considered:

   - Patient demographic information
   - Information about existing comorbidities along with their severity
   - Information about patients' current medication plan
   - Patient pre-operative blood test information 
   - Other critical health related information  

1. Data preparation

   Data preparation is the process of gathering, combining, structuring, and organizing data so it can be used to build machine learning models, business intelligence (BI), and analytics/data visualization applications.

   [Azure Data Factory ](/azure/data-factory/introduction) is used for the transformation, orchestration, and loading of data ready for further processing. [Azure API for FHIR](/azure/healthcare-apis/azure-api-for-fhir/overview) enables rapid exchange of data through FHIR APIs. [Azure Synapse]() is used to perform data processing and to trigger Azure Machine learning experiments. [Azure Data Lake]() is used to store tabular data describing patient-centric information in flat files.

1. AI/ML - Training

   Model training refers to the process of allowing a machine learning algorithm to learn patterns based on data and to pick a suitable model capable of predicting the surgery risk of previously unseen patients.
 
   [Azure Machine learning Studio]() is used to train the model. AML is a cloud service used for accelerating and managing the machine learning project lifecycle including training, deploying, and managing MLOps (Machine Learning Operations). 
 
   For this particular use case, it is important to choose models that are explainable. With the help of the interactive Interpretability dashboard supported by [RAI (Responsible Artificial Intelligence) toolbox](https://responsibleaitoolbox.ai), stakeholders can clearly understand the factors that play a key role in determining a particular risk for all patients as learned by the model. In addition to this, RAI toolbox also provides interpretation at a patient level. This tremendously helps clinicians to customize the treatment at an individual patient level. 

   RAI toolbox also provides an interactive dashboard support for detecting any bias in the chosen model towards protected classes like gender and race. Since the training data is based on patients who have undergone the surgery in the past, it is important for stakeholders to understand any inherent biases in the data that the model has picked up. When the chosen model is biased towards any protected classes, model mitigation can be done by using RAI toolbox.

1. AI/ML - Inference

   Machine learning Inference is the process of feeding previously unseen data points into a machine learning model to calculate an output such as a numerical score, in this case determining if input data is anomalous. 
 
   The model registry is built into AML (Azure Machine Learning) and is used to store and version models in the Azure cloud. The model registry makes it easy to organize and keep track of trained models.

   A trained machine learning model needs to be deployed so newly available data can be fed through it for inferencing. The deployment target is [Azure managed endpoints](/azure/machine-learning/concept-endpoints). Azure managed endpoints are the recommended deployment target that can be easily implemented for this solution. 

    For any new patient who is in the queue to undergo the surgery, the deployed model can be used, and the possible risks can be inferred based on that patient's historical health information. This way, both clinicians and the patient can understand the risks of them undergoing the surgery and come up with a suitable course of treatment.

1. Analytical Workload

   The results of model scoring are saved back into the analytic systems in this case [Azure Synapse]() and [Azure Data Lake]() where the input data is collected. This helps in sourcing the results of the risk prediction to the front-end for patient and clinician consumption, model monitoring and retraining the risk prediction models to help them learn from the newly available data. 

1. Front-end Model Consumption

   The scored results can be consumed through a webapps platform, [Power BI platform](/power-bi/fundamentals/power-bi-overview), [Power Apps](/power-apps/powerapps-overview) and can also be accessed on patient and clinician specific web portals and applications. This helps both patient and clinician to have access to the most up to date along with historical patient information to provide a more accurate diagnosis and to curate the best course of treatment. 

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems. Azure Synapse brings together the best of SQL technologies used in enterprise data warehousing, Spark technologies used for big data, Data Explorer for log and time series analytics, Pipelines for data integration and ETL/ELT, and deep integration with other Azure services such as Power BI, Cosmos DB, and AzureML.
- [Azure API for FHIR](/azure/healthcare-apis/azure-api-for-fhir/overview) enables rapid exchange of data through Fast Healthcare Interoperability Resources (FHIR®) APIs, backed by a managed Platform-as-a Service (PaaS) offering in the cloud. It makes it easier for anyone working with health data to ingest, manage, and persist Protected Health Information [PHI](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html) in the cloud.
- [Azure Data Factory]() is a cloud-based data integration service that automates data movement and transformation.
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) is a limitless data storage to house data in different shapes/formats and provides easier integration to the Analytics tools in Azure. The component has enterprise grade security and monitoring support. One can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. This solution provides a local data store for the ML (MACHINE LEARNING) data and a Premium data cache for training the ML model.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is the enterprise grade machine learning service for easier model development and deployment to a wide range of ML target computes. It provides users, at all skill levels, with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various IDEs (Integrated Development Environments).
- [Responsible AI Toolbox](https://responsibleaitoolbox.ai) is a collection of integrated tools and functionalities to help operationalize Responsible AI in practice. With the capabilities of this toolbox, you can assess your models and make user-facing decisions, faster and easier.
- [Azure Managed Endpoint](/azure/machine-learning/concept-endpoints) for Machine Learning is the HTTPS (Hypertext Transfer Protocol over Secure Socket Layer) endpoints that clients can call to receive inferencing (scoring) output of a trained model that provides a stable scoring URI with key-token authentication.
- [Power BI]() is the Azure SaaS (software as a service) for Business Analytics and visually immersive and interactive insights. It provides a rich set of connectors to various data sources, easier transformation capabilities, and sophisticated visualization capabilities. 
- [Power Apps]() is a suite of apps, services, and connectors, as well as a data platform, that provides a rapid development environment to build custom apps for your business needs. Using Power Apps, you can quickly build custom business apps that connect to your data stored either in the underlying data platform ([Microsoft Dataverse](/powerapps/maker/data-platform/data-platform-intro)) or in various online and on-premises data sources (such as SharePoint, Microsoft 365, Dynamics 365, SQL Server, etc.).

### Alternatives

- Azure ML is the data modeling and deployment tool in this solution. One can also build the solution in Azure Databricks with a code-first approach.
- As an alternative to Azure Synapse, Databricks could be used for data exploration and manipulation.
- Grafana could be used as the visualization tool instead of Power BI.
- One can have the data staged in Azure SQL Database instead of Azure Data Lake and the data staging/analysis can be accomplished using Azure Data Factory.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The technologies in this architecture were chosen for scalability and availability reasons with the aim of managing and controlling the costs.

### Reliability

The components in this architecture feature high reliability. However, machine learning and analytics tasks are comprised of two parts: training and production deployment. Resources required for training do not typically require high availability, as for production deployment high availability is fully supported by [Azure Managed Endpoint](/azure/machine-learning/concept-endpoints).

### Security

This scenario features built in security within the components, as well as permissions that can be managed via Azure Active Directory authentication or role-based access control. Consider the following [Azure Machine learning best practices for enterprise security](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-enterprise-security) to establish suitable security levels.

Azure Synapse features enterprise-grade and industry-leading security that allows for component isolation to protect data, network security, threat protection, etc. Component isolation can minimize exposure in the case of security vulnerability. Furthermore, Azure Synapse enables data obfuscation to protect sensitive personal student data.

Azure Data Lake provides security capabilities at all levels, from data protection and data masking to threat protection. More information is provided on [Azure Data Lake Security](/azure/data-lake-store/data-lake-store-security-overview).

Consider implementing the following security features in this architecture:

- [Deploy Azure services in Azure Virtual Network](/azure/virtual-network/virtual-network-for-azure-services)
- [Enterprise Security and Governance - Azure ML](/azure/machine-learning/concept-enterprise-security)
- [Overview of the security pillar](/azure/architecture/framework/security/overview)

Furthermore, when dealing with healthcare data, it is important to make sure any patient personally identifiable data must be handled with at most care and should follow the HIPPA standards. If personally identifiable data is necessary, then further enclave or homomorphic encryption solutions might be required.

### Cost optimization

- Scalability of the resources depends on the analytics workload, training, and deployment workloads enabled to optimize costs as needed.
- To estimate the cost of implementing this solution, please utilize [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) for the services mentioned above. It is also valuable to refer to [the Overview of the cost optimization pillars](/azure/architecture/framework/cost/overview).

### Operational excellence

Follow MLOps guidelines to standardize and manage an end-to-end Machine Learning lifecycle scalable across multiple workspaces. Before going into production, ensure the implemented solution supports ongoing inference with retraining cycles and automated redeployments of models. Below are a few resources to consider:

- [MLOps v2](https://microsoft.sharepoint.com/teams/CS_AzureDataAI/SitePages/Mlops.aspx?xsdata=MDV8MDF8fDVhM2M4ZDViNjM1ODRhMWFjMDM3MDhkYTFiZjIwYTkzfDcyZjk4OGJmODZmMTQxYWY5MWFiMmQ3Y2QwMTFkYjQ3fDB8MHw2Mzc4NTMwMjM1OTk4MzcyMzl8R29vZHxWR1ZoYlhOVFpXTjFjbWwwZVZObGNuWnBZMlY4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazkwYUdWeUlpd2lWMVFpT2pFeGZRPT18MXxNVGs2TXpCak9HUmlOR1JsTkRSbE5EVmlaR0UwWVRNMFpqQmpPV1kzT1RWa1pqaEFkR2h5WldGa0xuWXl8fA%3D%3D&sdata=czFMOUVSa3J1WjBSbm5haDc3NStGUVVGYTZyZE93MmF4d3U1cW92NlB2QT0%3D&ovuser=72f988bf-86f1-41af-91ab-2d7cd011db47%2Cchulahlou%40microsoft.com&OR=Teams-HL&CT=1649705566054&params=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyOC8yMjAzMjEwMDEwNyJ9) 
- [Azure MLOps (v2) solution accelerators](https://github.com/Azure/mlops-v2)

Responsible AI as a part of Azure ML is based on the six pillars of AI development and usage: fairness, reliability and safety, privacy and security, inclusiveness, transparency, and accountability. Below are more details about the overview and implementation:
- [Azure ML - Responsible AI](/azure/machine-learning/concept-responsible-ml)

### Performance efficiency

Most components in this scenario can be scaled up or down depending on the analysis activity levels. Azure Synapse provides scalability and high performance and can be reduced or paused at low levels of activity.

[Azure Machine Learning]() can be scaled depending on the data size and the necessary compute resources for model training. The deployment and compute resources can be scaled based on expected load and scoring service.

Consult with the [Performance Efficiency checklist](/architecture/framework/scalability/performance-efficiency) for guidance on designing scalable solutions.

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Manasa Ramalinga](https://www.linkedin.com/in/trmanasa) | Senior Cloud Solution Architect, US National CSA Team

Mick Alberts 

## Next steps

- [What is Azure Health Data Services?](/azure/healthcare-apis/healthcare-apis-overview)
- [Azure API for FHIR](/azure/healthcare-apis/azure-api-for-fhir/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [Track ML models with MLflow and Azure Machine Learning](/azure/machine-learning/how-to-use-mlflow)
- [Azure Data Factory documentation](/azure/data-factory/introduction)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)

## Related resources

- [Advanced analytics architecture](/azure/architecture/solution-ideas/articles/advanced-analytics-on-big-data)
- [What is Microsoft Cloud for Healthcare?](/industry/healthcare/overview)
- [Clinical insights with Microsoft Cloud for Healthcare](/azure/architecture/example-scenario/mch-health/medical-data-insights)
- [Confidential computing on a healthcare platform](/azure/architecture/example-scenario/confidential/healthcare-inference)
- [HIPAA and HITRUST compliant health data AI](/azure/architecture/solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai)
- [MLOps for Python models using Azure Machine Learning](/azure/architecture/reference-architectures/ai/mlops-python)
