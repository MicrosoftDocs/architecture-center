This article provides guidance for automating the subscription vending approach. It describes the technical steps and the architectural components you need to automate. It builds on the [subscription vending](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending) article in the Cloud Adoption Framework.

Subscription vending should be an automated process so the mechanism the platform team uses to create workload subscriptions is consistent and repeatable. The automation should use a combination of Azure APIs and infrastructure as code (IaC) to automate the process.

The following diagram shows the components of the automated subscription vending process.

[![Diagram showing the components of the subscription vending approach.](images/sub-vending.png)](images/sub-vending.png)

## Collect data

The subscription vending process requires data collection. The tool is used to create a request for a new subscription. It manages the business logic and authorization for the request. Once the request is approved, the tool passes this data into the Source Code Management (SCM) tool and creates a pull request. You might need a middleware layer, such as Azure Functions or Logic Apps, to complete the data transfer.

**Collect required data.** You should collect data on the authorization of the request, the cost center, the subscription name, and many other fields.

**Use ITSM or app.** You can use an IT Service Management tool to orchestrate the data collection process. Alternatively, you can also use a low-code / no-code tool like [Microsoft PowerApps](https://powerapps.microsoft.com/) to collect the data.

### IPAM (place holder)

## Create pull request

The SCM tool is combined with the CI/CD tool and contains the Infrastructure as Code (IaC) for the subscription. In order to scale, we recommend using semi-structured data files (JSON or YAML) to store the subscription data. You should use one file per subscription.

**Use Git flow.** You should use a Gitflow process to intake the data a merge the changes. The Gitflow should execute the following actions:

1. Create a new branch for each subscription request.
1. Use the data collected to create the YAML/JSON file for the new subscription.
1. Create a pull request.
1. Receive approval (optional).
1. Merge the changes.
1. Submit the subscription to the deployment tool.

```mermaid
---
title: Example subscription request
---
gitGraph
  commit id: "as-is"
  branch newsub
  checkout newsub
  commit id: "new-sub.yaml/json"
  checkout main
  merge newsub id: "PR"
```

### Infrastructure as Code

We provide IaC modules for Bicep and Terraform. For more information, see:

- [Bicep module](https://aka.ms/lz-vending/bicep)
- [Bicep wiki](https://github.com/Azure/bicep-lz-vending/wiki)
- [Terraform module](https://aka.ms/lz-vending/tf)
- [Terraform wiki](https://github.com/Azure/terraform-azurerm-lz-vending/wiki)

### IPAM (???)

[to add ? ]

## Create subscription

The CI/CD tool provides the automation to create the subscription. We recommend using either GitHub Actions or Azure Pipelines.

### Workload identities

In order to create the subscription, the CI/CD tool needs to authenticate to Azure.
We recommend using either managed identity or OpenID Connect (OIDC) to authenticate to Azure. Workload identities remove the requirement to manage secrets.

## Post-deployment (place holder)

### Cost management (place holder)
