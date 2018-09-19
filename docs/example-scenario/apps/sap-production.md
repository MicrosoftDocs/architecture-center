---
title: SAP production workloads on Azure virtual machines using an Oracle database
description: An example scenario showing an SAP production deployment in Azure using an Oracle database. 
author: AndrewDibbins, DharmeshBhagat
ms.date: 9/12/2018
---

# SAP production workloads on Azure virtual machines using an Oracle database

SAP systems are used to run mission-critical business applications. Any outage disrupts key processes and can cause increased expenses or lost revenue. Avoiding these outcomes requires an SAP infrastructure that is highly available and resilient when failures occur.

Building a highly available SAP environment requires eliminating single points of failures in your system architecture and processes. Single points of failure can be caused by site failures, errors in system components, or even human error.

This example scenario demonstrates an SAP deployment on Windows or Linux virtual machines (VMs) on Azure, along with an Oracle database with High Availability (HA). Oracle databases are supported for running SAP workloads. You can can use multiple VMs of different sizes based on your requirements. 

## Related use cases

Consider this example for the following scenarios:

* Mission-critical workloads running on SAP
* Non-critical SAP workloads 
* Test environments for SAP that simulate a high-availability environment.

## Architecture

![Architecture overview of a production SAP environment in Azure][architecture]

This example includes a high availability configuration for an Oracle database, SAP central services, and multiple SAP application servers running on different virtual machines. The Azure network uses a [hub-and-spoke topology][/azure/architecture/reference-architectures/hybrid-networking/hub-spoke] for security purposes. The data flows through the solution as follows:

1. Users access the SAP system via the SAP user interface, a web browser, or other client tools like Microsoft Excel. An ExpressRoute connection provides access from the organization's physical location to resources running in Azure. 
2. The ExpressRoute terminates in Azure at the ExpressRoute virtual network (VNet) gateway. Network traffic is routed through the ExpressRoute gateway to a gateway subnet created in the hub VNet.
3. The hub VNet is peered to a spoke VNet. The application tier subnet hosts the virtual machines running SAP in an availability set.
4. The identity management servers provide authentication services for the solution.
5. The jump box is used by system administrators to securely manage resources deployed in Azure.

### Components

