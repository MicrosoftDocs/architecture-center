This reference architecture shows how to create a separate Active Directory domain in Azure that is trusted by domains in your on-premises Active Directory forest.

## Architecture

:::image type="complex" border="false" source="./images/adds-forest.svg" alt-text="Diagram that shows a secure hybrid network architecture with separate Active Directory domains." lightbox="./images/adds-forest.svg":::
   The image has two key sections: an on-premises network and a virtual network. The on-premises network contains contoso.com, a gateway, and Active Directory servers. The virtual network section includes a gateway subnet, an application subnet, a management subnet, and Active Directory Domain Services (AD DS) subnets. The gateway subnet has a gateway. The application subnet contains network security groups (NSGs) and virtual machines (VMs). The management subnet contains NSGs, a VM, and a jump box. The AD DS section contains NSGs and servers. In a separate section, an arrow points from a public IP address to the VM in the management subnet section.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/identity-architectures.vsdx) of this architecture.*

### Components

- **The on-premises network** contains its own Active Directory forest and domains.

- **Active Directory servers** are domain controllers that implement domain services that run as virtual machines (VMs) in the cloud. These servers host a forest with one or more domains that are distinct from those located on-premises.

- **A one-way trust relationship** enables on-premises users to access resources in the domain in Azure. However, users who belong to the Azure domain can't access resources in the on-premises domain. The example in the diagram shows a one-way trust from the domain in Azure to the on-premises domain.

- **Active Directory subnet** is a separate network segment that hosts the Active Directory Domain Services (AD DS) servers. Network security group rules protect these servers and provide a firewall against traffic from unexpected sources.

- **Azure gateway** provides a connection between the on-premises network and the Azure virtual network. This type of connection can be a [VPN connection][azure-vpn-gateway] or [Azure ExpressRoute][azure-expressroute]. For more information, see [Configure ExpressRoute and site-to-site coexisting connections by using PowerShell](/azure/expressroute/expressroute-howto-coexist-resource-manager).

## Scenario details

AD DS stores identity information in a hierarchical structure. The top node in the hierarchical structure is known as a *forest*. A forest contains domains, and domains contain other types of objects. This reference architecture creates an AD DS forest in Azure with a one-way outgoing trust relationship with an on-premises domain. The forest in Azure contains a domain that doesn't exist on-premises. Because of the trust relationship, logons made against on-premises domains can be trusted for access to resources in the separate Azure domain.

### Potential use cases

Typical uses for this architecture include maintaining security separation for objects and identities held in the cloud. They also include migrating individual domains from on-premises to the cloud.

For more information, see [Integrate on-premises Active Directory domains with Microsoft Entra ID][considerations].

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

For specific recommendations about how to implement Active Directory in Azure, see [Deploy AD DS in an Azure virtual network][adds-extend-domain].

### Trust

The on-premises domains are contained within a different forest from the domains in the cloud. To enable authentication of on-premises users in the cloud, the domains in Azure must trust the logon domain in the on-premises forest. Similarly, if the cloud provides a logon domain for external users, it might be necessary for the on-premises forest to trust the cloud domain.

You can establish trusts at the forest level by [creating forest trusts][creating-forest-trusts] or at the domain level by [creating external trusts][creating-external-trusts]. A forest-level trust creates a relationship between all domains in two forests. An external domain-level trust only creates a relationship between two specified domains. You should only create external domain-level trusts between domains in different forests.

Trusts with an on-premises Active Directory are only one way, or *unidirectional*. A one-way trust allows users in one domain or forest, known as the incoming domain or forest, to access resources in another domain or forest, known as the outgoing domain or forest. Users in the outgoing domain can't access resources in the incoming domain.

The following table summarizes trust configurations for simple scenarios:

| Scenario | On-premises trust | Cloud trust |
| :--- | :--- | :--- |
| On-premises users require access to resources in the cloud, but cloud users don't require access to resources in the on-premises environment. | One-way, incoming | One-way, outgoing |
| Users in the cloud require access to resources located on-premises, but users in the on-premises environment don't require access to resources in the cloud. | One-way, outgoing | One-way, incoming |

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Provision a minimum of two domain controllers for each domain. This approach enables automatic replication between servers. Create an availability set for the VMs that act as Active Directory servers handling each domain. Put at least two servers in this availability set.

Consider designating one or more servers in each domain as [standby operations masters][standby-operations-masters] if connectivity to a server acting as a flexible single master operation role fails.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Forest-level trusts are transitive. If you establish a forest-level trust between an on-premises forest and a forest in the cloud, the trust extends to any new domains created in either forest. If you use domains to provide separation for security purposes, consider creating trusts at the domain level only. Domain-level trusts are non-transitive.

For Active Directory-specific security considerations, see the security considerations section in [Deploy AD DS in an Azure virtual network][adds-extend-domain].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs for the services used in this architecture.

<a name='ad-domain-services'></a>
#### Microsoft Entra Domain Services

Consider deploying Microsoft Entra Domain Services as a shared service that multiple workloads consume to lower costs. For more information, [Compare self-managed Active Directory Domain Services, Microsoft Entra ID, and managed Microsoft Entra Domain Services](/entra/identity/domain-services/compare-identity-solutions#domain-services-and-self-managed-ad-ds).

#### Azure VPN Gateway

The main component of this architecture is the VPN gateway service. You're charged based on the amount of time that the gateway is provisioned and available.

All inbound traffic is free and all outbound traffic is charged. Internet bandwidth costs are applied to VPN outbound traffic.

For more information, see [VPN Gateway pricing][azure-gateway-charges].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### DevOps

For DevOps considerations, see [Operational Excellence](adds-extend-domain.yml#operational-excellence).

#### Manageability

For more information about management and monitoring considerations, see [Deploy AD DS in an Azure virtual network][adds-extend-domain].

Follow the guidance in [Monitor Active Directory][monitoring-ad]. You can install tools such as [Microsoft System Center][microsoft-systems-center] on a monitoring server in the management subnet to help perform these tasks.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Active Directory is automatically scalable for domain controllers that are part of the same domain. Requests are distributed across all controllers within a domain. You can add another domain controller, and it synchronizes automatically with the domain. Don't configure a separate load balancer to direct traffic to controllers within the domain. Ensure that all domain controllers have sufficient memory and storage resources to handle the domain database. Make all domain controller VMs the same size.

## Related resources

- Learn the best practices for how to [extend your on-premises AD DS domain to Azure][adds-extend-domain].
- Learn the best practices for how to [create an Active Directory Federation Services (AD FS) infrastructure][adfs] in Azure.

<!-- links -->

[adds-extend-domain]: ./adds-extend-domain.yml
[adfs]: ./adfs.yml
[azure-gateway-charges]: https://azure.microsoft.com/pricing/details/vpn-gateway
[azure-expressroute]: /azure/expressroute/expressroute-introduction
[azure-vpn-gateway]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[considerations]: ./index.yml
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[creating-external-trusts]: /previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc816837(v=ws.10)
[creating-forest-trusts]: /previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc816810(v=ws.10)
[microsoft-systems-center]: https://microsoft.com/cloud-platform/system-center
[monitoring-ad]: /previous-versions/windows/it-pro/windows-2000-server/bb727046(v=technet.10)
[standby-operations-masters]: /previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc794737(v=ws.10)
