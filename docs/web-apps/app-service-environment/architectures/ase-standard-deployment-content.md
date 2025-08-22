This reference architecture demonstrates a common enterprise workload that uses App Service Environment version 3. It also describes best practices for strengthening the security of the workload.

> [!NOTE]
> [App Service Environment](/azure/app-service/environment/overview) version 3 is the main component of this architecture. Versions 1 and 2 [retired on August 31, 2024](https://azure.microsoft.com/updates/app-service-environment-v1-and-v2-retirement-announcement/).

![GitHub logo](../../../_images/github.png) A reference implementation for this architecture is available on [GitHub](https://github.com/mspnp/app-service-environments-ILB-deployments).

## Architecture

:::image type="complex" source="../_images/app-service-environment.png" alt-text="Diagram that shows an architecture for an App Service Environment deployment." lightbox="../_images/app-service-environment.png" border="false":::
The diagram shows a secure, zone‑redundant App Service Environment inside an Azure virtual network. Traffic enters through an Application Gateway from the internet, then routes to the ILB of the App Service Environment that hosts a web app, a private API, and a function app. Traffic flows to the web app. Outbound traffic flows through Azure Firewall. The environment connects to Azure services such as Service Bus, Azure Cosmos DB, SQL Server, and Key Vault through private endpoints and private DNS. Azure Cache for Redis provides in‑network caching. A dashed arrow points from GitHub Actions outside the virtual network to a jumpbox virtual machine in a subnet. Another dashed arrow points from this subnet to the App Service Environment subnet. Microsoft Entra ID is in the right top corner of the diagram to imply that it handles authentication.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/app-service-environment.vsdx) of this architecture.*

### Workflow

You can deploy App Service Environment in two ways:

- As an external App Service Environment with a public IP address

- As an internal App Service Environment with an internal IP address that belongs to an internal load balancer (ILB)

This reference architecture deploys an enterprise web application in an internal App Service Environment, also called an *ILB App Service Environment*. Use an ILB App Service Environment in scenarios that require the following capabilities:

- Host intranet applications with enhanced security in the cloud and access them via a site-to-site VPN or Azure ExpressRoute.

- Provide a layer of protection for apps by using a web application firewall (WAF).
- Host apps in the cloud that aren't listed in public DNS servers.
- Create internet-isolated back-end apps that front-end apps can integrate with in a highly secure way.

Always deploy an App Service Environment in its own subnet in the enterprise virtual network to maintain strict control of incoming and outgoing traffic. Within this subnet, Azure App Service applications run in one or more [App Service plans](/azure/app-service/overview-hosting-plans), which are collections of physical resources required to run the app. Depending on the complexity and resource requirement, multiple apps can share an App Service plan.

This reference implementation deploys a web app named *Voting App*, which interacts with a private web API and a function. It also deploys a dummy web app named *Test App* to demonstrate multiple-app deployments. Each App Service app runs in its own App Service plan, which enables independent scaling when needed. The App Service Environment infrastructure manages all resources required by these hosted apps, including storage, compute, and scaling.

The simple voting app in this implementation allows users to view existing entries, create new entries, and vote on existing entries. The web API creates and retrieves entries and votes. The data is stored in a SQL Server database. To demonstrate asynchronous data updates, the web app queues newly added votes in an Azure Service Bus instance. The function picks up queued votes and updates the SQL database. Azure Cosmos DB stores a mock-up ad that the web app retrieves to display in the browser. The application uses Azure Cache for Redis for cache management. A Premium tier Azure Cache for Redis is configured in the same virtual network as the App Service Environment, and it runs in its own subnet. This setup provides enhanced security and isolation for the cache.

The web apps are the only components that can access the internet via Azure Application Gateway. An internet client can't access the API and the function. A WAF that's configured on Application Gateway protects the inbound traffic.

### Components

The following services help secure the App Service Environment in this architecture:

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a private Azure cloud network owned by an enterprise. It provides enhanced network-based security and isolation. This architecture deploys App Service Environment into a subnet of the enterprise-owned virtual network. App Service Environment allows the enterprise to tightly control that network space and the resources that it accesses by using network security groups and private endpoints. 

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is an application-level web traffic load balancer that has Transport Layer Security (TLS) or Secure Sockets Layer (SSL) offloading and a WAF. It accepts incoming traffic on a public IP address and routes it to the application endpoint in the ILB App Service Environment. This application-level routing can route traffic to multiple apps within the same ILB App Service Environment. For more information, see [Application Gateway multisite hosting](/azure/application-gateway/multiple-site-overview).

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) restricts the outbound traffic from the web application. Outgoing traffic that doesn't go through the private endpoint channels and a route table required by App Service Environment routes to the firewall subnet. For simplicity, this architecture configures all private endpoints on the services subnet.

