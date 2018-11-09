
# What is this?
This directory contains a walk through of commands to get you started using  k8s with your application.

## Starting K8s Cluster(s)

Start the minikube cluster on your laptop (post [installation](https://kubernetes.io/docs/tasks/tools/install-minikube/)
```bash
# May take a bit - a VM is spun up
minikube start
```

Point your local host [docker client installation](https://docs.docker.com/install/) to the minikube VM's docker runtime. This helps you avoid the step of pushing to the docker registry every time you make a code change - K8s will find the image locally in the minikube docker runtime.
```bash
# Linux
eval $(minikube docker-env)
``` 

After you make any changes to the [application code](django-poll-project) you will need to create a new container and push it to the docker registry if you want to use the image on a remote k8s cluster (such as the AWS EKS cluster we [setup](aws-k8s-pgdb-with-terraform/aws-kubernetes/aws-k8s-README.md)). More details on creating and pushing local docker images in a related README: [poll-app-README.md](django-poll-project/poll-app-README.md).

## Default namespaces
We want a namespace called "development" in our minikube cluster and a namespace called "production" in our aws eks cluster to be the default namespaces.

```bash
# Development
kubectl config use-context minikube
kubectl create namespace development
kubectl config set-context minikube --namespace=development

 #Production
kubectl config use-context aws
kubectl create namespace production
kubectl config set-context aws --namespace=production
```

## Storing secrets
Secrets that show up as environment variables inside pods need to be set using k8s secrets.
For the development namespace we have
```bash
# Development - note the NA value for the s3 credentials (not needed for development)
kubectl config use-context development
kubectl  create secret generic db-password --from-literal=db-password=superSecret
kubectl create secret generic s3-secrets --from-literal=s3bucket=NA --from-literal=s3accesskey=NA --from-literal=s3secretkey=NA
```

For production
```bash
# Production - We need S3 secrets to store Django static files in AWS S3 for our example.
kubectl config use-context production
kubectl create secret generic s3-secrets --from-literal=s3bucket=bucket_name --from-literal=s3accesskey=substitute_access_key --from-literal=s3secretkey=substitute_secret_key
kubectl create secret generic db-password --from-literal=db-password=substitute_password
```
We can use the same secret names (db-poassword, s3-secrets) since they are being inserted into different namespaces (virtual k8s clusters).

## Configmaps for environment variables
We use [development](kubecode/configmap_development.yaml) and [production](kubecode/configmap_production) configmaps; their keys become environment variables inside of pods.

```bash
kubectl apply -f configmap_development.yaml

kubectl apply -f configmap_production.yaml
```
Note that if the correct kubectl context is set then we don't have to specify the namespace since the namespace key is stored in the metadata key inside these yaml files.
 