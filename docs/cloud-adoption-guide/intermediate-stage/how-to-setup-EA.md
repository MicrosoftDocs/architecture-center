---
title: "How to set up and configure your organization's Enterprise Agreement"
description: Guidance for setting up and configuring an Azure Enterprise Agreement
author: petertay
---

# How to set up and configure your organization's Enterprise Agreement

Any Microsoft customer with a Microsoft Enterprise Agreement can add Azure to their Microsoft Enterprise Agreement (EA) by making an upfront monetary commitment to Azure. Funds deposited on account are used over the course of the year as Azure services are consumed.

## Defining the Enterprise Agreement

A Microsoft Enterprise Agreement (EA) is the foundation upon which to build your organization's Azure administration and governance policies.   
 
The Azure EA is organized by: 
* Departments 
* Accounts 
* Subscriptions 
 
The hierarchy design is an important consideration in billing reporting (see operations section).  While the hierarchy structure is not fixed, it can become challenging to change as workloads are expand and deployed. Engage the appropriate stakeholders during the design process and run through different usage scenarios. 
 
The figure below shows a sample hierarchy and structure of an Azure EA.  Each level of activity represented by the hierarchy is managed by an administrative role. 
 
![](../_images/how-to-setup-ea-1.png)

### Administrative roles 
Use the four administrative roles listed below to manage the Microsoft Azure services under your enrollment. Use the corresponding Azure portal to administer the role: 

