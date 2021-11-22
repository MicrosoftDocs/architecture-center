This architecture is from a global manufacturing company. Their Operational technology and Information Technology departments are highly integrated demanding a single internal network. However, these environments have drastically different security and performance requirements. Due to the sensitive nature of their operations they require all traffic to be firewall protects and have an IDPS solution in place. Their Information Technology department has less demanding security requirements for the network but would like to performance optimize so users have low latency access to their IT applications. 

They turned to Azure VWAN to meet their global needs for a single network with varying security and performance requirements to get an easy to manage, deploy and scale solution so that as they add regions they can continue to grow seamlessly with a highly optimized network for their needs. 

## Potential use cases
Typical uses for this architecture include cases in which:
- A global organization requiring centralized file solution for a business critical work
- High performing files workloads requiring localized cached files
- A flexible remote workforce for users both in and out of the office

## Architecture 

![alt text and fix path](./media/performance-security-optimized-vwan-arhictecture-main.png)

The architecture consists of:
- **Express Route** ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection with the help of a connectivity provider.
- **Virtual WAN Service** Azure Virtual WAN is a networking service that brings many networking, security, and routing functionalities together to provide a single operational interface.
- **Virtual WAN Hub** A virtual hub is a Microsoft-managed virtual network. The hub contains various service endpoints to enable connectivity.
- **Hub Vnet Connections** The Hub virtual network connection resource is used to connect the hub seamlessly to your virtual networks
- **Connection Static Routes** static routes provides a mechanism to steer traffic through a next hop IP
- **Hub Route Tables**You can create a virtual hub route and apply the route to the virtual hub route table . 
- **Virtual Network Peering** Virtual network peering enables you to seamlessly connect two or more [Virtual Networks]() in Azure.
- **Virtual Networks** Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. 
- **User Defined Routes** routes in Azure to override Azure's default system routes, or to add additional routes to a subnet's route table.

This customer has multiple regions and continues to deploy regions to this model and only deploys a Security Optimized or Performance Optimized Environment as needed. The Environments route the following traffic through the NVA

### Traffic pathways
| |||         |        | Destinations|      |        |           |
|--|--|--|--|--|--|--|--|--|
| ||**Vnet1**        |**Vnet2**   |**Vnet3**   |**Vnet4**   |**Branch**   |**Internet**   |
|**Security Optimized Source**|**Vnet 1**|Intra Vnet|NVA1-Vnet2 |NVA1-hub-Vnet3|NVA1-hub-Vnet4|NVA1-hub-branch|NVA1-internet|
**Performance Optimized Source**|	**Vnet 3**|	hub-NVA1-vnet1	|hub-NVA1-vnet2|Intra Vnet|	NVA2-vnet4	|hub-branch|	NVA2-internet|
**Branch Source**	|**Branch**|	hub-NVA1-vnet1|	hub-NVA1-vnet2|	hub-Vnet3	|hub-Vnet4|	N/A	|N/A|

![image](performance-security-optimized-vwan-azure.png)

As you can see above the customer has provisioned and NVA and routing architecture that forces all traffic pathways in the security optimized environment to use the NVA between the VNETs and the hub in a common layered architecture. 

In the Performance optimized environment they have a more customized routing schema which provides a firewall and traffic inspection where it is needed, and no firewall where it is not needed. While Vnet to Vnet traffic in the Performance Optimized space is forced through NVA2, Branch to Vnet traffic is able to go directly across the hub, likewise, anything headed to the secure environment does not need to go to NVA Vnet 2 because we know it will be inspected at the edge of the secure environment by the NVA in NVA Vnet1. The result is high speed access to the branch! It is also notable that this still provides Vnet to vnet inspection in the performance optimized environment. This is not necessary for all customers but can be accomplished through the peerings seen in the architecture. 

### Associations and propagations of the VWAN hub
Routes for the VNET Hub should be configured as follows:

|Name|	Associated to	|Propagating to|
|--|-|-|
|NVAVnet1	|defaultRouteTable|	defaultRouteTable|
|NVAVnet2	|PerfOptimizedRouteTable|	defaultRouteTable|
|Vnet3	|PerfOptimizedRouteTable	|defaultRouteTable|
|Vnet4	|PerfOptimizedRouteTable	|defaultRouteTable|

### Routing requirements  
1. Custom Route on the default Route Table in the vWan Hub to route all traffic for Vnet1 and Vnet2 to the secOptConnection

   |  Route Name	|Destination Type|	Destination Prefix	|Next Hop|	Next Hop IP|
   |-|-|-|-|-|
   |Security Optimized Route|	CIDR|	10.1.0.0/16	|secOptConnection|	\<ip address NVA1>|

