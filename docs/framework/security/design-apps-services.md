---
title: Applications and services
description: Secure your applications and services in Azure
author: v-aangie
ms.date: 09/17/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Applications and services

Applications and the data associated with them act as the primary store of business value on a cloud platform. Applications can play a role in risks to the business because:

- **Business processes** are encapsulated and executed by applications and services need to be available and provided with high integrity.
- **Business data** is stored and processed by application workloads and requires high assurances of confidentiality, integrity, and availability.

## In this section
|Assessment|Description|
|---|---|
|[**What aspects of the application do you need to protect?**](design-apps-considerations.md)|Understanding the hosting models and the security responsibility.|
|[**Does the organization identify the highest severity threats to this workload through threat modeling?**](design-threat-model.md)|Identify risks to the application and risks it may pose to your enterprise through threat modeling. |
|[**Do you have any regulatory or governance requirements?**](design-regulatory-compliance.md)|Guidance on standards published by law, authorities, and regulators.|
|[**Are you exposing information through exception handling or HTTP headers?**](design-app-dependencies.md)|Consider the way you store secrets and handle exceptions. Here are some considerations.|
|[**Are the frameworks and libraries used by the application secure?**](design-app-dependencies.md)|Evaluate frameworks and libraries used by the application and the resulting vulnerabilities.|


## Next steps
See these best practices related to PaaS applications. 

> [!div class="nextstepaction"]
> [Securing PaaS deployments](/azure/security/fundamentals/paas-deployments)

Secure communication paths between applications and the services. Make sure that there's a distinction between the endpoints exposed to the public internet and private ones. Also, the public endpoints are protected with web application firewall. 

> [!div class="nextstepaction"]
> [Network security](./design-network.md)