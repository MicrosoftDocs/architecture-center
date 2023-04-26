[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for facilitating workloads that run on various types of servers and systems throughout an enterprise. The solution uses OpCon from SMA Technologies in a Kubernetes configuration in Azure. From a single automation control point, OpCon automates workflows across the enterprise—both on-premises and in Azure.

*Apache®, [Apache Hadoop](https://hadoop.apache.org), [Apache Spark](http://spark.apache.org), [Apache HBase](http://hbase.apache.org), and [Apache Storm](https://storm.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by the Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="../media/sma-opcon-azure-architecture.png" alt-text="Architecture diagram that shows an AI-enabled application running at the edge with Azure Stack Hub and hybrid connectivity." lightbox="../media/sma-opcon-azure-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/sma-opcon-azure-architecture.vsdx) of this architecture.*

### Dataflow

1. An OpCon container provides core services, which are deployed within Azure Kubernetes Service (AKS). Solution Manager is a web-based user interface that's part of OpCon core services. Users can interact with the entire OpCon environment by using Solution Manager.

   Persistent volumes store logs and configuration information. These volumes provide data persistence across container restarts. For these volumes, the solution uses Azure Files, which is configured in the `StorageClass` value.

   Network security groups limit traffic flow between subnets.

1. The solution uses an Azure SQL database as the OpCon database. The core services have secure access to this database through Azure Private Endpoint.

1. OpCon core services use OpCon connector technology to interact with Azure Storage and manage data in Blob Storage. OpCon Managed File Transfer (MFT) also provides support for Azure Storage.

1. The application subnet contains an OpCon MFT Server that provides comprehensive file-transfer functionality. Capabilities include compression, encryption, decryption, decompression, file watching, and enterprise-grade automated file routing.

   Azure virtual machines (VMs) make up the application infrastructure.
   - To manage workloads on these VMs and on-premises legacy systems, OpCon Core services communicate with OpCon agents that are installed on the VMs. The core services communicate with on-premises systems through the site-to-site connection on the virtual network gateway.
   - OpCon core services communicate directly with applications that provide REST API endpoints. These applications don't need extra software to connect to the core services. With on-premises systems, the communication goes via the virtual network gateway by using REST API connectivity options.

1. In a hybrid environment, the Gateway subnet uses a site-to-site VPN tunnel to provide a secure connection between the on-premises environment and the Azure cloud environment.

1. The gateway includes a cross-premises IPsec/IKE VPN tunnel connection between the VPN gateway and an on-premises VPN device. All data that passes between the Azure cloud and the on-premises environment is encrypted in this site-to-site private tunnel as it crosses the internet.

1. A local network gateway in the on-premises environment represents the gateway on the other end of the tunnel. The local network gateway holds configuration information that's needed to build a VPN tunnel to the other end and to route traffic from or to on-premises subnets.

1. All user requests are routed via the gateway connection to the OpCon core services environment. Users access the OpCon Solution Manager framework, a web-based user interface for:

   - OpCon administration.
   - OpCon MFT administration.
   - OpCon workflow development, execution, and monitoring.
   - Self service.
   - Vision, the OpCon task dashboard.
   - OpCon MFT Central Application, a dashboard and query application.

1. OpCon agents and application REST API endpoints are installed on legacy systems in the on-premises environment. OpCon core services use the site-to-site connection on the virtual network gateway to communicate with those agents and endpoints.

### Components

### Alternatives

The following sections describe alternatives that you can consider when you implement the solution.

#### Virtual networks and subnets

The application subnet can include the application VMs. You can also install the application servers in multiple subnets or virtual networks. Use this approach when you want to create separate environments for different types of servers, such as web and application servers.

#### Azure SQL Managed Instance

Instead of using Azure SQL, you can use Azure SQL Managed Instance as the OpCon database. You can install the SQL managed instance in the OpCon subnet. Alternatively, you can install the database in a separate subnet that you use exclusively for SQL managed instances in the existing virtual network.

#### Azure ExpressRoute

Instead of using a VPN gateway and a site-to-site VPN tunnel, you can use an ExpressRoute connection that provides a private connection to the Microsoft global network by using a connectivity provider. ExpressRoute connections don't go over the public internet.

We recommend ExpressRoute for hybrid applications that run large-scale business-critical workloads that require a high degree of scalability and resiliency.

## Scenario details

The core OpCon module that facilitates workloads is the Schedule Activity Monitor (SAM). This module communicates with agents on target systems to schedule and monitor tasks. SAM also receives external events. You can install OpCon agents on the following platforms:

- Windows
- Linux or Unix
- Unisys ClearPath Forward mainframes (MCP and 2200)
- IBM z/OS
- IBM AIX

SAM draws the various platforms under one automation umbrella.

You can install OpCon in an Azure cloud environment. OpCon supports cloud-only infrastructures and also hybrid infrastructures that contain cloud and on-premises systems.

The OpCon software is available from Docker Hub as Docker images that you can deploy in a cloud environment. For the Azure cloud, this solution uses Azure Kubernetes Service to deploy the OpCon environment within a Kubernetes cluster. Azure SQL Server is used as the database. 

For hybrid environments, a VPN Gateway provides a secure link between cloud infrastructure and on-premises infrastructure. 

The implementation uses a single virtual network and multiple subnets to support various functions. You can use network security groups to filter network traffic between Azure resources in the virtual network.

### AKS Kubernetes information

The deployed OpCon environment consists of two pods within a single replica set and an Azure-SQL database. A load balancer controls access to the pods. The load balancer maps external addresses and ports to internal REST API server addresses and ports.

The following diagram shows configuration requirements for an environment where the two pods are named OpCon and Impex2. The diagram also shows the relationship between various definitions in the Kubernetes configuration YAML file.

:::image type="content" source="../media/sma-opcon-azure-kubernetes-configuration.png" alt-text="Architecture diagram that shows Kubernetes configuration values that the solution uses." lightbox="../media/sma-opcon-azure-kubernetes-configuration.png" border="false":::

The following table provides detailed information about each definition.

| Kind | Value | Description |
| --- | --- | --- |
| `Secret` | dbpasswords | Contains the database passwords that are required to connect to the OpCon database. |
| `ConfigMap` | opcon | Contains the OpCon REST API information, the time zone, the language information, and the OpCon database information, such as the address, the database name, and the database user. |
| `ConfigMap` | impex | Contains the ImpEx2 Rest-API information and the OpCon database information, such as the address, the database name, and the database user. |
| `PersistentVolumeClaim` | opconconfig | Contains the various .ini files as well as the OpCon license file. |
| `PersistentVolumeClaim` | opconlog | Contains the log files that are associated with the OpCon environment. |
| `PersistentVolumeClaim` | impexlog | Contains the log files that are associated with the ImpEx2 environment. |
| `ReplicaSet` | opcon | Specifies the OpCon and ImpEx2 container definitions that reference the previously defined `Secret`, `ConfigMap`, and `PersistentVolumeClaim` definitions. |
| `Service` | loadbalancer | Defines the mapping of the internal REST API ports for the OpCon and Impex2 REST servers to external addresses and ports. |



### Potential use cases



## Next steps



## Related resources


