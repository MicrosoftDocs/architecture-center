This solution runs SAS analytics workloads on Azure. The guidance covers various deployment scenarios. For instance, multiple versions of SAS are available. You can run SAS software on self-managed virtual machines (VMs). You can also deploy container-based versions by using Azure Kubernetes Service (AKS).

## Architecture

:::image type="complex" source="./images/sas-azure-guide-architecture-diagram.svg" alt-text="Architecture diagram showing how to deploy SAS products on Azure." border="false":::
   The diagram contains a large rectangle with the label Azure Virtual Network. Inside it, another large rectangle has the label Proximity placement group. Two rectangles are inside it. They're stacked vertically, and each has the label Network security group. Each security group rectangle contains several computer icons that are arranged in rows. In the upper rectangle, the computer icons on the left side of the upper row have the label Mid tier. The icons on the right have the label Metadata tier. The lower row of icons has the label Compute tier. In the lower rectangle, the upper row of computer icons has the label MGS and MDS servers. The lower row has the label OSTs and OSS servers.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sas-overview.vsdx) of this architecture.*

### Workflow

SAS Azure deployments typically contain three layers:

- An API or visualization tier. Within this layer:

  - The metadata tier gives client apps access to metadata on data sources, resources, servers, and users.
  - Web apps provide access to intelligence data in the mid tier.

- A compute platform, where SAS servers process data.
- A storage tier that SAS uses for permanent storage. Popular choices on Azure are:

  - Lustre
  - IBM Spectrum Scale
  - Network File System (NFS)

An Azure Virtual Network isolates the system in the cloud. Within that network:

- A proximity placement group reduces latency between VMs.
- Network security groups protect SAS resources from unwanted traffic.

### Prerequisites

Before deploying a SAS workload, ensure the following components are in place:

- A sizing recommendation from a SAS sizing team
- A SAS license file
- Access to a resource group for deploying your resources
- A [virtual central processing unit (vCPU) subscription quota](/azure/virtual-machines/windows/quotas) that takes into account your sizing document and VM choice
- Access to a secure Lightweight Directory Access Protocol (LDAP) server

## Scenario details

Along with discussing different implementations, this guide also aligns with [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/index) tenets for achieving excellence in the areas of cost, DevOps, resiliency, scalability, and security. But besides using this guide, consult with a SAS team for additional validation of your particular use case.

