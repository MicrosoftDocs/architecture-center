[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Learn how to build a hybrid app that spans Azure and Azure Stack Hub. This solution also shows you how to use a single on-premises data source for compliance.

Many organizations collect and store massive amounts of sensitive customer data. Frequently they're prevented from storing sensitive data in the public cloud because of corporate regulations or government policy. Those organizations also want to take advantage of the scalability of the public cloud. The public cloud can handle seasonal peaks in traffic, allowing customers to pay for exactly the hardware they need, when they need it.

## Potential use cases

The solution takes advantage of the compliance benefits of the private cloud, combining them with the scalability of the public cloud. The Azure and Azure Stack Hub hybrid cloud provide a consistent experience for developers. This consistency lets them apply their skills to both public cloud and on-premises environments.

The solution deployment guide allows you to deploy an identical web app to a public and private cloud. You can also access a non-internet routable network hosted on the private cloud. The web apps are monitored for load. Upon a significant increase in traffic, a program manipulates DNS records to redirect traffic to the public cloud. When traffic is no longer significant, the DNS records are updated to direct traffic back to the private cloud.

When use this solution:.

- My organization is using a DevOps approach, or has one planned for the near future.
- I want to implement CI/CD practices across my Azure Stack Hub implementation and the public cloud.
- I want to consolidate the CI/CD pipeline across cloud and on-premises environments.
- I want the ability to develop apps seamlessly using cloud or on-premises services.
- I want to leverage consistent developer skills across cloud and on-premises apps.
- I'm using Azure but I have developers who are working in an on-premises Azure Stack Hub cloud.
- My on-premises apps experience spikes in demand during seasonal, cyclical, or unpredictable fluctuations.
- I have on-premises components and I want to use the cloud to scale them seamlessly.
- I want cloud scalability but I want my app to run on-premises as much as possible.

## Architecture

![Architecture diagram](../media/hybrid-cross-cloud-scale-onprem-data.png)  
_Download an [Visio](https://arch-center.azureedge.net/hybrid-cross-cloud-scale-onprem-data.vsdx) of this architecture._

### Data flow

1. The client sends a request to our application.
1. Traffic Manager sends the traffic to some of the available backend.
1. The data is kept on premise, so the app routes to the database by secure networking connections

### Components

#### Azure

- [Azure App Service](https://azure.microsoft.com/services/app-service/) allows you to build and host web apps, RESTful API apps, and Azure Functions. All in the programming language of your choice, without managing infrastructure.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) (VNet) is the fundamental building block for private networks in Azure. VNet enables multiple Azure resource types, such as virtual machines (VM), to securely communicate with each other, the internet, and on-premises networks. The solution also demonstrates the use of additional networking components:

  - app and gateway subnets.
  - a local on-premises network gateway.
  - a virtual network gateway, which acts as a site-to-site VPN gateway connection.
  - a public IP address.
  - a point-to-site VPN connection.
  - Azure DNS for hosting DNS domains and providing name resolution.

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) is a DNS-based traffic load balancer. It allows you to control the distribution of user traffic for service endpoints in different datacenters.
- [Application Insights](hhttps://azure.microsoft.com/services/monitor) is an extensible Application Performance Management service for web developers building and managing apps on multiple platforms.
- [Azure Functions](https://azure.microsoft.com/services/functions/) allows you to execute your code in a serverless environment without having to first create a VM or publish a web app.
- [Autoscale](https://azure.microsoft.com/features/autoscale/) is a built-in feature of Cloud Services, VMs, and web apps. The feature allows apps to perform their best when demand changes. Apps will adjust for traffic spikes, notifying you when metrics change and scaling as needed.

#### [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub/) (Azure services in your datacenter)

- IaaS Compute. Azure Stack Hub allows you to use the same app model, self-service portal, and APIs enabled by Azure. Azure Stack Hub IaaS allows a broad range of open-source technologies for consistent hybrid cloud deployments. The solution example uses a Windows Server VM to SQL Server, for example.
- Just like the Azure web app, the solution uses [Azure App Service on Azure Stack Hub](https://docs.microsoft.com/azure-stack/operator/azure-stack-app-service-overview) to host the web app.
- The Azure Stack Hub Virtual Network works exactly like the Azure Virtual Network. It uses many of the same networking components, including custom hostnames.

#### Azure DevOps Services

- Sign up. Quickly set up continuous integration for build, test, and deployment. For more information, see [Sign up, sign in to Azure DevOps](https://docs.microsoft.com/azure/devops/user-guide/sign-up-invite-teammates).
- Use [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines/) for Continuous Integration/Continuous delivery. Azure Pipelines allows you to manage hosted build and release agents and definitions.
- Leverage multiple code repositories to streamline your development pipeline. Use existing code repositories in GitHub, Bitbucket, Dropbox, OneDrive, and [Azure Repos](https://azure.microsoft.com/services/devops/repos/).

### Alternatives

For web applications, you can use [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/front-door-overview). It works at Layer 7 (HTTP/HTTPS layer) using anycast protocol with split TCP and Microsoft's global network to improve global connectivity. Based on your routing method you can ensure that Front Door will route your client requests to the fastest and most available application backend.

## Considerations

### Reliability

It's important to think about how to deal with networking or power failures. Leverage the [Resiliency and Dependencies](/azure/architecture/framework/resiliency/design-resiliency), [Best Practices](/azure/architecture/framework/resiliency/design-best-practices), and other [reliability guidance](/azure/architecture/framework/resiliency/) from the Microsoft Azure Well Architected Framework (WAF) to improve the solution resiliency.

### Security

#### Ensure compliance, and data sovereignty

Azure Stack Hub lets you run the same service across multiple countries as you would if using a public cloud. Deploying the same app in datacenters in each country allows data sovereignty requirements to be met. This capability ensures personal data is kept within each country's borders.

##### Azure Stack Hub - security posture

There's no security posture without a solid, continuous servicing process. For this reason, Microsoft invested in an orchestration engine that applies patches and updates seamlessly across the entire infrastructure.

Thanks to partnerships with Azure Stack Hub OEM partners, Microsoft extends the same security posture to OEM-specific components, like the Hardware Lifecycle Host and the software running on top of it. This partnership ensures Azure Stack Hub has a uniform, solid security posture across the entire infrastructure. In turn, customers can build and secure their app workloads.

##### Use of service principals via PowerShell, CLI, and Azure portal

To give resource access to a script or app, set up an identity for your app and authenticate the app with its own credentials. This identity is known as a service principal and lets you:

- Assign permissions to the app identity that are different than your own permissions and are restricted to precisely the app's needs.
- Use a certificate for authentication when executing an unattended script.
  For more information about service principal creation and using a certificate for credentials, see [Use an app identity to access resources](/active-directory/develop/howto-create-service-principal-portal).

### Operational excellence

#### A single, consistent development approach

Azure and Azure Stack Hub let you use a consistent set of development tools across the organization. This consistency makes it easier to implement a practice of continuous integration and continuous development (CI/CD). Many apps and services deployed in Azure or Azure Stack Hub are interchangeable and can run in either location seamlessly.

A hybrid CI/CD pipeline can help you:

- Initiate a new build based on code commits to your code repository.
- Automatically deploy your newly built code to Azure for user acceptance testing.
- Once your code has passed testing, automatically deploy to Azure Stack Hub.

##### A single, consistent identity management solution

Azure Stack Hub works with both Azure Active Directory (Azure AD) and Active Directory Federation Services (ADFS). Azure Stack Hub works with Azure AD in connected scenarios. For environments that don't have connectivity, you can use ADFS as a disconnected solution. Service principals are used to grant access to apps, allowing them to deploy or configure resources through Azure Resource Manager.

### Performance efficiency

Azure and Azure Stack Hub are uniquely suited to support the needs of today's globally distributed business.

#### Hybrid cloud without the hassle

Microsoft offers an unrivaled integration of on-premises assets with Azure Stack Hub and Azure in one unified solution. This integration eliminates the hassle of managing multiple point solutions and a mix of cloud providers. With cross-cloud scaling, the power of Azure is just a few clicks away. Just connect your Azure Stack Hub to Azure with cloud bursting and your data and apps will be available in Azure when needed.

- Eliminate the need to build and maintain a secondary DR site.
- Save time and money by eliminating tape backup and house up to 99 years of backup data in Azure.
- Easily migrate running Hyper-V, Physical (in preview), and VMware (in preview) workloads into Azure to leverage the economics and elasticity of the cloud.
- Run compute intensive reports or analytics on a replicated copy of your on-premises asset in Azure without impacting production workloads.
- Burst into the cloud and run on-premises workloads in Azure, with larger compute templates when needed. Hybrid gives you the power you need, when you need it.
- Create multi-tier development environments in Azure with a few clicks–even replicate live production data to your dev/test environment to keep it in near real-time sync.

#### Economy of cross-cloud scaling with Azure Stack Hub

The key advantage to cloud bursting is economical savings. You only pay for the additional resources when there's a demand for those resources. No more spending on unnecessary extra capacity or trying to predict demand peaks and fluctuations.

#### Reduce high demand loads into the cloud

Cross-cloud scaling can be used to shoulder processing burdens. Load is distributed by moving basic apps to the public cloud, freeing up local resources for business-critical apps. An app can be applied to the private cloud, then burst to the public cloud only when necessary to meet demands.

## Next Steps

To learn more about topics introduced in this article:

- Watch [Dynamically scale apps between datacenters and public cloud](https://www.youtube.com/watch?v=2lw8zOpJTn0) for an overview of how this pattern is used.
- See [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations) to learn more about best practices and to answer additional questions you might have.
- This solution uses the [Azure Stack family of products](/azure-stack), including Azure Stack Hub. See the Azure Stack family of products and solutions to learn more about the entire portfolio of products and solutions.
- [Extend an on-premises network using VPN](/azure/architecture/reference-architectures/hybrid-networking/vpn). This reference architecture shows how to extend a network from on premises or from Azure Stack into an Azure virtual network, using a site-to-site virtual private network (VPN). Traffic flows between the on-premises network and Azure through an IPSec VPN tunnel or through the Azure Stack multitenant VPN gateway

When you're ready to test the solution example, continue with the cross-cloud scaling (on-premises data) solution deployment guide. The deployment guide provides step-by-step instructions for deploying and testing its components.

## Related resources

- [Hybrid architecture design](./hybrid/hybrid-start-here.md)
- [Extend an on-premises network using VPN](./reference-architectures/hybrid-networking/vpn.yml)
