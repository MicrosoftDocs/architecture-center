


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Use AKS to simplify the deployment and management of microservices based architecture. AKS streamlines horizontal scaling, self-healing, load balancing, secret management.

## Architecture

![Architecture Diagram](../media/microservices-with-aks.png)
*Download an [SVG](../media/microservices-with-aks.svg) of this architecture.*

## Data Flow

1. Developer uses IDE such as Visual Studio to commit changes to GitHub
1. GitHub triggers a new build on Azure DevOps
1. Azure DevOps packages microservices as containers and pushes them to the Azure Container Registry
1. Containers are deployed to AKS cluster
1. Users access services via apps and website
1. Azure Active Directory is used to secure access to the resources
1. Microservices use databases to store and retrieve information
1. Administrator accesses via a separate admin portal

### Components

- [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service/) offers fully managed Kubernetes clusters for deployment, scaling, and management of containerized applications.
- [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/) is a managed, private Docker registry service on Azure. Use Container Registry to store private Docker images, which are deployed to the cluster. 
- [Azure Database for MySQL](https://azure.microsoft.com/en-us/services/mysql/) is a fully managed MySQL Database service on Azure to store stateful data
- [Azure Active Directory](https://docs.microsoft.com/en-us/azure/aks/manage-azure-rbac). When AKS is integrated with Azure Active Directory, it allows to use Azure AD users, groups, or service principals as subjects in Kubernetes RBAC to manage AKS resources securely.
- Azure Pipelines. Pipelines is part of Azure DevOps Services and runs automated builds, tests, and deployments. You can also use third-party CI/CD solutions such as Jenkins.

- 

## Next Steps

- To learn about hosting Microservices on AKS, see [Microservices architecture on Azure Kubernetes Service (AKS)](../aks-microservices/aks-microservices.yml).
- The see the AKS product roadmap, see [Azure Kubernetes Service Roadmap on GitHub](https://github.com/Azure/AKS/projects/1).

## Related articles

If you need a refresher in Kubernetes, complete the [Azure Kubernetes Service Workshop](/learn/modules/aks-workshop/) to deploy a multi-container application to Kubernetes on Azure Kubernetes Service (AKS).
