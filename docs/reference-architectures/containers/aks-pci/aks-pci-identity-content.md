This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS 3.2.1).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml).

Kubernetes has native role-based access control (RBAC) that manages permissions to the Kubernetes API. There are several built-in roles with specific permissions or actions on Kubernetes resources. Azure Kubernetes Service (AKS) supports those built-in roles and custom roles for granular control. Those actions can be authorized (or denied) to a user through Kubernetes RBAC.

This architecture and the implementation aren't designed to provide controls on physical access to on-premises resources or datacenters. One benefit of hosting your CDE in Azure, as opposed to your platform at the edge or in your datacenter, is that restricting physical access is mostly already handled through Azure datacenter security. There aren't any responsibilities for the organization in management of physical hardware.

> [!IMPORTANT]
>
> This guidance and the accompanying implementation build on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/baseline-aks). That architecture is based on a hub-and-spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintenance. The spoke virtual network contains the AKS cluster that provides the cardholder data environment (CDE) and hosts the PCI DSS workload.
>
> ![Image of the GitHub logo.](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure with identity and access management controls. This implementation provides an Azure AD-backed, private cluster that supports just-in-time (JIT) access and conditional access models for illustrative purposes.

## Implement strong access control measures

### Requirement 7 &mdash; Restrict access to cardholder data by business need to know

#### AKS feature support

AKS is fully integrated with Azure Active Directory (Azure AD) as the identity provider.

You don't have to manage separate user identities and credentials for Kubernetes. You can add Azure AD users for Kubernetes RBAC. This integration makes it possible to do role assignments to Azure AD users. Azure AD RBAC supports for role definitions, such as viewer, writer, service admin, cluster admin as built-in roles. Also you can create custom roles for more granular control.

By default, Azure RBAC is set to deny all so a resource cannot be accessed without granted permissions. AKS limits SSH access to AKS worker nodes and uses AKS network policy to control access to workloads in the pods.

For more information, see [Use Azure RBAC for Kubernetes Authorization](/azure/aks/manage-azure-rbac) and [Secure your cluster with Azure Policy](/azure/aks/use-pod-security-on-azure-policy).

#### Your responsibilities

|Requirement|Responsibility|
|---|---|
|[Requirement 7.1](#requirement-71)|Limit access to system components and cardholder data to only those individuals whose job requires such access.|
|[Requirement 7.2](#requirement-72)|Establish an access control system for systems components that restricts access based on a user's need to know, and is set to "deny all" unless specifically allowed.|
|[Requirement 7.3](#requirement-73)|Ensure that security policies and operational procedures for restricting access to cardholder data are documented, in use, and known to all affected parties.|

### Requirement 7.1

Limit access to system components and cardholder data to only those individuals whose job requires such access.

#### Your responsibilities

Here are some considerations:

- Make sure your implementation is aligned with the organization's requirements, and with compliance requirements about identity management.
- Minimize standing permissions especially for critical impact accounts.
- Follow the principle of least-privilege access. Provide just enough access to complete the task.

#### Requirement 7.1.1

Define access needs for each role, including:

- System components and data resources that each role needs to access for their job function
- Level of privilege required (for example, user, administrator, etc.) for accessing resources.

##### Your responsibilities

Define roles based on the tasks and responsibilities required for the in-scope components and their interaction with Azure resources. You can start with broad categories, such as:

- Scope by Azure management groups, subscriptions, or resource groups
- Azure Policy for the workload or subscription
- Container operations
- Secret management
- Build and deployment pipelines

While the definition of roles and responsibilities around those areas might be associated with your team structure, focus on the requirement of the workload. For instance, who is responsible for maintaining security, isolation, deployment, and observability. Here are some examples:

- Decisions about application security, Kubernetes RBAC, network policies, Azure policies, and communication with other services.
- Configuration and maintenance of Azure Firewall, web application firewall (WAF), network security groups (NSGs), and DNS configuration.
- Monitor and remediate server security, patching, configuration, and endpoint security.
- Set direction for use of RBAC, Microsoft Defender for Cloud, Administrator protection strategy, and Azure Policy to govern Azure resources.
- Incident monitoring and response team. Investigate and remediate security incidents in security information and event management (SIEM) or Microsoft Defender for Cloud.

Then, formalize the definition by determining what level of access is required for the role with respect to the workload and the infrastructure. Here's a simple definition for illustrative purposes.

|Role|Responsibilities|Access levels
|---|---|---|
|**Application owners**|Define and prioritize features aligning with business outcomes. They understand how features impact the compliance scoping of the workload, and balance customer data protection and ownership with business objectives.|Read access to logs and metrics emitted by the application. They don't need permissions to access to the workload or the cluster.|
|**Application developers**|Develop the application. All application code is subject to training and quality gates upholding compliance, attestation, and release management processes. Might manage the build pipelines, but usually not deployment pipelines.|Read access to Kubernetes namespaces and Azure resources that are in scope of the workload. No write access for deploying or modifying any state of the system.|
|**Application operators (or SRE)**|Have a deep understanding of the code base, observability, and operations. Do live-site triage and troubleshooting. Along with application developers, improve availability, scalability and performance of the application. Manage the "last-mile" deployment pipeline and help manage the build pipelines.|Highly privileged within the scope of the application that includes related Kubernetes namespaces and Azure resources. Likely have standing access to parts of the Kubernetes cluster.
|**Infrastructure owners**| Design a cost-effective architecture, including its connectivity and the functionality of components. The scope can include cloud and on-premises services. Decide capabilities data retention, business continuity features, and others.|Access to platform logs and cost center data. No access is required within the cluster.|
|**Infrastructure operators (or SRE)**|Operations related to the cluster and dependent services. Build, deploy, and bootstrap the pipeline for the cluster in which the workload is deployed. Set targets node pools, and expected sizing and scale requirements. Monitor the health of the container hosting infrastructure and dependent services.|Read access to workload namespaces. Highly-privileged access for the cluster.
|**Policy, security owners**| Have security or regulation compliance expertise. Define policies that protect the security and regulatory compliance of the company employees, its assets, and those of the company's customers. Works with all other roles to ensure policy is applied and auditable through every phase.|Read access to the workload and the cluster. Also access to log and audit data.|
|**Network operators**|Allocation of enterprise-wide virtual network and subnets. Configuration and maintenance of Azure Firewall, WAF, NSGs, and DNS configuration.|Highly-privileged in the networking layer. No write permission within the cluster.|

#### Requirement 7.1.2

Restrict access to privileged user IDs to least privileges necessary to perform job responsibilities.

##### Your responsibilities

Based on the job functions, strive to minimize access without causing disruptions. Here are some best practices:

- The identity should have just enough access to complete a task.
- Minimize standing permissions, especially on critical-impact identities that have access to in-scope components.
- Add extra restrictions where possible. One way is to provide conditional access based on access criteria.
- Conduct a regular review and audit of users and groups that have access in your subscriptions, even for read-access. Avoid inviting external identities.

#### Requirement 7.1.3

Assign access based on individual personnel's job classification and function.

##### Your responsibilities

Determine permissions based on the clearly assigned job duties of the individual. Avoid parameters such as the system or the tenure of the employee. Give access rights to a single user or to a group.

Here are some examples.

|Job classification|Role|
|---|---|
|A *product owner* defines the scope of the workload and prioritizes features. Balances customer data protection and ownership with business objectives. Needs access to reports, the cost center, or Azure dashboards. No access is needed for in-cluster or cluster-level permissions.|**Application owners**|
|A *software engineer* designs, develops, and containerizes the application code. A group with standing read permissions within defined scopes within Azure (such as Application Insights) and the workload namespaces. These scopes and permissions might be different between pre-production and production environments.|**Application developer**|
|A *site reliability engineer* does live-site triage, manages pipelines, and sets up application infrastructure.<p>Group A with full control within their allocated namespace(s). Standing permissions are not required.</p><p>Group B for day-to-day operations on the workload. It can have standing permissions within their allocated namespace(s), but are not highly privileged. </p> |**Application operators**|
|A *cluster operator* designs and deploys a reliable and secure AKS cluster to the platform. Responsible for maintaining cluster up time. <p>Group A with full control within their allocated namespace(s). Standing permissions are not required.</p><p>Group B for day-to-day operations on the workload. It can have standing permissions within their allocated namespace(s), but are not highly privileged. </p> |**Infrastructure operators**|
|A *network engineer* allocates of enterprise-wide virtual network and subnets, on-premises to cloud connectivity, and network security. |**Infrastructure operators**|

#### Requirement 7.1.4

Require documented approval by authorized parties specifying required privileges.

##### Your responsibilities

Have a gated process for approving changes in roles and permissions, including the initial assignment of privileges. Ensure those approvals are documented and available for inspection.

### Requirement 7.2

Establish an access control system for systems components that restricts access based on a user's need to know, and is set to "deny all" unless specifically allowed.

#### Your responsibilities

After following [Requirement 7.1](#requirement-71), you should have assessed roles and responsibilities that are applicable for your organization and the workload. All components in the architecture that are in-scope must have restricted access. This includes the AKS nodes that run the workload, data storage, network access, and all other services that participate in processing the card holder data (CHD).

Based on roles and responsibilities, assign roles to the infrastructure's role-based access control (RBAC). That mechanism can be:

- **Kubernetes RBAC** is a native Kubernetes authorization model that controls access to the *Kubernetes control plane*, exposed through the Kubernetes API server. This set of permissions defines what you can do with the API server. For example, you can deny a user the permissions to create or even list pods.
- **Azure RBAC** is an Azure AD-based authorization model that controls access to the *Azure control plane*. This is an association of your Azure AD tenant with your Azure subscription. With Azure RBAC you can grant permissions to create Azure resources, such as networks, an AKS cluster, and managed identities.

Suppose you need to give permissions to the cluster operators (mapped to the infrastructure operator role). All people who are assigned the infrastructure operator responsibilities belong to an Azure AD Group. As established in 7.1.1, this role requires the highest privilege in the cluster. Kubernetes has built-in RBAC roles, such as `cluster-admin`, that meets those requirements. You'll need to bind the Azure AD Group for infrastructure operator to `cluster-admin` by creating role bindings. There are two approaches. You can choose the built-in roles. Or, if the built-in roles do not meet your requirements (for example, they might be overly permissive), create custom roles for your bindings.

The reference implementation demonstrates the preceding example by using native Kubernetes RBAC. The same association can be accomplished with Azure RBAC. For more information, see [Control access to cluster resources using Kubernetes role-based access control and Azure Active Directory identities in Azure Kubernetes Service](/azure/aks/azure-ad-rbac).

You can choose the scope of permission at the cluster level or at the namespace level. For roles that have scoped responsibilities, such as application operators, the permissions are assigned at the namespace level for the workload.

In addition, the roles also need Azure RBAC permissions so that they are able to do their tasks. For example, the cluster operator needs to access Azure Monitor through the portal. So, the infrastructure operator role must have the appropriate RBAC assignment.

Apart from people and their roles, Azure resources and even pods within the cluster have managed identities. Those identities need a set of permissions through Azure RBAC, and must be tightly scoped based on the expected tasks. For example, Azure Application Gateway must have permissions to get secrets (TLS certificates) from Azure Key Vault. It must not have permissions to modify secrets.

Here are some best practices:

- Maintain meticulous documentation about each role and the assigned permissions. Keep clear distinction about which permissions are JIT and which are standing.

- Monitor the roles for changes, such as in assignment changes or role definitions. Create alerts on changes even if they are expected to gain visibility into intentions behind the changes.

#### Requirement 7.2.1

Coverage of all system components

##### Your responsibilities

Here are some best practices to maintain access control measures:

- Don't have standing access. Consider using [Just-In-Time AD group membership](/azure/aks/managed-aad#configure-just-in-time-cluster-access-with-azure-ad-and-aks). This feature requires Azure AD Privileged Identity Management.

- Set up [Conditional Access Policies in Azure AD for your cluster](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). This further puts restrictions on access to the Kubernetes control plane. With conditional access policies, you can require multifactor authentication, restrict authentication to devices that are managed by your Azure AD tenant, or block non-typical sign-in attempts. Apply these policies to Azure AD groups that are mapped to Kubernetes roles with high privilege.

  > [!NOTE]
  > Both JIT and conditional access technology choices require Azure AD Premium.

- Ideally disable SSH access to the cluster nodes. This reference implementation doesn't generate SSH connection details for that purpose.

- Any additional compute, such as jump boxes, must be accessed by authorized users. Do not create generic logins available to the entire team.

#### Requirement 7.2.2

Assignment of privileges to individuals based on job classification and function.

##### Your responsibilities

Based on 7.1.3, there will be many roles involved in cluster operations. Beyond the standard Azure resource roles, you'll need to define the extent and process of access.

For example, consider the cluster operator role. They should have a clearly-defined playbook for cluster triage activities. How different is that access from workload team? Depending on your organization, they might be the same. Here are some points to consider:

- How should they access the cluster?
- Which sources are allowed for access?
- What permissions should they have on the cluster?
- When are those permissions assigned?

Make sure the definitions are documented in governance documentation, policy, and training materials around workload operator and cluster operator.

#### Requirement 7.2.3

Default "deny-all" setting.

##### Your responsibilities

When you start the configuration, start with zero-trust policies. Make exceptions as needed and document them in detail.

- Kubernetes RBAC implements *deny all* by default. Don't override by adding highly-permissive cluster role bindings that inverse the deny all setting.

- Azure RBAC also implements *deny all* by default. Don't override by adding RBAC assignments that inverse the deny all setting.

- All Azure services, Azure Key Vault, and Azure Container Registry, have *deny all* set of permissions by default.

- Any administrative access points, such as a jump box, should deny all access in the initial configuration. All elevated permissions must be defined explicitly to the deny all rule.

> [!NOTE]
> Remember that for network access, NSGs allow all communication by default. Change that to set *deny all* as the starting rule with high priority. Then, add exceptions that will be applied before the *deny all* rule, as needed. Be consistent on the naming, so that it's easier to audit.
>
> Azure Firewall implements *deny all* by default.

### Requirement 7.3

Ensure that security policies and operational procedures for restricting access to cardholder data are documented, in use, and known to all affected parties.

#### Your responsibilities

It's critical that you maintain thorough documentation about the processes and policies. This includes Azure and Kubernetes RBAC policies and organizational governance policies. People operating regulated environments must be educated, informed, and incentivized to support the security assurances. This is particularly important for people who are part of the approval process from a policy perspective.

### Requirement 8 &mdash; Identify and authenticate access to system components

#### AKS feature support

Because of AKS and Azure AD integration, you can take advantage of ID management and authorization capabilities, including access management, identifier objects management, and others. For more information, see [AKS-managed Azure Active Directory integration](/azure/aks/managed-aad).

#### Your responsibilities

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

### Requirement 8.1

Define and implement policies and procedures to ensure proper user identification management for non-consumer users and administrators on all system components as follows:

- 8.1.1 Assign all users a unique ID before allowing them to access system components or cardholder data.
- 8.1.2 Control addition, deletion, and modification of user IDs, credentials, and other identifier objects.
- 8.1.3 Immediately revoke access for any terminated users.
- 8.1.4 Remove/disable inactive user accounts within 90 days.
- 8.1.5 Manage IDs used by third parties to access, support, or maintain system components via remote access as follows:
  - Enabled only during the time period needed and disabled when not in use.
  - Monitored when in use.
- 8.1.6 Limit repeated access attempts by locking out the user ID after not more than six attempts.
- 8.1.7 Set the lockout duration to a minimum of 30 minutes or until an administrator enables the user ID.
- 8.1.8 If a session has been idle for more than 15 minutes, require the user to re-authenticate to re-activate the terminal or session.

#### Your responsibilities

Here are overall considerations for this requirement:

**APPLIES TO: 8.1.1, 8.1.2, 8.1.3**

Don't share or reuse identities for functionally different parts of the CDE. For example, don't use a team account to access data or cluster resources. Make sure the identity documentation is clear about not using shared accounts.

Extend this identity principal to managed identity assignments in Azure. Do not share user-managed identities across Azure resources. Assign each Azure resource its own managed identity. Similarly, when you're using [Azure AD workload identity](/azure/aks/workload-identity-overview) in the AKS cluster, ensure that each component in your workload receives its own identity instead of using an identity that is broad in scope. Never use the same managed identity in pre-production and production.

[Access and identity options for Azure Kubernetes Service (AKS)](/azure/aks/concepts-identity)

**APPLIES TO: 8.1.2, 8.1.3, 8.1.4**

Use Azure AD as the identity store. Because the cluster and all Azure resources use Azure AD, disabling or revoking Azure AD access is applied to all resources automatically. If there are any components that are not backed directly by Azure AD, make sure you have a process to remove access. For example, SSH credentials for accessing a jump box might need explicit removal if the user is no longer valid.

**APPLIES TO: 8.1.5**

Take advantage of Azure AD business-to-business (B2B) that's designed to host third-party accounts, such as vendors, partners, as guest users. Grant the appropriate level of access by using conditional policies to protect corporate data. These accounts must have minimal standing permissions and mandatory expiry dates. For more information, see [What is guest user access in Azure Active Directory B2B](/azure/active-directory/external-identities/what-is-b2b).

Your organization should have a clear and documented pattern of vendor and similar access.

**APPLIES TO: 8.1.6, 8.1.7, 8.1.8**

##### Your responsibilities

Azure AD provides a [smart lock out feature](/azure/active-directory/authentication/howto-password-smart-lockout) to lock out users after failed sign-in attempts. The recommended way to implement lockouts is with Azure AD Conditional Access policies.

Implement the lockout for components that support similar features but are not backed with Azure AD (for example, SSH-enabled machines, such as a jump box). This ensures that lockouts are enabled to prevent or slow access attempt abuse.

AKS nodes are not designed to be routinely accessed. Block direct SSH or Remote Desktop to cluster nodes. SSH access should only be considered as part of advanced troubleshooting efforts. The access should be closely monitored and promptly reverted after completion of the specific event. If you do this, be aware that any node-level changes can cause your cluster to be out of support.

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

    Azure AD provides features that enforce the use of strong passwords. For example, weak passwords that belong to the global banned password list are blocked. This isn't sufficient protection. Consider adding the Azure AD Password Protection feature to create an organization-specific ban list. A password policy is applied by default. Certain policies cannot be modified and cover some of the preceding set of requirements. These include password expiration and allowed characters. For the complete list, see [Azure AD password policies](/azure/active-directory/authentication/concept-sspr-policy#password-policies-that-only-apply-to-cloud-user-accounts). Consider using advanced features that can be enforced with conditional access policies, such as those based on user risk, which detect leaked username and password pairs. For more information, see [Conditional Access: User risk-based Conditional Access](/azure/active-directory/conditional-access/howto-conditional-access-policy-risk-user).

    > [!NOTE]
    > We strongly recommend that you consider passwordless options. For more information, see [Plan a passwordless authentication deployment in Azure Active Directory](/azure/active-directory/authentication/howto-authentication-passwordless-deployment).

- **User identity verification**

    You can apply the sign-in risk conditional access policy to detect if the authentication request was issued by the requesting identity. The request is validated against threat intelligence sources. These include password spray and IP address anomalies. For more information, see [Conditional Access: Sign-in risk-based Conditional Access](/azure/active-directory/conditional-access/howto-conditional-access-policy-risk).

You might have components that don't use Azure AD, such as access to jump boxes with SSH. For such cases, use public key encryption with at least RSA 2048 key size. Always specify a passphrase. Have a validation process that tracks known approved public keys. Systems that use public key access mustn't be exposed to the internet.  Instead, all SSH access should be allowed through an intermediary, such as Azure Bastion to reduce the impact of a private key leak. Disable direct password access and use an alternative passwordless solution.

### Requirement 8.3

Secure all individual non-console administrative access and all remote access to the CDE using multi-factor authentication. Note: Multi-factor authentication requires that a minimum of two of the three authentication methods (see Requirement 8.2 for descriptions of authentication methods) be used for authentication. Using one factor twice (for example, using two separate passwords) is not considered multi-factor authentication.

#### Your responsibilities

Use conditional access policies to enforce multifactor authentication, specifically on administrative accounts. These policies are recommended on several built-in roles. Apply these policies to Azure AD groups that are mapped to Kubernetes roles with high privilege.

This policy can be further hardened with additional policies. Here are some examples:

- You can restrict authentication to devices that are managed by your Azure AD tenant.
- If the access originates from a network outside the cluster network, you can enforce multifactor authentication.

For more information, see:

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

Don't share or reuse identities for functionally different parts of the cluster or pods. For example, don't use a team account to access data or cluster resources. Make sure the identity documentation is clear about not using shared accounts.

Disable root users in the CDE. Disable usage of Kubernetes local accounts so that users cannot use the built-in `--admin` access to clusters within the CDE.

### Requirement 8.6

Where other authentication mechanisms are used (for example, physical or logical security tokens, smart cards, certificates, etc.), use of these mechanisms must be assigned as follows:

- Authentication mechanisms must be assigned to an individual account and not shared among multiple accounts.
- Physical and/or logical controls must be in place to ensure only the intended account can use that mechanism to gain access.

#### Your responsibilities

Ensure that all access to the CDE is provided on per-user identities, and this is extended into any physical or virtual tokens. This includes any VPN access into the CDE network, ensuring that enterprise point-to-site access (if any) use per-user certificates as part of that authentication flow.

### Requirement 8.7

All access to any database containing cardholder data (including access by applications, administrators, and all other users) is restricted as follows:

- All user access to, user queries of, and user actions on databases are through programmatic methods.
- Only database administrators have the ability to directly access or query databases.
- Application IDs for database applications can only be used by the applications (and not by individual users or other non-application processes).

#### Your responsibilities

Provide access based on roles and responsibilities. People can use their identity, but the access must be restricted on a need-to-know basis, with minimal standing permissions. People should never use application identities, and database access identities must never be shared.

If possible, access database from applications through managed identity. Otherwise, limit exposure to connection strings and credentials. Use Kubernetes secrets to store sensitive information instead of keeping them places where they are easily discovered, such as pod definition. Another way is to store and load secrets to and from a managed store, such as Azure Key Vault. With managed identities enabled on an AKS cluster, it has to authenticate itself against Key Vault to get access.

### Requirement 8.8

Ensure that security policies and operational procedures for identification and authentication are documented, in use, and known to all affected parties.

#### Your responsibilities

It's critical that you maintain thorough documentation about the processes and policies. Maintain documentation about the enforced policies. As part of your identity onboarding training, provide guidance for password reset procedures and organizational best practices about protecting assets. People operating regulated environments must be educated, informed, and incentivized to support the security assurances. This is particularly important for people who are part of the approval process from a policy perspective.

### Requirement 9 &mdash; Restrict physical access to cardholder data

### AKS feature support

There aren't any applicable AKS features for this requirement.

#### Your responsibilities

This architecture and the implementation aren't designed to provide controls on physical access to on-premises resources or datacenters. For considerations, refer to the guidance in the official PCI-DSS 3.2.1 standard.

Here are some suggestions for applying technical controls:

- Tune session timeouts in any administrative console access, such as jump boxes in the CDE, to minimize access.
- Tune conditional access policies to minimize the TTL on Azure access tokens from access points, such as the Azure portal. For information, see these articles:

  - [Configure authentication session management with Conditional Access](/azure/active-directory/conditional-access/howto-conditional-access-session-lifetime)
  - [Configurable token lifetimes - Microsoft identity platform](/azure/active-directory/develop/active-directory-configurable-token-lifetimes)

- For cloud-hosted CDE, there aren't any responsibilities for managing physical access and hardware. Rely on corporate network physical and logical controls.

- Minimize exporting of CHD backups to on-premises destinations. Use solutions hosted in Azure to limit physical access to backups.

- Minimize backups to on-premises. If this is required, be aware that the on-premises destination will be in scope for audit.

## Next steps

Track and monitor all access to network resources and cardholder data. Regularly test security systems and processes.

> [!div class="nextstepaction"]
> [Regularly monitor and test networks](aks-pci-monitor.yml)
