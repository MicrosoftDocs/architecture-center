# Build a private 5G network

This article is the second part of a series of articles about deploying private 5G networks. 

> [!div class="nextstepaction"]
> [Go to the first article in the series](deploy-private-mobile-network.md)

There are four critical components to a private 5G network: the local radio and networking functions, the edge compute platform, the application ecosystem, and the cloud. Private 5G network solutions are often built as a collection of loosely integrated components. This loose integration approach might make sense in terms of physical and organizational demarcation points, but it has drawbacks. The following problems are inherent in this approach: 

- Difficult to deploy 
- Difficult to manage 
- Expensive to scale 
- Not secure 

Microsoft offers a different approach to help operators take advantage of the  opportunity to provide private 5G to enterprises. This cloud-managed private 5G network solution features cloud-native mobile core technology, advanced edge computing, and a flexible choice of radio and application partners. The solution is designed to be delivered and managed by operators. It's appropriate for various industry verticals.  The Microsoft approach for private 5G networks provides advantages to both operators and enterprises, and a choice of platforms and applications.

[Azure private multiaccess edge compute](https://azure.microsoft.com/solutions/private-multi-access-edge-compute-mec) is a solution for integrating edge compute, networking, and applications on a range of edge platforms. It's designed to help operators and system integrators deliver high-performance MEC solutions to enterprises.

:::image type="content" source="media/private-multiaccess-edge-compute.png " alt-text="Diagram that shows the Azure private multiaccess edge compute stack." lightbox="media/private-multiaccess-edge-compute.png":::

## Azure Stack platform for the edge 

Private multiaccess edge compute can be deployed across multiple platforms powered by [Azure Stack](https://azure.microsoft.com/products/azure-stack) solutions. Azure Stack solutions extend Azure services and capabilities to various environments, from the datacenter to edge locations and remote offices. Operators can use Azure Stack to build, deploy, and run hybrid and edge computing apps consistently across IT ecosystems.

:::image type="content" source="media/edge-platforms.png" alt-text="Figure that shows cloud-managed edge platforms for private 5G networks.":::

[Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge) is an Azure-managed edge appliance that brings the compute, storage, and intelligence of Azure into the enterprise environment. As part of the private multiaccess edge compute solution, Azure Stack Edge provides a single point for processing mobile network data at the edge. It enables local, intelligent breakout of data processing for faster processing and lower bandwidth consumption.

Azure Stack HCI is a hyperconverged infrastructure (HCI) operating system delivered as an Azure service. It provides the latest security, performance, and hybrid capabilities, which include [Azure Arc](https://azure.microsoft.com/products/azure-arc) enablement and management via the Azure portal. 

## Azure Private 5G Core

The final component of the Microsoft architecture for private 5G networks is the 4G/5G mobile core, which is deployed as a standalone 5G core with an optional 4G interworking function to enable support for 4G LTE RAN. Private 5G Core is a fully virtualized, cloud-native solution that includes standard 5G core network functions.

:::image type="content" source="media/private-5g-core.png" alt-text="Diagram that shows the key components of Private 5G Core.":::

Azure automates the deployment and configuration of Private 5G Core on Azure Stack Edge. To deploy and update network configuration, the network operator can use any or all of these tools: 

- The Azure portal web GUI 
- The Azure Resource Manager REST API
- Deployment templates (ARM templates and/or Terraform)

Operators can use declarative syntax, in standard JSON or Bicep data format, to configure the core. This enables integration with CI/CD pipelines like Azure DevOps or GitHub Actions for repeatable deployments and updates across multiple network sites.

Operators don't have to deploy 5G to benefit from a cloud-enabled private 5G network. Enterprise customers and operators can deploy private 5G network in a 4G only, 5G only, or hybrid 4G/5G environment. Private 5G Core supports the transition from 4G to a 5G standalone network, so enterprises can start with a 4G implementation and later migrate to 5G or deploy a hybrid 4G/5G private solution. 

## Azure orchestration for edge workloads

Azure provides several tools for onboarding edge applications and network functions.  

Customers who want to simplify complex and distributed environments across on-premises, edge, and multi-cloud can use Azure Arc to deploy Azure services anywhere and extend Azure management to any infrastructure.  

- Organize and govern across environments - Get databases, Kubernetes clusters, and servers sprawling across on-premises, edge and multi-cloud environments under control by centrally organizing and governing from a single place.  
- Manage Kubernetes Apps at scale - Deploy and manage Kubernetes applications across environments using DevOps techniques. Ensure that applications are deployed and configured from source control consistently.  
- Run Azure services anywhere - Get automated patching, upgrades, security and scale on-demand across on-premises, edge and multi-cloud environments for your data estate.

For Network Function workloads, Azure Network Function Manager (NFM) is a fully managed cloud-native orchestration service that enables customers to deploy and provision network functions on Azure Stack platforms including Azure Stack Edge Pro with GPU and AS HCI for a consistent experience using the Azure portal.  When used with Azure Stack Edge, NFM provides deployment, provisioning, and secure cloud-based management of your network functions or apps running at the private edge, directly from the Azure portal. A managed service means that an Azure-managed service provider handles updates, lifecycle management, and support for your network functions and applications running on the edge device. The platform supports virtual machines and containerized workloads, along with one or two GPUs for acceleration.

## Azure solution characteristics 

This solution is fully integrated and cloud-based, which significantly lowers the total cost of ownership of operating a private cellular network. This is achieved through the following key solution attributes:

### Telco Private 5G Network-as-a-service 

Microsoft Azure continues to develop revolutionary core technology that allows operators, for the first time, to deploy a complete CBRS/4G/5G mobile core as a service. The Private 5G Network-as-a-service approach completely changes how Private 5G Networks are deployed and managed. Operators now have greater flexibility and can provide the mobile core functionality as a hosted and fully managed service within Azure.  

The end-to-end solution can be integrated with a variety of other RAN and SIM systems through the Microsoft partner ecosystem. In addition to broad integration with other applications on Azure, such as AI/ML and IoT hub, the solution has many built-in features that enterprises require for service integrations. These features typically incur separate cost, compute, and complex operations, but with Microsoft’s approach, these essential functions are integrated and included as part of the solution with no additional need for hardware. The solution also offers integrated local policy to allow differentiated traffic treatment based on SIM policies configured in the Azure cloud and synced to the Azure Private 5G Core.

### True cloud-native solution on Azure

By leveraging both the Azure cloud and Azure Stack Edge, the solution architecture brings the benefits of cloud economics and a pay-as-you-go consumption model. This allows customers to size and deploy the solution for their current workload and avoid the risk of underestimating or overestimating resource requirements. Another benefit the Azure cloud brings is built-in security and privacy compliance. Customers can confidently deploy the solution for verticals that require stringent data privacy laws, such as healthcare, government, public safety, and defense. Deploying an edge-based solution with Azure Stack Edge provides both connectivity services and the ability to deploy edge applications. This helps customers deploy edge applications that require low-latency and edge-compute processing.

### Cloud Management, Automation and Observability

The solution is managed remotely using Azure cloud. This is a multi-tenanted solution that gives role-based access control to network admins, allowing them to view, manage, and control Private 5G Networks and SIMs. Cloud management provides big cost savings to customers for several reasons. First, it doesn’t require truck rolls to service the solution. Second, it eliminates the need for an additional on-premises OSS solution, and third, exposed northbound APIs can be easily integrated with existing subscriber identity management (SIM) and OSS/BSS solutions.

Automation delivers a better user experience and simplifies deployment. Solution deployment can be reduced from weeks to hours through automation, whether the deployment is managed by the operator, a managed services provider (MSP), or a Systems Integrator (SI). This is extremely important; otherwise, the scale needed to deploy the solution to thousands of enterprises and consumers is unattainable.  Azure Automation delivers cloud-based automation, operating system updates, and configuration service that supports consistent management across your Azure and non-Azure environments. It includes process automation, configuration management, update management, shared capabilities, and heterogeneous features.

image 

Azure Monitor provides single-pane-of-glass for enterprises

The single-pane-of-glass approach not only allows operators to deploy the service but quickly instantiate the Private 5G Network service at scale for its enterprises. This portal can then be used for full-service assurance and automation, including configuration, fault, and performance management.  

Azure Private 5G core and Azure Stack Edge report metrics and alarms towards Azure Monitor to provide network insights. These insights can be leveraged for closed-loop automation and providing service assurance to the customers. Beyond network insights, this data can provide useful business intelligence and network monetization to enterprise customers. 

### Integration with Azure Services

Microsoft’s approach opens a rich ecosystem of applications to operators and enterprise customers, including business intelligence/analytics, artificial intelligence, and machine-learning applications from Microsoft and many others. The Azure Private MEC solution provides the Azure Private 5G Core plus the Azure-managed edge compute environment in a single architecture.  This empowers enterprises to move data in and out of their mobile network for processing while intelligently choosing which data should be processed on-site and which should be sent to the cloud.  

image 

### MEC for networking and Applications

An operator needs to provide both the local radio infrastructure and the managed compute in a Private 5G Network service. A cloud edge computing component is also required to process the cloud services and applications. Microsoft proposes a shared, secure edge where both the mobile network functions and local edge applications run side-by-side in a common zero-trust security framework provided by Azure Stack Edge or Azure Stack HCI platforms. This approach offers seamless integration between the 5G network, edge computing, and the cloud and significantly reduces Capex and Opex.

Alternate solutions allow splitting the compute functions into two boxes: one managed by the operator and the other by the enterprise or another managed service provider. In this approach, solution architecture may split up the management, but enterprises will benefit with the use of Azure as the common management layer for both networking and applications. 

For example, consider the scenario where the enterprise customer is a national retail chain with hundreds of stores.  The enterprise can either choose to integrate a select set of Modern Connected Applications with the Private 5G Network on a single compute platform managed by the operator or two distinct compute platforms at every location: one for the mobile network functions (managed by the operator) and another to run distributed cloud and enterprise-developed applications.   The architecture will deliver the flexibility to the enterprise and the operator. 