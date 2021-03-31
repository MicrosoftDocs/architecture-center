The healthcare industry has been traditionally been unable to effectively use the vast amount of data it creates. Majority of the medical data is unstructured and inaccessible for data driven decisions. When looking for insights, providers spend a considerable amount of time on data ingestion and unification. Healthcare organizations also face security and compliance pressures and risks of data breaches. Using [Microsoft Cloud for Healthcare](https://docs.microsoft.com/industry/healthcare/overview), you can build solutions to improve clinical and operational insights. This article discusses one such potential solution, and builds on the knowledge learned from [Virtual health on Microsoft Cloud for Healthcare](./virtual-health-mch.yml).

## Potential use cases

This solution demonstrates the following capabilities, any of which could be used in any scenario of any industry which requires those capabilities:

- Gather data insights from structured/unstructured data and display them with the help of Power BI visualizations.

- Set up automated operational tasks upfront based on these insights.

- Interpret the data from structured/unstructured data from desparate systems using machine learning, to assist various roles in the system.

- Share the data and insights securely and collaborate with different departments/roles using Teams.

## Architecture

![Clinical insights using Microsoft Cloud for Healthcare](./images/clinical-insights-solution.png)

_Download a [Visio file](https://arch-center.azureedge.net/virtual-health-solution.vsdx) that contains this architecture diagram._

Similar to the Virtual Visit solution, the blue-lined boxes in this architecture diagram represent the Microsoft services that are either the underlying services or add-ons required for [Microsoft Cloud for Healthcare](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare?rtc=1), each of which must be licensed separately.

Similar to the previous solution, data flows into this architecture through external medical systems, such as patient and provider schedules, medical records, wearable devices, and so on, and then ingested using the [Azure API for FHIR](https://docs.microsoft.com/azure/healthcare-apis/fhir/overview). It could also be gathered from other structured/unstructured data sources, such as, financial systems. The data transposed to the FHIR (or Fast Healthcare Interoperability Resources) standard, is stored in the Microsoft Dataverse in the [Common Data Model (CDM)](https://docs.microsoft.com/common-data-model/) format and then consumed by Dynamics 365 and Power BI components in this solution. The CDM component is not shown in the architecture for simplicity.

Additionally, this solution uses Azure Data Lake to store the large amounts of data required for reporting and analytics. This data is analyzed using Azure Synapse, for use by the Machine Learning module and Power BI visualizations. Synapse can also pull in unstructured data, such as X-ray images, and feed it into the machine learning algorithm to interpret this data. These intrepretations are stored in a Microsoft Word document, alongwith a snapshot of the image. This document is stored as a blob or file in the Dataverse, for future reference.

Continuing from the virtual visit flow, the care manager has the ability to review the patients current records through Teams, with the help of **Patient Monitoring Queue*, a custom Dynamics 365 web resource. It aggregates patient data from multiple sources, and provides an easy access point into each patient's information. It also provides additional insight into each patient's risk level, in the form of an *index score*. With the help of this score, the care manager is able to deep dive into the most critical patients under their care, and get access to these patients' records, care plan, appointment information, and so on, using the Care Management application. Care Management is able to show insights into patient's daily lifestyle by pulling in IoMT device data such as heart rate, in near real-time from the underlying Dynamics 365 layers. The Patient Monitoring Queue is a customized entry point for Care Management, that's better embedded with Teams in addition to provide the priority criteria for selecting the patient. This solution does not use the model-driven dashboard that comes default with the Care Management (TBD correct?).

This solution also has custom Power BI visualizations for incoming IoMT data, using threshold values for each device metric. If these thresholds are exceeded, Power Automate triggers a [*Sales Insights*](https://docs.microsoft.com/en-us/dynamics365/ai/sales/overview) notification as a warning on the Care Management's summary view (TBD correct?). (TBD: Add Sales Insights under the Power Automate and before Care management) These thresholds and alerts may be set for each patient individually. If the care manager thinks it is necessary, they can call the patient directly from Teams, using the contact information stored in the database.

If the patient is required to check in to an Emergency Department (ED), the care manager schedules that visit. An ED admin is in charge of taking care of resources and schedules within their department. This solution assists them by providing Power BI reports for resources such as bed usage, intake and readmission events as well as trends. This data is useful to provide more insights on patient readmission rates, which is an important metric for a hospital. These insights may be gathered from the medical data flowing into Azure API for FHIR, such as schedules, patients coming in for specific conditions, patients getting readmitted, and so on. This data is pulled into Azure Synapse, which creates the analyses which are then shown on Teams using Power BI visualizations (TBD correct?). The data and insights relavant for the ED admin are surfaced using the Power BI Teams application, within Teams. *ED Queue*, a custom-built Dynamics 365 web resource, shows a queue of incoming patients at various stages, such as, in-transit, arrived at the ED, going through intake process, assigned a bed/room, and so on. The ED admin can use this information to triage patients based on factors such as, arrival times and criticality of medical condition. These factors may be used as a decision tree using Power Automate flows to automate the tasks required to take care of the patient. These include tasks such as, assign the room or ICU, prepare required medical equipment, order tests specific to their medical condition, and so on. These tasks could be appropriately assigned to available personnel, leading to a timely and efficient patient intake. The solution can help manage the resources such as room, equipment, as well as personnel.

The *specialist* (TBD: Rename pulmonologist to specialist in diagram) persona in this diagram represents the medical provider in charge of reviewing the tests recommended in the ED flow. For example, a patient is admitted and is recommended an X-ray, the pulmologist will review the X-ray. When the tests are completed and the test file is saved in the EHR system, Power Automate gets triggered, which in turn uses Sales Insights to show a notification for the specialist in the Care Management app. Test results can be from an unstructured data source, such as X-rays. This data is pulled in via Azure Synapse, and fed into a custom Machine Learning model to interpret the data and make suggestions. These interpretations can help the specialist in making the actual diagnosis and the next steps for the patient.

The specialist then works on a recommended care plan for the patient. The *Social Determinants* [canvas app](https://docs.microsoft.com/en-us/powerapps/maker/canvas-apps/get-started-test-drive) uses a standardized questionnaire on socio-economic factors from Americal Medical Association, to predict how well the patient will adhere to the care plan. This helps practioners to make sure the care plan is customized for the patient's temparament for the best possible outcome. This data may be gathered at any point during the patient's current or past visits, and stored in DataVerse to inform any future decisions. In addition to this, the Care Management app in this solution also shows Power BI visualizations for health trends relevant to the patient. These are made using aggregated population health metrics specific to the recommended care plan, demographics prescribed with this plan, social determinants, the severity index of the patient, to guage how different treatment plans have worked out for population similar to the patient profile. The data fed into this visualization in this solution, are gathered from health records stored across the healthcare organization. External data sources such as published data from government researches, may also be used to enrich these insights, and they could be another input to the Azure Data Lake (TBD: to add "Structured data" under the Azure for Healthcare in the diagram). The care plan is stored in the DataVerse for later reference.

When the patient is discharged with the care plan, they are asked to provide a *Satisfaction Survey* (TBD: which app is this?) through the patient portal. This is a [Customer Voice](https://docs.microsoft.com/en-us/dynamics365/customer-voice/help-hub) form. This data is also stored in DataVerse for operational insights into the healthcare facility. The patient is also able to view the care plan recommended by the specialist during the ED visit.

The solution also provides reports for an operational overview, represented by the *Hospital Admin* persona. This may pulling in data from all data sources, to gather insights on metrics such as, total number of patients visited in a month, monthly readmission rates, monthly financial overview, staff patient ratio, sentiment score gathered from patient surveys. These Power BI reports are integrated into Teams, and should be customized for the healthcare facilities needs. These reports can also help to alert and deep dive into any operational deficiencies. Azure Synapse is used to create these Power BI reports (TBD: ?). For example, if a healthcare has issues with readmission rates, they can use these reports to figure out the departments that may be having most issues, and help fix the problems. Since these reports are Teams apps, it is easy to share on different channels for each department, creating an easy communication channel. Access to these reports could be controlled by different permission levels per department or user.

## Components

This section details the new components used in this architecture, as well as additional roles played by components used in the [Virtual Visit solution](./virtual-health-mch.yml).

**Azure Synapse Analytics**. This solution uses Azure Synapse to show a potential use of unstructured medical data, such as, medical tests, and using other medical information such as patient history and day-to-day health metrics, by a machine learning algorithm. This algorithm can interpret this medical data to provide machine-generated findings, that may assist medical providers in understanding of the patient's condition.

- **Microsoft Dataverse**. [Dataverse](https://docs.microsoft.com/powerapps/maker/data-platform/data-platform-intro), a relational database that powers Microsoft Dynamics 365, is the repository for the data represented in the Common Data Model. It holds databases for patient information, containing details about their names, family information, medical conditions, medication history, and so on. It also holds the information obtained from any wearable devices used and registered by the patients, as well as, scheduling and management data from the healthcare organization. This data is defined using the Common Data Model.

- **ED Queue**. TBD to write.

- **Power BI Visualizations**. TBD

- **Azure Machine Learning**. TBD

- **Customer Voice**. TBD

- **Unstructured data**. TBD

- **Social Determinants**. This is a Power BI Canvas app. TBD: link on how to create.

## Alternatives

All of the D364 applications in this architecture are tightly integrated with D365, which uses DataVerse as the data source. If these are replaced by non-D365 applications, such as if the existing EHR system has built-in patient monitoring and ED Queue, they can still interact with DataVerse via its RESTful API interface (TBD link?). In reality, some EHRs can be advanced enough to not require any Dynamics365 other than DataVerse. Having it DataVerse is convenient as a single location for aggregated data to be used by multiple components such as PowerBI, Power Automate, Synapse Analytics, Patient Portal, Teams, and so on.

TBD

## Security considerations

The security considerations for any architecture involving Microsoft Cloud for Healthcare would be similar. Please refer to the [security considerations discussed in the Virtual Visits solution](./virtual-health-mch.yml).

## Pricing

Pricing information for this architecture is similar to [pricing discussed in the Virtual Visits solution](./virtual-health-mch.yml).

## Deploy the solution

TBD anything else?

The deployment of this solution is similar to the [deployment for Virtual Visits solution](./virtual-health-mch.yml).

## Next steps

- Learn more about the Microsoft Cloud for Healthcare at [What is Microsoft Cloud for Healthcare?](https://docs.microsoft.com/industry/healthcare/overview)

- Learn more about Azure for healthcare offerings at [Azure for Healthcare—Healthcare Solutions](https://azure.microsoft.com/industries/healthcare/).

## Related resources

- [FHIR standard for health care data exchange](https://www.hl7.org/fhir/index.html)

- [Difference between EMR and EHR](https://www.healthit.gov/buzz-blog/electronic-health-and-medical-records/emr-vs-ehr-difference)

- [HIPAA compliance rules](https://www.hhs.gov/hipaa/index.html)
