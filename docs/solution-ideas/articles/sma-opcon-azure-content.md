[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article presents a solution for automating workloads that run on various types of servers and systems throughout an enterprise. The solution uses OpCon from SMA Technologies in a Kubernetes configuration in Azure. From a single automation control point, OpCon facilitates workflows across the enterprise—both on-premises and in Azure.

## Architecture

:::image type="content" source="../media/sma-opcon-azure-architecture.png" alt-text="Architecture diagram that shows how to deploy OpCon in Azure or a hybrid environment. Besides OpCon, components include SQL Database and VPN Gateway." lightbox="../media/sma-opcon-azure-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/sma-opcon-azure-architecture.vsdx) of this architecture.*

### Workflow

1. An OpCon container provides core services, which are deployed within Azure Kubernetes Service (AKS). These core services include Solution Manager, a web-based user interface. Users can interact with the entire OpCon environment by using Solution Manager. The environment includes:

   - Persistent volumes that store logs and configuration information and provide data persistence across container restarts. For these volumes, the solution uses Azure Files, which is configured in the `StorageClass` value.
   - The OpCon database.
   - Virtual machines (VMs) that run workloads.

1. The solution uses Azure SQL Database as the OpCon database. The core services have secure access to this database through an Azure Private Link private endpoint.

1. OpCon core services use OpCon connector technology to interact with Azure Storage and manage data in Azure Blob Storage. OpCon Managed File Transfer (MFT) also provides support for Storage.

1. The application subnet contains an OpCon MFT server that provides comprehensive file-transfer functionality. Capabilities include compression, encryption, decryption, decompression, file watching, and enterprise-grade automated file routing.

1. Azure VMs make up the application infrastructure. The placement of these VMs in subnets and virtual networks is flexible. For more information, see [Component placement](#component-placement).
   - To manage workloads on these VMs and on-premises legacy systems, OpCon core services communicate with OpCon agents that are installed on the VMs. The core services communicate with on-premises systems through a site-to-site connection on a virtual network gateway.
   - OpCon core services communicate directly with applications that provide REST API endpoints. These applications don't need extra software to connect to the core services. With on-premises systems, the communication goes via a virtual network gateway by using REST API connectivity options.

1. In a hybrid environment, the Gateway subnet uses a site-to-site VPN tunnel to provide a secure connection between the on-premises environment and the Azure cloud environment.

1. The gateway includes a cross-premises IPsec/IKE VPN tunnel connection between Azure VPN Gateway and an on-premises VPN device. All data that passes between the Azure cloud and the on-premises environment is encrypted in this site-to-site private tunnel as it crosses the internet.

1. A local network gateway in the on-premises environment represents the gateway on the on-premises end of the tunnel. The local network gateway holds configuration information that's needed to build a VPN tunnel and to route traffic from or to on-premises subnets.

1. All user requests are routed via the gateway connection to the OpCon core services environment. Through that access, users interact with Solution Manager for:

   - OpCon administration.
   - OpCon MFT administration.
   - OpCon workflow development, execution, and monitoring.
   - Self Service, an OpCon interface for running tasks.
   - Vision, the OpCon task dashboard.
   - OpCon MFT Central Application, a dashboard and query application.

1. OpCon agents and application REST API endpoints are installed on legacy systems in the on-premises environment. OpCon core services use the site-to-site connection on the virtual network gateway to communicate with those agents and endpoints.

Throughout the solution, network security groups can limit traffic flow between subnets.

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) is one of several types of on-demand, scalable computing resources that Azure offers. An Azure VM gives you the flexibility of virtualization but eliminates the maintenance demands of physical hardware. With Azure VMs, you have a choice of operating system that includes both Windows and Linux.

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for your private network in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network that operates in a datacenter. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of the Azure infrastructure.

- [Private Link](https://azure.microsoft.com/products/private-link) provides a private endpoint in a virtual network. You can use the private endpoint to connect to Azure platform as a service (PaaS) services like Storage and SQL Database or to customer or partner services.

- [Storage](https://azure.microsoft.com/products/category/storage) offers highly available, scalable, secure cloud storage for data, applications, and workloads.

- [Azure Files](https://azure.microsoft.com/products/storage/files) is a service that's part of Storage. Azure Files offers fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. You can mount these file shares concurrently by cloud or on-premises deployments. Windows, Linux, and macOS clients can access these file shares.

- [Blob Storage](https://azure.microsoft.com/products/storage/blobs) is a service that's part of Storage. Blob Storage offers optimized cloud object storage for large amounts of unstructured data. This service is a good fit for high-performance computing, machine learning, and cloud-native workloads.

- [VPN Gateway](https://azure.microsoft.com/products/vpn-gateway) is a specific type of virtual network gateway. You can use VPN Gateway to transmit encrypted traffic. That traffic can flow between an Azure virtual network and an on-premises location over the public internet. It can also flow between Azure virtual networks over the Azure backbone network.

- [Azure ExpressRoute](https://azure.microsoft.com/products/expressrout) extends your on-premises networks into the Microsoft cloud over a private connection that's facilitated by a connectivity provider. With ExpressRoute, you can establish connections to cloud services, such as Microsoft Azure and Microsoft 365.

- [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery) helps ensure business continuity by keeping business apps and workloads running during outages. Site Recovery can replicate workloads that run on physical machines and VMs from a primary site to a secondary location. When an outage occurs at your primary site, you fail over to a secondary location and access apps from there. After the primary location is running again, you can fail back to it.

- [Azure SQL](https://azure.microsoft.com/services/azure-sql) is a family of Azure databases that are powered by the SQL Server engine. Azure SQL is composed of SQL Server on Azure Virtual Machines, Azure SQL Managed Instance, and SQL Database.

- [SQL Database](https://azure.microsoft.com/services/sql-database) is a fully managed PaaS database engine with AI-powered, automated features. The OpCon backend can use SQL Database to manage OpCon entries.

- [SQL Managed Instance](https://azure.microsoft.com/services/azure-sql/sql-managed-instance) is an intelligent, scalable, cloud database service that combines the broadest SQL Server engine compatibility with all the benefits of a fully managed and evergreen PaaS. The OpCon backend can use SQL Managed Instance to manage OpCon entries.

- [OpCon](https://smatechnologies.com/opcon-cloud) core services run in a Linux container within a Kubernetes replica set. This solution uses SQL Database for the OpCon database.

- [OpCon Self Service](https://smatechnologies.com/products-self-service) is a web-based implementation that provides a way for users to run on-demand tasks and optionally enter arguments within an OpCon environment.

- [OpCon Vision](https://smatechnologies.com/products-opcon-vision) provides a dashboard for monitoring OpCon tasks. The dashboard displays a logical representation of the tasks across all flows. Vision uses tags to group tasks, with associated tasks in a group. When problems occur, you can drill down from the dashboard to failed tasks. Vision also provides a way to set SLA values for each group. The dashboard gives early warning when defined SLA values won't be met.

- [OpCon MFT](https://smatechnologies.com/opcon-managed-file-transfer) provides MFT services within an OpCon environment. The OpCon MFT solution provides file transfer and monitoring functionality across an enterprise by using an integrated MFT agent and a file transfer server.

### Alternatives

The following sections describe alternatives to consider when you implement the solution.

#### Component placement

The placement of the VMs and OpCon database is flexible.

- The application subnet can include the application VMs. You can also install the application servers in multiple subnets or virtual networks. Use this approach when you want to create separate environments for different types of servers, such as web and application servers.
- You can place the database inside or outside the OpCon subnet.

#### SQL Managed Instance

Instead of using SQL Database, you can use SQL Managed Instance as the OpCon database. You can install the SQL managed instance in the OpCon subnet. Alternatively, you can install the managed instance in a separate subnet that you use exclusively for SQL managed instances in the existing virtual network.

#### ExpressRoute

Instead of using VPN Gateway and a site-to-site VPN tunnel, you can use ExpressRoute, which uses a connectivity provider to establish a private connection to the Microsoft global network. ExpressRoute connections don't go over the public internet.

We recommend ExpressRoute for hybrid applications that run large-scale business-critical workloads that require a high degree of scalability and resiliency.

## Scenario details

The core OpCon module that facilitates workloads is the Schedule Activity Monitor (SAM). This module communicates with agents on target systems to schedule and monitor tasks. SAM also receives external events. You can install OpCon agents on the following platforms:

- Windows
- Linux or Unix
- Unisys ClearPath Forward mainframes (MCP and 2200)
- IBM z/OS
- IBM AIX

SAM draws the various platforms together under one automation umbrella.

You can install OpCon in an Azure cloud environment. OpCon supports cloud-only infrastructures and also hybrid infrastructures that contain cloud and on-premises systems.

The OpCon software is available from Docker Hub as Docker images that you can deploy in a cloud environment. For the Azure cloud, this solution uses AKS to deploy the OpCon environment within a Kubernetes cluster. SQL Database is used as the database.

For hybrid environments, VPN Gateway provides a secure link between cloud infrastructure and on-premises infrastructure.

The implementation uses a single virtual network and multiple subnets to support various functions. You can use network security groups to filter network traffic between Azure resources in the virtual network.

### AKS information

The deployed OpCon environment consists of two pods within a single replica set and an instance of SQL Database. A load balancer controls access to the pods. The load balancer maps external addresses and ports to internal REST API server addresses and ports.

The following diagram shows configuration requirements for an environment with two pods, OpCon and Impex2. The diagram also shows the relationship between various definitions in the Kubernetes configuration YAML file.

:::image type="content" source="../media/sma-opcon-azure-kubernetes-service-configuration.png" alt-text="Architecture diagram that shows Kubernetes configuration values that the solution uses." lightbox="../media/sma-opcon-azure-kubernetes-configuration.png" border="false":::

The following table provides detailed information about each definition.

| Kind | Value | Description |
| --- | --- | --- |
| `Secret` | dbpasswords | Contains the database passwords that are required to connect to the OpCon database. |
| `ConfigMap` | opcon | Contains the OpCon REST API information, the time zone, and the language information. Also contains OpCon database information, such as the address, the database name, and the database user. |
| `ConfigMap` | impex | Contains the Impex2 REST API information. Also contains OpCon database information, such as the address, the database name, and the database user. |
| `PersistentVolumeClaim` | opconconfig | Contains various .ini files and the OpCon license file. |
| `PersistentVolumeClaim` | opconlog | Contains the log files that are associated with the OpCon environment. |
| `PersistentVolumeClaim` | impexlog | Contains the log files that are associated with the Impex2 environment. |
| `ReplicaSet` | opcon | Specifies the OpCon and Impex2 container definitions that reference the previously defined `Secret`, `ConfigMap`, and `PersistentVolumeClaim` definitions. |
| `Service` | loadbalancer | Defines the mapping of the internal REST API ports for the OpCon and Impex2 REST servers to external addresses and ports. |

### Potential use cases

Many scenarios can benefit from this solution:

- Workload automation and orchestration across an entire IT enterprise
- Disaster recovery automation
- Cross-platform file transfers
- IT environment operations
- Batch scheduling
- Running self-service automation workflows
- Automation and deployment of server updates
- Automation and deployment of patch management
- Automation of the provisioning and decommissioning of Azure resources
- Monitoring an entire IT environment from a single interface
- Codifying repeatable or ad hoc processes

## Deploy this scenario

You can use the following template to deploy the OpCon environment within an AKS cluster.

```yml
# 
# Full OpCon deployment for Kubernetes
#
# This deployment uses Azure SQL Database.
#
apiVersion: v1
kind: Secret
metadata:
  name: dbpasswords
stringData:
  saPassword: ""
  dbPassword: ""
  sqlAdminPassword: ""
  dbPasswordEncrypted: ""
 
---
# OpCon environment values
apiVersion: v1
kind: ConfigMap
metadata:
  name: opconenv
data:
  DB_SERVER_NAME: "sqlopcon.database.windows.net"
  DATABASE_NAME: "opcon"
  DB_USER_NAME: "opconadmin"
  SQL_ADMIN_USER: "opconadmin"
  API_USES_TLS: "true" 
  CREATE_API_CERTIFICATE: "true"
  DB_SETUP: "true"
  TZ: "America/Chicago"
  LANG: "en_US.utf-8"
  LICENSE: ""
---
# Impex environment values
apiVersion: v1
kind: ConfigMap
metadata:
  name: impexenv
data:
  opcon.server.name: "sqlopcon.database.windows.net"
  opcon.db.name: "opcon"
  opcon.db.user: "opconadmin"
  web.port: "9011"
  web.ssl: "true" 
  system.debug: "false"
  TZ: "America/Chicago"
  LANG: "en_US.utf-8"
---
# OpCon persistent storage for configuration information
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: opconconfig
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
---
# OpCon persistent storage for log information
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: opconlog
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
---
# Impex persistent storage for log information
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: impexlog
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
---
# OpCon and deploy pods in a single replica set
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: opcon
spec:
  replicas: 1
  selector:
    matchExpressions:
      - key: app
        operator: In
        values:
          - opconservices
  template:
    metadata:
      labels:
        app: opconservices
    spec:
      containers:
      - env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: dbpasswords
              key: dbPassword
        - name: SQL_ADMIN_PASSWORD
          valueFrom:
            secretKeyRef:
              name: dbpasswords
              key: sqlAdminPassword
        envFrom:
          - configMapRef:
              name: opconenv
        image: smatechnologies/opcon-server:22.0-latest
        name: opcon
        ports:
        - containerPort: 443
          protocol: TCP
        volumeMounts:
        - name: opconconfig
          mountPath: /app/config
        - name: uat-opconlog
          mountPath: /app/log
      - env:
        - name: opcon.db.password
          valueFrom:
            secretKeyRef:
              name: dbpasswords
              key: dbPasswordEncrypted
        envFrom:
          - configMapRef:
              name: impexenv
        image: smatechnologies/deploy-impex2:22.0-latest
        name: impex
        volumeMounts:
        - name: impexlog
          mountPath: /app/log
      hostname: opcon
      volumes:
      - name: opconconfig
        persistentVolumeClaim:
          claimName: opconconfig
      - name: opconlog
        persistentVolumeClaim:
          claimName: opconlog
      - name: impexlog
        persistentVolumeClaim:
          claimName: impexlog
---
# OpCon service
apiVersion: v1
kind: Service
metadata:
  name: lbopcon
spec:
  type: LoadBalancer
  ports:
  - name: apiport
    port: 9010
    targetPort: 443
  - name: impexport
    port: 9011
    targetPort: 9011
  selector:
    app: opconservices
```

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Philip Brooks](https://www.linkedin.com/in/philipbbrooks) | Senior Program Manager
- [Bertie van Hinsbergen](https://www.linkedin.com/in/gys-bertie-van-hinsbergen-7802204) | Principal Automation Consultant

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about solution components, see the following resources:

- [Virtual machines in Azure](/azure/virtual-machines/overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Azure Private Link?](/azure/private-link/private-link-overview)
- [What is a private endpoint?](/azure/private-link/private-endpoint-overview)
- [What is Azure Kubernetes Service?](/azure/aks/intro-kubernetes)
- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Azure SQL?](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview?view=azuresql)
- [What is Azure SQL Managed Instance?](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql)
- [What is Azure VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Network security groups](/azure/virtual-network/network-security-groups-overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [About Site Recovery](/azure/site-recovery/site-recovery-overview)
- [Quickstart: Set up disaster recovery to a secondary Azure region for an Azure VM](/azure/site-recovery/azure-to-azure-quickstart)

For more information about this solution:

- Contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- Contact [SMA](https://smatechnologies.com/contact-us). A Microsoft Gold-level partner, [SMA Technologies](https://smatechnologies.com) is a leader in the IT automation space. SMA is dedicated to the single purpose of giving time back to clients and their employees by automating processes, applications, and workflows.

## Related resources

- [Unisys ClearPath Forward MCP mainframe rehost to Azure using Unisys virtualization](../../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml)
- [Azure Automation in a hybrid environment](../../hybrid/azure-automation-hybrid.yml)
- [Manage hybrid Azure workloads using Windows Admin Center](../../hybrid/hybrid-server-os-mgmt.yml)
