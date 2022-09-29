For the people running a healthcare facility, length of stay (LOS) — the number of days from patient admission to discharge — matters. However, that number can vary across facilities and across disease conditions and specialties, even within the same healthcare system, making it hard to track patient flow and plan accordingly.

This Azure solution helps hospital administrators use the power of machine learning to predict the length of stay for in-hospital admissions, to improve capacity planning and resource utilization. A chief medical information officer might use a predictive model to determine which facilities are overtaxed and which resources to bolster within those facilities, and a care line manager might use a model to determine whether there are adequate staff resources to handle the release of a patient.

## Architecture

> [!NOTE]
> **SECTION TODOS**
> - diagram: create final .png, upload to blob storage
> - section: reviews from SMEs, Chad et al

:::image type="content" source="./images/predict-length-of-stay.png" alt-text="Diagram of remote patient monitoring architecture using healthcare devices and Azure services." lightbox="./images/predict-length-of-stay.png" border="false" :::

*Download a [PowerPoint file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

### Dataflow

The following workflow (or dataflow) corresponds to the above diagram:
1. Health Data from electronic health records (EHR) and electronic medical records (EMR) is extracted using Azure Data Factory with the appropriate runtime (e.g., Azure, Self-hosted). Note that in this scenario we assume data is accessible for batch extraction using one of the Azure Data Factory connectors (e.g., ODBC, Oracle, SQL). Other data sources (e.g., FHIR data) may require the inclusion of an intermediary ingestion service (e.g., Azure Functions).  
2. Azure Data Factory data flows through the Data Factory into Azure Data Lake Storage (gen 2). No data is stored in Azure Data Factory during this process and failures (e.g., dropped connection) can be handled/retried during this step.  
3. Azure Machine Learning is used to apply machine learning algorithms/pipelines to the data ingested in step (2). This can be done on an event-basis, scheduled, or manually depending on the requirements. Specifically, this includes:   
   3.1 Train - The ingested data is used to train a machine learning model using a combination of algorithms (e.g., Linear regression, Gradient Boosted Decision Tree) via various frameworks (e.g., scikit-learn) typically in a pipeline and may include pre/post-processing pipeline steps. As an example, patient health factors (e.g., age, admission-type) coming from the existing pre-processed (e.g., drop null rows) EMR/EHR data could be used to train a regression model (e.g., Linear Regression) which would be capable of predicting a new patient length of stay.  
   3.2 Validate - The model performance is compared to existing models/test data and also aginst any downstream consumption targets (e.g., APIs).  
   3.3 Deploy - The model is packaged (e.g., containerized) for use in different target environments.  
   3.4 Monitor - The model predictions are collected and mopnitored to ensure performance does not degrade over time. Alerts can be sent to trigger manual/automated re-training/updates to the model as needed using this monitoring data. Note that some additional services (e.g., Azure Monitor) may be needed, depending on the type of monitoring data extracted.  
4. Azure ML output flows to Azure Synapse Analytics where the model output (i.e., predicted patient length of stay) is combined with the existing patient data in a scalible, serving layer (e.g., dedicated SQL pool) for downstream consumption. Additional analytics (e.g., average length of stay per hospital) can be done via Synapse Analytics at this point.  
5. Azure Synapse Analytics provides data to Power BI. Specifically, Power BI connects to the serving layer in step (4) to extract the data and apply any additonal semantic modeling needed.  
6. Power BI is used for analysis by manager/coordinator.  

### Components

- [Azure Data Factory](https://azure.microsoft.com/products/data-factory/) (ADF) provides fully managed, serverless data integration & orchistration service capaible of visually integrating data sources with more than 90+ built-in, maintenance-free connectors at no added cost. 
- In this scenario ADF is used to ingest data and orchistrate the data flows.
  
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake/) (ADLS) provides a scalable secure data lake for high-performance analytics. 
- In this scenario ADLS is used as a scalible, cost-effective data storage layer. 

- [Azure Machine Learning (ML)](https://azure.microsoft.com/services/machine-learning/) (AML) services accelerate the end-to-end LOS prediction ML lifecycle by:
  - Empowering data scientists and developers with a wide range of productive experiences to build, train, and deploy machine learning models and foster team collaboration. 
  - Accelerating time to market with industry-leading MLOps—machine learning operations, or DevOps for machine learning. 
  - Innovating on a secure, trusted platform, designed for responsible machine learning.
  - In this scenario AML is the service used to produce the model used to predict patient length of stay as well as to manage the end-to-end model lifecycle.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/): a limitless analytics service that brings together data integration, enterprise data warehousing and big data analytics. In this scenario, Synapse is used to incorporate the model predictions into the existing data model and also to provide a high-speed serving layer for downstream consumption.

- [Power BI](https://powerbi.microsoft.com/) provides self-service analytics at enterprise scale, allowing you to:
  - Create a data-driven culture with business intelligence for all.
  - Keep your data secure with industry-leading data security capabilities including sensitivity labeling, end-to-end encryption, and real-time access monitoring.
  - In this scenario, Power BI is used to create end-user dashboards as well as to apply any semantic modeling needed in those dashboards.

### Alternatives

- Spark (e.g., Synapse Spark, Azure Databricks) can be used as an alternative to perform the machine learning depending on the data scale and/or skillsets of the data science team.
- MLFlow can be used to manage the end-to-end lifecycle as an alternative to Azure Machine Learning depending on the customer skillset/environment.
- Synapse Pipelines can be used as an alternative to Azure Data Factory in most cases, depending largely on the specific customer environment.  

## Scenario details

This solution enables a predictive model for LOS for in-hospital admissions. LOS is defined in number of days from the initial admit date to the date that the patient is discharged from any given hospital facility. There can be significant variation of LOS across various facilities, disease conditions, and specialties, even within the same healthcare system. Advanced LOS prediction at the time of admission can greatly enhance the quality of care as well as operational workload efficiency. LOS prediction also helps with accurate planning for discharges resulting in lowering of various other quality measures such as readmissions.

### Potential use cases

There are two different business users in hospital management who can expect to benefit from more reliable predictions of the length of stay. These are:

- The chief medical information officer (CMIO), who straddles the divide between informatics/technology and healthcare professionals in a healthcare organization. Their duties typically include using analytics to determine if resources are being allocated appropriately in a hospital network. As part of this, the CMIO needs to be able to determine which facilities are being overtaxed and, specifically, what resources at those facilities may need to be bolstered to realign such resources with demand.
- The care line manager, who is directly involved with the care of patients. This role requires monitoring the status of individual patients as well as ensuring that staff is available to meet the specific care requirements of their patients. A care line manager also needs to manage the discharge of their patients. The ability to predict LOS of a patient enables care line managers to determine if staff resources will be adequate to handle the release of a patient.

## Considerations

> [!NOTE]
> **SECTION TODOS**
> - finalize the Cost optimizations section
> - pick and finalize at least 2 of the remaining 4 considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?

> REQUIREMENTS: 
>   You must include the "Cost optimization" section. 
>   You must include at least two of the other H3 sub-sections/pillars: Reliability, Security, Operational excellence, and Performance efficiency.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).


> This section includes resiliency and availability considerations. They can also be H4 headers in this section, if you think they should be separated.
> Are there any key resiliency and reliability considerations (past the typical)?

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

> This section includes identity and data sovereignty considerations.
> Are there any security considerations (past the typical) that I should know about this?
> Because security is important to our business, be sure to include your Azure security baseline assessment recommendations in this section. See https://aka.ms/AzureSecurityBaselines

### Cost optimization

The most expensive component of this solution is the compute and there are several ways to scale the compute cost-effectively with data volume. One example would be to use Spark (e.g., Synapse Spark, Azure Databricks) for the data engineering work as opposed to a single node solution as Spark scales horizontally and is more cost-effective compared to large, vertially scaled single node solutions.  
### Operational excellence

Although it is not discussed in detail in this scenario as it is out of scope, MLOps would play a critical role in the productionalization of this type of a solution. For more details please check see: https://azure.microsoft.com/en-us/products/machine-learning/mlops/#features

### Performance efficiency
In this scenario, we do data pre-processing in Azure Machine Learning. While this will work for small to medium data volumes, large data volumes or scenarios with near real-time SLAs may struggle from a performance standpoint. One way to address this type of concern is to use Spark (e.g., Synapse Spark, Azure Databricks) for data engineering or data science workloads if possible as Spark scales horizontially and is distributed by design, allowing it to process large datasets very effectively. 
## Deploy this scenario

> [!NOTE]
> **SECTION TODOS**
> - this section is optional, but at this point we don't have solution assets that demo this architecture

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors: 

 - [Dhanshri More](https://www.linkedin.com/in/dhanshrimore/L) | Principal Cloud Solution Architect
 - [DJ Dean](https://www.linkedin.com/in/deandaniel/) | Principal Cloud Solution Architect


Other contributors: 

 - [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Development Engineer
 - [Bryan Lamos](https://www.linkedin.com/in/bryanlamos/) | Senior Content Developer
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Predict hospital readmissions with traditional and ML techniques](/azure/architecture/example-scenario/ai/predict-hospital-readmissions-machine-learning)
 
## Related resources

> [!NOTE]
> **SECTION TODOS**
> - Dhanshri has deeper links on ML lifecycle

See the links below for technologies and resources that are related to this architecture:

- [Artificial intelligence (AI) - Architectural overview](/azure/architecture/data-guide/big-data/ai-overview)
