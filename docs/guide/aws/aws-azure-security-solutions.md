---
title: Microsoft Security Solutions for AWS
description: Learn how Microsoft security solutions can help secure and protect Amazon Web Services (AWS) account access and environments.
author: murthyla
ms.author: lmurthy
ms.date: 12/01/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Microsoft security solutions for AWS

This guide describes how to use Microsoft security solutions to help secure Amazon Web Services (AWS) by applying defense-in-depth controls that align with Zero Trust principles. These solutions help ensure consistent visibility, enforcement, and protection across your AWS environment.

The following diagram summarizes how AWS environments can benefit from Microsoft security components.

:::image type="complex" border="false" source="media/aws-azure-security-solutions-content/aws-doc-diagram.svg" alt-text="Diagram that shows how AWS environments can benefit from Microsoft security components." lightbox="media/aws-azure-security-solutions-content/aws-doc-diagram.svg":::
The image shows a three‑column diagram where arrows connect Microsoft Azure services on the left, Benefits in the center, and AWS on the right. The left column titled Microsoft Azure lists several services with descriptions. Microsoft Entra provides single sign-on (SSO), single life cycle automation, conditional access policies, identity protection, Privileged Identity Management (PIM), workload identities, entitlement management, and access reviews. Microsoft Defender for Cloud Apps provides visibility into activities, anomaly detection, policies, policy enforcement and governance, and session control. Microsoft Defender for Cloud provides cloud security graph, risk prioritization, attack path analysis (APA), data identity and permission exposure, data security posture management, multicloud attack path correlation, governance and compliance, and workload protections for servers, containers, databases, and AI. Microsoft Purview provides multicloud data discovery, data catalog and governance, risk management, and compliance reporting. Microsoft Sentinel provides unified visibility and analytics, threat intelligence, detection and hunting, and response automation. Microsoft Defender XDR provides real-time containment, cross-platform detection, and enhanced security for critical infrastructure, visibility, and control. Microsoft Security Copilot provides rapid incident investigation, step-by-step response guidance, automated remediation and scripting, and natural language threat hunting. The center column titled Benefits shows aligned outcomes including centralized identity access management, strong authentication, identity governance, session protection, information protection, threat protection, Cloud Security Posture Management, cloud workload protection, AI security posture management and protection, information governance, regulatory compliance, threat protection and response, threat hunting, automatic attack disruption, and AI-augmented threat detection. The right column titled AWS shows the AWS Management Console with role-based authorization to access AWS account resources and an AWS resources section labeled workloads that run on the AWS platform. Arrows link the Azure services through the benefits to the AWS environment.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/aws-security-solutions-architecture.pptx) of this diagram.*

## Microsoft Entra ID

Microsoft Entra ID is a cloud-based centralized identity and access management solution that can help secure and protect AWS accounts and environments. Microsoft Entra seamless single sign-on (SSO) supports most apps and platforms that follow common web authentication standards, including AWS. AWS accounts that support critical workloads and highly sensitive information need strong identity protection and access control. Microsoft Entra ID explicitly verifies every access request and enforces least-privilege access to AWS resources. Add Microsoft Entra ID to AWS to provide centralized identity management and enhanced security controls.

AWS organizations that use Microsoft Entra ID for Microsoft 365 or hybrid cloud identity and access protection can quickly and easily deploy Microsoft Entra ID for AWS accounts, often without incurring extra costs. 

Microsoft Entra ID provides several capabilities for direct integration with AWS:

- **Centralized identities:** Combine Microsoft Entra ID federation with AWS Identity and Access Management (IAM) Identity Center to enforce the Zero Trust principle of *never trust, always verify* for AWS access. Microsoft Entra ID provides enhanced security, improved user experience, centralized access control, and SSO across legacy, traditional, and modern authentication solutions.

- **Life cycle automation:** After you enable SSO, automate user life cycle management by using integrated human resources (HR) workflows. Map Microsoft Entra ID group memberships to AWS roles so that users automatically receive the appropriate AWS permissions based on their group assignments.

