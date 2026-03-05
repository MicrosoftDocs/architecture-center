Teams that manage workloads often rely on fully qualified domain names (FQDNs) for customer access. FQDNs are typically combined with Transport Layer Security (TLS) Server Name Indication (SNI). With this approach, when public customers access a workload from the public internet or enterprise customers access a workload internally, the routing to the application might follow fixed paths and have various levels of security or quality of service (QoS).

The following architecture demonstrates an approach to differentiate how traffic is treated based on the Domain Name System (DNS) and whether the customer originates from the internet or from a corporate network.

## Architecture

:::image type="content" source="./media/split-brain-dns.svg" alt-text="Diagram of the application hosting architecture." border="false" lightbox="./media/split-brain-dns.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/split-brain-dns.vsdx) of this architecture.*

The following workflow sections describe two configurations: a public internet workflow and a private workflow. Combine the two workflows to implement a split-brain hosting architecture.

### Public internet workflow

:::image type="content" source="./media/split-brain-dns-host-public.svg" alt-text="Diagram of the public internet workflow." border="false" lightbox="./media/split-brain-dns-host-public.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/split-brain-dns-host-public.vsdx) of this architecture.*

1. Customers send a request for the `app.contoso.com` application via the public internet.

1. An [Azure DNS zone](/azure/dns/dns-zones-records) is configured for the *contoso.com* domain. The appropriate [canonical name (CNAME) entries](/azure/frontdoor/front-door-custom-domain#create-a-cname-dns-record) are configured for the Azure Front Door endpoints.
1. External customers access the web application via Azure Front Door, which functions as a global load balancer and a web application firewall (WAF).

   - Within Azure Front Door, `app.contoso.com` is assigned as the FQDN via routes on a configured endpoint. Azure Front Door also hosts the TLS SNI certificates for the applications.

     > [!NOTE]
     > Azure Front Door doesn't support self-signed certificates.

   - Azure Front Door routes the requests to the configured origin group based on the customer's `Host` HTTP header.
   - The origin group is configured to point to the Azure Application Gateway instance via Application Gateway's public IP address.
1. A [network security group (NSG)](/azure/application-gateway/configuration-infrastructure#network-security-groups) is configured on the *AppGW subnet* to allow inbound access on port 80 and port 443 from the *AzureFrontDoor.Backend* service tag. The NSG doesn't allow inbound traffic on port 80 and port 443 from the internet service tag.

   > [!NOTE]
   > The *AzureFrontDoor.Backend* service tag doesn't limit traffic solely to *your* instance of Azure Front Door. Validation occurs at the next stage.

1. The Application Gateway instance has a [listener](/azure/application-gateway/configuration-listeners) on port 443. Traffic is routed to the back end based on the hostname that's specified within the listener.
   - To ensure that traffic originates from *your* Azure Front Door profile, configure a [custom WAF rule](/azure/web-application-firewall/ag/create-custom-waf-rules#example-7) to check the `X-Azure-FDID` header value.
   
   - Azure generates a unique identifier for each Azure Front Door profile. The unique identifier is the *Front Door ID* value located on the overview page of the Azure portal.
1. Traffic reaches the compute resource that's configured as a back-end pool in Application Gateway.

### Private enterprise workflow

:::image type="content" source="./media/split-brain-dns-host-private.svg" alt-text="Diagram of the private enterprise workflow." border="false" lightbox="./media/split-brain-dns-host-private.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/split-brain-dns-host-private.vsdx) of this architecture.*

1. Customers initiate a request for the `app.contoso.com` application from an on-premises environment.

1. Application FQDNs are configured on the on-premises DNS provider. This DNS provider can be on-premises Windows Server Active Directory DNS servers or other partner solutions. The DNS entries for each of the application FQDNs are configured to point to the private IP address of the Application Gateway instance.
1. An [Azure ExpressRoute circuit](/azure/expressroute/expressroute-circuit-peerings) or a [site-to-site VPN](/azure/vpn-gateway/design#s2smulti) facilitates access to Application Gateway.
1. An [NSG](/azure/application-gateway/configuration-infrastructure#network-security-groups) is configured on the *AppGW subnet* to allow incoming private requests from on-premises customer networks where traffic originates from. This configuration ensures that other sources of private traffic can't directly reach the private IP address of Application Gateway.
1. Application Gateway has a [listener](/azure/application-gateway/configuration-listeners) that's configured on port 80 and port 443. Traffic is routed to the back end based on the hostname that's specified within the listener.
1. Only private network traffic reaches the compute that's configured as a back-end pool in Application Gateway.

### Components

- DNS: For a public internet workflow, you must configure a [public Azure DNS zone](/azure/dns/dns-overview) with the proper CNAME of the Azure Front Door endpoint FQDN. On the private (enterprise) side, configure the local DNS provider (Windows Server Active Directory DNS or a partner solution) to point each application FQDN to the private IP address of Application Gateway.

- [Azure DNS Private Resolver](/azure/architecture/networking/architecture/azure-dns-private-resolver): You can use DNS Private Resolver for the resolution of on-premises customers. Enterprise customers can use this split-brain DNS solution to gain access to applications without traversing the public internet.
- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door): Azure Front Door is a global load balancer and WAF that provides fast and secure web application delivery to customers around the world. In this architecture, Azure Front Door routes external customers to the Application Gateway instance and provides caching and optimization options to enhance customer experience.
- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway): Application Gateway is a regional load balancer and WAF that provides high availability, scalability, and security for web applications. In this architecture, Application Gateway routes external and internal customer requests to the back-end compute and protects the web application from common web attacks.

  Both Azure Front Door and Application Gateway provide WAF capabilities, but the private workflow in this solution doesn't use Azure Front Door. Therefore, both architectures use the WAF functionality of Application Gateway.
- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute): You can use ExpressRoute to extend your on-premises networks to the Microsoft Cloud via a private connection, with the help of a connectivity provider. In this architecture, you can use ExpressRoute to facilitate private connectivity to Application Gateway for on-premises customers.
  
### Alternatives

As an alternative solution, you can remove Azure Front Door and instead point the public Azure DNS record to the public IP address of Application Gateway. Based on this architecture's requirements, you must do [caching and optimization](/azure/frontdoor/front-door-caching) at the entry point into Azure. Therefore, the alternative solution isn't an option for this scenario. For more information, see [Cost optimization](#cost-optimization).

:::image type="content" source="./media/split-brain-dns-host-public-alt.svg" alt-text="Diagram of the alternate split-brain DNS hosting architecture." border="false" lightbox="./media/split-brain-dns-host-public-alt.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/split-brain-dns-host-public-alt.vsdx) of this architecture.*

Other possible alternatives for the public ingress traffic in this architecture include:

- [Azure Traffic Manager](/azure/well-architected/service-guides/traffic-manager/reliability): Traffic Manager is a DNS-based traffic routing service that distributes traffic across various regions and endpoints. You can use Traffic Manager instead of Azure Front Door to route external customers to the closest Application Gateway instance. However, Azure Front Door provides features, such as WAF capabilities, caching, and session affinity. Traffic Manager doesn't provide these features.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability): Azure Load Balancer is a network load balancer that provides high availability and scalability for Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) traffic. You can use Load Balancer instead of Application Gateway to route external and internal customer requests to back-end web servers. However, Application Gateway provides features, such as WAF capabilities, Secure Sockets Layer (SSL) termination, and cookie-based session affinity. Load Balancer doesn't provide these features.

## Scenario details

This scenario solves the problem of hosting a web application that serves both external and internal customers. This architecture ensures that traffic follows an appropriate path based on a customer's origin. This architecture:

- Provides fast and reliable access over the internet to a web application for non-enterprise customers around the world.

- Provides enterprise customers the ability to access an application without traversing the public internet.
- Protects a web application from common web attacks and malicious traffic.

### Potential use cases

Use this architecture for scenarios that require:

- **Split-brain DNS**: This solution uses Azure Front Door for external customers and Application Gateway for internal customers, with different DNS records for each service. This approach helps optimize network performance, security, and availability for various customers.

- **Application scalability**: This solution uses Application Gateway, which can distribute traffic among configured back-end compute resources. This approach helps improve application performance and availability and support horizontal scaling.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

   - **Identify failure points**: In this split-brain DNS architecture, reliability hinges on the correct functioning of key components, such as Azure Front Door, Application Gateway, and DNS configurations. You must identify potential failure points, such as misconfigurations, SSL certificate problems, or capacity overloads.
   
   - **Assess impact**: You must assess the impact of failures. For external customers, any disruption to Azure Front Door, which serves as a gateway, could affect global access. For internal customers, any disruption to Application Gateway could impede enterprise operations.
   - **Implement mitigation strategies**: To mitigate risks, implement redundancy across [multiple availability zones](/azure/reliability/availability-zones-overview), use [health probes](/azure/frontdoor/health-probes) for real-time monitoring, and ensure the correct configuration of DNS routing for both external and internal traffic. Ensure that you regularly update DNS records and have a disaster recovery plan.
   - **Monitor continuously**: To keep a vigilant eye on your system's health, employ [Azure Monitor features](/azure/azure-monitor/logs/log-analytics-overview). [Set up alerts](/azure/azure-monitor/alerts/alerts-overview) for anomalies and have an incident response plan ready to promptly address potential problems.

Adhere to these principles to ensure a robust and reliable system that can withstand challenges and maintain service continuity.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

   - **Use the Zero Trust approach**: In the split-brain DNS setup, apply the [Zero Trust](/azure/security/fundamentals/zero-trust) approach. Explicitly verify the identity of a customer, whether they originate from the internet or a corporate network. This approach ensures that only trusted entities do authorized actions.
   
   - **Implementation**: Implement Microsoft Entra ID for robust identity management. Use Microsoft Entra Conditional Access policies to enforce strict access controls based on customer context, device health, and location.
   - **Assess security efficacy**: Evaluate the effectiveness of the security measures for your dual-access workload by implementing:
      - **Defensive investments**: Regularly assess the effectiveness of Azure Front Door and Application Gateway. Ensure that they provide meaningful protection against threats.
      
      - **Blast-radius restriction**: Ensure that you contain security breaches within a limited scope. For example, effectively isolate external and internal traffic flows.
   - **Assume a breach**: Acknowledge that attackers can breach security controls. Prepare for such scenarios.
   - **Implement security measures**: Implement network segmentation, micro-segmentation, and NSGs. Assume that an attacker might gain access, and design compensating controls accordingly.

Integrate these security principles into your split-brain DNS architecture to create a robust and resilient system that safeguards internal and external access to your workload.

#### Other security enhancements

  - **Application Gateway**: You can use a [WAF](/azure/web-application-firewall/ag/ag-overview) on Application Gateway to protect your web applications from common web vulnerabilities and exploits. You can also use [Azure Private Link](/azure/application-gateway/private-link) to securely access your back-end application servers from Application Gateway without exposing them to the public internet.
  
   - **Azure Firewall**: You can add an Azure firewall to the hub virtual network and use [Azure Firewall threat intelligence](/azure/firewall/threat-intel) to block malicious traffic from known malicious IP addresses and domains. You can also use [Azure Firewall as a DNS proxy](/azure/firewall/dns-details) to intercept and inspect DNS traffic and apply DNS-filtering rules. 
   - **Azure Front Door**: You can use [Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview) to protect your web applications from common web vulnerabilities and exploits at the edge. You can also use [Private Link](/azure/frontdoor/private-link) with the Azure Front Door Premium tier to securely access your back-end application servers from Azure Front Door without exposing them to the public internet.    

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

  - **Back-end compute**: Many factors, such as SKU selection, replica count, and region, drive the cost of running back-end compute services. Ensure that you consider all elements of a [compute resource](/azure/architecture/guide/technology-choices/compute-decision-tree#choose-a-candidate-service) before you select the best option for your workload.
  
  - **Application Gateway**: Application Gateway costs depend on the number of instances, the size of instances, and the amount of processed data. You can optimize cost by using [autoscaling](/azure/application-gateway/application-gateway-autoscaling-zone-redundant) to adjust the number of instances based on traffic demand. You can also deploy [zone-redundant SKUs](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#autoscaling-and-high-availability) across availability zones to reduce the need for additional instances for high availability. 
  - **Azure Front Door**: Azure Front Door costs depend on the number of routing rules, the number of HTTP or HTTPS requests, and the amount of transferred data. You can use [Azure Front Door Standard tier or Premium tier](/azure/frontdoor/understanding-pricing) to get a unified experience with Azure Content Delivery Network, Azure Web Application Firewall, and Private Link. You can also use [the Azure Front Door rules engine feature](/azure/frontdoor/front-door-rules-engine) to customize traffic management and optimize performance and cost.
  
    If your scenario doesn't require global access or the extra features of Azure Front Door, you can use this solution with only Application Gateway. You can point all public DNS records to the public IP address that's configured on the Application Gateway listeners.

See [an example of this solution](https://azure.com/e/e0b74472f72d48ce891b08b3af105872) that approximates the typical usage of the components in this architecture. Adjust the costs to fit your scenario.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

- [Troy Hite](https://www.linkedin.com/in/digitalbydesign) | Senior Cloud Solution Architect

Other contributors:

- [Mays Algebary](https://www.linkedin.com/in/maysalgebary) | Senior Azure Networking Global Blackbelt
- [Adam Torkar](https://www.linkedin.com/in/at-10993764) | Senior Azure Networking Global Blackbelt
- [Michael McKechney](https://www.linkedin.com/in/michaelmckechney/) | Principal Azure Technology Specialist
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Application Gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure)
- [End-to-end TLS with Azure Front Door](/azure/frontdoor/end-to-end-tls)
- [Add a custom domain to Azure Front Door](/azure/frontdoor/front-door-custom-domain)
- [What is geo-filtering on a domain for Azure Front Door](/azure/web-application-firewall/afds/waf-front-door-geo-filtering)
 
## Related resources

- [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.yml#architecture-2)
- [Use Azure Front Door in a multitenant solution](../../guide/multitenant/service/front-door.md)
