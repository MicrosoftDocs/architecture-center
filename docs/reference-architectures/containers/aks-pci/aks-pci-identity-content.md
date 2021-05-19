This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

<Todo: insert blurb>

> [!IMPORTANT]
>
> The guidance in this article builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). That architecture based on a hub and spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintainence. The spoke virtual network contains the AKS cluster that provides the card holder environment (CDE) and hosts the PCI DSS workload. 
>
> ![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates a regulated environment. The implementation illustrates <To do add identity blurb>.

## Implement Strong Access Control Measures

**Requirement 7**&mdash;Restrict access to cardholder data by business need to know

|Requirement|Responsibility|
|---|---|
|[Requirement 7.1](#requirement-71)|Limit access to system components and cardholder data to only those individuals whose job requires such access.|
|[Requirement 7.2](#requirement-72)|Establish an access control system for systems components that restricts access based on a user’s need to know, and is set to “deny all” unless specifically allowed.|
|[Requirement 7.3](#requirement-73)|Ensure that security policies and operational procedures for restricting access to cardholder data are documented, in use, and known to all affected parties.|


**Requirement 8**&mdash;Identify and authenticate access to system components

**Requirement 9**&mdash;Restrict physical access to cardholder data
***

### Requirement 7.1
Limit access to system components and cardholder data to only those individuals whose job requires such access.

#### Your responsibilities

Use role-based access control (RBAC) to limit access. A role is a collection of permissions. An identity  or a group of identities can be assigned to a role. RBAC can be divided into two categories:

- Azure RBAC&mdash;is an Azure Active Directory (AD)-based authorization model that controls access to the _Azure control plane_. This is an association of your Azure Active Directory (AD) tenant with your Azure subscription. With Azure RBAC you can grant permissions to create Azure resources such as networks, AKS cluster, managed identities, and and so on.
- Kubernetes RBAC&mdash;is a native Kubernetes authorization model that controls access to the _Kubernetes control plane_ exposed through the Kubernetes API server. This set of permissions defines what you can do with the API server. For example, you can deny a user the permissions to create and, list pods. 

You can choose to keep separate tenants for each RBAC mechanism. This way, you can clearly maintain tenant segmentation. The advantage is reduced attack surface and lateral movement. The down side is increased  complexity and cost of managing multiple identity stores.

AKS integrates the two RBAC mechanisms. You can use the same Azure AD tenants for both control planes by mapping Azure AD roles to Kubernetes roles. During cluster creation, configure it to use Azure AD for user authentication. Then, a user can access the Kubernetes control plane by using their Azure AD credentials. You can secure access with Azure AD features such as Conditional Access Policies.

This reference implementation will work with either model. Here are some considerations:

- Make sure your implementation is aligned with the organization's and compliance requirements about identity management.
- Minimize standing permissions and use just-in-time(JIT) role assignments, time-based, and approval-based role activation.
- Follow the principle of least-privilege access when making RBAC role assigments. 

#### Requirement 7.1.1
Define access needs for each role, including:
- System components and data resources that each role needs to access for their job function
- Level of privilege required (for example, user, administrator, etc.) for accessing resources.

##### Your responsibilities
Define a list of access for each role. Think about the roles and functions in your organization. For example:
- Who needs complete access to the cluster?
- Do you need an emergency break-glass cluster admin user?
- Who can administer a cluster?
- Who can create or update resources within a namespace?
<Ask chad: Please check the preceding/make better>
Based on that assessment, assign user or administrator roles. Kubernetes has built-in, user-facing RBAC roles, such `cluster-admin` that are applied at the namespace levels. If you are integrating Azure AD roles and Kubernetes roles, create a mapping between the two roles.

An example use case of that role is if you need a group that needs complete access to the cluster.  This role has the highest privilege. Members of this group will have complete access throughout the cluster. You can mapping the role to an existing AD RBAC role that has administrative access to the Azure control plane. In that case, make sure you have strategy in place to create separation of duties. An alternate way is to create a separate group dedicated for cluster administrative access. Of the two approaches, the second one is recommended and demonstrated in the reference implementation.

Here are some best practices to harden access. 
- Don't have standing access. Consider using[ Just-In-Time AD group membership](/azure/aks/managed-aad#configure-just-in-time-cluster-access-with-azure-ad-and-aks). This feature requires Azure AD Privileged Identity Management. 

- Set up [Conditional Access Policies in Azure AD for your cluster](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). This further puts restrictions on access to the Kubernetes control plane. With conditional access policies, you can require multi-factor authentication, restrict authentication to devices that are managed by your Azure AD tenant, or block non-typical sign-in attempts. Apply these policies to Azure AD groups that are mapped with to Kubernetes roles with high privilege. 

> [!NOTE]
> Both JIT and conditional access technology choices require Azure AD Premium.


- Maintain meticulous documentation about each role and the assigned permissions. Keep clear distinction about which permissions are JIT and  standing.

- Monitor the roles for changes such as, in assigment changes or role definitions. Create alerts on changes even if they are expected to gain visibility into intentions behind the changes.


#### Requirement 7.1.2
Restrict access to privileged user IDs to least privileges necessary to perform job responsibilities.

##### Your responsibilities

Minimize standing permissions, especially on critical-impact identities that have access to in-scope components. Use [ Just-In-Time AD group membership](/azure/aks/managed-aad#configure-just-in-time-cluster-access-with-azure-ad-and-aks) in Azure Active Directory (AD) through Privileged Identity Management. Add extra restrictions through [Conditional Access Policies in Azure AD for your cluster](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks) where possible.

Regular review and audit users and groups that have access in your subscriptions, even for read-access. Avoid inviting external identities.

#### Requirement 7.1.3
Assign access based on individual personnel’s job classification and function.

##### Your responsibilities
Grant permissions based on the clearly assigned job duties of the individual. Avoid parameters such as the system, tenure of the employee.

Strive for consistency with your RBAC implementation. Define common roles and apply group assignments appropriately that align with your team structure. A consistent approach will help in detecting changes and and provide justification for new access requirements that may develop.

Have a regular cadence for reviewing permissions. Responsibilities might change when there are changes on the team such as employee leaving the company or there are need for roles that are temporary. In some cases, the reviews might show  need for changes. One way is to review the `kube-audit-admin` logs to ensure access patterns are being followed. Outside of identity provider emergencies, the built-in `cluster admin` user should never be used. Consider including a review of these logs to detect unexpected admin user usage; as that might indicate reinforced training on your identity governance policies.

Make sure you maintain documentation that keeps track of the changes.

Consider using dedicated tenants for seperation of responsibilities between Kubernetes RBAC and Azure RBAC if appropriate (this tenant still would need to be a fully managed enterprise resource, do not create ""shadow identitys stores"").

<Ask chad: Please explain>

Be clear and consistent in naming of Azure RBAC and Kubernetes RBAC roles so that it's easier to audit.

#### Requirement 7.1.4
Require documented approval by authorized parties specifying required privileges.

##### Your responsibilities
Have a gated process for approving changes in roles and permissions.

### Requirement 7.2
Establish an access control system for systems components that restricts access based on a user’s need to know, and is set to “deny all” unless specifically allowed.

#### Your responsibilities

All components in the architecture that are in-scope must have restricted access. This includes the AKS nodes that run the workload, data storage, network access, and all other services that participate in processing the card holder data (CHD). 

#### Requirement 7.2.1
Coverage of all system components

##### Your responsibilities

Here are some best practices to maintain access control measures:

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

Make sure the definitions are documented in  governance documentation, policy, and training materials around workload operator and cluster operator. 

#### Requirement 7.2.3
Default “deny-all” setting.

##### Your responsibilities
- Kubernetes RBAC implements _deny all_ by default. Don't override by adding cluster role bindings that inverse the deny all setting.

- Azure RBAC also implements _deny all_ by default. Don't override by adding RBAC assignments that inverse the deny all setting. 

- All Azure services, Key Vault, Container Registry, by default have deny all set of permissions.

- Ensure network security groups (NSGs) have a short circuit "deny-all" in their rules to override default rules. Be consistent on the naming, so that it's easier to audit. Azure firewall implements "deny all" by default.

<Ask Chad: need more information on the last one>


### Requirement 7.3
Ensure that security policies and operational procedures for restricting access to cardholder data are documented, in use, and known to all affected parties.

#### Your responsibilities
It's critical that you maintain thorough documentation about the processes and policies. Especially RBAC policies (both Kubernetes and Azure), <Todo> People operating regulated enviroments must be educated, informed, and incentivized to support the security assurances. This is particularly important for people who are part of the approval process from a policy perspective.



## Next
Track and monitor all access to network resources and cardholder data. Regularly test security systems and processes.

> [!div class="nextstepaction"]
> [Regularly Monitor and Test Networks](aks-pci-monitor.yml)