This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

<Todo: insert blurb>

> [!IMPORTANT]
>
> The guidance in this article builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). That architecture based on a hub and spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintainence. The spoke virtual network contains the AKS cluster that provides the card holder environment (CDE) and hosts the PCI DSS workload. 
>
> ![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates a regulated environment. The implementation illustrates the set up malware scanning tools. Every node in the cluster (in-scope and out-of-scope) has placeholder `DaemonSet` deployments for antivirus, FIM, Kubernetes-aware security agent (Falco), and reboot agent (kured). Place your choice of software in this deployment.

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

Based on that assessment, assign user or administrator roles. Kubernetes has built-in, user-facing roles like admin, edit, and view, generally to be applied at namespace levels, which can also be mapped to various Azure AD Groups.

These roles should then be mapped to Azure RBAC and Kubernetes RBAC roles. 

For example, you need a group that needs complete access to the cluster. The appropriate role is the `cluster-admin` Kubernetes role. This role has the highest privilege. Members of this group will have complete access throughout the cluster. Consider using a separate group instead of reusing an administrative group that accesses the Azure controle plane. This will maintain separation of duties. 

For the cluster admin group, avoid standing access. Consider using[ Just-In-Time AD group membership](/azure/aks/managed-aad#configure-just-in-time-cluster-access-with-azure-ad-and-aks). This feature requires Azure AD PIM found in Premium P2 SKU. 

If you 

Maintain meticulous documentation about each role and permissions. 

 Likewise, if you know you'll have additional custom Kubernetes roles created as part of your separation of duties authentication schema, you can create those security groups now as well. For this walk through, you do NOT need to map any of these additional roles.

In the cluster-rbac.yaml file and the various namespaced rbac.yaml files, you can uncomment what you wish and replace the <replace-with-an-aad-group-object-id…> placeholders with corresponding new or existing AD groups that map to their purpose for this cluster or namespace. You do not need to perform this action for this walk through; they are only here for your reference. By default, in this implementation, no additional cluster roles will be bound other than cluster-admin. For your final implementation, create custom kubernetes roles to align specifically with those job functions of your team, and create role assignments as needed. Handle JIT access at the group membership level in Azure AD via Privileged Identity Management, and leverage conditional access policies where possible. Always strive to minimize standing permissions, especially on identities that have access to in-scope components.



Each individual with access should clearly be documented as to which role(s) they have. That way it's easy to map from individual to their expected permissions. Ensure you're documenting which permissions are JIT vs standing.

These roles should then be mapped to Azure RBAC and Kubernetes RBAC roles, and documented as such. Consider monitoring the defination of those roles for changes (defintion and assignment), and alert on changes to those custom roles -- even if they are expected changes.  That'll ensure visibility and intentionality on those roles.

Following the steps below will result in an Azure AD configuration that will be used for Kubernetes control plane (Cluster API) authorization.

| Object                         | Purpose                                                 |
|--------------------------------|---------------------------------------------------------|
| A Cluster Admin Security Group | Will be mapped to `cluster-admin` Kubernetes role.      |
| A Cluster Admin User           | Represents at least one break-glass cluster admin user. |
| Cluster Admin Group Membership | Association between the Cluster Admin User(s) and the Cluster Admin Security Group. Ideally there would be NO standing group membership associations made, but for the purposes of this material, you should have assigned the admin user(s) created above. |
| _Additional Security Groups_   | _Optional._ A security group (and its memberships) for the other built-in and custom Kubernetes roles you plan on using. |


#### Requirement 7.1.2
Restrict access to privileged user IDs to least privileges necessary to perform job responsibilities.

##### Your responsibilities
Minimize standing permissions, opting for JIT access where practiable. Create custom Azure RBAC roles and Kuberentes roles to define specific set of permissions that should be allowed.

Audit what users (and groups) have access in your subscriptions, even read. Inviting external identities should be disallowed or done with extreme care.

#### Requirement 7.1.3
Assign access based on individual personnel’s job classification and function.

##### Your responsibilities
Permissions should be based on the clearly assigned jod duties of the individual wrt this paticular system, not based on tenure, company importance, or job title.

Responsibility changes should be documented, even if they are temporary (filling in for someone that called in sick).

Consider using dedicated tenants for seperation of responsibilities between Kubernetes RBAC and Azure RBAC if appropriate (this tenant still would need to be a fully managed enterprise resource, do not create ""shadow identitys stores"").

Be clear and consistent in naming of Azure BRAC and Kubernetes RBAC roles.

#### Requirement 7.1.4
Require documented approval by authorized parties specifying required privileges.

##### Your responsibilities
TBD

### Requirement 7.2
Establish an access control system for systems components that restricts access based on a user’s need to know, and is set to “deny all” unless specifically allowed.

#### Your responsibilities
Jump Boxes should only be accessed by authorized users. Do not create generic "team" logins to jump boxes, they should be tied to inviduals. Ideally disable SSH access to the cluster nodes (this RI does not generate SSH connection details for that purpose). k8s rbac implements this by default, do not counter measure this by adding cluster role bindings that inverse the "deny all" relationship. Azure RBAC implements this by default, do bot counter measure this by adding RBAC assignments that inverse the "deny all relationship".  All services, KeyVault, Container Registry, etc by default start with "no permissions" and is additative.


#### Requirement 7.2.1
Coverage of all system components

##### Your responsibilities
TBD

#### Requirement 7.2.2
Assignment of privileges to individuals based on job classification and function.

##### Your responsibilities
Again, solved with RBAC

#### Requirement 7.2.3
Default “deny-all” setting.

##### Your responsibilities
Ensure NSGs have a short circuit "deny-all" in their rules to override default rules. Be consistent on the naming, so that it can be audited for its existance. Azure firewall implements "deny all" by default.


### Requirement 7.3
Ensure that security policies and operational procedures for restricting access to cardholder data are documented, in use, and known to all affected parties.

#### Your responsibilities



## Next
Track and monitor all access to network resources and cardholder data. Regularly test security systems and processes.

> [!div class="nextstepaction"]
> [Regularly Monitor and Test Networks](aks-pci-monitor.yml)