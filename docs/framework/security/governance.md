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
