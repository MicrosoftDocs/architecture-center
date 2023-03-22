The objective of this article is to provide technical details to implement Murex workloads in Azure.

## Architecture

Murex MX.3 workloads can run on databases like Oracle, Sybase, or SQL Server. This architecture focuses on the details for implementing MX.3 application using Oracle as the database.

:::image type="content" source="./media/murex-azure-reference-architecture.png" alt-text="Diagram that shows an Azure architecture for a Murex MX.3 application." lightbox="./media/murex-azure-reference-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/murex-azure-reference-architecture.vsdx) of this architecture.*

### Workflow

- Access the MX.3 presentation layer component of the application tier that's hosted in Azure by using an Azure ExpressRoute or VPN connection between Azure and your on-premises environment. The connection is protected by using Azure Firewall.
- Access the presentation layer by using virtual desktop infrastructure (VDI) solutions, like Citrix. You can also directly access the layer through a desktop application or by using the web interface provided by the MX.3 application.
- The application tier contains the presentation layer, business layer, orchestration layer, and grid layer. It accesses the Oracle database for storing and retrieving data.  
- The presentation layer accesses the business layer, orchestration layer, and grid layer components to complete the business process.
- The Oracle database uses Azure Premium SSD or Azure NetApp Files as the storage mechanism for faster access.
- The application layer accesses Azure Key Vault services to securely store encryption keys and secrets.
- Admin users securely access the Murex MX.3 servers by using the Azure Bastion service.

