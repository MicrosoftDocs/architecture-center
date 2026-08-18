---
title: Governance Options for a Kubernetes Cluster
description: Understand governance options for a Kubernetes cluster, and compare Amazon EKS and Azure Kubernetes Service (AKS) governance options.
author: pranabpaul-tech
ms.author: pranabp
ms.date: 06/07/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection:
  - migration
  - aws-to-azure
ms.custom:
  - arb-containers
---

# Kubernetes cluster governance

Governance includes planning initiatives, setting strategic priorities, and using mechanisms and processes to control applications and resources. Every organization and workload relies on internal rules to satisfy legal obligations, enforce industry best practices, and maintain standard operational conventions. You should automate these policy checks because manual enforcement is both inefficient and prone to human error. Automation provides operational consistency, gives developers instant configuration feedback to minimize delivery delays, and grants engineering teams autonomy without compromising corporate compliance.

For Kubernetes clusters in a cloud environment, governance means implementing policies across Kubernetes clusters and the applications that run in those clusters. Kubernetes supports policy enforcement through built-in [admission controllers](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/), ValidatingAdmissionPolicy, and admission webhooks. Admission webhooks intercept only create, update, delete, or connect requests that match their configured rules. Mutating webhooks can modify requests, and validating webhooks can accept or reject them. Kubernetes governance includes the cloud environment, the cluster deployment infrastructure, the clusters themselves, and the clusters' applications.

This guide focuses on governance within Kubernetes clusters. The article compares Amazon Elastic Kubernetes Service (EKS) and Azure Kubernetes Service (AKS) Kubernetes cluster governance.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Kubernetes governance dimensions

Three aspects define a consistent Kubernetes governance strategy:

- **Targets** define the security and compliance policy goals for your governance strategy. For example, targets can specify which users can access a Kubernetes cluster, namespace, or application. Or they can specify which container registries and images to use in which clusters. Your security operations team usually sets these targets as the first step of defining your company's governance strategy.

- **Scopes** specify the elements that the target policies apply to. Scopes must address all Kubernetes-visible components. Scopes include organizational units like departments, teams, and groups or environments like clouds, regions, or namespaces.

- **Policy directives** use Kubernetes capabilities to enforce the target rules across the specified scopes, which helps enforce governance policies.

