---
author: BryanLa
ms.author: bryanla
ms.date: 04/01/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
---
If you understand Azure landing zones, you can skip ahead to the [Reference architecture section](#reference-architecture). If not, here are some concepts to review before proceeding:

- Abstractly speaking, a ***landing zone*** helps you plan for and design an Azure deployment, by conceptualizing a designated area for placement and integration of resources. There are [two types of landing zones](/azure/cloud-adoption-framework/ready/landing-zone/#platform-vs-application-landing-zones):
   - ***platform landing zone:*** provides centralized enterprise-scale foundational services for workloads and applications.
   - ***application landing zone:*** provides services specific to an application or workload. 

- Concretely, a landing zone can be viewed through two lenses:
  - **reference architecture**: a specific design that illustrates resource deployment to one or more Azure subscriptions, which meet the requirements of the landing zone. 
  - **reference implementation**: artifacts that deploy Azure resources into the landing zone subscription(s), according to the reference architecture. Many landing zones offer multiple deployment options, but the most common is a ready-made Infrastructure as Code (IaC) template referred to as a ***landing zone accelerator***. Accelerators automate and accelerate the deployment of a reference implementation, using IaC technology such as ARM, Bicep, Terraform, and others. 

- A workload deployed to an application landing zone integrates with and is dependent upon services provided by the platform landing zone. These infrastructure services run workloads such as networking, identity access management, policies, and monitoring. This operational foundation enables migration, modernization, and innovation at enterprise-scale in Azure. 

In summary, [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone) provide a destination for cloud workloads, a prescriptive model for managing workload portfolios at scale, and consistency and governance across workload teams. 