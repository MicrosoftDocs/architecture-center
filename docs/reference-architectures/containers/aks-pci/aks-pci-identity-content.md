This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

Kubernetes has native role-based access control (RBAC) that manages permissions to the Kubernetes API. There are several built-in roles with specific permissions or actions on Kubernetes resources. Azure Kubernetes Service (AKS) supports those built-in roles and custom roles for granular control. Those actions can be authorized (or denied) to a user through Kubernetes RBAC.

Azure Kubernetes Service (AKS) is fully integrated with Azure Active Directory (AD) as the identity provider. You don't have to manage separate user identities and credentials for Kubernetes. You can add Azure AD users for Kubernetes RBAC. This integration makes it possible to do role assignments to Azure AD users.

For more information, see [Use Azure RBAC for Kubernetes Authorization](/azure/aks/manage-azure-rbac).

This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. One of the benefit of hosting your CDE in Azure as oppposed to your platform at the edge or in your data center, is that restricting physical access is mostly already handled through Azure datacenter security. There aren't any responsibilities for the organization in management of physcial hardware.

> [!IMPORTANT]
>
> The guidance in this article builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). That architecture based on a hub and spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintainence. The spoke virtual network contains the AKS cluster that provides the cardholder data environment (CDE) and hosts the PCI DSS workload.
>
> ![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates a regulated environment. The implementation illustrates <Todo add identity blurb>.

## Implement Strong Access Control Measures

**Requirement 7**&mdash;Restrict access to cardholder data by business need to know

|Requirement|Responsibility|
|---|---|
|[Requirement 7.1](#requirement-71)|Limit access to system components and cardholder data to only those individuals whose job requires such access.|
|[Requirement 7.2](#requirement-72)|Establish an access control system for systems components that restricts access based on a user’s need to know, and is set to “deny all” unless specifically allowed.|
|[Requirement 7.3](#requirement-73)|Ensure that security policies and operational procedures for restricting access to cardholder data are documented, in use, and known to all affected parties.|

**Requirement 8**&mdash;Identify and authenticate access to system components

|Requirement|Responsibility|
|---|---|
|[Requirement 8.1](#requirement-81)|Define and implement policies and procedures to ensure proper user identification management for non-consumer users and administrators on all system components as follows:|
|[Requirement 8.2](#requirement-82)| In addition to assigning a unique ID, ensure proper user-authentication management for non-consumer users and administrators on all system components by employing at least one of the following methods to authenticate all users:|
|[Requirement 8.3](#requirement-83)|Secure all individual non-console administrative access and all remote access to the CDE using multi-factor authentication.|
|[Requirement 8.4](#requirement-84)|Document and communicate authentication procedures and policies and procedures to all users including:|
|[Requirement 8.5](#requirement-85)| Do not use group, shared, or generic IDs, passwords, or other authentication methods as follows:|
|[Requirement 8.6](#requirement-86)| Where other authentication mechanisms are used (for example, physical or logical security tokens, smart cards, certificates, etc.), use of these mechanisms must be assigned as follows:|
|[Requirement 8.7](#requirement-87)| All access to any database containing cardholder data (including access by applications, administrators, and all other users) is restricted as follows:|
|[Requirement 8.8](#requirement-87)|Ensure that security policies and operational procedures for identification and authentication are documented, in use, and known to all affected parties.|

**Requirement 9**&mdash;Restrict physical access to cardholder data
***

|Requirement|Responsibility|
|---|---|
|[Requirement 9.1](#requirement-91)|Use appropriate facility entry controls to limit and monitor physical access to systems in the cardholder data environment.|
|[Requirement 9.2](#requirement-92)| Develop procedures to easily distinguish between onsite personnel and visitors, to include:|
|[Requirement 9.3](#requirement-93)|Control physical access for onsite personnel to the sensitive areas as follows:|
|[Requirement 9.4](#requirement-94)|Implement procedures to identify and authorize visitors. Procedures should include the following:|
|[Requirement 9.5](#requirement-95)| Physically secure all media.|
|[Requirement 9.6](#requirement-96)| Maintain strict control over the internal or external distribution of any kind of media, including the following:|
|[Requirement 9.7](#requirement-97)| Maintain strict control over the storage and accessibility of media.|
|[Requirement 9.8](#requirement-98)|Destroy media when it is no longer needed for business or legal reasons as follows:|
|[Requirement 9.9](#requirement-99)|Protect devices that capture payment card data via direct physical interaction with the card from tampering and substitution.|
|[Requirement 9.10](#requirement-910)|Ensure that security policies and operational procedures for restricting physical access to cardholder data are documented, in use, and known to all affected parties.|

### Requirement 7.1

Limit access to system components and cardholder data to only those individuals whose job requires such access.

#### Your responsibilities

Use role-based access control (RBAC) to limit access. A role is a collection of permissions. An identity  or a group of identities can be assigned to a role. RBAC can be divided into two categories:

- Azure RBAC&mdash;is an Azure Active Directory (AD)-based authorization model that controls access to the _Azure control plane_. This is an association of your Azure Active Directory (AD) tenant with your Azure subscription. With Azure RBAC you can grant permissions to create Azure resources such as networks, AKS cluster, managed identities, and and so on.
- Kubernetes RBAC&mdash;is a native Kubernetes authorization model that controls access to the _Kubernetes control plane_ exposed through the Kubernetes API server. This set of permissions defines what you can do with the API server. For example, you can deny a user the permissions to create or even list pods.

You can choose to keep separate tenants for each RBAC mechanism. This way, you can clearly maintain tenant segmentation. The advantage is reduced attack surface and lateral movement. The down side is increased  complexity and cost of managing multiple identity stores.

AKS integrates the two RBAC mechanisms. You can use the same Azure AD tenants for both control planes by mapping Azure AD roles to Kubernetes roles. During cluster creation, configure it to use Azure AD for user authentication. Then, a user can access the Kubernetes control plane by using their Azure AD credentials. You can secure access with Azure AD features such as Conditional Access Policies.

This reference implementation will work with either model. Here are some considerations:

- Make sure your implementation is aligned with the organization's and compliance requirements about identity management.
- Minimize standing permissions and use just-in-time(JIT) role assignments, time-based, and approval-based role activation.
- Follow the principle of least-privilege access when making RBAC role assigments to all components of the CDE.

#### Requirement 7.1.1

Define access needs for each role, including:

- System components and data resources that each role needs to access for their job function
- Level of privilege required (for example, user, administrator, etc.) for accessing resources.

##### Your responsibilities

Determine access for roles involved in workload and its operations. This depends on your organization structure. As you define roles, consider the scope of roles and responsibilities about topics such as:

- Source Code repository (GitHub Enterprise, Azure DevOps, GitLab, etc.)
- Key Vaults
- Resource Groups / Subscriptions
- Azure Management Groups
- Azure Policy (workload-centric), Azure Policy (subscription-centric)
- Container Registries
- Databases
- Pipelines (Build and Deploy)
- Azure Resources (ARM templates)
- Training and Certification
- TLS certificate authority
- Live-site access patterns
- Pre-production environments

Who in your organization is responsible for tasks, such as:

- Decisions about application security, Kubernetes RBAC, network policies, Azure policies, communication with other services.
- Configuration and maintenance of Azure Firewall, Web Application Firewall (WAF), network security groups (NSGs), DNS configuration, and so on.
- Allocation of enterprise-wide virtual network and subnets.
- Monitor and remediate server security, patching, configuration, endpoint security.
- Set direction for use of RBAC, Azure Security Center, Administrator protection strategy, and Azure Policy to govern Azure resources.
- Incident monitoring and response team. Investigate and remediate security incidents in Security Information and Event Management (SIEM) or Azure Security Center.
 
Here are example roles and their responsibilities.

|Team|Function|Access levels
|---|---|---|
|**Application owners**|Define the scope of the workload and prioritize features.  balance customer data protection and ownership with business objectives. |<TBD>|
|**Application developers**|Develop software in compliance with the standard. All code must be approved by entities responsible for quality gates, attestation, and release management processes.|Read privileges in Kubernetes namespaces and Azure resources that are in scope of the workload. May manage build pipelines but not deployment pipelines.|
|**Application operators (or SRE)**| Have deep understanding of the code base. Are experts in troubleshooting, observability standards, operations. Manage the "last-mile" deployment pipeline and may help the application developers manage the build pipelines. |Highly privileged within the scope of the application that includes related Kubernetes namespaces and Azure resources. |
|**Infrastructure operators (or SRE)**|Build, deploy, and bootstrap pipeline for the cluster in which the workload is deployed. Monitor and the health of the container hosting infrastructure and dependent services. |Read-only permissions for the workload namespaces for quota, limits, or OOM alerts. Need <TBD> permissions to bootstrap workload namespaces with requires zero-trust policies and set quotas.|


#### Requirement 7.1.2

Restrict access to privileged user IDs to least privileges necessary to perform job responsibilities.

##### Your responsibilities

Minimize standing permissions, especially on critical-impact identities that have access to in-scope components. Use [Just-In-Time AD group membership](/azure/aks/managed-aad#configure-just-in-time-cluster-access-with-azure-ad-and-aks) in Azure Active Directory (AD) through Privileged Identity Management. Add extra restrictions through [Conditional Access Policies in Azure AD for your cluster](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks) where possible.

Regular review and audit users and groups that have access in your subscriptions, even for read-access. Avoid inviting external identities.

#### Requirement 7.1.3

Assign access based on individual personnel’s job classification and function.

##### Your responsibilities

Determine permissions based on the clearly assigned job duties of the individual. Avoid parameters such as the system, tenure of the employee. Give access rights to a single user or to a group. Here are the some examples.

|Team|Group assignment| Single user|
|---|---|---|
|**Application owners**|A group with access to reports, cost center, or Azure Dashboards. No access needed for in-cluster or cluster-level permissions.|
|**Application developers**|A group with standing read permissions within defined scopes within Azure (such as  Application Insights) and the workload namespaces. These scopes and permissions may be different between pre-production and production environments.|
|**Application operators (or SRE)**| <p>Group A with full control within their allocated namespace(s). Standing permissions are not required.</p><p>Group B for day-to-day operations on the workload. It can have standing permissions within their allocated namespace(s) but are not highly privileged. </p> |A Service Principal responsible for deploying workload-centric resources.|
|**Infrastructure operators (or SRE)**|<p>Group A: that is used at the break-glass group that allows full control over the Kubernetes cluster. Standing permissions are not required.</p><p>Group B for day-to-day operations on the cluster. It can have standing permissions within a cluster but are not highly privileged.</p>|A Service Principal responsible for deploying Azure resources, such as the cluster and other Azure resources on the same lifecycle.|

Then, use role-based access control (RBAC) to limit access for the group and user. A role is a collection of permissions. An identity or a group of identities can be assigned to a role. RBAC can be divided into two categories:

- Azure RBAC&mdash;is an Azure Active Directory (AD)-based authorization model that controls access to the _Azure control plane_. This is an association of your Azure Active Directory (AD) tenant with your Azure subscription. With Azure RBAC you can grant permissions to create Azure resources such as networks, AKS cluster, managed identities, and and so on.
- Kubernetes RBAC&mdash;is a native Kubernetes authorization model that controls access to the _Kubernetes control plane_ exposed through the Kubernetes API server. This set of permissions defines what you can do with the API server. For example, you can deny a user the permissions to create or even list pods.

Here are some example Azure RBAC role assigments:

|Team group/user| Azure RBAC|
|---|---|
|**Application owners group**|TBD|
|**Application developers group**|TBD|
|**Application operators user**|TBD|
|**Application operators group A**|TBD|
|**Application operators group B**|TBD|
|**Infrastructure operators user**|TBD|
|**Infrastructure operators group A**|TBD|
|**Infrastructure operators group B**|TBD|


Within the cluster, the preceding user identities  and groups are mapped to Kubernetes `ClusterRole` and `ClusterRoleBinding` constructs, respectively. 


Here are some best practices when assigning roles:

- Consider using dedicated tenants for seperation of responsibilities between Kubernetes RBAC and Azure RBAC when applicable. This defense-in-depth will protect the system in situations if one tenant is compromised, actions by the other tenant remain unaffected. The downside is the increased overhead in management of two tenants. Follow the governance policies to choose a model that works for the organization.

- You can choose to keep separate tenants for each RBAC mechanism. This way, you can clearly maintain tenant segmentation. The advantage is reduced attack surface and lateral movement. The down side is increased  complexity and cost of managing multiple identity stores.


- Strive for consistency with your RBAC implementation. Define common roles and apply group assignments appropriately that align with your team structure. A consistent approach will help in detecting changes and and provide justification for new access requirements that may develop. It's also easier to audit.

- Have a regular cadence for reviewing permissions. Responsibilities might change when there are changes on the team such as employee leaving the company or there are need for roles that are temporary. In some cases, the reviews might show  need for changes. One way is to review the `kube-audit-admin` logs to ensure access patterns are being followed. Outside of identity provider emergencies, the built-in `cluster admin` user should never be used. Consider including a review of these logs to detect unexpected admin user usage; as that might indicate reinforced training on your identity governance policies.

- Make sure you maintain documentation that keeps track of the changes.


#### Requirement 7.1.4

Require documented approval by authorized parties specifying required privileges.

##### Your responsibilities

Have a gated process for approving changes in roles and permissions, including the intial assignment of prividleges. Ensure those approvals are documented and available for inspection.

### Requirement 7.2

Establish an access control system for systems components that restricts access based on a user’s need to know, and is set to “deny all” unless specifically allowed.

#### Your responsibilities

After following [Requirement 7.1](#requirement-71), you should have assessed roles and responsibilities that are applicable for your organization and the workload. All components in the architecture that are in-scope must have restricted access. This includes the AKS nodes that run the workload, data storage, network access, and all other services that participate in processing the card holder data (CHD).

Based on roles and responsibilities, assign user or administrator roles. Kubernetes has built-in, user-facing RBAC roles, such as `admin` that are applied typically at the namespace level. If you are integrating Azure AD roles and Kubernetes roles, create a mapping between the two roles.

Here's an example. Suppose you need a group for the SRE team.  This role assigned to the group requires the highest privilege and equates to a `cluster-admin` role. You can map the role to an existing AD RBAC role that has administrative access. Make sure you have strategy in place to create separation of duties.

An alternate way is to create a custom role dedicated for cluster administrative access. Of the two approaches, the second one is recommended and demonstrated in the reference implementation.

- Maintain meticulous documentation about each role and the assigned permissions. Keep clear distinction about which permissions are Just-In-Time(JIT) and standing. 

- Monitor the roles for changes such as, in assigment changes or role definitions. Create alerts on changes even if they are expected to gain visibility into intentions behind the changes.



#### Requirement 7.2.1

Coverage of all system components

##### Your responsibilities

Here are some best practices to maintain access control measures:

- Don't have standing access. Consider using[Just-In-Time AD group membership](/azure/aks/managed-aad#configure-just-in-time-cluster-access-with-azure-ad-and-aks). This feature requires Azure AD Privileged Identity Management.

- Set up [Conditional Access Policies in Azure AD for your cluster](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). This further puts restrictions on access to the Kubernetes control plane. With conditional access policies, you can require multi-factor authentication, restrict authentication to devices that are managed by your Azure AD tenant, or block non-typical sign-in attempts. Apply these policies to Azure AD groups that are mapped with to Kubernetes roles with high privilege.

    > [!NOTE]
    > Both JIT and conditional access technology choices require Azure AD Premium.

- Ideally disable SSH access to the cluster nodes. This reference implementation doesn't generate SSH connection details for that purpose.

- Any additional compute, such as jumpboxes, must be accessed by authorized users. Do not create generic logins available to the entire team.

#### Requirement 7.2.2

Assignment of privileges to individuals based on job classification and function.

##### Your responsibilities

There are many roles involved in cluster operations. Beyond the standard Azure resource roles, you'll need to now define the extent and process of access.

For example, consider the cluster operator role. They should have a clearly-defined playbook for cluster triage activities. How different is that access from workload team. Depending on your organization they may be the same. Here are some points:

- How should they access the cluster
- Which sources are allowed for access
- What permissions should they have on the cluster
- When are those permissions assigned

Make sure the definitions are documented in governance documentation, policy, and training materials around workload operator and cluster operator.

#### Requirement 7.2.3

Default "deny-all" setting.

##### Your responsibilities

When you start the configuration, start with zero-trust policies. Make exceptions as needed and document them in detail.

- Kubernetes RBAC implements _deny all_ by default. Don't override by adding highly-permissive cluster role bindings that inverse the deny all setting.

- Azure RBAC also implements _deny all_ by default. Don't override by adding RBAC assignments that inverse the deny all setting.

- All Azure services, Key Vault, Container Registry, by default have deny all set of permissions.

- Any administrative access points, such as a jump box, should deny all access in the initial configuraiton. All elevated permissions must be defined explicitly to the deny all rule. 

> [!NOTE]
> This note is not related identity access controls but is a reminder about network access. Network Security Groups (NSGs) allow all communication by default. Change that to set deny all as the starting rule with high priority. Then, add exceptions that will be applied before the deny all rule, as needed. Be consistent on the naming, so that it's easier to audit.
>   
> Azure firewall implements deny all by default.
 

### Requirement 7.3

Ensure that security policies and operational procedures for restricting access to cardholder data are documented, in use, and known to all affected parties.

#### Your responsibilities

It's critical that you maintain thorough documentation about the processes and policies. This includes Azure and Kubernetes RBAC policies and organizational governance policies. People operating regulated enviroments must be educated, informed, and incentivized to support the security assurances. This is particularly important for people who are part of the approval process from a policy perspective.

***

### Requirement 8.1

Define and implement policies and procedures to ensure proper user identification management for non-consumer users and administrators on all system components as follows:

- 8.1.1 Assign all users a unique ID before allowing them to access system components or cardholder data.
- 8.1.2 Control addition, deletion, and modification of user IDs, credentials, and other identifier objects.
- 8.1.3 Immediately revoke access for any terminated users.
- 8.1.4 Remove/disable inactive user accounts within 90 days.
- 8.1.5 Manage IDs used by thid parties to access, support, or maintain system components via remote access as follows:
  - Enabled only during the time period needed and disabled when not in use.
  - Monitored when in use.
- 8.1.6 Limit repeated access attempts by locking out the user ID after not more than six attempts.
- 8.1.7 Set the lockout duration to a minimum of 30 minutes or until an administrator enables the user ID.
- 8.1.8 If a session has been idle for more than 15 minutes, require the user to re-authenticate to re-activate the terminal or session.

#### Your responsibilities

Here are overall considerations for this requirement:

**APPLIES TO: 8.1.1, 8.1.2, 8.1.3**

Don't share or reuse identities for functionally different parts of the CDE.For example, using a team account to access data or cluster resources. Make sure the identity onboarding documentation is clear about not using shared accounts.

Extend this identity principal to managed identity assignments in Azure. Do not share user-managed identites across Azure resources, assign each Azure resource its own managed identity. Similarly, when using [Azure AD Pod Identity](https://github.com/Azure/aad-pod-identity) in the AKS cluster, ensure that each component in your workload receives its own identity instead of using an identity that is broad in scope. Never use the same managed identity in pre-production and production.

While preceding guidance must be applied to user identities, we recommend not sharing system identities.

[Access and identity options for Azure Kubernetes Service (AKS)](/azure/aks/concepts-identity)

**APPLIES TO: 8.1.2, 8.1.3, 8.1.4**

When you create the AKS cluster, enable Azure Active Directory (AD) as the identity store for use authentication. Create role bindings to use Kubernetes role-based access control (Kubernetes RBAC) to limit access to cluster resources, data, and runtime environments based a user's identity or group membership.

A strategy to limit access is to minimize standing permissions. Opt for [Just-In-Time AD group membership](/azure/aks/managed-aad#configure-just-in-time-cluster-access-with-azure-ad-and-aks) in Azure Active Directory (AD) through Privileged Identity Management. This approach is appropriate for situations where SREs need to interact with your cluster temporarily.

Add extra restrictions for privileged access through [Conditional Access Policies in Azure AD for your cluster](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks) where possible.

Always do deployments through authorized build and release pipelines. The pipelines should also minimize exposure to individuals high privilege access.

Make sure RBAC assignments are scoped appropriately for least access.

Because the cluster and all Azure resources use Azure AD, disabling or revoking  Azure AD access is applied to all resources automatically. If there are any components that are not backed directly by Azure AD, make sure you have process to remove access. For example, SSH credentials for accessing a jump box might need explicit removal if the user is no longer valid.

**APPLIES TO: 8.1.5**

Take advantage of Azure AD business-to-business (B2B) that's designed to host third-party accounts, such as vendors, partners, as guest users. The third-party uses their own identities; Azure AD is not required. Grant the appropriate level of access by using conditional policies to protect corporate data. These accounts must have minimal standing permissions and mandatory expiry dates. For more information, see [What is guest user access in Azure Active Directory B2B](/azure/active-directory/external-identities/what-is-b2b).

<Ask Chad: Azure AD B2C - Customers/citizens>

Your organization should have a clear and documented pattern of vendor and similar access.

**APPLIES TO: 8.1.6, 8.1.7, 8.1.8**

##### Your responsibilities

Azure AD provides a [smart lock out feature](/azure/active-directory/authentication/howto-password-smart-lockout) to lock out users after failed sign-in attempts. The recommended way to implement lock outs is with Azure AD Conditional Access policies.

Implement the lockut for components that support similar features but are not backed with Azure AD. For example, SSH-enabled machines, such as a jump box. This will ensure lock outs are enabled to prevent or slow access attempt abuse.

AKS nodes are not designed to be routinely accessed. Block direct SSH or Remote Desktop to cluster nodes. SSH access should only be considered as part of advanced troubleshooting efforts. The access should be closely monitored and promptly reverted after completion of the specific event.  If you do this, be aware that any node-level changes can cause the your cluster to be out of support.

### Requirement 8.2

In addition to assigning a unique ID, ensure proper user-authentication management for non-consumer users and administrators on all system components by employing at least one of the following methods to authenticate all users: Something you know, such as a password or passphrase, Something you have, such as a token device or smart card, Something you are, such as a biometric.

- 8.2.1 Using strong cryptography, render all authentication credentials (such as passwords/phrases) unreadable during transmission and storage on all system components.
- 8.2.2 Verify user identity before modifying any authentication credential—for example, performing password resets, provisioning new tokens, or generating new keys.
- 8.2.3 Passwords/phrases must meet the following:
  - Require a minimum length of at least seven characters.
  - Contain both numeric and alphabetic characters.
- 8.2.4 Change user passwords/passphrases at least once every 90 days.
- 8.2.5 Do not allow an individual to submit a new password/phrase that is the same as any of the last four passwords/phrases he or she has used.
- 8.2.6 Set passwords/phrases for first-time use and upon reset to a unique value for each user, and change immediately after the first use.

#### Your responsibilities

Set up [Conditional Access Policies in Azure AD for your cluster](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). This further puts restrictions on access to the Kubernetes control plane.

Several of the preceding set of requirements are automatically handled by Azure AD. Here are some examples:

- **Password security**

    Azure AD provides features that enforces the use of strong passwords. For example, weak passwords that belong to the global banned password list are blocked. This isn't sufficient protection. Consider adding the Azure AD Password Protection feature to create an organization-specific ban list. A password policy is applied by default. Certain policies cannot be modified and covers some of the preceding set of requirements. For example, password expiration, allowed characters, and others. For the complete list, see [Azure AD password policies](/azure/active-directory/authentication/concept-sspr-policy#password-policies-that-only-apply-to-cloud-user-accounts). Consider using advanced features that can be enforced with conditional access policies, such as User-risk based conditional access policies that detect leaked username and password pairs. For more information, see [Conditional Access: User risk-based Conditional Access](/azure/active-directory/conditional-access/howto-conditional-access-policy-risk-user).

- **User identity verification**

    You can apply the sign-in risk conditional access policy to detect if the authentication request was issued by the requesting identity. The request is validated against threat intelligence sources. For example, password spray, IP address anomalies, and others. For more information, see [Conditional Access: Sign-in risk-based Conditional Access](/azure/active-directory/conditional-access/howto-conditional-access-policy-risk).

You might have components that don't use Azure AD, such as access to jump boxes with SSH. For such cases, use public key encryption with at least RSA 2048 keysize. Always specify a passphrase. Have a validation process that tracks known approved public keys. Systems that use public key access mustn't be exposed to the internet.  Instead, all SSH access should be allowed through a intermediary, such as Azure Bastion to reduce the impact of a private key leak. Disable direct password access and use an alternative passwordless solution.

### Requirement 8.3

Secure all individual non-console administrative access and all remote access to the CDE using multi-factor authentication.
Note: Multi-factor authentication requires that a minimum of two of the three authentication methods (see Requirement 8.2 for descriptions of authentication methods) be used for authentication. Using one factor twice (for example, using two separate passwords) is not considered multi-factor
authentication.

#### Your responsibilities

Use conditional access policies to enforce  multi-factor authentication, specifically on administrative accounts. These policies are recommended on several built-in roles. Apply these policies to Azure AD groups that are mapped to Kubernetes roles with high privilege.

This policy can be further hardened with additional policies. Here are some examples:

- You can restrict authentication to devices that are managed by your Azure AD tenant.
- If the access originates from a network outside the cluster network, you can enforce multi-factor authentication.

For information, these articles:

- [Conditional Access: Require MFA for administrators](/azure/active-directory/conditional-access/howto-conditional-access-policy-admin-mfa)
- [How To: Require managed devices for cloud app access with Conditional Access](/azure/active-directory/conditional-access/require-managed-devices)
- [How to: Require MFA for access from untrusted networks with Conditional Access](/azure/active-directory/conditional-access/untrusted-networks)

### Requirement 8.4

Document and communicate authentication procedures and policies and procedures to all users including:

- Guidance on selecting strong authentication credentials
- Guidance for how users should protect their authentication credentials
- Instructions not to reuse previously used passwords
- Instructions to change passwords if there is any suspicion the password could be compromised.

#### Your responsibilities

Maintain documentation about the enforced policies. As part of your identity onboarding training, provide guidance for password reset procedures and organizational best practices about protecting assets.

### Requirement 8.5

Do not use group, shared, or generic IDs, passwords, or other authentication methods as follows:

- Generic user IDs are disabled or removed.
- Shared user IDs do not exist for system administration and other critical functions.
- Shared and generic user IDs are not used to administer any system components.

#### Your responsibilities

Don't share or reuse identities for functionally different parts of the cluster or pods.For example, using a team account to access data or cluster resources. Make sure the identity onboarding documentation is clear about not using shared accounts.

Disable root users in the CDE. Do not use the built-in `--admin` access in the CDE.

### Requirement 8.6

Where other authentication mechanisms are used (for example, physical or logical security tokens, smart cards, certificates, etc.), use of these mechanisms must be assigned as follows:

- Authentication mechanisms must be assigned to an individual account and not shared among multiple accounts.
- Physical and/or logical controls must be in place to ensure only the intended account can use that mechanism to gain access.

#### Your responsibilities

Ensure that all access to the CDE is provided on per-user identities, and this is extended into any physical or virtual tokens. This includes any VPN access into the CDE network, ensuring that enterprise point-to-site access (if any) use per-user certificates as part of that authenitcation flow.

### Requirement 8.7

All access to any database containing cardholder data (including access by applications, administrators, and all other users) is restricted as follows:

- All user access to, user queries of, and user actions on databases are through programmatic methods.
- Only database administrators have the ability to directly access or query databases.
- Application IDs for database applications can only be used by the applications (and not by individual users or other non-application processes).

#### Your responsibilities

Provide access based on roles and responisbilities. People can use their identity but the access must be restricted on need-to-know basis, with minimal standing permissions. People should never use application identies and database access identities must never be shared. 

If possible, access database from applications through managed identity. Otherwise, limit exposure to connection strings and credentials. Use Kubernetes secrets to store sensitive information instead of keeping them places where they are easily discovered, such as pod definition. Another way is to store and load secrets to and from a managed store, such as Azure Key Vault. With managed identities enabled on an AKS cluster, it has to authenticate itself against Key Vault to get access.


### Requirement 8.8

Ensure that security policies and operational procedures for identification and authentication are documented, in use, and known to all affected parties.

#### Your responsibilities

It's critical that you maintain thorough documentation about the processes and policies. Maintain documentation about the enforced policies. As part of your identity onboarding training, provide guidance for password reset procedures and organizational best practices about protecting assets. People operating regulated environments must be educated, informed, and incentivized to support the security assurances. This is particularly important for people who are part of the approval process from a policy perspective.

### Requirement 9.1
Use appropriate facility entry controls to limit and monitor physical access to systems in the cardholder data environment.
- 9.1.1 Use either video cameras or access control mechanisms (or both) to monitor individual physical access to sensitive areas. Review collected data and correlate with other entries. Store for at least three months, unless otherwise restricted by law. 

   Note: ""Sensitive areas” refers to any data center, server room or any area that houses systems that store, process, or transmit cardholder data. This excludes public-facing areas where only point-of-sale terminals are present, such as the cashier areas in a retail store."""
- 9.1.2 Implement physical and/or logical controls to restrict access to publicly accessible network jacks. 

   For example, network jacks located in public areas and areas accessible to visitors could be disabled and only enabled when network access is explicitly authorized. Alternatively, processes could be implemented to ensure that visitors are escorted at all times in areas with active network jacks."
- 9.1.3 Restrict physical access to wireless access points, gateways, handheld devices, networking/communications hardware, and telecommunication lines.

#### Your responsibilities

This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For considerations, refer to the guidance in the official PCI-DSS standard.

Here are some suggestions for applying technical controls:

- Tune session timeouts in any administrative console access, such as jump boxes in the CDE, to minimize access.
- Tune conditional access polices to minimize the TTL on Azure access tokens from access points, such as the Azure portal. For information, see these articles:

- [Configure authentication session management with Conditional Access](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/howto-conditional-access-session-lifetime)
- [Configurable token lifetimes - Microsoft identity platform](/azure/active-directory/develop/active-directory-configurable-token-lifetimes)

- For cloud-hosted CDE, There aren't any responsibilities for managing physcial access and hardware. Rely on corporate network physical and logical controls.


### Requirement 9.2
Use either video cameras or access control mechanisms (or both) to monitor individual physical access to sensitive areas. Review collected data and correlate with other entries. Store for at least three months, unless otherwise restricted by law. 


#### Your responsibilities

This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, There aren't any responsibilities on the organization for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.


### Requirement 9.3
Control physical access for onsite personnel to the sensitive areas as follows:
- Access must be authorized and based on individual job function.
- Access is revoked immediately upon termination, and all physical access mechanisms, such as keys, access cards, etc., are returned or disabled.


#### Your responsibilities
This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, there aren't responsibilities on the organization for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.


### Requirement 9.4

Implement procedures to identify and authorize visitors. Procedures should include the following:
- 9.4.1 Visitors are authorized before entering, and escorted at all times within, areas where cardholder data is processed or maintained
- 9.4.2 Visitors are identified and given a badge or other identification that expires and that visibly distinguishes the visitors from onsite personnel.
- 9.4.3 Visitors are asked to surrender the badge or identification before leaving the facility or at the date of expiration.
- 9.4.4 A visitor log is used to maintain a physical audit trail of visitor activity to the facility as well as computer rooms and data centers where cardholder data is stored or transmitted.

Document the visitor’s name, the firm represented, and the onsite personnel authorizing physical access on the log. Retain this log for a minimum of three months, unless otherwise restricted by law.

#### Your responsibilities
This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, there aren't responsibilities on the organization  for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.


### Requirement 9.5

Physically secure all media.
- 9.5.1 Store media backups in a secure location, preferably an off-site facility, such as an alternate or backup site, or a commercial storage facility. Review the location’s security at least annually.

#### Your responsibilities
This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, there aren't responsibilities on the organization  for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.


### Requirement 9.6
Maintain strict control over the internal or external distribution of any kind of media, including the following:
- 9.6.1 Classify media so the sensitivity of the data can be determined.
- 9.6.2 Send the media by secured courier or other delivery method that can be accurately tracked.
- 9.6.3 Ensure management approves any and all media that is moved from a secured area (including when media is distributed to individuals).


#### Your responsibilities
This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, there aren't responsibilities on the organization  for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.


### Requirement 9.7
Maintain strict control over the storage and accessibility of media.
- Properly maintain inventory logs of all media and conduct media inventories at least annually.


#### Your responsibilities
This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, there aren't responsibilities on the organization  for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.


### Requirement 9.8
Destroy media when it is no longer needed for business or legal reasons as follows:
- 9.8.1 Shred, incinerate, or pulp hard-copy materials so that cardholder data cannot be reconstructed. Secure storage containers used for materials that are to be destroyed.
- 9.8.2 Render cardholder data on electronic media unrecoverable so that cardholder data cannot be reconstructed.


#### Your responsibilities
This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, there aren't responsibilities on the organization  for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.


### Requirement 9.9
Protect devices that capture payment card data via direct physical interaction with the card from tampering and substitution.

Note: These requirements apply to card-reading devices used in card-present transactions (that is, card swipe or dip) at the point of sale. This requirement is not intended to apply to manual key-entry components such as computer keyboards and POS keypads. "
- 9.9.1 Maintain an up-to-date list of devices. The list should include the following:
   - Make, model of device
   - Location of device (for example, the address of the site or facility where the device is located)
   - Device serial number or other method of unique identification."
- 9.9.2 Periodically inspect device surfaces to detect tampering (for example, addition of card skimmers to devices), or substitution (for example, by checking the serial number or other device characteristics to verify it has not been swapped with a fraudulent device).

   Note: Examples of signs that a device might have been tampered with or substituted include unexpected attachments or cables plugged into the device, missing or changed security labels, broken or differently colored casing, or changes to the serial number or other external markings."
- 9.9.3 Provide training for personnel to be aware of attempted tampering or replacement of devices.  Training should include the following:
   - Verify the identity of any third-party persons claiming to be repair or maintenance personnel, prior to granting them access to modify or troubleshoot devices.
   - Do not install, replace, or return devices without verification.
   - Be aware of suspicious behavior around devices (for example, attempts by unknown persons to unplug or open devices).
   - Report suspicious behavior and indications of device tampering or substitution to appropriate personnel (for example, to a manager or security officer)."


#### Your responsibilities
This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, there aren't responsibilities on the organization  for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.


### Requirement 9.10

Ensure that security policies and operational procedures for restricting physical access to cardholder data are documented, in use, and known to all affected parties.

#### Your responsibilities
This architecture and the implementation aren't designed to do provide controls on physical access to resources for on-premises or data centers. For cloud-hosted CDE, there aren't responsibilities on the organization  for managing physcial hardware. For considerations, refer to the guidance in the official PCI-DSS standard.




## Next

Track and monitor all access to network resources and cardholder data. Regularly test security systems and processes.

> [!div class="nextstepaction"]
> [Regularly Monitor and Test Networks](aks-pci-monitor.yml)
