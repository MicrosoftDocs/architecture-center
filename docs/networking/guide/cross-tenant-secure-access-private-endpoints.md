---
title: Cross-tenant Secure Access to Apps with Private Endpoints
description: Restrict inbound traffic to a web app or function app. Use private endpoints in Azure to give consumer tenants secure access to provider tenant apps.
author: rdesutter
ms.author: rdesutter
ms.date: 03/30/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Cross-tenant secure access to apps with private endpoints

Like most Azure platform as a service (PaaS) services, web apps and function apps are publicly reachable over the internet by default. You can restrict inbound traffic to web apps and function apps by using private endpoints.

Private endpoints use IP addresses from the Azure virtual network address space. Network traffic between the client and the app traverses the virtual network and Private Link on the Microsoft backbone, which eliminates exposure to the public internet. Private endpoints also support improvised cross-tenant access. A secure connection can run from a consumer virtual network in one tenant to a specific web app or function app in another tenant, which means site-to-site VPNs or virtual network peerings aren't necessary.

This guide presents an architecture that uses a private endpoint. A private endpoint securely exposes a web app in one tenant to a client that consumes the web app in another tenant. You can also use this approach for a function app if you have a Premium or App Service plan for Functions.

## Architecture

:::image type="content" source="./images/cross-tenant-secure-access-private-endpoints-architecture.svg" alt-text="Diagram that shows how a private endpoint securely connects a user on a virtual machine in one tenant to a web app in another tenant." lightbox="./images/cross-tenant-secure-access-private-endpoints-architecture.svg" border="false":::
   Diagram that shows two tenant areas side by side. On the left, a consumer tenant contains Subscription C with a virtual network, a subnet, a virtual machine (VM), a private endpoint, and a private Domain Name System (DNS) zone. On the right, a provider tenant contains Subscription P with a virtual network, a subnet, a private endpoint, a private DNS zone, and an App Service web app. An internet globe and an Azure DNS service sit above the two tenants. Numbered arrows trace the dataflow: Step 1 goes from the VM to the internet, Step 2 goes from the internet to Azure DNS, Step 3 goes from Azure DNS to the private DNS zones in each tenant, Step 4 returns the private endpoint IP address to the VM, Step 5 sends an HTTPS request from the VM through the private endpoint to the web app, and Step 6 returns the response. A separate path, labeled Step 7, shows a red arrow going from the internet directly to the web app, with a red 403 label that indicates that public access is denied.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/US-2025459-cross-tenant-secure-access-private-endpoints.vsdx) of this architecture.*

### Dataflow

1. A user or service on a virtual machine (VM) submits a Domain Name System (DNS) request for an Azure web app at `webapp.azurewebsites.net`. The web app runs in a provider tenant.

1. The Azure public DNS service handles the query for `webapp.azurewebsites.net`. The response is a CNAME record, `webapp.privatelink.azurewebsites.net`.

1. An Azure DNS private zone handles the DNS query for `webapp.privatelink.azurewebsites.net`.

1. The response is an A record with the IP address of a private endpoint.

1. The VM issues an HTTPS request to the web app via the IP address of the private endpoint.

1. The web app handles the request and responds to the VM.

1. If the user or service doesn't have access to the private DNS zone, the Azure public DNS service resolves the DNS query to `webapp.privatelink.azurewebsites.net` by returning a public IP address. HTTPS requests to that public IP address receive a *403 Forbidden* response.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) and Web Apps provide a managed platform for you to build, deploy, and scale web applications. In this architecture, Web Apps hosts the application in the provider tenant and the application is secured via private endpoints to restrict public access.

- [Functions](/azure/well-architected/service-guides/azure-functions) is an event-driven serverless compute service. In this architecture, Functions can be used as an alternative to Web Apps. Functions is also secured via private endpoints to ensure that cross-tenant access remains private.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the foundational networking layer in Azure that facilitates secure communication between Azure resources, the internet, and on-premises networks. In this architecture, virtual networks host the private endpoints and DNS zones, which facilitates secure connectivity between provider and consumer tenants.

