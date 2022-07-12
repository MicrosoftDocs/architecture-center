Frequently, the evolution and maintenance of business applications is stalled because of underlying legacy hardware. Sometimes the hardware is no longer compatible with newer upgrades and integrations, or, worse, it's no longer supported. Aging infrastructure for mission critical-applications is a concern. The longer the problem remains unsolved, the higher the risk and cost of mitigation. 

These applications have supported the organization's critical business and evolved over decades, gone through audits and certifications, and have well-established operations around them. Instead of a high-risk and complex re-engineering project, an alternative approach is a low-risk project that moves the applications as-is to a modern and less expensive platform, like Azure cloud, with the help of an emulator. Such a project, often called *lift and shift*, preserves the business functionality of the application and replaces only the hardware, guaranteeing business continuity.

Running applications with an emulator on the cloud provides numerous benefits, like security, elasticity, disaster recovery, high availability, and failover. But the most significant benefit is the reduced operational costs and ease of maintenance. No risky migration projects or changes to the software (operating system, middleware) are required. A server virtualization software on Azure can be the first step towards modernization. After the workload is on Azure, you can potentially take advantage of other benefits of the cloud.

This article describes a migration of HP-UX's workload to Azure. HP-UX is HP's Unix operating system for PA-RISC workstations and servers. This article shows how emulator software called Charon-PAR from Microsoft partner [Stromasys](https://www.stromasys.com/about) can run HP-UX workloads on Azure.

The core business of [Stromasys](https://www.stromasys.com) centers on cross-platform virtualization / server virtualization software that allows owners of HP-UX legacy systems to continue running their mission-critical applications unchanged on new industry standard computer systems. Charon products preserve current application investments by enabling customers to continue to use their existing applications and business processes. Because everything continues to run without modification, no re-training or re-staffing is required. Charon products dramatically reduce the cost of ownership by reducing computer footprint, energy consumption, and cooling costs, while eliminating the risks and costs associated with running on aging hardware.

The Stromasys Charon environment provides a significantly higher level of platform stability. For the first time since the first HP-UX systems were introduced, replacing the actual physical server no longer requires any changes to the HP-UX software environment. Charon also provides more platform stability and has virtually unlimited lifetime.

With the steady increase in the use of Azure-hosted systems in the typical corporate environment, an emulated HP-UX system hosted on Linux is the best way to host an HP-UX system in these environments. Integral to the engagement is the ability to demonstrate the functionality of the emulated HP-UX-based applications in a virtual/Azure/Charon environment.

This is illustrated in the following image: 

![Diagram that compares two approaches to migration.](media/comparison.png)

Benefits of the lift-and-shift approach to migration include:

- Azure/Charon customers can continue to use existing critical applications without the cost of rewriting, porting, migrating, or retraining.
- Maintenance costs are reduced by moving these applications to emulated systems that are hosted on Azure.

### Potential use cases

- Enable low-friction lift-and-shift of on-premises HP-UX workloads that run on PA-RISC server machines to Azure.
- Continue to use HP-UX applications that run on end-of-life PA-RISC servers without any changes, but free the applications from old hardware and continue to provide users with the same or better interfaces.
- Manage multiple server hosts and child VMs from a single interface.
- Use low-cost Azure storage to archive tapes for regulatory and compliance.
- Migrate a database to the cloud and run the application in the cloud via emulation without any changes.

## Architecture

:::image type="content" source="media/stromasys-charon-par-hp-ux.png" alt-text="Diagram that shows an architecture for lift-and-shift migration of HP-UX." 
lightbox="media/stromasys-charon-par-hp-ux.png" border="false":::

download link  

Charon-PAR runs on Azure, emulating the PA-RISC systems for HP-UX. On this virtual system (Azure virtual machines), you install the Charon host operating system (Linux), the Charon emulator software, and your legacy operating system (HP-UX) and the associated applications. It's just as though you're using the original hardware. This enables an HP-UX workload or application to run unchanged in an emulation environment on a VM in Azure.

The preceding diagram shows a typical scenario. The numbered annotations refer to the following:

1. The Charon-PAR software runs on Linux Azure VMs because Charon-PAR requires a Linux host. Charon-PAR emulates the PA-RISC processor architecture. The HP-UX workloads run on these emulated PA-RISC systems.
1. The HP-UX workloads can reside on the solid-state drive (SSD) managed disk of the host Azure VM. 
1. One or more host network interface controllers (NICs) can be dedicated to the guest operating system. You can do this by dedicating physical NICs to the guest operating system. The HP-UX VMs each get their own Azure network interface, so they have their own dedicated private IP addresses. This host-specific network interface is normally used within the Charon configuration for the dedicated use of guest workloads.

   Optionally, you can easily set up Azure public IP addresses on the same network interfaces. There must always be network interfaces dedicated to the guest OS. The host is allocated a network interface. PA9-32 720 allows only one network interface, but PA9-64 allows multiple network interfaces dedicated to the guest OS.
1. Users can  connect via Secure Shell (SSH) directly to the HP-UX VMs (if SSH is supported by the version of HP-UX). These VMs their own dedicated network interface cards and IP addresses.
1. Azure storage account file shares mounted on the Linux VM allow mapping of the Charon-PAR virtual tape manager to a locally mounted device, which is backed by an Azure Files storage account in the cloud. This mapping enables low-cost storage of archived tapes for regulatory and compliance purposes.

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) provides on-demand, scalable computing resources in Azure. An Azure VM gives you the flexibility of virtualization without having to buy and maintain physical hardware. Azure VMs give you a choice of operating systems, including Windows and Linux.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks on Azure. Virtual networks enable Azure resources like VMs to communicate with each other, the internet, and on-premises networks. Azure Virtual Network is like a traditional network in your own datacenter, but it provides the additional scale, availability, and isolation benefits of the Azure infrastructure.
- [Azure Virtual Network interface cards](/azure/virtual-network/virtual-network-network-interface) enable an Azure VM to communicate with internet, Azure, and on-premises resources. As shown in the diagram, you can add additional network interface cards to a single Azure VM, which allows the Solaris child VMs to have their own dedicated network interface devices and IP addresses.
- [Azure SSD managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes managed by Azure that are used with Azure VMs. Ultra disks, premium SSDs, standard SSDs, and standard hard disk drives (HDDs) are available. For this architecture, we recommend either premium SSDs or ultra disk SSDs.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) enables you to extend your on-premises networks into the Microsoft Cloud over a private connection that's facilitated by a connectivity provider. By using ExpressRoute, you can establish connections to Microsoft Cloud services like Azure and Microsoft 365.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) and [Azure Files](https://azure.microsoft.com/services/storage/files) offer fully managed file shares in the cloud that can be accessed via the industry-standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS.
- [Stromasys Charon-PAR](https://www.stromasys.com/solutions/charon-par) re-creates the PA-RISC virtual hardware layer on industry standard x86-64 computer systems and VMs. The virtual hardware layer is compatible with a range of HP-UX software running on it [(compatible versions)](https://fileserver.stromasys.com/files/list?apikey=par-3-0-4-lp_6363838b&name=), so there's no need for code conversion or source code.  CHARON-PAR is a member of the Stromasys cross-platform hardware virtualization product family. Charon-PAR is a hardware virtualization layer running under Linux on industry standard servers. It emulates a range of historic 64-bit and 32-bit PA-RISC hardware and allows existing users of such systems to move to modern Intel-based server hardware. 

### Alternatives

- The solution works best with [compute optimized Azure VMs](/azure/virtual-machines/sizes-compute). Compute optimized VM sizes have a high CPU-to-memory ratio. Our [FX series](/azure/virtual-machines/fx-series) virtual machine is a new addition to the F-Series designed for high-frequency compute workloads. The VM features a base frequency of 3.4 GHz, an all-core-turbo (ACT) clock speed of up to 4.0 GHz. FX series is recommended for high end HP-UX workloads.
- This architecture works best with Premium SSDs or Ultra Disk SSDs. Premium SSD Disks are the recommended configuration. However, Azure Ultra SSD managed disks are also a potential option for even higher input/output operations per second (IOPS).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- This solution uses an Azure network security group (NSG) to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).
- [For additional security consider using Azure Bastion](https://azure.microsoft.com/services/azure-bastion), Azure Bastion maximizes admin access security by minimizing open ports. Bastion provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS.

### Performance efficiency 

For the best performance, we recommend a compute-optimized FX-Series. At least one CPU core for the host operating system, and 2 cores per emulated CPU are required.  Fx-series VMs feature a higher CPU-to-memory ratio. They are equipped with 2 GB RAM and 16 GB of local solid-state drive (SSD) per CPU core and are optimized for compute-intensive workloads. The Azure Fs series is possible for low end spec servers, however the required minimum for PAR is 3.0 GHZ (3.4+ GHz recommended) and an FX series instance would be required for high end servers. For more information, to boost performance efficiency , see [Overview of the Performance efficiency pillar](/azure/architecture/framework/scalability/overview).  

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- For proactive monitoring and management, consider using [Azure Monitor](https://azure.microsoft.com/services/monitor) for monitoring Azure Services that are used to host migrated HP-UX workloads.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Azure avoids unnecessary costs by identifying the correct number of resource types, analyzing spending over time, and scaling to meet business needs without overspending. For Example - With Cloud you only pay as you go – so when we do not need workloads we can shut down and save IT costs. Charon-PAR can be started as a service manually and automatically when the Azure VM boots. The service can be stopped manually or automatically when the host system shuts down. We should always ensure that we first shut down the Guest OS(HP-UX), then the emulator (Charon) and then the host VM(Azure VM). When bringing up the system the reverse is true. Here are few other cost optimization considerations:

- [Azure Files](https://azure.microsoft.com/pricing/details/storage/files) pricing depends on many factors: data volume, data redundancy, transaction volume, and the number of file sync servers that you use.
- [Azure Storage](https://azure.microsoft.com/pricing/details/storage) costs depend on data redundancy options and volume.
- The VMs in this architecture use either premium SSDs or Ultra disk SSDs. For more information, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).
- For [ExpressRoute](https://azure.microsoft.com/pricing/details/expressroute), you pay a monthly port fee and outbound data transfer charges.

To estimate the cost of Azure products and configurations, visit the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). To learn more about Stromasys products and their related services, visit the [Stromasys Website](https://www.stromasys.com)

## Next steps

- See [Charon-PAR](https://www.stromasys.com/solutions/charon-par) on the Stromasys website. 
- [Charon on the Azure Cloud | Stromasys](https://www.stromasys.com/solutions/charon-on-the-azure-cloud)
- For more information, contact legacy2azure@microsoft.com.
