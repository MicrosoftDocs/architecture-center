---
title: Segmentation strategies
description: Strategies for creating isolation between technical teams.
author: PageWriter-MSFT
ms.date: 09/07/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Segmentation strategies

Segmentation refers to the isolation of resources from other parts of the organization. It's an effective way of detecting and containing adversary movements. 

An approach to segmentation is network isolation. This approach is not recommended because different technical teams are not aligned with the overall business use cases and application workloads. An outcome is complexity especially with on-premises network and leads to broad network firewall exceptions. While network control should be considered as one of the strategies, it must be part of a unified segmentation strategy. 

An effective segmentation strategy will guide _all_ technical teams (IT, security, applications) to consistently isolate access using networking, applications, identity, and any other access controls. The strategy should aim to:

- Minimize operation friction by aligning to business practices and applications.
- Contain Risk by adding cost attackers. This is done by:
    -   Isolating sensitive workloads from compromise of other assets
    -   Isolating high exposure systems from being used as a pivot to other
        systems
- Monitor operations that can lead to potential violations of the integrity of the segments (account usage, unexpected traffic.).

Here are some recommendations for creating a unified strategy. 

- Ensure alignment of technical teams to a single strategy that is based on assessing business risks.
- Establish a modern perimeter based on zero-trust principles focused on identity, device, applications, and other signals. This will overcome the limitation of network controls to protect new resources and attack types.
- Reinforce network controls for legacy applications by exploring microsegmentation strategies.

## Reference model
Start with this reference model and adapt it to your organization’s needs. This model shows how functions, resources, and teams can be segmented. 

![Enterprise tenant](images/enterprise-tenant.png)

### Example segments
Consider isolating shared and individual resources as shown in the preceding image.
#### Core services segment
This segment hosts shared services utilized across the organization. These shared services typically include Active Directory Domain Services, DNS/DHCP, System Management Tools hosted on Azure Infrastructure as a Service (IaaS) virtual machines. 

#### Individual segments
There are other segments that can contain resources based on some criteria. For instance, resources used by a workload application can be contained in a separate segment. Another way is segment by lifecycle stages: development, test, and production. Some resources might intersect, such as applications can use virtual networks used for lifecycle stages. 

### Functions and teams
These are the main functions for this reference model. Mapping between central functions, responsibilities, and teams are described in [Team roles and responsibilities](design-role-definitions.md). 

|Function|Scope|Responsibility|
|---|---|---|
|Policy management (Core and individual segments)|Some or all resources.|Monitor and enforce compliance with external (or internal) regulations, standards, and security policy assign appropriate permission to those roles.|
|Central IT operations (Core)|Across all resources.|Grant permissions to the central IT department (often the infrastructure team) to create, modify, and delete resources like virtual machines and storage.|
|Central networking group (Core and individual segments)|All network resources.|Ensure consistency and avoid technical conflicts, assign network resource responsibilities to a single central networking organization. These resources should include virtual networks, subnets, Network Security Groups (NSG), and the virtual machines hosting virtual network appliances. |
|Resource role permissions (Core)|-|For most core services, administrative privileges required are granted through the application (Active Directory, DNS/DHCP, System Management Tools). No additional Azure resource permissions are required. If your organizational model requires these teams to manage their own VMs, storage, or other Azure resources, you can assign these permissions to those roles.| 
|Security operations (Core and individual segments)|All resources.|Assess risk factors, identify potential mitigations, and advise organizational stakeholders who accept the risk.|
|IT operations (individual segments) |All resources.|Grant permission to create, modify, and delete resources. The purpose of the segment (and resulting permissions) will depend on your organization structure. <ul><li>Segments with resources managed by a centralized IT organization can grant the central IT department (often the infrastructure team) permission to modify these resources.</li><li>Segments managed by independent business units or functions (such as a Human Resources IT Team) can grant those teams permission to all resources in the segment.</li><li>Segments with autonomous DevOps teams don’t need to grant permissions across all resources because the resource role (below) grants permissions to application teams. For emergencies, use the service admin account (break-glass account).</li></ul>|
|Service admin (Core and individual segments)||Use the service admin role only for emergencies (and initial setup if required). Do not use this role for daily tasks.|


## See also
[Management groups](design-management-groups.md)

## Next steps
Start with this reference model and manage resources across multiple subscriptions consistently and efficiently with management groups. 
> [!div class="nextstepaction"]
> [Management groups](design-management-groups.md)