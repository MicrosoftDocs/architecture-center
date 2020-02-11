---
ms.author: dastanfo
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.uid: 99b67f6d-3cac-49b1-a6de-dfda95e47dc4
ms.assessment_question: There are clear lines of responsibility established
---
## Clear lines of responsibility

Designate the parties responsible for specific functions in Azure

Clearly documenting and sharing the contacts responsible for each of these
functions will create consistency and facilitate communication. Based on our
experience with many cloud adoption projects, this will avoid confusion that can
lead to human and automation errors that create security risk.

Designate groups (or individual roles) that will be responsible for these key
functions:

|Group or individual role| Responsibility|
|---|---|
| **Network Security**                 | *Typically existing network security team* Configuration and maintenance of Azure Firewall, Network Virtual Appliances (and associated routing), WAFs, NSGs, ASGs, etc.                              |
| **Network Management**               | *Typically existing network operations team* Enterprise-wide virtual network and subnet allocation                                                                                                   |
| **Server Endpoint Security**         | *Typically IT operations, security, or jointly* Monitor and remediate server security (patching, configuration, endpoint security, etc.)                                                             |
| **Incident Monitoring and Response** | *Typically security operations team* Investigate and remediate security incidents in Security Information and Event Management (SIEM) or source console:                                             |
| **Policy Management**                | *Typically GRC team + Architecture* Set Direction for use of Role Based Access Control (RBAC), Azure Security Center, Administrator protection strategy, and Azure Policy to govern Azure resources |
| **Identity Security and Standards**  | *Typically Security Team + Identity Team Jointly* Set direction for Azure AD directories, PIM/PAM usage, MFA, password/synchronization configuration, Application Identity Standards
