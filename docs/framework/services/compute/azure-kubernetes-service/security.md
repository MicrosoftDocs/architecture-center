---
title: Azure Kubernetes Service (AKS) and security
description: Focuses on the Azure Kubernetes Service (AKS) used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to service security.
author: v-stacywray
ms.date: 11/11/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-kubernetes-service
categories:
  - compute
  - management-and-governance
---

# Azure Kubernetes Service (AKS) and security

[Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance.

To explore how AKS can bolster the security of your application workload, reference architecture guidance and best practices on the [AKS Solution architectures](/azure/architecture/reference-architectures/containers/aks-start-here) page.

The following sections include configuration checklists, recommended configuration options, and supporting source artifacts specific to AKS.

## Checklists

**Have you configured Azure Kubernetes Service (AKS) with security in mind?**
***

> [!div class="checklist"]
> - Define [Pod resource requests and limits](/azure/aks/developer-best-practices-resource-management#define-pod-resource-requests-and-limits) in application deployment manifests.
> - Use a central monitoring tool, such as [Azure Monitor and App Insights](/azure/azure-monitor/containers/container-insights-overview), to centrally collect metrics, logs, and diagnostics for troubleshooting purposes.
> - Enable and review [Kubernetes master node logs](/azure/azure-monitor/containers/container-insights-log-query#resource-logs).
> - Configure scraping of Prometheus metrics with Azure Monitor for containers.
> - Use [Azure Network Policies](/azure/aks/use-network-policies) or Calico to control traffic between pods. *Requires CNI Network Plug-in*.
> - Ensure proper selection of network plugin based on network requirements and cluster sizing.

### Security guidelines checklist

> [!div class="checklist"]
> - Use namespaces to logically group workloads within the cluster.
> - Use [Managed Identities](/azure/aks/use-managed-identity) to avoid managing and rotating service principles.
> - Use [AAD integration](/azure/aks/managed-aad) to take advantage of centralized account management, passwords, application access management, and identity protection.
> - Use Kubernetes RBAC with AAD for [least privilege](/azure/aks/azure-ad-rbac) and minimize granting administrator privileges to protect configuration, and secrets access.
> - Limit access to [Kubernetes cluster configuration](/azure/aks/control-kubeconfig-access) file with Azure role-based access control.
> - Limit access to [actions that containers can perform](/azure/aks/developer-best-practices-pod-security#secure-pod-access-to-resources). Provide the least number of permissions, and avoid the use of root, or privileged escalation.
> - Evaluate the use of the built-in [AppArmor security module](/azure/aks/operator-best-practices-cluster-security#app-armor) to limit actions that containers can perform such as read, write, or execute, or system functions such as mounting files systems.
> - Evaluate the use of the [seccomp (secure computing)](/azure/aks/operator-best-practices-cluster-security#secure-computing). Seccomp works at the process level and allows you to limit the process calls that containers can perform.
> - Use [Pod Identities](/azure/aks/operator-best-practices-identity#use-pod-identities) and [Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure#usage) with Azure Key Vault to protect secrets, certificates, and connection strings.
> - Protect the API server with Azure Active Directory RBAC.
> - Use [Azure Security Center](/azure/security-center/defender-for-kubernetes-introduction) to provide AKS recommendations.
> - Secure clusters and pods with [Azure Policy](/azure/aks/use-azure-policy).
> - Secure container access to resources.
> - Upgrade Kubernetes clusters regularly to stay current.
> - When using Azure CNI, create planned IP ranges to allow your cluster to scale in network.
> - Use ingress controllers for distributing traffic.
> - Use a Web Application Firewall to secure traffic.
> - Use Kubernetes network policies for controlling traffic flow between pods.
> - Securely connect to Kubernetes nodes through a bastion host.

## AKS configuration recommendations

Explore the following table of recommendations to optimize your AKS configuration for service security:

|AKS Recommendation|Description|
|------------------|-----------|
|Configure scraping of Prometheus metrics with Azure Monitor for containers.|Azure Monitor for containers provides a seamless onboarding experience to collect Prometheus metrics. Reference [Configure scraping of Prometheus metrics with Azure Monitor for containers](/azure/azure-monitor/containers/container-insights-prometheus-integration) for more information.|
|Ensure proper selection of network plugin based on network requirements and cluster sizing.|Azure CNI is required for specific scenarios, for example, Windows-based node pools, specific networking requirements, and Kubernetes Network Policies. Reference [Kubenet vs. Azure CNI](/azure/aks/concepts-network#compare-network-models) for more information.|

### Security guideline recommendations

The following table reflects security guideline recommendations and descriptions related to the overall AKS configuration recommendations:

|Security Guideline Recommendations|Description|
|----------------------------------|-----------|
|Use AAD integration.|Using Azure AD centralizes the identity management component. Any change in user account or group status is automatically updated in access to the AKS cluster. The developers and application owners of your Kubernetes cluster need access to different resources. Kubernetes doesn't provide an identity management solution to control which users can interact with what resources. You typically integrate your cluster with an existing identity solution. Azure AAD provides an enterprise-ready identity management solution, and can integrate with AKS clusters.|
|Use pod identities.|Don't use fixed credentials within pods or container images because they're at risk of exposure or abuse. Instead, use pod identities to request access using a central Azure AD identity solution. *Note: Pod identities are intended for use with Linux pods and container images only.*|
|Protect the API server with Azure Active Directory RBAC.|Securing access to the Kubernetes API Server is one of the most important things you can do to secure your cluster. Integrate Kubernetes role-based access control (RBAC) with Azure AD to control access to the API server. These controls let you secure AKS the same way that you secure access to your Azure subscriptions. The Kubernetes API server provides a single connection point for requests to perform actions within a cluster. To secure and audit access to the API server, limit access and provide the least-privileged access permissions required. This approach isn't unique to Kubernetes, but is especially important when the AKS cluster is logically isolated for multi-tenant use.|
|Secure clusters and pods with Azure Policy.|[Azure Policy](/azure/aks/use-azure-policy) can help to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner. It can also control what functions pods are granted and if anything is running against company policy. This access is defined through built-in policies provided by the Azure Policy Add-on for AKS. By providing more control over the security aspects of your pod's specification, like root privileges, Azure Policy enables stricter security adherence and visibility into what you've deployed in your cluster. If a pod doesn't meet conditions specified in the policy, Azure Policy can disallow the pod to start or flag a violation.|
|Secure container access to resources.|Limit access to actions that containers can perform. Provide the least number of permissions, and avoid the use of root or privileged escalation. In the same way that you should grant users or groups the least number of privileges required, containers should also be limited to only the actions and process that they need. To minimize the risk of attack, don't configure applications and containers that require escalated privileges or root access.|
|Upgrade Kubernetes clusters regularly to stay current.|To stay current on new features and bug fixes, regularly upgrade to the Kubernetes version in your AKS cluster. Kubernetes releases new features at a quicker pace than more traditional infrastructure platforms. Kubernetes updates include new features, bug, or security fixes. New features typically move through an alpha and then beta status before they become stable, and are generally available, and recommended for production use. This release cycle should allow you to update Kubernetes without regularly encountering breaking changes, or adjusting your deployments and templates.|
|Create planned IP ranges to allow your cluster to scale in network when using Azure CNI.|Clusters configured with Azure CNI networking require additional planning. The size of your virtual network and its subnet must accommodate the number of pods you plan to run and the number of nodes for the cluster.|
|Use ingress controllers for distributing traffic.|To distribute HTTP or HTTPS traffic to your applications, use ingress resources and controllers to provide extra features over a regular Azure load balancer, and can be managed as native Kubernetes resources.|
|Use a Web Application Firewall to secure traffic.|To scan incoming traffic for potential attacks, use a web application firewall such as Barracuda WAF for Azure or Azure Application Gateway. An ingress controller that distributes traffic to services and applications is typically a Kubernetes resource in your AKS cluster. In larger environments, you often want to offload some of this traffic routing or TLS termination to a network resource outside of the AKS cluster. You also want to scan incoming traffic for potential attacks.|
|Use Kubernetes network policies for controlling traffic flow between pods.|Use network policies to allow or deny traffic to pods. By default, all traffic is allowed between pods within a cluster. For improved security, define rules that limit pod communication. *Note: Network policy should only be used for Linux-based nodes and pods in AKS.*|
|Securely connect to Kubernetes nodes through a bastion host.|Don't expose remote connectivity to your AKS nodes. Create a bastion host, or jump box, in a management virtual network. Use the bastion host to securely route traffic into your AKS cluster to remote management tasks. *Note: Most operations in AKS can be completed using the Azure management tools or though the Kubernetes API server.* AKS nodes aren't connected to the public internet, and are only available on a private network. To connect to nodes and perform maintenance or troubleshoot issues, route your connections through a bastion host, or jump box.|

## Source artifacts

To identify AKS clusters *not* using **RBAC**, use the following query:

```sql
Resources
| where type =~ 'Microsoft.ContainerService/managedClusters'
| where properties.enableRBAC == false
```