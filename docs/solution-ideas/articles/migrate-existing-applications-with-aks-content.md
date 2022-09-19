[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Easily migrate existing application to container(s) and run within the Azure managed Kubernetes service (AKS). Control access via integration with Azure Active Directory and access SLA-backed Azure Services, such as Azure Database for MySQL using OSBA (Open Service Broker for Azure), for your data needs.

## Potential use cases

This solution is for migrating current applications.

## Architecture

![Diagram shows existing application migration to containers in Azure Kubernetes Service with Open Service Broker for Azure to access Azure databases.](../media/migrate-existing-applications-with-aks.png)

*Download a [Visio file](https://arch-center.azureedge.net/migrate-existing-applications-with-aks.vsdx) of this architecture.*

### Dataflow

1. User converts existing application to container(s) &amp; publishes container image(s)to the Azure Container Registry
1. By using Azure portal or command line, user deploys containers to AKS cluster
1. Azure Active Directory is used to control access to AKS resources
1. Easily access SLA-backed Azure Services such as Azure Database for MySQL using OSBA (Open Service Broker for Azure)
1. Optionally, AKS can be deployed with a VNET virtual network
