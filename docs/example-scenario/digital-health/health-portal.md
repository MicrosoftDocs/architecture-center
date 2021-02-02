---
title: Consumer Health Portal
titleSuffix: Azure Example Workloads
description: Describes an architecture for a consumer health portal.
author: matthansen0
ms.date: 02/01/2021
ms.service: architecture-center
ms.topic: conceptual
ms.subservice: example-scenario
ms.category:
    - fcp
---

# Consumer Health Portal on Azure

Throughout the health and life sciences industry, organizations are adopting a *digital health* strategy. While not the only component, one of the core pillars to digital health is a *consumer health portal*. Whether its use is for tracking progress and statistics from a wearable device, engaging with a medical provider, or even tracking healthy eating habits, the consumer health portal is a necessary component in various digital health models. This architecture is designed to prescribe the core components of such a portal, that aligns with the pillars of the [Azure Well Architected Framework](https://docs.microsoft.com/azure/architecture/framework/). You may choose to customize this architecture to meet your particular needs.

## Potential use cases

- Tracking statistics of a wearable device.
- Gaining access to medical records and engaging with a medical provider.
- Entering times and doses of medications which can be used for refill data or simply self-tracking of medications.
- Interacting with a healthy eating coach for weight loss or diabetes.

## Architecture

![Consumer health portal architecture](/images/Consumer_Health_Portal_1.0.png)

In this solution, we leverage the global footprint of Azure Front Door and edge security features of Azure Web Application Firewall (WAF) to authenticate the inbound data. The authenticated data is then routed by Azure API Management (APIM) to either the front-end interface for the users on the Azure App Service, or APIs hosted in Azure Functions.

The primary backend data service used is Azure Cosmos DB. The multi-model abilities of Cosmos DB, in addition to its scalability and security, allow flexibility for any type of consumer health portal. Any data that is not in a record format is stored in Azure Blob Storage as an object. This could include data such as, medical images, photos taken by the consumer, uploaded documents, archived data, and so on. Blob storage allows you to affordable store large volumes of unstructured data, potentially impacting cost and performance of Cosmos DB (**TBD**: How so? Does it lower?).


### Components

- [Azure HIPPA HITRUST 9.2 blueprint](https://docs.microsoft.com/azure/governance/blueprints/samples/hipaa-hitrust-9-2) is an [Azure blueprint](https://docs.microsoft.com/azure/governance/blueprints/) that uses [Azure Policy](https://docs.microsoft.com/azure/governance/policy/overview). It helps assess HIPPA HITRUST 9.2 controls and deploy a core set of policies for Azure workloads. While this does not give full compliance coverage for HIPPA HITRUST, it is a great place to start and add additional controls where applicable and necessary. Compliance with the policy initiatives can also be visualized in this blueprint as well as in Azure Defender.

- [Azure Front Door](https://azure.microsoft.com/services/frontdoor/) is used to manage at-scale edge traffic, and to increase performance for end-users by presenting an endpoint at Microsoft points of presence(**TBD**: Could we say this instead?: presenting endpoints all around the world.) all around the world. This is a cloud-native technology which doesn't require any licensing; you pay for only what you use. In this workload scenario, Azure Front Door serves as the ingress point for all traffic to the consumer health portal.
  
- [Azure Web Application Firewall](https://azure.microsoft.com/services/web-application-firewall/) protects applications from common web-based attacks such as OWASP vulnerabilities, SQL injections, cross-site scripting, and others. This is a cloud-native technology which doesn't require any licensing and is pay-as-you-use.
  
- [Azure API Management](https://azure.microsoft.com/services/api-management/) aids in the publishing, routing, securing, logging and analytics of APIs. Whether the API is only being used by the end-user or integrated with a third-party for external interoperability, API management allows for flexibility in how APIs are extended and presented.
  
- [Azure App Service](https://azure.microsoft.com/services/app-service/) is a service used to host HTTP-based web services. It supports a wide array of languages, can run on Linux or Windows, fully integrates with CI/CD pipelines, and can even run container workloads as a [PaaS](https://azure.microsoft.com/overview/what-is-paas/) offering. App Service allows for both scale-up, as well as scale-out, in addition to having native integration with identity, security, and logging services in Azure. It is able to meet the scaling needs of the consumer health portal while maintaining compliance. In this workload scenario, it hosts the front-end web portal.
  
- [Azure Function Apps](https://azure.microsoft.com/services/functions/) is a serverless platform solution on Azure that allows for strong flexibility in writing code that can act as compute-on-demand without having to maintain any of the underlying systems. In this workload scenario, Azure Functions can host any APIs, as well as any work that needs to be done asynchronously, such as running periodic jobs and computing statistics over a certain period of time.
   
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) is a fully-managed, multi-model, NoSQL database offering that offers single-digit response times, and guarantees performance at any scale. Each user in the consumer health system will have only data related to themselves, which is why it makes sense to use a NoSQL data structure. Cosmos DB allows for nearly limitless scale, as well as multi-region read and write. With the drastic growth of the amount of data collected by these types of consumer health systems, Cosmos DB will allow for security, speed and scale appropriately, regardless of whether there are 100 or 1,000,000 active users.

- [Azure Key Vault](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview) is an Azure native service used for securely storing and accessing secrets, keys, and certificates. Key Vault allows for HSM-backed security, and audited access through Azure Active Directory integrated role-based access controls. Applications should never have keys or secrets locally. In this solution, all secrets such as API Keys, passwords, cryptographic keys, and certificates should be stored in Azure Key Vault.
  
- [Azure AD B2C](https://azure.microsoft.com/services/active-directory/external-identities/b2c/) provides business-to-consumer identity-as-a-service at massive scale, the cost for which scales along with your active user count. In consumer-facing applications like this solution, instead of creating a new account, users may want to bring their own identity. It can be anything from a social ID, to an email account, or any SAML provider identity service. This allows for an easier onboarding experience for the user. The solution provider does not need to host and maintain the user identities, but instead just reference them. 
 
- [Azure Log Analytics](https://docs.microsoft.com/azure/azure-monitor/log-query/log-analytics-overview), an Azure Monitor Logs tool, can be used for diagnostic or logging information, and query this data to sort, filter, or visualize them. This service is priced by consumption, and is perfect for hosting diagnostic and usage logs from all of the services in this solution.
  
- [Azure Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview), another feature of Azure Monitor, is the native Application Performance Management (APM) service in Azure. It can be easily integrated into the front-end App Service, and into all of the Azure Functions code to enable live monitoring of the applications. Application Insights easily allows for detection of performance and usability anomalies and faults directly generated from the applications themselves, and not just from the compute platform hosting them.

- [Office 365 Email](https://docs.microsoft.com/microsoft-365/enterprise/azure-integration) is an industry-leading service used for email and communications. Many organizations have already invested in the use of this service. In this solution it can be used for sending out confirmation emails or any other emails related to the consumer health portal. 
  
- [Azure Notification Hub](https://azure.microsoft.com/services/notification-hubs/) is a simple and scalable push notification engine service that enables the ability to send notifications to any mobile platform. If the consumer health portal leverages a mobile app, integrating with Azure Notification Hub allows for a cost-effective way to push notifications to users with the app installed. In this workload example, notifications can be sent to remind users of their appointments, to enter information for disconnected devices, to reach certain health goals, and so on.  

- [Azure Defender](https://azure.microsoft.com/services/security-center/) is the core of security monitoring and posture management for this entire cloud-native solution. Azure Defender integrates with almost all major services on the Azure platform. Its capabilities include security alerts, anomaly detection, best practice reccomendations, regulatory compliance scores, and threat detection. In addition to HIPPA/HITRUST compliance monitoring, and overall Azure Security best practice monitoring, this solution uses the following:
  -  [Azure Defender for App Service](https://docs.microsoft.com/azure/security-center/defender-for-app-service-introduction)
  -   [Azure Defender for Storage](https://docs.microsoft.com/azure/security-center/defender-for-storage-introduction)
  -   [Azure Defender for KeyVault](https://docs.microsoft.com/azure/security-center/defender-for-key-vault-introduction)
  -   [Azure Defender for Resource Manager (Preview)](https://docs.microsoft.com/azure/security-center/defender-for-resource-manager-introduction)
  -   [Azure Defender for DNS](https://docs.microsoft.com/azure/security-center/defender-for-dns-introduction)
  -   [Threat Protections for Azure WAF](https://docs.microsoft.com/azure/security-center/other-threat-protections#threat-protection-for-other-microsoft-services-)
  -   [Threat Protections for Azure Cosmos DB (Preview)](https://docs.microsoft.com/azure/security-center/other-threat-protections#threat-protection-for-azure-cosmos-db-preview)


### Alternatives

- [SendGrid for Email](https://azuremarketplace.microsoft.com/marketplace/apps/SendGrid.SendGrid?tab=Overview) - 
Twillo's SendGrid may be used as an alternative for email notifications. SendGrid has direct marketplace integration in Azure. However, if customers already have an Office 365 subscription and if they plan on sending a large number of emails, using Office 365 integration could be a more cost effective solution. If your application is sending very few emails (**TBD** incomplete statement?).

- [Azure API for FHIR](https://azure.microsoft.com/services/azure-api-for-fhir/) for interoperability of medical records, using HL7 or FHIR communication standards. If your application needs to receive or transmit medical records from other systems, for instance if this were a portal for medical providers (**TBD**: incomplete statement).

- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) to ingest device data. If the portal is the front-end for a solution which collects data from a wearable or any other medical device, IoT Hub should be used to ingest this data. For more information, read the "INGEST" process of the [Remote Patient Monitoring Solutions](https://docs.microsoft.com/azure/architecture/solution-ideas/articles/remote-patient-monitoring) architecture. 



## Availability considerations

This solution is currently designed as a single-region deployment. If your scenario requires a multi-region deployment for high-availability, disaster recovery, or even proximity, you may need a [Paired Azure Region](https://docs.microsoft.com/azure/best-practices-availability-paired-regions) with the following configurations.

- Cosmos DB should be extended to leverage a [multi-region configuration](https://docs.microsoft.com/azure/cosmos-db/high-availability).

- Azure API Management [deployed using CI/CD](https://docs.microsoft.com/azure/api-management/devops-api-development-templates) into a secondary region. You may also leverage [API Managment's Multi-Region Deployment capability](https://docs.microsoft.com/azure/cosmos-db/high-availability). 

- Azure App Service and Functions will need to be deployed seperately to additional regions. This can be done within your [CI/CD pipeline](https://azure.microsoft.com/en-in/solutions/architecture/azure-devops-continuous-integration-and-continuous-deployment-for-azure-web-apps/) by creating a parallel deployment. Additionally, you can reference this [Highly available multi-region web application](https://docs.microsoft.com/azure/architecture/reference-architectures/app-service-web-app/multi-region) reference architecture. 

- Depending on the requirement for RTO (recovery time objective), Azure Blob Storage could either be configured as Geo-redundant storage (GRS) or Read-access Geo-Redundnant (RA-GRS) storage to allow reads directly from the alternate region. To read more, please refernece the [Azure Storage Redundancy](https://docs.microsoft.com/azure/storage/common/storage-redundancy) documentation. 

- Azure Key Vault has multiple layers of [availability and redundancy](https://docs.microsoft.com/azure/key-vault/general/disaster-recovery-guidance) built-in to the service.



### Security considerations

(**TBD**: are there any security considerations specific to this architecture?)

For best practices on security for each of the services used in this solution, please reference the documentation below.

- [Security Practices for Azure Front Door](https://docs.microsoft.com/azure/frontdoor/security-baseline)
- [Security Practices for Azure API Management](https://docs.microsoft.com/azure/api-management/security-baseline)
- [Security Practices for Azure App Service](https://docs.microsoft.com/azure/app-service/overview-security)
- [Security Practices for Azure Functions](https://docs.microsoft.com/azure/azure-functions/security-concepts)
- [Security Practices for Azure Blob Storage](https://docs.microsoft.com/azure/storage/blobs/security-recommendations)
- [Security Practices for Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/database-security)
- [Security Practices for Azure Key Vault](https://docs.microsoft.com/azure/key-vault/general/security-overview)
- [Security Practices for Azure AD B2C](https://docs.microsoft.com/azure/active-directory-b2c/threat-management)
- [Security Practices for Azure Log Analytics](https://docs.microsoft.com/azure/azure-monitor/platform/data-security)
- [Security Practices for Azure Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/data-retention-privacy#how-secure-is-my-data)
- [Security Practices for Azure Notification Hub](https://docs.microsoft.com/azure/notification-hubs/notification-hubs-push-notification-security)


## Pricing

Pricing for this architecture is largely variable based on the tiers of services you end up using, the capacity, throughput, types of queries being done on the data, number of users, and business continuity and disaster recovery. It can start anywhere from around $2,500/mo and scale from there.

To get started, you can view the Azure Calculator Generic Estimate [here](https://azure.com/e/ff314a92d6f947049b45c117695c3cd2).

[Azure API Management Consumption Tier](https://azure.microsoft.com/pricing/details/api-management/): Depending on the scale of your workload, and requirements for enterprise functionality, using the consumption tier of Azure API Manangement could save costs. 


## Next steps

(**TBD**) 

> Where should I go next if I want to start building this?
> Are there any reference architectures that help me build this?

## Related resources

<!-- links -->

- [HIPPA and HITRUST Compliant Health Data AI](https://docs.microsoft.com/azure/architecture/solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai)