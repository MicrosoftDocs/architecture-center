## Deploy private 5G networks on Azure

The fourth industrial revolution, often referred to as *Industry 4.0*, is upon us. This revolution brings with it a wave of modern industrial applications that will transform the way businesses operate. Driven by improved processing power and connectivity, these applications collect and process data from across an organization to help businesses run more strategically and more efficiently. As enterprises scale, they need solutions that can handle these mission-critical workloads. 

To meet these demands, modern enterprises need both private 5G networks and multi-access edge computing (MEC) solutions. Private LTE/5G networks give businesses the speed, security, mobility, and quality of service they need to process data efficiently. Edge compute supports latency-sensitive industrial applications and data localization and enables time sensitive data to be processed quickly at the edge. 

To realize the benefits of private LTE/5G networks, many key challenges need to be addressed. These include reducing operational and engineering complexity, ensuring end-to-end visibility for multi-site enterprises, providing access security, and improving the delivery of automated, software-based solutions. 

To address these challenges, Microsoft has introduced an innovative approach that combines Azure managed services, including a platform and networking services combined with a radio and application ISV ecosystem. This solution is a fully integrated private 5G network service that's created for enterprises. A growing list of global mobile operators and managed service providers deliver and manage these services. The solution combines Azure, Azure Network Function Manager, Azure Arc, Azure Stack Edge, Azure Stack HCI, Azure Kubernetes Service, and Azure Private 5G Core. These services are all managed and orchestrated from the global Azure cloud. 

This approach directly addresses the complexity and cost challenges that are faced by system integrators and enterprises. It enables enterprises to deploy high-performance, enhanced-security private 5G networks that can drive the adoption of modern industrial applications.

This series of three articles explains how system integrators and operators can build private networks for enterprises by using Azure services. These networks take advantage of the benefits of a hyperscale cloud and integrated MEC architecture to lower CapEx and OpEx, accelerate innovation, and open new revenue opportunities.

## Private networks enhanced by 5G 

Private networks accelerated and enhanced by 5G are transforming telecommunications services. Key radio and core features in 5G enable the dense scale and delivery of enhanced mobile broadband (eMBB), ultra-reliable low-latency communications (URLLC), and massive machine-type communications (mMTC). This allows operators to offer new services that are oriented to developers of high-performance industrial applications and enable the introduction of new, disruptive commercial models.  

Consumer-based offerings like voice, text, data, and video will remain an integral part of the telco operator service portfolio. However, new enterprise-based offerings like LTE/5G private networks for robotics, video AI, massive-scale IoT for digital twin applications, and augmented reality experiences with devices like Hololens will drive unprecedented revenue opportunities for operators. To deliver these services, telco operators need to look beyond the traditional telco network architecture to more directly use hyperscale cloud and MEC.  

Several factors are driving the implementation of private enterprise mobile networks: 

- The scale and reach limitations of current in-building wireless systems
- The rising amount of generated data and video
- The increased need for higher levels of mobility and security and the demand for real-time data processing  

The convergence of 5G, MEC, and the cloud makes it possible to create private wireless networks that are ultra-fast, highly secure, and scalable, and can take advantage of powerful applications for analytics running at the far edge, in the cloud, or across hybrid locations.

Here are some of the industry use cases that are powered by private 5G networks:  

:::image type="content" source="media/industry-use-cases.png" alt-text="Diagram showing industry use cases that are powered by private 5G networks." lightbox="media/industry-use-cases.png":::

We believe that Private 5G Networks represent a strong use case for 5G enterprise services, as these capabilities will underpin the more sophisticated services, such as smart spaces and Industry 4.0 applications. Yet, for all the advantages of a 5G private network, challenges remain for operators and enterprises. First and foremost is the complexity of deploying and managing a 5G network within the enterprise environment. 5G networks have many considerations that lie outside the traditional enterprise skill set, from RF design to 5G mobile core architectures. Simultaneously, telco operators may lack the technology portfolio or minimal footprint needed to deploy 5G networks and cloud managed edge computing cost effectively within the enterprise environment.

Microsoft proposes a simplified MEC-as-a-service (aaS) approach that combines a global hyperscale cloud platform, networking components including a cloud-native, 5G Standalone (SA) core powering a rich ecosystem of cloud applications. Our approach enables the enterprise to collect data from across their network, process delay sensitive data efficiently at the edge, while still leveraging the ability to process large amounts of data in Azure’s robust suite of IoT, analytics, AI, and machine-learning tools - delivering a balance or services with greater value.

### Benefits of Private 5G Networks 

The arrival of 4G and access to shared spectrum like CBRS (in limited geographic regions) changed Private 5G Network economics by allowing enterprises to deploy and experiment using dedicated private cellular networks using small cell technology and virtualized network functions. With 5G RAN and core optimizations comes a richer set of capabilities including faster speeds, ultra low latency, security methods, and improved cost efficiencies. These 5G characteristics are critical to industries such as manufacturing and transportation, where geographic coverage challenges and expanding IoT applications require the enhanced network characteristics that 5G provides.  

At Microsoft, we see the demand for 5G private networks across multiple vertical industries as benefitting from these same universal benefits: low latency, deterministic access support, higher throughput, greater coverage, data localization and privacy, operational simplicity, edge processing in order to offset backhaul savings and improve regulatory compliance by providing a higher level of data sovereignty.

#### Reliable coverage 

Many industrial and enterprise applications demand connectivity that exceeds the coverage limitations of wired and Wi-Fi technology that are prevalent across Operational Technology (OT) environments.   4G and 5G radios use of dedicated spectrum to limit dynamic interference, higher transmit power, and inherent mobility capabilities deliver high-performance, high capacity and cost-effective wireless connectivity over large sites, including airports, seaports, open-cast mines, distribution centers, campuses, and construction sites. The flexibility to use different spectrum options to optimize coverage and data rates for both indoor industrial and outdoor use cases.  

#### Higher throughput 

While 4G technology can deliver the throughput demanded by many private network applications, 5G can deliver 10-20x the throughput of 4G, expanding the range of applications that can be supported wirelessly.   Upcoming spectrum options such as millimeter wave can be deployed for indoor use to optimize for greater density of devices even when distributed within noisy RF environments, resulting in a scalable network. 

#### Low latency
 
5G networks offer latency that is an order of magnitude less than 4G networks. This is important for time-sensitive applications such as robotic control systems, which typically have round-trip latency budgets of 10ms or less. 5G networks with applications deployed in local edge compute facilities can comfortably support such latency requirements. 

#### Deterministic access support

5G radio, by design, supports deterministic access. This places a guaranteed upper limit on latency and jitter, which is important for many kinds of applications. In this dimension, 5G is far closer to the performance of wired Ethernet. Applications that would have required wired connections in the past can now be untethered, thanks to 5G.   

#### Data localization/Privacy 

Using traditional corporate networks, enterprises can effectively limit the exposure of data to specific geo-fenced regions. With the widespread adoption of wireless technologies, however, the ability to limit data exposure came at the price of restricting access. Private 5G Networks, combined with edge computing, can provide better visibility and control over where data is accessed and processed – giving the enterprise a much higher level of data sovereignty. They enable highly sensitive information to be kept securely locally and not exposed even to the operator over external network connections. 

#### Operational simplicity

Today, operators are faced with implementing multiple versions of network technology, along with access control and other security functions based on the need for wired, Wi-Fi, and, increasingly, mobile broadband access to corporate resources. Private wireless networks will offer corporate IT the opportunity to build a simplified access architecture that will work for employees in the office and on the go. 

#### Backhaul savings 

Some types of industrial and enterprise applications—such as high-resolution video cameras for surveillance or inspection—generate vast volumes of data. These applications usually involve some mix of storage and analysis. While they are typically not highly latency-sensitive, it makes sense to deploy such applications in local compute facilities to avoid the high cost of backhauling very large volumes of data to a centralized cloud. Private 5G Networks make this possible. Connectivity to centralized cloud facilities then only has to handle summarized data, for example, information about actionable events detected by local analysis.  

#### Legal and regulatory compliance improvements 

Private 5G mobile networks not only allow data to be kept local, but they also help enterprises protect themselves from constantly evolving threats to their information and communications security. 5G has built-in security mechanisms than any earlier generation of cellular technology and includes protection from sophisticated attacks, such as IMSI-catcher or Stingray. Utilizing multiple layers of embedded Azure security and tools like Defender for Cloud allows the operator to deploy, monitor, and securely operate critical workloads and applications even when running at the customer edge.   

### Private 5G Network: Manufacturing case study

Smart devices, automation, the cloud, and mobile broadband technology are driving the Industry 4.0 revolution. This, in turn, is fueling demand for Private 5G Networks in the manufacturing industry, as the leading consumer of Private 5G Networks. As manufacturers look to connect smart devices and leverage telemetry data to support real-time decisions and improve operational efficiencies, Private 5G Networks can provide the foundation to achieve these goals. 

#### Maintenance prediction

- Monitoring and tracking quality
- Potential damage, breakdowns, and bottlenecks
- Dramatically improve operating efficiencies

#### Smart factories

- Connected factory applications
- Staff safety applications and air quality management
- Access control (security) and smart analytics

#### Manufacturing operations

- Includes asset management and intelligent manufacturing and inventory 
- Performance optimization and monitoring
- Enables end-to-end operational visibility

The ability to process efficiently network data in the cloud helps manufacturers in a variety of ways:

- Proactively monitor and prevent production issues such as bottlenecks, breakdowns, machine wear, and process inefficiencies.
- Create “smart factories” by connecting business applications, safety and production data from sensors, and analytics in a real-time, secure environment. 
- Improve manufacturing operations through end-to-end visibility, performance monitoring and optimization, and secure asset management. 

Microsoft’s approach to Private 5G Network is ideally suited to IoT and Industry 4.0 applications. The ability to process data in a single, on-premises platform and intelligently backhaul selective data for processing in the Azure cloud allows for real-time decisions and automation with exceptionally low latencies. A reduction in backhauled traffic also reduces costs, both for the enterprise and the operator. 

Azure’s Zero Trust model ensures that manufacturing data remains secure as it moves between the mobile network functions, the enterprise, and the cloud. This built-in security also frees operators from the arduous task of securing customer data in transit or in storage. 

### Telco path to private 5G networks 

Private 5G networks exist at the intersection of the traditional enterprise LAN space, specialized industrial networks, and the public mobile network. They offer operators a chance to expand the scope of the 5G services into a market arena in which they have never previously competed. 

In considering how to deploy private 5G networks, many enterprises will look favorably on mobile network operators as potential suppliers of the solution. Operators are viewed by enterprises as trusted partners in communications, and commercial relationships between them are already well-established. Operators have a great deal of expertise in successfully deploying and operating secure and reliable mobile networks and depending on the local situation with regard to spectrum licensing, there may be a regulatory requirement or spectrum condition for an enterprise to partner with a mobile operator in order to deploy private 5G. 

Some network operators may view private 5G networks as a natural extension of their public mobile networks, leverage their existing network assets and use network slicing to securely partition enterprise mobile traffic from public networks like network slicing.  However, enterprises desire a dedicated network with localized connectivity and more control than is possible with this approach. Furthermore, public networks have been built out primarily to serve the mobile broadband market, and they are highly optimized for this purpose. Enterprise applications will place all sorts of new and different demands on the network, which simply won’t offer the flexibility needed to meet these demands.  The industry is adopting an edge based private wireless network while also allowing deep integration with the operator network, enterprises should leverage the flexibility attributes of 5G.

image 

Telcos deliver Azure managed edge networks and applications to global enterprises

What does an effective Private 5G Network solution—one that operators and enterprises alike can feel confident in deploying—look like? The answer can be summarized in three key solution attributes:

1. Managed connectivity. While many enterprises have experience with managing their Wi-Fi network and mobile access points, few have experience with 4G/5G radio network design, SIM activation and end to end solution deployment. This presents an opportunity for the operator to bring a managed radio and spectrum solution to meet the enterprise’s needs.

2. Managed services. A Private 5G Network partner that can provide deployment and management of the end-to-end networks, develop and deliver applications adds significant value to the enterprise customer. Moving the total solution management into a centralized, cloud-based environment allows operators and managed service providers (MSPs) to deliver end-to-end managed services from a single pane of glass. Leveraging deep levels of automation, security and scale found in cloud based architectures is essential to providing a compelling service experience and creating a clear ROI model for enterprises to adopt Private 5G Networks and secure and optimize edge deployments. 

3. Managed applications. Use cases for Private 5G Networks are as unique as the businesses they serve. For example, a remote oil-drilling platform will have very different mobile network considerations than an automotive manufacturer. To address these varied use cases, there must be flexibility and simplicity in how edge platforms and networks are configured, deployed, and managed. 
 
To achieve broad adoption, the installation and management of private wireless networks with the desired MEC applications is simplified for both the operator and the enterprise. 
