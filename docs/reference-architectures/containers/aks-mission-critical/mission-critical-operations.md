---
title: Operations for mission-critical workloads on Azure
description: Guidance for operations for the baseline reference architecture for a mission-critical workload on Azure. 
author: robbagby
categories: networking
ms.author: allensu
ms.date: 06/28/2022
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.category:
  - management-and-governance
azureCategories:
  - management-and-governance  
summary: Guidance for operations for the baseline reference architecture for a mission-critical workload on Azure.  
products:
  - azure
  - azure-devops
---

# Operations for mission-critical workloads on Azure

Like with any application, change will occur in your mission-critical workloads. The application will evolve over time, keys will expire, patches will be released, and more. All changes and maintenance should be applied using deployment pipelines. This article provides operational guidance for making common changes and updates.

Organizational alignment is equally important to operation procedures. It's crucial for the operational success of a mission-critical workload that the end-to-end responsibilities fall within a single team, the DevOps team.

The technical execution should take advantage of Azure-native platform capabilities, and the use of automated Azure Pipelines to deploy changes to the application, infrastructure, and configuration. Again, maintenance tasks should be automated and manual tasks should be avoided.

The following sections describe approaches to handling different types of change.

## Application automation

Continuous Integration and Continuous Deployment (CI/CD) enables the proper deployment and verification of mission-critical workloads. CI/CD is the preferred approach to deploy changes to any environment, Dev/Test, production, and others. For mission-critical workloads, the changes listed below should result in the deployment of an entirely new stamp. The new stamp should be thoroughly tested as part of the release process before traffic is routed to the stamp via a blue/green deployment strategy.

The following sections describe changes that should be implemented, where possible, through CI/CD.

### Application changes

All changes to the application code should be deployed through CI/CD. The code should be built, linted, and tested against regressions. Application dependencies, such as runtime environment or packages should be monitored, with updates deployed via CI/CD.

### Infrastructure changes

Infrastructure should be modeled and provisioned as code. This practice is commonly referred to as Infrastructure as Code (IaC). All changes to the IaC should be deployed through the CI/CD pipelines. Updates to the infrastructure, such as patching the OS should also be managed via CI/CD pipelines.

### Configuration changes

Configuration changes are a common cause of application outages. To combat these outages, configuration for application or infrastructure should be captured as code. This practice is known as Configuration as Code (CaC). Changes to CaC should be deployed via CI/CD pipelines.

### Library/SDK updates

For mission-critical applications, it's critical that source code and dependencies are updated when new versions become available. The recommended approach is to take advantage of configuration management change process in the source code repository. It should be configured to automatically create Pull Requests for various dependency updates, such as:

- .NET NuGet packages
- JavaScript Node Package Manager packages
- Terraform Provider

