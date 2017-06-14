# TABLE OF CONTENTS 
<!-- TOC -->
- <a href="Overview.md"> Solution Overview </a> 
- <a href="Configuration.md"> Configuration and setup for solution </a> 
- <a href="Payment processing solution.md"> The Payment Processing Solution (PCI)</a> 
- <a href="Payment Sample dataset.md"> Customer Samples, and monitoring</a> 
- <a href="FAQ.md"> Frequently Asked Questions </a> 


<!-- /TOC -->


# PRE DEPLOYMENT CONSIDERATIONS 

This section provides  information about items you will need during installation of the solution. These items ensures that account, and user access. 

**IMPORTANT**  The solution requires **a paid subscription** on Azure, a **trial** subscription account will not work, as many of the features used in this deployment are not available in an Azure trial account. You will also require to have access to manage the subscription as a [Subscription Admins role and co-administrator of the subscription](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-assign-admin-roles#global-administrator).

>If you have not already done so, it is advisable to download, or clone a copy of solution.


### Using PCI Compliant SSL, vs Self-Signed SSL
 This solution can be deployed with a self-signed certificate for testing purpose (**Self-signed certificates will not meet PCI DSS compliance requirements**). 

>To use a self signed certificate - you can use the **certificatePath** switch empty, in the pre-deployment script. 

Setting up a [custom domain with a DNS
record](https://docs.microsoft.com/en-us/azure/app-service-web/custom-dns-web-site-buydomains-web-app)
and a root domain can be configured in the [Azure
Portal](https://portal.azure.com/).

#### Custom domain, SSL certificate (Third party )
Microsoft recommends that a custom domain be purchased with [an SSL
package](https://d.docs.live.net/7b2b5032e10686e1/Azure%20Compliance/PCI%20DSS%20quickstart/1.%09https:/docs.microsoft.com/en-us/azure/app-service-web/web-sites-purchase-ssl-web-site).
Microsoft offers the ability to create a domain and request an SSL certificate
from a Microsoft partner.



## Local computer setup requirements

The local configuration of PowerShell will require that the installation script
be run with local admin privileges or remotely signed credentials to ensure that
local permissions do not prevent the installer from running correctly.

### Client software requirements

The following software applications and modules are required on the client
computer throughout the installation of this solution.

1.  [SQL Management
    Tools](https://msdn.microsoft.com/en-us/library/bb500441.aspx) to manage the
    SQL database.

2.  [Powershell
    version](https://msdn.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell)
    v5.x or greater. For example, in PowerShell you can use the following
    commands:

```powershell
    $PSVersionTable.psversion
```

3.  The Powershell modules referenced in the following PowerShell script, which
    must be installed with local Administrative permissions. To do so,

    -   Open Powershell in Administrator Mode

    -   Run the following installation script located in the
        `./pre-post-deployment` folder of this solution, and accept (or select
        Yes to user commands)
```powershell
   ./Install-azure-powershell-modules.ps1
```



If any of the commands from the script fail, see the following reference links
for assistance:


 To test [AzureRM](https://docs.microsoft.com/en-us/powershell/azureps-cmdlets-docs/) run the following commands in PowerShell:
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

### Configure your global admin for the solution

An Active Directory Administrator with global privileges is required to run the
installation. The local administrator must be in the `.onmicrosoft.com` domain
name to run this solution, this step will help create the correct administrator
user.

1.  In the [Azure Portal](https://portal.azure.com/), select **Azure Active
    Directory**.

2.  Select **Domain Name.** Record the name of your domain registered under
    **name**. This will be used in our domain script as the
    `$AzureADDomainName`. In our example

>`pcidemo.onmicrosoft.com`

1.  Select the **Properties**. It will provide your **Directory ID.** This will
    be used in our domain script as the `$tenantID`. In our example

>   `46d804b6-210b-4a4a-9304-83b93`

1.  You will require your username, and password that was used to create your
    subscription.

The script `CreateGlobalADAdmin.ps1` provides the setup and configuration of the admin user that will be used for the remainder of the installation. This user is essential that it be configured corrected, with the right level of [Subscription Admins role and co-administrator of the subscription](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-assign-admin-roles#global-administrator).

**NOTE**: Strong passwords **(Minimum 15 characters, with Upper and Lower case
letters, at least 1 number and 1 special character)** are recommended throughout
the solution.

1.  Open Powershell in Local Administrator Mode (Right click and select **run as
    administrator**)

2.  change directory to the local directory that contains the script and run the
    script.

```powershell
.\\pre-post-deployment\\CreateGlobalADAdmin.ps1
```

3.  Provide your **Domain Name, Directory ID (or tenantID), subscription manager
    password.**

4.  In the [Azure Portal](https://portal.azure.com/), select **Subscription**,
    select your subscription.

5.  Select **Access control (IAM)**

6.  Select **+Add**


![](images/image1.png)

1.  Select the Role as **Owner**.
2.  Select the user – Admin, in our example
`admin@pcidemo.onmicrosoft.com`

3.  Save the configurations.

Return to the Azure portal, and login with your **admin** user. You may need to open a [InPrivate
browser](http://www.thewindowsclub.com/launch-start-private-browsing) to ensure you are logging in without cached credentials. **Reset** your temporary password.

>**NOTE** – The remainder of the installation guidance will use the **Admin** user
for all steps.





### Pre-ARM template deployment

The script `pre-deployment.ps1` provides the setup and configuration of users and
other framework elements. The following steps are required to run the script.
Note that the scripts must complete without errors before the ARM template can
be deployed successfully. Note use admin ensure you are [LOGGING INTO POWERSHELL WITH CORRECT CREDENTIALS](#logging-into-powershell-with-correct-credentials)


Using the [Azure portal](https://portal.azure.com/) with an account that is a
member of the [Subscription Admins role and co-administrator of the
subscription](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-assign-admin-roles#global-administrator).

1.  Set up your resource group.

-   In a PowerShell IDE, run the following command:
```powershell
New-AzureRmResourceGroup -Name [RESOURCE GROUP NAME] -Location "East US"
```
-   In our example we use:

`New-AzureRmResourceGroup -Name contosowebstore -Location "East US"`

>**NOTE** - This demo currently ONLY runs correctly in the location **East**, **East US**

2.  Create an Automation account.
	1. Click **+Add**. and type **Automation** in the search window.
	2. Click **Automation** 
	3. Click **Create**
-   Name:`contosoautomation`
-   Subscription: `Select your subscription`
-	Resouce group, use exisiting: `Select your resource group'
-   In this example:    `contosodemo`
-	Location: `EAST US 2`
- 	Create Azure Run As account `Yes`
	4. Click **Create** 

3. Select your resource group, **contosodemo**, click on **contosoautomation** and select **Runbooks**

> **NOTE:** Do not proceed without verifying your Automation account was successful deployed
by running the runbook examples 
`azureautomationtutorialscript` Creation of a Service Principal has a **propensity to fail on occasion** troubleshooting this process is essential.

Select **>Start** on the `azureautomationtutorialscript` and **Run** to verify it executed correctly. 

3.  Record the information about your resource group, and Automation account:

| Parameter name | Example from previous step|
|----------------|---------------------------|
| Name of automation | `contosowebstore-Automation` |
| Resource group you added | `contosowebstore` |



4. In the PowerShell IDE, change directory to the local directory that contains the script and run the script `predeployment.ps1`.
```powershell
.\predeployment.ps1 -azureADDomainName `pcidemo.onmicrosoft.com` -subscriptionID `27017c43-3ea4-467a-afa4-7d3d3d9D33232` -suffix `contosowebstore` -sqlADAdminPassword `PASSWORD` -azureADApplicationClientSecret `QW2wFRE12df` -customHostName `contoso.com` -enableSSL $true -certificatePath `D:\Certificate\Contoso.pfx`
```
**NOTE**: customHostName, enableSSL & certificatePath are optional parameters. This parameters will help you provide necessary certificates and details what you will use during
the template deployment. You will only provide those parameters based on your requirements as mentioned below -

 -	**Use parameter customHostName** only when you have a custom domain but do not wish to install HTTPS endpoint. 
 -	**Use parameter customHostName & enableSSL** when you have a custom domain and wish to install HTTPS endpoint using self-signed certificate. 
 -	**Use parameter customHostName, enableSSL & certificatePath** when you have a custom domain and wish to install HTTPS endpoint using your own valid certificate. 
 -	**Do not provide any of the three parameters** if you wish to install this solution in a default manner with pcipaas.com as your customHostName with HTTP endpoint only.

 Select **Run Once** to the script warning if you are prompted

## Pre Deployment Script Output

| Parameter name      | Example from previous steps       |
|-------------------------|---------------------------------------|
| $azureADDomainName | `pcidemo.onmicrosoft.com`               |
| $subscriptionID    | `27017c43-3ea4-467a-afa4-7d3d3d9D33232` |
| $suffix            | `contosowebstore`                         |

Record the information provided by the script. You will need this information to
proceed as illustrated in the following example for `contosowebstore.com`.

>Name of Automation account `contosowebstore-Automation`

|Parameter name| Example for `contosowebstore.com`|
|--------------|-----------------------------|
|\_artifactsLocationSasToken:| [BLANK]|
|Cert Data:| Your base 64 SSL certificate string|
|Cert Password:| Your certificate password|
|Bastion Host Administrator User Name:| Default Value 'bastionadmin'|
|Bastion Host Administrator Password: | Password must meet minimum length and complexity requirements|
|SQL Administrator Login User Name:|Default Value is 'sqladmin'|
|SQL Administrator Login Password: |Password must meet minimum length and complexity requirements|
|SQL Threat Detection Alert Email Address:|Email Address to receive alerts for the account|
|Automation Account Name:|**Automation account** In our example `contosowebstore-automation`|
|Custom Host Name:|Your registered domain name. In our example `www.contosoclinc.com`|
|Azure AD Application Client ID:| In our example `27017c43-3ea4-467a-afa4-7d3d3d9D`|
|Azure AD Application Client Secret:| Value [PASSWORD] |
|Azure AD Application Object ID:| In our example `73559c5c-e213-4f10-a88c-546c2`|
|SQL AD Admin User Name:| Default Value, in our example `sqladmin\@pcidemo.onmicrosoft.com`|
|App Gateway certData :| In our example `MIIDYTCCAkm....ADYa2itE=` |
|App Gateway certPassword :| In our example [PASSWORD] |
|ASE ILB certData :| In our example `MIIDYTCCAkm....ADYa2itE=` |
|ASE ILB Certificate asePfxBlobString :| In our example `MIIKMAIBA....nfcSIzQICB9A` |
|ASE ILB pfxPassword :| In our example [PASSWORD] |
|ASE ILB Certificate aseCertthumbPrint :| In our example `DC8EF6928CD9E025C8D2B0997462158F5A4863D1` |



The following additional users have been created in domain.

|User Role| Example for `contosowebstore.com`|
|--------------|-----------------------------|
|Clerk|`Clerk_EdnaB@pcidemo.onmicrosoft.com`|
|doctor|`doctor_ChrisA@pcidemo.onmicrosoft.com`|




### Configuring the Active Directory application


Azure Active Directory application permissions must be configured manually;
there are no PowerShell scripts available at this time to manage the settings
reliably.

1.  In the [Azure Portal](https://portal.azure.com/), select **App
    Registrations**.
2.  Select the application you created. It will be listed with your selected
    `$suffix` with the name **Azure PCI PAAS Sample**.
3.  Click **Required Permissions**.
4.  Click **+Add**.
5.  Click **Select an API**.
6.  In this step you will modify **Windows Azure Active Directory**, **Microsoft
    Graph**, **Windows Azure Service Management API**, and **Azure Key Vault.**

>   **NOTE**: If **Azure Key Vault** is not listed in your **App Registration** list, you will need to manually
>   create a temporary key vault instance by selecting **Key Vault** in [Azure
>   Portal](https://portal.azure.com/), select **+Add**, you can create a sample
>   **Resource group**, and **name**. Once the Vault is created, you will be able to
>   delete it. This action will force the app. API to register in the App
>   Registration interface for the next step. Additional you can read the
>   following [guidance from this blog
>   post](https://blogs.technet.microsoft.com/kv/2016/09/17/accessing-key-vault-from-a-native-application/) for additional guidance.

 The following sections will help you configure each **App Registration** permission sets.
 >**NOTE** the order of your API’s maybe different than listed in this documentation.

1.  Select the **Windows Azure Active Directory** API

    1.  Select the following 2 application permissions

        -   **Read and write directory data**

        -   **Read directory data**

    2.  Select the following 3 delegated permissions

        -   **Read all groups**

        -   **Read directory data**

        -   **Access the directory as the signed-in user**

2.  Click Select

3.  Select Done

4.  Click **+Add**.

5.  Select the **Microsoft Graph** API

    1.  Select the following 6 application permissions

        -   **Read files in all site collections**

        -   **Read all groups**

        -   **Read directory data**

        -   **Read and write directory data**

        -   **Read all users’ full profiles**

        -   **Read all identity risk event information**

    2.  Select the following 7 delegated permissions

        -   **Sign in and read user profiles**

        -   **Read all users’ basic profiles**

        -   **Read all users’ full profiles**

        -   **Read all groups**

        -   **Read directory data**

        -   **Read and write directory data**

        -   **Access the directory as the signed in user**

6.  Click Select

7.  Select Done

8.  Click **+Add**.

9.  Select the **Azure Key Vault** API

    1.  Select no application permissions

    2.  Select the following 1 delegated permission

        -   **Have full access to the Azure Key Vault service**

10. Click Select

11. Select Done

12. Click **+Add**

13. Select the **Windows Azure Service Management** API

    1.  Select no application permissions

    2.  Select the following 1 delegated permission

        -   **Access Azure Service Management as organization user**

14. Click Select

15. Select Done

>   If the configurations are successful, you will see a table of permissions
>   similar to the following:

| **API**                          | **Application permissions** | **Delegated permissions** |
|----------------------------------|-----------------------------|---------------------------|
| Windows Azure Active Directory   | 2                           | 3                         |
| Microsoft Graph                  | 6                           | 7                         |
| Azure Key Vault                  | 0                           | 1                         |
| Windows Azure Service Management | 0                           | 1                         |

