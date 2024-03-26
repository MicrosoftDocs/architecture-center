The objective of this article is to provide technical details to implement Murex workloads in Microsoft Azure.

Murex is a leading global software provider of trading, risk management, processing operations, and post-trade solutions for capital markets. Many banks deploy Murex's third generation platform MX.3 to manage risk, accelerate transformation, and simplify compliance, all while driving revenue growth. The Murex platform lets customers gain greater control of their operations, improve efficiency, and reduce operational cost.

## Architecture

Murex MX.3 workloads can run on databases like Oracle, Sybase, or SQL Server. With version V3.1.48, SQL Server 2019 Standard is supported for MX.3, which lets you benefit from the performance, scalability, resilience, and cost savings facilitated by SQL Server. MX.3 is available only on Azure virtual machines (VMs) running Windows OS.

:::image type="content" source="./media/murex-azure-reference-architecture-sql.svg" alt-text="Diagram that shows an Azure architecture for a Murex MX.3 application." lightbox="./media/murex-azure-reference-architecture-sql.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/murex-azure-reference-architecture-sql.vsdx) of this architecture.*

### Workflow

- The MX.3 presentation layer is hosted in Azure and is accessible from an on-premises environment through ExpressRoute or a site-to-site VPN.
- The application tier contains the presentation layer, business layer, orchestration layer, and grid layer. It accesses SQL Server on Windows VM for storing and retrieving data. For added security, we recommend you use Azure Virtual Desktop or Windows 365 Cloud PC running a desktop application to access the presentation layer. However, you can also access it through a web interface.
- The presentation layer accesses the business layer, orchestration layer, and grid layer components to complete the business process.
- The application layer accesses Azure Key Vault services to securely store encryption keys and secrets.
- Admin users securely access the Murex MX.3 servers by using the Azure Bastion service.

