> [!NOTE]
> For general updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This article provides an overview of deploying SWIFT Alliance Access on Azure. Alliance Access is one of the messaging interfaces that SWIFT offers for enhanced-security financial messaging. You can deploy the solution in a single Azure subscription. For better management and governance of the solution, however, we recommend that you use two Azure subscriptions: 
- One subscription contains the SWIFT Alliance Access components.
- The other subscription contains the resources to connect to SWIFT's network via Alliance Connect Virtual.

## Architecture

[![Diagram of the architecture for SWIFT Alliance Access.](media/alliance-access-with-alliance-connect-virtual.png)](media/alliance-access-with-alliance-connect-virtual.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/diagrams-swift-alliance-access-with-alliance-connect-virtual-in-azure.vsdx) that contains this architecture diagram.*

The Alliance Access subscription contains resources that you manage. To create the core infrastructure of Alliance Access resources shown in the diagram, you can use an Azure Resource Manager template (ARM template). Alliance Access deployments on Azure should follow the guidance in SWIFT's Customer Security Programme (CSP) - Customer Security Control Framework (CSCF). We recommend that you use SWIFT CSP-CSCF Azure policies in this subscription.

The Alliance Connect Virtual subscription contains the components that are required to enable connectivity with SWIFTNet. The deployment of the respective vSRX components depicted in the above architecture diagram enables high availability by deploying the redundant resources in two different Azure Availability Zones. Additionally, the HA- VM 1 & HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improves the availability of the overall solution.