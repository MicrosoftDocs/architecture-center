This example scenario shows how to run [Apache NiFi][Apache NiFi] on Azure. Apache NiFi provides a system for processing and distributing data. NiFi works well for moving data and managing the flow of data:

- Connecting decoupled systems in the cloud
- Moving data in and out of Azure Storage and other data stores
- Integrating edge-to-cloud and hybrid-cloud applications with Azure IoT, Azure Stack, and Azure Kubernetes Service

In this scenario, NiFi runs in a clustered configuration across virtual machines in a scale set. But most recommendations also apply to scenarios that run NiFi in single-instance mode on a single virtual machine (VM). The best practices in this article demonstrate a scalable, high-availability, and secure deployment.

Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

- A paragraph that describes what the solution does (the domain)
- A paragraph that contains a brief description of the main Azure services that make up the solution.

## Potential use cases

This solution applies to many areas:

- Modern data warehouses (MDWs) bring structured and unstructured data together at scale. They collect and store data from a variety of sources, sinks, and formats. Apache NiFi excels at ingesting data into Azure-based MDWs for the following reasons:

  - Over 200 processors are available for reading, writing, and manipulating data.
  - The system supports Storage services including Blob Storage, ADLS Gen2, Event Hubs, Queue Storage, Cosmos DB, and Synapse.
  - Robust data provenance capabilities make it possible to implement compliant solutions. For information about capturing data provenance in Azure Log Analytics, see [][].

- NiFi can run standalone on small-footprint devices. In such cases, NiFi makes it possible to process edge data and move that data to larger NiFi instances or clusters in the cloud. NiFi helps filter, transform, and prioritize edge data in motion, ensuring reliable and efficient data flows.

- Industrial IoT (IIoT) solutions manage the flow of data from the edge to the data center. That flow starts with data acquisition from industrial control systems and equipment. The data then moves to data management solutions and MDWs. Apache NiFi offers capabilities that make it well suited for data acquisition and movement:

  - Edge data processing functionality
  - Support for protocols that IoT gateways and devices use
  - Integration with Azure Event Hubs and Azure Storage services

  IoT applications in the areas of predictive maintenance and supply chain management can make use of this functionality.

## Architecture

:::image type="content" source="./media/azure-nifi-architecture.svg" alt-text="Architecture diagram showing how data flows through an H T A P solution with Azure SQL Database at its center." border="false":::

*Download a [Visio file][Visio file of architecture diagram] of this architecture.*

- The Apache NiFi application runs on VMs in Apache NiFi cluster nodes. The VMs are in a virtual machine scale set (VMSS) that the configuration deploys across availability zones.

- Apache NiFi uses the Apache ZooKeeper cluster for these purposes:

  - To elect a cluster coordinator node
  - To coordinate the flow of data

- Azure Application Gateway provides layer-7 load balancing for the user interface that runs on the Apache NiFi nodes.

- Azure Monitor and Log Analytics collect, analyze, and act on telemetry from the Apache NiFi system. The telemetry includes the Apache NiFi system logs, system health metrics, and performance metrics. Add reference to Monitoring section (see original document).

- Azure Key Vault securely stores certificates and keys for the Apache NiFi cluster.

- Azure Active Directory (Azure AD) provides single sign-on and multi-factor authentication.

### Components

- Apache NiFi provides a system for processing and distributing data.
- Apache ZooKeeper is an open-source server that manages distributed systems.
- Virtual Machines is an infrastructure-as-a-service (IaaS) offer. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware.
- [Azure virtual machine scale sets][What are virtual machine scale sets?] provide a way to manage a group of load-balanced VMs. The number of VM instances in a set can automatically increase or decrease in response to demand or a defined schedule.
- [Availability zones][Availability Zones] are unique physical locations within an Azure region. These high-availability offerings protect applications and data from datacenter failures.
- [Azure Application Gateway][What is Azure Application Gateway?] is a load balancer that manages traffic to web applications.
- [Azure Monitor][Azure Monitor overview] collects and analyzes data on environments and Azure resources. This data includes app telemetry, such as performance metrics and activity logs.
- [Log Analytics][Log Analytics tutorial] is an Azure portal tool that runs queries on Monitor log data. Log Analytics also provides features for charting and statistically analyzing query results.
- [Azure DevOps Services][Azure DevOps] provides services, tools, and environments for managing coding projects and deployments.
- [Azure Key Vault][Azure Key Vault] securely stores and controls access to a system's secrets, such as API keys, passwords, certificates, and cryptographic keys.
- [Azure Active Directory (Azure AD)][Azure Active Directory (Azure AD)] is a cloud-based identity service that controls access to Azure and other cloud apps.

