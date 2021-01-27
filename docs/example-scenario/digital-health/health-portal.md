---
title: Consumer Health Portal
titleSuffix: Azure Example Workloads
description: <Article Description>
author: matthansen0
ms.date: <publish or update date - mm/dd/yyyy>
ms.service = architecture-center
ms.topic = conceptual
ms.subservice = example-scenario
---

# Consumer Health Portal on Azure

Across sub-verticals in the Health and Life Sciences Industry organizations are adopting a Digital Health Strategy. While not the only component, one of the core pillars to Digital Health is a Consumer Health Portal. Whether its use is for tracking progress and statistics from a wearable device, engaging with a Medical Provider, or even tracking healthy eating habbits, the Consumer Health Portal is a neccessary component to these types of Digital Health models. This architecture is designed to prescribe the core components of such a portal, aligning with the pillars of the Azure Well Architected Framework, and allowing for potential small modifications to meet your particular needs. 



## Potential use cases

- Tracking statistics of a wearable device.
- Gaining access to Medical Records and engaging with a Medical Provider.
- Entering times and doses of Medications which can be used for refill data or simply self-tracking of Medications.
- Interacting with a Healthy Eating Coach for weight loss or Diabetes.


## Architecture

<img src="images\Consumer_Health_Portal_1.0.png" width="75%"/>

In this solution, the we leverage the global footprint of Azure Front Door and edge security features of Azure WAF to handle the data inbound to be authenticated, and routed by Azure APIM to either the front-end interface for the users on the App Service or various APIs hosted in Azure Functions. 

The primary backend data service in use is Azure Cosmos DB, the multi-model abilities of Cosmos in addition to it's scalability and security allow flexibility for any type of Consumer Health Portal. Any data that isn't in a record format will be stored in Azure Blob Storage as an object, this would include data such as Medical Images, photos taken by the consumer, uploaded documents, archive data, etc. Using Blob storage allows for affordable storage of large volumes of unstructured data, which could potentially impact cost and peformance of Cosmos DB.


### Components

