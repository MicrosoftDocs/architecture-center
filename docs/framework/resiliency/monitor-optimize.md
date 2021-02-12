---
title: Optimize for reliability
description: How to optimize monitoring to improve application reliability in Azure
author: v-aangie
ms.date: 02/12/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Optimize for reliability

## Capacity & Service Availability

### Service Availability

Are Azure services available in the required regions?

All Azure services and SKUs are not available within every Azure region, so it is important to understand if the selected regions for the application offer all of the required capabilities. Service availability also varies across sovereign clouds, such as China ("Mooncake") or USGov, USNat, and USSec clouds. In situations where capabilities are missing, steps should be taken to ascertain if a roadmap exists to deliver required services(Azure Products by Region).

Are Azure Availability Zones available in the required regions?

Not all regions support Availability Zones today, so when assessing the suitability of availability strategy in relation to targets it is important to confirm if targeted regions also provide zonal support. All net new Azure regions will conform to the 3 + 0 datacenter design, and where possible existing regions will expand to provide support for Availability Zones(Regions that support Availability Zones in Azure)

Are any preview services/capabilities required in production?

If the application has taken a dependency on preview services or SKUs then it is important to ensure that the level of support and committed SLAs are in alignment with expectations and that roadmap plans for preview services to go Generally Available (GA) are understood Private Preview : SLAs do not apply and formal support is not generally provided Public Preview : SLAs do not apply and formal support may be provided on a best-effort basis

Are all APIs/SDKs validated against target runtime/languages for required functionality?

While there is a desire across Azure to achieve API/SDK uniformity for supported languages and runtimes, the reality is that capability deltas exist. For instance, not all CosmosDB APIs support the use of direct connect mode over TCP to bypass the platform HTTP gateway. It is therefore important to ensure that APIs/SDKs for selected languages and runtimes provide all of the required capabilities

Capacity
Is there a capacity model for the application?

A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it is therefore recommended that an N+1 model be applied to ensure complete tolerance to transient faults, where n describes the capacity required to satisfy performance and availability requirements(Performance Efficiency - Capacity)

Is the required capacity (initial and future growth) within Azure service scale limits and quotas?

Due to physical and logical resource constraints within the platform, Azure must apply limits and quotas to service scalability, which may be either hard or soft. The application should therefore take a scale-unit approach to navigate within service limits, and where necessary consider multiple subscriptions which are often the boundary for such limits. It is highly recommended that a structured approach to scale be designed up-front rather than resorting to a 'spill and fill' model(Azure subscription and service limits, quotas, and constraints)

Is the required capacity (initial and future growth) available within targeted regions?

While the promise of the cloud is infinite scale, the reality is that there are finite resources available and as a result situations can occur where capacity can be constrained due to overall demand. If the application requires a large amount of capacity or expects a significant increase in capacity then effort should be invested to ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, consideration should also be given to ensure suitable capacity exists in the secondary region(s) since a regional outage can lead to a significant increase in demand within a paired region due to other customer workloads also failing over. To help mitigate this, consideration should be given to pre-provisioning resources within the secondary region(Azure Capacity)

Scalability & Performance
App Performance
Does the application logic handle exceptions and errors using resiliency patterns?

Programming paradigms such as retry patterns, request timeouts, and circuit breaker patterns can improve application resiliency by automatically recovering from transient faults(Error handling for resilient applications)

Does the application require long running TCP connections?

If an application is initiating many outbound TCP or UDP connections it may exhaust all available ports leading to SNAT port exhaustion and poor application performance. Long-running connections exacerbate this risk by occupying ports for sustained durations. Effort should be taken to ensure that the application can scale within the port limits of the chosen application hosting platform(Managing SNAT port exhaustion)

Data Size/Growth
Are target data sizes and associated growth rates calculated per scenario or service?

Scale limits and recovery options should be assessed in the context of target data sizes and growth rates to ensure suitable capacity exists

Are there any mitigation plans defined in case data size exceeds limits?

Mitigation plans such as purging or archiving data can help the application to remain available in scenarios where data size exceeds expected limits

Data Latency and Throughput
Are latency targets defined, tested, and validated for key scenarios?

Latency targets, which are commonly defined as first byte in to last byte out, should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health

Are throughput targets defined, tested, and validated for key scenarios?

Throughput targets, which are commonly defined in terms of IOPS, MB/s and Block Size, should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health. Available throughput typically varies based on SKU, so defined targets should be used to inform the use of appropriate SKUs

Network Throughput and Latency
Are there any components/scenarios that are very sensitive to network latency?

