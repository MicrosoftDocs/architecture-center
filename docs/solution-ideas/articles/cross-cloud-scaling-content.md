[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea helps you understand how to improve cross-cloud scalability with solution architecture that includes Azure Stack.

## Architecture
[ ![Architecture diagram that shows how to improve cross-cloud scalability with solution architecture that includes Azure Stack.](../media/cross-cloud-scaling.svg)](../media/cross-cloud-scaling.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/cross-cloud-scaling.vsdx) of this architecture.*

### Dataflow

1. A large number of users attempt to access a web app.
1. Traffic manager returns the Azure Stack DNS name.
1. Users access the Azure Stack web app.
1. Once a threshold is reached, a function starts the Azure Web App and enables the Azure Traffic Manager route.
1. Traffic is routed to Azure, which can automatically scale App Service.

### Components

* [Traffic Manager](https://azure.microsoft.com/services/traffic-manager): Route incoming traffic for high performance and availability
* [Azure Functions](https://azure.microsoft.com/services/functions): Process events with serverless code
* [Azure Stack](https://azure.microsoft.com/overview/azure-stack): Build and run innovative hybrid applications across cloud boundaries

## Scenario details

Modern software is increasingly connected and distributed. The consistency of Azure Stack with Azure infrastructure and platform services enable you to scale resources cross cloud to meet increased load as needed, and decrease resources as demand drops. Optimize cost and maximize resource efficiency while remaining compliant with cross cloud architecture.

### Potential use cases

This solution applies to the following scenarios:

* Implement continuous integration and continuous delivery (CI/CD) practices across an Azure Stack Hub implementation and the public cloud.
* Consolidate the CI/CD pipeline across cloud and on-premises environments.
* Develop apps by using both cloud and on-premises services.

## Next steps

* [Traffic Manager documentation](/azure/traffic-manager)
* [Azure Functions documentation](/azure/azure-functions)
* [Azure Stack documentation](/azure/azure-stack/user/azure-stack-solution-cloud-burst)

## Related resources

* [Azure Functions in a hybrid environment](../../hybrid/azure-functions-hybrid.yml)
* [Cross-cloud scaling with Traffic Manager](../../example-scenario/hybrid/hybrid-cross-cloud-scaling.yml)
* [Enterprise-scale disaster recovery](disaster-recovery-enterprise-scale-dr.yml)
* [Hybrid geo-distributed architecture](../../example-scenario/hybrid/hybrid-geo-distributed.yml)
