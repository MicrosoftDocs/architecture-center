<!-- cSpell:ignore writeback MSOL -->

Microsoft Entra ID is a cloud-based directory and identity service. This reference architecture shows best practices for integrating on-premises Active Directory domains with Microsoft Entra ID to provide cloud-based identity authentication.

## Architecture

:::image type="content" source="./images/azure-ad.png" alt-text="Diagram of a hybrid cloud identity architecture that uses Microsoft Entra ID." lightbox="./images/azure-ad.png" border="false" :::

*Access the [Visio diagram](https://office.live.com/start/Visio.aspx?templatetitle=Integrating%20On-Prem%20AD%20domains%20with%20Azure%20AD&templateid=TM11735520) online, through Microsoft 365. Note that you must have a Visio license to access this diagram. Or, download a [Visio file][visio-download] of this architecture (see Visio tab "Microsoft Entra ID").*

> [!NOTE]
> For simplicity, this diagram only shows the connections directly related to Microsoft Entra ID, and not protocol-related traffic that may occur as part of authentication and identity federation. For example, a web application may redirect the web browser to authenticate the request through Microsoft Entra ID. Once authenticated, the request can be passed back to the web application, with the appropriate identity information.
>

For additional considerations, see [Choose a solution for integrating on-premises Active Directory with Azure][considerations].

### Components

The architecture has the following components.

- **Microsoft Entra tenant**. An instance of [Microsoft Entra ID][azure-active-directory] created by your organization. It acts as a directory service for cloud applications by storing objects copied from the on-premises Active Directory and provides identity services.
- **Web tier subnet**. This subnet holds VMs that run a web application. Microsoft Entra ID can act as an identity broker for this application.
- **On-premises AD DS server**. An on-premises directory and identity service. The AD DS directory can be synchronized with Microsoft Entra ID to enable it to authenticate on-premises users.
- **Microsoft Entra Connect Sync server**. An on-premises computer that runs the [Microsoft Entra Connect][azure-ad-connect] sync service. This service synchronizes information held in the on-premises Active Directory to Microsoft Entra ID. For example, if you provision or deprovision groups and users on-premises, these changes propagate to Microsoft Entra ID.

  > [!NOTE]
  > For security reasons, Microsoft Entra ID stores user's passwords as a hash. If a user requires a password reset, this must be performed on-premises and the new hash must be sent to Microsoft Entra ID. Microsoft Entra ID P1 or P2 editions include features that can allow for password changes to happen in the cloud and then be written back to on-premises AD DS.
  >

- **VMs for N-tier application**. For more information about these resources, see [N-tier architecture on virtual machines](/azure/architecture/guide/architecture-styles/n-tier#n-tier-architecture-on-virtual-machines).

## Scenario details

### Potential use cases

Typical uses for this reference architecture include:

- Web applications deployed in Azure that provide access to remote users who belong to your organization.
- Implementing self-service capabilities for end-users, such as resetting their passwords, and delegating group management. This requires Microsoft Entra ID P1 or P2 edition.
- Architectures in which the on-premises network and the application's Azure VNet aren't connected using a VPN tunnel or ExpressRoute circuit.

> [!NOTE]
> Microsoft Entra ID can authenticate the identity of users and applications that exist in an organization's directory. Some applications and services, such as SQL Server, may require computer authentication, in which case this solution is not appropriate.
>

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

<a name='configure-azure-ad-connect-sync-service'></a>

### Configure Microsoft Entra Connect Sync service

The Microsoft Entra Connect Sync service ensures that identity information stored in the cloud is consistent with the identity information stored on-premises. You install this service using the Microsoft Entra Connect software.

Before implementing Microsoft Entra Connect Sync, determine the synchronization requirements of your organization. For example, what to synchronize, from which domains, and how frequently. For more information, see [Determine directory synchronization requirements][aad-sync-requirements].

You can run the Microsoft Entra Connect Sync service on a VM or a computer hosted on-premises. Depending on the volatility of the information in your Active Directory directory, the load on the Microsoft Entra Connect Sync service is unlikely to be high after the initial synchronization with Microsoft Entra ID. Running the service on a VM makes it easier to scale the server if needed. Monitor the activity on the VM as described in the Monitoring considerations section to determine whether scaling is necessary.

If you have multiple on-premises domains in a forest, we recommend storing and synchronizing information for the entire forest to a single Microsoft Entra tenant. Filter information for identities that occur in more than one domain, so that each identity appears only once in Microsoft Entra ID, rather than being duplicated. Duplication can lead to inconsistencies when data is synchronized. For more information, see the Topology section below.

Use filtering so that only necessary data is stored in Microsoft Entra ID. For example, your organization might not want to store information about inactive accounts in Microsoft Entra ID. Filtering can be group-based, domain-based, organization unit (OU)-based, or attribute-based. You can combine filters to generate more complex rules. For example, you could synchronize objects held in a domain that have a specific value in a selected attribute. For detailed information, see [Microsoft Entra Connect Sync: Configure Filtering][aad-filtering].

To implement high availability for the AD Connect sync service, run a secondary staging server. For more information, see the Topology recommendations section.

  > [!NOTE]
  > **[Microsoft Entra Connect cloud sync][azure-ad-connect-cloud-sync]** is a new offering from Microsoft designed to meet and accomplish your hybrid identity goals for synchronization of users, groups, and contacts to Microsoft Entra ID. With Microsoft Entra Connect cloud sync, provisioning from AD to Microsoft Entra ID is orchestrated in Microsoft Online Services.

### Validate security configuration and policy

**User password management**. The Microsoft Entra ID P1 or P2 editions support password writeback, enabling your on-premises users to perform self-service password resets from within the Azure portal. This feature should be enabled only after reviewing your organization's password security policy. For example, you can restrict which users can change their passwords, and you can tailor the password management experience. For more information, see [Customizing Password Management to fit your organization's needs][aad-password-management].

**Protect on-premises applications that can be accessed externally.** Use the Microsoft Entra application proxy to provide controlled access to on-premises web applications to users from outside your network through Microsoft Entra ID. Only users that have valid credentials in your Azure directory have permission to use the application. For more information, see the article [Enable Application Proxy in the Azure portal][aad-application-proxy].

**Actively monitor Microsoft Entra ID for signs of suspicious activity.** Consider using Microsoft Entra ID P2 edition, which includes Microsoft Entra ID Protection. Identity Protection uses adaptive machine learning algorithms and heuristics to detect anomalies and risk events that may indicate that an identity has been compromised. For example, it can detect potentially unusual activity such as irregular sign-in activities, sign-ins from unknown sources or from IP addresses with suspicious activity, or sign-ins from devices that may be infected. Identity Protection uses this data to generate reports and alerts that enable you to investigate these risk events and take appropriate action. For more information, see [Microsoft Entra ID Protection][aad-identity-protection].

You can use the reporting feature of Microsoft Entra ID in the Azure portal to monitor security-related activities occurring in your system. For more information about using these reports, see [Microsoft Entra ID Reporting Guide][aad-reporting-guide].

### Validate network topology

Configure Microsoft Entra Connect to implement a topology that most closely matches the requirements of your organization. Topologies that Microsoft Entra Connect supports include:

- **Single forest, single Microsoft Entra directory**. In this topology, Microsoft Entra Connect synchronizes objects and identity information from one or more domains in a single on-premises forest into a single Microsoft Entra tenant. This topology is the default implementation  by the express installation of Microsoft Entra Connect.

  > [!NOTE]
  > Don't use multiple Microsoft Entra Connect Sync servers to connect different domains in the same on-premises forest to the same Microsoft Entra tenant, unless you are running a server in staging mode, described below.
  >
  >

- **Multiple forests, single Microsoft Entra directory**. In this topology, Microsoft Entra Connect synchronizes objects and identity information from multiple forests into a single Microsoft Entra tenant. Use this topology if your organization has more than one on-premises forest. You can consolidate identity information so that each unique user is represented once in the Microsoft Entra directory, even if the user exists in more than one forest. All forests use the same Microsoft Entra Connect Sync server. The Microsoft Entra Connect Sync server doesn't have to be part of any domain, but it must be reachable from all forests.

  > [!NOTE]
  > In this topology, don't use separate Microsoft Entra Connect Sync servers to connect each on-premises forest to a single Microsoft Entra tenant. This can result in duplicated identity information in Microsoft Entra ID if users are present in more than one forest.
  >

- **Multiple forests, separate topologies**. This topology merges identity information from separate forests into a single Microsoft Entra tenant, treating all forests as separate entities. This topology is useful if you're combining forests from different organizations and the identity information for each user is held in only one forest.

  > [!NOTE]
  > If the global address lists (GAL) in each forest are synchronized, a user in one forest may be present in another as a contact. This can occur if your organization has implemented GALSync with Forefront Identity manager 2010 or Microsoft Identity Manager 2016. In this scenario, you can specify that users should be identified by their *Mail* attribute. You can also match identities using the *ObjectSID* and *msExchMasterAccountSID* attributes. This is useful if you have one or more resource forests with disabled accounts.
  >

- **Staging server**. In this configuration, you run a second instance of the Microsoft Entra Connect Sync server in parallel with the first. This structure supports scenarios such as:

  - High availability.
  - Testing and deploying a new configuration of the Microsoft Entra Connect Sync server.
  - Introducing a new server and decommissioning an old configuration.

    In these scenarios, the second instance runs in *staging mode*. The server records imported objects and synchronization data in its database, but doesn't pass the data to Microsoft Entra ID. If you disable staging mode, the server starts writing data to Microsoft Entra ID, and also starts performing password write-backs into the on-premises directories where appropriate. For more information, see [Microsoft Entra Connect Sync: Operational tasks and considerations][aad-connect-sync-operational-tasks].

- **Multiple Microsoft Entra directories**. Typically you create a single Microsoft Entra directory for an organization, but there may be situations where you need to partition information across separate Microsoft Entra directories. In this case, avoid synchronization and password write-back issues by ensuring that each object from the on-premises forest appears in only one Microsoft Entra directory. To implement this scenario, configure separate Microsoft Entra Connect Sync servers for each Microsoft Entra directory, and use filtering so that each Microsoft Entra Connect Sync server operates on a mutually exclusive set of objects.

For more information about these topologies, see [Topologies for Microsoft Entra Connect][aad-topologies].

### Configure user authentication method

By default, the Microsoft Entra Connect Sync server configures password hash synchronization between the on-premises domain and Microsoft Entra ID. The Microsoft Entra service assumes that users authenticate by providing the same password that they use on-premises. For many organizations, this strategy is appropriate, but you should consider your organization's existing policies and infrastructure. For example:

- The security policy of your organization may prohibit synchronizing password hashes to the cloud. In this case, your organization should consider [pass-through authentication](/entra/identity/hybrid/connect/how-to-connect-pta).
- You might require that users experience seamless single sign-on (SSO) when accessing cloud resources from domain-joined machines on the corporate network.
- Your organization might already have Active Directory Federation Services (AD FS) or a third-party federation provider deployed. You can configure Microsoft Entra ID to use this infrastructure to implement authentication and SSO rather than by using password information held in the cloud.

For more information, see [Microsoft Entra Connect User Sign-on options][aad-user-sign-in].

<a name='configure-azure-ad-application-proxy'></a>

### Configure Microsoft Entra application proxy

Use Microsoft Entra ID to provide access to on-premises applications.

Expose your on-premises web applications using application proxy connectors managed by the Microsoft Entra application proxy component. The application proxy connector opens an outbound network connection to the Microsoft Entra application proxy. Remote users' requests are routed back from Microsoft Entra ID through this proxy connection to the web apps. This configuration removes the need to open inbound ports in the on-premises firewall and reduces the attack surface exposed by your organization.

For more information, see [Publish applications using Microsoft Entra application proxy][aad-application-proxy].

<a name='configure-azure-ad-object-synchronization'></a>

### Configure Microsoft Entra object synchronization

The default configuration for Microsoft Entra Connect synchronizes objects from your local Active Directory directory based on the rules specified in the article [Microsoft Entra Connect Sync: Understanding the default configuration][aad-connect-sync-default-rules]. Objects that satisfy these rules are synchronized while all other objects are ignored. Some example rules:

- User objects must have a unique *sourceAnchor* attribute and the *accountEnabled* attribute must be populated.
- User objects must have a *sAMAccountName* attribute and can't start with the text *Azure AD_* or *MSOL_*.

Microsoft Entra Connect applies several rules to User, Contact, Group, ForeignSecurityPrincipal, and Computer objects. Use the Synchronization Rules Editor installed with Microsoft Entra Connect if you need to modify the default set of rules. For more information, see [Microsoft Entra Connect Sync: Understanding the default configuration][aad-connect-sync-default-rules]).