Components or scenarios that are sensitive to network latency may indicate a need for co-locality within a single Availability Zone or even closer using Proximity Placement Groups with Accelerated Networking enabled(Proximity Placement Groups)

Have gateways (ExpressRoute or VPN) been sized accordingly to the expected cross-premises network throughput?

Azure Virtual Network Gateways throughput varies based on SKU. Gateways should therefore be sized according to required throughput(VPN Gateway SKUs)

Does the application require dedicated bandwidth?

Applications with stringent throughput requirements may require dedicated bandwidth to remove the risks associated with noisy neighbor scenarios

If NVAs are used, has expected throughput been tested?

Maximum potential throughput for third-party NVA solutions is based on a combination of the leveraged VM SKU size, support for Accelerated Networking, support for HA ports, and more generally the NVA technology used. Expected throughput should be tested to ensure optimal performance, however, it is best to confirm throughput requirements with the NVA vendor directly

Is autoscaling enabled based on throughput

Autoscaling capabilities can vary between NVA solutions, but ultimately help to mitigate common bottle-neck situations

Elasticity
Can the application scale horizontally in response to changing load?

A scale-unit approach should be taken to ensure that each application component and the application as a whole can scale effectively in response to changing demand. A robust capacity model should be used to define when and how the application should scale

Has the time to scale in/out been measured?

Time to scale-in and scale-out can vary between Azure services and instance sizes and should be assessed to determine if a certain amount of pre-scaling is required to handle scale requirements and expected traffic patterns, such as seasonal load variations

Is autoscaling enabled and integrated within Azure Monitor?

Autoscaling can be leveraged to address unanticipated peak loads to help prevent application outages caused by overloading

Has autoscaling been tested under sustained load?

The scaling on any single component may have an impact on downstream application components and dependencies. Autoscaling should therefore be tested regularly to help inform and validate a capacity model describing when and how application components should scale

## Security & Compliance

### Identity and Access

Is the identity provider and associated dependencies highly available?

It is important to confirm that the identity provider (e.g. Azure AD, AD, or ADFS) and its dependencies (e.g. DNS and network connectivity to the identity provider) are designed in a way and provide an SLA/SLO that aligns with application availability targets

Has role-based and/or resource-based authorization been configured within Azure AD?

Role-based and resource-based authorization are common approaches to authorize users based on required permission scopes(Role-based and resource-based authorization)

Does the application write-back to Azure AD?

The Azure AD SLA includes authentication, read, write, and administrative actions. In many cases, applications only require authentication and read access to Azure AD, which aligns with a much higher operational availability due to geographically distributed read replicas(Azure AD Architecture)

Are authentication tokens cached and encrypted for sharing across web servers?

Application code should first try to get tokens silently from a cache before attempting to acquire a token from the identity provider, to optimise performance and maximize availability(Acquire and cache tokens)

Are Azure AD emergency access accounts and processes defined for recovering from identity failures?

The impact of no administrative access can be mitigated by creating two or more emergency access accounts(Emergency Access accounts in Azure AD)

### Security Center

Is Azure Security Center Standard tier enabled for all subscriptions and reporting to centralized workspaces? Also, is automatic provisioning enabled for all subscriptions? (Security Center Data Collection)

Is Azure Security Center's Secure Score being formally reviewed and improved on a regular basis? (Security Center Secure Score)

Are contact details set in security center to the appropriate email distribution list? (Security Center Contact Details)

### Network Security

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

## Scalability & Capacity Model

Is the process to provision and deprovision capacity codified?

Fluctuation in application traffic is typically expected. To ensure optimal operation is maintained, such variations should be met by automated scalability. The significance of automated capacity responses underpinned by a robust capacity model was highlighted by the COVID-19 crisis where many applications experienced severe traffic variations. While Auto-scaling enables a PaaS or IaaS service to scale within a pre-configured (and often times limited) range of resources, is provisioning or deprovisioning capacity a more advanced and complex process of for example adding additional scale units like additional clusters, instances or deployments. The process should be codified, automated and the effects of adding/removing capacity should be well understood.

Is capacity utilization monitored and used to forecast future growth?

Predicting future growth and capacity demands can prevent outages due to insufficient provisioned capacity over time.

Especially when demand is fluctuating, it is useful to monitor historical capacity utilization to derive predictions about future growth. Azure Monitor provides the ability to collect utilization metrics for Azure services so that they can be operationalized in the context of a defined capacity model. The Azure Portal can also be used to inspect current subscription usage and quota status. (Supported metrics with Azure Monitor)

## Configuration & Secrets Management DIDN'T I PUT THIS SOMEWHERE?

 