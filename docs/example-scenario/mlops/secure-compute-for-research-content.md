This architecture shows a secure research environment. The architecture allows researchers to access sensitive data under a higher level of control and data protection. This article is intended for organizations that are bound by regulatory compliance or other security requirements. 

By following the guidance you can maintain full control of your data, have separation of duties, and meet strict regulatory compliance standards while providing a robust platform for collaboration. 

## Potential use cases 

We've deployed this architecture for Higher Education research institutions with HIPAA requirements. This design can be used in any industry that requires isolation of data for research perspectives. Some examples include: 
- Industries that process regulated data as per NIST requirements 
- Medical centers collaborating with internal or external researchers 
- Banking and finance 

## Architecture
<insert architecture diagram>

## Data flow

1. Data owners upload datasets to a public storage account. 

2. Data Factory utilizes “on upload” trigger to initiate a copy of uploaded data to secure storage account within locked down environment, only available via private endpoint with the use of a limited-permissions service principal.  Data Factory also deletes the original copy making it an immutable data set. 

3. Researchers access secure environment (DSVM) via Azure Virtual Desktop through a streaming app essentially using AVD as a privileged workstation/jump box.  

    This has advantages over using Azure Bastion for the following reasons: 

    - Ability to stream an app like VSCode to run notebooks against the AML compute resources.  
    - Ability to limit copy, paste and screen captures. 
    - Support for Azure Active Directory Authentication to DSVM. 

4. Data housed in the secure storage account is presented to the DSVM in the secure (limited internet connectivity) environment for research work. Much of the data preparation will be done on the DSVM.  This entire area uses NSGs and private endpoints to limit connectivity to the Internet at large. 

5. Azure Machine Learning also has access to the data via private endpoint for users to leverage AML capabilities. 

6. Models or deidentified data are saved to a specific location on the secure storage which triggers a Logic App requesting a review of data that is queued to be exported.  The manual reviewers are the data owners and their job is ensure that no sensitive data is being exported. Once the data is reviewed to ensure no sensitive data is present, it is approved, and the export functionality is sent to Data Factory. The Logic App can be in a standard environment as no data is sent to the Logic App, it is simply a notification and approval function.  

7. Data Factory moves the data to lower security level storage account, allowing external researchers to have access to their exported data/models. 
