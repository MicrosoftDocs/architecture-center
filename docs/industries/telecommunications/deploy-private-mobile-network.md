---
title: Deploy private 5G networks on Azure
description: Get an overview of how system integrators and operators can build private networks for enterprises by using Azure services. 
author: rickliev 
ms.author: rickliev
ms.date: 11/04/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-stack-edge
  - azure-stack-hci
  - azure-arc
  - azure-kubernetes-service
categories:
  - networking
  - mobile
---

# Deploy private 5G networks on Azure

The fourth industrial revolution, often referred to as *Industry 4.0*, is here. Industry 4.0 brings with it modern industrial applications that will change the way businesses operate. These applications have improved processing power and connectivity. They collect and process data from across an organization to help businesses run more strategically and efficiently. As enterprises scale, they need solutions that can handle these workloads. 

To meet these requirements, modern enterprises need both private 5G networks and multiaccess edge computing (MEC) solutions. Private LTE/5G networks give businesses the speed, security, mobility, and quality of service they need to process data efficiently. Edge compute supports latency-sensitive industrial applications and data localization and enables time-sensitive data to be processed quickly at the edge. 

Some challenges need to be addressed before enterprises can realize the benefits of private LTE/5G networks. These challenges include reducing operational and engineering complexity, ensuring end-to-end visibility for multi-site enterprises, providing access security, and improving the delivery of automated, software-based solutions. 

To meet these challenges, Microsoft has introduced an approach that combines Azure managed services, including a platform and networking services together with a radio and application ISV ecosystem. The solution is a fully integrated private 5G network service that's created for enterprises. A growing list of mobile operators and managed service providers deliver and manage these services. The solution combines Azure, [Azure Network Function Manager](https://azure.microsoft.com/products/azure-network-function-manager), [Azure Arc](https://azure.microsoft.com/products/azure-arc), [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge), [Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci), [Azure Kubernetes Service](https://azure.microsoft.com/products/kubernetes-service), and [Azure Private 5G Core](https://azure.microsoft.com/products/private-5g-core). These services are all managed and orchestrated from the Azure cloud. 

This approach addresses the complexity and cost challenges faced by system integrators and enterprises. It enables enterprises to deploy high-performance, enhanced-security private 5G networks that can drive the adoption of modern industrial applications.

This is part one of two articles that explain how system integrators and operators can build private networks for enterprises by using Azure services. These networks take advantage of the benefits of a hyperscale cloud and integrated MEC architecture to lower CapEx and OpEx, drive innovation, and open new revenue opportunities.

## Private networks enhanced by 5G 

Private networks enhanced by 5G are transforming telecommunications services. Key radio and core features in 5G enable the dense scale and delivery of enhanced mobile broadband (eMBB), ultra-reliable low-latency communications (URLLC), and massive machine-type communications (mMTC). This allows operators to offer new services that are oriented to developers of high-performance industrial applications and enable the introduction of new commercial models.  

Consumer-based offerings like voice, text, data, and video will remain an integral part of the telco operator service portfolio. However, new enterprise-based offerings like LTE/5G private networks for robotics, video AI, massive-scale IoT for digital twin applications, and augmented reality experiences with devices like HoloLens will create new revenue opportunities for operators. To deliver these services, telco operators need to move beyond the traditional telco network architecture and more directly use hyperscale cloud and MEC.  

Several factors motivate the implementation of private enterprise mobile networks: 

- The scale and reach limitations of current in-building wireless systems
- The rising amount of generated data and video
- The increased need for higher levels of mobility and security and the demand for real-time data processing  

The combination of 5G, MEC, and the cloud makes it possible to create private wireless networks that are fast, highly secure, and scalable, and can take advantage of applications for analytics running at the far edge, in the cloud, or across hybrid locations.

Here are some of the industry use cases that private 5G networks can help deliver:  

:::image type="content" source="media/industry-use-cases.png" alt-text="Diagram showing industry use cases that are powered by private 5G networks." lightbox="media/industry-use-cases.png":::

Private 5G networks represent a strong use case for 5G enterprise services because these capabilities will underpin the more sophisticated services, like smart spaces and Industry 4.0 applications. Yet, despite the advantages of a 5G private network, challenges remain for operators and enterprises. The biggest challenge is the complexity of deploying and managing a 5G network in an enterprise environment. 5G networks involve considerations that lie outside the traditional enterprise skill set, from radio frequency (RF) design to 5G mobile core architectures. Also, telco operators might lack the technology portfolio or minimal footprint needed to cost-effectively deploy 5G networks and cloud-managed edge computing in an enterprise environment.

