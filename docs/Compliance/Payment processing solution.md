# TABLE OF CONTENTS 
<!-- TOC -->
- <a href="Overview.md"> Solution Overview </a> 
- <a href="Configuration.md"> Configuration and setup for solution </a> 
- <a href="Payment processing solution.md"> The Payment Processing Solution (PCI)</a> 
- <a href="Payment Sample dataset.md"> Customer Samples, and monitoring</a> 
- <a href="FAQ.md"> Frequently Asked Questions </a> 


<!-- /TOC -->

# Payment processing solution deployment



Deploying solution requires that a subscription be configured with the right permissions, and roles. Details can be found in the  <a href="Configuration.md"> configuration </a>  
> The deployment fields in the for this template are retrieved using the [predeployment script output.](#predeployment-script-output)


The following example is used to illustrate the information for `contosowebstore.com`

**Basics**

>-   **Subscription**: `27017c43-3ea4-467a-afa4-7d3d3d9D33232`
>-   **Resource group**: `contosowebstore`
>-   **Location**: Greyed out

**Settings**

>-   **\_artifactsLocation**: `https://raw.githubusercontent.com/AvyanConsultingCorp/pci-paas-webapp-ase-sqldb-appgateway-keyvault-oms/master`
>-   **\_artifactsLocationSasToken**: NULL
>-   **sslORnon_ssl**:[Choose either ssl or non-ssl]
>-   **certData**: [The Contoso Base-64 SSL string]
>-   **certPassword**: [Password you created for the SSL cert]
>-   **aseCertData**:[The ASE ILB Certificate (.cer) Base-64 SSL string]
>-   **asePfxBlobString**:[The ASE ILB Certificate (.pfx) Base-64 SSL string]
>-   **asePfxPassword**:[Password for ASE ILB .pfx certificate]
>-   **aseCertThumbprint**:[Certificate Thumbprintor ASE ILB .pfx certificate]
>-   **bastionHostAdministratorUserName**: `bastionadmin`
>-   **bastionHostAdministratorPassword**: [Create a secure password]
>-   **SqlAdministratorLoginUserName**: `sqladmin`
>-   **sqlAdministratorLoginPassword**: [Create a secure password]
>-   **sqlThreatDetectionAlertEmailAddress**: `admin@contosowebstore.com`
>-   **automationAccountName**: `contosowebstore-Automation`
>-   **customHostName**: `contosowebstore.com`
>-   **azureAdApplicationClientId**: `952b0b1e-2582-4058-a0a0-0abc42107d70`
>-   **azureAdApplicationClientSecret**: `QW#2wFRE12df`
>-   **azureAdApplicationObjectId**: `e3aa33bb-1cae-4afd-a8ba-9124b2a1838a`
>-   **sqlAdAdminUserName**: `sqladmin@contosowebstore.onmicrosoft.com`
>-   **sqlAdAdminUserPassword**: [Create a secure password]


### Deployment Timeline

The following graphic displays the estimated time to deploy the solution
components. The total time required is approximately 1.5 hours from when the
**Purchase** button is clicked.

![](images/ARM_template_deployment_timeline.png)


## DEPLOY AZURE RESOURCE (ARM) TEMPLATE
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAvyanConsultingCorp%2Fpci-paas-webapp-ase-sqldb-appgateway-keyvault-oms%2Fmaster%2Fazuredeploy.json" target="_blank">
<img src="http://azuredeploy.net/deploybutton.png"/>
</a>



* Provide all of the deployment information you collected. Then click **I agree to the Terms and conditions stated above.**
* Click **Purchase**.


#### Update DNS setting with Application Gateway IP

In the Contoso example, the customer’s DNS settings require the Application
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
