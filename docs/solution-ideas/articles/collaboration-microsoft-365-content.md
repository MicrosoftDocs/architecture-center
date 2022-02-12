[!INCLUDE [header_file](../../../includes/header.md)]

Collaboration is critical to business efficiency and productivity. Tools like Microsoft Teams provide a great way to collaborate via chat, audio, and video. Word, Excel, and PowerPoint online make it easy to collaborate on various types of documents and spreadsheets with colleagues and customers around the world.  

You can use Azure services to add real-time collaborative functionality to custom applications just as you do with  off-the-shelf solutions. This example solution provides insight into libraries and Azure services that you can use to meet custom collaboration requirements. 

In addition to real-time collaboration, the solution supports user presence status. Users can work together in the custom app to collect ideas, see when new ideas are added, modified, or deleted in real time, and avoid data conflicts during collaboration sessions. 

To meet these requirements, the solution uses Fluid Framework and Azure Fluid Relay. It authenticates users against Azure Active Directory by using the Microsoft Graph Toolkit Login component and the Microsoft Authentication Library (MSAL) provider in the application.

## Potential use cases
This solution applies to companies that build custom application solutions that require:
- Secure application access.
- Real-time data collaboration among multiple users.
- Built-in collaboration data-storage capabilities.

## Architecture

diagram 

The architecture relies on Azure Active Directory, Microsoft Authentication Library (MSAL), and Microsoft Graph Toolkit for authenticating users. Fluid Framework and Azure Fluid Relay are used for real-time data collaboration.

### Workflow
- A user signs in to the application using the Microsoft Graph Toolkit Login component. It relies on the MSAL provider to validate their credentials against Azure Active Directory.
- Once a user successfully signs in, the client web app uses the Fluid Framework to connect to Azure Fluid Relay and creates a collaboration session.
- Additional users sign in to the collaboration session and add their ideas. Fluid Framework handles merging the data sent and received in each client to ensure that it is synchronized properly for all users. This is accomplished using the total order broadcast algorithm and eventual consistency.  
- As users continue to collaborate, Azure Fluid Relay automatically handles storing the collaboration data. 
- As additional users join the collaboration session, each user’s client retrieves previously stored data and ensures that the user is synchronized with other users in the session.

### Components
- [Fluid Framework](https://www.fluidframework.com) is a collection of client libraries for distributing and synchronizing shared state. These libraries allow multiple clients to simultaneously create and operate on shared data structures using coding patterns similar to those used to work with local data.
- [Azure Fluid Relay](https://docs.microsoft.com/azure/azure-fluid-relay) is a managed offering for the Fluid Framework that helps developers build real-time collaborative experiences and replicate state across connected JavaScript clients in real-time.
- [Azure Active Directory](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis) is Microsoft’s cloud-based identity and access management service, which helps your employees sign in and access resources.
- [Microsoft Graph Toolkit](https://docs.microsoft.com/graph/toolkit/overview) is a collection of reusable, framework-agnostic components and authentication providers for accessing and working with Microsoft Graph.
- [Azure Static Web Apps](https://docs.microsoft.com/azure/static-web-apps/overview) is a service that automatically builds and deploys full stack web apps to Azure from a code repository.

## Next steps 
A code sample demonstrating this Microsoft Cloud scenario can be found at:

https://github.com/microsoft/brainstorm-fluidframework-m365-azure  

## Related resources
- [Azure Active Directory](https://docs.microsoft.com/azure/active-directory/fundamentals)
- [Azure Fluid Relay](https://docs.microsoft.com/azure/azure-fluid-relay)
- [Azure Static Web Apps](https://docs.microsoft.com/azure/static-web-apps/overview)
- [Fluid Framework](https://fluidframework.com)
- [Microsoft Graph](https://docs.microsoft.com/graph/overview)
- [Microsoft Graph Toolkit](https://docs.microsoft.com/graph/toolkit/overview)
- [Total Order Broadcast and Eventual Consistency in the Fluid Framework](https://fluidframework.com/docs/concepts/tob/)