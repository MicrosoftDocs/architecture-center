<!-- cSpell:ignore saprouter linky -->

This article provides a set of proven practices for enabling improved-security inbound and outbound internet connections for your SAP on Azure infrastructure.

## Architecture

[![Diagram that shows a solution for internet-facing communication for SAP on Azure.](./images/sap-internet-inbound-outbound-visio.png)](./images/sap-internet-inbound-outbound-visio.png#lightbox)

_Download a [Visio file](https://arch-center.azureedge.net/sap-internet-communication-architecture.vsdx) of the architectures in this article._

This reference architecture illustrates a common production environment. You can reduce the size and scope of the configuration, per your requirements. This reduction might apply to the SAP landscape: fewer virtual machines (VMs), no high availability, or embedded SAP Web Dispatchers instead of discrete VMs. It can also apply to alternatives on the network side, as described later in this article.

Customer requirements, driven by business or company policies, will necessitate adaptations to the architecture, particularly on the network side. When possible, we've included alternatives. Many solutions are viable. Choose an approach that's right for your business. It needs to help you secure your Azure resources but still provide a performant solution.

Disaster recovery (DR) isn't covered in this architecture. On a network level, the same principles and design that are valid for primary production regions apply. For the network, depending on the applications being protected by DR, you might want to consider enabling DR in another Azure region.

### Components

**Subscriptions.** This architecture implements the Azure [landing zone](/azure/cloud-adoption-framework/ready/landing-zone) approach. One Azure subscriptions is used for each workload. One or more subscriptions are used for central IT services that contain the network hub and central, shared services like firewalls or Active Directory and DNS. An additional subscriptions is used for the SAP production workload. Use the [decision guide](/azure/cloud-adoption-framework/decision-guides/subscriptions) in the Cloud Adoption Framework for Azure to determine the best subscription strategy for your scenario.

**Virtual networks.** [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) connects Azure resources to each other with enhanced security. In this architecture, the virtual network connects to an on-premises environment via an Azure ExpressRoute or virtual private network (VPN) gateway that's deployed in the hub of a [hub-spoke topology](../../reference-architectures/hybrid-networking/hub-spoke.yml). The SAP production landscape uses own spoke virtual networks. Two distinct spoke virtual networks perform different tasks, and subnets provide network segregation.

Separating into subnets by workload makes it easier to enable network security groups (NSGs) to set security rules for application VMs or Azure services that are deployed on them.

**Zone-redundant gateway.** A gateway connects distinct networks, extending your on-premises network to the Azure virtual network. We recommend that you use [ExpressRoute](https://azure.microsoft.com/services/expressroute) to create private connections that don't go over the public internet. You can also use a [site-to-site](../../reference-architectures/hybrid-networking/expressroute.yml) connection. You can deploy ExpressRoute or VPN gateways across zones to help avoid zone failures. See [Zone-redundant virtual network gateways](/azure/vpn-gateway/about-zone-redundant-vnet-gateways) for an explanation of the differences between a zonal deployment and a zone-redundant deployment. For a zone deployment of the gateways, you need to use Standard SKU IP addresses.

**NSGs.** To restrict network traffic to and from the virtual network, create [network security groups](/azure/virtual-network/tutorial-filter-network-traffic-cli) and assign them to specific subnets. Provide security for individual subnets by using workload-specific NSGs.

**Application security groups.** To define fine-grained network security policies in your NSGs based on workloads that are centered on applications, use [application security groups](/azure/virtual-network/security-overview) instead of explicit IP addresses. By using application security groups, you can group VMs by purpose, for example, SAP SID. Application security groups help you secure applications by filtering traffic from trusted segments of your network.

**Private endpoint.** Many Azure services operate as public services, by design accessible via the internet. To allow private access via your private network range, you can use private endpoints for some services. [Private endpoints](/azure/private-link/private-endpoint-overview) are network interfaces in your virtual network. They effectively bring the service into your private network space.

**Azure Application Gateway.** [Application Gateway](https://azure.microsoft.com/services/application-gateway) is a web-traffic load balancer. With its web application firewall functionality, it's the ideal service to expose web applications to the internet with improved security. Application Gateway can service either public (internet) or private clients, or both, depending on the configuration.

In the architecture, Application Gateway, using a public IP address, allows inbound connections to the SAP landscape over HTTPS. Its back-end pool is two or more SAP Web Dispatcher VMs, accessed round-robin and providing high availability. The application gateway is a reverse proxy and web-traffic load balancer, but it doesn't replace the SAP Web Dispatcher. SAP Web Dispatcher provides application integration with your SAP systems and includes features that Application Gateway by itself can't provide. Client authentication, once it reaches the SAP systems, is performed by the SAP application layer natively or via single sign-on.

For optimal performance, enable [HTTP/2 support](/azure/application-gateway/configuration-listeners#http2-support) for Application Gateway, [SAP Web Dispatcher](https://help.sap.com/docs/SAP_NETWEAVER_AS_ABAP_751_IP/683d6a1797a34730a6e005d1e8de6f22/c7b46000a76445f489e86f4c5814c7e8.html), and SAP NetWeaver.

**[Azure Load Balancer](https://azure.microsoft.com/services/load-balancer).** Azure [Standard Load Balancer](/azure/load-balancer/load-balancer-overview) provides networking elements for the high-availability design of your SAP systems. For clustered systems, Standard Load Balancer provides the virtual IP address for the cluster service, like ASCS/SCS instances and databases running on VMs. You also can use Standard Load Balancer to provide the IP address for the virtual SAP host name of non-clustered systems when [secondary IPs on Azure network cards](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/use-sap-virtual-host-names-with-linux-in-azure/ba-p/3251593) aren't an option. The use of Standard Load Balancer instead of Application Gateway to address outbound internet access is covered later in this article.

## Network design

The architecture uses two discrete virtual networks, both spoke virtual networks that are peered to the central hub virtual network. There's no spoke-to-spoke peering. A star topology is used, in which communication passes through the hub. The separation of networks helps to protect the applications from breaches.

An application-specific [perimeter network](/azure/cloud-adoption-framework/ready/azure-best-practices/perimeter-networks) (also known as a *DMZ*) contains the internet-facing applications, like SAProuter, SAP Cloud Connector, SAP Analytics Cloud Agent, and Application Gateway. In the architecture diagram, the perimeter network is named SAP perimeter spoke virtual network. Because of dependencies on SAP systems, the SAP team typically does the deployment, configuration, and management of these services. That's why these SAP perimeter services frequently aren't located in a central hub subscription and network,where they would need to be managed by the central IT team. This constraint causes organizational challenges. Application Gateway always requires its own designated subnet, which is best placed in the SAP perimeter virtual network. Application Gateway uses a public IP addresses for its front end and HTTPS listener.

These are some of the benefits of using a separate SAP perimeter virtual network:

- Quick and immediate isolation of compromised services if a breach is detected. Removing virtual network peering from the SAP perimeter to the hub immediately isolates the SAP perimeter workloads and SAP application virtual network applications from the internet. Changing or removing an NSG rule that permits access affects only new connections and doesn't cut existing connections.
- More stringent controls on the virtual network and subnet, with a tight lockdown on communication partners in and out of the SAP perimeter network and SAP application networks. You can extend increased control to authorized users and access methods on SAP perimeter applications, with different authorization back ends, privileged access, or sign-in credentials for SAP perimeter applications.

Drawbacks are increased complexity and extra virtual network peering costs for internet-bound SAP traffic (because communication needs to pass through virtual network peering twice). The latency impact on spoke-hub-spoke peering traffic depends on any firewall in place and needs to be measured.

### Simplified architecture

To address the recommendations in this article but limit the drawbacks, you can use a single spoke virtual network for both the perimeter and the SAP applications. The following architecture contains all subnets in a single SAP production virtual network. The benefit of immediate isolation by termination of virtual network peering to the SAP perimeter if it's compromised isn't available. In this scenario, changes to NSGs affect only new connections.

[![Diagram that shows a simplified architecture for internet-facing communication for SAP on Azure.](./images/sap-internet-inbound-outbound-simplified-visio.png)](./images/sap-internet-inbound-outbound-simplified-visio.png#lightbox)

_Download a [Visio file](https://arch-center.azureedge.net/sap-internet-communication-architecture.vsdx) of the architectures in this article._

For deployments that are smaller in size and scope, the simplified architecture might be a better fit, and it still follows the principles of the more complex architecture. This article, unless otherwise noted, refers to the more complex architecture.

The simplified architecture uses a NAT gateway in the SAP perimeter subnet. This gateway provides outbound connectivity for SAP Cloud Connector and SAP Analytics Cloud Agent and OS updates for the deployed VMs. Because SAProuter requires for both incoming and outbound connections, the SAProuter communication path goes through the firewall instead of using the NAT gateway.

[NAT gateway](/azure/virtual-network/nat-gateway/nat-overview) is a service that provides static public IPs for outbound connectivity. The NAT gateway is assigned to a subnet. All outbound communications use the NAT gateway's IPs for internet access. Inbound connections don't use the NAT gateway. Applications like SAP Cloud Connector or VM OS update services that access repositories on the internet can use the NAT gateway instead of routing all outbound traffic through the central firewall. Frequently, [user defined rules](/azure/virtual-network/ip-services/default-outbound-access) are implemented on all subnets to force internet-bound traffic from all virtual networks through the central firewall.

Depending on your requirements, you might be able to use the NAT gateway as an alternative to the central firewall, on outbound connections only. By doing so, you can reduce load on the central firewall while communicating with NSG-allowed public endpoints. You also get outbound IP control, because you can configure destination firewall rules on a set IP list of the NAT gateway. Examples include reaching Azure public endpoints that are used by public services, OS patch repositories, or third-party interfaces.

For a high-availability configuration, keep in mind that NAT gateway is deployed in a [specific zone only](/azure/virtual-network/nat-gateway/faq#how-does-virtual-network-nat-gateway-work-with-availability-zones) and isn't currently cross-zone redundant. So it's not ideal for SAP deployments that use zone-redundant (cross-zone) deployment for virtual machines.

### Use of network components across a SAP landscape

An architecture document typically depicts only one SAP system or landscape, for ease of understanding. Often unaddressed is the overall bigger picture of how such architecture fits to a larger SAP landscape with several system tracks and tiers.

Central networking services, such as firewall, NAT gateway, proxy servers if deployed are best used across entire SAP landscape of all tiers - production, pre-production, development and sandbox. Depending on your requirements, organization size and company policy you can consider separate implementation per tier or one production and one sandbox/testing environment.

Services typically serving an SAP system are best separated as follows

- **Load Balancers** dedicated to individual service. Degree of separation best per company policy on naming and grouping. Recommended deployment is one load balancer for (A)SCS and ERS and another for DB, for each SAP SID separated. This ensures troubleshooting doesn't get complex with multiple front- and backend pools and load balancing rules all on same single load balancer. Single load balancer per SAP SID also ensures placement in resource groups matches the other infrastructure components.
- **Application Gateway**, similarly to load balancer, allows multiple back- and frontends, HTTP settings and rules. The decision to use one Application Gateway for multiple uses - different web dispatchers ports for same SAP S/4HANA system or different SAP environments is here more common, as not all SAP systems in the environment require public access. Recommended approach is thus to use one Application Gateway at least per tier (production, non-production, sandbox) unless the complexity and amount of connected systems gets too high.
- **SAP services** like saprouter or cloud connector, analytics cloud agent are deployed based on application requirements either centrally or split up. Often production and non-production separation is desired.

### Subnet sizing and design

When designing subnets for your SAP landscape, ensure correct sizing and design principles are adhered to.

- Several Azure PaaS services require own, designated subnets.
- Application Gateway requires at least /29 subnet, although /27 or larger is [recommended](/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsub). Application Gateway version 1 and 2 can't be part of the same subnet.
- If using Azure NetApp Files for your NFS/SMB shares or database storage, again own designated subnet is required. /24 subnet is default and [proper sizing](/azure/azure-netapp-files/azure-netapp-files-delegate-subnet) should be chosen based on requirements.
- If using SAP virtual hostnames, more address space is needed in your SAP subnets, including SAP DMZ.
- Central services like Azure Bastion or Azure Firewall, typically managed by central IT team, require their own dedicated subnets with sufficient sizing.

Dedicated subnets for SAP database and application allow NSGs to be set more strict, protecting both application types with own set of rules. Access to database can be then much more simply limited to SAP applications only, without having to resort to application security groups for granular control. Separating your SAP application and database subnets also allows easier manageability of your security rules within NSGs.

## SAP Services

### Saprouter

Enabling access to your SAP system to third parties such as SAP support or partners can be done with saprouter. Saprouter software runs on one VM in Azure. Routing permissions to use saprouter are stored in a flat file called saproutab. The saproutab entries allow connection to any TCP/IP port to a network destination behind saprouter, typically your SAP system VMs. SAP support remote access relies on the use of saprouter, same for download of SAP notes into your SAP NetWeaver system utilizes the saprouter to connect to SAP. The above architecture uses the earlier described network design, with a saprouter VM running within the designated SAP-DMZ vnet. Through the vnet peering, saprouter then communicates with your SAP servers running in own spoke virtual network and subnets.

Saprouter acts as a tunnel to SAP or partners, the communication path to Internet is protected through:

- Azure Firewall or third party NVA provides the public IP entry point into your Azure networks. Firewall rules in place to limit communication to authorized IPs only. For SAP support connection, [SAP note 48243 - Integrating the SAProuter software into a firewall environment](https://launchpad.support.sap.com/#/notes/48243) documents the IP address of SAP's routers.
- Similarly to firewall rules, network security rules allow communication on saprouter's port, typically 3299 with the designated destination.
- The saproutab file, where saprouter allow/deny rules are maintained, specifying who can contact saprouter and which SAP system can be accessed.
- Further NSG rules in place on the respective subnets within the SAP production subnet, containing the SAP systems.

The following blog post [SAP on Azure Tech Community | Saprouter configuration with Azure Firewall](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/saprouter-configuration-with-azure-firewall/ba-p/3293496) contains steps to configure saprouter with Azure Firewall.

#### Security considerations

As saprouter operates in different application subnet from your SAP systems, logon mechanisms for the OS might be different. Depending on customer's policy, a separate logon domain or entirely host-only user credentials can be used for the saprouter. Benefit if there's any security breach, no cascading access to the internal SAP systems is possible due to different credential base. Network separation in such case, as described earlier, can decouple further access from compromised saprouter into your application subnets by disconnecting the SAP DMZ vnet peering.

#### Saprouter high availability considerations

As saprouter is a simple executable with a file-based route permission table, it can be easily (re)-started. The application has no built-in high-availability natively. If there's VM or application failure, the service needs to start on another VM. Using a virtual hostname for the saprouter service is ideal. This virtual hostname is bound to an IP, which is assigned as secondary IP config with the VM’s NIC or to an internal load balancer connected to the VM(s). This way, if the saprouter service needs to be moved to another VM, the service virtual hostname's IP config can be removed. The virtual hostname is then added on another VM without having to change the route tables or firewall configuration since they're all configured to use the virtual IP address. The following blog post [SAP on Azure Tech Community | Use SAP Virtual Host Names with Linux in Azure](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/use-sap-virtual-host-names-with-linux-in-azure/ba-p/3251593) has more information about usage of virtual hostnames with SAP in Azure.

#### Cascading saprouter

Up to two saprouters can be defined for SAP's support connections and thus a concept of a cascading saprouter can be implemented. First saprouter, running in the SAP DMZ application subnet provide access from the central firewall and from SAP's or partners saprouters. Only allowed destinations are further saprouters, running with specific workload. Cascading saprouters could be a per-tier, per-region or per-SID separation, depending on your enterprise architecture. The second saprouter accepts only internal connections from the first saprouter and provides access to individual SAP systems and VMs. Allowing you separating access and management between different teams as needed. An example of a cascading saprouter is given in the above linked blog post.

### SAP Fiori and WebGui

SAP Fiori and other https frontends by SAP applications are often consumed by customer user base outside the internal corporate network. The need to be available on the Internet requires a secure solution protecting the SAP application. Azure Application Gateway with [web application firewall](/azure/web-application-firewall/ag/ag-overview) is the ideal service for this purpose. 

Users accessing the public hostname of the public IP tied to Application Gateway have the https session terminated on the Application Gateway. Backend pool of two or more SAP Web Dispatcher VMs get round-robin sessions from the Application Gateway. This internal traffic Application Gateway to Web Dispatcher can be either http or https depending on requirements. The web application firewall protects the SAP Web Dispatcher from attacks coming through the Internet with the [OWASP core rule set](/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules). User authentication is performed by SAP Netweaver, often tied to Azure Active Directory through [Single Sign-On](/azure/active-directory/saas-apps/sap-fiori-tutorial) (SSO). Following [blog post](https://blogs.sap.com/2020/12/10/sap-on-azure-single-sign-on-configuration-using-saml-and-azure-active-directory-for-public-and-internal-urls/) describes in great detail the steps needed to configure SSO with SAML for Fiori using Application Gateway.

Keep in mind that securing the SAP Web Dispatcher needs to be performed in any situation. Even if open internally only, open towards application gateway with public IP or accessible through any other network means. See SAP for further information about [securing the application](https://help.sap.com/docs/ABAP_PLATFORM/683d6a1797a34730a6e005d1e8de6f22/489ab29948c673e8e10000000a42189b.html?version=1709.008) layer of SAP Web Dispatcher.

#### Firewall and Application Gateway

All web traffic provided by the application gateway is https based and encrypted with the provided TLS certificate. Using a Firewall as entry point into the corporate network, with its public IP, and SAP Fiori traffic flowing from firewall to Application Gateway next through internal IP is possible and a [documented use case](/azure/architecture/example-scenario/gateway/firewall-application-gateway#application-gateway-after-firewall). Since the TCP/IP layer 7 encryption is already in place through TLS, there's limited benefit of using firewall in such scenario, and thus can't perform any packet inspection. One aspect is Fiori communicating through same external IP for both inbound and outbound traffic, which is typically not required for SAP Fiori deployments.

Benefits of a tandem Application Gateway and layer 4 firewall deployment is possible integration with enterprise-wide security policy management and already discarding network traffic violating [security rules](/azure/firewall/threat-intel) not requiring content inspection. Such a combined deployment is a good architecture and it depends on your overall enterprise architecture how inbound Internet traffic must be handled. Consider also how such overall network architecture fits with access from internal IP address space such as on-premise clients, covered in next section.

#### Application Gateway for internal IP (optional)

The architecture focuses on Internet facing applications. Clients accessing SAP Fiori, WebUI of a SAP Netweaver system or other SAP https interface through an internal, private IP have different options available. One scenario is treating all accesses to Fiori as public accesses, through the public IP. Another option is using direct network access through private network to the SAP Web Dispatchers, bypassing the Application Gateway entirely. Last option is to use [both private and public IP](/azure/application-gateway/configuration-front-end-ip#public-and-private-ip-address-support) address on the Application Gateway, providing access to both Internet and private network.

Similar configuration with private IP on Application Gateway can be used for private only network access to the SAP landscape. The public IP in such case only is used for management purposes and doesn't have a listener associated to it.

As an alternative when deciding to not use application gateway is to use a load balancer internally. A standard internal load balancer with Web Dispatcher VMs configured as round-robin backend. The Standard Load Balancer placed would be placed with the Web Dispatcher VMs in the SAP production application subnet and provide [active/active](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE/683d6a1797a34730a6e005d1e8de6f22/489a9a6b48c673e8e10000000a42189b.html) load balancing between Web Dispatcher VMs.

For any Internet facing deployments, Application Gateway with web application firewall is the recommended use case instead of using a load balancer with public IP.

### SAP Business Technology Platform (BTP)

SAP BTP is a large set of SAP's application - Software as a Service or Platform as a Service - most typically accessed through a public endpoint via the Internet. To provide communication for applications running in private networks, like an SAP S/4HANA system running in Azure, often [SAP Cloud Connector](https://help.sap.com/docs/CP_CONNECTIVITY/cca91383641e40ffbe03bdc78f00f681/e6c7616abb5710148cfcf3e75d96d596.html) is used. SAP Cloud Connector runs as application inside a virtual machine, requiring outbound Internet access to establish a TLS encrypted https tunnel with SAP BTP service. It acts as a reverse invoke proxy between the private IP range in your vnet and SAP BTP applications. Due to this reverse invoke support, there's no need for open firewall ports or other access for inbound connections, as the connection from view of your vnet is outbound.

By default, VMs have [outbound Internet](/azure/virtual-network/ip-services/default-outbound-access) access natively in Azure. The used public IP address, without a dedicated public IP associated to the virtual machine, is for outbound traffic flows randomly chosen from the pool of public IPs in the specific Azure region, beyond any customer control. Using a NAT gateway associated to the subnet or load balancer and its public IP, customer operated http proxy servers or by using [user defined route](/azure/virtual-network/ip-services/default-outbound-access) forcing the network traffic to a network appliance such as firewall, are all ways to ensure the outbound connections are made through a controlled and identifiable service and IP address.

The reference architecture shows the most common scenario of routing Internet bound traffic to the hub vnet and through the central firewall. [Further settings](https://help.sap.com/docs/CLOUD_INTEGRATION/368c481cd6954bdfa5d0435479fd4eaf/642e87f1492146998a8eb0779cd07289.html) are required in the SAP cloud connector to connect to your SAP BTP account.

#### High-availability for SAP Cloud Connector

SAP Cloud Connector provides high-availability built into the application. Cloud Connector is installed on two virtual machines. A main instance is active, with the shadow instance connected to the main, both share configuration and are kept in sync natively. Should main not be available, the secondary VM attempts to take over the main role and re-establish the TLS tunnel to SAP BTP. In the architecture, a high-available cloud connector environment is shown. No further Azure technologies such as load balancer or cluster software is required for such setup. See SAP documentation for [details on setup and operation](https://help.sap.com/docs/CP_CONNECTIVITY/cca91383641e40ffbe03bdc78f00f681/2f9250b0e6ac488286266461a82518e8.html).

#### SAP Analytics Cloud Agent

For some application scenarios, SAP Analytics Cloud (SAC) Agent is an application installed inside a virtual machine, which uses SAP cloud connector for SAP BTP connectivity. For this architecture, the SAC Agent VM should run in the SAP DMZ application subnet, alongside the SAP Cloud Connector VM(s). See SAP's documentation [showing the traffic flow](https://help.sap.com/docs/SAP_ANALYTICS_CLOUD/00f68c2e08b941f081002fd3691d86a7/5339a2395ccd4befb047c625a15f8481.html) from private networks such as Azure vnet to SAP BTP using SAC agent. 

#### SAP Private Link service in Azure

SAP has a [private link service](https://blogs.sap.com/2022/06/22/sap-private-link-service-on-azure-is-now-generally-available-ga/) available for SAP BTP, enabling private connection between selected SAP BTP services and selected services in your Azure subscription and vnet. By using the private link service, the communication isn't routed through the public Internet and remains on Azure backbone network, secure, with communication to Azure services through private address space. Data exfiltration protection is built in when using private link service, since the private endpoint maps the specific Azure service to an IP address. Access is only limited to the mapped Azure service.

Some SAP BTP integration scenarios will favor the private link service approach, while other might prefer SAP Cloud Connector. An excellent blog post exists to help you decide which is more suitable and compare both. [SAP Blogs | BTP private linky swear with Azure – running Cloud Connector and SAP Private Link side-by-side](https://blogs.sap.com/2022/07/07/btp-private-linky-swear-with-azure-running-cloud-connector-and-sap-private-link-side-by-side/)

### SAP RISE/ECS

For customers where SAP operates their SAP system under SAP RISE/ECS contract, SAP acts as the managed service partner. The SAP environment is deployed by SAP and under SAP's architecture, the architecture shown here doesn't apply to your systems running in RISE with SAP/ECS. See our Azure documentation about [integrating such SAP landscape with Azure](/azure/virtual-machines/workloads/sap/sap-rise-integration) services and your network.

### Other SAP communication needs

SAP landscape operating in Azure might require further considerations for Internet bound communication. Traffic flow in this architecture uses central Azure Firewall for such outbound traffic. User defined rules in the spoke vnets route the Internet bound traffic requests to the firewall. Alternatives are to use NAT gateways on specific subnets, [default Azure outbound](/azure/virtual-network/ip-services/default-outbound-access) communication, public IP on VM (not recommended) or public load balancer with outbound rules.

For virtual machines behind a standard internal load balancer, such as clustered environments, be aware the Standard Load Balancer modifies the behavior for public connectivity in following article. [Public endpoint connectivity for Virtual Machines using Azure Standard Load Balancer in SAP high-availability scenarios](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections)

#### Operating system  Updates

Operating systems (OS) updates are often located behind a public endpoint through the Internet. If no enterprise repository and update management are in place, mirroring OS updates from vendors on private IP/VMs, your SAP workload will need to access the update repositories of respective vendor.

For Linux operating systems, below repositories are accessible if you obtain the OS license from Azure. Contact the OS vendor if you purchase licenses directly and bring them to Azure (BYOS) about ways to connect to OS repositories and respective IP ranges.

- For SuSE Enterprise Linux, [SuSE maintains](https://pint.suse.com/?resource=servers&csp=microsoft) a list of servers in each Azure region.
- For RedHat Enterprise Linux, RedHat Update Infrastructure is [documented here](/azure/virtual-machines/workloads/redhat/redhat-rhui#the-ips-for-the-rhui-content-delivery-servers).
- For Windows, Windows Update is available as [FQDN tag](/azure/firewall/fqdn-tags#current-fqdn-tags) for Azure Firewall.

#### High-Availability cluster management

Highly available systems such as clustered SAP (A)SCS or databases might use a cluster manager with Azure fence agent as its STONITH device. Such systems are dependent on reaching Azure resource manager (ARM). ARM is used for both status queries about state of Azure resources and also operations to stop/start virtual machines. Since ARM is a public endpoint, reachable under management.azure.com, VM outbound communication need to be able to reach it. This architecture again here relies on central firewall with user defined rules routing traffic from SAP vnets. Alternatives to central firewall exist as explained previous sections.

## Communities

Communities can answer questions and help you set up a successful deployment. Consider the following communities:

- [Azure Community Support](https://azure.microsoft.com/support/forums/)
- [SAP Community](https://www.sap.com/community.html)
- [Stack Overflow SAP](http://stackoverflow.com/tags/sap/info)

## Related resources

- [SAP Blogs | SAP on Azure: Azure Application Gateway Web Application Firewall (WAF) v2 Setup for Internet facing SAP Fiori Apps](https://blogs.sap.com/2020/12/03/sap-on-azure-application-gateway-web-application-firewall-waf-v2-setup-for-internet-facing-sap-fiori-apps/)
- [SAP Blogs | Getting Started with BTP Private Link Service for Azure](https://blogs.sap.com/2021/12/29/getting-started-with-btp-private-link-service-for-azure/)
- [SAP Blogs | BTP private linky swear with Azure – running Cloud Connector and SAP Private Link side-by-side](https://blogs.sap.com/2022/07/07/btp-private-linky-swear-with-azure-running-cloud-connector-and-sap-private-link-side-by-side/)
- [SAP on Azure Tech Community | Saprouter configuration with Azure Firewall](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/saprouter-configuration-with-azure-firewall/ba-p/3293496)
- [SAP on Azure Tech Community | Use SAP Virtual Host Names with Linux in Azure](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/use-sap-virtual-host-names-with-linux-in-azure/ba-p/3251593)
- [SAP Documentation | What is Cloud Connector](https://help.sap.com/docs/CP_CONNECTIVITY/cca91383641e40ffbe03bdc78f00f681/e6c7616abb5710148cfcf3e75d96d596.html)
- [SAP Documentation | What is SAP Analytics Cloud Agent](https://help.sap.com/docs/SAP_ANALYTICS_CLOUD/00f68c2e08b941f081002fd3691d86a7/7cb6ffb38c294a5c871d6cc6ad5b1b36.html)
- [MS Docs | Default outbound access in Azure](/azure/virtual-network/ip-services/default-outbound-access)
- [MS Docs | Public endpoint connectivity for Virtual Machines using Azure Standard Load Balancer in SAP high-availability scenarios](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections)
- [MS Docs | Subscription decision guide](/azure/cloud-adoption-framework/decision-guides/subscriptions/)
- [SAP Blogs | SAP Fiori using Azure CDN for SAPUI5 libraries](https://blogs.sap.com/2021/03/22/sap-fiori-using-azure-cdn-for-sapui5-libraries/)
- [Youtube | [SOT113] Deploying Fiori at Scale](https://www.youtube.com/watch?v=IJQlSjxb8pE)
