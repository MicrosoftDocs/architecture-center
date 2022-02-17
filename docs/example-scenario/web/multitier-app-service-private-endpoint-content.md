The front-end application that makes calls to one or more API applications behind it is known as a multi-tier web application. Though not a complex concept, the architecture usually gets complicated when a user wants to secure the API applications by making it non-internet accessible. 

API applications can be secured in several ways where they can be accessed from your front-end applications only, which involves securing your API application’s inbound traffic. 

Below is the reference architecture that showcases the use of Private endpoints for secure communications between app services in a multi-tier environment.

A network interface that uses Azure private link to connect you privately and securely to your Web App is known as Private endpoint. It uses a private IP address from the virtual network, effectively bringing the web app into that network. This feature is applicable for only inbound flows to your web app. 

With [Private endpoints], there is no risk of data exfiltration since because the only thing you can reach across the private endpoint is the app with which it's configured.

## Potential use cases

Highlighting some of the use cases of this architecture:
- Applications that require private connections to a back-end API app
- Restricting app access from resources in a virtual network.
- Exposing your app on a private IP in virtual network.
- Connect from a Web App to Azure Storage, Azure Event Grid ,Azure Cognitive Search, Azure Cosmos DB or any other service supporting an [Azure Private Endpoint] for inbound connectivity.

## Architecture 

diagram

link to visio 

Here's the traffic flow and basic configuration of the architecture:
1. Front-end web app connects to Azure through an AppserviceSubnet subnet in an Azure Virtual Network using Azure App Service [regional VNet Integration],
2. [Private endpoint] for the API app is set up by the [Azure Private Link] in the PrivateLinkSubnet of the Virtual Network.
3. The Front-end web app connects to the back-end API app private endpoint through PrivateLinkSubnet of the Virtual Network.
4. The API app is made inaccessible from the public internet, allowing traffic coming from PrivateLinkSubnet only.

### DNS configuration

The requested URL must match the name of your Web App while using Private Endpoint. For example, mywebappname.azurewebsites.net. So, upon deploying Private endpoint, DNS entry will be updated to the canonical name mywebapp.privatelink.azurewebsites.net. 

It’s a must to setup a private DNS server or an Azure DNS private zone. Create a DNS zone **privatelink.azurewebsites.net**

After this configuration, you will be able to reach your Web App privately with the default name mywebappname.azurewebsites.net. For more detail information, see [DNS]. 

### Components

- [Azure App Service] allows you to build and host web apps and API apps in your chosen programming language without having to manage infrastructure. 
- [Azure Virtual Network] is the fundamental building block that lets you have your own network in Azure. It offers a highly secure environment for running your Azure resources like virtual machines (VMs).
- [Azure Private Link] provides private connectivity that enables you to access Azure PaaS services like Azure Storage and SQL Database, or to customer or partner services from a Virtual network.

### Alternatives

One way to implement the above solution is by deploying both the front-end app and the API app in the same ILB ASE and making the front-end app directly internet accessible with an application gateway. For information about App Service Environments, see [Introduction to the App Service Environments].

Another method is where you can deploy the front-end app in the multitenant service and the API app in an ILB ASE. Additionally, both the front-end app and the API app can also be hosted in the multitenant service.

Some other ways to secure your web apps are:
- App-assigned addresses
- Azure Service endpoint
- Access restrictions
 
For more information, see [App Service networking features].

## Benefits

The following are the benefits of using Private Endpoint for your Web App service:
- Configuring the Private Endpoint with your web app eliminates public exposure and makes it more secure
- Lets you connect securely from on-premises networks that connect to the VNet using a VPN or ExpressRoute private peering
- Prevents data exfiltration

If you are seeking just a secure connection between the VNet and the Web App, a Service Endpoint should be your go-to solution. However, if the requirement is to reach the web app from on-premises through an Azure Gateway, a regionally peered VNet or a globally peered VNet, then choose Private Endpoint. 

## Considerations

- When using Private endpoint for the web app, remote debugging feature is not available. In such a scenario, you need to deploy a code to a slot and remote debug it
- There is no FTP access while using private endpoint to the web app
- Private Endpoints do not support IP-Based SSL

### Availability

- A system can't be highly available unless it's reliable. For techniques to increase reliability, see [Reliability patterns].
- Consider Private Link availability when considering the SLA of the entire architecture. The Private Link service has an availability [SLA of 99.99%]

### Scalability

- Performance efficiency is the ability of your workload to scale to meet the demands placed on it in an efficient manner. Be aware of performance efficiency patterns as you design and build your cloud application. For more information, see [Performance Efficiency patterns].
- Learn about scaling a basic web app in [Scaling the App Service app]. Review the other articles in the same section for ideas regarding other architectures.
- For more performance efficiency ideas, see [Performance efficiency checklist].

## Pricing 

Use the [Azure Pricing Calculator] to estimate costs.

Some aspects that affect the cost of an implementation are:
- The scalability of the solution—how well it supports changes in demand.
- Whether the solution runs continuously or intermittently.
- The service tiers chosen.

## Next steps

- App Service documentation
- App Service networking features
- Integrate your app with an Azure virtual network
- Virtual Network service endpoints
- Introduction to the App Service Environments
- Private link resource
- App Service overview
- Reliability patterns
- Performance Efficiency patterns

## Related resources
- Basic web application
- Web application monitoring on Azure
- Highly available multi-region web application
- Scalable web application

