# A Microsoft Azure Three Tier Web Application Architecture For Workloads Classified as UK-OFFICIAL.

## Overview

This article provides guidance and automation scripts to deliver a Microsoft Azure three-tier web based architecture appropriate for handling many workloads classified as OFFICIAL in the United Kingdom.    

 Using an Infrastructure as Code approach, the set of [Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview)
 (ARM) templates deploy an environment that aligns to the National Cyber Security Centre (NCSC) [Cloud Security Principles](https://www.ncsc.gov.uk/guidance/implementing-cloud-security-principles) and  the Center for Internet Security (CIS) [Critical Security
 Controls](https://www.cisecurity.org/critical-controls.cfm).

 The NCSC recommend their Cloud Security Principles be used by customers to evaluate the security properties of the service, and to help understand the division of responsibility between the customer and supplier. We�ve provided information against each of these principles to help you understand the split of responsibilities.

 This architecture and corresponding ARM templates are underpinned by the Microsoft whitepaper [Azure Blueprint for the UK Government](https://aka.ms/azureblueprintukg-cloud). This paper catalogue how Azure services align with the fourteen
 cloud security principles set forth in the CESG/NCSC publication [Implementing the Cloud Security Principles](https://www.ncsc.gov.uk/guidance/implementing-cloud-security-principles)"
 thereby enabling organisations to fast-track their ability to meet their compliance obligations using cloud-based services globally and in the UK on the Microsoft Azure cloud.

 This template deploys the infrastructure for the workload. Application code and supporting business tier and data tier software must be installed and configured.

 If you do not have an Azure subscription then you can sign up quickly and easily, [Get Started with Azure](https://azure.microsoft.com/en-us/get-started/).


## Architecture Diagram and Components
===================================

 The Azure templates deliver a three-tier web application
 architecture in an Azure cloud environment that supports UK-OFFICIAL
 workloads. The architecture delivers a secure hybrid environment that
 extends an on-premises network to Azure allowing web based workloads
 to be accessed securely by corporate users or from the internet.

![alt text](images/diagram.png?raw=true "Azure UK-OFFICAL Three Tier Architecture")


 The components of this architecture include -

1.  **On-premises network**. A private local-area network implemented in an organization.

2.  **Production VNet**. The Production [VNet](https://docs.microsoft.com/en-us/azure/Virtual-Network/virtual-networks-overview) (Virtual Network) hosts the application and other operational resources running in Azure. Each VNet may contain several subnets which are used for isolating and managing network traffic.

3.  **Web tier.** Handles incoming HTTP requests. Responses are returned through this tier.

4.  **Business tier:** Implements business processes and other functional logic for the system.

5.  **Database tier:** Provides persistent data storage, using [SQL Server Always On Availability Groups](https://msdn.microsoft.com/en-us/library/hh510230.aspx) for high availability. Customers may wish to consider using [Azure SQL Database](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-technical-overview) as a PaaS alternative

6.  **Gateway**: The [VPN Gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) provides connectivity between the routers in the on-premises network and the Production VNet.

7.  **Internet Gateway and Public IP Address**: The internet gateway exposes application services to users through the internet. Traffic accessing these services is secured using an [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-introduction) offering Layer 7 routing and load balancing capabilities with web application firewall (WAF) protection.

8.  **Management VNet:** This [VNet](https://docs.microsoft.com/en-us/azure/Virtual-Network/virtual-networks-overviewcontains) contains resources that implement management and monitoring capabilities for the workloads running in the Production VNet.

9.  **Jumpbox.** Also, called a [bastion host](https://en.wikipedia.org/wiki/Bastion_host). A secure VM on the network that administrators use to connect to VMs in the Production VNet. The jumpbox has an NSG that allows remote traffic only from public IP addresses on a safe list. The NSG should permit remote desktop (RDP) traffic. Management of production resources is via RDP using a secured Jumpbox VM.

10. **User defined routes (UDR)**. [User defined routes](https://docs.microsoft.com/en-gb/azure/virtual-network/virtual-networks-udr-overview) are used to define the flow of IP traffic within Azure VNets.

11. **Network Peered VNETs:** The Production and Management VNets are connected using [VNet Peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)**.**
     They are still managed as separate resources, but appear as one for all connectivity purposes with virtual machines in these networks able to communicate with each other directly by using private IP addresses. VNet peering is subject to the VNets being in the same Azure Region

12. **Network Security Groups:** [NSGs](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-nsg) contain Access Control Lists that allow or Deny traffic within a VNet. NSGs can be used to secure traffic at a subnet or individual VM level.

13. **Active Directory Domain Services (AD DS):** This architecture provides a dedicated [Active Directory](https://msdn.microsoft.com/library/azure/jj156090.aspx) [Active Directory Domain Services](https://technet.microsoft.com/library/dd448614.aspx) deployment.

14. **Logging and Audit:** [Azure Activity Log](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-activity-logs) captures operations 
taken on the resources in your subscription such as who initiated the operation, when the operation occurred, the status of the operation and the values of other properties that might help you research the operation. 
Azure Activity Log is an Azure platform service that captures all actions on a subscription. Logs can be archived or exported if requried.

15. **Network Monitoring and Alerting** [Azure Network Watcher](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview) is a platform service provides network packet capture, flow logging, topology tools and diagnostics  for network traffics within your VNets. 


Guidance and Recommendations 
=============================


### Business continuity

> **High Availability:** Server workloads are grouped in a [Availability
> Set](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-manage-availability?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json)
> to ensure high availability of virtual machines in Azure. This
> configuration ensures that during a planned or unplanned maintenance
> event at least one virtual machine will be available and meet the
> 99.95% Azure SLA.

### Logging and Audit

> **Monitoring**: [Azure
> Monitor](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-get-started)
> is the platform service that provides a single source for monitoring
> the activity log, metrics, and diagnostic logs of all your Azure
> resources. Azure Monitor can be configured to visualize, query, route,
> archive, and act on the metrics and logs coming from resources in
> Azure. It is recommended that Resource Based Access Control is used to secure the audit trail to ensure that users don�t have the ability to modify the logs.
>
> **Activity Logs**: Configure [Azure Activity
> Logs](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-activity-logs)
> to provide insight into the operations that were performed on
> resources in your subscription.
>
> **Diagnostic Logs:** [Diagnostic
> Logs](https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview-of-diagnostic-logs)
> are all logs emitted by a resource. These logs could include Windows
> event system logs, blob, table, and queue logs.
>
> **Firewall Logs:** Application Gateway provides full diagnostics and
> access logs. Firewall logs are available for application gateway
> resources that have WAF enabled.
>
> **Log Archiving:** Logs storage can be configured to write to a
> centralised Azure storage account for archival and a defined retention
> period. Logs can be processed using Azure Log Analytics or by third
> party SIEM systems

### Identity 

> **Active Directory Domain Services:** This architecture delivers an
> Active Directory Domain Services deployment in Azure w For
> specific recommendations on implementing Active Directory in Azure,
> see the following articles -
>
> [Extending Active Directory Domain Services (AD DS) to
> Azure](https://docs.microsoft.com/en-gb/azure/guidance/guidance-identity-adds-extend-domain).
>
> [Guidelines for Deploying Windows Server Active Directory on Azure
> Virtual
> Machines](https://msdn.microsoft.com/library/azure/jj156090.aspx).
>
> **Active Directory Integration:** As an alternative to a dedicated AD
> DS architecture, customers may wish to use [Azure Active
> Directory](https://docs.microsoft.com/en-gb/azure/guidance/guidance-ra-identity#using-azure-active-directory)
> integration or [Active Directory in Azure joined to an on-premises
> forest](https://docs.microsoft.com/en-gb/azure/guidance/guidance-ra-identity#using-active-directory-in-azure-joined-to-an-on-premises-forest).

### Security 

> **Management Security:** This pattern allows administrators to connect
> to the management VNET and Jumpbox using RDP from a trusted source.
> Network traffic for the management VNET is controlled using NSGs to
> restrict access port 3389 to only traffic from a trusted IP range
> access to the subnet containing the Jumpbox.
>
> Customers may also consider using an [enhanced security administrative
> model](https://technet.microsoft.com/en-gb/windows-server-docs/security/securing-privileged-access/securing-privileged-access)
> to secure the environment when connecting to the Management VNET and
> Jumpbox. It is suggested that for enhanced security customers use a
> [Privileged Access
> Workstation](https://technet.microsoft.com/windows-server-docs/security/securing-privileged-access/privileged-access-workstations#what-is-a-privileged-access-workstation-paw)
> and RDGateway configuration. The use of Network Virtual Appliances and
> public/private DMZs will offer further security enhancements.
>
> **Securing the network:** [Network Security
> Groups](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-nsg)
> (NSG) are recommended for each subnet to provide a second level of
> protection against inbound traffic bypassing an incorrectly configured
> or disabled gateway. Example - [ARM Template for deploying an
> NSG](https://github.com/mspnp/template-building-blocks/tree/master/templates/buildingBlocks/networkSecurityGroups).
>
> **Securing public endpoints:** The internet gateway exposes
> application services to users through the internet. Traffic accessing
> these services is secured using an [Application
> Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-introduction)
> which provides a Web Application Firewall and HTTPS protocol
> management
>
> **IP Ranges:** The IP ranges in the architecture are suggested ranges,
> customers are advised to consider their own environment and use
> appropriate ranges.
>
> **Hybrid connectivity:** The cloud based workloads are connected to
> the on-premises datacentre through IPSEC VPN using the Azure VPN
> Gateway. Customers should ensure that they are using an appropriate
> VPN Gateway to connect to Azure. Example [VPN Gateway ARM
> Template](https://github.com/mspnp/template-building-blocks/tree/master/templates/buildingBlocks/vpn-gateway-vpn-connection)**.**
> Customers running large-scale, mission critical workloads with big data requirements may wish to consider a hybrid network architecture using
> [ExpressRoute](https://docs.microsoft.com/en-gb/azure/guidance/guidance-hybrid-network-expressroute)
> to ensure private network connectivity to Microsoft cloud services
>
> **Separation of concerns:** This pattern separates the VNets for
> Management operations and business operations. Separate VNets and
> subnets allow traffic management and traffic ingress and egress
> restriction using NSGs between network segments following [Microsoft cloud services and network security](https://docs.microsoft.com/en-gb/azure/best-practices-network-security)
> best practices.
>
> **Resource Management**: Azure resources such as VMs, VNets, and load
> balancers are managed by grouping them together into [Azure Resource
> Groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groupsresource).
> Resource Based Access Control roles can then be assigned to each
> resource group to restrict access to only authorized users.
>
> **Access control restrictions:** Use [Role-Based Access
> Control](https://docs.microsoft.com/en-gb/azure/active-directory/role-based-access-control-configure)
> (RBAC) to manage the resources in your application using [custom
> roles](https://docs.microsoft.com/en-gb/azure/active-directory/role-based-access-control-custom-roles)
>
> **Internet Access**: This pattern has utilised [Azure Application
> Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-introduction)
> as the internet facing gateway and load balancer. Some customers may
> also consider the use of third party vendor Network Virtual Appliances
> for additional layers of networking security as an alternative to the
> [Azure Application
> Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-introduction).
>
> **Azure Security Center:** The [Azure Security
> Center](https://docs.microsoft.com/en-us/azure/security-center/security-center-intro)
> provides a central view of the security status of resources in the
> subscriptions, and provides recommendations that help prevent
> compromised resources. It can enable more granular policies (for
> example, applying policies to specific resource groups that allow the
> enterprise to tailor their posture to the risk they are addressing).
> It is recommended that customers enable Azure Security Center in their
> Azure Subscription.
>
> [RBAC](https://docs.microsoft.com/en-gb/azure/active-directory/role-based-access-control-configure)
> can be used to restrict the operations that DevOps can perform on each
> tier. When granting permissions, use the [principle of least
> privilege](https://msdn.microsoft.com/library/hdb58b2f(v=vs.110).aspx#Anchor_1).
> Log all administrative operations and perform regular audits to ensure
> any configuration changes were planned.

NCSC Security Matrix Compliance
===============

 This UK-OFFICIAL Azure template aligns to the 14 cloud security
 principles are documented in the (NCSC) [Cloud Security
 Principles](https://www.ncsc.gov.uk/guidance/implementing-cloud-security-principles)
 paper to ensure an environment that supports workloads classified as
 UK-OFFICIAL.

 The following matrix provides a high level alignment of the 14 cloud security principles the Microsoft Azure security model, a detailed
 mapping of the 14 principles can be found in Microsoft's [Azure Blueprint for the UK Government](https://aka.ms/azureblueprintukg-cloud)
 whitepaper.
 
 ---

*Data in transit protection:* Consumer data transiting networks should be adequately protected against tampering and eavesdropping via 
a combination of network protection and encryption.
> Azure uses the industry-standard Transport Layer Security (TLS) 1.2 protocol with 2048-bit RSA/SHA256 encryption keys to encrypt 
communication internally and between customers and the cloud.

*Asset protection and resilience:* Consumer data, and the assets that store or process it, should be protected against physical 
tampering, loss, damage, and seizure.
> Most Azure services are deployed regionally, and customers can configure certain Azure services to store customer data only in a single region. Each facility is designed to run 24x7x365 and employs various industry-standard measures to help protect operations from power failure, physical intrusion, and network outages.
> These datacenters comply with industry standards (such as ISO 27001) for physical security and availability. They are managed, monitored, and administered by Microsoft operations personnel. Azure offers a wide range of encryption capabilities, giving customers the flexibility to choose the solution that best meets their needs. 
> When customers delete data or leave Azure, Microsoft follows strict standards for overwriting storage resources before reuse.Upon a system's end-of-life, 
> Microsoft operational personnel follow rigorous data handling procedures and hardware disposal processes to help assure that no hardware that may contain customer data is made available to untrusted parties.                                                                                                                                                                                                                                         
> To ensure data resiliency Azure asynchronously replicates data from a primary location to a secondary location within the same region.
> For applications resiliency, Microsoft Azure patterns ensure that at least one virtual machine will be available and meet the 99.95% Azure SLA.

*Separation between consumers:* Separation should exist between different consumers of the service to prevent one malicious or compromised consumer from affecting the service or data of another.
> Because all customer cloud servers are virtual, the physical separation paradigm no longer applies. 
> Microsoft Azure was designed to help identify and counter risks inherent in a multitenant environment. 
> Data storage and processing is logically segregated among consumers of Azure using Active Directory and functionality specifically
> developed for multitenant services, which aims to ensure that consumer data stored in shared Azure data centers is not accessible by 
> another organisation.

*Governance framework:* The service provider should have a security governance framework that coordinates and directs their overall 
  approach to the management of the service and information within it.
> The Microsoft compliance framework includes the following activities:
                                                                                                                                                                                                                                               
> 1.  Identify and integrate requirements
                                                                                                                                                                                                                                               
> 2.  Assess and remediate gaps.
                                                                                                                                                                                                                                               
> 3.  Test effectiveness and assess risk.
                                                                                                                                                                                                                                               
> 4.  Attain certification and attestations.
                                                                                                                                                                                                                                               
> 5.  Improve and optimize.
                                                                                                                                                                                                                                               
*Operational security:* The service provider should have processes and procedures in place to ensure the operational security of the service.
> Operational Security Assurance (OSA) is a framework that incorporates the knowledge gained through a variety of resources that are unique to Microsoft, 
> such as the Microsoft Security Response Center (MSRC), and incorporates deep awareness of the cybersecurity threat landscape. 
> OSA helps make Microsoft cloud-based services' infrastructure more resilient to attack by decreasing the amount of time needed to prevent, detect, contain 
> and respond to real and potential Internet-based security threats, thereby increasing the security of those services for customers.

*Personnel security:* Service provider staff should be subject to personnel security screening and security education appropriate for their role.
> Microsoft Azure Operations and Customer Support personnel and data center staff, who operate Azure services and provide customer support (or Microsoft subcontractors
> who assist with platform operations, troubleshooting, and technical support) undergo a Microsoft standard background (or equivalent) check to evaluate employee 
> education, employment, and criminal history. The background checks that are carried out are broadly in line with the requirements of the UK Government's 
> BPSS / BS7858. They do not specifically include a formal identity check.

*Secure development:* Services should be designed and developed to identify and mitigate threats to their security.
> The Microsoft [Security Development Lifecycle](https://www.microsoft.com/en-us/sdl/default.aspx) (SDL) provides an effective threat-modelling process to identify
>  threats and vulnerabilities in software and services. The STRIDE system (Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, and 
> Elevation of privilege) is used to help identify and resolve security threats early in the design process, before they can affect customers.

*Supply chain security:* The service provider should ensure that its supply chain satisfactorily supports all of the security principles that the service 
claims to implement.|                                                           
> In Azure, security risks that relate to external parties, such as customers and vendors, are identified and addressed as follows:
                                                                                                                                                                                                                                               
> 1.  Third parties undergo a review process and an approved vendor list is established and used. These vendors are required to comply with Microsoft security policies and are audited.
                                                                                                                                                                                                                                               
> 2.  Additional risks that relate to granting access to facilities and information systems are controlled and managed by Microsoft teams, including physical and network level access to facilities and Microsoft resources.
                                                                                                                                                                                                                                               
*Secure consumer management:* Consumers should be provided with the tools required to help them securely manage their service.
> Customers administer their Azure resources through the Azure portal, which provides access to all virtual machines, databases, cloud services, and 
> other resources configured for the customer's account. Web access to the Azure portal is secured by industry-standard Transport Layer Security (TLS) 1.2 
> connections using 2048-bit RSA/SHA256 encryption keys, as recommended by CESG/NCSC . Role-based access controls are provided to enable customers to provide 
> limited access to Azure management resources for specific users and groups.
                                                                                                                                                                                                                                               
*Identity and authentication* Access to all service interfaces (for consumers and providers) should be limited to authenticated and authorised individuals.
> Azure provides services to help track identity as well as integrate it with identity stores that may already be in use. Azure AD is a comprehensive identity and access management service for the cloud that helps secure access to data in on-premises and cloud applications.

*External interface protection:* All external or less trusted interfaces of the service should be identified and have appropriate protections to defend against 
attacks through them.
> Microsoft employs a method it calls 'Red Teaming' to improve Azure security controls and processes through regular penetration testing.

*Secure service administration:* The methods used by the service providers administrators to manage the operational service should be designed to mitigate 
any risk of exploitation that could undermine the security of the service.
> Azure infrastructure operations personnel are required to use secure admin workstations (SAWs; also known as privileged access workstations, or PAWs). The SAW approach is an extension of the well-established recommended practice to use separate admin and user accounts for administrative personnel.

*Audit information provision to consumers:* Consumers should be provided with the audit records they need to monitor access to their service and the data held within it.
> Azure Log Analytics collects records of the events occurring within an organisation's systems and networks as soon as they occur, before anyone can tamper with them, and allows different types of analysis by correlating data across multiple computers.

*Secure use of the service by the consumer:* Consumers have certain responsibilities when using a cloud service in order for this use to remain secure, and for their 
data to be adequately protected.
> Azure Security Center helps consumers prevent, detect, and respond to threats with increased visibility into and control over the security of their Azure resources. 
> It provides integrated security monitoring and policy management across Azure subscriptions, helps detect threats that might otherwise go unnoticed, 
> and works with a broad ecosystem of security solutions.


The CSA published the Cloud Control Matrix to support customers in the evaluation of cloud providers and to identify questions that should be
answered before moving to cloud services. In response, Microsoft Azure answered the CSA Consensus Assessment Initiative Questionnaire [CSA CAIQ](https://aka.ms/csacaiqresponsesto) describe how Microsoft
addresses the suggested principles.

The Crown Commercial Service (an agency that works to improve commercial and procurement activity by the government) renewed the
classification of Microsoft in-scope enterprise cloud services to  G-Cloud v6, covering all its offerings at the OFFICIAL level. Details
of Azure and G-Cloud can be found in the [Azure UK G-Cloud security assessment summary](https://www.microsoft.com/en-us/trustcenter/Compliance/UK-G-Cloud?downloadDocument=1&documentId=b4ed7712-d221-4a9c-ad0b-b36cf0d83eae).

Deployment Guide
================
These templates automatically deploy the Azure resources for a multi-tier, Windows based three tier application with an Active Directory Domain architecture. **As this is a complex deployment that delivers the full infrastructure and environment configuration
deployment can take up to two hours.** Progress can be monitored from the Resource Group blade and Deployment output blade in the Azure
Portal.

> Rather than develop the templates for this environment from scratch, some templates used are drawn from the [Microsoft Patterns and
> Practices GitHub Repository](https://github.com/mspnp) [Template
> Building Blocks](https://github.com/mspnp/template-building-blocks)
> and orchestrated through a an a master ARM template or PowerShell
> script. Other Azure architectural best practices and guidance can be
> found in [Azure Reference
> Architectures](https://docs.microsoft.com/en-gb/azure/guidance/guidance-architecture).
> Supporting Microsoft Visio templates are available from the [Microsoft
> download
> center](http://download.microsoft.com/download/1/5/6/1569703C-0A82-4A9C-8334-F13D0DF2F472/RAs.vsdx)
> with the corresponding ARM Templates found at [Azure Reference
> Architectures ARM
> Templates](https://github.com/mspnp/reference-architectures).

 As a pre-requisite to deployment users should ensure that they have -

- An Azure Subscription

- Admin or co-admin rights for the Subscription

- The Azure Subscription ID has been noted

- The [latest version of PowerShell](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/) to execute the deployment script

## Deployment and Configuration Activities

  Activity|Configuration|
  ---|---
  Create Management VNet Resource Groups|Enter resource group name during deployment
  Create Operational VNet Resource Groups|Enter resource group name during deployment
  Deploy  VNet network infrastructure|Enter resource group name during deployment
  Create VNet Peerings|None required|
  Deploy VPN Gateway|The template deploys an Azure environment with a public facing endpoint and an Azure Gateway to allow VPN setup between the Azure environment and your on-premises environment. To complete this VPN connection, you will need to provide the Local Gateway (your on-premises VPN public IP address) and complete the VPN connection set up locally. VPN Gateway requires local gateway configuration in the [/parameters/azure/ops-network.parameters.json](/parameters/azure/ops-network.parameters.json) template parameters file  or through the Azure portal.                                    
  Deploying internet facing Application Gateway|For SSL termination, Application Gateway requires you SSL certificates to be uploaded. When provisioned the Application Gateway will instantiate a public IP address and domain name to allow access to the web application
  Create Network Security Groups for VNETs|RDP access to the Management VNet Jumpbox must be secured to a trusted IP address range. It is important to amend the "sourceAddressPrefix" parameter with your own trusted source IP address range in the [/parameters/azure/nsg-rules.parameters.json](/parameters/azure/nsg-rules.parameters.json) template parameters file. NSG configuration for the operational VNet can be found at [/parameters/azure/ops-vent-nsgs.json](/parameters/azure/ops-vent-nsgs.json)
  Create ADDS resource group|Enter resource group name during deployment and edit the configuration fields if required
  Deploying ADDS servers|None required
  Updating DNS servers|None required
  Create ADDS domain|The provided templates create a demo 'treyresearch' domain. To ensure that the required Active Directory Domain is created with the desired domain name and administrative user the fields can be configured in the deployment screen or in the [/parameters/azure/add-adds-domain-controller.parameters.json](/parameters/azure/add-adds-domain-controller.parameters.json) template parameters file must be edited with the required values
  Create ADDS domain controller|None required
  Create operational workload Resource Group|Enter resource group name during deployment
  Deploy operational VM tiers and load balancers   |None required
  Set up IIS web server role for web tier|None required
  Enable Windows Auth for VMs|None required
  Deploy Microsoft Anti-malware to VMs|None required
  Domain Join VMs|Domain joining the Virtual Machines is a post deployment step and must be **manually** completed
                                                  

## Deployment Process

A deployment for this reference architecture is available on
[GitHub](https://github.com/mspnp/reference-architectures/tree/master/compliance/uk-official/three-tier-web-with-adds). The templates can be cloned or downloaded if customisation of parameters are requried.
The reference architecture is deployed in four stages. To deploy the architecture, follow these steps for each deployment stage -

For Virtual Machines The parameter files include a hard-coded
administrator user names and passwords. These values can be changed in the parameter files if required. Tt is *strongly recommended
that you immediately change both on all the VMs*. Click on each VM in the Azure portal then click on **Reset password** in the **Support
troubleshooting** blade.

## Deploy Networking Infrastructure
  
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fcompliance%2Fuk-official%2Fthree-tier-web-with-adds%2Ftemplates%2Fvirtualnetwork.azuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fcompliance%2Fuk-official%2Fthree-tier-web-with-adds%2Ftemplates%2Fvirtualnetwork.azuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

1. Click on the **Deploy to Azure** button to begin the first stage of the deployment. The link takes you to the Azure Portal.
2. Select **Create New** and enter a value such as `uk-official-networking-rg` in the **Resource group** textbox.
3. Select a region such as `UKSouth` from the **Location** drop down box (All Resource Groups required for this architecture should be in the same Azure region e.g. `UKSouth`
4. Some parameters can be edited in the deployment page. If greater customisation is requried this can be down through cloning and editing the templates directly, or in situ by editing the templates by clicking 'Edit template'.
5. Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
6. Click on the **Purchase** button.
7. Check Azure portal notification for a message that the stage of deployment is complete and move on to the next if completed.
8. If for some reason your deployment fails. To avoid incurring cost and orphan resources it is advisable to delete the resource group in its entirety, fix the issue and redeploy the resource groups and template.


## Deploy Active Directory Domain 
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fcompliance%2Fuk-official%2Fthree-tier-web-with-adds%2Ftemplates%2Faads.azuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fcompliance%2Fuk-official%2Fthree-tier-web-with-adds%2Ftemplates%2Faads.azuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>


1. Click on the **Deploy to Azure** button to begin the first stage of the deployment. The link takes you to the Azure Portal.
2. Select **Create New** and enter a value such as `uk-official-adds-rg` in the **Resource group** textbox.
3. Select a region such as `UKSouth` from the **Location** drop down box (All Resource Groups required for this architecture should be in the same Azure region e.g. `UKSouth`.
4. Some parameters can be edited in the deployment page. If greater customisation is requried this can be down through cloning and editing the templates directly, or in situ by editing the templates by clicking 'Edit template'.
5. In the **Settings** textboxes, enter the networking resource group as entered when creating the networking infrastructure in deployment step 1.
6. Enter the Domain settings and Admin credentials.
7. Review the terms and conditions, then click the **I agree to the terms and conditions stated above* checkbox.
8. Click on the **Purchase** button.
9. Check Azure portal notification for a message that the stage of deployment is complete and move on to the next if completed.
10. If for some reason your deployment fails. To avoid incurring cost and orphan resources it is advisable to delete the resource group in its entirety, fix the issue and redeploy the resource groups and template.

![alt text](images/create-official-aads-rg.JPG?raw=true "Create ADDS deployment")


## Deploy operational workload infrastructure 
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fcompliance%2Fuk-official%2Fthree-tier-web-with-adds%2Ftemplates%2Fworkloads.azuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fcompliance%2Fuk-official%2Fthree-tier-web-with-adds%2Ftemplates%2Fworkloads.azuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>


1. Click on the **Deploy to Azure** button to begin the first stage of the deployment. The link takes you to the Azure Portal.
2. Select **Create New** and enter a value such as `uk-official-operational-rg` in the **Resource group** textbox.
3. Select a region such as `UKSouth` from the **Location** drop down box (All Resource Groups required for this architecture should be in the same Azure region e.g. `UKSouth`
4. Some parameters can be edited in the deployment page. If greater customisation is requried this can be down through cloning and editing the templates directly, or in situ by editing the templates by clicking 'Edit template'.
5. In the **Settings** textboxes, enter the operational network resource group as entered when creating the networking infrastructure in deployment step 1.
6. Enter the Virtual Machine Admin credentials.
7. Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
8. Click on the **Purchase** button.
9. Check Azure portal notification for a message that the stage of deployment is complete and move on to the next if completed.
10. If for some reason your deployment fails. To avoid incurring cost and orphan resources it is advisable to delete the resource group in its entirety, fix the issue and redeploy the resource groups and template.

![alt text](images/create-official-workload-rg.JPG?raw=true "Create ADDS deployment").



##(Optional) PowerShell Deployment 

To deploy this solution through PowerShell, you will need the latest version of the Azure CLI to run the PowerShell script that deploys the solution. To deploy the reference architecture, follow these steps

1. Download or clone the solution folder from GitHub to your local machine.
2. Open the Azure CLI and navigate to the local solution folder.
3. Run the following command:  `.\Deploy-ReferenceArchitecture.ps1 <subscription id> <location> <mode>`
4. Replace `<subscription id>` with your Azure subscription ID.
5. For `<location>`, specify an Azure region, such as `UKSouth` or `UKWest`.
6. The `<mode>` parameter controls the granularity of the deployment, and can be one of the following values:
- `Infrastructure`: deploys the networking infrastructure
- `ADDS`: deploys the VMs acting as Active Directory DS servers, deploys Active Directory to these VMs, and deploys the domain in Azure.
- `Operational`: deploys the web, business and data tier VMs and load balancers
- `DeployAll`: deploys all the preceding deployments. 

UK Governments Private Network Connectivity
===========================================

Microsoft's customers are now able to use [private connections](https://news.microsoft.com/en-gb/2016/12/14/microsoft-now-offers-private-internet-connections-to-its-uk-data-centres/#sm.0001dca7sq10r1couwf4vvy9a85zx)
to the company's UK data centres. Microsoft's partners are providing a gateway from PSN/N3 to [ExpressRoute](https://azure.microsoft.com/en-us/services/expressroute/) and into Azure - just one of the new services the group has unveiled
since the company launched its [**Azure**](https://azure.microsoft.com/en-us/blog/) and Office 365 cloud offering in this country at launch (https://news.microsoft.com/en-gb/2016/09/07/not-publish-microsoft-becomes-first-company-open-data-centres-uk/). Since then, [**thousands of customers**](https://enterprise.microsoft.com/en-gb/industries/public-sector/microsoft-uk-data-centres-continue-to-build-momentum/?wt.mc_id=AID563187_QSG_1236) including the Ministry of Defence, the Met Police and parts of the NHS - have signed up to take advantage of the sites, which offer UK data residency, security and reliability.

Cost
====

Deploying this template will create one or more Azure resources. You
will be responsible for the costs generated by these resources so it is
important that you review the applicable pricing and legal terms
associated with all resources and offerings deployed as part of this
template. For cost estimates, you can use the [Azure Pricing
Calculator](https://azure.microsoft.com/en-us/pricing/calculator).

Further reading
===============

Further best practice information and recommendations for configuring and securing a multi-tier application in Azure can be found in
 [Running Windows VMs for an N-tier architecture on Azure](https://docs.microsoft.com/en-gb/azure/guidance/guidance-compute-n-tier-vm).

Best practices on Azure Network Security and a decision-making matrix can be found in [Microsoft cloud services and network
security](https://docs.microsoft.com/en-gb/azure/best-practices-network-security).