- [Microsoft Entra ID](/entra/fundamentals/whatis) provides access rights and permissions management to Azure resources and services. [*Managed identities*](/entra/identity/managed-identities-azure-resources/overview) assign identities to services and apps. Microsoft Entra ID manages the identities. These identities can authenticate to any service that supports Microsoft Entra authentication. This approach removes the need to explicitly configure credentials for these apps. This architecture assigns a managed identity to the web app.

- [Azure Key Vault](/azure/key-vault/general/overview) stores secrets and credentials that the apps require. Use this option instead of storing secrets directly in the application.

- [GitHub Actions](/azure/developer/github/github-actions) provides continuous integration and continuous deployment (CI/CD) capabilities in this architecture. The App Service Environment is in the virtual network, so a virtual machine serves as a jumpbox inside the virtual network to deploy apps in the App Service plans. The action builds the apps outside the virtual network. For enhanced security and seamless Remote Desktop Protocol (RDP) and Secure Shell (SSH) connectivity, consider using [Azure Bastion](/azure/bastion/bastion-overview) for the jumpbox.

### Multisite configuration

:::image type="complex" source="../_images/app-service-environment-multi-site.png" alt-text="Diagram that shows a multisite deployment." lightbox="../_images/app-service-environment-multi-site.png" border="false":::
The diagram has a virtual network that includes two subnets, Application Gateway subnet and App Service Environment subnet. Application Gateway resides in its own subnet. It points to a private DNS zone labeled default-appname.ase-domain.appserviceenvironment.net that reside outside the virtual network. The arrow is labeled DNS lookup of ILB IP. Additional text near the gateway shows the terms gateway IP, back-end pool, override domain name, listener, and CA-signed certificate. An arrow marked HTTPS points from an icon labeled appname.domain.com to the gateway and then to an ILB in the App Service Environment subnet. App Service Environment links to three separate App service components. It points to App Service for App 1 via an arrow labeled default-appname. This component includes the label HTTPS and default certificate. App Service Environment also points to App Service for App 2 and App service for API via separate dashed arrows.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/app-service-environment.vsdx) of this architecture.*

An internal App Service Environment can host several web apps and APIs that have HTTP endpoints. These applications aren't exposed to the public internet because the ILB IP can only be accessed from within the virtual network. [Application Gateway](/azure/application-gateway/overview) selectively exposes these applications to the internet. The App Service Environment assigns a default URL to each App Service application as `<default-appName>.<app-service-environment-domain>.appserviceenvironment.net`. A [private DNS zone](/azure/dns/private-dns-overview) is created that maps the App Service Environment domain name to the App Service Environment ILB IP address. This approach avoids custom DNS for app access within the virtual network.

Application Gateway is configured to include a [listener](/azure/application-gateway/configuration-overview#listeners) that accepts HTTP requests on the gateway's IP address. For simplicity, this implementation doesn't use a public DNS name registration. You must modify the localhost file on your computer to point an arbitrarily chosen URL to the Application Gateway IP. The listener uses a self-signed certificate to process these requests. Application Gateway has [back-end pools](/azure/application-gateway/configuration-overview#back-end-pool) for each App Service application's default URL. A [routing rule](/azure/application-gateway/configuration-overview#request-routing-rules) is configured to connect the listener to the back-end pool. [HTTP settings](/azure/application-gateway/configuration-overview#http-settings) determine whether the connection between the gateway and the App Service Environment uses encryption. These settings also override the incoming HTTP host header with a host name from the back-end pool. This implementation uses default certificates created for the default App Service Environment app URLs, and the gateway trusts those certificates. The request redirects to the default URL of the corresponding app. The private [DNS linked to the virtual network](/azure/dns/private-dns-virtual-network-links) forwards this request to the ILB IP. The App Service Environment then forwards the request to the requested app service. Any HTTP communication within the App Service Environment apps goes through private DNS. You must configure the listener, back-end pool, routing rule, and HTTP settings on the application gateway for each App Service Environment app.

Review [appgw.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/appgw.bicep) and [dns.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/dns.bicep) to learn how these configurations allow multiple sites. The web app named `testapp` is an empty app created to demonstrate this configuration. The deployment script [commands_std.azcli](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/commands_std.azcli) accesses the JSON files. And [commands_ha.azcli](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/commands_ha.azcli) uses the same files for [a high-availability multisite App Service Environment deployment](./ase-high-availability-deployment.yml).

## Scenario details

[Azure App Service](/azure/app-service/overview) is a PaaS service used to host a variety of apps on Azure, including web apps, API apps, functions, and mobile apps. You can use [App Service Environment](/azure/app-service/environment/intro) to deploy App Service apps in a subnet in your own [Azure Virtual Network](/azure/virtual-network), which provides an isolated, highly scalable, and dedicated environment for your cloud workloads.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### App Service Environment

An internal App Service Environment resides in the enterprise virtual network, hidden from the public internet. It enables you to secure back-end services, such as web APIs and functions, at the network level. Any App Service Environment app that has an HTTP endpoint can be accessed through the ILB from within the virtual network. Application Gateway forwards requests to the web app through the ILB. The web app itself goes through the ILB to access the API. The critical back-end components, like the API and the function, can't be accessed from the public internet.

Default certificates are created for each app service for the default domain name that the App Service Environment assigns. This certificate help secure traffic between the gateway and the app and might be required in some scenarios. They don't appear in the client browser and responds only to the certificates configured on Application Gateway.

#### Application Gateway

Application Gateway can [use TLS or SSL to encrypt and protect all traffic](/azure/application-gateway/ssl-overview) from web browsers. You can configure encryption in two ways:

- **Encryption terminated at the gateway.**  For this method, the back-end pools are configured for HTTP. The encryption stops at the gateway, and traffic between the gateway and the app service is unencrypted. Encryption is CPU-intensive, so unencrypted traffic at the back end improves performance and allows simpler certificate management. This approach provides a reasonable level of security because the back end is protected by the network configuration.

- **End-to-end encryption.** In some scenarios that have specific security or compliance requirements, the traffic might need to be encrypted between the gateway and the app. This configuration uses HTTPS connections and requires certificates at the back-end pool.

This reference implementation uses self-signed certificates for Application Gateway. For production code, use a certificate issued by a Certificate Authority. For a list of supported certificate types, see [Certificates supported for TLS termination](/azure/application-gateway/ssl-overview#certificates-supported-for-tls-termination). For information about how to create gateway-terminated encryption, see [Configure an application gateway with TLS termination by using the Azure portal](/azure/application-gateway/create-ssl-portal). The following example from `appgw.bicep` configures HTTP listeners programmatically.

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

The reference implementation demonstrates end-to-end encryption for traffic between Application Gateway and the web apps in the App Service Environment. It uses the default SSL certificates. The back-end pools in this implementation are configured to redirect HTTPS traffic. They also overide the host name with the default domain names associated with the web apps. Application Gateway trusts the default SSL certificates because Microsoft issues them. For more information, See [Configure App Service by using Application Gateway](/azure/application-gateway/configure-web-app-portal). The following example from `appgw.bicep` shows how the reference implementation configures this approach.

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

[Web Application Firewall on Application Gateway](/azure/web-application-firewall/ag/ag-overview) protects the web apps from malicious attacks, such as SQL injection. It also integrates with Azure Monitor to monitor attacks by using a real-time log. You must [enable WAF needs on the gateway](/azure/web-application-firewall/ag/application-gateway-web-application-firewall-portal). The reference implementation enables WAF programmatically in the `appgw.bicep` file by using the following code.

```bicep
webApplicationFirewallConfiguration: {
  enabled: true
  firewallMode: 'Detection'
  ruleSetType: 'OWASP'
  ruleSetVersion: '3.2'
}
```

#### Virtual Network

You can associate [network security groups](/azure/virtual-network/security-overview#how-traffic-is-evaluated) with one or more subnets in the virtual network. These groups define security rules that allow or deny traffic to flow between various Azure resources. This architecture associates a separate network security group for each subnet, which enables fine-tuned rules based on the services in that subnet.

- The configuration for the network security group of the App Service Environment subnet appears in the file [ase.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/ase.bicep).

- The configuration for the network security group for the Application Gateway subnet appears in the file [appgw.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/appgw.bicep).

Both configurations use the resource `"type": "Microsoft.Network/networkSecurityGroups"`.

[Private endpoints](/azure/private-link/private-endpoint-overview) enable enhanced-security private connectivity between clients and Azure services over a private network. They provide a privately accessed IP address for the Azure service, which enables enhanced-security traffic to an Azure Private Link resource. The platform validates network connections and allows only connections that target the specified Private Link resource. 

Private endpoints support network policies, such as network security groups, user-defined routes, and application security groups. To improve security, enable private endpoints for any Azure service that supports them. To help secure the service in the virtual network, disable public access to block access from the public internet. This architecture configures private endpoints for the services that support it, including Azure Service Bus, SQL Server, Key Vault, and Azure Cosmos DB. You can see the configuration in [privatendpoints.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/privateendpoints.bicep).

To enable private endpoints, you also need to configure private DNS zones. For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

#### Firewall

[Azure Firewall](/azure/firewall/overview) and private endpoints complement each other. Private endpoints help protect resources by allowing only traffic that originates from your virtual network. Azure Firewall enables you to restrict the outbound traffic from your applications. We recommend that you allow all outbound traffic to pass through the firewall subnet, including private endpoint traffic. This approach enables better monitoring of the outbound traffic. For simplicity, this reference architecture configures all private endpoints on the services subnet instead of on the firewall subnet.

For more information, see [Configure Azure Firewall with your App Service Environment](/azure/app-service/environment/networking#network-routing). The firewall monitors and controls any traffic that doesn't traverse the private endpoints and virtual network route table.

<a name='azure-active-directory'></a>

#### Microsoft Entra ID

Microsoft Entra ID provides security features to authenticate applications and authorize access to resources. This reference architecture uses two key features of Microsoft Entra ID, managed identities and Azure role-based access control (RBAC).

On cloud applications, you must secure the credentials required to authenticate to cloud services. Ideally, the credentials should never appear on developer workstations or in source control. Key Vault securely stores credentials and secrets, but the app still has to authenticate to Key Vault to retrieve them. **Managed identities for Azure resources** provides Azure services with an automatically managed identity in Microsoft Entra ID. You can use this identity to authenticate to any service that supports Microsoft Entra authentication, including Key Vault, without any credentials in the application.

[Azure RBAC](/azure/role-based-access-control/overview) manages access to Azure resources by defining the following conditions:

- Which entity has access, such as user, managed identity, or security principal

- What type of access it has, such as owner, contributor, reader, or admin
- The scope of access, such as resource, resource group, subscription, or management group

You can help secure access to App Service Environment applications by tightly controlling the role required and the type of access for each app. This approach allows multiple apps to deploy on the same App Service Environment from different development teams. For example, one team might handle the front end, and one team might handle the back end. Azure RBAC can limit each team's access to the apps that they work on. To create roles suitable for your organization, see [Azure custom roles](/azure/role-based-access-control/custom-roles).

#### Key Vault

Some services support managed identities and use Azure RBAC to set up permissions for the app. For example, see the built-in [Service Bus roles](/azure/service-bus-messaging/service-bus-managed-service-identity#built-in-rbac-roles-for-azure-service-bus) and [Azure RBAC in Azure Cosmos DB](/azure/cosmos-db/role-based-access-control). You must have *User Access Administrator* access to the subscription to grant these permissions. The *Contributor* role can deploy these services. To allow a wider team of developers to run the deployment scripts, you can use the native access control provided by each service.

- For Service Bus, use [shared access signatures](/azure/service-bus-messaging/service-bus-authentication-and-authorization#shared-access-signature).

- For Azure Cosmos DB, use [keys](/azure/cosmos-db/secure-access-to-data#master-keys).

If the workload needs service-based access, you should store those pre-shared secrets in Key Vault. Access the vault through the managed identity of the web application.

Apps access secrets stored in Key Vault. They reference the Key Vault key and value pair. This configuration is defined in the [sites.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/sites.bicep) file. The Voting App uses the following code.

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

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview). Azure Reservations help you save money by committing to one-year or three-years plans for many Azure resources. Read more in the article [Buy a reservation](/azure/cost-management-billing/reservations/prepare-buy-reservation).

Here are some points to consider for some of the key services used in this architecture.

#### App Service Environment v3

There are various [pricing options available for App Service](https://azure.microsoft.com/pricing/details/app-service/windows). An App Service Environment is deployed using the Isolated v2 Service Plan. Within this plan, there are multiple options for CPU sizes, from I1v2 through I6v2. This reference implementation uses three I1v2s per instance.

#### Application Gateway

[Application Gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/) provides various pricing options. This implementation uses the Application Gateway Standard v2 and WAF v2 SKU, which supports autoscaling and zone redundancy. See [Scaling Application Gateway v2 and WAF v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#pricing) for more information about the pricing model used for this SKU.

#### Azure Cache for Redis

[Azure Cache for Redis pricing](https://azure.microsoft.com/pricing/details/cache) provides the various pricing options for this service. This architecture uses the *Premium SKU*, for the virtual network support.

#### Additional dependencies

Following are pricing pages for other services that are used to lock down the App Service Environment:

- [Azure Firewall pricing](https://azure.microsoft.com/pricing/details/azure-firewall)
- [Key Vault pricing](https://azure.microsoft.com/pricing/details/key-vault)
- [Microsoft Entra pricing](https://www.microsoft.com/security/business/microsoft-entra-pricing)

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The deployment scripts in this reference architecture are used to deploy App Service Environment, other services, and the applications inside App Service Environment. Once these applications are deployed, enterprises might want to have a plan for continuous integration and deployment for app maintenance and upgrades. This section shows some of the common ways developers use for CI/CD of App Service Environment applications.

Apps can be deployed to an internal App Service Environment only from within the virtual network. The following three methods are widely used to deploy App Service Environment apps:

- **Manually inside the Virtual Network:** Create a virtual machine inside the App Service Environment virtual network with the required tools for the deployment. Open up the RDP connection to the VM using an NSG configuration. Copy your code artifacts to the VM, build, and deploy to the App Service Environment subnet. This is a simple way to set up an initial build and test development environment. It is however not recommended for production environment since it cannot scale the required deployment throughput.

- **Point to site connection from local workstation:** This allows you to extend your App Service Environment virtual network to your development machine, and deploy from there. This is another way to set up an initial dev environment, and not recommended for production.

- **Through Azure Pipelines:** This implements a complete CI/CD pipeline, ending in an agent located inside the virtual network. This is ideal for production environments requiring high throughput of deployment. The build pipeline remains entirely outside the virtual network. The deploy pipeline copies the built objects to the build agent inside the virtual network, and then deploys to the App Service Environment subnet. For more information, read this discussion on the [self-hosted build agent between Pipelines and the App Service Environment virtual network](/azure/devops/pipelines/agents/v2-windows).

Using Azure Pipelines is recommended for production environments. Scripting CI/CD with the help of [Azure Pipelines YAML schema](/azure/devops/pipelines/yaml-schema) helps to automate the build and deployment processes. The [azure-pipelines.yml](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/code/web-app-ri/VotingWeb/azure-pipelines.yml) implements such a CI/CD pipeline for the web app in this reference implementation. There are similar CI/CD scripts for the [web API](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/code/web-app-ri/VotingData/azure-pipelines.yml) as well as the [function](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/code/function-app-ri/azure-pipelines.yml). Read [Use Azure Pipelines](/azure/devops/pipelines/get-started/pipelines-get-started) to learn how these are used to automate CI/CD for each application.

Some enterprises may not want to maintain a permanent build agent inside the virtual network. In that case, you can choose to create a build agent within the DevOps pipeline, and tear it down once the deployment is completed. This adds another step in the DevOps, however it lowers the complexity of maintaining the VM. You may even consider using containers as build agents, instead of VMs. Build agents can also be completely avoiding by deploying from a *zipped file placed outside the virtual network*, typically in a storage account. The storage account will need to be accessible from the App Service Environment. The pipeline should be able to access the storage. At the end of the release pipeline, a zipped file can be dropped into the blob storage. The App Service Environment can then pick it up and deploy. Be aware of the following limitations of this approach:

- There is a disconnect between the DevOps and the actual deployment process, leading to difficulties in monitoring and tracing any deployment problems.

- In a locked down environment with secured traffic, you may need to change the rules to access the zipped file on the storage.
- You will need to install specific extensions and tools on the App Service Environment to be able to deploy from the zip.

To know some more ways the apps can be deployed to the App Service plans, read [the App Service articles focusing on deployment strategies](/azure/app-service/deploy-run-package).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

#### Design scalable apps

The application in this reference architecture is structured so that individual components can be scaled based on usage. Each web app, API, and function is deployed in its own App Service plan. You can monitor each app for any performance bottlenecks, and then [scale it up](/azure/app-service/manage-scale-up) if required.

#### Autoscaling Application Gateway

Autoscaling can be enabled on Azure Application Gateway V2. This allows Application Gateway to scale up or down based on the traffic load patterns. This reference architecture configures `autoscaleConfiguration` in the file [appgw.bicep](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/templates/appgw.bicep) to scale between zero and 10 additional instances. See [Scaling Application Gateway and WAF v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#scaling-application-gateway-and-waf-v2) for more details.

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

- [Run your app in Azure App Service directly from a ZIP package](/azure/app-service/deploy-run-package)
- [Azure Pipelines YAML schema](/azure/devops/pipelines/yaml-schema)
- [Get your management addresses from API](/azure/app-service/environment/management-addresses#get-your-management-addresses-from-api)
- [Azure Key Vault](/azure/key-vault)
- [Azure Pipelines](/azure/devops/pipelines)

## Related resources

To learn how to extend this architecture to support high availability, read [High availability app deployment via App Service Environment](./ase-high-availability-deployment.yml).
