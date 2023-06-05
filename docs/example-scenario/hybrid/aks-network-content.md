This scenario illustrates how to design and implement network concepts for deploying Azure Kubernetes Service (AKS) nodes on AKS hybrid clusters.

This article includes recommendations for networking design for Kubernetes nodes and Kubernetes containers. It's part of an architectural baseline guidance set of two articles. See the [baseline architecture recommendations here](aks-baseline.yml).

## Architecture

The following image shows the network architecture for Azure Kubernetes Service on Azure Stack HCI or Windows Server 2019/2022 datacenter clusters:

:::image type="content" source="media/aks-network.svg" alt-text="Conceptual graphic showing network baseline architecture." lightbox="media/aks-network.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/aks-azurestackhci-arch2-networking-v5.vsdx) of this architecture.*

The scenario consists of the following components and capabilities:

- [Azure Stack HCI (20H2)][] is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. Azure Stack HCI cluster is implemented as a 2-4 node cluster.
- Windows Server 2019/2022 datacenter failover cluster is a group of independent computers that work together to increase the availability and scalability of clustered roles.
- [Azure Kubernetes Service on Azure Stack HCI (AKS hybrid)][] is an on-premises implementation of Azure Kubernetes Service (AKS), which automates running containerized applications at scale.
- [Active Directory Domain Services][] is a hierarchical structure that stores information about objects on the network. It provides identity and access solution for identities associated with users, computers, applications, or other resources that are included in a security boundary.
- [Management cluster][] also known as AKS host is responsible for deploying and managing multiple workload clusters. The management cluster consumes 1 IP address from the node pool, but you should reserve another 2 IPs for update operations. The management cluster also consumes one IP from the VIP pool.
- [Workload Cluster][] is a highly available deployment of Kubernetes using Linux VMs for running Kubernetes control plane components and Linux and/or Windows worker nodes.
  - **Control plane.** Runs on a Linux distribution and contains API server components for interaction with Kubernetes API and a distributed key-value store, etcd, for storing all the configuration and data of the cluster. It consumes one IP from the node pool and one IP from the VIP pool.
  - **Load balancer.** Runs on a Linux VM and provides load-balanced services for the workload cluster. It consumes one IP from the node pool and one IP from the VIP pool.
  - **Worker nodes.** Run on a Windows or Linux operating system that hosts containerized applications. It consumes IP addresses from the Node pool, but you should plan at least 3 more IP addresses for update operations.
  - **Kubernetes resources.** Pods represent a single instance of your application, that usually have a 1:1 mapping with a container, but certain pods can contain multiple containers. Deployments represent one or more identical pods. Pods and deployments are logically grouped into a namespace that controls access to management of the resources. They consume 1 IP per pod from the VIP pool.
- [Azure Arc][] is a cloud-based service that extends the Azure Resource Manager-based management model to non-Azure resources including virtual machines (VMs), Kubernetes clusters, and containerized databases.
- [Azure Policy][] is a cloud-based service that evaluates Azure and on-premises resources through integration with Azure Arc by comparing properties to customizable business rules.
- [Azure Monitor][] is a cloud-based service that maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments.
- [Microsoft Defender for Cloud][] is a unified infrastructure security management system that strengthens the security posture of your data centers and provides advanced threat protection across your hybrid workloads in the cloud and on-premises.

## Components

- [Azure Stack HCI (20H2)][1]
- [Windows Server 2019/2022 datacenter failover cluster][]
- [Azure Kubernetes Service (AKS)][]
- [Windows Admin Center][]
- [An Azure subscription][]
- [Azure Arc][2]
- [Azure role-based access control (RBAC)][]
- [Azure Monitor][3]
- [Microsoft Defender for Cloud][4]

## Scenario details

The use cases for this scenario are described in the first article of the series, [Baseline architecture](aks-baseline.yml).

### Kubernetes node networking

The major consideration in the networking design for the AKS on Azure Stack HCI is selecting the network model that provides enough IP addresses. AKS on Azure Stack HCI uses virtual networking to allocate IP addresses to the Kubernetes node resources. You can use two IP address assignment models:

- Static IP networking is more predictable but adds extra effort for the initial configuration.
- Dynamic Host Configuration Protocol (DHCP) networking uses dynamic allocation of IP addresses and less effort, but you need to be careful not to exhaust the available pool of IPs. You also need to manage reservations and exclusion ranges for virtual IP pools and certain cluster wide resources like the cloud agent service.

Both assignment models must plan IP addresses for:

