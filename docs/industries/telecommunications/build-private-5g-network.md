# Build a private 5G network

There are four critical components to a Private 5G Network: the local radio and networking functions, the edge compute platform, the application ecosystem, and the cloud. Today’s Private 5G Network solutions are often built as a collection of loosely integrated components. While this loose integration approach may make sense in terms of physical and organizational demarcation points, it has several critical drawbacks: it is challenging to deploy; complex to manage; costly to scale; and is inherently insecure. 

Microsoft offers operators a different approach to monetize the enterprise opportunity with a fully integrated cloud managed private 5G network solution that features cloud-native mobile core technology, advanced edge computing, and a flexible choice of radio and application partners.  This solution is designed for various industry verticals, delivered and managed by operators.  Microsoft’s architectural and go-to-market approach for private 5G network provides unique advantages to both operators and enterprises while a choice of multiple radio access technologies, platforms and applications. 

Azure Private MEC is a flexible solution for integrating edge compute, networking and applications on a choice of edge platforms.  It is designed for operators and system integrators to deliver high performance MEC use cases to enterprises.

image 

Azure private MEC stack for Telcos to curate Industry solutions

Azure Stack platform for the Edge 

PMEC can be deployed across multiple platforms powered by Azure Stack solutions.  Azure Stack solutions extend Azure services and capabilities to your environment of choice—from the datacenter to edge locations and remote offices—with Azure Stack. Build, deploy, and run hybrid and edge computing apps consistently across your IT ecosystem, with flexibility for diverse workloads.

image 

Choice of cloud managed edge platforms for Private 5G Network

Azure Stack Edge (ASE) is an Azure-managed edge appliance that brings the compute, storage, and intelligence of Azure as an extension of the Azure cloud into the enterprise environment.  As part of the Azure Private MEC solution, ASE provides a single point for processing mobile network data at the edge,  enabling local, intelligent breakout of data processing and seamless data sharing for faster processing and lower bandwidth consumption. 

Azure Stack HCI is a new hyperconverged infrastructure (HCI) operating system delivered as an Azure service. It provides the latest security, performance, and hybrid capabilities, which now include Azure Arc enablement and new management scenarios through the Azure portal. Get robust host security with Secured-core server, improve performance for machine learning models with GPU enablement, and maximize performance of virtual desktop infrastructure. 

Azure Private 5G Core

The final component of Microsoft’s architecture for Private 5G Networks is the 4G/5G mobile core, which is deployed as a standalone (SA) 5G core with an optional 4G interworking function to enable support for 4G LTE RAN. The Azure Private 5G Core provides a fully virtualized, cloud-native solution that includes standard 5G core network functions.

image 

Azure Private 5G Core delivered on the edge as a cloud managed service

Azure cloud is used to automate fully the deployment and configuration of the Azure Private 5G Core on Azure Stack Edge.  To deploy and update network config, the network operator can use any or all of: the Azure Portal web GUI, the Azure Resource Manager REST API, and deployment templates (ARM templates and/or Terraform).     The configuration for the core is declarative, using a standard JSON or Bicep data format, allowing integration with CI/CD pipelines such as Azure DevOps or GitHub Actions for repeatable, efficient deployments and updates across multiple network sites.

Operators don’t have to deploy 5G to realize the value of a cloud-enabled Private 5G Network. With Microsoft’s approach, enterprise customers and operators can deploy Private 5G Network in a 4G only, 5G only, or hybrid 4G/5G environment. Azure Private 5G Core supports the transition from 4G to a 5G standalone network. This flexibility allows enterprises to start with a 4G implementation and migrate to 5G or deploy a hybrid 4G/5G Private 5G Network solution. 

Azure orchestration for edge workloads

Azure offers several tools to onboard edge applications and network functions.  
For customers who want to simplify complex and distributed environments across on-premises, edge and multi-cloud, Azure Arc enables deployment of Azure services anywhere and extends Azure management to any infrastructure.  

- Organize and govern across environments - Get databases, Kubernetes clusters, and servers sprawling across on-premises, edge and multi-cloud environments under control by centrally organizing and governing from a single place.  
- Manage Kubernetes Apps at scale - Deploy and manage Kubernetes applications across environments using DevOps techniques. Ensure that applications are deployed and configured from source control consistently.  
- Run Azure services anywhere - Get automated patching, upgrades, security and scale on-demand across on-premises, edge and multi-cloud environments for your data estate.

For Network Function workloads, Azure Network Function Manager (NFM) is a fully managed cloud-native orchestration service that enables customers to deploy and provision network functions on Azure Stack platforms including ASE Pro with GPU and AS HCI for a consistent experience using the Azure portal.  When used with Azure Stack Edge, NFM provides deployment, provisioning, and secure cloud-based management of your network functions or apps running at the private edge, directly from the Azure portal. A managed service means that an Azure-managed service provider handles updates, lifecycle management, and support for your network functions and applications running on the edge device. The platform supports virtual machines and containerized workloads, along with one or two GPUs for acceleration.

