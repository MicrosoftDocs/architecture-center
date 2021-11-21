This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS 3.2.1).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml).

## Maintain an information security policy

### **Requirement 12**&mdash;Maintain a policy that addresses information security for all personnel

Microsoft completed an annual PCI DSS assessment using an approved Qualified Security Assessor (QSA). Take into considerations all aspects of the infrastructure, development, operations, management, support, and in-scope services. For more information, see [Payment Card Industry (PCI) Data Security Standard (DSS)](/compliance/regulatory/offering-PCI-DSS#use-microsoft-compliance-manager-to-assess-your-risk).

This architecture and the implementation aren't designed to provide illustrative guidance for documenting the official security policy end-to-end. For considerations, refer to the guidance in the official PCI-DSS 3.2.1 standard.

Here are some general suggestions:

- Maintain thorough and updated documentation about the process and policies. Consider [using Microsoft Compliance Manager to assess your risk](/compliance/regulatory/offering-PCI-DSS#use-microsoft-compliance-manager-to-assess-your-risk).
- In the annual review of the security policy, incorporate new guidance delivered by Microsoft, Kubernetes, and other third-party solutions that are part of your CDE. Some resources include vendor publications combined with guidance derived from Microsoft Defender for Cloud, Azure Advisor, [Azure Well-Architected Review](/assessments/), and updates in the [AKS Azure Security Baseline](/security/benchmark/azure/baselines/aks-security-baseline) and [CIS Azure Kubernetes Service Benchmark](https://www.cisecurity.org/blog/new-release-cis-azure-kubernetes-service-aks-benchmark/), and others.
- When establishing your risk assessment process, align with a published standard where practical, for example [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final). Map publications from your vendor's published security list, such as the [Microsoft Security Response Center guide](https://msrc.microsoft.com/update-guide), to your risk assessment process.
- Keep up-to-date information about device inventory and personnel access documentation. Consider using the device discovery capability included in Microsoft Defender for Endpoint. For tracking access, you can derive that information from Azure Active Directory logs. Here are some articles to get you started:

  - [Device discovery](/microsoft-365/security/defender-endpoint/device-discovery)
  - [View reports and logs in Azure AD entitlement management](/azure/active-directory/governance/entitlement-management-reports)

- As part of your inventory management, maintain a list of approved solutions that deployed as part of the PCI infrastructure and workload. This includes a list of VM images, databases, third-party solutions of your choice that you bring to the CDE. You can even automate that process by building a service catalog. It provides self-service deployment using those approved solutions in a specific configuration, which adheres to ongoing platform operations. For more information, see [Establish a service catalog](/azure/cloud-adoption-framework/manage/considerations/platform#establish-a-service-catalog).

- Make sure that a security contact receives Azure incident notifications from Microsoft.

  These notifications indicate if your resource is compromised. This enables your security operations team to rapidly respond to potential security risks and remediate them. Ensure administrator contact information in the Azure enrollment portal includes contact information that will notify security operations directly or rapidly through an internal process. For details, see [Security operations model](/azure/cloud-adoption-framework/secure/security-operations#security-operations-model).

Here are other articles that will help you plan the operational compliance.

- [Cloud management in the Cloud Adoption Framework](/azure/cloud-adoption-framework/manage/)
- [Governance in the Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/govern/)

## Next steps

> [!div class="nextstepaction"]
> [Summary](aks-pci-summary.yml)
