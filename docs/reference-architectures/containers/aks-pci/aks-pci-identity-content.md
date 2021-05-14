This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

<Todo: insert blurb>

> [!IMPORTANT]
>
> The guidance in this article builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). That architecture based on a hub and spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintainence. The spoke virtual network contains the AKS cluster that provides the card holder environment (CDE) and hosts the PCI DSS workload. 
>
> ![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates a regulated environment. The implementation illustrates the set up malware scanning tools. Every node in the cluster (in-scope and out-of-scope) has placeholder `DaemonSet` deployments for antivirus, FIM, Kubernetes-aware security agent (Falco), and reboot agent (kured). Place your choice of software in this deployment.

## Implement Strong Access Control Measures

**Requirement 7**&mdash;Restrict access to cardholder data by business need to know

|Requirement|Responsibility|
|---|---|
|[Requirement 7.1](#requirement-71)|Limit access to system components and cardholder data to only those individuals whose job requires such access.|
|[Requirement 7.2](#requirement-72)|Establish an access control system for systems components that restricts access based on a user’s need to know, and is set to “deny all” unless specifically allowed.
This access control system must include the following:|
|[Requirement 7.3](#requirement-73)|Ensure that security policies and operational procedures for restricting access to cardholder data are documented, in use, and known to all affected parties.|


**Requirement 8**&mdash;Identify and authenticate access to system components

**Requirement 9**&mdash;Restrict physical access to cardholder data
***

## Next
Track and monitor all access to network resources and cardholder data. Regularly test security systems and processes.

> [!div class="nextstepaction"]
> [Regularly Monitor and Test Networks](aks-pci-monitor.yml)