You can also define your own filters to limit the objects to be synchronized by domain or OU. Alternatively, you can implement more complex custom filtering such as that described in [Microsoft Entra Connect Sync: Configure Filtering][aad-filtering].

### Configure monitoring agents

Health monitoring is performed by the following agents installed on-premises:

- Microsoft Entra Connect installs an agent that captures information about synchronization operations. Use the Microsoft Entra Connect Health blade in the Azure portal to monitor its health and performance. For more information, see [Using Microsoft Entra Connect Health for sync][aad-health].
- To monitor the health of the AD DS domains and directories from Azure, install the Microsoft Entra Connect Health for AD DS agent on a machine within the on-premises domain. Use the Microsoft Entra Connect Health blade in the Azure portal for health monitoring. For more information, see [Using Microsoft Entra Connect Health with AD DS][aad-health-adds]
- Install the Microsoft Entra Connect Health for AD FS agent to monitor the health of services running on on-premises, and use the Microsoft Entra Connect Health blade in the Azure portal to monitor AD FS. For more information, see [Using Microsoft Entra Connect Health with AD FS][aad-health-adfs]

For more information on installing the AD Connect Health agents and their requirements, see [Microsoft Entra Connect Health Agent Installation][aad-agent-installation].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The Microsoft Entra service is geo-distributed and runs in multiple datacenters spread around the world with automated failover. If a datacenter becomes unavailable, Microsoft Entra ID ensures that your directory data is available for instance access in at least two more regionally dispersed datacenters.

> [!NOTE]
> The service level agreement (SLA) for the Microsoft 365 Apps AD tier and Premium services guarantees at least 99.9% availability. There is no SLA for the Free tier of Microsoft Entra ID. For more information, see [SLA for Microsoft Entra ID][sla-aad].
>

Consider provisioning a second instance of Microsoft Entra Connect Sync server in staging mode to increase availability, as discussed in the topology recommendations section.

If you aren't using the SQL Server Express LocalDB instance that comes with Microsoft Entra Connect, consider using SQL clustering to achieve high availability. Solutions such as mirroring and Always On aren't supported by Microsoft Entra Connect.

For additional considerations about achieving high availability of the Microsoft Entra Connect Sync server and also how to recover after a failure, see [Microsoft Entra Connect Sync: Operational tasks and considerations - Disaster Recovery][aad-sync-disaster-recovery].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Use conditional access control to deny authentication requests from unexpected sources:

- Trigger [Microsoft Entra multifactor authentication (MFA)][azure-multifactor-authentication] if a user attempts to connect from an untrusted location such as across the Internet instead of a trusted network.

- Use the device platform type of the user (iOS, Android, Windows Mobile, Windows) to determine access policy to applications and features.

- Record the enabled/disabled state of users' devices, and incorporate this information into the access policy checks. For example, if a user's phone is lost or stolen it should be recorded as disabled to prevent it from being used to gain access.

