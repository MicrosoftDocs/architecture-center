---
title: SWIFT Alliance Messaging Hub (AMH) with Alliance Connect
description: Run SWIFT Alliance Messaging Hub (AMH) on Azure. This messaging solution helps financial institutions to securely and efficiently bring new services to market.
author: Mahesh-MSFT
ms.author: maksh
ms.date: 06/09/2022
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.category:
  - featured
ms.custom:
  - fcp
  - example-scenario
azureCategories:
  - integration
  - migration
summary: Run SWIFT Alliance Messaging Hub (AMH) on Azure. This messaging solution helps financial institutions to securely and efficiently bring new services to market.
products:
  - azure-virtual-machines
  - azure-virtual-network
  - azure-managed-disks
  - azure-load-balancer
  - azure-firewall
---

# SWIFT Alliance Messaging Hub (AMH) with Alliance Connect

This article outlines a solution for hosting SWIFT's Alliance Messaging Hub (AMH) on Azure.

## Architecture

:::image type="content" source="./media/azure-alliance-messaging-hub-architecture.png" alt-text="Architecture diagram that shows how to host a SWIFT Alliance Messaging Hub on Azure." border="false" lightbox="./media/azure-alliance-messaging-hub-architecture.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/amh-on-azure-srxha.pptx) of this architecture.*

### Workflow

This Azure solution uses the same topology that the on-premises environment uses. On-premises environments fall into two categories:

- On-premises site (Users): The location that business users and business applications use to access SWIFT's AMH
- On-premises site (Hardware Security Module): The location that hosts the Hardware Security Module (HSM) appliance that SWIFT provides

A business user or an application from the customer's on-premises site (Users) connects to SWIFT's AMH by using network connectivity. SWIFT's AMH processes the user request by coordinating with SWIFT's Alliance Gateway (SAG) and with SWIFTNet Link (SNL). The SAG and SNL components connect with the customer's on-premises site (HSM) to securely sign the message. SWIFT's Alliance Connect networking solution, which is deployed at an on-premises site, forwards the secure message to SWIFTNet. Azure services that run in the customer's optional shared Azure services subscription provide additional management and operational services.

SWIFT's AMH needs network connectivity with SAG and SNL.

- SAG provides multiple integration points and message concentration between SWIFT modules and SWIFTNet.
- SNL provides an API interface between SWIFT modules and SWIFTNet.

We recommend that you place the SWIFT modules, SAG, and SNL components in the same Azure virtual network. You can deploy them across separate subnets in the virtual network.

A key component in SWIFT's AMH technical solution is the *AMH node*, which runs a user interface, a database, and a messaging system. The AMH node provides the web front end that runs the user interface and the signal transfer point (STP) message processing.

