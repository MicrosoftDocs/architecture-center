[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Collaboration tools play a significant role in creating productive workspaces for teams. Microsoft 365 tools like Microsoft Teams, Word, and PowerPoint online bring people together and help them to work more effectively. In addition to supporting real-time changes to documents and data, these tools also support real-time presence information. Presence makes it easy to know your teammates' availability and see when they join a collaboration session.

You can also add presence to custom collaboration applications by using Microsoft Cloud services. This solution uses Microsoft Cloud APIs and services to enable real-time presence capabilities in custom applications. As people become available in Microsoft Teams, they can be invited to a collaboration session.

The solution provides presence for a JavaScript front-end application. It uses Microsoft Graph and Azure Active Directory (Active Directory) to provide real-time presence information. It also uses Power Automate, Azure Event Hubs, Azure Functions, and Azure SignalR Service.

## Potential use cases
This solution applies to companies that use custom applications that require:
- Real-time change tracking on Microsoft 365 data.
- Broadcasting of data to the browser in real time.
- Notifications to application users when a person's availability changes.
- A secure way to retrieve secrets that are used in an application.

## Architecture

![Diagram that shows a solution for providing teammate presence information.](.media/real-time-presence.png)

*Download a [PowerPoint file](https://arch-center.azureedge.net/real-time-presence.pptx) of this architecture.*

The solution uses the Microsoft Graph API presence resource to detect changes in a given person's presence. It uses Microsoft Graph change notifications that send presence messages to Azure Event Hubs. The messages received in Event Hubs are used as an input to Azure Functions. Azure SignalR Service then sends the data to the browser in real time. 

 It uses Azure AD and Power Automate to create a Microsoft Graph API presence subscription.

### Workflow

1. A Power Automate flow gets an access token for Microsoft Graph by using Azure AD.
2. The Power Automate flow retrieves members of the selected team who are on Microsoft Teams. The flow creates a subscription and updates it every hour to track changes in presence for the selected team members.
3. When there's a change in member presence, the Microsoft Graph Change Tracking application policy gets a connection string to Event Hubs from Key Vault.         
4. When a Microsoft Graph change notification is processed, the message is placed in Event Hubs.
5. Azure Functions uses an Event Hubs trigger to receive the Microsoft Graph presence messages. 
6. Azure SignalR Service is defined as an output in Azure Functions. This allows a browser to subscribe to Azure SignalR Service and receive messages in real time. 
7. To receive the presence messages in the browser, an app subscribes to Azure SignalR Service.

### Components

- [Microsoft Graph](/graph/overview) is the gateway to data and intelligence in Microsoft 365.
- [Azure AD](https://azure.microsoft.com/services/active-directory) is the Microsoft cloud-based identity and access management service that helps users sign in and access resources.
- [Power Automate](https://powerautomate.microsoft.com) helps automating repetitive manual tasks by recording mouse clicks, keystrokes and copy paste steps from your desktop.
- [Key Vault](https://azure.microsoft.com/services/key-vault) is a cloud service for storing and accessing secrets with high security.
- [Event Hubs](https://azure.microsoft.com/services/event-hubs) is a scalable event processing service that ingests and processes large volumes of events and data, with low latency and high reliability.
- [Azure Functions](https://azure.microsoft.com/services/functions) is a serverless solution that enables you to write less code, maintain less infrastructure, and save money.  
  - [Event Hubs triggers](/azure/azure-functions/functions-bindings-event-hubs-trigger) enable you to respond to an event sent to an event hub event stream. 
  - [SignalR Service output binding](/azure/azure-functions/functions-bindings-signalr-service-output) enable you to send messages by using Azure SignalR Service.
- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service) simplifies the process of adding real-time web functionality to applications over HTTP.
- [Azure Static Web Apps](https://azure.microsoft.com/services/app-service/static) automatically builds and deploys full stack web apps to Azure from a code repository.

## Next steps
Get a [code sample](https://github.com/microsoft/brainstorm-fluidframework-m365-azure) that demonstrates this solution.

For more information about the services and products that are used in this solution, see these articles:
- [Microsoft Graph](/graph/overview)
- [Azure AD](/azure/active-directory/fundamentals/active-directory-whatis)
- [Power Automate](/power-automate)
- [Key Vault](/azure/key-vault/general/overview)
- [Event Hubs](/azure/event-hubs/event-hubs-features)
- [Azure Functions](/azure/azure-functions/functions-overview)
- [Azure SignalR Service](/azure/azure-signalr) 

## Related resources
- [Enhanced-security hybrid messaging infrastructure—web access](../../example-scenario/hybrid/secure-hybrid-messaging-web.yml)
- [Enhanced-security hybrid messaging infrastructure—mobile access](../../example-scenario/hybrid/secure-hybrid-messaging-mobile.yml)
- [Manage Microsoft 365 tenant configuration by using Microsoft365DSC and Azure DevOps](../../example-scenario/devops/manage-microsoft-365-tenant-configuration-microsoft365dsc-devops.yml)
- [Power Automate deployment at scale](../../example-scenario/power-automate/power-automate.yml)