Azure solution characteristics 

This solution is fully integrated and cloud-based, which significantly lowers the total cost of ownership of operating a private cellular network. This is achieved through the following key solution attributes:

Telco Private 5G Network-as-a-service 

Microsoft Azure continues to develop revolutionary core technology that allows operators, for the first time, to deploy a complete CBRS/4G/5G mobile core as a service. The Private 5G Network-as-a-service approach completely changes how Private 5G Networks are deployed and managed. Operators now have greater flexibility and can provide the mobile core functionality as a hosted and fully managed service within Azure.  

The end-to-end solution can be integrated with a variety of other RAN and SIM systems through the Microsoft partner ecosystem. In addition to broad integration with other applications on Azure, such as AI/ML and IoT hub, the solution has many built-in features that enterprises require for service integrations. These features typically incur separate cost, compute, and complex operations, but with Microsoft’s approach, these essential functions are integrated and included as part of the solution with no additional need for hardware. The solution also offers integrated local policy to allow differentiated traffic treatment based on SIM policies configured in the Azure cloud and synced to the Azure Private 5G Core.

True cloud-native solution on Azure

By leveraging both the Azure cloud and Azure Stack Edge, the solution architecture brings the benefits of cloud economics and a pay-as-you-go consumption model. This allows customers to size and deploy the solution for their current workload and avoid the risk of underestimating or overestimating resource requirements. Another benefit the Azure cloud brings is built-in security and privacy compliance. Customers can confidently deploy the solution for verticals that require stringent data privacy laws, such as healthcare, government, public safety, and defense. Deploying an edge-based solution with Azure Stack Edge provides both connectivity services and the ability to deploy edge applications. This helps customers deploy edge applications that require low-latency and edge-compute processing.

Cloud Management, Automation and Observability

The solution is managed remotely using Azure cloud. This is a multi-tenanted solution that gives role-based access control to network admins, allowing them to view, manage, and control Private 5G Networks and SIMs. Cloud management provides big cost savings to customers for several reasons. First, it doesn’t require truck rolls to service the solution. Second, it eliminates the need for an additional on-premises OSS solution, and third, exposed northbound APIs can be easily integrated with existing subscriber identity management (SIM) and OSS/BSS solutions.

Automation delivers a better user experience and simplifies deployment. Solution deployment can be reduced from weeks to hours through automation, whether the deployment is managed by the operator, a managed services provider (MSP), or a Systems Integrator (SI). This is extremely important; otherwise, the scale needed to deploy the solution to thousands of enterprises and consumers is unattainable.  Azure Automation delivers cloud-based automation, operating system updates, and configuration service that supports consistent management across your Azure and non-Azure environments. It includes process automation, configuration management, update management, shared capabilities, and heterogeneous features.

image 

Azure Monitor provides single-pane-of-glass for enterprises

The single-pane-of-glass approach not only allows operators to deploy the service but quickly instantiate the Private 5G Network service at scale for its enterprises. This portal can then be used for full-service assurance and automation, including configuration, fault, and performance management.  

Azure Private 5G core and Azure Stack Edge report metrics and alarms towards Azure Monitor to provide network insights. These insights can be leveraged for closed-loop automation and providing service assurance to the customers. Beyond network insights, this data can provide useful business intelligence and network monetization to enterprise customers. 

Integration with Azure Services

Microsoft’s approach opens a rich ecosystem of applications to operators and enterprise customers, including business intelligence/analytics, artificial intelligence, and machine-learning applications from Microsoft and many others. The Azure Private MEC solution provides the Azure Private 5G Core plus the Azure-managed edge compute environment in a single architecture.  This empowers enterprises to move data in and out of their mobile network for processing while intelligently choosing which data should be processed on-site and which should be sent to the cloud.  

image 

MEC for networking and Applications

An operator needs to provide both the local radio infrastructure and the managed compute in a Private 5G Network service. A cloud edge computing component is also required to process the cloud services and applications. Microsoft proposes a shared, secure edge where both the mobile network functions and local edge applications run side-by-side in a common zero-trust security framework provided by Azure Stack Edge or Azure Stack HCI platforms. This approach offers seamless integration between the 5G network, edge computing, and the cloud and significantly reduces Capex and Opex.

Alternate solutions allow splitting the compute functions into two boxes: one managed by the operator and the other by the enterprise or another managed service provider. In this approach, solution architecture may split up the management, but enterprises will benefit with the use of Azure as the common management layer for both networking and applications. 

For example, consider the scenario where the enterprise customer is a national retail chain with hundreds of stores.  The enterprise can either choose to integrate a select set of Modern Connected Applications with the Private 5G Network on a single compute platform managed by the operator or two distinct compute platforms at every location: one for the mobile network functions (managed by the operator) and another to run distributed cloud and enterprise-developed applications.   The architecture will deliver the flexibility to the enterprise and the operator. 


