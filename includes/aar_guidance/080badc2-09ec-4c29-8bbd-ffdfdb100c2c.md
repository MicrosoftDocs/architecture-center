---
ms.author: dastanfo
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.uid: 080badc2-09ec-4c29-8bbd-ffdfdb100c2c
ms.assessment_question: You follow best practices for container security
---
## Follow best practices for container security

Applications hosted in containers should follow general application best
practices as well as some specific guidelines to manage this new application
architecture type

Containerized applications face the same risks as any application and also adds
new requirements to securely the hosting and management of the containerized
applications.

Application containers architectures introduced a new layer of abstraction and
management tooling (typically Kubernetes) that have increased developer
productivity and adoption of DevOps principles.

While this is an emerging space that is evolving rapidly, several key lessons
learned and best practices have become clear:

-   **Use a Kubernetes managed service instead of installing and managing
    Kubernetes**  
    Kubernetes is a very complex system and still has a number of default
    settings that are not secure and few Kubernetes security experts in the
    marketplace. While this has been improving in recent years with each
    release, there are still a lot of risks that have to be mitigated.

-   **Validate container + container supply chain**  
    Just as you should validate the security of any open-source code added to
    your applications, you should also validate containers you add to your
    applications.

    -   Ensure that the practices applied to building the container are
        validated against your security standards like application of security
        updates, scanning for unwanted code like backdoors and illicit crypto
        coin miners, scanning for security vulnerabilities, and application of
        secure development practices.

    -   Regularly scan containers for known risks in the container registry,
        before use, or during use.

-   **Set up registry of known good containers**  
    This allows developers in your organization to use containers validated by
    security rapidly with low friction. Additionally, build a process for
    developer to request and rapidly get security validation of new containers
    to encourage developers to use this process vs. working around it.

-   **Don’t run containers as root or administrator unless explicitly
    required**  
    Early versions of containers required root privileges (which makes attacks
    easier), but this is no longer required with current versions.

-   **Monitor containers**  
    Ensure you deploy security monitoring tools that are container aware to
    monitor for anomalous behavior and enable investigation of incidents.
