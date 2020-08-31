---
title: Magento e-commerce platform in Azure
titleSuffix: Azure Reference Architectures
description: See a reference architecture for deploying Magento e-commerce platform to Azure Kubernetes Service (AKS), and considerations for hosting Magento on Azure.
author: GitHubAlias
ms.date: 09/01/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom: - fcp
---

# Magento in Azure

Magento is an open-source e-commerce platform written in PHP. This reference architecture shows Magento deployed to Azure Kubernetes Service (AKS), and describes common best practices for hosting Magento on Azure.

![Diagram showing Magento deployed in Azure Kubernetes Service with other Azure components.](./_images/magento-architecture.png)

## Architecture

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) is responsible for deploying the Kubernetes cluster. AKS deploys Varnish, Magento, and [Elasticsearch](https://www.elastic.co/elasticsearch/) as different *Pods*.
- AKS creates a [virtual network](https://azure.microsoft.com/services/virtual-network/) to deploy the agent nodes into. Create the virtual network first to set up subnet configuration, private link, and egress restriction.
- [Varnish](https://varnish-cache.org/intro/index.html#intro) cache accelerator acts as a full-page cache.
- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql/) stores transaction data like orders and catalogs. Version 8.0 is recommended.
- [Azure Files Premium](https://azure.microsoft.com/services/storage/files/) or equivalent provides *network-attached storage (NAS)*. To store media files like product images, Magento needs a Kubernetes-compatible file system that can mount a volume in *ReadWriteMany* mode, like Azure Files Premium, SoftNAS, [Azure NetApp Files](https://azure.microsoft.com/services/netapp/), or GlusterFS. The current solution uses SoftNAS.
- A [content delivery network (CDN)](https://azure.microsoft.com/services/cdn/) to serve static content like CSS, JavaScript, and images. Serving content through a CDN minimizes network latency between users and the datacenter. A CDN can significantly offload from NAS by caching and serving static content.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache/) stores session data. Premium SKU lets you place caches into the same virtual network with other components, so you can improve performance and restrict access through virtual network topology and access policies.
- AKS uses [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory/) identity to create and manage other Azure resources like Azure load balancers. Azure AD also manages user authentication, role-based access control, and managed identity.
- [Azure Container Registry (ACR)](https://azure.microsoft.com/services/container-registry/) stores private [Docker](https://www.docker.com/) images, which are deployed to the cluster. Alternatively, you can use other container registries like Docker Hub. Note that default Magento installs write some secrets to the image.
- [Azure Monitor](https://azure.microsoft.com/services/monitor/) collects and stores metrics and logs, including platform metrics for the Azure services and application telemetry. Azure Monitor integrates with AKS to collect metrics from controllers, nodes, and containers, as well as container logs and master node logs.

No secure socket layer (SSL) for Redis nor MySQL, but they have service endpoints. Add Azure Application Gateway ingress to support SSL termination.

No Nginx, just a load balancer.

Built-in user authorization.

## Security considerations

Configure a [private link](https://azure.microsoft.com/services/private-link/) for MySQL so that the traffic between clients and MySQL isn't exposed to the public internet. For more information, see [What is Azure Private Link](/azure/private-link/private-link-overview).

### Role based access control (RBAC)

Kubernetes and Azure both have mechanisms for *role-based access control (RBAC)*:

- Azure RBAC controls access to resources in Azure, including the ability to create new Azure resources. Permissions can be assigned to users, groups, or *service principals*. A service principal is a security identity used by applications.

- Kubernetes RBAC controls permissions to the Kubernetes API. For example, creating Pods and listing Pods are actions that can be authorized or denied to a user through RBAC. To assign Kubernetes permissions to users, you create *roles* and *role bindings*:
  - A *Role* is a set of permissions that apply within a namespace. Permissions are defined as verbs like get, update, create, or delete, on resources like pods or deployments.
  - *RoleBinding* assigns users or groups to a role.
  - A *ClusterRole* object is like a role but applies to the entire cluster, across all namespaces. To assign users or groups to a ClusterRole, create a *ClusterRoleBinding*.
  
AKS integrates the Azure and Kubernetes RBAC mechanisms. When you create an AKS cluster, you can configure it to use Azure AD for user authentication. For details on how to set up Azure AD integration, see [Integrate Azure Active Directory with Azure Kubernetes Service](/azure/aks/aad-integration).

## Scalability considerations

Here are some ways to optimize scalability for this architecture:

- Provision Azure Files or other NAS. Magento can potentially store thousands of media files such as product images. Be sure to provision the Azure Files or other NAS product with sufficient *input/output operations per second (IOPS)* capacity.

- Turn on *persistent connection* to MySQL in Magento configuration. Once persistent connection is turned on, Magento keeps reusing the existing database connections instead of creating a new one upon every request.
  
  To turn on persistent connection to MySQL, in the database connection section of the *env.php* file, add the following setting:
  
  `'persistent' => '1'`

- Optimize `opcache`
  
  In the *php.ini* file, uncomment and set the following settings:
  
  ```
  opcache.enable=1
  
  opcache.save\_comments=1
  
  opcache.validate\_timestamps=0
  
```
- Turn off `product count` from layered navigation to reduce the utilization if MySQL is consuming too much CPU.
  
  `/var/www/html/magento2/bin/magento config:set -vvv catalog/layered_navigation/display_product_count 0`

- Use the following command to limit the Varnish logging to error-level:
  
  `varnishd -s malloc,1G -a :80 -f /etc/varnish/magento.vcl && varnishlog -q "RespStatus >= 400 or BerespStatus >= 400"`

- If you're using Apache as ingress, limit the Apache logging to error-level by adding the following [two?] lines to the Magento `VirtualHost` entry:
  
  `CustomLog /dev/null common`

- Turn off the access log from PHP-FPM by commenting out the `access.log` setting in all PHP-FPM configurations.

- Azure Cache for Redis has an option to persist the data it stores. Disable the persistence option to avoid unnecessary performance degradation. For more information, see [How to configure data persistence for a Premium Azure Cache for Redis](/azure/azure-cache-for-redis/cache-how-to-premium-persistence).

- In Magento configuration, enable *minification* to minimize the size of static content such as CSS and JavaScript. Minification can reduce bandwidth costs and provide a more responsive experience for your users.

- Load balance the Varnish cache by running multiple instances on pods so that it can scale.

## Availability considerations

Consider these ways to optimize availability for this architecture:

- Use health probes. Kubernetes defines two types of health probe. Customize them accordingly to tell if a pod is in good health.
  - *Readiness probe* tells Kubernetes whether the pod is ready to accept requests.
  - *Liveness probe* tells Kubernetes whether a pod should be removed and a new instance started.

- Consider zones or multi-regions. Consider deploying the app to multiple regions or zones for higher availability. Make sure all services and deployed components such as the AKS cluster and the Redis cache are co-located in the same region, to avoid unnecessary latency between services.

- Define resource constraints. Resource contention can affect the availability of a service. Define resource constraints for containers, so that no single container can overwhelm the cluster memory and CPU resources. For non-container resources, such as threads or network connections, consider using the [Bulkhead pattern](/azure/architecture/patterns/bulkhead) to isolate resources.
  
  Use resource quotas to limit the total resources allowed for a namespace. That way, the front end can't starve the backend services for resources or vice-versa.

## Cost considerations

Do capacity planning based on performance testing. Make sure to over-provision services to avoid unnecessary cost. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview).

## DevOps considerations

Here are some operational considerations for this architecture:

- If the build server stores configuration settings to the backend MySQL database, deploy the server into the same virtual network subnet that MySQL is connected to via service endpoint. In this architecture, MySQL doesn't expose a public endpoint.

- Deploy via container registry. Use ACR to store the private Docker images that are deployed to the cluster. AKS can authenticate with ACR by using its Azure AD identity. AKS doesn't require ACR, and can use other container registries like Docker Hub.

### Monitoring

Azure Monitor provides key metrics for all Azure services, including container metrics from AKS. Create a dashboard to show all metrics at one place.

![Screenshot of an Azure Monitor monitoring dashboard.](./_images/monitor-dashboard.png)

Another monitoring option is to use Grafana dashboard:

### Performance testing

Use [Magento Performance Toolkit](https://github.com/magento/magento2/tree/2.4/setup/performance-toolkit) for performance testing. The toolkit uses [Apache JMeter](https://jmeter.apache.org/) to simulate customer behaviors like signing in, browsing products, and checking out.

![Screenshot of a the Magento Performance Toolkit.](./_images/jmeter.png)

## Deploy the solution

To deploy the reference implementation for this architecture, follow the steps in the GitHub repo.
