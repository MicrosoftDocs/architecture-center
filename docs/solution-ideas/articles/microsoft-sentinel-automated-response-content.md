Microsoft Sentinel is the cloud-native Security information and event management (SIEM) and Security orchestration, automation and response (SOAR) solution that delivers intelligent security analytics for enterprises of all sizes. It provides business attack detection, proactive hunting, and threat response as a scalable and integrated solution for several partner solutions.

The following are the examples of automated responses based on the playbooks available from Microsoft Sentinel:

- Block an Azure AD user based on an approve or reject email
- Post a message on the Microsoft Teams channel about an incident or alert
- Post a message on Slack channel about an incident or alert
- Send an email with incident or alert information
- Send an email with a formatted incident report
- Confirm Azure AD user at risk
- Send an adaptive card using Microsoft Teams to confirm that a user is compromised
- Isolate an endpoint on Microsoft Defender for Endpoint

You can deploy a variety of playbooks that are built by the Github community using Microsoft Sentinel.

## Potential use case

This article shows how to deploy a specific Sentinel playbook that blocks an Azure Active Directory (AAD) user. The playbook runs on a simulation where an Azure AD user is compromised by suspicious activity. You can test this playbook on ToR browser with an anonymous login on My Apps.

This is useful because you don’t have to deploy automation on Microsoft Sentinel and wait for automated response to be executed. Also, by testing your automation as you deploy it, you can discover and correct problems.

## Architecture

:::image type="content" source="../media/microsoft-sentinel-architecture-azure.png" lightbox="../media/microsoft-sentinel-architecture-azure.png" alt-text="Microsoft sentinel architecture using playbooks.":::

