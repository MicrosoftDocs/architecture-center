This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

## Maintain an Information Security Policy 

**Requirement 12**&mdash;Maintain a policy that addresses information security for all personnel
***

This architecture and the implementation aren't designed to provide illustrative guidance for this requirement. For considerations, refer to the guidance in the official PCI-DSS standard.

This requirement is about documenting the official security policy end-to-end. Here are some general suggestions:

- Maintain thorough and updated documentation about the process and policies. People operating regulated environments must be educated, informed, and incentivized to support the security assurances. 
- In the annual review of the security policy, incorporate new guidance delivered by Microsoft, Kubernetes, and other third-party solutions that are part of your CDE. Some resources include vendor publications combined with guidance derived from Azure Security Center, Azure Advisor,  [Azure Well-Architected Review](https://docs.microsoft.com/assessments/), and updates in the [AKS Azure Security Baseline](https://docs.microsoft.com/security/benchmark/azure/baselines/aks-security-baseline) and [CIS Azure Kubernetes Service Benchmark](https://www.cisecurity.org/blog/new-release-cis-azure-kubernetes-service-aks-benchmark/)., and others.
- When establishing your risk assessment process, align with a published standard where practical. Using [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) is recommended. Map risk assessments to your vendor's published security list, such as the [Microsoft Security Response Center guide](https://msrc.microsoft.com/update-guide).
- Keep up-to-date information about device inventory and personnel access documentation. One way is to derive that information from Azure Active Directory logs.

## Next


> [!div class="nextstepaction"]
> [Maintain an Information Security Policy](aks-pci-summary.yml)