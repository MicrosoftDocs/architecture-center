<!-- TEMPLATE FILE - DO NOT ADD METADATA -->
<!-- markdownlint-disable MD002 MD041 -->

## Dependent decisions

The following decisions come from teams outside of the cloud governance team. The implementation of each will come from those same teams. However, the cloud governance team is responsible for implementing a solution to validate that those implementations are consistently applied.

### Identity Baseline

Identity Baseline is the fundamental starting point for all governance. Before attempting to apply governance, identity must be established. The established identity strategy will then be enforced by the governance solutions.
In this governance guide, the Identity Management team implements the **[Directory Synchronization](/azure/architecture/cloud-adoption/decision-guides/identity/overview#directory-synchronization)** pattern:

- RBAC will be provided by Azure Active Directory (Azure AD), using the directory synchronization or "Same Sign-On" that was implemented during company’s migration to Office 365. For implementation guidance, see [Reference Architecture for Azure AD Integration](/azure/architecture/reference-architectures/identity/azure-ad).
- The Azure AD tenant will also govern authentication and access for assets deployed to Azure.

In the governance MVP, the governance team will enforce application of the replicated tenant through subscription governance tooling, discussed later in this article. In future iterations, the governance team could also enforce rich tooling in Azure AD to extend this capability.

### Security Baseline: Networking

Software Defined Network is an important initial aspect of the Security Baseline. Establishing the governance MVP depends on early decisions from the Security Management team to define how networks can be safely configured.

Given the lack of requirements, IT security is playing it safe and has required a **[Cloud DMZ](/azure/architecture/cloud-adoption/decision-guides/software-defined-network/cloud-dmz)** Pattern. That means governance of the Azure deployments themselves will be very light.

- Azure subscriptions may connect to an existing datacenter via VPN, but must follow all existing on-premises IT governance policies regarding connection of a demilitarized zone to protected resources. For implementation guidance regarding VPN connectivity, see [VPN Reference Architecture](/azure/architecture/reference-architectures/hybrid-networking/vpn).
- Decisions regarding subnet, firewall, and routing are currently being deferred to each application/workload lead.
- Additional analysis is required before releasing of any protected data or mission-critical workloads.

In this pattern, cloud networks can only connect to on-premises resources over an existing VPN that is compatible with Azure. Traffic over that connection will be treated like any traffic coming from a demilitarized zone. Additional considerations may be required on the on-premises edge device to securely handle traffic from Azure.

The cloud governance team has proactively invited members of the networking and IT security teams to regular meetings, in order to stay ahead of networking demands and risks.

### Security Baseline: Encryption

Encryption is another fundamental decision within the Security Baseline discipline. Because the company currently does not yet store any protected data in the cloud, the Security Team has decided on a less aggressive pattern for encryption.
At this point, a **[cloud-native pattern for encryption](/azure/architecture/cloud-adoption/decision-guides/encryption/overview#key-management)** is suggested but not required of any development team.

- No governance requirements have been set regarding the use of encryption, because the current corporate policy does not permit mission-critical or protected data in the cloud.
- Additional analysis will be required before releasing any protected data or mission-critical workloads.

## Policy enforcement

The first decision to make regarding Deployment Acceleration is the pattern for enforcement. In this narrative, the governance team decided to implement the **[Automated Enforcement](/azure/architecture/cloud-adoption/decision-guides/policy-enforcement/overview#automated-enforcement)** pattern.

- Azure Security Center will be made available to the security and identity teams to monitor security risks. Both teams are also likely to use Security Center to identify new risks and improve corporate policy.
- RBAC is required in all subscriptions to govern authentication enforcement.
- Azure Policy will be published to each management group and applied to all subscriptions. However, the level of policies being enforced will be very limited in this initial Governance MVP.
- Although Azure management groups are being used, a relatively simple hierarchy is expected.
- Azure Blueprints will be used to deploy and update subscriptions by applying RBAC requirements, Resource Manager Templates, and Azure Policy across management groups.

## Applying the dependent patterns

The following decisions represent the patterns to be enforced through the policy enforcement strategy above:

**Identity Baseline.** Azure Blueprints will set RBAC requirements at a subscription level to ensure that consistent identity is configured for all subscriptions.

**Security Baseline: Networking.** The cloud governance team maintains a Resource Manager template for establishing a VPN gateway between Azure and the on-premises VPN device. When an application team requires a VPN connection, the cloud governance team will apply the gateway Resource Manager template via Azure Blueprints.

**Security Baseline: Encryption.** At this point, no policy enforcement is required in this area. This will be revisited during later iterations.
