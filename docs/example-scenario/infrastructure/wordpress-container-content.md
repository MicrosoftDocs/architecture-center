This article describes a container-based architecture for hosting a large, storage-intensive WordPress installation on Azure. Key components include [Azure Front Door](/azure/frontdoor/front-door-overview), [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks), and [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction).

## Architecture

:::image type="complex" source="media/azure-wordpress-container.svg" alt-text="Architecture diagram of an AKS WordPress deployment. Azure NetApp Files stores static content. Private endpoints provide access to other services." lightbox="media/azure-wordpress-container.svg" border="false":::
   The diagram shows a WordPress deployment architecture within Microsoft Azure inside a virtual network outlined by a dashed border. On the left, an arrow points from the public internet to Azure Front Door with Azure Web Application Firewall. An arrow points from Azure Front Door with Azure Web Application Firewall to an internal load balancer. An arrow points from the internal load balancer to ingress in the AKS section. A line labeled pod autoscaling points from ingress and splits into a double-sided arrow that points to two WordPress pods. A line points from the WordPress pods, converges, and splits to point to different private endpoints that resolve to Azure Database for MySQL flexible server and Azure Managed Redis. An arrow points from secret store Container Storage Interface (CSI) to a private endpoint that then points to Azure Key Vault. An arrow points from the AKS section to a private endpoint and then to Azure Container Registry. Another arrow points from the AKS section to Azure NetApp Files in a subnet protected by a network security group (NSG).
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-wordpress-container.vsdx) of this architecture.*

> [!NOTE]
> You can extend this solution by implementing recommendations that apply to any WordPress hosting method. For general WordPress deployment guidance, see [WordPress on Azure](../../guide/infrastructure/wordpress-overview.yml).

### Data flow

The following data flow corresponds to the previous diagram:

1. Users access the front-end website through Azure Front Door with Azure Web Application Firewall enabled.

1. Azure Front Door Premium connects to the AKS internal load balancer origin through an [Azure Private Link service](/azure/private-link/private-link-service-overview) that exposes the internal load balancer. The internal load balancer is a component of AKS. Azure Front Door retrieves data that it hasn't cached.

1. The internal load balancer distributes ingress traffic to an ingress controller within AKS. You can use the [managed NGINX ingress controller with the application routing add-on](/azure/aks/app-routing) or [Application Gateway for Containers](/azure/application-gateway/for-containers/overview) as the ingress controller.

1. Azure Key Vault stores secrets such as database passwords and Transport Layer Security (TLS) certificates, including their private keys.

1. The WordPress application uses a private endpoint to access an Azure Database for MySQL flexible server instance. The WordPress application retrieves dynamic information from this managed database service.

1. All static content is hosted in Azure NetApp Files. The solution uses the [Trident](https://docs.netapp.com/us-en/trident/index.html) Container Storage Interface (CSI) driver with the Network File System (NFS) protocol.

### Components

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service for deploying, managing, and scaling containerized applications. In this architecture, AKS hosts the WordPress containers and provides the orchestration platform for high availability and scalability.

- [Azure Managed Redis](/azure/redis/overview) is a managed in-memory data store and caching service. In this architecture, all pods share an Azure Managed Redis cache. WordPress performance optimization plugins use this cache to reduce response times.

- [Azure Database for MySQL flexible server](/azure/well-architected/service-guides/azure-database-for-mysql) is a managed relational database service based on the open-source MySQL database engine. In this architecture, this database stores WordPress data.

- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) is a network security service that provides enhanced distributed DDoS mitigation features. DDoS Protection has two tiers: [DDoS Network Protection and DDoS IP Protection](/azure/ddos-protection/ddos-protection-sku-comparison). In this architecture, DDoS Protection defends against DDoS attacks when you combine it with application-design best practices and enable it on the perimeter network.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a cloud content delivery network and global load balancer. This architecture requires the [Azure Front Door Premium tier](/azure/frontdoor/front-door-cdn-comparison) because it uses Azure Private Link to connect to the origin through a [Private Link service](/azure/private-link/private-link-service-overview) that exposes the internal load balancer. In this architecture, Azure Front Door is the public entry point into the WordPress deployment.

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is a managed, performance-intensive, and latency-sensitive storage solution. In this architecture, Azure NetApp Files hosts the WordPress content so that all pods can access the shared data through high-performance file storage.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that connects deployed resources with each other, the internet, and on-premises networks. In this architecture, virtual networks provide isolation and segmentation.

