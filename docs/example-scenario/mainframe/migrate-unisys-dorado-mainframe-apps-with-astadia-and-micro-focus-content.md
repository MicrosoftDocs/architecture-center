[from Theano's article]: Unisys ClearPath mainframe systems are full-featured operating environments that can scale up vertically to handle mission critical workloads. ClearPath mainframe models include Dorado, running Legacy Sperry 1100/2200, and Libra, running Legacy Burroughs A Series/MCP. Emulating, converting, or modernizing these systems into Azure can provide similar or better performance and SLA guarantees, while taking advantage of Azure flexibility, reliability, and future capabilities.

The Unisys Dorado Mainframe system comprises of several key components which provide the power and ability to scale up vertically to handle mission critical workloads.  Nevertheless, these components can be either be emulated or modernized into Azure and obtain very similar or even improved performance and SLA guarantees.
This architecture illustrates an example utilizing emulation technologies from two Microsoft Partners, Astadia and Micro Focus.  This approach allows an accelerated move into Azure without rewriting all the application code and redesigning the data architecture from Network-based to Relational-based.  Further, if desired, the application screens and interactions can be virtually unchanged, minimizing the need for end user retraining.

## Potential use cases

The Astadia and Micro Focus pattern supports several options to move client workloads to Azure:

- Original source code, such as COBOL, on a Unisys Dorado mainframe system cannot be modified due to compliance factors, prohibitive costs, complexity, or other considerations.
- As a bridge to re-engineering workload modernization, this pattern can provide a “lift-and-shift” of the application layer source code, while providing modern PaaS services and capabilities such as Azure SQL Database with built-in high availability and Azure Data Factory for automated, server-less file routing and transformations.

## Architecture

:::image type="complex" source="./media/migrate-unisys-dorado-mainframe-apps-architecture-diagram.png" alt-text="Architecture diagram showing how to use Logic Apps to respond to A P I calls by updating or accessing S Q L Server." border="false":::
   The diagram contains two boxes, one for Azure components, and one for on-premises components. Outside the Azure box is a data file labeled J S O N. An arrow points from the J S O N file into an A P I Management icon that's inside the Azure box. A second arrow points from the A P I Management icon to a Logic Apps icon that's also inside the Azure box. A third arrow points from the Logic Apps icon to an on-premises data gateway icon that's between the two boxes. A fourth arrow points from the gateway to a SQL Server icon that's inside the on-premises box. A final arrow points from the SQL Server icon to a person outside the on-premises box.
:::image-end:::

1. Transport Layer Security (TLS) connections that use port 443 provide access to web-based applications:

   - After migration, the web application presentation layer remains virtually unchanged. As a result, end users require minimal retraining. Alternatively, you can update the web application presentation layer to align with UX requirements.
   - Azure VM Bastion hosts work to maximize security. When giving administrators access to VMs, these hosts minimize the number of open ports.

1. The solution uses two sets of two VMs:

   - Within each set, one VM runs the web layer, and one runs the application emulation layer.
   - One set of VMs is the primary, active set. The other set is the secondary, passive set.
   - Azure Load Balancer manages approaching traffic. When the active VM set fails, the passive set comes online. The load balancer then routes traffic to that newly activated set.

1. Astadia OpenTS simulates Unisys mainframe screens. This component runs presentation layer code in Internet Information Services (IIS) and uses ASP.NET. OpenTS can either run on its own VM or on the same VM as other Astadia emulation products.

1. OpenMCS is a program from Astadia that emulates:

   - The Unisys Dorado Mainframe Transactional Interface Package (TIP).
   - Other services that Unisys mainframe COBOL programs use.

1. Micro Focus COBOL runs COBOL programs on the Windows server. There's no need to rewrite COBOL code. Micro Focus COBOL can invoke Unisys mainframe facilities through the Astadia emulation components.

1. Astadia OpenDMS emulates the Unisys Dorado mainframe DMS database access technology. With this component, you can *lift and shift* tables and data from relational-based RDMS and network-based DMS databases into Azure SQL Database.

1. Azure Storage Account File Share is mounted on the Windows server VM. COBOL programs then have easy access to the Azure files repository for file processing.

1. With either the Hyperscale or Business Critical service tier, Azure SQL Database provides:

   - High input/output operations per second (IOPS).
   - High uptime SLA.

   Private Link for Azure SQL Database provides a private, direct connection from VMs to Azure SQL Database through the Azure network backbone.

1. Azure Data Factory version 2 (V2) provides data movement pipelines that events trigger. These pipelines move files from external sources into Azure File Storage. Emulated COBOL programs then process the files.

1. Azure Site Recovery provides disaster recovery capabilities. This service mirrors the VMs to a secondary Azure region for quick failover in the rare case of an Azure datacenter failure.





This diagram shows the components that Unisys Sperry OS 1100/2200 mainframe systems typically contain.

:::image type="complex" source="./media/migrate-unisys-dorado-mainframe-apps-original-architecture.png" alt-text="Architecture diagram showing how to use Logic Apps to respond to A P I calls by updating or accessing S Q L Server." border="false":::
   The diagram contains two boxes, one for Azure components, and one for on-premises components. Outside the Azure box is a data file labeled J S O N. An arrow points from the J S O N file into an A P I Management icon that's inside the Azure box. A second arrow points from the A P I Management icon to a Logic Apps icon that's also inside the Azure box. A third arrow points from the Logic Apps icon to an on-premises data gateway icon that's between the two boxes. A fourth arrow points from the gateway to a SQL Server icon that's inside the on-premises box. A final arrow points from the SQL Server icon to a person outside the on-premises box.
:::image-end:::

- On-premises users interact with the mainframe (**A**):

  - Admin users interact through a UTS terminal emulator.
  - Web interface users interact via a web browser over TLS 1.3 port 443.

  Mainframes use communication standards like IPv4, IPv6, SSL/TLS, Telnet, FTP, and sockets. In Azure, web browsers replace legacy terminal emulation. On-demand and online users access system resources through these web browsers.

- Mainframe applications are in COBOL, Fortran, C, MASM, SSG, PASCAL, UCOBOL, and ECL (**B**). In Azure, Micro Focus COBOL recompiles COBOL and other legacy application code to .NET. Micro Focus can also maintain and reprocess original base code whenever that code changes. This architecture doesn't require any changes in the original source code.

- Mainframe batch and transaction loads run on application servers (**C**). For transactions, these servers use Transaction Interface Packages (TIPs) or High Volume TIPs (HVTIPs). In the new architecture:

  - Server topologies handle batch and transaction workloads.
  - An Azure load balancer routes traffic to the server sets.
  - Azure Site Recovery can provide High Availability (HA) and Disaster Recovery (DR) capabilities.

- A dedicated server handles workload automation, scheduling, reporting, and system monitoring (**D**). These functions retain the same platforms in Azure.

- A printer subsystem manages on-premises printers.

- Database management systems (**E**) follow the eXtended Architecture (XA) specification. Mainframes use relational database systems like RDMS and network-based database systems like DMS II and DMS. The new architecture migrates legacy database structures to Azure SQL Database, which provides DR and HA capabilities.

F.)	File structures (CIFS, flat files, virtual tape, etc.) map easily to Azure data constructs within structured files and/or blob storage.  Azure Data Factory can be utilized to provide a modern PaaS data transformation service and fully integrate with this architecture pattern.




### Components

This architecture uses the following components:



### Alternatives

A few alternatives exist for this solution:



## Considerations


### Availability considerations


### Scalability considerations



### Security considerations


## Pricing

The following table provides cost profiles for three implementations of this architecture:

The profiles include the following components:

To adjust the parameters and explore the cost of running this solution in your environment, use the [Azure pricing calculator][Azure pricing calculator].

## Next steps

[see some in original doc]

## Related resources