- Virtual IP pool
- Kubernetes node VM IP pool

### Virtual IP pool

A virtual IP pool is a set of IP addresses that are mandatory for any AKS on Azure Stack HCI deployment. Plan the number of IP addresses in the virtual IP pool based on the number of workload clusters and Kubernetes services. The virtual IP pool provides IP addresses for the following types of resources:

- Cloud agent requires a floating IP address from the virtual IP pool.
- The API server component that runs inside the Kubernetes Virtual Appliance (KVA) virtual machine (management cluster) uses an IP address from the virtual IP pool. The API server is a component of the Kubernetes control plane that exposes the Kubernetes API. The API server is the front end for the Kubernetes control plane. The KVA is a virtual machine running Mariner Linux and hosts a Kubernetes cluster. The IP address is floating and is also used for any other KVA VM that you deploy in AKS on Azure Stack HCI. The KVA virtual machine also hosts a Kubernetes virtual IP load-balancer service.

- Plan IP addressing for the number of control plane VMs that are deployed on the target servers, as they also consume more IP addresses from the virtual IP pool. Considerations are described in the next section.
- The target cluster contains a load balancer VM, which is HAProxy and owns the virtual IP Pool for the target cluster. This VM exposes all Kubernetes services through the virtual IP Pool.
- Applications that run in Kubernetes pods use IP addresses from the virtual IP pool.
- HAProxy load balancer is deployed as a specialized virtual machine and can be used to load balance incoming requests across multiple endpoints. They consume IP addresses from the virtual IP pool, and you need to plan IP addressing for every workload cluster.

### Kubernetes node VM IP pool

Kubernetes nodes are deployed as virtual machines in an AKS on Azure Stack HCI deployment. Ensure that you plan the number of IP addresses according to the total number of Kubernetes nodes and include at least three more IP addresses that are used during the upgrade process. For static IP address configuration, you need to specify the Kubernetes node VM IP pool range, this isn't necessary for DHCP allocation. Plan additional IP addresses for:

- The KVA VM also uses more IP address for Kubernetes from the Kubernetes node VM IP pool. Plan to add IP addresses during the update process, because the KVA VM uses the same virtual IP for the API service but requires a separate IP from the Kubernetes node VM IP pool.
- Control Plane VMs consume one IP from the Kubernetes node VM IP pool for the API server service. These virtual machines also host the Azure ARC agent that's connecting to the Azure portal for management purposes.
- Nodes in a Node pool (Linux or Windows) will consume IP addresses from the IP pool allocated for the Kubernetes node VM.

### Microsoft on-premises cloud service

Plan IP address range for Microsoft on-premises cloud (MOC), that enables management stack so the VMs on Azure Stack HCI are managed in the cloud. The IP address allocation for the MOC service is on the underlying physical network, and the IP addresses configured for the Azure Stack HCI cluster nodes are in your data center. You can configure IP addresses for the physical nodes of your Azure Stack HCI in one of the following:

- Azure Stack HCI cluster nodes with a DHCP-based IP address allocation mode. MOC service gets an IP address from the DHCP service presented on the physical network.
- Azure Stack HCI cluster nodes with a static IP allocation model. The IP address for the MOC cloud service must be explicitly specified as an IP range in Classless Inter-Domain Routing (CIDR) format and it must be in the same subnet as the IP addresses of Azure Stack HCI cluster nodes.

### Load balancer in AKS on Azure Stack HCI

For a small deployment, you can use the built-in load balancer, deployed as a Linux VM that uses HAProxy + KeepAlive to send traffic to application services that are deployed as a part of the AKS cluster. HAProxy load balancer configures pods as endpoints in the load balancer. It loads balance requests to the Kubernetes API server and manages traffic to application services.

You can also use a custom load balancer for managing traffic to your services. The custom load balancer provides added flexibility to the deployment and ensures that AKS on Azure Stack HCI works alongside existing deployments such as Software Defined Network (SDN) deployments that use load balancers. For custom load balancers, kube-virtual IP provides Kubernetes clusters with a virtual IP and load balancer for both the control plane and Kubernetes Services of type *LoadBalancer*. The kube-virtual IP service is automatically deployed on every worker node.

AKS on Azure Stack HCI also supports the use of MetalLB or other OSS Kubernetes based load balancers to balance traffic destined for services in a workload cluster. MetalLB is a load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols, such as Border Gateway protocol BGP. It can work with both network add-ons, Calico and Flannel, but you need to ensure that the virtual IP address range provided during the installation of AKS on Azure Stack HCI isn't overlapping with the IP address range planned for the custom load balancer.

