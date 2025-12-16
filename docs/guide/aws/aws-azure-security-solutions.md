---
metadata:
title: Microsoft Security for AWS
description: See how Microsoft security solutions can help secure and protect Amazon Web Services (AWS) account access and environments.
author: murthyla
ms.author: lmurthy
ms.date: 12/01/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Microsoft security solutions for AWS

This guide describes how Microsoft security solutions provide Zero Trust-aligned, defense-in-depth controls that you can extend to Amazon Web Services (AWS). These controls help remove blind spots and ensure consistent visibility, enforcement, and protection.

The following diagram summarizes how AWS installations can benefit from key Microsoft security components.

:::image type="content" border="false" source="media/aws-azure-security-solutions-content/aws-doc-diagram.png" alt-text="AWS doc diagram" lightbox="media/aws-azure-security-solutions-content/aws-doc-diagram.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/1985346*aws-azure-security-solutions-architecture.pptx) of this diagram.*

## Microsoft Entra

Microsoft Entra ID is a cloud-based centralized identity and access management solution that can help secure and protect AWS accounts and environments. Entra ID provides strong single sign-on (SSO) authentication to most apps and platforms that follow common web authentication standards, including AWS. AWS accounts that support critical workloads and highly sensitive information need strong identity protection and access control. Microsoft Entra ensures access to AWS resources is *verified explicitly* every time and *least privilege* is maintained. You can enhance AWS identity management when you combine it with Entra ID.

AWS organizations that use Entra ID for Microsoft 365 or hybrid cloud identity and access protection can quickly and easily deploy Entra ID for AWS accounts, often without incurring extra costs. 

Entra ID provides several capabilities for direct integration with AWS:

- **Centralized identities:** Combine Microsoft Entra federation with AWS IAM Identity Center to enforce *never trust, always verify* for AWS access. Entra ID enables enhanced security, improved user experience, centralized access control, and SSO across legacy, traditional, and modern authentication solutions.

- **Life cycle automation:** After you enable SSO, automate user life cycle management by using integrated HR workflows. Map Entra ID group memberships to AWS roles so that users automatically receive the appropriate AWS permissions based on their group assignments.