Download a [Visio file](https://arch-center.azureedge.net/microsoft-sentinel-playbook.vsdx) of this architecture.

### Workflow

You can either use an existing Azure AD user or [create a new user](/azure/active-directory/manage-apps/add-application-portal-assign-users) for this exercise.

1. Set up your Azure AD to send audit logs to the Log Analytics workspace used with Microsoft Sentinel.

    > [!NOTE]
    >
    > You can use the audit logs to investigate the blocked Azure AD user account in this exercise.

2. To collect the alerts created by Azure AD Identity protection on Microsoft Sentinel, navigate to the main service menu and select **Data Connectors**. Then, search for *Azure Active Directory Identity Protection* and enable the collection. Remember to ingest the alerts on Sentinel.

3. Install the ToR browser in a VM, server, or laptop that you can use without putting your IT security at risk.

Instructions for running the exercise:

- Log in to Microsoft My Apps and authenticate using Azure AD user selected for this exercise.

- Azure AD Identity protection detects that the user is using a ToR browser that executes an anonymous login. This type of login is a suspicious activity that puts the user at risk. Now, Sentinel is triggered with an alert.

- To transform the Azure AD Identity protection alert that is sent to Sentinel into an incident, navigate to the main menu Analytics and enable an Analytic query - *Create incidents based on Azure Active Directory Identity Protection alerts* on the Sentinel.

- When the Sentinel triggers an *incident*, the playbook starts its workflow with actions that blocks the user under risk on Azure AD.

Below are the step-by-step instructions to deploy the Sentinel playbook **Block AAD user - Incident**.

- Go to [Microsoft Sentinel](https://ms.portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/microsoft.securityinsightsarg%2Fsentinel) main page, and select *+ Create* to add Microsoft Sentinel to a workspace. You can also use existing workspaces in the list and select *Add* to create a new workspace.
- You can select the newly created workspace or choose an existing workspace.
- Navigate to the left menu and select *Automation*.
- Select the “Playbook template (Preview)” tab.
- In the search field, search using *Block AAD user - Incident* keyword.
- In the list displayed, select Block AAD user - Incident playbook and choose “Create playbook” in the bottom right corner.
- On the *Create playbook* page that opens up, fill in the following fields:
    - Select subscription, resource group, and region from the dropdown.
    - You can use the default playbook name or use a new name for your playbook.
    - It is optional to select the checkbox for *Enable diagnostics logs in Log Analytics* to enable logs.
    - You can leave the checkbox for *Associate with integration service environment* unchecked.
    - You can leave *Integration service environment* without any selection.
- Select the Next button.
- In the **Connections** page, choose how you will authenticate within the playbook’s components.

Authentication is required for:

• Azure AD
• Microsoft Sentinel
• Office 365 Outlook

> [!NOTE]
> You can authenticate the above resources during playbook customization under the logic app resource if you wish to enable later.
> If you decide to authenticate the above resources during this configuration, you'll need permissions to update a user on Azure AD, and use the user that has access to an email box and send emails.

- Review the information provided and select *Create and continue to designer.*
- The Logic App page is opened.

> [!NOTE]
>
> Sentinel playbook is an Azure Logic App.

- On the left menu, select *Logic app designer* and then expand every element on the screen to explore all the actions based on the initial trigger - *When Azure Sentinel incident creation rule was triggered.*

For more information to build a Logic App from scratch, you can refer to [Create Logic App](/azure/logic-apps/quickstart-create-logic-apps-visual-studio-code)

Below are the prerequisites and components for the architecture diagram that you can use as a reference to implement and test the playbook in action.

### Prerequisites

To implement and run the Sentinel playbook to block a user on Azure AD, you'll need Azure and Microsoft Sentinel running on your machine along with the following:

- Azure AD identity protection license (Premium P2 or E3, E5).
- Collect alerts from Azure AD identity protection on Microsoft Sentinel.
- Enable analytics query to transform an Azure AD identity protection alert into Sentinel incident.
- A virtual machine or a computer that can run a ToR browser to log in with an Azure AD user on Microsoft My Apps.
- An Azure AD user created for test purposes.

### Components

The solution uses the following components.

- [Microsoft Sentinel](https://azure.microsoft.com/en-us/services/microsoft-sentinel/) is part of Azure Security. Its a security solution that delivers intelligent security analytics and threat intelligence. There are several playbooks available on Microsoft Sentinel to automate your responses and protect your system.

- [Azure Active Directory](https://azure.microsoft.com/en-us/services/active-directory/) is a cloud-based identity and access management service that help employees access external resources. This exercise uses Azure Active Directory to detect suspicious activity from a user.

- [Azure Logic Apps](https://azure.microsoft.com/en-us/services/logic-apps/) is a cloud-based platform to create and run automated workflows. You can use Logic apps to explore the actions based on triggers generated in the Microsoft Sentinel.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal authors:**

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523/) | Senior Customer Engineer

**Other contributors:**

- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan/) | Senior Customer Engineering Manager

- [Lavanya Kasturi](https://www.linkedin.com/in/lakshmilavanyakasturi/) | Technical Writer

## Next steps

- [Overview of Azure Cloud Services?](/azure/cloud-services/cloud-services-choose-me)

- [What is Microsoft Sentinel?](/azure/sentinel/overview)

- [Security Orchestration, automation and response (SOAR) in Microsoft Sentinel.](/azure/sentinel/automation)

- [Automate threat response with playbooks in Microsoft Sentinel](/azure/sentinel/automate-responses-with-playbooks)

- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)

- [What is Identity Protection?](/azure/active-directory/identity-protection/overview-identity-protection)

- [Simulating risk detections in Identity Protection](/azure/active-directory/identity-protection/howto-identity-protection-simulate-risk)

- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)

- [Tutorial: Create automated approval-based workflows by using Azure Logic Apps](/azure/logic-apps/tutorial-process-mailing-list-subscriptions-workflow)

- [Introduction to Microsoft Sentinel](/learn/modules/intro-to-azure-sentinel/)

## Related resources

- [Threat indicators for cyber threat intelligence in Microsoft Sentinel](../../example-scenario/data/sentinel-threat-intelligence.yml)

- [Hybrid security monitoring using Microsoft Defender for Cloud and Microsoft Sentinel](../../hybrid/hybrid-security-monitoring.yml)

- [Security architecture design](../../guide/security/security-start-here.yml)