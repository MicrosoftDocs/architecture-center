<!-- cSpell:ignore wordpress -->

This article describes a container solution for hosting a large, storage-intensive installation of WordPress on Azure. The solution maximizes scalability and security. Key components include [Azure Front Door](/azure/frontdoor/front-door-overview), [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes), and [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction).

## Architecture

:::image type="content" source="media/wordpress-aks-azure-netapp-files.png" alt-text="Architecture diagram of an AKS WordPress deployment. Azure NetApp Files stores static content. Private endpoints provide access to other services." lightbox="media/wordpress-aks-azure-netapp-files.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-wordpress-container.vsdx) of this architecture.*

> [!NOTE]
> You can extend this solution by implementing tips and recommendations that aren't specific to any particular WordPress hosting method. For general tips for deploying a WordPress installation, see [WordPress on Azure](../../guide/infrastructure/wordpress-overview.yml).

### Dataflow

- Users access the front-end website through Azure Front Door with Azure Web Application Firewall enabled.
- Azure Front Door uses an internal instance of Azure Load Balancer as the origin. The internal load balancer is a hidden component of AKS. Azure Front Door retrieves any data that isn't cached.
- The internal load balancer distributes ingress traffic to pods within AKS.
- Azure Key Vault stores secrets such as the private key, which is an X.509 certificate.
- The WordPress application uses a private endpoint to access a flexible server instance of Azure Database for MySQL. The WordPress application retrieves dynamic information from this managed database service.
- All static content is hosted in Azure NetApp Files. The solution uses the Astra Trident Container Storage Interface (CSI) driver with the Network File System (NFS) protocol.

### Components

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a fully managed Kubernetes service for deploying, managing, and scaling containerized applications. In this architecture, AKS hosts the WordPress containers and provides the orchestration platform for running the containerized WordPress application with high availability and scalability.