- Control user access to resources based on group membership. Use [Microsoft Entra dynamic membership rules][aad-dynamic-membership-rules] to simplify group administration. For a brief overview of how this works, see [Introduction to Dynamic Memberships for Groups][aad-dynamic-memberships].

- Use Conditional Access risk-based policies with Microsoft Entra ID Protection to provide advanced protection based on unusual sign-in activities or other events.

For more information, see [Microsoft Entra Conditional Access][aad-conditional-access].

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.

Cost considerations include:

- **Microsoft Entra Connect** - The Microsoft Entra Connect synchronization feature is available in all editions of Microsoft Entra ID.

  - There a no additional license requirements for using Microsoft Entra Connect and is included in your Azure subscription.

  - For pricing information about the editions of Microsoft Entra ID, see [Microsoft Entra pricing][Azure-AD-pricing].

- **VMs for N-Tier application** - For cost information about these resources, see [Architecture best practices for Virtual Machines and scale sets](/azure/well-architected/service-guides/virtual-machines).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Manageability

There are two aspects to managing Microsoft Entra ID:

- Administering Microsoft Entra ID in the cloud.
- Maintaining the Microsoft Entra Connect Sync servers.

Microsoft Entra ID provides the following options for managing domains and directories in the cloud:

- **[Microsoft Graph PowerShell Module][microsoft-graph-powershell]** - used to script common Microsoft Entra administrative tasks such as user management, domain management, and configuring single sign-on.
- **[Microsoft Entra management blade in the Azure portal](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade)** - provides an interactive management view of the directory, and enables you to control and configure most aspects of Microsoft Entra ID.

