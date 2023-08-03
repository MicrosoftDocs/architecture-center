[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines a solution for creating a robust and scalable application in a distributed environment. The solution uses Azure App Configuration and Azure Key Vault to manage and store app configuration settings, feature flags, and secure access settings in one place.

## Architecture

The following diagrams show how App Configuration and Key Vault can work together to manage and secure apps in **development** and **Azure** environments.

### Development environment

In the development environment, the app uses an identity via Visual Studio or version 2.0 of the Azure CLI to sign in and send an authentication request to Azure Active Directory (Azure AD).

:::image type="content" alt-text="Architecture diagram that shows how an app signs in and authenticates in a development environment." source="../media/appconfig-development.svg" lightbox="../media/appconfig-development.svg" border="false":::

### Azure staging or production environment

The Azure staging and production environments use an [Azure Managed Service Identity (MSI)](/azure/active-directory/managed-identities-azure-resources/overview) for sign-in and authentication.

:::image type="content" alt-text="Architecture diagram that shows how an app signs in and authenticates in a staging or production environment." source="../media/appconfig-azure.svg" lightbox="../media/appconfig-azure.svg" border="false":::

[Download a Visio file](https://arch-center.azureedge.net/AppConfig_Development.vsdx) of this architecture.

### Dataflow

1. The application sends an authentication request during debugging in Visual Studio, or authenticates via the MSI in Azure.
1. Upon successful authentication, Azure AD returns an access token.
1. The App Configuration SDK sends a request with the access token to read the app's App Configuration Key Vault **secretURI** value for the app's key vault.
1. Upon successful authorization, App Configuration sends the configuration value.
1. Utilizing the sign-in identity, the app sends a request to Key Vault to retrieve the application secret for the **secretURI** that App Configuration sent.
1. Upon successful authorization, Key Vault returns the secret value.

### Components

* [Azure AD](https://azure.microsoft.com/services/active-directory) is a universal platform for managing and securing identities.
* [App Configuration](https://azure.microsoft.com/services/app-configuration) provides a way to store configurations for all your Azure apps in a universal, hosted location.
* [Azure Managed Service Identity](/azure/active-directory/managed-identities-azure-resources) offers managed identities that provide an identity for applications to use when connecting to resources that support Azure AD authentication.
* [Key Vault](https://azure.microsoft.com/services/key-vault) safeguards cryptographic keys and other secrets that are used by cloud apps and services.

## Scenario details

Cloud-based applications often run on multiple virtual machines or containers in multiple regions, and use multiple external services. Creating a robust and scalable application in a distributed environment presents a significant challenge.

By using App Configuration, you can manage and store all your app's configuration settings, feature flags, and secure access settings in one place. App Configuration works seamlessly with Key Vault, which stores passwords, keys, and secrets for secure access.

### Potential use cases

Any application can use App Configuration, but the following types of applications benefit most from it:

* Microservices that are based on Azure Kubernetes Service (AKS), Azure Service Fabric, or other containerized apps that are deployed in one or more regions.
* Serverless apps, which include Azure Functions or other event-driven stateless compute apps.
* Apps that use a continuous deployment (CD) pipeline.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

* It's best to use a different key vault for each application in each environment: development, Azure pre-production, and Azure production. Using different vaults helps prevent sharing secrets across environments, and reduces threats in the event of a breach.

* To use these scenarios, the sign-in identity must have the **App Configuration Data Reader** role in the App Configuration resource, and have explicit **access policies** for retrieving the secrets in Key Vault.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Sowmyan Soman](https://www.linkedin.com/in/sowmyancs) | Principal Cloud Solution Architect

## Next steps

Learn more about the component technologies:

* [Azure App Configuration](/azure/azure-app-configuration)
* [Azure Key Vault](/azure/key-vault/general/basic-concepts)
* [Use Key Vault references for App Service and Azure Functions](/azure/app-service/app-service-key-vault-references)
* [App Configuration and Managed Service Identity](/azure/azure-app-configuration/howto-integrate-azure-managed-service-identity?tabs=core2x)
* [Local development and security](/aspnet/core/security/app-secrets?tabs=windows&view=aspnetcore-3.1)

## Related resources

* [Security architecture design](../../guide/security/security-start-here.yml)
* [Microservices architecture on Azure Kubernetes Service](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
* [Microservices architecture on Azure Service Fabric](../../reference-architectures/microservices/service-fabric.yml)
* [External Configuration Store pattern](../../patterns/external-configuration-store.yml)