This guide presents data flow diagrams for [Azure Communication Services](/azure/communication-services). Use these diagrams to understand how your clients and services interact with Azure to deliver communication experiences.

 Communication Services is a cloud-based service with REST APIs and client library SDKs to help you integrate communication into your applications. Communication Services supports multiple communication formats: voice and video calling, text chat, SMS, and custom binary data.

You can add communication to web and mobile apps, integrate custom services and bots, and programmatically access the public switched telephony network (PSTN). You can acquire [phone numbers](/azure/communication-services/concepts/numbers/number-types) directly from Azure Communication Services APIs or the Azure portal and use these numbers for SMS or voice calling applications. By using [Communication Services direct routing](/azure/communication-services/concepts/telephony/telephony-concept#azure-direct-routing), you can bring your own telephony provider via Session Initiation Protocol (SIP) and Session Border Controllers.

The following components are used in these data flow diagrams:

- **Client application.** A website or native application used by end users for communication. Communication Services provides [SDK client libraries](/azure/communication-services/concepts/sdk-options) for browsers and native apps. [The open-source UI Library](/azure/communication-services/concepts/ui-library/ui-library-overview?pivots=platform-web) that's built on these SDKs provides programmable web (React), iOS, and Android UI components.
- **Identity management service.**  A service that you build to map users and services to Communication Services identities. This service also creates tokens for users when they need to access the data plane.
- **Communication controller service.**  A service that you build to control chat threads and voice and video calls.
- **Communication data service.**  A service capability that you build to directly interact with communication content, like sending chat and SMS messages or playing audio in a voice call.

Industry standards for communication, like [WebRTC](https://webrtc.org), separate communication into a *control and signaling plane* and a *data plane*. By using Communication Services, you can build a communication experience without needing to understand the service's internal implementation of WebRTC. These concepts can, however, help you design your app:

| System  | Function| Protocols  | Access model   |
|---|---|-----|--|
| **Control plane** | Governs who communicates, when, and how | REST | [Azure AD service credentials](/azure/communication-services/concepts/authentication#azure-ad-authentication) |
| **Data plane**| Contains communication content, voice, video, text, and data that interface with humans and apps | UDP, [RTMP](/azure/communication-services/concepts/voice-video-calling/network-requirements), WebSockets, REST | [User access tokens](/azure/communication-services/concepts/authentication#user-access-tokens) and Azure AD service credentials |

A common data flow occurs when client applications initiate communication by requesting control information from a service controller:

- What meetings do I have today?
- What phone number do I use to call my friend Joseph?
- What are the names of my teammates? What ongoing chat threads do we have?

Your control service fulfills these requests by providing clients with Communication Services tokens and identifiers for users, threads, phone numbers, and calls. Clients then use these tokens and identifiers to interact with the Azure data plane. Communication Services APIs don't constrain the design of your end-user experience or the processes that control communication.

In the WebRTC standard, clients request control information from services by sending *control messages* in a process known as *signaling*. Communication Services identifiers like call ID are comparable to [WebRTC session descriptions](https://datatracker.ietf.org/doc/html/rfc8866).

## Users authenticated via user access tokens

Communication Services clients present user access tokens to access, with improved security, the Azure calling and chat data plane. You should generate and manage user access tokens by using a trusted service. The token and the connection string or Azure Active Directory (Azure AD) secrets that are necessary to generate them need to be protected. Failure to properly manage access tokens can result in additional charges because of misuse of resources.

:::image type="content" source="./media/architecture-identity.png" alt-text="Diagram that shows the user access token architecture." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-communication-services-architecture.vsdx) of this architecture.*

### Dataflow

1. A user starts the client application.
2. The client application contacts your identity management service. The identity management service maintains a mapping between application identities and  Communication Services identities. (Application identities include your users and other addressable objects, like services or bots.)
3. The identity management service uses the mapping to [issue a user access token](/rest/api/communication/communication-identity/issue-access-token) for the applicable identity.

Azure App Service or Azure Functions are two alternatives for operating the identity management service. These services scale easily and have built-in features to [authenticate](/azure/app-service/overview-authentication-authorization) users. They're integrated with [OpenID](/azure/app-service/configure-authentication-provider-openid-connect) and third-party identity providers like [Facebook](/azure/app-service/configure-authentication-provider-facebook).

### Resources

- **Concept:** [User identity](/azure/communication-services/concepts/identity-model)
- **Quickstart:** [Create and manage access tokens](/azure/communication-services/quickstarts/access-tokens)
- **Tutorial:** [Build an identity management service using Azure Functions](/azure/communication-services/tutorials/trusted-service-tutorial)
- **Sample:** [Build an identity management service using Azure Functions](https://github.com/Azure-Samples/communication-services-authentication-hero-nodejs)

## User calls an app or phone number

The simplest voice and video calling scenario involves a user calling another user in the foreground without push notifications. You can integrate Communication Services voice and video calling into web, native mobile, and Windows desktop apps. The [open-source UI Library](/azure/communication-services/concepts/ui-library/ui-library-overview?pivots=platform-web) can help you accelerate development.

:::image type="content" source="./media/call-without-notifications.png" alt-text="Diagram that shows Communication Services calling without push notifications." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-communication-services-architecture.vsdx) of this architecture.*

### Dataflow

1. The initiating user obtains the Communication Services identity of the person they want to call. In a typical scenario, the user gets the identity from a *friends list* that's maintained by the identity management service. The list collates the user's friends and associated Communication Services identities.
1. The initiating user starts the Call client and calls the remote user.
1. The accepting user is notified of the incoming call via the Calling SDK. To receive incoming calls, the acceptor must have already initialized the Call client.
1. The users communicate with each other via voice and video in a call.

The dataflow is nearly identical when a user calls an external phone number. The key  difference is that, to access traditional telephony, the initiating user client must request source and destination phone numbers from the controller service, instead of requesting user identities.

In some situations, you might want apps to accept calls in the background by using platform services like Apple Push Notification. You can enable this functionality by integrating [Communication Services with Azure Notification Hubs](/azure/communication-services/concepts/notifications).

### Resources

- **Concept:** [Calling overview](/azure/communication-services/concepts/voice-video-calling/calling-sdk-features)
- **Concept:** [UI Library](/azure/communication-services/concepts/ui-library/ui-library-overview)
- **Quickstart:** [Add voice calling to your app](/azure/communication-services/quickstarts/voice-video-calling/getting-started-with-calling)
- **Quickstart:** [Add video calling to your app](/azure/communication-services/quickstarts/voice-video-calling/get-started-with-video-calling)
- **Sample:** [Group calling for web, iOS, and Android](/azure/communication-services/samples/calling-hero-sample)

## User joins a group call without an invitation

You might want users to be able to join a group call without an explicit invitation. Your app might provide a persistent *social space* or *club* that includes a video calling channel that users can join when they want to. This dataflow shows a call that's initially created by a client and allows a remote client to join without explicit invitation:

:::image type="content" source="./media/call-join-client-driven.png" alt-text="Diagram that shows a call without an invitation." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-communication-services-architecture.vsdx) of this architecture.*

### Dataflow

1. The initiating user initializes the Call client and makes a group call.
2. The initiating user shares the group call ID with a communication controller service.
3. The communication controller service shares the call ID with other users. For example, if the application provides user clubs, the group call ID is an attribute of the club's data model that's stored in Azure Cosmos DB.
4. Other users join the call by using the group call ID.
5. Users communicate with each other via voice and video in a call.

## Microsoft 365 and Teams

Many organizations use Microsoft 365 and Teams for communication. [Communication Services and Teams are interoperable,](/azure/communication-services/concepts/teams-interop) which enables these scenarios:

- **Build a custom application to allow an external user to join a Teams meeting.** This scenario is ideal for virtual visit scenarios, where a business that's using Teams hosts a meeting for external consumers who are using a custom app and a custom identity. To learn more about this scenario, see [Virtual visits tutorial and Sample Builder](/azure/communication-services/tutorials/virtual-visits).
- **Build a custom application for an internal user with Teams / Azure AD credentials.** This scenario is designed for building custom Teams clients for employees.

These custom application scenarios use [Microsoft Graph APIs](/graph/overview?view=graph-rest-1.0) and Communication Services. When you build external apps and services that connect to Teams, you generally use Microsoft Graph as the *Teams control plane*. You use this control plane to configure who communicates and how and when they communicate by using APIs for:

- [Teams](/graph/api/resources/team?view=graph-rest-1.0)
- [Calendar and online meetings](/graph/choose-online-meeting-api?view=graph-rest-1.0)

You use information from these control APIs, like the meeting URL and thread identifier, to connect Communication Services calling and chat clients to the Teams data plane.

[Teams also has SDKs](/microsoftteams/platform/get-started/get-started-overview) for adding custom functionality *within* Teams experiences and through the [Teams store](/microsoftteams/platform/concepts/deploy-and-publish/appsource/publish), like tabs, bots, and automation. These scenarios are beyond the scope of this article.

Communication Services doesn't directly support interactions with Teams channels. For custom applications, you can use the Microsoft Graph [Chat](/graph/api/chat-get?view=graph-rest-1.0&tabs=http) and [Channel](/graph/api/channel-get?view=graph-rest-1.0&tabs=http) APIs to build custom clients for employees who access channels.

## Application joins a scheduled Teams call
Communication Services applications can join Teams calls. For external users, the application needs a link to the Teams meeting. Link retrieval is managed via Microsoft Graph APIs. Here's the dataflow:

:::image type="content" source="./media/teams-driven-join.png" alt-text="Diagram showing Communication Services architecture for joining a Teams meeting." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-communication-services-architecture.vsdx) of this architecture.*

### Dataflow

1. (1A) The communication controller service schedules the group call by using the [Microsoft Graph API](/graph/api/resources/onlinemeeting?view=graph-rest-1.0&preserve-view=true). In another use case, (1B), users schedule the group call by using Outlook or Teams.
2. The communication controller service shares the details of the Teams call with Communication Services clients.
3. Typically, a Teams user must join the call via the Teams UI and allow external users to pass through the Teams pre-call lobby. However, this requirement depends on the configuration of the Teams tenant and the specific meeting settings.
4. Communication Services users initialize the Call client and join the Teams meeting by using the details received in step 2.
5. Users communicate with each other via voice and video.

### Resources

- **Tutorial and Sample Builder:**  [Virtual visits](/azure/communication-services/tutorials/virtual-visits)
- **Concept:** [Teams interoperability](/azure/communication-services/concepts/teams-interop)
- **Quickstart:** [Join a Teams meeting](/azure/communication-services/quickstarts/voice-video-calling/get-started-teams-interop)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Chris Palmer](https://www.linkedin.com/in/palmerchristopher) | Principal Group Product Manager

Other contributors:

 - [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
 - Mick Bengtson | Content Developer
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Communication Services?](/azure/communication-services/overview)
- [Create a Communication Services resource](/azure/communication-services/quickstarts/create-communication-resource)
- [Communication Services reference documentation](/azure/communication-services/concepts/reference)
- [Learn module: Introduction to Azure Communication Services](/learn/modules/intro-azure-communication-services)
- [Learn module: Create a voice calling web app with Azure Communication Services](/learn/modules/communication-services-voice-calling-web-app)

## Related resources

- [Governance of Microsoft Teams guest users](../../example-scenario/governance/governance-teams-guest-users.yml)
- [Real-time presence with Microsoft 365, Azure, and Power Platform](../../solution-ideas/articles/presence-microsoft-365-power-platform.yml)