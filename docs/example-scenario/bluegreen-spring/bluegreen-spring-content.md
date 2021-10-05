When running applications in cloud, availability of the application is an important factor. Depending on the type of application some downtime in the application can be acceptable, however, for certain applications keeping the uptime for the application as high as possible can be primordial. When the application becomes unavailable this would mean loss of business, loss of money or loss of face. This is something many companies would like to avoid. 

There are many events that can result in a cloud application not to be available. This might be from a glitch in the network, over a failure of an underlying system, or as simple as the deployment of a new version of the application. 

There are also many ways to design for higher availability. Typically this results in a design that makes use of either a high available setup, which will double run cost. Or it will result in a disaster recovery plan, which will bring up the application again in another region. The run cost for the latter might be lower, however, bringing up the entire application again will take time, which is a factor not all applications can take. 

This article describes ensuring high availability during the deployment of a new version of an application. In a normal setup, the new bits of the application will be deployed to the service that is hosting the application. This will often also lead to a reload and a restart of the application, during which time the application itself will be unavailable. This is often not preferable.

In this article we will focus on the blue-green deployment pattern for an application. This entails that the new version of the application will be deployed next to the existing version. This allows for restarting, warming up and testing this new version independent of the existing version. Once the new version is properly up and running, a simple switch can be made to this new version, redirecting any new incoming traffic to it. For the end user of the application the deployment of the new version will be done without any visible downtime of the application, making for much higher overall availability.

An additional advantage of using blue-green deployments will be that if a deployment is not as expected, you can easily abandon the new version without affecting the live version of the application. This is then a rollback of the changes. 

In the article we will focus on Azure Spring Cloud as a service for making blue-green deployments possible. We will also focus on automating the deployment of applications so they can be done in a repeatable way over and over again. We will also look at rolling back a deployment in case the changes made were not as expected. 

## Potential use cases

This solution benefits any organizations that wants to enable zero downtime deployments as well as organizations that want to be able to easily rollback a deployment. 

These other uses cases have similar design patterns:

- Deploy to an Azure Web App Slot. This slot will contain the new version of the application, which can be reloaded, warmed up and tested before making a slot swap. The slot swap will put the newly deployed version in production. This is build into the service as an easy extra setup.
- Deploy to any Azure service behind a load balancing solution. Any Azure service hosting web endpoints, can be placed behind a load balancing solution. This also implies that you can spin up a second instance of that Azure service to deploy the new version of your application to. As a next step to allow for a zero downtime deployment, you can switch the traffic at the load balancing solution to the Azure service holding the new version of the app. This solution to blue-green deployments would however ask much more management overhead.

## Architecture

![Diagram of blue-green deployment for Azure Spring Cloud, with GitHub source control, GitHub Action Workflow, and Azure Spring Cloud with a blue and a green slot.](media/bluegreen-spring.svg)

1. The **GitHub repository** holds the application code of which a new version needs to be deployed to Azure Spring Cloud. Every change to the application code happens under source control. GitHub functionality: 

    - Ensures review for changes
    - Prevents unintended or unauthorized changes
    - Enforces desired quality checks

1. The GitHub Repository also holds an **Action Workflow** for building the code changes and performing the necessary quality checks. After compiling the code, the action workflow deploys the latest version of the code to Azure Spring Cloud. For this deployment the GitHub Action Workflow: 

    - Checks what is currently the active production deployment.
    - Deploys the code to the non-production deployment. In case this non-production deployment does not exist, it gets created. At this point in time the old application version in the production deployment is still getting all of the production traffic.
    - Waits for the deployment to be reviewed and approved. During this approval the non-production url of the application can be used to double check the new version of the application.
    - In case the deployment is approved, the production deployment and non-production deployment are switched. So all production traffic now gets routed to the new version of the application.
    - Waits for a second review and approval to delete the non-production deployment. Cleaning up the non-production deployment will lead to a more cost effective setup. 

### Components

This solution uses the following components: 

