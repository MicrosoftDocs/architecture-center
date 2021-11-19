---
title: Roles, responsibilities, and permissions
description: Learn to define clear lines of responsibility and establish separation of duties as part of Azure identity and access management.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
categories:
  - management-and-governance
  - security
ms.custom:
  - article
---

# Roles, responsibilities, and permissions

In an organization, several teams work together to make sure that the workload and the supporting infrastructure are secure. To avoid confusion that can create security risks, define clear lines of responsibility and separation of duties.

Based on Microsoft's experience with many cloud adoption projects, establishing clearly defined roles and responsibilities for specific functions in Azure will avoid confusion that can lead to human and automation errors creating security risk.

## Clear lines of responsibility

**Do the teams have a clear view on responsibilities and individual/group access levels?**
***

Designate the parties responsible for specific functions in Azure.

Clearly documenting and sharing the contacts responsible for each of these functions will create consistency and facilitate communication. Based on our experience with many cloud adoption projects, this will avoid confusion that can lead to human and automation errors that create security risk.

Designate groups (or individual roles) that will be responsible for key functions.

|Group or individual role| Responsibility|
|---|---|
| **Network Security**                 | *Typically existing network security team.* Configuration and maintenance of Azure Firewall, Network Virtual Appliances (and associated routing), Web Application Firewall (WAF), Network Security Groups, Application Security Groups (ASG), and other cross-network traffic. |
| **Network Management**               | *Typically existing network operations team.* Enterprise-wide virtual network and subnet allocation. |
| **Server Endpoint Security**         | *Typically IT operations, security, or jointly.* Monitor and remediate server security (patching, configuration, endpoint security). |
| **Incident Monitoring and Response** | *Typically security operations team.* Incident monitoring and response to investigate and remediate security incidents in Security Information and Event Management (SIEM) or source console such as Microsoft Defender for Cloud Azure AD Identity Protection.|
| **Policy Management**                | *Typically GRC team + Architecture.* Apply governance based on risk analysis and compliance requirements. Set direction for use of Azure role-based access control (Azure RBAC), Microsoft Defender for Cloud, Administrator protection strategy, and Azure Policy to govern Azure resources. |
| **Identity Security and Standards**  | *Typically Security Team + Identity Team jointly.* Set direction for Azure AD directories, PIM/PAM usage, MFA, password/synchronization configuration, Application Identity Standards. |

> [!NOTE]
> Application roles and responsibilities should cover different access level of each operational function. For example, publish production release, access customer data, manipulate database records, and so on. Application teams should include central functions listed in the preceding table.

## Assign permissions

Grant roles the appropriate permissions that start with least privilege and add more based on your operational needs. Provide clear guidance to your technical teams that implement permissions. This clarity makes it easier to detect and correct that reduces human errors such as overpermissioning.

-  Assign permissions at management group for the segment rather than the individual subscriptions. This will drive consistency and ensure application to future subscriptions. In general, avoid granular and custom permissions.

- Consider the built-in roles in Azure before creating custom roles to grant the appropriate permissions to VMs and other objects.

- **Security managers** group membership may be appropriate for smaller teams/organizations where security teams have extensive operational responsibilities.

When assigning permissions for a segment, consider consistency while allowing flexibility to accommodate several organizational models. These models can range from a single centralized IT group to mostly independent IT and DevOps teams.

### Reference model example

