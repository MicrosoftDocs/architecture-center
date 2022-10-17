This architecture illustrates an OMS implementation of a Sterling OMS environment in Azure. It doesn't go into detail on how to install OMS. To learn more about the installation process, see [Installing Sterling Order Management Software](https://www.ibm.com/docs/en/order-management-sw/10.0?topic=installing-sterling-order-management-software).

## Architecture

:::image type="content" alt-text="Architecture diagram that shows the components and services that support deployment of IBM Order Management on Azure." source="./media/deploy-ibm-order-management-architecture.svg" lightbox="./media/deploy-ibm-order-management-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/deploy-ibm-order-management.vsdx) of this architecture.*

The workload can be deployed internally or externally facing, depending on your requirements.

### Workflow

From the perspective of infrastructure, this architecture will solve for these requirements in the following ways:

- Azure RedHat OpenShift: 
- Azure Postgres Flexible Server:
- IBM MQ running in Azure Kubernetes Service, or
- Private Endpoints for all relative services to isolate and secure network traffic 
- Additional, optional Azure Virtual Machines for both management and development purposes
- Azure Premium Files and standard files for storage

### Components

- [Azure RedHat OpenShift](https://learn.microsoft.com/en-us/azure/openshift/) Azure Red Hat OpenShift provides highly available, fully managed OpenShift clusters on demand, monitored and operated jointly by Microsoft and Red Hat.

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) to host the OpenShift platform and run the Maximo containers. Virtual Machines is an infrastructure-as-a-service (IaaS) offering. You can use Virtual Machines to deploy on-demand, scalable computing resources.

- [Virtual Network](https://azure.microsoft.com/services/virtual-network) for communication between nodes, Azure services, and hybrid connectivity needs.  Virtual Network is the fundamental building block for private networks in Azure.

- [Azure Files](https://azure.microsoft.com/services/storage/files) hosting the stateful data for the databases and systems inside the cluster. Azure Files provides fully managed file shares in the cloud that are accessible via the SMB and NFS protocols.

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) (optional) and a subnet to securely access any of the worker nodes or optional JumpBox machines. Azure Bastion is a fully managed service that provides secure and seamless RDP and SSH access to VMs without any exposure through public IP addresses.

- [Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/overview) Azure Database for PostgreSQL Flexible Server is a fully managed PostgreSQL database as a service offering that can handle mission-critical workloads with predictable performance and dynamic scalability.

- [Azure Kubernetes Service - IBM MQ](https://learn.microsoft.com/en-us/azure/aks/) Azure Kubernetes Service makes an ideal place to run your IBM MQ workload by offering a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure, and provides seamless integration with Azure Premium Files as a storage class for your MQ disk workloads, while providing built-in high-avaibility for your nodes.

- [Linux virtual machines in Azure](https://azure.microsoft.com/services/virtual-machines/linux) to provide a jump box for management of your OMS Azure-based resources and services. Note : If you have network connectivity into your Azure environment, you can perform the installation from an existing machine instead.

- [Azure Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) A Log Analytics workspace is a unique environment for log data from Azure Monitor and other Azure services and be used to develop monitoring dashboards and alerts for the health and performance of your resources.

### Alternatives

The following services typically aren't necessary, but they're effective alternatives:

- [IBM DB2 on Azure](https://azure.microsoft.com/en-us/solutions/oracle) if you prefer that to Azure Postgres SQL Flexible Server.
- [Azure NetApp Files](https://azure.microsoft.com/en-us/services/netapp) NetApp Files supports of any type of workload with high availability and high performance and is ideal for IO sensitive workloads, such as IBM DB2 on Azure Virtual Machines.
- [Oracle Database on Azure](https://azure.microsoft.com/en-us/solutions/oracle) if you prefer that to Azure Postgres SQL Flexible Server.
- [Azure Load Balancers](https://azure.microsoft.com/services/load-balancer) 