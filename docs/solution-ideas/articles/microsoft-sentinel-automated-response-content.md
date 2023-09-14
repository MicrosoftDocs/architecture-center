[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Microsoft Sentinel is a scalable cloud solution for security information and event management (SIEM), and for security orchestration, automation, and response (SOAR). It delivers intelligent security analytics for enterprises of all sizes, and provides the following capabilities:

- Business attack detection
- Proactive hunting
- Threat response

Threat response is provided by Microsoft Sentinel playbooks. When a playbook is triggered by a Microsoft Sentinel alert or incident, the playbook runs a series of actions to counter the threat. The playbooks are built by using Azure Logic Apps.

Microsoft Sentinel includes many ready-to-use playbooks, including playbooks for these uses:

- Block an Azure Active Directory (Azure AD) user
- Block an Azure AD user based on an approve or reject email
- Post a message on the Microsoft Teams channel about an incident or alert
- Post a message on Slack
- Send an email that has incident or alert information
- Send an email that has a formatted incident report
- Confirm that an Azure AD user is at risk
- Send an adaptive card via Microsoft Teams to confirm that a user is compromised
- Isolate an endpoint on Microsoft Defender for Endpoint

This article shows an example of implementing a playbook to respond to a threat. The playbook blocks an Azure AD user that's compromised by suspicious activity.

## Potential use case

The techniques described in this article apply whenever you need to implement an automatic response to a detectable condition.

## Architecture

:::image type="content" border="false" source="../media/microsoft-sentinel-automated-response-architecture.svg" lightbox="../media/microsoft-sentinel-automated-response-architecture.svg" alt-text="Microsoft Sentinel architecture using playbooks.":::

Download a [Visio file](https://arch-center.azureedge.net/US-1938642-microsoft-sentinel-automated-response.vsdx) of this architecture.

### Workflow

This workflow shows the steps to deploy the playbook. Make sure that the [Prerequisites](#prerequisites) are satisfied before you start. For example, you need to choose an Azure AD user.

1. Follow the steps in [Send logs to Azure Monitor](/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-log-analytics#send-logs-to-azure-monitor) to configure Azure AD to send audit logs to the Log Analytics workspace that's used with Microsoft Sentinel.

   > [!NOTE]
   >
   > This solution doesn't use the audit logs, but you can use them to investigate what happens when the user is blocked.

1. Azure AD Identity Protection generates the alerts that trigger the threat response playbook to run. To have Microsoft Sentinel collect the alerts, navigate to your Microsoft Sentinel instance and select **Data Connectors**. Search for **Azure Active Directory Identity Protection** and enable the collecting of alerts. For more information about Identity Protection, see [What is Identity Protection?](/azure/active-directory/identity-protection/overview-identity-protection).
1. [Install the ToR browser](/azure/active-directory/identity-protection/howto-identity-protection-simulate-risk#anonymous-ip-address) onto a computer or virtual machine (VM) that you can use without putting your IT security at risk.
1. Use the Tor Browser to log in anonymously to My apps as the user that you selected for this solution. See [Anonymous IP address](/azure/active-directory/identity-protection/howto-identity-protection-simulate-risk#anonymous-ip-address) for instructions on using the Tor Browser to simulate anonymous IP addresses.
1. Azure AD authenticates the user.
1. Azure AD Identity Protection detects that the user used a ToR browser to log in anonymously. This type of login is suspicious activity that puts the user at risk. Identity Protection sends an alert to Microsoft Sentinel.
1. Configure Microsoft Sentinel to create an incident from the alert. See [Automatically create incidents from Microsoft security alerts](/azure/sentinel/create-incidents-from-alerts) for information on doing this. The Microsoft security analytics rule template to use is **Create incidents based on Azure Active Directory Identity Protection alerts**.
1. When Microsoft Sentinel triggers an incident, the playbook responds with actions that block the user.

### Components

- [Microsoft Sentinel](https://azure.microsoft.com/services/microsoft-sentinel) is a cloud-native SIEM and SOAR solution. It uses advanced AI and security analytics to detect and respond to threats across the enterprise. There are many playbooks on Microsoft Sentinel that you can use to automate your responses and protect your system.
- [Azure AD](https://azure.microsoft.com/services/active-directory) is a multi-tenant, cloud-based directory and identity management service that combines core directory services, application access management, and identity protection into a single solution. It can synchronize with on-premises directories. The identity service provides single sign-on, multifactor authentication, and conditional access to guard against cybersecurity attacks. The solution shown in this article uses Azure AD Identity Protect to detect suspicious activity by a user.
- [Logic Apps](https://azure.microsoft.com/services/logic-apps) is a serverless cloud service for creating and running automated workflows that integrate apps, data, services, and systems. Developers can use a visual designer to schedule and orchestrate common task workflows.  Logic Apps has [connectors](/connectors) for many popular cloud services, on-premises products, and other software as a service applications. In this solution, Logic Apps runs the threat response playbook.

## Considerations

- The Azure Well-Architected Framework is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).
- Microsoft Sentinel offers more than 50 playbooks that are ready for use. You can find them on the **Playbook templates** tab of the **Microsoft Sentinel|Automation** page for your workspace.
- [GitHub](https://github.com/azure/Azure-Sentinel/tree/master/Playbooks) has a variety of Microsoft Sentinel playbooks that are built by the community.

## Deploy this scenario

You can deploy this scenario by following the steps in [Workflow](#workflow) after making sure that the [Prerequisites](#prerequisites) are satisfied.

### Prerequisites

- [Prepare the software and choose a test user](#prepare-the-software-and-choose-a-test-user)
- [Deploy the playbook](#deploy-the-playbook)

#### Prepare the software and choose a test user

To implement and test the playbook, you'll need Azure and Microsoft Sentinel along with the following:

- An Azure AD Identity Protection license (Premium P2, E3, or E5).
- An Azure AD user. You can use either an existing user or [create a new user](/azure/active-directory/manage-apps/add-application-portal-assign-users). If you do create a new user, you can delete it when you're done using it.
- A computer or VM that can run a ToR browser. You'll use the browser to log in to the My Apps portal as your Azure AD user.

#### Deploy the playbook

To deploy a Microsoft Sentinel playbook, proceed as follows:

- If you don't have a Log Analytics workspace to use for this exercise, create a new one as follows:
  - Go to the [Microsoft Sentinel](https://ms.portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/microsoft.securityinsightsarg%2Fsentinel) main page, and select **+ Create** to get to the **Add Microsoft Sentinel to a workspace** page.
  - Select **Create a new workspace**. Follow the instructions to create the new workspace. After a short time, the workspace is created.
- At this point, you have a workspace, perhaps one that you just created. Use the following steps to see whether Microsoft Sentinel has been added to it, and to add it if not:
  - Go to the [Microsoft Sentinel](https://ms.portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/microsoft.securityinsightsarg%2Fsentinel) main page.
  - If Microsoft Sentinel has already been added to your workspace, the workspace appears in the displayed list. If it hasn't been added yet, add it as follows.
    - Select **+ Create** to get to the **Add Microsoft Sentinel to a workspace** page.
    - Select your workspace from the displayed list, and then select **Add** at the bottom of the page. After a short time, Microsoft Sentinel is added to your workspace.
- Create a playbook, as follows:
  - Go to the [Microsoft Sentinel](https://ms.portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/microsoft.securityinsightsarg%2Fsentinel) main page. Select your workspace. Select **Automation** from the left menu to get to the **Automation** page. This page has three tabs.
  - Select the **Playbook templates (Preview)** tab.
  - In the search field, enter **Block AAD user - Incident**.
  - In the list of playbooks, select **Block AAD user - Incident** and then select **Create playbook** in the bottom right corner to get to the **Create playback** page.
  - On the **Create playbook** page, do the following:
    - Select values for **Subscription**, **Resource group**, and **Region** from the lists.
    - Enter a value for **Playbook name** if you don't want to use the default name that appears.
    - If you want, select **Enable diagnostics logs in Log Analytics** to enable logs.
    - Leave the **Associate with integration service environment** checkbox unchecked.
    - Leave **Integration service environment** empty.
  - Select **Next: Connections >** to go to the **Connections** tab of **Create playbook**.
  - Choose how you will authenticate within the playbook’s components. Authentication is required for:
    - Azure AD
    - Microsoft Sentinel
    - Office 365 Outlook
    > [!NOTE]
    > You can authenticate the resources during playbook customization under the logic app resource if you wish to enable later. To authenticate the above resources at this point, you need permissions to update a user on Azure AD, and the user must have access to an email mailbox and must be able to send emails.
  - Select **Next: Review and create >** to get to the **Review and create** tab of **Create playbook**.
  - Select **Create and continue to designer** to create the playbook and access the **Logic app designer** page.

For more information about building logic apps, see [What is Azure Logic Apps](/azure/logic-apps/logic-apps-overview) and [Quickstart: Create and manage logic app workflow definitions](/azure/logic-apps/quickstart-create-logic-apps-visual-studio-code).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

Other contributors:

- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager
- [Lavanya Kasturi](https://www.linkedin.com/in/lakshmilavanyakasturi) | Technical Writer

## Next steps

- [Overview of Azure Cloud Services?](/azure/cloud-services/cloud-services-choose-me)
- [What is Microsoft Sentinel?](/azure/sentinel/overview)
- [Security orchestration, automation and response (SOAR) in Microsoft Sentinel.](/azure/sentinel/automation)
- [Automate threat response with playbooks in Microsoft Sentinel](/azure/sentinel/automate-responses-with-playbooks)
- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [What is Identity Protection?](/azure/active-directory/identity-protection/overview-identity-protection)
- [Simulating risk detections in Identity Protection](/azure/active-directory/identity-protection/howto-identity-protection-simulate-risk)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [Tutorial: Create automated approval-based workflows by using Azure Logic Apps](/azure/logic-apps/tutorial-process-mailing-list-subscriptions-workflow)
- [Introduction to Microsoft Sentinel](/training/modules/intro-to-azure-sentinel)

## Related resources

- [Threat indicators for cyber threat intelligence in Microsoft Sentinel](../../example-scenario/data/sentinel-threat-intelligence.yml)
- [Monitor hybrid security using Microsoft Defender for Cloud and Microsoft Sentinel](../../hybrid/hybrid-security-monitoring.yml)
- [Security architecture design](../../guide/security/security-start-here.yml)