### Components

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion): Azure Bastion is a fully managed service that provides more secure and seamless Remote Desktop Protocol (RDP) and Secure Shell protocol (SSH) access to virtual machines (VMs) without any exposure through public IP addresses.
- [Azure Monitor](https://azure.microsoft.com/services/monitor): Azure Monitor helps you collect, analyze, and act on telemetry data from your Azure and on-premises environments.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall): Azure Firewall is a cloud-native and intelligent network firewall security service that provides the best threat protection for your cloud workloads running in Azure.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute): Use Azure ExpressRoute to create private connections between Azure datacenters and infrastructure on premises or in a colocation environment.
- [Azure Files](https://azure.microsoft.com/services/storage/files): Fully managed file shares in the cloud that are accessible via the industry-standard SMB and NFS protocols.
- [Azure Disk Storage](https://azure.microsoft.com/services/storage/disks): Azure Disk Storage offers high-performance, durable block storage for your mission- and business-critical applications.
- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery): Deploy replication, failover, and recovery processes through Site Recovery to help keep your applications running during planned and unplanned outages.
- [Azure NetApp Files](https://azure.microsoft.com/services/netapp): Azure NetApp Files is an enterprise-class, high-performance, metered file storage service.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault): Use Azure Key Vault to securely store and access secrets.
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway): VPN Gateway sends encrypted traffic between an Azure virtual network and an on-premises location over the public Internet.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy): Use Azure Policy to create, assign, and manage policy definitions in your Azure environment.
- [Azure Backup](https://azure.microsoft.com/services/backup): Azure Backup is a cost-effective, secure, one-click backup solution that’s scalable based on your backup storage needs.

## Scenario details

Murex is a leading global software provider of trading, risk management, processing operations, and post-trade solutions for capital markets. Many banks deploy Murex's third generation platform MX.3 to manage risk, accelerate transformation, and simplify compliance, all while driving revenue growth. The Murex platform enables customers to gain greater control of their operations, improve efficiency, and reduce operational cost.

MX.3 is a client/server application based on a three-tier architecture structure. Banks use MX.3 for their business requirements, like sales and trading, enterprise risk management, and collateral and investment.

Microsoft Azure provides Murex customers a fast and easy way to create and scale an MX.3 infrastructure. Azure enables a secure, reliable, and efficient environment for production, development, and test systems. It significantly reduces the infrastructure cost that's needed to operate the MX.3 environment.

For detailed information about the various tiers and layers of the Murex MX.3 application, compute, and storage requirements, contact the Murex technical team.

*Linux is a trademark of its respective company. No endorsement is implied by the use of this mark.*

### Potential use cases

This solution is ideal for use in the finance industry. The following are some potential use cases.

- Gain better control of operations, improve efficiency, and reduce infrastructure cost.
- Create a secure, reliable, and efficient environment for production and development.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Murex MX.3 is a complex workload with high memory, low latency, and high availability requirements. This section outlines some of the technical considerations that need to be analyzed while implementing a Murex MX.3 workload in Azure.

- MX.3 uses a client/server architecture. When implementing it in Azure, you must follow an infrastructure as a service (IaaS) architecture. Carefully analyze any native Azure services to ensure they meet the technical requirements for Murex.
- You can deploy the MX.3 solution on Azure completely, or you can deploy a partial set of Azure components using a hybrid model. This article doesn't cover hybrid models. You should carefully analyze the architecture and technical requirements before using a hybrid model of deployment. Hybrid models of deployment for MX.3 are subject to technical review by the Murex team.  
- You can access the MX.3 client tier directly from the user desktop or through VDI solutions like Citrix.
- The Murex MX.3 workloads across various tiers require specific types of compute resources to meet the functional and technical requirements. See the [Murex MX.3 architecture](https://www.murex.com/solutions/technology/mx3-architecture) to understand the compute, memory, and storage requirements for an MX.3 workload.
- The MX.3 application requires external (internet) and internal (on-premises) connectivity to perform tasks. The Azure architecture for the MX.3 application must support a secure connectivity model to integrate with internal and external services. Use an Azure site-to-site VPN or ExpressRoute (recommended) to connect with on-premises services.
- For backup, you can use Azure native backup services combined with Azure storage. Use these services for daily, weekly, or monthly backups of the application VMs or any other application tier specific backup/archival requirements. For database requirements, use database native replication or backup tools.
- To get high availability and resiliency of the Murex solutions on Azure, you should run each layer of the application tier in at least two VMs. You can use an Azure availability set configuration to achieve high availability across multiple VMs. You can also use Azure Virtual Machine Scale Sets for redundancy and improved performance of applications that are distributed across multiple instances. You can achieve high availability for the orchestration layer by hosting them in multiple instances and invoking the instances by using custom scripts. You can use database high availability features like Oracle Data Guard or SQL Server Always On to achieve the high availability requirements.
- To achieve the required performance metrics for Murex workloads, consider storing the MX.3 application directory and databases on Azure Managed Disks with Premium SSD. For high input/output operations per second and low latency requirements, you can use Azure NetApp Files as the storage option. You can use a proximity placement group and network acceleration in Azure to achieve high network throughput across layers.
- You can use Azure Monitor to monitor the Azure infrastructure components. You can use its alerting mechanism to take any preventive actions like auto-scaling or notification.
- Use services like Azure Key Vault to address the security requirements of the MX.3 application in Azure by storing keys and certificates. You can use Azure virtual networks, network security groups (NSGs), and application security groups to control access between various layers and tiers. You can use Azure Firewall, DDoS protection, and Azure Application Gateway or Web Application Firewall services to protect the front-end layer depending on the security requirements.
- You can achieve infrastructure automation by using Infrastructure as Code (IaC) services like Azure Resource Manager templates or Terraform scripts. You can use Murex DevOps tools to address the application-level DevOps requirements.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- All layers of the application tier are hosted in at least two VMs or virtual machine scale sets within each availability zone to support high resiliency.
- The business and grid layers of the application tier are hosted on virtual machine scale sets. These scale sets support autoscaling of the VMs based on pre-configured conditions.
- For the orchestration layers, the servers can be distributed across different VMs if needed. If there are issues with one of the VMs, you can configure automation scripts (Resource Manager template or Terraform) and alert notifications to automatically provision more VMs.
- For the persistence tier, you can achieve high availability of the Oracle database through an Oracle Data Guard solution. In this solution, multiple VMs run across availability zones with active replication configured between them.  
- For the application tier, redundant virtual machines are hosted for each of the layers. If there's a disaster in any of the virtual machines, Azure ensures that another instance of the VM is automatically provisioned to support the required level of disaster recovery.
- For disaster recovery, you should run the disaster recovery site in a different Azure region. You can use Active/Active or Active/Passive disaster recovery configurations based on the recovery point objective and recovery time objective requirements. You can use Site Recovery to automate the disaster recovery process and native database replication. You can also use backup tools to achieve the required level of RPO metrics.
- For the persistence tier, you should set up Oracle DataGuard with maximum performance (synchronous commit) to avoid any impact on MX.3. Oracle database instances between availability zones ensure the application is recovered with minimal data loss.
- If there's a region failure, you can use automation scripts (Resource Manager or Terraform) or Site Recovery services to provision the environment quickly in a paired Azure region.
- Depending on the recovery point objective requirements, you can use native Oracle backup solutions like Recovery Manager (RMAN) to periodically back up the database and restore it.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- You can use Azure Firewall to protect the MX.3 virtual network. It helps in threat intelligence and controlling inbound traffic to the presentation layer and outbound traffic from the application tier to the internet.
- Having NSGs in the application subnet and database subnet in an MX.3 application can provide control over network traffic flowing in and out of the database, business, and orchestration layer.
- You can use the Azure Key Vault service to securely store any sensitive information and certificates.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- You can host infrastructure resources for VDI solutions like Citrix in Azure. The client tier uses VDI solutions to access the application tier and optimize the overall cost and performance of the solution.
- If the minimum capacity of the VMs is known, you can use the **Reserved Instances** option for all the VMs. This option reduces the costs of the VMs.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate your costs.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- You can use Azure Monitor to monitor the platform and use Azure Monitor Logs to monitor the application. However, you can also configure your own custom tool to monitor the platform and application if necessary.
- You can use resource tagging to label resources and extend the monitoring of alerts and notifications by using the effective integration of an IT service management system.
- You can use IaC tools like Resource Manager templates or Terraform scripts to automate the infrastructure provisioning process. You can use Azure DevOps tools to integrate IaC tools with the Murex DevOps tools chain.
- You can use Azure policies to codify the security or compliance requirements, and to validate the Azure environment for audit and compliance requirements.

You can provision the VMs in the orchestration layer of the application tier by using custom scripts.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- You can achieve high storage throughput for a database server by using Azure NetApp Files Ultra storage to host the Oracle database. However, you can also use an Azure VM with a managed disk for lower storage throughput like Premium SSD storage.
- For low latency scenarios, use Azure proximity placement groups between the application and persistence tier.
- For better performance and reliability, use ExpressRoute to connect to an on-premises system.
- You can use Azure Files to store files used by the MX.3 application tier, like configuration files, log files, and binary files.

## Network hub-and-spoke model

A key consideration when you implement MX.3 workloads in Azure is defining the landing zone architecture. This architecture contains the subscription, resource group, virtual network isolation, and connectivity between various components of the solution. This section covers the [landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone) to implement an MX.3 workload on Azure, based on the Microsoft Cloud Adoption Framework.

The diagram below shows a high-level view of a landing zone that uses the [hub-spoke network topology in Azure](../../reference-architectures/hybrid-networking/hub-spoke.yml).

:::image type="content" source="./media/azure-hub-and-spoke-model.png" alt-text="Diagram that shows an example of a hub-and-spoke model with Azure services." lightbox="./media/azure-hub-and-spoke-model.png":::

- Using this model allows a strong isolation of the spoke networks used to run different environments. The model also maintains secure control access and a shared service layer in the hub network.
- You can use the same hub-spoke model in another region as it's a multi-region solution. You can build a hub for each region, followed by different spokes for non-production and production.
- You can use this landing zone for a single subscription or multiple subscriptions depending on how your organization categorizes your applications.

Each component in the landing zone is discussed below.

**Hub**: The hub is a virtual network that acts as a central location to manage external connectivity to an MX.3 client’s on-premises network and hosting services used by multiple workloads.

**Spoke**: The spokes are virtual networks that host MX.3’s Azure workloads and connect to the central hub through virtual network peering.

**Virtual network peering**: Hub and spoke virtual networks are connected using virtual network peering, which supports low latency connections between the virtual networks.

**Gateway**: A gateway is used to send traffic from an MX.3 client’s on-premises network to the Azure virtual network. You can encrypt the traffic before it's sent.

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

- [Gansu Adhinarayanan](http://linkedin.com//in/ganapathi-gansu-adhinarayanan-a328b121) | Director - Partner Technology Strategist
- [Vandana Bagalkot](http://linkedin.com/in/vandana-bagalkot) | Principal Cloud Solution Architect
- [Marc van Houten](https://www.linkedin.com/in/marcvanhouten) | Senior Cloud Solution Architect

Other contributors:

- [Astha Malik](http://linkedin.com/in/astha-malik8) | Senior Program Manager
- [Jason Martinez](https://www.linkedin.com/in/jason-martinez-502766123) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Centralize your core services by using hub and spoke Azure virtual network architecture](/training/modules/hub-and-spoke-network-architecture)
- [Get started with Finance and Operations apps](/training/paths/get-started-finance-operations)
- [Hub-and-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology)
- [Murex MX.3 architecture](https://www.murex.com/solutions/technology/mx3-architecture)
- [Recommended Practices for Success with Oracle on Azure IaaS](https://github.com/Azure/Oracle-Workloads-for-Azure/blob/main/Oracle%20on%20Azure%20IaaS%20Recommended%20Practices%20for%20Success.pdf)
- [Reference architectures for Oracle Database Enterprise Edition on Azure](/azure/virtual-machines/workloads/oracle/oracle-reference-architecture)
- [Run Your Most Demanding Oracle Workloads in Azure without Sacrificing Performance or Scalability](https://techcommunity.microsoft.com/t5/azure-architecture-blog/run-your-most-demanding-oracle-workloads-in-azure-without/ba-p/3264545)

## Related resources

- [Hub-spoke network topology in Azure](../../reference-architectures/hybrid-networking/hub-spoke.yml)
- [Oracle Database with Azure NetApp Files](../../example-scenario/file-storage/oracle-azure-netapp-files.yml)
- [Run Oracle databases on Azure](../../solution-ideas/articles/reference-architecture-for-oracle-database-on-azure.yml)
