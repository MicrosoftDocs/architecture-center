[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution enables a predictive model for the length of stay for in-hospital admissions. Length of stay (LOS) is defined in the number of days from the initial admit date to the date that the patient is discharged from any given hospital facility.

## Architecture

![Architecture Diagram](../media/predicting-length-of-stay-in-hospitals.png)
*Download an [SVG](../media/predicting-length-of-stay-in-hospitals.svg) of this architecture.*

### Components

* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/)
* [Power BI](https://powerbi.microsoft.com/)

## Solution details

This solution enables a predictive model for Length of Stay for in-hospital admissions. Length of Stay (LOS) is defined in number of days from the initial admit date to the date that the patient is discharged from any given hospital facility. There can be significant variation of LOS across various facilities and across disease conditions and specialties even within the same healthcare system. Advanced LOS prediction at the time of admission can greatly enhance the quality of care as well as operational workload efficiency and help with accurate planning for discharges resulting in lowering of various other quality measures such as readmissions.

### Business perspective

There are two different business users in hospital management who can expect to benefit from more reliable predictions of the Length of Stay. These are:

* The Chiefs Medical Information Officer (CMIO), who straddles the divide between informatics/technology and healthcare professionals in a healthcare organization. Their duties typically include using analytics to determine if resources are being allocated appropriately in a hospital network. As part of this, the CMIO needs to be able to determine which facilities are being overtaxed and, specifically, what resources at those facilities may need to be bolstered to realign such resources with demand.
* The Care Line Manager, who is directly involved with the care of patients. This role requires monitoring the status of individual patients as well as ensuring that staff is available to meet the specific care requirements of their patients. A Care Line Manager also needs to manage the discharge of their patients. The ability to predict LOS of a patient enables Care Line Managers to determine if staff resources will be adequate to handle the release of a patient.

### Data scientist perspective

SQL Server Machine Learning Services is a feature in SQL Server that gives the ability to run R scripts with relational data. You can use open-source packages and frameworks, and the Microsoft R packages, for predictive analytics and machine learning. The scripts are executed in-database without moving data outside SQL Server or over the network.

This solution walks through the steps needed to create and refine data, train the R models, and perform scoring on the SQL Server machine. The final scored database table in SQL Server gives the predicted LOS for each patient. This data is then visualized in Power BI. (Simulated data is used in this template to illustrate the feature.)

Data scientists who are testing and developing solutions can work conveniently from their preferred R IDE on their local computer, while pushing the compute to the SQL Server. The completed solutions are deployed to SQL Server by embedding calls to R in stored procedures. These solutions can then be further automated with SQL Server Integration Services and SQL Server agent.

This solution includes the R code needed by a data scientist in the R folder. It shows the stored procedures (.sql files) that can be deployed in the SQLR folder. Click on the Deploy to Azure button to test the automation and the entire solution will be made available in your Azure subscription.

## Deploy this scenario

For deployment instructions and more details on the technical implementation, please see the [Predicting Length of Stay in Hospitals](https://github.com/Microsoft/r-server-hospital-length-of-stay) GitHub repo.

## Pricing

Your Azure subscription used for the deployment will incur consumption charges on the services used in this solution. For pricing details, visit the [Azure Pricing Page](https://azure.microsoft.com/pricing/calculator).

## Next steps

* Learn more about [SQL Server Machine Learning Services](/sql/machine-learning/sql-server-machine-learning-services)
* Learn more about [Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
* Learn more about [Power BI](/power-bi)
* Learn more about [Azure Data Science Virtual Machines (DSVMs)](https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines)
