---
title: API security guidance
description: Guidance upon how to create a secure API.
services: ''
documentationcenter: na
author: dragon119
manager: christb
editor: ''
tags: ''

pnp.series.title: Best Practices

ms.assetid: 19514a32-923a-488c-85f5-b5beec2576de
ms.service: best-practice
ms.devlang: rest-api
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: na
ms.date: 07/13/2016
ms.author: masashin

---
# API security
[!INCLUDE [header](../_includes/header.md)]

It is vital to design and implement services that expose an API over the Internet in a secure way to protect the service and the users from a range of threats. This guide is meant to serve as a companion to the other guides on API design. This guide cover methods of authentication and authorization to protect your API from unauthorized access as well as API design consideration such as token types, authorization protocols, authorization flows and threat mitigation.

This guide is intended to help API designers and developers evaluate alternatives approaches to protecting and securing access to RESTful APIs.

##Challenges
Consider the following security challenges when designing and implementing a service API:

- Principals, such as users or devices, must be authenticated by a trusted identity provider in order to determine who is accessing the service. For more information, see the section on [Authentication](#insertlink#).
- Actions taken by users and access to resources must be authorized based on the user’s authenticated identity and the role membership, permissions, policies or other related information about that user. For more information, see the section on [Authorization](#insertlink#).
- Services must also be hardened to protect against unauthorized and malicious usage. Examples include:
	- Protect data crossing the network and data in storage from interception and tampering, and from non-authorized users being able to see the contents.
	- Maximize protection against a range of threats including cross-site request forgery and cross-origin resource sharing.
	- Maintain audit logs in order to counter repudiation challenges.
	- Monitor API usage and detect non-standard usage patterns.
	- Implement IP restrictions and rate limits on API usage. For more information, see the section on [Threat mitigation](#insertlink#).

## Authentication
There are several mechanisms for authentication, with a major trade-off between them being the strength of the security against the simplicity of use. For example, some use a pre-configured key whereas others use certificates or tokens to provide a more flexible and robust security mechanism. Choosing the appropriate mechanism requires consideration for the size of the user community (for example, is authentication limited to a small number of consumers or a large number of public consumers); the way that client identity is determined (such as a corporate directory, a token service, or a social identity provider); and the business requirements such as administration (managing keys and secrets), the benefits it provides for API consumers, and other related factors.

This section contains guidelines and considerations for the following authentication mechanisms:

- [HMAC authentication](#insertlink#)
- [Basic authentication](#insertlink#)
- [Certificate authentication](#insertlink#)
- [Digest authentication](#insertlink#)
- [Token based authentication](#insertlink#)

## HMAC authentication
Hash-based message authentication code (HMAC) is a mechanism for calculating a hash code using a cryptographic hash algorithm provider. It uses a combination of the message verb, headers and values, and a secret key that is known only to both the parties involved. The sender and the receiver generate the hash code. The result is a proof of integrity, and authenticity of the payload.

More information about HMAC authentication is available at [HMAC: Keyed-Hashing for Message Authentication](http://www.ietf.org/rfc/rfc2104.txt).

### Considerations for HMAC authentication
Consider the following when using HMAC authentication:

- HMAC authentication offers the following advantages:
	- It is simple to implement. 
	- It does not require a server for authentication, and so can easily scale. 
	- It can provide some protection against spoofing of requests.
	- The credential is not passed over the network as part of the request.
	- The cryptographic strength can be adjusted based on the choice of hash function and the size of the strength secret key. 
- HMAC authentication presents the following challenges: 
	- It cannot provide semantics for authorization or access control, such as roles or claims. 
	- There is no granular level of authorization control.
	- It requires the key to be shared with the sender and the receiver. 
	- The key may be open to disclosure in clients that use JavaScript or native code.
	- It does not provide mechanisms for key management, revocation, and key recycling.
	- It does not provide mechanisms for repudiation of critical business transactions, unless you are implementing a web API, because no identity can be attached to the request.
	- The key distribution policy for clients to obtain the key is difficult to implement in a secure way.

For an example of implementing HMAC authentication, see the section below on [OWIN middleware example - applying HMAC authentication](#insertlink#).

## Basic and Digest authentication
In the basic authentication scheme, a user name and password are sent in an authorization header from the client to the server, and are used to authenticate the caller. The authentication logic then authenticates the user against a store containing user names, passwords, and (optionally) user profiles.

In the digest authentication scheme, a digest that is computed as a hash using an MD5 cryptographic algorithm is sent instead of a user name and password. The algorithm can use any combination of the username, password, and the target resource URI. Digest authentication works by comparing the hashes produced by the client with those in an authentication store, which were generated using an identical cryptographic process.

More information about basic and digest authentication is available at [RFC 2617, HTTP Authentication: Basic and Digest Access Authentication and RFC 2069, An Extension to HTTP Digest Access Authentication](http://www.ietf.org/rfc/rfc2069.txt): 

### Considerations for Basic and Digest authentication

Consider the following when using basic or digest authentication:

- Basic and digest authentication offer the following advantages:
	- They are simple to use and require very little investment to implement.
	- They are part of the HTTP specifications.
- Basic and digest authentication present the following challenges:
	- They are considered less secure than other mechanisms such as token or certificate based authentication, and are generally not recommended because they are susceptible to spoofing, information disclosure, and brute force attacks:
		- Unlike more robust types of authentication, the security realm and username provided by the client cannot be validated against spoofing.
		- They are prone to tampering through replay attacks because there is no validation of the origin of request.
		- The credentials are cached in a web browser and are sent with every request, making it more likely that they will be visible to network monitoring.
		- In non-browser clients, such as when using JavaScript or native code, the credentials are exposed in the code in clear text, and are passed as clear text in the HTTP headers. Transport security can help to protect the credentials while in transit on the network, but it does not mitigate the fact that the credentials are held in clear text on the client.
	- They require the application itself to manage identities such as lists of users and individual accounts—including revocation, lock down policies, password rules, password recycling, and the sign in process.
	- They require the application to store personally identifiable information (PII) and sensitive details such as credentials in your authentication store. The service must obfuscate passwords by using secure hashing or encryption mechanisms.
	- When using digest authenticating, credentials are sent as hashes using MD5 as the hash algorithm cryptographic protocol, which is prone to collision attacks.
	- There is no way to sign out except, in a web browser session, by closing the browser or ending the session.
	- When using these authentication schemes with a web service that exposes an API:
		- Every request must be authenticated against the user account store because it relies on information in the HTTP headers. This affects latency, performance and scalability. In a web browser, cookies are typically used, which can be authenticated by the web server.
		- They may require code to build the appropriate authorization headers if the API does not support credentials embedded in the request URI. For example, when using basic authentication:

		```
HttpClientHandler handler = new HttpClientHandler();
handler.Credentials = new NetworkCredential("username", "password");
HttpClient client = new HttpClient(handler);
client.BaseAddress = new Uri("https://localhost");
var response = client.GetAsync("api/values").Result;
```

		When using digest authentication:

		```
HttpClientHandler handler = new HttpClientHandler();
//compute hash
HttpClient client = new HttpClient();
client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Digest", HashedValue);
client.BaseAddress = new Uri("https://localhost");
var response = client.GetAsync("api/values").Result;
```

## Certificate authentication
Using a certificate to authenticate a client can support a high security scenario. The client stores a certificate that it presents to the server to enable authentication. This approach supports a two factor authentication mechanism because the client will usually need to provide a PIN in order to use the certificate.

### Considerations for Certificate authentication
Consider the following when using certificate authentication:

- Certificate authentication offers the following advantages:
	- It provides a high degree of security because it is based on the PKI infrastructure and is a standard, proven solution.
	- There are frameworks and tools available that make it easier to implement compared to an authentication scheme such as HMAC.
- Certificate authentication presents the following challenges:
	- It requires the acquisition of a certificate from a certificate authority, which may mean additional costs to maintain the infrastructure.
	- Certificate distribution is a difficult task to achieve in distributed environments where there are many clients.
	- Certificate revocation and time synchronization issues.

## Token based authentication
Token based authentication is considered to be the most flexible form of authentication, and it separates the authentication infrastructure from the application business logic. This separation of concerns creates an abstraction level very different from traditional enterprise or username/password authentication techniques. Token based authentication offloads authentication to an external entity, which acts as an identity provider and a trusted authority that issues security tokens. The application and the identity provider can be different business entities who establish a relationship of trust.

Increasingly, the actors in complex authentication scenarios are client application entities—as well as the traditional user entity—which creates a level of complexity that cannot easily be managed with other traditional authentication schemes. Token based authentication makes it much easier to handle these types of scenarios.

More information about token based authentication is available at [A Guide to Claims-Based Identity and Access Control](http://msdn.microsoft.com/en-us/library/ff423674.aspx).

### Considerations for token based authentication
Consider the following when using token based authentication:

- Token based authentication offers the following advantages:
	- It solves the problems around handling usernames and passwords in different types of applications and clients.
	- It allows for federation of identity where businesses in different security realms can be integrated in various ways or as partner relationships.
	- It provides a single sign-on (SSO) capabilities for users and applications.
	- It can make it easier to scale the application because the application does not need to maintain complex authentication capabilities and stores on its own.
	- The design and development of the application is decoupled from the details of the authentication system—which makes refactoring, development, and testing easier and reduces costs.
	- It supports granular authorization and access control based on claims, roles or policies.
	- It enables secure hybrid integration between cloud-hosted and on-premises solutions.
	- It enables integration with social media providers, and simplifies multi-tenant scenarios.
	- It supports a wide range of clients, in addition to all common web browsers. Entities can be applications and clients, as well as users.
- Token based authentication presents the following challenges:
	- It requires effort and investment to convert legacy solutions that use other authentication mechanisms, especially those based on the username/password model. However, this conversion is typically required when moving to the scalable and elastic environment of the cloud.
	- It requires long term planning to design the security model based on trust delegation policies for authentication and authorization.

### Token types
JSON web tokens (JWT) and simple web tokens (SWT) are compact token formats suitable for use in RESTful services. They are designed for space-constrained environments such as HTTP authorization headers. Security Assertion Markup Language (SAML) tokens, which are based on SOAP messages represented in XML format, are much larger and can affect scalability and performance.

The following table shows the properties of these three types of tokens.

|                         | **SAML**                       | **JWT**                                              | **SWT**              |
|-------------------------|--------------------------------|------------------------------------------------------|----------------------|
| **Protocols**           | WS-Federation SAML-P           | OpenIDConnect                                        | WS-Federation        |
| **Representation**      | XML                            | JSON                                                 | HTML Encoded         |
| **Claims**              | XML Assertions                 | JWS Compact Serialization  JWS Compact Serialization | HTML                 |
| **Support for signing** | Yes (symmetric and asymmetric) | Yes (symmetric and asymmetric)                       | Yes (symmetric only) |
| Support for encryption  | Yes                            | Yes                                                  | No                   |

_Choosing a token type_

Consider the following points related to choosing token types:

- SAML tokens require a sophisticated XML stack to parse, validate and consume them. Many clients, such mobile devices, do not have this capability.
- SAML token format is supported by WS-Federation and SAML-P. For more information see [Web Services Federation Language (WS-Federation)](http://docs.oasis-open.org/wsfed/federation/v1.2/os/ws-federation-1.2-spec-os.html)
- JWT can be used with JavaScript. These tokens support many symmetric and asymmetric algorithms for encryption and signatures.
- JWT are easy to create, validate and transmit over a network, and are becoming the standard approach. OpenIdConnect mandates the use of JWT. For more information see [OpenIdConnect](http://openid.net/connect/)
- SWT is an attempt to simplify SAML tokens, but they only support symmetric signatures and so require considerable computational resources to process.
- SAML tokens are well suited to use with token issuers based on WS-Trust and WS-Federation. Examples are Active Directory Federation Services (ADFS) and other issuers that provide cross domain security federation or on-premises integration.

# Authorization
Authorization is the process of deciding if an entity can access a specific resource or perform a specific action. It occurs after the user authenticates. Authorization can be based on the user identity or the client application identity, using data from the claims in a security token or user profile data stored in a profile store.

Token claims can come from different sources such as simple authentication tokens (username and password), Windows tokens with role membership information, certificates, or from more advanced issuers such as identity providers and authorization servers.

## Considerations for authorization
Consider the following points related to authorization:

- Authorization can be complex because it is application centric and it might depend on several factors such as business logic, multi-tenancy, partner relationships, and more.
- Do not rely on the set of claims returned from authentication/authorization mechanism always being appropriate for, or compatible with your service. It is unlikely that the claim set in the token will directly fulfill your business requirements. You may need to augment, transform or enrich the claims to suit specific authorization scenarios and requirements. For example, the organizational role claim may be “Manager” but the application expects “Supervisor”.
- Claims can be augmented or enriched by adding new claims that are specific to, or required by your scenario, and this is good practice to achieve your authorization requirements. It may occur as part of the business logic; and can be based on existing profile data, a name identifier, or existing claims in a token. However, take care that the tokens do not become too large to handle.
- Client identities have other attributes such as scope and client type, which can be used for authorization decisions as well as being part of the authentication process. For example, a web API action might have an authorization check that limits tablet clients to the scope of read-only.
- Authorization can occur at different stages of handling the request. The general rule when a request must be denied is to return a 401 Unauthorized response as early as possible and as late as required by the business logic. The request handling stages include:
	- **The OWIN middleware**. This is the earliest point at which access can be denied. Denying a request here can help to implement a scalable solution and maintain performance because it minimizes computational resource overhead—the web API pipeline code has not yet been executed. For example if the token, certificate, HMAC key, or username validation checks fail, there is no point of continuing to execute the request.
	- **An authorization filter set globally in the filter collection**. This can terminate execution at the earliest stage of the web API pipeline, providing a solution that helps to minimize computation resource usage. At this stage, the authorization check occurs at global application level. For example, a web API may accept requests only from certain client types.
	- **An authorization filter set at controller level** (a declarative check). Authorization at this level provides a mechanism for managing access to all of the actions in a controller. It is efficient because model binding has not occurred at this point.
	- **An authorization filter set at action level** (a declarative check). Authorization at this level is more computationally intensive, but enables a granular approach to implementing authorization for business logic inside the service. It is reasonably efficient because model binding has not occurred at this point.
	- **Validation code within an action** (an imperative check). This is the most computationally intensive solution, but also gives the most granular control for authorizing access to business logic inside the service. An imperative check such as this gives you the opportunity to build custom code for authorization logic; but it requires care because unexpected scenarios, poor programming techniques, or lack of full testing can result in security flaws. Using imperative checks inside controller actions also has the disadvantage that it results in close coupling of the authorization logic and the application code.

For examples of authorization, see

- [Authorization example](#insertlink#)
- [Authentication filters](#insertlink#)

## OAuth 2.0 authorization protocol
OAuth is an authorization protocol designed to provide a delegation mechanism for distributed applications. In this model, resources are made available without the requirement for shared credentials. It is not a protocol for authenticating users. The actors that play a main role in the authentication flow of OAuth are applications, as well as users. In OAuth, a user gives consent to a client application, or to an API, to use protected resources in another API—without sharing credentials.

More information about OAuth is available at [Welcome to OpenID Connect](http://openid.net/connect/).

### Considerations for OAuth 2.0 authorization protocol

Consider the following when using the OAuth authorization protocol:

- There are different authorization flows in OAuth, depending on the application: 
	- Native applications.
	- Web applications.
	- Federated identity applications.
	- User agent applications such as JavaScript clients.
	- Machine to machine scenarios.
- The OAuth 2.0 authorization protocol offers the following advantages:
	- It allows APIs to be designed and scoped to different client types. For example, all tablet clients may have access to only a search capability whereas other clients have access to different capabilities.
	- It does not mandate the use of specific message standards or token formats, such as WS-Federation or the Saml-P protocol, and so it cannot be confused with well-known authentication protocols when using federated identity techniques.
	- OpenIDConnect, a sign-in protocol, is layered on top of OAuth 2.0. It formalizes the relationship between the application and the relying party (RP) and provides claims about the identity of the authenticate user through the ID token.
	- In the event of a compromised client, exposure of the protected resource can be limited to the relatively short lifespan of the access-token. For example, an access tokens may expire in 60 minutes, after which time the refresh token must be used to obtain a new access token from the authorization server. If the client device has been compromised, the authorization server can revoke access by not renewing the access token when it expires.
- The OAuth 2.0 authorization protocol presents the following challenges:
	- Every OAuth provider will be implemented differently with regard to token validation rules and message formats.
	- Implementing an authorization server requires expertise, and has a steep learning curve.

## Authorization flows
This section contains information about the different flows for authentication and authorization:

- [Resource flow](#insertlink#). Users trust the client application and provide it with their credentials. The client application sends these credentials to the authorization server when access to a protected resource is required. The authorization server returns an access token for the protected resource to the client application, which sends this token to the API.
- [Resource flow without credentials on the client](#insertlink#). Users do not trust the client application with their credentials. Users are redirected to the authorization server when access to a protected resource is required, and they provide credentials at this stage. The authorization server returns an access token for the protected resource to the client application, which sends the token to the API.
- [Server authorization code flow](#insertlink#). Users of a server-based application such as an ASP.NET website do not trust the server-based application with their credentials, but they need to provide the server-based application with proof of permission to access a protected resource. Users access the authorization server and they provide their credentials to obtain an access code (not a security token). Users present this code to the server-based application, which uses it to obtain a security token that it presents it to the protected resource when access is required. The protected resource accesses the authorization server to validate the token. If the server-based application does not present a valid token, the authorization server prompts the user to provide credentials at this stage.
- [Cross domain trust flow](#insertlink#). The protected resource is in a different security domain to the client application. Users trust the client application and provide it with their credentials. The client application sends these credentials to the authorization server in its own domain when access to a protected resource is required, and this authorization server returns an access token for the protected resource to the client application because it trusts the client application’s authorization server. The client application then presents this token to the authentication server in the domain of the protected resource, which sends a new token back to the client application. The client application uses the new token to access the protected resource.

### Resource flow
The following schematic shows the resource flow model, where the users trust the client application with credentials.

[insert graphic](#insertgraphic#)

The steps of the resource flow model are:

1.	The user interacts with a client application that must access a protected resource such as a web API on the user’s behalf. The user trusts the client application, and provides credentials to this application.
2.	The client application sends the user’s credentials to the authorization server, together with any other relevant information about the client application—which may include the type (such as Windows Phone or web browser), the required scope (such as read and/or write), and the required token duration.
3.	The authorization server returns an access token to the client application.
4.	The client application presents the access token as it makes a request for a protected resource.
5.	The protected resource authorizes the user based on the user’s identity (using claims and roles), the client type, and the required scope.
6.	The client application can refresh the token without user interaction if required, and if the access policy for the protected resource process allows this.

### Resource flow without credentials on the client
The following schematic shows the resource flow without credentials on the client model, where the users do not trust the client application with their credentials.

[insert graphic](#insertgraphic#)
 
The steps of the resource flow without credentials on the client model are:

1.	The user interacts with a client application that must access a protected resource such as a web API on the user’s behalf, but the user does not trust the client application.
2.	The client application redirects the user to a consent page on the authorization server, which prompts for credentials, client type (such as Windows Phone or web browser), and the required scope (such as read and/or write). It may also prompt for the type of consent and the duration of the token. The user sends credentials to the authorization server.
3.	The authorization server returns an access token to a call back location, which is the client application. The client application does not have access to the user’s credentials during this process.
4.	The client application presents the access token to the web API as it makes a request for a protected resource.
5.	The protected resource authorizes the user based on the user’s identity (using claims and roles), the client type, and the required scope.
6.	The client application can refresh the token without user interaction if required, and if the access policy for the protected resource process allows this.

Consent pages on the authorization server are specific to the application logic. Developers building authorization servers must implement a UI that prompts the user for the type of consent required. It could be data such as a birth date or last name, or an action such as read or print. The consent may also include the duration for which it is valid, and other information.

### Server authorization code flow
The following schematic shows the server authorization code flow model, which is typically used when the application that accesses a protected resource is running on the server (rather than as a local client application).

[insert graphic](#insertgraphic#)

The steps of the server authorization code flow model are:

1.	The user accesses the authorization server, which prompts for credentials, client type (such as Windows Phone or web browser), and the required scope (such as read and/or write). It may also prompt for the type of consent and the duration of the token. The user sends credentials to the authorization server.
2.	The authorization server returns an access code (not a security token for the protected resource) to the user.
3.	The user presents the access code to the server-based application.
4.	The server-based application authenticates with authorization server and presents the access code provided by the user.
5.	The authorization server returns a security access token to server-based application.
6.	The server-based application presents the access token to the protected resource.
7.	The protected resource authorizes the user based on the user’s identity using claims, roles, the client type, and/or the scope.
8.	The server-based application can refresh the token without user interaction if required, and if the access policy for the protected resource process allows this. 

### Cross domain trust flow
The following schematic shows the cross domain trust flow model, which can be used when the protected resource is in a different security domain to the client application.

[insert graphic](#insertgraphic#)

The steps of cross domain trust flow model are:

1.	The user interacts with a client application that must access a protected resource is in a different security domain on the user’s behalf. The user trusts the client application, and provides credentials to this application.
2.	The client application sends the user’s credentials to the authorization server in its security domain, together with any other relevant information about the client application—which may include the type (such as Windows Phone or web browser), the required scope (such as read and/or write), and the required token duration.
3.	The authorization server returns an access token valid that is in the client’s domain to the client application.
4.	The client application sends the access token received from its authorization server to the partner authorization server, which is in the domain of the protected resource. 
5.	There is trust relationship between the client application authorization server and the partner authorization server. The partner authorization server returns a new access token, which is valid in the domain of the protected resource, to the client application.
6.	The client application presents the new access token as it makes a request for a protected resource.
7.	The protected resource authorizes the user based on the user’s identity (using claims and roles), the client type, and the required scope.

## Authorization servers
Authorization servers provide authorization tokens to users or clients through delegation in order to enable access to protected resources. Protected resources in the context of a web API are typically methods that return the results of queries, or perform actions.

### Considerations for authorization servers
Consider the following when implementing and using an authorization server:

- Microsoft.OWIN.Oauth is a framework that provides the interface for building authorization servers. These servers are extensibility points in the OWIN interface, and can be hosted on any OWIN capable host—including IIS.
- Authorization servers can integrate with federated identity providers such as Active Directory Federations Services (ADFS).
- Authorization servers can be scoped to a configurable flow, and can map different providers to specific clients to achieve a very granular level of control and integration.
- OAuth does not provide any guidance for authentication techniques, token duration, or revocation policy. You must create custom code within the OWIN middleware layer to handle authentication and tokens.
- Authorization servers can refresh tokens to simulate long-living tokens. Clients effectively renew the token in order to continue to access protected resources. However, clients cannot add new claims or access additional resources with a refreshed token. The authorization server should provide features for clients to revoke an existing token and then re-authenticate to obtain a new token that permits access to other protected resources.

## Authorization example
The **Authorize** attribute is can be applied to a controller and to the individual actions in a controller. The combination at these two levels uses an AND logical operation, but controller-level attributes can be overridden by using the **AllowAnonymous** and **OverrideAuthorization** attributes at individual action level. The following code shows an example:

```
[Authorize(Roles="inventory")]
public class PatternController : ApiController
{
  // GET: api/Pattern
  public IEnumerable<string> Get()
  {
    return new string[] { "value1", "value2" };
  }
  // GET: api/Pattern/5
  [Authorize(Roles = "order")]
  public string Get(int id)
  {
    return "value";
  }
  // POST: api/Pattern
  // PUT: api/Pattern/5
  [AllowAnonymous]
  public void Put(int id, [FromBody]string value)
  {
  }
  // DELETE: api/Pattern/5
  [OverrideAuthorization(Roles = "sales")]
  public void Delete(int id)
  {
  }
```

This approach to authorization is prone to errors in the overall logic, which may result in lack of proper authorization checks. In addition, developers creating the classes may not know exactly how the business logic works during the development and testing cycle.

The second main challenge with using the **Authorize** attribute is that it creates a coupling between the authorization logic and the API code. Authorization logic might change over time, perhaps causing the code to break or introducing security flaws.

A better approach is to decouple the API facade from the authorization logic by creating a custom authorization attribute class that derives from the authorize attribute class. You can then override the **IsAuthorized** and **HandleUnauthorizedRequest** methods to create specialized authorization logic and unauthorized responses. This way, implementation of authorization logic is independent of the API business logic. You would retrieve the claims principal from the action context and return a Boolean value that correlates with the authorization result that was performed against your claims.

```
public class OrderAuthorizeAttribute : AuthorizeAttribute
{
  protected override bool IsAuthorized(HttpActionContext actionContext)
  {
   var principal = actionContext.RequestContext.Principal as ClaimsPrincipal;
    // Get your principal and handle authorization
    return authorizationresult;
  }
  protected override void HandleUnauthorizedRequest(
            System.Web.Http.Controllers.HttpActionContext actionContext)
  {
    actionContext.Response=actionContext.Request.CreateErrorResponse(
                  System.Net.HttpStatusCode.Unauthorized,"unauthorized")
    base.HandleUnauthorizedRequest(actionContext);
  }
}
```

You could add the custom authorization attribute globally at application level, so in this case all controllers will apply this authorization logic.

```
public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
   filters.Add(new  OrderAuthorizeAttribute())
}
```

Another approach is to implement imperative checks at the action level inside the controller. For example do a storage call to check to see if a customer meets certain conditions. In the action controller you can call the **Unauthorized** method from **System.Web.Http.Results** and return the appropriate message.

```
return Unauthorized(new AuthenticationHeaderValue("Bearer","unauthorized");
```

# Threat mitigation

This section contains guidelines and considerations for the following topics:

- [Information disclosure](#insertlink#)
- [Cross-site request forgery attacks](#insertlink#)
- [Cross-origin resource sharing attacks](#insertlink#)
- [Repudiation](#insertlink#)
- [Data validation](#insertlink#)

## Information disclosure
Information disclosure occurs when data that is in transit or at rest in storage is visible or accessed by non-valid or malicious users or processes. Preventing information disclosure is especially important for sensitive data.

### Considerations for information disclosure
Consider the following points related to information disclosure:

- Implement transport security to protect data when in transit. See the following section for more details.
- Take advantage of security features and access control capabilities of storage services such as databases, file systems, and cloud storage. 
- Protect data both in transit and at rest by using hashing or encryption algorithms that are sufficiently strong.

### Transport security
Transport security is based on using the HTTPS protocol, which is HTTP over Transport Layer Security (TLS). HTTP over TLS is commonly understood to provide:

- Protection of confidentiality 
- Server authentication
- Data integrity
- Protection against replay attacks

TLS is recommended for all new services and applications, and supersedes Secure Sockets Layer (SSL). For more information, see [TLS vs. SSL](http://msdn.microsoft.com/en-us/library/windows/desktop/aa380515(v=vs.85).aspx). For more information about the TLS protocol see [Transport Layer Security Protocol](http://msdn.microsoft.com/en-us/library/windows/desktop/aa380516(v=vs.85).aspx). 

_Considerations for transport security_

Consider the following when using transport security:

- Applying transport security techniques increases the resource usage and the consequent load on the compute instance. To minimize this, you can use it selectively to protect API calls that require this type of security, while using non-secured HTTP endpoints for other requests that do not require transport security.
- Consider offloading the transport security from the web server to a dedicated device that can more efficiently encrypt/decrypt data and handle certificates. This approach is commonly known as transport security offloading which can result in more efficient use of resources and better overall performance. However, beware that failing to secure traffic between application servers and the SSL device offloaded to can compromise the security of all offloaded sessions.
- Consider using filters to enforce the HTTPS URI scheme for the actions, controller, or application you want to protect. This allows you to apply a defense mechanism that refuses invalid API calls and replies to callers with the appropriate **HttpMessageResponse** message. Using filters is a good design technique for managing cross cutting concerns because they are extensibility points that can be applied to different applications to enforce security policy and standards. There are three levels at which filters can be used:
	- **Filter applied to individual action methods**. With this approach, a filter developed to enforce HTTPS and return a “Forbidden” status is applied selectively to the action method you want to protect. The example here applies the filter to an action method:

		```
public class HttpsOnlyAttribute : ActionFilterAttribute
{
  public override void OnActionExecuting(HttpActionContext context)
  {
    var request = context.Request;
    if (request.RequestUri.Scheme != Uri.UriSchemeHttps)
    {
      var Response = new HttpResponseMessage(HttpStatusCode.Forbidden);  
      Response.Content = new StringContent("HTTPS Required");
      context.Response = Response;
    }
  }
}
[HttpPost]
[HttpsOnly]
public async Task<HttpResponseMessage> Save(Pattern pattern)
```

	- **Filter applied at the controller level**. This uses a similar filter, but it is applied to the controller to enforce HTTPS for all actions exposed by the controller:

		```
[HttpsOnly]
public class PatternController : ApiController
```

	- **Filter registered in Global.asax**. This approach applies the filter at the global application level so that it applies to all requests:

		```
public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
  filters.Add(new HttpsOnlyAttribute());
}
```

## Cross-site request forgery attacks
This well-known attack relies on the user visiting a legitimate site and being authenticated, then visiting a malicious site while the browser still contains the authentication credentials or cookie. Either a form or client-side code running in the browser executes a post back to the malicious site, which includes the authentication credentials. A form can have hidden fields, but can lure the user into thinking there was no malicious intention—as shown here:
<h1>You Are a Winner!</h1>
<form action="http://mywebapi.com/api/payment" method="post">
  <input type="hidden" name="Transaction" value="pay" />
  <input type="hidden" name="card" value="1000000" />
  <input type="submit" value="Click Me"/>
</form>

### Considerations for cross-site request forgery attacks
Consider the following points related to cross-site request forgery attacks:

- Use anti-forgery tokens that the server can validate in forms and cookies. If either is missing, the server assumes that the request is invalid. For example, in a form post you could use the following code:

	```
@using (Html.BeginForm("Manage", "Account", FormMethod.Post, new { @class = "form-horizontal", role = "form" }))
{ @Html.AntiForgeryToken() ...
```

- If a cookie is used for validation, annotate the controller with a **ValidateAntiForgeryToken** attribute to protect it from cross-site request forgery attacks when calls come from a form in an MVC application or from JavaScript running in the client. For example:

	```
[ValidateAntiForgeryToken]
public class PatternController : ApiController
public void Validate(HttpContextBase httpContext)
{
  this.CheckSSLConfig(httpContext);
  AntiForgeryToken cookieToken = this._tokenStore.GetCookieToken(httpContext);
  AntiForgeryToken formToken = this._tokenStore.GetFormToken(httpContext);
  this._validator.ValidateTokens(httpContext,
  AntiForgeryWorker.ExtractIdentity(httpContext), cookieToken, formToken);
}
```

- Cross-site request forgery is only possible when cookie authentication is enabled for the API by configuring the scenario for _implicit browser authentication_. In this scenario, browsers are authenticated by the web application or with JavaScript. You can disable cookie authentication by removing the **UseCookieAuthentication** option from the OWIN middleware in the startup class. However, doing this degrades the single sign-on (SSO) experience by forcing clients to send an authentication token with every request. Web applications can still call the authorization server on behalf of original caller or application identity, but this requires an additional roundtrip to the server, or implementation of a token cache with suitable scalability and performance capabilities.

	```
// Enable the application to use a cookie to store information for the signed-in user.
app.UseCookieAuthentication(new CookieAuthenticationOptions
{
  AuthenticationType = DefaultAuthenticationTypes.ApplicationCookie,
  LoginPath = new PathString("/Account/Login"),
  Provider = new CookieAuthenticationProvider
  {
    OnValidateIdentity = SecurityStampValidator.OnValidateIdentity<
      ApplicationUserManager, ApplicationUser>(
      validateInterval: TimeSpan.FromMinutes(20),
      regenerateIdentity: (manager, user) 
        => user.GenerateUserIdentityAsync(manager))
  }
});
```

For more information, see [Preventing Cross-Site Request Forgery (CSRF) Attacks](http://www.asp.net/web-api/overview/security/preventing-cross-site-request-forgery-(csrf)-attacks).

## Cross-origin resource sharing attacks
A web application viewed in a web browser might use client-side code to access resources from an API exposed by a web service in a different domain. This is a cross-origin request, and occurs when the web application and the web service have different schemes, hosts, or ports. The web application may be prevented from performing a cross-origin request for security purposes—this mechanism prevents a web application served by one web server from silently redirecting a request to a third-party web service, and returning a potentially malicious response.

CORS is a W3SC standard protocol (see [Cross-Origin Resource Sharing](http://www.w3.org/tr/cors/)) that enables a web server to selectively relax the cross-origin security restriction. When a web application sends an HTTP request to the web service, it can include an Origin header that specifies the domain of the server hosting the web application as part of the request:

```
Origin: http://adventure-works.com
```

A benign web server hosting the web service can process this header, and if it recognizes the origin it can include an **Access-Control-Allow-Origin** header in the response.

```
Access-Control-Allow-Origin: http://adventure-works.com
```

If the web service does not include this header in the response, the browser running the web application may deem the server suspicious and block the response.

### Using credentials with CORS
By default, the browser does not include any credentials or cookies in any cross-origin requests. If an application wishes to include credential information, it must explicitly include them in the request header. The following JavaScript code shows how to achieve this by setting the **withCredentials** property of the **XMLHttpRequest** object being used to submit a request:

```
var xhr = new XMLHttpRequest();
xhr.open('get', 'http://adventure-works.com/orders');
xhr.withCredentials = true;
```

The server hosting the web service must also be configured to accept cross-origin credentials, and the response must include the **Access-Control-Allow-Credentials** header with the value **true** otherwise the browser will reject the response. Again, the configuration process will vary according to the web server.

### Handling preflight requests
By default, the CORS protocol enables a web application to send HTTP **GET** and **POST** requests to retrieve and add new resources, but not submit HTTP **PUT** and **DELETE** requests that can modify or remove existing data, or requests that include custom headers. Again, this is for security reasons, and to protect the web service from malicious requests that could damage the resources managed by the web service. To handle requests such as these, a CORS-enabled web application first submits a preflight **OPTIONS** request that specifies the type of operation to be performed in an **Access-Control-Request-Method** header, and the names of any custom headers in an **Access-Control-Request-Headers** header, together with the origin of the request:

```
OPTIONS http://adventure-works.com/orders/2 HTTP/1.1
...
Origin: http://adventure-works.com
Access-Control-Request-Method: DELETE
Access-Control-Request-Headers: Custom-Header
```

If the web server allows this particular request, it should send a response that includes an appropriate **Access-Control-Allow-Methods** header that specified the operations that are permitted, and/or the **Access-Control-Allow-Headers** header if the preflight request specifies a custom header:

```Access-Control-Allow-Origin: http://adventure-works.com
Access-Control-Allow-Methods: DELETE, GET, POST, PUT
Access-Control-Allow-Headers: Custom-Header
```

When the web application receives this response, it can then send the real request in the knowledge that it should be honored. If the server wishes to deny the request, it can send a generic response (with a 200 status code), but without any CORS headers. Note that, as far as the web application is concerned, as long as the browser is CORS enabled, preflight requests are performed automatically and you do not normally have to write any additional application code to handle them. Most of the effort is involved in configuring the web server that is the target of the requests.

Performing requests that require preflight checks can be expensive due to the increased network traffic and latency involved. Many browsers and servers support caching of preflight responses. As part of the response to a preflight request, the server can include an **Access-Control-Max-Age** header that specifies the number of seconds for which the preflight request remains valid. If the web application makes additional requests to the same resource within this time, the preflight checks do not need to be performed and the web application does not have to send an OPTIONS request.

### Considerations for cross-origin resource sharing
Consider the following points related to cross-origin resource sharing:

- CORS requires that the web browser supports the appropriate HTTP headers (_Origin_ and _Access-Control-Allow-Origin_). Most modern browsers have this capability built in and use it automatically. For a list of supported browsers, see [Can I Use CORS?](http://caniuse.com/#search=cors)
- If you are building web applications intended to run in Internet Explorer 10 onwards, use the **XMLHttpRequest** object to send requests rather than the legacy **XDomainRequest** object. While the **XDomainObject** supports some aspects of CORS, it has a number of limitations. For example, it only supports HTTP **GET** and **POST** methods, it only supports a Content-Type of plain/text in the request header, and it does not permit authentication information or cookies to be included in a request. For more information, see the article [XDomainRequest – Restrictions, Limitations, and Workarounds](http://blogs.msdn.com/b/ieinternals/archive/2010/05/13/xdomainrequest-restrictions-limitations-and-workarounds.aspx). 
- CORS requires that the server hosting the web service is configured to enable cross-origin requests. This process will vary according to the web server, but for detailed information on enabling CORS in an ASP.NET web service, see the article [Enabling Cross-Origin Requests in ASP.NET Web API](http://www.asp.net/web-api/overview/security/enabling-cross-origin-requests-in-web-api#how-it-works).
- Prior to the adoption of CORS, many developers used [JSONP](http://en.wikipedia.org/wiki/JSONP) (JSON with Padding) to enable web applications to request data from a server running in a different domain. JSONP utilizes the fact that browsers do not enforce the same-origin restriction on **script** elements, enabling a web application to use these tags to access a URL that identifies a resource located a different server. However, JSONP has some limitations. For example, you can only use it to retrieve data from a remote server. There are also some security concerns as it is possible that the resource referenced by a **script** element could actually contain malicious content which is easily injected into your web application. For these reasons, it is recommended that you adopt CORS rather than JSONP if you need to access resources held in a different web domain.
- CORS might be considered a cross cutting concern, and it can be handled at application, controller or action level using message handler or attribute annotation. For example:

	```
[EnableCors("origin","verbs","headers")]
public void Post([FromBody]string value)
{ ... }
```

- Consider using the classes in the Microsoft.Owin.Cors namespace and handling CORS concerns in your OWIN middleware. This moves CORS handling code out of the API. The disadvantage with this approach is that you lose the ability to assert granular control over actions. For more information, see [CORS Support in ASP.NET Web API 2](http://msdn.microsoft.com/en-us/dn532203.aspx).

## Repudiation
Repudiation is an attempt by a user or a business entity to deny or challenge a claim that a specific action took place. For example, a user may deny executing a specific business process. It is vital to maintain logs of all significant actions that are executed by users or by other applications in order to provide evidence in the case of repudiation.

### Considerations for repudiation
Consider the following points related to repudiation:

- Log the identity of all users so that you can track critical business transactions, whether these are legitimate or not.
- Log the identity of the user for all authentication and authorization failures.
- Log the identity of the user for all failed business transactions.
- You can retrieve the identity of use in an API from **ClaimsPrincipal.Current.Identities**.

## Data validation
Data validation includes checking all data at every level or boundary to ensure both security and reliability of applications. Invalid data can cause information loss, data corruption, and can prevent applications from performing correctly. Malicious attacks often make use of specially crafted invalid data inputs to cause system errors or information disclosure.

### Considerations for data validation
Consider the following points related to data validation:

- Validate all data received by services, applications, APIs, and components, especially where the reliability of the source of the data cannot be absolutely guaranteed.
- Validate all data inputs to vital business processes, irrespective of where it comes from.
- Validate using an allow-list approach instead of a block-list approach wherever possible. Block-list validation is unlikely to cover all of the possible risks and edge cases.
- Ensure that any errors that may arise from invalid data being accepted cannot result in the application behaving abnormally, failing in an unspecified state, or generating error messages that may disclose sensitive information.

# Implementing security using OWIN
The Open Web Interface for .NET (OWIN) is an extensible pipeline mechanism. This section describes good practice techniques for implementing security using OWIN. The following schematic shows the Web API V2 components.

[insert graphic](#insertgraphic#)

## Message handlers

Message handlers are low level interfaces that allow you to override the asynchronous methods and inspect the request object, before returning a result. For example:

```public class MessageHandler1 : DelegatingHandler
{
  protected async override Task<HttpResponseMessage> SendAsync(
        HttpRequestMessage request, CancellationToken cancellationToken)
  {
    // Call the inner handler.
    var response = await base.SendAsync(request, cancellationToken);
    Debug.WriteLine("Process response");
    return response;
  }
}
```

## Authentication filters
Authentication filters are part of the web API framework, and can be used to invoke OWIN security calls and authentication middleware. A service can use more than one authentication provider if required; typically this approach is used in more advanced scenarios where you support authentication through multiple identity providers (for example, certificate authentication and Azure Active Directory) and you need to normalize the claims they provide.

When you use multiple authentication providers, users accessing the service with a web browser (the passive authentication scenario) will be redirected to the first one. In the active authentication scenario, where a client application performs authentication by accessing a provider directly, the client can choose which one to use, and can authenticate with more than one if required. In this case, the **ClaimsPrincipal** will have multiple identities—one for each provider.

You can specify which authentication provider(s) must be used for a controller and for individual actions in a service. If one or more providers is not specified, the controller and the actions will accept requests from clients that were authenticated with any of the configured providers.

As an example, you can use the following approach to map controllers or actions to an authentication scheme when your application has more than one authentication provider configured.

- In a startup class you specify all of the authentication providers you want to support:

	```
app.UseActiveDirectoryFederationServicesBearerAuthentication(
    new ActiveDirectoryFederationServicesBearerAuthenticationOptions
            { AuthenticationType="wsfederation" } )
app.UseWindowsAzureActiveDirectoryBearerAuthentication(
    new WindowsAzureActiveDirectoryBearerAuthenticationOptions
        { AuthenticationType="bearer" })
```

- In an API controller class you can use an attribute to specify the authentication provider for all actions in that controller:

	```[Authorize]
[HostAuthentication("bearer")]
public class ValuesController : ApiController
{ ...
```

- In the individual actions in a web controller action, you can use an attribute to specify the authentication provider:

	```[HostAuthentication("bearer")]
        public async Task<HttpResponseMessage> Get(string Id)
        { ...
```

## Considerations for using OWIN
Consider the following when using OWIN middleware:

- Do not use authentication logic code inside extensibility points such as authentication filters or message handlers because this will couple the API façade to functional cross cutting concerns, creating a dependency on the host (such as IIS) and affecting performance and scalability of your application. 

More information about OWIN is available at [OWIN - Open Web Interface for .NET](http://owin.org/).

## OWIN middleware example - applying HMAC authentication

To implement HMAC authentication logic code in OWIN middleware, do the following:

1. Create a class that derives from **AuthenticationOptions** in the Microsoft.Owin.Security namespace. The new class will contain the configuration settings for the authentication provider you are implementing, and will be passed to the middleware. The settings can be any configurable setting such as the key, lifetime, validation rules, and other details of your provider.

	```public class HmacAuthenticationOptions : AuthenticationOptions
{
  public HmacAuthenticationOptions() : base("Hmac")
  { 
  }
  public string Key { get; set; }
  public DateTimeOffset dateOffset { get; set; }
}```

2. Create a middleware class that derives from **AuthenticationMiddleware** in the Microsoft.Owin.Security.Infrastructure namespace. This class takes the **AuthenticationOptions** type you created in the previous step as a generic type and it must override the **CreateHandler** method to instantiate your new custom authentication handler.

	```public class HmacAuthenticationMiddleware :
               AuthenticationMiddleware<HmacAuthenticationOptions>
{
  public HmacAuthenticationMiddleware(OwinMiddleware next, IAppBuilder app,
                      HmacAuthenticationOptions options) : base(next, options)
  {
  }
  protected override AuthenticationHandler<HmacAuthenticationOptions> CreateHandler()
  {
    return new HmacAuthenticationHandler();
  }
}```

3. Create the **AuthenticationHandler** class that encapsulates your authentication logic. If authentication is successful for a request, code in the handler must create an identity and any required claims, adds the claims to the identity, and create an **AuthenticationTicket** instance using the identity and the authentication options of your identity provider. It must then return a **Task** as an **AuthenticationTicket**. If authentication fails, the method must return **null** instead.

	```protected override Task<AuthenticationTicket> AuthenticateCoreAsync()
{
  string privateKey = Options.Key;
  // Your authentication logic goes here
  if(authenticated) 
  { 
    ClaimsIdentity identity = new ClaimsIdentity("Hmac");
    Claim claim = new Claim(ClaimTypes.Name,"Hmac");
    identity.AddClaim(claim);
    AuthenticationProperties authprops= new AuthenticationProperties {
           AllowRefresh = options.allowrefresh, ExpiresUtc = Options.dateOffset };
    var ticket = new AuthenticationTicket(identity, authprops);
    return Task.FromResult(ticket);
  }
  else
  {
    return Task.FromResult<AuthenticationTicket>(null);
  }
}```

4. Create an authentication extension method that returns the **AppBuilder** with the middleware class you created in previous steps.

	```public static class HmacAuthenticationExtensions
{
  public static IAppBuilder UseHmacAuthentication(this IAppBuilder app,
                                         HmacAuthenticationOptions options)
  {
    return app.Use(typeof(HmacAuthenticationMiddleware), app, options);
  }
}```

5. Wire up the authentication provider in the startup class using the authentication extensions class.

	```public partial class Startup
{
  public void ConfigureAuth(IAppBuilder app)
  {
    app.UseHmacAuthentication(new HmacAuthenticationOptions {
                            Key = "W9cE42m+fmBX...WD/Awiw==", 
                            dateOffset = new DateTimeOffset().AddMinutes(10) });
  }
}```

# More information
- [HMAC: Keyed-Hashing for Message Authentication.](http://www.ietf.org/rfc/rfc2104.txt)
- [RFC 2617, HTTP Authentication: Basic and Digest Access Authentication](http://www.ietf.org/rfc/rfc2617.txt)
- [RFC 2069, An Extension to HTTP: Digest Access Authentication](http://www.ietf.org/rfc/rfc2069.txt)
- [Welcome to OpenID Connect](http://openid.net/connect/)
- [Transport Layer Security Protocol](http://msdn.microsoft.com/en-us/library/windows/desktop/aa380516(v=vs.85).aspx)
- [Preventing Cross-Site Request Forgery (CSRF) Attacks](http://www.asp.net/web-api/overview/security/preventing-cross-site-request-forgery-(csrf)-attacks)
- [Cross-Origin Resource Sharing](http://www.w3.org/tr/cors/)
- [Enabling Cross-Origin Requests in ASP.NET Web API](http://www.asp.net/web-api/overview/security/enabling-cross-origin-requests-in-web-api#how-it-works)
- [A Guide to Claims-Based Identity and Access Control](http://msdn.microsoft.com/en-us/library/ff423674.aspx)
- [OWIN - Open Web Interface for .NET](http://owin.org/)