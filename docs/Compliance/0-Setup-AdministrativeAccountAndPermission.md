# 0-Setup-AdministrativeAccountAndPermission.ps1



This PowerShell script is used to verify pre-deployment requirements for the Payment Card Payment processing solution for PCI DSS enablement.
 
```powershell
0-Setup-AdministrativeAccountAndPermission.ps1 
-azureADDomainName <String>
-tenantId <String>
-subscriptionId <String>
-configureGlobalAdmin
-installModules
```


# Description 
 This Powershell script automates the installation and verification of the PowerShell modules installation, and validates, or installs the administrative user of the solution. 
 > This script MUST be run as *Local Administrator* with elevated prividges. [Why I need to run as local administrator?](https://social.technet.microsoft.com/Forums/scriptcenter/en-US/41a4ba3d-93fd-485b-be22-c877afff1bd8/how-to-run-a-powershell-script-in-admin-account?forum=ITCG )  

 Running this script is not required, but installation will fail if the following conditions are NOT met. 

 Installed Modules needed:
 
 - AzureRM
 - AzureAD
 - MSOnline
 - AzureDiagnosticsAndLogAnalytics
 - SqlServer
 - Enable-AzureRMDiagnostics (Script)


## Example 1 Installing required modules

```powershell
.\0-Setup-AdministrativeAccountAndPermission.ps1 -installModules
```
This command will validate, and install missing required PowerShell modules to deploy the Payment Card Payment processing solution for PCI DSS enablement.

## Example 2 Installing required modules and configuring a global admin

```powershell
 .\0-Setup-AdministrativeAccountAndPermission.ps1 
-azureADDomainName contosowebstore.onmicrosoft.com
-tenantId XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
-subscriptionId XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
-configureGlobalAdmin 
-installModules
 ```

 This command will deploy installed modules, and setup the solution  on a **new subscription**. It will create a the user adminXX@contosowebstore.onmicrosoft.com with a randomly generated strong passwords **(Minimum 15 characters, with Upper and Lower case
letters, at least 1 number and 1 special character)** 

 
# Required Parameters

> -azureADDomainName <String>

Specifies the ID of the Azure ctive Directory Domain. As defined by [Get-ADDomain](https://technet.microsoft.com/en-us/library/ee617224.aspx)

> -tenantId <String>

Specifies the ID of a tenant. If you do not specify this parameter, the account is authenticated with the home tenant.


> -subscriptionId <String>

Specifies the ID of a subscription. If you do not specify this parameter, the account is authenticated with the home tenant.

> -configureGlobalAdmin

Will attempt to create a administrator user that will be configured as a subscrption administrator. 
An Active Directory Administrator with global privileges is required to run the
installation. The local administrator must be in the `.onmicrosoft.com` domain
name to run this solution, this step will help create the correct administrator
user.

> -installModules

Installs and verifies all required modules.
If any of the commands from the script fail, see the following reference linksfor assistance:

## Toubleshooting your tenant administrator

The following debugging, and troublshooting efforts can help identify common issue.

Testing your username and passwords [AzureRM](https://docs.microsoft.com/en-us/powershell/azureps-cmdlets-docs/) run the following commands in PowerShell:
```powershell
$cred = Get-Credential  
Login-AzureRmAccount -Credential $cred
```

To test [Azure AD](https://technet.microsoft.com/en-us/library/dn975125.aspx) run the following commands in PowerShell:  
```powershell
$cred = Get-Credential  
Login-AzureAD -Credential $cred
```

 Review the following documentation to test [Enable AzureRM Diagnostics](https://www.powershellgallery.com/packages/Enable-AzureRMDiagnostics/1.3/DisplayScript)                      

 Review the following documentation to test [Azure Diagnostics and LogAnalytics](https://www.powershellgallery.com/packages/AzureDiagnosticsAndLogAnalytics/0.1)                    

 To test [SQL Server PowerShell](https://msdn.microsoft.com/en-us/library/hh231683.aspx?f=255&MSPPError=-2147217396#Installing#SQL#Server#PowerShell#Support) run the following commands in PowerShell:
```powershell
 $Credential = Get-Credential   Connect-AzureAD -Credential $Credential   Get-Module -ListAvailable -Name Sqlps;
```