This section uses this [Reference model](design-segmentation.md#reference-model) to demonstrate the considerations for assigning permissions for different segments. Microsoft recommends starting from these models and adapting to your organization.

#### Core services reference permissions

This segment hosts shared services utilized across the organization. These shared services typically include Active Directory Domain Services, DNS/DHCP, System Management Tools hosted on Azure Infrastructure as a Service (IaaS) virtual machines.

![Conceptual art showing reference permissions](images/ref-perms.png)

**Security Visibility across all resources:** For security teams, grant read-only access to security attributes for all technical environments. This access level is needed to assess risk factors, identify potential mitigations, and advise organizational stakeholders who accept the risk. See
[Security Team Visibility](#security-team-visibility) for more details.

**Policy management across some or all resources:** To monitor and enforce compliance with external (or internal) regulations, standards, and security policy, assign appropriate permission to those roles. The roles and permissions you choose will depend on the organizational culture and expectations of the policy program. See [Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/govern/security-baseline).

Before defining the policies, consider:
- How is the organization's security audited and reported? Is there mandatory reporting?
- Are the existing security practices working?
- Are there any requirements specific to industry, government, or regulatory requirements?

Designate group(s) (or individual roles) for central functions that affect shared services and applications.

After the policies are set, continuously improve those standards incrementally. Make sure that the security posture doesn't degrade over time by having auditing and monitoring compliance. For information about managing security standards of an organization, see [governance, risk, and compliance (GRC)](/azure/cloud-adoption-framework/migrate/azure-best-practices/governance-or-compliance).

**Central IT operations across all resources:** Grant permissions to the central IT department (often the infrastructure team) to create, modify, and delete resources like virtual machines and storage. **Contributor** or **Owner** roles are appropriate for this function.

**Central networking group across network resources:** To ensure consistency and avoid technical conflicts, assign network resource responsibilities to a single central networking organization. These resources should include virtual networks, subnets, Network Security Groups (NSG), and the virtual machines hosting virtual network appliances. Assign network resource responsibilities to a single central networking organization. The **Network Contributor** role is appropriate for this group. See [Centralize Network Management And Security](/azure/architecture/framework/security/design-network-segmentation#centralize-network-management-and-security) for more details

**Resource Role Permissions:** For most core services, administrative privileges required to manage them are granted through the application (Active Directory, DNS/DHCP, System Management Tools), so no additional Azure resource permissions are required. If your organizational model requires these teams to manage their own VMs, storage, or other Azure resources, you can assign these permissions to those roles.

Workload segments with autonomous DevOps teams will manage the resources associated with each application. The actual roles and their permissions depend on the application size and complexity, the application team size and complexity, and the culture of the organization and application team.

**Service admin (Break Glass Account):** Use the **Service Administrator** role only for emergencies and initial setup. Do not use this role for daily tasks. See [Emergency Access ('Break Glass' Accounts)](/azure/architecture/framework/security/design-admins#emergency-access-or-break-glass-accounts) for more details.

#### Segment reference permissions

This segment permission design provides consistency while allowing flexibility to accommodate the range of organizational models from a single centralized IT group to mostly independent IT and DevOps teams.

![Diagram showing segment Permissions.](images/ref-segment.png)

**Security visibility across all resources:** For security teams, grant read-only access to security attributes for all technical environments. This access level is needed to assess risk factors, identify potential mitigations, and advise organizational stakeholders who accept the risk. See
[Security Team Visibility](#security-team-visibility).

**Policy management across some or all resources:** To monitor and enforce compliance with external (or internal) regulations, standards, and security policy assign appropriate permission to those roles. The roles and permissions you choose will depend on the organizational culture and expectations of the policy program. See [Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/govern/security-baseline).

**IT Operations across all resources:** Grant permission to create, modify, and delete resources. The purpose of the segment (and resulting permissions) will depend on your organization structure.

- Segments with resources managed by a centralized IT organization can grant the central IT department (often the infrastructure team) permission to modify these resources.

- Segments managed by independent business units or functions (such as a Human Resources IT Team) can grant those teams permission to all resources in the segment.

- Segments with autonomous DevOps teams don't need to grant permissions across all resources because the resource role (below) grants permissions to application teams. For emergencies, use the service admin account (break-glass account).

**Central networking group across network resources:** To ensure consistency and avoid technical conflicts, assign network resource responsibilities to a single central networking organization. These resources should include virtual networks, subnets, Network Security Groups (NSG), and the virtual machines hosting virtual network appliances. See [Centralize Network Management And Security](/azure/architecture/framework/security/design-network-segmentation#centralize-network-management-and-security).

**Resource Role Permissions:** Segments with autonomous DevOps teams will manage the resources associated with each application. The actual roles and their permissions depend on the application size and complexity, the application team size and complexity, and the culture of the organization and application team.

**Service Admin (Break Glass Account):** Use the service admin role only for emergencies (and initial setup if required). Do not use this role for daily tasks. See [Emergency Access ('Break Glass' Accounts)](/azure/architecture/framework/security/design-admins#emergency-access-or-break-glass-accounts) for more details.

## Security team visibility

An application team needs to be aware of security initiatives to align their security improvement plans with the outcome of those activities. Provide security teams read-only access to the security aspects of all technical resources in their purview.

Security organizations require visibility into the technical environment to perform their duties of assessing and reporting on organizational risk. Without this visibility, security will have to rely on information provided from groups, operating the environment, which have potential conflict of interest (and other priorities).

Note that security teams may separately be granted additional privileges if they have operational responsibilities or a requirement to enforce compliance on Azure resources.

For example in Azure, assign security teams to the **Security Readers** permission that provides access to measure security risk (without providing access to the data itself).

For enterprise security groups with broad responsibility for security of Azure, you can assign this permission using:

- *Root management group* – for teams responsible for assessing and reporting risk on all resources

- *Segment management group(s)* – for teams with limited scope of responsibility (typically required because of organizational boundaries or regulatory requirements)

> [!IMPORTANT]
> Because security will have broad access to the environment (and visibility into potentially exploitable vulnerabilities), treat security teams as critical impact accounts and apply the same protections as administrators. The [Administration](/azure/architecture/framework/security/design-admins) section details these controls for Azure.

**Suggested actions**

- Define a process for aligning communication, investigation, and hunting activities with the application team.
- Following the principle of least privilege, establish access control to all cloud environment resources for security teams with sufficient access to gain required visibility into the technical environment and to perform their duties of assessing, and reporting on organizational risk.

**Learn more**

[Engage your organization's security team](/azure/security/develop/secure-dev-overview#engage-your-organizations-security-team)

## Manage connected tenants

Does your security team have visibility into all existing subscriptions and cloud environments? How do they discover new ones?

Ensure your security organization is aware of all enrollments and associated subscriptions connected to your existing environment (via ExpressRoute or Site-Site VPN) and monitoring as part of the overall enterprise.

These Azure resources are part of your enterprise environment and security organizations require visibility into them. Security organizations need this access to assess risk and to identify whether organizational policies and applicable regulatory requirements are being followed.

The organizations' cloud infrastructure should be well documented, with security team access to all resources required for monitoring and insight. Frequent scans of the cloud-connected assets should be performed to ensure no additional subscriptions or tenants have been added outside of organizational controls. Regularly review Microsoft guidance to ensure security team access best practices are consulted and followed.

### Suggested actions

Ensure all Azure environments that connect to your production environment and network apply your organization's policy, and IT governance controls for security.

You can discover existing connected tenants using a
[tool](/azure/role-based-access-control/elevate-access-global-admin?toc=%252fazure%252factive-directory%252fprivileged-identity-management%252ftoc.json) provided by Microsoft. Guidance on permissions

## Next steps

Restrict access to Azure resources based on a need-to-know basis starting with the principle of least privilege security and add more based on your operational needs.

> [!div class="nextstepaction"]
> [Azure control plane security](design-identity-control-plane.md)

## Related links

For considerations about using management groups to reflect the organization's structure within an Azure Active Directory (Azure AD) tenant, see [CAF: Management group and subscription organization](/azure/cloud-adoption-framework/ready/enterprise-scale/management-group-and-subscription-organization).

> Back to the main article: [Azure identity and access management considerations](design-identity.md)