- [Azure HIPPA HITRUST 9.2 blueprint](https://docs.microsoft.com/en-us/azure/governance/blueprints/samples/hipaa-hitrust-9-2) is an [Azure Blueprint](https://docs.microsoft.com/en-us/azure/governance/blueprints/) that uses [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) to help assess HIPPA HITRUST 9.2 controls and deploy a core set of policies for Azure workloads. While this does not give full compliance coverage for HIPPA HITRUST, it is a great place to start and add additional controls where applicable and neccessary. Compliance with the policy initatives can also be visualized here, and within Azure Defender. 


- [Azure Front Door](https://azure.microsoft.com/en-us/services/frontdoor/) is used to manage at-scale edge traffic, and to increase performance for end users by presenting an endpoint at Microsoft points of presence all around the world. This is a cloud-native technology which doesn't require any licensing and is only pay for what you use. In this workload scenerio, Azure Front Door will serve as the ingress point for all traffic in our Consumer Health Portal.
  
- [Azure Web Application Firewall](https://azure.microsoft.com/en-us/services/web-application-firewall/) protects applications from common web-based attacks such as OWASP Vulnerabilities, SQL Injections Cross-Site Scripting, and others. This is a cloud-native technology which doesn't require any licensing and is only pay for what you use. 
  
- [Azure API Management](https://azure.microsoft.com/en-us/services/api-management/) aids in the publishing, routing, securing, loggina and analytics of APIs. Whether the API is only being used by the end-user or integrating with a third-party for external interoperability, API management allows for flexibility in how APIs are extended and presented. 
  
- [Azure App Service](https://azure.microsoft.com/en-us/services/app-service/) is a service used to host HTTP-based web services. It supports a wide array of languages, can run on Linux or Windows, fully integrates with CI/CD pipelines, and can even run container workloads as a [PaaS](https://azure.microsoft.com/en-us/overview/what-is-paas/) offering. App Service allows for both scale-up, as well as scale-out, in addition to having native integration with identity, security and logging services in Azure which allow it to meet the scale needs of the Consumer Health Portal while maintaining compliance. In this workload scenario, this will host the front-end web portal. 
  
- [Azure Function Apps](https://azure.microsoft.com/en-us/services/functions/) is a serverless platform solution on Azure that allows for strong flexibility in writing code that can act as compute-on-demand without having to maintain any of the underlying systems. In this workload scenario Azure Functions will host any APIs, as well as any work that needs to be done asyncronously such as running periodic jobs to compute statistics over a certain period of time.
   
- [Azure Cosmos DB](https://azure.microsoft.com/en-us/services/cosmos-db/) is a fully managed, multi-model, NoSQL database offering that offers single-digit response times, garuntees performance at any scale. Each user in the Consumer Health system will have only data related to themselves, which is why it makes sense to use a NoSQL data structure. Cosmos allows for nearly limitless scale, multi-region read and write. With the drastic growth of the amount of data collected by these types of Consumer Health Systems, Cosmos will allow for security, speed and scale appropriately whether there are 100 or 1,000,000 active users. 

- [Azure Key Vault](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) is an Azure native service used for securly storing and accessing secrets, keys and certificates. Key Vault allows for HSM-backed security, and audited access through Azure Active Directory integrated role-based access controls. Applications should never have keys or secrets locally, and in this solution all secrets like API Keys, passwords, cryptographic keys, and certificates should be stored in Azure Key Vault.
  
- [Azure AD B2C](https://azure.microsoft.com/en-us/services/active-directory/external-identities/b2c/) provides business-to-consumer identity as a service at massive scale, the cost for which scales along with your active user count. In consumer-facing applications like this solution, many times users will not want to create a new account and can instead can bring their own identity which can be anything from a Social ID, to an email account or any SAML provider identity service. This allows for a an easier onboarding experience of the user, and relieves the solution provider from hosting and maintaining the user identities and rather just reference them. 
 
- [Azure Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-analytics-overview), an Azure Monitor Logs tool, can be used for diagnostic or otherwise logging information and query this data to sort, filter, or visualize them. This service is priced by consumption, and is perfect for hosting diagnostic and usage logs from all of the services in this solution.
  
- [Azure Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview), another feature of Azure Monitor, is the native Application Performance Management (APM) service in Azure. It can be easily integrated into the front-end App Service, and into all of the Azure Functions code to allow for live monitoring the applications. Application Insights easily allows for detection of performance and usability anomalies and faults directly generated from the applications themselves, and not just from the compute platform hosting them.

- [Office 365 Email](https://docs.microsoft.com/en-us/microsoft-365/enterprise/azure-integration) is an industry-leading service used for email and communications. Many organizations have already invested in the use of this service, in this solution it can be used for sending out confirmation emails or any other emails related to the Consumer Health Portal. 
  
- [Azure Notification Hub](https://azure.microsoft.com/en-us/services/notification-hubs/) is a a simple and scalable push notification engine service that enables the ability to send notifications to any mobile platform. If the version of a Consumer Health portal in question leverages a Mobile App like most do, integrating with Azure Notification Hub allows for a cost-effective way to push notifications to users with the app installed. In this workload example this could be things like reminders for appointments, to enter information, if devices aren't connecting, reaching certain goals, etc.  

- [Azure Defender](https://azure.microsoft.com/en-us/services/security-center/) is the core of security monitoring and posture management for this entire cloud-native solution. Azure Defender integrates with almost all major services on the Azure Platform and provides things like security alerts, anomily detection, best practice reccomendations, regulatory compliance scores, and threat detection. In addition to HIPPA/HITRUST compliance monitoring, and overall Azure Security best practice monitoring, this solution will be using the following:
  -  [Azure Defender for App Service](https://docs.microsoft.com/en-us/azure/security-center/defender-for-app-service-introduction)
  -   [Azure Defender for Storage](https://docs.microsoft.com/en-us/azure/security-center/defender-for-storage-introduction)
  -   [Azure Defender for KeyVault](https://docs.microsoft.com/en-us/azure/security-center/defender-for-key-vault-introduction)
  -   [Azure Defender for Resource Manager (Preview)](https://docs.microsoft.com/en-us/azure/security-center/defender-for-resource-manager-introduction)
  -   [Azure Defender for DNS](https://docs.microsoft.com/en-us/azure/security-center/defender-for-dns-introduction)
  -   [Threat Protections for Azure WAF](https://docs.microsoft.com/en-us/azure/security-center/other-threat-protections#threat-protection-for-other-microsoft-services-)
  -   [Threat Protections for Azure Cosmos DB (Preview)](https://docs.microsoft.com/en-us/azure/security-center/other-threat-protections#threat-protection-for-azure-cosmos-db-preview)


### Alternatives

- [SendGrid for Email](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/SendGrid.SendGrid?tab=Overview)
An alternitive solution for email notifications could be the use of Twillo's SendGrid. SendGrid is a partner which has direct marketplace integration in Azure and is a very useful service for email notifications in your applications. In many cases, customers already have an Office 365 subscription and if they plan on sending a large number of emails, using Office 365 integration could be a more cost effective solution. If your application is sending very few emails. 

- [Azure API for FHIR](https://azure.microsoft.com/en-us/services/azure-api-for-fhir/) for Medical Records interoperability using HL7 or FHIR communication standards. If your application needs to recieve or transmit Medical Records from other systems, for instance if this were a portal for Medical Provider.

- [Azure IoT Hub](https://azure.microsoft.com/en-us/services/iot-hub/) to ingest device data. In the case where this portal services as a front-end for a solution which collects data from a wearable or otherwise medical device, IoT Hub should be used to ingest this data. Similar to the "INGEST" process of the [Remote Patient Monitoring Solutions](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/remote-patient-monitoring) architecture. 



## Considerations

This solution is currently designed as a single-region deployment. In the case where requirements dictate it be multi-region for reasons of high-availability, disaster recovery, or even proximity, the following changes would be made in a [Paired Azure Region](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions).


- Cosmos DB should be extended to leverage a [multi-region configuration](https://docs.microsoft.com/en-us/azure/cosmos-db/high-availability).

- Azure API Management could be[deployed using CI/CD](https://docs.microsoft.com/en-us/azure/api-management/devops-api-development-templates) into a secondary region, but you can also leverage [API Managment's Multi-Region Deployment capability](https://docs.microsoft.com/en-us/azure/cosmos-db/high-availability). 

- Azure App Service and Functions will need to be deployed seperately to additional regions, the configuration for doing so can be done within your [CI/CD pipeline](https://azure.microsoft.com/en-in/solutions/architecture/azure-devops-continuous-integration-and-continuous-deployment-for-azure-web-apps/) by creating a paralell deployment. Additional you can reference this [Highly available multi-region web application](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/multi-region) reference architecture. 

- Depending on the requirement for RTO (recovery time objective), Azure Blob Storage could either be configured as Geo-redundant storage (GRS) or Read-access Geo-Redundnant (RA-GRS) storage to allow reads directly from the alternate region. To read more, please refernece the [Azure Storage Redundancy](https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy) documentation. 

- Azure Key Vault has multiple layers of [availability and redundancy](https://docs.microsoft.com/en-us/azure/key-vault/general/disaster-recovery-guidance) built-in to the service.



### Security Best Practices

For best practices on security for each of the services used in this solution, please reference the documentation below.

- [Security Practices for Azure Front Door](https://docs.microsoft.com/en-us/azure/frontdoor/security-baseline)
- [Security Practices for Azure API Management](https://docs.microsoft.com/en-us/azure/api-management/security-baseline)
- [Security Practices for Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/overview-security)
- [Security Practices for Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/security-concepts)
- [Security Practices for Azure Blob Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/security-recommendations)
- [Security Practices for Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/database-security)
- [Security Practices for Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/general/security-overview)
- [Security Practices for Azure AD B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/threat-management)
- [Security Practices for Azure Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-security)
- [Security Practices for Azure Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/data-retention-privacy#how-secure-is-my-data)
- [Security Practices for Azure Notification Hub](https://docs.microsoft.com/en-us/azure/notification-hubs/notification-hubs-push-notification-security)


## Deploy this scenario

> (Optional, but greatly encouraged)
>
> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Pricing

Pricing for this architecture is largely variable based on the tiers of services you end up using, the capacity, throughput, types of queries being done on the data, number of users, and business continuity and disaster recovery and can start anywhere from around $2,500/mo and scale from there.

To get started, you can view this Azure Calculator Generic Estimate [here](https://azure.com/e/ff314a92d6f947049b45c117695c3cd2).

- [Azure API Management Consumption Tier](https://azure.microsoft.com/en-us/pricing/details/api-management/): Depending on the scale of your workload, and requirements for enterprise functionality, using the consumption tier of Azure API Manangement could save costs. 



## Next steps

> Where should I go next if I want to start building this?
> Are there any reference architectures that help me build this?

## Related resources

> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful?
> Are there product documents that go into more detail on specific technologies not already linked

<!-- links -->

- [HIPPA and HITRUST Compliant Health Data AI](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai)