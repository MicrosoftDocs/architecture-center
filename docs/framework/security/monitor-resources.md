---
title: Monitor Azure resources in Azure Security Center
description: Remediate the common risks identified by Azure Security Center.
author: PageWriter-MSFT
ms.date: 03/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Monitor Azure resources in Azure Security Center

Identify common security risks significantly reduces overall risk to the organization. Use Azure Security Center to monitor the security posture of machines, networks, storage and data services, and applications to discover potential security issues. Common issues include internet connected VMs, or missing security updates, missing endpoint protection or encryption, deviations from baseline security configurations, missing Web Application Firewall (WAF), and more.

## Virtual machines

If you're running your own Windows and Linux virtual machines, use Azure Security Center. Take advantage of the free services to check for missing OS patches, security misconfiguration, and basic network security. Enabling Azure Defender is highly recommended because you get features that provide adaptive application controls, file integrity monitoring (FIM), and others.

For example, a common risk is the virtual machines don't have vulnerability scanning solutions that check for threats. Azure Security Center reports those machines. You can remediate in Azure Security Center by deploying a scanning solution. You can use the built-in vulnerability scanner for virtual machines. You don't need a license. Instead, you can bring your license for supported partner solutions. 

> [!NOTE]
>
>Vulnerability assessments are also available for container images, and SQL servers.

Attackers constantly scan public cloud IP ranges for open management ports, which can lead to attacks such as common passwords and known unpatched vulnerabilities. JIT (Just In Time) access allows you to lock down the inbound traffic to the virtual machines while providing easy access to connect to machines when needed. Security center identifies which machines should have JIT applied.

With Azure Defender, you also get Microsoft Defender for Endpoint. This provides investigative tools Endpoint Detection and Response (EDR) that helps in threat detection and analysis.

Azure Defender for servers also watches the network to and from virtual machines. If you are using network security groups to control access to the virtual machines and the rules are overpermissive, Security Center will flag them. Adaptive network hardening provides recommendations to further harden the NSG rules. 

For a full list of features, see [Feature coverage for machines](/azure/security-center/security-center-services?tabs=features-windows). 

## Containers

Application containers architectures have an extra layer of abstraction and orchestration. That complexity requires specific security measures that protect against common container attacks such as supply chain attacks. 

- Use container registries that are validated for security. Images in public registries may contain malware or unwanted applications that can only get detected when the container is running. Build a process for developers to request and rapidly get security validation of new containers and images. The process should validate against your security standards. This includes applying security updates, scanning for unwanted code such as backdoors and illicit crypto coin miners, scanning for security vulnerabilities, and application of secure development practices.

    A popular process pattern is the quarnatine pattern. This pattern allows you to get your images on a dedicated container registry and subject them to security or compliance scrutiny applicable for your organization. After its validated, they can then be released from quarantine and promoted to being available.

    Azure Security Center identifies unmanaged containers hosted on IaaS Linux VMs, or other Linux machines running Docker containers. 

- Make sure you use images from authorized registries. You can enforce this restriction through Azure Policy. For example, for an Azure Kubernetes Service (AKS) cluster, have policies that retrict the cluster to only pulls images from Azure Container Registry (ACR) that is deployed as part of the architecture.

    > [!TIP]
    > Here are the resources for the preceding example:
    >
    > ![GitHub logo](../../_images/github.svg) [GitHub: Azure Kubernetes Service (AKS) Secure Baseline Reference Implementation](https://github.com/mspnp/aks-secure-baseline).
    >
    > The design considerations are described in [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/secure-baseline-aks.yml).


- Regularly scan containers for known risks in the container registry, before use, and during use. 

- Use security monitoring tools that are container aware to monitor for anomalous behavior and enable investigation of incidents. 

    Azure Defender for container registries protections for AKS clusters, container hosts
(virtual machines running Docker), and ACR registries. When enabled, the images that are pulled or pushed to registries are subject to vulnerability scans. 

For more information, see these articles:

- [Container security in Security Center](/azure/security-center/container-security)
- [Compute section](/azure/security-center/recommendations-reference#recs-compute) of the recommendations reference table.

## Storage

## Network

**How do you monitor and diagnose conditions of the network?** 
***

As an initial step, enable and review all logs (including raw traffic) from your network devices.

- Security group logs – [flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-portal) and diagnostic logs
- [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview)

Take advantage of the [packet capture](/azure/network-watcher/network-watcher-alert-triggered-packet-capture) feature to set alerts and gain access to real-time performance information at the packet level. 

Packet capture tracks traffic in and out of virtual machines. It gives you the capability to run proactive captures based on defined network anomalies including information about network intrusions. 

For an example, see [Scenario: Get alerts when VM is sending you more TCP segments than usual](/azure/network-watcher/network-watcher-alert-triggered-packet-capture#scenario).

Then, focus on observability of specific services by reviewing the diagnostic logs. For example, for Azure Application Gateway with integrated WAF, see [Web application firewall logs](/azure/application-gateway/application-gateway-diagnostics). Azure Security Center analyzes diagnostic logs on virtual networks, gateways, network security groups and determins if the controls are secure enough. For example:

- Is your virtual machine exposed to public internet. If so, do you have tight rules on network security groups to protect the machine?
- Are the network security groups (NSG) and rules that control access to the virtual machines overly permissive? 
- Do you have overly-permissive inbound rules for management ports in your Network Security Group? 
- Are the storage accounts receiving traffic over secure connections?

Follow the recommendations provided by Security Center. For more information, see [Networking recommendations](azure/security-center/recommendations-reference#networking-recommendations).

Integrate all logs into a security information and event management (SIEM) service, such as Azure Sentinel. The SIEM solutions support ingestion of large amounts of information and can analyze large datasets quickly. Based on those insights, you can:
- Set alerts or block traffic crossing segmentation boundaries.
- Identify anomalies. 
- Tune the intake to significantly reduce the false positive alerts. 

## Identity


## Next steps
> [!div class="nextstepaction"]
> [View logs and alerts](monitor-logs-alerts.md)

 by increasing cost to attackers. Azure Secure Score in 