Microsoft proposes a simplified MEC-as-a-service approach that combines a global hyperscale cloud platform with networking components like a cloud-native, 5G standalone core that powers a suite of cloud applications. This approach enables enterprises to collect data from across their networks and efficiently process delay-sensitive data at the edge and still take advantage of the ability to process large amounts of data on Azure. 

### Benefits of private 5G networks

The arrival of 4G and access to shared spectrums like CBRS in limited geographic regions changed private 5G network economics. This change occurred because it enabled enterprises to deploy and experiment by using dedicated private cellular networks that use small cell technology and virtualized network functions. 5G RAN and core optimizations provide a richer set of capabilities, including faster speeds, ultra-low latency, security methods, and cost efficiencies. These 5G characteristics are critical in industries like manufacturing and transportation, where the challenges of geographic coverage and the expanding use of IoT applications require enhanced network characteristics.  

Multiple vertical industries can benefit from these same characteristics, as described in the following sections. 

#### Reliable coverage

Many industrial and enterprise applications require connectivity that exceeds the coverage limitations of the wired and Wi-Fi technologies that are common in Operational Technology environments. 4G and 5G radios' use of dedicated spectrum to limit dynamic interference and increase transmit power, and the inherent mobility capabilities, provide high performance, high capacity, and cost-effective wireless connectivity over large sites. These sites include airports, seaports, open-cast mines, distribution centers, campuses, and construction sites. The flexibility to use different spectrum options optimizes coverage and data rates for both indoor and outdoor use cases.  

#### Higher throughput

4G technology can provide the throughput required by many private network applications. But 5G can deliver 10 to 20 times the throughput of 4G, which expands the range of applications that can be supported wirelessly. Upcoming spectrum options like millimeter wave can be deployed for indoor use to optimize for greater density of devices even when they're distributed in noisy RF environments. This results in a scalable network. 

#### Low latency
 
5G networks provide latency that's an order of magnitude less than that of 4G networks. Low latency is important for time-sensitive applications like robotic control systems, which typically have round-trip latency budgets of 10 ms or less. 5G networks that have applications deployed in local edge compute facilities can comfortably support these latency requirements. 

#### Deterministic access support

5G radio, by design, supports deterministic access. This design places a guaranteed upper limit on latency and jitter, which is important for many kinds of applications. In this category, 5G is far closer to the performance of wired Ethernet. Because of 5G, applications that once required wired connections can now be untethered.   

#### Data localization and privacy 

By using traditional corporate networks, enterprises can effectively limit the exposure of data to specific geo-fenced regions. With the widespread adoption of wireless technologies, however, the ability to limit data exposure came at the price of restricting access. Private 5G networks, combined with edge computing, can provide better visibility and control over where data is accessed and processed. This visibility and control gives the enterprise a much higher level of data sovereignty. Private 5G networks and edge computing enable highly sensitive information to be kept with increased security locally and not exposed, even to the operator, over external network connections. 

#### Operational simplicity

Operators are faced with implementing multiple versions of network technology, along with access control and other security functions based on the need for wired, Wi-Fi, and, increasingly, mobile broadband access to corporate resources. Private wireless networks give enterprise IT teams the opportunity to build a simplified access architecture that works for employees in and out of the office. 

#### Backhaul savings 

Some types of industrial and enterprise applications, like high-resolution video cameras for surveillance or inspection, generate large amounts of data. These applications usually involve a mix of storage and analysis. They're typically not highly sensitive to latency. However, it makes sense to deploy these applications in local compute facilities to avoid the high cost of backhauling large volumes of data to a centralized cloud. Private 5G networks make this deployment possible. Connectivity to centralized cloud facilities then has to handle only summarized data, for example, information about actionable events detected by local analysis.  

#### Legal and regulatory compliance improvements 

Private 5G mobile networks don't just allow data to be kept locally. They also help enterprises protect themselves from threats to their information and communications security. 5G has more built-in security mechanisms than any earlier generation of cellular technology and includes enhanced protection from sophisticated attacks, like IMSI-catcher and Stingray. By using multiple layers of embedded Azure security and tools like Defender for Cloud, the operator can deploy, monitor, and operate critical workloads and applications with improved security, even when running at the customer edge.   

### Private 5G network: Manufacturing case study

