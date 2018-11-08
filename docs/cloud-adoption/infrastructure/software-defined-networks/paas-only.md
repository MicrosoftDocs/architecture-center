---
title: "Enterprise Cloud Adoption: Software Defined Networks - PaaS Only" 
description: Discussion of the PaaS Only model for cloud based networking functionalty.
author: rotycenh
ms.date: 11/07/2018
---

# Enterprise Cloud Adoption: Software Defined Networks - PaaS Only

For Platform as a Service (PaaS) implementations, your deployment may not need a software defined network. When deploying a PaaS solution, an assumed underlying network is created. There are a limited number of controls over that network including; load balancing, port blocking, public endpoint connections to other PaaS services, etc... In some cases, this may qualify as a sufficient network for the desired deployment. However, before choosing this for your deployment, validate that the assumptions required for a PaaS only architecture are a fit for your requirements.

**PaaS Only Assumptions:** Deploying a PaaS Only network assumes the following:

- The application being deployed is a stand alone application OR is dependent only on other PaaS solutions
- The application being deployed does not have any dependencies on existing on-prem or IaaS resources
- The operations team supporting the application once it goes to production has implemented tooling or processes required to support a stand alone PaaS application
- This PaaS application is not part of a broader cloud adoption initiative

> [!TIP]
> The above assumptions are minimum qualifiers aligned to a PaaS Only network. While this approach may fit the requirements of a single application deployment, your cloud migration team should think about some longer-term questions: 
>- Will this deployment expand in scope or scale to require access to other non-PaaS resources? 
>- Are other PaaS deployments planned beyond the current solution? 
>- Does the organization have plans for other future cloud migrations? 
> 
> The answers to these questions would not preclude a team from choosing a PaaS only option, but should be considered before making this decision.

## Next steps

Learn about the [cloud native](cloud-native.md) virtual network architecture.

> [!div class="nextstepaction"]
> [Cloud Native](cloud-native.md)