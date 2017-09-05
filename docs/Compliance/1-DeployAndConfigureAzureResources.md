# 1-DeployAndConfigureAzureResources.ps1

This PowerShell script is used to deploy the Payment Card Payment processing solution for PCI DSS enablement.Deploying solution requires that a subscription be configured with the right permissions, and roles. Details can be found in the  <a href="0-Setup-AdministrativeAccountAndPermission.ps1"> configuration readme. </a>  
```powershell
.\1-DeployAndConfigureAzureResources.ps1
-resourceGroupName <String>
-globalAdminUserName <String>
-globalAdminPassword <String>
-azureADDomainName <String>
-subscriptionID <String>
-suffix <String>
-sqlTDAlertEmailAddress <String>
-customHostName <String>
-enableSSL <Switch>
-enableADDomainPasswordPolicy <Switch>
```

### Deployment Timeline

The following graphic displays the estimated time to deploy the solution
components. The total time required is approximately 1.5 hours from when the
**Purchase** button is clicked.

![](images/ARM_template_deployment_timeline.png)
 



## Example 1 simple deployment 
    
```powershell
.\1-DeployAndConfigureAzureResources.ps1 
-resourceGroupName contosowebstore
-globalAdminUserName adminXX@contosowebstore.onmicrosoft.com 
-globalAdminPassword **************
-azureADDomainName contosowebstore.onmicrosoft.com 
-subscriptionID XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX 
-suffix PCIcontosowebstore
-sqlTDAlertEmailAddress edna@contosowebstore.com 
-enableSSL 

```

This command will create required Azure accounts, generate a self-signed certificate for ASE ILB & Application Gateway SSL endpoint, use a provided custom domain.

## Example 2 deploy with custom certificate, custom domain, and set password policy

```powershell
.\1-DeployAndConfigureAzureResources.ps1
-resourceGroupName contosowebstore
-globalAdminUserName adminXX@contosowebstore.onmicrosoft.com 
-globalAdminPassword **************
-azureADDomainName contosowebstore.onmicrosoft.com 
-subscriptionID XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX 
-suffix PCIcontosowebstore
-sqlTDAlertEmailAddress edna@contosowebstore.com 
-customHostName contosowebstore.com
-enableADDomainPasswordPolicy
```

This command will create required Azure accounts, generate a self-signed certificate for ASE ILB & Application Gateway SSL endpoint, use a provided custom domain and setup password policy with 60 days.







## Required Parameters

>-resourceGroupName <String>

Specifies the Resource Group name in which all resources will be deployed.

>-globalAdminUserName <String>

Specifies the AD Global admin. This user must be a *Global Administratior* that has been granted full control of the default Active Directory. The user must be in the `.onmicrosoft.com` domain format

Role based access control requires that a administrator grants themselfs administrative rights in AAD. Refer to this blog for a detailed explaination.
> [Delegating Admin Rights in Microsoft Azure](https://www.petri.com/delegating-admin-rights-in-microsoft-azure)
> [PowerShell - Connecting to Azure Active Directory using Microsoft Account](http://stackoverflow.com/questions/29485364/powershell-connecting-to-azure-active-directory-using-microsoft-account)
user.

Details can be found in the  <a href="0-Setup-AdministrativeAccountAndPermission.ps1"> configuration readme</a>  

>-globalAdminPassword <String>

Specifies the password for the AD Global Admin.

>-suffix <String>

Suffix is used as an identifier in the deployment of the solution. This can be any character, or identifier such as a business unit name.

>-sqlTDAlertEmailAddress <String>

Provide a valid email address for alerts, and issues associated with your deployment.

> -azureADDomainName <String>

Specifies the ID of the Azure ctive Directory Domain. As defined by [Get-ADDomain](https://technet.microsoft.com/en-us/library/ee617224.aspx)


> -subscriptionId <String>

Specifies the ID of a subscription. If you do not specify this parameter, the account is authenticated with the home tenant.



> -enableSSL 

Specifies a boolean switch. 
enable SSL on the ApplicationGateway allowing the user to browse on the website with https://www.contosowebsore.com 
 
 
| Input          | Usage |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| none           | Customer can use the application on http (e.g. http://...)  |
| Switch present | Customer can use the application on **`https`** (e.g. https://...).  When this switch is used in combination with `appGatewaySslCertPath` and `appGatewaySslCertPwd`, it will enable a custom certificate on the AppGateway. You want to pass a custom certificate, please have the .pfx certificate file. The following process can be used to create the correct file. |  

1.  Review the instructions on [creating a website SSL
    certificate](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure-ssl-certificate).

2.  Retrieve your private key. This file will have a name structure such as
    `www.contosowebstore.com\_private\_key.key`

3.  Retrieve your certificate. This file will have a name structure such as
    `www.contosowebstore.com\_ssl\_certificate.cer`

4.  [Create a personal information exchange (pfx)
    file](https://technet.microsoft.com/en-us/library/dd261744.aspx) protect
    this file with a password.




## Optional Parameters

> -customHostName

Specifies a custom domain for the deployment. To be able to connect to the website, it is required that you provide a custom domain name, such as contoso.com. This is enabled by using the '-customHostName' switch on step2. [Details to purchase, and enable a custom domain.](https://docs.microsoft.com/en-us/azure/app-service-web/custom-dns-web-site-buydomains-web-app)
A custom domain name is not required to successfully deploy the solution for it to run, however you will not be able to connect to the website for demonstration purposes.
If this parameter is used you will be required to update the applications IP address with your DNS hosting provider (custom domain name)

#### Update DNS setting with Application Gateway IP

In the  example, the customer’s DNS settings require the Application
Gateway IP address to be updated as a DNS record on the hosting site.

1.  Collect the Application Gateway IP address using the following PowerShell
    command:

```powershell
   Get-AzureRmPublicIpAddress | where {$_.Name -eq "publicIp-AppGateway"} |select IpAddress
```


This command will return the IP address. For example:

>` IpAddress`  
>` ---------`
>` 52.168.0.1`

1.  Log into your DNS hosting provider and update the A/AAAA record
    with the Application Gateway IP address.


> -enableADDomainPasswordPolicy

When enabled all users in the solution will have a forced password expire duration of 60 days. 


## Optional variables

> $location

This variable can be changed to a location other than the default "eastus". Changing this setting will require that monitoring of the deployment be observed to ensure that template solution do not fail.

>$automationAcclocation

This variable can be changed to a location other than the default "eastus2". Changing this setting will require that monitoring of the deployment be observed to ensure that template solution do not fail.





