
# What is this?
This directory contains a walk through of commands to get you started usign  k8s with your application.


Start the minikube cluster on your laptop (post [installation](https://kubernetes.io/docs/tasks/tools/install-minikube/)
```
#May take a bit - a VM is spun up
minikube start
```

Point your local host [docker client installation](https://docs.docker.com/install/) to the minikube VM's docker runtime. This helps you avoid the step of pushing to the docker registry every time you make a code change - K8s will find the image locally in the minikube docker runtime.
```
# Linux
$ eval $(minikube docker-env)
``` 

After you make any changes to the [application code](django-poll-project) you will need to create a new container and push it to the docker registry if you want to use the image on a remote k8s cluster (such as the AWS EKS cluster we [setup](aws-k8s-pgdb-with-terraform/aws-kubernetes/aws-k8s-README.md)). More details on creating and pushing local docker images in a related README: [poll-app-README.md](django-poll-project/poll-app-README.md).



