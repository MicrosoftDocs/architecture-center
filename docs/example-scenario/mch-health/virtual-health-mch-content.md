
In the current COVID-19 (coronavirus) pandemic, most patients might prefer to visit their medical providers virtually rather than in-person, whenever possible. Improving clinical and operational insights in healthcare becomes extremely important in such a virtual world. This includes connecting data from across systems, creating insights to predict risk and help improve patient care, quality assurance, and operational efficiencies. 

This article discusses a potential solution for scheduling and following up on virtual visits between patients and providers. The basis for this solution is the [Microsoft Cloud for Healthcare](https://docs.microsoft.com/industry/healthcare/overview).

## Potential use cases

Although this solution can be a backbone for patient care in the pandemic situation, health care providers can easily apply it to the following non-pandemic scenarios:

- When follow-ups to in-person visit can be done virtually.

- When the patient needs to get non-emergency medical guidance while traveling.

## Architecture

![alt text](./images/virtual-health-solution.png)

TBD: _Download a [Visio file](https://arch-center.azureedge.net/architecture.vsdx) that contains this architecture diagram. This file must be uploaded to `https://arch-center.azureedge.net/`_

The blue lined boxes in the above architecture diagram are components of the Microsoft Cloud for Healthcare that are available to you when you [buy the license](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare?rtc=1). This licensed bundle allows easy access to all the services helpful for an integrated health solution, some of which are used in this architecture.

The data flows into the system through various external medical systems, such as scheduling, medical records and devices, and so on. MCH transposes this external data to the FHIR standard, using the Azure FHIR API (TBD more clarity needed here). It then gets stored into the Microsoft Dataverse, a Dynamics 365 powered database, in the standardized format of the [Common data model](https://www.healthit.gov/topic/scientific-initiatives/pcor/common-data-model-harmonization-cdm) (TBD: is this link appropriate here?), which provides an industry standard to represent medical data. MCH uses this standard to create all the entities and the relationships between them. All patient and care giver interactions happen using the CDM data stored in Dataverse.

An established patient can log in securely to the Patient Portal, which is a website hosted in the Power Apps Portals. Within this portal, the patient can talk to the *Intelligent Assistant*, a health bot which gathers their symptoms, and recommends calling to the practitioner if needed. If the patient chooses to connect to their medical provider, it connects to the Dataverse to get the data on providers available for virtual visit and their schedules. Once the patient selects a provider and a time, the bot presents the patient with their contact information, which is an *EMR/EHR* data stored in Dataverse. The patient can validate or change their information, and save the data through the bot.

To schedule an appointment, the health bot uses the [Microsoft Graph API](https://docs.microsoft.com/graph/overview) to connect to the Bookings App and books an appointment on the provider's calendar. An email is sent via Outlook to both the parties, with the appointment information. The patient is given instructions to log in to the Patient Portal for the patient intake process. The portal presents a form to confirm or change their contact, payment, and insurance information, and then sign a consent form for the virtual visit. Once they sign the consent, they are provided the Teams link for the appointment.

The provider first logs into Teams to check their appointment schedule and summary information with the help of the *Appointment Queue* application. They are then able to start the virtual visit on Teams for the scheduled appointment, and takes notes and adds them to the patient's records. This triggers a notification for the patient's assigned care manager, to review new notes.

When the care manager gets this patient care change notification, they can log in to Teams. There they are able to see the patients assigned to them, and view the notes, through the Care Management app, and make required changes to their care plan.

## Components

The architecture consists of the following components:

- **PAS**. Patient Administration Systems (PAS) are systems that automate the administrative paperwork in healthcare organisations, particularly hospitals. They have become one of the core components of the IT infrastructure of a hospital. A PAS records the patient's demographics, such as name, home address, date of birth, and so on, and detailed information of all patient contact with the hospital, both outpatient and inpatient. With the help of PAS, modern hospitals are able to report and schedule resources across the organization. PAS is a key source of scheduling data in this solution. Since this data is external and may be in a non-standard format, it is important to convert it into a format that is understood by all components of this solution.

- **EMR/EHR**. [Electronic Medical Records (EMR)](https://digital.ahrq.gov/key-topics/electronic-medical-record-systems) and [Electronic Health Records (EHR)](https://www.healthit.gov/faq/what-electronic-health-record-ehr) provide the digital records of a patient's medical and health information, including diagnoses, medications, immunizations, and so on. They can be scoped to a single practice office, such as EMRs, or designed to scope larger and travel with the patients to whichever facility they go, such as the EHRs. These are important external data sources in this solution, and may be unstructured non-standard format. As such, this data needs to be converted to a format used by the components in this solution.

- **Azure Healthcare Capabilities**. Data coming in from disparate sources such as the EMR, PAS, and the devices, could be structured or unstructured. The Azure Healthcare Capabilities of the MCH converts this data into the standardized format of the Common Data Model, to be usable across the various modules in the system. Azure Healthcare Capabilities module also provides security layer into the system, and all data coming into is encrypted.

- **Common Data Model**. With [Common Data Model](https://docs.microsoft.com/common-data-model/), Microsoft provides standardized metadata definition system, that is extensible and customizable for specific business needs. The Commond Data Model entities are available for subject areas such as, CRM, Healthcare, Talent, and so on. For details, read the [Common Data Model usage information](https://docs.microsoft.com/common-data-model/use). In addition to these entities, customers can pull in proprietary data by defining that entity table and the underlying fields in the Common Data Model, which can then seamlessly used with other entities throughout their solution.

- **Microsoft Dataverse**. (Formerly Common Data Service). [Dataverse](https://docs.microsoft.com/powerapps/maker/data-platform/data-platform-intro) is the repository for the data represented in the Common Data Model. As an example, it holds databases such as patient information, with details about their names, family information, medical conditions, medication history, and so on. This database is defined in the Common Data Model and stored in the Dataverse. It's a relational database that powers Dynamics 365.

- **Patient Portal**. This is a [Power Apps portal](https://docs.microsoft.com/dynamics365/industry/healthcare/use-patient-access#patient-portal), and a part of the MCH bundle. It lets the patient view their medical records, book appointments, chat with a HealthBot, and so on. This portal can be extended to support other data. MCH includes this portal as part of the bundle, allowing you to easily spin up a portal which can connect with entities in Dataverse. The portal can pull in patient information, care plans, appointments, and so on.

- **Intelligent Assistance**. This is a health bot, accessible to patients through the Patient Portal. It is an instance of the [Azure Health Bot Service](https://docs.microsoft.com/azure/health-bot/), containerized within Azure App Service. The App Service does the secured handshaking between (TBD) and the Health Bot Service (TBD: explain more clearly). This health bot is customizable, and can be programmed using the scenarios required by the customers.

- **Bookings App**. Bookings App is an Microsoft 365 service, that is included in the MCH package for convenience. It is not installed by default like Outlook, and needs to be selected to install. It facilitates scheduling of calendar events, and allows creating Teams meetings.

- **Microsoft Outlook**. The Bookings App is integrated with Microsoft Outlook. The Outlook service sends an email notification for the scheduled email to the patient (TBD) and the provider.

- **Microsoft Teams**. Although the users of the system can install Teams, it's also available as a web version for infrequent usage. It provides the front-end for the interactions between the patient, providers, and care management. It is included as part of the MCH bundle. For more information on Teams, read the [Microsoft Teams documentation](https://docs.microsoft.com/en-us/microsoftteams/).

- **Appointment Queue**. This tool generates an HTML page with data pulled out of the Dataverse, using the [Dynamics 365 Web API](https://docs.microsoft.com/dynamics365/customer-engagement/web-api/about?view=dynamics-ce-odata-9). It presents the provider with information about the appointments scheduled for the day, summary about each, and a link to access the patient information by loading the Care Management app through the Dynamics 365. Note that this tool was developed to support this scenario, and is not included in the MCH package. The data presented by this tool is typically pulled from PAS management and scheduling systems and EMR/EHR records. These systems may have tools integrated to present this data, which can be used in an actual deployment.

- **Care Management**. (Formerly D365 Patient Management). The Care Management tool is a part of the MCH bundle, and is a Power App deployed through Dynamics 365 from the Microsoft Solution Center. It uses the Common Data Model, that sits within the Microsoft Dataverse. It pulls in the patient data from the EMR/EHR system. A care center's solution might choose to use their own system for their functionality, depending on how they want to present this information.

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

## Related resources

- Learn more about the Microsoft Cloud for Healthcare at [What is Microsoft Cloud for Healthcare?](https://docs.microsoft.com/en-us/industry/healthcare/overview).

- Learn more about Azure for healthcare offerings at [Azure for Healthcare—Healthcare Solutions](https://azure.microsoft.com/en-us/industries/healthcare/).

## Next steps

TBD - the links provided for next steps don't seem like actual next steps, but rather resources to read before proceeding to actual next steps.
