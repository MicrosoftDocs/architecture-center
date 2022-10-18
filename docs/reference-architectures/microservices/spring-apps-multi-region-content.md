This reference architecture details how to run multiple instances of an Azure Spring Apps service across multiple regions in an active/active and highly available configuration.

For some scenarios you would like your application to be available in multiple Azure regions. This is the case when you would like to have global reach for your application and for instance make it available in both Europe, Asia and the Americas. It brings the workload closer to the end user, making latency as low as possible. Or you can make use of multiple regions to increase the overall SLA of your application. You might also use a secondary region as a failover site for your first region and opt for an active/passive setup of 1 or more regions.

This architecture describes a multi region setup for Azure Spring Apps service. It also takes into account how you load balance the incoming requests to your application to 1 of the regions your application is deployed in. It also provides host name preservation all the way from the browser request to your application code. [**Deploy this scenario**.](#deploy-this-scenario)

## Architecture

![Multi region Azure Spring Apps reference architecture](./_images/ha-zr-spring-apps-reference-architecture.png)

Download a [Visio file](https://arch-center.azureedge.net/ha-zr-spring-apps-reference-architecture.vsdx) that contains this architecture diagram.

### Workflow

The following workflow corresponds to the above diagram:

- **User browser**. The user navigates to the application by using the applications HTTP host name, for instance `www.contoso.com`.

- **Azure DNS**. Either Azure DNS or another public DNS service will need to be configured to forward the request for this host name to the Azure Front Door service.

- **Azure Front Door**. Azure Front Door is configured with this same host name and a certificate signed by a certificate authority for this host name. Front door is also configured with multiple origins for the requests, one per region you want to deploy your application to. Each origin is pointing to an Application Gateway in this region. Azure Front Door service can use multiple load balancing configurations to forward the request to one region or the other. Currently the solution is configured with an equal weight load balancing rule between the 2 regions.

- **Application Gateway**. Each region you want to deploy to will have an Application Gateway configured with a Web Application Firewall. The Web Application Firewall will only allow incoming calls from your specific Azure Front Door service. The Application Gateway is also configured with the same host name which is backed by the same certificate from a well known certificate authority. In each region, the Application Gateway will send the call to the Azure Spring Apps load balancer.

- **Azure Spring Apps**. Azure Spring Apps will be deployed inside a virtual network, in each region. Incoming calls to the Azure Spring Apps load balancer are only allowed from the Application Gateway. This is where your application workload will run.

- **MySQL Server**. As a database in this setup we are using Azure MySQL Server, however each database would be ok for data storage. Do note that data syncing may also be needed by your application, this architecture will not describe data sychonisation. You should double check with the data service of your choice what the best setup would be for syncing the data between regions. An additional option would be using Azure CosmosDb as a backend for storing data with multi master write enabled.

- **Key Vault**. Key Vault is used in this architecture to store both application secrets, like database username and password, but also the certificate used by Azure Spring Apps, Application Gateway and Azure Front Door service.

### Components

- [Azure DNS Service](https://learn.microsoft.com/azure/dns/dns-overview) is a hosting service for DNS domains that provides name resolution by using Microsoft Azure infrastructure. In this setup Azure DNS can be used for DNS resolution from your custom domain to your Azure Front Door endpoint.
- [Azure Front Door Service](https://learn.microsoft.com/azure/frontdoor/front-door-overview) can help you deliver higher availability, lower latency, greater scale, and more secure experiences to your users wherever they are. In this solution it is used to load balance incoming calls to the regions that host your workload.
- [Azure Application Gateway Service](https://learn.microsoft.com/azure/application-gateway/overview) is a web traffic load balancer that enables you to manage traffic to your web applications. It is used as a local reverse proxy in each region you are running your application.
- [Azure Web Application Firewall](https://learn.microsoft.com/azure/web-application-firewall/overview) provides centralized protection of your web applications from common exploits and vulnerabilities. It is configured on the Application Gateway to only allow incoming calls from the Azure Front Door service and to track OWASP exploits.
- [Azure Spring Apps Service](https://learn.microsoft.com/azure/spring-apps/overview) makes it easy to deploy Java Spring Boot applications to Azure without any code changes.
- [Azure Database for MySQL](https://learn.microsoft.com/azure/mysql/single-server/overview) is a relational database service in the Microsoft cloud based on the MySQL Community Edition.
- [Azure Key Vault Service](https://learn.microsoft.com/azure/key-vault/general/overview) is one of several key management solutions in Azure, which helps solve keys, secrets and certificate management problems. In this setup it is used for storing application secrets and the certificates used by Front Door, Application Gateway and Spring apps.
- [Resource Groups](https://learn.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-portal) is a logical container for Azure resources. We use resource groups to organize everything related to this setup per region. As a naming convention the setup also contains a short string for the region a component is deployed to so it easy to identify which region a component is running in.
- [Virtual Network](https://learn.microsoft.com/azure/virtual-network/virtual-networks-overview) is the fundamental building block for your private network in Azure. This setup contains a virtual network per region you deploy this solution to.
- [Private Endpoint](https://learn.microsoft.com/azure/private-link/private-endpoint-overview) is a network interface that uses a private IP address from your virtual network. This network interface connects you privately and securely to a service that's powered by Azure Private Link. By enabling a private endpoint, you're bringing the service into your virtual network. A private endpoint is used for the database and the Key Vault service.

### Alternatives

#### Multi zone deployment

For increasing the overall resilience and reliability of an application, setting up the application in multiple zones within the same region, can also be utilized. In this case the application gets deployed in 1 region, however the multiple zones guarantee the application workload is spread across physically separate locations within each Azure region that are tolerant to local failures. Azure availability zones are connected by a high-performance network with a round-trip latency of less than 2ms. The added benefit would be that for data workloads you don't have to rely on asynchronous replication, which in most cases calls for additional design concerns.

When deploying your workload to multiple zones instead of multiple regions take the following into account:
- The region you are deploying to should support multiple zones. For a list of supported regions, you can check the [list of Azure regions that support availability zones](https://learn.microsoft.com/azure/availability-zones/az-overview#azure-regions-with-availability-zones).
- Preferably all services in your setup should support a multi-zone setup. You can check the [list of Azure services that support availability zones](https://learn.microsoft.com/azure/availability-zones/az-region).

For the services used in this setup:

|Service|Resiliency|
|---|---|
|Azure DNS|Globally available|
|Azure Front Door|Globally available|
|Azure Application Gateway|Zone redundant|
|Azure Web Application Firewall|Zone redundant|
|Azure Spring Apps|Zone redundant|
|Azure Database for MySQL|Zone redundant|
|Azure Key Vault|Zone redundant|
|Azure Resource Groups|not applicable|
|Azure Virtual Network|Zone redundant|
|Azure Private Endpoint|???Zone redundant because Private Link is???|

When deploying this setup to multiple zones instead of multipl regions for higher resilience and reliability, it still makes sense to front your single region setup with an Azure Front Door service. This allows for future expansion, and is an easy way to get a first version of a active/passive setup.

Additionaly you can also combine a multi-zone setup with a multi-region setup.

#### Backend database




## Solution details

> This should be an introduction of the business problem and why this scenario was built to solve it.
>   What industry is the customer in?
>   What prompted them to solve the problem?
>   What services were used in building out this solution?
>   What does this example scenario show? What are the customer's goals?

> What were the benefits of implementing the solution described below?

### Design patterns

This reference architecture uses two cloud design patterns. [Geographical Node (geodes)](../../patterns/geodes.yml), where any region can service any request, and [Deployment Stamps](../../patterns/deployment-stamp.yml) where multiple independent copies of an application or application component are deployed from a single source (deployment template).

### Potential use cases

> Are there any other use cases or industries where this would be a fit?
> How similar or different are they to what's in this article?

These other uses cases have similar design patterns:

- List of example use cases

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

_Include considerations for deploying or configuring the elements of this architecture._

## Considerations

> REQUIRED STATEMENT: Include the following statement to introduce this section:

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?

> REQUIREMENTS: 
>   For a Reference Architecture, you must include all of these H3 sub-sections/WAF pillars: Reliability, Security, Cost optimization, Operational excellence, and Performance efficiency.

### Reliability

> REQUIRED STATEMENT: Include the following statement to introduce the section:

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

> This section includes resiliency and availability considerations. They can also be H4 headers in this section, if you think they should be separated.
> Are there any key resiliency and reliability considerations (past the typical)?

### Security

> REQUIRED STATEMENT: Include the following statement to introduce the section:

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

> This section includes identity and data sovereignty considerations.
> Are there any security considerations (past the typical) that I should know about this?
> Because security is important to our business, be sure to include your Azure security baseline assessment recommendations in this section. See https://aka.ms/AzureSecurityBaselines

### Cost optimization

> REQUIRED STATEMENT: Include the following statement to introduce the section:

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

> How much will this cost to run? See if you can answer this without dollar amounts.
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?

> Link to the pricing calculator (https://azure.microsoft.com/en-us/pricing/calculator) with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

### Operational excellence

> REQUIRED STATEMENT: Include the following statement to introduce the section:

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

> This includes DevOps, monitoring, and diagnostics considerations.
> How do I need to think about operating this solution?

### Performance efficiency

> REQUIRED STATEMENT: Include the following statement to introduce the section:

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

> This includes scalability considerations.
> Are there any key performance considerations (past the typical)?
> Are there any size considerations around this specific solution? What scale does this work at? At what point do things break or not make sense for this architecture?

## Deploy this scenario

> REQUIRED: Reference Architectures require a deployment. If you cannot provide a deployment, use the Example Workload template instead. 

_Describe a step-by-step process for implementing the reference architecture solution. Best practices are to add the solution to GitHub, provide a link (use boilerplate text below), and explain how to roll out the solution._

A deployment for a reference architecture that implements these recommendations and considerations is available on [GitHub](https://www.github.com/path-to-repo).

1. First step
2. Second step
3. Third step ...

## Contributors

> (Expected, but this section is optional if all the contributors would prefer to not be mentioned.)

> Start with the explanation text (same for every section), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Principal authors" list and the "Other contributors" list, if there are additional contributors (all in plain text, not italics or bold). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). (The profiles can be linked to from the person's LinkedIn page, and we hope to automate that on the platform in the future). Implement this format:

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: > Only the primary authors. Listed alphabetically by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s).

 - [Author 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Author 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each primary author (even if there are 10 of them).

Other contributors: > Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. Listed alphabetically by last name. Use this format: Fname Lname. It's okay to add in newer contributors.

 - [Contributor 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Contributor 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each additional contributor (even if there are 10 of them).

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> Link to Learn articles. Could also be to appropriate sources outside of Learn, such as GitHub repos, third-party documentation, or an official technical blog post.

Examples:
* [Azure Machine Learning documentation](/azure/machine-learning)
* [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)

## Related resources

> Use "Related resources" for architecture information that's relevant to the current article. It must be content that the Azure Architecture Center TOC refers to, but may be from a repo other than the AAC repo.
> Links to articles in the AAC repo should be repo-relative, for example (../../solution-ideas/articles/article-name.yml).

> Here is an example section:

Fully deployable architectures:

* [Chatbot for hotel reservations](/azure/architecture/example-scenario/ai/commerce-chatbot)
* [Build an enterprise-grade conversational bot](/azure/architecture/reference-architectures/ai/conversational-bot)
* [Speech-to-text conversion](/azure/architecture/reference-architectures/ai/speech-ai-ingestion)