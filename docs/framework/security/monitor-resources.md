---
title: Monitor Azure resources in Microsoft Defender for Cloud
description: Use Microsoft Defender for Cloud to monitor the security posture of machines, networks, storage and data services, and applications to discover potential security issues.
author: PageWriter-MSFT
ms.date: 03/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
  - azure-active-directory
categories:
  - security
subject:
  - security
  - monitoring
---

# Monitor Azure resources in Microsoft Defender for Cloud

Most cloud architecture have compute, networking, data, and identity components and each require different monitoring mechanisms. Even Azure services have individual monitoring needs. For instance, to monitor Azure Functions you want to enable Azure Application Insights.

Microsoft Defender for Cloud has many plans that monitor the security posture of machines, networks, storage and data services, and applications to discover potential security issues. Common issues include internet connected VMs, or missing security updates, missing endpoint protection or encryption, deviations from baseline security configurations, missing Web Application Firewall (WAF), and more.

## Key points

 [!div class="checklist"]
>
> - Enable Microsoft Defender for Cloud as a defense-in-depth measure. Use resource-specific Defender for Cloud features such as Microsoft Defender for servers, Microsoft Defender for Endpoint, Microsoft Defender for Storage.
> - Observe container hygiene through container aware tools and regular scanning.
> - Review all network flow logs through network watcher. See diagnostic logs in Microsoft Defender for Cloud.
> - Integrate all logs in a central SIEM solution to analyze and detect suspicious behavior.
> - Monitor identity-related risk events in Azure AD reporting amd Azure Active Directory Identity Protection.

## General best practices

Identifying common security activities will significantly reduce the overall risk.

- Monitor suspicious activities from administrative accounts.
- Monitor the location from where Azure resources are being managed.
- Monitor attempts to access deactivated credentials.
- Use automated tools to monitor network resource configurations and detect changes.

For more information, see [Azure security baseline for Azure Monitor](/security/benchmark/azure/baselines/monitor-security-baseline).

### IaaS and PaaS security

In an IaaS model, you can host the workload on Azure infrastructure. Azure provides security assurances that maintain isolation and timely security updates to the infrastructure. For greater control, you host the entire IaaS solution on-premises or in a hosted data center and are responsible for security. You must implement security on the host, virtual machine, network, and storage. For instance if you have your own VNet, consider enabling Azure Private Link over Azure Monitor so you can access this over a private endpoint.

In PaaS, you have shared responsibility with Azure in protecting the data.

## Virtual machines

If you're running your own Windows and Linux virtual machines, use Microsoft Defender for Cloud. Take advantage of the free services to check for missing OS patches, security misconfiguration, and basic network security. Enabling Microsoft Defender for Cloud is highly recommended because you get features that provide adaptive application controls, file integrity monitoring (FIM), and others.

For example, a common risk is the virtual machines don't have vulnerability scanning solutions that check for threats. Microsoft Defender for Cloud reports those machines. You can remediate in Microsoft Defender for Cloud by deploying a scanning solution. You can use the built-in vulnerability scanner for virtual machines. You don't need a license. Instead, you can bring your license for supported partner solutions.

> [!NOTE]
>
> Vulnerability assessments are also available for container images, and SQL servers.

Attackers constantly scan public cloud IP ranges for open management ports, which can lead to attacks such as common passwords and known unpatched vulnerabilities. JIT (Just In Time) access allows you to lock down the inbound traffic to the virtual machines while providing easy access to connect to machines when needed. Defender for Cloud identifies which machines should have JIT applied.

With Microsoft Defender for Cloud, you also get Microsoft Defender for Endpoint. This provides investigative tools Endpoint Detection and Response (EDR) that helps in threat detection and analysis.

Microsoft Defender for servers also watches the network to and from virtual machines. If you are using network security groups to control access to the virtual machines and the rules are overpermissive, Defender for Cloud will flag them. Adaptive network hardening provides recommendations to further harden the NSG rules.

For a full list of features, see [Feature coverage for machines](/azure/security-center/security-center-services?tabs=features-windows).

### Remove direct internet connectivity

Make sure policies and processes require restricting and monitoring direct internet connectivity by virtual machines.

For Azure, you can enforce policies by:

- **Enterprise-wide prevention:** Prevent inadvertent exposure by following the permissions and roles described in the reference model.

  - Ensures that network traffic is routed through approved egress points by default.

  - Exceptions (such as adding a public IP address to a resource) must go through a centralized group that evaluates exception requests and makes sure appropriate controls are applied.

- **Identify and remediate** exposed virtual machines by using the [Microsoft Defender for Cloud](/azure/security-center/) network visualization to quickly identify internet exposed resources.

- **Restrict management ports** (RDP, SSH) using [Just in Time access](/azure/security-center/security-center-just-in-time) in Microsoft Defender for Cloud.

