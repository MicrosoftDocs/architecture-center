This example scenario discusses a [highly available](https://wikipedia.org/wiki/High_availability) solution for a jump server solution running on Azure using an open-source tool called Apache Guacamole, which similar functionalities from [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)

Apache Guacamole is a clientless remote desktop gateway that supports standard protocols like VNC, RDP, and SSH. Clientless means your clients don't need to install anything but just use a web browser to remotely access your fleet of VMs.

The Guacamole comprises two main components:

* Guacamole Server which provides guacd which is like a proxy server for the client to connect to the remote server.
* Guacamole Client is a servelet container that users will log in via web browser.

For more information about Guacamole, visit its [architecture page](https://guacamole.apache.org/doc/gug/guacamole-architecture.html).

To offer high availability, this solution:

* Make use of [Availability Sets](https://docs.microsoft.com/en-us/azure/virtual-machines/availability#availability-sets) for Virtual Machines ensuring 99.95% of SLA
* Use Azure Database for MySQL, a highly available, scalable, managed database as service guarantees a [99.99% SLA](https://docs.microsoft.com/en-us/azure/mysql/concepts-high-availability).

The environment to be built will leverage the usage of Azure Database for MySQL (DBaaS), Azure Load Balancer, and Virtual Machines with [Nginx as Reverse Proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/), [Tomcat as Application Service](https://tomcat.apache.org/), and the [Certbot](https://certbot.eff.org/) to get free SSL certificates from [Let's Encrypt](https://letsencrypt.org/).

## Potential use cases

* Access your computers from any device: As Guacamole requires only a reasonably-fast, standards-compliant browser, Guacamole will run on many devices, including mobile phones and tablets.
* Keep a computer in the “cloud”: Computers hosted on virtualized hardware are more resilient to failures, and with so many companies now offering on-demand computing resources, Guacamole is a perfect way to access several machines that are only accessible over the internet.
* Provide easy access to a group of people: Guacamole allows you to centralize access to a large group of machines, and specify on a per-user basis which machines are accessible. Rather than remember a list of machines and credentials, users need only log into a central server and click on one of the connections listed.
* Adding HTML5 remote access to your existing infrastructure: As Guacamole is an API, not just a web application, the core components and libraries provided by the Guacamole project can be used to add HTML5 remote access features to an existing application. You need not use the main Guacamole web application; you can write (or integrate with) your own rather easily.

## Architecture

The drawing below refers to the suggested architecture. This architecture includes a public load balancer that receives external accesses and directs them to two virtual machines in the web layer. The web layer communicates with the data layer where we have a MySQL database responsible for storing login information, accesses, and connections.

[![Diagram of the reference architecture Apache Guacamole on Azure](media/azure-architecture-guacamole.png)](media/azure-architecture-guacamole.png#lightbox)

Download a Visio file of this architecture

### Components

- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer): A service to distribute load (incoming network traffic) across a group of backend resources or servers.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network): The fundamental building block for your private network in Azure.
- [Public IP Addresses](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses): A service to allow Internet resources to communicate inbound to Azure resources.
- [Network Security Group](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview): A service to filter network traffic to and from Azure resources in an Azure virtual network
- [Azure Availability Set](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview): A logical grouping of VMs that allows Azure to understand how your application is built to provide for redundancy and availability
- [Azure Database for MySQL](https://azure.microsoft.com/en-us/services/mysql/): A fully managed MySQL Database as a Service 

### Alternatives

Customers who doesn't need this high level of control using their own solution can implement a solution similar to this leveraging the usage of [Azure Bastion](https://azure.microsoft.com/services/azure-bastion/), a fully managed service that provides secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to VMs without any exposure through public IP addresses. 


## Considerations

> REQUIRED STATEMENT: Include the following statement to introduce this section:
> "These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework)."

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?

> REQUIREMENTS: 
>   You must have the "Cost optimization" section. 
>   You must have at least two of the other H3 sub-sections/pillars: Reliability, Security, Operational excellence, and Performance efficiency.

### Reliability

> REQUIRED STATEMENT: If using this section, include the following statement to introduce the section:
> "Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview)."

> This section includes resiliency and availability considerations. They can also be H4 headers in this section, if you think they should be separated.
> Are there any key resiliency and reliability considerations (past the typical)?

### Security

> REQUIRED STATEMENT: If using this section, include the following statement to introduce the section:
> "Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview)."

> This section includes identity and data sovereignty considerations.
> Are there any security considerations (past the typical) that I should know about this?
> Because security is important to our business, be sure to include your Azure security baseline assessment recommendations in this section. See https://aka.ms/AzureSecurityBaselines

### Cost optimization

> REQUIRED: This section is required. Cost is of the utmost importance to our customers.
> REQUIRED STATEMENT: Include the following statement to introduce the section:
> "Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview)."

> How much will this cost to run? See if you can answer this without dollar amounts.
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?

> Link to the pricing calculator (https://azure.microsoft.com/en-us/pricing/calculator) with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

### Operational excellence

> REQUIRED STATEMENT: If using this section, include the following statement to introduce the section:
> "Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview)."

> This includes DevOps, monitoring, and diagnostics considerations.
> How do I need to think about operating this solution?

### Performance efficiency

> REQUIRED STATEMENT: If using this section, include the following statement to introduce the section:
> "Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview)."

> This includes scalability considerations.
> Are there any key performance considerations (past the typical)?
> Are there any size considerations around this specific solution? What scale does this work at? At what point do things break or not make sense for this architecture?

## Deploy this scenario

> (Optional, but greatly encouraged)

> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Contributors

> (Expected, but this section is optional if all the contributors would prefer to not be mentioned.)

> Start with the explanation text (same for every section), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Principal authors" list and the "Other contributors" list, if there are additional contributors (all in plain text, not italics or bold). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). (The profiles can be linked to from the person's LinkedIn page, and we hope to automate that on the platform in the future). 

> Implement this format:

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: > Only the primary authors. Listed alphabetically by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s).

 - [Author 1 Name](http://linkedin.com/ProfileURL) | (Title, such as "Cloud Solution Architect")
 - [Author 2 Name](http://linkedin.com/ProfileURL) | (Title, such as "Cloud Solution Architect")
 - > Continue for each primary author (even if there are 10 of them).

Other contributors: > Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. Listed alphabetically by last name. Use this format: Fname Lname. It's okay to add in newer contributors.

 - [Contributor 1 Name](http://linkedin.com/ProfileURL) | (Title, such as "Cloud Solution Architect")
 - [Contributor 2 Name](http://linkedin.com/ProfileURL) | (Title, such as "Cloud Solution Architect")
 - > Continue for each additional contributor (even if there are 10 of them).

## Next steps

> Link to Docs and Learn articles, along with any third-party documentation.
> Where should I go next if I want to start building this?
> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful? Are there product documents that go into more detail on specific technologies that are not already linked?

Examples:
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Machine Learning documentation](/azure/machine-learning)
* [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
* [What is Language Understanding (LUIS)?](/azure/cognitive-services/luis/what-is-luis)
* [What is the Speech service?](/azure/cognitive-services/speech-service/overview)
* [What is Azure Active Directory B2C?](/azure/active-directory-b2c/overview)
* [Introduction to Bot Framework Composer](/composer/introduction)
* [What is Application Insights](/azure/azure-monitor/app/app-insights-overview)
 
## Related resources

> Use "Related resources" for architecture information that's relevant to the current article. It must be content that the Azure Architecture Center TOC refers to, but may be from a repo other than the AAC repo.
> Links to articles in the AAC repo should be repo-relative, for example (../../solution-ideas/articles/article-name.yml).

Examples:
  - [Artificial intelligence (AI) - Architectural overview](/azure/architecture/data-guide/big-data/ai-overview)
  - [Choosing a Microsoft cognitive services technology](/azure/architecture/data-guide/technology-choices/cognitive-services)
  - [Chatbot for hotel reservations](/azure/architecture/example-scenario/ai/commerce-chatbot)
  - [Build an enterprise-grade conversational bot](/azure/architecture/reference-architectures/ai/conversational-bot)
  - [Speech-to-text conversion](/azure/architecture/reference-architectures/ai/speech-ai-ingestion)
