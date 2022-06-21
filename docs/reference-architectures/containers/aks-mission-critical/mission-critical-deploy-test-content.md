## Introduction

The deployment and testing of the mission critical environment is crucial piece of the overall reference architecture. The individual application stamps are deployed as infrastructure as code from a source code repository. Updates to the infrastructure are deployed with zero downtime to the application. A DevOps continuous integration pipeline is used to retrieve the source code from the repository and deploy the individual stamps in Azure.

Deployment and updates is the central process in the architecture. Infrastructure and application related updates are deployed to fully independent stamps. Only the globally shared infrastructure in the architecture is shared across the stamps. Existing stamps in the infrastructure aren't touched. The new application version will only be deployed to these new stamps. Infrastructure updates will only be deployed to these new stamps.

The new stamps are added to Azure Front Door. Traffic is gradually moved over to the new stamps. When it's determined that traffic is served from the new stamps without issue, the previous stamps are deleted.

Proactive testing of the infrastructure discovers weaknesses and how the deployed application will behave in the event of a failure.

## Deployment

The deployment of the infrastructure in the reference architecture is dependent upon the following components:

* DevOps - The source code and pipelines for the infrastructure.

* Zero downtime updates - Updates and upgrades are deployed to the environment with zero downtime to the deployed application.

* Environments - Short-lived and permanent environments used for the architecture.

* Shared and dedicated resources - Azure resources that are dedicated and shared to the stamps and overall infrastructure.

### DevOps

The DevOps components provide the source code repository and CI/CD pipelines for deployment of the infrastructure and updates. Github and Azure Pipelines were chosen as the components.

* Github - Contains the source code repositories for the application and infrastructure.

* Azure Pipelines - The pipelines in the Azure DevOps service are used by the architecture for all build, test and release tasks.

An additional component in the design used for the deployment are build agents. Microsoft Hosted build agents are used as part of Azure Pipelines to deploy the infrastructure and updates. The use of Microsoft Hosted build agents removes the management burden for developers to maintain and update the build agent.

For more information about Azure Pipelines and Azure DevOps, see [What is Azure DevOps?](/azure/devops/user-guide/what-is-azure-devops).

### Zero downtime updates

The zero downtime and update strategy in the reference architecture is central to the over all mission critical application. The methodology of replace instead of upgrade of the stamps allows parallel environments for testing and deployment.

There are two main components of the reference architecture:

* Infrastructure - Azure services and resources. Deployed with Terraform and it's associated configuration.

* Application - The hosted service or application that serves users. Based on Docker containers and npm built artifacts in HTML and JavaScript for the UI.

### Environments


### Shared and dedicated resources

## Failure injection testing

### DNS failure

### Firewall block