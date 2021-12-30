SWIFT Alliance Messaging Hub (AMH) can be hosted on Azure, and is one of the key messaging solutions in SWIFT's product portfolio. It's customizable and meets the messaging needs of financial institutions. With SWIFT AMH, financial institutions can introduce new services and products in the market quickly and efficiently. SWIFT AMH meets security and compliance requirements around financial messaging.

Using this article, customers can start with highly available and disaster resistant deployments of SWIFT AMH on Azure.

## Architecture

The diagram below shows high-level architecture for SWIFT – AMH.

[![AMH Expanded Architecture](./media/AMHonAzure_SRXHA.png) ](./media/AMHonAzure_SRXHA.png#lightbox)

*Download a [PowerPoint file](https://arch-center.azureedge.net/AMHonAzure_SRXHA.pptx) that contains this architecture diagram.*

Azure architecture is built using the same topology that runs in an on-premise environment. Next, we'll discuss a typical user journey.

Business users or the application from the customer's on-premises site (users) connect to SWIFT AMH using network connectivity. SWIFT AMH will process the user request by coordinating with SWIFT SAG/SNL components. SWIFT SAG/SNL components will connect with the customer's on-premises site (HSM) to securely sign the message. SWIFT SRX deployed at on-premises site will forward the secure message to SWIFTNet. Additional management and operational services will be provided by Azure services running in the customer's Shared Azure Services (optional) subscription.

SWIFT AMH needs network connectivity with two other SWIFT components listed here:

1. SWIFT Alliance Gateway (SAG)
1. SWIFTNet Link (SNL)

SWIFT Alliance Gateway (SAG) provides multiple integration points and message concentration between SWIFT modules and SWIFTNet. SWIFTNet Link (SNL) provides API interface between SWIFT modules and SWIFTNet. It's recommended to have SWIFT modules, SAG, and SNL components in the same Azure Virtual Network. They can be deployed across separate subnets in VNet. SAG and SNL should be deployed in a separate Azure Resource Group.

Key SWIFT AMH technical solution components consist of *AMH node* running user interface, a database, and a messaging system. *AMH node* provides the web front-end running the user interface and the STP messaging processing. *AMH node* runs on [JBoss Enterprise Application Platform (EAP) on Red Hat Enterprise Linux (RHEL)](https://techcommunity.microsoft.com/t5/azure-marketplace/announcing-red-hat-jboss-eap-on-azure-virtual-machines-and-vm/ba-p/2374068).  The database runs on [Oracle](/azure/virtual-machines/workloads/oracle/oracle-overview). The messaging system typically runs on [Websphere MQ](https://azure.microsoft.com/updates/general-availability-enabling-ibm-websphere-application-server-on-azure-virtual-machines), but it can also be any JMS protocol-compliant messaging solution. Azure infrastructure services running these software components are discussed in detail below:

* **Azure Subscription**: An Azure Subscription is needed to deploy SWIFT AMH. It's recommended to use a new Azure Subscription to manage and scale SWIFT AMH.

* **Azure Resource Group**: Customers can deploy SWIFT AMH in a specific Azure Region using Azure Resource Group. It's recommended to have SWIFT AMH, SWIFT SAG, and SWIFT SNL in their own separate resource groups.

* **Azure Virtual Network**: An Azure Virtual Network forms a private network boundary around SWIFT AMH deployment. Customers should choose a network address space that doesn't conflict with the customer's on-premises site (users), customer's on-premises site (HSM), and SWIFT SRX networks.

* **Azure Virtual Network Subnet**: SWIFT AMH Core components (front-end, database, and messaging) should be deployed in separate subnets. This allows traffic control between them via Azure Virtual Network Subnet Network Security Groups.

* **Azure Route Table**: Network connectivity between SWIFT AMH and customer's on-premises site (HSM) can be controlled via Azure Route Table. Similarly, connectivity to SWIFTNet is also configured using Azure Route Table.

* **Azure Load Balancer**: It acts as a gateway to SWIFT AMH. Business users and applications from an on-premises site can connect to Azure Load Balancer, which then routes requests to a pool of back-end virtual machines (VMs) running AMH front-end.

* **Azure Firewall**: Any outbound connectivity from SWIFT AMH VMs to the internet should be routed via Azure Firewall. Typical examples of such connectivity are time syncs, anti-virus definition updates, and more.

* **Azure Expressroute** / **Azure VPN**: SWIFT AMH components can be connected with the customer's on-premises site (users) and the customer's on-premises site (HSM) using Azure Expressroute / Azure VPN. Customers requiring dedicated and private network connectivity can opt for Azure Expressroute based connectivity. Azure VPN will use internet-based connection.

* **Azure Virtual Machine** : Azure Virtual Machine provides compute services for running SWIFT AMH. Consider using the following guideline to choose the right SKU.

    1. Compute optimized SKU for running *AMH node*.
    2. Memory optimized with larger storage SKU for running the database.
    3. Compute optimized SKU for running messaging component.

* **Azure Managed Disk**: Premium SSD managed disks ensure SWIFT AMH components get high throughput and low latency disk performance. They also provide the ability to back up and restore disks attached to VMs.

* **Azure Proximity Placement Group**: To reduce the network latency between SWIFT AMH components, customers should consider using Azure Proximity Groups, which ensures all SWIFT AMH VMs will be placed as close as possible to each other.

### Alternatives

Proposed Azure architecture shows all SWIFT AMH solution components running in Azure. However, it's possible to run some solution components in Azure and some from an on-premises site. These solution components can connect with each other through a network connectivity set up between Azure and on-premises site.

## Considerations

The following guidance helps improve the architecture quality for SWIFT AMH on Azure.

### Availability

1. Consider deploying AMH across Azure paired regions so that a regional outage doesn’t affect the workload availability.
2. Consider using Azure availability zones inside an Azure region. Solution components (like Virtual Machine Scale Sets and Load Balancer) support Availability Zones. Using Availability Zones enables solution to be available even during an outage in an Azure region.
3. Consider using Azure Alerts for monitoring metrics and activity logs for key solution components (web, database and, messaging).  

### Operations

1. Consider using Azure Monitor for monitoring solution infrastructure. Configure alerts and dashboards using Azure Log Analytics to detect and respond to critical events.
2. Consider using Azure Application Insights for application level monitoring.
3. Consider using Azure Policy for enforcing governance and compliance requirements using declarative definitions.  

### Performance

1. Consider deploying Azure virtual machine scale set running Web server VM instances in a Proximity Placement Group, which colocates VM instances and reduced inter-VM latency.
2. Consider using Azure VMs with Accelerated Networking for up to 30 Gbps of network throughput.

### Scalability

1. Consider using Azure Managed Disks with premium SSD for getting up to 20,000 IOPS and 900 MB/s of throughput.
2. Consider configuring Azure Disk host caching as ReadOnly for higher disk throughput.
3. Consider configuring Azure Autoscale to scale up the VM instances based on the metrics such as CPU or memory usage.

### Security

1. Customers can use Azure Policy for assessing the solution against [SWIFT CSP-CSCF](/azure/governance/blueprints/samples/swift-2020) standard.
2. Consider using Azure Security Center for protection from server and application vulnerabilities. Azure Security Center helps to quickly identify threats, streamline threat investigation, and automate remediation.
3. Consider using Azure Active Directory (AD) for using Azure AD Role-Based Access Control (RBAC) to limit access to application components.
4. Consider using Azure Sentinel for analyzing security and other events reported by solution components. Deep investigations and hunting exercises will enable a quick response to any anomaly or potential threat.

### Resiliency

1. Consider using Azure Load Balancer configured in zone-redundant configuration to route user requests to sustain a zone failure inside Azure region.
2. Consider using Oracle Active Data Guard for database reliability if there's a single Azure Availability Zone failure.
3. Consider identifying single point of failure in the solution and plan for remediation.

### DevOps

1. Consider using Azure DevOps Services based continuous integration and continuous delivery (CI/CD) workflow for zero-touch deployment experience.
1. Consider using Azure Resource Manager (ARM) script to provision Azure infrastructure components.
1. Consider using Azure Virtual Machine (VM) Extensions to configure any other solution component on top of Azure infrastructure.

## Pricing

For SWIFT AMH deployment, calculated your estimated costs [here](https://azure.com/e/d2e12d232edb49db85cf330f70ffd636).

## Next steps

Explore other SWIFT modules functionality and architecture in detail in the following links.

* [SWIFT on Azure](swift-on-azure.yml)
* [Alliance Access](swift-alliance-access-on-azure.yml)