* [Virtual Networks](/azure/virtual-network/virtual-networks-overview) are used in this scenario to create a virtual hub-and-spoke topology in Azure.
* [Virtual Machines](/azure/virtual-machines/windows/overview) provide the compute resources for each tier of the solution. Each cluster of virtual machines is configured as an [availability set](/azure/virtual-machines/windows/regions-and-availability#availability-sets).
* [Express Route](/azure/expressroute/expressroute-introduction) extends your on-premises network into the Microsoft cloud through a private connection established by a connectivity provider.
* [Network Security Groups (NSG)](/azure/virtual-network/security-overview) limit network access to the resources in a virtual network. An NSG contains a list of security rules that allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. 
* [Resource Groups](/azure/azure-resource-manager/resource-group-overview#resource-groups) act as logical containers for Azure resources.

### Alternatives

SAP provides flexible options for different combinations of operating system, database management system, and VM types in an Azure environment. For more information, see [SAP note 1928533](https://launchpad.support.sap.com/#/notes/1928533), "SAP Applications on Azure: Supported Products and Azure VM Types".

## Considerations

Recommended practices are defined for building highly available SAP environments in Azure. For more information, see [High-availability architecture and scenarios for SAP NetWeaver](/azure/virtual-machines/workloads/sap/sap-high-availability-architecture-scenarios).
For additional information, see [High availability of SAP applications on Azure VMs](/azure/virtual-machines/workloads/sap/high-availability-guide).
* Oracle databases also have recommended practices for Azure. For more information, see [Designing and implementing an Oracle database in Azure](/azure/virtual-machines/workloads/oracle/oracle-design). 
*Oracle Data Guard is used to eliminate single points of failure for mission critical Oracle databases. For more information, see [Implementing Oracle Data Guard on a Linux virtual machine in Azure](/azure/virtual-machines/workloads/oracle/configure-oracle-dataguard).

Microsoft Azure offers infrastructure services that can be used to deploy SAP products with an Oracle database. For more information, see [Deploying an Oracle DBMS on Azure for an SAP workload](/azure/virtual-machines/workloads/sap/dbms_guide_oracle).

## Pricing

To help you explore the cost of running this scenario, all of the services are pre-configured in the cost calculator examples below. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided four sample cost profiles based on amount of traffic you expect to receive:

|Size|SAPs|DB VM Type|DB Storage|(A)SCS VM|(A)SCS Storage|App VM Type|App Storage|Azure Pricing Calculator|
|----|----|-------|-------|-----|---|---|--------|---------------|
|Small|30000|DS13_v2|4xP20, 1xP20|DS11_v2|1x P10|DS13_v2|1x P10|[Small](https://azure.com/e/45880ba0bfdf47d497851a7cf2650c7c)|
|Medium|70000|DS14_v2|6xP20, 1xP20|DS11_v2|1x P10|4x DS13_v2|1x P10|[Medium](https://azure.com/e/9a523f79591347ca9a48c3aaa1406f8a)|
Large|180000|E32s_v3|5xP30, 1xP20|DS11_v2|1x P10|6x DS14_v2|1x P10|[Large](https://azure.com/e/f70fccf571e948c4b37d4fecc07cbf42)|
Extra Large|250000|M64s|6xP30, 1xP30|DS11_v2|1x P10|10x DS14_v2|1x P10|[Extra Large](https://azure.com/e/58c636922cf94faf9650f583ff35e97b)|

Note: pricing is a guide and only indicates the VMs and storage costs. It excludes networking, backup storage, and data ingress/egress charges.

* [Small](https://azure.com/e/45880ba0bfdf47d497851a7cf2650c7c): A small system consists of VM type DS13_v2 for the db server with 8x vCPUs, 56GB RAM and 112GB temp storage, additionally five 512GB premium storage disks. An SAP Central Instance servers using a DS11_v2 VM types with 2x vCPUs 14GB RAM and 28GB temp storage. A single VM type DS13_v2 for the SAP application server with 8x vCPUs, 56GB RAM and 400GB temp storage, additionally one 128GB premium storage disk.

* [Medium](https://azure.com/e/9a523f79591347ca9a48c3aaa1406f8a): A medium system consists of VM type DS14_v2 for the db server with 16x vCPUs, 112GB RAM and 800GB temp storage, additionally seven 512GB premium storage disks. An SAP Central Instance server using a DS11_v2 VM types with 2x vCPUs 14GB RAM and 28GB temp storage. Four VM type DS13_v2 for the SAP application server with 8x vCPUs, 56GB RAM and 400GB temp storage, additionally one 128GB premium storage disk.

* [Large](https://azure.com/e/f70fccf571e948c4b37d4fecc07cbf42): A large system consists of VM type E32s_v3 for the db server with 32x vCPUs, 256GB RAM and 800GB temp storage, additionally three 512GB and one 128GB premium storage disks. An SAP Central Instance server using a DS11_v2 VM types with 2x vCPUs 14GB RAM and 28GB temp storage. Six VM type DS14_v2 for the SAP application servers with 16x vCPUs, 112GB RAM and 224GB temp storage, additionally six 128GB premium storage disk.

* [Extra Large](https://azure.com/e/58c636922cf94faf9650f583ff35e97b): An extra large system consists of a VM type M64s for the db server with 64x vCPUs, 1024GB RAM and 2000GB temp storage, additionally seven 1024GB premium storage disks. An SAP Central Instance server using a DS11_v2 VM types with 2x vCPUs 14GB RAM and 28GB temp storage. Ten VM type DS14_v2 for the SAP application servers with 16x vCPUs, 112GB RAM and 224GB temp storage, additionally ten 128GB premium storage disk.

## Deployment

Click here to deploy the underlying infrastructure for this scenario.

<a
href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsolution-architectures%2Fmaster%2Fapps%2Fsap-3tier-distributed-ora%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

Note: SAP and Oracle are not installed during this deployment. You will need to deploy these components separately.

## Related resources

For other SAP production use cases running in Azure, review the following SAP reference architectures:
* [SAP NetWeaver for AnyDB](/azure/architecture/reference-architectures/sap/sap-netweaver) 
* [SAP S/4Hana](/azure/architecture/reference-architectures/sap/sap-s4hana)
* [SAP on Azure large instances](/azure/architecture/reference-architectures/sap/hana-large-instances)

<!-- links -->
[architecture]: media/architecture-diagram-sap-production.png
