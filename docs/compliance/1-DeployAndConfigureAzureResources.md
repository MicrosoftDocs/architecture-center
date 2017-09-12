# Automated Foundational Architecture for PCI DSS-Compliant Environments

## Script Details: `1-DeployAndConfigureAzureResources.ps1`

This PowerShell script is used to deploy the Automated Foundational Architecture for PCI DSS-Compliant Environments. Deploying this solution requires that a subscription be configured with the proper permissions and roles. For more information, see [Script Details: 0-Setup-AdministrativeAccountAndPermission.ps1](./0-Setup-AdministrativeAccountAndPermission.md).

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

The estimated time to deploy the solution components is shown in the diagram below. The total time required is approximately 1.5 hours from when the **Purchase** button is clicked.

![](images/arm-template-deployment-timeline.png)
 
## Example 1: Simple deployment 
    
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

This command creates the required Azure accounts and generates a self-signed certificate for the ASE ILB and Application Gateway SSL endpoint using a provided custom domain.

## Example 2: Deploy with custom certificate and custom domain, and set password policy

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

This command creates the required Azure accounts and generates a self-signed certificate for ASE ILB and Application Gateway SSL endpoint, using a provided custom domain and establishes a password policy for expiration in 60 days.

## Required Parameters

> -resourceGroupName <String>

Specifies the Resource Group name into which all resources will be deployed.

> -globalAdminUserName <String>

Specifies the AD Global admin. This user must be a *Global Administrator* that has been granted full control of the default Active Directory. The user must be in the `.onmicrosoft.com` domain namespace.

Role-based access control requires that an administrator grants themselves administrative rights in AAD. Refer to this blog for a detailed explanation.
> [Delegating Admin Rights in Microsoft Azure](https://www.petri.com/delegating-admin-rights-in-microsoft-azure)
> [PowerShell - Connecting to Azure Active Directory using Microsoft Account](http://stackoverflow.com/questions/29485364/powershell-connecting-to-azure-active-directory-using-microsoft-account) user.

For more information, see [Script Details: 0-Setup-AdministrativeAccountAndPermission.ps1](./0-Setup-AdministrativeAccountAndPermission.md).

>-globalAdminPassword <String>

Specifies the password for the AD Global Admin.

>-suffix <String>

Used as an identifier in the deployment of the solution. This can be any character or identifier, such as a business unit name.

>-sqlTDAlertEmailAddress <String>

Provide a valid email address for alerts and issues associated with your deployment.

> -azureADDomainName <String>

Specifies the ID of the Azure Active Directory Domain, as defined by [Get-ADDomain](https://technet.microsoft.com/en-us/library/ee617224.aspx).

> -subscriptionId <String>

Specifies the ID of a subscription. If you do not specify this parameter, the account is authenticated with the home tenant.

> -enableSSL <Boolean>

Indicates whether to enable SSL on the Application Gateway, allowing the user to browse the website via https://www.contosowebstore.com.

| Input          | Usage |
|----------------|-------|
| none           | Customer can browse the application via HTTP (for example http://...). |
| Switch present | Customer can browse the application via **`HTTPS`** (for example https://...).  When this switch is used in combination with `appGatewaySslCertPath` and `appGatewaySslCertPwd`, it enables a custom certificate on the Application Gateway. If you want to pass a custom certificate, use the .pfx certificate file with the process below to create the correct file. |  

1.  Review the instructions on [creating a website SSL certificate](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure-ssl-certificate).

2.  Retrieve your private key. This file will have a name similar to `www.contosowebstore.com\_private\_key.key`.

3.  Retrieve your certificate. This file will have a name similar to `www.contosowebstore.com\_ssl\_certificate.cer`.

4.  [Create a personal information exchange (pfx) file](https://technet.microsoft.com/en-us/library/dd261744.aspx) and protect this file with a password.

## Optional Parameters

> -enableADDomainPasswordPolicy

When enabled, all users in the solution will have a forced password expiration duration of 60 days. 

> -customHostName

Specifies a custom domain for the deployment. To be able to connect to the website, it is required that you provide a custom domain name, such as contoso.com. This is enabled by using the '-customHostName' switch in step 2. A custom domain name is not required to successfully deploy the solution for it to run, however you will not be able to connect to the website for demonstration purposes. For more information, see [How to buy and enable a custom domain name for Azure Web Apps](https://docs.microsoft.com/en-us/azure/app-service-web/custom-dns-web-site-buydomains-web-app). If this parameter is used you will be required to update the application's IP address with your DNS hosting provider (custom domain name). In the example, the customer’s DNS settings require the Application
Gateway IP address to be updated as a DNS record on the hosting site. You can do this via the steps below.

1.  Collect the Application Gateway IP address using the following PowerShell command:

```powershell
Get-AzureRmPublicIpAddress | where {$_.Name -eq "publicIp-AppGateway"} |select IpAddress
```

This command will return the IP address. For example:
>` IpAddress`  
>` ---------`
>` 52.168.0.1`

2.  Log into your DNS hosting provider and update the A/AAAA record with the Application Gateway IP address.

## Optional variables

> $location

This variable can be changed to a different location than the default value `eastus`. Changing this setting requires that the deployment is monitored to ensure its successful completion.

>$automationAcclocation

This variable can be changed to a different location than the default value `eastus2`. Changing this setting requires that the deployment is monitored to ensure its successful completion.
