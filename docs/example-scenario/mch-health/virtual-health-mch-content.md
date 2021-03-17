In the current COVID-19 (coronavirus) pandemic, a large number of patients might prefer to visit their medical providers virtually rather than in-person, whenever possible. Improving clinical and operational insights in healthcare becomes extremely important in such a virtual world. This includes connecting data from across systems, creating insights to predict risk and help improve patient care, quality assurance, and operational efficiencies.

This article discusses a potential solution for scheduling and following up on virtual visits between patients, providers, and care managers. The foundation for this solution is the [Microsoft Cloud for Healthcare](https://docs.microsoft.com/industry/healthcare/overview).

## Potential use cases

This solution is specifically targeted to provide virtual patient care in the current pandemic. However, health care providers can easily apply it to the following scenarios:

- Scheduling virtual follow-ups to in-person visits.

- Providing non-emergency medical guidance to patients while traveling.

## Architecture

![Architecture for virtual visit using Microsoft Cloud for Healthcare](./images/virtual-health-solution.png)

_Download a [Visio file](https://arch-center.azureedge.net/virtual-health-solution.vsdx) that contains this architecture diagram._

In this architecture diagram, the blue-lined boxes represent the components of the Microsoft Cloud for Healthcare. These components are available to you as part of [the licensed bundle](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare?rtc=1), which provides an easy access to services that are helpful to create an integrated healthcare solution.

The data flows into the system through various external medical systems, such as patient and provider schedules, medical records, wearable devices, and so on. Microsoft Cloud for Healthcare transposes this external data to the FHIR (or Fast Healthcare Interoperability Resources) standard, using the [Azure FHIR API](https://docs.microsoft.com/azure/healthcare-apis/fhir/overview). This transposed data is stored in the Microsoft Dataverse, which is a data store powered by the Power Apps Platform. This data is formatted to use entities and relationships between them, created using the [Common Data Model (CDM)](https://docs.microsoft.com/en-us/common-data-model/), an industry standard to represent medical data. All interactions between patient, provider, and the care manager happen using this CDM data stored in Dataverse.

An established patient can log in securely to the Patient Portal, a website hosted in the Power Apps Portals. In this portal, the patient can talk to an *Intelligent Assistant*. This is a health bot which gathers their symptoms, provides suggestions, and recommends calling to the practitioner, if needed. If the patient chooses to connect to their medical provider, the health bot gets the data on providers available for virtual visits and their schedules, from the Dataverse. Once the patient selects a provider and a time, the bot presents their contact information, obtained from the *EMR/EHR* data stored in Dataverse. The patient can validate or change this information, and save the data using the bot.

To schedule an appointment, the health bot connects to the Bookings App using the [Microsoft Graph API](https://docs.microsoft.com/graph/overview) and books an appointment on the provider's calendar. An email with the appointment information, is sent to both the parties using Microsoft Outlook. The patient is given instructions to log in to the Patient Portal for the intake process. This process involves confirming or changing their contact, payment, and insurance information, and then signing a consent form for the virtual visit. Once they sign the consent, they are provided the Microsoft Teams link for the appointment.

The provider logs into Teams to check their appointment schedule and summary information for each. Teams presents this information using the *Appointment Queue* application. The provider is then able to start the virtual visit on Teams for the scheduled appointment. During the call, the provider can take notes and add them to the patient's records.

A new note on the patient's medical records triggers a review notification for the care manager assigned to the patient. When the care manager receives this notification, they can log in to Teams, where they are able to see the patients assigned to them, and view the notes. Through the Care Management app, they can make required changes to the patient's care plan.

## Components

The architecture consists of the following components:

- **PAS**. Patient Administration Systems (PAS) are systems that automate the administrative paperwork in healthcare organisations, such as hospitals. They are the core components of the IT infrastructure of such an organization. A PAS records the patient's demographics, such as name, home address, date of birth, and so on. It also records detailed information of all contact the patient had with the hospital, both outpatient and inpatient. With the help of PAS, modern hospitals are able to report and schedule resources across the organization. PAS is a key source of scheduling data in this solution. Since this data is external and may be in a non-standard format, it is important to convert it into a format that is understood by all components of this solution.

- **EMR/EHR**. [Electronic Medical Records (EMR)](https://digital.ahrq.gov/key-topics/electronic-medical-record-systems) and [Electronic Health Records (EHR)](https://www.healthit.gov/faq/what-electronic-health-record-ehr) provide the digital records of a patient's medical and health information, including diagnoses, medications, immunizations, and so on. They can be scoped to a single practice office, such as EMRs, or designed to scope much larger, traveling with the patients to whichever facility they go, such as the EHRs. These are important external data sources in this solution, and may be unstructured non-standard format. As such, this data needs to be converted to a format that can be used by the components in this solution.

- **Azure Healthcare Capabilities**. Azure Healthcare Capabilities layer denotes the part of the Microsoft Cloud for Healthcare that lies with the Azure ecosystem. The services in this layer provide a secure interface between external data and internal components of this architecture. Data coming in from disparate sources such as the EMR, PAS, and the devices, could be structured or unstructured. The Azure Healthcare Capabilities layer converts this data into the standardized format of the Common Data Model. This data can then be used across the various modules in the system. Azure Healthcare Capabilities also provides a security layer into the system, such as encrypting all data coming into the system, maintaining appropriate access rights, and so on. For more information on this layer, see [Azure for healthcare](https://azure.microsoft.com/en-us/industries/healthcare/).

- **Common Data Model**. With [Common Data Model](https://docs.microsoft.com/common-data-model/), Microsoft provides standardized metadata definition system, that is extensible and customizable for specific business needs. CDM entities are available for subject areas such as, CRM, Healthcare, Talent, and so on. For details, read the [Common Data Model usage information](https://docs.microsoft.com/common-data-model/use). In addition to these entities, customers can pull in proprietary data by defining that entity table and the underlying fields in the Common Data Model, which can then seamlessly be used with other entities throughout their solution.

- **Microsoft Dataverse**. [Dataverse](https://docs.microsoft.com/powerapps/maker/data-platform/data-platform-intro), a relational database that powers Microsoft Dynamics 365, is the repository for the data represented in the Common Data Model. It holds databases for patient information, containing details about their names, family information, medical conditions, medication history, and so on. It also holds the information obtained from any wearable devices used and registered by the patients, as well as, scheduling and management data from the healthcare organization. This data is defined using the Common Data Model.

- **Patient Portal**. This is a [Power Apps portal](https://docs.microsoft.com/dynamics365/industry/healthcare/use-patient-access#patient-portal). It lets the patients view their medical records, book appointments, chat with a health bot, and so on. This portal can be extended to support other data. Microsoft Cloud for Healthcare includes this portal as part of the licensed bundle, allowing you to easily spin up a portal which can connect with entities in Dataverse. The portal can pull in patient information, care plans, appointments, and so on.

- **Intelligent Assistance**. This is a health bot, accessible to patients through the Patient Portal. It is an instance of the [Azure Health Bot Service](https://docs.microsoft.com/azure/health-bot/), hosted within Azure App Service. The App Service hosts the web page that embeds and facilitates loading of the [Azure Health Bot Service](https://docs.microsoft.com/azure/health-bot/integrations/embed). This health bot is customizable, and can be programmed using the scenarios required by the customers.

- **Bookings App**. Bookings App is an Microsoft 365 service, that is included in the MCH package for convenience. It is not installed by default like Outlook, and needs to be selected to install. It facilitates scheduling of calendar events, and allows creating Teams meetings.

- **Microsoft Outlook**. The Bookings App is integrated with Microsoft Outlook. The Bookings app generates and sends an email notification to the patient and the provider. The solution uses Outlook to open the emails, however it is replaceable by any other email client.

- **Microsoft Teams**. Although the users of the system can install Teams, it's also available as a web version for infrequent usage. It provides the front-end for the interactions between the patient, providers, and care management. It is included as part of the MCH bundle. For more information on Teams, read the [Microsoft Teams documentation](https://docs.microsoft.com/en-us/microsoftteams/).

- **Appointment Queue**. This tool generates an HTML page with data pulled out of the Dataverse, using the [Dynamics 365 Web API](https://docs.microsoft.com/dynamics365/customer-engagement/web-api/about?view=dynamics-ce-odata-9). It presents the provider with information about the appointments scheduled for the day, summary about each, and a link to access the patient information by loading the Care Management app through the Dynamics 365. Note that this tool was developed to support this scenario, and is not included in the MCH package. The data presented by this tool is typically pulled from PAS management and scheduling systems and EMR/EHR records. These systems may have tools integrated to present this data, which can be used in an actual deployment.

- **Care Management**. The Care Management tool is a part of the MCH bundle, and is a Power App deployed through Dynamics 365 from the Microsoft Solution Center. It uses the Common Data Model, that sits within the Microsoft Dataverse. It pulls in the patient data from the EMR/EHR system, and presents the aggregated data in the Teams view. A care center's solution might choose to use their own system for their functionality, depending on how they want to present this information.

- **Power BI Analytics**. This is a custom analytics tool created for this scenario, that generates information derived from the IoMT devices registered for the patients. It pulls in data such as heart rate, blood oxygen level, and so on. The Care Management app uses this data to provide additional information about the patient from their daily activities.

- **Connected devices**. These are *Internet of Medical Things (IoMT)* devices, which are smart devices for medical or healthcare use. Examples include wearables such as Apple Watch or Fitbit, medical or vital monitors, and so on. The patient can provision their devices through Azure, and choose to allow their health care management system to gather this IoMT data for use by their providers. The providers can gain additional insights from such devices, in near real time, and link anomalies such as an elevated heart rate for a period of time, with patient's symptoms.

- **Automation with Power Automate**. This is another custom tool, created to support this scenario. Since this is a virtual visit scenario, the provider might just be an on-call physician and not the patient's regular physician. This tools allows the provider's notes to trigger a Teams notification to the *care manager*. A care manager is the member of the medical team that works as the liaison between the primary care physician (PCP) and the patient, and takes care of long term care management. A notification sent to the care manager, indicating new notes added for the patient, enables them to review and make appropriate changes in the patient's care management immediately after the visit.

## Alternatives

Azure Healthcare Capabilities, Common Data Model interface, Microsoft Dataverse, and Microsoft Teams form the core components of this solution. Most other components of this system can be replaced by systems currently used by the healthcare facility:

- If the EHR system comes with built-ins such as, booking, scheduling, appointment queue, automated notifications, and so on, these built-ins can be used instead of the respective components in this solution.

- Bookings and Outlook scheduling and email notification could be swapped out by the systems used by the healthcare facility. These could be done via the EHR system, or a third-party application. The application should provide an API that the health bot can use to create and schedule appointments, alongwith the capability to create virtual meeting links.

- If the provider already has a patient portal implemented externally through their EMR/EHR system, they can use that instead of the MCH package. It is easy to integrate that with other components, for example, using an [iFrame](https://html.com/tags/iframe/) to communicate with the health bot. Components that support this flow can be created on the proprietary portal, such as the check-in form that the patient needs to sign before joining the Teams meeting.

## Security considerations

Since the system is built around patient data, basic security considerations for Personally Identifiable Information (PII) should be considered when developing this solution:

- Only the required data is flowing through the system at any given time. For example, pull in only that data from the EMR/EHR systems that are required to surface for the virtual visit scheduling and management. Review the established [HIPAA compliance rules](https://www.hhs.gov/hipaa/index.html) for where the patient data is stored, what is done with it, and who has access to it.

- Only authorized personnel should have access to patient data, and only to the data required for their role. At various points in the system, such as the Care Management and the analytics feeding into it, or the Appointment Queue, or the notification systems, care should be taken to authenticate and authorize personnel and limit their access to requried patient information.

- For modules interacting with the patients, such as health bot and bookings app, which take in, store, and use patient data. Proper access control and authentication at these modules ensures privacy concerns are addressed.

Because of the nature of PII data invovled, [security](https://docs.microsoft.com/en-us/industry/healthcare/security-overview) and [compliance](https://docs.microsoft.com/en-us/industry/healthcare/compliance-overview) form the basic tenets of the Microsoft Cloud for Healthcare package.

This example also relies on the security rules set by Dynamics 365 and Teams:

- [Dynamics 365 security](https://docs.microsoft.com/learn/modules/recognize-dynamics-365-security/)
- [Microsoft Teams security](https://docs.microsoft.com/microsoftteams/security-compliance-overview)

In addition, individual services packaged under the MCH bundle provide their own layer of security and compliance:

- [Power Platform compliance and data privacy](https://docs.microsoft.com/power-platform/admin/wp-compliance-data-privacy)
- [Dataverse security](https://docs.microsoft.com/power-platform/admin/wp-security)

For custom security controls, consider using [Azure Active Directory](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis) and [role-based access control](https://docs.microsoft.com/azure/role-based-access-control/best-practices).

When implementing this solution, keep in mind the [best practices and guidance for Azure security](https://docs.microsoft.com/azure/security/fundamentals/overview).

## Pricing

For pricing information on Microsoft Cloud for Healthcare, see [How to buy Microsoft Cloud for Healthcare?](https://docs.microsoft.com/en-us/industry/healthcare/buy). For components that are not part of this package, there may be additional costs involved:

- [Microsoft 365 pricing plans](https://www.microsoft.com/en-us/microsoft-365/compare-microsoft-365-enterprise-plans)

- [Microsoft Dynamics 365 pricing](https://dynamics.microsoft.com/en-us/pricing/)

## Deploy the solution

The solution needs to be deployed in stages:

- Certain products need to be installed as the prerequisites for Microsoft Cloud for Healthcare. See the detailed list on this [article on Licensing requirements](https://docs.microsoft.com/en-us/dynamics365/industry/healthcare/licensing).

- Microsoft Cloud for Healthcare can be deployed using instructions provided by the [Deploy Microsoft Cloud for Healthcare solutions powered by Dynamics 365](https://docs.microsoft.com/en-us/dynamics365/industry/healthcare/deploy).

- The Healthcare package provides basic components to jumpstart building the solution for virtual health, such as, Patient Portal, Teams, Bookings, and so on. The data that will be used to power these building blocks, will need to be customized as per the business needs.

- The components available in the Healthcare package and its prerequisites, need to be customized to support the business needs:

  - Power Automate flows need to be created to support the care manager notifications.
  - Power Apps Patient Portal needs to be configured and additional forms might need to be created for elements such as the check-in forms.
  - Health Bot service needs to be connected to the Dataverse database, and customized for its communication with the patients.

- The additional components that were specifically created for this solution, are not available for production-grade usage. The healthcare facility will need to create its own version of these applications:
  
  - Appointment Queue
  - Reporting application using Power BI

## Next steps

- Learn more about the Microsoft Cloud for Healthcare at [What is Microsoft Cloud for Healthcare?](https://docs.microsoft.com/en-us/industry/healthcare/overview)

- Learn more about Azure for healthcare offerings at [Azure for Healthcare—Healthcare Solutions](https://azure.microsoft.com/en-us/industries/healthcare/).

## Related resources

- [FHIR standard for health care data exchange](https://www.hl7.org/fhir/index.html)

- [Difference between EMR and EHR](https://www.healthit.gov/buzz-blog/electronic-health-and-medical-records/emr-vs-ehr-difference)
