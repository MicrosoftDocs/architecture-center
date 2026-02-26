This architecture shows how to extend an on-premises Active Directory domain to Azure to provide distributed authentication services.

## Architecture

:::image type="complex" border="false" source="./media/ad-ds-extend-domain.svg" alt-text="Diagram that shows a secure hybrid network architecture that uses Active Directory." lightbox="./media/ad-ds-extend-domain.svg":::
   The diagram consists of two sections that are labeled as the on-premises network and the virtual network. The on-premises network section shows a gateway that has a two-way connection from the Active Directory servers to the gateway subnet in the virtual network section. An arrow points from that gateway to a box that represents the application subnet. This box contains an icon that represents network security groups (NSGs) and another gateway that connects to two virtual machines (VMs). An arrow that represents an authentication request points from the VMs to a box that's labeled AD DS subnet. This box contains an icon that represents NSGs and a group of two AD DS servers. In the on-premises network section, an arrow that's labeled public IP points from an icon that represents the internet to a VM in the virtual network section. This VM is inside of a box labeled management subnet. The box also contains NSGs and a jump box. A dotted line that represents Azure DDoS Protection surrounds the virtual network section.
:::image-end:::

*Download a [Visio file][visio-download] of this architecture.*

This architecture extends the hybrid network architecture shown in [Connect an on-premises network to Azure by using a VPN gateway](/azure/expressroute/expressroute-howto-coexist-resource-manager). 

### Workflow

The following workflow corresponds to the previous diagram:

- **On-premises network:** The on-premises network includes local Active Directory servers that can perform authentication and authorization for components located on-premises.

- **Active Directory servers:** These servers are domain controllers that implement directory services that run as virtual machines (VMs) in the cloud. They can provide authentication of components that run in your Azure virtual network.

- **Active Directory subnet:** The Active Directory Domain Services (AD DS) servers are hosted in a separate subnet. Network security group (NSG) rules help protect the AD DS servers and provide a firewall against traffic from unexpected sources.

- **Azure VPN Gateway and Active Directory synchronization:** VPN Gateway provides a connection between the on-premises network and Azure Virtual Network. This connection can be a [VPN connection][azure-vpn-gateway] or via [Azure ExpressRoute][azure-expressroute]. All synchronization requests between the Active Directory servers in the cloud and on-premises pass through the gateway. User-defined routes handle routing for on-premises traffic that passes to Azure.

### Components

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an enterprise identity service that provides single sign-on, multifactor authentication, and Microsoft Entra Conditional Access. In this architecture, Microsoft Entra ID provides more secure access to cloud applications and services.

