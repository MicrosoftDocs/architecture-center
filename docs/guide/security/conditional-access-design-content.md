In this article, you'll learn about design principles and dependencies for a Conditional Access scenario that's based on Zero Trust.

## Design principles

We'll start out with some design principles.

### Conditional Access as a Zero-Trust policy engine

The Microsoft approach to Zero Trust includes Conditional Access as the main policy engine. Here's an overview of that approach:

 ![Diagram that provides an overview of the Zero Trust model.](./images/zero-trust-model.png)

visio 

 Conditional Access is used as the policy engine for a Zero-Trust architecture that covers both policy definition and policy enforcement. Based on various signals or conditions, Conditional Access can block or give limited access to resources, as shown here:

 ![Diagram that provides an overview of the Conditional Access signal, decision, enforcement path.](./images/conditional-access-signals.png)

 Here's a more detailed view of the elements of Conditional Access what it covers:

 ![ZT User Access](./images/user-access.png)

 The figure shows Conditional Access and related elements that can protect access to resources for users (as opposed to non-interactive/non-human access) as shown in the figure below.

 ![CA Identity Types](./images/conditional-access-identity.svg)

The non-human access to resources also must be protected. Expect this document to be changed to reflect any such potential changes in the CA policy engine as/if they arrive. Meanwhile, non-human identities accessing cloud resources must be protected by other means (like grant controls for OAuth based access).

Note! As per medio November, Microsoft now provides a preview for targeting service principals and protect access to resources for such machine/workload identities based on location. See persona section for more details.

### Enterprise Access Model

In the past, Microsoft has provided guidance and principles for access to on-premises resources based on a tiering model, where Domain Controllers, PKI, ADFS servers and management solutions managing these servers are considered Tier 0, servers hosting applications are considered Tier 1 and client devices are considered Tier 2.

This model is still relevant for on-premises resources, but when we discuss protecting access to resources in the cloud, Microsoft suggests developing an access control strategy that

- Is comprehensive and consistent
- Rigorously applies security principles throughout the technology stack
- Is flexible enough to meet the needs of the organization

Based on these principles, Microsoft has formed the following the Enterprise Access Model shown below.

![Enterprise Access Model](./images/enterprise-access-model.png)

The enterprise access model supersedes and replaces the legacy tier model that was focused on containing unauthorized escalation of privilege in an on-premises Windows Server Active Directory environment. Tier 0 expands to become the control plane, Tier 1 consists of the management and data plane and Tier 2 covers user and app access.

Microsoft suggests moving the control and management plane up into being cloud services using Conditional Access as the main control plane and policy engine, thus defining and enforcing access.

The Azure Active Directory CA policy engine can be extended to other policy enforcement points, including:

- Modern applications: Applications that use modern authentication protocols.
- Legacy applications: Via Azure AD Application Proxy.
- VPN and remote access solutions: Such as Microsoft Always-On, Cisco AnyConnect, Palo Alto Networks, F5, Fortinet, Citrix, and Zscaler.
- Documents, email, and other files: Via Microsoft Information Protection.
- SaaS applications:

### Zero Trust Principles

Based on experiences from having worked with various enterprise customers, it seems that the three main Zero Trust principles that Microsoft defines are well understood and makes sense, especially for security departments. However, sometimes, it is overlooked how important the usability is when designing Zero Trust solutions.

Based on experiences from having worked with various enterprise customers, it seems that the three main Zero Trust principles that Microsoft defines are well understood and makes sense, especially for security departments. However, sometimes, it is overlooked how important the usability is when designing Zero Trust solutions.

The figure below emphasize that the usability should always be considered as an implicit principle and shows a few examples of where usability can be improved as you implement solutions based on Zero Trust.

### Conditional Access Principles

Based on all this, we summarize the suggested principles. Microsoft recommends creating an access model based on Conditional Access that is aligned with Microsoft’s three main Zero Trust principles.

**Verify explicitly**

- Move control plane to the cloud (Integrate app with AAD and protect using Conditional Access)
- Consider all clients as external (even so you are connected to Corp net)
Least privileged access
- Evaluate access based on compliance and risk (including user risk, sign-in risk and device risk)
- Use the following access priorities
  - Access the resource directly protected by Conditional Access
  - Publish access to resource using Azure AD Application Proxy, protected by Conditional Access
  - Use CA based VPN to get access to the resource, restrict access to be on a per-app/DNS name
  
**Assume Breach**

- Segment network infrastructure
- Minimize use of Enterprise PKI
- Migrate SSO from ADFS to PHS
- Minimize dependencies on DCs using “Cloud KDC” (Kerberos KDC provided in Azure AD)
- Move management plane to the cloud (Manage devices with MEM)

Further, some additional and more detailed principles and recommended practices for Conditional Access

- Apply Zero Trust principles to Conditional Access
- Use report-only mode before putting a policy into production.
- Test both positive and negative scenarios
- Use change and revision control on CA policies
- Automate the management of CA policies using tools like Azure DevOps/GitHub or Logic Apps
- Limited use of block mode for general access, only if/where needed
- Assure all applications and platform are protected (CA has no implicit "deny all")
- Protect privileged users in all M365 RBAC systems
- Require password change and MFA for high-risk users and sign-ins
- Restrict access from devices with high risk (Intune compliance policy with compliance check in Conditional Access)
- Protect privileged systems (like Azure Mgt. Portal, AWS, GCP)
- Prevent persistent browser sessions for admins and on untrusted devices
- Block legacy authentication
- Restrict access from unknown or unsupported device platforms
- Restrict strong credential registration
- Consider using default session policy that allows sessions to continue working in case of outage given the satisfied the conditions before the outage

## Design dependencies and related areas

The figure below shows dependencies and related areas. Some of the areas are pre-requisites for CA and others are areas that depend on CA being in place. The design described in this document mainly focuses on CA itself and not on any of the related areas.

![CA Dependencies](./images/conditional-access-dependencies.svg)

## Next Steps

In the next sub-section we will look at the conceptual Conditional Access design based on Zero Trust and personas.

## Related resources