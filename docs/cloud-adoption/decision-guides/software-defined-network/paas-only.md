---
title: "CAF: Software Defined Networks - PaaS only" 
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Discussion of the PaaS only model for cloud-based networking functionality
author: rotycenh
---

# Software Defined Networks: PaaS-only

When you implement a platform as a service (PaaS) resource, the deployment process automatically creates an assumed underlying network with a limited number of controls over that network, including load balancing, port blocking, and connections to other PaaS services.

In Azure, several PaaS resource types can be [deployed into](/azure/virtual-network/virtual-network-for-azure-services) or [connected to](/azure/virtual-network/virtual-network-service-endpoints-overview) a virtual network, allowing these resources to integrate with your existing virtual networking infrastructure. However, in many cases a PaaS only networking architecture, relying only on these default networking capabilities natively provided by PaaS resources, is sufficient to meet workload requirements.

If you are considering a PaaS only networking architecture, be sure you validate that the required assumptions align with your requirements.

## PaaS-only assumptions

Deploying a PaaS-only networking architecture assumes the following:

- The application being deployed is a standalone application OR is dependent on only other PaaS resources.
- Your IT operations teams can update their tools, training, and processes to support management, configuration, and deployment of standalone PaaS applications.
- The PaaS application is not part of a broader cloud migration effort that will include IaaS resources.

These assumptions are minimum qualifiers aligned to deploying a PaaS-only network. While this approach may align with the requirements of a single application deployment, your Cloud Adoption team should examine these long-term questions:

- Will this deployment expand in scope or scale to require access to other non-PaaS resources?
- Are other PaaS deployments planned beyond the current solution?
- Does the organization have plans for other future cloud migrations?

The answers to these questions would not preclude a team from choosing a PaaS only option but should be considered before making a final decision.
