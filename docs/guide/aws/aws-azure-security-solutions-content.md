This guide shows how Microsoft Defender for Cloud Apps and Microsoft Sentinel can help secure and protect Amazon Web Services (AWS) account access and environments.

AWS organizations that use Azure Active Directory (Azure AD) for Microsoft 365 or hybrid cloud identity and access protection can quickly and easily [deploy Azure AD for AWS accounts](../../reference-architectures/aws/aws-azure-ad-security.yml), often without additional cost.

## Architecture

This diagram summarizes how AWS installations can benefit from key Microsoft security components:

:::image source="./media/aws-azure-security-solutions-architecture.png" alt-text="Architecture diagram that shows the benefits of implementing Azure security for AWS." border="false" lightbox="./media/aws-azure-security-solutions-architecture.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/1985346_aws-azure-security-solutions-architecture.pptx) of this architecture.*

### Workflow

- Azure AD provides centralized *single sign-on (SSO)* and strong authentication through *multifactor authentication* and the *conditional access* feature. Azure AD supports AWS role-based identities and authorization for access to AWS resources. For more information and detailed instructions, see [Azure AD identity and access management for AWS](../../reference-architectures/aws/aws-azure-ad-security.yml). Microsoft Entra Permissions Management is a *cloud infrastructure entitlement management (CIEM)* product that provides comprehensive visibility and control over permissions for any AWS identity or resource. You can use Entra Permissions Management to:

  - Get a multi-dimensional view of your risk by assessing identities, permissions, and resources.
  - Automate the enforcement of the [least privilege](https://wikipedia.org/wiki/Principle_of_least_privilege) policy in your entire multicloud infrastructure.
  - Use anomaly and outlier detection to prevent data breaches that are caused by misuse and malicious exploitation of permissions.

  For more information and detailed onboarding instructions, see [Onboard an Amazon Web Services (AWS) account](/azure/active-directory/cloud-infrastructure-entitlement-management/onboard-aws).

- Defender for Cloud Apps:
  - Integrates with the Azure AD conditional access feature to enforce additional restrictions.
  - Helps monitor and protect sessions after sign-in.
  - Uses *user behavior analytics (UBA)* and other AWS APIs to monitor sessions and users and to support information protection.

- Defender for Cloud displays AWS security recommendations in the Defender for Cloud portal together with Azure recommendations. Defender for Cloud offers more than 160 out-of-the-box recommendations for infrastructure as a service (IaaS) and platform as a service (PaaS) services. It also provides support for regulatory standards, including Center for Internet Security (CIS) and payment card industry (PCI) standards, and for the AWS Foundational Security Best Practices standard. Defender for Cloud also provides cloud workload protection (CWP) for [Amazon EKS clusters](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-containers?tabs=aws-eks), [AWS EC2 instances](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-servers?tabs=features-multicloud), and [SQL servers that run on AWS EC2](/azure/defender-for-cloud/defender-for-sql-introduction).

- Microsoft Sentinel integrates with Defender for Cloud Apps and AWS to detect and automatically respond to threats. Microsoft Sentinel monitors the AWS environment for misconfiguration, potential malware, and advanced threats to AWS identities, devices, applications, and data.

### Components

- [Microsoft Defender for Cloud Apps](https://www.microsoft.com/en-us/security/business/siem-and-xdr/microsoft-defender-cloud-apps)
- [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel)
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory)

### Defender for Cloud Apps for visibility and control

When several users or roles make administrative changes, a consequence can be *configuration drift* away from intended security architecture and standards. Security standards can also change over time. Security personnel must constantly and consistently detect new risks, evaluate mitigation options, and update security architecture to prevent potential breaches. Security management across multiple public cloud and private infrastructure environments can become burdensome.

[Defender for Cloud Apps](/cloud-app-security/what-is-cloud-app-security) is a *cloud access security broker (CASB)* platform with *cloud security posture management (CSPM)* capabilities. Defender for Cloud Apps can connect to multiple cloud services and applications to collect security logs, monitor user behavior, and impose restrictions that the platforms themselves might not offer.

Defender for Cloud Apps provides several capabilities that can integrate with AWS for immediate benefits:

- The Defender for Cloud Apps app connector uses several AWS APIs, including UBA, to search for configuration issues and threats on the AWS platform.
- AWS Access Controls can enforce sign-in restrictions that are based on application, device, IP address, location, registered ISP, and specific user attributes.
- Session Controls for AWS block potential malware uploads or downloads based on Microsoft Defender Threat Intelligence or real-time content inspection.
- Session controls can also use real-time content inspection and sensitive data detection to impose *data loss prevention (DLP)* rules that prevent cut, copy, paste, or print operations.

Defender for Cloud Apps is available standalone, or as part of Microsoft Enterprise Mobility + Security E5, which includes Azure AD Premium P2. For pricing and licensing information, see [Enterprise Mobility + Security pricing options](https://www.microsoft.com/microsoft-365/enterprise-mobility-security/compare-plans-and-pricing).

### Defender for Cloud for CSPM and CWP platforms (CWPP)

With cloud workloads commonly spanning multiple cloud platforms, cloud security services must do the same. Defender for Cloud helps protect workloads in Azure, AWS, and Google Cloud Platform (GCP).

Defender for Cloud provides an agentless connection to your AWS account. Defender for Cloud also offers plans to secure your AWS resources:

- The [Defender for Cloud overview page](/azure/defender-for-cloud/overview-page) displays CSPM metrics, alerts, and insights. Defender for Cloud assesses your AWS resources according to [AWS-specific security recommendations](/azure/defender-for-cloud/recommendations-reference-aws) and incorporates your security posture into your secure score. The [asset inventory](/azure/defender-for-cloud/asset-inventory) provides a single place to view all your protected AWS resources. The [regulatory compliance dashboard](/azure/defender-for-cloud/regulatory-compliance-dashboard) reflects the status of your compliance with built-in standards that are specific to AWS. Examples include AWS CIS standards, PCI data security standards (PCI-DSS), and the AWS Foundational Security Best Practices standard.
- [Microsoft Defender for Servers](/azure/defender-for-cloud/defender-for-servers-introduction) brings threat detection and advanced defenses to [supported Windows and Linux EC2 instances](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-servers?tabs=features-windows).
- [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) brings threat detection and advanced defenses to [supported Amazon EKS clusters](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-containers?tabs=azure-aks).
- [Microsoft Defender for SQL](/azure/defender-for-cloud/defender-for-sql-introduction) brings threat detection and advanced defenses to your SQL servers that run on AWS EC2 and AWS RDS Custom for SQL Server.

### Microsoft Sentinel for advanced threat detection

Threats can come from a wide range of devices, applications, locations, and user types. DLP requires inspecting content during upload or download, because post-mortem review might be too late. AWS doesn't have native capabilities for device and application management, risk-based conditional access, session-based controls, or inline UBA.

It's critical that security solutions reduce complexity and deliver comprehensive protection regardless of whether resources are in multicloud, on-premises, or hybrid environments. Defender for Cloud provides CSPM and CWP. Defender for Cloud identifies configuration weak spots across AWS to help strengthen your overall security posture. It also helps provide threat protection for Amazon EKS Linux clusters, AWS EC2 instances, and SQL servers in AWS EC2.

[Microsoft Sentinel](/azure/sentinel) is a *security information and event management (SIEM)* and *security orchestration, automation, and response (SOAR)* solution that centralizes and coordinates threat detection and response automation for modern security operations. Microsoft Sentinel can monitor AWS accounts to compare events across multiple firewalls, network devices, and servers. Microsoft Sentinel combines monitoring data with threat intelligence, analytics rules, and machine learning to discover and respond to advanced attack techniques.

You can connect AWS and Defender for Cloud Apps with Microsoft Sentinel. Then you can see Defender for Cloud Apps alerts and run additional threat checks that use multiple Defender Threat Intelligence feeds. Microsoft Sentinel can initiate a coordinated response that's outside Defender for Cloud Apps. Microsoft Sentinel can also integrate with IT service management (ITSM) solutions and retain data on a long-term basis for compliance purposes.

## Scenario details

Microsoft offers several security solutions that can help secure and protect Amazon Web Services (AWS) accounts and environments.

Other Microsoft security components can integrate with Azure AD to provide additional security for AWS accounts:

- Microsoft Defender for Cloud Apps backs up Azure AD with session protection and user-behavior monitoring.
- Microsoft Defender for Cloud provides threat protection to AWS workloads. It also helps proactively strengthen security for AWS environments and uses an agentless approach to connect to those environments.
- Microsoft Sentinel integrates with Azure AD and Defender for Cloud Apps to detect and automatically respond to threats against AWS environments.

These Microsoft security solutions are extensible and offer multiple levels of protection. You can implement one or more of these solutions along with other types of protection for a full-security architecture that helps protect current and future AWS deployments.

### Potential use cases

This article provides AWS identity architects, administrators, and security analysts with immediate insights and detailed guidance for deploying several Microsoft security solutions.

## Recommendations

Keep the following points in mind when you develop a security solution.

### Security recommendations

The following principles and guidelines are important for any cloud security solution:

- Ensure that the organization can monitor, detect, and automatically protect user and programmatic access into cloud environments.
- Continually review current accounts to ensure identity and permission governance and control.
- Follow least privilege and [zero trust](https://www.microsoft.com/security/business/zero-trust) principles. Make sure that users can access only the specific resources that they require, from trusted devices and known locations. Reduce the permissions of every administrator and developer to provide only the rights that they need for the role that they perform. Review regularly.
- Continuously monitor platform configuration changes, especially if they provide opportunities for privilege escalation or attack persistence.
- Prevent unauthorized data exfiltration by actively inspecting and controlling content.
- Take advantage of solutions that you might already own, like Azure AD Premium P2, that can increase security without additional expense.

#### Basic AWS account security

To ensure basic security hygiene for AWS accounts and resources:

- Review the AWS security guidance at [Best practices for securing AWS accounts and resources](https://aws.amazon.com/premiumsupport/knowledge-center/security-best-practices).
- Reduce the risk of uploading and downloading malware and other malicious content by actively inspecting all data transfers through the AWS Management Console. Content that you upload or download directly to resources within the AWS platform, such as web servers or databases, might need additional protection.
- Consider protecting access to other resources, including:
  - Resources created within the AWS account.
  - Specific workload platforms, like Windows Server, Linux Server, or containers.
  - Devices that administrators and developers use to access the AWS Management Console.

## Deploy this scenario

Take the steps in the following sections to implement a security solution.

### Plan and prepare

To prepare for deployment of Azure security solutions, review and record current AWS and Azure AD account information. If you've deployed more than one AWS account, repeat these steps for each account.

1. In the [AWS Billing Management Console](https://console.aws.amazon.com/billing/home?#/account), record the following current AWS account information:
   - **AWS Account ID**, a unique identifier
   - **Account name**, or root user
   - **Payment method**, whether assigned to a credit card or a company billing agreement
   - **Alternate contacts** who have access to AWS account information
   - **Security questions**, securely updated and recorded for emergency access
   - **AWS regions** that are enabled or disabled to comply with data security policy

1. In the [Azure AD portal](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview), review the Azure AD tenant:
   - Assess **Tenant information** to see whether the tenant has an Azure AD Premium P1 or P2 license. A P2 license provides [advanced Azure AD identity management](../../reference-architectures/aws/aws-azure-ad-security.yml#advanced-azure-ad-identity-management-with-aws-accounts) features.
   - Assess **Enterprise applications** to see whether any existing applications use the AWS application type, as shown by `http://aws.amazon.com/` in the **Homepage URL** column.

### Deploy Defender for Cloud Apps

After you deploy the central management and strong authentication that modern identity and access management require, you can implement Defender for Cloud Apps to:

- Collect security data and carry out threat detections for AWS accounts.
- Implement advanced controls to mitigate risk and prevent data loss.

To deploy Defender for Cloud Apps:

1. Add a Defender for Cloud Apps app connector for AWS.
1. Configure Defender for Cloud Apps monitoring policies for AWS activities.
1. Create an enterprise application for SSO to AWS.
1. Create a conditional access app control application in Defender for Cloud Apps.
1. Configure Azure AD session policies for AWS activities.
1. Test Defender for Cloud Apps policies for AWS.

#### Add an AWS app connector

1. In the [Defender for Cloud Apps portal](https://portal.cloudappsecurity.com), expand **Investigate** and then select **Connected apps**.

1. On the **App connectors** page, select the **Plus Sign (+)** and then select **Amazon Web Services** from the list.

1. Use a unique name for the connector. In the name, include an identifier for the company and specific AWS account, for example *Contoso-AWS-Account1*.

1. Follow the instructions at [Connect AWS to Microsoft Defender for Cloud Apps](/cloud-app-security/connect-aws-to-microsoft-cloud-app-security) to create an appropriate AWS identity and access management (IAM) user.
   1. Define a policy for restricted permissions.
   1. Create a service account to use those permissions on behalf of the Defender for Cloud Apps service.
   1. Provide the credentials to the app connector.

The time it takes to establish the initial connection depends on the AWS account log sizes. When the connection is complete, you see a connection confirmation:

:::image type="content" source="media/connect-app.png" alt-text="Screenshot of the Defender for Cloud Apps portal. Information about an AWS connector is visible with a status of Connected.":::

#### Configure Defender for Cloud Apps monitoring policies for AWS activities

After you turn on the app connector, Defender for Cloud Apps shows new templates and options in the policy configuration builder. You can create policies directly from the templates and modify them for your needs. You can also develop a policy without using the templates.

To implement policies by using the templates:

1. In the Defender for Cloud Apps left navigation window, expand **Control** and then select **Templates**.

   :::image type="content" source="media/template-menu.png" alt-text="Screenshot of the Defender for Cloud Apps left navigation window with Templates called out.":::

1. Search for **aws** and review the available policy templates for AWS.

   :::image type="content" source="media/policy-template.png" alt-text="Screenshot of AWS template data on the Policy templates page. A plus sign next to a template and the Name box, which contains aws, are called out.":::

1. To use a template, select the **Plus Sign (+)** to the right of the template item.

1. Each policy type has different options. Review the configuration settings and save the policy. Repeat this step for each template.

   :::image type="content" source="media/create-policy.png" alt-text="Screenshot of the Create file policy page, with various options visible.":::

   To use file policies, make sure the file monitoring setting is turned on in Defender for Cloud Apps settings:

   :::image type="content" source="media/file-monitoring.png" alt-text="Screenshot of the File section of the Defender for Cloud Apps settings page. The Enable file monitoring option is selected.":::

As Defender for Cloud Apps detects alerts, it displays them on the **Alerts** page in the Defender for Cloud Apps portal:

:::image type="content" source="media/alerts.png" alt-text="Screenshot of the Defender for Cloud Apps portal. Six alerts are visible.":::

#### Create an enterprise application for SSO to AWS

Follow the instructions at [Tutorial: Azure Active Directory single sign-on (SSO) integration with AWS single sign-on](/azure/active-directory/saas-apps/aws-single-sign-on-tutorial?WT.mc_id=wwc_spark) to create an enterprise application for SSO to AWS. Here's a summary of the procedure:

1. Add AWS SSO from the gallery.
1. Configure and test Azure AD SSO for AWS SSO:
   1. Configure Azure AD SSO.
   1. Configure AWS SSO.
   1. Create an AWS SSO test user.
   1. Test SSO.

#### Create a conditional access app control application in Defender for Cloud Apps

1. Go to the [Defender for Cloud Apps portal](https://portal.cloudappsecurity.com), select **Investigate**, and then select **Connected apps**.

   :::image type="content" source="media/investigate-connected-apps.png" alt-text="Screenshot of the Defender for Cloud Apps portal. On the left bar, Investigate is called out. In the Investigate menu, Connected apps is called out.":::

1. Select **Conditional Access App Control apps**, and then select **Add**.

   :::image type="content" source="media/add-conditional-access-app-control-app.png" alt-text="Screenshot of the Connected apps page in the Defender for Cloud Apps portal. Conditional Access App Control Apps and Add are called out.":::

1. In the **Search for an app** box, enter **Amazon Web Services**, and then select the application. Select **Start wizard**.

   :::image type="content" source="media/add-saml-application-start-wizard-button.png" alt-text="Screenshot of the Add a SAML application with your identity provider page. A Start wizard button is visible.":::

1. Select **Fill in data manually**. Enter the **Assertion consumer service URL** value that's shown in the following screenshot, and then select **Next**.

   :::image type="content" source="media/turn-on-manual-data-entry.png" alt-text="Screenshot of the Add a SAML application with your identity provider page. A URL box and an option for manually entering data are visible.":::

1. On the next page, ignore the **External configuration** steps. Select **Next**.

   :::image type="content" source="media/external-configuration-steps.png" alt-text="Screenshot of the Add a SAML application with your identity provider page. Under External configuration, three steps are visible.":::

1. Select **Fill in data manually**, and then take the following steps to enter the data:
   1. Under **Single sign-on service URL**, enter the **Login URL** value for the enterprise application that you created for AWS.
   1. Under **Upload identity provider's SAML certificate**, select **Browse**.
   1. Locate the certificate for the enterprise application that you created.
   1. Download the certificate to your local device, and then upload it to the wizard.
   1. Select **Next**.

   :::image type="content" source="media/enter-sso-url-certificate.png" alt-text="Screenshot that shows the SSO service URL and certificate boxes. Arrows indicate where to find values for those boxes in other screens.":::

1. On the next page, ignore the **External configuration** steps. Select **Next**.

   :::image type="content" source="media/external-configuration-steps-identity-provider-steps.png" alt-text="Screenshot of the Add a SAML application with your identity provider page. Under External configuration, four steps are visible.":::

1. On the next page, ignore the **External configuration** steps. Select **Finish**.

   :::image type="content" source="media/external-configuration-steps-app-changes-steps.png" alt-text="Screenshot of the Add a SAML application with your identity provider page. Under External configuration, five steps are visible.":::

1. On the next page, ignore the **Verify your settings** steps. Select **Close**.

   :::image type="content" source="media/verify-settings.png" alt-text="Screenshot of the Add a SAML application with your identity provider page. Under Verify your settings, two steps are visible.":::

#### Configure Azure AD session policies for AWS activities

Session policies are a powerful combination of Azure AD conditional access policies and the reverse proxy capability of Defender for Cloud Apps. These policies provide real-time suspicious behavior monitoring and control.

1. In Azure AD, create a new conditional access policy with the following settings:
   - Under **Name**, enter **AWS Console – Session Controls**.
   - Under **Users and Groups**, select the two role groups that you created earlier:
     - **AWS-Account1-Administrators**
     - **AWS-Account1-Developers**
   - Under **Cloud apps or actions**, select the enterprise application that you created earlier, such as **Contoso-AWS-Account 1**.
   - Under **Session**, select **Use Conditional Access App Control**.

1. Under **Enable policy**, select **On**.

   :::image type="content" source="media/session-controls.png" alt-text="Screenshot of the AWS Console - Session Controls page with settings configured as described in the article and the Enable policy section called out.":::

1. Select **Create**.

After you create the Azure AD conditional access policy, set up a Defender for Cloud Apps session policy to control user behavior during AWS sessions.

1. In the Defender for Cloud Apps portal, expand **Control** and then select **Policies**.

1. On the **Policies** page, select **Create policy** and then select **Session policy** from the list.

   :::image type="content" source="media/session-policy.png" alt-text="Screenshot of the Defender for Cloud Apps portal. Create policy is called out. In its list, Session policy is called out.":::

1. On the **Create session policy** page, under **Policy template**, select **Block upload of potential malware (based on Microsoft Threat Intelligence)**.

1. Under **Activities matching all of the following**, modify the activity filter to include **App**, **equals**, and **Amazon Web Services**. Remove the default device selection.

   :::image type="content" source="media/activity-source.png" alt-text="Screenshot of the Activity source section of the Create session policy page. A filter rule is visible for AWS apps.":::

1. Review the other settings, and then select **Create**.

#### Test Defender for Cloud Apps policies for AWS

Test all policies regularly to ensure that they're still effective and relevant. Here are a few recommended tests:

- IAM policy changes: This policy is triggered each time that you attempt to modify the settings within AWS IAM. For instance, when you follow the procedure later in this deployment section to create a new IAM policy and account, you see an alert.

- Console sign-in failures: Any failed attempts to sign in to one of the test accounts trigger this policy. The alert details show that the attempt came from one of the Azure regional datacenters.

- S3 bucket activity policy: When you attempt to create a new AWS S3 storage account and set it to be publicly available, you trigger this policy.

- Malware detection policy: If you configure malware detection as a session policy, you can test it by following these steps:
  1. Download a safe test file from the [European Institute for Computer Anti-Virus Research (EICAR)](https://www.eicar.org).
  1. Try to upload that file to an AWS S3 storage account.

  The policy immediately blocks the upload attempt, and an alert appears in the Defender for Cloud Apps portal.

### Deploy Defender for Cloud

You can use a native cloud connector to connect an AWS account to Defender for Cloud. The connector provides an agentless connection to your AWS account. You can use this connection to gather CSPM recommendations. By using Defender for Cloud plans, you can secure your AWS resources with CWP.

:::image type="content" source="media/defender-cloud-dashboard.png" alt-text="Screenshot of the Defender for Cloud dashboard. Metrics and charts are visible that show the secure score, inventory health, and other information.":::

To protect your AWS-based resources, take these steps, which the following sections describe in detail:

1. Connect an AWS account.
1. Monitor AWS.

#### Connect your AWS account

To connect your AWS account to Defender for Cloud by using a native connector, follow these steps:

1. Review the [prerequisites](/azure/defender-for-cloud/quickstart-onboard-aws?pivots=env-settings#prerequisites) for connecting an AWS account. Ensure that you complete them before you proceed.

1. If you have any classic connectors, remove them by following the steps in [Remove classic connectors](/azure/defender-for-cloud/quickstart-onboard-aws?pivots=env-settings#remove-classic-connectors). Using both the classic and native connectors can produce duplicate recommendations.

1. Sign in to the [Azure portal](https://portal.azure.com).

1. Select **Microsoft Defender for Cloud**, and then select **Environment settings**.

1. Select **Add environment** > **Amazon Web Services**.

   :::image type="content" source="media/defender-cloud-environment-settings-page.png" alt-text="Screenshot of the Defender for Cloud Environment settings page. Under Add environment, Amazon Web Services is called out.":::

1. Enter the details of the AWS account, including the storage location of the connector resource. Optionally, select **Management account** to create a connector to a management account. Connectors are created for each member account that's discovered under the provided management account. Auto-provisioning is turned on for all newly onboarded accounts.

   :::image type="content" source="media/defender-cloud-add-account-page.png" alt-text="Screenshot of the Add account page in the Defender for Cloud portal. Fields are visible for the connector name, location, and other data.":::

1. Select **Next: Select plans**.

   :::image type="content" source="media/defender-cloud-add-account-details.png" alt-text="Screenshot of the Select plans section of the Add account page. Plans are visible for security posture management, servers, and containers.":::

1. By default, the servers plan is turned on. This setting is necessary to extend Defender for Servers coverage to your AWS EC2. Ensure you've fulfilled the [network requirements for Azure Arc](/azure/azure-arc/servers/network-requirements?tabs=azure-cloud). Optionally, to edit the configuration, select **Configure**.

1. By default, the containers plan is turned on. This setting is necessary to have Defender for Containers protection for your AWS EKS clusters. Ensure you've fulfilled the [network requirements](/azure/defender-for-cloud/defender-for-containers-enable?pivots=defender-for-container-eks&source=docs&tabs=aks-deploy-portal%2Ck8s-deploy-asc%2Ck8s-verify-asc%2Ck8s-remove-arc%2Caks-removeprofile-api#network-requirements) for the Defender for Containers plan. Optionally, to edit the configuration, select **Configure**. If you disable this configuration, the threat detection feature for the control plane is disabled. To view a list of features, see [Defender for Containers feature availability](/azure/defender-for-cloud/supported-machines-endpoint-solutions-clouds-containers?tabs=azure-aks).

1. By default, the databases plan is turned on. This setting is necessary to extend Defender for SQL coverage to your AWS EC2 and RDS Custom for SQL Server. Optionally, to edit the configuration, select **Configure**. We recommend that you use the default configuration.

1. Select **Next: Configure access**.

1. Download the CloudFormation template.

1. Follow the on-screen instructions to use the downloaded CloudFormation template to create the stack in AWS. If you onboard a management account, you need to run the CloudFormation template as Stack and as StackSet. Connectors are created for the member accounts within 24 hours of onboarding.

1. Select **Next: Review and generate**.

1. Select **Create**.

Defender for Cloud immediately starts scanning your AWS resources. Within a few hours, you see security recommendations. For a list of all the recommendations Defender for Cloud can provide for AWS resources, see [Security recommendations for AWS resources - a reference guide](/azure/defender-for-cloud/recommendations-reference-aws).

#### Monitor your AWS resources

The Defender for Cloud security recommendations page displays your AWS resources. You can use the environments filter to take advantage of the multicloud capabilities of Defender for Cloud, such as viewing the recommendations for Azure, AWS, and GCP resources together.

To view all the active recommendations for your resources by resource type, use the Defender for Cloud asset inventory page. Set the filter to display the AWS resource type that you're interested in.

:::image type="content" source="media/defender-cloud-inventory-page.png" alt-text="Screenshot of the Defender for Cloud Inventory page. A table lists resources and their basic data. A filter for the resource type is also visible.":::

### Deploy Microsoft Sentinel

If you connect an AWS account and Defender for Cloud Apps to Microsoft Sentinel, you can use monitoring capabilities that compare events across multiple firewalls, network devices, and servers.

#### Enable the Microsoft Sentinel AWS connector

After you enable the Microsoft Sentinel connector for AWS, you can monitor AWS incidents and data ingestion.

As with the Defender for Cloud Apps configuration, this connection requires configuring AWS IAM to provide credentials and permissions.

1. In AWS IAM, follow the steps at [Connect Microsoft Sentinel to AWS CloudTrail](/azure/sentinel/connect-aws).

1. To complete the configuration in the Azure portal, under **Microsoft Sentinel** > **Data connectors**, select the **Amazon Web Services** connector.

   :::image type="content" source="media/aws-connector.png" alt-text="Screenshot of the Microsoft Sentinel Data connectors page that shows the Amazon Web Services connector.":::

1. Select **Open connector page**.

1. Under **Configuration**, enter the **Role ARN** value from the AWS IAM configuration in the **Role to add** field, and select **Add**.

1. Select **Next steps**, and then select the **AWS Network Activities** and **AWS User Activities** activities to monitor.

1. Under **Relevant analytic templates**, select **Create rule** next to the AWS analytic templates that you want to turn on.

1. Set up each rule, and select **Create**.

The following table shows the rule templates that are available for checking AWS entity behaviors and threat indicators. The rule names describe their purpose, and the potential data sources list the data sources that each rule can use.

| Analytic template name                                                 | Data sources                                                           |
|------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| Known IRIDIUM IP                                                       | DNS, Azure Monitor, Cisco ASA, Palo Alto Networks, Azure AD, Azure Activity, AWS |
| Full Admin policy created and then attached to Roles, Users, or Groups | AWS                                                                              |
| Failed AzureAD logons but success logon to AWS Console                 | Azure AD, AWS                                                                    |
| Failed AWS Console logons but success logon to AzureAD                 | Azure AD, AWS                                                                    |
| Multifactor authentication disabled for a user                         | Azure AD, AWS                                                                    |
| Changes to AWS Security Group ingress and egress settings              | AWS                                                                              |
| Monitor AWS Credential abuse or hijacking                              | AWS                                                                              |
| Changes to AWS Elastic Load Balancer security groups                   | AWS                                                                              |
| Changes to Amazon VPC settings                                         | AWS                                                                              |
| New UserAgent observed in last 24 hours                                | Microsoft 365, Azure Monitor, AWS                                                |
| Login to AWS Management Console without multifactor authentication     | AWS                                                                              |
| Changes to internet facing AWS RDS Database instances                  | AWS                                                                              |
| Changes made to AWS CloudTrail logs                                    | AWS                                                                              |
| Defender Threat Intelligence map IP entity to AWS CloudTrail           | Defender Threat Intelligence Platforms, AWS                                      |

Enabled templates have an **IN USE** indicator on the connector details page.

:::image type="content" source="media/templates.png" alt-text="Screenshot of the connector details page. A table lists templates that are in use and the severity, rule type, data sources, and tactics for each one.":::

#### Monitor AWS incidents

Microsoft Sentinel creates incidents based on the analyses and detections that you turn on. Each incident can include one or more events, which reduces the overall number of investigations that are necessary to detect and respond to potential threats.

Microsoft Sentinel shows incidents that Defender for Cloud Apps generates, if it's connected, and incidents that Microsoft Sentinel creates. The **Product names** column shows the incident source.

:::image type="content" source="media/incidents.png" alt-text="Screenshot of the Microsoft Sentinel Incidents page. A table lists basic data for incidents. A Product names column contains the incident source.":::

#### Check data ingestion

Check that data is continuously ingested into Microsoft Sentinel by regularly viewing the connector details. The following chart shows a new connection.

:::image type="content" source="media/data-ingestion.png" alt-text="Screenshot of AWS connector data. A line chart shows the amount of data the connector receives, with initial values at zero and a spike at the end.":::

If the connector stops ingesting data and the line chart value drops, check the credentials that you use to connect to the AWS account. Also check that AWS CloudTrail can still collect the events.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Lavanya Murthy](https://www.linkedin.com/in/lavanyamurthy) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For security guidance from AWS, see [Best practices for securing AWS accounts and resources](https://aws.amazon.com/premiumsupport/knowledge-center/security-best-practices).
- For the latest Microsoft security information, see [Microsoft Security](https://www.microsoft.com/security).
- For full details of how to implement and manage Azure AD, see [Securing Azure environments with Azure Active Directory](https://aka.ms/AzureADSecuredAzure).
- For an overview of AWS asset threats and corresponding protective measures, see [How Defender for Cloud Apps helps protect your Amazon Web Services (AWS) environment](/cloud-app-security/protect-aws).
- For information about connectors and how to establish connections, see these resources:
  - [Connect your AWS accounts to Microsoft Defender for Cloud](/azure/defender-for-cloud/quickstart-onboard-aws?pivots=env-settings)
  - [New AWS connector in Microsoft Defender for Cloud](/azure/defender-for-cloud/episode-one)
  - [Connect AWS to Microsoft Defender for Cloud Apps](/cloud-app-security/connect-aws-to-microsoft-cloud-app-security)
  - [Connect Microsoft Sentinel to AWS CloudTrail](/azure/sentinel/connect-aws)

## Related resources

- For in-depth coverage and comparison of Azure and AWS features, see the [Azure for AWS professionals](../../aws-professional/index.md) content set.
- For guidance for deploying Azure AD identity and access solutions for AWS, see [Azure AD identity and access management for AWS](../../reference-architectures/aws/aws-azure-ad-security.yml).