### Components

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion): Azure Bastion is a fully managed service that provides more secure and seamless Remote Desktop Protocol (RDP) and Secure Shell protocol (SSH) access to VMs without any exposure through public IP addresses.
- [Azure Monitor](https://azure.microsoft.com/services/monitor): Azure Monitor helps you collect, analyze, and act on telemetry data from your Azure and on-premises environments.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall): Azure Firewall is a cloud-native and intelligent network firewall security service that provides the best threat protection for your cloud workloads running in Azure.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute): Use Azure ExpressRoute to create private connections between Azure datacenters and infrastructure on premises or in a colocation environment.
- [Azure Files](https://azure.microsoft.com/services/storage/files): Fully managed file shares in the cloud that are accessible via the industry-standard SMB and NFS protocols.
- [Azure Disk Storage](https://azure.microsoft.com/services/storage/disks): Azure Disk Storage offers high-performance, durable block storage for your mission- and business-critical applications.
- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery): To help keep your applications running during planned and unplanned outages, deploy replication, failover, and recovery processes through Site Recovery.
- [SQL Server on Windows VM](/azure/azure-sql/virtual-machines/linux/sql-server-on-linux-vm-what-is-iaas-overview): SQL Server on Azure Virtual Machines lets you use full versions of SQL Server in the cloud without having to manage any on-premises hardware. SQL Server VMs also simplify licensing costs when you pay as you go.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault): Use Azure Key Vault to securely store and access secrets.
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway): VPN Gateway sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy): Use Azure Policy to create, assign, and manage policy definitions in your Azure environment.
- [Azure Backup](https://azure.microsoft.com/services/backup): Azure Backup is a cost-effective, secure, one-click backup solution that's scalable, based on your backup storage needs.

### Alternatives

As an alternate solution, you can use Murex MX.3 with Oracle as a database instead of SQL. For more information, see [Host a Murex MX.3 workload on Azure](murex-mx3-azure.yml).

## Scenario details

MX.3 is a client/server application based on a three-tier architecture structure. Banks use MX.3 for their business requirements, such as sales and trading, enterprise risk management, and collateral and investment.

Azure provides a fast and easy way to create and scale an MX.3 infrastructure. It offers a secure, reliable, and efficient environment for production, development, and test systems, and significantly reduces the infrastructure cost needed to operate the MX.3 environment.

For detailed information about the various tiers and layers of the Murex MX.3 application, compute, and storage requirements, contact the [Murex technical team](https://www.murex.com/en/solutions/technology/mx3-architecture).

### Potential use cases

This solution is ideal for use in the finance industry, including these potential use cases:

- Gain better control of operations, improve efficiency, and reduce infrastructure cost.
- Create a secure, reliable, and efficient environment for production and development.

### Requirements and limitations

Murex MX.3 is a complex workload with high memory, low latency, and high availability requirements. Following are some of the technical limitations and requirements that you must analyze when implementing a Murex MX.3 workload in Azure.

- MX.3 uses a client/server architecture. When implemented in Azure, it can be run on VMs, and no PaaS services are supported for the application. Carefully analyze any native Azure services to ensure they meet the technical requirements for Murex.
- The MX.3 application requires external (internet) and internal (on-premises) connectivity to perform tasks. The Azure architecture for the MX.3 application must support a secure connectivity model to integrate with internal and external services. Use an Azure site-to-site VPN or ExpressRoute (recommended) to connect with on-premises services.
- You can deploy the MX.3 solution on Azure completely, or you can deploy a partial set of Azure components using a hybrid model (not covered in this article). You should carefully analyze the architecture and technical requirements before using a hybrid model of deployment. Hybrid models of deployment for MX.3 are subject to technical review by the Murex team.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

For backup, you can use Azure native backup services combined with Azure storage. Use these services for daily, weekly, or monthly backups of the application VMs or any other application tier-specific backup requirements. For database requirements, you can use Site Recovery to automate the disaster recovery process and native database replication. You can also use backup tools to achieve the required level of RPO metrics.

To get high availability and resiliency of the Murex solution on Azure, run each layer of the application tier in at least two VMs. You can use an Azure availability set configuration to achieve high availability across multiple VMs. You can also use [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) for redundancy and improved performance of applications that are distributed across multiple instances. You can achieve high availability for the orchestration layer by hosting them in multiple instances and invoking the instances by using custom scripts. To achieve the high availability requirements, use database high availability features like SQL Server Always On availability group.

SQL Server Always On availability group can be used to automate DR failover by setting up a primary SQL Server instance and one or more secondary instances. Configure the [Always On availability group](/sql/linux/sql-server-linux-availability-group-configure-ha) feature on each server instance.

MX.3 requires DTC to be turned on in SQL Server. We recommend you host SQL Server on Windows Server VMs to support DTC transactions, as DTC support isn't yet available in SQL Server on RedHat Linux OS for SQL Server Always On availability group.

For disaster recovery, you should run the [disaster recovery site](/azure/virtual-machines/linux/tutorial-disaster-recovery) in a different Azure region. For SQL Server, you can use active-passive disaster recovery configurations based on the recovery point objective and recovery time objective requirements. Active-active isn't an option with SQL Server as multi region writes aren't possible. Data loss due to latency and the timing of backups has to be considered. You can use Site Recovery to automate the disaster recovery process and native database replication. You can also use backup tools to achieve the required level of RPO metrics.

*Linux is a trademark of its respective company. No endorsement is implied by the use of this mark.*

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Access the MX.3 client tier directly from the user desktop or through virtual desktop solutions like Azure Virtual Desktop, Windows 365 Cloud PCs, or other non-Microsoft solutions.

Use services like Azure Key Vault to address the security requirements of the MX.3 application in Azure by storing keys and certificates. You can use virtual networks, network security groups (NSGs), and application security groups to control access between various layers and tiers. Use Azure Firewall, DDoS protection, and Azure Application Gateway or Web Application Firewall services to protect the front-end layer depending on the security requirements.

Check out the SQL Server features and capabilities that provide a method of security at the data level. In addition, with Azure security measures, it's possible to encrypt your sensitive data, protect VMs from viruses and malware, secure network traffic, identify and detect threats, meet compliance requirements, and provide a single method for administration and reporting for any security need in the hybrid cloud. For more information on these security considerations, see [Security considerations for SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/security-considerations-best-practices).

For more information about SQL Server VM best practices, see the other articles in this series:

- [Checklist: Best practices for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist)
- [VM size: Performance best practices for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-vm-size)
- [HADR configuration best practices](/azure/azure-sql/virtual-machines/windows/hadr-cluster-best-practices)
- [Collect baseline: Performance best practices for SQL Server on Azure VM](/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-collect-baseline)

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

[Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit/) lets you exchange your existing licenses for discounted rates on Azure SQL database and Azure SQL Managed Instance. You can save up to 30 percent or more on SQL database and SQL Managed Instance by using your Software Assurance-enabled SQL Server licenses on Azure. The Azure Hybrid Benefit page provides a calculator to help determine savings.

Several options can affect cost, and it's important to pick the right VM SKU that balances costs with business requirements.  

Virtual Machine Scale Sets can automatically increase the number of VM instances as application demand increases, then reduce the number of VM instances as demand decreases.

Autoscale also minimizes the number of unnecessary VM instances that run your application when demand is low. Customers continue to receive an acceptable level of performance as demand grows and extra VM instances are automatically added. This ability helps reduce costs and efficiently create Azure resources as required.

For more information about pricing, see [Pricing guidance for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/pricing-guidance). You can also use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate your costs.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Use Azure Monitor to monitor the Azure infrastructure components. Its alerting mechanism lets you take preventive actions like autoscaling or notification.

You can achieve infrastructure automation by using Infrastructure as Code services, like Azure Resource Manager templates or Terraform scripts.

Azure DevOps lets you deploy Azure SQL Server with any IaC that is supported, such as Terraform. You can use Murex DevOps tools to address the application-level DevOps requirements. Engage directly with Murex for guidance on this approach.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Having Murex MX.3 workloads across various tiers requires specific types of compute resources to meet functional and technical requirements. See the [Murex MX.3 architecture](https://www.murex.com/solutions/technology/mx3-architecture) to understand the compute, memory, and storage requirements for an MX.3 workload.

To achieve the required performance metrics for Murex workloads, consider storing the MX.3 application directory and databases on Azure Managed Disks with Premium SSD. You can use a proximity placement group and network acceleration in Azure to achieve high network throughput across layers.

Use Premium or Ultra SSD storage for SQL on Azure VM. For more information on Premium SSD, see [Storage Configuration Guidelines for SQL Server on Azure VM](https://blogs.msdn.microsoft.com/sqlserverstorageengine/2018/09/25/storage-configuration-guidelines-for-sql-server-on-azure-vm/).

Ultra SSD on the other hand is another storage offering available on Azure for mission-critical workloads with submillisecond latencies at high throughput. With Ultra SSD, we need only one Ultra SSD disk of 1 TB, which can scale up to 50,000 IOPS. Ultra SSD can be configured flexibly, and size and IOPS can scale independently. For more information on Ultra SSD, see [Mission critical performance with Ultra SSD for SQL Server on Azure VM | Azure Blog | Microsoft Azure](https://azure.microsoft.com/blog/mission-critical-performance-with-ultra-ssd-for-sql-server-on-azure-vm/).

The article [Checklist: Best practices for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist) provides a quick checklist of best practices and guidelines to optimize performance of your SQL Server on Azure VMs. To learn more about SQL Server VM best practices, see the other articles in this series:

- [VM size: Performance best practices for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-vm-size)
- [Storage: Performance best practices for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-storage)
- [Security considerations for SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/security-considerations-best-practices)
- [HADR configuration best practices](/azure/azure-sql/virtual-machines/windows/hadr-cluster-best-practices)
- [Collect baseline: Performance best practices for SQL Server on Azure VM](/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-collect-baseline)

Enable [SQL Assessment for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/sql-assessment-for-sql-vm#enable) to evaluate your SQL Server against known best practices, with results provided on the SQL VM management page of the Azure portal.

If you're using Virtual Machine Scale Sets, then it's possible to scale out and create extra VMs to meet the compute demand for business layer. However, for Murex MX.3, it must be done without terminating active sessions. Murex MX.3 customers can engage with their product support engineers for strategies to accomplish safe VM scaling.

## Network hub-and-spoke model

A key consideration when you implement MX.3 workloads in Azure is defining the landing zone architecture. This architecture contains the subscription, resource group, virtual network isolation, and connectivity between various components of the solution. This section covers the [landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone) to implement an MX.3 workload on Azure, based on the Microsoft Cloud Adoption Framework.

This diagram shows a high-level view of a landing zone that uses the [hub-spoke network topology in Azure](../../networking/architecture/hub-spoke.yml).

:::image type="content" source="./media/murex-landing-zone-architecture.png" alt-text="Diagram that shows an example of a hub-and-spoke model with Azure services." lightbox="./media/murex-landing-zone-architecture.png":::

- This model provides a strong isolation of the spoke networks used to run different environments. The model also maintains secure control access and a shared service layer in the hub network.
- You can use the same hub-spoke model in another region as it's a multi-region solution. You can build a hub for each region, followed by different spokes for nonproduction and production.
- Use this landing zone for a single subscription or multiple subscriptions depending on how your organization categorizes your applications.

Each component in the landing zone is discussed here:

**Hub**: The hub is a virtual network that acts as a central location to manage external connectivity to an MX.3 client's on-premises network and hosting services used by multiple workloads.

**Spoke**: The spokes are virtual networks that host MX.3's Azure workloads and connect to the central hub through virtual network peering.

**Virtual network peering**: Hub and spoke virtual networks are connected using virtual network peering, which supports low latency connections between the virtual networks.

**Gateway**: A gateway is used to send traffic from an MX.3 client's on-premises network to the Azure virtual network. You can encrypt the traffic before you send it.

**Gateway Subnet**: The gateway that sends traffic from on-premises to Azure uses a specific subnet called the gateway subnet. The gateway subnet is part of the virtual network IP address range that you specify when configuring your virtual network. It contains the IP addresses that the virtual network gateway resources and services use.

**Azure Jumpbox VM**: Jumpbox connects Azure VMs of the application and persistence tiers by using dynamic IP. Jumpbox prevents all the application and database VMs from being exposed to the public. This connection is your entry point to connect through an RDP from the on-premises network.

**Azure Firewall**: You should route any inbound and outbound connectivity between MX.3 VMs and the internet through Azure Firewall. Typical examples of such connectivity are time sync and anti-virus definition update.

**Azure Bastion**: By using Azure Bastion, you can securely connect the application and database VMs through Azure portal. Deploy the Azure Bastion host inside the hub virtual network, and then access the VMs in the peered spoke virtual networks. This component is optional, and you can use it as needed.

**Azure Bastion subnet**: Azure Bastion requires a dedicated subnet: AzureBastionSubnet. You must create this subnet in the hub and you must deploy the Bastion host into this subnet.

**Azure management subnet**: Azure Jumpbox must be in the management subnet. Jumpbox contains VMs that implement management and monitoring capabilities for the application and database VMs in the spoke virtual network.

**Application subnet**: You can place all the components under the application tier here. Having a dedicated application subnet also helps in controlling traffic to the business, orchestration, and technical services layers through NSGs.

**Database Subnet**: You can place the components in the database subnet in a dedicated subnet to manage traffic around the database.

**Private Link**: Azure services like Recovery Services vaults, Azure Cache for Redis, and Azure Files are all connected through a private link to the virtual network. Having a private link between these services and the virtual network secures the connection between endpoints in Azure by eliminating data exposure to the internet.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Vandana Bagalkot](http://linkedin.com/in/vandana-bagalkot) | Principal Cloud Solution Architect
- [Gansu Adhinarayanan](http://linkedin.com//in/ganapathi-gansu-adhinarayanan-a328b121) | Director - Partner Technology Strategist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Centralize your core services by using hub and spoke Azure virtual network architecture](/training/modules/hub-and-spoke-network-architecture)
- [Get started with Finance and Operations apps](/training/paths/get-started-finance-operations)
- [Hub-and-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology)
- [Murex MX.3 architecture](https://www.murex.com/solutions/technology/mx3-architecture)

## Related resources

- [Hub-spoke network topology in Azure](../../networking/architecture/hub-spoke.yml)
- [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/)
