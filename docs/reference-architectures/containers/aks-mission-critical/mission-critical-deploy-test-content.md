## Introduction

The deployment and testing of the mission critical environment is crucial piece of the overall reference architecture. The individual application stamps are deployed as infrastructure as code from a source code repository. Updates to the infrastructure are deployed with zero downtime to the application. A DevOps continuous integration pipeline is used to retrieve the source code from the repository and deploy the individual stamps in Azure.

Deployment and updates is the central process in the architecture. Infrastructure and application related updates are deployed to fully independent stamps. Only the globally shared infrastructure in the architecture is shared across the stamps. Existing stamps in the infrastructure aren't touched. The new application version will only be deployed to these new stamps. Infrastructure updates will only be deployed to these new stamps.

The new stamps are added to Azure Front Door. Traffic is gradually moved over to the new stamps. When it's determined that traffic is served from the new stamps without issue, the previous stamps are deleted.

Proactive testing of the infrastructure discovers weaknesses and how the deployed application will behave in the event of a failure.

## Deployment



### DevOps

### Zero downtime updates

### Environments

### Shared and dedicated resources

## Failure injection testing

### DNS failure

### Firewall block