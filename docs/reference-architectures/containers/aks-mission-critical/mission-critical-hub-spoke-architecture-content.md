
This reference architecture provides guidance for a mission critical workload that uses a hub-spoke network topology. The workload resources are deployed in the spoke virtual network. The hub network has resources that provide connectivity to the workload.

Organizations often centralize the hub network, which is preprovised as part of _landing zone_ or the foundational platform. A key benefit of this approach is that the platform provides all the infrastructre needed to run the workload.This includes the network, identity access management, policies, and monitoring capabilities that the workload doesn't have to manage. It can rely on organizational resources, integrate with other workloads (if needed), and use shared services. For example, the workload assumes that the virtual private network or Azure Private DNS Zone already exists within the connectivity subscription provided by the landing zone. However, the workload must be designed to operate within the restrictions imposed by the organization. For example, <TBD> 

For a mission-critical workload, the landing zone itself needs to be highly reliable. The workload in this architecture represents the workload that is plugs into the landing zone infrastructure. Like the other mission-critical architecture designs, cloud-native capabilities are used to maximize reliability and operational effectiveness of the workload.

TBD - Include independent hub-spoke blurb

This architecture builds on the [mission-critical baseline architecture with network controls](./mission-critical-network-architecture.yml), which is designed to restrict both ingress and egress traffic flows from the same virtual network. This architecture provides egress restrictions through the hub network. 

It's recommended that you become familiar with the baseline before proceeding with this article.

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by a production-grade [example implementation](https://github.com/Azure/Mission-Critical-Connected) which showcases mission critical application development on Azure. This implementation can be used as a basis for further solution development in your first step towards production.

## Architecture

![Architecture diagram of a mission-critical workload in a hub-spoke topology.](./images/mission-critical-architecture-hub-spoke.svg)