The following is an example of automating library updates using [dependabot](https://github.com/dependabot) in a GitHub repository.

1. Dependabot detects updates of libraries and SDK used in application code
2. Dependabot updates the application code in a branch and creates a pull request (PR) with those changes against the main branch. The PR contains all relevant information and is ready for final review.
   :::image type="content" source="./images/mission-critical-operations-dependabot.png" alt-text="Screenshot of a pull request generated from dependabot." lightbox="./images/mission-critical-operations-dependabot.png":::
3. When code review and testing are done, the PR can be merged to the main branch.

For dependencies dependabot isn't able to monitor, ensure that you have processes in place to detect new releases.

### Key/Secret/Certificate rotations

Rotating (renewing) keys and secrets should be a standard procedure in any workload. Secrets might need to be changed on short notice after being exposed or regularly as a good security practice.

Because expired or invalid secrets can cause outages to the application [(see Failure Analysis)](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-health-modeling#failure-analysis), it's important to have a clearly defined and proven process in place. For Azure Mission-Critical, stamps are only expected to live for a few weeks. Because of that, rotating secrets of stamp resources isn't a concern. If secrets in one stamp expire, the application as a whole would continue to function.

Management of secrets to access long-living global resources, however, are critical. A notable example is the Azure Cosmos DB API keys. If Azure Cosmos DB API keys expire, all stamps will be affected simultaneously and cause a complete outage of the application.

The following is Azure mission critical tested and documented approach for rotating Azure Cosmos DB keys without causing downtime to services running in Azure Kubernetes Service.

1. Update stamps with secondary key. By default, the primary API key for Azure Cosmos DB is stored as a secret in Azure Key Vault in each stamp. Create a PR that updates the IaC template code to use the secondary Azure Cosmos DB API key. Run this change through the normal PR review and update procedure to get deployed as a new release or as a hotfix.
2. (optional) If the update was deployed as a hotfix to an existing release, the pods will automatically pick up the new secret from Azure Key Vault after a few minutes. However, the Azure Cosmos DB client code does currently not reinitialize with a changed key. To resolve this issue, restart all pods manually using the following commands on the clusters:

   ```bash
   kubectl rollout restart deployment/CatalogService-deploy -n workload
   kubectl rollout restart deployment/BackgroundProcessor-deploy -n workload
   kubectl rollout restart deployment/healthservice-deploy -n workload
   ```

3. Newly deployed or restarted pods will now use the secondary API key for the connection to Azure Cosmos DB.
4. Once all pods on all stamps are restarted, or a new stamp has been deployed, regenerate the primary API key for Azure Cosmos DB. Here's an example for the command:

   ```Bash
   az cosmosdb keys regenerate --key-kind primary --name MyCosmosDBDatabaseAccount --resource-group MyResourceGroup
   ```

5. Change the IaC template back to use the primary API key for future deployments. Alternatively, you can continue to use the secondary key and switch back to the primary API key when to the time comes to renew the secondary.

### Alerts

Alerts are key to understanding if and when there are issues with your environment. Changes to alerts and/or action groups should be implemented via CI/CD pipelines. For more information on alerts, see [Health modeling and observability of mission-critical workloads on Azure](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-health-modeling#alerting).

## Automation

Many platforms and services running on Azure provide automation for common operational activities. This automation includes autoscaling and the automated handling of keys and certificates.

### Scaling

As part of the application design, the scale requirements that define a scale-unit for the stamp as a whole should be determined. The individual services within the stamp need to be able to scale out to meet peak demand or scale in to save money or resources.

Services that don't have enough resources can exhibit different side effects, including the following:

- An insufficient number of pods processing messages from a queue/topic/partition will result in a growing number of unprocessed messages. This is sometimes referred to as a growing queue depth.
- Insufficient resources on an AKS node can result in pods not being able to run.
- The following will result in throttled requests:
  - Insufficient Request Units (RUs) for Azure Cosmos DB
  - Insufficient processing units (PUs) for Event Hubs premium or throughput units (TUs) for standard
  - Insufficient Messaging Units (MUs) for Service Bus premium tier

Take advantage of autoscaling features of the services, where possible, to ensure you have enough resources to meet demand. The following are automatic scaling features you can take advantage of:

- [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) allows you to increase or decrease the number of pods running workloads, depending upon demand.
- The [AKS cluster autoscaler](/azure/aks/cluster-autoscaler) allows you to increase or decrease the number of nodes in the cluster, depending upon demand.
- You can [automatically scale up Azure Event Hubs throughput units (standard tier)](/azure/event-hubs/event-hubs-auto-inflate)
- You can [Automatically update messaging units of an Azure Service Bus namespace](/azure/service-bus-messaging/automate-update-messaging-units)

### Managing keys, secrets, and certificates

Use managed identities where possible to avoid having to manage API keys or secrets such as passwords.

When you're using keys, secrets, or certificates, use Azure-native platform capabilities whenever possible. The following are some examples of these platform-level capabilities:

- Azure Front Door has built-in capabilities for TLS certificate management and renewal.
- Azure Key Vault supports automatic key rotation.

## Manual operations

There are operational activities that require manual intervention. These processes should be tested.

### Dead-lettered messages

Messages that can't be processed should be routed to a dead-letter queue with an alert configured for that queue. These messages usually require manual intervention to understand and mitigate the issue. You should build the ability to view, update and replay dead-lettered messages.

### Azure Cosmos DB restore

When Azure Cosmos DB data is unintentionally deleted, updated, or corrupted, you need to perform a restore from a periodic backup. 
Restoring from a periodic backup can only be accomplished via a support case. This process should be documented and periodically tested.

### Quota increases

Azure subscriptions have quota limits. Deployments can fail when these limits are reached. Some quotas are adjustable. For adjustable quotas, you can request an increase from the <b>My quotas</b> page on the Azure portal. For non-adjustable quotas you, need to submit a support request. The Azure support team will work with you to find a solution.

> [!IMPORTANT]
> See [Operational procedures for mission-critical workloads on Azure](/azure/architecture/framework/mission-critical/mission-critical-operational-procedures) for operational design considerations and recommendations.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

 - [Rob Bagby](https://www.linkedin.com/in/robbagby/) | Principal Content Developer
 - [Allen Sudbring](https://www.linkedin.com/in/allen-sudbring-9163171/) | Senior Content Developer
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Deploy the reference implementation to get a full understanding of the resources and their configuration used in this architecture.

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical Online](https://github.com/Azure/Mission-Critical-Online)