- **Enforce strong authentication:** Use Microsoft Entra Conditional Access to enforce the Zero Trust principle of *verify explicitly* for AWS sign-ins. You can require strong authentication by using Microsoft Entra multifactor authentication (MFA) or integrate with solutions from [Microsoft Intelligent Security Association](https://www.microsoft.com/security/business/intelligent-security-association) partners.

  For example, if you require MFA on every sign-in, Microsoft Entra ID evaluates each attempt against your policies and either prompts the user for extra authentication or rejects the attempt *before* it grants access to AWS. This approach reduces the risk of account takeover. You can also enforce other factors like risk level, network location, and device compliance to ensure that only managed, healthy devices can access your AWS resources.

- **Microsoft Entra ID Protection:** Improve protection against identity-based attacks by implementing real-time detection, continuous risk assessment, and remediation of risky sign-ins and unusual user behavior. Combine ID Protection with Conditional Access policies to detect whether an account is associated with suspicious activities, like leaked credentials on the dark web. Automatically impose tighter controls or deactivate the account.

- **Microsoft Entra Privileged Identity Management (PIM):** Enable just-in-time and least-privilege access to govern administrative access to AWS roles. These measures reduce standing access and limit exposure to attacks. Use PIM to assign users to a Microsoft Entra group that corresponds to an AWS admin role rather than directly granting admin permissions. You can configure that group membership as *eligible*, which means that it's only active when the user needs it. PIM logs activations and requires approval for them. You can expand PIM to any delegated permission by controlling access to custom groups that you create to grant access to AWS roles.

- **Identity governance:** Extend Microsoft Entra governance features to AWS. Let users request AWS access by using Microsoft Entra ID access packages that have time-limited assignments and approval workflows. Do periodic access reviews to remove excess or standing access to reduce risk. These access reviews also simplify reporting and help demonstrate regulatory compliance.

- **Workload identities:** Use Microsoft Entra workload identity federation for AWS to issue short-lived tokens that AWS trusts for API access. This approach avoids static AWS access keys. It also integrates Microsoft Entra ID with AWS IAM roles, so Azure-based workloads can assume AWS roles. This approach minimizes the risk of leaked credentials because it verifies every access request in real time and governs identities centrally.

  Use Microsoft Entra as the identity plane for AWS to achieve a unified identity security stance across your multicloud environment. Users have one identity, one strong authentication policy, and one centralized location where you can revoke access when they leave. This approach closes the gaps that siloed accounts create. For more information and detailed instructions, see [Microsoft Entra IAM for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security).

### Microsoft Defender for Cloud Apps

Microsoft Defender for Cloud Apps provides enhanced protection for software as a service (SaaS) applications. It adds a dynamic layer of security to user activities and data in cloud applications. It provides the following features to help you monitor and protect your cloud app data:

- **Fundamental cloud access security broker functionality**, including shadow IT discovery, visibility into cloud app usage, enhanced protection against app-based threats from anywhere in the cloud, and information protection and compliance assessments.

- **SaaS security posture management features** that enable security teams to improve the organization's security posture.

- **Advanced threat protection** as part of the Microsoft extended detection and response solution. This feature correlates signals and visibility across the full cyberattack chain of advanced attacks.

- **App-to-app protection** that extends the core threat scenarios to Open Authorization (OAuth)-enabled apps that have permissions and privileges to critical data and resources.

Connect AWS to Defender for Cloud Apps to help secure your assets and detect potential threats. This setup monitors administrative and sign-in activities and sends alerts about the following threats:

- Possible brute force attacks
- Malicious use of privileged user accounts
- Unusual virtual machine (VM) deletions
- Publicly exposed storage buckets

Defender for Cloud Apps helps protect AWS environments from abuse of cloud resources, compromised accounts, insider threats, data leakage, resource misconfiguration, and insufficient access control. It enforces Zero Trust at the session and application level. After a user authenticates to AWS, Defender for Cloud Apps continues to monitor and validate their actions.

AWS with Defender for Cloud Apps provides the following benefits:

- **Visibility into activities:** Defender for Cloud Apps consolidates user and admin actions from AWS into a single activity log. You can filter and search across all cloud apps from one interface. For example, you can query *Show me all AWS Management Console activities by user X in the last 24 hours.* This capability supports investigations and provides input for anomaly detection.

- **Anomaly detection policies:** Defender for Cloud Apps continually monitors your users' activities. It uses user and entity behavior analytics (UEBA) and machine learning to learn and understand the typical behavior of your users. It triggers alerts on deviations to [detect cloud threats, compromised accounts, malicious insiders, and ransomware](/defender-cloud-apps/best-practices). Consider the following examples of anomalies:

  - *Impossible travel:* A user signs in to AWS from the US and then 30 minutes later signs in from Russia. This activity indicates a compromised account and triggers an alert.
  
  - *Activity from a risky IP address or anonymous proxy:* A user typically accesses AWS from a known IP address range but suddenly connects from a Tor node.
  
  - *Unusual administrative activity:* A user deletes an unusual number of VMs or changes logging settings that they don't typically modify.
  
  - *Mass downloads or deletions:* A user attempts to download a large number of objects from Amazon Simple Storage Service (S3) or delete many resources in a short time span. This behavior can indicate sabotage or cleanup actions by an attacker.
  
  Each detected anomaly generates an alert in Defender for Cloud Apps. These behavior-based detections catch activities that signature-based detections miss.
  
- **Policy enforcement and governance:** Define policies that take automated action. You can create policies for specific scenarios, like *Alert and suspend the user if they delete more than five Amazon Elastic Compute Cloud (EC2) instances within 10 minutes* or *If any Amazon S3 bucket becomes public, notify the security team and optionally revert the access control list (ACL).*

  The platform includes file policies to detect when Amazon S3 buckets become publicly available and activity policies for critical changes, like AWS IAM or network ACL modifications. Many policies are available as templates that you can enable. Defender for Cloud Apps can automatically remediate problems through API calls. These automated actions enforce security in near real time and often mitigate problems faster than manual intervention. Consider the following example governance actions:

  - *Suspend the user:* Suspend the Microsoft Entra ID user, which blocks access to AWS via federation identity.
  
  - *Require reauthentication:* Sign the user out of AWS and force them to sign in again through Microsoft Entra ID with MFA if Defender for Cloud Apps deems the session risky.
  
  - *Notify the user:* Send a pop-up alert or email to inform a user that their action violates policy, like *You violated policy by downloading 1,000 records from Amazon S3.* This approach gives insiders a gentle nudge and helps flag accidental policy violations.
  
  - *Make the Amazon S3 bucket private:* Remove public access from an Amazon S3 bucket through the AWS API when a policy triggers.
  
  - *Remove collaborator:* Automatically remove an external collaborator. For example, this action can occur if someone shares an Amazon S3 bucket with an external account.
  
- **Session control (real-time intervention):** Conditional Access app control routes user traffic through Defender for Cloud Apps and Conditional Access to actively block or monitor specific actions in real time. For example, if a user tries to download files from AWS on an unmanaged device, session control can prevent the download or display a warning message instead. The platform can also apply Microsoft Purview Data Loss Prevention policies to prevent data exfiltration, like blocking attempts to copy secret keys or specific patterns through the console.

For more information about how to connect AWS environments to Defender for Cloud Apps, see [Protect your AWS environment](/defender-cloud-apps/protect-aws).

### Microsoft Defender for Cloud

Misconfigurations or vulnerabilities in cloud resources can expose your environment to bad actors. Microsoft Defender for Cloud is a cloud-native application protection platform (CNAPP). It provides Microsoft Defender Cloud Security Posture Management (CSPM) and cloud workload protection platforms (CWPPs) for your AWS environment. It continuously scans for weaknesses and recommends fixes by using defense-in-depth controls. It also provides unified multicloud visibility into the security posture across Azure, AWS, and Google Cloud Platform (GCP).

Defender for Cloud provides the following capabilities:

- Defender CSPM is a configuration hygiene layer that surfaces actions that you can take to help prevent breaches. By reducing misconfigurations, you reduce the attack surface available to adversaries.

- A CWPP provides protection for servers, containers, storage, databases, development operations (DevOps), AI, and other workloads.

Defender for Cloud native AWS support provides the following benefits:

-  **Defender CSPM:** When you connect AWS accounts to Defender for Cloud, it immediately begins to assess your AWS resources against known best practices and benchmarks. It uses the Microsoft Cloud Security Benchmark, which is a unified framework that includes controls for AWS. The assessment checks for common security problems, like the following examples:

   - Public Amazon S3 buckets
   - AWS IAM users without MFA
   - Overly permissive security groups
   - Exposed Kubernetes dashboards on Amazon Elastic Kubernetes Service (EKS) clusters
   
   Defender for Cloud reports each problem as a recommendation in the Azure portal. These recommendations contribute to a secure score that provides a quantifiable measure of your AWS security posture and compliance. 

  -  **Foundational CSPM:** Foundational CSPM provides unified asset inventory, hardening recommendations for your AWS resources, and workflow automation to remediate misconfigurations. It includes visualization and reporting capabilities. Defender for Cloud provides these foundational multicloud CSPM capabilities at no cost.
  
  -  **Defender CSPM:** Defender CSPM provides advanced posture management capabilities and agentless workload insights, including critical assets.
  
    - *Cloud security graph and risk prioritization:* Uses AWS resource metadata, AWS IAM roles, policies, and networks to build exploitability context across AWS services, like Amazon EC2, Amazon S3, AWS IAM, and Amazon VPC. Correlates the exploitability context with identities and permissions.
    
    - *Attack path analysis (APA):* Detects multistep attack chains in AWS, like an attack that progresses from a public Amazon EC2 instance through AWS IAM role escalation to Amazon S3 bucket access. Visualizes attack paths and provides *break-the-path* remediation for AWS-specific misconfigurations.
    
    - *Cloud security explorer:* Queries AWS posture by using graph-based filters, like *internet-exposed Amazon EC2 with attached AWS IAM role granting Amazon S3 write*.
    
    - *Identity and permission exposure:* Evaluates AWS IAM roles, policies, and effective permissions. Highlights toxic combinations, like overly permissive roles and public exposure.
    
    - *Data security posture management (DSPM):* Uses built-in classification rules to scan Amazon S3 buckets and Amazon Relational Database Service (RDS) databases, like Aurora, PostgreSQL, MySQL, MariaDB, SQL Server, and Oracle SE2.
    
    - *Multicloud attack path correlation:* Correlates AWS identities and resources with Azure and GCP to identify cross-cloud exploit chains. 
    
    - *Governance and compliance:* Uses tools to assess your [security compliance](/azure/defender-for-cloud/review-security-recommendations) with a wide range of benchmarks and regulatory standards. Microsoft provides built-in policies for AWS that cover standards like AWS Foundational Security Best Practices Standard and Payment Card Industry Data Security Standard (PCI-DSS). You can also add custom security policies for your organization, industry, or region to track AWS compliance.
    
- **CWPPs:** Defender for Cloud provides workload protection plans for various AWS workloads.

  - *Servers (VMs on Amazon EC2):* When you enable Defender for Servers for an AWS account, Defender for Cloud onboards your Amazon EC2 instances (Windows or Linux) for advanced threat protection. This process includes an integrated license for Microsoft Defender for Endpoint. Onboarded VMs receive endpoint detection and response (EDR) capabilities, including file integrity monitoring, malware scanning, behavior monitoring, and vulnerability assessment. The vulnerability scanner reports OS and software vulnerabilities to Defender for Cloud. Defender for Endpoint reports endpoint threats, like ransomware behavior or suspicious process activity. Defender for Cloud displays all findings as security alerts. For more information, see [Defender for Servers](/azure/defender-for-cloud/support-matrix-defender-for-servers).
  
  -  *Containers:* Microsoft Defender for Containers can protect Kubernetes clusters that run on AWS, including Amazon EKS. The protection works by deploying Azure Arc-enabled Kubernetes agents and the Defender extension to the cluster. Defender for Containers provides image vulnerability scanning for container images. It provides runtime threat detection for clusters, which identifies suspicious process activity in containers and crypto-mining operations. The solution monitors Kubernetes policy compliance and the Kubernetes control plane logs for suspicious events. For more information, see [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-aws-overview).
  
  - *Databases:* Defender for Cloud supports SQL servers that run on Amazon EC2 and Amazon RDS Custom. It provides capabilities for vulnerability assessment scanning, like checking for misconfigurations or missing patches. It also provides advanced threat protection for SQL, which detects anomalous queries and SQL injection attempts, and surfaces the alerts. For more information, see [Defender for SQL](/azure/defender-for-cloud/defender-for-sql-usage).
  
Defender for Cloud extends the *secure by design* philosophy to AWS through environment hardening, vulnerability management, and threat detection in one solution. For more information about protecting workloads in AWS, see [Connect your AWS account](/azure/defender-for-cloud/quickstart-onboard-aws) and [Assign regulatory compliance standards in Defender for Cloud](/azure/defender-for-cloud/assign-regulatory-compliance-standards). 

### Microsoft Purview

Data is the primary target for attackers and a core asset that you must protect for compliance. In a multicloud environment, data can reside anywhere, including Azure SQL databases, on-premises files, Amazon S3 buckets, or AWS databases.

Microsoft Purview provides a unified data governance solution that identifies what data exists in AWS, where it resides, and how sensitive it is. A defense-in-depth approach needs this information because it informs the protective measures needed at the data layer, like encryption, data loss prevention, and access controls. Microsoft Purview lets you enforce Zero Trust principles for data. Microsoft Purview also supports regulatory compliance because it ensures that AWS data repositories meet the same compliance standards as Azure or on-premises environments through consistent classification and reporting.

- **Multicloud data discovery:** The Microsoft Purview multicloud scanning connectors extend its discovery capabilities to AWS.

  For example, you can register an Amazon S3 bucket as a data source in Microsoft Purview and run a scan. The scanner reads object metadata and content. It uses the Microsoft Purview built-in classification rules, which include over 200 detectors for sensitive information like credit card numbers, Social Security numbers (SSNs), and API keys. The scanner identifies sensitive information within the objects but doesn't copy the data. It only retrieves metadata and classification results. Microsoft Purview stores the results in the Microsoft Purview Data Map. The scan might report: *Bucket: s3://my-finance-data/ contains three files classified as Privacy/Personal Data, detected UK National Insurance numbers.*
  
  Microsoft Purview can also scan Amazon RDS databases, like RDS for PostgreSQL or SQL Server. It connects and runs queries to retrieve schemas and sample data for classification.

-  **Data catalog and governance:** Microsoft Purview onboards all discovered AWS data assets into the Microsoft Purview Data Catalog alongside your other data assets. Data stewards and compliance officers can use a single portal to search for data. For example, they can search for *customer data* and find results in both Azure Data Lake Storage and AWS buckets. You can uniformly apply business glossary terms and sensitivity labels across all assets. This consistency supports compliance and demonstrates to auditors that you inventory and label all personal data across clouds.

- **Risk management:** Understand what sensitive data exists in AWS so that you can implement targeted security measures. For example, if Microsoft Purview finds credit card numbers in an Amazon S3 bucket, you can encrypt or move the data. You can also set up a Defender for Cloud Apps policy to monitor access to that bucket more closely. You can run Microsoft Purview scans on a schedule to detect changes. This approach provides continuous DSPM and highlights where sensitive data exists in AWS and whether you enable proper controls.

- **Integration with broader security:** Microsoft Purview surfaces the sensitive data identified in Defender for Cloud and Defender for Cloud Apps. This integration provides extra context to help you manage security posture and respond to alerts.

- **Compliance reporting:** For frameworks like General Data Protection Regulation (GDPR) and California Consumer Privacy Act (CCPA), Microsoft Purview Compliance Manager generates reports that show where you store personal data, including AWS locations. These reports make it easier to answer data subject requests and do impact assessments. Instead of manually searching AWS for data, you query Microsoft Purview as your centralized inventory. For PCI compliance, Microsoft Purview helps you identify all locations of cardholder data in AWS so that you can implement proper segmentation.

Microsoft Purview for AWS extends your data governance across clouds. At the deepest layer—the data itself—you gain insight and control over your sensitive information. Microsoft Purview provides compliance evidence to demonstrate that you identify and secure sensitive data regardless of where it resides. It also helps you make informed decisions about applying extra security controls. For more information, see [Amazon S3 Multicloud Scanning Connector for Microsoft Purview](/purview/register-scan-amazon-s3).

### Microsoft Sentinel

Microsoft Sentinel is a scalable, cloud-native security information and event management (SIEM) and security orchestration, automation, and response (SOAR) platform. Microsoft Sentinel supports ingesting and analyzing logs from any source, including on-premises systems, Azure, Microsoft 365, partner SaaS applications, and AWS. Microsoft Sentinel provides advanced threat detection, investigation, proactive hunting, and automated response capabilities.

For AWS environments, Microsoft Sentinel collects a broad array of AWS security data and stores it in its analytics engine. It runs cloud-scale queries and applies machine learning to detect malicious patterns. Microsoft Sentinel aligns with Zero Trust principles by continuously monitoring and analyzing telemetry under an assume-breach mindset. It automatically triggers response actions to contain incidents rapidly.

- **Unified visibility and analytics:** Microsoft Sentinel supports a range of AWS logs. You can use the Microsoft-published AWS Sentinel Solution (available in Content Hub), which includes predefined analytics rules and workbooks. This solution pulls AWS service logs into Microsoft Sentinel. The connector ingests logs from the following AWS services by pulling them from an Amazon S3 bucket.

  | Service | Data source |
  | - | - |
  | [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) | [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) |
  | [Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html) | [GuardDuty findings](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_finding-types-active.html) |
  | [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) | [Management](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html) and [data](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html) events |
  |[Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) | [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)|

  - After data ingestion, you can enable analytical rules. For example, you can set an alert if root-user activity occurs (which is rare and high risk in AWS) or escalate GuardDuty cryptocurrency-mining findings to incidents. Microsoft Sentinel can also detect machine learning-based anomalies across all logs.
  
  - Microsoft Sentinel enables cross-platform correlation when you bring AWS logs into the platform. For example, it can correlate an AWS CloudTrail event (like a new AWS IAM user creation) with a Microsoft Entra ID log (the same user signs in from a Tor IP address) and a Microsoft 365 event (the user downloads multiple files). Microsoft Sentinel analyzes these signals together to flag multistage attacks that span multiple systems.
  
    This unified view provides advantages in multicloud operations by ensuring complete visibility across your entire environment. Many AWS customers who use Microsoft 365 choose Microsoft Sentinel because it provides a single location to correlate Microsoft 365, Microsoft Entra ID, and AWS logs. Neither platform's native tools can provide this capability independently.
  
-  **Threat intelligence:** Microsoft Sentinel can integrate threat intelligence feeds to provide an extra layer of defense. You can match AWS log data, like source IP addresses in CloudTrail or Domain Name System (DNS) queries, against known malicious indicators. When Microsoft Sentinel identifies a match, like an AWS resource that communicates with a known malicious IP address, it generates an alert. This threat intelligence correlation helps detect threats that activity-based detection alone might miss.

- **Detection and hunting:** When logs reside in Microsoft Sentinel, you can use Kusto Query Language (KQL) to query AWS data alongside other logs. For example, you can search for AWS API calls by a user who fails Microsoft Entra ID sign-in attempts, which enables cross-platform threat investigations. Microsoft Sentinel built-in rule templates for AWS cover the following scenarios:

  - *Exfiltration patterns:* Sudden spikes in outgoing traffic in VPC Flow Logs after a new AWS IAM access key creation might indicate a stolen key used to download and exfiltrate large volumes of data.
  
  - *Persistence or privilege escalation:* An unusual source creates an AWS IAM user or access key, or the source changes security group rules to open normally closed ports.
  
  - *Brute force:* Multiple failed sign-in attempts to the AWS Management Console or an Amazon EC2 instance. Microsoft Sentinel detects these patterns from CloudTrail events for console sign-in failures and authentication logs on Linux instances.
  
  - *Response automation:* Microsoft Sentinel is a SIEM and SOAR platform, so you can trigger playbooks in Azure Logic Apps in response to AWS alerts.
  
    For example, Microsoft Sentinel might get an alert for a critical GuardDuty finding, like Amazon EC2 instance credential exfiltration. You can configure a playbook to respond to this alert by calling AWS APIs. The playbook uses Logic Apps connectors for AWS or an AWS Lambda function to isolate the compromised Amazon EC2 instance. The playbook isolates the instance by modifying the instance's security group or shutting it down. Another playbook can disable an AWS IAM user in AWS when it detects suspicious activity. This automation capability enables rapid response, which reinforces defense-in-depth security.
  
Microsoft Sentinel enables a uniform, orchestrated approach to incident response. For example, a single incident might involve disabling a user in Microsoft Entra ID and locking their AWS API keys. Microsoft Sentinel playbooks and the incident timeline can coordinate both actions.

For more information, see [Connect Microsoft Sentinel to AWS to ingest AWS service log data](/azure/sentinel/connect-aws?tabs=s3).

### Microsoft Defender XDR

Microsoft Defender XDR is a unified enterprise defense suite that provides integrated protection against sophisticated cyberattacks. It coordinates detection, prevention, investigation, and response across endpoints, identities, email, and applications. The solution centralizes threat tooling and uses advanced technologies like machine learning and threat intelligence to enhance security operations.

Automatic attack disruption is an autonomous response capability in Defender XDR. It stops active cyberattacks in real time with minimal human intervention. The capability limits attack impact by automatically isolating compromised assets and preventing lateral movement within the network. Automatic disruption includes the following key features:

- **Real-time containment:** When this feature detects a threat, it identifies and contains compromised user accounts, endpoints, sessions and tokens, threat infrastructure, and applications. This immediate containment protects against further exploitation.

- **Enhanced security for critical infrastructure:** Automatic attack disruption enhances security for essential infrastructure like Active Directory, DNS, and Dynamic Host Configuration Protocol (DHCP) servers. This feature selectively isolates critical assets while maintaining service availability. 

- **Cross platform detection:** The automatic attack disruption feature works with other Microsoft Defender products and extends beyond Defender XDR. It incorporates data from AWS, Proofpoint, and Okta through Microsoft Sentinel. The feature uses AI and millions of signals from Threat Intelligence to detect sophisticated threats across federated accounts and cloud boundaries. These threats include phishing, business email compromise, and identity compromise.

- **Visibility and control:** The Security Operations Center (SOC) maintains full visibility and control over all automatic actions. Defender XDR clearly tags and highlights incidents where automatic attack disruption is triggered. Analysts can view the details in Action Center to see the actions that the system takes, like which users the system disables and which devices it contains. The system logs every automated action, and you can undo actions or define exclusions. These safeguards balance speed with safety through high precision.

#### Automatic disruption for AWS

Automatic attack disruption reduces dwell time and minimizes business impact. By integrating telemetry from AWS, Proofpoint, and Okta, the feature lets security teams shift from reactive detection to proactive, cross-platform protection. This approach provides unified defense and reduces operational complexity. For more information, see [Automatic attack disruption in Defender XDR](/defender-xdr/automatic-attack-disruption).

### Microsoft Security Copilot

Microsoft Security Copilot is a generative AI-powered security assistant that works across the Microsoft security stack to help you defend multicloud environments, including AWS. It integrates with tools like Defender for Cloud, Microsoft Sentinel, and Microsoft Entra ID to access their data and capabilities. Security Copilot then applies intelligent analysis and automation to enhance your AWS security controls.

- **AI-augmented threat detection:** Security Copilot correlates signals and identifies complex attack patterns that span multiple systems. The Security Copilot Dynamic Threat Detection Agent can identify an ongoing AWS attack. For example, if a threat actor uses a compromised Microsoft Entra ID account to federate into an AWS admin role and begins exfiltrating data, Security Copilot can correlate the unusual Microsoft Entra ID sign-in behavior with AWS API activity from Microsoft Sentinel. It generates a proactive alert early in the attack sequence, so security teams can stop multistage attacks that siloed monitoring tools miss.

- **Rapid incident investigation:** When an AWS incident occurs, Security Copilot accelerates analysis by examining AWS CloudTrail events, configuration changes, and network logs that Microsoft Sentinel and Defender for APIs ingest. It presents a natural language summary, like *User X (privileged) from IP Y created an access key and downloaded data from Amazon S3 bucket Z at 3:45 AM.*

  Analysts can ask follow-up questions in natural language, like *Which Amazon S3 buckets did that user access?* Security Copilot dynamically queries the data and provides answers. This approach reduces the time and skill needed to interpret AWS logs. Junior analysts can investigate complex AWS scenarios without deep KQL or AWS knowledge because Security Copilot translates their questions into technical queries.

- **Step-by-step response guidance:** For confirmed threats or risks in AWS, Security Copilot provides actionable response steps based on Microsoft best practices and your organization's playbooks. For a comprised Amazon EC2 instance, Security Copilot might recommend isolating the VM, removing it from load balancers and security groups, creating an instance snapshot for forensics, and rotating exposed AWS IAM credentials.

- **Automated remediation and scripting:** Security Copilot generates remediation code in PowerShell, command-line interface (CLI) commands, or Terraform snippets to fix AWS security problems. For example, when you identify a public Amazon S3 bucket that violates policy, Security Copilot can produce an AWS CLI command. The command revokes public access or generates Terraform code to enforce the correct access settings.

  > [!NOTE]
  > AI-generated scripts provide a solid starting point but require review before implementation.

- **Natural language threat hunting:** Security Copilot lets you hunt for threats in AWS by using plain language. Instead of writing complex queries, you can prompt Security Copilot with requests like *Identify anomalous AWS Management Console sign-ins outside business hours this week.* This natural language interface makes threat hunting available to more team members, including people without expertise in query languages.

Security Copilot integrates with Defender for Cloud and Microsoft Sentinel to provide a unified view of AWS security data. It correlates signals across Microsoft security tools and AWS to detect threats, investigate incidents, and respond to attacks. For more information, see [Security Copilot](/copilot/security/microsoft-security-copilot).

### Security for AI

The Microsoft security stack protects AI workloads that run in AWS. The stack combines the following services:

- Microsoft Entra ID for identity control
- Defender for Cloud for infrastructure hardening
- Microsoft Sentinel for threat monitoring
- Microsoft Purview for data governance

These tools secure AI applications and autonomous agents across cloud environments.

- **Implement layered, defense-in-depth controls:** Use overlapping controls to protect AI deployments at all layers, like identity, code, infrastructure, network, and data layers.

- **Secure the AI development pipeline:** Apply the same security standards to your AI model training and DevOps pipeline that you apply to production environments. Use Azure DevOps or GitHub with Defender for Cloud DevOps Security to scan infrastructure as code (IaC) templates and code for secrets or misconfigurations before deployment. Use Defender for Containers to scan AI containers for vulnerabilities. Store keys and model weights in secure locations like Azure Key Vault. Use Python Risk Identification Tool (PyRIT) for generative AI to run red-teaming exercises and identify vulnerabilities in your AI applications. These measures prevent supply chain attacks and ensure that your AI deployment starts from a secure baseline.

- **Secure AI APIs:** Deploy Azure API Management and Azure Web Application Firewall in front of AWS endpoints to provide rate limiting, injection attack filtering, and integration with Microsoft security monitoring. Use Defender for Cloud API workload protections to monitor these APIs for abnormal usage patterns or sensitive data exposure in responses. For example, if an AI API unexpectedly returns chunks of training data, Defender for APIs flags this behavior as a policy violation. At the network level, send AWS API Gateway or AWS Application Load Balancer logs to Microsoft Sentinel. Microsoft Sentinel detects and correlates spikes or exploit attempts, like suspicious payloads designed for prompt injection attacks.

- **Monitor AI-specific threats and metrics:** Enable Defender for Cloud AI workload protection features to detect AI workloads, identify vulnerabilities, provide posture recommendations, and analyze attack paths. Defender for Cloud supports monitoring AWS Bedrock. Use Defender for Cloud Apps and Microsoft Sentinel to continuously monitor data access in AWS for comprehensive coverage.

- **Strengthen data governance and privacy:** Use Microsoft Purview governance features to scan and classify data before you use it to train or operate AI applications.

- **Appy consistent multicloud strategy:** Manage Azure and AWS under a unified security strategy. Use the same security policies, monitoring tools, and incident response procedures across both platforms. Avoid creating separate security teams or using disconnected tools for each cloud platform. This consistency reduces security gaps and operational complexity.

Microsoft security solutions integrate with AWS-native controls to provide defense-in-depth protection for AI applications. For more information, see [Defender for Cloud AI posture management](/azure/defender-for-cloud/ai-security-posture) and [Gain application and user context for AI alerts](/azure/defender-for-cloud/gain-end-user-context-ai).

### Recommendations

Use the Microsoft security solutions and basic AWS security recommendations to protect AWS accounts.

#### Basic AWS account security

For information about basic security hygiene for AWS accounts and resources, see [Best practices for securing AWS accounts and resources](https://repost.aws/knowledge-center/security-best-practices).

- Inspect all data transfers via the AWS Management Console to reduce the risk of uploading and downloading malware and other malicious content. Content that you upload or download directly to resources within the AWS platform, like web servers or databases, might need extra protection.

- Rotate access keys periodically. Avoid embedding access keys in code. Use AWS IAM roles instead of long-term access keys where possible.

- Configure security groups and network ACLs to control inbound and outbound traffic to your resources. Deploy resources in a virtual private cloud (VPC) to isolate them from the public internet.

- Enable encryption for data at rest and data in transit by using AWS Key Management Service.

- Protect devices that administrators and developers use to access the AWS Management Console.  

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Lavanya Murthy](https://www.linkedin.com/in/lavanyamurthy) | Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Monitor and protect AWS administrative and sign-in activities](/defender-cloud-apps/protect-aws)
- [Connect AWS accounts to Defender for Cloud](/azure/defender-for-cloud/quickstart-onboard-aws)
- [Connect Microsoft Sentinel to AWS to ingest AWS service log data](/azure/sentinel/connect-aws?tabs=s3)
- [AI threat protection](/azure/defender-for-cloud/ai-threat-protection)
- [Amazon S3 Multicloud Scanning Connector for Microsoft Purview](/purview/register-scan-amazon-s3)

## Related resource

- [Secure AWS identities](../../reference-architectures/aws/aws-azure-ad-security.yml) 
