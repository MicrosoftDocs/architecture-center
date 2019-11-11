---
title: "Enable tracking and alerting for critical changes"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Enable tracking and alerting for critical changes
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: operate
---

# Enable tracking and alerting for critical changes

Azure Change Tracking and Inventory provides alerts on the configuration state of your hybrid environment and on any changes to that environment. You can monitor critical file, service, software, and registry changes that might affect your deployed servers.

By default, the Azure Automation inventory service doesn't monitor files or registry settings. The solution does provide a list of registry keys that we recommend for monitoring. To see this list, go to your Automation account in the Azure portal and select **Inventory** > **Edit Settings**:

![Screenshot of the Azure Automation Inventory view in the Azure portal](./media/change-tracking1.png)

For more information about each registry key, see [Registry key change tracking](/azure/automation/automation-change-tracking#registry-key-change-tracking). You can evaluate and then enable each key by selecting it. The setting is applied to all VMs enabled in the current workspace.

You can also track critical file changes. For example, you might want to track the C:\windows\system32\drivers\etc\hosts file because the OS uses it to map host names to IP addresses. Any changes to this file could cause connectivity problems or redirect traffic to dangerous websites.

To enable file content tracking for the hosts file, follow the steps in [Enable file content tracking](/azure/automation/change-tracking-file-contents#enable-file-content-tracking).

You can also add an alert for changes made to files that you're tracking. For example, say you want to set an alert for changes made to the hosts file. Start by going to Log Analytics by selecting **Log Analytics** on the command bar or by opening Log Search for the linked Log Analytics workspace. After you're in Log Analytics, search for content changes to the hosts file by using the following query:

```kusto
ConfigurationChange | where FieldsChanged contains "FileContentChecksum" and FileSystemPath contains "hosts"
```

![Screenshot of the Log Analytics query editor in the Azure portal](./media/change-tracking2.png)

This query searches for changes to the contents of files that have a path that contains the word “hosts.” You can also search for a specific file by changing the path parameter. (For example, `FileSystemPath ==  "c:\\windows\\system32\\drivers\\etc\\hosts"`.)
  
After the query returns the results, select **New alert rule** to open the alert rule editor. You can also get to this editor via Azure Monitor in the Azure portal.

In the alert rule editor, review the query and change the alert logic if you need to. In this case, we want the alert to be raised if any changes are detected on any machine in the environment.

![Screenshot of the Log Analytics alert rule editor in the Azure portal](./media/change-tracking3.png)

After you set the condition logic, you can assign action groups to perform actions in response to the alert. In this example, when the alert is raised, emails are sent and an ITSM ticket is created. You can take many other useful actions, like triggering an Azure function, an Azure Automation runbook, a webhook, or a logic app.

![Screenshot of the sample alert rule summary in the Azure portal](./media/change-tracking4.png)

After you've set all the parameters and logic, apply the alert to the environment.

## More tracking and alerting examples

Here are some other common scenarios for tracking and alerting that you might want to consider:

### Driver file changed

Detect if driver files are changed, added, or removed. Useful for tracking changes to critical system files.

  ```kusto
  ConfigurationChange | where ConfigChangeType == "Files" and FileSystemPath contains " c:\\windows\\system32\\drivers\\"
  ```

### Specific service stopped

Useful for tracking changes to system-critical services.

  ```kusto
  ConfigurationChange | where SvcState == "Stopped" and SvcName contains "w3svc"
  ```

### New software installed

Useful for environments that need to lock down software configurations.

  ```kusto
  ConfigurationChange | where ConfigChangeType == "Software" and ChangeCategory == "Added"
  ```

### Specific software version is or isn't installed on a machine

Useful for assessing security. Note that this query references `ConfigurationData`, which contains the logs for Inventory and reports the last reported configuration state, not changes.

  ```kusto
  ConfigurationData | where SoftwareName contains "Monitoring Agent" and CurrentVersion != "8.0.11081.0"
  ```

### Known DLL changed through registry

Useful for detecting changes to well-known registry keys.

  ```kusto
  ConfigurationChange | where RegistryKey == "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\KnownDlls"
  ```

## Next steps

Learn how to manage updates to your servers by [creating update schedules](./update-schedules.md) with Azure Automation.

> [!div class="nextstepaction"]
> [Create update schedules](./update-schedules.md)