For more information, see [Kubernetes Governance](https://www.cncf.io/blog/2024/09/23/kubernetes-governance-the-great-policy-for-innovation/).

## Governance tools

### Open Policy Agent

The [Open Policy Agent (OPA)](https://github.com/open-policy-agent/opa) is an open-source, general-purpose policy engine that unifies policy enforcement across the stack. OPA provides a high-level declarative language that you can use to specify policy as code (PaC). It also provides simple APIs to offload policy decision-making from your software. Use OPA to enforce policies in microservices, Kubernetes, CI/CD pipelines, API gateways, and more.

OPA uses a high-level declarative language called [Rego](https://www.openpolicyagent.org/docs#writing-policies-with-rego) to express policy decisions. For example, a Rego policy can require tenant pods to use designated nodes or a specific priority class.

### Gatekeeper

[Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/) is a Kubernetes webhook that validates and enforces policies on resources by using OPA rules. It helps cluster administrators enforce compliance. Beyond admission control, Gatekeeper's auditing capabilities enable administrators to identify resources that violate specific policies.

Gatekeeper provides the gator CLI to evaluate constraints against manifests outside a cluster. Integrate gator with a pre-commit hook or CI pipeline to detect noncompliant infrastructure-as-code changes before deployment. Gatekeeper's admission webhook doesn't block source-control commits.

### Kyverno

[Kyverno](https://kyverno.io/) is a cloud-native policy engine that was initially developed for Kubernetes and has since evolved into a unified policy language that you can use both inside and outside of Kubernetes environments. It enables platform engineering teams to automate security, compliance, and operational best-practice enforcement while providing application teams with secure self-service capabilities.

Key capabilities of Kyverno include:

- Managing policies as declarative Kubernetes resources.
- Enforcing policies through a Kubernetes admission controller, CLI-based scanning, and runtime validation.
- Validating, mutating, generating, and cleaning up Kubernetes resources.
- Verifying container images and associated metadata to strengthen software supply chain security.
- Applying policies to any JSON-based payload, including Terraform configurations, cloud resources, and service authorization requests.
- Generating policy reports by using the [OpenReports](https://openreports.io/) standard. OpenReports standardizes policy violation reporting across many tools.
- Supporting flexible policy exception workflows.
- Providing tooling for comprehensive unit and end-to-end policy testing.
- Enabling policy-as-code practices by using familiar tools such as Git and [Kustomize](https://kustomize.io/).

### Kubewarden

[Kubewarden](https://www.kubewarden.io/) is a policy engine that uses WebAssembly (Wasm) to execute policies written in multiple languages, including CEL, Rego (OPA and Gatekeeper variants), Rust, Go, and YAML. Developers can author, test, and iterate on policies locally before deploying them to a Kubernetes cluster.

### GitOps

As cloud-native adoption continues to grow, [GitOps](https://about.gitlab.com/topics/gitops/) has become a widely adopted approach for managing Kubernetes applications and infrastructure. By using Git as the single source of truth, GitOps enables consistent, automated, and auditable deployments. It helps teams improve reliability, simplify operations, and speeds up software delivery.

A variety of GitOps tools are available for Kubernetes, each offering different features, deployment models, and integration capabilities. Select the right solution based on your organization's operational requirements, team expertise, scalability goals, and compatibility with your existing CI/CD pipelines and platform tooling. Choosing the most appropriate tool can significantly affect the efficiency, security, and maintainability of your Kubernetes environment.

## Governance in EKS

Governance in EKS relies on identifying and fixing policy violations and configuration errors early in the software development lifecycle, before deployment ([shifting left](https://docs.aws.amazon.com/eks/latest/best-practices/compliance.html#_shifting_left)). This approach improves security by allowing developers to address issues before applications reach EKS clusters. Policy defines the rules that govern acceptable and prohibited behaviors, such as requiring containers to run as non-root users. PaC automates the enforcement of security, compliance, and privacy controls while keeping policies version-controlled like other code. This approach enables organizations to apply DevOps and GitOps practices to consistently manage and enforce policies across EKS environments.

Amazon Web Services (AWS) customers can use Kyverno, Gatekeeper, or other partner solutions to define and implement a governance strategy for their Amazon EKS clusters. You can find a collection of common Gatekeeper OPA policies in the [EKS GitHub repository](https://github.com/aws/aws-eks-best-practices/tree/mainline/policies/opa). For Kyverno, see the project's [policies repository](https://github.com/kyverno/policies). Kubewarden is another option for implementing governance policies programmatically. [GitOps tools and operators](https://docs.aws.amazon.com/prescriptive-guidance/latest/eks-gitops-tools/introduction.html), such as Argo CD, Flux, Jenkins X, and Rancher Fleet, can support administrative, DevOps, and policy-related requirements in EKS.

You enforce best practices on an Amazon EKS cluster by using a combination of PaC admission controllers, the official AWS automated validation CLI, and native AWS governance configurations.

### AWS managed policies for Amazon EKS

[AWS managed policies](https://docs.aws.amazon.com/eks/latest/userguide/security-iam-awsmanpol.html) are prebuilt, standalone Identity and Access Management (IAM) policies that AWS creates and maintains to support common permission requirements for EKS clusters. They provide a quick way to assign access permissions to users, groups, and roles without creating custom policies from scratch. However, because these policies are designed for a broad range of AWS customers, they might grant more permissions than necessary for a specific environment. To follow the principle of least privilege, create [customer-managed policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#customer-managed-policies) tailored to your organization's exact access requirements.

### Conformance packs for AWS Config

A [conformance pack](https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html) is a collection of AWS Config rules and optional remediation actions that you can deploy together as a single package across an AWS account, Region, or multiple accounts within an AWS organization. It simplifies the implementation of compliance and governance by grouping related rules into a reusable template. You define conformance packs by using YAML templates that include AWS Config managed or custom rules, along with remediation actions where applicable. You can also store these templates as AWS Systems Manager (SSM) documents for centralized management and deployment. You can deploy conformance packs by using the AWS Config console or the AWS CLI.

## Governance in AKS

Azure customers can also use Kyverno or Gatekeeper. To extend Gatekeeper for an AKS governance strategy, use the [Azure Policy for Kubernetes add-on](/azure/governance/policy/concepts/policy-for-kubernetes). Unlike Gatekeeper or Azure Policy for AKS, Kyverno can use policies to generate new Kubernetes objects, instead of only validating or mutating existing resources. For example, you can define a Kyverno policy to automate the creation of a default network policy for new namespaces. Kubewarden is another option for implementing admission-control policies in Kubernetes clusters.

[Flux and Argo CD](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks) are widely used GitOps tools for AKS. These operators manage GitOps continuous delivery of apps and infrastructure workloads. GitOps enforces source control as the single source of truth for the system. You can use policy management and enforcement tools with GitOps to enforce policies and provide feedback for proposed policy changes.

[Deployment Safeguards](/azure/aks/deployment-safeguards) are used to enforce best practices on an AKS cluster. Deployment Safeguards are optional for AKS Standard. For AKS Automatic, Deployment Safeguards and baseline Pod Security Standards are enabled by default in Enforce mode.

### Azure Policy add-on for AKS

The Azure Policy add-on for AKS extends Gatekeeper, which is an admission controller webhook for OPA. This add-on applies policy enforcement at scale and provides centralized safeguards for your cluster components. Cluster components include pods, containers, and namespaces. [Azure Policy](/azure/governance/policy/overview) provides centralized compliance management and reporting for multiple Kubernetes clusters. When you use this capability, the management and governance of multicluster environments is easier than it is when you deploy and manage Kyverno or Gatekeeper for each cluster.

The Azure Policy add-on for AKS performs the following functions:

- It uses Azure Policy to check for policy assignments to the cluster.
- It deploys policy definitions into the cluster as ConstraintTemplate and Constraint custom resources.
- It reports auditing and compliance details back to Azure Policy.

To install the add-on on new and existing clusters, follow the [installation instructions](/azure/governance/policy/concepts/policy-for-kubernetes#install-azure-policy-add-on-for-aks).

After you install the Azure Policy add-on for AKS, you can apply individual policy definitions or groups of policy definitions, called initiatives, to your AKS cluster. You can enforce [Azure Policy built-in policy and initiative definitions](/azure/aks/policy-reference) from the start. Or you can create and assign your own custom policy definitions by completing the [necessary steps](/azure/aks/use-azure-policy#optional-create-and-assign-a-custom-policy-definition). The [Azure Policy](/azure/governance/policy/overview) built-in security policies enhance the security posture of your AKS cluster, enforce organizational standards, and assess compliance at scale.

### Azure Policy initiative

Like conformance packs for AWS Config, an [Azure Policy initiative](/azure/governance/policy/concepts/initiative-definition-structure) (represented by the `Microsoft.Authorization/policySetDefinitions` resource type in the Azure API) is a collection of multiple Azure Policy definitions grouped together to meet a single overarching governance goal or compliance standard. Instead of assigning and tracking individual policies one by one, you apply the entire initiative to a specific scope, allowing you to manage compliance at scale.

### Azure Kubernetes Fleet Manager

[Azure Kubernetes Fleet Manager](/azure/kubernetes-fleet/overview) provides centralized management for fleets of supported Kubernetes clusters, including AKS and Azure Arc-enabled clusters across clouds and on-premises. You can create an Azure Kubernetes Fleet Manager resource with or without a hub cluster. Update orchestration doesn't require a hub, but capabilities such as managed Fleet namespaces and resource placement do. Managed Fleet namespaces can enforce resource quotas, network policies, and user access across selected member clusters. Azure Kubernetes Fleet Manager also provides centralized access to monitoring data.

## Comparison chart between AWS and Azure policy implementation at different scopes

| Scope | AWS | Azure |
| --- | --- | --- |
| Organization / Enterprise | AWS Organizations (service control policies, or SCPs). Enforce guardrails across multiple AWS accounts. Common tools: AWS Organizations SCPs, IAM Identity Center, AWS Control Tower. | Management group. Apply governance policies across multiple subscriptions. Common tools: Azure Policy, Azure RBAC, Azure landing zones. |
| Account / Subscription | AWS account. Control permissions and compliance within a single account. Common tools: IAM policies, AWS Config, AWS CloudTrail, AWS Security Hub. | Subscription. Apply policies to all resources within a subscription. Common tools: Azure Policy, Azure RBAC, Microsoft Defender for Cloud. |
| Resource group | No direct equivalent of Azure resource groups. You can achieve similar governance by using resource tags, AWS Config Rules, IAM Conditions, and AWS Resource Groups. | Resource group. Scope policies to related resources. Common tools: Azure Policy, Azure RBAC, resource locks, tags. |
| Managed Kubernetes cluster | Amazon EKS. Enforce Kubernetes policies within clusters. Common tools: Validating Admission Policy (CEL), OPA Gatekeeper, Kyverno, Kubernetes RBAC, Amazon EKS Pod Identity, IAM roles for service accounts (IRSA). | AKS. Enforce Kubernetes-specific policies. Common tools: Azure Policy for AKS (Gatekeeper), Validating Admission Policy (CEL), OPA Gatekeeper, Kyverno, Kubernetes RBAC. |

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski/) | Senior Service Engineer
- [Pranab Paul](https://www.linkedin.com/in/pranabpaul/) | Senior Global Partner Solution Architect
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Policy for Kubernetes](/azure/governance/policy/concepts/policy-for-kubernetes)
- [Secure your AKS cluster by using Azure Policy](/azure/aks/use-azure-policy)
- [AKS security best practices](/azure/aks/concepts-security)
- [OPA Gatekeeper: Policy and governance for Kubernetes](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)