- [Azure Spring Cloud Service](https://azure.microsoft.com/services/spring-cloud) is a modern microservices platform for running Java Sping Boot and Steeltoe .NET Core apps. It eliminates boilerplate code for running microservices and helps to quickly develop robust apps in cloud. 

- [GitHub](https://github.com) is a code hosting platform for version control and collaboration. GitHub offers Git distributed version control, source code management, and other features.

- [GitHub Actions](https://docs.github.com/actions) help you automate software development workflows as well as deployment workflows right in the repository. They allow for a fully automated CI/CD setup. 

### Alternatives

In this architecture we use GitHub Actions for automating the deployment. An alternative to GitHub Actions is [Azure DevOps Pipelines](https://dev.azure.com) or any other CI/CD automation system. The sample we build makes use of Azure CLI statements as much as possible, so this setup can be easily translated to another automation tool. 

## Considerations

The following considerations apply to this solution.

### Availability

This solution helps in maintaining availability for your application during deployment of a new version. It does however not increase the overall availability of your application on Azure Spring Cloud. Meaning that it will not increase the SLA the Azure Spring Service gives you, you can still be affected by service failures on the platform.

In case you are looking for a solution to increase the overall SLA of your setup, you should look at setting up a high available Azure Spring Cloud service over multiple regions and front it with a global load balancing solution.

### Operations

> How do I need to think about operating this solution?

### Performance

> Are there any key performance considerations (past the typical)?

### Scalability

> Are there any size considerations around this specific solution?
> What scale does this work at?
> At what point do things break or not make sense for this architecture?

### Security

Apart from the task of setting up repository permissions, consider implementing the following security measures in Git repositories that hold code you want to deploy to Azure Spring Cloud Service: 

- **Branch protection:** Protect the branches that represent the production state of your application from having changes pushed to them directly. Require every change to be proposed by a PR that is reviewed by at least one other person. Also use PRs to do automatic checks. For example, build all code and run unit tests on the code that a PR creates or modifies.

- **PR review:** Require PRs to have at least one reviewer, to enforce the four-eyes principle. You can also use the GitHub [code owners](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-on-github/about-code-owners) feature to define individuals or teams that are responsible for reviewing specific files in a repository.

- **Immutable history:** Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.

- **Further security measures:** Require your GitHub users to activate [two-factor authentication](https://wikipedia.org/wiki/Multi-factor_authentication). Also, allow only signed commits, which can't be altered after the fact.

We also currently only deploy to one Azure Spring Cloud Service. However, in a production setup, your code will be tested first on other environments before being deployed to production. Your production environment should be preferably a totally different environment from your development and test environment. 

### Resiliency

> Are there any key resiliency considerations (past the typical)?

### DevOps

> Are there any key DevOps considerations (past the typical)?

## Deploy this scenario

> (Optional, but greatly encouraged)
>
> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Pricing

> How much will this cost to run?
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?
>
> Link to the pricing calculator with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

## Next steps

> Where should I go next if I want to start building this?
> Are there any reference architectures that help me build this?
> Be sure to link to the Architecture Center, to related architecture guides and architectures.
 
- Examples:
  - [Artificial intelligence (AI) - Architectural overview](/azure/architecture/data-guide/big-data/ai-overview)
  - [Choosing a Microsoft cognitive services technology](/azure/architecture/data-guide/technology-choices/cognitive-services)
  - [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
  - [What is Language Understanding (LUIS)?](/azure/cognitive-services/luis/what-is-luis)
  - [What is the Speech service?](/azure/cognitive-services/speech-service/overview)
  - [What is Azure Active Directory B2C?](/azure/active-directory-b2c/overview)
  - [Introduction to Bot Framework Composer](/composer/introduction)
  - [What is Application Insights](/azure/azure-monitor/app/app-insights-overview)
  - [Chatbot for hotel reservations](/azure/architecture/example-scenario/ai/commerce-chatbot)
  - [Build an enterprise-grade conversational bot](/azure/architecture/reference-architectures/ai/conversational-bot)
  - [Speech-to-text conversion](/azure/architecture/reference-architectures/ai/speech-ai-ingestion)

## Related resources

> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful?
> Are there product documents that go into more detail on specific technologies that are not already linked?

<!-- links -->

[calculator]: https://azure.com/e/
