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
<!-- cSpell:ignore pentesting -->

# Azure security test practices

Regularly test your security design and implementation, as part the organization's operations. That integration will make sure the security assurances are effective and maintained as per the security standards set by the organization. 

A well-architected workload should be resilient to attacks. It should recover rapidly from disruption and yet provide the security assurances of confidentiality, integrity, and availability. Invest in simulated attacks as tests that can indicate gaps. Based on the results of the results you can harden the defense and limit a real attacker's lateral movement within your environment.

Simulated tests can also give you data to plan risk mitigation. Applications that are already in production should use data from real-world attacks. New or updated applications with new features, should rely on structured models for detecting risks early, such as threat modeling. 

## Key points
- Define test cases that are realistic and based on real-world attacks. 
- Identify and catalog lowest cost methods for preventing and detecting attacks. 
- Use penetration testing as a one-time attack to validate security defenses.
- Simulate attacks through red teams for long-term persistent attacks.
- Measure and reduce the potential attack surface that attackers target for exploitation for resources within the environment.
- Ensure proper follow-up to educate users about the various means that an attacker may use.


## Penetration testing (pentesting)

**Do you perform penetration testing on the workload?**
***

It's recommended that you simulate a one-time attack to detect vulnerabilities. Pentesting is a popular methodology to validate the security defense of a system. The practitioners are security experts who are not part of the organization's IT or application teams. So, they look at the system in a way that malicious actors scope an attack surface. The goal is to find security gaps by gathering information, analyzing vulnerabilities, and reporting. 

[Penetration Testing Execution Standard (PTES)](http://www.pentest-standard.org/index.php/Main_Page) provides guidelines about common scenarios and the activities required to establish a baseline.  

Azure uses shared infrastructure to host your assets and assets belonging to other customers. In a pentesting exercise, the practitioners may need access to sensitive data of the entire organization. Follow the rules of engagement to make sure that access and the intent is not misused. For guidance about planning and executing simulated attacks, see [Penetration Testing Rules of Engagement](https://www.microsoft.com/msrc/pentest-rules-of-engagement).


## Simulate attacks
The way users interact with a system is critical in planning your defense. The risks are even higher for critical impact accounts because they have elevated permissions and can cause more damage. 

**Do you carry out simulated attacks on users of this workload?**
***
Simulate a persistent threat actor targeting your environment through a red team. Here are some advantages:

- Periodic checks. The workload will get checked through a realistic attack to make sure the defense is up to date and effective.
- Educational purposes. Based on the learnings, upgrade the knowledge and skill level. This will help the users understand the various means that an attacker may use to compromise accounts.

A popular choice for ro simulate realistic attack scenarios is [Office 365 Attack Simulator](/office365/securitycompliance/attack-simulator). 


## Related links

Threat modeling is a structured process to identify the possible attack vectors. Based on the results, prioritize the risk mitigate efforts. For more information, see [Application threat analysis](design-threat-model.md). 

For more information on current attacks, see the [Microsoft Security Intelligence (SIR)](https://www.microsoft.com/security/business/security-intelligence-report) report.

[Microsoft Cloud Red Teaming](https://gallery.technet.microsoft.com/Cloud-Red-Teaming-b837392e)


> Go back to the main article: [Monitor](monitor.md)