- The AMH node runs on [JBoss Enterprise Application Platform (EAP) on Red Hat Enterprise Linux (RHEL)](https://techcommunity.microsoft.com/t5/azure-marketplace/announcing-red-hat-jboss-eap-on-azure-virtual-machines-and-vm/ba-p/2374068).
- The database runs on [Oracle](/azure/virtual-machines/workloads/oracle/oracle-overview).
- The messaging system typically runs on [Websphere MQ](https://azure.microsoft.com/updates/general-availability-enabling-ibm-websphere-application-server-on-azure-virtual-machines), but you can use any Java Message Service (JMS) protocol–compliant messaging solution.

The following Azure infrastructure services are also part of this solution:

- An Azure subscription is needed to deploy SWIFT's AMH. We recommend that you use a new Azure subscription to manage and scale SWIFT's AMH.

- The solution deploys SWIFT's AMH in a specific Azure region by using an Azure resource group. We recommend that you set up a single resource group for SWIFT AMH, SAG, and SNL.

- Azure Virtual Network forms a private network boundary around SWIFT's AMH deployment. The solution uses a network address space that doesn't conflict with the on-premises site (Users), the on-premises site (HSM), and SWIFT's Alliance Connect networking solution.

- The solution deploys SWIFT's AMH core components—the front-end, the database, and the messaging system—in separate Virtual Network subnets. With this setup, you can control the traffic between them by using network security groups.

- Azure route tables provide a way to:

  - Control network connectivity between SWIFT's AMH and the on-premises site (HSM).
  - Configure the connectivity to SWIFTNet.

- Azure Load Balancer acts as a gateway to SWIFT's AMH. Business users and applications from an on-premises site connect to Load Balancer, which routes requests to a pool of back-end virtual machines (VMs) that run the AMH front end.

- Outbound connectivity from SWIFT's AMH VMs to the internet is routed through Azure Firewall. Typical examples of such connectivity include time syncs and anti-virus definition updates.

- ExpressRoute or Azure VPN Gateway connects SWIFT's AMH components with the on-premises site (Users) and the on-premises site (HSM). ExpressRoute provides dedicated, reliable private network connectivity. VPN Gateway uses an internet-based connection.

- Azure Virtual Machines provides compute services for running SWIFT's AMH:

  - A compute-optimized SKU runs the AMH node.
  - A memory-optimized SKU with ample storage runs the database.
  - A compute-optimized SKU runs the messaging component.

- Premium SSD managed disks ensure SWIFT's AMH components achieve high-throughput and low-latency disk performance. Azure Disk Storage also provides backup and restore capabilities for disks that are attached to VMs.

- To reduce the network latency between SWIFT's AMH components, the solution uses Azure proximity placement groups, which place the SWIFT AMH VMs as close as possible to each other.

### Components

- [Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks.
- [Load Balancer](https://azure.microsoft.com/services/load-balancer) distributes inbound traffic to back-end pool instances. Load Balancer directs traffic according to configured load-balancing rules and health probes.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) enforces application and network connectivity policies. This network security service centrally manages the policies across multiple virtual networks and subscriptions.
- [ExpressRoute](https://azure.microsoft.com/services/expressroute) extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections to cloud components like Azure services and Microsoft 365.
- [Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is an infrastructure-as-a-service (IaaS) offering. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware.
- [Azure Disk Storage](https://azure.microsoft.com/services/storage/disks) provides high-performance, highly durable block storage. You can use these managed storage volumes with Virtual Machines.

### Alternatives

In this solution, all SWIFT AMH components run in Azure except the HSM and the Alliance Connect networking solution appliances. If you prefer to run all components in Azure, use [SWIFT's Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml) networking solution instead of Alliance Connect. You can run Alliance Connect Virtual in Azure.

## Scenario details

SWIFT's AMH is one of the key messaging solutions in the SWIFT product portfolio. AMH is customizable and meets the messaging needs of financial institutions. With AMH, financial institutions can introduce new services and products in the market quickly and efficiently. SWIFT's AMH meets security and compliance standards that financial messaging requires.

### Potential use cases

This solution is optimal for the finance industry.

The solution can benefit existing and new SWIFT customers. You can use it for the following scenarios:

- Migrating AMH from on-premises systems to Azure
- Establishing a new AMH environment in Azure

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Consider these guidelines for best performance when you run SWIFT's AMH on Azure.

### Availability

- Deploy AMH across Azure paired regions so that a regional outage doesn't affect the workload availability.
- Use Azure availability zones inside an Azure region. Solution components like Azure Virtual Machine Scale Sets and Load Balancer support availability zones. When you use availability zones, your solution is available during an outage in the Azure region.
- Use Azure Alerts to monitor the metrics and activity logs of key components such as web components, the database, and messaging components.  

### Operations

- Use Azure Monitor to monitor the solution infrastructure. Configure alerts and dashboards by using Azure Log Analytics to detect and respond to critical events.
- Use Azure Application Insights for application-level monitoring.
- Use declarative definitions in Azure Policy to enforce governance and compliance requirements.

### Performance efficiency 

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Deploy an Azure virtual machine scale set that runs web server VM instances in a proximity placement group. This approach positions VM instances near each other and reduces latency between VMs.
- Use Azure VMs with accelerated networking to achieve up to 30 Gbps of network throughput.

### Scalability

- Use Azure managed disks with premium SSD to achieve up to 20,000 IOPS and 900 Mbps of throughput.
- Configure Azure disk host caching as **ReadOnly** for high disk throughput.
- Configure the Azure autoscale feature to scale up the VM instances based on metrics such as CPU or memory usage.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Use the latest implementation of SWIFT content security policy (CSP) controls in Azure. But consult your Microsoft team first.
- Use Microsoft Defender for Cloud for protection from threats that exploit server and application vulnerabilities. Defender for Cloud helps to quickly identify threats, streamline threat investigation, and automate remediation.
- Use Azure Active Directory (Azure AD) and role-based access control (RBAC) to limit access to application components.
- Use Microsoft Sentinel to analyze security events and other events that solution components report. The deep investigations and hunting exercises of this service provide a quick response to any anomaly or potential threat.

### Resiliency

- Use Load Balancer in a zone-redundant configuration. With this setup, you can route user requests so that they aren't affected by a zone failure inside an Azure region.
- If you have a single Azure availability zone, use Oracle Active Data Guard for database reliability during zone failures.
- Identify the single points of failure in the solution and plan for remediation.

### DevOps

- For zero-touch deployment, use a continuous integration and continuous delivery (CI/CD) workflow that Azure DevOps Services offers.
- Use an Azure Resource Manager template (ARM template) to provision Azure infrastructure components.
- Use Virtual Machines extensions to configure any other solution components on top of Azure infrastructure.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

For an estimate of the cost of a SWIFT AMH deployment, see [a sample cost profile](https://azure.com/e/d2e12d232edb49db85cf330f70ffd636).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Mahesh Kshirsagar](https://uk.linkedin.com/in/mahesh-kshirsagar-msft) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Azure Firewall?](/azure/firewall/overview)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [Availability zones](/azure/availability-zones/az-overview)
- [Azure virtual machine extensions](/azure/virtual-machines/extensions/overview)

## Related resources

- [SWIFT's Alliance Connect in Azure](swift-on-azure-srx.yml)
- [SWIFT's Alliance Connect Virtual in Azure](swift-on-azure-vsrx.yml)
- [SWIFT's Alliance Access with Alliance Connect](swift-alliance-access-on-azure.yml)
- [SWIFT's Alliance Access with Alliance Connect Virtual](swift-alliance-access-vsrx-on-azure.yml)
- [SWIFT's Alliance Messaging Hub (AMH) with Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml)
- [SWIFT Alliance Cloud in Azure](swift-alliance-cloud-on-azure.yml)
- [SWIFT Alliance Lite2 on Azure](swift-alliance-lite2-on-azure.yml)
