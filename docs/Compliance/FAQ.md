
# TABLE OF CONTENTS 
<!-- TOC -->
- <a href="Overview.md"> Solution Overview </a> 
- <a href="Configuration.md"> Configuration and setup for solution </a> 
- <a href="Payment processing solution.md"> The Payment Processing Solution (PCI)</a> 
- <a href="Payment Sample dataset.md"> Customer Samples, and monitoring</a> 
- <a href="FAQ.md"> Frequently Asked Questions </a> 


<!-- /TOC -->

# FAQ AND FIXES

#### I can't seem to be able to log in, or run the PowerShell scripts with my Subscription user? 
> You require to create an AAD admin as identified in the document. This is required as a subscription admin does not automatically receive DS or AAD credentials. This is a security feature that enables RBAC and role separation in Azure.
#### Why do I need to add my subscription administrator to the AAD Admin role?
>Role based access control requires that a administrator grants themselfs administrative rights in AAD. Refer to this blog for a detailed explaination.
> [Delegating Admin Rights in Microsoft Azure](https://www.petri.com/delegating-admin-rights-in-microsoft-azure)
> [PowerShell - Connecting to Azure Active Directory using Microsoft Account](http://stackoverflow.com/questions/29485364/powershell-connecting-to-azure-active-directory-using-microsoft-account)
#### What should I do if my SSL pxf files is not working?
> Consider reviewing the following artiles, and blogs.
> [How to install a SSL certification on Azure](https://www.ssl.com/how-to/install-a-ssl-certificate-on-a-microsoft-azure-web-appwebsite-and-cloud-service/)
> [Web sites configuring SSL certificate](https://docs.microsoft.com/en-us/azure/app-service-web/web-sites-configure-ssl-certificate)
#### Why do I required a paid Azure account to use this solution?
> Many of the features used in the solution are not available in an Azure trial account. You will also require to have access to manage the subscription as a [Subscription Admins role and co-administrator of the subscription](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-assign-admin-roles#global-administrator).
#### Why do I need an SSL certificate?
> The installation requires a custom domain and SSL certificate to meet PCI DSS requirements and protect the client side traffic from snooping. Microsoft
recommends that a custom domain be purchased with [an SSL package](https://d.docs.live.net/7b2b5032e10686e1/Azure%20Compliance/PCI%20DSS%20quickstart/1.%09https:/docs.microsoft.com/en-us/azure/app-service-web/web-sites-purchase-ssl-web-site).
Microsoft offers the ability to create a domain and request an SSL certificate from a Microsoft partner.
#### Why do Application gateway backend health status showing `unhealthy` ?
> This deployment assumes that VIP address [ASE ILB >> Properties >> Virtual IP Address] assinged to ASE ILB would be 10.0.3.8 (observed behaviour). However, it might get changed to 10.0.3.9. If  the application gateway backend health is listed as `un-healthy`, verify that ASE ILB VIP address and application backend pool targets are same. Update the application gateway backend pool targets with ASE ILB VIP. (https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-create-gateway-portal#add-servers-to-backend-pools)
#### How do I set up the administrator properly to use this solution.
> Review the 'Configure your global admin for the solution' section of the installation guide
#### I get a script failed, error. User permission error. Insuficient permission error?
> Review 'LOGGING INTO POWERSHELL WITH CORRECT CREDENTIALS' section of the installation guide
#### The ARM template fails to run because of my password complexity?
> **NOTE**: Strong passwords **(Minimum 15 characters, with Upper and Lower case letters, at least 1 number and 1 special character)** are recommended throughout the solution.
#### The ARM template fails to deploy `xxxxxxxx` service
> Currently this solution requires that you deploy in US EAST. Limitation to service avalibility in all regions may prevent the solution from deploying storage accounts, or the AES. This solution was tested with the following resource group `New-AzureRmResourceGroup -Name [RESOURCE GROUP NAME] -Location "East US"`
#### The deployment of my services is taking a long time (over two hours), is that normal?
> The total deployment of the services is estimated to take approximately 1.5 hours from when the you select **Purchase** on the ARM template. ASE takes 2 hours to provision.
[How to deploy ASE](http://www.bizbert.com/bizbert/2016/01/07/AppServiceEnvironmentsHowToDeployAPIAppsToAVirtualNetwork.aspx)
#### How do I use this solution in my production deployment, environment?
> This solution including the scripts, template, and documentation are designed to help you build a pilot or demo site. Utilizing this solution does not provide a customer ready to run solution, it only illustrates the components required to build for a secure and compliant end to end solution. For instance, Custom Host Names, SSL Certificates, Virtual network address spacing, NSG routing, existing Storage and Databases, existing enterprise-wide OMS workspaces and solutions, Key vault rotation policies, usage of existing AD Admins and RBAC roles, usage of existing AD Applications and Service Principals will require customization and change to meet your custom production ready solution.

####The scripts fail to run, I get a permission error XXXX, what do I do next?
The following log-ons should be tested whenever you restart your PowerShell
IDE session. This may not be required at all times, but strongly recommended to
ensure the correct credentials are cached in your new session. ---at all times
for this demo log in as the **admin** user in our example.

Logging in to the powershell administrative


1.  [Connect to your Azure
    AD](https://docs.microsoft.com/en-us/powershell/module/azuread/connect-azuread?view=azureadps-2.0)
    service running the following command, with your admin user such as
    admin\@pcidemo.onmicrosoft.com
```powershell
    Connect-AzureAD
```
2.  [Connect to your Azure Active
    directory](https://docs.microsoft.com/en-us/powershell/module/msonline/connect-msolservice?view=azureadps-1.0)
    running the following command, with your admin user such as
    admin\@pcidemo.onmicrosoft.com
```powershell
    Connect-MsolService
```
3.  [Connect to your Azure
    Resource](https://msdn.microsoft.com/en-us/library/mt125356.aspx) manager
    running the following commands, with your admin user such as
    admin\@pcidemo.onmicrosoft.com
```powershell
    login-azurermaccount
```
4.  Retrieve your subscription information running the following commands
```powershell
Get-AzureRmSubscription
```

#### What else do I need to consider once the solution is installed?
Once the script has completed you should consider resetting your administrative passwords, including your ADsqladmin, and Admin users. The following command can be used to quickly reset passwords in PowerShell. 

#### When I run the scripts, I receive the following error "New-Alias : The alias is not allowed, because an alias with the name 'Login-AzureRmAccount' already exists."
This error is related to conflicting PowerShell Modules. To fix, uninstall all PowerShell msi and modules. 

```powershell
Set-MsolUserPassword -userPrincipalName [sqladmin@yourdomain] -NewPassword [NEWPASSWORD] -ForceChangePassword $false
```

#### Are there third party solutions that can help achieve or manage PCI compliance?
The following examples in the marketplace partners that have solutions that can help with continous compliance efforts.

| Security Layer                           	| Azure Marketplace Product(s)                                                                                                                                         	|
|------------------------------------------	|----------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Continuous Compliance Monitoring         	| [CloudNeeti - Continuous Governance of Azure Assets](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/cloudneeti.cloudneeti_enterpise?tab=Overview)     	|
| Network Security and Management      	| [Azure Marketplace: Network Security](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/category/networking?page=1)                                     	|
| Extending Identity Security           	| [Azure Marketplace: Security + Identity](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/category/security-identity?page=1)                           	|
| Extending Monitoring and Diagnostics 	| [Azure Marketplace: Monitoring + Diagnostics](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/category/monitoring-management?page=1&subcategories=monitoring-diagnostics) 	|

 #### How often is this solution updated? 

This solution is maintained in three repositories, one private, and two public. Currently Avyan Consulting team provided the development branch of this solution, any questions or concerns contact. azurecompliance@avyanconsulting.com 

The current version of the solution is avalible in preview,  no stable build has been commited.
 Please check back frequently for updates for the official release of this solution.
The next version pre-release, fixes and updates are located at [Avyan Consulting Git Repo](https://github.com/AvyanConsultingCorp/pci-paas-webapp-ase-sqldb-appgateway-keyvault-oms/)


  ![](images/deploy.png)
  
  