- [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a managed in-memory data store and caching service. In this solution, Azure Cache for Redis hosts a key-value cache that is shared among all pods and used for WordPress performance optimization plug-ins to improve response times.

- [Azure Database for MySQL - flexible server](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a managed relational database service based on the open-source MySQL database engine. In this architecture, this database stores WordPress data.

- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) is a network security service that provides enhanced DDoS mitigation features. In this architecture, DDoS Protection helps defend against DDoS attacks when combined with application-design best practices and is enabled on the perimeter network.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a modern cloud content delivery network and global load balancer. In this architecture, Azure Front Door is the public entry point into the WordPress deployment.

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is a fully managed, performance-intensive and latency-sensitive storage solution. In this solution, Azure NetApp Files hosts all the WordPress content so that all the pods have access to the shared data through high-performance file storage.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that provides a way for deployed resources to communicate with each other, the internet, and on-premises networks. In this architecture, virtual networks provide isolation and segmentation.

- [Key Vault](/azure/key-vault/general/overview) is a cloud service for securely storing and controlling access to secrets, certificates, keys, and passwords. In this architecture, Key Vault provides secrets to the AKS cluster if pods need them.

- [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) is a layer 4 load balancer that distributes inbound traffic based on rules and health probe results with low latency and high throughput. In this architecture, the load balancer distributes traffic from Azure Front Door to the ingress controller pods.

- [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) are security features that use a list of security rules to allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. In this architecture, NSG rules restrict traffic flow between the application components in the subnets.

### Alternatives

- Instead of using the Azure Cache for Redis managed service, you can use a self-hosted pod within the AKS cluster as the cache.
- Instead of using a managed storage solution like Azure NetApp Files, you can use a self-hosted solution like [Rook-Ceph storage](https://rook.io). For more information, see how to [Use Rook Ceph on Azure Kubernetes Service](https://github.com/Azure/kubernetes-volume-drivers/tree/master/rook-ceph).
- Instead of using Azure Kubernetes Service (AKS), you can use [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/overview) to host containerized WordPress workloads. Azure Container Apps is a fully managed serverless container service that may suit simpler or smaller-scale scenarios. For large, storage-intensive, and highly customizable deployments, AKS is typically preferred.

## Scenario details

This example scenario is appropriate for large, storage-intensive installations of WordPress. This deployment model can scale to meet spikes in traffic to the site.

### Potential use cases

- High-traffic blogs that use WordPress as their content management system
- Business or e-commerce websites that use WordPress

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Consider the following recommendations when you deploy this solution:

- The solution uses pods in AKS and a load balancer to distribute ingress traffic. This approach provides high availability even if there's a pod failure.
- The solution supports multiple regions, data replication, and autoscaling. The components distribute traffic to the pods. Health probes are used so that traffic is distributed only to healthy pods.
- All the networking components are fronted by Azure Front Door. This approach makes the networking resources and application resilient to issues that would otherwise disrupt traffic and affect end-user access.
- Azure Front Door is a global service that supports virtual machine scale sets that are deployed in another region.
- When you use Azure Front Door to cache all responses, you gain a small availability benefit. Specifically, when the origin doesn't respond, you can still access content. But caching doesn't provide a complete availability solution.
- To increase availability, replicate Azure NetApp Files storage between paired regions. For more information, see [Cross-region replication with Azure NetApp Files](/azure/azure-netapp-files/cross-region-replication-requirements-considerations).
- To increase Azure Database for MySQL availability, follow the [high availability options](/azure/mysql/flexible-server/concepts-high-availability) that meet your needs.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following best practices when you deploy this solution:

- Use Web Application Firewall on Azure Front Door to help protect the virtual network traffic that flows into the front-end application tier. For more information, see [Azure Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview).
- Don't allow outbound internet traffic to flow from the database tier.
- Don't allow public access to private storage, and disable public access to resources. Use private endpoints for Azure Database for MySQL, Azure Cache for Redis, Key Vault, and Azure Container Registry. For more information, see [Azure Private Link](/azure/private-link/private-link-overview).

For more information about WordPress security, see [General WordPress security and performance tips](../../guide/infrastructure/wordpress-overview.yml#general-wordpress-security-and-performance-tips) and [Azure security documentation][security].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Review the following cost considerations when you deploy this solution:

- **Traffic expectations (GB/month)**. Your traffic volume is the factor that has the greatest effect on your cost. The amount of traffic that you receive determines the number of AKS nodes that you need and the price for outbound data transfer. The traffic volume also directly correlates with the amount of data that's provided by your content delivery network, where outbound data transfer costs are cheaper.
- **Amount of hosted data**. It's important to consider the amount of data that you host, because Azure NetApp Files pricing is based on reserved capacity. To optimize costs, reserve the minimum capacity that you need for your data.
- **Write percentage**. Consider how much new data you write to your website and the cost for storing it. For multi-region deployments, the amount of new data that you write to your website correlates with the amount of data that's mirrored across your regions.
- **Static versus dynamic content**. Monitor your database storage performance and capacity to determine whether a cheaper SKU can support your site. The database stores dynamic content, and the content delivery network caches static content.
- **AKS cluster optimization**. To optimize your AKS cluster costs, follow general tips for AKS, such as guidance about Virtual Machine (VM) size and Azure reservations. For more information, see [AKS cost optimization](/azure/well-architected/services/compute/azure-kubernetes-service/azure-kubernetes-service#cost-optimization).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This scenario uses pods in AKS to host the front end. With the autoscale feature, the number of pods that run the front-end application tier can automatically scale in response to customer demand. They can also scale based on a defined schedule. For more information, see [Scaling options for applications in Azure Kubernetes Service (AKS)](/azure/aks/concepts-scale).

> [!IMPORTANT]
> For best performance, it's essential to mount a persistent volume that uses NFS protocol version 4.1. The following YAML example shows how to configure a `PersistentVolume` object for this purpose. Note the value of the `mountOptions` field.

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

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Vaclav Jirovsky](https://www.linkedin.com/in/vaclavjirovsky) | Cloud Solution Architect

Other contributors:

- Adrian Calinescu | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Product documentation:

- [What is Azure Front Door?](/azure/frontdoor/front-door-overview)
- [What is Azure Web Application Firewall?](/azure/web-application-firewall/overview)
- [What is Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction)
- [Create an NFS volume for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-create-volumes)
- [Configure Azure NetApp Files for Azure Kubernetes Service](/azure/aks/azure-netapp-files)
- [Azure Database for MySQL - Flexible Server](/azure/mysql/flexible-server/overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [About Azure Key Vault](/azure/key-vault/general/overview)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [What is Azure DDoS Protection?](/azure/ddos-protection/ddos-protection-overview)

Microsoft training modules:

- [Develop and deploy applications on Kubernetes](/training/paths/develop-deploy-applications-kubernetes)
- [Introduction to Azure NetApp Files](/training/modules/introduction-to-azure-netapp-files)
- [Load balance your web service traffic with Azure Front Door](/training/modules/create-first-azure-front-door)
- [Implement Azure Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Azure Virtual Network](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Ten design principles for Azure applications](../../guide/design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)

<!-- links -->

[security]: /azure/security
