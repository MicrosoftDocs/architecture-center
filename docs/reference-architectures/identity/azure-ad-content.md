<!-- cSpell:ignore writeback MSOL -->

Microsoft Entra ID is a cloud-based directory and identity service. This reference architecture shows best practices for integrating on-premises Active Directory domains with Microsoft Entra ID to provide cloud-based identity authentication.

## Architecture

:::image type="complex" border="false" source="./images/azure-active-directory.svg" alt-text="Diagram of a hybrid cloud identity architecture that uses Microsoft Entra ID." lightbox="./images/azure-active-directory.svg":::
   The image contains two key sections: an on-premises network and an Azure virtual network. The on-premises network section includes a domain controller, Microsoft Entra Connect Sync, and an on-premises client. An arrow points from the domain controller to Microsoft Entra Connect Sync. An arrow labeled sync points from Microsoft Entra Connect Sync to the Microsoft Entra tenant. An arrow labeled Requests from on-premises users points from the on-premises client to the Microsoft Entra tenant. An arrow labeled Requests from external users points to Microsoft Entra tenant. An arrow points from Microsoft Entra tenant to the Load balancer. Three arrows point from Load balancer to three separate virtual machines (VMs) in the Azure virtual network section. A dotted line labeled DDoS Protection encloses the Azure virtual network section. This section includes the Web tier, the Business tier, the Data tier, and the Management subnet. All three tiers include a network security group, a load balancer, and three VMs. The Management subnet includes Azure Bastion.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/identity-architectures.vsdx) of this architecture.*

> [!NOTE]
> For simplicity, this diagram only shows the connections directly related to Microsoft Entra ID and not protocol-related traffic that might occur as part of authentication and identity federation. For example, a web application might redirect the web browser to authenticate the request through Microsoft Entra ID. After authentication, the request can be passed back to the web application along with the appropriate identity information.

### Components

- **Microsoft Entra tenant:** An instance of [Microsoft Entra ID][azure-active-directory] created by your organization. It acts as a directory service for cloud applications by storing objects copied from the on-premises Active Directory and provides identity services.

- **Web tier subnet:** This subnet hosts virtual machines (VMs) that run a web application. Microsoft Entra ID serves as an identity broker for this application.

- **On-premises Active Directory Domain Services (AD DS) server:** An on-premises directory and identity service. The AD DS directory can be synchronized with Microsoft Entra ID to enable it to authenticate on-premises users.

- **Microsoft Entra Connect Sync server:** An on-premises computer that runs the [Microsoft Entra Connect][azure-ad-connect] synchronization service. This service synchronizes information stored in the on-premises Active Directory with Microsoft Entra ID. For example, provisioning or deprovisioning users and groups on-premises automatically synchronizes those changes to Microsoft Entra ID.

  > [!NOTE]
  > For security reasons, Microsoft Entra ID stores user passwords as hashes. If a user requires a password reset, the reset must be performed on-premises, and the updated hash must be sent to Microsoft Entra ID. Microsoft Entra ID P1 or P2 editions include features that allow password changes to be initiated in the cloud and then written back to the on-premises AD DS.

