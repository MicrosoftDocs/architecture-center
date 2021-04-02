The healthcare industry has traditionally been unable to effectively use the vast amount of data it creates. Majority of the medical data is unstructured and inaccessible for data driven decisions. When looking for insights, providers spend a considerable amount of time on data ingestion and unification. Healthcare organizations also face security and compliance pressures and risks of data breaches. Using [Microsoft Cloud for Healthcare](https://docs.microsoft.com/industry/healthcare/overview), you can build solutions to improve clinical and operational insights. This article discusses one such potential solution, and builds on the knowledge learned from [Virtual health on Microsoft Cloud for Healthcare](./virtual-health-mch.yml).

## Potential use cases

This solution demonstrates the following capabilities, which may be applicable to any scenario in any industry, not limited to healthcare:

- Gather data from multiple structured/unstructured sources, and visualize trends and insights using Power BI.

- Set up automated operational tasks upfront based on these insights.

- Interpret the structured/unstructured data from disparate systems using machine learning, and assist various roles in the system.

- Share the data and insights securely and collaborate with different departments/roles using Microsoft Teams.

## Architecture

[![Clinical insights using Microsoft Cloud for Healthcare](./images/clinical-insights-solution.png)](./images/clinical-insights-solution.png#lightbox)

_Download a [Visio file](https://arch-center.azureedge.net/clinical-insights-solution.vsdx) that contains this architecture diagram._

> [!NOTE]
> In the diagram above, the term *ED* refers to an *Emergency Department* of a healthcare facility, such as a hospital. It is also commonly known as *Emergency Room*, or a *casuality department*, and it's the department of the hospital specializing in emergency medicine, and acute care of patients, who may or may not require an emergency transportation, such as an ambulance. This article refers to this department as Emergency Department or ED for short, as a more globally recognized term.

Similar to the Virtual Visit solution, the blue-lined boxes in this architecture diagram represent the Microsoft services that are either the underlying services or add-ons required for [Microsoft Cloud for Healthcare](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare?rtc=1). Each of these services are licensed separately.

Similar to the previous solution, data flows into this architecture through external medical systems, such as patient and provider schedules, medical records, wearable devices, and so on, and then ingested using the [Azure API for FHIR](https://docs.microsoft.com/azure/healthcare-apis/fhir/overview). It could also be gathered from other structured data sources, such as, financial systems. The API transposes the data to Fast Healthcare Interoperability Resources (FHIR) standard. This data is then stored in the Microsoft Dataverse in the [Common Data Model (CDM)](https://docs.microsoft.com/common-data-model/) format, to be consumed by Dynamics 365 and Power BI components in this solution. The CDM component is not shown in the architecture for simplicity.

Additionally, this solution uses Azure Data Lake to store the large amounts of data required for reporting and analytics. This data is analyzed using Azure Synapse, for use by the Machine Learning module and Power BI visualizations. Synapse can also pull in unstructured data, such as X-ray images, and feed it into the machine learning algorithm to generate interpretations. These interpretations are stored in a Microsoft Word document, along with a snapshot of the image. This document is stored as a blob or file in the Dataverse, for future reference.

This solution supports the following data flows for each of the user groups depicted in the diagram:

1. **Care Manager**. Continuing from the virtual visit flow, the care manager has the ability to review their patients' current records through Teams, with the help of *Patient Monitoring Queue*. This Dynamics 265 application provides a list of patients along with an *index score*, which indicates the urgency required to attend them. The care manager can select the patient with the highest index score, which opens the Care Management app to display the related medical records, care plan, appointment information, and so on. Care Management is also able to show insights into patient's daily lifestyle by pulling in data from their registered IoMT device, such as heart rate, in near real-time. The Patient Monitoring Queue is a customized entry point for Care Management, and is integrated with Teams to provide a consistent platform.

    This solution also tracks incoming IoMT data, and Care Management displays this custom Power BI visualizations. Thresholds are set for each device metric, and if these are exceeded, Power Automate triggers a Sales Insights alert within Care Management. These thresholds and alerts may be set for each patient individually. If necessary, the care manager can call the patient directly from Teams, using the contact information stored in Dataverse.

1. **ED Admin**. If the patient needs to visit the Emergency Department (ED), they can coordinate the transportation with their care manager. An ED admin is in charge of taking care of resources and schedules within their department. This solution assists them by providing Power BI reports for resources such as bed usage, intake and readmission events as well as trends. This data is useful to provide more insights on patient readmission rates, which is an important metric for a hospital. These insights may be gathered from the medical data flowing into Azure API for FHIR, such as schedules, patients coming in for specific conditions, patients getting readmitted, and so on. This data is pulled into Azure Synapse, which creates the analyses which are then shown on Teams using Power BI visualizations    . The data and insights relevant for the ED admin are surfaced using the Power BI Teams application, within Teams. *ED Queue*, a custom-built Dynamics 365 web resource, shows a queue of incoming patients at various stages, such as, in-transit, arrived at the ED, going through intake process, assigned a bed/room, and so on. The ED admin can use this information to triage patients based on factors such as, arrival times and criticality of medical condition. These factors may be used as a decision tree using Power Automate flows to automate the tasks required to take care of the patient. These include tasks such as, assign the room or ICU, prepare required medical equipment, order tests specific to their medical condition, and so on. These tasks could be appropriately assigned to available personnel, leading to a timely and efficient patient intake. The solution can help manage the resources such as room, equipment, as well as personnel.

1. **Specialist**. The *specialist* persona in this diagram represents the medical provider in charge of reviewing the tests recommended in the ED flow. For example, a patient is admitted and is recommended an X-ray, the pulmonologist will review the X-ray. When the tests are completed and the test results file is saved in the system, which triggers Power Automate. Power Automate then uses Sales Insights to show a notification for the specialist in the Care Management app. Test results can be from an unstructured data source, such as X-rays. This data is pulled in via Azure Synapse, and fed into a custom Machine Learning model to interpret the data and make suggestions. These interpretations can help the specialist in making the actual diagnosis and the next steps for the patient.

    The specialist then works on a recommended care plan for the patient. The *Social Determinants*, a custom-built [Power Apps canvas app](https://docs.microsoft.com/en-us/powerapps/maker/canvas-apps/getting-started) provides insights into socio-economic conditions of the patient, which helps practitioners to make sure the care plan is customized for the patient's temperament for the best possible outcome. In addition to this, the Care Management app in this solution also shows Power BI visualizations for population health trends relevant to the patient. These are made using aggregated population health metrics specific to the recommended care plan, demographics prescribed with this plan, social determinants, the severity index of the patient, to gauge how different treatment plans have worked out for population similar to the patient profile. The data fed into this visualization in this solution, are gathered from health records stored across the healthcare organization. External data sources such as published data from government researches, may also be used to enrich these insights, and they could be another input to the Azure Data Lake. The care plan is stored in Dataverse for later reference.

1. **Patient**. When the patient is discharged with the care plan, they are asked to provide a *Satisfaction Survey* through the patient portal. This is a [Customer Voice](https://docs.microsoft.com/dynamics365/customer-voice/help-hub) form. This data is also stored in Dataverse for operational insights into the healthcare facility. The patient is also able to view the care plan recommended by the specialist during the ED visit.

1. **Hospital Admin**. The solution also provides several reports for an operational overview, represented by the *Hospital Admin* persona. This may pull in data from multiple data sources, to surface insights on metrics such as, total number of patients visited in a month, monthly readmission rates, monthly financial overview, staff patient ratio, sentiment score gathered from patient surveys. These Power BI reports are integrated into Teams, and should be customized for the healthcare facilities needs. These reports can also help to alert and deep dive into any operational deficiencies. Azure Synapse is used as a data source to aggregate the data coming from multiple systems on these Power BI reports. For example, if a healthcare has issues with readmission rates, they can use these reports to figure out the departments that may be having most issues, and help fix the problems. Since these reports are embedded in Microsoft Teams, it is easy to share on different channels for each department, creating an easy channel for communication and collaboration. Access to these reports could be controlled by different permission levels per department or user.

## Components

This section details the new components used in this architecture, as well as additional roles played by components used in the [Virtual Visit solution](./virtual-health-mch.yml#components).

- **Azure Synapse Analytics**. This solution uses Azure Synapse to show a potential use of unstructured medical data, such as, medical tests, and using other medical information such as patient history and day-to-day health metrics, by a machine learning algorithm. This algorithm can interpret this medical data to provide machine-generated findings, that may assist medical providers in understanding of the patient's condition.

- **Azure Data Lake**. [Azure Data Lake](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction) stores the data ingested into the system, and allows to be used for analytics by Azure Synapse. (TBD: Is this the right version? Gen1/Gen2?)

- **Patient Monitoring Queue**. This is a custom Dynamics 365 web resource, and not a part of the Microsoft Cloud for Healthcare. It aggregates patient data from multiple sources, and provides an easy access point into each patient's information. It also provides additional insight into each patient's risk level, in the form of the index score.

- **ED Queue**. This is a custom Dynamics 365 web resource, and not a part of the Microsoft Cloud for Healthcare.

- **Power BI Visualizations**. Visualizing large amounts of data, makes it easier to assimilate the insights, and identify patterns and trends. Read [Visualization types in Power BI](https://docs.microsoft.com/power-bi/visuals/power-bi-visualization-types-for-reports-and-q-and-a) for the different types of visualizations available in Power BI, and [Visualizations in Power BI reports](https://docs.microsoft.com/power-bi/visuals/power-bi-report-visualizations) to learn how to create them. This solution also integrates these visuals with Microsoft Teams, allowing them to be shared across departments in a healthcare organization for collaborative process improvements. Read [Collaborate in Microsoft Teams with Power BI](https://docs.microsoft.com/power-bi/collaborate-share/service-collaborate-microsoft-teams) for more information.

- **Azure Machine Learning**. This solution uses [Azure Machine Learning](https://docs.microsoft.com/azure/machine-learning/) to demonstrate a potential use as medical provider's assistant. It can be modeled to use [publicly available medical data](https://guides.lib.berkeley.edu/publichealth/healthstatistics/rawdata) and diagnostic test results of the patients, to provide additional insights into patient's condition. The final diagnostic responsibility lies with the medical provider.

- **Dynamics365 Sales Insights**. [Sales Insights](https://docs.microsoft.com/dynamics365/ai/sales/overview) is a Dynamics 365 add-in that analyzes data in the Dataverse to provide sophisticated insights. This solution uses Sales Insights for:

  - alerting if patient's wearable device has exceeded any preset thresholds for health metrics, such as heart rate, and
  
  - alerting if a diagnostic result is available in the system.

  These notifications are triggered from a [Power Automate flow](https://docs.microsoft.com/power-automate/flow-types). See [Create custom insight cards](https://docs.microsoft.com/dynamics365/ai/sales/create-insight-cards-flow) on how to create automation flows that integrate with Sales Insights.

- **Power Automate**. [Power Automate](https://docs.microsoft.com/power-automate/getting-started) provides a no-code/low-code platform to automate repetitive manual tasks in a business. Every workflow created is specific to that business or scenario, and hence customized. In this solution, Power Automate ingests data stored in Dataverse to set automations such as sending notifications when specified data changes. See [Create a cloud flow that uses Microsoft Dataverse](https://docs.microsoft.com/power-automate/common-data-model-intro) on how to create customized data-based flows.

- **Customer Voice**. [Dynamics 365 Customer Voice](https://docs.microsoft.com/dynamics365/customer-voice/about) is enterprise feedback management application. This solution uses this service to get feedback from patients after a recent emergency hospital visit, to get insights in management of ED processes. These insights are again stored in Dataverse to be used by the hospital admin for process improvements.

- **Unstructured data**. This block in the architecture is used to represent unstructured binary data such as X-ray results. This solution does not store this data, as it may already be stored in existing EHR systems. However, you may consider storing such data [securely in Azure Blob Storage](https://docs.microsoft.com/azure/storage/blobs/security-recommendations).

- **Social Determinants**. This is a [Power BI Canvas app](https://docs.microsoft.com/powerapps/maker/canvas-apps/get-started-test-drive). This app uses a standardized questionnaire on socio-economic factors from national medical associations, to predict how well the patient will adhere to the care plan. This data may be gathered at any point during the patient's current or past visits, and stored in Dataverse to inform any future decisions.

## Alternatives

All of the Dynamics 365 applications in this architecture are tightly integrated the Dynamics 365 platform, which uses Dataverse as the data source. If these are replaced by third party applications, they should interact with Dataverse using its RESTful [API interface](https://docs.microsoft.com/powerapps/developer/data-platform/work-with-data). For example, the built-in patient monitoring and ED Queue in the existing EHR system. Dataverse is convenient data source for aggregated data to be used by multiple components such as PowerBI, Power Automate, Synapse Analytics, Patient Portal, Teams, and so on.

## Security considerations

The security considerations for any architecture involving Microsoft Cloud for Healthcare would be similar. Please refer to the [security considerations discussed in the Virtual Visits solution](./virtual-health-mch.yml#security-considerations).

## Pricing

Pricing information for this architecture is similar to [pricing discussed in the Virtual Visits solution](./virtual-health-mch.yml#pricing).

## Deploy the solution

For deploying this solution, go through steps one through four of [the deployment for Virtual Visits solution](./virtual-health-mch.yml#deploy-the-solution).

The following are the additional components created specifically for this solution. You might choose to create similar applications, or use tools provided by the EHR system in use.

1. Patient Monitoring Queue.

1. ED Queue.

1. Power BI visualizations for applications in this solution.

1. Power Automate notifications for device thresholds and diagnostic test availability.

1. Diagnostic imaging insights with Azure Machine Learning.

## Next steps

- Learn more about the Microsoft Cloud for Healthcare at [What is Microsoft Cloud for Healthcare?](https://docs.microsoft.com/industry/healthcare/overview)

- Learn more about Azure for healthcare offerings at [Azure for Healthcare—Healthcare Solutions](https://azure.microsoft.com/industries/healthcare/).

## Related resources

- [Guide to social needs screening - American Academy of Family Physicians](https://www.aafp.org/dam/AAFP/documents/patient_care/everyone_project/hops19-physician-guide-sdoh.pdf) (TBD: Right link?)
