# Configuring Backups using Velero



## Introduction
If you are looking to Backup your AKS resources then Velero can be a good tool to consider. This tool gives users the capability to Backup & restore the Kubernetes resources & also the Persistent volumes.
This can be quite useful for scenarios where certain resources needs backup which can be also be stored on Object storage.

It can also be useful in some of the scensrios where the data Migration of cluster can be a need (Due & sufficient deligence & PoC is required before any design Decision)
Please refer the below link for quick Introduction & different usecases

[Velero](https://velero.io/)

---

## Implementation

As the implementation / updates continously happen , therefore we are going to refernce few handy links for the tool to help you forward .
If the tool suits you need, then you can refer the below documentation for configuring backup of respective resources in AKS

[Velero Plugin for MS Azure](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure)

:bulb: An important point to note that Velero & plugin versions have to be carefully matched to make things work!

