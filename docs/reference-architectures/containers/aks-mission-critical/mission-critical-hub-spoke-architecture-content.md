
This reference architecture provides guidance for a mission critical workload that uses a hub-spoke network topology. The workload resources are deployed in a spoke virtual network. The hub network has resources that provide connectivity to the workload.

Organizations often centralize the hub network. It's pre-provisioned as part of a _landing zone_ or the foundational platform. A key benefit of this approach is that the platform provides the most of the infrastructure needed to run the workload. The infrastructure includes the network, identity access management, policies, and monitoring capabilities that the workload doesn't have to manage. It can rely on organizational resources, integrate with other workloads (if needed), and use shared services. For example, the workload assumes that the virtual private network or Azure Private DNS Zone already exists within the connectivity subscription provided by the landing zone. However, the workload must be designed to operate within the restrictions imposed by the organization. For example, <TBD> 

In this approach, **the landing zone itself needs to be highly reliable for a mission critical workload to operate as expected.** The reliability tier of the platform and the workload must be aligned. The workload team must have a trusted relationship with the platform team so that unavailability issues in the foundational services, which  affect the workload, are mitigated at the platform level. 

An alternate approach is for the workload team to deploy the hub resources. However, expect added complexity and  management overhead.

This architecture builds on the [**mission-critical baseline architecture with network controls**](./mission-critical-network-architecture.yml), which is designed to restrict both ingress and egress traffic flows from the same virtual network. This architecture provides egress restrictions through the hub network. Like other mission-critical architecture designs, cloud-native capabilities are used to maximize reliability and operational effectiveness of the workload.

It's recommended that you become familiar with the **baseline architecture** before proceeding with this article.

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) which showcases mission critical application development on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Architecture

![Architecture diagram of a mission-critical workload in a hub-spoke topology.](./images/mission-critical-architecture-hub-spoke.svg)