## Deploy this scenario

### Deploy an ingress controller

Consider implementing an [ingress controller][] for TLS termination, reversible proxy or configurable traffic routing. Ingress controllers work at Layer 7 and can use intelligent rules to distribute application traffic. Kubernetes ingress resources are used to configure the ingress rules and routes for individual Kubernetes services. When you define an ingress controller, you consolidate the traffic-routing rules into a single resource that runs as part of your cluster.

Use an ingress controller to expose services through externally reachable URLs. Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the ingress resource. The ingress HTTP rules contain the following information:

- An optional host. If you don't provide host information, the rule is applied to all inbound HTTP traffic.
- A list of paths that has an associated backend defined with a ***service.name*** and a ***service.port.name*** or ***service.port.number***.
- A backend that provides a combination of service and port names.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-world
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: test.example.com
     http:
       paths:
       - path: /hello-world
          pathType: Prefix
          backend:
            service:
              name: hello-world
              port:
                 number: 8080
```

Use an ingress controller to balance the traffic between different backends of the application. The traffic is split and sent to different service endpoints and deployments, based on the path information.

To route HTTP traffic to multiple host names on the same IP address, you can use a different ingress resource for each host. The traffic that comes through the load balancer IP address is routed based on the host name and the path provided in the ingress rule.

### Container networking concepts in Azure Kubernetes Service (AKS) on Azure Stack HCI

Kubernetes provides an abstraction layer to a virtual network, so the container-based applications can communicate internally or externally.
The *kube-proxy* component runs on each node and can either provide direct access to the service, distribute traffic using load balances, or
use ingress controllers for more complex application routing. Kubernetes use services to logically group together a set of pods and provide
network connectivity. The following Kubernetes services are available:

- **Cluster IP**: This service creates an internal IP address for internal-only applications.
- **NodePort**: This service creates port mapping on the underlying node, which makes the application directly accessible with the node IP address and port.
- **LoadBalance**r: You can expose Kubernetes services externally using load-balancer rules or an ingress controller.
- **ExternalName**:. This service uses a specific DNS entry for the Kubernetes application.

### Kubernetes networks

In AKS on Azure Stack HCI, the cluster can be deployed using one of the following network models:

- [Project Calico networking][]. This is a default networking model for AKS on Azure Stack HCI and is based on an open-source networking that provides network security for containers, virtual machines, and native host-based workloads. Calico network policy can be applied on any kind of endpoint such as pods, containers, VMs, or host interfaces. Each policy consists of rules that control ingress and egress traffic by using actions that can, either allow, deny, log, or pass the traffic between source and destination endpoints. Calico can use either Linux extended Berkeley Packet Filter (eBPF) or Linux kernel networking pipeline for traffic delivery. Calico is also supported on Windows using Host Networking Service (HNS) for creating network namespaces per container endpoint. In the Kubernetes network model, every pod gets its own IP address that's shared between containers within that pod. Pods communicate on the network using pod IP addresses and the isolation is defined using network policies. Calico is using CNI (Container Network Interface) plugins for adding or deleting pods to and from the Kubernetes pod network and CNI IPAM (IP Address Management) plugins for allocating and releasing IP addresses.
- [Flannel overlay networking.][] Flannel creates a virtual network layer that overlays the host network. Overlay networking uses encapsulation of the network packets over the existing physical network. Flannel simplifies IP Address Management (IPAM), supports IP re-use between different applications and namespaces, and provides logical separation of container networks from the underlay network used by the Kubernetes nodes. Network isolation is achieved using Virtual eXtensible Local Area Network (VXLAN), an encapsulation protocol that provides data center connectivity using tunneling to stretch Layer 2 connections over an underlying Layer 3 network. Flannel is supported both by Linux containers using *DaemonSet* and Windows containers using Flannel CNI plugin.

### Azure Stack HCI networking design

The overall networking design includes planning activities for the Azure Stack HCI.

First, start by planning the hardware and installation of Azure Stack HCI. You can either purchase integrated systems from a Microsoft
hardware partner with the Azure Stack HCI operating system pre-installed, or you can buy validated nodes and install the operating
system yourself. Azure Stack HCI is intended as a virtualization host, so Kubernetes server roles must run inside VMs.

### Physical network requirements for Azure Stack HCI

Microsoft doesn't certify network switches, but it has certain requirements that the vendor of the equipment must satisfy:

- Standard: IEEE 802.1Q that defines a virtual local area network (VLAN).
- Standard: IEEE 802.1Qbb that defines Priority Flow Control (PFC).
- Standard: IEEE 802.1Qaz that defines Enhanced Transmission Selection (ETS).
- Standard: IEEE 802.1AB that defines Link Layer Topology Discovery (LLTD) protocol.

### Host network requirements for Azure Stack HCI

Consider using a network adapter that has achieved the Windows Server Software Defined Data Center (SDDC) certification with the Standard or
Premium Additional Qualification (AQ).

Ensure that the network adapter supports:

- [Dynamic Virtual Machine Multi-Queue][] (Dynamic VMMQ or d.VMMQ) is an intelligent, receive-side technology for automatic tuning of network traffic processing to CPU cores.
- Remote Direct Memory Access (RDMA) is a network stack offload to the network adapter. It allows SMB storage traffic to bypass the    operating system for processing.
- Guest RDMA enables SMB workloads for VMs to gain the same benefits of using RDMA on hosts.
- Switch Embedded Teaming (SET) is a software-based teaming technology.

Consider using [Network ATC][], which provides intent-based control to simplify host networking configuration.

AKS on an Azure Stack HCI requires a reliable high-bandwidth, low-latency network connection between each server node. Ensure that at
least one network adapter is available and dedicated for cluster management. Also verify that physical switches in your network are
configured to allow traffic on any VLANs you'll use.

### Virtual switch

Azure Stack HCI simplifies the networking design by configuring a virtual switch that can be used for network classification. The virtual
network interface card (vNIC) can be placed in different VLANs for the hosts to provide different traffic flow for the following networks:

- Management network. The management network is part of the north-south network and is used for host communication.
- Compute network. The compute network is part of the north-south network and is used for virtual machine traffic. Use Quality of Service (QOS), single-root I/O virtualization (SR-IOV), and virtual Remote Direct Memory Access (vRDMA) to tune the network performance based on demand.
- Storage network. The storage network is part of the east-west network and requires RDMA with recommended throughput 10GB+. It's used for live migration of the VMs.
- VM guest network.

### East-West traffic benefit of RDMA traffic

East-West network traffic represents communication between the hosts, and it doesn't expose any external access. Traffic remains within the
Top of Rack (ToR) switch and Layer-2 boundary. It includes the following types of traffic:

- Cluster heartbeats and inter-node communication
- \[SMB\] Storage Bus Layer
- \[SMB\] Cluster Shared Volume
- \[SMB\] Storage Rebuild

### North-South traffic

North-South traffic is the external traffic that reaches the AKS on Azure Stack HCI cluster. You can plan the traffic for the range of Azure
services that enable monitoring, billing, and security management through the integration of Azure ARC. North-south traffic has the
following characteristics:

- Traffic flows out of a ToR switch to the spine or in from the spine to a ToR switch.
- Traffic leaves the physical rack or crosses a Layer-3 boundary (IP).
- Traffic includes management (PowerShell, Windows Admin Center), compute (VM), and inter-site stretched cluster traffic.
- Uses an Ethernet switch for connectivity to the physical network.

AKS on Azure Stack HCI can use several cluster network deployment options:

- Converged Network Combining Multiple Network Intents (MGMT, Compute, Storage). This is the recommended deployment for more than three physical nodes and requires that all physical network adapters are connected to the same ToR switches. ROCEv2 is highly recommended.
- Switchless deployment uses North-South communication as a network team by combining compute and management networks.
- Hybrid deployment as a combination of both deployments.

## Recommendations

The following recommendations apply for most scenarios. Follow the recommendations unless you have a specific requirement that overrides it.

### Network recommendations

The major concern in the networking design for the AKS on Azure Stack HCI is selecting a network model that provides enough IP addresses for
your Kubernetes cluster, and its services and applications.

- Consider implementing static IP addresses to allow AKS on Azure Stack HCI to control the IP address assignment.
- Dimension properly the IP address ranges so you have enough free IP addresses for a Kubernetes node pool and for a virtual IP pool. Ensure that your virtual IP pool is large enough so that whenever you're upgrading you can use rolling upgrades, which require more IP addresses. You can plan the following:
  - Addressing/hostnames for Proxy settings
  - IP addresses for the target cluster control plane
  - IP addresses for the Azure ARC
  - IP addresses for horizontal scaling of worker and control plane nodes in target clusters
- Your virtual IP pool should be large enough to support the deployment of the application services that require connectivity to the external router.
- Implement Calico CNI to provide enhanced network policy for controlling the pod and application communication.
- Ensure that the physical cluster nodes (HCI or Windows Server) are located in the same rack and connected to the same ToR switches.
- Disable IPv6 on all network adapters.
- Ensure that the existing virtual switch and its name are the same across all cluster nodes.
- Verify that all subnets you define for your cluster are routable among each other and to the Internet.
- Make sure there is network connectivity between Azure Stack HCI hosts and the tenant VMs.
- Enable dynamic DNS updates in your DNS environment to allow AKS on Azure Stack HCI to register the cloud agent generic cluster name in the DNS system for discovery.

- Consider implementing classification of the network traffic by its direction:
  - North-South traffic is the traffic from Azure Stack HCI and rest of the network,
    - Management
    - Compute
    - Inter-site stretched cluster traffic
  - East-West traffic within Azure Stack HCI:
    - Storage traffic including live migration between nodes in the same cluster.
    - Ethernet switch or direct connection.

### Storage traffic models

- Use multiple subnets and VLANs to separate storage traffic in Azure Stack HCI.
- Consider implementing traffic bandwidth allocation of various traffic types.

## Considerations

The [Microsoft Azure Well-Architected Framework][] is a set of guiding tenets that are followed in this scenario. The following
considerations are framed in the context of these tenets.

### Reliability

- Built-in resiliency, inherent to Microsoft software-defined compute (failover cluster of Hyper-V nodes), storage (Storage Spaces Direct nested resiliency), and networking (Software Defined Networking).
- Consider selecting the network switch that supports industry standards and ensures reliable communications between nodes. The following standards include:
  - Standard: IEEE 802.1Q
  - Standard IEEE 802.1Qbb
  - Standard IEEE 802.1 Qas
  - Standard IEEE 802.1 AB
- Consider implementing multiple hosts in the management cluster and in the Kubernetes cluster to meet the minimum level of availability for workloads.
- AKS on Azure Stack HCI uses failover clustering and live migration for high availability and fault tolerance. Live migration is a Hyper-V feature that allows you to transparently move running virtual machines from one Hyper-V host to another without perceived downtime.
- You should ensure that services referenced in the [Architecture](#architecture) section are supported in the region to which Azure Arc is deployed.

### Security

- Secure traffic between pods using network policies in AKS on Azure Stack HCI.
- The API server in AKS on Azure Stack HCI contains the Certificate Authority which signs certificates for communication from the Kubernetes API server to *kubelet*.
- Use Azure Active Directory (Azure AD) single sign-on (SSO) to create a secure connection to Kubernetes API server.
- You can use Azure RBAC to manage access to Azure Arc–enabled Kubernetes across Azure and on-premises environments using Azure AD identities. For more information, see [Use Azure RBAC for Kubernetes Authorization][].

### Cost optimization

- Use the [Azure pricing calculator][] to estimate costs for the services used in the architecture. Other best practices are described in the [cost optimization][] section in [Microsoft Azure Well-Architected Framework.][]
- Consider implementing hyper-threading on your physical computer, to optimize the cost, because the AKS on Azure Stack HCI billing unit is a virtual core.
- Azure Arc control plane functionality is provided at no extra cost. This includes support for resource organization through Azure management groups and tags, and access control through Azure RBAC. Azure services used in conjunction to Azure Arc–enabled servers incur costs according to their usage.
- For cost-effectiveness, you can use as few as two cluster nodes with only four disks and 64 gigabytes (GB) of memory per node. To further minimize costs, you can use switchless interconnects between nodes, thereby eliminating the need for redundant switch devices.

### Operational excellence

- Simplified management using Windows Admin Center. Windows Admin Center is the user interface for creating and managing AKS on Azure Stack HCI. It can be installed on Windows 10/11 or Windows Server VM that need to be registered in Azure and are in the same domain as the Azure Stack HCI or Windows Server Datacenter cluster.
- Integration with Azure Arc or a range of Azure services that provide more management, maintenance, and resiliency capabilities (Azure Monitor, Azure Backup).
- If your Kubernetes cluster is [attached to Azure Arc][Azure Arc–enabled Kubernetes service], you can [manage your Kubernetes cluster using GitOps][]. To review best practices for connecting a hybrid Kubernetes cluster to Azure Arc, see the [Azure Arc hybrid management and deployment for Kubernetes clusters][] scenario.
- The Azure Stack HCI platform also helps to simplify virtual networking for AKS on Azure Stack HCI clusters by providing the "underlying" network in a highly available manner.

### Performance efficiency

- Use Azure Stack HCI certified hardware for improved application uptime and performance, simplified management and operations, and lower total cost of ownership.
- Storage: Storage Spaces Direct
  - Volume configuration (nested two-way mirror versus nested mirror-accelerated parity)
  - Disk configuration (caching, tiers)
- Ensure that the cluster nodes are physically located in the same rack and connected to the same ToR switches.
- Plan IP address reservations to configure AKS hosts, workload clusters, Cluster API servers, Kubernetes Services, and application services. Microsoft recommends reserving a minimum of 256 IP addresses for AKS deployment on Azure Stack HCI.
- Consider implementing an ingress controller that works at layer 7 and uses more intelligent rules to distribute application traffic.
- Use graphics processing unit (GPU) acceleration for extensive workloads.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal authors:**

- [Lisa DenBeste](https://www.linkedin.com/in/lisa-denbeste) | Project Management Program Manager
- [Kenny Harder](https://www.linkedin.com/in/kenny-harder-03b14a64) | Project Manager
- [Mike Kostersitz](https://www.linkedin.com/in/mikekostersitz) | Principal Program Manager Lead
- [Meg Olsen](https://www.linkedin.com/in/megolsenpm) | Principal
- [Nate Waters](https://www.linkedin.com/in/nate-waters) | Product Marketing Manager

**Other contributors:**

- [Walter Oliver](https://www.linkedin.com/in/walterov) | Senior Program Manager

## Next steps

- [AKS overview](/azure/aks/hybrid/aks-hybrid-options-overview)

  [Azure Stack HCI (20H2)]: /azure-stack/hci/overview
  [Azure Kubernetes Service on Azure Stack HCI (AKS hybrid)]: /azure/aks/hybrid/aks-hybrid-options-overview
  [Active Directory Domain Services]: /windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview
  [Management cluster]: /azure/aks/hybrid/kubernetes-concepts#the-management-cluster
  [Workload Cluster]: /azure/aks/hybrid/kubernetes-concepts#the-workload-cluster
  [Azure Arc]: /azure/azure-arc/overview
  [Azure Policy]: /azure/governance/policy/overview
  [Azure Monitor]: /azure/azure-monitor/overview
  [Microsoft Defender for Cloud]: /azure/defender-for-cloud/defender-for-cloud-introduction
  [1]: https://azure.microsoft.com/products/azure-stack/hci/
  [Windows Server 2019/2022 datacenter failover cluster]: /windows-server/failover-clustering/failover-clustering-overview
  [Azure Kubernetes Service (AKS)]: https://azure.microsoft.com/services/kubernetes-service/
  [Windows Admin Center]: /windows-server/manage/windows-admin-center/overview
  [An Azure subscription]: https://azure.microsoft.com
  [2]: https://azure.microsoft.com/services/azure-arc/
  [Azure role-based access control (RBAC)]: /azure/role-based-access-control/
  [3]: https://azure.microsoft.com/services/monitor/
  [4]: https://azure.microsoft.com/services/defender-for-cloud/
  [ingress controller]: /azure/aks/hybrid/create-ingress-controller
  [Project Calico networking]: https://projectcalico.docs.tigera.io/security/calico-network-policy
  [Flannel overlay networking.]: https://techcommunity.microsoft.com/t5/networking-blog/introducing-kubernetes-overlay-networking-for-windows/ba-p/363082
  [Dynamic Virtual Machine Multi-Queue]: https://techcommunity.microsoft.com/t5/networking-blog/synthetic-accelerations-in-a-nutshell-windows-server-2019/ba-p/653976
  [Network ATC]: /azure-stack/hci/concepts/network-atc-overview
  [Azure Arc–enabled Kubernetes service]: /azure/azure-arc/kubernetes/
  [Microsoft Azure Well-Architected Framework]: /azure/architecture/framework
  [Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
  [cost optimization]: /azure/architecture/framework/cost/overview
  [Microsoft Azure Well-Architected Framework.]: /azure/architecture/framework/
  [manage your Kubernetes cluster using GitOps]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
  [Azure Arc hybrid management and deployment for Kubernetes clusters]: /azure/architecture/hybrid/arc-hybrid-kubernetes
  [Use Azure RBAC for Kubernetes Authorization]: /azure/aks/manage-azure-rbac

## Related resources

- [Baseline architecture for AKS on Azure Stack HCI](aks-baseline.yml)
