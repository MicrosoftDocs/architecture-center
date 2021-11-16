---
title: Segmentation strategies
description: Strategies for creating isolation between technical teams.
author: PageWriter-MSFT
ms.date: 09/07/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure
categories:
  - management-and-governance
  - security
ms.custom:
  - article
---

# Segmentation strategies

Segmentation refers to the isolation of resources from other parts of the organization. It's an effective way of detecting and containing adversary movements.

One approach to segmentation is network isolation. This approach is not recommended because different technical teams may not be aligned with the business use cases and application workloads. One outcome of such a mismatch is complexity, as especially seen with on-premises networking, and can lead to reduced velocity, or in worse cases, broad network firewall exceptions. Although network control should be considered as a segmentation strategy, it should be part of a unified segmentation strategy.

Network security has been the traditional linchpin of enterprise security efforts. However, cloud computing has increased the requirement for network perimeters to be more porous and many attackers have mastered the art of attacks on identity system elements (which nearly always bypass network controls). These factors have increased the need to focus primarily on identity-based access controls to protect resources rather than network-based access controls.

An effective segmentation strategy will guide _all_ technical teams (IT, security, applications) to consistently isolate access using networking, applications, identity, and any other access controls. The strategy should aim to:

- Minimize operational friction by aligning to business practices and applications
- Contain risk by adding cost to attackers. This is done by:
    -   Isolating sensitive workloads from compromise by other assets.
    -   Isolating high-exposure systems from being used as a pivot to other systems.
- Monitor operations that might lead to potential violation of the integrity of the segments (account usage, unexpected traffic).

Here are some recommendations for creating a unified strategy:

- Ensure alignment of technical teams to a single strategy based on assessing business risks.
- Establish a modern perimeter based on zero-trust principles, focused on identity, devices, applications, and other signals. This helps overcome limitations of network controls in protecting from new resources and attack types.
- Reinforce network controls for legacy applications by exploring microsegmentation strategies.
- Centralize the organizational responsibility for management and security of core networking functions such as cross-premises links, virtual networking, subnetting, and IP address schemes as well as network security elements such as virtual network appliances, encryption of cloud virtual network activity and cross-premises traffic, network-based access controls, and other traditional network security components.

## Reference model
Start with this reference model and adapt it to your organization's needs. This model shows how functions, resources, and teams can be segmented.

![Enterprise tenant](images/enterprise-tenant.png)

### Example segments
Consider isolating shared and individual resources as shown in the preceding image.

#### Core Services segment
This segment hosts shared services utilized across the organization. These shared services typically include Active Directory Domain Services, DNS/DHCP, and system management tools hosted on Azure Infrastructure as a Service (IaaS) virtual machines.

#### Additional segments
Other segments can contain grouped resources based on certain criteria. For instance, resources that are used by one specific workload or application might be contained in a separate segment. You may also segment or sub-segment by lifecycle stage, like _development_, _test_, and _production_. Some resources might intersect, such as applications, and can use virtual networks for lifecycle stages.

#### Clear lines of responsibility
These are the main functions for this reference model. Permissions for these functions are described in [Team roles and responsibilities](design-identity-role-definitions.md).

|Function|Scope|Responsibility|
|---|---|---|
|Policy management (Core and individual segments)|Some or all resources.|Monitor and enforce compliance with external (or internal) regulations, standards, and security policy assign appropriate permission to those roles.|
|Central IT operations (Core)|Across all resources.|Grant permissions to the central IT department (often the infrastructure team) to create, modify, and delete resources like virtual machines and storage.|
|Central networking group (Core and individual segments)|All network resources.|Centralize network management and security to reduce the potential for inconsistent strategies that create potential attacker exploitable security risks. Because all divisions of the IT and development organizations do not have the same level of network management and security knowledge and sophistication, organizations benefit from leveraging a centralized network team's expertise and tooling.  </br>Ensure consistency and avoid technical conflicts, assign network resource responsibilities to a single central networking organization. These resources should include virtual networks, subnets, Network Security Groups (NSG), and the virtual machines hosting virtual network appliances.|
|Resource role permissions (Core)|-|For most core services, administrative privileges required are granted through the application (Active Directory, DNS/DHCP, System Management Tools). No additional Azure resource permissions are required. If your organizational model requires these teams to manage their own VMs, storage, or other Azure resources, you can assign these permissions to those roles.|
|Security operations (Core and individual segments)|All resources.|Assess risk factors, identify potential mitigations, and advise organizational stakeholders who accept the risk.|
|IT operations (individual segments) |All resources.|Grant permission to create, modify, and delete resources. The purpose of the segment (and resulting permissions) will depend on your organization structure. <ul><li>Segments with resources managed by a centralized IT organization can grant the central IT department (often the infrastructure team) permission to modify these resources.</li><li>Segments managed by independent business units or functions (such as a Human Resources IT Team) can grant those teams permission to all resources in the segment.</li><li>Segments with autonomous DevOps teams don't need to grant permissions across all resources because the resource role (below) grants permissions to application teams. For emergencies, use the service admin account (break-glass account).</li></ul>|
|Service admin (Core and individual segments)||Use the service admin role only for emergencies (and initial setup if required). Do not use this role for daily tasks.|

## Next steps
Start with this reference model and manage resources across multiple subscriptions consistently and efficiently with management groups.

> [!div class="nextstepaction"]
> [Management groups](design-management-groups.md)
