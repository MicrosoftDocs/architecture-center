


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

For the people running a healthcare facility, length of stay-the number of days from patient admission to discharge-matters. However, that number can vary across facilities and across disease conditions and specialties, even within the same healthcare system, making it harder to track patient flow and plan accordingly.

This Azure solution helps hospital administrators use the power of machine learning to predict the length of stay for in-hospital admissions, to improve capacity planning and resource utilization. A Chief Medical Information Officer might use a predictive model to determine which facilities are overtaxed and which resources to bolster within those facilities, and a Care Line Manager might use it to determine if there will be adequate staff resources to handle the release of a patient.

Being able to predict length of stay at the time of admission helps hospitals provide higher quality care and streamline their operational workload. It also helps accurately plan for discharges, lowering other quality measures such as readmissions.

## Architecture

![Architecture Diagram](../media/predict-length-of-stay-and-patient-flow-with-healthcare-analytics.png)
*Download an [SVG](../media/predict-length-of-stay-and-patient-flow-with-healthcare-analytics.svg) of this architecture.*

## Components

* [SQL Server R Services](/sql/machine-learning/r/sql-server-r-services?view=sql-server-2016): Stores the patient and hospital data. Provides training and predicted models and predicted results for consumption using R.
* [Power BI](https://powerbi.microsoft.com) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Machine Learning helps you design, test, operationalize, and manage predictive analytics solutions in the cloud.

## Next steps

* [Learn more about SQL Server](/sql/machine-learning/r/sql-server-r-services?view=sql-server-2016)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)
* [Learn more about Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)