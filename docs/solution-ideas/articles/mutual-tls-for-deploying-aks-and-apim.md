[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

## Potential use cases

AKS integration with API Management and Application Gateway with mTLS. Deploy AKS as private cluster, horizontal scaling, self-healing,  load balancing, and secret management using Azure Key Vault. Securely connect to Azure PaaS services over private endpoint. 

## Architecture

![Diagram of the mutual-tls-for-deploying-aks-and-apim architecture.](./media/mutual-tls-for-deploying-aks-and-apim.png)

*Download a [Visio file](https://arch-center.azureedge.net/mutual-tls-for-deploying-aks-and-apim.vsdx) of this architecture.*

> Note that Visio or PowerPoint files are not allowed in the GitHub repo. Send the file or provide a link so the file can be uploaded to our limited-access CDN server.

### Dataflow

1. User request to application endpoint from internet
2. Application Gateway receive traffic as Https
3. Validate PFX certificate, private key
4. Decrypt traffic using private Keys ( SSL Offloaded) and ReEncrypt traffic using Public Key ( end-to-end encryption )
5. Apply Application Gateway rules, Http Settings base on backend pool and send traffic to backend pool over Https
6. API Management deployed as internal vNet mode with private IP address and receive traffic as Https with custom domain PFX certificates
7. API Management policies and authentication using OAuth with Azure Active directory
8. Traffic send to AKS ( Azure Kubernetes Service) ingress controller over Https
9. AKS ingress controller receive traffic as Https and verify PEM server certificate and private key
10. Ingress TLS secret ( Kubernetes Secret) process wit pem.cert and pem.key. Decrypt traffic using private key (  Offloaded)
11.   

### Components

> A bullet list of components in the architecture (including all relevant Azure services) with links to the product service pages. This is for lead generation (what business, marketing, and PG want). It helps drive revenue.

> Why is each component there?
> What does it do and why was it necessary?
> Link the name of the service (via embedded link) to the service's product service page. Be sure to exclude the localization part of the URL (such as "en-US/").

Example: 
* [Resource Groups][resource-groups] is a logical container for Azure resources.  We use resource groups to organize everything related to this project in the Azure console.

## Scenario details

> This should be an explanation of the business problem and why this scenario was built to solve it.
>> What prompted them to solve the problem?
>> What services were used in building out this solution?
>> What does this example scenario show? What are the customer's goals?

> What were the benefits of implementing the solution?

### Potential use cases

> What industry is the customer in? Use the following industry keywords, when possible, to get the article into the proper search and filter results: retail, finance, manufacturing, healthcare, government, energy, telecommunications, education, automotive, nonprofit, game, media (media and entertainment), travel (includes hospitality, like restaurants), facilities (includes real estate), aircraft (includes aerospace and satellites), agriculture, and sports. 
>> Are there any other use cases or industries where this would be a fit?
>> How similar or different are they to what's in this article?

## Contributors

> (Expected, but this section is optional if all the contributors would prefer to not include it)

> Start with the explanation text (same for every section), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Pricipal authors" list and the "Other contributors" list, if there are additional contributors (all in plain text, not italics or bold). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). Implement this format:

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: > Only the primary authors. Listed alphabetically by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s).

 - [Author 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Author 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each primary author (even if there are 10 of them).

Other contributors: > (If applicable.) Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. Listed alphabetically by last name. Use this format: Fname Lname. It's okay to add in newer contributors.

 - [Contributor 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Contributor 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each additional contributor (even if there are 10 of them).

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> Links to articles on the Learn platform. Could also be to appropriate sources outside of Learn, such as third-party documentation, GitHub repos, or an official technical blog post.

Examples:
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Machine Learning documentation](/azure/machine-learning)
* [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)

## Related resources

> Use "Related resources" for architecture information that's relevant to the current article. It must be content that the Azure Architecture Center TOC refers to, but may be from a repo other than the AAC repo.
> Links to articles in the AAC repo should be repo-relative, for example (../../solution-ideas/articles/article-name.yml).

> Here are example sections:

Related architecture guides:

* [Artificial intelligence (AI) - Architectural overview](/azure/architecture/data-guide/big-data/ai-overview)
* [Choosing a Microsoft cognitive services technology](/azure/architecture/data-guide/technology-choices/cognitive-services)

Fully deployable architectures:

* [Chatbot for hotel reservations](/azure/architecture/example-scenario/ai/commerce-chatbot)
* [Build an enterprise-grade conversational bot](/azure/architecture/reference-architectures/ai/conversational-bot)
* [Speech-to-text conversion](/azure/architecture/reference-architectures/ai/speech-ai-ingestion)