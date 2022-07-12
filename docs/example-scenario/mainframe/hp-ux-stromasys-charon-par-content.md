Frequently the evolution and maintenance of the business applications is stalled because of the underlying legacy hardware. Possibly because the hardware is no longer compatible with newer upgrades and integrations, or worse it is no longer supported. Aging infrastructure for mission critical applications is a concern. The longer the problem remains unsolved the higher the risk and cost of mitigation will become. These applications (software) have supported the organization’s critical business and evolved over decades, gone through audits and certifications and have a well-established operation around them. So instead of a high-risk re-engineering complex project, an alternative approach could be a low-risk project to move the workload (applications) as-is to a modern and less expensive platform like Azure cloud with the help of an emulator. Such a project – often called a “Lift and Shift” - preserves the business functionality of the application and replaces only the hardware, guaranteeing business continuity.

Running applications with an emulator on Cloud has numerous benefits like Security, Elasticity, Disaster Recovery, High Availability, Fail Over etc. but the most significant is the reduced operational costs and ease of maintenance. No risky migration projects are required, no changes to the software (operating system, middleware etc.). A server virtualization software on Azure cloud, could be the first step towards modernization. Once the workload is in Azure, this will open the possibility to leverage other cloud benefits.

This article describes a migration of HP-UX’s workload to Azure. HP-UX is HP’s Unix operating system for the PA-RISC workstations and servers. This article shows how an emulator software called Charon-PAR from Microsoft partner [Stromasys](https://www.stromasys.com/about) , can run HP-UX workloads in Azure.

[Stromasys](https://www.stromasys.com) core business centers around Cross-Platform Virtualization / Server Virtualization software that allows owners of HP-UX Legacy systems to continue running their mission-critical applications unchanged on new Industry Standard Computer systems. Charon products preserve current application investments by enabling users to continue to use their existing applications and business processes. Since everything continues to run without modification, no re-training or re-staffing is required. Charon products dramatically lower cost of ownership by reducing computer footprint, energy consumption, and cooling costs, while eliminating the risks and costs associated with running on aging hardware.

The Stromasys Charon environment provides a significantly higher level of platform stability, and for the first time since the first HP-UX systems were introduced, replacing the actual physical server no longer requires any changes to be made to the HP-UX software environment. Charon also provides more platform stability and has virtually unlimited lifetime.

With the steady increases in the use of Azure hosted systems in the typical corporate environment, an emulated HP-UX system hosted on Linux is the best possible way to host a HP-UX system in these environments. Integral to the Engagement will be the ability to demonstrate the functionality of the emulated HP-UX-based applications in a Virtual/Azure/Charon environment.

This is illustrated in the following image. 

image 

Benefits of this capability are the ability for Azure/Charon customers to continue to utilize their existing critical applications without the cost of rewriting, porting, migrating, or retraining; as well as the reduced maintenance cost realized by moving these applications to emulated systems hosted on Microsoft Azure. 

### Potential use cases

- Enable low-friction "lift-and-shift" of on-premises HP-UX workloads running on PA-RISC servers’ machines into Azure.
- Continue to use HP-UX applications that run on end-of-life PA-RISC servers without any changes but free the applications from old hardware and continue to provide the users with the same, if not better, interfaces.
- Manage multiple server hosts and child VMs from a single interface.
- Customers want to leverage the low-cost Azure storage to archive tapes for regulatory and compliance purposes.
- Customers might want to migrate the database to a cloud and want the application running in cloud using emulation without any changes.

## Architecture

diagram 

Charon-PAR runs on Azure, emulating the PA-RISC systems for HP-UX. On this 'virtual' system (Azure VM), you install the Charon host operating system (Linux), the Charon emulator software, and your legacy operating system (HP-UX) and the associated applications, just as though you were using the original hardware. This enables an HP-UX workload or application to run unchanged in an emulation environment on a VM in Azure.

The figure above shows a typical scenario. The numbered annotations refer to the following:

