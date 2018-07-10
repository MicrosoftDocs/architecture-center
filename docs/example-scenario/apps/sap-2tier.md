<!---
title: <SAP on Azure in a 2-Tier Architecture>
description: <Article Description>
author: Andrew-Dibbins, Dharmesh-Bhagat
ms.date: <publish or update date>
--->

# SAP Deployment in a 2-Tier Architecture on Azure

This architectural design shows a set of proven practices for running SAP NetWeaver in a Windows or Linux environment on Azure. The database is AnyDB, the SAP term for any supported DBMS and SAP HANA. This architecture is deployed with specific virtual machine (VM) sizes that can be changed to accommodate your organization's needs.

## Potential use cases

You should consider this solution for the following use cases:

* Non-Critical SAP non-productive workloads (Sandbox, Development, Test, Quality Assurance)
* Non-critical SAP Business One workloads

## Architecture diagram

The solution diagram below is an example of this solution:

![Diagram](media/SAP-Infra-2Tier_finalversion.png)

## Architecture

This solution covers the provision of a single SAP system database and SAP application Server on a single virtual machine, the data flows through the solution as follows:

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
* MS Windows 2008 R2 or greater
* SUSE Enterprise Linux Server for SAP (based on SLES 12)
* RedHat Enterprise Linux (based on RHEL 7)
* Oracle Enterprise Linux (Oracle DB only)

Please refer to to [SAP note 1928533](https://launchpad.support.sap.com/#/notes/1928533)

<!---
### Alternatives

* List of alternative options and why you might use them.
---->

### Availability
For any Single Instance Virtual Machine using premium storage for all Operating System Disks and Data Disks, we guarantee you will have Virtual Machine Connectivity of at least 99.9%.

For more information on Microsoft Azure Service Level Agreement for Virtual Machines [SLA For Virtual Machines](https://azure.microsoft.com/en-us/support/legal/sla/virtual-machines/v1_8/)

### Scalability

For greater scalability please consider deploying your SAP infrastructure based on a 3-tier distributed architecture.[SAP 3-Tier Solution](sap-3tier-distributed)

### Security

For a deeper discussion on [Azure Security](https://azure.microsoft.com/en-us/services/security-center/) please see the relevant article in the architecure center.

### Resiliency

For greater resilience please consider deploying your SAP infrastructure based on a 3-tier distributed High Availability. [SAP 3-Tier High Availability Solution](sap-3tier-distributed-HA.md)

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided four sample cost profiles based on amount of traffic you expect to get:

|Size|SAPs|VM Type|Storage|Azure Pricing Calculator|
|----|----|-------|-------|---------------|
|Small|8000|D8s_v3|2xP20, 1xP10|[Small](https://azure.com/e/9d26b9612da9466bb7a800eab56e71d1)|
|Medium|16000|D16s_v3|3xP20, 1xP10|[Medium](https://azure.com/e/465bd07047d148baab032b2f461550cd)|
Large|32000|E32s_v3|3xP20, 1xP10|[Large](https://azure.com/e/ada2e849d68b41c3839cc976000c6931)|
Extra Large|64000|M64s|4xP20, 1xP10|[Extra Large](https://azure.com/e/975fb58a965c4fbbb54c5c9179c61cef)|

Note: * pricing is a guide, indicates only the VMs and storage costs (excludes, networking, backup storage and data ingress/egress charges)

* [Small](https://azure.com/e/9d26b9612da9466bb7a800eab56e71d1): A small system consists of VM type D8s_v3 with 8x vCPUs, 32GB RAM and 200GB temp storage, additionally two 512GB and one 128GB premium storage disks.
* [Medium](https://azure.com/e/465bd07047d148baab032b2f461550cd): A medium system consists of VM type D16s_v3 with 16x vCPUs, 64GB RAM and 400GB temp storage, additionally three 512GB and one 128GB premium storage disks.
* [Large](https://azure.com/e/ada2e849d68b41c3839cc976000c6931): A large system consists of VM type E32s_v3 with 32x vCPUs, 256GB RAM and 512GB temp storage, additionally three 512GB and one 128GB premium storage disks.
* [Extra Large](https://azure.com/e/975fb58a965c4fbbb54c5c9179c61cef): An extra large system consists of a VM type M64s with 64x vCPUs, 1024GB RAM and 2000GB temp storage, additionally four 512GB and one 128GB premium storage disks.

## Deployment Example
To deploy a sample solution similar to the solution above, please use the deploy button

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fgithub.com%2FAzure%2Ffta-wip%2Fblob%2Fmaster%2FSAP%2Ftemplates%2Fsap-2tier%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


## Alternative deployment examples
For further deployment examples, please refer to many the github samples templates. [Github QuickStart Templates] https://github.com/Azure/azure-quickstart-templates

## Related Resources

Other resources that are relevant that aren't linked from else where in the doc.

[reference architecture]  https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/sap

[resiliency] https://docs.microsoft.com/en-us/azure/architecture/resiliency/

[security] https://www.microsoft.com/en-us/trustcenter/security/azure-security

[scalability] https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability