This guide shows how Microsoft security solutions can secure and protect Amazon Web Services (AWS) account access and environments.

## Architecture

This diagram summarizes how AWS installations can benefit from key Microsoft security components:

:::image source="./media/aws-azure-security-solutions-architecture.png" alt-text="Architecture diagram that shows the benefits of implementing Azure security for AWS." border="false" lightbox="./media/aws-azure-security-solutions-architecture.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/1985346_aws-azure-security-solutions-architecture.pptx) of this architecture.*

### Microsoft Entra

- **Centralized Identity and Access Management**

Microsoft Entra ID is a cloud-based, comprehensive, centralized identity and access management solution that can help secure and protect AWS accounts and environments.

Microsoft Entra ID provides strong SSO authentication to almost any app or platform that follows common web authentication standards, including AWS. Amazon Web Services (AWS) accounts that support critical workloads and highly sensitive information need strong identity protection and access control. AWS identity management is enhanced when combined with Microsoft Entra ID.

AWS organizations that use Microsoft Entra ID for Microsoft 365 or hybrid cloud identity and access protection can quickly and easily deploy Microsoft Entra ID for AWS accounts, often without additional cost.  Microsoft Entra ID offers several capabilities for direct integration with AWS:

-  SSO across legacy, traditional, and modern authentication solutions.

