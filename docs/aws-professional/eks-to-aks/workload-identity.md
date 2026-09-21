---
title: Workload Identity and Access in EKS and AKS
description: Understand how Kubernetes clusters, nodes, and pods handle identity and access, and compare options in Amazon EKS and Azure Kubernetes Service (AKS).
author: pranabpaul-tech
ms.author: pranabp
ms.date: 08/24/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
ms.custom:
  - arb-containers
ms.collection:
  - migration
  - aws-to-azure
---

# Workload identity and access in EKS and AKS

Amazon Elastic Kubernetes Service (EKS) and Azure Kubernetes Service (AKS) are managed Kubernetes platforms that provide a similar fundamental experience. The cloud provider operates the Kubernetes control plane while you deploy and manage Kubernetes workloads, policies, namespaces, service accounts, and applications. From an identity and access management perspective, however, the two platforms implement security architectures based on their respective cloud ecosystems.

EKS is built on AWS Identity and Access Management (IAM), IAM roles, temporary credentials, Kubernetes RBAC, EKS access entries, and workload identity mechanisms such as EKS Pod Identity and IAM Roles for Service Accounts (IRSA). AKS is built on Microsoft Entra ID, Azure RBAC, Kubernetes RBAC, Azure managed identities, and Microsoft Entra Workload ID. In both platforms, the key architectural objective is the same: avoid using long-lived credentials in applications and instead establish a controlled relationship between a Kubernetes identity and a cloud identity.

This article describes how EKS and AKS provide identity to enable Kubernetes workloads to access cloud platform services. For a detailed comparison of Amazon Web Services (AWS) IAM and Microsoft Entra ID, see the following resources:

- [Microsoft Entra identity management and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security)
- [Compare AWS and Azure identity management solutions](/azure/architecture/aws-professional/security-identity)

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

As managed Kubernetes platforms, Amazon EKS and Azure Kubernetes Service solve the same problem: enabling a cluster, its nodes, and its workloads to access cloud resources without using long-lived credentials. But they solve it with different architectures. EKS routes almost everything through a single system, AWS IAM. AKS splits the problem across two systems: managed identities for cluster communication with Azure, and Microsoft Entra ID to configure who can communicate with the cluster and what they can do. Otherwise, both platforms operate in a similar pattern.

## Amazon EKS identity and access options

Amazon EKS uses AWS IAM for cloud-facing identity and Kubernetes API authentication, but it doesn't replace Kubernetes-native identities. Kubernetes service accounts identify workloads inside the cluster, and Kubernetes RBAC or EKS access policies authorize access to Kubernetes resources.

### Cluster and node identity

