The healthcare industry has been traditionally been unable to effectively use the vast amount of data it creates. Majority of the medical data is unstructured and inaccessible for data driven decisions. When looking for insights, providers spend a considerable amount of time on data ingestion and unification. Healthcare organizations also face security and compliance pressures and risks of data breaches. Using [Microsoft Cloud for Healthcare](https://docs.microsoft.com/industry/healthcare/overview), you can build solutions to improve clinical and operational insights. This article discusses one such potential solution, and builds on the knowledge learned from [Virtual health on Microsoft Cloud for Healthcare](./virtual-health-mch.yml).

## Potential use cases

TBD

## Architecture

![Clinical insights using Microsoft Cloud for Healthcare](./images/clinical-insights-solution.png)

_Download a [Visio file](https://arch-center.azureedge.net/virtual-health-solution.vsdx) that contains this architecture diagram._

Similar to the Virtual Visit solution, the blue-lined boxes in this architecture diagram represent the Microsoft services that are either the underlying services or add-ons required for [Microsoft Cloud for Healthcare](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare?rtc=1), each of which must be licensed separately.

Similar to the previous solution, data flows into this architecture through external medical systems, such as patient and provider schedules, medical records, wearable devices, and so on, and then ingested using the [Azure API for FHIR](https://docs.microsoft.com/azure/healthcare-apis/fhir/overview). The data transposed to the FHIR (or Fast Healthcare Interoperability Resources) standard, is stored in the Microsoft Dataverse in the [Common Data Model (CDM)](https://docs.microsoft.com/common-data-model/) format and then consumed by the rest of the components in this solution. The CDM component is not shown in the architecture for simplicity.

This solution requires a large amount of data to be stored for reporting and analytics. Azure Data Lake serves this purpose during data ingestion. Data stored in Data Lake is analyzed using Azure Synapse, for use by the Machine Learning module and Power BI visualizations. (TBD: Difference between Dataverse and Data Lake? In the previous solution, did it need the data to be queried from external sources all the time? What was the role of Dataverse in that solution then?)

Continuing from the virtual visit flow, the care manager has the ability to review the patients current records through Teams, with the help of **Patient Monitoring Queue*, a custom Dynamics 365 web resource (TBD: how different is this from the Appointment Queue custom app or the Care Management MC4H app?). It aggregates patient data from multiple sources, and provides an easy access point into each patient's information. It also provides additional insight into each patient's risk level, in the form of an *index score*. Such a score is typically calculated by an EHR system, such as, [the Rothman Index](https://en.wikipedia.org/wiki/Rothman_Healthcare) (TBD?). With the help of this score, the care manager is able to deep dive into the most critical patients under their care, and get access to these patients' records, care plan, appointment information, and so on, using the Care Management application. Care Management is able to show insights into patient's daily lifestyle by pulling in IoMT device data such as heart rate, in near real-time from the underlying Dynamics 365 layers.







An established patient can log in securely to the Patient Portal, a website hosted in the Power Apps Portals. In this portal, the patient can talk to an *Intelligent Assistant*. This is an instance of the [Azure Health Bot service](https://docs.microsoft.com/azure/health-bot/) which gathers their symptoms, provides suggestions, and recommends calling to the practitioner, if needed. If the patient chooses to connect to their medical provider, the health bot instance gets the data on providers available for virtual visits and their schedules, from the Dataverse. Once the patient selects a provider and a time, the bot presents their contact information, obtained from the *EMR/EHR* data stored in Dataverse. The patient can validate or change this information, and save the data using the bot.

To schedule an appointment, the health bot instance connects to the Bookings App using the [Microsoft Graph API](https://docs.microsoft.com/graph/overview) and books an appointment on the provider's calendar. An email with the appointment information, is sent to both the parties using Microsoft Outlook. The patient is given instructions to log in to the Patient Portal for the intake process. This process involves confirming or changing their contact, payment, and insurance information, and then signing a consent form for the virtual visit. Once they sign the consent, they are provided the Microsoft Teams link for the appointment.

The provider logs into Teams to check their appointment schedule and summary information for each. Teams presents this information using the *Appointment Queue* application. The provider is then able to start the virtual visit on Teams for the scheduled appointment. During the call, the provider can take notes and add them to the patient's records.

A new note on the patient's medical records triggers a review notification for the care manager assigned to the patient. When the care manager receives this notification, they can log in to Teams, where they are able to see the patients assigned to them, and view the notes. Through the Care Management app, they can make required changes to the patient's care plan.

## Components

The architecture consists of the following components:

- **PAS**. Patient Administration Systems (PAS) are systems that automate the administrative paperwork in healthcare organisations, such as hospitals. They are the core components of the IT infrastructure of such an organization. A PAS records the patient's demographics, such as name, home address, date of birth, and so on. It also records detailed information of all contact the patient had with the hospital, both outpatient and inpatient. With the help of PAS, modern hospitals are able to report and schedule resources across the organization. PAS is a key source of scheduling data in this solution. Since this data is external and may be in a non-standard format, it is important to convert it into a format that is understood by all components of this solution.

- **EMR/EHR**. [Electronic Medical Records (EMR)](https://digital.ahrq.gov/key-topics/electronic-medical-record-systems) and [Electronic Health Records (EHR)](https://www.healthit.gov/faq/what-electronic-health-record-ehr) provide the digital records of a patient's medical and health information, including diagnoses, medications, immunizations, and so on. They can be scoped to a single practice office, such as EMRs, or designed to scope much larger, traveling with the patients to whichever facility they go, such as the EHRs. These are important external data sources in this solution, and may be unstructured non-standard format. As such, this data needs to be converted to a format that can be used by the components in this solution.

- **Azure API for FHIR**. Azure is the first step in the process of bringing data into the Microsoft ecosystem and the Microsoft Cloud for Healthcare. This layer provides a secure interface between external data and internal components of this architecture. The Azure API for FHIR ingests the data coming from disparate sources such as EMR, PAS, devices, whether structured or unstructured, converts it into FHIR and persists in Azure. This data can then be used across the Microsoft Cloud for Healthcare for different services. The Azure API for FHIR is built with security and compliance in mind and specifically designed for PHI (Protected Health Information) data. For more information on this layer, see [Azure for healthcare](https://azure.microsoft.com/industries/healthcare/) and the [Azure API for FHIR](https://docs.microsoft.com/azure/healthcare-apis/fhir/overview).

- **Common Data Model**. With [Common Data Model](https://docs.microsoft.com/common-data-model/), Microsoft provides a standardized metadata definition system, that is extensible and customizable for specific business needs. CDM entities are available for subject areas such as, CRM, Healthcare, Talent, and so on. For details, read the [Common Data Model usage information](https://docs.microsoft.com/common-data-model/use). In addition to these entities, customers can pull in proprietary data by defining that entity table and the underlying fields in the Common Data Model, which can then seamlessly be used with other entities throughout their solution.

- **Microsoft Dataverse**. [Dataverse](https://docs.microsoft.com/powerapps/maker/data-platform/data-platform-intro), a relational database that powers Microsoft Dynamics 365, is the repository for the data represented in the Common Data Model. It holds databases for patient information, containing details about their names, family information, medical conditions, medication history, and so on. It also holds the information obtained from any wearable devices used and registered by the patients, as well as, scheduling and management data from the healthcare organization. This data is defined using the Common Data Model.

- **Patient Portal**. This [Power Apps portal](https://docs.microsoft.com/dynamics365/industry/healthcare/use-patient-access#patient-portal) lets patients view their medical records, book appointments, chat with the health bot instance, and so on. This portal can be extended to support other data. This portal is part of Microsoft Cloud for Healthcare, and allows you to easily spin up a portal which can connect with entities in Dataverse, pulling in data such as patient information, care plans, appointments, and so on.

- **Intelligent Assistance**. This is an instance of the [Azure Health Bot Service](https://docs.microsoft.com/azure/health-bot/), accessible to patients through the Patient Portal. This health bot instance is loaded within an Azure App Service website. It is customizable, and can be programmed using the scenarios required by the customers. For more information, read [Embed a health bot instance in your application](https://docs.microsoft.com/azure/health-bot/integrations/embed).

- **Bookings App**. Bookings App is a Microsoft 365 service, included in the Microsoft Cloud for Healthcare. It facilitates scheduling of calendar events, and allows creating Teams meetings.

- **Microsoft Outlook**. This solution uses Microsoft Outlook as the email client. The Bookings App that sends the email notification is integrated with Outlook. Alternatively, the healthcare provider's preferred email client may be used.

- **Microsoft Teams**. Microsoft Teams is a component of Microsoft Cloud for Healthcare, and provides the front-end for interactions between the patients, providers, and care managers. Users can use a locally installed version or the web version. For more information on Teams, read the [Microsoft Teams documentation](https://docs.microsoft.com/microsoftteams/).

- **Appointment Queue**. This tool generates an HTML page with data pulled out of the Dataverse, using the [Dynamics 365 Web API](https://docs.microsoft.com/dynamics365/customer-engagement/web-api/about?view=dynamics-ce-odata-9). It presents the provider with information about the appointments scheduled for the day and summary about each. It also provides a link to access the patient information through the Care Management application. Note that the Appointment Queue was developed to support this scenario, and is not a part of Microsoft Cloud for Healthcare. The data sources for this tool, are mainly the PAS systems and EMR/EHR records. If this systems have tools integrated to present this data, those tools may be a replacement for this component in an actual deployment.

- **Care Management**. The Care Management tool is a component of Microsoft Cloud for Healthcare. It is a Power Apps application deployed through Dynamics 365. It pulls in the EMR/EHR patient data stored in the Dataverse in CDM format, and presents an aggregated view in Teams. A care center's solution might choose to use their own system for their functionality, depending on how they want to present this information.

- **Power BI Analytics**. This is an analytics tool created for this scenario, and is not available with Microsoft Cloud for Healthcare. In this solution, it generates information derived from the patient's IoMT devices. This could be data such as heart rate, blood oxygen level, and so on. The Care Management app uses this data to present medical providers with additional insights about their patients based on their daily activities.

- **Connected devices**. These are *Internet of Medical Things (IoMT)* devices, which are smart devices for medical or healthcare use. Examples of IoMT devices include wearables such as Apple Watch or Fitbit, medical or vital monitors, and so on. Patients can provision their devices through Azure, and choose to allow their health care management system to gather this IoMT data for use by their providers. Providers can gain additional insights from such devices, in near real time, and link anomalies such as an elevated heart rate for a period of time, with patient's current symptoms.

- **Automation with Power Automate**. This is a custom tool created to support this scenario, and is not available with Microsoft Cloud for Healthcare. Since this is a virtual visit scenario, the provider might just be an on-call physician and not the patient's regular physician. This tools allows the provider's notes to trigger a Teams notification to the *care manager*. A care manager is the member of the medical team that works as the liaison between the primary care physician (PCP) and the patient, and takes care of long term care management. A notification sent to the care manager, indicating new notes added for the patient, enables them to review and make appropriate changes in the patient's care management after the visit.

## Alternatives

TBD

## Security considerations

The security considerations for any architecture involving Microsoft Cloud for Healthcare would be similar. Please refer to the [security considerations discussed in the Virtual Visits solution](./virtual-health-mch.yml).

## Pricing

Pricing information for this architecture is similar to [pricing discussed in the Virtual Visits solution](./virtual-health-mch.yml).

## Deploy the solution

The solution should be deployed in stages:

1. Certain products need to be installed as the prerequisites for Microsoft Cloud for Healthcare. See the detailed list on [this article on licensing requirements](https://docs.microsoft.com/dynamics365/industry/healthcare/licensing).

1. Microsoft Cloud for Healthcare can be deployed using instructions provided in the [Deploy Microsoft Cloud for Healthcare solutions powered by Dynamics 365](https://docs.microsoft.com/dynamics365/industry/healthcare/deploy).

1. Microsoft Cloud for Healthcare provides basic components to jumpstart building a virtual health solution, such as, Patient Portal, Teams, Bookings, and so on. The data that will be used to power these building blocks, will need to be customized as per the business needs.

1. The components available in Microsoft Cloud for Healthcare and its prerequisites, need to be customized to support the business needs:

    1. Power Automate flows need to be created to support the care manager notifications.

    1. Patient Portal needs to be configured. Additional forms might need to be created for elements such as the check-in/consent forms.

    1. Azure Health Bot service needs to be connected to the Dataverse database, and customized for its communication with patients.

1. The additional components that were specifically created for this solution, are not available for production-grade usage. The healthcare facility will need to create its own version of these applications:
  
    1. Appointment Queue

    1. Automated notifications using Power Automate

    1. Reporting application using Power BI

## Next steps

- Learn more about the Microsoft Cloud for Healthcare at [What is Microsoft Cloud for Healthcare?](https://docs.microsoft.com/industry/healthcare/overview)

- Learn more about Azure for healthcare offerings at [Azure for Healthcare—Healthcare Solutions](https://azure.microsoft.com/industries/healthcare/).

## Related resources

- [FHIR standard for health care data exchange](https://www.hl7.org/fhir/index.html)

- [Difference between EMR and EHR](https://www.healthit.gov/buzz-blog/electronic-health-and-medical-records/emr-vs-ehr-difference)

- [HIPAA compliance rules](https://www.hhs.gov/hipaa/index.html)