Smart devices, automation, the cloud, and mobile broadband technology are driving the Industry 4.0 revolution. This revolution, in turn, is creating demand for private 5G networks in the manufacturing industry, which is the leading consumer of private 5G networks. Private 5G networks can provide a foundation for manufacturers that want to connect smart devices and use telemetry data to support real-time decisions and improve operational efficiencies. The ability to efficiently process network data in the cloud helps manufacturers in a variety of ways:  

#### Maintenance prediction

- Monitoring and tracking quality
- Reducing machine wear, breakdowns, and bottlenecks
- Improving operating efficiencies

#### Smart factories

- Connected factory applications
- Staff safety applications and air quality management
- Access control (security) and smart analytics

#### Manufacturing operations

- Asset management and intelligent manufacturing and inventory 
- Performance optimization and monitoring
- End-to-end operational visibility

The Microsoft approach to private 5G networks is ideally suited to IoT and Industry 4.0 applications. The ability to process data in a single on-premises platform and intelligently backhaul selective data for processing in Azure enables real-time decision-making and automation with low latencies. A reduction in backhauled traffic also reduces costs, for the enterprise and the operator. 

The Azure Zero Trust model helps to ensure that manufacturing data remains secure as it moves among the mobile network functions, the enterprise, and the cloud. These security enhancements also free operators from the task of securing customer data in transit or in storage. 

### Telco path to private 5G networks 

Private 5G networks exist at the intersection of the traditional enterprise LAN, specialized industrial networks, and the public mobile network. They give operators a chance to expand the scope of 5G services into new markets. 

When considering how to deploy private 5G networks, many enterprises will look favorably on mobile network operators as potential suppliers. Enterprises view operators as trusted partners in communications, and the commercial relationships are already established. Operators have expertise in deploying and operating secure and reliable mobile networks. Depending on local spectrum licensing, there might be a regulatory requirement or spectrum condition stating that an enterprise must partner with a mobile operator to deploy private 5G.

Some network operators might view private 5G networks as a natural extension of their public mobile networks. They could take advantage of their existing network assets and use network slicing to securely partition enterprise mobile traffic from public networks. However, enterprises want a dedicated network with localized connectivity and more control than they can get with that approach. And public networks are built primarily to serve the mobile broadband market. They're highly optimized for that purpose. Enterprise applications will place new and different demands on the network, which won't provide the flexibility that's required. The industry is adopting an edge-based private wireless network that also allows deep integration with the operator network. Enterprises should take advantage of the flexibility of 5G.

:::image type="content" source="media/telcos-provide-edge-networks-apps.png " alt-text="Diagram that shows how telcos provide Azure managed-edge networks and applications to global enterprises." lightbox="media/telcos-provide-edge-networks-apps.png ":::

A private 5G network solution that operators and enterprises can feel confident about requires three key attributes:

- **Managed connectivity.** Many enterprises have experience with managing their Wi-Fi network and mobile access points. Few have experience with 4G/5G radio network design, SIM activation, and end-to-end solution deployment. This situation presents an opportunity for operators to bring a managed radio and spectrum solution to meet the needs of enterprises.

- **Managed services.** A partner that can provide deployment and management of end-to-end private 5G networks and develop and deliver applications adds significant value to the enterprise. Moving total solution management into a centralized, cloud-based environment allows operators and managed service providers to deliver end-to-end managed services from a single location. Taking advantage of the automation, security, and scale of cloud-based architectures is essential to providing a clear ROI model for enterprises to adopt private 5G networks.

- **Managed applications.** Use cases for private 5G networks are as unique as the businesses they serve. For example, a remote oil-drilling platform won't have the same concerns as a car manufacturer. To address these varied use cases, there must be flexibility and simplicity in how edge platforms and networks are configured, deployed, and managed. 
 
The installation and management of private wireless networks with the desired MEC applications is simplified for both the operator and the enterprise.

> [!div class="nextstepaction"]
> [Go to part two: Build a private 5G network](build-private-5g-network.md)

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author: 

 - [Rick Lievano](https://www.linkedin.com/in/ricklievano) | Director of Business Strategy

Other contributor:

 - [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Private 5G Core Preview?](/azure/private-5g-core/private-5g-core-overview)
- [Key components of a private mobile network](/azure/private-5g-core/key-components-of-a-private-mobile-network)
- [Private mobile network design requirements](/azure/private-5g-core/private-mobile-network-design-requirements)
- [Learning path: Deploy 5G services with Azure](/training/paths/deploy-5g-services)

## Related resources

- [Solutions for the telecommunications industry](../../industries/telecommunications.md)
- [Edge Workload Configuration pattern](../../patterns/edge-workload-configuration.md)
- [Build a private 5G network](build-private-5g-network.md)
