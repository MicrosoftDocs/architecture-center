## Architecture

:::image type="content" source="./media/student-attrition-prediction-architecture.png" alt-text="Architecture diagram that shows the traffic route from a user to a private AKS cluster. The traffic flows through Azure Bastion and a jump box." lightbox="./media/student-attrition-prediction-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1958830-student-attrition-prediction-architecture.vsdx) of this architecture.*

### Workload

1. **Data source**. Educational data comes from various sources: district records, digital archives of instructional materials and grade books, details about financial grants, and student responses to course surveys. Educational data is housed in an on-premises database. It's also retrieved from third-party data sources, district databases, and state databases.

1. **Data preparation**. During data preparation, the data is gathered, combined, structured, and organized so it can be used to build machine learning models, for business intelligence purposes, and in analytics and data visualization applications. The solution uses Azure Data Factory to orchestrate the process of transforming and loading the data. Azure Synapse is used to process data and to trigger Azure Machine Learning experiments.

1. **AI machine learning training**. The solution uses Azure Machine Learning Studio to train a wide range of supervised learning algorithms and find a model that can accurately predict student attrition. The following Responsible AI Toolbox tools help to implement responsible AI:

   - The interpretability tool helps users understand the major factors that contribute to student attrition.
   - The fairness tool identifies and mitigates bias in the chosen model that's related to student gender and race.

1. **AI machine learning inferencing**. During inferencing, previously unseen data points are fed into a machine learning model. The model calculates the probability of student attrition. In Azure Machine Learning, a built-in model registry stores and provides version control for models in the Azure cloud. The model registry makes it easy to organize and keep track of trained models. Trained models are deployed to machine learning VMs or managed endpoints.

1. **Analytical workload**. The model scoring results are stored in Azure Synapse Analytics and Azure SQL Database. The results are then available for use in the front end and for monitoring and retraining the models.

1. **Front-end model consumption**. Web apps and the Power BI platform consume the scored results.

#### Student data schema

The information that's critical for the student attrition model consists of the data features that identify student behavior. The following table lists sample data elements that affect student attrition and retention patterns. You can add more factors to this list.

| Feature | Subfeature | Description |
|---------|------------|-------------|
| Gender |  | The gender that the student was assigned at birth or "Not reported." |
| Race |  | The student's reported race: either "Black," "White," "Pacific Islander," "Asian," "American Indian," or "Not reported." |
| First generation in college |  | Whether the student is a first-generation student. Neither parent or guardian of a first-generation student has a four-year degree or higher from a college or university. |
| Total terms |  | The total number of terms that the student has been enrolled. |
| High school graduate or GED |  | Whether the student graduated from high school or has an equivalent education. |
| Cumulative GPA |  | The average over all the grades the student has earned. |
| Cumulative credit hours earned |  | All the hours the student has accumulated over the period of enrollment. |
| Transferred to another program |  | Whether the student has switched programs since starting. |
| Financial aid eligible |  | Whether the student is eligible for a grant. |
| Age | Minimum | The minimum age that's recorded for the period of enrollment. |
| Age | Maximum | The maximum age that's recorded for the period of enrollment. |
| Entry type | Dual enrollment | Whether the student is enrolled in a dual program. |
| Entry type | Early admission | Whether the student was admitted in advance of the usual notification date. |
| Entry type | First time in college | Whether the student is enrolled in college for the first time. |
| Entry type | Other | Other admission types, indicated as a numerical value. |
| Entry type | Re-entry | A numerical value that represents re-entry admission.  |
| Entry type | Transfer | A numerical value that represents transfer admission. |
| Academic standing | Academic probation | The period in which the student must improve academic standing, expressed as a normalized value in proportion to the enrollment period. |
| Academic standing | Academic suspension | Whether the student has been suspended, expressed as a normalized value in proportion to the enrollment period. |
| Academic standing | Academic suspension for one year | The proportion of the enrollment period that the student has been suspended for one academic year. |
| Academic standing | Academic warning | Whether the student has been given an academic warning for failing grades. |
| Academic standing | Extended probation for low GPA | The period of time that the student's probation has been extended in proportion to the enrollment period. |
| Academic standing | Good academic standing | The proportion of the enrollment period that the student has been in good academic standing. |
| Academic standing | Probation after suspension or dismissal | Whether the student has been placed on probation after academic suspension. |
| Instruction type | Blended | The proportion of time that the student has received a combination of in-person and online instruction. |
| Instruction type | Fully online | The proportion of time that the student has received only online instruction. |
| Instruction type | Remote learning | Whether the student has enrolled in remote learning. |
| Instruction type | Remote learning blended | The proportion of time that the student has combined in-person instruction with remote learning. |
| Instruction type | Traditional | The proportion of time that the student has received conventional in-person instruction. |
| Faculty type | Faculty | The proportion of instruction that the student has received from academic staff at the institution. |
| Faculty type | Adjunct | The proportion of instruction that the student has received from contract professors. |
| Faculty type | Unknown instructor type | The proportion of instruction that the student has received of unknown type. |
| Attrition |  | Whether the student has dropped out of college. |

### Components

- [Azure Data Lake](https://azure.microsoft.com/en-us/solutions/data-lake/) offers limitless storage for data in different shapes and formats. Besides enterprise-grade security and monitoring support, Azure Data Lake provides easy integration to Azure analytics tools. Built on top of [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs), Azure Data Lake can manage large amounts of unstructured data, such as archives and data lakes. The service is a good fit for high-performance computing, machine learning, and cloud-native workloads. This solution provides a local data store for the machine learning data and a premium data cache for training the machine learning model.

- [Azure SQL Database](https://azure.microsoft.com/en-us/products/azure-sql/database/) is a fully managed database engine for modern cloud applications. This database service offers built-in intelligent optimization, global scalability and availability, advanced security options, and dynamic scalability with no downtime. Azure SQL Database can automatically process relational data and non-relational structures such as graphs and JSON, spatial, and XML data. For this service's availability guarantee, see [SLA for Azure SQL Database](https://azure.microsoft.com/en-us/support/legal/sla/azure-sql-database/v1_8/).

- [Azure Data Factory](https://azure.microsoft.com/en-us/services/data-factory/) is an orchestration and cloud extract-transform-load (ETL) tool. Besides offering over 90 built-in connectors across various data sources, Data Factory provides copy and transformation functionality in a no-code environment. You can use its diagram view to monitor and manage data integration processes.

- [Azure Synapse Analytics](https://azure.microsoft.com/en-us/services/synapse-analytics/#overview) is an analytics service for enterprise data warehouses. This tool uses SQL and Spark technologies and offers dedicated or serverless options for querying data. This service provides a unified experience for ingesting, exploring, preparing, transforming, and managing data. It also makes data available for business intelligence and machine learning purposes.

- [Azure Machine Learning](https://azure.microsoft.com/en-us/services/machine-learning/) is an enterprise-grade machine learning service for easy model development and deployment to a wide range of machine learning targets. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various integrated development environments (IDEs).

- [Responsible AI Toolbox](https://responsibleaitoolbox.ai/) is a collection of integrated tools and functionalities that help you implement responsible AI principles. You can use this toolbox to assess machine learning models quickly and easily.

- [Azure Data Science Virtual Machine](https://docs.microsoft.com/en-us/azure/machine-learning/data-science-virtual-machine/overview) is a customized VM image on the Azure cloud platform that's built specifically for doing data science. The image has many popular data science tools preinstalled and preconfigured to jump-start building intelligent applications for advanced analytics.