The front-end application that makes calls to one or more API applications behind it is known as a multi-tier web application. Though not a complex concept, the architecture usually gets complicated when a user wants to secure the API applications by making it non-internet accessible. 

API applications can be secured in several ways where they can be accessed from your front-end applications only, which involves securing your API application’s inbound traffic. 
Below is the reference architecture that showcases the use of Private endpoints for secure communications between app services in a multi-tier environment.

A network interface that uses Azure private link to connect you privately and securely to your Web App is known as Private endpoint. It uses a private IP address from the virtual network, effectively bringing the web app into that network. This feature is applicable for only inbound flows to your web app. 

With [Private endpoints], there is no risk of data exfiltration since because the only thing you can reach across the private endpoint is the app with which it's configured.
