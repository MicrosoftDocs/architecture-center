The Reliable Web App pattern has a few essential architectural elements. You need DNS to manage endpoint resolution, a web application firewall and load balancer to protect and route inbound user requests. The application platform hosts your web app code and makes calls to all the backend services through private endpoints in a virtual network. An application performance monitoring tool captures metrics and logs to understand your web app.

[![Diagram showing the Essential architectural elements of the Reliable Web App pattern.](../../../_images/reliable-web-app-architecture.svg)](../../../_images/reliable-web-app-architecture.svg#lightbox)
*Figure 1. Essential architectural elements of the Reliable Web App pattern.*

### Design the architecture

 For a higher service-level objective (SLO), you can add a second region to your web app architecture. Configure your load balancer to route traffic to the second region to support either an active-active or active-passive configuration depending on your business need. The two regions require the same services except one region has a hub virtual network that connects. Adopt a a hub-and-spoke network topology to centralize and share resources, such as a network firewall. If you have virtual machines, add a bastion host to the hub virtual network to manage them securely (*see figure 2*).

[![Diagram showing the aReliable Web App pattern with a second region and a hub-and-spoke topology.](../../../_images/reliable-web-app-architecture-plus-optional.svg)](../../../_images/reliable-web-app-architecture-plus-optional.svg#lightbox) *Figure 2. The Reliable Web App pattern with a second region and a hub-and-spoke topology.*

**Choose infrastructure reliability.** Determine how many availability zones and regions you need to meet your availability needs. Define a target SLO for your web app, such as 99.9% uptime.

Calculate the [composite SLA](/azure/well-architected/reliability/metrics#slos-and-slas) for all the services that affect the availability of your web app. Add availability zones and regions until the composite SLA meets your SLO. The Reliable Web App pattern support multiple regions for an active-active or active-passive configuration (*see figure 2*). For example, the reference implementation uses an active-passive configuration to meet an SLO of 99.9%.

Design your infrastructure to support your [recovery metrics](/azure/well-architected/reliability/metrics#recovery-metrics), such as recovery time objective (RTO) and recovery point objective (RPO). The RTO affects availability and must support your SLO. Determine a recovery point objective (RPO) and configure [data redundancy](/azure/well-architected/reliability/redundancy#data-resources) to meet the RPO.

**Choose a network topology.** Choose the right network topology for your web and networking requirements. Use a single virtual network if you have one virtual network. If you plan on adding more virtual networks, use a [hub and spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology). It provides cost, management, and security benefits with hybrid connectivity options to on-premises and virtual networks.

### Pick the right Azure services

To streamline the move to the cloud, use the platform-as-a-service (PaaS) solutions that support your current web app requirements, such as runtime, database engine, data types, and redundancy requirements.

| Architectural element | Service selection guidance |
| --- | --- |
| Identity and access management | Use [Microsoft Entra ID](/entra/identity/enterprise-apps/migration-resources) for all identity and access management needs. |
| Web application firewall | Use [Azure Web Application Firewall](/azure/web-application-firewall/overview) to secure the ingress from web app attacks. |
| Load balancer | Web applications using PaaS solutions should use Azure Front Door, Azure Application Gateway, or both based on web app architecture and requirements. Use the [load balancer decision tree](/azure/architecture/guide/technology-choices/load-balancing-overview#decision-tree-for-load-balancing-in-azure) to pick the right load balancer. |
| Application platform | Start with [Azure App Service](/azure/app-service/overview) as the default application platform, and use the [compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree) to validate your choice. |
| Application performance monitoring | Use [Application Insights](/azure/azure-monitor/app/app-insights-overview) to analyze telemetry on your application. |
| Private endpoints | Use [Azure Private Link](/azure/private-link/private-link-overview) to keep service communication with the virtual network. |
| Cache | Use [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) to support the Cache-Aside pattern. |
| Database | Use a service that allows you to keep the same database engine. Use the [data store decision tree](/azure/architecture/guide/technology-choices/data-store-decision-tree) to guide service selection. |
| Storage | Review the Azure [storage options](/azure/architecture/guide/technology-choices/storage-options) to pick the right storage solution based on your requirements. |
| Secrets manager | Use [Azure Key Vault](/azure/key-vault/general/overview) to secure all secrets. |
| Configuration storage | Use [Azure App Configuration](/azure/azure-app-configuration/overview) to store nonsecret, configuration values. |
| Network firewall | Use [Azure Firewall](/azure/firewall/overview) to control inbound and outbound traffic at the network level. |
| Bastion host | Use [Azure Bastion](/azure/bastion/bastion-overview) to securely connect to virtual machines. |