- [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a service that uses virtual network gateways to send encrypted traffic between an Azure virtual network and on-premises locations over the public internet. In this architecture, VPN Gateway allows Active Directory synchronization traffic to flow more securely between environments.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that you can use to extend your on-premises networks into the Microsoft cloud over a private connection with the help of a connectivity provider. In this architecture, ExpressRoute is an alternative to VPN connections for scenarios that require higher bandwidth and lower latency.

- [Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for private networks on Azure. You can use it to enable Azure resources, like VMs, to communicate with each other, the internet, and on-premises networks. In this architecture, Virtual Network supports domain replication and authentication.

## Scenario details 

If your application is hosted partly on-premises and partly in Azure, replicating AD DS in Azure might be more efficient. This replication can reduce the latency caused by sending authentication requests from the cloud back to AD DS instances that run on-premises.

### Potential use cases

This architecture is commonly used when a VPN or ExpressRoute connection connects the on-premises and Azure virtual networks. This architecture also supports bidirectional replication, which means that changes can be made either on-premises or in the cloud, and both sources are kept consistent. Typical uses for this architecture include hybrid applications in which functionality is distributed between on-premises and Azure and applications and services that perform authentication by using Active Directory.

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### VM recommendations

Determine your [VM size][vm-windows-sizes] requirements based on the expected volume of authentication requests. Use the specifications of the machines that host AD DS on-premises as a starting point and match them with the Azure VM sizes. After you deploy your application, monitor usage and scale up or down based on the actual load on the VMs. For more information, see [Capacity planning for AD DS][capacity-planning-for-adds].

Create a separate virtual data disk to store the database, logs, and system volume (sysvol) folder for Active Directory. Don't store these items on the same disk as the operating system. By default, data disks are attached to a VM by using write-through caching. However, this form of caching can conflict with the requirements of AD DS. For this reason, set the *Host Cache Preference* setting on the data disk to *None*.

Deploy at least two VMs that run AD DS as domain controllers and add them to different [availability zones](/azure/reliability/availability-zones-overview). If availability zones aren't available in the region, deploy the VMs in an [availability set][availability-set].

### Networking recommendations

Configure the VM network interface (NIC) for each domain controller with a static private IP address instead of using Dynamic Host Configuration Protocol (DHCP). By assigning a static IP address directly to the VM, clients can continue to contact the domain controller even if the DHCP service is unavailable. For more information, see [Create a VM that uses a static private IP address][set-a-static-ip-address].

> [!NOTE]
> Don't configure the VM NIC for any AD DS by using a public IP address. For more information, see [Security considerations][security-considerations].

The Active Directory subnet NSG requires rules to permit incoming traffic from on-premises and outgoing traffic to on-premises. For more information, see [Configure a firewall for Active Directory domains and trusts][ad-ds-ports].

If the new domain controller VMs also have the role of Domain Name System (DNS) servers, we recommend that you configure them as custom DNS servers at the virtual network level, as explained in [Change DNS servers](/azure/virtual-network/manage-virtual-network#change-dns-servers). You should apply this configuration for the virtual network that hosts the new domain controllers and peered networks where other VMs must resolve Active Directory domain names. For more information, see [Name resolution for resources in Azure virtual networks](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances).

For the initial configuration, you might need to adjust the NIC of one of your domain controllers in Azure to point to a domain controller on-premises as the primary DNS source.

The inclusion of its IP address in the list of DNS servers improves performance and increases the availability of DNS servers. However, a start-up delay can happen if the DNS server is also a domain controller and points only to itself or points to itself first for name resolution. 

For this reason, be cautious when you configure the loopback address on an adapter if the server is also a domain controller. You might need to overwrite the NIC DNS settings in Azure to point toward another domain controller hosted in Azure or on-premises for the primary DNS server. The loopback address should be configured only as a secondary or tertiary DNS server on a domain controller.

### Active Directory site

In AD DS, a site represents a physical location, network, or collection of devices. Use AD DS sites to manage AD DS database replication by grouping AD DS objects that are located close to one another and connected by a high-speed network. AD DS includes logic to select the best strategy for replicating the AD DS database between sites.

We recommend that you create an AD DS site, including the subnets defined for your application in Azure. Then, you can configure a site link between your on-premises AD DS sites. AD DS automatically performs the most efficient database replication possible. This database replication doesn't require much work beyond the initial configuration.

### Active Directory operations master

You can assign the operations master role to AD DS domain controllers to support consistency when they check between instances of replicated AD DS databases. The five operations master roles are schema master, domain naming master, relative identifier master, primary domain controller master emulator, and infrastructure master. For more information, see [Plan operations master role placement][ad-ds-operations-masters]. 

We also recommend that you give at least two of the new Azure domain controllers the global catalog (GC) role. For more information, see [Plan GC server placement](/windows-server/identity/ad-ds/plan/planning-global-catalog-server-placement).

### Monitoring

Monitor the resources of the domain controller VMs and AD DS and create a plan to correct any problems quickly. For more information, see [Monitor Active Directory][monitoring-ad]. You can also install tools like [Microsoft Systems Center][microsoft-systems-center] on the monitoring server to help perform these tasks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Deploy the VMs that run AD DS into at least two [availability zones](/azure/reliability/availability-zones-overview). If availability zones aren't available in the region, use [availability sets][availability-set]. Also, consider assigning the role of [standby operations master][ad-ds-operations-masters] to at least one server or more, depending on your requirements. A standby operations master is an active copy of the operations master that can replace the primary operations master's server during failover.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

AD DS servers provide authentication services and are an appealing target for attacks. To help secure them, prevent direct internet connectivity by placing the AD DS servers in a separate subnet with an NSG as a firewall. Close all ports on the AD DS servers except the ports that are necessary for authentication, authorization, and server synchronization. For more information, see [Configure a firewall for Active Directory domains and trusts][ad-ds-ports].

Use either BitLocker or Azure disk encryption to encrypt the disk that hosts the AD DS database.

[Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to help defend against DDoS attacks. You should enable [DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Other considerations are described in the Cost Optimization section in [Well-Architected Framework][aaf-cost].

The following sections describe cost considerations for the services that this architecture uses.

#### Microsoft Entra Domain Services

Consider having Microsoft Entra Domain Services as a shared service consumed by multiple workloads to lower costs. For more information, see [Domain Services pricing][ADDS-pricing].

#### VPN Gateway

VPN Gateway is the main component of this architecture. You're charged based on the time that the gateway is provisioned and available.

All inbound traffic is free, and all outbound traffic is charged. Internet bandwidth costs are applied to VPN outbound traffic.

For more information, see [VPN Gateway pricing][azure-gateway-charges].

#### Virtual Network

Virtual Network is free. Every subscription is allowed to create up to 1,000 virtual networks across all regions. All traffic within a virtual network's boundaries is free, so communication between two VMs in the same virtual network is free.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use infrastructure as code practices to provision and configure the network and security infrastructure. One option is [Azure Resource Manager templates][arm-template].

- Isolate workloads to enable DevOps to do continuous integration and continuous delivery (CI/CD) because every workload is associated and managed by its corresponding DevOps team.

In this architecture, the entire virtual network that includes the different application tiers, management jump box, and Domain Services is identified as a single isolated workload.

You can configure AD DS on VMs by using VM extensions and other tools, such as [Desired State Configuration (DSC)][dsc-overview].

- Consider automating your deployments by using [Azure DevOps][az-devops] or any other CI/CD solutions. [Azure Pipelines][az-pipelines] is the recommended component of Azure DevOps Services. It provides automation for solution builds and deployments and is highly integrated into the Azure ecosystem.

- Use [Azure Monitor][azure-monitor] to analyze the performance of your infrastructure. You can also use it to monitor and diagnose networking problems without logging into your VMs. Application Insights provides rich metrics and logs to verify the state of your infrastructure.

For more information, see the DevOps section in [Well-Architected Framework][AAF-devops].

#### Manageability

Perform regular AD DS backups. Don't just copy the Virtual Hard Disk (VHD) files of domain controllers because the AD DS database file on the VHD might not be consistent when copied, which makes it impossible to restart the database.

We don't recommend that you shut down a domain controller VM by using the Azure portal. Instead, shut down and restart the guest operating system. If you shut down a domain controller by using the Azure portal, it causes the VM to be deallocated, which results in the following effects when you restart the domain controller VM:

- It resets the `VM-GenerationID` and the `invocationID` of the Active Directory repository.
- It discards the current Active Directory relative identifier (RID) pool.
- It marks the sysvol folder as nonauthoritative.

The first problem is relatively benign. Repeated resetting of the `invocationID` causes minor additional bandwidth usage during replication, but this usage isn't significant.

The second problem can contribute to RID pool exhaustion in the domain, especially if the RID pool size is configured to be larger than the default. If the domain exists for a long time or is used for workflows that require repetitive account creation and deletion, it might already be nearing RID pool exhaustion. Monitoring the domain for RID pool exhaustion warning events is a good practice. For more information, see [Manage RID issuance](/windows-server/identity/ad-ds/manage/managing-rid-issuance).

The third problem is relatively benign as long as an authoritative domain controller is available when a domain controller VM in Azure is restarted. If all domain controllers in a domain are running in Azure, and they're all simultaneously shut down and deallocated, then each domain controller fails to find an authoritative replica when you restart them. Fixing this condition requires manual intervention. For more information, see [Force authoritative and nonauthoritative synchronization for DFSR-replicated sysvol replication](/troubleshoot/windows-server/group-policy/force-authoritative-non-authoritative-synchronization).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

AD DS is designed for scalability. You don't need to configure a load balancer or traffic controller to direct requests to AD DS domain controllers. The only scalability consideration is to configure the VMs that run AD DS with the correct size for your network load requirements, monitor the load on the VMs, and scale up or down as necessary.

## Next steps

- [What is Microsoft Entra ID?](/entra/fundamentals/whatis)
- [Azure DevOps][az-devops]
- [Azure Pipelines][az-pipelines]
- [Azure Monitor][azure-monitor]
- [Configure a firewall for Active Directory domains and trusts][ad-ds-ports]
- [DSC overview][dsc-overview]
- [Configure ExpressRoute and site-to-site coexisting connections by using PowerShell](/azure/expressroute/expressroute-howto-coexist-resource-manager)

## Related resources

- [Create an AD DS resource forest in Azure][adds-resource-forest] 
- [Extend on-premises AD FS to Azure][adfs] 

<!-- links -->

[aaf-cost]: /azure/architecture/framework/cost/overview
[AAF-devops]: /azure/architecture/framework/devops/overview
[adds-resource-forest]: ../../reference-architectures/identity/adds-forest.yml
[adfs]: ../../reference-architectures/identity/adfs.yml
[dsc-overview]: /powershell/scripting/dsc/overview
[ad-ds-operations-masters]: /windows-server/identity/ad-ds/plan/planning-operations-master-role-placement
[ad-ds-ports]: /troubleshoot/windows-server/identity/config-firewall-for-ad-domains-and-trusts  
[arm-template]: /azure/azure-resource-manager/resource-group-overview#resource-groups
[availability-set]: /azure/virtual-machines/windows/tutorial-availability-sets
[azure-expressroute]: /azure/expressroute/expressroute-introduction
[azure-monitor]: https://azure.microsoft.com/services/monitor
[az-devops]: /azure/virtual-machines/windows/infrastructure-automation#azure-devops-services
[az-pipelines]: /azure/devops/pipelines/
[ADDS-pricing]: https://azure.microsoft.com/pricing/details/active-directory-ds
[availability-set]: /azure/virtual-machines/windows/tutorial-availability-sets
[azure-expressroute]: /azure/expressroute/expressroute-introduction
[azure-gateway-charges]: https://azure.microsoft.com/pricing/details/vpn-gateway
[azure-vpn-gateway]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[capacity-planning-for-adds]: https://social.technet.microsoft.com/wiki/contents/articles/14355.capacity-planning-for-active-directory-domain-services.aspx
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[microsoft-systems-center]: https://www.microsoft.com/download/details.aspx?id=50013
[monitoring-ad]: /windows-server/identity/ad-ds/plan/security-best-practices/monitoring-active-directory-for-signs-of-compromise
[security-considerations]: #security
[set-a-static-ip-address]: /azure/virtual-network/virtual-networks-static-private-ip-arm-pportal
[visio-download]: https://arch-center.azureedge.net/identity-architecture-adds.vsdx
[vm-windows-sizes]: /azure/virtual-machines/sizes
