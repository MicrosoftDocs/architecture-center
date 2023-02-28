AI and machine learning play a pivotal role when it comes to surgical intervention. For  patients, the decision to undergo surgery can be life changing. The ability to predict individual outcomes enables patients and doctors to take appropriate actions and better understand the associated risks. This article provides a reference architecture that shows how to implement risk prediction for surgeries.

## Architecture

:::image type="content" source="media/surgery-risk-models.png" alt-text="Diagram that shows an architecture for implementing surgery risk stratification." lightbox="media/surgery-risk-models.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/surgery-risk-models.vsdx) of this architecture.*

### Workflow

1. Data source

   Patient-centric data is sourced from [Fast Healthcare Interoperability Resources (FHIR®)](https://www.hl7.org/fhir/index.html), real-time Electronic Health Records (EHR), on-premises, and third-party data sources.
   
   > [!IMPORTANT]
   > When you use patient-centric data, you need to be sure that personally identifiable data is carefully handled and is excluded from the training and test dataset.

   Consider the following data points when predicting surgery risk:

   - Patient demographic information
   - Information about existing comorbidities and their severity
   - Information about the patient's current medication plan
   - Patient pre-operative blood test information 
   - Other critical health-related information  

1. Data preparation

   *Data preparation* is the process of gathering, combining, structuring, and organizing data so that you can use it to build machine learning models, business intelligence (BI), and analytics and data visualization applications.

   - [Azure Data Factory](/azure/data-factory/introduction) transforms, orchestrates, and loads data that's ready for further processing. 
   - [Azure API for FHIR](/azure/healthcare-apis/azure-api-for-fhir/overview) enables the rapid exchange of data. 
   - [Azure Synapse Analytics](/azure/synapse-analytics/index) processes data and triggers Azure Machine Learning experiments. 
   - [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) stores tabular data that describes patient-centric information in flat files.

1. AI / machine learning - training

   *Model training* is the process of using a machine learning algorithm to learn patterns based on data and picking a model that's capable of predicting the surgery risk of previously unseen patients.
 
   [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) trains the model. Azure Machine Learning is a cloud service that accelerates and manages the machine learning project lifecycle. The lifecycle includes training models, deploying models, and managing Machine Learning Operations (MLOps). 
 
   For this use case, you need to use models that can be explained. With the help of the interactive interpretability dashboard in [Responsible AI Toolbox](https://responsibleaitoolbox.ai), stakeholders can clearly understand the factors that play a key role in determining a particular risk for all patients. Responsible AI Toolbox also provides interpretation at the patient level. This interpretation helps clinicians to customize treatments for specific treatments.

   Responsible AI Toolbox provides an interactive dashboard for detecting bias towards protected classes like gender and race in models. Because the training data is based on patients who have undergone the surgery, stakeholders need to understand any inherent biases in the data that the model has picked up. When the chosen model is biased towards protected classes, you can use Responsible AI Toolbox for model mitigation.

1. AI / machine learning - inference

   *Machine learning inference* is the process of feeding previously unseen data points into a machine learning model to calculate an output, like a numerical score. In this case, it's used to determine risks to patients.
 
   The model registry is built into Azure Machine Learning. It's used to store and version models in the Azure cloud. The model registry makes it easy to organize and keep track of trained models.

   A trained machine learning model needs to be deployed so that new data can be fed through it for inferencing. The recommended deployment target is an [Azure managed endpoint](/azure/machine-learning/concept-endpoints).

    For any new patient in the queue for surgery, the deployed model can be used, and the possible risks can be inferred based on the patient's historical health information. Clinicians and the patient can understand the risks of surgery and determine a suitable course of treatment.

1. Analytical workload

   The results of model scoring are saved back into the analytics systems, in this case Azure Synapse Analytics and Azure Data Lake, where input data is collected. This helps in sourcing the results of the risk prediction to the front end for patient and clinician consumption, model monitoring, and retraining the prediction models to help them learn from newly available data.

1. Front-end model consumption

   You can consume the scored results through a web apps platform: [Power BI](/power-bi/fundamentals/power-bi-overview) and [Power Apps](/power-apps/powerapps-overview). The results can also be accessed through patient and clinician web portals and applications. This enables patients and clinicians to access the most up-to-date information, along with historical information, for a more accurate diagnosis and to curate the best course of treatment.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems. Azure Synapse brings together the best of SQL technologies used in enterprise data warehousing, Spark technologies used for big data, Azure Data Explorer for log and time-series analytics, pipelines for data integration and ETL/ELT, and deep integration with other Azure services, like Power BI, Azure Cosmos DB, and Azure Machine Learning.
- [Azure API for FHIR](/azure/healthcare-apis/azure-api-for-fhir/overview) enables the rapid exchange of data through FHIR APIs. It's backed by a managed platform as a service (PaaS) offering in the cloud. This API makes it easier for anyone working with health data to ingest, manage, and persist Protected Health Information [PHI](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html) in the cloud.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a cloud-based data integration service that automates data movement and transformation.
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) is a limitless data storage service for housing data in various shapes and formats. It provides easy integration with the analytics tools in Azure. It has enterprise-grade security and monitoring support. You can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. This solution provides a local data store for the machine learning data and a premium data cache for training the machine learning model.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is the enterprise-grade machine learning service for easier model development and deployment to a wide range of machine learning compute targets. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various integrated development environments.
- [Responsible AI Toolbox](https://responsibleaitoolbox.ai) is a collection of integrated tools to help you operationalize responsible AI. By using this toolbox, you can assess your models and more quickly make user-facing decisions.
- [Azure Machine Learning endpoints](/azure/machine-learning/concept-endpoints) are HTTPS endpoints that clients can call to receive the inferencing (scoring) output of a trained model. An endpoint provides a stable scoring URI with key-token authentication.
- [Power BI](https://powerbi.microsoft.com) is software as a service (SaaS) that provides business analytics and visually immersive and interactive insights. It provides a rich set of connectors to various data sources, easy transformation capabilities, and sophisticated visualization.
- [Power Apps](https://powerapps.microsoft.com) is a suite of apps, services, and connectors, together with a data platform, that provides a rapid development environment to build custom apps for your business needs. You can use Power Apps to quickly build business apps that connect to your data. Data can be stored in the underlying data platform ([Microsoft Dataverse](/powerapps/maker/data-platform/data-platform-intro)) or in various online and on-premises data sources, like SharePoint, Microsoft 365, Dynamics 365, and SQL Server.

### Alternatives

- Azure Machine Learning provides data modeling and deployment in this solution. You can also build the solution in Azure Databricks, using a code-first approach.
- As an alternative to Azure Synapse, you can use Azure Databricks for data exploration and manipulation.
- You can use Grafana instead of Power BI for visualization.
- You can stage data in Azure SQL Database instead of Data Lake. You can use Data Factory for data staging and analysis.

## Scenario details

Advancements in data collection technologies and developments in data standards (transport, content, terminology, and security) have created a growing transformation of AI and machine learning in the healthcare industry. This transformation is particularly groundbreaking in patient care and provider administration. It has also provided an opportunity for insurance and pharmaceutical companies to offer digitally connected systems that enable a holistic view of a patient's wellbeing and overall healthcare history.

Risk stratification can use either a binary or a multiclass classification model. In the case of binary classification, outcomes are a surgery resulting in either a successful or a risky outcome. In the multiclass classification approach, there's an opportunity to further refine outcomes as successful, moderate, or severe/death. For either approach, you need patient-centric data, including demographic information, comorbidities, current medication plan, blood test reports, and anything else that can shed light on a patient's overall health.

Developing a transparent system that provides the ability to explain potential surgical outcomes to a patient must be the primary goal of models like this one. Transparency and interpretability help clinicians to have meaningful conversations with patients and lets them establish a treatment plan before surgery takes place. 

It's also important to acknowledge that patients come from diverse backgrounds. You need to create a model that's free from bias toward protected classes like gender and race. An unbiased model provides unbiased medical support for patients, irrespective of their backgrounds, to maximize their chances of a positive surgical outcome. The architecture in this article uses interpretability and bias-detection tools from the Responsible AI Toolbox.

One of the largest healthcare organizations in the world, National Health Services in the United Kingdom, uses the Azure machine learning platform and the Responsible AI Toolbox for risk stratification models for orthopedic surgery. For more information, see [Two NHS surgeons are using Azure AI to spot patients facing increased risks during surgery](https://news.microsoft.com/en-gb/features/two-nhs-surgeons-are-using-azure-ai-to-spot-patients-facing-increased-risks-during-surgery).

Or watch this short video:

<br>

> [!VIDEO https://www.youtube.com/embed/LRZHcipcweY]

### Potential use cases

This solution is ideal for the healthcare industry. Risk stratification models apply to these scenarios:

- **Clinical medicine.**  Predict surgical outcomes for patients undergoing orthopedic surgery, heart surgery, eye surgery, and other types of surgeries.
- **Public health.** Help medical professionals and policy makers understand the spread of specific diseases among residents in geographical areas, for example, to determine how many residents are susceptible to COVID.
- **Epidemiology.** Implement clinical trials to better understand the outcomes of a treatment as compared to a placebo.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The technologies in this architecture were chosen for scalability and availability, with the aim of managing and controlling costs.

### Reliability

Reliability ensures your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

The components in this architecture feature high reliability. However, machine learning and analytics tasks are made up of two parts: training and production deployment. Resources required for training don't typically require high availability. For production deployment, high availability is fully supported by [Azure Machine Learning endpoints](/azure/machine-learning/concept-endpoints).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario provides improved security that's built into the components. It also provides permissions that you can manage via Azure Active Directory authentication or role-based access control. Consider the following [Azure Machine learning best practices for enterprise security](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-enterprise-security) to establish suitable security levels.

Azure Synapse offers enterprise-grade and industry-leading security features that provide component isolation to protect data, improve network security, and improve threat protection. Component isolation can minimize exposure in the case of a security vulnerability. Azure Synapse also enables data obfuscation to protect sensitive personal data.

Azure Data Lake provides security capabilities at all levels, from improved data protection and data masking to improved threat protection. For more information, see [Azure Data Lake security](/azure/data-lake-store/data-lake-store-security-overview).

For more information about security features for this architecture, see the following resources:

- [Deploy dedicated Azure services into virtual networks](/azure/virtual-network/virtual-network-for-azure-services)
- [Enterprise security and governance for Azure Machine Learning](/azure/machine-learning/concept-enterprise-security)
- [Overview of the security pillar](/azure/architecture/framework/security/overview)

 > [!IMPORTANT]
 > When you handle healthcare data, you need to be sure patients' personally identifiable data is handled carefully and follow HIPAA standards. If personally identifiable data is necessary, you might need to implement further enclave or homomorphic encryption solutions.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Scalability of the resources depends on the analytics workload, training, and deployment workloads enabled to optimize costs as needed.
- To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator), inputting the services described in this article. [Overview of the cost optimization pillars](/azure/architecture/framework/cost/overview) can also be helpful.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Follow MLOps guidelines to standardize and manage an end-to-end machine learning lifecycle that's scalable across multiple workspaces. Before going into production, ensure that the implemented solution supports ongoing inference with retraining cycles and automated redeployments of models. Here are some resources to consider:

- [MLOps v2](https://microsoft.sharepoint.com/teams/CS_AzureDataAI/SitePages/Mlops.aspx?xsdata=MDV8MDF8fDVhM2M4ZDViNjM1ODRhMWFjMDM3MDhkYTFiZjIwYTkzfDcyZjk4OGJmODZmMTQxYWY5MWFiMmQ3Y2QwMTFkYjQ3fDB8MHw2Mzc4NTMwMjM1OTk4MzcyMzl8R29vZHxWR1ZoYlhOVFpXTjFjbWwwZVZObGNuWnBZMlY4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazkwYUdWeUlpd2lWMVFpT2pFeGZRPT18MXxNVGs2TXpCak9HUmlOR1JsTkRSbE5EVmlaR0UwWVRNMFpqQmpPV1kzT1RWa1pqaEFkR2h5WldGa0xuWXl8fA%3D%3D&sdata=czFMOUVSa3J1WjBSbm5haDc3NStGUVVGYTZyZE93MmF4d3U1cW92NlB2QT0%3D&ovuser=72f988bf-86f1-41af-91ab-2d7cd011db47%2Cchulahlou%40microsoft.com&OR=Teams-HL&CT=1649705566054&params=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyOC8yMjAzMjEwMDEwNyJ9) 
- [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2)

Responsible AI as a part of Azure Machine Learning is based on the six pillars of AI development and use: fairness, reliability and safety, privacy and security, inclusiveness, transparency, and accountability. For an overview and implementation details, see [What is responsible AI?](/azure/machine-learning/concept-responsible-ml).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Most components in this scenario can be scaled up or down depending on the analysis activity levels. Azure Synapse provides scalability and high performance and can be reduced or paused at low levels of activity.

You can scale [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) based on the amount of data and the necessary compute resources for model training. You can scale the deployment and compute resources based on the expected load and scoring service.

For more information about designing scalable solutions, see [Performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Manasa Ramalinga](https://www.linkedin.com/in/trmanasa) | Principal Cloud Solution Architect, US National CSA Team

Other contributor:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Health Data Services?](/azure/healthcare-apis/healthcare-apis-overview)
- [Azure API for FHIR](/azure/healthcare-apis/azure-api-for-fhir/overview)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [Track ML models with MLflow and Azure Machine Learning](/azure/machine-learning/how-to-use-mlflow)
- [Azure Data Factory documentation](/azure/data-factory/introduction)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [What is Microsoft Cloud for Healthcare?](/industry/healthcare/overview)

## Related resources

- [Advanced analytics architecture](../../solution-ideas/articles/advanced-analytics-on-big-data.yml)
- [Clinical insights with Microsoft Cloud for Healthcare](../../example-scenario/mch-health/medical-data-insights.yml)
- [Confidential computing on a healthcare platform](../../example-scenario/confidential/healthcare-inference.yml)
- [HIPAA and HITRUST compliant health data AI](../../solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai.yml)
- [MLOps for Python models using Azure Machine Learning](../../reference-architectures/ai/mlops-python.yml)
