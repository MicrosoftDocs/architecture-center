---
title: Security audits
description: Security logging and monitoring focuses on activities related to enabling, acquiring, and storing audit logs for Azure services.
author: PageWriter-MSFT
ms.date: 11/03/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
ms.custom:
  - article
---

# Security audits 

To make sure that the security posture doesn’t degrade over time, have regular auditing that checks compliance with organizational standards. 

## Key points
> [!div class="checklist"]
> - Discover and remediate common risks to improve secure score in Azure Security Center.
> - Establish security benchmarking using Azure Security Benchmark to align with industry standards.
> - Perform regular internal and external compliance audits, including regulatory compliance attestations.
> - Review the policy requirements.


## Track the secure score

**Does you review and remediate common risks within Azure tenants?**
***

Monitor the security posture of VMs, networks, storage, data services, and various other contributing factors. [Secure Score](/azure/security-center/secure-score-security-controls) in Azure Security Center shows a composite score that represents the security posture at the subscription level. 

![Azure secure score overview](images/secure-score-tile.png)

View the recommendations to see potential security issues, such as internet connected VMs, or missing security updates, missing endpoint protection or encryption, and more.

![Azure secure score](images/secure-score.png)

There might be some resources that may not get remediated as the Azure Platform evolves. For example, compliance can prevents adoption of new features.

## Evaluate using standard benchmarks

**Do you evaluate the security posture of this workload using standard benchmarks?**
***

Benchmarking enables security program improvement by learning from external organizations. It lets the organization know how its current security state compares to that of other organizations. As an example, the Center for Internet Security (CIS) has created security benchmarks for Azure that map to the CIS Control Framework. Another reference example is the MITRE ATT&CK™ framework that defines the various adversary tactics and techniques based on real-world observations.

Establish security benchmarking using [Azure Security Benchmark](/azure/security/benchmarks/) to align with industry standards. 

You can monitor the state of Azure Security Benchmark in Azure Security Center, after it's been added as a policy to the subscription.  

## Audit regulatory compliance

**Have you established a monitoring and assessment solution for compliance?**
***
Continuously assess and monitor the compliance status of your workload. Azure Security Center provides a regulatory compliance dashboard that shows the current security state of workload against controls mandated by the standard governments or industry organizations and Azure Security Benchmark. Keep your resources in compliance with those standards. Security Center tracks many standards. You can set the standards by management groups in a subscription.  

![Azure regulatory compliance](images/regulatory-compliance.png)

Here's an example management group that is tracking compliance to the Payment Card Industry (PCI) standard.

![PCI regulatory compliance](images/regulatory-compliance-pci.png)

**Do you have internal and external audits for this workload?**
***

A workload should be audited internally, external, or both with the goal of discovering security gaps. Make sure that the gaps are addressed through updates. 

Auditing is important for workloads that follow a standard. Aside from signifying levels of standards, noncompliance with regulatory guidelines may bring sanctions and penalties.

Perform regulatory compliance attestation. Attestations are done by an independent party that examines if the workload is in compliance with a standard. 

## Review critical access

**Is access to the control plane and data plane of the application periodically reviewed?**
***

Regularly review roles that have high privileges. Set up a recurring review pattern to ensure that accounts are removed from permissions as roles change. Consider auditing at least twice a year.

As people in the organization and on the project change, make sure that only the right people have access to the application infrastructure. Auditing and reviewing the access control reduces the attack vector to the application. 

Azure control plane depends on Azure AD. You can conduct the review manually or through an automated process by using tools such as [Azure AD access reviews](/azure/active-directory/governance/create-access-review). These reviews are often centrally performed often as part of internal or external audit activities. 

## Check policy compliance

Make sure that the security team is auditing the environment to report on compliance with the security policy of the organization. Security teams may also enforce compliance with these policies. 

Enforce and audit industry, government, and internal corporate security policies. Policy monitoring checks that initial configurations are correct and that it continues to be compliant over time. 

For Azure, use Azure Policy to create and manage policies that enforce compliance. Azure Policies are built on the Azure Resource Manager capabilities. Azure Policy can also be assigned through Azure Blueprints. 
For more information, see [Tutorial: Create and manage policies to enforce compliance](/azure/governance/policy/tutorials/create-and-manage).



## Next steps
> [!div class="nextstepaction"]
> [Application development](./design-apps-services.md)

## Related links

- [Secure score in Azure Security Center](/azure/security-center/secure-score-security-controls) allows you view all the security vulnerabilities into a single score.

- [Tutorial: Improve your regulatory compliance](/azure/security-center/security-center-compliance-dashboard) describes a step-by-step process to evaluate regulatory requirements in Azure Security Center.