- [Key Vault](/azure/key-vault/general/overview) is a cloud service that stores and controls access to secrets, certificates, keys, and passwords. In this architecture, Key Vault stores secrets such as database credentials and TLS certificates that pods retrieve at runtime.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a layer-4 load balancer that distributes inbound traffic based on rules and health probe results. In this architecture, an internal load balancer sits behind a [Private Link service](/azure/private-link/private-link-service-overview), which enables Azure Front Door Premium to reach the origin privately. The internal load balancer then distributes traffic to the ingress controller pods.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed container image registry service. In this architecture, Container Registry stores the WordPress container images and makes them available to the AKS cluster through a private endpoint.

- [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) are security features that use security rules to allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. In this architecture, NSG rules restrict traffic flow between the application components in the subnets.

### Alternatives

- Use a self-hosted Redis pod within the AKS cluster as the cache instead of the Azure Managed Redis managed service.

- Use a self-hosted solution like [Rook-Ceph storage](https://rook.io) instead of a managed storage solution like Azure NetApp Files. A self-hosted storage solution increases operational complexity and requires your team to manage the storage layer directly. Evaluate whether the operational overhead is acceptable for your organization before you choose this approach.

- Use [Azure Container Apps](/azure/container-apps/overview) to host containerized WordPress workloads instead of AKS. Container Apps is a managed serverless container service that suits simpler or smaller-scale scenarios. For large, storage-intensive, and highly customizable deployments, use AKS.

## Scenario details

This example scenario works best for large, storage-intensive installations of WordPress. This deployment model scales to meet spikes in traffic to the site.

### Potential use cases

- High-traffic blogs that use WordPress as their content management system
- Business or e-commerce websites that use WordPress

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Consider the following recommendations when you deploy this solution:

- Use pods in AKS and a load balancer to distribute ingress traffic. This approach provides high availability even if a pod failure occurs.

- Place all networking components behind Azure Front Door. This approach provides resilience against problems that can disrupt traffic and affect user access.

- Enable caching in Azure Front Door. When the origin isn't available, Azure Front Door can continue to serve cached content. Caching alone doesn't provide a complete availability solution.

- Replicate Azure NetApp Files storage between paired regions to increase availability. For more information, see [Azure NetApp Files replication](/azure/azure-netapp-files/replication).

- Implement [high availability options](/azure/mysql/flexible-server/concepts-high-availability) that meet your needs to increase Azure Database for MySQL availability.

- The architecture supports multiregion deployment, data replication, and autoscaling. Health probes ensure that only healthy pods receive traffic.

- Azure Front Door is a global service that can route traffic to origins in multiple regions.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following best practices when you deploy this solution:

- Use Azure Web Application Firewall on Azure Front Door to help protect virtual network traffic that flows into the front-end application tier. For more information, see [Azure Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview).

- Block outbound internet traffic from the database tier.

- Block public access to private storage, and turn off public access to resources. Use private endpoints for Azure Database for MySQL, Azure Managed Redis, Key Vault, and Container Registry. For more information, see [Private Link](/azure/private-link/private-link-overview).

For more information, see [General WordPress security and performance tips](../../guide/infrastructure/wordpress-overview.yml#general-wordpress-security-and-performance-tips) and [Azure security documentation](/azure/security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Review the following cost considerations when you deploy this solution:

- **Traffic expectations in GB per month:** Your traffic volume has the greatest effect on your cost. The traffic that you receive determines the number of AKS nodes required and the price for outbound data transfer. The traffic volume also directly correlates with the data that your content delivery network provides, where outbound data transfer costs are lower.

- **Hosted data:** Consider the data that you host, because Azure NetApp Files pricing depends on reserved capacity. To optimize costs, reserve the minimum capacity required for your data.

- **Write percentage:** Consider how much new data you write to your website and the cost to store it. For multiregion deployments, the new data that you write to your website correlates with the data mirrored across your regions.

- **Static versus dynamic content:** Monitor your database storage performance and capacity to determine whether a lower-cost SKU supports your site. The database stores dynamic content, and the content delivery network caches static content.

- **AKS cluster optimization:** Follow general guidance for AKS, such as guidance about virtual machine size and Azure reservations, to optimize your AKS cluster costs. For more information, see [AKS Cost Optimization](/azure/well-architected/service-guides/azure-kubernetes-service#cost-optimization).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Consider the following recommendations when you deploy this solution:

- Enable [Kubernetes monitoring in Azure Monitor](/azure/azure-monitor/containers/kubernetes-monitoring-enable) for the AKS cluster, including Managed Prometheus metrics and container logging. Configure alerts for node and pod resource utilization so that you can respond to problems before they affect users.

- Store your Kubernetes manifests, Helm charts, and infrastructure as code (IaC) templates in a version control system. Use a continuous integration and continuous deployment (CI/CD) pipeline to deploy changes to your AKS cluster to reduce manual errors and ensure repeatable deployments.

- Use [AKS node image upgrades](/azure/aks/upgrade-node-image) and regular Kubernetes version upgrades to remain current with security patches and bug fixes.

- Use [Azure Policy for AKS](/azure/aks/policy-reference) to enforce organizational standards across your clusters, such as requiring private registries or restricting privileged containers.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This scenario uses pods in AKS to host the front end. The autoscale feature enables the number of pods that run the front-end application tier to automatically scale based on customer demand. Pods can also scale based on a schedule. For more information, see [Scaling options for applications in AKS](/azure/aks/concepts-scale).

> [!IMPORTANT]
> For best performance, mount a persistent volume that uses the NFS protocol version 4.1. The following YAML example shows how to configure a `PersistentVolume` object for this purpose. The `mountOptions` field specifies NFS version 4.1.

  ```yaml
  kind: PersistentVolume
  ...
      accessModes:
      - ReadWriteMany
      mountOptions:
      - vers=4.1
      nfs:
        server: xx.xx.xx.xx
  ```

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Vaclav Jirovsky](https://www.linkedin.com/in/vaclavjirovsky) | Cloud Solution Architect

Other contributors:

- Adrian Calinescu | Senior Cloud Solution Architect
- [Andrew Cardy](https://www.linkedin.com/in/andrewcardy/) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Product documentation:

- [Azure Front Door overview](/azure/frontdoor/front-door-overview)
- [Azure Web Application Firewall overview](/azure/web-application-firewall/overview)
- [Azure NetApp Files overview](/azure/azure-netapp-files/azure-netapp-files-introduction)
- [Create an NFS volume for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-create-volumes)
- [Configure Azure NetApp Files for AKS](/azure/aks/azure-netapp-files)
- [Azure Database for MySQL flexible server](/azure/mysql/flexible-server/overview)
- [Virtual Network overview](/azure/virtual-network/virtual-networks-overview)
- [Key Vault overview](/azure/key-vault/general/overview)
- [Load Balancer overview](/azure/load-balancer/load-balancer-overview)
- [DDoS Protection overview](/azure/ddos-protection/ddos-protection-overview)

Microsoft training modules:

- [Develop and deploy applications on Kubernetes](/training/paths/develop-deploy-applications-kubernetes)
- [Introduction to Azure NetApp Files](/training/modules/introduction-to-azure-netapp-files)
- [Implement Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Virtual Network](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Design principles for Azure applications](../../guide/design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)