### Alternatives

- [Azure Data Factory][Data Factory] provides an alternative to this solution.
- Instead of Azure Key Vault, you can use a comparable service to store system secrets.

## Recommendations

Keep the following points in mind when you use this solution:

### Recommended versions of Apache NiFi

When you run this solution on Azure, we recommend using version 1.13.2+ of Apache NiFi. You can run other versions, but they may require different configurations from the ones in this guide.

To install Apache NiFi on Azure VMs, it's best to download the convenience binaries from the [Apache NiFi downloads page][Apache nifi Downloads]. You can also build the binaries from [source code][NiFi on GitHub].

### Recommended versions of Apache ZooKeeper

For this example workload we recommend using versions 3.5.5 and later or 3.6.x of Apache ZooKeeper.

You can install Apache ZooKeeper on Azure VMs by using official convenience binaries or source. Both are available on the [Apache ZooKeeper releases page][Apache ZooKeeper Releases].

### Implementation recommendations

- To configure the Apache NiFi application, see the [Apache NiFi System Administrator's Guide][NiFi System Administrators Guide].
- To increase availability, deploy the ZooKeeper cluster on separate VMs from the VMs in the NiFi cluster. For more information on configuring ZooKeeper, see [State Management][NiFi System Administrators Guide - State Management] in the Apache NiFi System Administrator's Guide.
- Use a load balancer for the UI to increase its availability in the event of node downtime. Limit access to within the virtual network by configuring the application gateway to only use an internal subnet IP address. Only configure the application gateway to include a public IP if the cluster is accessed over the public internet.

## Considerations

The following considerations apply to this solution:

### VM considerations

The following sections provide a detailed outline of how to configure the Apache NiFi VMs:

#### VM size

The following table lists recommended VM sizes to start with. For most general-purpose data flows, Standard_D16s_v3 is best. But each data flow in Apache NiFi has different requirements. Test your flow and resize as needed based on the flow's actual requirements.

Consider enabling accelerated networking on the VMs to increase network performance. For more information, see [Networking for Azure virtual machine scale sets][Networking for Azure virtual machine scale sets - Accelerated Networking].

| VM size | vCPU | Memory in GiB | Max uncached data disk throughput in I/O operations per second (IOPS) per MBps* | Max NICs / Expected network bandwidth (Mbps) |
|---|---|---|---|---|
| Standard_D8s_v3 | 8 | 32 | 12800/192 | 4/4000 |
| Standard_D16s_v3** | 16 | 64 | 25600/384 | 8/8000 |
| Standard_D32s_v3 | 32 | 128 | 51200/768 | 8/16000 |
| Standard_M16m | 16 | 437.5 | 10000/250 | 8/4000|

\* Disable data disk write caching for all data disks that you use on Apache NiFi nodes.

\*\* We recommend this SKU for most general-purpose data flows. Azure VM SKUs with similar vCPU and memory configurations should also perform adequately.

#### VM operating system (OS)

We recommend running Apache NiFi in Azure on one of the following guest operating systems:

- Ubuntu 18.04 LTS or later
- CentOS 7.9

To meet the specific requirements of your data flow, it's important to adjust a number of OS-level settings including:

- Maximum forked processes
- Maximum file handles
- Access time, or atime

Once you adjust the OS to fit your expected use case, use Azure Image Builder to codify the generation of those tuned images. For guidance that's specific to Apache NiFi, see [Configuration Best Practices][NiFi System Administrators Guide - Configuration Best Practices] in the Apache NiFi System Administrator's Guide.

### Storage considerations

Store the various Apache NiFi repositories on data disks and not on the OS disk for three main reasons:

- Flows often have high disk throughput requirements that a single disk cannot meet.
- You should separate the Apache NiFi disk operations from the OS disk operations.
- The repositories should not be on temporary storage.

The following sections outline guidelines for configuring the data disks. These guidelines are specific to Azure. For more information on configuring the repositories, see [State Management][NiFi System Administrators Guide - State Management] in the Apache NiFi System Administrator's Guide.

#### Data disk type and size

Consider these factors when you configure the data disks for Apache NiFi:

- Disk type
- Disk size
- Total number of disks

> [!NOTE]
> For up-to-date information on disk types, sizing, and pricing, see [Introduction to Azure managed disks][Introduction to Azure managed disks].

The following table shows the types of managed disks that are currently available in Azure. You can use Apache NiFi any of these disk types. But for high-throughput data flows, we recommend Premium SSD.

| | Ultra Disk (NVMe) | Premium SSD | Standard SSD | Standard HDD |
| --- | --- | --- | --- | ---|
| **Disk type** | SSD | SSD | SSD | HDD |
| **Max disk size** | 65,536 (GiB) | 32,767 GiB | 32,767 GiB | 32,767 GiB |
| **Max throughput** | 2,000 MiB/s | 900 MiB/s | 750 MiB/s | 500 MiB/s |
| **Max IOPS** | 160,000 | 20,000 | 6,000 | 2,000 |

Use at least three data disks to increase throughput of the data flow. For best practices for configuring the repositories on the disks, see add link to the repository configuration section.

The following table list the relevant size and throughput numbers for each disk size and type.

| | Standard HDD S15 |  Standard HDD S20 |  Standard HDD S30 |  Standard SSD S15 |  Standard SSD S20 |  Standard SSD S30 | Premium SSD P15 | Premium SSD P20 | Premium SSD P30 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Disk Size in GiB** | 256 | 512 | 1,024 | 256 | 512 | 1,024 | 256 | 512 | 1,024 |
| **IOPS per disk** | Up to 500 | Up to 500 | Up to 500 | Up to 500 | Up to 500 | Up to 500 | 1,100 | 2,300 | 5,000 |
| **Throughput per disk** | Up to 60 MiB/sec | Up to 60 MiB/sec | Up to 60 MiB/sec | Up to 60 MiB/sec | Up to 60 MiB/sec | Up to 60 MiB/sec | 125 MiB/sec | 150 MiB/sec | 200 MiB/sec |

If your system hits VM limits, adding more disks may not increase throughput:

- IOPS and throughput limits depend on the size of the disk.
- The VM size thaht you choose places IOPs and throughput limits for the VM on all data disks.

For VM-level disk throughput limits, see [Sizes for Linux virtual machines in Azure][Sizes for virtual machines in Azure].

#### VM disk caching

On Azure VMs, the Host Caching feature manages disk write caching. To increase throughput in data disks that you use for repositories, turn off disk write caching by setting Host Caching to `None`.

#### Repository configuration

The best practice guidelines for Apache NiFi are to use a separate disk or disks for each of these repositories:

- Content
- FlowFile
- Provenance.

This approach requires a minimum of three disks.

Apache NiFi also supports application-level striping. This functionality increases the size or performance of the data repositories.

The following excerpt is from the `nifi.properties` configuration file. This configuration partitions and stripes the repositories across managed disks that are attached to the VMs:

```config
nifi.provenance.repository.directory.stripe1=/mnt/disk1/ provenance_repository
nifi.provenance.repository.directory.stripe2=/mnt/disk2/ provenance_repository
nifi.provenance.repository.directory.stripe3=/mnt/disk3/ provenance_repository
nifi.content.repository.directory.stripe1=/mnt/disk4/ content_repository
nifi.content.repository.directory.stripe2=/mnt/disk5/ content_repository
nifi.content.repository.directory.stripe3=/mnt/disk6/ content_repository
nifi.flowfile.repository.directory=/mnt/disk7/ flowfile_repository
```

For additional details about designing for high-performance storage, see [Azure premium storage: design for high performance][Azure premium storage: design for high performance].

### Reporting considerations

Apache NiFi includes a provenance reporting task for the [Azure Log Analytics][Log Analytics agent overview] service.

You can use this reporting task to offload provenance events to cost-effective, durable long-term storage. The Log Analytics service provides a [query interface][Log queries in Azure Monitor] for viewing and graphing the individual events. For more information on querying Azure Log Analytics, see add link to section.

You can also use this task in conjunction with volatile, in-memory provenance storage. In many scenarios, you can then achieve a throughput increase. But this approach is risky if you need to preserve event data. Ensure that volatile storage meets your durability requirements for provenance events. For more information, see [Provenance Repository][NiFi System Administrators Guide - Provenance Repository] in the Apache NiFi System Administrator's Guide.

Before using this process, create a log analytics workspace in your Azure subscription. It's best to set up the workspace in the same region as your workload.

To configure the provenance reporting task:

1. Open the controller settings in Apache NiFi.
1. Select the reporting tasks menu.
1. Select **Create a new reporting task**.
1. Select **Azure Log Analytics Reporting Task**.

The following screenshot shows the properties menu for this reporting task:

:::image type="content" source="media/nifi-configure-reporting-task-window.png" alt-text="Alt text here.":::

Two properties are required:

- The log analytics workspace ID
- The log analytics workspace key

You can find these values in the Azure portal by navigating to your Log Analytics workspace.

Additional options are available for customizing and filtering the provenance events that the system sends.

### Enterprise security considerations

You can secure Apache NiFi from an [authentication][NiFi System Administrators Guide - User Authentication] and [authorization][NiFi System Administrators Guide - Multi-Tenant Authorization] point of view. You can also secure Apache NiFi for all network communication including:

- Within the cluster
- Between the cluster and Apache ZooKeeper

See the [Apache NiFi Administrators Guide][NiFi System Administrators Guide] for instructions on turning on the following options:

- Kerberos
- LDAP
- Certificate-based authentication and authorization
- Two-way SSL for cluster communications

If you turn on Apache ZooKeeper secure client access, configure Apache NiFi by adding related properties to its bootstrap.conf configuration file. The following configuration entries provide an example:

```config
java.arg.18=-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
java.arg.19=-Dzookeeper.client.secure=true
java.arg.20=-Dzookeeper.ssl.keyStore.location=/path/to/keystore.jks
java.arg.21=-Dzookeeper.ssl.keyStore.password=[KEYSTORE PASSWORD]
java.arg.22=-Dzookeeper.ssl.trustStore.location=/path/to/truststore.jks
java.arg.23=-Dzookeeper.ssl.trustStore.password=[TRUSTSTORE PASSWORD]
```

For general recommendations, see the [Linux security baseline][Azure security baseline for Linux Virtual Machines].








## Pricing


## Next steps

## Related resources

[Apache NiFi]: https://nifi.apache.org/
[Apache nifi Downloads]: https://nifi.apache.org/download.html
[Apache ZooKeeper Releases]: https://zookeeper.apache.org/releases.html
[Availability Zones]: https://docs.microsoft.com/en-us/azure/availability-zones/az-overview#availability-zones
[Azure Active Directory (Azure AD)]: https://azure.microsoft.com/en-us/services/active-directory/
[Azure DevOps]: https://azure.microsoft.com/en-us/services/devops/
[Azure Key Vault]: https://docs.microsoft.com/en-us/azure/key-vault/
[Azure Monitor overview]: https://docs.microsoft.com/en-us/azure/azure-monitor/overview
[Azure premium storage: design for high performance]: https://docs.microsoft.com/en-us/azure/virtual-machines/premium-storage-performance
[Azure security baseline for Linux Virtual Machines]: https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/virtual-machines-linux-security-baseline
[Data Factory]: https://azure.microsoft.com/en-us/services/data-factory/
[Introduction to Azure managed disks]: https://docs.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview
[Log Analytics agent overview]: https://docs.microsoft.com/en-us/azure/azure-monitor/agents/log-analytics-agent
[Log Analytics tutorial]: https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-tutorial
[Log queries in Azure Monitor]: https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-query-overview
[Networking for Azure virtual machine scale sets - Accelerated Networking]: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-networking#accelerated-networking
[NiFi on GitHub]: https://github.com/apache/nifi
[NiFi System Administrators Guide]: https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html
[NiFi System Administrators Guide - Configuration Best Practices]: https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#configuration-best-practices
[NiFi System Administrators Guide - Multi-Tenant Authorization]: https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#multi-tenant-authorization
[NiFi System Administrators Guide - Provenance Repository]: https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#provenance-repository
[NiFi System Administrators Guide - State Management]: https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#state_management
[NiFi System Administrators Guide - User Authentication]: https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#user_authentication
[Sizes for virtual machines in Azure]: https://docs.microsoft.com/en-us/azure/virtual-machines/sizes
[Visio file of architecture diagram]: https://arch-center.azureedge.net/US-1875891-azure-nifi-architecture.vsdx
[What is Azure Application Gateway?]: https://docs.microsoft.com/en-us/azure/application-gateway/overview
[What are virtual machine scale sets?]: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview
