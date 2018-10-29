---
title: Predict Length of Stay and Patient Flow 
description: Learn how to predict capacity and patient flow for your hospital or healthcare facility to enhance the quality of care and improve operational efficiency.
author: adamboeglin
ms.date: 10/29/2018
---
# Predict Length of Stay and Patient Flow 
For the people running a healthcare facility, length of staythe number of days from patient admission to dischargematters. However, that number can vary across facilities and across disease conditions and specialties, even within the same healthcare system, making it harder to track patient flow and plan accordingly.
This Azure solution helps hospital administrators use the power of machine learning to predict the length of stay for in-hospital admissions, to improve capacity planning and resource utilization. A Chief Medical Information Officer might use a predictive model to determine which facilities are overtaxed and which resources to bolster within those facilities, and a Care Line Manager might use it to determine if there will be adequate staff resources to handle the release of a patient.
Being able to predict length of stay at the time of admission helps hospitals provide higher quality care and streamline their operational workload. It also helps accurately plan for discharges, lowering other quality measures such as readmissions.

## Architecture
<img src="media/predict-length-of-stay-and-patient-flow-with-healthcare-analytics.svg" alt='architecture diagram' />

## Components
* [SQL Server R Services](https://www.microsoft.comhref="http://azure.microsoft.com/sql-server/sql-server-r-services): Stores the patient and hospital data. Provides training and predicted models and predicted results for consumption using R.
* [Power BI](https://powerbi.microsoft.comhttp://azure.microsoft.com/) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.
* [Machine Learning Studio](href="http://azure.microsoft.com/services/machine-learning-studio/): Machine Learning helps you easily design, test, operationalize, and manage predictive analytics solutions in the cloud.

## Next Steps
* [Learn more about SQL Server](https://www.microsoft.com/sql-server/sql-server-r-services)
* [Learn more about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)
* [Learn more about Machine Learning](https://docs.microsoft.com/azure/machine-learning/machine-learning-what-is-machine-learning)