---
title: Governance, risk, and compliance in Azure | Microsoft Docs
description: Learn how to define security priorities around governance, risk, and compliance, beginning with definitions of these concepts and how they affect security.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
products:
  - azure-devops
categories:
  - security
subject: 
  - security
---

<!-- cSpell:ignore NIST -->

# Governance, risk, and compliance

Organizations of all sizes are constrained by their available resources;
financial, people, and time. To achieve an effective return on investment (ROI) organizations must prioritize where they will invest. Implementation of security across the organization is also constrained by this, so to achieve an appropriate ROI on security the organization needs to first understand and define its security priorities.

**Governance:** How is the organization's security going to be monitored, audited, and reported? Design and implementation of security controls within an organization is only the beginning of the story. How does the organization know that things are actually working? Are they improving? Are there new requirements? Is there mandatory reporting? Similar to compliance there may be external industry, government or regulatory standards that need to be considered.

**Risk:** What types of risks does the organization face while trying to
protect identifiable information, Intellectual Property (IP), financial information? Who may be interested or could use this information if stolen, including external and internal threats as well as unintentional or malicious? A commonly forgotten but extremely important
consideration within risk is addressing Disaster Recovery and Business
Continuity.

**Compliance:** Is there a specific industry, government, or regulatory requirements that dictate or provide recommendation on criteria that your organization's security controls must meet? Examples of such standards, organizations, controls, and legislation are [ISO27001]( https://www.iso.org/isoiec-27001-information-security.html), [NIST]( https://www.nist.gov), [PCI-DSS]( https://www.pcicomplianceguide.org/faq).

The collective role of organization(s) is to manage the security standards of
the organization through their lifecycle:

- **Define** - Set organizational standards and policies for practices,
    technologies, and configurations based on internal factors (organizational
    culture, risk appetite, asset valuation, business initiatives, etc.) and
    external factors (benchmarks, regulatory standards, threat environment, and
    more)

- **Improve** – Continually push these standards incrementally forward towards
    the ideal state to ensure continual risk reduction.

- **Sustain** – Ensure the security posture doesn't degrade naturally over
    time by instituting auditing and monitoring compliance with organizational
    standards.

## Prioritize security best practices investments

Security best practices are ideally applied proactively and completely to all
systems as you build your cloud program, but this isn't reality for most
enterprise organizations. Business goals, project constraints, and other factors
often cause organizations to balance security risk against other risks and apply
a subset of best practices at any given point.

We recommend applying as many of the best practices as early as possible, and
then working to retrofit any gaps over time as you mature your security program
to include review, prioritization, and proactive application of best practices 
to cloud resources. We recommend evaluating the following considerations when 
prioritizing which to follow first:

- **High business impact and highly exposed systems:** These include systems with direct intrinsic value as well as the systems that provide attackers a path to them. For more information, see [Identify and classify business critical applications](./design-apps-services.md).

- **Easiest to implement mitigations:** Identify quick wins by prioritizing the best practices, which your organization can execute quickly because you already have the required skills, tools, and knowledge to do it (for example, implementing a Web App Firewall (WAF) to protect a legacy application). Be careful not to exclusively use (or overuse) this short-term prioritization method. Doing so can increase your risk by preventing your program from growing and leaving critical risks exposed for extended periods.

Microsoft has provided some prioritized lists of security initiatives to help organizations start with these decisions based on our experience with threats and mitigation initiatives in our own environments and across our customers. See [Module 4a](/office365/securitycompliance/ciso-workshop-module-4a)
of the [Microsoft CISO Workshop](/security/ciso-workshop/ciso-workshop).



## Establish segmentation with management groups

Structure management groups into a simple design that guides the enterprise
segmentation model.

Management groups offer the ability to consistently and efficiently manage resources (including multiple subscriptions as needed). However, because of their flexibility, it's possible to create an overly complex design. Complexity creates confusion
and negatively impacts both operations and security (as illustrated by overly
complex Organizational Unit (OU) and Group Policy Object (GPO) designs for
Active Directory).

