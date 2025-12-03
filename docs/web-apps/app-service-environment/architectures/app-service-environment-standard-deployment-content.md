This reference architecture demonstrates a common enterprise workload that uses Azure App Service Environment version 3. It also describes best practices for strengthening the security of the workload.

> [!NOTE]
> [App Service Environment](/azure/app-service/environment/overview) version 3 is the main component of this architecture. Versions 1 and 2 were [retired on August 31, 2024](https://azure.microsoft.com/updates/app-service-environment-v1-and-v2-retirement-announcement/).

## Architecture

:::image type="complex" source="../_images/app-service-environment.svg" alt-text="Diagram that shows an architecture for an App Service Environment deployment." lightbox="../_images/app-service-environment.svg" border="false":::
The diagram shows a secure, zone‑redundant App Service Environment inside an Azure virtual network. Traffic enters through Application Gateway from the internet, then routes to the ILB of the App Service Environment that hosts a web app, a private API, and a function app. Traffic flows to the web app. Outbound traffic flows through Azure Firewall. The environment connects to Azure services like Azure Service Bus, Azure Cosmos DB, Azure SQL Database, and Azure Key Vault through private endpoints and private Domain Name System (DNS). Azure Managed Redis connects to the web app by way of a two-sided arrow. A dashed arrow points from GitHub Actions outside the virtual network to a jump box virtual machine (VM) in a subnet. Another dashed arrow points from this subnet to the App Service Environment subnet. Microsoft Entra ID is in the right top corner of the diagram to indicate that it handles authentication.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/app-service-environment.vsdx) of this architecture.*

