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
> In the diagram above, the term *ED* refers to an *Emergency Department* of a healthcare facility or a hospital. It is also commonly known as *Emergency Room*, or a *casuality department*, and it's the department of the hospital specializing in emergency medicine, and acute care of patients, who may or may not require an emergency transportation (ambulance). This article uses the more globally reconized term, Emergency Department (ED).

Similar to the Virtual Visit solution, the blue-lined boxes in this architecture diagram represent the Microsoft services that are either the underlying services or add-ons required for [Microsoft Cloud for Healthcare](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare?rtc=1). Each of these services are licensed separately.

Similar to the previous solution, data flows into this architecture through external medical systems, such as patient and provider schedules, medical records, wearable devices, and so on, and then ingested using the [Azure API for FHIR](https://docs.microsoft.com/azure/healthcare-apis/fhir/overview). It could also be gathered from other structured data sources, such as, financial systems. The API transposes the data to Fast Healthcare Interoperability Resources (FHIR) standard. This data is then stored in the Microsoft Dataverse in the [Common Data Model (CDM)](https://docs.microsoft.com/common-data-model/) format, to be consumed by Dynamics 365 and Power BI components in this solution. The CDM component is not shown in the architecture for simplicity.

Additionally, this solution uses Azure Data Lake to store the large amounts of data required for reporting and analytics. This data is analyzed using Azure Synapse, for use by the Machine Learning module and Power BI visualizations. Synapse can also pull in unstructured data, such as X-ray images, and feed it into the machine learning algorithm to generate interpretations. These interpretations are stored in a Microsoft Word document, along with a snapshot of the image. This document is stored as a blob or file in the Dataverse, for future reference.

This solution supports the following data flows for each of the user groups depicted in the diagram:

1. **Care Manager**. Continuing from the virtual visit flow, the care manager has the ability to review their patients' current records through Teams, with the help of *Patient Monitoring Queue*. This Dynamics 265 application provides a list of patients along with an *index score*, which indicates the urgency required to attend them. The care manager can select the patient with the highest index score, which opens the Care Management app to display the related medical records, care plan, appointment information, and so on. Care Management is also able to show insights into patient's daily lifestyle by pulling in data from their registered IoMT device, such as heart rate, in near real-time. The Patient Monitoring Queue is a customized entry point for Care Management, and is integrated with Teams to provide a consistent platform.

    This solution also tracks incoming IoMT data, and Care Management displays this custom Power BI visualizations. Thresholds are set for each device metric, and if these are exceeded, Power Automate triggers a Sales Insights alert within Care Management. These thresholds and alerts may be set for each patient individually. If necessary, the care manager can call the patient directly from Teams, using the contact information stored in Dataverse.

1. **ED Admin**. If the patient needs to visit the Emergency Department (ED), they can coordinate the transportation with their care manager. An ED admin is responsible for the resources and schedules required in this department. The ED admin can monitor resources such as bed usage, intake and readmission events as well as trends, using Power BI reports integrated with Teams. This data is useful to provide more insights on vital metrics for the hospital, for example, the patient readmission rates. These insights may be created using data such as patients schedules, tracked medical conditions, number of times patients are readmitted, and so on. Azure Synapse creates the analyses relevant to the ED, which are visualized on the Power BI reports in Teams. *ED Queue*, a custom-built Dynamics 365 web resource, shows a queue of incoming patients at various stages such as, in-transit, checkin, intake, room assignment, and so on. The ED admin can use this information to triage patients based on their arrival times and criticality of their medical condition. A decision tree is created with Power Automate flows, which automates tasks required to for patient care. These tasks include room or ICU assignment, medical equipment setup, and ordering of required tests, and are assigned to available personnel. Thus this solution can help efficient management of ED resources and personnel, resulting in smooth patient intake.

1. **Specialist**. The *specialist* persona in this diagram represents the medical provider in charge of reviewing the tests recommended in the ED flow. For example, the pulmonologist who will review any X-ray results for admitted patients. When a test is completed, the results are saved in the system. This event triggers Power Automate, which shows a Sales Insights alert for the specialist in the Care Management. Test such as X-rays are considered unstructured data, which is pulled in by Azure Synapse, and fed into a custom Machine Learning model for making interpretations. These interpretations can help the specialist to make the actual diagnosis and suggest the next steps for the patient.

    The specialist then recommends a care plan for the patient. *Social Determinants*, a custom-built [Power Apps canvas app](https://docs.microsoft.com/powerapps/maker/canvas-apps/getting-started) provides insights into socio-economic conditions of the patient. This data can help the specialist customize the care plan for the patient that may give the best possible outcome. In addition to this, Care Management shows Power BI visualizations suggesting *population health trends*, using aggregated population health metrics, demographics, social determinants, and the severity index of the patient. These visualizations help gauge the success rates of different care plans used to treat population profiles similar to the patient. The data fed into these visualizations, is gathered from health records stored across the healthcare organization. External data sources, such as the data published from government researches, may also be used to enrich these insights. Such data would need to be pulled in to Azure Data Lake. The selected care plan is stored in Dataverse for later reference.

1. **Patient**. When the patient is discharged with the care plan, they are asked to provide a *Satisfaction Survey* through the patient portal. This is a [Customer Voice](https://docs.microsoft.com/dynamics365/customer-voice/help-hub) form. The survey result is stored in Dataverse to generate operational insights into the healthcare facility. The patient can use the Patient Portal to view the care plan recommended by the specialist, as well as get access to educational material designed to help them recover at home.

1. **Hospital Admin**. The solution can help a hospital admin improve healthcare management, by providing Power BI reports customized for an operational review of the facilities. These reports can surface insights on metrics such as, total number of patient visits in a month, monthly readmission rates, financial overview, staff patient ratio, and the sentiment score gathered from patient surveys. These Power BI reports are integrated into Teams. Azure Synapse aggregates the data coming from multiple systems for these Power BI reports.

    These reports can assist the hospital admin in detecting operational deficiencies. For example, if a hospital has high readmission rates, these reports can be used to find departments with the most readmissions, and then troubleshoot and fix the underlying issues. Since these reports are integrated with Microsoft Teams, they can be easily shared with each department using [Teams channels](https://docs.microsoft.com/microsoftteams/teams-channels-overview), allowing faster communication and collaboration. Access to these reports can be controlled by setting permission levels per department or user.

## Components

Most of the components used in this solution are detailed in the [Components section of the Virtual Visit solution](./virtual-health-mch.yml#components). This section details the additional components.

- **Azure Synapse Analytics**. Azure Synapse is used to demonstrate how unstructured medical data such as diagnostic test results, as well as patient data such as medical history and day-to-day health metrics, can be interpreted by a machine learning algorithm. This algorithm can provide machine-generated findings, that may assist medical providers in quicker understanding of the patient's condition.

- **Azure Data Lake**. [Azure Data Lake](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction) stores the data ingested into the system. Azure Synapse uses this data for analytics.

- **Patient Monitoring Queue**. This is a custom [Dynamics 365 web resource](https://docs.microsoft.com/dynamics365/customerengagement/on-premises/customize/create-edit-web-resources), and not a part of the Microsoft Cloud for Healthcare. It aggregates patient data from multiple sources, and provides an easy access point into each patient's information. It also provides additional insights into each patient's risk level, in the form of the index score.

- **ED Queue**. This is a custom Dynamics 365 web resource, and not a part of the Microsoft Cloud for Healthcare. This queue shows the information of patients coming into the ED, that can help the ED admin to quickly triage and assign required resources.

- **Power BI Visualizations**. Visualizing large amounts of data, makes it easier to assimilate the insights, and identify patterns and trends. Read [Visualization types in Power BI](https://docs.microsoft.com/power-bi/visuals/power-bi-visualization-types-for-reports-and-q-and-a) for the different types of visualizations available in Power BI, and [Visualizations in Power BI reports](https://docs.microsoft.com/power-bi/visuals/power-bi-report-visualizations) to learn how to create them. This solution also integrates these visuals with Microsoft Teams, allowing them to be shared across departments in a healthcare organization for collaborative process improvements. Read [Collaborate in Microsoft Teams with Power BI](https://docs.microsoft.com/power-bi/collaborate-share/service-collaborate-microsoft-teams) for more information.

- **Azure Machine Learning**. This solution uses [Azure Machine Learning](https://docs.microsoft.com/azure/machine-learning/) to demonstrate a potential use as a medical provider's assistant. It can be modeled to use [publicly available medical data](https://guides.lib.berkeley.edu/publichealth/healthstatistics/rawdata) and diagnostic test results of the patients, to provide additional insights into patient's condition. The final diagnostic responsibility lies with the medical provider.

- **Dynamics 365 Sales Insights**. [Sales Insights](https://docs.microsoft.com/dynamics365/ai/sales/overview) is a Dynamics 365 add-in that analyzes data in Dataverse to provide sophisticated insights. This solution uses Sales Insights for alerting when:

  - patient's wearable device exceeds preset thresholds for health metrics, such as heart rate, and
  
  - diagnostic test results are available in the system.

  These notifications are triggered from a [Power Automate flow](https://docs.microsoft.com/power-automate/flow-types). See [Create custom insight cards](https://docs.microsoft.com/dynamics365/ai/sales/create-insight-cards-flow) on how to create automation flows that integrate with Sales Insights.

- **Power Automate**. [Power Automate](https://docs.microsoft.com/power-automate/getting-started) provides a no-code/low-code platform to automate repetitive manual tasks in a business. Every workflow created is specific to that business or scenario, and hence customized. In this solution, Power Automate ingests data stored in Dataverse to set automations such as, sending notifications for data changes. See [Create a cloud flow that uses Microsoft Dataverse](https://docs.microsoft.com/power-automate/common-data-model-intro) on how to create customized data-based flows.

- **Customer Voice**. [Dynamics 365 Customer Voice](https://docs.microsoft.com/dynamics365/customer-voice/about) is an enterprise feedback management application. This solution uses this application to get feedback from patients after a recent emergency hospital visit. This feedback can provide insights into the management of ED processes. These insights are stored in Dataverse for use by the hospital admin for process improvements.

- **Unstructured data**. This block in the architecture is used to represent unstructured binary data such as X-ray results. This solution does not store this data, as it may already be stored in the existing EHR systems. However, you may consider storing such data [securely in Azure Blob Storage](https://docs.microsoft.com/azure/storage/blobs/security-recommendations).

- **Social Determinants**. This is a [Power BI Canvas app](https://docs.microsoft.com/powerapps/maker/canvas-apps/get-started-test-drive). This app uses a standardized questionnaire on socio-economic factors from national medical associations, to predict how well the patient will adhere to the care plan. This data may be gathered at any point during the patient's current or past visits, and stored in Dataverse to inform any future decisions.

## Alternatives

The Dynamics 365 applications used in this architecture are tightly integrated the Dynamics 365 platform, which uses Dataverse as the data source. If these are replaced by third party applications, such as built-in EHR tools for patient monitoring and emergency department triages, they should interact with Dataverse using its RESTful [API interface](https://docs.microsoft.com/powerapps/developer/data-platform/work-with-data). Dataverse is a convenient data source for aggregated data to be used by multiple components such as PowerBI, Power Automate, Synapse Analytics, Patient Portal, Teams, and so on.

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

- [Questionnaire to detect the socioeconomic conditions of patients](https://icd.who.int/browse10/2016/en#/Z55-Z65)
