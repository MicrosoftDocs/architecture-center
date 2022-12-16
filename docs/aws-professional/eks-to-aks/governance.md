---
title: Governance options for a Kubernetes cluster
description: Understand governance options for a Kubernetes cluster, and compare Amazon EKS and Azure Kubernetes Service (AKS) governance options.
author:  gjoshevski
ms.author: mgjoshevski
ms.date: 10/10/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - containers
  - management-and-governance
products:
  - azure-kubernetes-service
  - azure-policy
---

# Cluster Governance

Governance provides mechanisms and processes to control your applications and resources in the cloud. It involves planning your initiatives and setting strategic priorities. Governance can help you mitigate risks, stay compliant with corporate standards and external regulations, and ensure minimal interruption to adoption or innovation in your organization.

When looking at the governance of Kubernetes clusters in a cloud environment, we can distinguish the following aspects:

- Managing the cloud environment and infrastructure where Kubernetes clusters are deployed.
- Governance inside your Kubernetes environment, or how applications are deployed and run on it.

This article will focus only on governance in your Kubernetes environment.

> [!NOTE]
> This article is part of a [series of articles](index.md) that helps professionals who are familiar with Amazon Elastic Kubernetes Service (Amazon EKS) to understand Azure Kubernetes Service (AKS).

## Enforce policies and strengthen governance in your Kubernetes environment
Governance refers to an organization's ability to enforce and validate rules across departments, groups, or the entire organization to guarantee compliance with corporate standards. In the Kubernetes context, this means implementing policies across a fleet of Kubernetes clusters and applications running in those clusters.

There are three governance dimensions to define a consistent Kubernetes governance strategy. 

- **Targets** define the policy goals a governance strategy should meet regarding security and compliance. For example, targets specify which users should have access to a Kubernetes cluster, namespace, or application or which container registries and images to use in which clusters. The security operations team usually sets these targets as the first step when defining a governance strategy for the company. 
- **Scopes** define a set of elements to which policies should be applied to address the targets and must address all Kubernetes-visible components. You can specify scopes in terms of organizational units (departments, teams, groups, users), environments (cloud provider, region, group of clusters, namespaces, etc.), or both. 
- **Policy directives** use Kubernetes capabilities to enforce governance policies across the specified scopes to enforce the rules defined by targets. 

