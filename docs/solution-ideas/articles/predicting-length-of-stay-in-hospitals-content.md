


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution enables a predictive model for Length of Stay for in-hospital admissions. Length of Stay (LOS) is defined in number of days from the initial admit date to the date that the patient is discharged from any given hospital facility.

## Architecture

![Architecture Diagram](../media/predicting-length-of-stay-in-hospitals.png)
*Download an [SVG](../media/predicting-length-of-stay-in-hospitals.svg) of this architecture.*

## Description

Required preliminary agreement: You need to accept the Terms of Use for the Data Science Virtual Machine on your Azure Subscription before you deploy this VM the first time. Click here to agree to these terms.

## Overview

This solution enables a predictive model for Length of Stay for in-hospital admissions. Length of Stay (LOS) is defined in number of days from the initial admit date to the date that the patient is discharged from any given hospital facility. There can be significant variation of LOS across various facilities and across disease conditions and specialties even within the same healthcare system. Advanced LOS prediction at the time of admission can greatly enhance the quality of care as well as operational workload efficiency and help with accurate planning for discharges resulting in lowering of various other quality measures such as readmissions.

## Business Perspective

There are two different business users in hospital management who can expect to benefit from more reliable predictions of the Length of Stay. These are:

* The Chiefs Medical Information Officer (CMIO), who straddles the divide between informatics/technology and healthcare professionals in a healthcare organization. Their duties typically include using analytics to determine if resources are being allocated appropriately in a hospital network. As part of this, the CMIO needs to be able to determine which facilities are being overtaxed and, specifically, what resources at those facilities may need to be bolstered to realign such resources with demand.
* The Care Line Manager, who is directly involved with the care of patients. This role requires monitoring the status of individual patients as well as ensuring that staff is available to meet the specific care requirements of their patients. A Care Line Manager also needs to manage the discharge of their patients. The ability to predict LOS of a patient enables Care Line Managers to determine if staff resources will be adequate to handle the release of a patient.

## Data Scientist Perspective

SQL Server R Services brings the computing resources to the data by running R on the computer that hosts the database. It includes a database service that runs outside the SQL Server process and that communicates securely with the R runtime.

This solution walks through the steps needed to create and refine data, train the R models, and perform scoring on the SQL Server machine. The final scored database table in SQL Server gives the predicted LOS for each patient. This data is then visualized in PowerBI. (Simulated data is used in this template to illustrate the feature.)

Data scientists who are testing and developing solutions can work conveniently from their preferred R IDE on their client machine, while pushing the compute to the SQL Server machine. The completed solutions are deployed to SQL Server 2016 by embedding calls to R in stored procedures. These solutions can then be further automated with SQL Server Integration Services and SQL Server agent.

This solution includes the R code needed by a data scientist in the R folder. It shows the stored procedures (.sql files) that can be deployed in the SQLR folder. A PowerShell script (.ps1 file) is also provided that automates the running of the SQL code. Click on the Deploy button to test the automation and the entire solution will be made available in your Azure subscription.

## Pricing

Your Azure subscription used for the deployment will incur consumption charges on the services used in this solution, approximately $1.15/hour for the default VM.

Please ensure that you stop your VM instance when not actively using the solution. Running the VM will incur higher costs.

Please delete the solution if you are not using it.
