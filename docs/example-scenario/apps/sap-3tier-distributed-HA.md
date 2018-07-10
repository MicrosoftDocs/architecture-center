<!---
title: <SAP on Azure in a 4-Tier Architecture with HA>
description: <Article Description>
author: Andrew-Dibbins, Dharmesh-Bhagat
ms.date: <publish or update date>
--->

# SAP Deployment in a 3-Tier Architecture with High Availability on Azure

This architectural design shows a set of proven practices for running SAP NetWeaver in a Windows or Linux environment on Azure. The database is AnyDB, the SAP term for any supported DBMS and SAP HANA. This architecture is deployed with specific virtual machine (VM) sizes that can be changed to accommodate your organization's needs.

## Potential use cases

You should consider this solution for the following use cases:

* Critical SAP productive workloads

## Architecture diagram

The solution diagram below is an example of this solution:

![Diagram](media/SAP-Infra-3TierDistributedHA_finalversion.png)

## Architecture

This solution covers the provision of a dual SAP system databases in a highly available configuration, multiple SAP Central services in a highly available configuration and multiple SAP application Servers each on a virtual machine, the data flows through the solution as follows:

1. Customers from the Presentation Tier use their SAP gui, or other user interfaces (Internet Explorer, Excel or other web application) on premise to access the Azure based SAP system.
2. Connectivity is provided through the use of the established Express Route. The Express Route is terminated in Azure at the Express Route Gateway. Network traffic routes through the Express Route gateway to the Gateway Subnet and from the gateway subnet to the Application Tier Spoke subnet and via a Network Security Gateway to the SAP application virtual machine.
3. The identity management servers provide authentication services to the solution.
4. The Jump Box provides local management capabilities to the solution.

### Components

* [Resource Groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groups) is a logical container for Azure resources.
* [Virtual Networks](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) is the basis of network communications within Azure
* [Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview) Azure Virtual Machines provides on-demand, high-scale, secure, virtualized infrastructure using Windows or Linux Server
* [Express Route](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-introduction) lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider.
* [Network Security Group](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview) lets you limit network traffic to resources in a virtual network. A network security group contains a list of security rules that allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. 


#### Supported SAP Configurations
* SAP Business Suite 6.x (SAP Netweaver Application 7.x)
* SAP Business All-in-One
* SAP Business One
* SAP Netweaver Application Server 7.x (ABAP & JAVA)
* SAP BPC Netweaver
* SAP TREX 7.0
* SAP LiveCache, SAP Content Server 6.50
* SAP Business Objects
#### Supported Database Systems
* SQL Server (Windows only)
* SAP ASE (Windows, SUSE and RHEL only)
* SAP MaxDB (Windows, SUSE and RHEL only)
* IBM DB2/UDB (Windows, SUSE and RHEL only)
* Oracle Database (Windows and OEL only)
* SAP HANA (SUSE and RHEL)
#### Supported Operating Systems
*  MS Windows 2008 R2 or greater
* SUSE Enterprise Linux Server for SAP (based on SLES 12)
* RedHat Enterprise Linux (based on RHEL 7)
* Oracle Enterprise Linux (Oracle DB only)

<!--
### Alternatives

* List of alternative options and why you might use them.
--->

### Availability
For multiple Instance Virtual Machines across Availability Zones using premium storage for all Operating System Disks and Data Disks, we guarantee you will have Virtual Machine Connectivity of at least 99.99%.

For multiple Instance Virtual Machines across Availability Sets using premium storage for all Operating System Disks and Data Disks, we guarantee you will have Virtual Machine Connectivity of at least 99.95%.