- [Private Link](/azure/private-link/private-link-overview) facilitates secure, private connectivity between Azure services and virtual networks by mapping service endpoints to private IP addresses within a virtual network. You can use the private endpoint to connect to Azure PaaS services, customer services, or partner services. In this architecture, Private Link exposes the web app or function app securely to another tenant without traversing the public internet.

- [Azure DNS](/azure/dns/dns-overview) is a scalable DNS hosting service that uses Azure infrastructure to provide name resolution. The private Azure DNS service manages and resolves domain names in a virtual network and in connected virtual networks. This service doesn't require configuration of a custom DNS solution. In this architecture, Azure DNS handles public DNS queries and integrates with private DNS zones to resolve private endpoint addresses.

- [Azure DNS private zones](/azure/dns/private-dns-overview) allow DNS resolution within virtual networks without exposing records to the public internet. In this architecture, private DNS zones manage internal name resolution for private endpoints, which ensures secure and accurate routing within and across tenants.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) provides scalable compute resources to run applications and services. In this architecture, a VM in the consumer tenant initiates DNS and HTTPS requests to the provider's web app via the private endpoint.

## Provider setup

1. Secure the web app in the tenant that owns it. Create a private endpoint and restrict access from the public internet to the web app.

1. Evaluate if the service you're using requires additional access controls to disable public access.

   All Azure services implement their own public access behavior. If you don't complete additional configurations, some Azure services remain publicly available even after you associate them with a private endpoint. Web apps and function apps become unavailable publicly when they're associated with a private endpoint and the [public access setting](/azure/app-service/overview-access-restrictions#app-access) is disabled.

1. Prepare a virtual network and subnet for the private endpoint NIC.

   The NIC consumes one IP address from the subnet. Define your DNS strategy so you can register the NIC's A record in the appropriate DNS zone.

1. Create the private endpoint.
   - If you use the default Azure DNS services, we recommend that you use the Azure DNS private zone service and allow automatic integration when you create the private endpoint. This approach ensures that:
     - The private DNS zone, `privatelink.azurewebsites.net`, is created automatically if needed.
     - The DNS zone is linked to the virtual network of the private endpoint's NIC.
     - The A record is registered and managed automatically in the private DNS zone.

   - If you don't use the default Azure DNS services, you must configure and manage your own DNS servers and zones:
     1. Create a `privatelink.azurewebsites.net` DNS zone.
     1. Ensure that `privatelink.azurewebsites.net` can be resolved in the virtual networks that need to resolve the NIC of the private endpoint.
     1. Register the A record in the `privatelink.azurewebsites.net` DNS zone with the IP address of the private endpoint. You might need to configure a DNS forwarder to resolve the Azure DNS public zone, `azurewebsites.net`.

During the creation of the private endpoint, the Azure DNS public zone, `azurewebsites.net`, is automatically updated with the CNAME record that points to the private DNS zone. Users can try to reach the web app from sources that can't resolve the private DNS zone to retrieve the actual A record and its internal IP address. Those users get a public resolvable IP address, but the response is *403 Forbidden*. For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

The provider can configure a [custom domain name](/azure/app-service/app-service-web-tutorial-custom-domain) for the web app via a CNAME record that references the entry in the public zone `azurewebsites.net`. The CNAME record created for this custom domain shouldn't point to the `privatelink.azurewebsites.net` entry.

## Consumer setup

After the consumer initiates consumer setup, enable a client in another tenant to reach the provider's Azure web app. The provider must provide manual approval to activate the connection.

### Step 1 (consumer): Create a private endpoint

Create a private endpoint resource on the consumer side. As with the provider, the consumer needs to have a virtual network and subnet where the NIC of the private endpoint can be deployed. This step consumes an IP address of the subnet. There are no constraints on the private IP range of the virtual network. It's OK to have overlapping IP ranges in the provider and consumer tenants.

The consumer doesn't own the target resource, so use the full resource ID of the web app in the provider tenant. The resource ID contains the provider's subscription ID, the name of the resource group, and the name of the web app resource. We recommend that the provider share this information with the consumer securely. It's not possible to use an alias.

Some Azure resources have multiple subresources. For instance, an [Azure Storage resource](/azure/storage/common/storage-private-endpoints#dns-changes-for-private-endpoints) has *blob*, *table*, *queue*, *file*, *web*, and *dfs* subresources. The provider must also provide information about the subresources. Web apps and function apps only have one subresource, *sites*. For more information about private endpoint subresources and their values, see [Private-link resource](/azure/private-link/private-endpoint-overview#private-link-resource). Because the private endpoint connection isn't automatically approved, the consumer can enter a message for the provider to read.

It's not possible to automate the DNS zone integration setup. The consumer must  manually configure the DNS records as explained in [Step 3](#step-3-consumer-dns-setup).

When the private endpoint resource is created, the connection status is *Pending*. The connection remains in this unusable state until the provider approves the request.

### Step 2 (provider): Review and approve the connection request

The consumer needs to inform the provider when a request is made.

The provider can retrieve, review, and approve or reject pending requests in the Azure portal in the following places:

- On the **Private Link Center** page. The approver can enter an approval message on this page.
- Under **Networking** in the web app. Select **Private endpoints**.
- In the Azure CLI or Azure PowerShell, where the provider can retrieve, review, and approve or reject the pending requests.

The provider can read the message that was provided when the private endpoint was created. The provider can also see the name that the consumer gave the private endpoint. In the Azure CLI and Azure PowerShell, the consumer's tenant ID, resource group name, and private endpoint resource name are also available. The Azure portal creates a hyperlink to the private endpoint of the consumer. Because the consumer is in a different tenant, it's typically not available to the provider.

It's not possible to automate private endpoint connection approvals. However,  you can use the autoapproval property to preapprove a set of subscriptions for automated access to the service by using Private Link.

### Step 3 (consumer): DNS setup

You can take the steps in this section immediately after you create the private endpoint resource in step 1. However, we recommend that you wait until the provider approves the connection.

The consumer needs to set up and configure the private DNS zone to make sure its clients can find the NIC of the private endpoint. As with the provider, the DNS strategy in the tenant determines the required steps.

- If the consumer uses the default Azure DNS services, we recommend that you use the Azure DNS private zone service. If necessary, the consumer can create the private DNS zone `privatelink.azurewebsites.net` and link it to a virtual network that contains the NIC of the private endpoint. Automatic registration isn't needed for this DNS zone. Then, the consumer must add a new DNS configuration:

  1. In the Azure portal, search for and select the private endpoint.
  1. Open **DNS configuration**.
  1. Select the private DNS zone and provide a connection name to add a new DNS configuration.

  These actions create the A record in the private DNS zone. The fully qualified domain name (FQDN) is populated automatically when the connection is approved.

- If the consumer manages their own DNS zones, the consumer needs to configure their environment as described earlier in [Provider setup](#provider-setup).

If the provider configures a custom domain name, the consumer can access the web app via that name.

In this guide's architecture, the consumer VM uses the private endpoint to access the web app. Access to the web app is possible as soon as the connection is approved and the DNS is configured correctly.

## Connection management

Both the provider and the consumer can manage the private endpoint connection after it's created and approved.

- The consumer can remove the connection independently via the private endpoint resource, the **Private Link Center** page, the Azure CLI, or Azure PowerShell.

- The provider can remove the connections to its service under **Networking** in the web app, the Azure CLI, or Azure PowerShell. After the private endpoint is deleted, the consumer's access to the service is blocked. The consumer sees that the connection on the private endpoint has the status *Disconnected* and that the DNS record is removed from the private DNS zone. The consumer needs to delete the private endpoint resource manually.

It's not possible to temporarily pause or disable a connection. After the consumer or the provider deletes a connection, you have to create a new private endpoint to restore the connection.

## Cost optimization

In contrast to access restrictions, which are free, private endpoints come with fixed and variable costs for both the provider and consumer.

### Fixed costs

- The [duration of the private endpoint](https://azure.microsoft.com/pricing/details/private-link).
- The [number of DNS zones](https://azure.microsoft.com/pricing/details/dns).

### Variable costs

- The volume of data processed on the private endpoint.
- The [bandwidth charges](https://azure.microsoft.com/pricing/details/bandwidth) if the web app and the private endpoint are deployed in different regions.
- The number of DNS queries.

VMs aren't included in this pricing overview because they're not an absolute requirement for the architecture.

## Other considerations

- The provider needs to share the subscription ID, the resource group name, and the web app resource name with the consumer. The consumer shares the subscription ID, the resource group name, and the private endpoint resource name with the provider.

- The number of private endpoints that you can create in a subscription are limited, but because private endpoints are created in the consumer subscriptions, this limit shouldn't be a problem. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

- The subscription that contains the Private Link resource must be registered with the Microsoft network resource provider. The subscription that contains the private endpoint must also be registered with the Microsoft network resource provider. For more information, see [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).

- If you have connectivity problems, see [Troubleshoot Azure private endpoint connectivity problems](/azure/private-link/troubleshoot-private-endpoint-connectivity). In particular, verify the DNS configuration.

## Deploy this scenario

For a GitHub repo with Bicep templates that you can use to deploy this architecture, see [Project Cross-Tenant Secure Access to Web Apps and Functions with Private Endpoints](https://github.com/Azure/Secure-Cross-Tenant-Azure-App-Access-with-Private-Endpoints).

## Other solutions

You can configure the resource's internal firewall by using access restrictions to define allow and deny rules. You can base restrictions on IPv4/IPv6 addresses, service tags, or service endpoints. Service endpoints only permit traffic from selected subnets and virtual networks. Access restrictions are free to use and they're available in all Azure App Service and Azure Functions plans. However, it's difficult to maintain rules, and non-Microsoft clients require listed IPs, which could be dynamic or considered sensitive.

For some other PaaS resources, such as Storage Accounts, Key Vault, and Event Hubs, Azure Network Security Perimeter is an additional option to restrict inbound traffic. You can use Azure Network Security define a logical security boundary around certain Azure PaaS resources that aren't deployed inside a virtual network by using a network security perimeter (NSP). NSPs provide you with a virtual perimeter for PaaS resources and they can control who and what can talk to them. NSPs can be used in combination with private endpoints.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Robbie De Sutter](https://www.linkedin.com/in/robbiedesutter) | Digital Cloud Solution Architect

Other contributor:

- [Rajkumar (Raj) Balakrishnan](https://www.linkedin.com/in/raj-microsoft) | Digital Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure role-based access control (Azure RBAC) permissions for Private Link](/azure/private-link/rbac-permissions)
- [Restrict your storage account to a virtual network (for Functions)](/azure/azure-functions/configure-networking-how-to#restrict-your-storage-account-to-a-virtual-network)
- [Microsoft Azure Well-Architected Framework - Security](/azure/architecture/framework/security)
- [Set up App Service access restrictions](/azure/app-service/app-service-ip-restrictions)
- [Using private endpoints for Azure web app](/azure/app-service/networking/private-endpoint)
- [Functions networking options](/azure/azure-functions/functions-networking-options)
- [What is a private endpoint?](/azure/private-link/private-endpoint-overview)
- [Manage Azure private endpoints](/azure/private-link/manage-private-endpoint)
- [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
- [Multitenancy and Private Link](/azure/architecture/guide/multitenant/service/private-link)

## Related resources

- [Improved-security access to multitenant web apps from an on-premises network](../../web-apps/guides/networking/access-multitenant-web-app-from-on-premises.yml)
- [Multi-tier App Service with private endpoint](../../example-scenario/web/multi-tier-app-service-private-endpoint.yml)
- [Private Link in a hub-and-spoke network](../guide/private-link-hub-spoke-network.md)
- [Limit cross-tenant private endpoint connections in Azure](/azure/cloud-adoption-framework/ready/azure-best-practices/limit-cross-tenant-private-endpoint-connections)
- [NSP](/azure/private-link/network-security-perimeter-concepts)
- 