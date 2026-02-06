---
title: Kubernetes Workload Identity and Access
description: Understand how Kubernetes pods handle identity and access, and compare options in Amazon EKS and Azure Kubernetes Service (AKS).
author: francisnazareth
ms.author: fnazaret
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-containers
ms.collection:
  - migration
  - aws-to-azure
---

# Kubernetes workload identity and access

This article describes how Amazon Elastic Kubernetes Service (EKS) and Azure Kubernetes Service (AKS) provide identity for Kubernetes workloads to access cloud platform services. For a detailed comparison of Amazon Web Services (AWS) Identity and Access Management (IAM) and Microsoft Entra ID, see the following resources:

- [Microsoft Entra identity management and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security)
- [Map AWS IAM concepts to similar Azure concepts](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/mapping-aws-iam-concepts-to-similar-ones-in-azure/ba-p/3612216)

This guide explains how AKS clusters, built-in services, and add-ons use [managed identities](/entra/identity/managed-identities-azure-resources/overview) to access Azure resources, like load balancers and managed disks. It also demonstrates how to use [Microsoft Entra Workload ID](https://azure.github.io/azure-workload-identity/docs) so that AKS workloads can access Azure resources without needing a connection string, access key, or user credentials.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS identity and access management

Amazon EKS provides native options to manage identity and access within Kubernetes pods. These options include IAM roles for service accounts and Amazon EKS service-linked roles.

### IAM roles for service accounts

You can associate IAM roles with Kubernetes service accounts. This association provides AWS permissions to the containers within any pod that uses the service account. IAM roles for service accounts provide the following benefits:

- **Least privilege:** You can assign specific IAM permissions to a service account, which ensures that only the pods that use that service account have access to those permissions. This configuration eliminates the need to grant extended permissions to the node IAM role for all pods on a node. This approach provides enhanced security and granular control and eliminates the need for partner solutions, like [kube2iam](https://github.com/jtblin/kube2iam). For more information, see [IAM roles for service accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).

- **Credential isolation:** Each container within a pod can only retrieve the credentials for the IAM role that's associated with its respective service account. This isolation ensures that a container can't access credentials that belong to another container in a different pod.

- **Auditability:** Amazon EKS uses [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html?msclkid=001d22acb02911ec8c00d5b286e46997) to provide access and event logging, which facilitates retrospective auditing and compliance.

For more information, see [IAM roles for service accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).

### Amazon EKS service-linked roles

Amazon EKS service-linked roles are unique IAM roles that directly link to Amazon EKS. These predefined roles include the necessary permissions to call AWS services on behalf of the associated role. The main service-linked role for Amazon EKS is the [Amazon EKS node IAM role](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html).

The Amazon EKS node `kubelet` daemon uses the Amazon EKS node IAM role to make API calls to AWS services on behalf of the node. The IAM instance profile and associated policies provide permissions for these API calls. This setup simplifies the management of IAM roles for nodes within the EKS cluster.

For more information, see [Use service-linked roles for Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/using-service-linked-roles.html).

### More information about identity and access management

In addition to IAM roles for service accounts and Amazon EKS service-linked roles, other essential aspects of managing identity and access in Amazon EKS include:

- [Amazon EKS RBAC authorization](https://docs.aws.amazon.com/eks/latest/userguide/managing-auth.html): Amazon EKS supports role-based access control (RBAC). Use this feature to define fine-grained permissions for Kubernetes resources within your cluster.

- [AWS IAM](https://aws.amazon.com/iam/): IAM provides a comprehensive identity management solution for AWS services, including EKS. Use IAM to create and manage users, groups, and roles to control access to your EKS resources.

- [Amazon EKS security groups](https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html): Use Amazon EKS to apply security group rules to pods that run within your cluster. Use this feature to control inbound and outbound traffic.

For more information, see [What is Amazon EKS?](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).

## AKS cluster managed identities

AKS clusters require a [Microsoft Entra identity](/entra/fundamentals/whatis) to access Azure resources, like load balancers and managed disks. We recommend that you use managed identities for Azure resources to authorize access from an AKS cluster to other Azure services.

### Managed identity types

Developers often struggle with the management of secrets, credentials, certificates, and keys that help secure communication between services. [Managed identities](/entra/identity/managed-identities-azure-resources/overview) eliminate the need for you to manage these credentials. You can use managed identities to authenticate your AKS cluster without managing credentials or including them in your code. Assign an [Azure RBAC](/azure/role-based-access-control/overview) role to an identity to grant the identity permissions to specific resources in Azure.

Two types of managed identities include:

- **System-assigned.** You can use some Azure resources, such as virtual machines, to enable a managed identity directly on the resource. When you enable a system-assigned managed identity:
  - A special type of service principal is created in Microsoft Entra ID for the identity. The service principal is tied to the lifecycle of that Azure resource. When the Azure resource is deleted, Azure automatically deletes the service principal.

  - Only that Azure resource can use the identity to request tokens from Microsoft Entra ID.
  - You authorize the managed identity to have access to one or more services.
  - The name of the system-assigned service principal is the same as the name of the Azure resource that it's created for.

- **User-assigned.** You might create a managed identity as a standalone Azure resource. You can [create a user-assigned managed identity](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp) and assign it to one or more Azure resources. When you enable a user-assigned managed identity:
  - A special type of service principal is created in Microsoft Entra ID for the identity. The service principal is managed separately from the resources that use it.

  - Multiple resources can use it.
  - You authorize the managed identity to have access to one or more services.

You can use either type of managed identity to authorize access to Azure resources from your AKS cluster.

For more information, see [Managed identity types](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types).

### Managed identities in AKS

You can use the following types of managed identities with an AKS cluster:

- A **system-assigned managed identity** is associated with a single Azure resource, such as an AKS cluster. It exists for the lifecycle of the cluster only.

- A **user-assigned managed identity** is a standalone Azure resource that you can use to authorize access to other Azure services from your AKS cluster. It persists separately from the cluster and multiple Azure resources can use it.

- A **precreated kubelet managed identity** is an optional user-assigned identity that the kubelet can use to access other resources in Azure. If no user-assigned managed identity is specified for the kubelet, AKS creates a user-assigned kubelet identity in the node resource group.

### Configure managed identities for AKS clusters

When you deploy an AKS cluster, a system-assigned managed identity is automatically created. You can also create the cluster with a user-assigned managed identity. The cluster uses the managed identity to request tokens from Microsoft Entra ID. The tokens authorize access to other resources that run in Azure.

When you assign an Azure RBAC role to the managed identity, you can grant your cluster permissions to access specific resources. For example, you can assign the managed identity an Azure RBAC role that allows it to access secrets in an Azure key vault. Use this approach to easily authorize access to your cluster without managing credentials.

### Benefits and management of managed identities in AKS

When you use managed identities in AKS, you don't need to provision or rotate secrets. Azure manages the identity's credentials. Therefore, you can authorize access from your applications without managing any extra secrets.

If you already have an AKS cluster that uses a managed identity, you can update the cluster to a different type of managed identity. However, this update might introduce a delay while the control plane components switch to the new identity. This process can take several hours. During this time, the control plane components continue to use the old identity until its token expires.

### Types of managed identities in AKS

AKS uses different types of managed identities to enable various built-in services and add-ons.

| Managed identity                                                     | Use case                                                     | Default permissions                                          |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Control plane (system-assigned)                              | AKS control plane components use this identity to manage cluster resources. These resources include ingress load balancers, AKS-managed public IP addresses, the cluster autoscaler, and Azure disk, file, and blob CSI drivers. | Contributor role for the node resource group                     |
| Kubelet (user-assigned)                                      | Authenticate with Azure Container Registry. | N/A (for Kubernetes version 1.15 and later)                                  |
| Add-on identities (AzureNPM, AzureCNI network monitoring, Azure Policy, and Calico) | These add-ons don't require an identity.                      | N/A                                                          |
| Application routing                                          | Manages Azure DNS and Azure Key Vault certificates.          | Key Vault Secrets User role for Key Vault, DNS Zone Contributor role for DNS zones, Private DNS Zone Contributor role for private DNS zones |
| Ingress application gateway                                  | Manages required network resources.                          | Contributor role for the node resource group                     |
| Operations Management Suite (OMS) agent                                                    | Sends AKS metrics to Azure Monitor.                   | Monitoring Metrics Publisher role                            |
| Virtual node (Azure Container Instances connector)                                 | Manages required network resources for Container Instances. | Contributor role for the node resource group                     |
| Cost analysis                                                |  Gathers cost allocation data.                         | N/A                                                          |
| Workload identity (Workload ID)              | Enables applications to securely access cloud resources with Workload ID. | N/A                                                          |

For more information, see [Use a managed identity in AKS](/azure/aks/use-managed-identity).

## Workload ID for Kubernetes

[Workload ID](/entra/workload-id/) integrates with Kubernetes to enable AKS cluster-deployed workloads to access Microsoft Entra protected resources, such as Key Vault and Microsoft Graph. Workload ID uses Kubernetes-native capabilities to federate with external identity providers. For more information, see [Use Workload ID with AKS](/azure/aks/workload-identity-overview).

To use Workload ID, configure a service account within Kubernetes. Pods use this service account to authenticate and access Azure resources securely. Workload ID works well with Azure identity services client libraries or the Microsoft Authentication Library collection. You must register the application in Microsoft Entra ID to manage permissions and access control for the identities.

To fully employ Workload ID in a Kubernetes cluster, configure the AKS cluster to issue tokens and publish an OpenID Connect (OIDC) discovery document for token validation. For more information, see [Create an OIDC provider on AKS](/azure/aks/use-oidc-issuer). 

You also need to configure the Microsoft Entra applications to trust the Kubernetes tokens. Developers can then configure their deployments to use Kubernetes service accounts to obtain tokens. Workload ID exchanges the tokens for Microsoft Entra tokens. AKS cluster workloads can use these Microsoft Entra tokens to securely access protected resources in Azure.

The following diagram shows how a Kubernetes cluster becomes a security token issuer that issues tokens to Kubernetes service accounts. You can configure these tokens to be trusted on Microsoft Entra applications. The tokens can then be exchanged for Microsoft Entra access tokens via the [Azure identity services SDKs](/dotnet/api/overview/azure/identity-readme) or the [Microsoft Authentication Library](https://github.com/AzureAD/microsoft-authentication-library-for-dotnet).


:::image type="complex" source="./media/message-flow.png" border="false" lightbox="./media/message-flow.png" alt-text="Diagram that shows a simplified workflow for a pod managed identity in Azure.":::
A sequence diagram shows the interaction between five components: Kubelet, Kubernetes workload, Microsoft Entra ID, OpenID discovery document, and Azure resources. The interactions are numbered from 1 to 5. Arrows indicate the direction of communication. An arrow from Kubelet to Kubernetes workload is labeled 1. An arrow from Kubernetes workload to Microsoft Entra ID is labeled 2. An arrow from Microsoft Entra ID to OpenID discovery document is labeled 3. An arrow from Microsoft Entra ID back to Kubernetes workload is labeled 4. An arrow from Kubernetes workload to Azure resources is labeled 5.
:::image-end:::

1. The `kubelet` agent projects a service account token to the workload at a configurable file path.

1. The Kubernetes workload sends the projected, signed service account token to Microsoft Entra ID and requests an access token.
1. Microsoft Entra ID uses an OIDC discovery document to verify trust on the user-defined managed identity or registered application and validate the incoming token.
1. Microsoft Entra ID issues a security access token.
1. The Kubernetes workload accesses Azure resources via the Microsoft Entra access token.

For more information about Workload ID, see the following resources:

- [Workload ID open-source project](https://azure.github.io/azure-workload-identity)
- [Workload identity federation](/entra/workload-id/workload-identity-federation)
- [Workload ID federation with Kubernetes](https://blog.identitydigest.com/azuread-federate-k8s)
- [Workload ID federation with external OIDC identity providers](https://arsenvlad.medium.com/azure-active-directory-workload-identity-federation-with-external-oidc-idp-4f06c9205a26)
- [Minimal Workload ID federation](https://cookbook.geuer-pollmann.de/azure/workload-identity-federation)
- [Workload ID documentation](https://azure.github.io/azure-workload-identity/docs/introduction.html)
- [Workload ID quick start](https://azure.github.io/azure-workload-identity/docs/quick-start.html)
- [Use Workload ID for Kubernetes with a user-assigned managed identity in a .NET Standard application](/samples/azure-samples/azure-ad-workload-identity-mi/azure-ad-workload-identity-mi/)

### Example workload

The following example workload runs on an AKS cluster and consists of a front-end and a back-end service. These services use Workload ID to access Azure services, including Key Vault, Azure Cosmos DB, Azure Storage accounts, and Azure Service Bus namespaces. To set up this example workload, do the following prerequisites:

1. Set up an AKS cluster that has the [OIDC issuer](/azure/aks/use-oidc-issuer) and [workload identity](/azure/aks/workload-identity-deploy-cluster) enabled.

1. Create a Kubernetes [service account](https://kubernetes.io/docs/concepts/security/service-accounts/) in the workload [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/).
1. Create a Microsoft Entra user-assigned managed identity or [registered application](/entra/identity/enterprise-apps/what-is-application-management).
1. Establish a federated identity credential between the Microsoft Entra managed identity or registered application and the workload service account.
1. Assign the necessary roles with appropriate permissions to the Microsoft Entra managed identity or registered application.
1. Deploy the workload and verify authentication with the workload identity.

#### Workload ID message flow

In this example workload, the front-end and back-end applications acquire Microsoft Entra security tokens to access Azure platform as a service (PaaS) solutions. The following diagram shows the message flow.

:::image type="complex" source="./media/microsoft-entra-id-workload-identity.svg" border="false" lightbox="./media/microsoft-entra-id-workload-identity.svg" alt-text="Diagram that shows an example application that uses Workload ID.":::
The main section is the AKS cluster setup, which includes the NGINX ingress controller and the Todolist namespace and its components. The deployment containers indicate step 1 in the overall workflow. Flow 2 goes from the deployment containers to Microsoft Entra ID. Flow 3 goes from Microsoft Entra ID to the OIDC issuer URL. Flow 4 goes from Microsoft Entra ID to the deployment containers. Flow 5 goes from the deployment containers to Azure Key Vault, Azure Service Bus, Azure Cosmos DB, and an Azure Storage account.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/eks-to-aks-iam-workload-identity.vsdx) of this architecture.*

1. Kubernetes issues a token to the pod when the pod is scheduled on a node. This token is based on the pod or deployment specifications.

1. The pod sends the OIDC-issued token to Microsoft Entra ID to request a Microsoft Entra token for the specific `appId` and resource.
1. Microsoft Entra ID verifies the trust on the application and validates the incoming token.
1. Microsoft Entra ID issues a security token: `{sub: appId, aud: requested-audience}`.
1. The pod uses the Microsoft Entra token to access the target Azure resource.

To use Workload ID end-to-end in a Kubernetes cluster:

1. Configure the AKS cluster to issue tokens and publish an OIDC discovery document to allow validation of these tokens.

1. Configure the Microsoft Entra applications to trust the Kubernetes tokens.
1. Developers configure their deployments to use the Kubernetes service accounts to get Kubernetes tokens.
1. Workload ID exchanges the Kubernetes tokens for Microsoft Entra tokens.
1. AKS cluster workloads use the Microsoft Entra tokens to access protected resources, such as Microsoft Graph.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski/) | Senior Service Engineer

Other contributors:

- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Software Engineer
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Use a service principal with AKS](/azure/aks/kubernetes-service-principal)
- [Use a managed identity in AKS](/azure/aks/use-managed-identity)
- [Learning path: Manage identity and access in Microsoft Entra ID](/learn/paths/manage-identity-and-access)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Secure network access to Kubernetes](private-clusters.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
- [Microsoft Entra identity management and access management for AWS](../../reference-architectures/aws/aws-azure-ad-security.yml)