For more information on Microsoft Azure Service Level Agreement for Virtual Machines [SLA For Virtual Machines](https://azure.microsoft.com/en-us/support/legal/sla/virtual-machines/v1_8/)

### Scalability

For increased scalablity either consider large VM sizes or the addition of further SAP application server VMs in the SAP application tier.

### Security

For a deeper discussion on [Azure Security](https://azure.microsoft.com/en-us/services/security-center/) please see the relevant article in the architecure center.

<!---
### Resiliency
-->

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic. 

We have provided four sample cost profiles based on amount of traffic you expect to get:

|Size|SAPs|DB VM Type|DB Storage|(A)SCS VM|(A)SCS Storage|App VM Type|App Storage|Azure Pricing Calculator|
|----|----|-------|-------|-----|---|---|--------|---------------|
|Small|30000|2x DS13_v2|4xP20, 1xP20|2x DS11_v2|1x P10|DS13_v2|1x P10|[Small](https://azure.com/e/7674e0ab4eb34dde855caf61e51d3337)|
|Medium|70000|2x DS14_v2|6xP20, 1xP20|2x DS11_v2|1x P10|4x DS13_v2|1x P10|[Medium](https://azure.com/e/8b14bcae8a7b46ad92684ccc1d41b454)|
Large|180000|2x E32s_v3|5xP30, 1xP20|2x DS11_v2|1x P10|6x DS14_v2|1x P10|[Large](https://azure.com/e/c3debccdc1b7481085fa28115059d446)|
Extra Large|250000|2x M64s|6xP30, 1xP30|2x DS11_v2|1x P10|10x DS14_v2|1x P10|[Extra Large](https://azure.com/e/ec6b516a8dd04b52b5aef53960bbd33f)|


* [Small](https://azure.com/e/7674e0ab4eb34dde855caf61e51d3337) : A small system consists of two VM type DS13_v2 for the db servers with 8x vCPUs, 56GB RAM and 112GB temp storage, additionally five 512GB premium storage disks. Two SAP Central Instance servers using two DS11_v2 VM types with 2x vCPUs 14GB RAM and 28GB temp storage. VM type DS13_v2 for the SAP application server with 8x vCPUs, 56GB RAM and 400GB temp storage, additionally one 128GB premium storage disk.


* [Medium](https://azure.com/e/8b14bcae8a7b46ad92684ccc1d41b454): A medium system consists of two VM type DS14_v2 for the db server with 16x vCPUs, 112GB RAM and 800GB temp storage, additionally seven 512GB premium storage disks. Two SAP Central Instance servers using two DS11_v2 VM types with 2x vCPUs 14GB RAM and 28GB temp storage. Four VM type DS13_v2 for the SAP application servers with 8x vCPUs, 56GB RAM and 400GB temp storage, additionally one 128GB premium storage disk.

* [Large](https://azure.com/e/c3debccdc1b7481085fa28115059d446): A large system consists of two VM type E32s_v3 for the db server with 32x vCPUs, 256GB RAM and 800GB temp storage, additionally three 512GB and one 128GB premium storage disks.Two SAP Central Instance servers using two DS11_v2 VM types with 2x vCPUs 14GB RAM and 28GB temp storage. Six VM type DS14_v2 for the SAP application servers with 16x vCPUs, 112GB RAM and 224GB temp storage, additionally six 128GB premium storage disk.

* [Extra Large](https://azure.com/e/ec6b516a8dd04b52b5aef53960bbd33f): An extra large system consists of two VM type M64s for the db server with 64x vCPUs, 1024GB RAM and 2000GB temp storage, additionally seven 1024GB premium storage disks. Two SAP Central Instance servers using two DS11_v2 VM types with 2x vCPUs 14GB RAM and 28GB temp storage. Ten VM type DS14_v2 for the SAP application servers with 16x vCPUs, 112GB RAM and 224GB temp storage, additionally ten 128GB premium storage disk.

## Deployment Example
To deploy a sample solution similar to the solution above, please use the deploy button 

<a
href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fgithub.com%2FAzure%2Ffta-wip%2Fblob%2Fmaster%2FSAP%2Ftemplates%2Fsap-3tier-distributed%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

## Alternative deployment examples
For further deployment examples, please refer to the many github samples templates. [Github QuickStart Templates] https://github.com/Azure/azure-quickstart-templates


## Related Resources

Other resources that are relevant that aren't linked from else where in the doc.

[reference architecture]  https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/sap

[resiliency] https://docs.microsoft.com/en-us/azure/architecture/resiliency/

[security] https://www.microsoft.com/en-us/trustcenter/security/azure-security

[scalability] https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability