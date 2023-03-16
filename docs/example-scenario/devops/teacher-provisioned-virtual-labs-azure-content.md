Azure Lab Services helps teachers create labs. Lab Services manages the infrastructure, from spinning up the VMs to handling errors and scaling as needed.

## Architecture

:::image type="content" source="media/teacher-provisioned-virtual-labs-azure.png" alt-text="Architecture for teacher-provisioned virtual labs by using Lab Services." lightbox="media/teacher-provisioned-virtual-labs-azure.png" border="false" :::

*Download a [Visio file](https://arch-center.azureedge.net/US-1898940-teacher-provisioned-virtual-labs-azure.vsdx) of this architecture.*

### Workflow

- To create virtual labs for a class, an Azure administrator whose role is Contributor or higher does the following:
  - Creates a lab plan to host one or more virtual labs.
  - Approves appropriate marketplace images to serve as starting points for faculty to create lab templates.
  - Optionally attaches an Azure compute gallery to the lab plan. The compute gallery contains one or more OS images, which that can be starting points for the templates.
  - Grants Lab Creator role to the teacher or teachers who will create labs within the lab plan.
- The teacher signs in to Lab Services at [https://labs.azure.com](https://labs.azure.com) and creates a lab and a template image that runs Windows or Linux. The starting point for the template comes from the list of approved marketplace images or from an attached compute gallery.
- The teacher logs into the template VM and installs additional software, sample code, and data that's needed for the lab. The result is the template for the lab. The teacher can configure start and stop schedules for all VMs, and can grant additional quota hours outside the scheduled hours for student use. At all times, a maximum cost estimate is displayed so that the teacher can see the effect of changes.
- Students can be granted access to a lab using any of these options:
  - [Azure Active Directory account](/azure/lab-services/tutorial-setup-classroom-lab#add-users-by-email-address)
  - [Azure Active Directory group](/azure/lab-services/how-to-configure-student-usage#add-users-from-an-azure-ad-group)
  - [Microsoft Teams integration](/azure/lab-services/how-to-get-started-create-lab-within-teams) and, by extension, [School Data Sync (SDS)](/schooldatasync/creating-class-teams-with-sds)
  - [Emails or CSV](/azure/lab-services/how-to-configure-student-usage#add-users-manually-from-emails-or-csv-file)
  - [Registration Link](/azure/lab-services/how-to-configure-student-usage#get-the-registration-link)
- After being added to a lab, a student can sign in to [https://labs.azure.com](https://labs.azure.com) to see the VMs that they can access. If a student's VM isn't already running and quota is available for that student, the student can start the VM and connect via RDP or SSH by using the provided link. Any changes the student makes to the VM will persist until the lab is deleted or the VM is reset by the teacher. When done working, the student can shut down the VM to preserve quota, or the VM can shut down on its own per any configured idle / disconnected user settings in the lab.
- If the student's VM needs to be returned to its original state, the teacher can reset it in the portal. Additional quota hours, if needed, can be assigned to an individual student or granted to all the students. Once the course is complete, the labs can be deleted by the teacher.
- There are several class types highlighted in the documentation including [Ethical Hacking](/azure/lab-services/class-types#ethical-hacking-with-hyper-v), [Python/Jupyter Notebooks](/azure/lab-services/class-types#python-and-jupyter-notebooks) and [Networking with GNS3](/azure/lab-services/class-types#networking-with-gns3).

### Components

- [Azure Lab Services](https://azure.microsoft.com/services/lab-services) is the tool used in this architecture to set up labs and provide on-demand access to preconfigured virtual machines (VMs).
- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) allow you to create Linux and Windows virtual machines (VMs) in seconds, which can help you reduce costs.
- [Azure Active Directory](https://azure.microsoft.com/en-us/services/active-directory) is a complete identity and access management solution with integrated security.

### Alternatives

[Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) (AVD) can also provide one-to-one virtual desktop infrastructure (VDI), but the cost of persistent VM storage isn't waived for AVD deployments. If the scenario is larger in scale and allows for multi-user desktops or application streaming, AVD can provide cost advantages from economies of scale, due to its support for multi-user and application streaming.

## Scenario details

A teacher needs to provide each student with a personal Windows or Linux virtual machine (VM) for use during a course. The students must be able to use their VMs during scheduled instruction (synchronous) and unscheduled study (asynchronous) periods. They use their own devices of various types to access VMs from anywhere. A simple user experience for students is a high priority, since in many cases they don't have technical expertise. The teacher requires cost controls to adhere to a fixed budget.

Azure Lab Services equips teachers to create labs to satisfy such course needs. Lab Services manages the infrastructure, from spinning up the VMs to handling errors and scaling as needed.

After an IT admin creates a lab plan in Lab Services, a teacher can quickly set up a lab for the class, specifying the number and type of VMs that are needed for class exercises, and then adding students to the class or inviting students to self-enroll online. Once registered, a student can access one or more (via nested virtualization) exclusive VMs to complete exercises for the class.

### Potential use cases

This solution is ideal for the education industry. This architecture can be used to provide virtual labs for:

- Classes and professional training
- Customer trials and demos
- Developers
- Replacing on-premises computers
- Collaborative computer programming (hackathons)

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Build your solution as per the five pillars of the [Azure Well Architected Framework](/azure/architecture/framework).

### Scalability

- The Lab Services portal automatically scales to meet service demand.
- Multiple lab plans can be created in an Azure subscription and multiple labs can be created in each lab plan.
- Understand the [Capacity limits in Azure Lab Services](/azure/lab-services/capacity-limits).

### Availability

- Understand the [SLA for Azure Lab Services](https://azure.microsoft.com/support/legal/sla/lab-services)

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Lab VMs aren't provisioned in the customer's subscription. They're managed by Microsoft. Because of this, Azure services such as Azure Policy don't affect the VM or related objects like virtual network adapters (vNICs) and storage.
- Each lab hosts VMs on a single virtual network, so all VMs can communicate with one another to the extent allowed by firewalls.
- Lab VMs can egress to the internet. Ingress occurs only via managed load balancer or proxy, to RDP and SSH ports on the VMs.
- Lab Services doesn't expose the availability zone configuration for lab VMs to the customer.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The two primary drivers of cost within Lab Services are how many hours the lab VMs are powered on, and what size they are. Larger sizes and GPU-enabled sizes are higher cost, so it makes sense to select the minimum size VM that's adequate for the labs.
- Lab Services helps contain compute costs via teacher-controlled schedules and quota hours. There are no VM storage costs, even though the VM's storage is persistent.
- Pricing is covered in [Azure Lab Services pricing](https://azure.microsoft.com/pricing/details/lab-services), and sample cost estimates are provided for many of the [Class Type examples](/azure/lab-services/class-types) in the product docs, in the **Cost** section towards the end of each scenario. The [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) provides a way to build scenario pricing also.

## Deploy this scenario

Because Lab Services labs are designed to be easy for teachers to deploy, the [portal deployment method](/azure/lab-services/how-to-manage-classroom-labs#create-a-classroom-lab) is simple and quick. In large scale, uniform deployments or highly customized scenarios, [REST APIs](/rest/api/labservices) can be used to automate deployment and configuration actions at scale. The [Az.LabServices PowerShell](https://github.com/Azure/azure-devtestlab/tree/master/samples/ClassroomLabs/Modules/Library) module project facilitates various actions.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Manuel Garriga](https://www.linkedin.com/in/manuelgarriga) | Principal Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- To get started with Azure Lab Services quickly, complete these tutorials:
  - [Set up a lab plan with Azure Lab Services](/azure/lab-services/tutorial-setup-lab-plan)
  - [Set up a classroom lab using Azure Lab Services](/azure/lab-services/tutorial-setup-lab)
- [What is Azure Lab Services?](/azure/lab-services/lab-services-overview)
- [Azure Lab Services documentation](/azure/lab-services)
- [Azure Lab Services Pricing](https://azure.microsoft.com/pricing/details/lab-services)
- [Cost management for Azure Lab Services](/azure/lab-services/cost-management-guide)
- [Class Types](/azure/lab-services/class-types)
- [Teams Integration](/azure/lab-services/lab-services-within-teams-overview)
- Customer stories from:
  - [Sheffield Hallam University](https://customers.microsoft.com/story/1410363304401416399-sheffield-hallam-university-higher-education-azure-virtual-desktop)
  - [Imperial College London](https://customers.microsoft.com/story/1373865514221253184-imperial-college-london-higher-education-azure-virtual-desktop)
  - [College of Professional and Continuing Education (CPCE) of PolyU - Hong Kong SAR](https://news.microsoft.com/en-hk/2021/04/13/polyu-cpce-and-microsoft-hong-kong-launch-virtual-labs-for-limitless-learning)
  - [Institute of Technology Sligo - Ireland](https://pulse.microsoft.com/making-a-difference-en-ie/na/fa2-it-sligo-levelling-the-playing-field-in-education-with-cloud-technology-2).

## Related resources

- [DevTest Image Factory](../../solution-ideas/articles/dev-test-image-factory.yml)
- [DevTest and DevOps for IaaS solutions](../../solution-ideas/articles/dev-test-iaas.yml)
- [Azure DevTest Labs reference architecture for enterprises](../infrastructure/devtest-labs-reference-architecture.yml)
