Intro

## Potential use cases

This solution applies to many areas:



## Architecture

:::image type="complex" source="./media/sql-server-azure-net-app-files-architecture.png" alt-text="Architecture diagram showing how information flows through a genomics analysis and reporting pipeline." border="false":::
   The diagram contains two boxes. The first, on the left, has the label Azure Data Factory for orchestration. The second box has the label Clinician views. The first box contains several smaller boxes that represent data or various Azure components. Arrows connect the boxes, and numbered labels on the arrows correspond with the numbered steps in the document text. Two arrows flow between the boxes, ending in the Clinician views box. One arrow points to a clinician icon. The other points to a Power BI icon.
:::image-end:::

The components in the solution function and interact in these ways:

- SQL Server runs on an Azure VM within the SQL subnet.
- In the ANF subnet, Azure NetApp Files stores the database and log files.
- SQL Server accesses database files by using version 3 of Server Message Block (SMB), a network file sharing protocol.
- Azure NetApp Files has the [SMB Continuous Availability shares option][SMB Continuous Availability (CA) shares (Preview)] turned on. This feature makes SMB Transparent Failover possible, so you can do non-disruptive maintenance on Azure NetApp Files.





### Components

The solution uses the following components:

- [Azure NetApp Files][Azure NetApp Files] makes it easy to migrate and run file-based applications with no code change. This shared file-storage service is a joint development from Microsoft and NetApp.
- [Azure Virtual Machines][Azure Virtual Machines] are on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. This solution uses Windows virtual machines.
- [SQL Server on Azure Virtual Machines][What is SQL Server on Azure Virtual Machines (Windows)] provides a way to migrate SQL Server workloads to the cloud with 100 percent code compatibility. As part of the Azure SQL family, SQL Server on Azure Virtual Machines offers the flexibility and hybrid connectivity of Azure. But this database solution also provides the performance, security, and analytics of SQL Server. You can continue to use your current SQL Server version. You can also access the latest SQL Server updates and releases, including SQL Server 2019. This solution uses Windows virtual machines.
- [Azure Virtual Network][Azure Virtual Network] is a networking service that manages virtual private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a datacenter. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of Azure's infrastructure.

## Considerations

The following considerations align with the [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework] and apply to this solution:

### Availability considerations

The service level agreements (SLAs) of most Azure components guarantee availability:


### Scalability considerations

Most Azure services are scalable by design:


### Security considerations

The technologies in this solution meet most companies' requirements for security.

## Deploy the solution



## Pricing

With most Azure services, you can reduce costs by only paying for what you use:

- With [Data Factory, your activity run volume determines the cost][Data Factory pricing].
- [Azure Databricks offers many tiers, workloads, and pricing plans][Azure Databricks general pricing information] to help you minimize costs.
- [Blob Storage costs depend on data redundancy options and volume][Azure Storage costs].
- With [Data Lake Storage, pricing depends on many factors: your namespace type, storage capacity, and choice of tier][Data Lake Storage pricing].
- For [Microsoft Genomics, the charge depends on the number of gigabases that each workflow processes][Microsoft Genomics - pricing].

## Next steps


## Related resources

Fully deployable architectures:

[Azure NetApp Files]: https://azure.microsoft.com/en-us/services/netapp/
[Azure Virtual Machines]: https://azure.microsoft.com/en-us/services/virtual-machines/#overview
[Azure Virtual Network]: https://azure.microsoft.com/en-us/services/virtual-network/
[SMB Continuous Availability (CA) shares (Preview)]: https://docs.microsoft.com/en-us/azure/azure-netapp-files/whats-new#march-2021
[What is SQL Server on Azure Virtual Machines (Windows)]: https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview