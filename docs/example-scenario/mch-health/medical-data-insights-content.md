The healthcare industry has traditionally struggled to effectively use the vast amount of data it creates. Most of the medical data is unstructured and inaccessible for data driven decisions. When looking for insights, providers spend a considerable amount of time on data ingestion and unification. Healthcare organizations also face security and compliance pressures and risks of data breaches. Using [Microsoft Cloud for Healthcare](/industry/healthcare/overview), you can build solutions to improve clinical and operational insights. This article discusses one such potential solution, and builds on the knowledge learned from [Virtual health on Microsoft Cloud for Healthcare](./virtual-health-mch.yml).

## Potential use cases

This solution demonstrates the following capabilities, which may be applicable to any industry:

- Gather data from multiple structured/unstructured sources, and visualize trends and insights using Power BI.

- Set up automated operational tasks upfront based on these insights.

- Interpret the structured/unstructured data from disparate systems using machine learning, and assist various roles in the system.

- Share the data and insights securely and collaborate with different departments/roles using Microsoft Teams.

## Architecture

[![Clinical insights using Microsoft Cloud for Healthcare](./images/clinical-insights-solution.png)](./images/clinical-insights-solution.png#lightbox)

_Download a [Visio file](https://arch-center.azureedge.net/clinical-insights-solution.vsdx) that contains this architecture diagram._

> [!NOTE]
> In the diagram above, the term *ED* refers to an *Emergency Department* of a healthcare facility or a hospital. It is also commonly known as *Emergency Room*, or a *casualty department*. This hospital department specializes in emergency medicine and acute care of patients, who may or may not require an emergency transportation (or an ambulance). This article uses the more globally recognized term, Emergency Department (ED).

Similar to the Virtual Visit solution, the blue-lined boxes in this architecture diagram represent the Microsoft services that are either the underlying services or add-ons required for [Microsoft Cloud for Healthcare](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare?rtc=1). Each of these services is licensed separately.

Similar to the previous solution, data flows into this architecture through external medical systems, such as patient and provider schedules, medical records, wearable devices, and so on, and then ingested using Azure. This process can also ingest other structured data required for specific insights, such as financial data. This data is then stored in Microsoft Dataverse in the [Common Data Model (CDM)](/common-data-model/) format, to be consumed by [Dynamics 365](https://dynamics.microsoft.com/) and [Power BI](https://powerbi.microsoft.com/) components in this solution.

This solution also uses Azure Data Lake to store the large amounts of data required for reporting and analytics. This data is analyzed using Azure Synapse, for use by the machine learning module and Power BI visualizations. Synapse can also pull in unstructured data, such as X-ray images, and feed it into the machine learning algorithm to generate interpretations. These interpretations are stored in a Microsoft Word document, along with a snapshot of the image. This document is stored as a blob or file in Dataverse, for future reference.

This solution supports the following data flows for each of the user groups shown in the diagram:

1. **Care Manager**. Continuing from the virtual visit flow, the care manager can review their patients' current records through Teams, with the help of *Patient Monitoring Queue*. This Dynamics 365 application provides a list of patients along with an *index score*, which indicates the urgency required to attend them. The care manager can select the patient with the highest index score, and view their medical records, care plan, appointment information, and so on, in the Care Management app. Care Management is also able to show insights into the patient's daily lifestyle by pulling in data such as heart rate, from their registered IoMT device, in near real time. Care Management tracks and displays the incoming device data with custom Power BI visualizations. Thresholds are set for each device metric, and if exceeded, Power Automate triggers a Sales Insights alert within Care Management. These thresholds and alerts may be set for each patient individually. If necessary, the care manager can call the patient directly from Teams, using the contact information stored in Dataverse.

1. **ED Admin**. If the patient needs to visit the Emergency Department (ED), they can coordinate the transportation with their care manager. An ED admin is responsible for the resources and schedules in this department. Resources such as bed usage, rooms, and personnel, as well as trends in intake and readmission events, are monitored with Power BI reports customized for the department and integrated with Teams. These reports are created using hospital and patient data stored in Dataverse, and analyzed by Azure Synapse. *ED Queue*, a custom Dynamics 365 web resource, displays a queue of incoming patients at various stages such as, in-transit, checkin, intake, room assignment, and so on. The ED admin can use this information to triage patients based on their arrival times and medical conditions. A decision tree is created with Power Automate *flows*, which automates tasks required for patient care. Examples of these tasks can be room or ICU assignment, medical equipment setup, ordering of required tests, and assignment to available medical staff. These reports and automations lead to efficient patient care and ED management.

1. **Specialist Physician**. The ED admin assigns a specialist physician, to review the tests recommended for the patient in the ED automation. For example, if X-ray tests are required, a pulmonologist is assigned to review them. The test results are saved in the system, which triggers Power Automate. Power Automate displays a Sales Insights alert in the physician's view of the Care Management. Test such as X-rays are considered unstructured data. This data is pulled into Azure Synapse through Azure Data Lake, and fed into a custom machine learning model to interpret the results. These interpretations can help the physician to make the actual diagnosis and recommend the treatment or care plan.

    *Social Determinants*, a [canvas app](/powerapps/maker/canvas-apps/getting-started) custom-built for this solution, provides insights into the patient's socio-economic conditions. This data can help the physician to prescribe a care plan that is most likely to be followed by the patient. Power BI visualizations in the Care Management, also display the treatment success trends for the patient's medical condition, using aggregated *population health metrics*, demographics, social factors, and other data available in the hospital records. It may also use publically available medical data from government-funded researches. These visualizations can help the physician choose the care plan with the best success rate. The data fed into these visualizations is pulled in through Azure Data Lake. The selected care plan is stored in Dataverse for later reference.

1. **Patient**. When the patient is discharged with the care plan, they are asked to provide a *Satisfaction Survey* through the patient portal. This is a [Customer Voice](/dynamics365/customer-voice/help-hub) form. The survey result is stored in Dataverse to generate operational insights into the healthcare facility.

    The patient uses the Patient Portal to view the care plan recommended by the physician. The portal can also provide access to educational material that may be required to understand the care plan and recover at home.

1. **Hospital Admin**. Power BI reports customized for the hospital admin, provide insights on key healthcare metrics, such as patient readmission rates, length of stay, staff patient ratio, patient satisfaction, and costs. These insights can help improve healthcare management. These reports are created using data aggregated by Azure Synapse from multiple systems, such as patient visit records, financial data, sentiment scores gathered from patient surveys. These reports can assist the hospital admin in detecting operational shortages. For example, if a hospital has high readmission rates, these reports can be used to find departments with the most readmissions, and then troubleshoot and fix the underlying issues.

    These Power BI reports are integrated with Microsoft Teams. This allows them to be easily shared with other departments using [Teams channels](/microsoftteams/teams-channels-overview), resulting in faster communication and collaboration. Access to these reports can be controlled by setting permission levels per department or user.

## Components

Most of the components used in this solution are detailed in the [Components section of the Virtual Visit solution](./virtual-health-mch.yml#components). Additional components used in this solution are described below:

- **Azure Synapse Analytics**. Azure Synapse is used to demonstrate how unstructured medical data such as diagnostic test results, as well as patient data such as medical history and day-to-day health metrics, can be interpreted by machine learning algorithms. These machine-generated findings can be used to assist medical providers in diagnosing and treating the patient.

- **Azure Data Lake**. [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction) provides a fast and secure data warehouse for Azure Synapse Analytics. Unlike traditional data warehouses, once the large amount of data required for analytics is stored in Azure Data Lake, it's ready to be queried minimizing repeated loading.

- **Azure Machine Learning**. This solution uses [Azure Machine Learning](/azure/machine-learning/) to demonstrate a potential use as a medical provider's assistant. It can be modeled to use [publicly available medical data](https://guides.lib.berkeley.edu/publichealth/healthstatistics/rawdata) and diagnostic test results, to provide additional insights into patient's medical condition. The final diagnostic responsibility lies with the medical provider.

- **Power BI**. Visualizing large amounts of data makes it easier to assimilate insights and identify patterns or trends. Read [Visualization types in Power BI](/power-bi/visuals/power-bi-visualization-types-for-reports-and-q-and-a) and [Visualizations in Power BI reports](/power-bi/visuals/power-bi-report-visualizations) to learn how to create different Power BI visualizations. These visuals can be integrated with Microsoft Teams, allowing them to be shared across departments for collaborative process improvements. Read [Collaborate in Microsoft Teams with Power BI](/power-bi/collaborate-share/service-collaborate-microsoft-teams) for more information.

  This solution creates following Power BI visualizations using Azure Synapse Analytics:

  - A [Power BI dashboard integrated with Teams](/workplace-analytics/tutorials/power-bi-teams#set-up-the-dashboard) for the emergency department, that provides a snapshot of patients waiting, wait times, bed status, projected bed occupancy, and other ED metrics.

  - Population health dashboard that allows providers to compare effectiveness of treatment plans for patients with similar demographics and conditions.

  - Cross department analytics and reports for the hospital administration.

- **Power Automate**. [Power Automate](/power-automate/getting-started) provides a no-code/low-code platform to automate repetitive manual tasks in a business. Every workflow created is specific to that business or scenario, and as such is inherently customized. In this solution, Power Automate ingests data stored in Dataverse to set automations, such as sending notifications for data changes. See [Create a cloud flow that uses Microsoft Dataverse](/power-automate/common-data-model-intro) on how to create customized data-based flows.

  Power Automate flows are also used to automate procedures, room and staff assignments in the emergency department.

- **Sales Insights**. This solution uses [Sales Insights](/dynamics365/ai/sales/overview), a Dynamics 365 add-in, to provide alerts and notifications for the following data changes in the system:

  - patient's wearable device exceeds preset thresholds for health metrics, such as heart rate, and

  - diagnostic test results are available in the system.

  These notifications are triggered from a [Power Automate flow](/power-automate/flow-types). See [Create custom insight cards](/dynamics365/ai/sales/create-insight-cards-flow) on how to create automation flows that integrate with Sales Insights.

- **Patient Monitoring Queue**. This is a custom [Dynamics 365 web resource](/dynamics365/customerengagement/on-premises/customize/create-edit-web-resources), and is not a part of the Microsoft Cloud for Healthcare. It provides the care manager with aggregated patient data from multiple sources, and is a customized entry point for Care Management to access individual patient information. It is integrated with [Microsoft Teams](https://www.microsoft.com/microsoft-teams/group-chat-software) to provide a consistent platform. It also displays the urgency of medical attention each patient requires, in the form of the index score. This score can be derived from the patient's device data and known medical conditions.

- **ED Queue**. This is a custom Dynamics 365 web resource, and is not a part of the Microsoft Cloud for Healthcare. The ED admin uses this queue to retrieve medical information and arrival times of incoming patients, as well as urgency required for their treatment. This helps them to triage more efficiently and start automated workflows using Power Automate to assign resources based on their medical conditions.

- **Social Determinants**. This is a [Power BI Canvas app](/powerapps/maker/canvas-apps/get-started-test-drive), which displays patient's socio-economic factors to medical providers. This information is gathered using a standardized questionnaire, and helps predict how well the patient will adhere to the care plan. This data may be gathered at any point during the patient's current or past visits, and is stored in Dataverse to inform future decisions.

- **Customer Voice**. [Dynamics 365 Customer Voice](/dynamics365/customer-voice/about) is an enterprise feedback management application. This application is used to get patient feedback after a recent emergency hospital visit. This feedback can provide insights into the management of ED processes. The survey results are stored in Dataverse for use by the hospital admin for process improvements.

- **Unstructured data**. This block in the architecture is used to represent unstructured binary data such as X-ray results. This data may be stored in the existing EHR systems. It is ingested by Azure Data Lake for use by Azure Synapse.

- **Structured data**. This block represents any structured data not typically considered part of EMR/EHR or PAS systems, that may be required to create insights for the hospital management. For example, the financial records of the healthcare organization.

## Alternatives

The [alternatives listed in the Virtual Visits solution](./virtual-health-mch.yml#alternatives) are applicable to this architecture as well.

- The Dynamics 365 and Power BI applications used in this architecture are tightly integrated with Dataverse as their data source. If these are replaced by third-party applications, such as built-in EHR tools for patient monitoring and emergency department triages, they can interact with Dataverse using its RESTful [API interface](/powerapps/developer/data-platform/work-with-data). Dataverse is a convenient data source for aggregated data and is used by multiple components such as Power BI, Power Automate, Synapse Analytics, Patient Portal, Teams, and so on.

- Components shown in the above diagram without the blue outlines, will need to be created or replaced by available tools, as per the needs of the healthcare organization.

## Security considerations

The security considerations for any architecture involving Microsoft Cloud for Healthcare would be similar. Refer to the [security considerations discussed in the Virtual Visits solution](./virtual-health-mch.yml#security-considerations).

## Pricing

Pricing information for this architecture is similar to the [pricing discussed in the Virtual Visits solution](./virtual-health-mch.yml#pricing).

## Deploy the solution

For deploying this solution, go through steps one through four of [the Virtual Visits solution deployment](./virtual-health-mch.yml#deploy-the-solution).

The following are the additional components created specifically for this solution. You might choose to create similar applications, or use tools provided by the EHR system in use.

1. Patient Monitoring Queue

1. ED Queue

1. Power BI reports and visualizations

1. Power Automate notifications for device thresholds and diagnostic test availability

1. Machine learning algorithms such as the machine-generated diagnostic findings

1. Social Determinants and Satisfaction Survey apps

## Next steps

- Learn more about the Microsoft Cloud for Healthcare at [What is Microsoft Cloud for Healthcare?](/industry/healthcare/overview)

- Learn more about Azure for healthcare offerings at [Azure for Healthcare—Healthcare Solutions](https://azure.microsoft.com/industries/healthcare/).

## Related resources

- [Questionnaire to detect the socioeconomic conditions of patients](https://icd.who.int/browse10/2016/en#/Z55-Z65)
