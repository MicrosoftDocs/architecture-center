This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

<Todo: insert blurb>

> [!IMPORTANT]
>
> The guidance in this article builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). That architecture based on a hub and spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintainence. The spoke virtual network contains the AKS cluster that provides the card holder environment (CDE) and hosts the PCI DSS workload. 
>
> ![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates a regulated environment. The implementation illustrates the set up malware scanning tools. Every node in the cluster (in-scope and out-of-scope) has placeholder `DaemonSet` deployments for antivirus, FIM, Kubernetes-aware security agent (Falco), and reboot agent (kured). Place your choice of software in this deployment.

## Maintain an Information Security Policy 

**Requirement 12**&mdash;Maintain a policy that addresses information security for all personnel
***

## Next


> [!div class="nextstepaction"]
> [Maintain an Information Security Policy](aks-pci-summary.yml)