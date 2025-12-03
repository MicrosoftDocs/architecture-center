---
title: N-tier Architecture Style
description: Learn about the benefits, challenges, and best practices for N-tier architectures on Azure, which separates an app into logical layers and physical tiers.
author: claytonsiemens77
ms.author: pnp
ms.date: 08/15/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-web
---

# N-tier architecture style

An N-tier architecture divides an application into **logical layers** and **physical tiers**.

:::image type="complex" source="./images/n-tier-logical.svg" border="false" lightbox="./images/n-tier-logical.svg" alt-text="Logical diagram that shows an N-tier architecture style.":::
The diagram starts with a client, then goes to a web application firewall (WAF), and then to the web tier. From the web tier, one flow goes to middle tier 1 and another flow goes to messaging and then middle tier 2. From middle tier 1, one flow goes to remote service and another flow goes to the data tier. From middle tier 2, the flow goes to the data tier. From the data tier, both flows reverse through cache, then back to middle tier 1 and 2 respectively.
:::image-end:::

Layers separate responsibilities and manage dependencies. Each layer has a specific responsibility. A higher layer can use services in a lower layer, but a lower layer can't use services in a higher layer.

Tiers are physically separated and run on separate machines. Contractually, the tier can have strict or relaxed communication models. In the strict model, a request must go through adjacent tiers, one by one, and can't skip any tier in between. For example, a request travels from the web application firewall (WAF) to the web tier, then to middle tier 1, and continues on. In contrast, the relaxed approach allows requests to skip some tiers if necessary. The strict approach has greater latency and overhead. The relaxed approach has more couplings, which makes changes more difficult. You can also combine both approaches in the same system.

A tier can call to another tier directly, or use [asynchronous messaging patterns](/azure/service-bus-messaging/service-bus-async-messaging) through a message queue. You might host each layer in its own tier, but this approach isn't required. You can host several layers on the same tier. Physical separation of tiers improves scalability and resiliency but also adds latency from the extra network communication.

A traditional three-tier application has a presentation tier, an optional middle tier, and a database tier. More complex applications can have more than three tiers. The previous diagram shows an application with two middle tiers that encapsulate different areas of functionality.

An N-tier application can have a **closed layer architecture** or an **open layer architecture**:

- In a closed layer architecture, a layer can only call the next layer immediately down.
- In an open layer architecture, a layer can call any layers under it.

A closed layer architecture limits the dependencies between layers. But this architecture might create unnecessary network traffic if one layer only passes requests along to the next layer.

## When to use this architecture

Consider an N-tier architecture for the following scenarios:

- Support architectural requirements that are still evolving.
- Migrate an on-premises application to Azure with minimal changes.
- Develop applications that span both on-premises and cloud environments.

N-tier architectures are common in traditional on-premises systems, which makes them a natural fit for transitioning existing workloads to Azure.

Implement N-tier architectures effectively by using managed services that provide scalability, reliability, and reduced operational overhead or virtual machines (VMs). These workloads often benefit from also using managed solutions for key components such as caching, messaging, and data storage.

## Benefits

- Portable across cloud and on-premises, and between cloud platforms
- Requires less learning curve for most developers
- Costs relatively little by not rearchitecting the solution
- Follows a natural evolution from the traditional application model
- Supports mixed environments that include Windows and Linux

## Challenges

- A middle tier might only perform basic create, read, update, delete (CRUD) operations, which adds latency and complexity without delivering meaningful value.
- Monolithic design prevents independent deployment of features.
- Large systems can make network security difficult to manage.
- User requests and data that move through multiple tiers make testing and monitoring more difficult.

## Best practices

- Use autoscaling to handle changes in load. For more information, see [Autoscaling best practices][autoscaling].
- Use [asynchronous messaging](/azure/service-bus-messaging/service-bus-async-messaging) to decouple tiers.
- Cache data that doesn't change often. For more information, see [Caching best practices][caching].
- Configure the database tier for high availability by using a solution such as [SQL Server Always On availability groups][sql-always-on].
- Place a WAF between the front end and the internet.
- Place each tier in its own subnet, and use subnets as a security boundary.
- Restrict access to the data tier by allowing requests from a middle tier only.

## N-tier architecture on VMs

This section describes an N-tier architecture that runs on VMs.

