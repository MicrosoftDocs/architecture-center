This reference architecture shows a set of proven practices how to securely enable inbound and outbound Internet connections to your SAP on Azure landscape

## Architecture

This reference architecture describes a common production environment. The configuration described and shown can also be reduced in size and scope, depending on business requirements. A reduction applies to both SAP landscape - fewer VMs, no high-availability, embedded SAP Web Dispatchers instead of discrete VMs - as well as on alternatives on network side, described later in this document.

Particularly in the network space different customer requirements, driven by business or company policy, will require adaptation of the architecture. Where possible alternatives have been listed below and many solutions are viable. Chose the right approach for your business while securing your Azure resources yet providing a good solution to your user base.

[![Reference architecture for Internet facing communication for SAP on Azure](./images/sap-internet-inbound-outbound-visio.png)](./images/sap-internet-inbound-outbound-visio.png#lightbox)
*Figure - Reference architecture for Internet facing communication for SAP on Azure.*

_Download a [Visio file](https://arch-center.azureedge.net/sap-internet-communication-architecture.vsdx) of this architecture, containing all drawings shown here._

### Components

Introducing the components used in the architecture.

**Subscriptions** Following the Azure [landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) concept, own Azure subscriptions are used. One subscription for central IT services containing the network hub and central, shared services such as firewalls or Active Directory. Further subscription(s) are used for individual workloads, in this architecture the SAP production workload. Utilize the [decision guide](/azure/cloud-adoption-framework/decision-guides/subscriptions/) in the Azure Cloud Adoption Framework to decide on the optimal subscription strategy for your company.

**Virtual networks (vnet)** The [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) service connects Azure resources to each other with enhanced security. In this architecture, the virtual network connects to an on-premises environment via an ExpressRoute or virtual private network (VPN) gateway deployed in the hub of a [hub-spoke topology](../../reference-architectures/hybrid-networking/hub-spoke.yml). SAP production landscape uses own spoke virtual networks. Two distinct spoke virtual networks used for different purposes, with several subnets for network segregation.

Separating into subnets by workload allows easier enablement of network security groups (NSG) to set security rules applicable to application VMs or Azure service deployed therein.

**Zone-redundant gateway** A gateway connects distinct networks, extending your on-premises network to the Azure virtual network. We recommend that you use [ExpressRoute](../../reference-architectures/hybrid-networking/expressroute.yml) to create private connections that don't go over the public internet. You can also use a [site-to-site](../../reference-architectures/hybrid-networking/expressroute.yml) connection. Azure ExpressRoute or VPN gateways can be deployed across zones to guard against zone failures. See [Zone-redundant virtual network gateways](/azure/vpn-gateway/about-zone-redundant-vnet-gateways) to understand the differences between a zonal deployment and a zone-redundant deployment.  The IP addresses used need to be of Standard SKU for a zone deployment of the gateways.

**Network security groups (NSG)**  To restrict incoming and outgoing network traffic of the virtual network, create [network security groups](/azure/virtual-network/tutorial-filter-network-traffic-cli) which are in turn assigned to specific subnets. Individual subnets are secured with workload specific NSGs.

**Application security groups (ASG)** To define fine-grained network security policies inside your NSGs based on workloads that are centered on applications, use [application security groups](/azure/virtual-network/security-overview) instead of explicit IP addresses. They let you group VMs by purpose, for example SAP SID, and help you secure applications by filtering traffic from trusted segments of your network.

**Private Endpoint** Many Azure services operate as public services, by design accessible through the Internet. In order to allow private access via customer's private network range, some services can use private endpoints. [Private endpoints](/azure/private-link/private-endpoint-overview) are a network interface in the your virtual network, bringing the service effectively into your private network space. 

**Application Gateway** Azure [Application Gateway](/azure/application-gateway/overview) (AppGw) is a web traffic load balancer. Together with its web application firewall functionality, it is the ideal service to expose web applications to the Internet, securely. Application Gateway can service both or either public (Internet) or private clients, depending on configuration. In the architecture AppGw with a public IP address, allows inbound connections to the SAP landscape over https. Its backend pool are two or more SAP Web Dispatcher VMs, access round-robin providing high-availability. Client authentication is performed by the SAP application layer.

**NAT Gateway** Azure virtual network [NAT gateway](/azure/virtual-network/nat-gateway/nat-overview) is a service providing static public IP(s) for outbound connectivity. Configured on a subnet, all outbound communications use the NAT Gateway's IP(s) for Internet access. Inbound connections are not using the NAT gateway, outbound connection only. Applications such as SAP Cloud Connector or VM's OS update services accessing repositories on Internet can use NAT Gateway, instead of the routing all outbound traffic through the central firewall. Very often [user defined rules](/azure/virtual-network/ip-services/default-outbound-access) are in place on all subnets, forcing all Internet bound traffic off all vnets through the central firewall. NAT Gateway can act as alternative for such central firewall, on outbound connections.

## Network design

The architecture uses two discrete virtual networks, both as a spoke vnet peered to the central hub vnet. There is no spoke to spoke peering, following the star principle of communication through the hub. The separation of networks acts to protect the applications from possible breach.

An application specific - here SAP DMZ - [perimeter network](/azure/cloud-adoption-framework/ready/azure-best-practices/perimeter-networks) contains the Internet facing applications such as saprouter, SAP cloud connector, SAP analytics cloud agent, or application gateway. Deployment, configuration and management of these services are performed by the SAP team and thus are often not located in a central hub subscription and network. Application Gateway always requires own designated subnet and it ideally located in the SAP DMZ vnet, along with the public IP addresses it uses as frontend and https listener.

Benefits of a separate SAP DMZ virtual network are:

- Quick and immediate isolation of compromised services, if a breach is detected. Removing vnet peering from SAP DMZ to hub immediately isolates both the SAP DMZ workloads, but also SAP application vnet application. Changing or removing a NSG rule permitting access only affects new connections and does not interrupt existing connections.
- More stringent controls on the vnet and subnet, with a tight lockdown on communication partners in and out of both SAP DMZ network and SAP application networks. Can be extended to authorized users and access methods on SAP DMZ applications.

Drawbacks are increased complexity, additional vnet peering cost for Internet bound SAP traffic since communication needs to pass through vnet peering twice. Latency implications on the spoke - hub - spoke peering traffic are dependant on any firewall and its latency impact.

### Simplified architecture

In order to address the recommendations in this document but limit the drawbacks, a single spoke vnet for both the DMZ and SAP applications is possible. This architecture is shown below and contains all subnets in one single SAP production virtual network. The benefit of immediate isolation through terminating vnet peering to SAP DMZ in case of compromise is not available. NSG changes in such case scenario will affect new connections.

This simplified architecture uses NAT Gateway in the SAP DMZ subnet, providing outbound connectivity for SAP Cloud Connector and SAP Analytics Cloud Agent as well as OS updates for the deployed VMs. Due to saprouter requirement for both incoming and outbound connections, this communication path is through the firewall.

[![Simplified architecture for Internet facing communication for SAP on Azure](./images/sap-internet-inbound-outbound-simplified-visio.png)](./images/sap-internet-inbound-outbound-simplified-visio.png#lightbox)
*Figure - Simplified architecture for Internet facing communication for SAP on Azure.*

_Download a [Visio file](https://arch-center.azureedge.net/sap-internet-communication-architecture.vsdx) of this architecture, containing all drawings shown here._

For deployments smaller in size and scope the simplified architecture can be more suitable, while keeping in mind the benefits of the main architecture. In this document the reference architecture shown at start will be referred to, unless noted othewise.

## SAP Services

### Saprouter

Enabling access to your SAP system to 3rd parties such as SAP themselves or partners can be done with Saprouter. Saprouter software runs on one VM, and with entries in the saproutab allows connection to any TCP/IP port on the destination behind saprouter. SAP support remote access relies on the use of this, same for download of SAP notes into your SAP NetWeaver system utilizes the saprouter to connect to SAP. The above architecture uses the earlier described network design, with a saprouter running on a VM within the designated SAP-DMZ vnet. Through the vnet peering saprouter then communicates with your SAP servers running in own spoke virtual network and subnets.

Saprouter acts as a tunnel to SAP or partners, the communication path to Internet is protected through:

- Azure Firewall or 3rd party NVA provides the public IP entry point into your Azure networks. Firewall rules in place to limit communication to authorized IPs only. For SAP suppport connection, [SAP note 48243 - Integrating the SAProuter software into a firewall environment](https://launchpad.support.sap.com/#/notes/48243) documents the IP address of SAP's routers.
- The saproutab file, where saprouter allow/deny rules are maintained, specifying who can contact saprouter and which SAP system can be accessed.
- NSG rules in place on the respective subnets.

The following blog post [SAP on Azure Tech Community | Saprouter configuration with Azure Firewall](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/saprouter-configuration-with-azure-firewall/ba-p/3293496) contains steps to configure saprouter with Azure Firewall.

#### Security considerations

As saprouter operates in different application subnet from your SAP systems, logon mechanisms for the OS might be different. Depending on customer's policy, a separate logon domain or entirely host-only user credentials can be used for the saprouter. Benefit in case of any security breach, no cascading access to the internal SAP systems is possible due to different credential base. Network separation in such case, as described earlier, can decouple further access from compromised saprouter into your application subnets.

#### Saprouter high availability considerations

As saprouter is a simple executable with a file-based route permission table, it can be easily (re)-started. The application has no built-in high-availability natively. In case of VM or application failure, the service needs to start on another VM. Using a virtual hostname for the saprouter service is ideal. This virtual hostname is bound to an IP which is assigned as secondary IP config with the VM’s NIC or to an internal load balancer connected to the VM(s). This way, if the saprouter service needs to be moved to another VM, the service virtual hostname's IP config can be removed and added on another VM without having to change the route tables or firewall configuration since they are all configured to use the virtual IP address. The following blog post [SAP on Azure Tech Community | Use SAP Virtual Host Names with Linux in Azure](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/use-sap-virtual-host-names-with-linux-in-azure/ba-p/3251593) has more information about usage of virtual hostnames with SAP in Azure.

#### Cascading saprouter

Up to 2 saprouters can be defined for SAP's support connections and thus a concept of a cascading saprouter can be implemented. First saprouter, running in the SAP DMZ application subnet provide access from the central firewall and from SAP's or partners saprouters. Only allowed destination are further saprouters, running with specific workload. This could be a per-tier, per-region or per-SID separation, depending on your enterprise architecture. The second saprouter accepts only internal connections from the first saprouter and provides access to individual SAP systems and VMs. Allowing your finely control access between different teams as needed.

### SAP Fiori and WebGui

SAP Fiori and other https frontends by SAP applications are often consumed by customer user base outside the internal corporate network. The need to be available on the Internet requires a secure solution protecting the SAP application. Azure Application Gateway with [web application firewall](/azure/web-application-firewall/ag/ag-overview) is the ideal service for this purpose. 

Users accessing the public hostname of the public IP tied to AppGw have the https session terminated on the AppGw. Backend pool of two or more SAP Web Dispatcher VMs get round-robin sessions from the AppGw. This internal traffic AppGw to VM can be either http or https depending on requirements. The web application firewall protects the SAP webdispatcher from attacks coming through the Internet with the [OWASP core rule set](/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules). User authentication is performed by SAP Netweaver, often tied to Azure Active Directory through [Single Sign-On](/azure/active-directory/saas-apps/sap-fiori-tutorial) (SSO). Following [blog post](https://blogs.sap.com/2020/12/10/sap-on-azure-single-sign-on-configuration-using-saml-and-azure-active-directory-for-public-and-internal-urls/) describes in great detail the steps needed to configure SSO with SAML for Fiori using AppGw.

Keep in mind that securing the SAP Webdispatcher needs to be performed in any case, regardless if open internally only, towards application gateway or any other network means. See SAP for further information about [securing the application](https://help.sap.com/docs/ABAP_PLATFORM/683d6a1797a34730a6e005d1e8de6f22/489ab29948c673e8e10000000a42189b.html?version=1709.008) layer of SAP Webdispatcher.

#### Firewall and AppGw

All web traffic provided by the application gateway is https based and encrypted with the provided TLS certificate. Using a Firewall as entry point into the corporate network, with its public IP, and SAP Fiori traffic flowing from firewall to AppGw next through internal IP is possible and [documented use case](/azure/architecture/example-scenario/gateway/firewall-application-gateway#application-gateway-after-firewall). Since the TCP/IP layer 7 encryption is already is in place through TLS, there is very limited benefit of using firewall in such scenario and thus cannot perform any packet inspection. One benefit would be Fiori getting same external IP for both inbound and outbound traffic but is typically not required for SAP Fiori scenarios. As such, using only AppGw with public IP is the recommended use case for SAP deployments.

#### AppGw for internal IP (optional)

The architecture focuses on Internet facing applications. Clients accessing SAP Fiori, WebUI of a SAP Netweaver system or other SAP https interface through an internal, private IP have different options to accomplish this. One scenario is treating all accesses to Fiori as public accesses, through the public IP. Another option is using direct network access through private network to the SAP WebDispatchers, bypassing the AppGw entirely. Last option is to use [both private and public IP](/azure/application-gateway/configuration-front-end-ip#public-and-private-ip-address-support) address on the AppGw, providing access to both Internet and private network.

Similar configuration with private IP on AppGw can be used for private only network access to the SAP landscape. The public IP in such case only is used for management purposes and does not have a listener associated to it.

Lastly, for architectures without public IP requirements for SAP Fiori deployments and for any reason deciding to not use application gateway, a round-robin configured standard internal load balancer (ILB) can be used. SAP Webdispatcher VMs are the ILB's backend pool, with the ILB placed in the SAP production application subnet. Dedicated ILB with just frontend private IP for the virtual Webdispatcher hostname should be used, to avoid sharing ILB with for example ASCS or DB cluster, as such sharing make troubleshooting and management complicated.

For any Internet facing deployments, AppGw with web application firewall is the recommended use case.

### SAP Business Technology Platform (BTP)

SAP BTP is large set of SAP's application - Software as a Service or Platform as a Service - most typically accessed through a public endpoint via the Internet. To provide communication for applications running in private networks, like a SAP S/4HANA system running in Azure, often [SAP Cloud Connector](https://help.sap.com/docs/CP_CONNECTIVITY/cca91383641e40ffbe03bdc78f00f681/e6c7616abb5710148cfcf3e75d96d596.html) is used. SAP Cloud Connector runs as application inside a virtual machine, requiring outbound Internet access to establish a TLS encrypted https tunnel with SAP BTP service. It acts as a reverse invoke proxy between the private IP range in your vnet and SAP BTP. Due to this reverse invoke support, there is no needed open firewall ports or other access for inbound connections, as the connection from view of your vnet is outbound.

By default, VMs have [outbound Internet](/azure/virtual-network/ip-services/default-outbound-access) access natively in Azure. The used public IP address, without a dedicated public IP associated to the virtual machine, is for outbound traffic flows randomly chosen from the pool of public IPs in the specific Azure region, beyond any customer control. For SAP BTP, the outbound IP address should be known and thus can be limited with public load balancer and its public IP, NAT gateway associated to the subnet, customer operated http proxy servers or by using [user defined route](/azure/virtual-network/ip-services/default-outbound-access) forcing the network traffic to a network appliance such as firewall.

The reference architecture shows the most common scenario of routing Internet bound traffic to the hub vnet and through the central firewall. The public IP address(es) associated with the firewall should be configured for SAP BTP communication endpoints. [Further settings](https://help.sap.com/docs/CLOUD_INTEGRATION/368c481cd6954bdfa5d0435479fd4eaf/642e87f1492146998a8eb0779cd07289.html) are required in the SAP cloud connector to connect to your SAP BTP account.

#### High-availability for SAP Cloud Connector

SAP Cloud Connector provides built-in high-availability through the deployment on two distinct virtual machines. A main instance is active with the shadow instance connected to the master, including shared configuration and kept in sync. Should master not be available, the shadow attempts to take over the master role and re-establish the TLS tunnel to SAP BTP. In the architecture a high-available cloud connector environment is shown. No further Azure technologies such as load balancer or cluster software is required for such highly available setup. See SAP documentation for [details on setup and operation](https://help.sap.com/docs/CP_CONNECTIVITY/cca91383641e40ffbe03bdc78f00f681/2f9250b0e6ac488286266461a82518e8.html).

#### SAP Analytics Cloud Agent

For some application scenarios, SAP Analytics Cloud (SAC) Agent is an application installed inside a virtual machine, which uses SAP cloud connector for SAP BTP connectivity. For this architecture, the SAC Agent VM should run in the SAP DMZ application subnet, alongside the SAP Cloud Connector VM(s). See SAP's documentation [showing the traffic flow](https://help.sap.com/docs/SAP_ANALYTICS_CLOUD/00f68c2e08b941f081002fd3691d86a7/5339a2395ccd4befb047c625a15f8481.html) from private networks such as Azure vnet to SAP BTP using SAC agent. 

#### SAP Private Link service in Azure

SAP has a [private link service](https://blogs.sap.com/2022/06/22/sap-private-link-service-on-azure-is-now-generally-available-ga/) available for SAP BTP, enabling private connection between selected SAP BTP services and selected services in your Azure subscription and vnet. By using the private link service, the communication is not routed through the public Internet and remains on Azure backbone network, secure, with communication to Azure services through private address space. Data exfiltration protection is built-in when using private link service, since the private endpoint maps the specific Azure service to an IP address. Access is only limited to the mapped Azure service.

### Other SAP communication needs

SAP landscape operating in Azure might require further considerations for Internet bound communication. Traffic flow in this architecture uses central Azure Firewall for such outbound traffic. User defined rules in the spoke vnets route the Internet bound traffic requests to the firewall. Alternatives are to use NAT gateways on specific subnets, [default Azure outbound](/azure/virtual-network/ip-services/default-outbound-access) communication, public IP on VM (not recommended) or public load balancer with outbound rules.

For virtual machines behind a standard internal load balancer, such as clustered environments, be aware the standard ILB modifies the behaviour for public connectivity in following article. [Public endpoint connectivity for Virtual Machines using Azure Standard Load Balancer in SAP high-availability scenarios](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections)

#### Operating system  Updates

Operating systems (OS) updates are often located behind a public endpoint through the Internet. If no enterprise repository and update management is in place, mirroring OS updates from vendors on private IP/VMs, your SAP workload will need to access the update repositories of respective vendor.

For Linux operating systems, below repositories are accessible if you obtain the OS license from Azure. Contact the OS vendor if you purchase licenses directly and bring them to Azure (BYOS) about ways to connect to OS repositories and respective IP ranges.

- For SuSE Enterprise Linux, [SuSE maintains](https://pint.suse.com/?resource=servers&csp=microsoft) a list of servers in each Azure region.
- For RedHat Enterprise Linux, RedHat Update Infrastructure is [documented here](/azure/virtual-machines/workloads/redhat/redhat-rhui#the-ips-for-the-rhui-content-delivery-servers).
- For Windows, Windows Update is available as [FQDN tag](/azure/firewall/fqdn-tags#current-fqdn-tags) for Azure Firewall.

#### High-Availability cluster management

Highly available systems such as clustered SAP (A)SCS or databases might use a cluster manager and thus be dependant on reaching Azure resource manager (ARM). ARM is used for both status queries about state of Azure resources and also operations to stop/start virtual machines. Since ARM is a public endpoint, reachable under management.azure.com, VM outbound communication need to be able to reach it. This architecture again here relies on central firewall with user defined rules routing traffic from SAP vnets. Alternatives to central firewall exist as explained previous sections.

## Communities

Communities can answer questions and help you set up a successful deployment. Consider the following communities:

- [Azure Community Support](https://azure.microsoft.com/support/forums/)
- [SAP Community](https://www.sap.com/community.html)
- [Stack Overflow SAP](http://stackoverflow.com/tags/sap/info)

## Related resources

[SAP Blogs | SAP on Azure: Azure Application Gateway Web Application Firewall (WAF) v2 Setup for Internet facing SAP Fiori Apps](https://blogs.sap.com/2020/12/03/sap-on-azure-application-gateway-web-application-firewall-waf-v2-setup-for-internet-facing-sap-fiori-apps/)
[SAP Blogs | Getting Started with BTP Private Link Service for Azure](https://blogs.sap.com/2021/12/29/getting-started-with-btp-private-link-service-for-azure/)
[SAP on Azure Tech Community | Saprouter configuration with Azure Firewall](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/saprouter-configuration-with-azure-firewall/ba-p/3293496)
[SAP on Azure Tech Community | Use SAP Virtual Host Names with Linux in Azure](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/use-sap-virtual-host-names-with-linux-in-azure/ba-p/3251593)
[SAP Documentation | What is Cloud Connector](https://help.sap.com/docs/CP_CONNECTIVITY/cca91383641e40ffbe03bdc78f00f681/e6c7616abb5710148cfcf3e75d96d596.html)
[MS Docs | Default outbound access in Azure](/azure/virtual-network/ip-services/default-outbound-access)
[MS Docs | Public endpoint connectivity for Virtual Machines using Azure Standard Load Balancer in SAP high-availability scenarios](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections)
[MS Docs | Subscription decision guide](/azure/cloud-adoption-framework/decision-guides/subscriptions/)

