[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Microsoft Sentinel is a scalable cloud-based solution for security information and event management (SIEM) and security orchestration, automation, and response (SOAR). It offers intelligent security analytics for organizations of all sizes and provides the following capabilities and more:

- Business attack detection
- Proactive hunting
- Automated incident response

Threat response in Microsoft Sentinel is managed via playbooks. When triggered by an alert or incident, a playbook runs a series of automated actions to counter the threat. You create these playbooks are by using Azure Logic Apps.

Microsoft Sentinel provides hundreds of ready-to-use playbooks, including playbooks for the following scenarios:

- Blocking a Microsoft Entra user
- Blocking a Microsoft Entra user based on rejection via email
- Posting a message in a Microsoft Teams channel about an incident or alert
- Posting a message on Slack
- Sending an email with incident or alert details
- Sending an email with a formatted incident report
- Determining whether a Microsoft Entra user is at risk
- Sending an adaptive card via Microsoft Teams to determine whether a user is compromised
- Isolating an endpoint via Microsoft Defender for Endpoint

This article includes an example of implementing a playbook that responds to a threat by blocking a Microsoft Entra user that's compromised by suspicious activity.

## Potential use case

The techniques described in this article apply whenever you need to implement an automatic response to a detectable condition.

## Architecture

:::image type="content" border="false" source="../media/microsoft-sentinel-automated-response-architecture.svg" lightbox="../media/microsoft-sentinel-automated-response-architecture.svg" alt-text="Microsoft Sentinel architecture using playbooks.":::

Download a [Visio file](https://arch-center.azureedge.net/US-1938642-microsoft-sentinel-automated-response.vsdx) of this architecture.

### Workflow

This workflow shows the steps to deploy the playbook. Make sure that the [Prerequisites](#prerequisites) are satisfied before you start. For example, you need to choose a Microsoft Entra user.

1. Follow the steps in [Send logs to Azure Monitor](/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs#send-logs-to-azure-monitor) to configure Microsoft Entra ID to send audit logs to the Log Analytics workspace that's used with Microsoft Sentinel.

   > [!NOTE]
   >
   > This solution doesn't use the audit logs, but you can use them to investigate what happens when the user is blocked.

1. Microsoft Entra ID Protection generates the alerts that trigger the threat response playbook to run. To have Microsoft Sentinel collect the alerts, navigate to your Microsoft Sentinel instance and select **Data Connectors**. Search for **Microsoft Entra ID Protection** and enable the collecting of alerts. For more information about Identity Protection, see [What is Identity Protection?](/entra/id-protection/overview-identity-protection).
1. [Install the ToR browser](/entra/id-protection/howto-identity-protection-simulate-risk#simulate-an-anonymous-ip-address) onto a computer or virtual machine (VM) that you can use without putting your IT security at risk.
1. Use the Tor Browser to sign in anonymously to My apps as the user that you selected for this solution. See [Anonymous IP address](/entra/id-protection/howto-identity-protection-simulate-risk#simulate-an-anonymous-ip-address) for instructions on using the Tor Browser to simulate anonymous IP addresses.
1. Microsoft Entra authenticates the user.
1. Microsoft Entra ID Protection detects that the user used a ToR browser to sign in anonymously. This type of sign-in is suspicious activity that puts the user at risk. Identity Protection sends an alert to Microsoft Sentinel.
1. Configure Microsoft Sentinel to create an incident from the alert. For more information, see [Automatically create incidents from Microsoft security alerts](/azure/sentinel/create-incidents-from-alerts). The Microsoft security analytics rule template to use is **Create incidents based on Microsoft Entra ID Protection alerts**.
1. When Microsoft Sentinel triggers an incident, the playbook responds with actions that block the user.

### Components

- [Microsoft Sentinel](/azure/sentinel/overview) is a cloud-native SIEM and SOAR solution. It uses advanced AI and security analytics to detect and respond to threats across the enterprise. There are many playbooks on Microsoft Sentinel that you can use to automate your responses and protect your system.
- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based directory and identity management service that combines core directory services, application access management, and identity protection into a single solution. It can synchronize with on-premises directories. The identity service provides single sign-on, multifactor authentication, and Conditional Access to guard against cybersecurity attacks. The solution shown in this article uses Microsoft Entra identity Protect to detect suspicious activity by a user.
- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a serverless cloud service for creating and running automated workflows that integrate apps, data, services, and systems. Developers can use a visual designer to schedule and orchestrate common task workflows. Azure Logic Apps has [connectors](/connectors) for many popular cloud services, on-premises products, and other software-as-a-service applications. In this solution, Azure Logic Apps runs the threat response playbook.

## Considerations

- The Azure Well-Architected Framework is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).
- Microsoft Sentinel offers more than 50 playbooks that are ready for use. You can find them on the **Playbook templates** tab of the **Microsoft Sentinel|Automation** page for your workspace.
- [GitHub](https://github.com/azure/Azure-Sentinel/tree/master/Playbooks) has various Microsoft Sentinel playbooks that are built by the community.

## Deploy this scenario

You can deploy this scenario by following the steps in [Workflow](#workflow) after making sure that the [Prerequisites](#prerequisites) are satisfied.

### Prerequisites

- [Prepare the software and choose a test user](#prepare-the-software-and-choose-a-test-user)
- [Deploy the playbook](#deploy-the-playbook)

#### Prepare the software and choose a test user

To implement and test the playbook, you need Azure and Microsoft Sentinel along with the following prerequisites:

- A Microsoft Entra ID Protection license (Premium P2, E3, or E5).
- A Microsoft Entra user. You can use either an existing user or [create a new user](/entra/identity/enterprise-apps/add-application-portal-assign-users). If you do create a new user, you can delete it when you're done using it.
- A computer or VM that can run a ToR browser. You'll use the browser to sign in to the My Apps portal as your Microsoft Entra user.

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
  - In the search field, enter **Block Microsoft Entra user - Incident**.
  - In the list of playbooks, select **Block Microsoft Entra user - Incident** and then select **Create playbook** in the bottom right corner to get to the **Create playback** page.
  - On the **Create playbook** page, do the following steps:
    - Select values for **Subscription**, **Resource group**, and **Region** from the lists.
    - Enter a value for **Playbook name** if you don't want to use the default name that appears.
    - If you want, select **Enable diagnostics logs in Log Analytics** to enable logs.
  - Select **Next: Connections >** to go to the **Connections** tab of **Create playbook**.
  - Choose how to authenticate within the playbook's components. Authentication is required for:
    - Microsoft Entra ID
    - Microsoft Sentinel
    - Office 365 Outlook
    > [!NOTE]
    > You can authenticate the resources during playbook customization under the logic app resource if you wish to enable later. To authenticate the above resources at this point, you need permissions to update a user on Microsoft Entra ID, and the user must have access to an email mailbox and must be able to send emails.
  - Select **Next: Review and create >** to get to the **Review and create** tab of **Create playbook**.
  - Select **Create and continue to designer** to create the playbook and access the **Logic app designer** page.

For more information about building logic apps, see [What is Azure Logic Apps](/azure/logic-apps/logic-apps-overview) and [Quickstart: Create and manage logic app workflow definitions](/azure/logic-apps/quickstart-create-logic-apps-visual-studio-code).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Azure Security Engineer

Other contributors:

- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager
- [Lavanya Kasturi](https://www.linkedin.com/in/lakshmilavanyakasturi) | Technical Writer

## Related content

- [Overview of Azure Cloud Services?](/azure/cloud-services/cloud-services-choose-me)
- [What is Microsoft Sentinel?](/azure/sentinel/overview)
- [Security orchestration, automation, and response (SOAR) in Microsoft Sentinel.](/azure/sentinel/automation)
- [Automate threat response with playbooks in Microsoft Sentinel](/azure/sentinel/automate-responses-with-playbooks)
- [What is Microsoft Entra ID?](/entra/fundamentals/whatis)
- [What is Identity Protection?](/entra/id-protection/overview-identity-protection)
- [Simulating risk detections in Identity Protection](/entra/id-protection/howto-identity-protection-simulate-risk)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [Tutorial: Create automated approval-based workflows by using Azure Logic Apps](/azure/logic-apps/tutorial-process-mailing-list-subscriptions-workflow)
- [Introduction to Microsoft Sentinel](/training/modules/intro-to-azure-sentinel)

## Related resource

- [Security architecture design](../../guide/security/security-start-here.yml)