Every EKS cluster requires a cluster IAM role that the control plane uses to manage cluster resources. EC2 nodes use a separate node IAM role so that the kubelet can register nodes, pull container images, and call required AWS APIs. These roles correspond to the AKS control-plane and kubelet managed identities described later in this article. For more information, see [Amazon EKS cluster IAM role](https://docs.aws.amazon.com/eks/latest/userguide/cluster-iam-role.html) and [Amazon EKS node IAM role](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html).

### Pod identity

Amazon EKS offers two mechanisms for giving individual pods scoped access to AWS services without widening the node role for every pod on a node.

IRSA was the original mechanism. It requires the cluster to run an IAM OIDC identity provider tied to the cluster's own (OpenID Connect) OIDC endpoint. An IAM role's trust policy is written to accept only tokens issued to a specific Kubernetes namespace and service account, and the Kubernetes service account is annotated with the role's Amazon Resource Name (ARN). When a pod using that service account calls an AWS API, the AWS SDK exchanges the pod's projected service account token for temporary AWS credentials through AWS Security Token Service (STS).

Amazon EKS Pod Identity is a newer, simpler mechanism that removes the OIDC dependency. Instead of a per-cluster OIDC trust relationship, a Pod Identity association maps an IAM role to a Kubernetes service account through the EKS API directly. The role's trust policy needs only a single, cluster-independent principal, `pods.eks.amazonaws.com`. Credentials are issued by the EKS Auth service and cached per node rather than requested independently by every pod's SDK call, which AWS positions as a more scalable and portable pattern: the same IAM role can be reused across multiple clusters without rebuilding a federated trust relationship for each one. Pod Identity supports Linux EC2 nodes and EKS Hybrid Nodes. It isn't available for Fargate, Windows nodes, non-EKS self-managed Kubernetes clusters, AWS Outposts, or EKS Anywhere. For more information, see [EKS Pod Identity](https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html).

Both mechanisms provide short-lived credentials per workload without storing static AWS access keys in pods. The IAM role determines the workload's permissions.

### Cluster access, authentication, and authorization

Human users, IAM roles used by CI/CD pipelines, and cross-account principals all authenticate to the Kubernetes API as IAM identities. EKS access entries associate these principals with Kubernetes permissions through the EKS API. They provide the comparison point for AKS access managed through Microsoft Entra ID and Azure RBAC. Existing EKS clusters might instead use the deprecated aws-auth ConfigMap, whose entries aren't automatically migrated when access entries are enabled. For more information, see [Amazon EKS access entries](https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html).

After authentication, EKS can authorize a principal through an EKS access policy, Kubernetes RBAC groups, or both. Access policies are managed via the EKS API, while Kubernetes RBAC permissions use Role, ClusterRole, RoleBinding, and ClusterRoleBinding objects in each cluster. This choice maps to the AKS distinction between Azure RBAC for Kubernetes authorization and Kubernetes RBAC. For more information, see [Learn how access control works in Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html).

### Auditing

Every IAM and EKS API call, including cluster creation, role assumption, and access entry changes, is captured by AWS CloudTrail, which records who took which action and when. Kubernetes API activity inside the cluster is captured only when you enable EKS control-plane audit logging. EKS sends enabled audit logs to Amazon CloudWatch Logs. For more information, see [Send control plane logs to CloudWatch Logs](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html).

## AKS identity and access options

AKS splits the same set of concerns into two systems: Azure managed identities, which govern how the cluster and its workloads act on Azure resources, and Microsoft Entra ID, which governs who can call the Kubernetes API and what they're allowed to do after they're authenticated. For more information, see [Concepts: access and identity in AKS](/azure/aks/concepts-identity).

### Cluster identity

Every AKS cluster is created with a system-assigned managed identity by default. This identity is created alongside the cluster and deleted with it, requires no stored secret, and needs no manual credential rotation. The control plane uses this identity, with Contributor rights scoped to the cluster's node resource group, to manage load balancers, managed disks, and storage CSI drivers on the cluster's behalf. A separate kubelet identity authenticates the cluster's nodes to Azure Container Registry when pulling images. For more information, see [Overview of managed identities in AKS](/azure/aks/managed-identity-overview).

Clusters can use a user-assigned managed identity in place of the system-assigned identity when the identity needs a lifecycle independent of any single cluster, or when it needs to be shared across multiple Azure resources. The kubelet identity specifically can also be pre-created, which lets an administrator scope its Container Registry permissions precisely before the cluster is ever created, independent of the control-plane identity. For more information, see [System-assigned managed identity](/azure/aks/system-assigned-managed-identity), [User-assigned managed identity](/azure/aks/user-assigned-managed-identity), and [Pre-created kubelet managed identity](/azure/aks/pre-created-kubelet-managed-identity).

Service principals remain available as a legacy alternative, created with `az ad sp create-for-rbac` and supplied to AKS as an application ID and password stored on node virtual machines. We recommend managed identities over service principals because by default service principal credentials expire after one year and require manual rotation. A cluster created with a managed identity also can't be converted back to using a service principal. For more information, see [Use a service principal with AKS](/azure/aks/kubernetes-service-principal).

### Workload identity

For pod-level access to Azure resources, AKS uses Microsoft Entra Workload ID, which, like Amazon EKS's IRSA, is built on OIDC federation. The cluster's OIDC issuer must be enabled so the cluster can publish a discovery document that Microsoft Entra ID uses to validate cluster-issued tokens. Once it's enabled, the OIDC issuer can't be disabled, and enabling it on an existing cluster causes a brief control-plane interruption. A federated identity credential then links a Microsoft Entra managed identity (or registered application) to a specific Kubernetes namespace and service account subject. The service account is annotated with the managed identity's client ID, and the pod is labeled `azure.workload.identity/use: "true"`, which triggers a mutating webhook to inject the projected service account token. At runtime, the application must use a supported version of an Azure Identity client library or the Microsoft Authentication Library (MSAL) to exchange that token for a Microsoft Entra access token, capped at a 24-hour lifetime, without handling a connection string, access key, or password. For more information, see [Microsoft Entra Workload ID overview](/azure/aks/workload-identity-overview) and [Use the OIDC issuer](/azure/aks/use-oidc-issuer).

Use a separate managed identity for each workload when doing so is practical. Scope each identity's Azure role assignments to only the resources and actions that the workload requires.

Each user-assigned managed identity is limited to 20 federated identity credentials. This limit can constrain organizations that share one identity across many clusters with distinct OIDC issuers. [Identity bindings for AKS](/azure/aks/identity-bindings-concepts) address this limit by using one federated credential per managed identity and mapping multiple clusters through separate identity bindings.

The following diagram shows how a Kubernetes cluster becomes a security token issuer that issues tokens to Kubernetes service accounts. You can configure these tokens to be trusted on Microsoft Entra applications. The tokens can then be exchanged for Microsoft Entra access tokens via the [Azure identity services SDKs](/dotnet/api/overview/azure/identity-readme) or the [Microsoft Authentication Library](https://github.com/AzureAD/microsoft-authentication-library-for-dotnet).

:::image type="complex" source="./media/message-flow.png" border="false" lightbox="./media/message-flow.png" alt-text="Diagram that shows a simplified workflow for Microsoft Entra Workload ID in Azure.":::
    A sequence diagram shows the interaction between five components: Kubelet, Kubernetes workload, Microsoft Entra ID, an OpenID discovery document, and Azure resources. The interactions are numbered from 1 to 5. Arrows indicate the direction of communication. An arrow from Kubelet to Kubernetes workload is labeled 1. An arrow from Kubernetes workload to Microsoft Entra ID is labeled 2. An arrow from Microsoft Entra ID to OpenID discovery document is labeled 3. An arrow from Microsoft Entra ID back to Kubernetes workload is labeled 4. An arrow from Kubernetes workload to Azure resources is labeled 5.
:::image-end:::

### Cluster authentication and authorization

Human users and automation authenticate to the AKS control plane by using Microsoft Entra ID. Users and groups are validated against the cluster's Entra tenant, and group membership changes take effect without any cluster-side reconfiguration. Entra ID integration brings Conditional Access, multifactor authentication, and Privileged Identity Management into scope for cluster access. The kubelogin client plugin handles interactive and device-code sign-in flows for kubectl. AKS also supports local accounts, a built-in administrative certificate that bypasses Microsoft Entra ID entirely. We recommend disabling local accounts in production clusters, because they represent a non-auditable path around every other access control that's configured. For more information, see [Cluster authentication concepts in AKS](/azure/aks/concepts-cluster-authentication) and [Manage local accounts](/azure/aks/local-accounts).

AKS supports Kubernetes RBAC and Azure RBAC for Kubernetes authorization, and you can use both models on the same cluster. Use Azure RBAC as the default for centrally governed human access and authorization across multiple clusters. Use Kubernetes RBAC for service accounts, GitOps-managed permissions, and fine-grained access within a cluster or namespace. Kubernetes RBAC uses Role/RoleBinding and ClusterRole/ClusterRoleBinding objects managed per cluster. Azure attribute-based access control (Azure ABAC) uses built-in or custom Azure roles scoped at the cluster, resource group, subscription, or management group level. Azure ABAC conditions are available in preview only to restrict access to specific Custom Resource Definition (CRD) groups and kinds. Don't use this preview feature for production workloads. For more information, see [Cluster authorization concepts in AKS](/azure/aks/concepts-cluster-authorization) and [Use Microsoft Entra ID authorization for the Kubernetes API](/azure/aks/entra-id-authorization).

### Auditing in AKS

Azure records identity-related activity by using complementary logs. The Azure activity log captures control-plane and identity operations, such as role assignments and managed identity changes. Microsoft Entra ID sign-in logs capture who authenticates to the cluster, when authentication occurs, and which Conditional Access policies apply. Kubernetes API activity isn't collected by default. Create an AKS diagnostic setting and route the `kube-audit` or `kube-audit-admin` resource logs to a destination like a Log Analytics workspace. For more information, see [Monitor Azure Kubernetes Service](/azure/aks/monitor-aks).

## Comparing the two models

At a conceptual level, the two platforms solve a similar set of identity problems. IRSA and Microsoft Entra Workload ID both use OIDC federation, while EKS Pod Identity uses the EKS Auth service instead.

| Concern | Amazon EKS | Azure Kubernetes Service |
| ------- | ---------- | ------------------------ |
| Cluster acting on cloud resources | Cluster IAM role | System-assigned or user-assigned managed identity |
| Nodes calling cloud APIs | Node IAM role | Kubelet managed identity |
| Pod-level access without stored secrets | IAM roles for service accounts (IRSA) or EKS Pod Identity | Microsoft Entra Workload ID |
| Federation mechanism | Cluster-specific IAM OIDC provider (IRSA) or pods.eks.amazonaws.com trust (Pod Identity) | AKS OIDC issuer plus federated identity credential |
| Sharing one identity across clusters | Native with Pod Identity, per-cluster trust required with IRSA | Identity bindings (preview), to work around the 20-credential limit |
| Human and automation authentication | IAM principals, via access entries or the legacy aws-auth ConfigMap | Microsoft Entra ID, via kubelogin. Local accounts also exist but are discouraged. |
| In-cluster authorization | EKS access policies, Kubernetes RBAC, or both | Kubernetes RBAC, or Azure RBAC for Kubernetes authorization |
| Multi-cluster, centrally managed access | IAM Identity Center centralizes workforce identities, but access entries must be configured per cluster, typically through infrastructure as code | Azure RBAC role assignments above the cluster scope |
| Just-in-time privileged access | No native equivalent | Privileged Identity Management |
| Control-plane and identity audit trail | AWS CloudTrail | Azure activity log and Microsoft Entra sign-in logs |

The similarities are substantial. Both platforms use platform-managed identities that avoid static credentials and separate cluster-level, node-level, and pod-level identity. IRSA and Microsoft Entra Workload ID use OIDC federation, whereas EKS Pod Identity uses the EKS Auth service. Both platforms support Kubernetes RBAC alongside cloud identity. AWS is replacing the deprecated `aws-auth` ConfigMap with access entries while continuing to support IRSA alongside Pod Identity. We recommend managed identities and Workload ID over service principals and the deprecated pod-managed identity.

The platforms organize identity governance differently. Amazon EKS keeps AWS IAM responsible for the cluster, the nodes, the pods, and the humans who administer the cluster. That setup gives an organization already fluent in IAM a consistent policy language and toolset across every layer. However, there's no built-in equivalent to Conditional Access or just-in-time elevation for cluster access. Azure Kubernetes Service separates cloud-resource access, through managed identity, from human and API access, through Microsoft Entra ID, and offers a choice between Kubernetes-native and Azure-native authorization. That setup requires teams to learn another identity model, but it brings capabilities native to Entra ID, including Conditional Access, Privileged Identity Management, and centralized multi-cluster RBAC.

## Identity and access with EKS Auto Mode and AKS Automatic

Both platforms offer a more fully managed cluster tier that reduces how much identity configuration an operator must perform directly, and both tiers change the identity defaults in similar ways.

EKS Auto Mode shifts more permissions to the cluster IAM role so that EKS can automate compute, storage, networking, and load-balancing operations. It keeps the node IAM role limited to operations like joining the cluster, pulling images, and assuming Pod Identity roles. Auto Mode also includes the Pod Identity Agent. For more information, see [Amazon EKS Auto Mode cluster IAM role](https://docs.aws.amazon.com/eks/latest/userguide/auto-cluster-iam-role.html) and [Amazon EKS Auto Mode node IAM role](https://docs.aws.amazon.com/eks/latest/userguide/auto-create-node-role.html).

AKS Automatic takes a comparable approach in Azure but goes further toward removing configuration choices entirely rather than narrowing them. The following table summarizes the identity defaults that change between AKS Automatic and standard AKS.

| Identity setting | AKS Standard | AKS Automatic |
| ---------------- | ------------ | ------------- |
| Kubernetes API authentication | Local accounts enabled by default. Microsoft Entra authentication is optional. | Microsoft Entra authentication preconfigured. Local accounts disabled. |
| Kubernetes API authorization | Kubernetes RBAC or Azure RBAC for Kubernetes authorization | Azure RBAC preconfigured. Kubernetes RBAC can coexist for service accounts and fine-grained permissions. |
| Local accounts | Enabled by default | Disabled by default |
| OIDC issuer | Enabled by default for new clusters on Kubernetes 1.34 or later. Manually enabled for existing clusters and earlier Kubernetes versions. | Preconfigured |
| Microsoft Entra Workload ID | Optional, enabled separately | Preconfigured |

AKS Automatic doesn't only simplify identity configuration. It removes the least secure default (local accounts) and replaces it with Azure RBAC, OIDC federation, and Workload ID enabled from the start. A cluster created with AKS Automatic begins in the same secure-by-default posture that a security-conscious team would otherwise have to configure explicitly on AKS Standard.

Lined up against each other, EKS Auto Mode and AKS Automatic share a clear intent: reduce the amount of identity configuration left to the operator and default to the more secure option at each layer, but they act on different layers of the stack. EKS Auto Mode's identity changes are concentrated at the cluster and node level, standardizing IAM policies while continuing to rely on IAM as the single identity system. Pod-level identity moves toward EKS Pod Identity, while cluster access can use EKS access policies, Kubernetes RBAC, or both. AKS Automatic's identity changes are concentrated at the authentication and authorization layer, eliminating local accounts and defaulting to Azure RBAC while also preconfiguring OIDC federation and Workload ID for pod-level access.

| Identity setting | EKS Auto Mode | AKS Automatic |
| ---------------- | ------------- | ------------- |
| Cluster and node IAM/identity | Standardized, narrower IAM policy set | Managed identity, unchanged from AKS Standard. |
| Human/API cluster access | IAM principals authenticate via access entries or aws-auth; EKS access policies or Kubernetes RBAC authorize access | Microsoft Entra ID authenticates users. Azure RBAC is preconfigured for authorization. Local accounts are disabled. |
| Pod-level identity | Pod Identity Agent preinstalled. Operators still create pod identity associations. | OIDC issuer and Workload ID enabled. Operators still configure an identity, federated credential, service account, and pod. |
| In-cluster authorization | EKS access policies, Kubernetes RBAC, or both | Azure RBAC is preconfigured. Kubernetes RBAC can coexist for service accounts and fine-grained permissions. |

## Kubernetes identity considerations

Regardless of which platform you use, keep the following points in mind:

First, pod-level identity is where the two platforms are most alike. IRSA is the closest EKS equivalent to Microsoft Entra Workload ID because both use OIDC federation. EKS Pod Identity instead uses the EKS Auth service. For new AKS workloads, use Workload ID rather than the deprecated pod-managed identity.

Second, AKS local accounts bypass Microsoft Entra authentication. Disable local accounts after enabling Microsoft Entra integration so that administrators use centralized authentication. For EKS professionals, access entries provide the closest comparison point for centrally managed principal-to-cluster access, while Azure RBAC provides the AKS authorization layer.

Third, centralizing access across many clusters is a capability, not a given. Amazon EKS handles it through IAM tooling built for AWS generally (such as IAM Identity Center) rather than anything EKS-specific. Azure RBAC, on the other hand, for Kubernetes authorization, is designed from the start to apply consistently across clusters, subscriptions, and management groups.

Finally, AKS Automatic is the recommended production-ready default for most AKS workloads. Compared with EKS Auto Mode, AKS Automatic changes more authentication and authorization defaults by disabling local accounts and preconfiguring Azure RBAC, the OIDC issuer, and Workload ID.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski/) | Senior Service Engineer
- [Pranab Paul](https://www.linkedin.com/in/pranabpaul/) | Senior Global Partner Solution Architect
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Use a service principal with AKS](/azure/aks/kubernetes-service-principal)
- [Use a managed identity in AKS](/azure/aks/managed-identity-overview)
- [Learning path: Manage identity and access in Microsoft Entra ID](/training/paths/manage-identity-and-access)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
- [Microsoft Entra identity management and access management for AWS](../../reference-architectures/aws/aws-azure-ad-security.yml)