1. A Static Route on the secOptConnection forwarding the traffic for Vnet1 and Vnet2 to the ip of NVA1

   |Name|	Address prefix|	Next hop type|	Next hop IP address|
   |-|-|-|-|
   |rt-to-secOptimized	|10.1.0.0/16	|Virtual Appliance|	\<ip address NVA1>|

1. A Custom Route Table on the vWAN Hub named “perfOptimizedRouteTable”. This is used to ensure that the perf optimized vnets cannot speak to one another over the hub and must use the peering to NVAVnet2
1. A UDR associated to all subnets in vnets 1 and 2 to route all traffic back to NVA1

   |Name|	Address prefix|	Next hop type|	Next hop IP address|
   |-|-|-|-|
   rt-all	|0.0.0.0/0|	Virtual Appliance|	\<ip address NVA1>|
1. A UDR associated to all subnets in vnets 3 and 4 to route vnet-vnet traffic and internet traffic to NVA2

   Name	|Address prefix|	Next hop type|	Next hop IP address
   |-|-|-|-|
   rt-to-internet	|0.0.0.0/0	|Virtual Appliance	|\<ip address NVA2>
   vnet-to-vnet	|10.2.0.0/16	|Virtual Appliance	|\<ip address NVA2>

*** NVA ip addresses can be replaced with load balancer ip addresses in the routing if the user is deploying a high availability architecture with multiple NVA’s behind the load balancer

### Components
- [Azure Virtual WAN](https://docs.microsoft.com/azure/virtual-wan/virtual-wan-about):  networking service that brings many networking, security, and routing functionalities together to provide a single operational interface. In this case it is used to simplify and scale routing to the attached virtual networks and branches
- [User Defined Routes](https://docs.microsoft.com/azure/virtual-network/virtual-networks-udr-overview#user-defined): are static routes that routes in Azure to override Azure's default system routes. In this case they are used to force traffic to the NVA’s when necessary
- [Network Virtual Appliances](https://azure.microsoft.com/solutions/network-appliances): NVA’s are marketplace offered network appliances. In this case the customer deployed Palo Alto’s but any NVA Firewall would fit this model. 

### Alternatives
In order to deploy only a high security NVA environment this model can be followed [Scenario: Route traffic through a Network Virtual Appliance (NVA) - Azure Virtual WAN | Microsoft Docs](/azure/virtual-wan/scenario-route-through-nva)

In order to deploy a custom NVA model that supports Routing traffic to a dedicated firewall for internet AND routing branch traffic over an NVA please see here: [Route traffic through NVAs by using custom settings - Azure Virtual WAN | Microsoft Docs](/azure/virtual-wan/scenario-route-through-nvas-custom) 

While the above show the capability to deploy a high security environment behind an NVA and some capability to deploy a custom environment it deviates from our use case in two ways. The first is that it shows these models in isolation instead of in combination. The second is that it does not support vnet to vnet traffic in the “Custom” or what we call the *Performance Optimized Environment*

## Considerations 
When deploying this environment it becomes clear that what we have effectively accomplished in the performance optimized environment is that all routes across the VWAN Hub to that environment do not pass through the NVA enmeshed in that environment. This presents an issue with cross regional traffic that is illustrated below. 

[image]performance-security-optimized-vwan-architecture-regions.png

Traffic across regions between performance optimized environments in this design does not cross the NVA. This is a limitation of directly routing hub traffic to the Vnets. 

### Availability
Virtual WAN is a highly available networking service provided by Azure. Additional connectivity or paths from the branch can be set up for multiple pathways to the VWAN service but nothing additional is needed within the VWAN service. 

NVA’s should be set up in a highly available architecture similar to what is seen here: [Deploy highly available NVAs](../../reference-architectures/dmz/nva-ha.yml)
### Performance
This solution is designed to optimize performance of the network where necessary. It is possible to tweak the routing per the customer requirements enabling the traffic to the branch to cross the NVA and the traffic between Vnets to flow freely or to use a single firewall for internet egress if necessary.
### Scalability
This architecture is scalable across regions. Consideration will need to be taken with routing labels to group routes and branch traffic forwarding between the vhubs per customer requirements. 
### Security
NVAs provide the ability to enable features such as IDPS with Virtual WAN!
### Resiliency
Consider the commentary in the availability section to cover environment resiliency in this case
## Pricing
Pricing for this environment is heavily dependent on the NVA’s deployed. A pricing estimate for a 2Gbps ER connection and a VWAN hub processing 10TB per month can be found [here](https://azure.com/e/0bf78de2bf3b45aa961e0dc2f57eb2fe)

## Next steps
[How to configure virtual hub routing - Azure Virtual WAN](/azure/virtual-wan/how-to-virtual-hub-routing)