- **VMs for N-tier applications:** VMs that support scalable, resilient, and secure applications by separating workloads into individual tiers such as web, business logic, and data. For more information about these resources, see [N-tier architecture on VMs](/azure/architecture/guide/architecture-styles/n-tier#n-tier-architecture-on-virtual-machines).

## Scenario details

### Potential use cases

Consider the following typical uses for this reference architecture:

- Web applications deployed in Azure that provide access to remote users who belong to your organization.

- Implementing self-service capabilities for customers, such as resetting their passwords and delegating group management. This functionality requires Microsoft Entra ID P1 or P2 edition.

- Architectures in which the on-premises network and the application's Azure virtual network aren't connected by using a VPN tunnel or Azure ExpressRoute circuit.

> [!NOTE]
> Microsoft Entra ID can authenticate the identity of users and applications that exist in an organization's directory. Some applications and services, such as SQL Server, might require computer authentication, in which case this solution isn't appropriate.

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

<a name='configure-azure-ad-connect-sync-service'></a>

### Configure Microsoft Entra Connect Sync service

The Microsoft Entra Connect Sync service ensures that identity information stored in the cloud is consistent with the identity information stored on-premises. You install this service by using the Microsoft Entra Connect software.

Before you implement Microsoft Entra Connect Sync, determine the synchronization requirements of your organization. For example, consider what to synchronize, which domains to include, and how often synchronization should occur.

You can run the Microsoft Entra Connect Sync service on a VM or a computer hosted on-premises. Depending on the volatility of the information in your Active Directory directory, the load on the Microsoft Entra Connect Sync service is unlikely to be high after the initial synchronization with Microsoft Entra ID. Running the service on a VM makes it easier to scale the server if needed. Monitor the activity on the VM as described in the [Monitoring considerations](#configure-monitoring-agents) section to determine whether scaling is necessary.

If you have multiple on-premises domains in a forest, we recommend that you store and synchronize information for the entire forest to a single Microsoft Entra tenant. Filter information for identities that occur in more than one domain so that each identity appears only one time in Microsoft Entra ID instead of being duplicated. Duplication can result in inconsistencies when data is synchronized. For more information, see the [Validate network topology](#validate-network-topology) section.

Use filtering so that only necessary data is stored in Microsoft Entra ID. For example, your organization might not want to store information about inactive accounts in Microsoft Entra ID. Filtering can be group-based, domain-based, organization unit (OU)-based, or attribute-based. You can combine filters to generate more complex rules. For example, you can synchronize objects held in a domain that have a specific value in a selected attribute. For more information, see [Microsoft Entra Connect Sync: Configure filtering][aad-filtering].

To implement high availability for the Active Directory Connect sync service, run a secondary staging server. For more information, see [Staging mode][staging-mode].

  > [!NOTE]
  > **[Microsoft Entra cloud sync][azure-ad-connect-cloud-sync]** is an offering from Microsoft designed to meet and accomplish your hybrid identity goals for synchronization of users, groups, and contacts to Microsoft Entra ID. With Microsoft Entra cloud sync, provisioning from Active Directory to Microsoft Entra ID is orchestrated in Microsoft 365.

### Validate security configuration and policy

**User password management.** The Microsoft Entra ID P1 or P2 editions support password writeback. This feature enables your on-premises users to perform self-service password resets from within the Azure portal. This feature should be enabled only after you review your organization's password security policy. For example, you can restrict which users can change their passwords, and you can customize the password management experience. For more information, see [Customize the user experience for Microsoft Entra self-service password reset].

**Protect on-premises applications that can be accessed externally.** Use the Microsoft Entra application proxy to provide controlled access to on-premises web applications to users from outside your network through Microsoft Entra ID. Only users who have valid credentials in your Azure directory have permission to use the application. For more information, see [Enable application proxy in Microsoft Entra ID][aad-application-proxy].

**Actively monitor Microsoft Entra ID for signs of suspicious activity.** Consider using Microsoft Entra ID P2 edition, which includes Microsoft Entra ID Protection. ID Protection uses adaptive machine learning algorithms and heuristics to detect anomalies and risk events that might indicate that an identity has been compromised. For example, it can detect potentially unusual activity such as irregular sign-in activities, sign-ins from unknown sources or from IP addresses with suspicious activity, or sign-ins from devices that might be infected. Identity Protection uses this data to generate reports and alerts that enable you to investigate these risk events and take appropriate action. For more information, see [ID Protection][aad-identity-protection].

You can use the reporting feature of Microsoft Entra ID in the Azure portal to monitor security-related activities that occur in your system. For more information about how to use these reports, see [Microsoft Entra monitoring and health][aad-reporting-guide].

### Validate network topology

Configure Microsoft Entra Connect to implement a topology that most closely matches the requirements of your organization. Microsoft Entra Connect supports the following topologies:

- **Single forest, single Microsoft Entra directory:** In this topology, Microsoft Entra Connect synchronizes objects and identity information from one or more domains in a single on-premises forest into a single Microsoft Entra tenant. This topology is the default implementation by the express installation of Microsoft Entra Connect.

  > [!NOTE]
  > Don't use multiple Microsoft Entra Connect Sync servers to connect different domains in the same on-premises forest to the same Microsoft Entra tenant. This configuration is only appropriate if one of the servers is running in staging mode, as described in the following section.

- **Multiple forests, single Microsoft Entra directory:** In this topology, Microsoft Entra Connect synchronizes objects and identity information from multiple forests into a single Microsoft Entra tenant. Use this topology if your organization has more than one on-premises forest. You can consolidate identity information so that each unique user is represented one time in the Microsoft Entra directory, even if the user exists in more than one forest. All forests use the same Microsoft Entra Connect Sync server. The Microsoft Entra Connect Sync server must be domain-joined, but it must be reachable from all forests. For more information, see [Prerequisites for Microsoft Entra Connect](/entra/identity/hybrid/connect/how-to-connect-install-prerequisites).

  > [!NOTE]
  > In this topology, don't use separate Microsoft Entra Connect Sync servers to connect each on-premises forest to a single Microsoft Entra tenant. This configuration can result in duplicated identity information in Microsoft Entra ID if users are present in more than one forest.

- **Multiple forests, separate topologies:** This topology merges identity information from separate forests into a single Microsoft Entra tenant and treats all forests as separate entities. This topology is useful if you combine forests from different organizations and the identity information for each user is held in only one forest.

  > [!NOTE]
  > If the global address lists in each forest are synchronized, a user in one forest might be present in another as a contact. This behavior can occur if your organization has implemented GALSync with Forefront Identity manager 2010 or Microsoft Identity Manager 2016. In this scenario, you can specify that users should be identified by their *Mail* attribute. You can also match identities by using the *ObjectSID* and *msExchMasterAccountSID* attributes. This approach is useful if you have one or more resource forests that have disabled accounts.

- **Staging server:** In this configuration, you run a second instance of the Microsoft Entra Connect Sync server in parallel with the first. This structure supports the following scenarios:

  - High availability

  - Testing and deploying a new configuration of the Microsoft Entra Connect Sync server

  - Introducing a new server and decommissioning an old configuration

    In these scenarios, the second instance runs in *staging mode*. The server records imported objects and synchronization data in its database but doesn't pass the data to Microsoft Entra ID. If you disable staging mode, the server starts writing data to Microsoft Entra ID. It also starts performing password writebacks into the on-premises directories where appropriate. For more information, see [Microsoft Entra Connect Sync: Operational tasks and considerations][aad-connect-sync-operational-tasks].

- **Multiple Microsoft Entra directories:** You typically create a single Microsoft Entra directory for an organization. But there might be scenarios where you need to partition information across separate Microsoft Entra directories. In this case, avoid synchronization and password write-back problems by ensuring that each object from the on-premises forest appears in only one Microsoft Entra directory. To implement this scenario, configure separate Microsoft Entra Connect Sync servers for each Microsoft Entra directory, and use filtering so that each Microsoft Entra Connect Sync server operates on a mutually exclusive set of objects.

For more information about these topologies, see [Topologies for Microsoft Entra Connect][aad-topologies].

### Configure user authentication method

By default, the Microsoft Entra Connect Sync server configures password hash synchronization between the on-premises domain and Microsoft Entra ID. The Microsoft Entra service assumes that users authenticate by providing the same password that they use on-premises. For many organizations, this strategy is appropriate, but you should consider your organization's existing policies and infrastructure. Consider the following factors:

- The security policy of your organization might prohibit synchronizing password hashes to the cloud. In this case, your organization should consider [pass-through authentication](/entra/identity/hybrid/connect/how-to-connect-pta).

- You might require that users experience seamless single sign-on (SSO) when accessing cloud resources from domain-joined machines on the corporate network.

- Your organization might already have Active Directory Federation Services (AD FS) or a non-Microsoft federation provider deployed. You can configure Microsoft Entra ID to use this infrastructure to implement authentication and SSO instead of by using password information held in the cloud.

For more information, see [Microsoft Entra Connect user sign-in options][aad-user-sign-in].

<a name='configure-azure-ad-application-proxy'></a>

### Configure Microsoft Entra application proxy

Use Microsoft Entra ID to provide access to on-premises applications.

Expose your on-premises web applications by using application proxy connectors that the Microsoft Entra application proxy component manages. The application proxy connector opens an outbound network connection to the Microsoft Entra application proxy. Remote users' requests are routed back from Microsoft Entra ID through this proxy connection to the web apps. This configuration removes the need to open inbound ports in the on-premises firewall and reduces the attack surface exposed by your organization.

For more information, see [Publish applications by using Microsoft Entra application proxy][aad-application-proxy].

<a name='configure-azure-ad-object-synchronization'></a>

### Configure Microsoft Entra object synchronization

The default configuration for Microsoft Entra Connect synchronizes objects from your local Active Directory directory based on the rules specified in [Microsoft Entra Connect Sync: Understand the default configuration][aad-connect-sync-default-rules]. Objects that satisfy these rules are synchronized while all other objects are ignored. Consider the following example rules:

- User objects must have a unique *sourceAnchor* attribute and the *accountEnabled* attribute must be populated.

- User objects must have a *sAMAccountName* attribute and can't start with the text *Azure AD_* or *MSOL_*.

Microsoft Entra Connect applies several rules to the User, Contact, Group, ForeignSecurityPrincipal, and Computer objects. Use the Synchronization Rules Editor that's installed with Microsoft Entra Connect if you need to modify the default set of rules.

You can also define your own filters to limit the objects to be synchronized by domain or OU. Alternatively, you can implement more complex [custom filtering][aad-filtering].

### Configure monitoring agents

The following agents installed on-premises perform health monitoring:

- Microsoft Entra Connect installs an agent that captures information about synchronization operations. Use the Microsoft Entra Connect Health blade in the Azure portal to monitor its health and performance. For more information, see [Use Microsoft Entra Connect Health for sync][aad-health].

- To monitor the health of the AD DS domains and directories from Azure, install the Microsoft Entra Connect Health for AD DS agent on a machine within the on-premises domain. Use the Microsoft Entra Connect Health blade in the Azure portal for health monitoring. For more information, see [Use Microsoft Entra Connect Health with AD DS][aad-health-adds].

- Install the Microsoft Entra Connect Health for AD FS agent to monitor the health of services that run on on-premises, and use the Microsoft Entra Connect Health blade in the Azure portal to monitor AD FS. For more information, see [Use Microsoft Entra Connect Health with AD FS][aad-health-adfs].

For more information, see [Microsoft Entra Connect Health agent installation][aad-agent-installation].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The Microsoft Entra service is geo-distributed and runs in multiple datacenters spread around the world with automated failover. If a datacenter becomes unavailable, Microsoft Entra ID ensures that your directory data is available for instance access in a minimum of two more geographically distributed datacenters.

> [!NOTE]
> The service-level agreement (SLA) for the Microsoft 365 Apps AD tier and Premium services guarantees at least 99.9% availability. There's no SLA for the Free tier of Microsoft Entra ID. For more information, see [SLA for Microsoft Entra ID][sla-aad].

Consider provisioning a second instance of Microsoft Entra Connect Sync server in staging mode to increase availability.

If you aren't using the SQL Server Express LocalDB instance that comes with Microsoft Entra Connect, consider using SQL clustering to achieve high availability. Microsoft Entra Connect doesn't support solutions such as mirroring and Always On.

For other considerations about achieving high availability of the Microsoft Entra Connect Sync server and also how to recover after a failure, see [Microsoft Entra Connect Sync: Operational tasks and considerations - Disaster recovery][aad-sync-disaster-recovery].

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Use Microsoft Entra Conditional Access control to deny authentication requests from unexpected sources:

- Trigger [Microsoft Entra multifactor authentication (MFA)][azure-multifactor-authentication] if a user attempts to connect from an untrusted location, such as from across the internet instead of a trusted network.

- Use the device platform type of the user, like iOS, Android, or Windows, to determine access policy to applications and features.

- Record the enabled or disabled state of users' devices. Incorporate this information into the access policy checks. For example, if a user's phone is lost or stolen, it should be recorded as disabled to prevent it from being used to gain access.

- Control user access to resources based on group membership. Use [Microsoft Entra dynamic membership rules][aad-dynamic-membership-rules] to simplify group administration.

- Use Conditional Access risk-based policies with ID Protection to provide advanced protection based on unusual sign-in activities or other events.

For more information, see [Risk-based access policies][aad-conditional-access].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.

Consider the following cost considerations:

- **Microsoft Entra Connect:** The Microsoft Entra Connect synchronization feature is available in all editions of Microsoft Entra ID.

  - There are no extra license requirements for using Microsoft Entra Connect. And it's included with your Azure subscription.

  - For pricing information about the editions of Microsoft Entra ID, see [Microsoft Entra pricing][Azure-AD-pricing].

- **VMs for N-Tier application:** For cost information about these resources, see [Architecture best practices for Azure Virtual Machines and scale sets](/azure/well-architected/service-guides/virtual-machines).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Manageability

There are two aspects to managing Microsoft Entra ID:

- Administering Microsoft Entra ID in the cloud
- Maintaining the Microsoft Entra Connect Sync servers

Microsoft Entra ID provides the following options for managing domains and directories in the cloud:

- **[Microsoft Graph PowerShell module][microsoft-graph-powershell]** is used to script common Microsoft Entra administrative tasks such as user management, domain management, and configuring SSO.

- **[Microsoft Entra management blade in the Azure portal](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade)** provides an interactive management view of the directory. It also enables you to control and configure most aspects of Microsoft Entra ID.

Microsoft Entra Connect installs the following tools to maintain Microsoft Entra Connect Sync services from your on-premises machines:

- **Microsoft Entra Connect console** allows you to modify the configuration of the Microsoft Entra Connect Sync server, customize how synchronization occurs, enable or disable staging mode, and switch the user sign-in mode. You can enable AD FS sign-in by using your on-premises infrastructure.

- **Synchronization Service Manager** uses the *Operations* tab in this tool to manage the synchronization process and detect whether any parts of the process have failed. You can trigger synchronizations manually by using this tool. The *Connectors* tab enables you to control the connections for the domains that the synchronization engine is attached to.

- **Synchronization rules editor** allows you to customize how objects are transformed when they're copied between an on-premises directory and Microsoft Entra ID. This tool enables you to specify extra attributes and objects for synchronization. Then it implements filters to determine which objects should or shouldn't be synchronized. For more information, see [Microsoft Entra Connect Sync: Understand the default configuration][aad-connect-sync-default-rules] and [Microsoft Entra Connect Sync: Best practices for changing the default configuration][aad-sync-best-practices].

#### DevOps

For DevOps considerations, see Operational Excellence in [Deploy AD DS in an Azure virtual network](adds-extend-domain.yml#operational-excellence).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The Microsoft Entra service supports scalability based on replicas. It has a single primary replica that handles write operations and multiple read-only secondary replicas. Microsoft Entra ID transparently redirects attempted writes made to secondary replicas to the primary replica and maintains eventual consistency. All changes made to the primary replica are propagated to the secondary replicas. This architecture scales effectively because most operations performed against Microsoft Entra ID are reads instead of writes. For more information, see [Microsoft Entra architecture][aad-scalability].

For the Microsoft Entra Connect Sync server, determine how many objects you're likely to synchronize from your local directory. If you have fewer than 100,000 objects, you can use the default SQL Server Express LocalDB software provided with Microsoft Entra Connect. If you have a larger number of objects, install a production version of SQL Server. Then perform a custom installation of Microsoft Entra Connect and specify that it should use an existing SQL Server instance.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Eric Woodruff](https://www.linkedin.com/in/msfthiker) | Product Technical Specialist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Review [Topologies for Microsoft Entra Connect][aad-topologies] to ensure that the hybrid topology for Microsoft Entra Connect is deployed in a supported configuration.
- Learn how to use [Conditional Access deployment][aad-ca-plan] to protect access to your applications.
- Review [Integrate on-premises AD with Microsoft Entra ID][adds-azure-design] for more information about providing AD DS in Azure as infrastructure.
- Review [Microsoft Entra application proxy][aad-application-proxy] if you intend on providing Microsoft Entra integrations with on-premises or cloud infrastructure as a service applications.
- Review [Identity management best practices][identity-best-practices] because identity is the new control plane for security.
- Review [Secure privileged access][security-compass-paw] because deploying this solution requires highly privileged accounts.

## Related resources

- [Manage identity in multitenant applications](../../multitenant-identity/index.yml)
- [Extend on-premises AD FS to Azure](./adfs.yml)

<!-- links -->

[aad-agent-installation]: /entra/identity/hybrid/connect/how-to-connect-health-agent-install
[aad-application-proxy]: /entra/identity/app-proxy/application-proxy-add-on-premises-application
[aad-ca-plan]: /entra/identity/conditional-access/plan-conditional-access
[aad-conditional-access]: /entra/id-protection/concept-identity-protection-policies
[aad-connect-sync-default-rules]: /entra/identity/hybrid/connect/concept-azure-ad-connect-sync-default-configuration
[aad-connect-sync-operational-tasks]: /entra/identity/hybrid/connect/how-to-connect-sync-staging-server
[aad-dynamic-membership-rules]: /entra/identity/users/groups-dynamic-membership
[aad-filtering]: /entra/identity/hybrid/connect/how-to-connect-sync-configure-filtering
[aad-health]: /entra/identity/hybrid/connect/how-to-connect-health-sync
[aad-health-adds]: /entra/identity/hybrid/connect/how-to-connect-health-adds
[aad-health-adfs]: /entra/identity/hybrid/connect/how-to-connect-health-adfs
[aad-identity-protection]: /entra/id-protection/overview-identity-protection
[aad-password-management]: /entra/identity/authentication/howto-sspr-customization
[aad-reporting-guide]: /entra/identity/monitoring-health/overview-monitoring-health
[aad-scalability]: /entra/architecture/architecture
[aad-sync-best-practices]: /entra/identity/hybrid/connect/how-to-connect-sync-best-practices-changing-default-configuration
[aad-sync-disaster-recovery]: /entra/identity/hybrid/connect/how-to-connect-sync-staging-server#disaster-recovery
[aad-sync-requirements]: /entra/identity/hybrid/
[aad-topologies]: /entra/identity/hybrid/connect/plan-connect-topologies
[aad-user-sign-in]: /entra/identity/hybrid/connect/plan-connect-user-signin
[adds-azure-design]: ./index.yml
[azure-active-directory]: /entra/identity/domain-services/overview
[azure-ad-connect]: /entra/identity/hybrid/whatis-hybrid-identity
[azure-ad-connect-cloud-sync]:/entra/identity/hybrid/cloud-sync/what-is-cloud-sync
[azure-ad-pricing]: https://azure.microsoft.com/pricing/details/active-directory
[azure-multifactor-authentication]: /azure/multi-factor-authentication/multi-factor-authentication
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[identity-best-practices]: /azure/security/fundamentals/identity-management-best-practices
[microsoft-graph-powershell]: /powershell/module/?view=graph-powershell-1.0
[security-compass-paw]: /security/compass/overview
[sla-aad]: https://azure.microsoft.com/support/legal/sla/active-directory
[staging-mode]: /entra/identity/hybrid/connect/how-to-connect-sync-staging-server
