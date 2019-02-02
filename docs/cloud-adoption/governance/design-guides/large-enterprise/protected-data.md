---
title: "Fusion: Large Enterprise – Security baseline evolution "
description: Large Enterprise – Security baseline evolution 
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Large Enterprise – Security Baseline evolution

This article evolves the narrative by adding security controls that support moving protected data to the cloud.

## Evolution of the narrative

The CIO has spent months collaborating with colleagues and the company’s legal staff. A management consultant with expertise in cybersecurity was engaged to help the existing IT Security and IT Governance teams draft a new policy regarding protected data. The group was able to foster board support to replace the existing policy, allowing PII and financial data to be hosted by approved cloud providers. This required adopting a set of security requirements and a governance process to verify and document adherence to those policies.

For the past 12 months, the cloud adoption teams have cleared most of the 5,000 assets from the two datacenters to be retired. The 350 incompatible assets were moved to an alternate datacenter. Only the 1,250 virtual machines that contain protected data remain. 

### Evolution of the Cloud Governance team

The Cloud Governance team continues to evolve along with the narrative. The two founding members of the team are now among the most respected cloud architects in the company. The collection of configuration scripts has grown as new teams tackle innovative new deployments. The Cloud Governance team has also grown. Most recently, members of the IT Operations team have joined Cloud Governance team activities to prepare for cloud operations. The cloud architects who helped foster this community are seen both as cloud guardians and cloud accelerators.

While the difference is subtle, it is an important distinction when building a governance-focused IT culture. A cloud custodian cleans up the messes made by innovative cloud architects, and the two roles have natural friction and opposing objectives. A cloud guardian helps keep the cloud safe, so other cloud architects can move more quickly with fewer messes. A cloud accelerator performs both functions but is also involved in the creation of templates to accelerate deployment and adoption, becoming an innovation accelerator as well as a defender of the five cloud disciplines.

### Evolution of the current state

In the previous phase of this narrative, the company had begun the process of retiring two datacenters. This ongoing effort includes migrating some applications with legacy authentication requirements, which required an evolution of the Identity Baseline, described in the [previous article](identity-baseline.md).

Since then, some things have changed that will affect governance:

- Thousands of IT and business assets have been deployed to the cloud.
- The application development team has implemented a continuous integration and continuous deployment (CI/CD) pipeline to deploy a cloud native application with an improved user experience. That application doesn’t interact with protected data yet, so it’s not production ready.
- The Business Intelligence team within IT actively curates data in the cloud from logistics, inventory, and third-party data. This data is being used to drive new predictions, which could shape business processes. However, those predictions and insights are not actionable until customer and financial data can be integrated into the data platform.
- The IT team is progressing on the CIO and CFO's plans to retire two datacenters. Almost 3,500 of the assets in the two datacenters have been retired or migrated.
- The policies regarding PII and financial data have been modernized. However, the new corporate policies are contingent upon the implementation of related security and governance policies. Teams are still stalled.

### Evolution of the future state

- Early experiments from the application development and BI teams have shown potential improvements in customer experiences and data-driven decisions. Both teams would like to expand adoption of the cloud over the next 18 months by deploying those solutions to production. 
- IT has developed a business justification to migrate five more datacenters to Azure, which will further decrease IT costs and provide greater business agility. While smaller in scale, the retirement of those datacenters is expected to double the total cost savings.
- Capital expense and operational expense budgets have approved to implement the required security and governance policies, tools, and processes. The expected cost savings from the datacenter retirement are more than enough to pay for this new initiative. IT and business leadership are confident this investment will accelerate the realization of returns in other areas. The grassroots Cloud Governance team became a recognized team with dedicated leadership and staffing.
- Collectively, the cloud adoption teams, Cloud Governance team, IT Security team, and IT Governance team will implement security and governance requirements to allow cloud adoption teams to migrate protected data into the cloud.

## Evolution of tangible risks

**Data Breach**: There is an inherent increase in liabilities related to data breaches when adopting any new data platform. Technicians adopting cloud technologies have increased responsibilities to implement solutions which can decrease this risk. A robust security and governance strategy must be implemented to ensure those technicians fulfill those responsibilities.

This business risk can be expanded into a few technical risks:

- Mission-critical apps or protected data might be deployed unintentionally.
- Protected data might be exposed during storage due to poor encryption decisions.
- Unauthorized users might access protected data.
- External intrusion could result in access to protected data.
- External intrusion or denial of service attacks could cause a business interruption.
- Organization or employment changes could allow for unauthorized access to protected data.
- New exploits might create opportunities for intrusion or unauthorized access.
- Inconsistent deployment processes might result in security gaps that could lead to data leaks or interruptions.
- Configuration drift or missed patches might result in unintended security gaps that could lead to data leaks or interruptions.
- Disparate edge devices might increase network operations costs.
- Disparate device configurations might lead to oversights in configuration and compromises in security.
- The cyber security team insists there is a risk of vendor lock-in from generating encryption keys on a single cloud provider's platform. While this claim is unsubstantiated, it was accepted by the team for the time being.

