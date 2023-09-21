### ArgoCD

[link](https://hodovi.cc/blog/migrating-kubernetes-resources-between-argocd-applications/)
I've been using ArgoCD for a while now, and as time went by I started to splitting my Kubernetes resources into smaller ArgoCD Applications. However, I could not figure out clear guidelines on how to do it without downtime. Recently I figured it out and wanted to share the solution.

First, disable auto-syncing so that neither of your ArgoCD Application sync. Then, remove the relevant code on Git from the ArgoCD Application that you want to migrate it from and push it to Git.

Now ArgoCD will mark the resource for deletion but won't sync since auto syncing is disabled. Now, we can manually remove the ArgoCD label argocd.argoproj.io/instance and then it should be removed from ArgoCD's state and in the ArgoCD UI you should see the Kubernetes resources disappear. 

Now we move the relevant code on Git from the old ArgoCD Application to the new. Enable auto-syncing and the ArgoCD will add the ArgoCD label argocd.argoproj.io/instance with the value of the new Application.

It won't change any of the Kubernetes resources unless you've explicitly done so when migrating the resources. Neither Applications will be out-of-sync and you can re-enable auto-syncing now.
