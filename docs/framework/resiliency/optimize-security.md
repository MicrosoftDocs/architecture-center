---
title: Optimize for security
description: How to optimize for application security reliability in Azure
author: v-aangie
ms.date: 02/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Optimize for security

Security and reliability are different aspects of the general problem of protecting our customers.

https://www.microsoft.com/security/blog/2007/12/07/reliability-vs-security/

## Security & compliance

### Identity and access

The identity provider and associated dependencies should be highly available. It's important to confirm that the identity provider and its dependencies are designed in a way to provide a Service Level Agreement (SLA)/Service Level Objective (SLO) that aligns with application availability targets. Examples of an identity provider are Azure AD, AD, or ADFS; examples of its dependencies are DNS and network connectivity to the identity provider.

Role-based and resource-based authorization are common approaches to authorize users based on required permission scopes. To learn more, see [Role-based and resource-based authorization](https://docs.microsoft.com/azure/architecture/multitenant-identity/authorize).

The Azure Active Directory (Azure AD) SLA includes authentication, read, write, and administrative actions. In many cases, applications only require authentication and read access to Azure AD, which aligns with a much higher operational availability due to geographically distributed read replicas. (Azure AD Architecture)

Are authentication tokens cached and encrypted for sharing across web servers?

Application code should first try to get tokens silently from a cache before attempting to acquire a token from the identity provider, to optimise performance and maximize availability(Acquire and cache tokens)

Are Azure AD emergency access accounts and processes defined for recovering from identity failures?

The impact of no administrative access can be mitigated by creating two or more emergency access accounts(Emergency Access accounts in Azure AD)

### Security Center

Is [Azure Security Center](/azure/security-center/security-center-introduction) Standard tier enabled for all subscriptions and reporting to centralized workspaces? Also, is automatic provisioning enabled for all subscriptions? (Security Center Data Collection)

Is Azure Security Center's Secure Score being formally reviewed and improved on a regular basis? (Security Center Secure Score)

Are contact details set in security center to the appropriate email distribution list? (Security Center Contact Details)

### Network security

Are all external application endpoints secured?

External application endpoints should be protected against common attack vectors, such as Denial of Service (DoS) attacks like Slowloris, to prevent potential application downtime due to malicious intent. Azure native technologies such as Azure Firewall, Application Gateway/Azure Front Door WAF, and DDoS Protection Standard Plan can be used to achieve requisite protection(Azure DDoS Protection)

Is communication to Azure PaaS services secured using VNet Service Endpoints or Private Link?

Service Endpoints and Private Link can be leveraged to restrict access to PaaS endpoints from only authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability. Service Endpoints provide service level access to a PaaS service, while Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks (e.g. malicious admin scenarios)

If data exfiltration concerns exist for services where Private Link is not yet supported, is filtering via Azure Firewall or an NVA being used?

NVA solutions and Azure Firewall (for supported protocols) can be leveraged as a reverse proxy to restrict access to only authorized PaaS services for services where Private Link is not yet supported(Azure Firewall)

Are Network Security Groups (NSGs) being used?

If NSGs are being used to isolate and protect the application, the rule set should be reviewed to confirm that required services are not unintentionally blocked(Azure Platform Considerations for NSGs)

Are NSG flow logs being collected?

NSG flow logs should be captured and analyzed to monitor performance and security(Why use NSG flow logs)

### Scalability & capacity model

Is the process to provision and deprovision capacity codified?

Fluctuation in application traffic is typically expected. To ensure optimal operation is maintained, such variations should be met by automated scalability. The significance of automated capacity responses underpinned by a robust capacity model was highlighted by the COVID-19 crisis where many applications experienced severe traffic variations. While Auto-scaling enables a PaaS or IaaS service to scale within a pre-configured (and often times limited) range of resources, is provisioning or deprovisioning capacity a more advanced and complex process of for example adding additional scale units like additional clusters, instances or deployments. The process should be codified, automated and the effects of adding/removing capacity should be well understood.

Is capacity utilization monitored and used to forecast future growth?

Predicting future growth and capacity demands can prevent outages due to insufficient provisioned capacity over time.

Especially when demand is fluctuating, it is useful to monitor historical capacity utilization to derive predictions about future growth. Azure Monitor provides the ability to collect utilization metrics for Azure services so that they can be operationalized in the context of a defined capacity model. The Azure Portal can also be used to inspect current subscription usage and quota status. (Supported metrics with Azure Monitor)

## Configuration & Secrets Management

 Where is application configuration information stored and how does the application access it?

Application configuration information can be stored together with the application itself or preferably using a dedicated configuration management system like Azure App Configuration or Azure Key Vault

Preferably configuration information is stored using a dedicated configuration management system like Azure App Configuration or Azure Key Vault so that it can be updated independently of the application code.

Do you have procedures in place for secret rotation?

In the situation where a key or secret becomes compromised, it is important to be able to quickly act and generate new versions. Key rotation reduces the attack vectors and should be automated and executed without any human interactions.

Secrets (keys, certificates etc.) should be replaced once they have reached the end of their active lifetime or once they have been compromised. Renewed certificates should also use a new key. A process needs to be in place for situations where keys get compromised (leaked) and need to be regenerated on-demand. Tools, such as Azure Key Vault should ideally be used to store and manage application secrets to help with rotation processes (Key Vault Key Rotation)

Are keys and secrets backed-up to geo-redundant storage?

Keys and secrets must still be available in a failover case.

Keys and secrets should be backed up to geo-redundant storage so that they can be accessed in the event of a regional failure and support recovery objectives. In the event of a regional outage, the Key Vault service will automatically be failed over to the secondary region in a read-only state(Azure Key Vault availability and reliability)

Are certificate/key backups and data backups stored in different geo-redundant storage accounts?

Encryption keys and data should be backed up separately to optimise the security of underlying data

Is Soft-Delete enabled for Key Vaults and Key Vault objects?

The Soft-Delete feature retains resources for a given retention period after a DELETE operation has been performed, while giving the appearance that the object is deleted. It helps to mitigate scenarios where resources are unintentionally, maliciously or incorrectly deleted(Azure Key Vault Soft-Delete)

Key Vault Soft Delete helps to mitigate scenarios where resources are unintentionally, maliciously or incorrectly deleted(Azure Key Vault Soft-Delete). It is therefore highly recommended to enable this.

Is the application stateless or stateful? If it is stateful, is the state externalized in a data store?

Stateless processes can easily be hosted across multiple compute instances to meet scale demands, as well as helping to reduce complexity and ensure high cacheability(Stateless web services)

Is the session state (if any) non-sticky and externalized to a data store?

Sticky session state limits application scalability because it is not possible to balance load. With sticky sessions all requests from a client must be sent to the same compute instance where the session state was initially created, regardless of the load on that compute instance. Externalizing session state allows for traffic to be evenly distributed across multiple compute nodes, with required state retrieved from the external data store(Avoid session state)

## Next step

>[!div class="nextstepaction"]
>[Best Practices](/azure/architecture/framework/resiliency/optimize-best-practices)

## Related links

- For information on regions and Availability Zones, see [Regions that support Availability Zones in Azure](https://docs.microsoft.com/azure/availability-zones/az-region).

Go back to the main article: [Optimize](optimize-checklist.md)