One way of managing VMs in the virtual network is by using [Azure Bastion](/azure/bastion/). This service allows you to log into VMs in the virtual network through SSH or remote desktop protocol (RDP) without exposing the VMs directly to the internet. To see a reference architecture that uses Bastion, see [Network DMZ between Azure and an on-premises datacenter](../../reference-architectures/dmz/secure-vnet-dmz.yml).

## Containers

Containerized workloads have an extra layer of abstraction and orchestration. That complexity requires specific security measures that protect against common container attacks such as supply chain attacks.

- Use container registries that are validated for security. Images in public registries might contain malware or unwanted applications that activate when the container is running. Build a process for developers to request and rapidly get security validation of new containers and images. The process should validate against your security standards. This includes applying security updates, scanning for unwanted code such as backdoors and illicit crypto coin miners, scanning for security vulnerabilities, and application of secure development practices.

    A popular process pattern is the quarantine pattern. This pattern allows you to get your images on a dedicated container registry and subject them to security or compliance scrutiny applicable for your organization. After it's validated, they can then be released from quarantine and promoted to being available.

    Microsoft Defender for Cloud identifies unmanaged containers hosted on IaaS Linux VMs, or other Linux machines running Docker containers.

- Make sure you use images from authorized registries. You can enforce this restriction through Azure Policy. For example, for an Azure Kubernetes Service (AKS) cluster, have policies that restrict the cluster to only pull images from Azure Container Registry (ACR) that is deployed as part of the architecture.

    > [!TIP]
    > Here are the resources for the preceding example:
    >
    > ![GitHub logo](../../_images/github.svg) [GitHub: Azure Kubernetes Service (AKS) Secure Baseline Reference Implementation](https://github.com/mspnp/aks-secure-baseline).
    >
    > The design considerations are described in [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/secure-baseline-aks.yml).

- Regularly scan containers for known risks in the container registry, before use, and during use.

- Use security monitoring tools that are container aware to monitor for anomalous behavior and enable investigation of incidents.

    Microsoft Defender for container registries are designed to protect AKS clusters, container hosts (virtual machines running Docker), and ACR registries. When enabled, the images that are pulled or pushed to registries are subject to vulnerability scans.

For more information, see these articles:

- [Container security in Defender for Cloud](/azure/security-center/container-security)

## Network

**How do you monitor and diagnose conditions of the network?**
***

As an initial step, enable and review all logs (including raw traffic) from your network devices.

- Security group logs – [flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-portal) and diagnostic logs
- [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview)

Take advantage of the [packet capture](/azure/network-watcher/network-watcher-alert-triggered-packet-capture) feature to set alerts and gain access to real-time performance information at the packet level.

Packet capture tracks traffic in and out of virtual machines. It gives you the capability to run proactive captures based on defined network anomalies including information about network intrusions.

For an example, see [Scenario: Get alerts when VM is sending you more TCP segments than usual](/azure/network-watcher/network-watcher-alert-triggered-packet-capture#scenario).

Then, focus on observability of specific services by reviewing the diagnostic logs. For example, for Azure Application Gateway with integrated WAF, see [Web application firewall logs](/azure/application-gateway/application-gateway-diagnostics). Microsoft Defender for Cloud analyzes diagnostic logs on virtual networks, gateways, network security groups and determines if the controls are secure enough. For example:

- Is your virtual machine exposed to public internet. If so, do you have tight rules on network security groups to protect the machine?
- Are the network security groups (NSG) and rules that control access to the virtual machines overly permissive?
- Are the storage accounts receiving traffic over secure connections?

Follow the recommendations provided by Defender for Cloud. For more information, see [Networking recommendations](/azure/security-center/recommendations-reference#networking-recommendations). Use [Azure Firewall logs](/azure/firewall/logs-and-metrics) and metrics for observability into operational and audit logs.

Integrate all logs into a security information and event management (SIEM) service, such as Microsoft Sentinel. The SIEM solutions support ingestion of large amounts of information and can analyze large datasets quickly. Based on those insights, you can:

- Set alerts or block traffic crossing segmentation boundaries.
- Identify anomalies.
- Tune the intake to significantly reduce the false positive alerts.

## Identity

Monitor identity-related risk events using adaptive machine learning algorithms, heuristics quickly before the attacker can gain deeper access into the system.

### Review identity risks

Most security incidents take place after an attacker initially gains access using a stolen identity. Even if the identity has low privileges, the attacker can use it to traverse laterally and gain access to more privileged identities. This way the attacker can control access to the target data or systems.

**Does the organization actively monitor identity-related risk events related to potentially compromised identities?**
***
Monitor identity-related risk events on potentially compromised identities and remediate those risks.  Review the reported risk events in these ways:

- Azure AD reporting. For information, see [users at risk security report](/azure/active-directory/reports-monitoring/concept-user-at-risk) and the [risky sign-ins security report](/azure/active-directory/reports-monitoring/concept-risky-sign-ins).
- Use the reporting capabilities of [Azure Active Directory Identity Protection](/azure/active-directory/active-directory-identityprotection).
- Use the Identity Protection risk events API to get programmatic access to security detections by using Microsoft Graph. See [riskDetection](/graph/api/resources/riskdetection?view=graph-rest-1.0&preserve-view=true) and [riskyUser](/graph/api/resources/riskyuser?view=graph-rest-1.0&preserve-view=true) APIs.

Azure AD uses adaptive machine learning algorithms, heuristics, and known compromised credentials (username/password pairs) to detect suspicious actions that are related to your user accounts. These username/password pairs come from monitoring public and dark web and by working with security researchers, law enforcement, security teams at Microsoft, and others.

Remediate risks by manually addressing each reported account or by setting up a [user risk policy](/azure/active-directory/identity-protection/howto-user-risk-policy) to require a password change for high risk events.

### Regularly review critical access

Regularly review roles that are assigned privileges with a business-critical impact.

Set up a recurring review pattern to ensure that accounts are removed from permissions as roles change. You can conduct the review manually or through an automated process by using tools such as [Azure AD access reviews](/azure/active-directory/governance/create-access-review).

### Discover & replace insecure protocols

Discover and disable the use of legacy insecure protocols SMBv1, LM/NTLMv1, wDigest, Unsigned LDAP Binds, and Weak ciphers in Kerberos.

Applications should use the SHA-2 family of hash algorithms (SHA-256, SHA-384, SHA-512). Use of weaker algorithms, like SHA-1  and MD5, should be avoided.

Authentication protocols are a critical foundation of nearly all security assurances. These older versions can be exploited by attackers with access to your network and are often used extensively on legacy systems on Infrastructure as a Service (IaaS).

Here are ways to reduce your risk:

- Discover protocol usage by reviewing logs with Microsoft Sentinel's Insecure Protocol Dashboard or third-party tools.

- Restrict or Disable use of these protocols by following guidance for
    [SMB](https://support.microsoft.com/help/2696547/detect-enable-disable-smbv1-smbv2-smbv3-in-windows-and-windows-server),
    [NTLM](/windows/security/threat-protection/security-policy-settings/network-security-restrict-ntlm-ntlm-authentication-in-this-domain),
    [WDigest](https://support.microsoft.com/help/2871997/microsoft-security-advisory-update-to-improve-credentials-protection-a).

- Use only secure hash algorithms (SHA-2 family).

We recommend implementing changes using pilot or other testing methods to mitigate risk of operational interruption.

#### Learn more

For more information about hash algorithms, see [Hash and Signature Algorithms](/windows/win32/seccrypto/hash-and-signature-algorithms).

### Connected tenants

**Does your security team have visibility into all existing subscriptions and cloud environments? How do they discover new ones?**
***

Make sure the security team is aware of all enrollments and associated subscriptions connected to your existing environment through ExpressRoute or Site-Site VPN. Monitor them as part of the overall enterprise.

Assess if organizational policies and applicable regulatory requirements are followed for the connected tenants. This applies to all Azure environments that connect to your production environment network.

The organizations' cloud infrastructure should be well documented, with security team access to all resources required for monitoring and insight. Conduct frequent scans of the cloud-connected assets to ensure no additional subscriptions or tenants have been added outside of organizational controls. Regularly review Microsoft guidance to ensure security team access best practices are consulted and followed.

For information about permissions for this access, see [Assign privileges for managing the environment section](/azure/architecture/framework/security/governance?branch=master#assign-privileges-for-managing-the-environment).

#### Suggested actions

Ensure all Azure environments that connect to your production environment and network apply your organization's policy, and IT governance controls for security.

You can discover existing connected tenants using a
[tool](/azure/role-based-access-control/elevate-access-global-admin?toc=%252fazure%252factive-directory%252fprivileged-identity-management%252ftoc.json) provided by Microsoft. Guidance on permissions you may assign to security is in the [Assign privileges for managing the environment](/azure/architecture/framework/security/design-identity-role-definitions#clear-lines-of-responsibility) section.

## CI/CD pipelines

DevOps practices are for change management of the workload through continuous integration, continuous delivery (CI/CD). Make sure you add security validation in the pipelines. Follow the guidance described in [Learn how to add continuous security validation to your CI/CD pipeline](/azure/devops/migrate/security-validation-cicd-pipeline?view=azure-devops&preserve-view=true).

## Next steps

> [!div class="nextstepaction"]
> [View logs and alerts](monitor-logs-alerts.md)
