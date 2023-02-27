# Subscription Vending Design Considerations

This article provides guidance for the architectural components of automated subscription vending.
For information about subscription vending, please see the [article](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending) in the Cloud Adoption Framework.

## Overview

Automated subscription vending is a process that enables the creation of subscriptions in a consistent and repeatable manner.
The process is automated by using a combination of Azure APIs and Infrastructure as Code (IaC).
The following diagram shows the components of the automated subscription vending process.

```


               Creates data
               file and PR
    ┌───────┐  in...      ┌──────┐         ┌────────┐
    │       │             │      │         │        │
    │ ITSM  ├────────────►│ SCM  ├────────►│ CI/CD  │
    │       │             │      │         │        │
    └───────┘             └──────┘         └────────┘

                                   Automated
                                   subscription
                                   creation

```

## IT Service Management Tool

The ITSM tool is used to create a request for a new subscription.
It managed the business logic and authorization for the request.
Once the request is approved, the ITSM tool passes this data into the Source Control Management (SCM) tool and creates a pull request (PR).

## Source Code Management

The SCM tool is usually combined with the CI/CD tool and contains the Infrastructre as Code (IaC) for the subscription.
In order to scale, we recommend using semi-structured data files, e.g. JSON / YAML, to store the subscription data, using one file per subscription.

### Infrastructure as Code

We provide IaC modules for Bicep and Terraform.

## CI/CD

The CI/CD tool provides the automation to create the subscription. We recommend using either GitHub Actions or Azure DevOps Pipelines.

### Workload Identities

In order to create the subscription, the CI/CD tool needs to authenticate to Azure.
We recommend using either managed identity or OpenID Connect (OIDC) to authenticate to Azure.
This removes the requirement to manage secrets.