> [!NOTE]
> Use VMs to host an N-teir architecture if you plan to migrate an existing application to Azure with minimal refactoring. Otherwise, consider using [managed services to implement the architecture](/azure/app-service/tutorial-secure-ntier-app), such as Azure App Service or Azure Container Apps.

:::image type="complex" source="./images/n-tier-physical-bastion.png" border="false" lightbox="./images/n-tier-physical-bastion.png" alt-text="Diagram that shows an N-tier architecture.":::
The flow begins with the internet, which connects to a load balancer that routes incoming traffic to two network virtual appliances (NVAs) located in the perimeter network. Traffic then passes through another load balancer to reach multiple VMs in the web tier. A third load balancer forwards traffic from the web tier to the business tier, which includes multiple VMs. The business tier connects through a fourth load balancer to the data tier, which includes a primary and secondary SQL Server. For secure administrative access, DevOps personnel use the Azure portal to connect to an Azure Bastion host located in the AzureBastionSubnet. The perimeter network, all tiers, and the AzureBastionSubnet reside in a virtual network.
:::image-end:::

Each tier consists of a virtual machine scale set that has two or more VMs. Multiple VMs provide resiliency if one VM fails. Load balancers distribute requests across the VMs in a tier. You can scale a tier horizontally by adding more VMs to the pool.

Each tier is also placed inside its own subnet, which means that their internal IP addresses fall within the same address range. This approach makes it easy to apply network security group rules and route tables to individual tiers.

The web and business tiers are stateless. Any VM can handle any request for that tier. The data tier should consist of a replicated database. Where possible, use a managed database, but you can also host databases on VMs hosted databases. For Windows, we recommend [SQL Server](/azure/azure-sql/virtual-machines/) with Always On availability groups for high availability. For Linux, choose a database that supports replication, such as Apache Cassandra.

Network security groups restrict access to each tier. For example, the database tier only allows access from the business tier.

> [!NOTE]
> The layer labeled **Business tier** in the reference diagram refers to the business logic tier. The presentation tier is labeled **Web tier**. The example shows a web application, but you can also use multi-tier architectures for other topologies, like desktop apps. Use clear, descriptive names for each tier that your team understands. You can also use these names in your Azure resources, for example, `vmss-appname-business-tier`.

### Other considerations

- N-tier architectures aren't restricted to three tiers. More complex applications often have more tiers. In that case, consider using layer-7 routing to route requests to a particular tier.

- Tiers create boundaries for scalability, reliability, and security. Consider having separate tiers for services with different requirements in those areas.

- Use virtual machine scale sets for [autoscaling][autoscaling].

- Find places in the architecture where you can use a managed service without significant refactoring. In particular, consider caching, messaging, storage, and databases.

- Place a perimeter network (also known as *DMZ*, *demilitarized zone*, and *screened subnet*) in front of the application for higher security. The perimeter network includes network virtual appliances (NVAs) that implement security functionality such as firewalls and packet inspection. For more information, see [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz).

- Use two or more NVAs in a virtual machine scale set, with an external load balancer to distribute internet requests across the instances for high availability. For more information, see [Deploy highly available NVAs][ha-nva].

- Block direct Remote Desktop Protocol (RDP) or Secure Shell (SSH) access to VMs that run application code. Instead, use Azure Bastion to securely connect to VMs via private IP addresses, which provides RDP and SSH connectivity. For more information, see [Azure Bastion overview](/azure/bastion/bastion-overview).

- Extend the Azure virtual network to your on-premises network by using a site-to-site virtual private network (VPN) or Azure ExpressRoute. For more information, see [Hybrid network reference architecture][hybrid-network].

## Next step

- [Create a secure N-tier app in App Service](/azure/app-service/tutorial-secure-ntier-app)

## Related resource

- [Messaging in an N-tier architecture style on Azure](https://docs.particular.net/architecture/azure/n-tier)

[autoscaling]: ../../best-practices/auto-scaling.md
[caching]: ../../best-practices/caching.yml
[ha-nva]: ../../networking/guide/network-virtual-appliance-high-availability.md
[hybrid-network]: ../../reference-architectures/hybrid-networking/index.yml
[sql-always-on]: /sql/database-engine/availability-groups/windows/always-on-availability-groups-sql-server
