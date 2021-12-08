---
title: Application threat analysis
description: Use threat modeling to identify threats, attacks, vulnerabilities, and countermeasures that can affect an application.
author: PageWriter-MSFT
ms.date: 09/17/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-active-directory
ms.custom:
  - article
---

# Application threat analysis

Do a comprehensive analysis to identify threats, attacks, vulnerabilities, and counter measures. Having this information can protect the application and threats it might pose to the system. Start with simple questions to gain insight into potential risks. Then, progress to advanced techniques using threat modeling.

## 1- Gather information about the basic security controls

A threat modeling tool will produce a report of all threats identified. This report is typically uploaded into a tracking tool, or converted to work items that can be validated and addressed by the developers. As new features are added to the solution, the threat model should be updated and integrated into the code management process. If a security issue is found, there should be a process to triage issue severity and determine when and how to remediate (such as in the next release cycle, or a faster release).

Start by gathering information about each component of the application. The answers to these questions will identify gaps in basic protection and clarify the attack vectors.

|Ask this question ...|To determine controls that ...|
|---|---|
|Are connections authenticated using Azure AD, TLS (with mutual authentication), or another modern security protocol approved by the security team?<ul><li>Between users and the application</li><li>Between different application components and services</li></ul>|Prevent unauthorized access to the application component and data.|
|Are you limiting access to only those accounts that have the need to write or modify data in the application| Prevent unauthorized data tampering or alteration.|
|Is the application activity logged and fed into a Security Information and Event Management (SIEM) through Azure Monitor or a similar solution?|Detect and investigate attacks quickly.|
|Is critical data protected with encryption that has been approved by the security team?| Prevent unauthorized copying of data at rest.|
|Is inbound and outbound network traffic encrypted using TLS?|Prevent unauthorized copying of data in transit.|
|Is the application protected against Distributed Denial of Service (DDoS) attacks using services such as Azure DDoS protection?|Detect attacks designed to overload the application so it can't be used.|
|Does the application store any logon credentials or keys to access other applications, databases, or services?| Identify whether an attack can use your application to attack other systems.|
|Do the application controls allow you to fulfill regulatory requirements?| Protect user's private data and avoid compliance fines.|

**Suggested actions**

Assign tasks to the individual people who are responsible for a particular risk identified during threat modeling.

**Learn more**

[Threat modeling](https://www.microsoft.com/en-us/securityengineering/sdl/threatmodeling)

## 2- Evaluate the application design progressively
Analyze application components and connections and their relationships. Threat modeling is a crucial engineering exercise that includes defining security requirements, identifying and mitigating threats, and validating those mitigations. This technique can be used at any stage of application development or production, but it's most effective during the design stages of a new functionality.

Popular methodologies include:

- [STRIDE](/azure/security/develop/threat-modeling-tool-threats):
    - Spoofing
    - Tampering
    - Repudiation
    - Information Disclosure
    - Denial of Service
    - Elevation of Privilege

Microsoft Security Development Lifecycle uses STRIDE and provides a tool to assist with this process. This tool is available at no additional cost. For more information, see [Microsoft Threat Modeling Tool](https://www.microsoft.com/en-us/securityengineering/sdl/threatmodeling).
- [Open Web Application Security Project (OWASP)](https://owasp.org/www-community/Threat_Modeling_Process) has documented a threat modeling approach for applications.
> ![Best practice](../../_images/i-best-practices.svg) Integrate threat modeling through automation using secure operations. Here are some resources:
>
> - Toolkit for [Secure DevOps on Azure](https://azsk.azurewebsites.net/).
> - [Guidance on DevOps pipeline security](https://www.owasp.org/index.php/OWASP_AppSec_Pipeline#tab=Main) by OWASP.

## 3- Mitigate the identified threats
The threat modeling tool produces a report of all the threats identified. After a potential threat is identified, determine how it can be detected and the response to that attack. Define a process and timeline which minimizes exposure to any identified vulnerabilities in the workload, so that those vulnerabilities cannot be left unaddressed.

Use the _Defense-in-Depth_ approach. This can help identify controls needed in the design to mitigate risk if a primary security control fails. Evaluate how likely it is for the primary control to fail. If it does, what is the extent of the potential organizational risk? Also, what is the effectiveness of the additional control (especially in cases that would cause the primary control to fail). Based on the evaluation apply Defense-in-Depth measures to address potential failures of security controls.

The principle of _least privilege_ is one way of implementing Defense-in-Depth. It limits the damage that can be done by a single account. Grant least number of privileges to accounts that allows them to accomplish with the required permissions within a time period. This helps mitigate the damage of an attacker who gains access to the account to compromise security assurances.

There's often a disconnect between organizational leadership and technical teams regarding business requirements for critical workloads.  This can create undesired outcomes and is especially sensitive when it pertains to information security. Routinely reviewing business critical workload requirements with executive sponsors to define requirements provides an opportunity to align expectations and ensure operational resource allocation to the initiative.

**How are threats addressed once found?**
***
Here are some best practices:

- Make sure the results are communicated to the interested teams.
- Prioritize the vulnerabilities and fix the most important in a timely manner.
- Upload the threat modeling report to a tracking tool. Create work items that can be validated and addressed by the developers. Cyber security teams can also use the report to determine attack vectors during a penetration test.
- As new features are added to the application, update the threat model report and integrate it into the code management process. Triage security issues into the next release cycle or a faster release, depending on the severity.

For information about mitigation strategies, see [RapidAttack](/security/compass/human-operated-ransomware).

**How long does it typically take to deploy a security fix into production?**
***
If a security vulnerability is discovered, update the software with the fix as soon as possible. Have processes, tools, and approvals in place to roll out the fix quickly.

### Learn more

[Threat modeling](https://www.microsoft.com/securityengineering/sdl/threatmodeling)

## Next steps

 - [Applications and services](design-apps-services.md)
 - [Application classification](design-apps-considerations.md)
 - [Regulatory compliance](design-regulatory-compliance.md)
