---
title: "Fusion: Software Defined Networks - PaaS only" 
description: Discussion of the PaaS only model for cloud based networking functionality
author: rotycenh
ms.date: 11/07/2018
---

# Fusion: Software Defined Networks - PaaS only

When you implement a platform as a service (PaaS) solution, the deployment process automatically creates an assumed underlying network with a limited number of controls over that network, including load balancing, port blocking, public endpoint connections to other PaaS services, etc. 

Not all PaaS implementations need a software defined network (SDN). In some cases, the deployment may qualify as a sufficient network on its own. However, before choosing this deployment be sure you validate that the assumptions required for a PaaS-only architecture align with your requirements.

**PaaS Only assumptions:** Deploying a PaaS-only network assumes the following:

- The application being deployed is a standalone application OR is dependent on only one other PaaS solutions
- The application being deployed does not have any dependencies on existing on-premises or IaaS resources
- The operations team supporting the application once it goes to production has implemented tooling or processes required to support a standalone PaaS application
- The PaaS application is not part of a broader cloud adoption initiative

> [!TIP]
> The above assumptions are minimum qualifiers aligned to deploying a PaaS-only network. While this approach may align with the requirements of a single application deployment, your Cloud Adoption Team should examine these long-term questions: 
>- Will this deployment expand in scope or scale to require access to other non-PaaS resources? 
>- Are other PaaS deployments planned beyond the current solution? 
>- Does the organization have plans for other future cloud migrations? 
> 
> The answers to these questions would not preclude a team from choosing a PaaS only option, but should be considered before making a final decision.

## Next steps

Learn about the [cloud native](cloud-native.md) virtual network architecture.

> [!div class="nextstepaction"]
> [Cloud Native](cloud-native.md)