Microsoft recommends aligning the top level of management groups (MGs) into a simple [enterprise segmentation strategy](./governance.md#enterprise-segmentation-strategy) limited to 1 or 2 levels.

## Use root management group carefully

Use the Root Management Group (MG) for enterprise consistency, but test changes
carefully to minimize risk of operational disruption.

The root management group enables you to ensure consistency across the enterprise by applying policies, permissions, and tags across all subscriptions.
Care must be taken when planning and implementing assignments to the root
management group because this can affect every resource on Azure and potentially
cause downtime or other negative impacts on productivity in the event of errors
or unanticipated effects.

Root management group guidance:

- **Plan Carefully** - Select enterprise-wide elements to the root management
    group that have a clear requirement to be applied across every resource
    and/or low impact.

    Good candidates include:

    -   **Regulatory requirements** with clear business risk/impact (for example,
        restrictions related to data sovereignty).

    -   **Near-zero potential negative impact** on operations such as policy
        with audit effect, Tag assignment, Azure RBAC permissions assignments that
        have been carefully reviewed.

- **Test First -** Carefully test all enterprise-wide changes on the root
    management group before applying (policy, tags, Azure RBAC model, etc.) using a

    -   **Test Lab -** Representative lab tenant or lab segment in production
        tenant.

    -   **Production Pilot -** Segment MG or Designated subset in
        subscription(s) / MG.

- **Validate Changes** – to ensure they have the desired effect.

## Virtual Machine (VM) security updates and strong passwords

Ensure policy and processes enable (and require) rapid application of security
updates to virtual machines.

Attackers constantly scan public cloud IP ranges for open management ports and
attempt "easy" attacks like common passwords and unpatched vulnerabilities.

Enable [Azure Security Center](/azure/security-center/security-center-apply-system-updates)
to identify missing security updates & apply them.

[Local Admin Password Solution (LAPS)](https://www.microsoft.com/download/details.aspx?id=46899) or a third-party Privileged Access Management can set strong local admin passwords and just in time access to them.

## Remove Virtual Machine (VM) direct internet connectivity

Make sure policies and processes require restricting and monitoring direct
internet connectivity by virtual machines.

For Azure, you can enforce policies by,

-   **Enterprise-wide prevention** - Prevent inadvertent exposure by following
    the permissions and roles described in the reference model.

    -   Ensures that network traffic is routed through approved egress points by
        default.

    -   Exceptions (such as adding a public IP address to a resource) must go
        through a centralized group that evaluates exception requests and makes
        sure appropriate controls are applied.

-   **Identify and remediate** exposed virtual machines by using the [Azure Security Center](/azure/security-center/)
    network visualization to quickly identify internet exposed resources.

-   **Restrict management ports** (RDP, SSH) using [Just in Time
    access](/azure/security-center/security-center-just-in-time)
    in Azure Security Center.



One way of managing VMs in the virtual network is by using [Azure Bastion](/azure/bastion/). This service allows you to log into VMs in the virtual network through SSH or remote desktop protocol (RDP) without exposing the VMs directly to the internet. To see a reference architecture that uses Bastion, see [Network DMZ between Azure and an on-premises datacenter](../../reference-architectures/dmz/secure-vnet-dmz.yml).

## Assign incident notification contact

Security alerts need to reach the right people in your organization. Establish a 
designated point of contact to receive Azure incident notifications from Microsoft/Azure 
Security Center, typically a notification that your resource is compromised and/or attacking 
another customer.

This enables your security operations team to rapidly respond to potential
security risks and remediate them.

Ensure administrator contact information in the Azure enrollment portal includes
contact information that will notify security operations (directly or rapidly
via an internal process).

**Learn more**

To learn more about establishing a designated point of contact to receive Azure incident 
notifications from Microsoft, reference the following articles:
  
- [Update notification settings](/azure/cost-management-billing/manage/ea-portal-administration#update-notification-settings)
- [Configure email notifications for security alerts](/azure/security-center/security-center-provide-security-contact-details)

## Regularly review critical access

Regularly review roles that are assigned privileges with a business-critical impact. 

Set up a recurring review pattern to ensure that accounts are removed from permissions as roles change.
You can conduct the review manually or through an automated process by using tools such as [Azure AD access reviews](/azure/active-directory/governance/create-access-review).

## Discover and remediate common risks

Identify well-known risks for your Azure tenants, remediate those risks, and
track your progress using Secure Score. Secure Score is a snapshot of your security posture relative to Microsoft recommendations.

Identifying and remediating common security hygiene risks significantly reduces
overall risk to your organization by increasing cost to attackers. When you
remove cheap and well-established attack vectors, attackers are forced to
acquire and use advanced or untested attack methods.

[Azure Secure Score](/azure/security-center/security-center-secure-score)
in Azure Security Center monitors the security posture of machines, networks,
storage and data services, and applications to discover potential security
issues (internet connected VMs, or missing security updates, missing endpoint
protection or encryption, deviations from baseline security configurations,
missing Web Application Firewall (WAF), and more). You should enable this
capability (no additional cost), review the findings, and follow the included
[recommendations](/azure/security-center/security-center-recommendations)
to plan and execute technical remediations starting with the highest priority
items.

As you address risks, track progress and prioritize ongoing investments in your
governance and risk reduction programs.

## Increase automation with Azure Blueprints

Use Azure's native automation capabilities to increase consistency, compliance,
and deployment speed for workloads.

Automation of deployment and maintenance tasks reduces security and compliance
risk by limiting opportunity to introduce human errors during manual tasks. This
will also allow both IT Operations teams and security teams to shift their focus
from repeated manual tasks to higher value tasks like enabling developers and
business initiatives, protecting information, and so on.

Utilize the Azure Blueprint service to rapidly and consistently deploy
application environments that are compliant with your organization's policies
and external regulations. [Azure Blueprint Service](/azure/governance/blueprints/)
automates deployment of environments including Azure roles, policies, resources
(VM/Net/Storage/etc.), and more. Azure Blueprints builds on Microsoft's
significant investment into the Azure Resource Manager to standardize
resource deployment in Azure and enable resource deployment and governance based
on a desired-state approach. You can use built in configurations in Azure
Blueprint, make your own, or just use Resource Manager scripts for smaller scope.

Implement a *landing zone* concept with Azure Blueprints and Azure Policies. The purpose of a landing zone is to ensure that when a workload lands on Azure, the required *plumbing* is already in place, providing greater agility and compliance with enterprise security, and governance requirements. It is crucial that a landing zone is handed over to the workload owner with security guardrails deployed.

For more information about landing zones, reference [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/)

Several [Security and Compliance Blueprints](https://servicetrust.microsoft.com/ViewPage/SCCIntroPage) [samples](/azure/governance/blueprints/samples/)
are available to use as a starting template.
  
**Learn more**

[What is the Microsoft Cloud Adoption Framework for Azure?](/azure/cloud-adoption-framework/overview)

## Evaluate security using benchmarks

Use an industry standard benchmark to evaluate your organizations current
security posture. Azure Security Benchmark v2 is Microsoft's current Azure
security benchmark.

Benchmarking allows you to improve your security program by learning from
external organizations. It lets you know how your current security
state compares to that of other organizations, providing both external
validation for successful elements of your current system and identifying
gaps that serve as opportunities to enrich your team's overall security
strategy. Even if your security program isn't tied to a specific benchmark or
regulatory standard, you will benefit from understanding the documented ideal
states by those outside and inside of your industry.

As an example, the Center for Internet Security (CIS) has created security
benchmarks for Azure that map to the CIS Control Framework. Another
reference example is the MITRE ATT&CK&trade; framework that defines the various
adversary tactics and techniques based on real-world observations. These
external references control mappings and help you to understand any gaps between
your current strategy, what you have, and what other experts have in the industry.

### Suggested action
  
Develop an Azure security benchmarking strategy aligned to industry standards.

## Audit and enforce policy compliance

Ensure that the security team is auditing the environment to report on
compliance with the security policy of the organization. Security teams may also
enforce compliance with these policies.

Organizations of all sizes will have security compliance requirements. Industry,
government, and internal corporate security policies all need to be audited and
enforced. Policy monitoring is critical to check that initial configurations are
correct and that it continues to be compliant over time.

In Azure, you can take advantage of Azure Policy to create and manage policies
that enforce compliance. Like Azure Blueprints, Azure Policies are built on the
underlying Azure Resource Manager capabilities in the Azure platform (and
Azure Policy can also be assigned via Azure Blueprints).

For more information on how to do this in Azure, please review **Tutorial: Create and manage policies to enforce compliance**.

## Monitor identity Risk

Monitor identity-related risk events for warning on potentially compromised
identities and remediate those risks.

Most security incidents take place after an attacker initially gains access
using a stolen identity. These identities can often start with low privileges,
but the attackers then use that identity to traverse laterally and gain access
to more privileged identities. This repeats as needed until the attacker
controls access to the ultimate target data or systems.

Azure Active Directory uses adaptive machine learning algorithms, heuristics,
and known compromised credentials (username/password pairs) to detect suspicious
actions that are related to your user accounts. These username/password pairs
come from monitoring public and dark web sites (where attackers often dump
compromised passwords) and by working with security researchers, law
enforcement, Security teams at Microsoft, and others.

There are two places where you review reported risk events:

- **Azure AD reporting** - Risk events are part of Azure AD's security
    reports. For more information, see the [users at risk security
    report](/azure/active-directory/reports-monitoring/concept-user-at-risk) and
    the [risky sign-ins security
    report](/azure/active-directory/reports-monitoring/concept-risky-sign-ins).

- **Azure AD Identity Protection** - Risk events are also part of the
    reporting capabilities of [Azure Active Directory Identity
    Protection](/azure/active-directory/active-directory-identityprotection).

In addition, you can use the [Identity Protection risk events API](/graph/api/resources/identityriskevent?view=graph-rest-beta&preserve-view=true) to
gain programmatic access to security detections using Microsoft Graph.

Remediate these risks by manually addressing each reported account or by setting
up a [user risk policy](/azure/active-directory/identity-protection/howto-user-risk-policy)
to require a password change for these high risk events.

## Penetration testing

Use Penetration Testing to validate security defenses.

Real world validation of security defenses is critical to validate your defense
strategy and implementation. This can be accomplished by a penetration test
(simulates a one time attack) or a red team program (simulates a persistent
threat actor targeting your environment).

Follow the [guidance published by Microsoft](https://technet.microsoft.com/mt784683) for planning and executing simulated
attacks.


## Discover & replace insecure protocols

Discover and disable the use of legacy insecure protocols SMBv1, LM/NTLMv1,
wDigest, Unsigned LDAP Binds, and Weak ciphers in Kerberos.
  
Applications should use the SHA-2 family of hash algorithms (SHA-256, SHA-384, SHA-512). Use of weaker algorithms, like SHA-1 
and MD5, should be avoided.

Authentication protocols are a critical foundation of nearly all security
assurances. These older versions can be exploited by attackers with access to
your network and are often used extensively on legacy systems on Infrastructure
as a Service (IaaS).

Here are ways to reduce your risk:

- Discover protocol usage by reviewing logs with Azure Sentinel's Insecure Protocol Dashboard or third-party tools.

- Restrict or Disable use of these protocols by following guidance for
    [SMB](https://support.microsoft.com/help/2696547/detect-enable-disable-smbv1-smbv2-smbv3-in-windows-and-windows-server),
    [NTLM](/windows/security/threat-protection/security-policy-settings/network-security-restrict-ntlm-ntlm-authentication-in-this-domain),
    [WDigest](https://support.microsoft.com/help/2871997/microsoft-security-advisory-update-to-improve-credentials-protection-a).
  
- Use only secure hash algorithms (SHA-2 family). 
  
We recommend implementing changes using pilot or other testing methods to mitigate risk of operational interruption.
  
### Learn more
  
For more information about hash algorithms, see [Hash and Signature Algorithms](/windows/win32/seccrypto/hash-and-signature-algorithms).

## Elevated security capabilities

Consider whether to utilize specialized security capabilities in your enterprise
architecture.

Dedicated HSMs and Confidential Computing have the potential to enhance security and meet regulatory
requirements, but can introduce complexity that may negatively impact your
operations and efficiency.

### Suggested actions

We recommend careful consideration and judicious use of these security measures
as required:

- **Dedicated Hardware Security Modules (HSMs)**  
    [Dedicated Hardware Security Modules (HSMs) may help meet regulatory or
    security requirements](/azure/dedicated-hsm/).

- **Confidential Computing**  
    [Confidential Computing may help meet regulatory or security requirements](https://azure.microsoft.com/blog/azure-confidential-computing/).

Learn more about [elevated security capabilities for Azure workloads](https://azure.microsoft.com/solutions/confidential-compute/).
