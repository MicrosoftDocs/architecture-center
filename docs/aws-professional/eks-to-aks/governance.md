---
title: Governance Options for a Kubernetes Cluster
description: Understand governance options for a Kubernetes cluster, and compare Amazon EKS and Azure Kubernetes Service (AKS) governance options.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: 
 - migration
 - aws-to-azure
ms.custom:
  - arb-containers
---

# Kubernetes cluster governance

Governance refers to an organization's ability to enforce and validate rules to help guarantee compliance with corporate standards. Governance helps organizations mitigate risks, comply with corporate standards and external regulations, and minimize interruption to adoption or innovation.

Governance includes planning initiatives, setting strategic priorities, and using mechanisms and processes to control applications and resources. For Kubernetes clusters in a cloud environment, governance means implementing policies across Kubernetes clusters and the applications that run in those clusters.

Kubernetes governance includes the cloud environment, the cluster deployment infrastructure, the clusters themselves, and the clusters' applications. This guide focuses on governance within Kubernetes clusters. The article compares Amazon Elastic Kubernetes Service (EKS) and Azure Kubernetes Service (AKS) Kubernetes cluster governance.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Kubernetes governance dimensions

Three aspects define a consistent Kubernetes governance strategy:

- **Targets** define the security and compliance policy goals for your governance strategy. For example, targets can specify which users can access a Kubernetes cluster, namespace, or application. Or they can specify which container registries and images to use in which clusters. Your security operations team usually sets these targets as the first step to define your company's governance strategy.

- **Scopes** detail the elements that the target policies apply to. Scopes must address all Kubernetes-visible components. Scopes include organizational units like departments, teams, and groups or environments like clouds, regions, or namespaces.

- **Policy directives** use Kubernetes capabilities to enforce the target rules across the specified scopes, which helps enforce governance policies.

For more information, see [Kubernetes governance](https://www.cncf.io/blog/2020/05/29/kubernetes-governance-what-you-should-know).

## Governance in EKS and AKS

- Amazon Web Services (AWS) customers usually use [Kyverno](https://kyverno.io), [Gatekeeper](https://github.com/open-policy-agent/gatekeeper), or other partner solutions to define and implement a governance strategy for their Amazon EKS clusters. The [aws-eks-best-practices/policies](https://github.com/aws/aws-eks-best-practices/tree/master/policies) GitHub repository contains a collection of example policies for Kyverno and Gatekeeper.

- Azure customers can also use Kyverno or Gatekeeper. To extend Gatekeeper for an AKS governance strategy, you can use the [Azure Policy for Kubernetes add-on](/azure/governance/policy/concepts/policy-for-kubernetes).

## Gatekeeper

The [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io) sponsors the open-source [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) tool, which helps enforce policies in Kubernetes clusters. Gatekeeper is a Kubernetes admission controller that helps enforce policies that you create with [Open Policy Agent (OPA)](https://www.openpolicyagent.org), a general-purpose policy engine.

OPA uses a high-level declarative language called [Rego](https://www.openpolicyagent.org/docs/latest/#rego) to create policies that can run pods from tenants on separate instances or at different priorities. For a collection of common OPA policies, see the [OPA Gatekeeper library](https://open-policy-agent.github.io/gatekeeper-library).

## Kyverno

CNCF also sponsors the [Kyverno](https://kyverno.io) open-source project, which helps enforce policies in Kubernetes clusters. Kyverno is a Kubernetes-native policy engine that can use policies to validate, mutate, and generate Kubernetes resource configurations.

Use Kyverno to define and manage policies as Kubernetes resources without using a new language. You can manage policies by using familiar tools, such as [kubectl](https://kubernetes.io/docs/tasks/tools), [git](https://git-scm.com), and [kustomize](https://kustomize.io).

Kyverno has the following features:
- Uses `kustomize`-style overlays for validation
- Supports JSON patch and strategic merge patch for mutation
- Clones resources across namespaces based on flexible triggers

To deploy policies individually, use the policy YAML manifests. To package and deploy policies, use Helm charts.

Unlike Gatekeeper or Azure Policy for AKS, Kyverno can use policies to generate new Kubernetes objects, instead of only validating or mutating existing resources. For example, you can define a Kyverno policy to automate the creation of a default network policy for new namespaces.

- For more information, see [Kyverno installation guide](https://kyverno.io/docs/installation).
- For a list of ready-to-use or customizable policies, see [Kyverno policies library](https://kyverno.io/policies).
- For troubleshooting guidance, such as *APIServer failing webhook calls*, see [Kyverno troubleshooting](https://kyverno.io/docs/troubleshooting/#api-server-is-blocked).

Optionally, you can deploy Kyverno's implementation of the [Kubernetes Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards) as [Kyverno policies](https://artifacthub.io/packages/helm/kyverno/kyverno-policies). Pod Security Standards controls provide a starting point for general Kubernetes cluster operational security.

## Azure Policy add-on for AKS

The [Azure Policy add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes) extends [Gatekeeper](https://github.com/open-policy-agent/gatekeeper), which is an admission controller webhook for [OPA](https://www.openpolicyagent.org/). This add-on applies at-scale enforcements and safeguards on your cluster components in a centralized, consistent manner. Cluster components include pods, containers, and namespaces. [Azure Policy](https://azure.microsoft.com/products/azure-policy) provides centralized compliance management and reporting for multiple Kubernetes clusters. This capability simplifies the management and governance of multicluster environments compared to deploying and managing Kyverno or Gatekeeper for each cluster.

The [Azure Policy add-on for AKS](/azure/governance/policy/concepts/policy-for-kubernetes) performs the following functions:

- It uses Azure Policy to check for policy assignments to the cluster.

- It deploys policy definitions into the cluster as constraint-template and constraint-custom resources.
- It reports auditing and compliance details back to Azure Policy.

The Azure Policy add-on is compatible with both [AKS](/azure/aks) and [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes) cluster environments. For more information, see [Understand Azure Policy for Kubernetes clusters](/azure/governance/policy/concepts/policy-for-kubernetes).

To install the add-on on new and existing clusters, follow the [installation instructions](/azure/governance/policy/concepts/policy-for-kubernetes#install-azure-policy-add-on-for-aks).

After you install the Azure Policy add-on for AKS, you can apply individual policy definitions or groups of policy definitions, called *initiatives*, to your AKS cluster. You can enforce [Azure Policy built-in policy and initiative definitions](/azure/aks/policy-reference) from the start. Or you can create and assign your own custom policy definitions by doing the [necessary steps](/azure/aks/use-azure-policy#create-and-assign-a-custom-policy-definition). The [Azure Policy](/azure/governance/policy/overview) built-in security policies enhance the security posture of your AKS cluster, enforce organizational standards, and assess compliance at scale.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski/) | Senior Service Engineer

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes)
- [Secure your AKS cluster by using Azure Policy](/azure/aks/use-azure-policy)
- [Governance disciplines for AKS](/azure/cloud-adoption-framework/scenarios/app-platform/aks/security)
- [OPA Gatekeeper: Policy and governance for Kubernetes](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)

