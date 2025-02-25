This article describes how Amazon Elastic Kubernetes Service (Amazon EKS) and Azure Kubernetes Service (AKS) provide identity for Kubernetes workloads to access cloud platform services. For a detailed comparison of Amazon Web Services (AWS) Identity and Access Management (IAM) and Microsoft Entra ID, see:

- [Microsoft Entra identity management and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security)
- [Mapping AWS IAM concepts to similar ones in Azure](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/mapping-aws-iam-concepts-to-similar-ones-in-azure/ba-p/3612216)

This guide explains how AKS clusters, built-in services, and add-ons use [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) to access Azure resources like load balancers and managed disks. The article also demonstrates how to use [Microsoft Entra Workload ID](https://azure.github.io/azure-workload-identity/docs) so AKS workloads can access Azure resources without needing a connection string, access key, or user credentials.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS Identity and Access Management

Amazon Elastic Kubernetes Service (EKS) provides native options for managing identity and access management within Kubernetes pods. These options include IAM roles for service accounts and Amazon EKS service-linked roles.

### IAM roles for service accounts

IAM roles for service accounts allow you to associate IAM roles with Kubernetes service accounts. This association provides AWS permissions to the containers within any pod that utilizes the service account. The benefits of using IAM roles for service accounts are as follows:

- **Least privilege**: You can assign specific IAM permissions to a service account, ensuring that only the pods using that service account have access to those permissions. This eliminates the need to grant extended permissions to the node IAM role for all pods on a node, providing a more secure and granular approach. Additionally, this feature eliminates the need for third-party solutions like [kube2iam](https://github.com/jtblin/kube2iam). For more information, see [IAM roles for service accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).

- **Credential isolation**: Each container within a pod can only retrieve the credentials for the IAM role associated with its respective service account. This isolation ensures that a container cannot access credentials belonging to another container in a different pod.

- **Auditability**: Amazon EKS leverages [Amazon CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html?msclkid=001d22acb02911ec8c00d5b286e46997) to provide access and event logging, facilitating retrospective auditing and compliance.

For more information on IAM roles for service accounts, refer to the [official documentation](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).

### Amazon EKS service-linked roles

Amazon EKS service-linked roles are unique IAM roles directly linked to Amazon EKS. These predefined roles include all the necessary permissions required to call AWS services on behalf of the associated role. The main service-linked role for Amazon EKS is the [Amazon EKS node IAM role](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html).

The Amazon EKS node `kubelet` daemon utilizes the Amazon EKS node IAM role to make API calls to AWS services on behalf of the node. The IAM instance profile and associated policies provide permissions for these API calls. This setup simplifies the management of IAM roles for nodes within the EKS cluster.

To learn more about Amazon EKS service-linked roles, visit the [official documentation](https://docs.aws.amazon.com/eks/latest/userguide/using-service-linked-roles.html).

### Additional information

In addition to IAM roles for service accounts and Amazon EKS service-linked roles, there are other essential aspects of managing identity and access in Amazon EKS.

1. [Amazon EKS RBAC Authorization](https://docs.aws.amazon.com/eks/latest/userguide/managing-auth.html): Amazon EKS supports role-based access control (RBAC), allowing you to define fine-grained permissions for Kubernetes resources within your cluster.

2. [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/): IAM provides a comprehensive identity management solution for AWS services, including EKS. It allows you to create and manage users, groups, and roles to control access to your EKS resources.

3. [Amazon EKS Security Groups](https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html): Amazon EKS allows you to apply security group rules to pods running within your cluster to control inbound and outbound traffic.

For more details on managing identity and access management in Amazon EKS, refer to the [official Amazon EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).

## AKS cluster managed identities

Azure Kubernetes Service (AKS) clusters require a [Microsoft Entra identity](/entra/fundamentals/whatis) to access Azure resources like load balancers and managed disks. Managed identities for Azure resources are the recommended way to authorize access from an AKS cluster to other Azure services.

### What are managed identities?

A common challenge for developers is the management of secrets, credentials, certificates, and keys used to secure communication between services. [Managed identities](/entra/identity/managed-identities-azure-resources/overview) eliminate the need for developers to manage these credentials. Managed identities allow you to authenticate your AKS cluster without managing credentials or including them in your code. With managed identities, you assign an [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) role to the identity, granting it permissions to specific resources in Azure.

Here are two types of managed identities:

- **System-assigned**. Some Azure resources, such as virtual machines allow you to enable a managed identity directly on the resource. When you enable a system-assigned managed identity:
  - A service principal of a special type is created in Microsoft Entra ID for the identity. The service principal is tied to the lifecycle of that Azure resource. When the Azure resource is deleted, Azure automatically deletes the service principal for you.
  - By design, only that Azure resource can use this identity to request tokens from Microsoft Entra ID.
  - You authorize the managed identity to have access to one or more services.
  - The name of the system-assigned service principal is always the same as the name of the Azure resource it's created for.

- **User-assigned**. You may also create a managed identity as a standalone Azure resource. You can [create a user-assigned managed identity](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp) and assign it to one or more Azure Resources. When you enable a user-assigned managed identity:
  - A service principal of a special type is created in Microsoft Entra ID for the identity. The service principal is managed separately from the resources that use it.
  - User-assigned identities can be used by multiple resources.
  - You authorize the managed identity to have access to one or more services.

For more information on the differences between the two types of managed identities, see [Managed identity types](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types).

### Managed identities in Azure Kubernetes Service (AKS)

These two types of managed identities are similar in that you can use either type to authorize access to Azure resources from your AKS cluster. The key difference between them is that a system-assigned managed identity is associated with a single Azure resource like an AKS cluster, while a user-assigned managed identity is itself a standalone Azure resource. For more details on the differences between types of managed identities, see **Managed identity types** in [Managed identities for Azure resources](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types).

There are three types of managed identities that you can use with an AKS cluster:

1. **System-assigned managed identity:** This type of managed identity is associated with a single Azure resource, such as an AKS cluster. It exists for the lifecycle of the cluster only.

2. **User-assigned managed identity:** A user-assigned managed identity is a standalone Azure resource that you can use to authorize access to other Azure services from your AKS cluster. It persists separately from the cluster and can be used by multiple Azure resources.

3. **Pre-created kubelet managed identity:** This is an optional user-assigned identity that can be used by the kubelet to access other resources in Azure. If no user-assigned managed identity is specified for the kubelet, AKS creates a user-assigned kubelet identity in the node resource group.

### How does AKS use managed identities?

When you deploy an AKS cluster, a [system-assigned managed identity](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types) is created for you automatically. You can also choose to create the cluster with a [user-assigned managed identity](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types). The cluster uses this managed identity to request tokens from Microsoft Entra ID, which are then used to authorize access to other resources running in Azure.

By assigning an Azure RBAC role to the managed identity, you can grant your cluster permissions to access specific resources. For example, you can assign the managed identity an Azure RBAC role that allows it to access secrets in an Azure Key Vault. This way, you can easily authorize access to your cluster without managing credentials.

### Using managed identities in AKS

When you use managed identities in AKS, you don't need to provision or rotate any secrets. Azure manages the identity's credentials for you. This allows you to authorize access from your applications without managing any additional secrets.

If you already have an AKS cluster that is using a managed identity, you can update it to a different type of managed identity. However, please note that there may be a delay while the control plane components switch to the new identity. This process can take several hours, and during this time, the control plane components will continue to use the old identity until its token expires.

### Summary of managed identities used by AKS

AKS uses different types of managed identities to enable various built-in services and add-ons. Here is a summary of the managed identities used by AKS:

| Identity                                                     | Use Case                                                     | Default Permissions                                          |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Control plane (system-assigned)                              | Used by AKS control plane components to manage cluster resources, including ingress load balancers, AKS-managed public IPs, Cluster Autoscaler, Azure Disk, File, and Blob CSI drivers. | Contributor role for Node resource group                     |
| Kubelet (user-assigned)                                      | Used for authentication with Azure Container Registry (ACR). | N/A (for Kubernetes v1.15+)                                  |
| Add-on identities (e.g., AzureNPM, AzureCNI network monitoring, Azure Policy, Calico, etc.) | No identity required for these add-ons.                      | N/A                                                          |
| Application Routing                                          | Manages Azure DNS and Azure Key Vault certificates.          | Key Vault Secrets User role for Key Vault, DNS Zone Contributor role for DNS zones, Private DNS Zone Contributor role for private DNS zones |
| Ingress Application Gateway                                  | Manages required network resources.                          | Contributor role for node resource group                     |
| OMS Agent                                                    | Used to send AKS metrics to Azure Monitor.                   | Monitoring Metrics Publisher role                            |
| Virtual Node (ACI Connector)                                 | Manages required network resources for Azure Container Instances (ACI). | Contributor role for node resource group                     |
| Cost Analysis                                                | Used to gather cost allocation data.                         | N/A                                                          |
| Workload identity (Microsoft Entra Workload ID)              | Enables applications to securely access cloud resources with Microsoft Entra Workload ID. | N/A                                                          |

For more information about managed identities in AKS, see [Use a managed identity in Azure Kubernetes Service](/azure/aks/use-managed-identity).

## Microsoft Entra Workload ID for Kubernetes

[Microsoft Entra Workload ID](/entra/workload-id/) integrates with Kubernetes to enable workloads deployed on an AKS cluster to access Microsoft Entra protected resources, such as Azure Key Vault and Microsoft Graph. It uses the capabilities native to Kubernetes to federate with external identity providers. For more information, see [Use Microsoft Entra Workload ID with Azure Kubernetes Service](/azure/aks/workload-identity-overview).

To use Microsoft Entra Workload ID, you need to configure a service account within Kubernetes. This service account is then used by pods to authenticate and access Azure resources securely. Microsoft Entra Workload ID works well with Azure Identity client libraries or the Microsoft Authentication Library (MSAL) collection, along with application registration.

To fully leverage Microsoft Entra Workload ID in a Kubernetes cluster, you need to configure the AKS cluster to issue tokens and publish an OIDC discovery document for token validation. For more information, see [Create an OpenID Connect provider on Azure Kubernetes Service](/azure/aks/use-oidc-issuer). 

You also need to configure the Microsoft Entra applications to trust the Kubernetes tokens. Developers can then configure their deployments to use Kubernetes service accounts to obtain tokens, which are then exchanged for Microsoft Entra tokens by Microsoft Entra Workload ID. Finally, AKS cluster workloads can use these Microsoft Entra tokens to securely access protected resources in Azure.

As shown in the following diagram, the Kubernetes cluster becomes a security token issuer that issues tokens to Kubernetes service accounts. You can configure these tokens to be trusted on Microsoft Entra applications. The tokens can then be exchanged for Microsoft Entra access tokens by using the [Azure Identity SDKs](/dotnet/api/overview/azure/identity-readme) or the [Microsoft Authentication Library (MSAL)](https://github.com/AzureAD/microsoft-authentication-library-for-dotnet).

![Diagram showing a simplified workflow for a pod managed identity in Azure.](./media/message-flow.png)

1. The `kubelet` agent projects a service account token to the workload at a configurable file path.
2. The Kubernetes workload sends the projected, signed service account token to Microsoft Entra ID and requests an access token.
3. Microsoft Entra ID uses an OIDC discovery document to check trust on the user-defined managed identity or registered application and validate the incoming token.
4. Microsoft Entra ID issues a security access token.
5. The Kubernetes workload accesses Azure resources by using the Microsoft Entra access token.

For more information, documentation, and automation related to Microsoft Entra Workload ID, refer to the following resources:

- [Azure Workload Identity open-source project](https://azure.github.io/azure-workload-identity)
- [Workload identity federation](/entra/workload-id/workload-identity-federation)
- [Microsoft Entra Workload ID federation with Kubernetes](https://blog.identitydigest.com/azuread-federate-k8s)
- [Microsoft Entra Workload ID federation with external OIDC identity providers](https://arsenvlad.medium.com/azure-active-directory-workload-identity-federation-with-external-oidc-idp-4f06c9205a26)
- [Minimal Microsoft Entra Workload ID federation](https://cookbook.geuer-pollmann.de/azure/workload-identity-federation)
- [Microsoft Entra Workload ID documentation](https://azure.github.io/azure-workload-identity/docs/introduction.html)
- [Microsoft Entra Workload ID quick start](https://azure.github.io/azure-workload-identity/docs/quick-start.html)
- [Example: Use Microsoft Entra Workload ID for Kubernetes with a user-assigned managed identity in a .NET Standard application](/samples/azure-samples/azure-ad-workload-identity-mi/azure-ad-workload-identity-mi/)

### Example workload

An example workload running on an AKS cluster consists of a frontend and a backend service. These services use Microsoft Entra Workload ID to access Azure services, including Azure Key Vault, Azure Cosmos DB, Azure Storage account, and Azure Service Bus namespace. To set up this example workload, the following prerequisites must be met:

1. Set up an AKS cluster with the [OpenID Connect issuer](/azure/aks/use-oidc-issuer) and [Microsoft Entra Workload ID](/azure/aks/workload-identity-deploy-cluster) enabled.
2. Create a Kubernetes [service account](https://kubernetes.io/docs/concepts/security/service-accounts/) in the workload [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/).
3. Create a Microsoft Entra [user-assigned managed identity](/entra/identity/managed-identities-azure-resources/overview) or [registered application](/entra/identity/enterprise-apps/what-is-application-management).
4. Establish a federated identity credential between the Microsoft Entra managed identity or registered application and the workload service account.
5. Assign the necessary roles with appropriate permissions to the Microsoft Entra managed identity or registered application.
6. Deploy the workload and verify authentication with the workload identity.

#### Microsoft Entra Workload ID message flow

In this example workload, the frontend and backend applications acquire Microsoft Entra security tokens to access Azure Platform as a Service (PaaS) services. The following diagram illustrates the message flow:

![Diagram showing an example application that uses Microsoft Entra Workload ID.](./media/azure-ad-workload-identity.png)

*Download a [Visio file](https://arch-center.azureedge.net/eks-to-aks-iam-workload-identity.vsdx) of this architecture.*

1. Kubernetes issues a token to the pod when it's scheduled on a node, based on the pod or deployment spec.
2. The pod sends the OIDC-issued token to Microsoft Entra ID to request a Microsoft Entra token for the specific `appId` and resource.
3. Microsoft Entra ID checks the trust on the application and validates the incoming token.
4. Microsoft Entra ID issues a security token: `{sub: appId, aud: requested-audience}`.
5. The pod uses the Microsoft Entra token to access the target Azure resource.

To use Microsoft Entra Workload ID end-to-end in a Kubernetes cluster:

1. You configure the AKS cluster to issue tokens and publish an OIDC discovery document to allow validation of these tokens.
1. You configure the Microsoft Entra applications to trust the Kubernetes tokens.
1. Developers configure their deployments to use the Kubernetes service accounts to get Kubernetes tokens.
1. Microsoft Entra Workload ID exchanges the Kubernetes tokens for Microsoft Entra tokens.
1. AKS cluster workloads use the Microsoft Entra tokens to access protected resources such as Microsoft Graph.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski) | Senior Service Engineer

Other contributors:

- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Software Engineer
- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer
- [Ed Price](https://www.linkedin.com/in/priceed) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes monitoring and logging](monitoring.yml)
- [Secure network access to Kubernetes](private-clusters.yml)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.yml)
- [Kubernetes node and node pool management](node-pools.yml)
- [Cluster governance](governance.md)
- [Microsoft Entra identity management and access management for AWS](../../reference-architectures/aws/aws-azure-ad-security.yml)

## Related resources

- [Use a service principal with Azure Kubernetes Service (AKS)](/azure/aks/kubernetes-service-principal)
- [Use a managed identity in Azure Kubernetes Service](/azure/aks/use-managed-identity)
- [Implement Azure Kubernetes Service (AKS)](/learn/modules/implement-azure-kubernetes-service)
- [Manage identity and access in Microsoft Entra ID](/learn/paths/manage-identity-and-access)