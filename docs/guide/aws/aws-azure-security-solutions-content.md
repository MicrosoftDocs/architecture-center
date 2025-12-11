This guide describes how Microsoft security solutions provide a Zero Trust, defense-in-depth controls that can be extended to AWS to eliminate blind spots and ensure consistent visibility, enforcement, and protection.

#placeholder update

This diagram summarizes how AWS installations can benefit from key Microsoft security components:

:::image source="./media/aws-azure-security-solutions-architecture.png" alt-text="Architecture diagram that shows the benefits of implementing Azure security for AWS." border="false" lightbox="./media/aws-azure-security-solutions-architecture.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/1985346_aws-azure-security-solutions-architecture.pptx) of this diagram.*

## Microsoft Entra

Microsoft Entra ID is a comprehensive, cloud-based centralized identity and access management solution that can help secure and protect AWS accounts and environments.  Microsoft Entra ID provides strong SSO authentication to almost any app or platform that follows common web authentication standards, including AWS. AWS accounts that support critical workloads and highly sensitive information need strong identity protection and access control. Microsoft Entra ensures access to AWS resources is _“verified explicitly”_ every time and _“least privilege”_ is maintained. AWS identity management is enhanced when you combine it with Microsoft Entra ID.

AWS organizations that use Microsoft Entra ID for Microsoft 365 or hybrid cloud identity and access protection can quickly and easily deploy Microsoft Entra ID for AWS accounts, often without incurring additional costs. 

Microsoft Entra ID provides several capabilities for direct integration with AWS:

- __Centralized Identities__: Entra federation with AWS IAM Identity Center enforces “never trust, always verify” for AWS access. Entra ID allows enhanced security, improved user experience, centralized access control, and SSO across legacy, traditional, and modern authentication solutions.

- __Lifecycle Automation:__ With SSO in place, automate lifecycle management with integrated HR workflows. Design AWS role mappings with group memberships that are mapped to AWS roles for authorization.

