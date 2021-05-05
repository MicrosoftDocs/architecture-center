# Protect APIs with Application Gateway and API Management

With more companies' internal applications adhering to the API-first approach, and the growing number and severity of threats to web application over the internet, it's critical to have a security strategy to protect APIs. The first step toward security is restricting who can access which aspects of an API from what locations. This article describes how to protect API access by using Azure Application Gateway and Azure API Management.

## Architecture

![Proposed architecture.](images/protect-apis.png)

This solution doesn't address the architecture's underlying services, like App Service Environment, Azure SQL Database, and Azure Kubernetes Services. These services only showcase what you can do as a broader solution. This solution specifically discusses the gray-background areas, API Management and Application Gateway.

Application Gateway sets up a URL redirection mechanism that sends the request to the proper [backend pool](/azure/application-gateway/application-gateway-components#backend-pools) depending on the URL format of the API call.

- URLs formatted like `api.<some-domain>/external/*` can reach the back end to interact with the requested APIs.
  
- Application Gateway redirects calls formatted as `api.<some-domain>/*` to a dead end, meaning a backend pool with no target.
  
API Management accepts and properly maps internal calls, which come from resources in the same Azure virtual network, under `api.<some-domain>/internal/*`.

So that developers can manage APIs and their configurations from both internal and external environments, this scenario adds a rule at the Application Gateway level to properly redirect users under `portal.<some-domain>/*` to the developer portal.

Finally, at the API Management level, APIs are set up to accept calls under the following patterns:

- `api.<some-domain>/external/*`
- `api.<some-domain>/internal/*`

## Recommendations

- This solution focuses on implementing the whole solution, building blocks, and testing API access from inside and outside the API Management virtual network. For details on the API Management virtual network integration process, see [Integrate API Management in an internal VNET with Application Gateway](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway).

- Product creation and API configuration in API Management isn't covered here. For a comprehensive tutorial, see [Tutorial: Create and publish a product](/azure/api-management/api-management-howto-add-products).

- To communicate with private resources in the back end, Application Gateway and API Management must be in the same virtual network. This solution assumes you already have a virtual network set up with your own resources. The solution also creates two subnets for Application Gateway and API Management.

- The private, internal deployment model allows API Management to connect to an existing virtual network, making it reachable from the inside of that network context. This feature requires either **Development** or **Production** API Management tiers.
  
- Application Gateway requires PFX certificates for SSL termination. These certificates should be in place before you implement the solution.

- You can manage certificates and passwords in [Azure Key Vault](/azure/key-vault/general/basic-concepts).

- You can use CNAME entries to personalize interactions with the services.

- For firewall and Web Application Firewall (WAF), other services can deliver the same level of protection:
  
  - [Azure Front Door](/azure/frontdoor/front-door-overview)
  - [Azure Firewall](/azure/firewall/overview)
  - Third-party solutions like [Barracuda](https://azuremarketplace.microsoft.com/marketplace/apps/barracudanetworks.waf?tab=overview)
  - Other solutions available in [Azure Marketplace](https://azure.microsoft.com/marketplace/)

### Components

- [Azure Resource Groups](/azure/azure-resource-manager/management/manage-resource-groups-portal) provides a logical container for Azure components.

- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) enables many types of Azure resources, such as Azure Virtual Machines (VMs), to securely communicate with each other, the internet, and on-premises networks.

- [Azure Application Gateway](/azure/application-gateway/overview) is a web traffic load balancer that manages traffic to web applications. Load balancers operate at the transport layer (OSI layer 4 - TCP and UDP), and route traffic based on source IP address and port to a destination IP address and port.

- [Azure API Management](https://azure.microsoft.com/services/api-management/) creates consistent, modern API gateways for existing backend services.

## Scalability considerations

- Turn on Application Gateway's autoscale feature. Application Gateway serves as entry point for this architecture, and the WAF feature requires additional processing power for each request analysis. It's critical that the service can expand its computational capacity on the spot. To enable autoscale, see [Specify autoscale](/azure/application-gateway/tutorial-autoscale-ps#specify-autoscale).

- Consider Application Gateway subnet sizing. Application Gateway requests one private address per instance, plus another private IP address if a private front-end IP is configured. Application Gateway also takes five IPs per instance from the subnet it's deployed to. To properly deploy Application Gateway for this architecture, make sure its subnet has enough space to grow. For more information, see [Application Gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure).

- Turn on the API Management autoscaling feature to support highly concurrent scenarios. Autoscaling lets the service expand its capabilities to quickly respond to a growing number of incoming requests. To enable the autoscale feature, see [Automatically scale an Azure API Management instance](/azure/api-management/api-management-howto-autoscale).

## Availability considerations

- Enable Application Gateway's zone redundance. An Application Gateway or WAF deployment can span multiple Availability Zones, so you don't have to provision separate Application Gateway instances in each zone with a traffic manager. You can choose to deploy Application Gateway instances in a single zone or multiple zones, making it more resilient to zone failure.

## Security considerations

- In this scenario, API Management has two types of IP addresses, public and private. Public IP addresses are used for internal communication on port 3443. In the external virtual network configuration, public IPs are also used for runtime API traffic. When a request is sent from API Management to a public, internet-facing back end, a public IP address is visible as the origin of the request. For more information, see [IP addresses of API Management service in VNet](/azure/api-management/api-management-howto-ip-addresses#ip-addresses-of-api-management-service-in-vnet).

- To fortify the communication through API Management, see [Azure security baseline for API Management](/security/benchmark/azure/baselines/api-management-security-baseline).

## Deploy the solution

The following deployment steps use PowerShell. You could also use the [Azure portal](/azure/azure-portal/) or [Azure CLI](/cli/azure/) to get the same results.

1. Deploy a new Resource Group.
   
   ```powershell
   $resGroupName = "{resource-group-name}"
   $location = "{azure-region}"
   New-AzResourceGroup -Name $resGroupName -Location $location
   ```
   
1. Add subnets for API Management and Application Gateway.
   
   ```powershell
   # Retrieve VNet information
   $vnet = Get-AzVirtualNetwork -Name {vnet-name}  -ResourceGroupName {resource-group-name}
   
   # Add appgtw-subnet to the existing VNet
   $subnetApplication GatewayConfig = Add-AzVirtualNetworkSubnetConfig `
   -Name appgtw-subnet `
   -AddressPrefix {subnet-prefix-address} `
   -VirtualNetwork $vnet
   
   # Add API Management-subnet to the existing VNet
   $subnetAPI ManagementConfig = Add-AzVirtualNetworkSubnetConfig `
     -Name API Management-subnet `
     -AddressPrefix {subnet-prefix-address} `
     -VirtualNetwork $vnet
   
   # Attach subnets to the VNet
   $vnet | Set-AzVirtualNetwork
   
   # Make sure subnets were successfully added
   $vnet.Subnets
   
   # Assign subnet to variables
   $appgatewaysubnetdata = $vnet.Subnets[subnet-index]
   $API Managementsubnetdata = $vnet.Subnets[subnet-index]
   ```
   
1. Deploy a new API Management instance.
   
   ```powershell
   # Create an API Management VNET connected object
   $API ManagementVirtualNetwork = New-AzAPI ManagementanagementVirtualNetwork -SubnetResourceId $API Managementsubnetdata.Id
   
   # Create an API Management service inside the VNET
   $API ManagementServiceName = "{API Management-name}"
   $API ManagementOrganization = "{organization-name}"
   $API ManagementAdminEmail = "{alias}@{somedomain}"
   
   $API ManagementService = New-AzAPI Managementanagement `
       -ResourceGroupName $resGroupName `
       -Location $location `
       -Name $API ManagementServiceName `
       -Organization $API ManagementOrganization `
       -AdminEmail $API ManagementAdminEmail `
       -VirtualNetwork $API ManagementVirtualNetwork `
       -VpnType "Internal" `
       -Sku "{API Management-tier}"
   ```
   
1. Configure hostnames and certificates.
   
   ```powershell
   # Specify cert configuration
   $gatewayHostname = "api.{some-domain}"
   $portalHostname = "portal.{some-domain}"
   $gatewayCertCerPath = "{local-path-to-cer-certificate}"
   $gatewayCertPfxPath = "{local-path-to-pfx-certificate}"
   $portalCertPfxPath = "{local-path-to-pfx-certificate}"
   $gatewayCertPfxPassword = "{cert-api-password}"
   $portalCertPfxPassword = "{cert-portal-password}"
   
   # Convert to secure string before send it over HTTP
   $certPwd = ConvertTo-SecureString -String $gatewayCertPfxPassword -AsPlainText -Force
   $certPortalPwd = ConvertTo-SecureString -String $portalCertPfxPassword -AsPlainText -Force
   
   # Create and set the hostname configuration objects for the proxy and portal
   $proxyHostnameConfig = New-AzAPI ManagementanagementCustomHostnameConfiguration `
     -Hostname $gatewayHostname `
     -HostnameType Proxy `
     -PfxPath $gatewayCertPfxPath `
     -PfxPassword $certPwd
     
   $portalHostnameConfig = New-AzAPI ManagementanagementCustomHostnameConfiguration `
     -Hostname $portalHostname `
     -HostnameType Portal `
     -PfxPath $portalCertPfxPath `
     -PfxPassword $certPortalPwd
   
   # Ties certificates confs into API Management service
   $API ManagementService.ProxyCustomHostnameConfiguration = $proxyHostnameConfig
   $API ManagementService.PortalCustomHostnameConfiguration = $portalHostnameConfig
   
   # Updates the existing API Management with the updated configuration
   Set-AzAPI Managementanagement -InputObject $API ManagementService
   ```
   
1. Provision a public IP (PIP) for Application Gateway.
   
   ```powershell
   # Create a public IP address for the Application Gateway front-end
   $publicip = New-AzPublicIpAddress `
       -ResourceGroupName $resGroupName `
       -name "{pip-name}" `
       -location $location `
       -AllocationMethod Dynamic
   ```
   
1. Create Application Gateway's configuration.
   
   ```powershell
   # Create Application Gateway configuration
   # Step 1 - create App GW IP config
   $gipconfig = New-AzApplicationGatewayIPConfiguration `
       -Name "gatewayIP" `
       -Subnet $appgatewaysubnetdata
   ```
   
1. Configure the front-end IP port object.
   
   ```powershell
   # Step 2 - configure the front-end IP port for the public IP endpoint
   $fp01 = New-AzApplicationGatewayFrontendPort `
       -Name "frontend-port443" `
       -Port 443
   ```
   
1. Tie the front-end IP port to the public IP.
   
   ```powershell
   # Step 3 - configure the front-end IP with the public IP endpoint
   $fipconfig01 = New-AzApplicationGatewayFrontendIPConfig `
       -Name "frontend1" `
       -PublicIPAddress $publicip
   ```
   
1. Set up certificates for Application Gateway.
   
   ```powershell
   # Step 4 - configure certs for the App Gateway
   $cert = New-AzApplicationGatewaySslCertificate `
       -Name "API Management-gw-cert" `
       -CertificateFile $gatewayCertPfxPath `
       -Password $certPwd
   
   $certPortal = New-AzApplicationGatewaySslCertificate `
       -Name "API Management-portal-cert" `
       -CertificateFile $portalCertPfxPath `
       -Password $certPortalPwd
   ```
   
1. Create Application Gateway's listeners.
   
   ```powershell
   # Step 5 - configure HTTP listeners for the App Gateway
   $listener = New-AzApplicationGatewayHttpListener `
       -Name "API Management-api-listener" `
       -Protocol "Https" `
       -FrontendIPConfiguration $fipconfig01 `
       -FrontendPort $fp01 `
       -SslCertificate $cert `
       -HostName $gatewayHostname `
       -RequireServerNameIndication true
   
   $portalListener = New-AzApplicationGatewayHttpListener `
       -Name "API Management-portal-listener" `
       -Protocol "Https" `
       -FrontendIPConfiguration $fipconfig01 `
       -FrontendPort $fp01 `
       -SslCertificate $certPortal `
       -HostName $portalHostname `
       -RequireServerNameIndication true
   ```
   
1. Create Application Gateway's probes to map API Management's endpoints.
   
   ```powershell
   # Step 6 - create custom probes for API Management endpoints
   $API Managementprobe = New-AzApplicationGatewayProbeConfig `
       -Name "API Management-api-probe" `
       -Protocol "Https" `
       -HostName $gatewayHostname `
       -Path "/status-0123456789abcdef" `
       -Interval 30 `
       -Timeout 120 `
       -UnhealthyThreshold 8
   
   $API ManagementPortalProbe = New-AzApplicationGatewayProbeConfig `
       -Name "API Management-portal-probe" `
       -Protocol "Https" `
       -HostName $portalHostname `
       -Path "/signin" `
       -Interval 60 `
       -Timeout 300 `
       -UnhealthyThreshold 8
   ```
   
1. List API Management's endpoints to backend pools.
   
   ```powershell
   # Step 7 - upload cert for SSL-enabled backend pool resources
   $authcert = New-AzApplicationGatewayAuthenticationCertificate `
       -Name "whitelistcert" `
       -CertificateFile $gatewayCertCerPath
   ```
   
1. Configure Application Gateway's HTTP settings.
   
   ```powershell
   # Step 8 - configure HTTPs backend settings for the App Gateway
   $API ManagementPoolSetting = New-AzApplicationGatewayBackendHttpSettings `
       -Name "API Management-api-poolsetting" `
       -Port 443 `
       -Protocol "Https" `
       -CookieBasedAffinity "Disabled" `
       -Probe $API Managementprobe `
       -AuthenticationCertificates $authcert `
       -RequestTimeout 180
   
   $API ManagementPoolPortalSetting = New-AzApplicationGatewayBackendHttpSettings `
       -Name "API Management-portal-poolsetting" `
       -Port 443 `
       -Protocol "Https" `
       -CookieBasedAffinity "Disabled" `
       -Probe $API ManagementPortalProbe `
       -AuthenticationCertificates $authcert `
       -RequestTimeout 180
   ```
   
1. Map backend pool IP with API Management's internal IP.
   
   ```powershell
   # 1. Map backend pool IP with API Management's internal IP
   $API ManagementProxyBackendPool = New-AzApplicationGatewayBackendAddressPool `
       -Name "API Managementbackend" `
       -BackendIPAddresses $API ManagementService.PrivateIPAddresses[0]
   
   # 2. Create sinkpool for API Management requests to discard 
   $sinkpool = New-AzApplicationGatewayBackendAddressPool -Name "sinkpool"
   
   $API ManagementProxyBackendPool = New-AzApplicationGatewayBackendAddressPool `
       -Name "API Managementbackend" `
       -BackendIPAddresses $API ManagementService.PrivateIPAddresses[0]
   ```
   
1. Allow external access to API Management's developer portal.
   
   ```powershell
   # Create a routing rule to allow external Internet access to the developer portal
   $rule01 = New-AzApplicationGatewayRequestRoutingRule `
       -Name "API Management-portal-rule" `
       -RuleType Basic `
       -HttpListener $portalListener `
       -BackendAddressPool $API ManagementProxyBackendPool `
       -BackendHttpSettings $API ManagementPoolPortalSetting
   ```
   
1. Configure and deploy Application Gateway.
   
   ```powershell
   # Step 11 - change App Gateway SKU and instances (# instances can be configured as required)
   $sku = New-AzApplicationGatewaySku -Name "{waf-sku-name}" -Tier "WAF" -Capacity {instances-number}
   
   # Step 12 - configure WAF to be in prevention mode
   $config = New-AzApplicationGatewayWebApplicationFirewallConfiguration `
       -Enabled $true `
       -FirewallMode "Detection"
   
   # Deploy the App Gateway
   $appgwName = "{ag-name}"
   
   $appgw = New-AzApplicationGateway `
       -Name $appgwName `
       -ResourceGroupName $resGroupName `
       -Location $location `
       -BackendAddressPools $API ManagementProxyBackendPool, $sinkpool `
       -BackendHttpSettingsCollection $API ManagementPoolSetting, $API ManagementPoolPortalSetting `
       -FrontendIpConfigurations $fipconfig01 `
       -GatewayIpConfigurations $gipconfig `
       -FrontendPorts $fp01 `
       -HttpListeners $listener, $portalListener `
       -RequestRoutingRules $rule01 `
       -Sku $sku `
       -WebApplicationFirewallConfig $config `
       -SslCertificates $cert, $certPortal `
       -AuthenticationCertificates $authcert `
       -Probes $API Managementprobe, $API ManagementPortalProbe
   ```
   
1. Configure redirection rules.
   
   ```powershell
   # Get existing Application Gateway config
   $appgw = Get-AzApplicationGateway `
       -ResourceGroupName $resGroupName `
       -Name $appgwName
   
   $listener = Get-AzApplicationGatewayHttpListener `
       -Name "API Management-api-listener" `
       -ApplicationGateway $appgw
   
   $sinkpool = Get-AzApplicationGatewayBackendAddressPool `
       -ApplicationGateway $appgw `
       -Name "sinkpool"
   
   $pool = Get-AzApplicationGatewayBackendAddressPool `
       -ApplicationGateway $appgw `
       -Name "API Managementbackend"
   
   $poolSettings = Get-AzApplicationGatewayBackendHttpSettings `
       -ApplicationGateway $appgw `
       -Name "API Management-api-poolsetting"
   
   $pathRule = New-AzApplicationGatewayPathRuleConfig `
       -Name "external" `
       -Paths "/external/*" `
       -BackendAddressPool $pool `
       -BackendHttpSettings $poolSettings
   
   $appgw = Add-AzApplicationGatewayUrlPathMapConfig `
       -ApplicationGateway $appgw `
       -Name "external-urlpathmapconfig" `
       -PathRules $pathRule `
       -DefaultBackendAddressPool $sinkpool `
       -DefaultBackendHttpSettings $poolSettings
   
   $appgw = Set-AzApplicationGateway `
       -ApplicationGateway $appgw
   
   $pathmap = Get-AzApplicationGatewayUrlPathMapConfig `
       -ApplicationGateway $appgw `
       -Name "external-urlpathmapconfig"
   
   $appgw = Add-AzApplicationGatewayRequestRoutingRule `
       -ApplicationGateway $appgw `
       -Name "API Management-api-external-rule" `
       -RuleType PathBasedRouting `
       -HttpListener $listener `
       -BackendAddressPool $Pool `
       -BackendHttpSettings $poolSettings `
       -UrlPathMap $pathMap
   ```
   
1. Update Application Gateway with the new configuration.
   
   ```powershell
   $appgw = Set-AzApplicationGateway `
       -ApplicationGateway $appgw
   ```

## Pricing

The cost of this architecture depends on configuration aspects like:
- Service tiers
- Scalability, meaning number of instances dynamically allocated by services to support a given demand
- Automation scripts
- Whether this architecture will run continuously or just a few hours a month

After you assess these aspects, go to the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) to estimate pricing.
