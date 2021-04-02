


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

## Components

* [Azure Active Directory](/services/active-directory/)
* [Azure Container Registry](/services/container-registry/)
* [Azure Cosmos DB](/services/cosmos-db/)
* [Azure Database for MySQL](/services/mysql/)
* [Azure DevOps](/services/devops/)
* [Azure Kubernetes Service](/services/kubernetes-service/)
* [Azure SQL Database](/services/sql-database/)

## Next steps

* [Azure Kubernetes Service solution journey](/azure/architecture/reference-architectures/containers/aks-start-here)
* [Microservices architecture on Azure Kubernetes Service (AKS)](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)
* [CI/CD pipeline for container-based workloads](/azure/architecture/example-scenario/apps/devops-with-aks)