:::image type="icon" source="../../../_images/github.png"::: A reference implementation for this architecture is available on [GitHub](https://github.com/mspnp/app-service-environments-ILB-deployments).

### Workflow

You can deploy App Service Environment in two ways:

- As an *external* App Service Environment that has a public IP address

- As an *internal* App Service Environment that has an internal IP address that belongs to an internal load balancer (ILB)

This reference architecture deploys an enterprise web application in an internal App Service Environment, also known as an *ILB App Service Environment*. Use an ILB App Service Environment in scenarios that require the following capabilities:

- Host intranet applications with enhanced security in the cloud and access them by way of a site-to-site VPN or Azure ExpressRoute.

- Provide a layer of protection for apps by using a web application firewall (WAF).
- Host apps in the cloud that aren't listed in public Domain Name System (DNS) servers.
- Create internet-isolated back-end apps that front-end apps can integrate with in a highly secure way.

Always deploy an App Service Environment in its own subnet in the enterprise virtual network. This approach maintains strict control of incoming and outgoing traffic. Within this subnet, Azure App Service applications run in one or more [App Service plans](/azure/app-service/overview-hosting-plans), which are collections of physical resources required to run the app. Depending on the complexity and resource requirement, multiple apps can share an App Service plan. The App Service Environment infrastructure manages all resources that these hosted apps require, including storage, compute, and scaling.

This reference implementation deploys a web app named *Voting App*, which interacts with a private web API and a function. It also deploys a mock web app named *Test App* to demonstrate multiple-app deployments. In the reference implementation, each App Service app runs in its own App Service plan, which enables independent scaling when needed.

The simple voting app in this implementation lets users view existing entries, create new entries, and vote on existing entries. The web API creates and retrieves entries and votes. The data is stored in an Azure SQL database. To demonstrate asynchronous data updates, the web app queues newly added votes in a Service Bus instance. The function picks up queued votes and updates the SQL database. Azure Cosmos DB stores a mock-up ad that the web app retrieves to display in the browser. The application uses Azure Managed Redis for cache management. A Balanced Optimized tier of Azure Managed Redis is configured in the same virtual network as the App Service Environment, and it runs in its own subnet. This setup provides enhanced security and isolation for the cache.

The web apps are the only components that are reachable from the internet. Internet traffic must pass through Azure Application Gateway, which is protected by a WAF. An internet client can't access the API or the function app.

### Components

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a private Azure cloud network that your enterprise owns. It provides enhanced network-based security and isolation. This architecture deploys an App Service Environment into a subnet of the enterprise-owned virtual network. App Service Environment allows your enterprise to tightly control that network space and the resources that it accesses by using network security groups (NSGs) and private endpoints. 

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is an application-level web traffic load balancer that has Transport Layer Security (TLS) or Secure Sockets Layer (SSL) offloading and a WAF. In this architecture, Application Gateway accepts incoming traffic on a public IP address and routes it to the application endpoint in the ILB App Service Environment. This application-level routing can route traffic to multiple apps within the same ILB App Service Environment. For more information, see [Application Gateway multisite hosting](/azure/application-gateway/multiple-site-overview).

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-native, stateful firewall service built into Azure. It provides high availability and unrestricted cloud scalability, and it supports both inbound and outbound filtering rules. In this architecture, Azure Firewall restricts outbound traffic from the web application. A route table is configured to route outgoing traffic that doesn't go through the private endpoint channels to the firewall. For simplicity, this architecture configures all private endpoints on the services subnet.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and network access product that provides access rights and permissions management to Azure resources and services. [Managed identities](/entra/identity/managed-identities-azure-resources/overview) assign identities to services and apps. They can authenticate to any service that supports Microsoft Entra authentication. This approach removes the need to explicitly configure credentials for these apps. This architecture assigns a managed identity to the web app.

- [Azure Key Vault](/azure/key-vault/general/overview) is a cloud service that securely stores and manages sensitive information like secrets, encryption keys, and certificates. This architecture uses Key Vault to store secrets and credentials that the apps require. Use this option instead of storing secrets directly in the application.

- [GitHub Actions](/azure/developer/github/github-actions) is a workflow automation feature built into GitHub that enables continuous integration and continuous delivery (CI/CD). In this architecture, the App Service Environment is in the virtual network, so a VM serves as a jump box inside the virtual network to deploy apps in the App Service plans. The action builds the apps outside the virtual network. For enhanced security and seamless Remote Desktop Protocol (RDP) and Secure Shell (SSH) connectivity, consider using [Azure Bastion](/azure/bastion/bastion-overview) for the jump box.

### Multisite configuration

:::image type="complex" source="../_images/app-service-environment-multisite.svg" alt-text="Diagram that shows a multisite deployment." lightbox="../_images/app-service-environment-multisite.svg" border="false":::
The diagram shows a virtual network that includes two subnets, the Application Gateway subnet and the App Service Environment subnet. Application Gateway resides in its own subnet. It points to a private DNS zone labeled default-appname.ase-domain.appserviceenvironment.net, which resides outside the virtual network. The arrow is labeled DNS lookup of ILB IP. Other text near the gateway reads gateway IP, back-end pool, override domain name, listener, and CA-signed certificate. An arrow labeled HTTPS points from an icon labeled appname.domain.com to the gateway and then to an ILB in the App Service Environment subnet. App Service Environment points to three separate App service components. It points to App Service for App 1 by way of an arrow labeled default-appname. This component includes the label HTTPS and default certificate. App Service Environment also points to App Service for App 2 and App service for API by way of separate dashed arrows.
:::image-end:::

An internal App Service Environment can host several web apps and APIs that have HTTP endpoints. These applications aren't exposed to the public internet because the ILB IP address can only be accessed from within the virtual network. [Application Gateway](/azure/application-gateway/overview) selectively exposes these applications to the internet. The App Service Environment assigns a default URL to each App Service application as `<default-appName>.<app-service-environment-domain>.appserviceenvironment.net`. A [private DNS zone](/azure/dns/private-dns-overview) is created that maps the App Service Environment domain name to the App Service Environment ILB IP address. This approach avoids custom DNS for app access within the virtual network.

Application Gateway is configured to include a [listener](/azure/application-gateway/configuration-overview#listeners) that accepts HTTP requests on the gateway's IP address. For simplicity, this implementation doesn't use a public DNS name registration. You must modify the localhost file on your computer to point an arbitrarily chosen URL to the Application Gateway IP address. The listener uses a self-signed certificate to process these requests. 

Application Gateway has [back-end pools](/azure/application-gateway/configuration-overview#backend-pool) for each App Service application's default URL. A [routing rule](/azure/application-gateway/configuration-overview#request-routing-rules) is configured to connect the listener to the back-end pool. 

[HTTP settings](/azure/application-gateway/configuration-overview) determine whether the connection between the gateway and the App Service Environment uses encryption. These settings also override the incoming HTTP host header with a host name from the back-end pool. This implementation uses default certificates created for the default App Service Environment app URLs, and the gateway trusts those certificates. The request redirects to the default URL of the corresponding app. 

The private [DNS linked to the virtual network](/azure/dns/private-dns-virtual-network-links) forwards this request to the ILB IP address. The App Service Environment then forwards the request to the requested app service. Any HTTP communication within the App Service Environment apps goes through private DNS. You must configure the listener, back-end pool, routing rule, and HTTP settings on the application gateway for each App Service Environment app.

Review the [appgw.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/appgw.bicep) and [dns.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/dns.bicep) files to learn how these configurations allow multiple sites. The web app named `testapp` is an empty app created to demonstrate this configuration.

## Scenario details

[App Service](/azure/app-service/overview) is a platform as a service (PaaS) solution that hosts various apps on Azure, including web apps, API apps, functions, and mobile apps. You can use [App Service Environment](/azure/app-service/environment/intro) to deploy App Service apps in a subnet in your own [Azure virtual network](/azure/virtual-network). This approach provides an isolated, highly scalable, and dedicated environment for cloud workloads.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### App Service Environment

An internal App Service Environment resides in the enterprise virtual network and is hidden from the public internet. It enables you to secure back-end services, like web APIs and functions, at the network level. Any App Service Environment app that has an HTTP endpoint can be accessed through the ILB from within the virtual network. Application Gateway forwards requests to the web app through the ILB. The web app itself goes through the ILB to access the API. The critical back-end components, like the API and the function, can't be accessed from the public internet.

The App Service Environment assigns a default domain name to each app service and automatically creates a default certificate for each domain name. This certificate helps secure traffic between the gateway and the app and might be required in some scenarios. The default certificate doesn't appear in the client browser and only responds to the certificate configured on Application Gateway.

#### Application Gateway

Application Gateway can use [TLS or SSL to encrypt and protect all traffic](/azure/application-gateway/ssl-overview) from web browsers. You can configure encryption in two ways:

- **Encryption terminated at the gateway:**  For this method, the back-end pools are configured for HTTP. The encryption stops at the gateway, and traffic between the gateway and App Service is unencrypted. Encryption is CPU-intensive, so unencrypted traffic at the back end improves performance and allows simpler certificate management. This approach provides moderate security because the network configuration protects the back end.

- **End-to-end encryption:** In some scenarios that have specific security or compliance requirements, the traffic might need to be encrypted between the gateway and the app. This configuration uses HTTPS connections and requires certificates at the back-end pool.

This reference implementation uses self-signed certificates for Application Gateway. For production code, use a certificate issued by a certificate authority (CA).

- For a list of supported certificate types, see [Certificates supported for TLS termination](/azure/application-gateway/ssl-overview#certificates-supported-for-tls-termination).
- For information about how to create gateway-terminated encryption, see [Configure an application gateway with TLS termination by using the Azure portal](/azure/application-gateway/create-ssl-portal).

The following example from `appgw.bicep` configures HTTP listeners programmatically.

```bicep
httpListeners: [for item in appgwApplications: {
name: '${appgwListenerName}${item.name}'
properties: {
  frontendIPConfiguration: {
    id: '${appgwId}/frontendIPConfigurations/${appgwFrontendName}'
  }
  frontendPort: {
    id: '${appgwId}/frontendPorts/port_443'
  }
  protocol: 'Https'
  sslCertificate: {
    id: '${appgwId}/sslCertificates/${appgwSslCertificateName}${item.name}'
  }
  hostName: item.hostName
  requireServerNameIndication: true
}
}]
```

The reference implementation demonstrates end-to-end encryption for traffic between Application Gateway and the web apps in the App Service Environment. It uses the default SSL certificates. The back-end pools in this implementation are configured to redirect HTTPS traffic. They also override the host name with the default domain names associated with the web apps. Application Gateway trusts the default SSL certificates because Microsoft issues them. For more information, see [Configure App Service by using Application Gateway](/azure/application-gateway/configure-web-app-portal). The following example from `appgw.bicep` shows how the reference implementation configures this approach.

```bicep
backendHttpSettingsCollection: [for item in appgwApplications: {
name: '${appgwHttpSettingsName}${item.name}'
properties: {
  port: 443
  protocol: 'Https'
  cookieBasedAffinity: 'Disabled'
  pickHostNameFromBackendAddress: true
  requestTimeout: 20
  probe: {
    id: '${appgwId}/probes/${appgwHealthProbeName}${item.name}'
  }
}
}]
```

##### Web Application Firewall

[Web Application Firewall on Application Gateway](/azure/web-application-firewall/ag/ag-overview) protects the web apps from malicious attacks, like SQL injection. It also integrates with Azure Monitor to monitor attacks by using a real-time log. To enable Web Application Firewall, you must [configure the gateway to meet its requirements](/azure/web-application-firewall/ag/application-gateway-web-application-firewall-portal). The reference implementation enables WAF programmatically in the `appgw.bicep` file by using the following code.

```bicep
webApplicationFirewallConfiguration: {
  enabled: true
  firewallMode: 'Detection'
  ruleSetType: 'OWASP'
  ruleSetVersion: '3.2'
}
```

#### Virtual Network

You can associate [NSGs](/azure/virtual-network/security-overview#how-traffic-is-evaluated) with one or more subnets in the virtual network. These groups define security rules that allow or deny traffic to flow between various Azure resources. This architecture associates a separate NSG for each subnet, which enables fine-tuned rules based on the services in that subnet.

- The configuration for the NSG of the App Service Environment subnet is in the file [ase.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/ase.bicep).

- The configuration for the NSG of the Application Gateway subnet is in the file [appgw.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/appgw.bicep).

Both configurations use the resource `"type": "Microsoft.Network/networkSecurityGroups"`.

[Private endpoints](/azure/private-link/private-endpoint-overview) enable enhanced-security private connectivity between clients and Azure services over a private network. They provide a privately accessed IP address for the Azure service, which enables enhanced-security traffic to an Azure Private Link resource. The platform validates network connections and allows only connections that target the specified Private Link resource. 

Private endpoints support network policies, like NSGs, user-defined routes (UDRs), and application security groups. To improve security, enable private endpoints for any Azure service that supports them. To help secure the service in the virtual network, disable public access to block access from the public internet. This architecture configures private endpoints for the services that support it, including Service Bus, SQL Database, Key Vault, and Azure Cosmos DB. You can see the configuration in [privatendpoints.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/privateendpoints.bicep).

To enable private endpoints, you must also configure private DNS zones. For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

#### Azure Firewall

[Azure Firewall](/azure/firewall/overview) and private endpoints complement each other. Private endpoints help protect resources by allowing only traffic that originates from your virtual network. Azure Firewall lets you restrict the outbound traffic from your applications. We recommend that you allow all outbound traffic to pass through the firewall subnet, including private endpoint traffic. This approach enables better monitoring of the outbound traffic. For simplicity, this reference architecture configures all private endpoints on the services subnet instead of the firewall subnet.

For more information, see [Configure Firewall with your App Service Environment networking](/azure/app-service/environment/networking#network-routing). The firewall monitors and controls traffic that doesn't traverse the private endpoints and virtual network route table.

<a name='azure-active-directory'></a>

#### Microsoft Entra ID

Microsoft Entra ID provides security features to authenticate applications and authorize access to resources. This reference architecture uses two key features of Microsoft Entra ID, managed identities and Azure role-based access control (Azure RBAC).

On cloud applications, you must secure the credentials required to authenticate to cloud services. Ideally, the credentials should never appear on developer workstations or in source control. Key Vault securely stores credentials and secrets, but the app must authenticate to Key Vault to retrieve them. **Managed identities for Azure resources** provide Azure services with an automatically managed identity in Microsoft Entra ID. You can use this identity to authenticate to any service that supports Microsoft Entra authentication, including Key Vault, without any credentials in the application.

[Azure RBAC](/azure/role-based-access-control/overview) manages access to Azure resources by defining the following conditions:

- Which entity has access, like user, managed identity, or security principal

- What type of access it has, like owner, contributor, reader, or admin
- The scope of access, like resource, resource group, subscription, or management group

You can help secure access to App Service Environment applications by tightly controlling the role required and the type of access for each app. This approach allows multiple apps to deploy on the same App Service Environment from different development teams. For example, one team might handle the front end, and one team might handle the back end. Azure RBAC can limit each team's access to the apps that they work on. To create roles suitable for your organization, see [Azure custom roles](/azure/role-based-access-control/custom-roles).

#### Key Vault

Some services support managed identities and use Azure RBAC to set up permissions for the app. For example, see the built-in [Service Bus roles](/azure/service-bus-messaging/service-bus-managed-service-identity#built-in-rbac-roles-for-azure-service-bus) and [Azure RBAC in Azure Cosmos DB](/azure/cosmos-db/role-based-access-control). You must have *User Access Administrator* access to the subscription to grant these permissions. The *Contributor* role can deploy these services. To allow a wider team of developers to run the deployment scripts, you can use the native access control that each service provides.

- For Service Bus, use [shared access signatures](/azure/service-bus-messaging/service-bus-authentication-and-authorization#shared-access-signature).

- For Azure Cosmos DB, use [keys](/azure/cosmos-db/secure-access-to-data#master-keys).

If the workload needs service-based access, store the preshared secrets in Key Vault. Access the vault through the managed identity of the web application.

Apps access secrets stored in Key Vault. They reference the Key Vault key and value pair. The [sites.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/sites.bicep) file defines the configuration. The Voting App uses the following code.

```bicep
properties: {
  enabled: true
  hostingEnvironmentProfile: {
    id: aseId
  }
  serverFarmId: votingWebPlanName.id
  siteConfig: {
    appSettings: [
      {
        name: 'ASecret'
        value: '@Microsoft.KeyVault(SecretUri=${applicationKeyVault::secretName.secretUriWithVersion})'
      }
    ]
  }
}
```

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. For more information, see the [Cost Optimization pillar in the Well-Architected Framework](/azure/well-architected/cost-optimization). To save money, [Azure reservations](/azure/cost-management-billing/reservations/prepare-buy-reservation) provide one-year or three-year plans for many Azure resources.

Consider the following cost factors for some key services in this architecture.

#### App Service Environment v3

App Service has various [pricing options](https://azure.microsoft.com/pricing/details/app-service/windows). An App Service Environment is deployed by way of the Isolated v2 service plan. This plan includes multiple options for CPU sizes, from I1v2 through I6v2. This reference implementation uses three I1v2 instances.

#### Application Gateway

Application Gateway has various [pricing options](https://azure.microsoft.com/pricing/details/application-gateway/). This implementation uses the Application Gateway Standard v2 and Web Application Firewall v2 SKU, which support autoscaling and zone redundancy. For more information, see [Scale Application Gateway v2 and Web Application Firewall v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#pricing).

#### Azure Managed Redis

Azure Managed Redis has various [pricing options](https://azure.microsoft.com/pricing/details/managed-redis).

#### Other dependencies

Other services that help secure the App Service Environment also have several pricing options:

- [Azure Firewall pricing](https://azure.microsoft.com/pricing/details/azure-firewall)
- [Key Vault pricing](https://azure.microsoft.com/pricing/details/key-vault)
- [Microsoft Entra pricing](https://www.microsoft.com/security/business/microsoft-entra-pricing)

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The deployment scripts in this reference architecture deploy App Service Environment, other services, and the applications inside App Service Environment. After these applications are deployed, your enterprise might plan for CI/CD for app maintenance and upgrades. This section describes common methods that developers use for CI/CD of App Service Environment applications.

You can deploy apps to an internal App Service Environment only from within the virtual network. Use one of the following methods to deploy App Service Environment apps:

- **Use a VM inside the virtual network.** Create a VM inside the App Service Environment virtual network by using the required tools for deployment. To open up the RDP connection to the VM, use an NSG configuration. Copy your code artifacts to the VM, build them, and deploy to the App Service Environment subnet. This method works well to set up an initial build and test development environment. Don't use this method for a production environment because it can't scale to match the required deployment throughput.

- **Use a point-to-site VPN connection from a local workstation.** Extend your App Service Environment virtual network to your development machine. Deploy from your local workstation. This method also works well for an initial development environment but doesn't suit a production environment.

- **Use Azure Pipelines.** Implement a complete CI/CD pipeline that ends in an agent located inside the virtual network. This method suits production environments that require high throughput of deployment. The build pipeline remains entirely outside the virtual network. The deploy pipeline copies the built objects to the build agent inside the virtual network, then deploys to the App Service Environment subnet. For more information, see [Self-hosted Windows agents](/azure/devops/pipelines/agents/v2-windows).

We recommend that you use Azure Pipelines or another CI/CD tool for production environments. The [voting-data-app.yml](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/.github/workflows/voting-data-app.yml) file implements a CI/CD pipeline for the web app in this reference implementation. Similar CI/CD scripts support the [web API](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/.github/workflows/voting-web-app.yml).

Some enterprises might not want to maintain a permanent build agent inside the virtual network. In that case, consider one of the following options:

- **Dynamically create a build agent.** Create a build agent within the development operations (DevOps) pipeline and tear it down after the deployment finishes. This approach adds another step for DevOps but simplifies VM maintenance.

- **Use containers.** Use containers as build agents instead of VMs.

- **Deploy without an agent.** Avoid build agents completely by deploying from a zipped file placed outside the virtual network, typically in a storage account. The App Service Environment and the pipeline must have access to the storage account. The end of the release pipeline can drop a zipped file into the blob storage. The App Service Environment can then pick it up and deploy.

    This approach includes the following limitations:

    - This method disconnects DevOps from the actual deployment process, which makes monitoring and tracing deployment problems difficult.
    - In a locked-down environment with secured traffic, you might need to update access rules for the zipped file in storage.
    - You must install specific extensions and tools on the App Service Environment to deploy from the ZIP file.

    For more information about app deployment methods, see [Run your app in App Service](/azure/app-service/deploy-run-package).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

#### Design scalable apps

This reference architecture structures the application so that you can scale individual components based on usage. Each web app, API, and function deploys in its own App Service plan. You can monitor each app for performance bottlenecks, then [scale it up](/azure/app-service/manage-scale-up) when needed.

#### Scale Application Gateway automatically

Application Gateway supports autoscaling. This feature enables Application Gateway to scale up or down based on traffic load patterns. The reference architecture configures `autoscaleConfiguration` in the [appgw.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/appgw.bicep) file to scale between 0 and 10 extra instances. For more information, see [Scale Application Gateway and Web Application Firewall](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#scaling-application-gateway-and-waf-v2).

## Deploy this scenario

To deploy the reference implementation for this architecture, see the [GitHub readme](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/README.md), and follow the script for *standard deployment*.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Dhanashri Kshirsagar](https://www.linkedin.com/in/dhanashrikr/) | Senior Content PM

Other contributors:

- [Deep Bhattacharya](https://www.linkedin.com/in/deeplydiligent/) | Cloud Solution Architect
- [Suhas Rao](https://www.linkedin.com/in/suhasaraos/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Pipelines YAML schema](/azure/devops/pipelines/yaml-schema)
- [Key Vault](/azure/key-vault/general/overview)
- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines)

## Related resource

- [High availability enterprise deployment that uses App Service Environment](./ase-high-availability-deployment.yml)
