


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Use the AKS virtual node to provision pods inside ACI that start in seconds. This enables AKS to run with just enough capacity for your average workload. As you run out of capacity in your AKS cluster, scale out additional pods in ACI without any additional servers to manage.

## Architecture

![Architecture Diagram](../media/scale-using-aks-with-aci.png)
*Download an [SVG](../media/scale-using-aks-with-aci.svg) of this architecture.*

## Components

1. [ Azure Container Registry ](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-intro)- You can deploy the models to a private Docker Registry such as Azure Container Registry since they are Docker container images.
2. [Azure Kubernetes Services](https://docs.microsoft.com/en-us/azure/aks/)-You can use Azure Kubernetes Services to automatically scale the model's Docker container image for high-scale production deployments.
3. [ Azure Container Instances ](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview)-You can deploy the model's Docker container image directly to a container group.
4. [Azure SQL DB ](https://docs.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview)- Azure SQL Database is a fully managed platform as a service (PaaS) database engine that handles most of the database management functions such as upgrading, patching, backups, and monitoring without user involvement.

## Data Flow

1. User registers container in Azure Container Registry
1. Container images are pulled from the Azure Container Registry
1. AKS virtual node, a Virtual Kubelet implementation, provisions pods inside ACI from AKS when traffic comes in spikes.
1. AKS and ACI containers write to shared data store

## Next Steps

1. [ Scale with ease using AKS and ACI ](https://azure.microsoft.com/en-in/resources/scale-with-ease-using-aks-and-aci/)
3. [ Scaling options for applications in Azure Kubernetes Service (AKS) ](https://docs.microsoft.com/en-us/azure/aks/concepts-scale)
5. [ Scale single database resources in Azure SQL Database ](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-scale#:~:text=%20Scale%20single%20database%20resources%20in%20Azure%20SQL,storage%20in%20the%20Premium%20tier%20is...%20More)
