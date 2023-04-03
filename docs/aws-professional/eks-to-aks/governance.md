---
title: Governance options for a Kubernetes cluster
description: Understand governance options for a Kubernetes cluster, and compare Amazon EKS and Azure Kubernetes Service (AKS) governance options.
author:  gjoshevski
ms.author: mgjoshevski
ms.date: 03/29/2023
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

# Kubernetes cluster governance

Governance refers to an organization's ability to enforce and validate rules to guarantee compliance with corporate standards. Governance helps organizations mitigate risks, comply with corporate standards and external regulations, and minimize interruption to adoption or innovation.

Governance includes planning initiatives, setting strategic priorities, and using mechanisms and processes to control applications and resources. For Kubernetes clusters in a cloud environment, governance means implementing policies across Kubernetes clusters and the applications that run in those clusters.

Kubernetes governance includes both the cloud environment and cluster deployment infrastructure, and the clusters themselves and their applications. This guide focuses on governance within Kubernetes clusters. The article describes and compares how Amazon Elastic Kubernetes Service (Amazon EKS) and Azure Kubernetes Service (AKS) manage Kubernetes cluster governance.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Kubernetes governance dimensions

Three dimensions define a consistent Kubernetes governance strategy:

- **Targets** describe the security and compliance policy goals a governance strategy should meet. For example, targets specify which users can access a Kubernetes cluster, namespace, or application, or which container registries and images to use in which clusters. The security operations team usually sets these targets as the first step in defining a company's governance strategy.

- **Scopes** detail the elements that the target policies apply to. Scopes must address all Kubernetes-visible components. Scopes can be organizational units like departments, teams, and groups, or environments like clouds, regions, or namespaces, or both.

- **Policy directives** use Kubernetes capabilities to enforce the target rules across the specified scopes to enforce the governance policies.

For more information, see [Kubernetes governance, what you should know](https://www.cncf.io/blog/2020/05/29/kubernetes-governance-what-you-should-know).

## Governance in EKS and AKS

- Amazon Web Services (AWS) customers usually use Kyverno, Gatekeeper, or other third-party solutions to define and implement a governance strategy for their Amazon EKS clusters. The [aws-eks-best-practices/policies](https://github.com/aws/aws-eks-best-practices/tree/master/policies) GitHub repository contains a collection of example policies for Kyverno and Gatekeeper.

- Azure customers can also use Kyverno or Gatekeeper, and can use the [Azure Policy for Kubernetes Add-on](/azure/governance/policy/concepts/policy-for-kubernetes) to extend Gatekeeper for an AKS governance strategy.

## Gatekeeper

The [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io) sponsors the open-source [Gatekeeper Policy Controller for Kubernetes](https://github.com/open-policy-agent/gatekeeper) for enforcing policies in Kubernetes clusters. Gatekeeper is a Kubernetes admission controller that enforces policies created with [Open Policy Agent (OPA)](https://www.openpolicyagent.org), a general-purpose policy engine.

OPA uses a high-level declarative language called [Rego](https://www.openpolicyagent.org/docs/latest/#rego) to create policies that can run pods from tenants on separate instances or at different priorities. For a collection of common OPA policies, see the [OPA Gatekeeper Library]( https://open-policy-agent.github.io/gatekeeper-library).

## Kyverno

CNCF also sponsors the [Kyverno](https://kyverno.io) open-source project for enforcing policies in Kubernetes clusters. Kyverno is a Kubernetes-native policy engine that can validate, mutate, and generate Kubernetes resource configurations with policies.

With Kyverno, you can define and manage policies as Kubernetes resources without using a new language. This approach allows using familiar tools such as [kubectl](https://kubernetes.io/docs/tasks/tools), [git](https://git-scm.com), and [kustomize](https://kustomize.io) to manage policies.

Kyverno uses `kustomize`-style overlays for validation, supports JSON patch and strategic merge patch for mutation, and can clone resources across namespaces based on flexible triggers. You can deploy policies individually by using their YAML manifests, or package and deploy them by using Helm charts.

Kyverno, unlike Gatekeeper or Azure Policy for AKS, can generate new Kubernetes objects with policies, not just validate or mutate existing resources. For example, you can define a Kyverno policy to automate the creation of a default network policy for any new namespace.

For more information, see the official [Kyverno installation guide](https://kyverno.io/docs/installation). For a list of ready-to-use or customizable policies, see the Kyverno [Policies](https://kyverno.io/policies) library.

Optionally, you can deploy Kyverno's implementation of the [Kubernetes Pod Security Standards (PSS)](https://kubernetes.io/docs/concepts/security/pod-security-standards) as [Kyverno policies](https://artifacthub.io/packages/helm/kyverno/kyverno-policies). The PSS controls provide a starting point for general Kubernetes cluster operational security.

## Azure Policy Add-on for AKS

[The Azure Policy Add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes) extends [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) to apply at-scale enforcements and safeguards on AKS clusters in a centralized, consistent manner. [Azure Policy](https://azure.microsoft.com/products/azure-policy) enables centralized compliance management and reporting for multiple Kubernetes clusters from a single location. This capability makes management and governance of multicluster environments more efficient than deploying and managing Kyverno or Gatekeeper for each cluster.

The Azure Policy Add-on for AKS enacts the following functions:

- Checks with the Azure Policy service for policy assignments to the cluster.
- Deploys policy definitions into the cluster as constraint template and constraint custom resources.
- Reports auditing and compliance details back to the Azure Policy service.

The Azure Policy Add-on supports the [AKS](/azure/aks) and [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes) cluster environments. For more information, see [Understand Azure Policy for Kubernetes clusters](/azure/governance/policy/concepts/policy-for-kubernetes). To install the add-on on new and existing clusters, see [Install the Azure Policy Add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes#install-azure-policy-add-on-for-aks).

After you install the Azure Policy Add-on for AKS, you can apply individual policy definitions or groups of policy definitions called initiatives to your AKS cluster. You can apply and enforce [Azure Policy built-in policy and initiative definitions](/azure/aks/policy-reference) from the outset, or [create and assign your own custom policy definitions](/azure/aks/use-azure-policy#create-and-assign-a-custom-policy-definition). The [Azure Policy](/azure/governance/policy/overview) built-in security policies help improve the security posture of your AKS cluster, enforce organizational standards, and assess compliance at scale.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski) | Senior Service Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer
- [Ed Price](https://www.linkedin.com/in/priceed) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.yml)
- [Kubernetes monitoring and logging](monitoring.yml)
- [Secure network access to Kubernetes](private-clusters.yml)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.yml)
- [Kubernetes node and node pool management](node-pools.yml)

## Related resources

- [Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes)
- [Secure your AKS cluster with Azure Policy](/azure/aks/use-azure-policy)
- [Governance disciplines for AKS](/azure/cloud-adoption-framework/scenarios/app-platform/aks/security)
- [OPA Gatekeeper: Policy and Governance for Kubernetes](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/)
