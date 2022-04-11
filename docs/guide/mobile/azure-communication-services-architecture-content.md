This guide presents data flow diagrams for [Azure Communication Services (ACS)](https://docs.microsoft.com/en-us/azure/communication-services/). Use these diagrams to understand how your clients and services interact with Azure, and with each other, to deliver communication experiences. 

Azure Communication Services are cloud-based services with REST APIs and client library SDKs to help you integrate communication into your applications. Azure Communication Services supports multiple communication formats: voice and video calling, text chat, SMS and custom binary data. 

You can add communication to Web and mobile apps, integrate custom services and bots, and progammatically access the publicly switched telephony network (PSTN). You can acquire [phone numbers](https://docs.microsoft.com/azure/communication-services/concepts/numbers/number-types) directly from Azure Communication Services APIs or the Azure portal; and use these numbers for SMS or voice calling applications. [Azure Communication Services direct routing](https://docs.microsoft.com/azure/communication-services/concepts/telephony/telephony-concept#azure-direct-routing) allows you to bring your own telephony provider using SIP and session border controllers.

Several components are used in these data flow diagrams:

1. **Client Application.** This website or native application is used by end users to communicate. Azure Communication Services provides [SDK client libraries](https://docs.microsoft.com/azure/communication-services/concepts/sdk-options) for browsers and native apps. [An open-source UI Library](https://aka.ms/acsstorybook) built on these SDKs provides programmable Web (React), iOS, and Android UI components.
1. **Identity Management Service.**  This service capability you build to map users and services to Azure Communication Services identities and create tokens for those users when required to access the data plan.
1. **Communication Controller Service.**  This service capability you build to **control** chat threads, voice and video calls.
1. **Communication Data Service.**  This service capability you build to interact with communication **content** directly such as sending chat and SMS messages or playing audio in a voice call.

Industry standards for communication such as [WebRTC](https://webrtc.org/) separate communication into a **control & signaling plane** and **data plane**. Azure Communication Services allows you to build communication experience without understanding the service's internal implementation of WebRTC, but these concepts can help you design your app:

| System  | Function| Protocols  | Access Model   |
|---|---|-----|--|
| **Control Plane** | Governs who communicates, when, and how | REST | [Azure Active Directory service credentials](https://docs.microsoft.com/azure/communication-services/concepts/authentication#azure-ad-authentication) |
| **Data Plane**| Communication content, voice, video, text, data, that interface with humans and apps | UDP, [RTMP](https://docs.microsoft.com/azure/communication-services/concepts/voice-video-calling/network-requirements), WebSockets, REST | [User access tokens](https://docs.microsoft.com/azure/communication-services/concepts/authentication#user-access-tokens) and AAD service credentials |

A common data flow is client applications initiating communication by requesting control information from a service controller:

1. What meetings do I have today?
2. What phone number do I use to call my friend Joseph? 
3. What are the names of my teammates? What chat threads do we have on-going?

Your control service fulfills these requests by providing clients Azure Communication Services tokens and identifiers for users, threads, phone numbers, and calls, which are then used by clients to interact with the Azure data plane. Azure Communication Service APIs do not constrain the design of your end-user experience or the concepts that control communcation. 

In the WebRTC standard, the process of clients requesting control information from services is called *control messages* or *signaling* - and ACS identifiers such as call ID are comparable to [WebRTC session descriptions](https://datatracker.ietf.org/doc/html/rfc8866). 

## Authenticate users with user access tokens

Azure Communication Services clients present `user access tokens` to access the Azure calling and chat data plane securely. `User access tokens` should be generated and managed by a trusted service due to the sensitive nature of the token and the connection string or Azure Active Directory secrets necessary to generate them. Failure to properly manage access tokens can result in additional charges due to misuse of resources.

:::image type="content" source="./media/architecture_v2_identity.svg" alt-text="Diagram showing user access token architecture.":::

### Dataflows
1. The user starts the client application. 
2. The client application contacts your identity management service. The identity management service maintains a mapping between your users and other addressable objects (for example services or bots) to Azure Communication Service identities.
3. The identity management service [issues a user access token](https://docs.microsoft.com/rest/api/communication/communicationidentity/communication-identity/issue-access-token) for the applicable identity. 

Azure App Services or Azure Functions are straightforward options for operating the identity management service. These services scale easily and have built-in features to [authenticate](https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization) end-users. They are integrated with [OpenID](https://docs.microsoft.com/azure/app-service/configure-authentication-provider-openid-connect) and 3rd party identity providers such as [Facebook](https://docs.microsoft.com/azure/app-service/configure-authentication-provider-facebook).

### Resources
- **Concept:** [User Identity](https://docs.microsoft.com/azure/communication-services/concepts/identity-model)
- **Quickstart:** [Create and manage access tokens](https://docs.microsoft.com/azure/communication-services/quickstarts/access-tokens)
- **Tutorial:** [Build a identity management service use Azure Functions](https://docs.microsoft.com/azure/communication-services/tutorials/trusted-service-tutorial)
- **Sample:** [Build a identity management service use Azure Functions](https://github.com/Azure-Samples/communication-services-authentication-hero-nodejs)

## User calling an app or phone number 
The simplest voice and video calling scenario involves a user calling another user in the foreground without push notifications.

:::image type="content" source="./media/architecture_v2_calling_without_notifications.svg" alt-text="Diagram showing Communication Services architecture calling without push notifications.":::

### Dataflows

1. The accepting user initializes the Call client, allowing them to receive incoming phone calls.
2. The initiating user needs the Azure Communication Services identity of the person they want to call. A typical experience may have a *friend's list* maintained by the identity management service that collates the user's friends and associated Azure Communication Service identities.
3. The initiating user initializes their Call client and calls the remote user.
4. The accepting user is notified of the incoming call through the Calling SDK.
5. The users communicate with each other using voice and video in a call.

Azure App Services is a straightforward option for create a custom Web app. This flow is nearly identical in cases where a user is calling an external phone number, distinguished only by the requirement that the initiating user request from the controller the source and destination phone numbers.

 ### Resources
- **Concept:** [Calling Overview](voice-video-calling/calling-sdk-features.md)
- **Quickstart:** [Add voice calling to your app](https://docs.microsoft.com/azure/communication-services/quickstarts/voice-video-calling/getting-started-with-calling.md)
- **Quickstart:** [Add video calling to your app](https://docs.microsoft.com/azure/communication-services/quickstarts/voice-video-calling/get-started-with-video-calling.md)
- **Hero Sample:** [Group Calling for Web, iOS, and Android](https://docs.microsoft.com/azure/communication-services/samples/calling-hero-sample.md)

## User joining a group call without solicitation
You may want users to join a call without an explicit invitation. For example your app may have a persistant *social space* or *club* that is includes a video callling channel, and users join that video call at their leisure. In this dataflow, we show a call that is initially created by a client.

:::image type="content" source="./media/architecture_v2_calling_join_client_driven.svg" alt-text="Diagram showing Communication Services architecture calling out-of-band signaling.":::

### Dataflows
1. Initiating user initializes their Call client and makes a group call.
2. The initiating user shares the group call ID with a Communication Controller service.
3. The communication controller service shares the call ID with other users. For example, if the application orients around clubs, the group call ID would be an attribute of the club's data model stored in CosmosDB.
4. Other users join the call using the group call ID.
5. The users communicate with each other using voice and video in a call.

## Extending Microsoft 365 & Teams
Many organizations use Microsoft 365 and Teams for communication. [Azure Communcication Services and Teams are interoperable](https://docs.microsoft.com/azure/communication-services/concepts/teams-interop.md) which enables these scenarios:

1. **Building a custom application for an external user to join a Teams meeting.** This is ideal for virtual visit scenarios where a business using Teams hosts a meeting for external consumers who are using a custom app and a custom identity. Check out the [Virtual Visits tutorial and Sample Builder](https://review.docs.microsoft.com/en-us/azure/communication-services/tutorials/virtual-visits?branch=pr-en-us-184102) to learn more about this specific scenario.
2. **Building a custom application for an internal user with Teams/AAD credentials.** This is designed for building custom Teams clients for employees. For example [Landis Technologies](https://landistechnologies.com/microsoft-teams-attendant-console/) offers a custom attendant app that answers calls to Teams phone numbers.

These custom application scenarios combine usage of [Microsoft Graph APIs](https://docs.microsoft.com/en-us/graph/overview?view=graph-rest-1.0) and Azure Communication Services. When building external apps and services that connect to Teams, you generally Graph as the *Teams control plane* - configuring who, how, and when users communicate using APIs for:

- [Teams](https://docs.microsoft.com/graph/api/resources/team?view=graph-rest-1.0)
- [Calendar and online meetings](https://docs.microsoft.com/en-us/graph/choose-online-meeting-api?view=graph-rest-1.0)

You use information from these control APIs like `meeting URL` and `thread identifier` to connect Azure Communication Service Calling and Chat clients to the Team's data plane.

[Teams also has SDKs](https://docs.microsoft.com/en-us/microsoftteams/platform/get-started/get-started-overview) for adding custom experiences *within* the Teams experiences and through the [Teams store](https://docs.microsoft.com/microsoftteams/platform/concepts/deploy-and-publish/appsource/publish) such as tabs, bots, and automation. These scenarios are outside this article's scope. 

Azure does not support interoperability with Team channels. Use Graph's [Chat](https://docs.microsoft.com/graph/api/chat-get?view=graph-rest-1.0&tabs=http) and [Channel](https://docs.microsoft.com/en-us/graph/api/channel-get?view=graph-rest-1.0&tabs=http) APIs to build custom clients for employees accessing channels. 

## Joining a scheduled Teams call
Azure Communication Service applications can join Teams calls. For external users, they need a link to the Teams meeting, and this is managed using Graph APIs. The complete flow is below:

:::image type="content" source="./media/architecture_v2_calling_join_teams_driven.svg" alt-text="Diagram showing Communication Services architecture for joining a Teams meeting.":::


### Dataflows
1. The Communication Controller Service creates a group call with [Graph APIs](/graph/api/resources/onlinemeeting?view=graph-rest-1.0&preserve-view=true). Another pattern involves end users creating the group call using [Bookings](https://www.microsoft.com/microsoft-365/business/scheduling-and-booking-app), Outlook or Teams.
2. The communication controller service shares the Teams call details with Azure Communication Service clients.
3. Typically, a Teams user must join the call and allow external users to join through the lobby. However this experience is sensitive to the Teams tenant configuration and specific meeting settings.
4. Azure Communication Service users initialize their Call client and join the Teams meeting, using the details received in Step 2.
5. The users communicate with each other using voice and video in a call.

### Resources
- **Concept:** [Teams Interoperability](https://docs.microsoft.com/en-us/azure/communication-services/concepts/teams-interop.md)
- **Quickstart:** [Join a Teams meeting](https://docs.microsoft.com/azure/communication-services/quickstarts/voice-video-calling/get-started-teams-interop.md)

## Next steps
- [What is Azure Communication Services?](https://docs.microsoft.com/en-us/azure/communication-services/overview)
- [Create a Communication Services resource](https://docs.microsoft.com/en-us/azure/communication-services/quickstarts/create-communication-resource)
- [Azure Communication Services Client and Server Architecture](https://docs.microsoft.com/en-us/azure/communication-services/concepts/client-and-server-architecture)

## Related resources
- [Azure Communication Services Reference docs](https://docs.microsoft.com/en-us/azure/communication-services/concepts/reference)
