---
title: Risk reduction with Azure | Microsoft Docs
description: Applying good security practices and principles should be an ongoing task rather than a static absolute state.
author: PageWriter-MSFT
ms.date: 07/15/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
---

# How do you keep your organization's risk down

Much like physical safety, success in information security is defined more as an
ongoing task of applying good security practices and principles and hygiene
rather than a static absolute state. Reducing risk for your security program
should be aligned to your organizations mission and shaped by three key
strategic directions:

-   Building **resilience** into your cybersecurity strategy

-   Strategically **increasing attacker cost**

-   Tactically **containing attacker access**.

## Resilience

Building cybersecurity resilience into your organization requires balancing
investments across the security lifecycle, diligently applying maintenance, vigilantly responding to anomalies and alerts to prevent security
assurance decay, and designing to defense in depth and least privilege.

Balancing your investments will help you both prevent cybersecurity attacks
and rapidly restore normal operations in the event of a successful attack.
By investing in both of these, you will reduce the risk your organization
faces. The functions of the [NIST](https://www.nist.gov/cyberframework) map well to these dual goals:

-   **Identify/Protect –** Understanding your posture, your attackers, and
    invest in establishing and improving controls to prevent attacks on data and
    systems over time. A defense in-depth approach can further mitigate risk
    including supplemental controls designed to handle the potential failure of
    primary control (for example, assuming network controls will fail and implementing
    endpoint and data security protections)

-   **Detect/Respond/Recovery –** Stay vigilant so that when attackers do get
    access to systems and data, you can rapidly detect them and restore normal
    operations and security assurances

## Increasing attacker cost

Cybersecurity attacks are planned and conducted by human attackers that must
manage their return on investment into attacks (return could include profit
or achieving an assigned objective). As you invest in security, you should
carefully consider how you can damage the *attacker’s return on investment*
with your defensive investments.

The best way to damage an attacker’s ability to successfully attack your
organization is to increase their cost by preventing and detecting easy and
cheap attack methods. This will rapidly increase the minimum attacker cost
and make you a less attractive target overall (particularly to profit driven
attackers). Some attackers like nation states have considerable resources
for attack research and execution, but increasing their costs still affects
how many successful attacks they can mount with the (large but) finite
amount of talent and time available. Well-resourced attackers often have
invested in building a library of advanced attacks, but typically hold them
back until needed because using these methods risks “burning” them— exposing
them to discovery and mitigation by vendors and target organizations.
Removing cheap and easy attacks impacts the effectiveness of all attackers
and lowers your risk overall.

This is a general mindset with many possible applications, but two concrete
applications of this are:

-   **Investment criteria** - As you consider various security investments,
    evaluate whether the potential investments lower attacker cost overall (for example,
    does this security investment force an attacker to build or buy a more
    expensive option? Does it eliminate one of many cheap options on the
    attacker menu? Or does it only eliminate an expensive/rare attack method?)

-   **Attack simulation goals** – As you engage in penetration testing or red
    teaming activities to test, you should focus these teams on identifying and
    cataloging the lowest cost methods to get to business critical data so you
    can eliminate those first.

## Containing attacker access

The actual security risk for an organization is heavily influenced by how
much access an adversary can or does obtain to valuable systems and data.
Your investments should be focused on ensuring your security measures
constrain how much access an adversary gets:

**Time** – Limit how long the adversary can have access to your environment
during an attack operation. This is primarily achieved through security
operations that rapidly detect potential attacks, prioritizing potential
detections so your team is focused on quickly investigating real attacks
(vs. false positives), and reducing your mean time to remediate those real
incidents.  
More information on these goals and metrics is in the [security
operations](/azure/architecture/security/security-operations#objective-and-metrics) section.

**Privilege** – Limit the privileges and permissions that an adversary can
gain during an attack operation (by permissions and by amount of time
privileges are assigned). As attackers gain more privileges, they can access
more target systems and data (or leverage those systems to continue to pivot
within your environment). Your security strategy should be focused on
containing those privileges with:
- Preventive controls
- Detection/response/recovery that is prioritized to focus on business
critical assets and high amounts of permissions to assets typically IT
operations roles.