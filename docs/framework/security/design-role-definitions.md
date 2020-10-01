---
title: Team roles and responsibilities
description: Define clear lines of responsibility and separation of duties.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Team roles and responsibilities 

To avoid confusion that can lead to human and automation errors that create security risk, define clear lines of responsibility and separation of duties.

**Do the teams have a clear view on responsibilities and individual/group access levels?**
***

- Designate groups (or individual roles) that will be responsible for central functions, such as network, policy management and so on. 
- Document responsibilities of each group, share contacts to facilitate communication. 

|Central function| Responsibility|Technical team|
|---|---|---|
| Network security | Configuration and maintenance of Azure Firewall, Network Virtual Appliances (and associated routing), Web Application Firewall (WAF), Network Security Groups, Application Security Groups (ASG), and other cross-network traffic. | Network security team.|
| Network operations | Enterprise-wide virtual network and subnet allocation.|Network operations team.|
| IT operations, Security| Server endpoint security includes monitoring and remediating server security. This includes tasks such as patching, configuration, endpoint security,and so on. |IT operations and, or, security.  |
| Security operations | Incident monitoring and response to investigate and remediate security incidents in Security Information and Event Management (SIEM) or source console such as Azure Security Center Azure AD Identity Protection. | Security operations team.|
| Policy management | Apply governance based on risk analysis and compliance requirements. Set direction for use of Roles Based Access Control (RBAC), Azure Security Center, Administrator protection strategy, and Azure Policy to govern Azure resources|Governance and architecture teams.
|Identity Security and Standards| Set direction for Azure AD directories, PIM/PAM usage, MFA, password/synchronization configuration, Application Identity Standards. | Security and identity teams|

Application teams should include central functions listed in the preceding table. Application roles and responsibilities should cover different access level of each operational function. For example, publish production release, access customer data, manipulate database records, and so on. 

## Next steps
Start with this reference model and adapt it to your organization’s needs. This model shows how functions, resources, and teams can be segmented. 
> [!div class="nextstepaction"]
> [Segmentation reference model](design-segmentation.md)


