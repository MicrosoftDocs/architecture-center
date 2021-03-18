# Remediate security risks in Azure Security Center

Security controls must remain effective against attackers who continuously improve their ways to attack the digital assets of an enterprise. Use the principle of drive continuous improvement to make sure systems are regularly evaluated and improved.

Start by remediating common security risks. These risks are usually from well-established attack vectors. This will forces attackers to acquire use advanced and more expensive attack methods.

## Key points

- Processes for handling incidents and post-incident activities, such as lessons learned and evidence retention.
- Remediate the common risks identified by Azure Security Center.
- Track remediation progress with secure score and comparing agaist historical results. 
- Address alerts and take action with remediation steps.

## Review and remediate recommendations

Azure Security Center monitors the security status of machines, networks, storage and data services, and applications to discover potential security issues. Enable this capability at no additional cost to  detect vulnerable virtual machines connected to internet, missing security updates, missing endpoint protection or encryption, deviations from baseline security configurations, missing Web Application Firewall (WAF), and more.  

Review the results and apply the [Azure security center recommendations](/azure/security-center/security-center-recommendations) to execute technical remediations. 

The recommendations are grouped by controls. Each recommendation has detailed information such as severity, affected resources, and quick fixes where applicable. Start with high severity items. 

For example, a common risk is the virtual machines don't have vulnerability scanning solutions that check for threats. Azure Security Center reports those machines. You can remediate in Azure Security Center by deploying a scanning solution. Through Azure Defender for servers, you can use the built-in vulnerability scanner for virtual machines. You don't need a license. Alternatively, you can bring your license for supported partner solutions. 

When conducting remote scans, do not use a single, perpetual, administrative account. Consider implementing JIT (Just In Time) provisioning methodology for the scan account. Credentials for the scan account should be protected, monitored, and used only for vulnerability scans.

> [!NOTE]
>
>Vulnerability assessments are also available for container images, and SQL servers.

Security Center has the capability of exporting results at configured intervals. Compare the results with previous sets to verify that issues have been remediated. 

For more information, see [Continuous export](azure/security-center/continuous-export). 

Software-defined datacenters allow easy and rapid discovery of all resources, enabling technology like [Azure Security Center](/azure/security-center/security-center-intro) to quickly and accurately measure the patch state of all servers. 


## Policy remediation

A common approach for maintaining the security posture is through Azure Policy. 

Along with organizational policies, a workload owner can use scoped policies for governance purposes, such as check misconfiguration, prohibit certain resource types, and others. The resources are evaluated against rules to identify unhealthy resources that are risky. Post evaluation, certain actions are required as remediation. The actions can be in enforced through Azure Policy effects. 

For example, a workload runs in an Azure Kubernetes Service (AKS) cluster. The business goals require the workload to run in a highly restrictive environment. As a workload owner, you want the resource group to contain AKS clusters that are private. You can enforce that requirement with the **Deny** effect. It'll prevent a cluster from being created if that rule isn't satisfied. 

Another use case is that can be automatically remediated by deploying related resources. For example, the organization wants all storage resources in a subscription to send logs to a common Log Analytics workspace. If a storage account doesn't pass the policy, a deployment is automatically started as remediation. That remediation can be enforced through **DeployIfNotExist**. There are some considerations. 
- There's a significant wait before the resource is updated and the deployment starts. In the preceding example, this means there won't be logs captured during that wait time. Avoid using this effect for resources that cannot tolerate a delay. 
- The resource deployed as a result of **DeployIfNotExist** is owned by a separate identity. That identity must have high enough privleges to make changes to the subscription. 

## Track the secure score

Azure Secure Score in Azure Security Center represents the overall security in a composite score. It takes into consideration the security risk of monitored by the Security Center. 

**Do you have a process for formally reviewing secure score on Azure Security Center?**
***

As you review the results and apply recommendations, track the progress and prioritize ongoing investments. Higher score indicates a better security posture. 

## Manage alerts

Azure Security Center shows a list of alerts that's based on logs collected from resources within a scope. Alerts include context information such as severity, status, activity time. Most alerts have MITRE ATT&CK® tactics that can help you understand the kill chain intent. Select the alert and investigate the problem with detailed information. 

Finally take action. That action can be to fix the resources that are out of compliance with actionable remediation steps. You can also suppress alerts that are false positives. 

Make sure that you are integrating critical security alerts into Security Information and Event Management (SIEM), Security Orchestration Automated Response (SOAR) without introducing a high volume of low value data. Azure Security Center can stream alerts to Azure Sentinel. You can also use a third-party solution by using Microsoft Graph Security API.

## Review advanced controls
Review notification from advanced security features. Here are some examples: 
- Manage the various threat protection services
- Just-in-time (JIT) VM access. This reduces the attack surface by denying inbound traffic to selected ports. 
- Changes to Adaptive controls use machine learning to analyze the security state. For example, adaptive application controls can analyze frequently running applications to create an allow list.  Network Hardening, adaptive application controls, and more.







## Related links










