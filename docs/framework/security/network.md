---
title: Network
description: Describes security considerations to make when building out the network for your workload.
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How have you secured the network of your workload? 
---

# Network

Network security has been the traditional lynchpin of enterprise security
efforts. However, cloud computing has increased the requirement for network
perimeters to be more porous and many attackers have mastered the art of attacks
on identity system elements (which nearly always bypass network controls). These
factors have increased the need to focus primarily on identity-based access
controls to protect resources rather than network-based access controls.

These do diminish the role of network security controls, but do not eliminate it
entirely. While network security is no longer the primary focus for securing
cloud-based assets, it is still a top priority for the large portfolio of legacy
assets (which were built with the assumption that a network firewall-based
perimeter was in place). Many attackers still employ scanning and exploit
methods across public cloud provider IP ranges, successfully penetrating
defenses for those who don’t follow basic network security hygiene. Network
security controls also provide a defense-in-depth element to your strategy that
help protect, detect, contain, and eject attackers who make their way into your
cloud deployments.

In the category of network security and containment, we have the following best
practice recommendations:

-   Align network segmentation with overall strategy

-   Centralize network management and security

-   Build a network containment strategy

-   Define an internet edge strategy
 
<!-- DDos Protection -->
[!include[0b02951b-c60d-4593-a7c8-5a9e5ac645cd](../../../includes/aar_guidance/0b02951b-c60d-4593-a7c8-5a9e5ac645cd.md)]

<!-- How do you configure public IPs for which traffic is passed in, and how and where it's translated -->
[!include[ef437d0c-6b4f-43e6-9679-9a6e6ff89b1e](../../../includes/aar_guidance/ef437d0c-6b4f-43e6-9679-9a6e6ff89b1e.md)]

<!-- Isolate network traffic -->
[!include[c7466891-5bdd-4a2b-b2c1-b26c78d18bbf](../../../includes/aar_guidance/c7466891-5bdd-4a2b-b2c1-b26c78d18bbf.md)]

<!-- Traffic flow between tiers -->
[!include[8e3f022b-c5a8-468d-b3ea-c4b55b26b0ac](../../../includes/aar_guidance/8e3f022b-c5a8-468d-b3ea-c4b55b26b0ac.md)]

<!-- Security appliances and boundary policy enforcement -->
[!include[d67104c2-6210-49ee-9fdc-318b454bff6b](../../../includes/aar_guidance/d67104c2-6210-49ee-9fdc-318b454bff6b.md)]

<!-- Firewalls, load balancers, and intrusion detection systems -->
[!include[1f4f8735-53e6-4966-8cc2-8eebb9ae181e](../../../includes/aar_guidance/1f4f8735-53e6-4966-8cc2-8eebb9ae181e.md)]

<!-- Segmenting address space -->
[!include[446b4aaa-3e24-4ca6-b68d-6fd73a186e91](../../../includes/aar_guidance/446b4aaa-3e24-4ca6-b68d-6fd73a186e91.md)]

<!-- Routing -->
[!include[412b853a-eb19-4dc6-9449-dbbfd1ca40d4](../../../includes/aar_guidance/412b853a-eb19-4dc6-9449-dbbfd1ca40d4.md)]

<!-- Forced tunneling -->
[!include[6811873a-1805-4c4e-90c5-2a5f5d799ea8](../../../includes/aar_guidance/6811873a-1805-4c4e-90c5-2a5f5d799ea8.md)]

<!-- Cross-site connectivity -->
[!include[268aea68-4831-47db-920e-b95d02c12e3c](../../../includes/aar_guidance/268aea68-4831-47db-920e-b95d02c12e3c.md)]

<!-- Global load balancing -->
[!include[620290ad-c04b-44d2-9b42-3d8b03c0dc5b](../../../includes/aar_guidance/620290ad-c04b-44d2-9b42-3d8b03c0dc5b.md)]

<!-- Disable RDP/SSH Access -->
[!include[16a0b466-b486-42ae-bfcc-a03a2ee82bab](../../../includes/aar_guidance/16a0b466-b486-42ae-bfcc-a03a2ee82bab.md)]

<!-- VPN connectivity -->
[!include[b82b09b1-01b8-4dcd-85dd-4347fdca0807](../../../includes/aar_guidance/b82b09b1-01b8-4dcd-85dd-4347fdca0807.md)]