- **Enforce strong authentication:** Use Microsoft Entra Conditional Access to enforce the Zero Trust principle of verify explicitly for AWS sign-ins. You can require strong authentication by using Microsoft Entra multifactor authentication (MFA) or integrate with solutions from [Microsoft Intelligent Security Association](https://www.microsoft.com/security/business/intelligent-security-association) partners. For example, if you require MFA on every sign-in, Microsoft Entra evaluates each attempt against your policies and either prompts the user for extra authentication or rejects the attempt *before* granting access to AWS. This approach reduces the risk of account takeover. You can also enforce other factors like risk level, network location, and device compliance to ensure that only managed, healthy devices can access your AWS resources.

- **Microsoft Entra ID Protection:** Improve protection against identity-based attacks by implementing real-time detection, continuous risk assessment, and remediation of risky sign-ins and unusual user behavior. Combine Microsoft Entra ID Protection with Conditional Access policies to detect whether an account is associated with suspicious activities, like leaked credentials on the dark web, and automatically impose tighter controls or disable it.

- **Microsoft Entra Privileged Identity Management (PIM):** Enable just-in-time and least-privilege access to govern administrative access to AWS roles. These measures reduce standing access and limit exposure to attacks. Use PIM to assign users to an Microsoft Entra group that corresponds to an AWS admin role rather than directly granting admin permissions. That group membership can be "eligible" and only active when a particular user needs it. PIM logs and requires approval for activations. You can expand PIM to any delegated permission by controlling access to custom groups that you create for access to AWS roles.

- **Identity governance:** Extend Microsoft Entra governance features to AWS. Enable users to request AWS access by using Microsoft Entra ID access packages that have time-limited assignments and approval workflows. Do periodic access reviews to remove excess or standing access to reduce risk. These access reviews also simplify reporting and help demonstrate regulatory compliance.

- **Workload identities:** Use Microsoft Entra workload identity federation for AWS to issue short-lived tokens that AWS trusts for API access. This approach avoids static AWS access keys. It also integrates Entra ID with AWS IAM roles, so Azure-based workloads can assume AWS roles. This approach minimizes the risk of leaked credentials because it verifies every access request in real time and governs identities centrally.

  Use Microsoft Entra as the identity plane for AWS to achieve a unified identity security stance across your multi-cloud environment. Users have one identity, one strong authentication policy, and one centralized location where you can revoke access when they leave. This approach closes the gaps that siloed accounts create. For more information and detailed instructions, see [Microsoft Entra identity and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security).

### Microsoft Defender for Cloud Apps

Microsoft Defender for Cloud Apps provides enhanced protection for software as a service (SaaS) applications. It adds a dynamic layer of security on user activities and data in cloud applications. It provides the following features to help you monitor and protect your cloud app data:

- **Fundamental Cloud Access Security Broker functionality** including shadow IT discovery, visibility into cloud app usage, enhanced protection against app-based threats from anywhere in the cloud, and information protection and compliance assessments.

- **SaaS Security Posture Management features** that enable security teams to improve the organization's security posture.

- **Advanced threat protection** as part of the Microsoft extended detection and response solution, enables powerful correlation of signal and visibility across the full cyberattack chain of advanced attacks.

- **App-to-app protection** which extends the core threat scenarios to OAuth-enabled apps that have permissions and privileges to critical data and resources.

Connect AWS to Defender for Cloud Apps to help secure your assets and detect potential threats. This setup monitors administrative and sign-in activities and sends alerts about possible brute force attacks, malicious use of privileged user accounts, unusual virtual machine (VM) deletions, and publicly exposed storage buckets. Defender for Cloud Apps helps protect AWS environments from abuse of cloud resources, compromised accounts, insider threats, data leakage, resource misconfiguration, and insufficient access control. It enforces Zero Trust at the session and application level. After a user authenticates to AWS, it continues to monitor and validate their actions.

AWS with Defender for Cloud Apps provides the following benefits:

- **Visibility into activities:** Defender for Cloud Apps consolidates user and admin actions from AWS into a single activity log. You can filter and search across all cloud apps from one interface. For example, you can query "Show me all AWS console activities by user X in the last 24 hours." This capability supports investigations and provides input for anomaly detection.

- **Anomaly detection policies:** Defender for Cloud Apps continually monitors your users' activities and uses user and entity behavior analytics (UEBA) and machine learning to learn and understand the typical behavior of your users. It triggers alerts on deviations to [detect cloud threats, compromised accounts, malicious insiders, and ransomware](/defender-cloud-apps/best-practices). Consider the following examples of anomalies:

  - *Impossible travel:* A user signs in to AWS from the US and then 30 minutes later signs in from Russia. This activity indicates a compromised account and triggers an alert.
  
  - *Activity from a risky IP address or anonymous proxy:* A user typically accesses AWS from a known IP address range but suddenly connects from a The Onion Router (TOR) node.
  
  - *Unusual administrative activity:* A user deletes an unusual number of VMs or changes logging settings that they've never modified before.
  
  - *Mass downloads or deletions:* A user attempts to download a large number of objects from S3 or delete many resources in a short time span. This behavior can indicate sabotage or cleanup actions by an attacker.
  
  Each detected anomaly generates an alert in Defender for Cloud Apps. These behavior-based detections catch activities that signature-based detections miss.
  
- **Policy enforcement and governance:** Define policies that take automated action. You can create policies for specific scenarios, like *Alert and suspend user if they delete more than five EC2 instances within 10 minutes* or *If any S3 bucket is made public, notify the security team and optionally revert the access control list (ACL).* The platform includes file policies to detect when S3 buckets become publicly available and activity policies for critical changes, like identity and access management (IAM) or network ACL modifications. Many policies are available as templates that you can enable. MCAS can automatically remediate problems through API calls. These automated actions enforce security in near real-time and often mitigate problems faster than manual intervention. Consider the following example governance actions:

  - *Suspend user:* Disable the Entra ID user, which in turn blocks access to AWS via federation identity.
  
  - *Require re-authentication:* Sign the user out of AWS and force them to sign in again through Entra ID with MFA if the session is deemed risky.
  
  - *Notify user:* Send a pop-up or email to inform a user that their action violates policy, such as "You have violated policy by downloading 1,000 records from S3." This approach provides a gentle nudge for insiders or flags accidental policy violations.
  
  - *Make S3 bucket private:* Remove public access from an S3 bucket through the AWS API when a policy triggers.
  
  - *Remove collaborator:* Automatically remove an external collaborator, for example if someone shares an S3 bucket with an external account.
  
- **Session control (real-time intervention):** Conditional Access App Control routes user traffic through Defender for Cloud Apps and Conditional Access to actively block or monitor specific actions in real time. For example, if a user tries to download files from AWS on an unmanaged device, session control can prevent the download or display a warning message instead. The platform can also apply Microsoft Purview data loss prevention (DLP) policies to prevent data exfiltration, like blocking attempts to copy secret keys or specific patterns through the console.

For more information about connecting AWS environments to Defender for Cloud Apps, see [Protect your AWS environment](/defender-cloud-apps/protect-aws).

### Microsoft Defender for Cloud

Misconfigurations or vulnerabilities in cloud resources can expose your environment to bad actors. Microsoft Defender for Cloud is a Cloud-Native Application Protection Platform (CNAPP). It provides Microsoft Defender Cloud Security Posture Management (CSPM) and cloud workload protection platforms (CWPPs) for your AWS environment. It continuously scans for weaknesses and recommends fixes by using defense-in-depth controls. It also provides unified multicloud visibility into the security posture across Azure, AWS, and Google Cloud Platform (GCP).

Defender for Cloud provides the following capabilities:

- Defender CSPM is a configuration hygiene layer that surfaces actions that you can take to help prevent breaches. By reducing misconfigurations, you reduce the attack surface available to adversaries.

- A CWPP provides protection for servers, containers, storage, databases, DevOps, AI, and other workloads.

Defender for Cloud native AWS support provides the following benefits:

-  **Defender CSPM:** When you connect AWS accounts to Defender for Cloud, it immediately begins assessing your AWS resources against known best practices and benchmarks. It uses the Microsoft Cloud Security Benchmark (MCSB), which is a unified framework that includes controls for AWS. The assessment checks for common security problems, like public S3 buckets, IAM users without MFA, overly permissive security groups, and exposed Kubernetes dashboards on Amazon Elastic Kubernetes Service (EKS) clusters. Defender for Cloud reports each finding as a recommendation in the Azure portal. These recommendations contribute to a secure score that provides a quantifiable measure of your AWS security posture and compliance. 

  -  **Foundational CSPM:** Foundational CSPM provides a unified asset inventory, hardening recommendations for your AWS resources, and workflow automation to remediate misconfigurations. It includes visualization and reporting capabilities. These foundational multicloud CSPM capabilities are available at no cost.
  
  -  **Defender CSPM:** provides advanced posture management capabilities and agentless workload insights including critical assets.
  
    - *Cloud security graph and risk prioritization:* Uses AWS resource metadata, IAM roles, policies, and network to build exploitability context across AWS services, like EC2, S3, IAM, and VPC. Correlates the exploitability context with identities and permissions.
    
    - *Attack path analysis (APA):* Detects multi-step attack chains in AWS, such as when an attack progresses from a public EC2 instance through IAM role escalation to ultimately access an S3 bucket. Visualizes attack paths and provides *break-the-path* remediation for AWS-specific misconfigurations.
    
    - *Cloud Security Explorer:* Querys AWS posture by using graph-based filters, like *internet-exposed EC2 with attached IAM role granting S3 write*.
    
    - *Identity and permission exposure:* Evaluates AWS IAM roles, policies, and effective permissions. Highlights toxic combinations, like overly permissive roles and public exposure.
    
    - *Data Security Posture Management (DSPM):* Scans AWS S3 buckets and AWS RDS databases, like Aurora, PostgreSQL, MySQL, MariaDB, SQL Server, Oracle SE2, by using built-in classification rules.
    
    - *Multi-cloud attack path correlation:* Correlates AWS identities and resources with Azure and GCP to identify cross-cloud exploit chains. 
    
    - *Governance and compliance:* Tools to assess your [security compliance](/azure/defender-for-cloud/review-security-recommendations) with a wide range of benchmarks and regulatory standards. Microsoft provides built-in policies for AWS that cover standards like AWS Foundational Security Best Practices Standard and PCI-DSS and any custom security policies required in your organization, industry, or region to track AWS compliance state.
    
- **CWPPs:** In addition to posture management, Defender for Cloud provides workload protection plans for various AWS workloads:

  - **Servers (VMs on EC2):** When you enable Defender for Servers for an AWS account, Defender for Cloud onboards your EC2 instances (Windows or Linux) for advanced threat protection. This process includes an integrated license for Microsoft Defender for Endpoint. Onboarded VMs receive endpoint detection and response (EDR) capabilities, including file integrity monitoring, malware scanning, behavior monitoring, and vulnerability assessment. The vulnerability scanner reports OS and software vulnerabilities to Defender for Cloud. Defender for Endpoint reports endpoint threats, like ransomware behavior or suspicious process activity. Defender for Cloud displays all findings as security alerts. For more information, see [Defender for Servers](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-servers).
  
  -  **Containers:** Defender for Containers can protect Kubernetes clusters that run on AWS, including Amazon EKS. The protection works by deploying Azure Arc-enabled Kubernetes agents and the Defender extension to the cluster. Defender for Containers provides image vulnerability scanning for container images. It provides runtime threat detection for clusters, which identifies suspicious process activity in containers and crypto-mining operations. The solution monitors Kubernetes policy compliance and the Kubernetes control plane logs for suspicious events. For more information, see [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-aws-overview).
  
  - **Databases:** Defender for Cloud supports SQL servers that run on AWS EC2 and AWS RDS Custom. It provides capabilities for vulnerability assessment scanning, like checking for misconfigurations or missing patches. It also provides advanced threat protection for SQL, which detects anomalous queries and SQL injection attempts, and surfaces the alerts. For more information, see [Defender for SQL](/azure/defender-for-cloud/defender-for-sql-usage).
  
Defender for Cloud brings the *secure by design* philosophy to AWS through environment hardening, vulnerability management, and threat detection in one solution. For more information about protecting workloads in AWS, see [Connect your AWS account](/azure/defender-for-cloud/quickstart-onboard-aws) and [Assign regulatory compliance standards in Defender for Cloud](/azure/defender-for-cloud/update-regulatory-compliance-packages). 

### Microsoft Purview

Data is ultimately what attackers seek to steal and what you must protect for compliance. In a multi-cloud environment, data can reside anywhere, including Azure SQL databases, on-premises files, AWS S3 buckets, or AWS databases. Microsoft Purview provides a unified data governance solution that answers three critical questions: What data exists in AWS, where does the data reside, and how sensitive is the data? This information is crucial for a defense-in-depth approach because it informs the protective measures needed at the data layer, like encryption, DLP, and access controls. Microsoft Purview enables you to enforce Zero Trust principles for data. Microsoft Purview is also essential for regulatory compliance because it ensures that AWS data repositories meet the same compliance standards as Azure or on-premises environments through consistent classification and reporting.

- **Multi-cloud data discovery:** The Microsoft Purview multi-cloud scanning connectors extend its discovery capabilities to AWS.

  For example, you can register an AWS S3 bucket as a data source in Microsoft Purview and perform a scan. The scanner reads object metadata and content. It uses the Microsoft Purview built-in classification rules, which include over 200 detectors for sensitive information like credit card numbers, Social Security numbers, and API keys. The scanner identifies sensitive information within the objects but doesn't copy the data. It only retrieves metadata and classification results, which Microsoft Purview stores in its Data Map. The scan might report: "Bucket: s3://my-finance-data/ contains 3 files classified as Privacy/Personal Data, detected UK National Insurance Numbers."
  
  Microsoft Purview can also scan Amazon RDS databases, like RDS for PostgreSQL or SQL Server. It connects and runs queries to retrieve schemas and sample data for classification.

-  **Data catalog and governance:** Microsoft Purview onboards all discovered AWS data assets into the Microsoft Purview Data Catalog alongside your other data assets. Data stewards and compliance officers can use a single portal to search for data. For example, they can search for *customer data* and find results in both Azure Data Lake Storage and AWS buckets. You can uniformly apply business glossary terms and sensitivity labels across all assets. This consistency is crucial for compliance. It demonstrates to auditors that you inventory and label all personal data across clouds.

- **Risk management:** Understand what sensitive data exists in AWS so that you can implement targeted security measures. For example, if Microsoft Purview finds credit card numbers in an S3 bucket, you can encrypt or move the data. You can also set up a Defender for Cloud Apps policy to monitor access to that bucket more closely. You can run Microsoft Purview scans on a schedule to detect changes. This approach provides continuous Data Security Posture Management (DSPM). It highlights where sensitive data exists in AWS and whether you enable proper controls.

- **Integration with broader security:** Microsoft Purview surfaces the sensitive data identified in Defender for Cloud and Defender for Cloud Apps to provide extra context for posture management and addressing alerts.

- **Compliance reporting:** For frameworks like GDPR and California Consumer Privacy Act (CCPA), Microsoft Purview Compliance Manager generates reports that show where you store personal data, including AWS locations. These reports make it easier to answer data subject requests and do impact assessments. Instead of manually searching AWS for data, you query Microsoft Purview as your centralized inventory. For PCI compliance, Microsoft Purview helps you identify all locations of cardholder data in AWS so that you can implement proper segmentation.

Microsoft Purview for AWS extends your data governance across clouds. At the deepest layer—the data itself—you gain insight and control over your sensitive information. Microsoft Purview provides compliance evidence to demonstrate that you identify and secure sensitive data regardless of where it resides. It also enables you to make informed decisions about applying extra security controls. For more information, see [Amazon S3 Multicloud Scanning Connector for Microsoft Purview](/purview/register-scan-amazon-s3).

### Microsoft Sentinel

Microsoft Sentinel is a scalable, cloud-native Security Information and Event Management (siem) and security orchestration, automation, and response (SOAR) platform. Microsoft Sentinel supports ingesting and analyzing logs from any source, including on-premises systems, Azure, Microsoft 365, partner SaaS applications, and AWS. Microsoft Sentinel provides advanced threat detection, investigation, proactive hunting, and automated response capabilities.

For AWS environments, Microsoft Sentinel collects a broad array of AWS security data and stores it in its analytics engine. It runs cloud-scale queries and applies machine learning to detect malicious patterns. Microsoft Sentinel aligns with Zero Trust principles by continuously monitoring and analyzing telemetry under an assume-breach mindset. It automatically triggers response actions to contain incidents rapidly.

- **Unified visibility and analytics:** Microsoft Sentinel supports a range of AWS logs. You can use the Microsoft-published **AWS Sentinel Solution** (available in Content Hub), which includes predefined analytics rules and workbooks. This solution pulls AWS service logs into Microsoft Sentinel. The connector ingests logs from the following AWS services by pulling them from an S3 bucket:

  - After ingestion, you can enable analytical rules. For example, you can set an alert if root user usage occurs (rare and high risk in AWS) or escalate GuardDuty cryptocurrency mining findings to incidents. Microsoft Sentinel can also detect machine learning-based anomalies across all logs.
  
  - Microsoft Sentinel enables cross-platform correlation when you bring AWS logs into the platform. For example, Microsoft Sentinel can correlate an AWS CloudTrail event (like a new IAM user creation) with an Entra ID log (the same user signs in from a TOR IP address) and a Microsoft 365 event (the user downloads multiple files). Microsoft Sentinel analyzes these signals together to flag multi-stage attacks that span multiple systems.
  
    This unified view provides advantages in multi-cloud operations by ensuring complete visibility across your entire environment. Many AWS customers who use Microsoft 365 choose Microsoft Sentinel because it provides a single location to correlate Microsoft 365, Entra ID, and AWS logs—a capability that neither platform's native tools can provide independently.
  
|Service|Data source|
|-|-|
|[Amazon Virtual Private Cloud (VPC)](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) | [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)|
| [Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html) | [GuardDuty findings](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty*findings.html)|
|[AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) | [Management](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html) and [data](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html) events|
|[AWS CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) | [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)|

-  **Leverage threat intelligence:** Microsoft Sentinel can integrate threat intel (TI) feeds. You can match AWS logs (say, source IPs in CloudTrail or DNS queries from AWS if you ingest DNS logs) against known malicious indicators. If a match occurs (AWS resource communicating with a known bad IP), raise an alert. This cross-check adds another layer of defense (threat intel layer). 

- **Detection and hunting:** Once logs are in Microsoft Sentinel, analysts can use **KQL (Kusto Query Language)** to query AWS data alongside other logs. For instance, one could search for any AWS API calls by a user that also had failed Entra ID logins – a hypothetical query across two data types. Microsoft Sentinel's built-in rule templates for AWS cover scenarios like:

  - **Exfiltration patterns:** sudden spikes in outgoing traffic in VPC Flow Logs after a new IAM access key creation (could indicate a stolen key being used to mass-download data and exfiltrate).
  
  - **Persistence or Privilege Escalation:** creation of an IAM user or access key by an unusual source, or changes to security group rules (opening ports that are normally closed).
  
  - **Brute force:** multiple failed login attempts to the AWS Console or to an EC2 instance (from CloudTrail events for AWS console login failures or analyzing authentication logs on Linux).
  
  - **Response automation:** Microsoft Sentinel is a SIEM and SOAR platform which means you can trigger Playbooks (Logic Apps) on AWS alerts. For example, if Microsoft Sentinel gets an alert of "Critical GuardDuty finding: EC2 instance credential exfiltration," you could have a playbook that automatically calls AWS APIs (using Azure's AWS connectors or via an AWS Lambda) to isolate that EC2 instance (e.g., by modifying its security group or shutting it down). Another playbook could disable an IAM user in AWS if suspicious activity is detected. This automation ability is crucial for reacting quickly – bridging back to defense-in-depth,
  
By responding to incidents from Microsoft Sentinel, you ensure a uniform, orchestrated approach – e.g., a single incident might involve disabling a user in Entra ID and locking their AWS API keys; Microsoft Sentinel playbooks and its incident timeline can coordinate both.

For more information on how to install and configure the AWS connector in Microsoft Sentinel, see [Connect Microsoft Sentinel to Amazon Web Services to ingest AWS service log data](/azure/sentinel/connect-aws?tabs=s3)

### Microsoft Defender XDR

Microsoft Defender XDR is a unified enterprise defense suite that provides integrated protection against sophisticated cyberattacks. It coordinates detection, prevention, investigation, and response across endpoints, identities, email, and applications, ensuring comprehensive security for organizations. This solution centralizes threat tooling and utilizes advanced technologies like machine learning and threat intelligence to enhance security operations.

Automatic attack disruption is an autonomous response capability in Microsoft Defender XDR designed to stop active cyberattacks in real time with minimal human intervention. This capability aims to limit the impact of attacks by automatically isolating compromised assets and preventing lateral movement within the network. Key features of automatic disruption include:

- **Real-time containment:** The feature automatically identifies and contains compromised user accounts, endpoints, session and token disruption, threat infrastructure, application as soon as a threat is detected, providing immediate protection against further exploitation.

- **Enhanced security for critical infrastructure:** Updates to the automatic attack disruption capabilities have improved security for essential services like Active Directory, DNS, and DHCP servers, allowing for selective isolation of critical assets while maintaining service availability. 

- **Cross platform detection:** The automatic attack disruption feature works in conjunction with other Microsoft Defender products and extends beyond XDR, incorporating data from AWS, Proofpoint and Okta when brought in through Microsoft Sentinel. By leveraging millions of signals from Microsoft Threat Intelligence, this feature uses AI to detect sophisticated threats like phishing, business email compromise, and identity compromise across federated accounts and cloud boundaries.

- **Visibility and control:** Even though the actions are automatic, the SOC remains in full control and informed. Defender XDR clearly tags and highlights incidents where attack disruption was triggered. Analysts can click in to see exactly what was done: which users were disabled, which devices contained, etc., via Action Center. Every automated action is logged and can be undone with a single click if needed and provides the ability to define exclusions. These safeguards, along with the high precision, are meant to balance speed with safety.

#### Automatic disruption for AWS

![attack disruption](media/aws-azure-security-solutions-content/attack-disruption.png)

Automatic attack disruption reduces dwell time and minimizing business impact. Integrating telemetry from AWS, Proofpoint, and Okta, security teams can transition from reactive detection to proactive, cross-platform protection, ensuring cohesive defense and lowering operational complexity. For more Information see - [Automatic attack disruption in Microsoft Defender XDR](/defender-xdr/automatic-attack-disruption)

### Microsoft Security Copilot

Microsoft Security Copilot is a generative AI-powered security assistant that works across Microsoft's security stack to help organizations defend multi-cloud environments including AWS at machine speed. It integrates with tools like Microsoft Defender for Cloud, Microsoft Sentinel, and Entra ID to draw on their data and capabilities, layering intelligent analysis and automation on top of your AWS security controls.

- **AI-augmented threat detection:** Security Copilot excels at correlating signals and spotting complex attack patterns that span multiple systems. Security Copilot's Dynamic Threat Detection Agent can identify an ongoing AWS attack. For instance,  if a threat actor uses a compromised Entra ID account to federate into an AWS admin role and start exfiltrating data, Security Copilot can correlate unusual sign-in behavior from Entra ID  with AWS API activity (via Microsoft Sentinel) and generate a proactive alert before the intruder fully completes a single sign-on, effectively stopping the attack in real-time to catch multi-stage attacks in AWS that would evade siloed alerts.

- **Rapid incident investigation:** When an AWS-related incident occurs, Security Copilot can drastically speed up analysis by combing through AWS CloudTrail events, config changes, network logs, and more (as ingested by Microsoft Sentinel/Defender) and present a natural language summary of what happened – e.g., *"User X (privileged) from IP Y created an access key and downloaded data from S3 bucket Z at 3:45 AM"*. Analysts can ask follow-up questions in plain English ("*Which S3 buckets were accessed by that user?*") and Copilot will dynamically query the data to answer. This reduces the time and skill needed to interpret AWS logs or pivot across consoles. Junior analysts can investigate complex AWS scenarios without deep KQL or AWS knowledge – Security Copilot translates their intent into the technical queries.

- **Step-by-step response guidance:** For confirmed threats or risks in AWS, Security Copilot provides actionable response steps grounded in Microsoft's best practices and any playbooks your organization has provided, it will outline containment and remediation measures. For example, if an EC2 instance is compromised, Security Copilot might recommend steps like "isolate VM by removing from load balancers and security groups, then trigger instance snapshot for forensics" followed by "rotate any exposed IAM credentials". 

- **Automated remediation and scripting:** Beyond guidance, Security Copilot can assist with the actual fixes. It can generate PowerShell, CLI commands, or Terraform snippets to remediate issues in AWS. For instance, if a policy violation is detected (like an S3 bucket made public), Copilot might produce an AWS CLI command to revoke public access or a Terraform code change to enforce the correct setting. This capability saves time.

> [!NOTE]
> AI-generated scripts provide a solid starting point but require review before implemenatation.

- **Natural language threat hunting:** Security Copilot allows analysts to hunt for threats in AWS using plain language. Instead of writing complex queries, an analyst can prompt Security Copilot with requests like *"Identify any anomalous AWS console logins outside business hours this week".* This lowers the barrier for proactive threat hunting in AWS and empowers broader use of your AWS security data,

Security Copilot acts as a force-multiplier for your SOC when dealing with AWS incidents. By deeply integrating with Defender for Cloud and Microsoft Sentinel, it breaks down multi-cloud data silos and accelerates detection, accelerates investigation, and accelerates response. For more information, see - [Microsoft Security Copilot](/copilot/security/microsoft-security-copilot)

### Security for AI

Microsoft's security stack can extend protection to AI workloads running in AWS. By unifying identity control, hardening cloud infrastructure, monitoring threats, and governing sensitive data, you can secure AI applications and autonomous agents in multi-cloud environments.

- **Implement Layered, Defense-in-Depth Controls:** Protect AI deployments at all layers – identity, code, infrastructure, network, data – using overlapping controls.

- **Secure the AI Development Pipeline:** Treat the AI model training and DevOps pipeline with the same rigor as production. Use Azure DevOps or GitHub with Defender for Cloud's DevOps Security to scan IaC templates and code for secrets or misconfigurations before deployment. Ensure AI containers are scanned for vulnerabilities with Defender for Containers. Store keys and model weights securely. This prevents supply chain attacks and ensures the AI agent starts in a secure state. Leverage PyRIT for red teaming and hardening AI Apps.

- **Secure AI APIs:** Azure's API Management (APIM) and Web Application Firewall (WAF) can be used even in front of AWS endpoints to provide rate limiting, injection attack filtering, and integration with Microsoft security monitoring. Additionally, Microsoft's Defender for Cloud's API workload protections can monitor these APIs for abnormal usage patterns or sensitive data exposure in responses. For instance, if an AI API unexpectedly returns chunks of training data, Defender for APIs can flag that as a policy violation. At the network level, ensure AWS API Gateway or ALB logs feed into Microsoft Sentinel so that any spikes or exploit attempts (like suspicious payloads aimed at prompt injections) are detected and correlated with other signals.

- **Monitor AI-Specific Threats and Metrics:** Enable Defender for Cloud's AI workload protection features to detect AI workloads, vulnerabilities, posture recommendations, and attack path analysis. Defender for Cloud supports monitoring of AWS Bedrock. Continuously monitors data access in AWS through Defender for Cloud Apps and Microsoft Sentinel for comprehensive monitoring.

- **Strengthen Data Governance and Privacy:** Before using data with AI Apps, use Purview governance features to identify sensitive data.

- **Consistent Multi-Cloud Strategy:** Manage Azure and AWS under a single security strategy. Avoid siloed teams or tools and reduce gaps with multi cloud security.

By leveraging Microsoft security solutions in tandem with native controls, organizations can confidently run AI applications on AWS with enterprise-grade protections. For more information see – [Defender AI Posture Management](/azure/defender-for-cloud/ai-security-posture) and [Defender for AI](/azure/defender-for-cloud/gain-end-user-context-ai)

### Recommendations

Use the Microsoft security solutions and basic AWS security recommendations to protect AWS accounts.

#### Basic AWS account security

For information about basic security hygiene for AWS accounts and resources, see the AWS security guidance at [Best practices for securing AWS accounts and resources](https://aws.amazon.com/premiumsupport/knowledge-center/security-best-practices).

- Reduce the risk of uploading and downloading malware and other malicious content by actively inspecting all data transfers via the AWS Management Console. Content that you upload or download directly to resources within the AWS platform, such as web servers or databases, might need additional protection.

- Provide security for access keys by rotating the keys periodically. Avoid embedding them in code. Use IAM roles instead of long-term access keys wherever possible.

- Use security groups and network ACLs to control inbound and outbound traffic to your resources. Implement VPC to isolate resources.

- Encrypt sensitive data at rest and in transit by using AWS Key Management Services.

- Protect devices that administrators and developers use to access the AWS Management Console.  

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Lavanya Murthy](https://www.linkedin.com/in/lavanyamurthy) | Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Monitor and protect AWS administrative and sign-in activities](/defender-cloud-apps/protect-aws)
- [Protect workloads in AWS](/azure/defender-for-cloud/quickstart-onboard-aws)
- [Connect Microsoft Sentinel to AWS to ingest AWS service log data](/azure/sentinel/connect-aws?tabs=s3)
- [AI threat protection](/azure/defender-for-cloud/ai-threat-protection)
- [Microsoft Purview scanning for Amazon S3](/purview/register-scan-amazon-s3)

## Related resources

- [Secure AWS identities](../../reference-architectures/aws/aws-azure-ad-security.yml) 