## Evolution of the policy statements

The following changes to policy will help mitigate the new risks and guide implementation. The list looks long, but the adoption of these policies may be easier than it would appear.

1. All deployed assets must be categorized by criticality and data classification. Classifications are to be reviewed by the Cloud Governance team and the application before deployment to the cloud.
2. Applications that store or access protected data are to be managed differently than those that don’t. At a minimum, they should be segmented to avoid unintended access of protected data.
3. All protected data must be encrypted when at rest.
4. Elevated permissions in any segment containing protected data should be an exception. Any such exceptions will be recorded with the Cloud Governance team and audited regularly.
5. Network subnets containing protected data must be isolated from any other subnets. Network traffic between protected data subnets will be audited regularly.
6. No subnet containing protected data can be directly accessed over the public internet or across datacenters. Access to those subnets must be routed through intermediate subnet works. All access into those subnets must come through a firewall solution that can perform packet scanning and blocking functions.
7. Governance tooling must audit and enforce network configuration requirements defined by the Security Management team.
8. Governance tooling must limit VM deployment to approved images only.
9. Whenever possible, node configuration management should apply policy requirements to the configuration of any guest operating system. Node configuration management should respect the existing investment in Group Policy Object (GPO) for resource configuration.
10. Governance tooling will audit that automatic updates are enabled on all deployed assets. When possible, automatic updates will be enforced. When not enforced by tooling, node-level violations must be reviewed with operational management teams and remediated in accordance with operations policies. Assets that are not automatically updated must be included in processes owned by IT operations.
11. Creation of new subscriptions or management groups for any mission critical-applications or protected data requires a review from the Cloud Governance team to ensure proper blueprint assignment.
12. A least-privilege access model will be applied to any subscription that contains mission critical apps or protected data.
13. The cloud vendor must be capable of integrating encryption keys managed by the existing on-premises solution.
14. The cloud vendor must be capable of supporting the existing edge device solution and any required configurations to protect any publicly exposed network boundary.
15. The cloud vendor must be capable of supporting a shared connection to the global WAN, with data transmission routed through the existing edge device solution.
16. Trends and exploits that could affect cloud deployments should be reviewed regularly by the security team to provide updates to Security Baseline tooling used in the cloud.
17. Deployment tooling must be approved by the Cloud Governance team to ensure ongoing governance of deployed assets.
18. Deployment scripts must be maintained in a central repository accessible by the Cloud Governance team for periodic review and auditing.
19. Governance processes must include audits at the point of deployment and at regular cycles to ensure consistency across all assets.
20. Deployment of any applications that require customer authentication must use an approved identity provider that is compatible with the primary identity provider for internal users.
21. Cloud Governance processes must include quarterly reviews with Identity Baseline teams to identify malicious actors or usage patterns that should be prevented by cloud asset configuration.

## Evolution of the best practices

This section of the article will evolve the Governance MVP design to include new Azure Policies and an implementation of Azure Cost Management. Together, these two design changes will fulfill the new corporate policy statements.

The new best practices fall into two categories: Corporate IT (Hub) and Cloud Adoption (Spoke).

**Establishing a corporate IT hub/spoke subscription to centralize the security baseline**: In this best practice, the existing governance capacity is wrapped by a [Hub Spoke Topology with Shared Services][shared-services], with a few key additions from the Cloud Governance team.

1. Azure DevOps repository. Create a repository in Azure DevOps to store and version all relevant Azure Resource Manager templates and scripted configurations
2. Hub-Spoke template.
    1. The guidance in the [Hub-Spoke with Shared Services Reference Architecture][shared-services] can be used to generate Azure Resource Manager Templates for the assets required in a corporate IT hub.
    2. Using those templates, this structure can be made repeatable, as part of a central governance strategy.
    3. In addition to the current reference architecture, it is advised that a Network Security Group (NSG) template should be created capturing any port blocking or whitelisting requirements for the VNet to host the firewall. This NSG will differ from prior NSGs, because it will be the first NSG to allow public traffic into a VNet.
3. Create Azure Policies. Create an Azure Policy named "Hub NSG enforcement" to enforce the configuration of the NSG assigned to any VNet created in this subscription. Apply the built-in Policies for guest configuration as follows:
    1. Audit that Windows Web Servers are using secure communication protocols.
    2. Audit that password security settings are set correctly inside Linux and Windows machines.
4. Corporate IT Blueprint.
    1. Create an Azure Blueprint called "Corporate IT Subscription."
    2. Add the hub/spoke templates and Hub NSG policy.
5. Expanding on initial Management Group Hierarchy.
    1. For each management group that has requested support for protected data, the "Corporate IT Subscription" Blueprint provides an accelerated hub solution.
    2. Because management groups in this fictional example include a regional hierarchy in addition to a business unit hierarchy, this blueprint will be deployed in each region.
    3. For each region in the Management Group hierarchy, create a subscription called "Corporate IT Subscription".
    4. Apply the "Corporate IT Subscription" blueprint to each regional instance.
    5. This will establish a hub for each business unit in each region. Note: Further cost savings could be achieved, but sharing hubs across business units in each region.