Microsoft Entra Connect installs the following tools to maintain Microsoft Entra Connect Sync services from your on-premises machines:

- **Microsoft Entra Connect console** - allows you to modify the configuration of the Azure AD Sync server, customize how synchronization occurs, enable or disable staging mode, and switch the user sign-in mode. You can enable Active Directory FS sign-in using your on-premises infrastructure.
- **Synchronization Service Manager** - use the *Operations* tab in this tool to manage the synchronization process and detect whether any parts of the process have failed. You can trigger synchronizations manually using this tool. The *Connectors* tab enables you to control the connections for the domains that the synchronization engine is attached to.
- **Synchronization Rules Editor** - allows you to customize the way objects are transformed when they're copied between an on-premises directory and Microsoft Entra ID. This tool enables you to specify additional attributes and objects for synchronization, then executes filters to determine which objects should or shouldn't be synchronized. For more information, see the Synchronization Rule Editor section in the document [Microsoft Entra Connect Sync: Understanding the default configuration][aad-connect-sync-default-rules].

For more information and tips for managing Microsoft Entra Connect, see [Microsoft Entra Connect Sync: Best practices for changing the default configuration][aad-sync-best-practices].

#### DevOps

For DevOps considerations, see Operational excellence in [Extending Active Directory Domain Services (AD DS) to Azure](adds-extend-domain.yml#operational-excellence).

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The Microsoft Entra service supports scalability based on replicas, with a single primary replica that handles write operations plus multiple read-only secondary replicas. Microsoft Entra ID transparently redirects attempted writes made against secondary replicas to the primary replica and provides eventual consistency. All changes made to the primary replica are propagated to the secondary replicas. This architecture scales well because most operations against Microsoft Entra ID are reads rather than writes. For more information, see [What is the Microsoft Entra architecture?][aad-scalability]

For the Microsoft Entra Connect Sync server, determine how many objects you're likely to synchronize from your local directory. If you have less than 100,000 objects, you can use the default SQL Server Express LocalDB software provided with Microsoft Entra Connect. If you have a larger number of objects, you should install a production version of SQL Server and perform a custom installation of Microsoft Entra Connect, specifying that it should use an existing instance of SQL Server.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Eric Woodruff](https://www.linkedin.com/in/msfthiker) | Product Technical Specialist 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Review [Topologies for Microsoft Entra Connect][aad-topologies] to ensure the hybrid topology for Microsoft Entra Connect is deployed in a supported configuration.
- Learn about using conditional access to protect access to your applications, with [Plan a Conditional Access deployment][aad-ca-plan].
- For more information on providing AD DS in Azure as infrastructure, review [Integrating on-premises AD with Azure][adds-azure-design].
- Review [Microsoft Entra application proxy][aad-application-proxy] if you intend on providing Microsoft Entra integrations with on-premises or cloud IaaS applications.
- Because identity is the new control plane for security, review [Identity Management Best Practices][identity-best-practices].
- Furthermore, as deploying this solution requires highly privileged accounts, review [Securing privileged access][security-compass-paw], to understand security controls for privileged accounts.

## Related resources

* [Manage identity in multitenant applications](../../multitenant-identity/index.yml)
* [Integrate on-premises AD with Azure](./index.yml)
* [Extend on-premises AD FS to Azure](./adfs.yml)

<!-- links -->

[aaf-cost]: /azure/architecture/framework/cost/overview

[aad-agent-installation]: /entra/identity/hybrid/connect/how-to-connect-health-agent-install

[aad-application-proxy]: /entra/identity/app-proxy/application-proxy-add-on-premises-application

[aad-conditional-access]: /entra/id-protection/concept-identity-protection-policies

[aad-connect-sync-default-rules]: /entra/identity/hybrid/connect/concept-azure-ad-connect-sync-default-configuration

[aad-connect-sync-operational-tasks]: /entra/identity/hybrid/connect/how-to-connect-sync-staging-server

[aad-dynamic-memberships]: https://youtu.be/Tdiz2JqCl9Q

[aad-dynamic-membership-rules]: /entra/identity/users/groups-dynamic-membership

[aad-filtering]: /entra/identity/hybrid/connect/how-to-connect-sync-configure-filtering

[aad-health]: /entra/identity/hybrid/connect/how-to-connect-health-sync

[aad-health-adds]: /entra/identity/hybrid/connect/how-to-connect-health-adds

[aad-health-adfs]: /entra/identity/hybrid/connect/how-to-connect-health-adfs

[aad-identity-protection]: /entra/id-protection/overview-identity-protection

[aad-password-management]: /entra/identity/authentication/howto-sspr-customization

[aad-powershell]: /powershell/module/azuread/?view=azureadps-2.0

[microsoft-graph-powershell]: /powershell/module/?view=graph-powershell-1.0

[aad-reporting-guide]: /entra/identity/monitoring-health/overview-monitoring-health

[aad-scalability]: /entra/architecture/architecture

[aad-sync-best-practices]: /entra/identity/hybrid/connect/how-to-connect-sync-best-practices-changing-default-configuration

[aad-sync-disaster-recovery]: /entra/identity/hybrid/connect/how-to-connect-sync-staging-server#disaster-recovery

[aad-sync-requirements]: /entra/identity/hybrid/

[aad-topologies]: /entra/identity/hybrid/connect/plan-connect-topologies

[aad-user-sign-in]: /entra/identity/hybrid/connect/plan-connect-user-signin

[AAF-devops]: /azure/architecture/framework/devops/overview

[azure-active-directory]: /entra/identity/domain-services/overview

[azure-ad-connect]: /entra/identity/hybrid/whatis-hybrid-identity

[Azure-AD-pricing]: https://azure.microsoft.com/pricing/details/active-directory

[azure-multifactor-authentication]: /azure/multi-factor-authentication/multi-factor-authentication

[considerations]: ./index.yml

[sla-aad]: https://azure.microsoft.com/support/legal/sla/active-directory

[visio-download]: https://arch-center.azureedge.net/identity-architectures.vsdx

[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator

[aad-ca-plan]: /entra/identity/conditional-access/plan-conditional-access

[adds-azure-design]: ./index.yml

[identity-best-practices]: /azure/security/fundamentals/identity-management-best-practices

[security-compass-paw]: /security/compass/overview

[security-compass]:/security/compass/compass

[azure-ad-connect-cloud-sync]:/entra/identity/hybrid/cloud-sync/what-is-cloud-sync