-  Azure MFA, including integration with several third-party solutions from [Microsoft Intelligent Security Association (MISA)](https://www.microsoft.com/security/business/intelligent-security-association) partners.

-  Powerful Conditional Access features for strong authentication and strict governance. Microsoft Entra ID uses Conditional Access policies and risk-based assessments to       authentictae and authorize user access to the AWS Management Console and AWS resources. 

- Large-scale threat detection and automated response. Microsoft Entra ID processes over 30 billion authentication requests per day, along with trillions of signals about          threats worldwide. Advanced Identity Protection increases Microsoft Entra sign-in security by monitoring user or session risk. 

- Privileged Access Management (PAM) to enable Just-In-Time (JIT) provisioning specific resources. You can expand PIM to any delegated permission by controlling access       to custom groups, such as the ones you created for access to AWS roles.

For more information and detailed instructions, see [Microsoft Entra identity and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security).

 

-  __Entra Permissions Management__

Microsoft Entra Permissions Management is a cloud infrastructure entitlement management (CIEM) product that provides comprehensive visibility and control over permissions on identities, actions, and resources across multicloud infrastructure in Microsoft Azure, Amazon Web Services (AWS), and Google Cloud Platform (GCP). You can use Microsoft Entra Permissions Management to:

- Get a multi-dimensional view of yout risk by assessing identities, permissions, and resources. 

- Auotmate the enforcement of the least privilege policy in your entire multicloud infrastructure.

- Use anomaly and outlier detection to prevent data breaches that are caused by misuse and malicious exploitation of permissions.

For more information and detailed onboarding instructions, see [Onboard an Amazon Web Services (AWS) account](/azure/active-directory/cloud-infrastructure-entitlement-management/onboard-aws).

 

### __Microsoft Defender for Cloud Apps__

When several users or roles make administrative changes, a consequence can be _configuration drift_ away from intended security architecture and standards. Security standards can also change over time. Security personnel must constantly and consistently detect new risks, evaluate mitigation options, and update security architecture to prevent potential breaches. Security management across multiple public cloud and private infrastructure environments can become burdensome.

Microsoft Defender for Cloud Apps delivers full protection for SaaS applications, helping you monitor and protect your cloud app data across the following feature areas:

- __Fundamental cloud access security broker (CASB) functionality__, such as Shadow IT discovery, visibility into cloud app usage, protection against app-based threats from anywhere in the cloud, and information protection and compliance assessments.

- __SaaS Security Posture Management (SSPM) features__, enabling security teams to improve the organization’s security posture

- __Advanced threat protection__, as part of Microsoft's extended detection and response (XDR) solution, enabling powerful correlation of signal and visibility across the full kill chain of advanced attacks

- __App-to-app protection__, extending the core threat scenarios to OAuth-enabled apps that have permissions and privileges to critical data and resources.

Connecting AWS to Defender for Cloud Apps helps you secure your assets and detect potential threats by monitoring administrative and sign-in activities, notifying on possible brute force attacks, malicious use of a privileged user account, unusual deletions of VMs, and publicly exposed storage buckets. Defender for Cloud Apps protects AWS environments from abuse of cloud resources, compromised accounts and insider threats, data leakage, and resource misconfiguration and insufficient access control. 

```
 · https://learn.microsoft.com/en-us/defender-cloud-apps/best-practices#detect-cloud-threats-compromised-accounts-malicious-insiders-and-ransomware
```
```

```

- [Limit exposure of shared data and enforce collaboration policies](/defender-cloud-apps/best-practices)

- [Use the audit trail of activities for forensic investigations](/defender-cloud-apps/best-practices)

- [Protect AWS in real time with Conditional access app control to block and protect the download of sensitive data located in AWS to unmanaged or risky users.](/defender-cloud-apps/proxy-intro-aad)

 For more information on how to connect AWS environments with Defender for Cloud Apps, see -  [Protect your Amazon Web Services environment - Microsoft Defender for Cloud Apps | Microsoft Learn](/defender-cloud-apps/protect-aws)

### __Microsoft Defender for Cloud__

Microsoft Defender for Cloud is a cloud-native application protection platform (CNAPP) that is made up of security measures and practices that are designed to protect cloud-based applications from various cyber threats and vulnerabilities. Defender for Cloud combines the capabilities of:

- A development security operations (DevSecOps) solution that unifies security management at the code level across multicloud and multiple-pipeline environments

- A cloud security posture management (CSPM) solution that surfaces actions that you can take to prevent breaches

- A cloud workload protection platform (CWPP) with specific protection for servers, containers, storage, databases, and other workloads.

Microsoft Defender for Cloud’s native AWS support provides several benefits to your organization.:

- Foundational CSPM for AWS resources

- Defender CSPM for AWS resources

- CWP support for Amazon EKS clusters

- CWP support for AWS EC2 instances

- CWP support for SQL servers running on AWS EC2, RDS Custom for SQL Server

The CSPM (both foundational capabilities and Defender CSPM) for AWS resources is <u>completely agentless.</u>  Foundational CSPM provides recommendations on how to best harden your AWS resources and remediate misconfigurations. Important Note: Defender for cloud offers foundational multicloud CSPM capabilities for free. 

Defender CSPM provides you advanced posture management capabilities such as [Attack path analysis](/azure/defender-for-cloud/how-to-manage-attack-path), [Cloud security explorer](/azure/defender-for-cloud/how-to-manage-cloud-security-explorer), advanced threat hunting, [security governance capabilities](/azure/defender-for-cloud/concept-regulatory-compliance), and also tools to assess your [security compliance](/azure/defender-for-cloud/review-security-recommendations) with a wide range of benchmarks, regulatory standards, and any custom security policies required in your organization, industry, or region.

The CWP support for AWS EC2 instances offers a wide set of capabilities, including automatic provisioning of pre-requisites on existing and new machines, vulnerability assessment, integrated license for Microsoft Defender for Endpoint (MDE), file integrity monitoring and [more](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-servers?tabs=features-multicloud).

The CWP support for Amazon EKS clusters offers a wide set of capabilities including discovery of unprotected clusters, advanced threat detection for the control plane and workload level, Kubernetes data plane recommendations (through the Azure Policy extension) and [more](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-containers?tabs=aws-eks).

The CWP support for SQL servers running on AWS EC2, AWS RDS Custom for SQL Servers offers a wide set of capabilities, including advanced threat protection, vulnerability assessment scanning, and [more](/azure/defender-for-cloud/defender-for-sql-introduction).

Security standards provide support for assessing resources and workloads in AWS against regulatory compliance standards such as Center for Internet Security (CIS) and payment card industry (PCI) standards, and for the AWS Foundational Security Best Practices standard.

For more information how to protect workloads in AWS, see [Connect your AWS account - Microsoft Defender for Cloud | Microsoft Learn](/azure/defender-for-cloud/quickstart-onboard-aws) and [Assign regulatory compliance standards in Microsoft Defender for Cloud - Microsoft Defender for Cloud | Microsoft Learn](/azure/defender-for-cloud/update-regulatory-compliance-packages)

 

### __Microsoft Sentinel__

Microsoft Sentinel is a scalable, cloud-native security information and event management (SIEM) that delivers an intelligent and comprehensive solution for SIEM and security orchestration, automation, and response (SOAR). Microsoft Sentinel provides cyberthreat detection, investigation, response, and proactive hunting, with a bird's-eye view across your enterprise.

Use the Amazon Web Services (AWS) connectors to pull AWS service logs into Microsoft Sentinel. These connectors work by granting Microsoft Sentinel access to your AWS resource logs. Setting up the connector establishes a trust relationship between Amazon Web Services and Microsoft Sentinel. This is accomplished on AWS by creating a role that gives permission to Microsoft Sentinel to access your AWS logs.

The connector can ingest logs from the following AWS services by pulling them from an S3 bucket:

- [Amazon Virtual Private Cloud (VPC)](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) - [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)

- [Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html) - [Findings](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings.html)

- [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) - [Management](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html) and [data](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html) events

- [AWS CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) - [CloudWatch logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)

For more information on how to install and configure the AWS connector in Microsoft Sentinel, see [Connect Microsoft Sentinel to Amazon Web Services to ingest AWS service log data | Microsoft Learn](/azure/sentinel/connect-aws?tabs=s3)

### __Recommendations__

Keep the following points in mind when you develop a security solution.

#### __Security recommendations__

The following principles and guidelines are important for any cloud security solution:

- Ensure that the organization can monitor, detect, and automatically protect user and programmatic access into cloud environments.

- Continually review current accounts to ensure identity and permission governance and control.

- Follow least privilege and [zero trust](https://www.microsoft.com/security/business/zero-trust) principles. Make sure that users can access only the specific resources that they require, from trusted devices and known locations. Reduce the permissions of every administrator and developer to provide only the rights that they need for the role that they perform. Review regularly.

- Continuously monitor platform configuration changes, especially if they provide opportunities for privilege escalation or attack persistence.

- Prevent unauthorized data exfiltration by actively inspecting and controlling content.

- Take advantage of solutions that you might already own, like Microsoft Entra ID P2, that can increase security without additional expense.

#### __Basic AWS account security__

To ensure basic security hygiene for AWS accounts and resources:

- Review the AWS security guidance at [Best practices for securing AWS accounts and resources](https://aws.amazon.com/premiumsupport/knowledge-center/security-best-practices).

- Reduce the risk of uploading and downloading malware and other malicious content by actively inspecting all data transfers through the AWS Management Console. Content that you upload or download directly to resources within the AWS platform, such as web servers or databases, might need additional protection.

- Consider protecting access to other resources, including:

  - Resources created within the AWS account.
  
  - Specific workload platforms, like Windows Server, Linux Server, or containers.
  
- Devices that administrators and developers use to access the AWS Management Console.

     
  
## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Lavanya Murthy](https://www.linkedin.com/in/lavanyamurthy) | Principal Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For security guidance from AWS, see [Best practices for securing AWS accounts and resources](https://aws.amazon.com/premiumsupport/knowledge-center/security-best-practices).
- For the latest Microsoft security information, see [Microsoft Security](https://www.microsoft.com/security).
- For full details of how to implement and manage Microsoft Entra ID, see [Securing Azure environments with Microsoft Entra ID](https://aka.ms/AzureADSecuredAzure).
- For an overview of AWS asset threats and corresponding protective measures, see [How Defender for Cloud Apps helps protect your Amazon Web Services (AWS) environment](/cloud-app-security/protect-aws).
- For information about connectors and how to establish connections, see these resources:
  - [Connect your AWS accounts to Microsoft Defender for Cloud](/azure/defender-for-cloud/quickstart-onboard-aws?pivots=env-settings)
  - [New AWS connector in Microsoft Defender for Cloud](/azure/defender-for-cloud/episode-one)
  - [Connect AWS to Microsoft Defender for Cloud Apps](/cloud-app-security/connect-aws-to-microsoft-cloud-app-security)
  - [Connect Microsoft Sentinel to AWS CloudTrail](/azure/sentinel/connect-aws)

## Related resources

- For in-depth coverage and comparison of Azure and AWS features, see the [Azure for AWS professionals](../../aws-professional/index.md) content set.
- For guidance for deploying Microsoft Entra identity and access solutions for AWS, see [Microsoft Entra identity and access management for AWS](../../reference-architectures/aws/aws-azure-ad-security.yml).
