---
title: CI/CD for a serverless Azure frontend | Microsoft Docs
description: Learn best practices for a robust CI/CD pipeline for your serverless frontend on Azure. 
author: dsk-2015
ms.date: 09/20/2019
ms.author: dkshir
ms.topic: guide
ms.service: architecture-center
ms.subservice: guide
---

# Develop a robust CI/CD pipeline for serverless application frontend on Azure

Serverless computing abstracts the servers, infrastructure, and operating systems, allowing developers to focus on application development. A robust *CI/CD* or *Continuous Integration*/*Continuous Delivery* of such applications allows companies to ship fully-tested and integrated software versions within minutes of development. It provides a backbone of modern DevOps environment.

What does CI/CD actually stand for?

- Continuous Integration allows development teams to integrate code changes in a shared repository almost instantaneously. This ability coupled with automated build and testing before the changes are actually integrated, ensures that only fully-functional application code is available for deployment.
- Continuous Delivery allows changes in the source code, configuration, content, and other artifacts, to be delivered to production, and ready to be deployed to end-users, as quickly and safely as possible. The process keeps the code in a *deployable state* at all times. A special case of this is *Continuous Deployment*, which includes actual deployment to end-users.

This article discusses a CI/CD pipeline for the web frontend of [serverless reference implementation](../../reference-architectures/serverless/web-app.md). This pipeline is developed using Azure services. This web frontend demonstrates a modern web application, with client-side JavaScript, reusable server-side APIs, and pre-built Markup, alternatively called [JAMstack](https://jamstack.org). The application frontend used in this article is in [this GitHub repository](https://github.com/mspnp/serverless-reference-implementation/). The readme describes the steps to download the application, and create your own CI/CD pipeline.

The following figure describes the CI/CD pipeline used in this sample frontend:

![CI/CD pipeline in Serverless App using Azure services](./images/cicd_serverless_frontend.png)

Note that this does not include the [backend deployment](../../reference-architectures/serverless/web-app.md#back-end-deployment).

## Prerequisites

To work with this sample application, make sure you have the following:

- A GitHub account
- An Azure account - if you don't have one, you can try out a [free Azure account](https://azure.microsoft.com/free/).
- An Azure DevOps account - if you don't have one, you can try out a [basic plan](https://azure.microsoft.com/pricing/details/devops/azure-devops-services/) which includes DevOps services such as Azure Pipelines.

## Use an online version control system

Version control systems keep track and control changes in your source code. Keeping your source code in an online version control system allows multiple development teams to collaborate. It is also easier to maintain than a traditional version control on premises. These online systems can also more easily integrated with leading CI/CD services. You get the ability to create and maintain the source code in multiple directories, along with build and configuration files, in what is called as a *repository*.

The sample application project files are kept in GitHub, one of the most popular online version control systems today. If you do not have a GitHub account, read [this documentation to get started with GitHub repositories](https://help.github.com/en#dotcom).

## Automate your build and deploy

Use a powerful CI/CD service such as Azure Pipelines to automate your build and deploy processes.

### Integrate your build tools

Modern build tools can simplify your build process, and provide functionality such as pre-configuration, [minification](https://techterms.com/definition/minification) of the JavaScript files, and static site generation. Static site generators can build markup files before they are deployed to the hosting servers, resulting in a fast user experience. You can select from a variety of these tools, based on the type of your application's programming language and platform, as well as additional functionality needed. [This article](https://blog.logrocket.com/the-best-static-websites-generators-compared-5f1f9eeeaf1a/) provides a list of popular build tools.

The sample is a React application, built using Gatsby.js - a React-based static site generator and front-end development framework. In addition to running locally during development and testing phases, these tools can be integrated with [Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) to pre-build before deploy.

The sample installs the [gatsby-plugin-typescript](https://www.gatsbyjs.org/packages/gatsby-plugin-typescript/) using the [gatsby-config.js](https://github.com/mspnp/serverless-reference-implementation/blob/master/src/ClientApp/gatsby-config.js).

### Automate builds

Automating the build process reduces the human errors. Since the markup files are prebuilt, the content changes will go live only when after a build is completed. The sample achieves automated builds using [Azure Pipelines](https://docs.microsoft.com/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops).

The file [azure-pipelines.yml](https://github.com/mspnp/serverless-reference-implementation/blob/master/src/ClientApp/azure-pipelines.yml) includes the script for the two-stage automation. [The Readme for this project](https://github.com/mspnp/serverless-reference-implementation/tree/master/src/ClientApp) describes the steps required to set up the automation pipeline using Azure Pipelines. The following sub-sections show how the pipeline stages are configured.

#### Build stage

Since the Azure Pipeline is [integrated with GitHub repository](https://docs.microsoft.com/en-us/azure/devops/pipelines/repos/github?view=azure-devops&tabs=yaml), any change in the directory in the master branch observed by the azure-pipelines.yml, triggers the first stage of the pipeline, which is the build stage:

```Yaml
trigger:
  batch: true
  branches:
    include:
    - master
  paths:
    include:
    - src/ClientApp
```

The following snippet illustrates the start of the build stage, which spins a Ubuntu virtual machine to run this stage.

```Yaml
    stages:
    - stage: Build
      jobs:
      - job: WebsiteBuild
        displayName: Build Fabrikam Drone Status app
        pool:
          vmImage: 'Ubuntu-16.04'
        continueOnError: false
    steps:
```

This is followed by *tasks* and *scripts* required to successfully build the project. These include the following: 

- installing Node.js and setting environment variables,
- installing and running Gatsby.js that builds your static website:
    ```Yaml
        - script: |
            cd src/ClientApp
            npm install
            npx gatsby build
          displayName: 'gatsby build'
    ```
- installing and running the compression tool named *brotli*, to [compress the built files](#host-and-distribute-using-the-cloud) before deployment:
    ```Yaml
        - script: |
            cd src/ClientApp/public
            sudo apt-get install brotli --install-suggests --no-install-recommends -q --assume-yes
            for f in $(find . -type f \( -iname '*.html' -o -iname '*.map' -o -iname '*.js' -o -iname '*.json' \)); do brotli $f -Z -j -f -v && mv ${f}.br $f; done
          displayName: 'enable compression at origin level'
    ```
- computing the version of the current build, for [cache management](#manage-cache-at-the-edge-and-user-devices),
- publishing the built files for use by the [deploy stage](https://docs.microsoft.com/azure/devops/pipelines/artifacts/pipeline-artifacts?view=azure-devops&tabs=yaml):
    ```Yaml
        - task: PublishPipelineArtifact@1
          inputs:
            targetPath: 'src/ClientApp/public'
            artifactName: 'drop'
    ```

A successful completion of the build stage tears down the Ubuntu environment and triggers the deploy stage in the pipeline.

#### Deploy stage

The deploy stage runs in a separate Ubuntu virtual machine:

```Yaml
    - stage: Deploy
      jobs:
      - deployment: WebsiteDeploy
        displayName: Deploy Fabrikam Drone Status app
        pool:
          vmImage: 'Ubuntu-16.04'
        environment: 'fabrikamdronestatus-prod'
        strategy:
          runOnce:
            deploy:
              steps:
```

This is followed by various deployment tasks and scripts to:

- download the build artifacts to the virtual machine (this happens automatically as a consequence of using `PublishPipelineArtifact` in the build stage), 
- record the build release version, and update in the GitHub repository, 
- upload the website files to the Blob Storage, in a new folder corresponding to the new version, and 
- change the CDN to point to this new folder. 

The last two steps together replicate a cache purge, since older folders are no longer accessible by the CDN edge servers. The following snippet shows how this is achieved:

```Yaml
       - script: |
              az login --service-principal -u $(azureArmClientId) -p $(azureArmClientSecret) --tenant $(azureArmTenantId)
              # upload content to container versioned folder
              az storage blob upload-batch -s "$(Pipeline.Workspace)/drop" --destination "\$web\$(releaseSemVer)" --account-name $(azureStorageAccountName) --content-encoding br --pattern "*.html" --content-type "text/html"
              az storage blob upload-batch -s "$(Pipeline.Workspace)/drop" --destination "\$web\$(releaseSemVer)" --account-name $(azureStorageAccountName) --content-encoding br --pattern "*.js" --content-type "application/javascript"
              az storage blob upload-batch -s "$(Pipeline.Workspace)/drop" --destination "\$web\$(releaseSemVer)" --account-name $(azureStorageAccountName) --content-encoding br --pattern "*.js.map" --content-type "application/octet-stream"
              az storage blob upload-batch -s "$(Pipeline.Workspace)/drop" --destination "\$web\$(releaseSemVer)" --account-name $(azureStorageAccountName) --content-encoding br --pattern "*.json" --content-type "application/json"
              az storage blob upload-batch -s "$(Pipeline.Workspace)/drop" --destination "\$web\$(releaseSemVer)" --account-name $(azureStorageAccountName) --pattern "*.txt" --content-type "text/plain"
              # target new version
              az cdn endpoint update --resource-group $(azureResourceGroup) --profile-name $(azureCdnName) --name $(azureCdnName) --origin-path '/$(releaseSemVer)'
              AZURE_CDN_ENDPOINT_HOSTNAME=$(az cdn endpoint show --resource-group $(azureResourceGroup) --name $(azureCdnName) --profile-name $(azureCdnName) --query hostName -o tsv)
              echo "Azure CDN endpoint host ${AZURE_CDN_ENDPOINT_HOSTNAME}"
              echo '##vso[task.setvariable variable=azureCndEndpointHost]'$AZURE_CDN_ENDPOINT_HOSTNAME
            displayName: 'upload to Azure Storage static website hosting and purge Azure CDN endpoint'
```

### Atomic deploys

Atomic deployment ensures that the users of your website or application always get the content corresponding to the same version. 

In the sample CI/CD pipeline, the website contents are deployed to the Blob storage, which acts as [the origin server for the Azure CDN](https://docs.microsoft.com/en-us/azure/cdn/cdn-create-endpoint-how-to). If the files are updated in the same *root folder* in the blob, the website will be served inconsistently. Uploading to a new versioned folder as shown in the preceding section solves this problem. The users either get *all or nothing* of the new successful build, since the CDN points to the new folder as the origin, only after all files are successfully updated. This also makes it easy to roll back to a previous version if required. You can configure how many such versions should be stored in the blob.

![Versioned deployment](./images/versioned-deployment.png)

## Host and distribute using the cloud

A Content Delivery Network or CDN is a set of distributed servers that speed up the content delivery to clients and devices spread out geographically, with every user getting content from the server nearest to them. The CDN accesses this content from an *origin* server, and then caches it to *edge* servers at strategic locations. For static websites, these edge servers can cache content for a long duration, since it may not change too much over time. This reduces the overhead of accessing the single origin server for every user request, leading to better traffic management. Dynamic websites also benefit from this model, since their scripts can be run in a CDN cache instead of a remote server, reducing response time to the end-users. Using a CDN will help you create a fast and efficient experience for your users all over the world.

The sample code uses [Azure CDN](https://docs.microsoft.com/azure/cdn/cdn-overview) to cache the markup and the JavaScript files. You would also use it to store any other resources such as images, video, etc. It uses [Azure Blob Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview) as the origin server for these files. For a quick guide on how to use Azure CDN with Azure Blob Storage, read [Integrate an Azure storage account with Azure CDN](https://docs.microsoft.com/en-us/azure/cdn/cdn-create-a-storage-account-with-cdn).

To further improve performance, you should [compress the files in the Azure CDN](https://docs.microsoft.com/en-us/azure/cdn/cdn-improve-performance). There are two ways to do this: at the origin level or on the CDN edge servers. The advantage of compressing at the origin is that it is done during deployment rather than at run time, further improving the run time performance of your website. Additionally, you can fine tune the compression by controlling which tool to use. The sample compresses the files before uploading to the Blob Storage using [Brotli](https://brotli.org/). Refer to the following script at line 40 of [azure-pipelines.yml](https://github.com/mspnp/serverless-reference-implementation/blob/master/src/ClientApp/azure-pipelines.yml):

```JavaScript
    - script: |
        cd src/ClientApp/public
        sudo apt-get install brotli --install-suggests --no-install-recommends -q --assume-yes
        for f in $(find . -type f \( -iname '*.html' -o -iname '*.map' -o -iname '*.js' -o -iname '*.json' \)); do brotli $f -Z -j -f -v && mv ${f}.br $f; done
      displayName: 'enable compression at origin level'
```

## Manage cache at the edge and user devices

You may choose to [purge your Azure CDN cache ](https://docs.microsoft.com/en-us/azure/cdn/cdn-purge-endpoint) to guarantee a new user will get the latest live website files. Since the sample deploys latest files in a versioned folder, it takes another approach to invalidate the CDN cache: 

1. The CDN validates the index.html against the one in the origin, every time a new website instance is loaded. 
2. If there is no change in the index.html, the files in the CDN cache is fetched. If change is found, the latest file is transfered to the CDN cache and presented to the client. 
3. All other resource files are fingerprinted and cached for a year. This is based on the assumption that resources such as images and videos do not need frequent changes. Everytime the resource file is built, it;s name is appended by a new fingerprint GUID. This means the name changes. Which also means index.html which calls this new file, has also changed to call the new fingerprint file. Since the CDN validates the cached index.html against the origin, it detects the change and downloads the latest index.html to the CDN servers. When it tries to render the html, it finds a new fingerprint file not available in the browser's or CDN's cache. It then accesses the origin and downloads the changed resource files.

This process makes sure that regardless of the cache staleness, the users get all the new website files for every new instance or a refresh. This also removes the costly purge process. 
