


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Use the AKS virtual node to provision pods inside ACI that start in seconds. This enables AKS to run with just enough capacity for your average workload. As you run out of capacity in your AKS cluster, scale out additional pods in ACI without any additional servers to manage.

## Architecture

![Architecture Diagram](../media/scale-using-aks-with-aci.png)
*Download an [SVG](../media/scale-using-aks-with-aci.svg) of this architecture.*

## Data Flow

1. User registers container in Azure Container Registry
1. Container images are pulled from the Azure Container Registry
1. AKS virtual node, a Virtual Kubelet implementation, provisions pods inside ACI from AKS when traffic comes in spikes.
1. AKS and ACI containers write to shared data store

## Components

- [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service/) offers fully managed Kubernetes clusters for deployment, scaling, and management of containerized applications.
- [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/) is a managed, private Docker registry service on Azure. Use Container Registry to store private Docker images, which are deployed to the cluster. 
- [Azure Container Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview) offers the fastest and simplest way to run a container in Azure, without having to manage any virtual machines and without having to adopt a higher-level service. Azure Kubernetes Service (AKS) can use the Virtual Kubelet to provision pods inside Azure Container Instance(ACI) that start in seconds. This enables AKS to run with just enough capacity for your average workload. As you run out of capacity in your AKS cluster, scale out additional pods in ACI without any additional servers to manage.
- [Azure Database for MySQL](https://azure.microsoft.com/en-us/services/mysql/) is a fully managed MySQL Database service on Azure to store stateful data.
- [Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview) is a fully managed and intelligent relational database service built for the cloud. With SQL Database, you can create a highly available and high-performance data storage layer for modern cloud applications.

## Next Steps

- To learn about how to run a Kubernetes cluster by bridging AKS and ACI through the Virtual-Kubelet, see [Run a serverless Kubernetes cluster by bridging AKS and ACI through the Virtual-Kubelet](https://azure.microsoft.com/en-us/resources/videos/ignite-2018-run-a-serverless-kubernetes-cluster-by-bridging-aks-and-aci-through-the-virtual-kubelet/).
- The see the AKS product roadmap, see [Azure Kubernetes Service Roadmap on GitHub](https://github.com/Azure/AKS/projects/1).

## Related articles

If you need a refresher in Kubernetes, complete the [Azure Kubernetes Service Workshop](https://docs.microsoft.com/en-us/learn/modules/aks-workshop/) to deploy a multi-container application to Kubernetes on Azure Kubernetes Service (AKS).