|Administrative Role|Role Description| Azure Portal|
|----------|----------|----------|
|Enterprise Administrator (EA)|The Azure EA policies are defined and managed by the Enterprise Administrator. There is no limit to the number of Enterprise Administrators.|[Enterprise Portal](https://ea.azure.com/)|
|Department Administrator (DA) |The DA can edit their assigned department details such as name and cost center. The DA also has the authority to manage and create accounts under the department within the enrollment. |[Enterprise Portal](https://ea.azure.com/)|
|Account Owner (AO) | The AO is the user who signed-up for the Azure subscription. Conceptually, the Account Administrator is the billing owner of the subscription. In RBAC, the Account Administrator isn't assigned a role. The AO is authorized to access the Account Center and perform management tasks which include: create new subscriptions,  cancel subscriptions, change the billing for a subscription, and change the Service Administrator|[Account Portal](https://azure.microsoft.com/en-us/)|
|Service Administrator (SA)|The SA is authorized to managed services in the Azure portal. By default, for a new subscription, the Account Administrator is also the Service Administrator. In RBAC, the Owner role is given to the Service Administrator at the subscription scope. |[Management Portal](http://portal.azure.com)|

## Assigning the Enterprise Administrator Role 

Use the procedure described in this section to assign Enterprise Administrator roles. The information in this section is intended for: Licensing Administrator, Project lead, Technical Architect and Operations. The Enterprise Administrator (EA) is a key management role. The EA has full access privileges and visibility into all activities and resources of a corporate enrollment. The EA account is created at on-boarding and ideally, two people are assigned to the EA role. 

### Preparation  

Perform the following activities before you begin the procedure tasks:  
 
1. Consult with the following stakeholders to define the Enterprise Administrator role:
  * Finance:
    * Owns the customer policies and procedures and licensing related to changes to the Enterprise Agreement.  
    * Owns the customer policies and procedures related to payment of invoices related to Azure services.  
   * IT Security and compliance:  Owns the customer policies and procedures related to Privileged Access Management and Identity and, Access Management policy application. This stakeholder is responsible for the creation and management of Azure administration credentials.
2. Select two people to assume the Enterprise Administrator role.  
3. Create valid Azure Active Directory accounts for each EA role. Associate the EA accounts with a monitored mailbox. Enrollment and account notifications are sent to the Azure Active Directory account mailbox. Collect the information as shown in the following table: 

|Field|Value|
|-----|-----|
|Azure Tenant Name|tenant.onmicrosoft.com|
|Azure Tenant Administrator|tenant.adminl@contoso.com|
|Enterprise Administrator(s) Name|Lastname, Firstname| 
|Azure Active Directory Tenant Credentials|___@tenant.onmicrosoft.com|
|Enterprise Administrator Email |enterprise.admin@contoso.com|

### Procedure:  How to assign the Enterprise Administrator role  

Use this procedure to order cloud services, obtain credentials and initial access and assign administrator roles.  
 
1. Schedule a concierge on-boarding call (If assistance is required)
  * Schedule a concierge on-boarding call to receive an overview of Enterprise Azure, answer questions and get started. Either the customer or the Microsoft Account Team can perform this step.
    * Access the customer URL:  [http://aka.ms/AzureEntSupport](http://aka.ms/AzureEntSupport)
    * Choose the problem type:  Onboarding
    * Choose the category:  Scheduling an Onboarding or Concierge Session
    * Provide the Enterprise customer name and enrollment number, date and time and, attendees emails  
2. Activate the service
  * During the Azure services procurement process, a monitored corporate email address (not a consumer email provider) is specified to receive the invitation to activate.  
  * Refer to page four in the [Onboarding Guide to the Microsoft Azure Enterprise Portal](https://eaportalonboardingvideos.blob.core.windows.net/onboardingvideos/AzureDirectEACustomerOnboardingGuide_En.pdf) for instructions on how to start the activation process.
  * **Note:** If a different email address is needed to activate the enrollment request a new identity be added by submitting a incident request here. 
3. Select the Work Account authentication method
 * On the Enterprise Administrator Portal (https://ea.azure.com) landing page:
   * select the "Work Account" Authentication Mode
   * click the Sign-in button. 
4. Sign-in or sign-up
  * Use one of the login processes described below:
    * Sign In: Customers with existing tenant, or Azure, O365, D365, or VSTS Online
      * Contact the Azure tenant Azure administrators to obtain the cloud-based Azure Active Directory credentials.
      * Login to an existing tenant using cloud-based Azure Active Directory account. 
    * Sign-up: Customers without existing Microsoft cloud tenant (Azure Active Directory) and no Azure, O365, D365, or VSTS Online. Login using the email address listed in the invitation email that was sent and create a password that adheres to organizational policy. **Note:** You are creating your first Active Directory tenant. If you have an existing tenant, select Sign-in as described in the section below. 
 5. Assign enterprise administrators
   * A tenant administrator or initial existing enterprise administrator can assign additional enterprise administrators. See page eight in the [Onboarding Guide to the Microsoft Azure Enterprise Portal](https://eaportalonboardingvideos.blob.core.windows.net/onboardingvideos/AzureDirectEACustomerOnboardingGuide_En.pdf); Adding/Editing Enterprise Admins and Notification Contacts. **Note:** contact your Microsoft representative or create an incident request here if a notification is received indicating "The account provided is not a valid user of the Microsoft Azure Enterprise Portal". 
 
## Assigning the Department Administrator Role

Use the procedure described in this section to define Department Administrator (DA) roles and account structures. Organizations may want to split administration and costs by business units or other logical divisions. Azure refers to these divisions as Departments. An Enterprise enrollment can have many departments. Each department is assigned two Department Administrators. 

### Preparation 
Perform the following activities before you begin the procedure tasks:  
  
1. Consult the following stakeholders to define the Department Administrator role:
  * Department owners:  Responsible and accountable for the consumption of Azure services and related expenses
  * Finance:
    * Owns the customer policies and procedures related to changes to the Enterprise Agreement
    * Owns the customer policies and procedures related to payment of invoices related to Azure services
  * IT Security and Compliance:  Owns the customer policies and procedures related to Privileged Access Management and Identity and, Access Management policy application. This stakeholder is responsible for the creation and management of Azure administration credentials
2. Collect the department details as outlined in the following table:

|Field|Value|
|-----|-----|
|Department Name|Department Name|
|Cost Center|Cost Center|
|Spending Quota|Spending Quota ($)|
|Spending Notifications|Spending Notifications (%)|
3. Select two people to assume the role of Department Administrators.
4. Create valid Azure Active Directory accounts for each EA account. Associate the EA accounts with a monitored mailbox and collect the details as outlined in the table below. Enrollment and account notifications are sent to the Azure Active 
Directory account mailbox (as specified in the Enterprise Portal).

### Procedure:  How to create the department administrator roles and account structures 
 
Use this procedure to create the department and account structures. 
 
1. Sign-in to the Enterprise Administrator portal
  * Sign-in to the Enterprise Administrator Portal [https://ea.azure.com](https://ea.azure.com) as an Enterprise Administrator.
2. Define the Department / Account Structure
  * Follow the "Department/Account Setup Methodology" instructions on page nine of the [Onboarding Guide to the Microsoft Azure Enterprise Portal](https://eaportalonboardingvideos.blob.core.windows.net/onboardingvideos/AzureDirectEACustomerOnboardingGuide_En.pdf).
3. Create the department
  * Follow the "Manage Departments Panel" instructions found on page ten and the "Manage Department Detail" found on page eleven of the [Onboarding Guide to the Microsoft Azure Enterprise Portal](https://eaportalonboardingvideos.blob.core.windows.net/onboardingvideos/AzureDirectEACustomerOnboardingGuide_En.pdf).
  
## Assigning the Account Owner Role

Use the procedure described in this section to assign Account Owner (AO) roles to each department. Account Owners administer department subscriptions.

### Preparation 

1. Consult the following stakeholders as part of the Account Owner definition:
  * Department owners:  Responsible and accountable for the consumption of Azure services and related expenses.
  * Workload service owners: Owns the business requirements and drivers consumption of the different cloud services.
  * IT Operations owners:  Owns the customer policies and procedures related to IT Service Management and continuity of operations.
  * IT Security and compliance:  Owns the customer policies and procedures related to Privileged Access Management and Identity and, Access Management policies applicable to the creation and management of Azure administration credentials.  
2. Collect the AO and department details as outlined in the following table:

|Field|Value|
|-----|-----|
|Account Owner Name|Account Name|
|Department|Parent Department|
|Cost Center|Cost Center|
|Account Owner Azure AD Credentials|account.admin@tenant.onmicrosoft.com|
|Account Owner Email|account.admin@tenant.onmicrosoft.com|
|Is this an existing Account Owner|Yes/No|

### Procedure: How to assign the Account Owner role  

Use this procedure to create and validate ownership of an Account Owner role.    
  
1. Sign into the Azure account portal
  * Sign-in to the Account Portal using the account specified by the Enterprise Administrator, see:  [https://account.windowsazure.com](https://account.windowsazure.com).  
2. Associate an Account Owner with an email address
  * Associate the account with an existing, valid Account Owner. Enter the email address associated with the account. Alternatively, associate a new Account Owner by entering a new, valid email address.  
3. Confirm account ownership
  * Confirm the account ownership was created. The owner of the email address provided in the previous step receives a notification that they have been invited to activate their account in the enrollment.
4. Activate account ownership
  * Activate the account ownership by signing in to the Enterprise Portal with the Account Owner email address provided. Receipt of email notification is not required for login. Valid Account Owners can log into the Azure Enterprise Administrator Portal: [https://ea.azure.com](https://ea.azure.com).

## Assigning the Service Administrator Role

Use the procedure described in this section to create a subscription and assign a Service Administrator (SA) role. Azure services are provisioned within subscriptions. Those services are managed within the context of the subscription by the service administrator. By default, the account owner is the service administrator on any new subscriptions.

### Preparation

1. Consult the following stakeholders as part of the Account Owner definition:
  * Department owners:  Responsible and accountable for the consumption of Azure services and related expenses.
  * Workload service owners: Owns the business requirements and drivers consumption of the different cloud services.
  * IT Operations owners:  Owns the customer policies and procedures related to IT Service Management and continuity of operations.
  * IT Security and compliance:  Owns the customer policies and procedures related to Privileged Access Management and Identity and, Access Management policies applicable to the creation and management of Azure administration credentials.  
2. Collect the AO and department details as outlined in the following table:

|Field|Value|
|-----|-----|
|Subscription Name|Subscription Name|
|Account|Parent Account|
|Department|Parent Department|
|Service Administrator AD Credentials|service.admin@tenant.onmicrosoft.com|
|Service Administrator Email|service.admin@tenant.onmicrosoft.com|Co-Service Administrator AD Credentials|coservice.admin@tenant.onmicrosoft.com|
|Co-Administrator Email|coservice.admin@tenant.onmicrosoft.com|
|Offer|Microsoft Azure Enterprise, Dev/Test|

### Procedure: How to assign the Service Administrator role  
  
Use this procedure to assign a Service Administrator (SA) to the enrollment.

1. Open the Account Portal
  * Sign-in to the Account Portal [https://account.azure.com](https://account.azure.com) as the Subscription Administrator.
2. Create a subscription
  * To create a subscription, use the "Adding a New Subscription" instructions shown on page 25,  [Onboarding Guide to the Microsoft Azure Enterprise Portal](https://eaportalonboardingvideos.blob.core.windows.net/onboardingvideos/AzureDirectEACustomerOnboardingGuide_En.pdf).
3. Assign a Service Administrator
  * To assign a Service Administrator, use the "Edit Subscription Detail" instructions shown on page 27,[Onboarding Guide to the Microsoft Azure Enterprise Portal](https://eaportalonboardingvideos.blob.core.windows.net/onboardingvideos/AzureDirectEACustomerOnboardingGuide_En.pdf). **Note:** designate separate individuals as Service Administrators of sandbox and production subscriptions.    