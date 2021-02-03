---
title: Azure security test practices
description: Test and validate the workload frequently to detect attacks.
author: PageWriter-MSFT
ms.date: 02/01/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Azure security test practices

Regularly test your security design and implementation, as part the organization's operations. That integration will make sure that the security assurances are effective and maintained as per the security standards set by the organization. 

An architecture built on good security practices should be resilient to attacks. The system should recover rapidly from disruption to the security assurances of confidentiality, integrity, and availability. Invest in penetration testing to simulate one-time attack and red teams to simulate long-term persistent attacks. The simulated attacks can indicate gaps that can help the attacker's lateral movement within your environment.

Use a data-based approach to guide risk mitigation. Applications that are already in production should use data from real-world attacks. New or updated applications with new features, should rely on structured models for detecting risks early, such as threat modeling. 

## Key points
- Define test cases that are realistic and based on real-world attacks. 
- Identify and catalogue lowest cost methods for preventing and detecting attacks. 
- Use penetration testing as a one-time attack to validate security defenses.
- Simulate attacks through red teams for long-term persistent attacks.
- Measure and reduce the potential attack surface that attackers target for exploitation for resources within the environment.
- Ensure proper follow-up to educate users about the various means that an attacker may use.


## Penetration testing (pentesting)

**Do you perform penetration testing on the workload?**
***

Pentesting is a popular methodology to validate the security defense of a system. Use penetration test to simulate a one-time attack. The practitioners are security experts who are not part of the organization's IT or application teams. They look at the system in a similar way that attackers scope an attack surface. The goal is to find security gaps by gathering information, analysing vulnerabilities, and reporting. 

[Penetration Testing Execution Standard (PTES)](http://www.pentest-standard.org/index.php/Main_Page) provides guidelines about common scenarios and the activities required to establish a baseline.  

When doing pentesting, be aware that Azure uses shared infrastructure to host your assets and assets belonging to other customers. In a pentesting exercise, the practicers need access to senstive data of an organization. Follow the rules of engagement to make sure that access is not misused. For guidance about planning and executing simulated attacks, see [Penetration Testing Rules of Engagement](https://www.microsoft.com/en-us/msrc/pentest-rules-of-engagement).


## Simulate attacks
The way users interact with a system is critical in planning your defense. The risks are even higher for critical impact accounts because they have elevated permissions and can cause more damage. 

**Do you carry out simulated attacks on users of this workload?**
***
Simulate a persistent threat actor targeting your environment through a red team. Here are some advantages:

- Periodic checks. The workload will get checked through a realistic attack to make sure the defense is up to date and effective.
- Educational purposes. The effort can help enforce a requirement to have knowledge and skills to understand the various means that an attacker may use to compromise accounts.

A popular choice for ro simulate realistic attack scenarios is [Office 365 Attack Simulator](/office365/securitycompliance/attack-simulator). 


## Related links

Threat modeling is a structured process for identifying possible attack vectors. You can prioritize the  risk mitigate efforts based on the report. For more information, see [Application threat analysis](design-threat-model.md). 

For more information on current attacks, see the [Microsoft Security Intelligence (SIR)](https://www.microsoft.com/en-us/security/business/security-intelligence-report) report.

[Microsoft Cloud Red Teaming](https://gallery.technet.microsoft.com/Cloud-Red-Teaming-b837392e)


> Go back to the main article: [Monitor](monitor.md)