- __Enforce Strong Authentication:__ Powerful Conditional Access features to enforce zero trust principle of verify explicitly to AWS logins. Require strong authentication with Microsoft Entra multifactor authentication or integration with several third-party solutions from [Microsoft Intelligent Security Association](https://www.microsoft.com/security/business/intelligent-security-association) partners.  For example, you can require MFA every time, Entra will “challenge” or reject login attempts as per policy _before_ the user ever touches AWS. This significantly reduces the risk of account takeover. Entra ID can also enable enforcement of several other factors such as risk, network location, device compliance – ensuring only managed, healthy devices can access the AWS.

- __Identity Protection:__ Improved protection against identity-based attacks via real-time detection, continuous risk assessment, and remediation of risky sign-ins and unusual user behavior. Additionally, Entra Identity Protection with conditional access policies can detect if an account had suspicious activities (e.g. leaked credentials on the dark web) and automatically impose tighter controls or disable it.

- __Privileged Identity Management (PIM):__ enables just-in-time and least privileges to govern administrative access to AWS roles.  Reduce standing access and limit exposure to attacks. Instead of giving a user a permanent AWS admin access key, assign them to an Entra group that corresponds to an AWS admin role; with PIM, that group membership can be “eligible” and only active when the user needs it. Entra PIM will log and require approval for activations.  You can expand PIM to any delegated permission by controlling access to custom groups that you create for access to AWS roles.

- __Identity Governance:__ Extend Entra governance features to AWS. Provide self-service governance using Entra ID Access Packages that are time bound to handle AWS access requests with approval workflows. Conduct periodic access reviews to remove excess or standing access to reduce risk. Access recertification also help simplify reporting and prove regulatory compliance.

- __Workload identities:__ Leverage Entra workload identity federation for AWS to issue short-lived tokens that AWS trusts for API access – eliminating the need for static AWS access keys. This approach tightly integrates Entra ID with AWS IAM roles, so Azure-based workloads can seamlessly assume AWS roles resulting in no long-lived credentials to leak, every access is verified in real-time, and identities are governed centrally. By using Entra as the identity plane for AWS, you achieve a __unified identity security stance across multi-cloud__ – users have one identity, one strong authentication policy, and one place to be de-provisioned if they leave, thereby closing gaps that siloed accounts would create.  For more information and detailed instructions, see [Microsoft Entra identity and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security). 

### Microsoft Defender for Cloud Apps

Defender for Cloud Apps provides enhanced protection for Software as a Service (SaaS) applications. Defender for Cloud Apps adds a dynamic layer of security on user activities and data in cloud applications. It provides the following features to help you monitor and protect your cloud app data:

- __Fundamental Cloud Access Security Broker functionality__ including shadow IT discovery, visibility into cloud app usage, enhanced protection against app-based threats from anywhere in the cloud, and information protection and compliance assessments.

- __SaaS Security Posture Management features__ that enable security teams to improve the organization's security posture.

- __Advanced threat protection__ as part of the Microsoft extended detection and response solution, enables powerful correlation of signal and visibility across the full cyberattack chain of advanced attacks.

- __App-to-app protection__ which extends the core threat scenarios to OAuth-enabled apps that have permissions and privileges to critical data and resources.

Connecting AWS to Defender for Cloud Apps helps you secure your assets and detect potential threats by monitoring administrative and sign-in activities. You get notifications of possible brute force attacks, malicious use of privileged user accounts, unusual deletions of VMs, and publicly exposed storage buckets. Defender for Cloud Apps helps protect AWS environments from abuse of cloud resources, compromised accounts and insider threats, data leakage, and resource misconfiguration and insufficient access control. It enforces Zero Trust at the session/application level: even after a user is authenticated to AWS and continues to monitor and validate their actions.

By connecting AWS to Defender for Cloud Apps, you gain:

- __Visibility into activities:__ A consolidated activity log of user and admin actions in AWS. This log is presented in Defender for Cloud Apps where you can filter and search across all cloud apps. For example, you can query “Show me all AWS console activities by user X in the last 24 hours” easily. This is useful for investigations and to feed anomaly detection.

- __Anomaly detection policies:__ Defender for Cloud Apps continually monitors your users' activities and uses UEBA and machine learning to learn and understand the typical behavior of your users and trigger alerts on any deviations to [detect cloud threats, compromised accounts, malicious insiders, and ransomware](/defender-cloud-apps/best-practices). Some examples of anomalies include:

  - Impossible travel: User logs into AWS from say the US and then 30 minutes later from Russia – impossible given the distance. This indicates account compromise, triggering an alert.
  
  - Activity from a risky IP or anonymous proxy: If a user normally comes from a known IP range and suddenly is active from a TOR node is flagged.
  
  - Unusual administrative activity: e.g., deletion of an unusual number of VMs or changing logging settings that the user never touched before.
  
  - Mass download or deletion: If someone tries to download a large number of objects from S3 or delete many resources in a short span – possible sabotage or cleanup actions by an attacker. Each anomaly that triggers generates an alert in Defender for Cloud Apps catching activities that signature-based detections miss
  
- __Policy enforcement and governance:__ Beyond just detecting and alerting, Defener for Cloud Apps lets you set policies to take action. For instance, you can define a policy: “Alert and suspend user if they delete more than 5 EC2 instances within 10 minutes” or “If any S3 bucket is made public, notify the security team and optionally revert the ACL”. In fact, it includes file policies like detecting if an S3 bucket becomes publicly accessible, and activity policies for critical changes (IAM changes, Network ACL changes, etc.). Many of these are available as template policies which you can simply enable. For governance, MCAS can automatically remediate via API. Example actions are below and these automated actions enforce security in near real-time, often mitigating issues faster than a human admin could respond.

  - Suspend user: disable the Entra ID user which in turn blocks access to AWS via federation identity.
  
  - Require re-authentication: sign the user out of AWS and force them to log in again via Entra ID requiring MFA if a session is deemed risky.
  
  - Notify user: Pop-up or email a user that what they did is against policy, e.g. “You have violated policy by downloading 1000 records from S3” – a gentle nudge for insiders or a marker for accidental policy violations.
  
  - Make S3 bucket private: Through AWS API, Defender for Cloud Apps can remove public access from an S3 bucket if a policy triggers.
  
  - Remove collaborator: If someone shared an S3 bucket with an external account for example, Defender for Cloud Apps could remove that external collaborator automatically.
  
- __Session control (real-time intervention):__ One powerful feature of Defender for Cloud Apps is Conditional Access App Control. With AWS, you can route user traffic through Defender for Cloud Apps and Entra ID Conditional Access to actively block or monitor specific actions in real time. For example, if a user tries to download files from AWS on an unmanaged device, session control can prevent the download or replace the file with a sanitized message. Similarly, it can apply Purview DLP policies to data exfiltration attempts – e.g., block copying of secret keys or certain patterns via the console.

For more information on how to connect AWS environments to Defender for Cloud Apps, see [Protect your Amazon Web Services environment](/defender-cloud-apps/protect-aws).

### Microsoft Defender for Cloud

Defender for Cloud is a Cloud-Native Application Protection Platform that's made up of security measures and practices that are designed to protect cloud-based applications from various cyberthreats and vulnerabilities. Defender for Cloud provides the following capabilities:

- A development security operations solution that unifies security management at the code level across multicloud and multiple-pipeline environments

- A cloud security posture management (CSPM) solution that surfaces actions that you can take to help prevent breaches

- A cloud workload protection platform (CWPP) that provides protection for servers, containers, storage, databases, and other workloads

Defender for Cloud native AWS support provides several benefits:

- Foundational CSPM for AWS resources

- Defender CSPM for AWS resources

- CWPP support for Amazon EKS clusters

- CWPP support for AWS EC2 instances

- CWPP support for SQL servers running on AWS EC2 and RDS Custom for SQL Server

The foundational CPSM and Defender CSPM are both completely agentless. Foundational CSPM provides recommendations on how to best harden your AWS resources and remediate misconfigurations. Defender for Cloud offers foundational multicloud CSPM capabilities for free. 

Defender CSPM provides advanced posture management capabilities like [attack path analysis](/azure/defender-for-cloud/how-to-manage-attack-path), [cloud security explorer](/azure/defender-for-cloud/how-to-manage-cloud-security-explorer), advanced threat hunting, and [security governance capabilities](/azure/defender-for-cloud/concept-regulatory-compliance). It also provides tools to assess your [security compliance](/azure/defender-for-cloud/review-security-recommendations) with a wide range of benchmarks, regulatory standards, and any custom security policies required in your organization, industry, or region.

The CWPP support for AWS EC2 instances provides capabilities like automatic provisioning of prerequisites on existing and new machines, vulnerability assessment, an integrated license for Microsoft Defender for Endpoint, file integrity monitoring, and [more](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-servers?tabs=features-multicloud).

The CWPP support for Amazon EKS clusters provides capabilities like discovery of unprotected clusters, advanced threat detection for the control plane and workload level, Kubernetes data plane recommendations (via the Azure Policy extension), and [more](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-containers?tabs=aws-eks).

The CWPP support for SQL servers running on AWS EC2 and AWS RDS Custom for SQL Server provides capabilities like advanced threat protection, vulnerability assessment scanning, and [more](/azure/defender-for-cloud/defender-for-sql-introduction).

Security standards provide support for assessing resources and workloads in AWS against regulatory compliance standards like Center for Internet Security (CIS) and Payment Card Industry (PCI) standards, and for the AWS Foundational Security Best Practices standard.

For more information about protecting workloads in AWS, see [Connect your AWS account](/azure/defender-for-cloud/quickstart-onboard-aws) and [Assign regulatory compliance standards in Microsoft Defender for Cloud](/azure/defender-for-cloud/update-regulatory-compliance-packages). 

### Microsoft Sentinel

Microsoft Sentinel is a scalable cloud-native security information and event management (SIEM) system that provides an intelligent and comprehensive solution for SIEM and security orchestration, automation, and response. Microsoft Sentinel provides cyberthreat detection, investigation, response, and proactive hunting. It gives you a bird's-eye view across your enterprise.

You can use the AWS connectors to pull AWS service logs into Microsoft Sentinel. These connectors work by granting Microsoft Sentinel access to your AWS resource logs. Setting up the connector establishes a trust relationship between AWS and Microsoft Sentinel. You create this relationship on AWS by creating a role that gives permission to Microsoft Sentinel to access your AWS logs.

The connector can ingest logs from the following AWS services by pulling them from an S3 bucket:

|Service|Data source|
|-|-|
|[Amazon Virtual Private Cloud (VPC)](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) | [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)|
| [Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html) | [GuardDuty findings](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings.html)|
|[AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) | [Management](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html) and [data](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html) events|
|[AWS CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) | [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)|

For more information on how to install and configure the AWS connector in Microsoft Sentinel, see [Connect Microsoft Sentinel to Amazon Web Services to ingest AWS service log data](/azure/sentinel/connect-aws?tabs=s3).

### Recommendations

Use the Microsoft security solutions and basic AWS security recommendations to protect AWS accounts.

#### Basic AWS account security

For information about basic security hygiene for AWS accounts and resources, review the AWS security guidance at [Best practices for securing AWS accounts and resources](https://aws.amazon.com/premiumsupport/knowledge-center/security-best-practices).

- Reduce the risk of uploading and downloading malware and other malicious content by actively inspecting all data transfers via the AWS Management Console. Content that you upload or download directly to resources within the AWS platform, such as web servers or databases, might need additional protection.

- Provide security for access keys by rotating the keys periodically. Avoid embedding them in code. Use IAM roles instead of long-term access keys wherever possible.

- Use security groups and network ACLs to control inbound and outbound traffic to your resources. Implement VPC to isolate resources.

- Encrypt sensitive data at rest and in transit by using AWS Key Management Services. 

- Protect devices that administrators and developers use to access the AWS Management Console.  

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Lavanya Murthy](https://www.linkedin.com/in/lavanyamurthy) | Principal Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Monitor and protect AWS administrative and sign-in activities](/defender-cloud-apps/protect-aws)
- [Protect workloads in AWS](/azure/defender-for-cloud/quickstart-onboard-aws)
- [Connect Microsoft Sentinel to Amazon Web Services to ingest AWS service log data](/azure/sentinel/connect-aws?tabs=s3)

## Related resources

- [Secure AWS identities](/azure/architecture/reference-architectures/aws/aws-azure-ad-security) 
