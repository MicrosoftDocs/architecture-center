This guide describes various options for connecting to the API server of your Azure Kubernetes Service (AKS) cluster or private AKS cluster. In the general case, the API server of an AKS cluster is exposed over the internet. With a private AKS cluster, you can only connect to the API server from a device that has network connectivity to that private AKS cluster. Planning access to your API Server is a day-zero activity. How you choose to access the API server depends on your deployment scenario.

## AKS API server access

To manage an AKS cluster, you interact with its API server. It's critical to lock down access to the API server and only grant access to those who need it. You can provide granular access by integrating your AKS cluster with Azure Active Directory (Azure AD). Administrators can then use role-based access control (RBAC) to restrict access. Through RBAC, administrators can place users and identities in Azure AD groups and assign appropriate roles and permissions to the groups. Azure AD authentication is provided to AKS clusters with OpenID Connect. For more information, see [AKS-managed Azure Active Directory integration](https://docs.microsoft.com/en-us/azure/aks/managed-aad) or [Integrate Azure Active Directory for the cluster](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks#integrate-azure-active-directory-for-the-cluster).

> [!NOTE]
> You can further lock down your AKS cluster by only allowing authorized IP address ranges to communicate with the API Server. For more information, see [Secure access to the API server using authorized IP address ranges in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges).

## Access the AKS cluster over the internet

When you create a non-private cluster that resolves to the API server's fully qualified domain name (FQDN), the API server is assigned a public IP address by default. You can use the Azure portal to connect to your cluster, or you can use a shell like the Azure CLI, Powershell, or Command Prompt.

> [!NOTE]
> For detailed information about using the Kubernetes command-line client `kubectl` to connect to a cluster over the internet, see [Connect to the cluster](https://docs.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster).

## Azure Cloud Shell

Azure Cloud Shell is a shell that's built into the Azure portal. You can manage and connect to Azure resources from Cloud Shell the same way you would from PowerShell or the Azure CLI. For more information, see [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview).

## Access an AKS private cluster

Don't forget the note that comes before Bastion.

