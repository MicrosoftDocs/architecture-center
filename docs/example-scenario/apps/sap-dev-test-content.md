This example shows how to establish a development and test environment for SAP NetWeaver in a Windows or Linux environment on Azure. The database used is AnyDB. (AnyDB is the SAP term for any supported DBMS that isn't SAP HANA.)

## Architecture

[ ![Architecture diagram for dev/test environments for SAP workloads.](./media/architecture-sap-dev-test-architecture.svg)](./media/architecture-sap-dev-test-architecture.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/architecture-sap-dev-test-architecture.vsdx) of this architecture.*

### Dataflow

This scenario demonstrates provisioning a single SAP system database and SAP application server on a single virtual machine. The data flows through the scenario as follows:

1. Customers use the SAP user interface or other client tools (Excel, a web browser, or other web application) to access the Azure-based SAP system.
2. Connectivity is provided by using an established ExpressRoute. The ExpressRoute connection is ended in Azure at the ExpressRoute gateway. Network traffic routes through the ExpressRoute gateway to the gateway subnet, and from the gateway subnet to the application-tier spoke subnet (see the [hub-spoke network topology][hub-spoke]) and via a Network Security Gateway to the SAP application virtual machine.
3. The identity management servers provide authentication services.
4. The jump box provides local management capabilities.

### Components

- [Virtual networks](https://azure.microsoft.com/products/virtual-network) are the basis of network communication within Azure.
- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) provide on-demand, high-scale, secure, virtualized infrastructure using Windows or Linux servers.
- [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute) extends your on-premises networks into the Microsoft cloud over a private connection, which is facilitated by a connectivity provider.
- [Network security groups](/azure/virtual-network/security-overview) limit network traffic to specific resources in a virtual network. A network security group contains a list of security rules that allow or deny inbound or outbound network traffic. The security rules are based on source or destination IP address, port, and protocol.
- [Resource groups](/azure/azure-resource-manager/resource-group-overview#resource-groups) act as logical containers for Azure resources.
- [Azure Files](https://azure.microsoft.com/products/storage/files) or [Azure NetApp Files](https://azure.microsoft.com/products/netapp) are recommended solutions to provide the storage for the SAP executables and HANA data and logs.

## Scenario details

Because this architecture is designed for non-production environments, it's deployed with only one virtual machine (VM). The VM size can be changed to accommodate your organization's needs.

For production use cases, review the SAP reference architectures available below:

- [SAP NetWeaver for AnyDB][sap-netweaver]
- [SAP S/4HANA][sap-hana]
- [SAP on Azure large instances][sap-large]

### Potential use cases

Other relevant use cases include:

- Noncritical SAP nonproduction workloads (such sandbox, development, test, and quality assurance).
- Noncritical SAP business workloads.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Keep the following points in mind when establishing a development and test environment for SAP NetWeaver.

### Availability

Microsoft offers a service level agreement (SLA) for single VM instances. For more information on Microsoft Azure Service Level Agreement for Virtual Machines [SLA For Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines)

### Scalability

For general guidance on designing scalable solutions, see the [performance efficiency checklist][scalability] in the Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

#### Data protection and cloning

For general guidance on protecting your application data, see [Azure Application Consistent Snapshot tool](/azure/azure-netapp-files/azacsnap-introduction), which provides application consistent snapshots when used in combination with Azure NetApp Files.

### Resiliency

For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To help you explore the cost of running this scenario, all services are preconfigured in the cost calculator examples below. Change the appropriate variables to match the expected traffic for your use case.

We've provided four sample cost profiles based on amount of traffic you expect to receive:

|Size|SAPs|VM Type|Storage|Azure Pricing Calculator|
|----|----|-------|-------|---------------|
|Small|8000|D8s_v3|2xP20, 1xP10|[Small](https://azure.com/e/9d26b9612da9466bb7a800eab56e71d1)|
|Medium|16000|D16s_v3|3xP20, 1xP10|[Medium](https://azure.com/e/465bd07047d148baab032b2f461550cd)|
Large|32000|E32s_v3|3xP20, 1xP10|[Large](https://azure.com/e/ada2e849d68b41c3839cc976000c6931)|
Extra Large|64000|M64s|4xP20, 1xP10|[Extra Large](https://azure.com/e/975fb58a965c4fbbb54c5c9179c61cef)|

> [!NOTE]
> This pricing is a guide that only indicates the VMs and storage costs. It excludes networking, backup storage, and data ingress/egress charges.

- [Small](https://azure.com/e/9d26b9612da9466bb7a800eab56e71d1): A small system consists of VM type D8s_v3 with 8x vCPUs, 32-GB RAM, and 200 GB of temporary storage. It also contains premium storage: two 512-GB disks and one 128-GB disk.
- [Medium](https://azure.com/e/465bd07047d148baab032b2f461550cd): A medium system consists of VM type D16s_v3 with 16x vCPUs, 64-GB RAM, and 400 GB of temporary storage. It also contains premium storage: three 512-GB disks and one 128-GB disk.
- [Large](https://azure.com/e/ada2e849d68b41c3839cc976000c6931): A large system consists of VM type E32s_v3 with 32x vCPUs, 256-GB RAM, and 512 GB of temporary storage. It also contains premium storage: three 512-GB disks and one 128-GB disk.
- [Extra Large](https://azure.com/e/975fb58a965c4fbbb54c5c9179c61cef): An extra-large system consists of a VM type M64s with 64x vCPUs, 1024-GB RAM, and 2000 GB of temporary storage. It also contains premium storage: four 512-GB disks and one 128-GB disk.

## Deploy this scenario

Select the link below to deploy the solution.

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsolution-architectures%2Fmaster%2Fapps%2Fsap-2tier%2Fazuredeploy.json)

> [!NOTE]
> SAP and Oracle are not installed during this deployment. You will need to deploy these components separately.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Andrew Dibbins](https://www.linkedin.com/in/andrew-dibbins-5551771) | Senior Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn more about the component technologies:

- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Linux virtual machines in Azure](/azure/virtual-machines/linux/overview)
- [Windows virtual machines in Azure](/azure/virtual-machines/windows/overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [Network security groups](/azure/virtual-network/network-security-groups-overview)
- [Use Azure to host and run SAP workload scenarios](/azure/virtual-machines/workloads/sap/get-started)
- [Installation of SAP HANA on Azure virtual machines](/azure/virtual-machines/workloads/sap/hana-get-started)
- [Manage Azure Resource Manager resource groups by using Azure CLI](/azure/azure-resource-manager/management/manage-resource-groups-cli)
- [High-availability architecture and scenarios for SAP NetWeaver](/azure/virtual-machines/workloads/sap/sap-high-availability-architecture-scenarios)
- [What is Azure Files](/azure/storage/files/storage-files-introduction)
- [What is Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction)

## Related resources

Explore related architectures:

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [Run SAP NetWeaver in Windows on Azure](/azure/architecture/guide/sap/sap-netweaver)
- [SAP on Azure Architecture Guide](../../reference-architectures/sap/sap-overview.yml)

<!-- links -->

[resiliency]: /azure/architecture/framework/resiliency/principles
[security]: /azure/security
[scalability]: /azure/architecture/framework/scalability/performance-efficiency
[sap-netweaver]: /azure/architecture/guide/sap/sap-netweaver
[sap-hana]: /azure/architecture/guide/sap/sap-s4hana
[sap-large]: ../../reference-architectures/sap/hana-large-instances.yml
[hub-spoke]: ../../reference-architectures/hybrid-networking/hub-spoke.yml
