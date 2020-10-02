---
title: Security management groups
description: Strategies using management groups to manage resources across multiple subscriptions consistently and efficiently.
author: PageWriter-MSFT
ms.date: 09/07/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Security management groups

Management groups can manage resources across multiple subscriptions consistently and efficiently. However, due to its flexibility, your design can become complex and compromise security and operations.

The recommendations in this article are based on an example reference model. Start with this model and adapt it to your organization’s needs. For more information, see [Enterprise segmentation strategy](design-segmentation.md).

## Support your segmentation strategy with management groups

It's recommended that you align the top level of management groups into a simple enterprise segmentation strategy and limit the levels to no more than two. 

In the example reference, there are enterprise-wide resources used by all segments, a set of core services that share services, additional segments for each workload. 

![Core services](images/ref-perms.png)


![Segment services](images/ref-segment.png)

The recommended approach is to use these management groups:

- Root management group for enterprise-wide resources.

    Use the root management group to include identities that have the requirement to apply policies across every resource. For example, regulatory requirements, such as restrictions related to data sovereignty. This group is effective in by applying policies, permissions, tags, across all subscriptions. 

- Management group for each workload segment.

    Use a separate management group for teams with limited scope of responsibility. This group is typically required because of organizational boundaries or regulatory requirements.

- Root or segment management group for the core set of services.  


## Azure role-based access control (RBAC) role assignment 

Grant roles the appropriate permissions that start with least privilege and add more based your operational needs. Provide clear guidance to your technical teams that implement permissions. This clarity makes it easier to detect and correct that reduces human errors such as overpermissioning.

-  Assign permissions at management group for the segment rather than the individual subscriptions. This will drive consistency and ensure application to future subscriptions.

- Consider the built-in roles before creating custom roles to grant the appropriate permissions to VMs and other objects. 
- **Security managers** group membership may be appropriate for smaller teams/organizations where security teams have extensive operational responsibilities. 

When assigning permissions for a segment, consider consistency while allowing flexibility to accommodate several organizational models. These models can range from a single centralized IT group to mostly independent IT and DevOps teams.  

The reference model has several groups assigned for core services and workload segments.  Here are some other considerations when assigning permissions for the common teams across those segments.

### Security team's visibility

Grant read-only access to security attributes for all technical environments. Assign security teams with the **Security Readers** permission that provides access needed to assess risk factors, identify potential mitigations, without providing access to the data.

You can assign this permission by using:
- Root management group – for teams responsible for assessing and reporting risk on all resources.
- Segment management group(s) – for teams with limited scope of responsibility. This group is typically required because of organizational boundaries or regulatory requirements.

> [!IMPORTANT] 
> Treat security teams as critical impact accounts and apply the same protections as administrators.

### Policy management across some or all resources 

Assign appropriate permission to roles that monitor and enforce compliance with external (or internal) regulations, standards, and security policy. The roles and permissions you choose will depend on the organizational culture and expectations of the policy program. 

The reference model assigns **Read Contributor** permissions to roles related to policy management.

### Central IT operations across all resources

Grant permissions to the central IT department (often the infrastructure team) to create, modify, and delete resources like virtual machines and storage. **Contributor** or **Owner** roles are appropriate for this function.

### Central networking group across network resources

Assign network resource responsibilities to a single central networking organization. 
The **Network Contributor** role is appropriate for this group.

### IT Operations across all resources

Grant permission to create, modify, and delete resources that belong to a segment. The purpose of the segment (and resulting permissions) will depend on your organization structure. 
- Segments with resources managed by a centralized IT organization can grant the central IT department (often the infrastructure team) permission to modify these resources. 
- Segments managed by independent business units or functions (such as a Human Resources IT Team) can grant those teams permission to all resources in the segment. 
- Segments with autonomous DevOps teams don’t need to grant permissions across all resources because the resource role (below) grants permissions to application teams. For emergencies, use the service admin account (break-glass account). 

### Resource role permissions

For most core services, administrative privileges required to manage them are granted through the application (Active Directory, DNS/DHCP, System Management Tools), so no additional Azure resource permissions are required. If your organizational model requires these teams to manage their own VMs, storage, or other Azure resources, you can assign these permissions to those roles. 

Workload segments with autonomous DevOps teams will manage the resources associated with each application. The actual roles and their permissions depend on the application size and complexity, the application team size and complexity, and the culture of the organization and application team. 

### Break-glass account
Use the **Service Administrator** role only for emergencies and initial setup. Do not use this role for daily tasks.  


## Use root management group with caution
Use the root management group to drive consistency across the enterprise by applying policies, permissions, tags, across all subscriptions. This group can affect every all resources on Azure and potentially cause downtime or other negative impacts. 

Select enterprise-wide identities that have a clear requirement to be applied across every resources. These requirements could be for regulatory reasons. Also, select identities that have near-zero negative impact on operations. For example, policy with audit effect, tag assignment, RBAC permissions assignments that have been carefully reviewed.

Use a dedicated service principal name (SPN) to execute management group management operations, subscription management operations, and role assignment. SPN reduces the number of users who have elevated rights and follows least-privilege guidelines. Assign the **User Access Administrator** at the root management group scope (/) to grant the SPN just mentioned access at the root level. After the SPN is granted permissions, the **User Access Administrator** role can be safely removed. In this way, only the SPN is part of the **User Access Administrator** role.

Assign **Contributor** permission to the SPN, which allows tenant-level operations. This permission level ensures that the SPN can be used to deploy and manage resources to any subscription within your organization.

Limit the number of Azure Policy assignments made at the root management group scope (/). This limitation minimizes debugging inherited policies in lower-level management groups.

Don't create any subscriptions under the root management group. This hierarchy ensures that subscriptions don't only inherit the small set of Azure policies assigned at the root-level management group, which don't represent a full set necessary for a workload.
    
> [!IMPORTANT] 
> Test all enterprise-wide changes on the root management group before applying (policy, tags, RBAC model, and so on). You can use a test lab. This can be representative lab tenant or lab segment in production tenant. Another option is to use a production pilot. This can be a segment management group or designated subset in subscription(s) management group. Validate changes to make sure the requirements have the desired effect.


