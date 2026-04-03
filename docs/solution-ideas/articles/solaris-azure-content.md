[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article shows how an emulator called Charon-SSP from the Microsoft partner, Stromasys, can run SPARC processor-based Solaris virtual machines (VMs) in Azure. Charon-SSP is a member of the Charon cross-platform hardware virtualization product family. The emulator can create virtual replicas of Sun-4m, Sun-4u, or Sun-4v SPARC family members on standard x86-64 Linux physical computers or hypervisors.

Running applications in an emulator on Azure has several benefits, such as reduced operational costs and energy consumption. You can also run multiple application instances on a single x86-64 standard host or existing virtualization infrastructure, giving you the advantages of consolidation while easing legacy system management and maintenance.

## Potential use cases

- Enable low-friction "lift-and-shift" from on-premises workloads running on SPARC Solaris machines into Azure.
- Continue to use applications that run on end-of-life SPARCstation or SPARCserver, without changes.
- Manage multiple server hosts and child Solaris VMs from a single interface.
- Allow mapping to low-cost Azure storage to archive tapes for regulatory and compliance purposes.

## Architecture

:::image type="content" border="false" source="../media/solaris.svg" alt-text="Diagram showing the Charon-SSP and Solaris architecture." lightbox="../media/solaris.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/solaris-emulator-azure.vsdx) of this architecture.*

### Dataflow

1. The Charon-SSP Director allows managing multiple server hosts, each potentially running one or more child Solaris VMs. This setup provides a single place of management as you scale out your farm of host VMs and their Solaris child VMs. Charon-SSP Manager provides an easy-to-use and intuitive graphical management interface.
1. The Charon-SSP Agent runs on Linux distributions on Azure VMs. This component runs the child Solaris VMs and emulates the SPARC processor architecture.
1. The child Solaris VMs are based on the SPARC processor architecture.
1. The child Solaris VMs each get their own Azure network interface, and therefore have their own dedicated private IP addresses. Optionally, you can easily set up Azure public IP addresses on the same network interfaces.
1. The Solaris VM images can reside on the solid-state drive (SSD) managed disk of the host Azure VM. Ultra Disks are also a potential option for even higher input/output operations per second (IOPS).
1. Azure Storage Account file shares mounted on the Linux VM allow mapping of the Charon-SSP Virtual Tape Manager to a locally mounted device, which is backed by an Azure Files storage account in the cloud. This mapping allows for low-cost storage of archived tapes for regulatory and compliance purposes.
1. The management VM that runs Charon-SSP Director and Manager can be either Windows-based, or Linux-based with a graphic user interface like [GNOME](https://www.gnome.org).
1. End users can secure-shell (SSH) connect directly to the Solaris VMs, which have their own dedicated network interface cards and IP addresses.

[XDMCP](https://wiki.ubuntu.com/xdmcp) is available for desktop access to the Solaris VMs. XDMCP isn't an encrypted protocol, so the recommended topology for accessing a Solaris VM via XDMCP is to create a Windows Server VM in Azure as a "hop" server, in which an XDMCP client, such as [MobaXterm](https://mobaxterm.mobatek.net), can be installed. With this configuration, all network traffic occurs over the private Azure virtual network.

### Components

- [Azure VMs](/azure/well-architected/service-guides/virtual-machines) are on-demand, scalable computing resources in Azure. An Azure VM gives you the flexibility of virtualization without having to buy and maintain physical hardware. Azure VMs give you a choice of operating systems including Windows and Linux. Azure VMs are used to run the emulation software from Stromasys.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for private networks in Azure. Virtual networks let Azure resources like VMs securely communicate with each other, the internet, and on-premises networks. Azure Virtual Network is similar to a traditional network in your own datacenter, but provides the additional scale, availability, and isolation benefits of the Azure infrastructure. The Virtual Network is used for communication between the applications running on the Virtual Machines, users, and storage.

- [Azure Virtual Network interface cards](/azure/virtual-network/virtual-network-network-interface) enable an Azure VM to communicate with internet, Azure, and on-premises resources. As shown in this architecture, you can add additional network interface cards to the same Azure VM, which allows the Solaris child VMs to have their own dedicated network interface devices and IP addresses.

- [Azure Managed Disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes managed by Azure that are used with Azure VMs. The available types of disks are Ultra Disks, Premium SSDs, Standard SSDs, and Standard HDDs. For this architecture, we recommend either Premium SSDs or Ultra Disks.

- [Azure Files](/azure/well-architected/service-guides/azure-files) storage accounts offer fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud and on-premises deployments of Windows, Linux, and macOS. In this architecture, Azure Files is used as the storage for tape files for regulatory and compliance purposes.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you establish connections to Microsoft cloud services like Microsoft Azure and Microsoft 365. In this architecture, it supports private access to the Stromasys emulation environment for enterprise users.

- [Stromasys Charon-SSP](https://www.stromasys.com/solution/charon-ssp-sun-sparc-virtualization/) emulator recreates the SPARC virtual hardware layer on industry standard x86-64 computer systems and VMs. The virtual SPARC virtual hardware layer is compatible with any Sun software running on it, so there's no need for code conversion or source code. Charon-SSP is fully compatible with SPARC storage, Ethernet, and serial I/O hardware.

## Next steps

- For more information, please contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- See [Charon-SSP](https://www.stromasys.com/solution/charon-ssp-sun-sparc-virtualization/) on the Stromasys website.
- Read the [Charon-SSP Azure Setup Guide](https://stromasys.atlassian.net/wiki/spaces/KBP/pages/814121242/CHARON-SSP+for+Azure+Cloud).
