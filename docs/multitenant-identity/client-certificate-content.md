[:::image type="icon" source="../_images/github.png" border="false"::: Sample code][sample application]

This article describes how to add client certificate to the [Tailspin Surveys][Surveys] sample application.

When using authorization code flow or hybrid flow in OpenID Connect, the client exchanges an authorization code for an access token. During this step, the client has to authenticate itself to the server.

![Client secret](./images/client-secret.png)

There are many ways to authenticate the client, using client secret, certificate, and assertions. The [Tailspin Surveys][Surveys] application is configured to use client secret by default.

Here is an example request from the client to the IDP, requesting an access token. Note the `client_secret` parameter.

```http
POST https://login.microsoftonline.com/b9bd2162xxx/oauth2/token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

resource=https://tailspin.onmicrosoft.com/surveys.webapi
  &client_id=87df91dc-63de-4765-8701-b59cc8bd9e11
  &client_secret=i3Bf12Dn...
  &grant_type=authorization_code
  &code=PG8wJG6Y...
```

The secret is just a string, so you have to make sure not to leak the value. The best practice is to keep the client secret out of source control. When you deploy to Azure, store the secret in an [app setting][configure-web-app].

However, anyone with access to the Azure subscription can view the app settings. Furthermore, there is always a temptation to check secrets into source control (for example, in deployment scripts), share them by email, and so on.

For additional security, you can use a client certificate instead of a client secret. The client uses a certificate to prove the token request came from the client. The client certificate is stored in key vault. For this option, add the `ClientCertificates` under AzureAd and specify the configuration settings as shown here:

```dotnetcli
   "ClientCertificates": [
      {
        "SourceType": "KeyVault",
        "KeyVaultUrl": "https://msidentitywebsamples.vault.azure.net",
        "KeyVaultCertificateName": "MicrosoftIdentityCert"
      }
     ]
```

> [!NOTE]
> For more information, see [Using certificates with Microsoft.Identity.Web](https://github.com/AzureAD/microsoft-identity-web/wiki/Using-certificates).

[**Next**](./adfs.md)

<!-- links -->

[configure-web-app]: /azure/app-service-web/web-sites-configure
[client assertion]: https://tools.ietf.org/html/rfc7521
[sample application]: https://github.com/mspnp/multitenant-saas-guidance
[Surveys]: ./tailspin.md
[using-certs-in-websites]: https://azure.microsoft.com/blog/using-certificates-in-azure-websites-applications
