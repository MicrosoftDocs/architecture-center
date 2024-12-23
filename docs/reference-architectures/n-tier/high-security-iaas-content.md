There are many security considerations for deploying *infrastructure-as-a-service (IaaS)* apps to Azure. This article builds on reference architectures for virtual machine-based workloads and hybrid network infrastructures to focus on security for highly sensitive IaaS workloads in Azure, based on [Azure security fundamentals](/azure/security/fundamentals/).

Also see [Azure virtual machines security overview](/azure/security/fundamentals/virtual-machines-overview) and [Security best practices for IaaS workloads in Azure](/azure/security/fundamentals/iaas).

## Azure VMs

Azure's compute platform is based on machine virtualization. A *hypervisor* runs on the physical hardware of each Azure node or network endpoint and creates a variable number of guest [Hyper-V virtual machines (VMs)](/virtualization/hyper-v-on-windows/about/) in the node. All user code executes on the VMs. For basic Azure VM deployment instructions, see [Run a Linux VM on Azure](./linux-vm.yml) or [Run a Windows VM on Azure](./windows-vm.yml). Most deployment processes are the same for the two operating systems (OSs), but OS-specific tools like disk encryption may differ.

You should use [Microsoft Defender for Cloud](https://azure.microsoft.com/services/security-center/) for VM patch management and to deploy and monitor [antimalware tools](/security/benchmark/azure/security-control-malware-defense). Alternatively, manage your own or third-party patching and antimalware tools, which is common when extending or migrating existing infrastructures to Azure.

### Choosing Virtual Machine Images

Virtual machines in Azure are created from a baseline image. These typically are chosen from available images in the Azure Marketplace but can also be customized images created by customers for their specific requirements.

Unless there are compatibility issues, the most recent versions of these images should be used when creating new virtual machines and immediately updated with the latest security updates after deployment.

Third parties have also made images available that meet even more stringent security requirements. For example, the [Center for Internet Security](https://www.cisecurity.org/cis-hardened-images) has created Windows and Linux images that are pre-hardened and made them available through the Marketplace as well.

In addition to choosing a secure image, there are available virtual machine types – [Trusted Launch](/azure/virtual-machines/trusted-launch) and [Confidential](/azure/confidential-computing/confidential-vm-overview) – that can be used to ensure a secure compute environment from the moment the virtual machine is booted.

**Trusted Launch**, now selected as the default state for newly created Azure VMs, ensures that boot loaders, operating system kernels, and drivers are all verified to minimize the chance of advanced and persistent attack techniques.

**Confidential** VMs offer strong security and confidentiality for tenants by creating a hardware-enforced boundary between applications and the virtualization stack. It has a secure boot capability similar to Trusted Launch VMs, while leveraging additional cryptographic validation features to protect application code and data.

### Isolate Compute Resources

On each Azure node or network endpoint, the hypervisor and a special root OS ensure guest VMs can't access the physical host server, and user code executes only on guest VMs. This isolation prevents users from obtaining raw read, write, or execute access to the system, and mitigates the risk of sharing resources. Azure protects against all known *side-channel attacks* and *noisy neighbors* through the hypervisor and an advanced VM placement algorithm. For more information, see [Compute isolation](/azure/security/fundamentals/isolation-choices#compute-isolation).

For highly sensitive workloads, you can add additional protection against side-channel attacks with [isolated VMs](/azure/security/fundamentals/isolation-choices#isolated-virtual-machine-sizes) or dedicated hosts.

#### Isolated VMs

Isolated VMs are large VM sizes that are isolated to a specific hardware type and dedicated to a single customer. Using an isolated VM size guarantees that your VM is the only one running on a specific server instance. You can further subdivide the resources of isolated VMs by using [nested virtual machines](/virtualization/hyper-v-on-windows/user-guide/nested-virtualization).

The minimum size of an isolated VM is 64 virtual CPU cores and 256 GiB of memory. These VMs are far larger than most n-tier applications require and can create a large cost overhead. To reduce the overhead, you can run multiple app tiers on a single VM with nested virtualization, or in different processes or containers. You still need to deploy different VMs in availability zones for resiliency and run [demilitarized zone (DMZ) appliances](#deploy-a-dmz) on separate VMs. Combining multiple apps on one infrastructure for economic reasons might also conflict with organizational app segregation policies.

As Azure region capabilities expand over time, Azure may also remove isolation guarantees from certain VM sizes, with one year's notice.

#### Azure Dedicated Hosts

[Azure Dedicated Host](/azure/virtual-machines/dedicated-hosts) is the preferred compute isolation solution for highly sensitive workloads. A dedicated host is a physical server dedicated to one customer for hosting multiple VMs. Besides isolating VMs, dedicated hosts let you control [maintenance](/azure/virtual-machines/maintenance-control-powershell) and VM placement to avoid noisy neighbors.

![Dedicated hosts](images/dedicated-hosts.png)

Dedicated hosts have the same minimum size and many of the same sizing considerations as isolated VMs. However, a dedicated host can host VMs located in different virtual networks, to satisfy application segregation policies. You should still run [DMZ](#deploy-a-dmz) VMs on a different host, to prevent any side-channel attack from a compromised VM in the DMZ.

### Secure VMs after Deployment

After virtual machines are deployed, they need to be continually monitored for potential issues and security risks. [Microsoft Defender for Cloud](https://azure.microsoft.com/services/security-center/) should be used to evaluate security posture across servers and other resources. Use Defender to ensure that Microsoft Antimalware is installed on Windows clients. [Microsoft Antimalware](/azure/virtual-machines/extensions/iaas-antimalware-windows) is a free real-time protection client that helps identify and remove viruses, spyware, and other malicious software. Alternatively, third-party tools can be used, which is common when extending or migrating existing infrastructures to Azure.

To ensure that virtual machines are always up to date with the last security patches, use [Azure Update Manager.](/azure/update-manager/overview) This service helps to manage and govern updates for all machines in your environment. This includes managing updates for machines on-premises and/or running in other cloud platforms through the use of [Azure Arc](/azure/azure-arc/).

__Visibility to the Internet__

Exposing virtual machines directly to the public internet should only be done when absolutely necessary, and if so, every precaution should be taken to keep them secure.

Providing Remote Desktop Protocol (RDP) or Secure Sockets Host (SSH) access to virtual machines over the internet is highly discouraged. Virtual machines should never have a Public IP instance directly associated with their virtual network cards. If this type of access is required, [Azure Bastion](/azure/bastion/bastion-overview) should be used. Bastion is a managed service that will allow secure access to Azure virtual machines through their private IP addresses over a secure TLS connection, reducing the attack surface.

__Backup Virtual Machines__

Use [Azure Backup](/azure/backup/backup-overview) to protect virtual machine workloads. Azure Backup is a simple and secure solution to backup Azure resource data. It provides features to protect against accidental or intentional deletion of backup data and allows restoring data across regions. Using integration with Azure Key Vault, encrypted virtual machine disks can be backed up and restored for additional layers of protection.

## Networking

Virtual machines within Azure must run in the context of a [virtual network](/azure/virtual-network/virtual-networks-overview). Similar to traditional on-premises networks, Azure virtual networks facilitate communication between resources running in Azure, on-premises, and on the public internet. And also like on-premises networks, there are various ways to ensure virtual networks in Azure provide a secure foundation for the resources connected to them.

### Segmentation

**Subnets**

Azure virtual networks must be segmented into separate subnets, with each subnet hosting resources that provide similar functionality and security profiles. For example, web servers should be in a separate subnet than servers hosting databases or application servers. With these workloads separated, security boundaries can be established that limit what types of traffic are allowed in and out of the subnets. Be sure to restrict traffic to only what is needed for an application to work or for administrators to manage the servers in the subnets. All other traffic should be denied or dropped.

**Hybrid Networking**

Hybrid architectures connect on-premises networks with public clouds like Azure. There are several ways to connect on-premises networks to applications running in Azure:

- **Azure or third-party VPN gateway**. On-premises networks can communicate with Azure virtual networks by using an [Azure VPN gateway](/azure/expressroute/expressroute-howto-coexist-resource-manager). Traffic still travels over the internet, but over an encrypted tunnel that uses IPSec. A third-party gateway in a virtual machine is also an option if you have specific requirements not supported by the Azure VPN gateway.

- **ExpressRoute**. ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure, and provides scalability and a reliable service-level agreement (SLA).
  - [ExpressRoute with VPN failover](../hybrid-networking/expressroute-vpn-failover.yml). This option uses ExpressRoute in normal conditions, but fails over to a VPN connection if there's a loss of connectivity in the ExpressRoute circuit, providing higher availability.
  - [VPN over ExpressRoute](/azure/expressroute/site-to-site-vpn-over-microsoft-peering). This option is the best for highly sensitive workloads. ExpressRoute provides a private circuit with scalability and reliability, and VPN provides an additional layer of protection that terminates the encrypted connection in a specific Azure virtual network.
    
For more guidance on choosing between different types of hybrid connectivity, see [Choose a solution for connecting an on-premises network to Azure](../hybrid-networking/index.yml).

### Ingress/Egress

Few workloads are self-contained to where they do not need to communicate with resources running in other security contexts. The following components can help to analyze and restrict traffic flowing in and out of Azure virtual networks, enforcing security rules to minimize threats.

**Network Security Groups**

[Network security groups (NSGs)](/azure/virtual-network/security-overview) filter traffic between resources in Azure virtual networks. NSG security rules allow or deny network traffic to or from Azure resources based on IP addresses and ports. By default, NSGs block traffic to and from the internet. To improve security, Azure now prevents outbound internet traffic by default, and internet-outbound traffic must be explicitly allowed through the use of [recommended network architectures](/azure/virtual-network/ip-services/default-outbound-access).

NSGs create flow records for existing connections and allow or deny communication based on the flow record's connection state. The flow record allows an NSG to be stateful. For example, if you specify an outbound security rule to any address over port 443, it's not necessary to also specify an inbound security rule for the response. You only need to specify an inbound security rule if the communication is initiated externally.

NSGs can be assigned to the virtual network interface card (NIC) of a virtual machine, to a subnet within a virtual network, or multiple NSGs can be used in tandem to additional security with one assigned to the NIC and another assigned to the subnet. This will allow more restrictive traffic filtering where more traffic is permitted into the subnet, but certain virtual machines in that subnet should not accept that traffic, for example.

**Application Security Groups**

To filter traffic between application tiers within a virtual network, use [Application security groups (ASGs)](/azure/virtual-network/application-security-groups). ASGs let you configure network security as an extension of an application's structure, letting you group VMs and define network security policies based on the groups. You can reuse your security policy at scale without manually maintaining explicit IP addresses.

![Application security groups](images/asg.png)

Since ASGs are applied to a network interface instead of a subnet, they enable micro-segmentation. You can tightly control which VMs can talk to each other, even blocking traffic between VMs in the same tier, and making it easy to quarantine a VM by removing ASGs from that VM.

**Network Firewalls**

Another way to control network security is through [virtual network traffic routing](/azure/virtual-network/virtual-networks-udr-overview) and *forced tunneling*. Azure automatically creates system routes and assigns the routes to each subnet in a virtual network. You can't create or remove system routes, but you can override some system routes with custom routes. Custom routing lets you route traffic over a *network virtual appliance (NVA)* like a firewall or proxy, or drop unwanted traffic, which has a similar effect to blocking the traffic with an NSG.

You can use NVAs like [Azure Firewall](/azure/firewall/overview) to allow, block, and inspect network traffic. Azure Firewall is a managed, highly available platform firewall service. You can also deploy third-party NVAs from the [Azure Marketplace](https://azuremarketplace.microsoft.com). To make these NVAs highly available, see [Deploy highly available network virtual appliances](../../networking/guide/nva-ha.yml).

**Web Application Firewalls**

If your workloads are web-based, they should be protected with a web application firewall. [Web Application Firewalls](/azure/web-application-firewall/overview) (WAFs) provide protection for web applications from common exploits and vulnerabilities. They protect web applications from malicious attacks such as SQL injection and cross-site scripting. Azure Web Application Firewalls are available for use with Azure Application Gateway, Azure Front Door, and Azure Content Delivery Network (CDN) service from Microsoft (currently in Preview). WAFs have customized features for each of these services.

**Service Endpoints / Private Endpoints**

Even though the focus of this article is IaaS security, many IaaS workloads rely on other services for a complete solution, such as storage accounts or databases. If these services are PaaS services, they likely have a public endpoint for consumers to access them, providing a potential attack vector. These public endpoints should be disabled, allowing only access from the internal network, through Service Endpoints or Private Endpoints.

[Service Endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview) allow securing Azure services to only your virtual networks by providing secure and direct connectivity to Azure services over an optimized route over the Azure backbone network. This limits the need for a public IP address for the resource. There is additional configuration needed to allow [secure Azure service access from on-premises](/azure/virtual-network/virtual-network-service-endpoints-overview).

[Private Endpoints](/azure/private-link/private-endpoint-overview) use a virtual network interface card to essentially bring the instance of the service into your virtual network. The virtual NIC is assigned a private IP address from the subnet where it is deployed, which all resources can use either through DNS resolution or directly through the IP to access that secured instance. The service can be directly accessed from on-premises using that private IP address.

**DDoS Protection**

[Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) helps to protect resources from Distributed Denial of Service (DDoS) attacks., particularly when used in conjunction with application design proven practices. It is tuned to help protect Azure resources in a virtual network without any application or resource changes. For additional protection, Azure [offers 2 enhanced tiers](/azure/ddos-protection/ddos-protection-sku-comparison) of DDoS protection.

Azure DDoS IP Protection is a pay-per-protected IP model and is largely targeted at small and medium sized businesses that have a smaller number of IP addresses to protect. But it does include a large number of features including always on traffic monitoring, adaptive real time tuning, analytics, metrics, and alerting, and much more.

Azure DDoS Network Protection provides enhanced mitigation features and is automatically tuned to help protect your Azure resources in a virtual network. It contains all of the features of DDoS IP Protection and also adds DDoS rapid response support, cost protection, and discounts on Web Application Firewalls.

## Azure Platform

## Encryption

Data encryption is an important component of securing workloads. Encryption encodes information so only authorized receivers can decode it by using a key or certificate. Encryption includes *disk encryption*, for data encryption-at-rest, and *Transport Level Security (TLS)*, for encryption-in-transit over networks.

### Azure Key Vault

You can protect encryption keys and certificates by storing them in [Azure Key Vault](https://azure.microsoft.com/services/key-vault/), a cloud *Hardware Security Module (HSM)* solution validated for Federal Information Processing Standards (FIPS) 140-2 Level 2. For best practices to allow only authorized applications and users to access Key Vault, see [Secure access to a key vault](/azure/key-vault/key-vault-secure-your-key-vault).

To protect keys in Key Vault, you can enable [soft delete](/azure/key-vault/key-vault-ovw-soft-delete), which ensures that deleted keys are recoverable. For additional protection, you can [back up individual keys](/powershell/module/azurerm.keyvault/backup-azurekeyvaultkey) to an encrypted file that you can use to [restore the keys](/powershell/module/azurerm.keyvault/restore-azurekeyvaultkey), potentially to another Azure region in the same geography.

When hosting SQL Server on a VM, you can use the [SQL Server Connector for Microsoft Azure Key Vault](/sql/relational-databases/security/encryption/extensible-key-management-using-azure-key-vault-sql-server) to get keys for *transparent data encryption (TDE)*, *column level encryption (CLE)*, and backup encryption. For details, see [Configure Azure Key Vault integration for SQL Server on Azure virtual machines](/azure/azure-sql/virtual-machines/windows/azure-key-vault-integration-configure).

### Azure Disk Encryption

Azure Disk Encryption uses a BitLocker external key protector to provide volume encryption for the OS and data disks of Azure VMs, and can be integrated with Azure Key Vault to help you control and manage disk encryption keys and secrets. Each VM generates its own encryption keys and stores them in Azure Key Vault. To configure Azure Key Vault to enable Azure Disk Encryption, see [Create and configure a key vault for Azure Disk Encryption](/azure/virtual-machines/windows/disk-encryption-key-vault).

For highly sensitive workloads, you should also use a *key encryption key (KEK)* for an additional layer of security. When you specify a KEK, Azure Disk Encryption uses that key to wrap the encryption secrets before writing to Key Vault. You can generate a KEK in Azure Key Vault, but a more secure method is to generate a key in your on-premises HSM and import it to Azure Key Vault. This scenario is often referred to as *bring your own key*, or BYOK. Because the imported keys can't leave the HSM boundary, generating the key in your HSM ensures you're in full control of the encryption keys.

![HSM-protected encryption](images/encryption.png)

For more information about HSM-protected keys, see [How to generate and transfer HSM-protected keys for Azure Key Vault](/azure/key-vault/key-vault-hsm-protected-keys).

### Network traffic encryption

Network protocols like HTTPS encrypt data in transit with certificates. Client-to-application traffic usually uses a certificate from a trusted *certificate authority (CA)*. Internal apps can use a certificate from an internal CA or a public CA like DigiCert or GlobalSign. Tier-to-tier communication typically uses a certificate issued by an internal CA, or a self-signed certificate. Azure Key Vault can accommodate any of these certificate types. For more information about creating different certificate types, see [Certificate creation methods](/azure/key-vault/create-certificate).

Azure Key Vault can act as a self-signed certificate CA for tier-to-tier traffic. The *Key Vault VM extension* provides monitoring and automatic refresh of specified certificates on VMs, with or without the private key depending on use case. To use the Key Vault VM extension, see [Key Vault virtual machine extension for Linux](/azure/virtual-machines/extensions/key-vault-linux) or [Key Vault virtual machine extension for Windows](/azure/virtual-machines/extensions/key-vault-windows).

Key Vault can also store keys for network protocols that don't use certificates. Custom workloads could require scripting a [custom script extension](/azure/virtual-machines/windows/tutorial-automate-vm-deployment) that retrieves a key from Key Vault and stores it for applications to use. Apps can also use a VM's [managed identity](/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-nonaad) to retrieve secrets directly from Key Vault.

### Deploy a DMZ

Connecting on-premises and Azure environments gives on-premises users access to Azure applications. A perimeter network or *demilitarized zone (DMZ)* provides additional protection for highly sensitive workloads.

An architecture like the one in [Network DMZ between Azure and an on-premises datacenter](../dmz/secure-vnet-dmz.yml) deploys all DMZ and application services in the same virtual network, with NSG rules and user-defined routes to isolate the DMZ and application subnets. This architecture can make the management subnet available via public internet, to manage apps even if the on-premises gateway isn't available. However, for highly sensitive workloads, you should only allow bypassing the gateway in a [break glass scenario](/azure/active-directory/users-groups-roles/directory-emergency-access). A better solution is to use [Azure Bastion](https://azure.microsoft.com/services/azure-bastion/), which enables access directly from the Azure portal while limiting exposure of public IP addresses.

You can also use [Just-In-Time (JIT) VM access](/azure/security-center/security-center-just-in-time) for remote management while limiting exposure of public IP addresses. With JIT VM access, an NSG blocks remote management ports like *remote desktop protocol (RDP)* and *secure shell (SSH)* by default. Upon request, JIT VM access enables the port only for a specified time window, and potentially for a specific IP address or range. JIT access also works for VMs that have only private IP addresses. You can use Azure Bastion to block traffic to a VM until JIT VM access is enabled.

To deploy more applications, you can use a [hub-spoke network topology](../../networking/architecture/hub-spoke.yml) in Azure, with the DMZ in the hub virtual network and the applications in spoke virtual networks. The hub virtual network can contain a VPN and/or ExpressRoute gateway, firewall NVA, management hosts, identity infrastructure, and other shared services. The spoke virtual networks are connected to the hub with [virtual network peering](/azure/virtual-network/virtual-network-peering-overview). An Azure virtual network doesn't allow transitive routing over the hub from one spoke to another. Spoke-to-spoke traffic is only possible via the firewall appliances in the hub. This architecture effectively isolates applications from one another.

## Multi-region deployment

Business continuity and disaster recovery might require deploying your application across multiple Azure regions, which can impact data residency and security. For a reference architecture for multi-region deployments, see [Run an N-tier application in multiple Azure regions for high availability](../../reference-architectures/n-tier/multi-region-sql-server.yml).

### Regional pairs

An Azure geography is a defined area of the world that contains at least one Azure region, each with one or more datacenters. Each Azure region is paired with another region in the same geography in a *regional pair*. Regional pairs aren't both updated at the same time, and if a disaster hits both regions, one of the regions is prioritized to come back online first. For business continuity, you should deploy highly sensitive apps at least to regional pairs if you deploy in multiple regions.

For more details, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions). The whitepaper [Achieve compliant data residency and security with Azure](https://azure.microsoft.com/resources/achieving-compliant-data-residency-and-security-with-azure/) discusses data residency, and what to do to meet data residency requirements.

### Replication between regions

In IaaS architectures, replicating data between regions is the responsibility of the application. The most common replication scenario uses database replication technologies built into the database server product, such as [SQL Server Always On Availability Groups](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server), [Oracle Data Guard](https://www.oracle.com/database/technologies/high-availability/dataguard.html), or [MySQL Replication](https://dev.mysql.com/doc/refman/8.0/en/replication.html).

Setting up replication between IaaS database servers isn't straightforward, and you need to take business continuity requirements into account. Azure database services such as [Azure SQL Database](/azure/sql-database/sql-database-designing-cloud-solutions-for-disaster-recovery), Azure Database for MySQL, and [Azure Cosmos DB](/azure/cosmos-db/distribute-data-globally) make replication between regions easier, but may not meet security requirements for highly sensitive workloads.

For more information and guidance for multi-region SQL Server and Oracle deployments, see:

- [Configure an availability group on Azure virtual machines running SQL Server in different regions](/azure/azure-sql/virtual-machines/windows/availability-group-manually-configure-multiple-regions)
- [Disaster recovery for an Oracle Database 12c database in an Azure environment](/azure/virtual-machines/workloads/oracle/oracle-disaster-recovery)

### Cross-region peering

You can enable secure communication between virtual networks in different regions by using global [virtual network peering](/azure/virtual-network/virtual-network-peering-overview). Global peering works the same as within-region peering. The traffic between regions runs over the Microsoft backbone, doesn't traverse the internet, and is isolated from other traffic. For more security, you can deploy VPN NVAs in both regions, and use *user-defined routes* to force traffic between regions over the NVAs, similar to [deploying a DMZ](#deploy-a-dmz).

### Failover traffic routing

With public endpoints, you can use [Traffic Manager](/azure/traffic-manager/) or [Azure Front Door](/azure/frontdoor/) to direct traffic to the active region or closest region in an *active-active* failover configuration. However, Traffic Manager and Azure Front Door both require public endpoints to monitor availability, and their corresponding DNS entries are public. For highly sensitive workloads, the alternative solution is to deploy DNS on-premises, and change the entries to the active region for failover.

## Management and governance

Securing your highly sensitive IaaS apps requires more than just deploying the correct architectures and implementing network security rules. Because cloud environments are easily changed, it's especially important to ensure changes can be made only with certain permissions, and within the boundaries of security policies. For example, you must prevent a malicious actor from being able to change a network security rule to allow traffic from the internet.

To deploy workloads in Azure, you need one or more *management accounts*. Securing management accounts is critical to securing your workloads. For more information, see [Secure privileged access for hybrid and cloud deployments in Microsoft Entra ID](/azure/active-directory/users-groups-roles/directory-admin-roles-secure).

Use the resources in your management subnet to grant app tier access only to people who need to manage that tier. For example, you can use [Microsoft Identity Manager](/microsoft-identity-manager/microsoft-identity-manager-2016) with Microsoft Entra ID. However, for cloud-native scenarios, Microsoft Entra [Privileged Identity Management (PIM)](/azure/active-directory/privileged-identity-management/pim-configure) is preferred.

There are several other ways to control Azure roles and policies:

- [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) for Azure resources lets you assign built-in or custom roles to users, so they have only the privileges they need. You can combine Azure RBAC with PIM to implement an audited approval workflow that elevates privileges for a limited time period.
- Policies enforce corporate rules, standards, and SLAs. [Azure Policy](/azure/governance/policy/) is an Azure service that creates, assigns, and manages policies, and evaluates your resources for policy compliance.
## Monitoring

[Microsoft Defender for Cloud](/azure/security-center/security-center-intro) provides monitoring and alerts that help you maintain security of your environment. The free service automatically checks for vulnerabilities such as missing OS patches, security misconfiguration, and basic network security. The Standard paid version gives you additional features, such as [behavioral analytics](/azure/security-center/threat-protection), [Adaptive Network Hardening](/azure/security-center/security-center-adaptive-network-hardening), and [JIT VM access](/azure/security-center/security-center-just-in-time). For a full list of features, see [Feature coverage for machines](/azure/security-center/security-center-services). Defender for Cloud also provides [threat protection](/azure/security-center/security-center-services) for other resources like Azure Key Vault.

You can use [Azure Monitor](/azure/azure-monitor/overview) for further monitoring and analysis. To monitor identity and access, you can [route Microsoft Entra activity logs to Azure Monitor](/azure/active-directory/reports-monitoring/concept-activity-logs-azure-monitor). You can also monitor [VMs](/azure/azure-monitor/insights/vminsights-overview), [networks](/azure/azure-monitor/insights/network-insights-overview), and [Azure Firewall](/azure/firewall/tutorial-diagnostics), and analyze imported logs with powerful [log query](/azure/azure-monitor/log-query/log-query-overview) capability. You can integrate Azure Monitor with your *Security Information and Event Manager (SIEM)*, which can be a [third-party SIEM](https://azure.microsoft.com/blog/use-azure-monitor-to-integrate-with-siem-tools/) or [Microsoft Sentinel](/azure/sentinel/overview).

## Related resources

- For more information about n-tier architectures, see [Linux n-tier application in Azure with Apache Cassandra](./n-tier-cassandra.yml).
- For an end-to-end tutorial on using the Azure Key Vault virtual machine extension, see [Secure a web server on a Windows virtual machine in Azure with SSL certificates stored in Key Vault](/azure/virtual-machines/windows/tutorial-secure-web-server).
- For more information about Azure Disk Encryption, see [Azure Disk Encryption for Linux VMs](/azure/virtual-machines/linux/disk-encryption-overview) or [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview).
- For more information about Azure network security, see [Azure network security overview](/azure/security/fundamentals/network-overview).
