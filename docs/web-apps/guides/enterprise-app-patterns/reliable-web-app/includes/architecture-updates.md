---
author: claytonsiemens77
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
The Reliable Web App pattern has a few essential architectural elements. You need Domain Name System (DNS) to manage endpoint resolution, a web application firewall to block malicious HTTP traffic, and a load balancer to route and help protect inbound user requests. The application platform hosts your web app code and calls the back-end services through private endpoints in a virtual network. An application performance monitoring tool captures metrics and logs to help you understand your web app.

:::image type="complex" border="false" source="../../../_images/reliable-web-app-architecture.svg" alt-text="Diagram that shows the essential architectural elements of the Reliable Web App pattern." lightbox="../../../_images/reliable-web-app-architecture.svg":::
   In the diagram, users connect through DNS, which resolves the endpoint to a public IP address. Traffic first passes through a web application firewall that inspects and blocks malicious HTTP requests. A load balancer distributes incoming requests to the web application platform, which hosts the web app code. The web app communicates with back-end services such as databases, storage, and APIs by using private endpoints within a virtual network to ensure secure internal-only access. Application performance monitoring tools collect metrics and logs from the web app for observability. The diagram highlights the separation of public and private network boundaries, the use of security controls at each layer, and the flow of user requests from the internet to the application and its back-end services.
:::image-end:::

### Design the architecture

Design your infrastructure to support your [recovery metrics](/azure/well-architected/reliability/metrics), like your recovery time objective (RTO) and recovery point objective (RPO). The RTO affects availability and must support your SLO. Determine an RPO and configure [data redundancy](/azure/well-architected/reliability/redundancy) to meet the RPO.

- *Choose infrastructure reliability.* Determine the number of availability zones and regions that you need to meet your availability requirements. Add availability zones and regions until the composite SLA meets your SLO. The Reliable Web App pattern supports multiple regions for an active-active or active-passive configuration. For example, the reference implementation uses an active-passive configuration to meet an SLO of 99.9%.

  For a multiregion web app, configure your load balancer to route traffic to the second region to support either an active-active or active-passive configuration, depending on your business need. The two regions require the same services. But one region has a hub virtual network that connects the regions. Adopt a hub-and-spoke network topology to centralize and share resources, such as a network firewall. If you have virtual machines (VMs), add a bastion host to the hub virtual network to manage them with enhanced security.

  :::image type="complex" border="false" source="../../../_images/reliable-web-app-architecture-plus-optional.svg" alt-text="Diagram that shows the Reliable Web App pattern with a second region and a hub-and-spoke topology." lightbox="../../../_images/reliable-web-app-architecture-plus-optional.svg":::
    Diagram that shows the Reliable Web App pattern extended for multiregion deployment with a hub and spoke network topology. The architecture includes two Azure regions, each with its own set of web app resources and back-end services. User requests are resolved by DNS and enter through a global load balancer, which directs traffic to the primary or secondary region based on availability. Each region contains a web application firewall and a load balancer that protect and distribute requests to the web application platform. The web apps in both regions connect to back-end services such as databases and storage by using private endpoints within their respective virtual networks. The hub virtual network, present in one region, contains shared resources like a network firewall and a bastion host for secure management of VMs. Spoke virtual networks host the application and data services and are connected to the hub for centralized security and management. The diagram illustrates the flow of user requests, the separation of public and private network boundaries, the use of security controls, and the redundancy provided by deploying resources across multiple regions.
  :::image-end:::

- *Select a network topology.* Choose the right network topology for your web and networking requirements. If you plan to use multiple virtual networks, use a [hub-and-spoke network topology](/azure/architecture/networking/architecture/hub-spoke). It provides cost, management, and security benefits and hybrid connectivity options to on-premises and virtual networks.