6. Integrate Group Policy Objects (GPO) through Desired State Configuration (DSC):
    1. Convert GPO to DSC – The [Microsoft Baseline Management project](https://github.com/Microsoft/BaselineManagement) in Github can accelerate this effort. * Be sure to store DSC in the repository in parallel to Resource Manager Templates.
    2. Deploy Azure Automation State Configuration to any instances of the Corporate IT Subscription. Azure automation can be used to apply DSC to VMs deployed in supported subscriptions within the Management Group.
    3. The current roadmap plans to enable custom Guest Configuration policies. When that feature is released, the use of Azure Automation in this best practice will no longer be required.

**Applying additional governance to a Cloud Adoption Subscription (Spoke)**: Building on the "Corporate IT Subscription", minor changes to the Governance MVP applied to each subscription dedicated to the support of application archetypes can produce rapid evolution. 

In prior evolutions of the best practice, NSGs were defined which blocked public traffic and whitelisted internal traffic. Additionally, the Azure Blueprint temporarily created DMZ and Active Directory capabilities. In this evolution, we will tweak those assets a bit, creating a new version of the Azure Blueprint.

1. Network Peering Template. This template will peer the VNet in each subscription with the Hub VNet in the Corporate IT subscription.
    1. The guidance from the prior section, [Hub-Spoke with Shared Services Reference Architecture][shared-services] generated a Resource Manager template for enabling VNet peering.
    2. That template can be used as a guide to modify the DMZ template from the prior governance evolution.
    3. Essentially, we are now adding VNet peering to the DMZ VNet that was previously connected to the local edge device over VPN. 
    4. *** It is also advised that the VPN should be removed from this template as well to ensure no traffic is routed directly to the on-premises datacenter, without passing through the Corporate IT Subscription and Firewall solution.
    5. Additional [network configuration](/azure/automation/automation-dsc-overview#network-planning) will be required by Azure Automation to apply DSC to hosted VMs.
2. Modify the NSG. Block all public AND direct on-premises traffic in the NSG. The only inbound traffic should be coming through the VNet peer in the corporate IT subscription.
    1. In the prior evolution, an NSG was created blocking all public traffic and whitelisting all internal traffic. Now we want to shift this NSG a bit.
    2. The new NSG configuration, should block all public traffic and all traffic from the local datacenter.
    3. Traffic entering this VNet should only come from the VNet on the other side of the VNet peer.
3. Azure Security Center implementation
    1. Configure Azure Security Center for any management group that contains protected data classifications.
    2. Set Automatic provisioning to on by default to ensure patching compliance.
    3. Establish OS security configurations. IT Security to define the configuration.
    4. Support IT Security in the initial use of Azure Security Center. Transition use of security center to IT security, but maintain access for governance continuous improvement purposes
    5. Create an Azure Resource Manager Template reflecting the changes required for Azure Security Center configuration within a subscription.
4. Update Azure Policy for all subscriptions.
    1. Audit and enforce criticality and data classification across all management groups and subscriptions to identify any subscriptions with protected data classifications.
    2. Audit and enforce use of approved OS images only.
    3. Audit and enforce guest configurations based on security requirements for each node.
5. Update Azure Policy for all subscriptions that contains protected data classifications.
    1. Audit and enforce use of standard roles only
    2. Audit and enforce application of encryption for all storage accounts and files at rest on individual nodes.
    3. Audit and enforce the application of the new version of the DMZ NSG.
    4. Audit and enforce use of approved network subnet and VNet per network interface.
    5. Audit and enforce the limitation of user-defined routing tables.
6. Azure Blueprint
    1. Create a new Azure Blueprint called "Protected Data."
    2. Add the VNet peer, NSG, and Azure Security Center templates to the blueprint.
    3. Ensure the template for Active Directory from the previous evolution is NOT included in the blueprint. Any dependencies on Active Directory will be provided by the Corporate IT subscription.
    4. Terminate any existing Active Directory VMs deployed in the previous evolution.
    5. Add the new policies for protected data subscriptions.
    6. Publish the Azure Blueprint to any management group intended to host protected data.
    7. Apply the new blueprint to each affected subscription along with existing blueprints.

## Conclusion

The addition of the above processes and changes to the Governance MVP help to mitigate many of the risks associated with security governance. Together, they add the network, identity, and security monitoring tools needed to protect data.

## Next steps

As cloud adoption continues to evolve and deliver additional business value, risks and cloud governance needs also evolve. For the fictitious company in this journey, the next step is to support mission-critical workloads. This is the point when resource consistency controls are needed.

> [!div class="nextstepaction"]
> [Resource consistency evolution](./mission-critical.md)

<!-- links -->

[shared-services]: ../../../../reference-architectures/hybrid-networking/shared-services.md