[As partners](https://news.microsoft.com/2020/06/15/sas-and-microsoft-partner-to-further-shape-the-future-of-analytics-and-ai/), Microsoft and SAS are working to develop a roadmap for organizations that innovate in the cloud. Both companies are committed to ensuring high-quality deployments of SAS products and solutions on Azure.

### Introduction to SAS

SAS analytics software provides a suite of services and tools for drawing insights from data and making intelligent decisions. SAS platforms fully support its solutions for areas such as data management, fraud detection, risk analysis, and visualization. SAS offers these primary platforms, which Microsoft has validated:

- SAS Grid 9.4
- SAS Viya

The following architectures have been tested:

- SAS Grid 9.4 on Linux
- SAS 9 Foundation
- SAS Viya 3.5 with symmetric multiprocessing (SMP) and massively parallel processing (MPP) architectures on Linux
- SAS Viya 2020 and up with an MPP architecture on AKS

This guide provides general information for running SAS on Azure, not platform-specific information. These guidelines assume that you host your own SAS solution on Azure in your own tenant. SAS doesn't host a solution for you on Azure. For more information on the Azure hosting and management services that SAS provides, see [SAS Managed Application Services](https://www.sas.com/en_us/solutions/cloud/sas-cloud/managed-application-services.html).

## Recommendations

Consider the points in the following sections when designing your implementation.

SAS documentation provides requirements per core, meaning per physical CPU core. But Azure provides vCPU listings. On the VMs that we recommend for use with SAS, there are two vCPU for every physical core. As a result, to calculate the value of a vCPU requirement, use half the core requirement value. For instance, a physical core requirement of 150 MBps translates to 75 MBps per vCPU. For more information on Azure computing performance, see [Azure compute unit (ACU)](/azure/virtual-machines/acu).

> [!NOTE]
> If you're scaling up and persisting data in a single-node SAS deployment (and not to an externalized file system), the [SAS documentation](https://communities.sas.com/t5/Administration-and-Deployment/Best-Practices-for-Using-Microsoft-Azure-with-SAS/m-p/676833) recommends bandwidth of at least 150 MB/s. To achieve this bandwidth, you need to stripe multiple P30 Premium (or larger) disks.

### Operating systems

Linux works best for running SAS workloads. SAS supports 64-bit versions of the following operating systems:

- Red Hat 7 or newer
- SUSE Linux Enterprise Server (SLES) 12.2
- Oracle Linux 6 or later

For more information about specific SAS releases, see the [SAS Operating System support matrix](https://support.sas.com/supportos/list?requestAction=summary&outputView=sasrelease&sasrelease=9.4&platformGroup=UNIX&platformName=Linux+64-bit). In environments that use multiple machines, it's best to run the same version of Linux on all machines. Azure doesn't support Linux 32-bit deployments.

To optimize compatibility and integration with Azure, start with an operating system image from Azure Marketplace. If you use a custom image without additional configurations, it can degrade SAS performance.

#### Kernel issues

When choosing an operating system, be aware of a soft lockup issue that affects the entire Red Hat 7.x series. It occurs in these kernels:

- Linux 3.x kernels
- Versions earlier than 4.4

A problem with the [memory and I/O management of Linux and Hyper-V](https://access.redhat.com/solutions/22621) causes the issue. When it comes up, the system logs contain entries like this one that mention a non-maskable interrupt (NMI):

```console
Message from syslogd@ronieuwe-sas-e48-2 at Sep 13 08:26:08
kernel:NMI watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [swapper/12:0]
```

Another issue affects older versions of Red Hat. Specifically, it can happen in versions that meet these conditions:

- Have Linux kernels that precede 3.10.0-957.27.2
- Use non-volatile memory express (NVMe) drives

When the system experiences high memory pressure, the generic Linux NVMe driver may not allocate sufficient memory for a write operation. As a result, the system reports a soft lockup that stems from an actual deadlock.

Upgrade your kernel to avoid both issues. Alternatively, try this possible workaround:

- Set `/sys/block/nvme0n1/queue/max_sectors_kb` to `128` instead of using the default value, `512`.
- Change this setting on each NVMe device in the VM and on *each* VM boot.

Run these commands to adjust that setting:

```shell
# cat /sys/block/nvme0n1/queue/max_sectors_kb
512
# echo 128 >/sys/block/nvme0n1/queue/max_sectors_kb
# cat /sys/block/nvme0n1/queue/max_sectors_kb
128
```

### VM sizing recommendations

SAS deployments often use the following VM SKUs:

#### Edsv5-series

VMs in the Edsv5-series are the default SAS machines for Viya and Grid. They offer these features:

- Constrained cores. With many machines in this series, you can constrain the VM vCPU count.
- A good CPU-to-memory ratio.
- A high-throughput locally attached disk. I/O speed is important for folders like `SASWORK` and the Cloud Analytics Services (CAS) cache, `CAS_CACHE`, that SAS uses for temporary files.

If the Edsv5-series VMs are unavailable, it's recommended to use the prior generation. The [Edsv4-series VMs](/azure/virtual-machines/edv4-edsv4-series) have been tested and perform well on SAS workloads.

#### Ebsv5-series

In some cases, the locally attached disk doesn't have sufficient storage space for `SASWORK` or `CAS_CACHE`. To get a larger working directory, use the [Ebsv5-series of VMs](/azure/virtual-machines/ebdsv5-ebsv5-series) with premium attached disks. These VMs offer these features:

- Same specifications as the Edsv5 and Esv5 VMs
- High throughput against remote attached disk, up to 4 GB/s, giving you as large a `SASWORK` or `CAS_CACHE` as needed at the I/O needs of SAS.

If the Edsv5-series VMs offer enough storage, it's better to use them as they're more cost efficient. 

#### M-series

Many workloads use M-series VMs, including:

- SAS Programming Runtime Environment (SPRE) implementations that use a Viya approach to software architecture.
- Certain SAS Grid workloads.

M-series VMs offer these features:

- Constrained cores
- Up to 3.8 TiB of memory, suited for workloads that use a large amount of memory
- High throughput to remote disks, which works well for the `SASWORK` folder when the locally available disk is insufficient

#### Ls-series

Certain I/O heavy environments should use [Lsv2-series](/azure/virtual-machines/lsv2-series) or [Lsv3-series](/azure/virtual-machines/lsv3-series) VMs. In particular, implementations that require fast, low latency I/O speed and a large amount of memory benefit from this type of machine. Examples include systems that make heavy use of the `SASWORK` folder or `CAS_CACHE`. 

> [!NOTE]
> SAS optimizes its services for use with the Intel Math Kernel Library (MKL).
>
> - With math-heavy workloads, avoid VMs that don't use Intel processors: the Lsv2 and Lasv3.
> - When selecting an AMD CPU, validate how the MKL performs on it.

> [!WARNING]
> When possible, avoid using Lsv2 VMs. Please use the Lsv3 VMs with Intel chipsets instead.

With Azure, you can scale SAS Viya systems on demand to meet deadlines:

- By increasing the compute capacity of the node pool.
- By using the AKS [Cluster Autoscaler](/azure/aks/cluster-autoscaler) to add nodes and scale horizontally.
- By temporarily scaling up infrastructure to accelerate a SAS workload.

> [!NOTE]
> When scaling computing components, also consider scaling up storage to avoid storage I/O bottlenecks.

With Viya 3.5 and Grid workloads, Azure doesn't support horizontal or vertical scaling at the moment. Viya 2022 supports horizontal scaling.

### Network and VM placement considerations

SAS workloads are often chatty. As a result, they can transfer a significant amount of data. With all SAS platforms, follow these recommendations to reduce the effects of chatter:

- Deploy SAS and storage platforms on the same virtual network. This approach also avoids incurring peering costs.
- Place SAS machines in a [proximity placement group](/azure/virtual-machines/co-location) to reduce latency between nodes.
- When possible, deploy SAS machines and VM-based data storage platforms in the same proximity placement group.
- Deploy SAS and storage appliances in the same availability zone to avoid cross-zone latency. If you can't confirm your solution components are deployed in the same zone, contact Azure support.

SAS has specific fully qualified domain name (FQDN) requirements for VMs. Set machine FQDNs correctly, and ensure that domain name system (DNS) services are working. You can set the names with Azure DNS. You can also edit the `hosts` file in the `etc` configuration folder.

> [!NOTE]
> Turn on accelerated networking on all nodes in the SAS deployment. When you turn this feature off, performance suffers significantly.
>
> To turn on accelerated networking on a VM, follow these steps:
>
> 1. Run this command in the Azure CLI to deallocate the VM:
>
>    `az vm deallocate --resource-group <resource_group_name> --name <VM_name>`
> 1. Turn off the VM.
> 1. Run this command in the CLI:
>
>    `az network nic update -n <network_interface_name> -g <resource_group_name> --accelerated-networking true`

When you migrate data or interact with SAS in Azure, we recommend that you use one of these solutions to connect on-premises resources to Azure:

- An [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/) circuit
- A [virtual private network (VPN)](/azure/vpn-gateway/vpn-gateway-about-vpngateways)

For production SAS workloads in Azure, ExpressRoute provides a private, dedicated, and reliable connection that offers these advantages over a site-to-site VPN:

- Higher speed
- Lower latency
- Tighter security

Be aware of latency-sensitive interfaces between SAS and non-SAS applications. Consider moving data sources and sinks close to SAS.

### Identity management

SAS platforms can use local user accounts. They can also use a secure LDAP server to validate users. We recommend running a domain controller in Azure. Then use the domain join feature to properly manage security access. If you haven't set up domain controllers, consider deploying [Azure Active Directory Domain Services (Azure AD DS)](../../reference-architectures/identity/adds-extend-domain.yml). When you use the domain join feature, ensure machine names don't exceed the 15-character limit.

> [!NOTE]
> In some environments, there's a requirement for on-premises connectivity or shared datasets between on-premises and Azure-hosted SAS environments. In these situations, we strongly recommended deploying a domain controller in Azure.
>
> The Azure AD DS forest creates users that can authenticate against Azure AD devices but not on-premises resources and vice versa.

### Data sources

SAS solutions often access data from multiple systems. These data sources fall into two categories:

- SAS datasets, which SAS stores in the `SASDATA` folder
- Databases, which SAS often places a heavy load on

For best performance:

- Position data sources as close as possible to SAS infrastructure.
- Limit the number of network hops and appliances between data sources and SAS infrastructure.

> [!NOTE]
> If you can't move data sources close to SAS infrastructure, avoid running analytics on them. Instead, run extract, transform, load (ETL) processes first and analytics later. Take the same approach with data sources that are under stress.

#### Permanent remote storage for SAS Data

SAS and Microsoft have tested a series of data platforms that you can use to host SAS datasets. The SAS blogs document the results in detail, including performance characteristics. The tests include the following platforms:

- [Sycomp Storage Fueled by IBM Spectrum Scale](https://azuremarketplace.microsoft.com/en-us/marketplace/apps?search=Sycomp%20Storage&page=1), which uses General Parallel File System (GPFS)
- [EXAScaler Cloud by DataDirect Networks (DDN)](https://azuremarketplace.microsoft.com/marketplace/apps/ddn-whamcloud-5345716.exascaler_cloud_app?tab=overview), which is based on the Lustre file system
- [Azure NetApp Files](https://azure.microsoft.com/services/netapp/), which supports NFS file-storage protocols

SAS offers performance-testing scripts for the Viya and Grid architectures. The [SAS forums](https://communities.sas.com/t5/Administration-and-Deployment/bd-p/sas_admin) provide documentation on tests with scripts on these platforms.

##### Sycomp Storage Fueled by IBM Spectrum Scale (GPFS)

For information about how Sycomp Storage Fueled by IBM Spectrum Scale meets performance expectations, see [SAS review of Sycomp for SAS Grid](https://communities.sas.com/t5/Administration-and-Deployment/Sycomp-Storage-Fueled-by-IBM-Spectrum-Scale-A-new-shared-file/m-p/701508#M20810).

For sizing, Sycomp makes the following recommendations:

- Provide one GPFS scale node per eight cores with a configuration of 150 MBps per core.
- Use a minimum of five P30 drives per instance.

##### DDN EXAScaler Cloud (Lustre)

DDN, which acquired Intel's Lustre business, provides EXAScaler Cloud, which is based on the Lustre parallel file system. The solution is available in the Azure Marketplace as part of the DDN EXAScaler Cloud umbrella. Designed for data-intensive deployment, it provides high throughput at low cost.

[Tests show that DDN EXAScaler can run SAS workloads in a parallel manner](https://communities.sas.com/t5/Administration-and-Deployment/EXAScaler-Cloud-by-DDN-A-shared-file-system-to-use-with-SAS-Grid/m-p/714234#M21291). DDN recommends running this command on all client nodes when deploying EXAScaler or Lustre:

```shell
lctl set_param mdc.*.max_rpcs_in_flight=128 osc.*.max_pages_per_rpc=16M osc.*.max_rpcs_in_flight=16 osc.*.max_dirty_mb=1024 llite.*.max_read_ahead_mb=2048 osc.*.checksums=0  llite.*.max_read_ahead_per_file_mb=256
```

##### Azure NetApp Files (NFS)

SAS tests have [validated NetApp performance for SAS Grid](https://communities.sas.com/t5/Administration-and-Deployment/Azure-NetApp-Files-A-shared-file-system-to-use-with-SAS-Grid-on/td-p/579437). Specifically, testing shows that Azure NetApp Files is a viable primary storage option for SAS Grid clusters of up to 32 physical cores across multiple machines. When [NetApp provided optimizations and Linux features](https://communities.sas.com/t5/Administration-and-Deployment/Azure-NetApp-Files-A-shared-file-system-to-use-with-SAS-Grid-on/m-p/722261/highlight/true#M21648) are used, Azure NetApp Files can be the primary option for clusters up to 48 physical cores across multiple machines.

Consider the following points when using this service:

- Azure NetApp Files works well with Viya deployments. Don't use Azure NetApp Files for the CAS cache in Viya, because the write throughput is inadequate. If possible, use your VM's local ephemeral disk instead.
- On SAS 9 Foundation with Grid 9.4, the performance of Azure NetApp Files with SAS for `SASDATA` files is good for clusters up to 32 physical cores. This goes up to 48 cores when [tuning](https://communities.sas.com/t5/Administration-and-Deployment/Azure-NetApp-Files-A-shared-file-system-to-use-with-SAS-Grid-on/m-p/722261/highlight/true#M21648) applied.
- To ensure good performance, select at least a Premium or Ultra storage tier [service level](/azure/azure-netapp-files/azure-netapp-files-service-levels) when deploying Azure NetApp Files. You can choose the Standard service level for very large volumes. Consider starting with the Premium level and switching to Ultra or Standard later. Service level changes can be done online, without disruption or data migrations.
- Read and write [performance are different](/azure/azure-netapp-files/azure-netapp-files-performance-considerations) for Azure NetApp Files. Write throughput for SAS hits limits at around 1600MiB/s while read throughput goes beyond that, to around 4500MiB/s. If you need continuous high write throughput, Azure NetApp Files may not be a good fit.

#### Other data sources

SAS platforms support various data sources:

- An [Azure Data Lake Storage account](https://communities.sas.com/t5/SAS-Communities-Library/SAS-Viya-3-5-CAS-accessing-Azure-Data-Lake-files/ta-p/635147) that uses a [hierarchical namespace](/azure/storage/blobs/data-lake-storage-namespace)
- [Azure Synapse Analytics](https://blogs.sas.com/content/subconsciousmusings/2020/12/04/3-steps-to-better-models-with-sas-and-azure-synapse/)
- Apache Hadoop and Hive on [Azure HDInsight](https://communities.sas.com/t5/SAS-Communities-Library/SAS-Viya-CAS-accessing-Azure-HDInsight/ta-p/700597)
- SQL Server
- SQL Server using Open Database Connectivity (ODBC)

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The output of your SAS workloads can be one of your organization's critical assets. SAS output provides insight into internal efficiencies and can play a critical role in reporting strategy. It's important, then, to secure access to your SAS architecture. To achieve this goal, use secure authentication and address network vulnerabilities. Use encryption to protect all data moving in and out of your architecture.

Azure delivers SAS by using an infrastructure as a service (IaaS) cloud model. Microsoft builds security protections into the service at the following levels:

- Physical datacenter
- Physical network
- Physical host
- Hypervisor

Carefully evaluate the services and technologies that you select for the areas above the hypervisor, such as the guest operating system for SAS. Make sure to provide the proper security controls for your architecture.

SAS currently doesn't fully support [Azure Active Directory (Azure AD)](/azure/active-directory/). For authentication into the visualization layer for SAS, you can use Azure AD. But for back-end authorization, use a strategy that's similar to on-premises authentication. When managing IaaS resources, you can use Azure AD for authentication and authorization to the Azure portal. When using Azure AD DS, you can't authenticate guest accounts. Guest attempts to sign in will fail.

Use [network security groups](/azure/virtual-network/security-overview) to filter network traffic to and from resources in your [virtual network](/azure/virtual-network/virtual-networks-overview). With these groups, you can define rules that grant or deny access to your SAS services. Examples include:

- Giving access to CAS worker ports from on-premises IP address ranges.
- Blocking access to SAS services from the internet.

You can use [Azure Disk Encryption](/azure/security/azure-security-disk-encryption-faq) for encryption within the operating system. This solution uses the DM-Crypt feature of Linux. But we currently don't recommend using Azure Disk Encryption. It can severely degrade performance, especially when you use `SASWORK` files locally.

[Server-side encryption (SSE) of Azure Disk Storage](/azure/virtual-machines/disk-encryption) protects your data. It also helps you meet organizational security and compliance commitments. With Azure managed disks, SSE encrypts the data at rest when persisting it to the cloud. This behavior applies by default to both OS and data disks. You can use platform-managed keys or your own keys to encrypt your managed disk.

#### Protect your infrastructure

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship](/azure/active-directory/active-directory-how-subscriptions-associated-directory) with an Azure AD tenant. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope. The scope can be a subscription, a resource group, or a single resource. Make sure to [audit all changes to infrastructure](/azure/azure-resource-manager/resource-group-audit).

Manage remote access to your VMs through [Azure Bastion](https://azure.microsoft.com/services/azure-bastion/#get-started). Don't expose any of these components to the internet:

- VMs
- Secure Shell Protocol (SSH) ports
- Remote Desktop Protocol (RDP) ports

## Deploy this scenario

It's best to deploy workloads using an infrastructure as code (IaC) process. SAS workloads can be sensitive to misconfigurations that often occur in manual deployments and reduce productivity.

When building your environment, see quickstart reference material in these repositories:

- [Automating SAS Deployment on Azure using GitHub Actions](https://github.com/grtn316/viya4-iac-azure)
- [CoreCompete SAS 9 or Viya on Azure](https://github.com/corecompete/sas94-viya)

<!--More details can be found in the pages specific to [Viya 3.5](sas-viya-35-overview.md) and [Grid](sas-grid-94-overview.md). -->

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:
- [Roeland Nieuwenhuis](https://www.linkedin.com/in/roelandnieuwenhuis) | Principal Cloud Solution Architect
- [David Baumgarten](https://www.linkedin.com/in/baumgarten-david) | Senior Cloud Solution Architect

Other contributor:
- [Drew Furgiuele](https://www.linkedin.com/in/pittfurg) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For help getting started, see the following resources:

- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml?tabs=portal)
- [Edsv5 series VMs](/azure/virtual-machines/edv5-edsv5-series)
- [Ebsv5 series VMs](/azure/virtual-machines/ebdsv5-ebsv5-series)
- [Lsv3 series VMs](/azure/virtual-machines/lsv3-series)
- [Proximity placement groups](/azure/virtual-machines/co-location)
- [Azure availability zones](/azure/availability-zones/az-overview)

For help with the automation process, see the following templates that SAS provides:

- [SAS Viya 4 Infrastructure as Code](https://github.com/sassoftware/viya4-iac-azure)
- [SAS Viya 3.5 Guide](https://github.com/sassoftware/sas-viya-3.5-ha-deployment/blob/main/sas-viya-3.5-ha-deployment-on-microsoft-azure/SAS-Viya-HA-Deployment-Azure.md)
- [SAS 9.4 Grid](https://github.com/corecompete/sas94grid-viya)

## Related resources

- [Azure Kubernetes in event stream processing](/azure/architecture/solution-ideas/articles/serverless-event-processing-aks)
- [GitOps for Azure Kubernetes Service](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks)
- [Monitor a microservices architecture in Azure Kubernetes Service (AKS)](/azure/architecture/microservices/logging-monitoring)
- [Cost management for Kubernetes](/azure/architecture/aws-professional/eks-to-aks/cost-management)
- [Oracle Database with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/oracle-azure-netapp-files)
- [SQL Server on Azure Virtual Machines with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/sql-server-azure-netapp-files)