For more information, read [Kubernetes governance, what you should know](https://www.cncf.io/blog/2020/05/29/kubernetes-governance-what-you-should-know/).
You can leverage one of the following leading CNCF projects to enforce policies in your Kubernetes clusters:

- Open Policy Agent (OPA) via Gatekeeper 
- Kyverno

### Open Policy Agent (OPA) & Gatekeeper

[Gatekeeper](https://github.com/open-policy-agent/gatekeeper) is an open-source CNCF project. Gatekeeper is a Kubernetes admission controller that enforces policies created with [Open Policy Agent (OPA)](https://www.openpolicyagent.org/), a general-purpose policy engine. With OPA you can create a policy that runs pods from tenants on separate instances or at a higher priority than other tenants. OPA policies are expressed in a high-level declarative language called [Rego](https://www.openpolicyagent.org/docs/latest/#rego). A collection of common OPA policies can be found in the [OPA Gatekeeper Library]( https://open-policy-agent.github.io/gatekeeper-library/).

### Kyverno

[Kyverno](https://kyverno.io) is a Kubernetes native policy engine that can validate, mutate, and generate configurations with policies as Kubernetes resources. Kyverno uses Kustomize-style overlays for validation, supports JSON Patch and strategic merge patch for mutation, and can clone resources across namespaces based on flexible triggers. With Kyverno, you can manage policies as Kubernetes resources without requiring a new language to define policies. This approach allows using familiar tools such as [kubectl](https://kubernetes.io/docs/tasks/tools/), [git](https://git-scm.com/), and [customize](https://kustomize.io/) to manage policies. You can use Kyverno policies to validate, mutate, and generate Kubernetes resources. 


## EKS Governance

AWS customers usually rely on and use [Kyverno](https://kyverno.io), [Gatekeeper](https://github.com/open-policy-agent/gatekeeper), or other third-party solutions to define and implement a governance strategy for their EKS clusters. This [GitHub repository](https://github.com/aws/aws-eks-best-practices/tree/master/policies) contains a collection of example policies for [Kyverno](https://kyverno.io) and [Gatekeeper](https://github.com/open-policy-agent/gatekeeper).

## AKS Governance

Azure customers can use [Azure Policy with OPA Gatekeeper](/azure/governance/policy/concepts/policy-for-kubernetes) or [Kyverno](https://kyverno.io) to implement a governance strategy and in their AKS clusters.

### Azure Policy

[Azure Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes) extends [Gatekeeper v3](https://github.com/open-policy-agent/gatekeeper), to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner. Azure Policy enables centralized management and reporting of the compliance status of multiple Kubernetes clusters from a single place, making the management and governance of multi-cluster environments significantly more efficient than when Kyverno and Gatekeeper are deployed and managed on a cluster-by-cluster basis.
The add-on enacts the following functions:

- Checks with Azure Policy service for policy assignments to the cluster.
- Deploys policy definitions into the cluster as constraint template and constraint custom resources.
- Reports auditing and compliance details back to Azure Policy service.

Azure Policy for Kubernetes supports the following cluster environments:

- Azure Kubernetes Service (AKS)
- Azure Arc-enabled Kubernetes

You can install Azure Policy on new and existing AKS clusters by installing the [Azure Policy Add-on](/azure/governance/policy/concepts/policy-for-kubernetes#install-azure-policy-add-on-for-aks). For more information, see [Understand Azure Policy for Kubernetes clusters](/azure/governance/policy/concepts/policy-for-kubernetes). 

To improve the security posture of your Azure Kubernetes Service (AKS) cluster, you can apply and enforce built-in security policies on your cluster using Azure Policy. [Azure Policy](/azure/governance/policy/overview) helps to enforce organizational standards and to assess compliance at scale. 

After installing the [Azure Policy Add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes#install-azure-policy-add-on-for-aks), you can apply individual policy definitions or groups of policy definitions called initiatives to your AKS cluster. You can [create and assign your own custom policy definitions](/azure/aks/use-azure-policy#create-and-assign-a-custom-policy-definition) or see [Azure Policy built-in definitions for AKS](/azure/aks/policy-reference) for a complete list of AKS built-in policy and initiative definitions that you can use from the outset.

### Kyverno

Alternatively, you can use [Kyverno](https://kyverno.io/) as a policy engine to secure and manage your AKS cluster.

For more information, see the official [Kyverno installation guide](https://kyverno.io/docs/installation/).

Unlike Azure Policy for Kubernetes, with Kyverno you can create policies not only to validate or mutate existing resources, but also policies to create new Kubernetes objects. For example, you can define a Kyverno policy to automate the creation of a default network policy for any new namespace.

See [Kyverno Policies Library](https://kyverno.io/policies/) for a large list of policies ready to use or customize. You can deploy policies individually using their YAML manifest or package and deploy them using a Helm chart.

Optionally, you can deploy the [Kyverno policies for Kubernetes Pod Security Standards](https://artifacthub.io/packages/helm/kyverno/kyverno-policies/) which provide a Kyverno's implementation of the [Kubernetes Pod Security Standards (PSS)](https://kubernetes.io/docs/concepts/security/pod-security-standards/). The Kubernetes Pod Security Standards (PSS) controls aim to provide a good starting point for general Kubernetes cluster operational security.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski) | Senior Software Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer


## Next steps

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.yml)
- [Kubernetes monitoring and logging](monitoring.yml)
- [Secure network access to Kubernetes](private-clusters.yml)
- [Cost management for Kubernetes](cost-management.yml)


## Related resources

- [Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes)
- [Secure your AKS cluster with Azure Policy](/azure/aks/use-azure-policy)
- [Governance disciplines for AKS](/azure/cloud-adoption-framework/scenarios/app-platform/aks/security)
- [OPA Gatekeeper: Policy and Governance for Kubernetes](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/)
